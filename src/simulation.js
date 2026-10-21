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

  /**
   * How much model time to ask for in one request, given the run and the log
   * interval. Aims for `UPDATES_PER_RUN` refreshes across the run — enough for
   * a plot to look live — and never asks for less than one logged point, since
   * a chunk shorter than the log interval buys nothing but another round trip.
   * A whole multiple of `logEach` keeps chunk boundaries on logged points.
   */
  var UPDATES_PER_RUN = 20;

  /**
   * How many time bases one of our models runs on: 1, or the highest "Time
   * base" (`timeBase`, Simile's `step=N`) of any of its submodels. Each has
   * its own time step, `dt(N)`.
   */
  function timeBasesOf(path) {
    var model = path ? Sienna.userData.get(path) : null;
    var subs = (model && model.submodels) || {};
    return Object.keys(subs).reduce(function (n, id) {
      var b = parseInt(String((subs[id].props || {}).timeBase || ''), 10);
      return b > n ? b : n;
    }, 1);
  }

  /**
   * A time-step setting with at least one value per time base. Neither the
   * page's engine nor a model file says what a further base's step is, and
   * one never set is not a step at all, so a missing value repeats the last
   * one given ("0.1" for two bases → "0.1 0.1"). The modeller changes it in
   * the run settings, one value per base.
   */
  function padSteps(step, bases) {
    var parts = String(step).trim().split(/\s+/).filter(Boolean);
    if (!parts.length) return String(step);
    while (parts.length < bases) parts.push(parts[parts.length - 1]);
    return parts.join(' ');
  }

  function chunkFor(runLength, logEach) {
    var log = logEach > 0 ? logEach : 1;
    var run = runLength > 0 ? runLength : log;
    var steps = Math.max(1, Math.round(run / UPDATES_PER_RUN / log));
    return Math.min(run, steps * log);
  }

  /**
   * The run settings a modeller chose, per model, so loading a model again —
   * after an edit, or another day — does not put them back to the model's
   * defaults. Kept beside the models rather than inside them: they are how
   * this person likes to run it, not part of what the model says.
   */
  var SETTINGS_KEY = 'simile.runSettings.v1';

  /**
   * What to call a component in a list or a legend. Simile names one by
   * its path from the top of the model — `/account`, `/forest/tree/height`.
   * A display looks at the whole model, so names are given as seen from the
   * top (the convention everywhere: a name carries the path of submodels
   * outside the one it is seen from, and nothing more): `account` at the top,
   * `forest/tree/height` in a submodel. Never a leading `/`.
   */
  function displayName(c) {
    return String(c.captpath || c.text || '').replace(/\s+/g, ' ').replace(/^\/+/, '');
  }

  /** A model's Prolog without its first line, which is stamped with the time. */
  function essence(prolog) {
    return String(prolog).replace(/^source\(.*\)\.\n/, '');
  }
  var KEPT = ['runLength', 'updateEach', 'logEach', 'timeStep'];

  // The same, for this visit only. Where nothing is stored — a page that keeps
  // nothing (`Sienna.ephemeral`), or no storage at all — settings must still
  // survive a reload of the model within the visit, or ▶ after an edit would
  // quietly put the run back to the model's defaults.
  var keptThisVisit = {};

  function rememberedFor(key) {
    var all = (Sienna.persistence && Sienna.persistence.readJSON(SETTINGS_KEY)) || {};
    return key ? all[key] || keptThisVisit[key] || null : null;
  }

  function remember(key, settings) {
    if (!key) return;
    var keep = {};
    KEPT.forEach(function (k) { if (settings[k] != null) keep[k] = settings[k]; });
    keptThisVisit[key] = keep;
    if (!Sienna.persistence) return;
    var all = Sienna.persistence.readJSON(SETTINGS_KEY) || {};
    all[key] = keep;
    Sienna.persistence.writeJSON(SETTINGS_KEY, all);
  }

  var Simulation = {
    SERVER: SERVER,
    keyOf: keyOf,
    displayName: displayName,

    /** 'idle' | 'loading' | 'ready' | 'running' | 'error' */
    status: 'idle',
    message: '',

    base: null,        // the server-side session id ('/tmp/dbx…'), or 'local:…'
    local: null,       // the compiled model running in the page, when it is
    params: null,      // run defaults from BuildShareLib
    components: null,  // the Describe dictionary: id -> {text, captpath, dims, …}
    modelLink: '',     // what was loaded, for display
    modelPath: null,   // which of OUR models is loaded (its userData path), if any
    loadedFor: null,   // the model whose run control loaded it (see viewFor)
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
      // A model running in the page answers the same requests, in the same shapes
      // (src/engine-local.js), without leaving the page.
      if (this.local) return this.local.act(act, data);
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
        self.modelPath = null;   // a server demo, not one of ours
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
        return self._startSession(html);
      }).catch(function (err) {
        self._setStatus('error', err.message || String(err));
        throw err;
      });
    },

    /**
     * Everything after the model has been handed over, however it was handed
     * over: find the session id, compile, attach, read the structure, reset.
     */
    _startSession: function (html, localBase) {
      var self = this;

      return Promise.resolve().then(function () {
        if (localBase) {
          self.base = localBase;
        } else {
          // The session id is embedded in a script tag of an HTML page meant
          // for a browser. Scraping it is not elegant, but it is the only way
          // in: the endpoint has no JSON form.
          var m = /fileBase\s*=\s*'([^']+)'/.exec(html);
          if (!m) throw new Error('the server did not start a session (is the model path right?)');
          self.base = m[1];
        }

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
        var runLength = parseFloat(self.params.execTime);
        var logEach = parseFloat(self.params.displayInt);
        self.settings = {
          runLength: runLength,
          current: parseFloat(self.params.resetTo),
          // NOT displayInt, which is what these two used to share. `logEach` is
          // how often the model records a point and belongs to the model;
          // `updateEach` is how much of the run is asked for in one request and
          // belongs to the display. Conflating them made the chunk as small as
          // the log interval, so a run of 100 logging every 1 was a hundred
          // round trips to a server on the other end of the internet. Measured
          // 2026-09-08 against SimiLive, growth, 100 logged points either way:
          // updateEach 1 → 4068ms, 10 → 402ms, 100 → 46ms. The results are
          // identical; a small chunk buys nothing but how often the plot
          // advances while the run is going.
          updateEach: chunkFor(runLength, logEach),
          logEach: logEach,
          timeStep: String(self.params.phaseList),
        };
        // What the modeller set last time for this model, over its defaults.
        var kept = rememberedFor(self._settingsKey());
        if (kept) {
          KEPT.forEach(function (k) { if (kept[k] != null) self.settings[k] = kept[k]; });
          // The chunk follows the run actually made, not the model's default
          // length: a page running 300 where the model says 100 would
          // otherwise ask for it in 60 pieces, each one a redraw.
          if (kept.updateEach == null) {
            self.settings.updateEach = chunkFor(Number(self.settings.runLength), Number(self.settings.logEach));
          }
        }
        self.settings.timeStep = padSteps(self.settings.timeStep, timeBasesOf(self.modelPath));
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
     * Load a model of OUR OWN: convert it and upload the bytes, rather than
     * naming something already on the server.
     *
     * This is the step the whole exercise was for. It shares everything after
     * the first request with `load` — the difference is one multipart POST
     * instead of a form field, which is why `create_model.php` accepting an
     * uploaded file was worth confirming before any of this was written.
     */
    loadOwn: function (path) {
      var self = this;
      var model = Sienna.userData.get(path);
      if (!model) return Promise.reject(new Error('no model at ' + path));

      var sml;
      try {
        // With the sliders' values in it: the model's defaults are then what
        // the sliders say, so a starting value (which only a load can change,
        // see `setParameter`) is right, and a reset keeps every value.
        sml = Sienna.exportSimile.sml(this._withParameters(path, model));
      } catch (err) {
        // A refusal to export is a message about the MODEL, written for the
        // modeller. Surface it as-is rather than wrapping it in transport talk.
        this._setStatus('error', err.message || String(err));
        return Promise.reject(err);
      }

      return this.unload().then(function () {
        self.modelLink = model.name || model.id || path;
        self.modelPath = path;
        // What was run, to tell later whether the model has been
        // edited since. The Prolog, not the .sml: the .sml wraps it in MIME
        // with a fresh random boundary each time.
        var prolog = Sienna.exportSimile.prolog(model);
        self._loadedText = essence(prolog);

        // Run it in the page: compiled for exactly this model already, if it
        // is, or compiled here now (seconds; the first time, a few more to
        // load the tools). The slider values are not written in (as they are
        // in `sml`): a model run here takes every one at a reset, starting
        // values included. Only if it cannot be compiled, SimiLive.
        var token = self._loading = {};
        var LE = Sienna.LocalEngine;
        var entry = LE ? LE.find(prolog) : null;
        var made = entry ? Promise.resolve(entry) : !LE ? Promise.resolve(null)
          : LE.build(self.modelLink, prolog, function (text) {
            if (self._loading === token) self._setStatus('loading', text);
          }).catch(function (err) {
            if (window.console) console.warn('Running the model on SimiLive: ' + err.message);
            return null;
          });
        return made.then(function (entry) {
          // Another load began while this one was building: it is the one.
          if (self._loading !== token) throw Object.assign(new Error('superseded'), { superseded: true });
          if (entry) return self._runHere(entry);
          return self._upload(sml);
        });
      }).catch(function (err) {
        if (err.superseded) throw err;
        self._setStatus('error', err.message || String(err));
        throw err;
      });
    },

    /** Start a compiled model in the page. */
    _runHere: function (entry) {
      var self = this;
      self._setStatus('loading', 'Starting the model in the page…');
      return Sienna.LocalEngine.open(entry).then(function (session) {
        self.local = session;
        return self._startSession(null, 'local:' + entry.name);
      });
    },

    /** Hand the model to SimiLive. */
    _upload: function (sml) {
      var self = this;
      return Promise.resolve().then(function () {
        self._setStatus('loading', 'Uploading model…');
        var fd = new FormData();
        fd.append('model_src', 'file');
        fd.append('model', new Blob([sml], { type: 'application/octet-stream' }), 'model.sml');
        fd.append('param_src', 'none');
        fd.append('helper_src', 'none');

        return Promise.resolve($.ajax({
          type: 'POST', url: SERVER + 'create_model.php', data: fd,
          processData: false, contentType: false, dataType: 'text',
        }));
      }).then(function (html) {
        return self._startSession(html);
      });
    },

    /**
     * Tell the server to drop the session. Best-effort: it is a courtesy to a
     * shared public server (each session is a live process and a temp
     * directory), so a failure here is not the user's problem.
     */
    unload: function () {
      this.stop();
      // Whose session it was goes even when there is no session: a load that
      // failed leaves a claim behind and no base, and the next load is not it.
      this.modelPath = null;
      this.loadedFor = null;
      this._loadedText = null;
      this._runStep = null;
      if (!this.base) return Promise.resolve();
      var dead = this.base;
      var local = this.local;
      this.base = null;
      this.local = null;
      this.components = null;
      this.params = null;
      this._setStatus('idle', '');
      if (local) {
        local.exit();
        return Promise.resolve();
      }
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
      // The step a run is made with is fixed here, at its start. SimiLive
      // takes a new step one request late — a change made at the start of a
      // run gave 320.18 for a first year that is 320 — so a change waits for
      // the next reset rather than being half applied (see `start`).
      this._runStep = String(this.settings.timeStep);

      // A model run in the page takes the slider values BEFORE the reset, and
      // all of them — the whole set, so one put back is cleared — and keeps
      // them through it, starting values included.
      var before = !this.local ? Promise.resolve()
        : this._post('Parameterize', { data: JSON.stringify(this._liveParameters(true)) });

      return before.then(function () {
        return self._post('Reset', {
          current: current * self.timeUnit,
          step: self._scaleTimes(self._runStep),
          method: self.params.intMethod,
          // -2 on the first reset of a session is what SimiLive sends, and the
          // server takes it as "initialise everything"; later resets are 0.
          depth: self._firstReset ? -2 : 0,
          note: JSON.stringify(note),
        });
      }).then(function (text) {
        if (self.local) return text;
        // A reset puts every variable parameter back to the model's value, so
        // the sliders' values go back in — and the values read again, since
        // what the reset reported was computed before them.
        var live = self._liveParameters();
        if (!Object.keys(live).length) return text;
        live.seqNo = ++self._paramSeq;
        return self._post('Parameterize', { data: JSON.stringify(live) })
          .then(function () { return self._post('Query', { note: JSON.stringify(note) }); });
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
    start: function (justLoaded) {
      var self = this;
      if (!this.base || this._running) return;

      // Edited since it was loaded: ▶ means "run what I have drawn", so load
      // it again first — as Simile's Run rebuilds before it runs. The run
      // settings come back with it (`remember`), and plots rebind by name.
      if (!justLoaded && this.isStale()) {
        this._reload().then(function () { self.start(true); }, function () { /* reported */ });
        return;
      }
      // A time step changed before anything has run: start again with it, so
      // the whole run is made with the step it shows.
      if (this.stepPending() && this.atStart()) {
        this.reset().then(function () { self.start(); }, function () { /* reported */ });
        return;
      }

      this._running = true;
      this._runStart = Number(this.settings.current);
      this._runEnd = this._runStart + Number(this.settings.runLength);
      this._setStatus('running', '');
      this._step();
    },

    /** True while nothing has been run since the last reset. */
    atStart: function () {
      var from = this.params ? parseFloat(this.params.resetTo) : 0;
      return Number(this.settings.current) === from;
    },

    /** A time step has been typed that the run in progress is not using. */
    stepPending: function () {
      return !!this.base && this._runStep != null
        && String(this.settings.timeStep).trim() !== this._runStep;
    },

    /**
     * The run settings chosen for one of our models — as they were last set
     * for it, over nothing — or null if none were. What File ▸ Export model as
     * script ships with the model, so a page runs it the way its modeller did.
     * `updateEach` is left out: it is about the network, not the model.
     */
    settingsFor: function (path) {
      var kept = rememberedFor(path);
      if (!kept) return null;
      var out = {};
      ['runLength', 'logEach', 'timeStep'].forEach(function (k) {
        if (kept[k] != null) out[k] = kept[k];
      });
      return Object.keys(out).length ? out : null;
    },

    // ---- parameters (sliders) ---------------------------------------------

    /**
     * Values the sliders have given a model's parameters, by model path and
     * node id. NOT edits to the model: the stored model keeps its own values,
     * a slider's is a setting for running it, gone with the page. They apply
     * to that model whenever it is the one loaded.
     */
    _overrides: {},
    _preview: {},      // a slider being dragged: {path: {nodeId: number}}
    _paramSeq: 0,

    /** The slider values for one model: `{nodeId: number}`. */
    parameterValues: function (path) {
      return $.extend({}, this._overrides[path] || {});
    },

    /** Is this model being run in the page? */
    runsHere: function (path) {
      return !!this.local && this.modelPath === path;
    },

    /**
     * Run one of a model's parameters at `value` instead of the model's own.
     * Runs again from the start when that model is the one loaded. On
     * SimiLive a rate changes in place (`Parameterize`, about a second) and a
     * starting value means loading the model again, since Simile fixes those
     * when it builds it and a reset puts them back. In the page, both are a
     * reset and a run: milliseconds.
     * @returns {Promise}
     */
    setParameter: function (path, nodeId, value) {
      var o = this._overrides[path] || (this._overrides[path] = {});
      var reload = Simulation.parameterNeedsLoad(path, nodeId) && o[nodeId] !== value;
      o[nodeId] = value;
      delete this._preview[path];
      this._emit({ type: 'parameters', path: path });
      return this._rerun(path, reload);
    },

    /**
     * Run with a value a slider is passing through as it is dragged — only
     * where that is fast enough to keep up: in the page. Nothing is
     * recorded: the value the slider is let go at is `setParameter`'s.
     */
    previewParameter: function (path, nodeId, value) {
      if (!this.runsHere(path)) return Promise.resolve();
      var p = this._preview[path] || (this._preview[path] = {});
      p[nodeId] = value;
      return this._rerun(path, false);
    },

    /** Every slider back to the model's own value, and run again. */
    clearParameters: function (path) {
      var had = this._overrides[path] || {};
      var reload = Object.keys(had).some(function (id) { return Simulation.parameterNeedsLoad(path, id); });
      delete this._overrides[path];
      delete this._preview[path];
      this._emit({ type: 'parameters', path: path });
      return this._rerun(path, reload);
    },

    _rerun: function (path, reload) {
      var self = this;
      if (this.modelPath !== path || !this.base || this.status === 'loading') return Promise.resolve();
      // In the page, runs come faster than a slider moves; one asked for while
      // another is under way is made when it ends, and only the latest.
      if (this.local && this._rerunning) {
        this._rerunAgain = true;
        return this._rerunning;
      }
      this.stop();
      var go = reload ? this._reload().then(function () { self.start(true); })
        : this.reset().then(function () { self.start(); });
      go = go.catch(function () { /* reported through status */ });
      if (!this.local) return go;
      this._rerunning = go.then(function () { return self._whenRunEnds(); }).then(function () {
        self._rerunning = null;
        if (self._rerunAgain) {
          self._rerunAgain = false;
          return self._rerun(path, false);
        }
      });
      return this._rerunning;
    },

    /** Resolves when the run under way (if any) has finished or stopped. */
    _whenRunEnds: function () {
      var self = this;
      if (!this._running) return Promise.resolve();
      return new Promise(function (resolve) {
        var off = self.subscribe(function (e) {
          if (e.type === 'status' && e.status !== 'running') { off(); resolve(); }
        });
      });
    },

    /** The model as loaded: its slider values written in as its own. */
    _withParameters: function (path, model) {
      var o = this._overrides[path];
      if (!o || !Object.keys(o).length) return model;
      var copy = JSON.parse(JSON.stringify(model));
      Object.keys(o).forEach(function (id) {
        var n = copy.nodes[id];
        if (n && n.props) n.props.value = String(o[id]);
      });
      return copy;
    },

    /**
     * `{captpath: 'NOW value'}` for the loaded model's rate parameters — or,
     * with `all`, for every parameter a slider has moved (a model run in the
     * page takes starting values too), a slider being dragged included.
     */
    _liveParameters: function (all) {
      var path = this.modelPath;
      var o = $.extend({}, (path && this._overrides[path]) || {},
        (all && path && this._preview[path]) || {});
      var out = {};
      Simulation.parametersOf(path).forEach(function (p) {
        if (p.id in o && (all || !p.needsLoad)) out[p.captpath] = 'NOW ' + o[p.id];
      });
      return out;
    },

    /**
     * Say how one of our models is to be run before it is loaded — what a
     * page with the model embedded in it ships with (`Simile.model`). Taken
     * as if the modeller had set them: they replace the model's defaults on
     * every load. Only the settings named are given.
     */
    presetSettings: function (path, settings) {
      var keep = $.extend({}, rememberedFor(path) || {});
      KEPT.forEach(function (k) { if (settings && settings[k] != null) keep[k] = settings[k]; });
      remember(path, keep);
    },

    /** Change one run setting, and remember it for this model. */
    setSetting: function (key, value) {
      // A chunk nobody chose follows the run's length and log interval; one
      // set by hand (Update each) stays.
      if ((key === 'runLength' || key === 'logEach')
          && Number(this.settings.updateEach)
            === chunkFor(Number(this.settings.runLength), Number(this.settings.logEach))) {
        var next = $.extend({}, this.settings);
        next[key] = value;
        this.settings.updateEach = chunkFor(Number(next.runLength), Number(next.logEach));
      }
      this.settings[key] = value;
      remember(this._settingsKey(), this.settings);
      this._emit({ type: 'settings' });
    },

    _settingsKey: function () {
      return this.modelPath || (this.modelLink ? 'server:' + this.modelLink : null);
    },

    /**
     * One of our models, edited since it was loaded. Compared as what would be
     * sent — so moving an element about, which changes nothing the simulation
     * sees, does not count. A model that will not export counts as changed:
     * reloading it is how the modeller gets told why.
     */
    isStale: function () {
      if (!this.base || !this.modelPath || this._loadedText == null) return false;
      var model = Sienna.userData.get(this.modelPath);
      if (!model) return false;
      try {
        return essence(Sienna.exportSimile.prolog(model)) !== this._loadedText;
      } catch (e) {
        return true;
      }
    },

    /** Load the same model again, keeping whose session it is. */
    _reload: function () {
      var owner = this.loadedFor;
      var p = this.loadOwn(this.modelPath);
      // `loadOwn` begins with a synchronous unload, which drops the claim.
      this.loadedFor = owner;
      return p;
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

      // In the page the whole run is one request: Update each is about how
      // often a remote run reports, and a run here is over in milliseconds.
      var interval = this.local ? this._runEnd - current
        : Math.min(this._runEnd - current, Number(this.settings.updateEach));
      var note = this.noteList();

      this._post('ExecuteMulti', {
        runlength: interval * this.timeUnit,
        current: current * this.timeUnit,
        step: this._scaleTimes(this._runStep),
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
     * Components that are one number — what a plotter can draw against time.
     * `dims` is `[0]` for a scalar; anything longer is a value per submodel
     * instance, which is a different chart and not this one.
     */
    scalarComponents: function () {
      var comps = this.components;
      if (!comps) return [];
      return Object.keys(comps).filter(function (id) {
        var c = comps[id];
        return c.type !== 'VALUELESS' && (c.dims || []).length === 1;
      }).map(function (id) {
        return {
          id: id,
          label: displayName(comps[id]),
          units: comps[id].units || '',
        };
      }).sort(function (a, b) { return a.label.localeCompare(b.label); });
    },

    /**
     * Components with one number per member of a population — `dims` is
     * `['MEMBERS', 0]`. Simile sends one as an object keyed by member
     * (`{"2": 3, "3": 1.6}`), and a member keeps its key for as long as it
     * exists, so a display can follow each one through time: a line per tree on
     * a plot, a lollipop per tree on the ground. Members of a population inside
     * another multi-instance submodel are not offered — their value is nested
     * a level deeper, and nothing here draws that yet.
     */
    memberComponents: function () {
      var comps = this.components;
      if (!comps) return [];
      return Object.keys(comps).filter(function (id) {
        var c = comps[id];
        return c.type !== 'VALUELESS' && Simulation.isPerInstance(c.dims);
      }).map(function (id) {
        return {
          id: id,
          label: displayName(comps[id]),
          units: comps[id].units || '',
        };
      }).sort(function (a, b) { return a.label.localeCompare(b.label); });
    },

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
          label: displayName(c),
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

  /**
   * The variables a model HAS, read from the diagram rather than the running model,
   * named as Simile will name them once it is loaded (`tree/size`).
   *
   * A display lists what it can show from Simile's description of the
   * model loaded, which is the only place values come from — so a variable
   * added since the last load was missing from the list, and the modeller had
   * to load before they could even choose it. Offering these as well lets a
   * display take one at once and fill it in when the model next loads, which
   * ▶ does by itself after an edit (Robert, 2026-10-13).
   *
   * `many` marks one with a value per instance of ONE multi-instance
   * submodel — a population's members, a fixed membership of one dimension,
   * or an ASSOCIATION's pairings (`isPerInstance`); an association's kind is
   * stored as `single`, but it has an instance per pairing, and taken for one
   * instance its variables were listed "(from the next run)" for ever
   * (Robert, 2026-10-21). Left out, since no display here draws them:
   * anything deeper (two such levels, a 2-D grid).
   */
  /**
   * One number per instance of ONE multi-instance submodel — what a plot
   * draws as a line each:
   *   - a population's members, `dims` `['MEMBERS', 0]`, sent as
   *     `{member: value}`;
   *   - a fixed membership's instances, `[n, 0]`, sent as an array;
   *   - an association's pairings, `[0, n1, n2, 0, 0]` (one size per role),
   *     sent as `{"i,j": value}` for the pairings that exist — farmer i with
   *     field j (`sx_value` in tools/engine/bridge.cpp).
   * Anything deeper (a 4×44 grid, a population inside another multi-instance
   * submodel) is not this.
   */
  Simulation.isPerInstance = function (dims) {
    dims = (dims || []).map(String);
    var whole = function (x) { return /^\d+$/.test(x) && x !== '0'; };
    if (dims.length === 2) return dims[0] === 'MEMBERS' || whole(dims[0]);
    return dims.length >= 4 && dims[0] === '0' && dims[dims.length - 1] === '0'
      && dims[dims.length - 2] === '0' && dims.slice(1, -2).every(whole);
  };

  Simulation.variablesOf = function (ref) {
    var m = ref && Sienna.userData ? Sienna.userData.get(ref) : null;
    if (!m || !m.nodes) return [];
    var subs = m.submodels || {};
    var KINDS = { stock: true, variable: true, valve: true };
    var out = [];
    Object.keys(m.nodes).forEach(function (id) {
      var n = m.nodes[id];
      if (!KINDS[n.type] || !n.label) return;
      var path = [];
      var multi = [];
      for (var p = n.parent; p && subs[p]; p = subs[p].parent) {
        path.unshift(subs[p].label || p);
        if (Sienna.Diagram && Sienna.Diagram.isAssociation(m, p)) multi.push('association');
        else if (subs[p].kind === 'population') multi.push('population');
        else if (subs[p].kind === 'fixed-membership') {
          // One dimension only: "10", not "4,44".
          multi.push(String((subs[p].props || {}).dimensions || '').indexOf(',') < 0 ? 'fixed' : 'grid');
        }
      }
      if (multi.length > 1 || multi[0] === 'grid') return;
      out.push({ label: path.concat([n.label]).join('/'), many: multi.length === 1 });
    });
    return out.sort(function (a, b) { return a.label.localeCompare(b.label); });
  };

  /**
   * A model's PARAMETERS — what a slider can move: each variable that
   * `exportSimile.isParameter` says Simile will take as a "variable
   * parameter" (a number for its value, a minimum and a maximum, nothing
   * influencing it). Read from the model, so they are there before it is
   * loaded. Members of a population are left out: Simile gives them no slider.
   *
   * `needsLoad` marks one a starting value depends on — an influence path
   * leads from it to a stock or a creation — which only loading the model again changes.
   * @returns {Array<{id, label, captpath, value, min, max, units, needsLoad}>}
   */
  Simulation.parametersOf = function (ref) {
    var m = ref && Sienna.userData ? Sienna.userData.get(ref) : null;
    if (!m || !m.nodes || !Sienna.exportSimile) return [];
    var subs = m.submodels || {};
    var out = [];
    Object.keys(m.nodes).forEach(function (id) {
      if (!Sienna.exportSimile.isParameter(m, id)) return;
      var n = m.nodes[id];
      var path = [];
      var multi = false;
      for (var p = n.parent; p && subs[p]; p = subs[p].parent) {
        path.unshift(subs[p].label || p);
        if (subs[p].kind && subs[p].kind !== 'single') multi = true;
      }
      if (multi) return;
      var label = path.concat([n.label]).join('/');
      out.push({
        id: id,
        label: label,
        captpath: '/' + label,
        value: Number(n.props.value),
        min: Number(n.props.min),
        max: Number(n.props.max),
        units: n.props.units || '',
        needsLoad: reachesStock(m, id) && !Simulation.runsHere(ref),
      });
    });
    return out.sort(function (a, b) { return a.label.localeCompare(b.label); });
  };

  Simulation.parameterNeedsLoad = function (ref, id) {
    // The engine in the page takes a starting value at a reset (src/engine-local.js).
    if (Simulation.runsHere(ref)) return false;
    var m = ref && Sienna.userData ? Sienna.userData.get(ref) : null;
    return !!(m && m.nodes && reachesStock(m, id));
  };

  /**
   * Does an influence path lead from `id` to a starting value: a stock's, or
   * the number a population's creation makes (`initialiser`)? Both are
   * evaluated once, as the model is built.
   */
  function reachesStock(m, id) {
    var seen = {};
    var todo = [id];
    while (todo.length) {
      var at = todo.pop();
      if (seen[at]) continue;
      seen[at] = true;
      var hit = Object.keys(m.arcs || {}).some(function (k) {
        var a = m.arcs[k];
        if (a.type !== 'influence' || a.from !== at) return false;
        var t = (m.nodes[a.to] || {}).type;
        if (t === 'stock' || t === 'initialiser') return true;
        todo.push(a.to);
        return false;
      });
      if (hit) return true;
    }
    return false;
  }

  /**
   * The session as seen by a panel that belongs to ONE model (its `ref`) — a
   * run control or display in that model's Simulation collection. There is one
   * session, so one model loaded at a time, and another model's panels must
   * not show this one's run or drive it. Through this view a panel sees the
   * session only while it is ITS model's: loaded by its model's run control
   * (whatever that loaded, a server demo included), or, when an unbound run
   * control did the loading, while its model is the one up there. Otherwise no
   * model is loaded as far as it can tell, which is exactly what it then says —
   * and loading from its run control replaces whatever was loaded.
   *
   * Status events always pass, so a panel clears when its model is replaced.
   * A panel with no model (`ref` empty) gets the session itself, as before.
   *
   * Several sessions at once — two runs side by side — would replace this with
   * a session per model; deliberately not yet.
   */
  Simulation.viewFor = function (ref) {
    var sim = Simulation;
    if (!ref) return sim;
    var mine = function () {
      return sim.loadedFor ? sim.loadedFor === ref : sim.modelPath === ref;
    };
    var claim = function (call) {
      if (sim.status === 'loading') return call();   // refused: already loading
      var p = call();
      // After the call, because a load begins by unloading, which clears the
      // claim. If nothing is loaded now, this load is ours — including one
      // that failed at once, whose error is then ours to show. If something
      // still is, the load was refused before it touched the session.
      if (!sim.base) sim.loadedFor = ref;
      return p;
    };
    return {
      get base() { return mine() ? sim.base : null; },
      get components() { return mine() ? sim.components : null; },
      get status() { return mine() ? sim.status : 'idle'; },
      get message() { return mine() ? sim.message : ''; },
      get modelLink() { return mine() ? sim.modelLink : ''; },
      get params() { return mine() ? sim.params : null; },
      get settings() { return sim.settings; },
      get unitName() { return sim.unitName; },
      scalarComponents: function () { return mine() ? sim.scalarComponents() : []; },
      memberComponents: function () { return mine() ? sim.memberComponents() : []; },
      gridCandidates: function () { return mine() ? sim.gridCandidates() : []; },
      addTarget: function (owner, spec) { return sim.addTarget(owner, spec); },
      removeTarget: function (owner) { return sim.removeTarget(owner); },
      query: function (specs) {
        return mine() ? sim.query(specs) : Promise.reject(new Error(ref + ' is not loaded'));
      },
      load: function (link, params) { return claim(function () { return sim.load(link, params); }); },
      loadOwn: function (path) { return claim(function () { return sim.loadOwn(path); }); },
      unload: function () { return mine() ? sim.unload() : Promise.resolve(); },
      reset: function () { return mine() ? sim.reset() : Promise.resolve(); },
      start: function () { if (mine()) sim.start(); },
      setSetting: function (key, value) { return sim.setSetting(key, value); },
      // A model's slider values are its own whichever model is loaded: they
      // apply when it next is.
      parameterValues: function (path) { return sim.parameterValues(path); },
      setParameter: function (path, id, v) { return sim.setParameter(path, id, v); },
      previewParameter: function (path, id, v) { return sim.previewParameter(path, id, v); },
      runsHere: function (path) { return sim.runsHere(path); },
      clearParameters: function (path) { return sim.clearParameters(path); },
      stepPending: function () { return mine() && sim.stepPending(); },
      atStart: function () { return sim.atStart(); },
      isStale: function () { return mine() && sim.isStale(); },
      get modelPath() { return mine() ? sim.modelPath : null; },
      stop: function () { if (mine()) sim.stop(); },
      subscribe: function (fn) {
        return sim.subscribe(function (e) {
          if (e.type === 'status' || e.type === 'parameters' || mine()) fn(e);
        });
      },
    };
  };

  Sienna.Simulation = Simulation;

  // The session is a process on someone else's server; leaving without saying
  // so strands it until the server times it out.
  $(window).on('unload', function () {
    if (!Simulation.base || Simulation.local) return;
    Simulation.stop();
    try {
      navigator.sendBeacon(
        SERVER + 'model_action.php',
        new URLSearchParams({ base: Simulation.base, act: 'Exit' }),
      );
    } catch (e) { /* nothing more we can do on the way out */ }
  });
})(window.Sienna, window.jQuery);
