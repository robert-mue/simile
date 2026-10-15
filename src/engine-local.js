/**
 * `Sienna.LocalEngine` — Simile's engine running in the page, as WebAssembly,
 * standing in for SimiLive.
 *
 * Simile's own engine (`Run/shank.cpp` of github.com/jal-frezie/simile) is
 * compiled once into `vendor/simile-engine/simile-engine.js`; a model is
 * compiled by Simile into C++ and then into a small WebAssembly module of its
 * own, shipped as `<name>.engine.js` (tools/engine/build-model.sh), which
 * calls `Simile.engine(name, {prolog, wasm})`. That engine is used only while
 * the model is EXACTLY the one it was made from (`prolog` is a fingerprint of
 * the Simile Prolog the exporter writes for it). For any other model — an
 * edited one, or one with no engine file — `build` makes one in the page
 * (`src/engine-build.js`: Simile's generator and clang, both in WebAssembly),
 * kept for the visit under its fingerprint, so undoing an edit finds the
 * engine already made. Should that fail (the tools missing, or a model Simile
 * cannot generate), the model runs on SimiLive as before.
 *
 * A session answers the requests `Sienna.Simulation` sends to SimiLive, in
 * the shapes SimiLive answers them — the server side is
 * `Extensions/www/web_embed.tcl` (`ResponseTo`), and this is that, in
 * JavaScript, over the engine's C API (`tools/engine/bridge.cpp`). So the
 * session layer and every widget are the same for both; what differs is that
 * no request leaves the page. A run takes milliseconds rather than seconds.
 *
 * Two differences from SimiLive, both to the good:
 * - `Parameterize` REPLACES the set of slider values (one not named goes back
 *   to the model's), and is sent BEFORE a reset rather than after;
 * - a reset keeps them (the engine's "slider rollover"), so a parameter a
 *   starting value depends on works like any other, with no rebuild.
 *
 * Not yet: grid renderings (`{format: 'binary'…}` specs answer null), values
 * that are arrays or records, and more than the fixed step of Euler.
 *
 * Classic script; no imports/exports.
 */
(function (Sienna) {
  'use strict';

  // Where the engine is, worked out from where this script came from.
  var me = typeof document !== 'undefined' ? document.currentScript : null;
  var HERE = me && me.src ? me.src.replace(/[^/]*$/, '') : 'src/';
  var ENGINE_SRC = HERE + '../vendor/simile-engine/simile-engine.js';
  var BUILD_SRC = HERE + 'engine-build.js';

  /** The run settings SimiLive reports for a model with none of its own. */
  var DEFAULTS = {
    intMethod: 'Euler', errLimit: '0', execTime: '100', phaseList: '0.1',
    displayInt: '1', resetTo: '0', timeUnit: 'unit',
  };

  var registered = {};   // fingerprint -> {name, wasm (base64, or bytes if made here)}
  var engineScript = null;
  var buildScript = null;
  var cannotBuild = null;  // why the page cannot make engines, once found out

  /**
   * A short fingerprint of a model's Simile Prolog, without its `source(…)`
   * line (which carries the date). cyrb53: 53 bits, as hex.
   */
  function fingerprint(prolog) {
    var str = String(prolog).replace(/^source\(.*\)\.\n/, '');
    var h1 = 0xdeadbeef, h2 = 0x41c6ce57;
    for (var i = 0; i < str.length; i++) {
      var ch = str.charCodeAt(i);
      h1 = Math.imul(h1 ^ ch, 2654435761);
      h2 = Math.imul(h2 ^ ch, 1597334677);
    }
    h1 = Math.imul(h1 ^ (h1 >>> 16), 2246822507) ^ Math.imul(h2 ^ (h2 >>> 13), 3266489909);
    h2 = Math.imul(h2 ^ (h2 >>> 16), 2246822507) ^ Math.imul(h1 ^ (h1 >>> 13), 3266489909);
    return (4294967296 * (2097151 & h2) + (h1 >>> 0)).toString(16);
  }

  /** The engine script, loaded once, on first use. */
  function loadEngine() {
    if (engineScript) return engineScript;
    engineScript = new Promise(function (resolve, reject) {
      if (window.SimileEngine) { resolve(window.SimileEngine); return; }
      var s = document.createElement('script');
      s.src = ENGINE_SRC;
      s.onload = function () { resolve(window.SimileEngine); };
      s.onerror = function () {
        engineScript = null;
        reject(new Error('the Simile engine could not be loaded from ' + ENGINE_SRC));
      };
      (document.head || document.documentElement).appendChild(s);
    });
    return engineScript;
  }

  /** The builder (src/engine-build.js), loaded once, on first use. */
  function loadBuilder() {
    if (buildScript) return buildScript;
    buildScript = new Promise(function (resolve, reject) {
      if (Sienna.EngineBuild) { resolve(Sienna.EngineBuild); return; }
      var s = document.createElement('script');
      s.src = BUILD_SRC;
      s.onload = function () { resolve(Sienna.EngineBuild); };
      s.onerror = function () {
        buildScript = null;
        reject(new Error('could not load ' + BUILD_SRC));
      };
      (document.head || document.documentElement).appendChild(s);
    });
    return buildScript;
  }

  function bytesOf(base64) {
    if (base64 instanceof Uint8Array) return base64;
    var bin = atob(base64);
    var out = new Uint8Array(bin.length);
    for (var i = 0; i < bin.length; i++) out[i] = bin.charCodeAt(i);
    return out;
  }

  /**
   * One model, loaded in an engine instance of its own (two models in one
   * instance collide: each brings its own copy of the support globals).
   */
  function Session(E, name) {
    this.E = E;
    this.name = name;
    this.describe = null;   // id -> component, once Described
    this._idOf = {};        // captpath -> id
  }

  Session.prototype = {
    _call: function (fn, ret, types, args) {
      return this.E.ccall(fn, ret, types, args);
    },

    _value: function (spec) {
      if (typeof spec !== 'string') return null;   // renderings: not yet
      return JSON.parse(this._call('sx_value', 'string', ['string'], [spec]));
    },

    _values: function (note) {
      var self = this;
      return note.map(function (spec) { return self._value(spec); });
    },

    _steps: function (step) {
      var self = this;
      String(step).trim().split(/\s+/).forEach(function (dt, i) {
        self._call('sx_setstep', null, ['number', 'number'], [i + 1, parseFloat(dt)]);
      });
    },

    _note: function (params) {
      return params.note ? JSON.parse(params.note) : [];
    },

    /** One request, as SimiLive would answer it: the reply's text. */
    act: function (act, params) {
      var self = this;
      return new Promise(function (resolve) { resolve(self._act(act, params || {})); });
    },

    _act: function (act, p) {
      switch (act) {
        case 'BuildShareLib':
          return 'Simile engine in the page: ' + this.name + '\n' + JSON.stringify(DEFAULTS);
        case 'CreateSocket':
          return 'Direct SIMILE Connection';
        case 'WaitSocket':
          return 'Local SIMILE';
        case 'Describe': {
          var text = this._call('sx_describe', 'string', [], []);
          this.describe = JSON.parse(text);
          var self = this;
          Object.keys(this.describe).forEach(function (id) {
            self._idOf[self.describe[id].captpath] = id;
          });
          return text;
        }
        case 'LoadSPF':
          return '-1';
        case 'Parameterize': {
          // The whole set: one not named goes back to the model's value.
          var data = JSON.parse(p.data || '{}');
          delete data.seqNo;
          var keep = {};
          var self2 = this;
          Object.keys(data).forEach(function (path) {
            var id = self2._idOf[path];
            var v = parseFloat(String(data[path]).replace(/^\s*NOW\s+/i, ''));
            if (id && isFinite(v)) {
              self2._call('sx_param', 'number', ['string', 'number'], [id, v]);
              keep[id] = true;
            }
          });
          Object.keys(this._set || {}).forEach(function (id) {
            if (!keep[id]) self2._call('sx_param_clear', null, ['string'], [id]);
          });
          this._set = keep;
          return '""';
        }
        case 'Reset': {
          this._steps(p.step);
          // A fresh seed for the random numbers on a full reset, as SimiLive's
          // (threaded) reset takes one from the clock.
          var exc = this._call('sx_reset', 'number', ['number', 'number', 'number'],
            [parseFloat(p.current) || 0, parseInt(p.depth, 10) || 0,
              Math.floor(Math.random() * 4294967296)]);
          if (exc) throw new Error('the model stopped as it was reset (exception ' + exc + ')');
          return JSON.stringify(this._values(this._note(p)));
        }
        case 'Query':
          return JSON.stringify(this._values(this._note(p)));
        case 'ExecuteMulti': {
          this._steps(p.step);
          var note = this._note(p);
          var start = parseFloat(p.current), end = start + parseFloat(p.runlength);
          var log = parseFloat(p.log) > 0 ? parseFloat(p.log) : end - start;
          var rows = [];
          var ok = 1;
          for (var k = 1, t = start; t < end - 1e-9; k++) {
            // Count log points from the start, as SimiLive's loop adds up
            // the same intervals, rather than accumulating rounding.
            var next = Math.min(end, start + k * log);
            var exc2 = this._call('sx_execute', 'number', ['number', 'number'], [t, next]);
            if (exc2) next = this._call('sx_stopped_at', 'number', [], []);
            var row = this._values(note);
            row.push(next);
            rows.push(row);
            t = next;
            if (exc2) { ok = 0; break; }
          }
          rows.push(ok);
          return JSON.stringify(rows);
        }
        case 'Exit':
          this.exit();
          return '';
        default:
          throw new Error('the engine in the page does not do ' + act);
      }
    },

    exit: function () {
      if (!this.E) return;
      this._call('sx_exit', null, [], []);
      this.E = null;
    },
  };

  Sienna.LocalEngine = {
    fingerprint: fingerprint,

    /** A model's compiled engine, from its `<name>.engine.js`. */
    register: function (name, spec) {
      if (!spec || !spec.prolog || !spec.wasm) return;
      registered[spec.prolog] = { name: name, wasm: spec.wasm };
    },

    /** The engine made from exactly this Prolog, or null. */
    find: function (prolog) {
      return registered[fingerprint(prolog)] || null;
    },

    /**
     * Make the engine for this Prolog in the page, and keep it as if it had
     * come from an engine file. `say(text)` hears each stage.
     * @returns {Promise} of the entry, as `find` would give it
     */
    build: function (name, prolog, say) {
      if (cannotBuild) return Promise.reject(cannotBuild);
      var print = fingerprint(prolog);
      if (registered[print]) return Promise.resolve(registered[print]);
      return loadBuilder().then(function (B) {
        return B.build(prolog, say);
      }).then(function (wasm) {
        registered[print] = { name: name, wasm: wasm };
        return registered[print];
      }, function (err) {
        // The tools missing is for good; a model that fails is that model's.
        if (/could not load/.test(err.message)) cannotBuild = err;
        throw err;
      });
    },

    /** Start an engine for one model: resolves to a Session. */
    open: function (entry) {
      return loadEngine().then(function (factory) {
        return factory();
      }).then(function (E) {
        var file = '/model.wasm';
        E.FS.writeFile(file, bytesOf(entry.wasm));
        var problem = E.ccall('sx_load', 'string', ['string'], [file]);
        if (problem) throw new Error('the engine could not load the model: ' + problem);
        return new Session(E, entry.name);
      });
    },
  };
})(window.Sienna = window.Sienna || {});
