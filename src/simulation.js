/**
 * `Sienna.Simulation` — the simulation session: everything this app knows about
 * running a model on a SimiLive server. No DOM, no pixels; the run-control and
 * display widgets are views onto this.
 *
 * This is app-specific code that belongs in neither the shell nor a widget. The
 * run control DRIVES a session and a grid RECEIVES from it, so if the protocol
 * lived inside either widget the other would have to reach across a panel
 * boundary to get at it — and closing that panel, or opening a second display,
 * would break the arrangement. It is the same split the editor already makes
 * between `src/diagram.js` (model, no pixels) and `src/widgets/diagram.js`
 * (view), applied to running rather than editing.
 *
 * ## Why this is not in userData
 *
 * Every other piece of shared state in this app lives in `Sienna.userData`,
 * which is the shell's pub/sub substrate — so putting the session there would
 * have been the conventional move. It would also have been wrong. `userData`
 * autosaves to localStorage and feeds undo, and a session is neither saveable
 * nor undoable: the interesting half of it is a process on someone else's
 * machine, identified by a temp-directory name that means nothing after the tab
 * closes. Restoring one from localStorage would hand the user a play button
 * wired to a process that no longer exists, and "undo" over a running model has
 * no meaning at all. So this keeps its own listener list — the same shape as
 * `userData.subscribe`, deliberately, but with a lifetime of one page visit.
 *
 * ## The protocol
 *
 * Two endpoints, no cookies. `create_model.php` takes a model and returns an
 * HTML page whose only load-bearing content is `var fileBase = '/tmp/xxxxx'`;
 * that opaque string IS the session. Everything after is a form POST to
 * `model_action.php` carrying `base` and `act`. The server sends
 * `Access-Control-Allow-Origin: *` and every request here is CORS-simple (form
 * encoding, no custom headers), so this works cross-origin from a `file://`
 * page — which is how this app is normally opened.
 *
 * Startup is a fixed sequence: `BuildShareLib` (compiles the model; its LAST
 * line is the JSON of run defaults) → `CreateSocket` → `WaitSocket` (the model
 * process attaches) → `Describe` (the component dictionary) → `LoadSPF`.
 *
 * Running is a poll loop the CLIENT drives. `ExecuteMulti` advances the model
 * by one chunk and returns every logged point in that chunk; the caller decides
 * how big a chunk is (that is what "Update each" means) and asks again. The
 * server holds model state between calls but has no notion of a run.
 *
 * ## `note` — asking for values
 *
 * Every `Reset`/`ExecuteMulti`/`Query` carries a `note`: a JSON array saying
 * what to send back. An entry is either a bare component id, or an object
 * requesting a rendering of it — of which the one that matters here is
 * `{format:'binary', node, bottom, top, nswat, hex}`, which makes the SERVER
 * scale the values to 0–255 and LZW-encode them, so a 200×300 grid comes back
 * as a few hundred bytes of GIF body rather than 60000 numbers. Replies are
 * positional: `[value-per-note-entry…, timestamp]`.
 *
 * Display widgets register what they want via `addTarget`, and this collects
 * them (deduplicated) before each request. Values come back keyed by `keyOf`,
 * so a widget looks up its own result with the same spec it asked with.
 *
 * Classic script; no imports/exports.
 */
(function (Sienna, $) {
  'use strict';

  var SERVER = 'https://similive.simulistics.com/';

  /**
   * Days per time unit. The server works in days whatever the model's declared
   * unit, so times crossing the wire are multiplied on the way out and divided
   * on the way in. Straight from SimiLive's own table.
   */
  var TIME_LIB = {
    second: 1 / 86400, minute: 1 / 1440, hour: 1 / 24, day: 1,
    unit: 1, week: 7, month: 365 / 12, year: 365,
  };

  /**
   * The key a value comes back under. Object specs are keyed by their JSON, so
   * property order matters — always build the spec in one place and reuse it.
   */
  function keyOf(spec) {
    return typeof spec === 'string' ? spec : JSON.stringify(spec);
  }

  var Simulation = {
    SERVER: SERVER,
    keyOf: keyOf,

    /** 'idle' | 'loading' | 'ready' | 'running' | 'error' */
    status: 'idle',
    message: '',

    base: null,        // the server-side session id ('/tmp/dbx…')
    params: null,      // run defaults from BuildShareLib
    components: null,  // the Describe dictionary: id -> {text, captpath, dims, …}
    modelLink: '',     // what was loaded, for display
    timeUnit: 1,       // days per model time unit
    unitName: 'unit',

    /**
     * Run settings. Held here rather than in the run-control widget so that a
     * second run-control panel shows the same numbers, and so the run loop is
     * not reading them back out of input elements.
     */
    settings: {
      runLength: 100,
      current: 0,
      updateEach: 10,
      logEach: 1,
      timeStep: '0.1',   // a STRING: multi-phase models give "0.1 0.001"
    },

    // ---- events ---------------------------------------------------------

    _listeners: [],

    /**
     * Listen to everything this session emits: `{type, …}` where type is
     * 'status' | 'settings' | 'describe' | 'data' | 'progress' | 'targets'.
     * @returns {() => void} unsubscribe
     */
    subscribe: function (fn) {
      var list = this._listeners;
      list.push(fn);
      return function () {
        var i = list.indexOf(fn);
        if (i >= 0) list.splice(i, 1);
      };
    },

    _emit: function (event) {
      // Copy first: a listener may unsubscribe (a closing panel does exactly
      // that) and splicing the array we are walking would skip its neighbour.
      this._listeners.slice().forEach(function (fn) {
        try {
          fn(event);
        } catch (e) {
          if (window.console) console.error('simulation listener failed', e);
        }
      });
    },

    _setStatus: function (status, message) {
      this.status = status;
      this.message = message || '';
      this._emit({ type: 'status', status: status, message: this.message });
    },

    // ---- transport ------------------------------------------------------

    /**
     * One POST to `model_action.php`, resolving to the raw response text.
     * Deliberately text and not JSON: several acts return a log with JSON only
     * on the last line, so parsing is the caller's business.
     */
    _post: function (act, extra) {
      var data = $.extend({ base: this.base, act: act }, extra || {});
      return Promise.resolve(
        $.ajax({ type: 'POST', url: SERVER + 'model_action.php', data: data, dataType: 'text' }),
      ).catch(function (xhr) {
        throw new Error(
          act + ' failed (' + (xhr && xhr.status ? 'HTTP ' + xhr.status : 'no response')
          + '). The server may be unreachable.',
        );
      });
    },

    /** Scale a possibly multi-phase time-step string into server (day) units. */
    _scaleTimes: function (list) {
      var self = this;
      return String(list).trim().split(/\s+/).map(function (t) {
        return parseFloat(t) * self.timeUnit;
      }).join(' ');
    },

    // ---- targets --------------------------------------------------------

    _targets: {},

    /**
     * Register what a display widget wants back on every step. `owner` is any
     * stable string (a panel id will do); registering again replaces.
     */
    addTarget: function (owner, spec) {
      this._targets[owner] = spec;
      this._emit({ type: 'targets' });
    },

    removeTarget: function (owner) {
      delete this._targets[owner];
      this._emit({ type: 'targets' });
    },

    /** Every registered target, deduplicated — the `note` for the next request. */
    noteList: function () {
      var seen = {};
      var list = [];
      var targets = this._targets;
      Object.keys(targets).forEach(function (owner) {
        var spec = targets[owner];
        if (spec == null) return;
        var k = keyOf(spec);
        if (seen[k]) return;
        seen[k] = true;
        list.push(spec);
      });
      return list;
    },

    /** Turn a positional reply into `{key: value}` against the note that asked. */
    _valuesFrom: function (note, row) {
      var out = {};
      for (var i = 0; i < note.length; i++) out[keyOf(note[i])] = row[i];
      return out;
    },

    // ---- lifecycle ------------------------------------------------------

    /**
     * Load a model and bring a session up to the point where it can run.
     *
     * `link` is a path on the SimiLive server (`demos/fire_rect.sml`), and
     * `paramLink` an optional `.spf` of parameter values for models that ship
     * their data separately. Feeding this a model of OUR OWN is the next step
     * and needs only a different first request: `create_model.php` already
     * accepts an uploaded `.sml` or `.pl`, so exporting Simile Prolog from the
     * diagram will plug in here without the rest of this file changing.
     *
     * The `.shf` (SimiLive's saved panel layout) is deliberately NOT sent. Its
     * whole content is which display tools to open and how to arrange them,
     * which is the workspace's business here — the shell's panels are the
     * layout, so accepting a second answer to the same question would only mean
     * two of them disagreeing.
     */
    load: function (link, paramLink) {
      var self = this;
      if (this.status === 'loading') return Promise.reject(new Error('already loading'));

      return this.unload().then(function () {
        self.modelLink = link;
        self._setStatus('loading', 'Uploading model…');

        return Promise.resolve($.ajax({
          type: 'POST',
          url: SERVER + 'create_model.php',
          data: {
            model_src: 'url', model_link: link,
            param_src: paramLink ? 'url' : 'none', param_link: paramLink || '',
            helper_src: 'none',
          },
          dataType: 'text',
        }));
      }).then(function (html) {
        // The session id is embedded in a script tag of an HTML page meant for
        // a browser. Scraping it is not elegant, but it is the only way in: the
        // endpoint has no JSON form.
        var m = /fileBase\s*=\s*'([^']+)'/.exec(html);
        if (!m) throw new Error('the server did not start a session (is the model path right?)');
        self.base = m[1];

        self._setStatus('loading', 'Compiling model…');
        return self._post('BuildShareLib');
      }).then(function (log) {
        // A compile log, whose last line is the run defaults as JSON. Anything
        // else on the last line means the compile failed, and the log is then
        // the only diagnosis the user is going to get.
        var last = log.trim().split('\n').pop();
        try {
          self.params = JSON.parse(last);
        } catch (e) {
          if (window.console) console.error('BuildShareLib said:\n' + log);
          throw new Error('the model would not compile — see the console for the log');
        }

        self.unitName = self.params.timeUnit || 'unit';
        self.timeUnit = TIME_LIB[self.unitName] || 1;
        self.settings = {
          runLength: parseFloat(self.params.execTime),
          current: parseFloat(self.params.resetTo),
          updateEach: parseFloat(self.params.displayInt),
          logEach: parseFloat(self.params.displayInt),
          timeStep: String(self.params.phaseList),
        };
        if (self.params.errLimit == null) self.params.errLimit = 0;
        self._emit({ type: 'settings' });

        self._setStatus('loading', 'Starting model process…');
        return self._post('CreateSocket');
      }).then(function () {
        return self._post('WaitSocket');
      }).then(function () {
        self._setStatus('loading', 'Reading model structure…');
        return self._post('Describe');
      }).then(function (text) {
        self.components = JSON.parse(text);
        self._emit({ type: 'describe', components: self.components });
        return self._post('LoadSPF');
      }).then(function () {
        self._firstReset = true;
        return self.reset();
      }).catch(function (err) {
        self._setStatus('error', err.message || String(err));
        throw err;
      });
    },

    /**
     * Tell the server to drop the session. Best-effort: it is a courtesy to a
     * shared public server (each session is a live process and a temp
     * directory), so a failure here is not the user's problem.
     */
    unload: function () {
      this.stop();
      if (!this.base) return Promise.resolve();
      var dead = this.base;
      this.base = null;
      this.components = null;
      this.params = null;
      this._setStatus('idle', '');
      return Promise.resolve(
        $.ajax({
          type: 'POST', url: SERVER + 'model_action.php',
          data: { base: dead, act: 'Exit' }, dataType: 'text',
        }),
      ).catch(function () { /* the session is gone either way */ });
    },

    // ---- running --------------------------------------------------------

    /** Back to the start: re-initialise the model and re-read every target. */
    reset: function () {
      var self = this;
      if (!this.base) return Promise.reject(new Error('no model loaded'));

      this._running = false;
      var note = this.noteList();
      var current = this.params ? parseFloat(this.params.resetTo) : 0;

      return this._post('Reset', {
        current: current * this.timeUnit,
        step: this._scaleTimes(this.settings.timeStep),
        method: this.params.intMethod,
        // -2 on the first reset of a session is what SimiLive sends, and the
        // server takes it as "initialise everything"; later resets are 0.
        depth: this._firstReset ? -2 : 0,
        note: JSON.stringify(note),
      }).then(function (text) {
        self._firstReset = false;
        self.settings.current = current;
        self._emit({ type: 'settings' });
        self._emit({ type: 'progress', fraction: 0 });
        self._setStatus('ready', '');
        self._emit({
          type: 'data',
          time: current,
          values: self._valuesFrom(note, JSON.parse(text)),
          reset: true,
        });
      }).catch(function (err) {
        self._setStatus('error', err.message || String(err));
        throw err;
      });
    },

    /** Read the current value of some targets without advancing the model. */
    query: function (specs) {
      var self = this;
      if (!this.base) return Promise.reject(new Error('no model loaded'));
      return this._post('Query', { note: JSON.stringify(specs) })
        .then(function (text) {
          return self._valuesFrom(specs, JSON.parse(text));
        });
    },

    /**
     * Run from the current time for `runLength`. The loop is here rather than
     * in the widget because two display panels must not each be driving it.
     */
    start: function () {
      if (!this.base || this._running) return;
      this._running = true;
      this._runStart = Number(this.settings.current);
      this._runEnd = this._runStart + Number(this.settings.runLength);
      this._setStatus('running', '');
      this._step();
    },

    /** Stop after the chunk in flight. `settings.current` is left where it is. */
    stop: function () {
      if (!this._running) return;
      this._running = false;
      if (this.status === 'running') this._setStatus('ready', '');
    },

    _step: function () {
      var self = this;
      if (!this._running) return;

      var current = Number(this.settings.current);
      if (current >= this._runEnd) {
        this._running = false;
        this._setStatus('ready', '');
        this._emit({ type: 'progress', fraction: 1 });
        return;
      }

      var interval = Math.min(this._runEnd - current, Number(this.settings.updateEach));
      var note = this.noteList();

      this._post('ExecuteMulti', {
        runlength: interval * this.timeUnit,
        current: current * this.timeUnit,
        step: this._scaleTimes(this.settings.timeStep),
        method: this.params.intMethod,
        log: Number(this.settings.logEach) * this.timeUnit,
        errLimit: this.params.errLimit,
        note: JSON.stringify(note),
      }).then(function (text) {
        if (!self._running) return; // paused while this was in flight

        var history = JSON.parse(text);
        // Last element is the execution status; everything before it is a
        // logged point: [value-per-note-entry…, timestamp].
        var ok = history[history.length - 1];
        var points = history.slice(0, -1);

        points.forEach(function (row) {
          self._emit({
            type: 'data',
            time: parseFloat(row[row.length - 1]) / self.timeUnit,
            values: self._valuesFrom(note, row),
            reset: false,
          });
        });

        if (points.length) {
          var lastRow = points[points.length - 1];
          self.settings.current = parseFloat(lastRow[lastRow.length - 1]) / self.timeUnit;
        } else {
          // No logged point inside this chunk (a log interval longer than the
          // update interval). The model still advanced, so trust the clock.
          self.settings.current = current + interval;
        }
        self._emit({ type: 'settings' });
        self._emit({
          type: 'progress',
          fraction: Math.max(0, Math.min(1,
            (self.settings.current - self._runStart) / (self._runEnd - self._runStart))),
        });

        if (!ok) {
          // The model stopped itself — an error limit, or a condition inside
          // the model. Not a failure to report as a crash, but the run is over.
          self._running = false;
          self._setStatus('ready', 'the model stopped at t = ' + self.settings.current);
          return;
        }

        // A macrotask, not a microtask: the browser must get a chance to paint
        // the frames just emitted before the next chunk is asked for.
        window.setTimeout(function () { self._step(); }, 0);
      }).catch(function (err) {
        self._running = false;
        self._setStatus('error', err.message || String(err));
      });
    },

    // ---- reading the model ----------------------------------------------

    /**
     * Components that could be shown on a spatial grid: a value-bearing
     * variable two dimensions deep. `dims` is [rows, cols, 0] for a scalar per
     * cell and [rows, cols, n, 0] for an array per cell, so the width is only
     * known directly in the shapes SimiLive itself accepts; anything else is
     * still offered, with the column count left for the user to say.
     */
    gridCandidates: function () {
      var comps = this.components;
      if (!comps) return [];
      var out = [];
      Object.keys(comps).forEach(function (id) {
        var c = comps[id];
        if (c.type === 'VALUELESS') return;
        var dims = c.dims || [];
        if (dims.length < 3) return; // [0] is a scalar; [n,0] is a plain list
        var parent = comps[c.parent];
        var rows = parseInt(dims[0], 10);
        var knownCols = (dims.length === 3 || (dims.length === 4 && parseInt(dims[2], 10) === 3))
          && !isNaN(rows) && !isNaN(parseInt(dims[1], 10));
        out.push({
          id: id,
          // Caption paths carry the line breaks from the diagram's labels —
          // "/cell/live\nneighbours" — which would break a one-line menu.
          label: String(c.captpath || c.text).replace(/\s+/g, ' '),
          rows: rows,
          cols: knownCols ? parseInt(dims[1], 10) : null,
          hex: !!(parent && parent.eval === 'HONEYCOMB'),
          grid: !!(parent && (parent.eval === 'GRID' || parent.eval === 'HONEYCOMB')),
        });
      });
      // Members of an actual grid submodel first — in the fire model that is
      // the difference between five plausible answers and the right one.
      out.sort(function (a, b) {
        if (a.grid !== b.grid) return a.grid ? -1 : 1;
        return String(a.label).localeCompare(String(b.label));
      });
      return out;
    },
  };

  Sienna.Simulation = Simulation;

  // The session is a process on someone else's server; leaving without saying
  // so strands it until the server times it out.
  $(window).on('unload', function () {
    if (!Simulation.base) return;
    Simulation.stop();
    try {
      navigator.sendBeacon(
        SERVER + 'model_action.php',
        new URLSearchParams({ base: Simulation.base, act: 'Exit' }),
      );
    } catch (e) { /* nothing more we can do on the way out */ }
  });
})(window.Sienna, window.jQuery);
