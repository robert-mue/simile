/**
 * The ONE script a page with simile's widgets embedded in it needs.
 *
 *     <script src="https://robert-mue.github.io/simile/embed.js"></script>
 *     …
 *     <div data-simile="diagram" data-model="predator-prey"></div>
 *     …
 *     <script src="predator-prey.js"></script>
 *     <script>Simile.page();</script>
 *
 * It loads everything else — the shell, simile's model and simulation code,
 * their stylesheets — from wherever it was itself loaded from, so a page can
 * use the public copy or a local one with no other change. It also makes the
 * page keep nothing (a reader's edits last as long as the tab), and tells the
 * widget registry where widget scripts live.
 *
 * Loading is asynchronous, so until it is done `Simile` is a stand-in that
 * remembers calls to `Simile.model`, `Simile.compiledModel` and `Simile.page` and
 * makes them, in order, once the real one (src/page.js) is there. A page
 * therefore needs no knowledge of when the scripts arrive.
 *
 * Classic script; no imports/exports.
 */
(function () {
  'use strict';

  var me = document.currentScript;
  var base = me && me.src ? me.src.replace(/[^/]*$/, '') : '';

  // Before the shell reads storage: keep nothing.
  window.SIENNA_EPHEMERAL = true;
  // From the first paint, the page's look is its own: the shell's styles keep
  // to its elements (sienna/src/styles.css).
  document.documentElement.classList.add('slx-embedding');

  var STYLES = ['sienna/src/styles.css', 'src/styles.css'];

  // In dependency order, as index.html lists them — less the workspace,
  // panels, menus and app, which an embedded widget has no use for.
  var SCRIPTS = [
    'sienna/vendor/jquery.min.js',
    'sienna/vendor/jquery-ui.js',
    'vendor/peggy.min.js',
    'sienna/src/core/namespace.js',
    'sienna/src/core/persistence.js',
    'sienna/src/core/widget-registry.js',
    'sienna/src/core/user-data.js',
    'sienna/src/core/actions.js',
    'sienna/src/core/history.js',
    'sienna/src/core/widget-base.js',
    'src/schema/simile-v1.js',
    'src/diagram.js',
    'src/sketch.js',
    'src/dialog.js',
    'src/grammar.js',
    'src/predicates.js',
    'src/equation-grammar.js',
    'src/equation.js',
    'src/equation-check.js',
    'src/export-simile.js',
    'src/engine-local.js',
    'src/simulation.js',
    'src/widgets/index.js',
    'src/page.js',
  ];

  // Stylesheets first in the head, so a page's own styles, after this script,
  // win over them.
  var head = document.head || document.getElementsByTagName('head')[0];
  STYLES.forEach(function (href) {
    var link = document.createElement('link');
    link.rel = 'stylesheet';
    link.href = base + href;
    if (me && me.parentNode === head) head.insertBefore(link, me);
    else head.appendChild(link);
  });

  // The stand-in.
  var calls = [];
  var waiting = [];
  window.Simile = {
    model: function () { calls.push(['model', arguments]); },
    compiledModel: function () { calls.push(['compiledModel', arguments]); },
    page: function () {
      var args = arguments;
      return new Promise(function (resolve, reject) {
        calls.push(['page', args, resolve, reject]);
      });
    },
    /** Resolves once everything is loaded — for a page that wants to know. */
    ready: function () {
      return new Promise(function (resolve) { waiting.push(resolve); });
    },
  };

  function done() {
    var real = window.Simile;   // src/page.js replaced the stand-in
    window.Sienna.widgetRegistry.setBase(base);
    real.ready = function () { return Promise.resolve(); };
    calls.forEach(function (c) {
      var r = real[c[0]].apply(real, c[1]);
      if (c[2]) Promise.resolve(r).then(c[2], c[3]);
    });
    waiting.forEach(function (w) { w(); });
  }

  function failed(src) {
    var msg = 'simile could not load ' + src + ' (from ' + base + ')';
    if (window.console) console.error(msg);
    document.querySelectorAll('[data-simile]').forEach(function (el) { el.textContent = msg; });
  }

  // `async = false` on an inserted script keeps them in the order inserted —
  // each still loads in parallel, but runs only after the one before it.
  SCRIPTS.forEach(function (src, i) {
    var s = document.createElement('script');
    s.src = base + src;
    s.async = false;
    s.onerror = function () { failed(src); };
    if (i === SCRIPTS.length - 1) s.onload = done;
    head.appendChild(s);
  });
})();
