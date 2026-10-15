/**
 * `Sienna.ModelCompiler` — a model compiled in the page: its Simile Prolog
 * to C++ by Simile's own generator, running in SWI-Prolog, and the C++ to a
 * WebAssembly side module (the compiled model, which runs linked to Simile's
 * run-time library) by clang, also running here. What
 * tools/engine/build-model.sh does with desktop Simile and emsdk, with no
 * server and no install. Loaded by `src/engine-local.js` the first time a
 * model has no `<name>.compiled.js`; the scripts it uses in turn are loaded on
 * first use too, as they are large (clang is 30 MB):
 *
 *   vendor/swipl/swipl-bundle.js                SWI-Prolog in WebAssembly
 *   vendor/simile-generator/simile-generator.js Simile's Prolog, headless
 *   vendor/clang/clang-data.js, clang.js        clang and wasm-ld
 *   vendor/simile-runtime/model-kit.js          the headers, support.cpp built
 *
 * all made by tools/engine/build-browser-tools.sh (README, steps 3 and 4).
 *
 * The work is done in a WORKER, so the page goes on drawing and answering
 * while a model compiles. A page opened from file:// may not start a worker
 * from a file, nor a worker load one, so the page loads the tools with
 * <script> as before, and hands the worker their text and data: each tool
 * script defines ONE function (`SIMILE_TOOL_SWIPL`, `SIMILE_TOOL_CLANG`),
 * whose text is sent, and the worker itself is made from text (`core` and
 * `workerMain` below, which use nothing from outside themselves). Should a
 * worker not start, the same `core` runs in the page, as it did before.
 *
 * Each generation has a Prolog of its own. One Prolog could generate many
 * models, but Simile then numbers each model's nodes after the last's, which
 * reorders the C++ (tools/engine/README.md); a fresh one writes exactly what
 * desktop Simile writes.
 *
 * Classic script; no imports/exports.
 */
(function (Sienna) {
  'use strict';

  var me = document.currentScript;
  var VENDOR = (me && me.src ? me.src.replace(/[^/]*$/, '') : 'src/') + '../vendor/';

  var scripts = {};   // src -> Promise

  function load(src) {
    if (scripts[src]) return scripts[src];
    scripts[src] = new Promise(function (resolve, reject) {
      var s = document.createElement('script');
      s.src = VENDOR + src;
      s.onload = function () { resolve(); };
      s.onerror = function () {
        delete scripts[src];
        reject(new Error('could not load ' + VENDOR + src
          + ' (made by tools/engine/build-browser-tools.sh)'));
      };
      (document.head || document.documentElement).appendChild(s);
    });
    return scripts[src];
  }

  function bytes(base64) {
    if (Uint8Array.fromBase64) return Uint8Array.fromBase64(base64);
    var bin = atob(base64);
    var out = new Uint8Array(bin.length);
    for (var i = 0; i < bin.length; i++) out[i] = bin.charCodeAt(i);
    return out;
  }

  /** Let the page draw (a status line) before the next long stretch. */
  function breathe() {
    return new Promise(function (resolve) { setTimeout(resolve, 20); });
  }

  /**
   * The work: generating and compiling, given the tools
   * `{SWIPL, generatorFiles, clang, kitTree}`. Self-contained, as its text is
   * what a worker runs.
   */
  function core() {
    'use strict';

    // emcc's flags for a side module (tools/engine/clang/flags.json).
    var COMPILE = ['-target', 'wasm32-unknown-emscripten', '-fignore-exceptions', '-fvisibility=default',
      '-mllvm', '-combiner-global-alias-analysis=false', '-mllvm', '-enable-emscripten-sjlj',
      '-mllvm', '-disable-lsr', '--sysroot=/sysroot', '-Xclang', '-iwithsysroot/include/compat',
      '-O2', '-fPIC', '-I/stubs', '-I/simile/Run', '-c'];
    var LINK = ['-Bdynamic', '--strip-debug', '--export=__wasm_call_ctors',
      '--unresolved-symbols=import-dynamic', '-shared', '--no-stack-first'];

    /** The C++ Simile writes for this Prolog: a Promise of its text. */
    function generate(tools, prolog) {
      var said = [];
      return tools.SWIPL({
        arguments: ['-q'],
        print: function (s) { said.push(s); },
        printErr: function (s) { said.push(s); },
      }).then(function (swipl) {
        var FS = swipl.FS;
        var files = tools.generatorFiles;
        Object.keys(files).forEach(function (p) {
          FS.mkdirTree(p.replace(/\/[^/]*$/, ''));
          FS.writeFile(p, files[p]);
        });
        FS.writeFile('/model.pl', prolog);
        var r = swipl.prolog.query("consult('/gen/headless.pl'), assertz(hl_setting(structdb, prolog)), "
          + "catch(generate('/simile', '/model.pl', '/model.cpp'), E, (print_message(error, E), fail))").once();
        var cpp = null;
        try { cpp = FS.readFile('/model.cpp', { encoding: 'utf8' }); } catch (e) { /* none */ }
        if (!r || !r.success || !cpp) {
          var why = said.filter(function (s) { return !/^headless: no answer/.test(s); }).join('\n');
          console.error('Simile\'s generator said:\n' + said.join('\n'));
          throw new Error('Simile could not make C++ of this model' + (why ? ': ' + why.split('\n')[0] : ''));
        }
        return cpp;
      });
    }

    /** Copy the directories (not the files) so each compile starts clean. */
    function copyTree(t) {
      var out = {};
      Object.keys(t).forEach(function (k) {
        out[k] = t[k] instanceof Uint8Array || typeof t[k] === 'string' ? t[k] : copyTree(t[k]);
      });
      return out;
    }

    /** The compiled model: a Promise of its bytes. */
    function compile(tools, cpp) {
      var said = [];
      var opts = {
        stdout: function () {},
        stderr: function (b) { if (b) said.push(new TextDecoder().decode(b)); },
      };
      var C = tools.clang;
      var tree = copyTree(tools.kitTree);
      // The generator names the function library by where it ran (/simile).
      tree['model.cpp'] = cpp;
      return Promise.resolve().then(function () {
        return C.runClang(['clang++'].concat(COMPILE, ['/model.cpp', '-o', '/model.o']), tree, opts);
      }).then(function (files) {
        return C.runLLVM(['wasm-ld', '-o', '/model.wasm'].concat(LINK, ['/model.o', '/support.o']), files, opts);
      }).then(function (files) {
        return files['model.wasm'];
      }, function () {
        console.error('clang said:\n' + said.join(''));
        var first = said.join('').split('\n').filter(function (l) { return /error/.test(l); })[0];
        throw new Error('the model\'s C++ would not compile' + (first ? ': ' + first : ''));
      });
    }

    /** Wait for clang.js, which finishes setting itself up asynchronously. */
    function clangIn(scope) {
      return new Promise(function (resolve) {
        (function wait() { if (scope.YoWASPClang) resolve(scope.YoWASPClang); else setTimeout(wait, 10); })();
      });
    }

    return { generate: generate, compile: compile, clangIn: clangIn };
  }

  /**
   * The worker: takes the tools as the page sends them, then requests
   * `{id, op: 'generate'|'compile', …}`, answering `{id, result}` or
   * `{id, error}`. Self-contained, as its text is the worker.
   */
  function workerMain(scope, core) {
    'use strict';
    var K = core();
    var tools = {};
    var clang = null;   // Promise of YoWASPClang, once sent

    // A tool's text, run here. As a script of the worker's own making: one
    // the page made (a blob: URL of origin null, from file://) it may not load.
    function run(text) {
      var url = URL.createObjectURL(new Blob([text], { type: 'text/javascript' }));
      scope.importScripts(url);
      URL.revokeObjectURL(url);
    }

    function answer(id, work) {
      Promise.resolve().then(work).then(function (result) {
        scope.postMessage({ id: id, result: result }, result instanceof Uint8Array ? [result.buffer] : []);
      }, function (err) {
        scope.postMessage({ id: id, error: String((err && err.message) || err) });
      });
    }

    scope.onmessage = function (e) {
      var m = e.data;
      if (m.op === 'generator') {
        run(m.swipl);
        tools.SWIPL = scope.SIMILE_TOOL_SWIPL();
        tools.generatorFiles = m.files;
      } else if (m.op === 'clang') {
        scope.YOWASP_DATA = m.data;
        scope.YOWASP_SIZES = m.sizes;
        tools.kitTree = m.kit;
        run(m.clang);
        scope.SIMILE_TOOL_CLANG(scope);
        clang = K.clangIn(scope);
      } else if (m.op === 'generate') {
        answer(m.id, function () { return K.generate(tools, m.prolog); });
      } else if (m.op === 'compile') {
        answer(m.id, function () {
          return clang.then(function (C) { tools.clang = C; return K.compile(tools, m.cpp); });
        });
      }
    };
  }

  // ---- the tools, loaded into the page --------------------------------------

  var generatorFiles = null;   // path -> bytes, decoded once
  var kitTree = null;          // the file tree clang starts from, made once

  function generatorReady() {
    return Promise.all([load('swipl/swipl-bundle.js'), load('simile-generator/simile-generator.js')])
      .then(function () {
        if (!generatorFiles) {
          generatorFiles = {};
          var packed = window.SIMILE_GENERATOR.files;
          Object.keys(packed).forEach(function (p) { generatorFiles[p] = bytes(packed[p]); });
          delete window.SIMILE_GENERATOR;
        }
      });
  }

  function clangReady() {
    window.YOWASP_DATA = window.YOWASP_DATA || {};
    return load('clang/clang-data.js').then(function () {
      return Promise.all([load('clang/clang.js'), load('simile-runtime/model-kit.js')]);
    }).then(function () {
      if (!kitTree) {
        kitTree = {};
        var kit = window.SIMILE_MODEL_KIT;
        Object.keys(kit.files).forEach(function (p) { put(kitTree, p, bytes(kit.files[p])); });
        put(kitTree, 'support.o', bytes(kit.supportO));
        delete window.SIMILE_MODEL_KIT;
      }
    });
  }

  function put(tree, p, data) {
    var parts = p.split('/');
    var t = tree;
    for (var i = 0; i < parts.length - 1; i++) t = t[parts[i]] || (t[parts[i]] = {});
    t[parts[parts.length - 1]] = data;
  }

  // ---- in the page, when there is no worker -------------------------------

  var K = core();
  var inPage = {};   // the tools, started in the page

  function hereGenerate(prolog) {
    if (!inPage.SWIPL) inPage.SWIPL = window.SIMILE_TOOL_SWIPL();
    inPage.generatorFiles = generatorFiles;
    return breathe().then(function () { return K.generate(inPage, prolog); });
  }

  function hereCompile(cpp) {
    if (!inPage.clangStarted) { window.SIMILE_TOOL_CLANG(window); inPage.clangStarted = K.clangIn(window); }
    inPage.kitTree = kitTree;
    return inPage.clangStarted.then(function (C) {
      inPage.clang = C;
      return breathe();
    }).then(function () { return K.compile(inPage, cpp); });
  }

  // ---- the worker -------------------------------------------------------------

  var pool = null;     // {worker, next, pending, sent, answered}; false: none to be had
  /** A tool's script for the worker: `self.<name> = <that function's text>`. */
  function textOf(name) {
    return 'self.' + name + ' = ' + window[name].toString() + ';\n';
  }

  function startWorker() {
    if (pool !== null) return pool;
    try {
      var url = URL.createObjectURL(new Blob(['(' + workerMain.toString() + ')(self, ' + core.toString() + ');\n'],
        { type: 'text/javascript' }));
      pool = { worker: new Worker(url), next: 1, pending: {}, sent: {}, answered: false };
    } catch (e) {
      return (pool = false);
    }
    var mine = pool;
    mine.worker.onmessage = function (e) {
      var p = mine.pending[e.data.id];
      if (!p) return;
      delete mine.pending[e.data.id];
      mine.answered = true;
      if (e.data.error) p.reject(new Error(e.data.error));
      else p.resolve(e.data.result);
    };
    mine.worker.onerror = function (e) {
      // A worker that never answered is one this page cannot have: work in
      // the page from now on. One that did has died (out of memory, say):
      // the next request starts another.
      e.preventDefault();
      mine.worker.terminate();
      pool = mine.answered ? null : false;
      var pending = mine.pending;
      mine.pending = {};
      Object.keys(pending).forEach(function (id) {
        var p = pending[id];
        if (pool === false) p.here().then(p.resolve, p.reject);
        else p.reject(new Error('the compiler in the page stopped: ' + (e.message || 'no reason given')));
      });
    };
    return pool;
  }

  /** One request to the worker, or, with none, `here()` in the page. */
  function ask(op, payload, here) {
    var w = startWorker();
    if (!w) return here();
    if (op === 'generate' && !w.sent.generator) {
      w.worker.postMessage({ op: 'generator', swipl: textOf('SIMILE_TOOL_SWIPL'), files: generatorFiles });
      w.sent.generator = true;
    }
    if (op === 'compile' && !w.sent.clang) {
      w.worker.postMessage({ op: 'clang', clang: textOf('SIMILE_TOOL_CLANG'),
        data: window.YOWASP_DATA, sizes: window.YOWASP_SIZES, kit: kitTree });
      w.sent.clang = true;
    }
    return new Promise(function (resolve, reject) {
      var id = w.next++;
      w.pending[id] = { resolve: resolve, reject: reject, here: here };
      payload.op = op;
      payload.id = id;
      w.worker.postMessage(payload);
    });
  }

  /** The C++ Simile writes for this Prolog: a Promise of its text. */
  function generate(prolog) {
    return generatorReady().then(function () {
      return ask('generate', { prolog: prolog }, function () { return hereGenerate(prolog); });
    });
  }

  /** The compiled model: a Promise of its bytes. */
  function compile(cpp) {
    return clangReady().then(function () {
      return ask('compile', { cpp: cpp }, function () { return hereCompile(cpp); });
    });
  }

  Sienna.ModelCompiler = {
    generate: generate,
    compile: compile,

    /** Is the work done in a worker? (null: not known until the first build) */
    inWorker: function () { return pool === null ? null : !!pool; },

    /**
     * Prolog -> compiled model. `say(text)` is told each stage, for a status line.
     * @returns {Promise<Uint8Array>}
     */
    build: function (prolog, say) {
      say = say || function () {};
      say('Making the model\'s C++ in the page…');
      // The compiler loads while the C++ is made, the worker being busy and
      // the page not (in the page, it waits its turn, as before).
      if (pool !== false) clangReady().catch(function () { /* compile says */ });
      return generate(prolog).then(function (cpp) {
        say(window.SIMILE_TOOL_CLANG ? 'Compiling the model in the page…'
          : 'Compiling the model in the page (loading the compiler first)…');
        return compile(cpp);
      });
    },
  };
})(window.Sienna = window.Sienna || {});
