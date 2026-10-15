/**
 * `Sienna.EngineBuild` — a model's engine made in the page: its Simile
 * Prolog to C++ by Simile's own generator, running in SWI-Prolog, and the C++
 * to the engine's WebAssembly side module by clang, also running here. What
 * tools/engine/build-model.sh does with desktop Simile and emsdk, with no
 * server and no install. Loaded by `src/engine-local.js` the first time a
 * model has no `<name>.engine.js`; the scripts it uses in turn are loaded on
 * first use too, as they are large (clang is 30 MB):
 *
 *   vendor/swipl/swipl-bundle.js                SWI-Prolog in WebAssembly
 *   vendor/simile-generator/simile-generator.js Simile's Prolog, headless
 *   vendor/clang/clang-data.js, clang.js        clang and wasm-ld
 *   vendor/simile-engine/model-kit.js           the headers, support.cpp built
 *
 * all made by tools/engine/build-browser-tools.sh (README, steps 3 and 4).
 *
 * Each generation has a Prolog of its own. One Prolog could generate many
 * models, but Simile then numbers each model's nodes after the last's, which
 * reorders the C++ (tools/engine/README.md); a fresh one writes exactly what
 * desktop Simile writes.
 *
 * Both run on the page's thread, so the page stops for each (about a second
 * each, once loaded); `build` lets it repaint between them.
 *
 * Classic script; no imports/exports.
 */
(function (Sienna) {
  'use strict';

  var me = document.currentScript;
  var VENDOR = (me && me.src ? me.src.replace(/[^/]*$/, '') : 'src/') + '../vendor/';

  // emcc's flags for a side module (tools/engine/clang/flags.json).
  var COMPILE = ['-target', 'wasm32-unknown-emscripten', '-fignore-exceptions', '-fvisibility=default',
    '-mllvm', '-combiner-global-alias-analysis=false', '-mllvm', '-enable-emscripten-sjlj',
    '-mllvm', '-disable-lsr', '--sysroot=/sysroot', '-Xclang', '-iwithsysroot/include/compat',
    '-O2', '-fPIC', '-I/stubs', '-I/simile/Run', '-c'];
  var LINK = ['-Bdynamic', '--strip-debug', '--export=__wasm_call_ctors',
    '--unresolved-symbols=import-dynamic', '-shared', '--no-stack-first'];

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

  // ---- generating: Simile Prolog -> C++ -----------------------------------

  var generatorFiles = null;   // path -> bytes, decoded once

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

  /** The C++ Simile writes for this Prolog: a Promise of its text. */
  function generate(prolog) {
    var said = [];
    return generatorReady().then(function () {
      return window.SWIPL({
        arguments: ['-q'],
        print: function (s) { said.push(s); },
        printErr: function (s) { said.push(s); },
      });
    }).then(function (swipl) {
      var FS = swipl.FS;
      Object.keys(generatorFiles).forEach(function (p) {
        FS.mkdirTree(p.replace(/\/[^/]*$/, ''));
        FS.writeFile(p, generatorFiles[p]);
      });
      FS.writeFile('/model.pl', prolog);
      var r = swipl.prolog.query("consult('/gen/headless.pl'), assertz(hl_setting(structdb, prolog)), "
        + "catch(generate('/simile', '/model.pl', '/model.cpp'), E, (print_message(error, E), fail))").once();
      var cpp = null;
      try { cpp = FS.readFile('/model.cpp', { encoding: 'utf8' }); } catch (e) { /* none */ }
      if (!r || !r.success || !cpp) {
        var why = said.filter(function (s) { return !/^headless: no answer/.test(s); }).join('\n');
        if (window.console) console.error('Simile\'s generator said:\n' + said.join('\n'));
        throw new Error('Simile could not make C++ of this model' + (why ? ': ' + why.split('\n')[0] : ''));
      }
      return cpp;
    });
  }

  // ---- compiling: C++ -> the engine's side module -------------------------

  var kitTree = null;   // the file tree clang starts from, made once

  function clangReady() {
    window.YOWASP_DATA = window.YOWASP_DATA || {};
    return load('clang/clang-data.js').then(function () {
      return Promise.all([load('clang/clang.js'), load('simile-engine/model-kit.js')]);
    }).then(function () {
      // clang.js finishes setting itself up asynchronously.
      return new Promise(function (resolve) {
        (function wait() { if (window.YoWASPClang) resolve(); else setTimeout(wait, 10); })();
      });
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

  /** Copy the directories (not the files) so each compile starts clean. */
  function copyTree(t) {
    var out = {};
    Object.keys(t).forEach(function (k) {
      out[k] = t[k] instanceof Uint8Array || typeof t[k] === 'string' ? t[k] : copyTree(t[k]);
    });
    return out;
  }

  /** The model's side module: a Promise of its bytes. */
  function compile(cpp) {
    var said = [];
    var opts = {
      stdout: function () {},
      stderr: function (b) { if (b) said.push(new TextDecoder().decode(b)); },
    };
    return clangReady().then(function () {
      var tree = copyTree(kitTree);
      // The generator names the function library by where it ran (/simile).
      tree['model.cpp'] = cpp;
      var C = window.YoWASPClang;
      return Promise.resolve(C.runClang(['clang++'].concat(COMPILE, ['/model.cpp', '-o', '/model.o']), tree, opts))
        .then(function (files) {
          return C.runLLVM(['wasm-ld', '-o', '/model.wasm'].concat(LINK, ['/model.o', '/support.o']), files, opts);
        });
    }).then(function (files) {
      return files['model.wasm'];
    }, function (err) {
      if (window.console) console.error('clang said:\n' + said.join(''));
      var first = said.join('').split('\n').filter(function (l) { return /error/.test(l); })[0];
      throw new Error('the model\'s C++ would not compile' + (first ? ': ' + first : ''));
    });
  }

  Sienna.EngineBuild = {
    generate: generate,
    compile: compile,

    /**
     * Prolog -> side module. `say(text)` is told each stage, for a status line.
     * @returns {Promise<Uint8Array>}
     */
    build: function (prolog, say) {
      say = say || function () {};
      say('Making the model\'s C++ in the page…');
      return breathe().then(function () {
        return generate(prolog);
      }).then(function (cpp) {
        say(window.YoWASPClang ? 'Compiling the model in the page…'
          : 'Compiling the model in the page (loading the compiler first)…');
        return breathe().then(function () { return compile(cpp); });
      });
    },
  };
})(window.Sienna = window.Sienna || {});
