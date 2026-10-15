/**
 * `Simile` — widgets embedded in an ordinary web page.
 *
 * The app's widgets are self-contained, so a page of text can carry a model's
 * diagram, plots of it and its other displays among its paragraphs, with the
 * model running as the page opens. Not another modelling environment: a way of
 * making a page about a dynamic system that a reader can change and re-run.
 *
 * A page needs three things besides the scripts:
 *
 *   1. **The model**, as a script: `Simile.model('predator-prey', {…}, run)`
 *      — what File ▸ Export model as script writes (`exportScriptFile` in
 *      src/main.js).
 *      A page opened from disk cannot fetch a file beside it, but it can load
 *      one with `<script>`, and a call rather than an assignment lets several
 *      models share a page. `run` is how to run it (`runLength`, `timeStep`,
 *      `logEach`, `updateEach`), over the model's own defaults.
 *   2. **Where the widgets go**: an element per widget, saying which and of
 *      what —
 *
 *        <div data-simile="diagram" data-model="predator-prey"></div>
 *        <div data-simile="plotter" data-model="predator-prey" data-show="rabbits"></div>
 *        <div data-simile="controls" data-model="predator-prey"></div>
 *
 *      `data-show` names the variables a plot starts with (space separated);
 *      `data-options` takes any other widget options as JSON. `controls` is
 *      this file's own: the run's status, and buttons to run it again and to
 *      put the model back as the page gave it.
 *   3. **`Simile.page()`** once the elements exist.
 *
 * and the scripts, which `embed.js` (at the top of this repository) loads
 * from wherever it was itself loaded: one `<script>` tag. A page that lists
 * the scripts itself instead passes `Simile.page({ base })`, `base` being the
 * way from the page to the app's folder (`'../../'`), which is where the widget
 * manifest's script URLs start from.
 *
 * What a reader changes is NOT kept: `SIENNA_EPHEMERAL` is set, so each
 * visit starts from the model as the page gave it. An edit to the diagram runs
 * the model again once the editing pauses.
 *
 * One model RUNS per page: there is one simulation session
 * (`Sienna.Simulation`), so with several models on a page the first is the one
 * run, and the others are diagrams only.
 *
 * Classic script; no imports/exports.
 */
(function (Sienna, $) {
  'use strict';

  var models = {};   // name -> { model, run }
  var order = [];    // the order the page declared them, so "the first" means something
  var RERUN_AFTER = 1200;   // ms of quiet after an edit before running again

  function pathOf(name) { return 'models/' + name; }

  function copy(obj) { return JSON.parse(JSON.stringify(obj)); }

  /** Put a model into the store as the page gave it, in the current format. */
  function fresh(name) {
    var m = copy(models[name].model);
    m.id = name;
    if (Sienna.Diagram && Sienna.Diagram.migrate) Sienna.Diagram.migrate(m);
    Sienna.userData.set(pathOf(name), m);
  }

  /** A widget's options from its element's `data-show` and `data-options`. */
  function optionsFrom($el) {
    var opts = {};
    var json = $el.attr('data-options');
    if (json) {
      try {
        opts = JSON.parse(json);
      } catch (e) {
        if (window.console) console.error('data-options is not JSON:', json);
      }
    }
    var show = $el.attr('data-show');
    if (show) opts.variables = show.trim().split(/\s+/);
    return opts;
  }

  // ---- running ------------------------------------------------------------

  var running = null;   // the name of the model this page runs

  /** Load the model and run it, as the page does on opening. */
  function loadAndRun(name) {
    var sim = Sienna.Simulation;
    return sim.loadOwn(pathOf(name)).then(function () {
      sim.start();
    }, function () { /* reported through the status line */ });
  }

  /** Run it again from the start, model unchanged (or reloaded if edited). */
  function runAgain() {
    var sim = Sienna.Simulation;
    if (!sim.base || sim.status === 'loading') return;
    sim.stop();
    if (sim.isStale()) { sim.start(); return; }   // ▶ reloads an edited model
    sim.reset().then(function () { sim.start(); }, function () { /* reported */ });
  }

  /** Put the model back as the page gave it, and run that. */
  function resetModel(name) {
    var sim = Sienna.Simulation;
    if (sim.status === 'loading') return;
    sim.stop();
    if (sim.parameterValues && Object.keys(sim.parameterValues(pathOf(name))).length) {
      // The sliders go back too — without running twice: clearing them
      // re-runs the model only if it is the one loaded and unedited.
      delete sim._overrides[pathOf(name)];
      sim._emit({ type: 'parameters', path: pathOf(name) });
    }
    fresh(name);
    if (sim.base) runAgain();
    else loadAndRun(name);
  }

  /**
   * Run again once the reader stops editing. Only an edit the engine would see
   * counts (`isStale`): moving a symbol about changes nothing it runs.
   */
  function rerunOnEdit(name) {
    var timer = null;
    Sienna.userData.subscribe(pathOf(name), function () {
      window.clearTimeout(timer);
      timer = window.setTimeout(function () {
        var sim = Sienna.Simulation;
        if (sim.status !== 'ready' || !sim.isStale()) return;
        sim.start();
      }, RERUN_AFTER);
    });
  }

  // ---- the controls ---------------------------------------------------------

  var STATUS_TEXT = {
    idle: 'Not loaded',
    loading: '',
    ready: 'Ready',
    running: 'Running…',
    error: 'Could not run the model',
  };

  function buildControls($el, name) {
    $el.addClass('slx-page-controls');
    var $again = $('<button type="button">').text('Run again')
      .attr('title', 'Run the model again from the start').appendTo($el);
    var $reset = $('<button type="button">').text('Reset model')
      .attr('title', 'Undo every change to the model and run it as this page gave it').appendTo($el);
    var $status = $('<span class="slx-page-status">').appendTo($el);

    $again.on('click', runAgain);
    $reset.on('click', function () { resetModel(name); });

    var sim = Sienna.Simulation;
    function show() {
      var base = sim.status === 'loading' ? sim.message : STATUS_TEXT[sim.status] || sim.status;
      var msg = sim.status !== 'loading' && sim.message ? ': ' + sim.message : '';
      if (sim.status === 'ready' && !sim.message && sim.base) {
        base = 'Ran to t = ' + Number(sim.settings.current) + ' ' + (sim.unitName || '');
      }
      $status.text(base + msg).toggleClass('slx-page-error', sim.status === 'error');
      $again.prop('disabled', !sim.base || sim.status === 'loading');
    }
    sim.subscribe(function (e) {
      if (e.type === 'status' || e.type === 'settings') show();
    });
    show();
  }

  // ---- the page ---------------------------------------------------------------

  window.Simile = {
    /**
     * Declare a model this page shows. Call it before `page()`, typically from
     * the model's own script file.
     * @param {string} name — what the page's elements call it (`data-model`)
     * @param {object} model — the model, as the app stores it
     * @param {object} [run] — run settings over the model's defaults
     */
    model: function (name, model, run) {
      if (!/^[A-Za-z0-9_-]+$/.test(name)) throw new Error('A model name is letters, digits, - and _: ' + name);
      if (!models[name]) order.push(name);
      models[name] = { model: copy(model), run: run || {} };
    },

    /**
     * A model compiled for the engine in the page — what its `<name>.engine.js`
     * calls (tools/engine/build-model.sh). The model then runs here, in
     * milliseconds, for as long as it is the model the engine was made from;
     * an edited one runs on SimiLive.
     * @param {string} name
     * @param {{prolog: string, wasm: string}} spec
     */
    engine: function (name, spec) {
      Sienna.LocalEngine.register(name, spec);
    },

    /**
     * Fill the page: put every declared model in the store, make every
     * `[data-simile]` element its widget, and run the first model.
     * @param {{ base?: string }} [opts]
     * @returns {Promise} settled once the widgets exist and the run has begun
     */
    page: function (opts) {
      opts = opts || {};
      if (opts.base != null) Sienna.widgetRegistry.setBase(opts.base);
      order.forEach(fresh);
      running = order[0] || null;

      var made = [];
      $('[data-simile]').each(function () {
        var $el = $(this);
        var kind = $el.attr('data-simile');
        var name = $el.attr('data-model') || running;
        if (!models[name]) {
          $el.text('No model called "' + name + '" on this page.');
          return;
        }
        if (kind === 'controls') { buildControls($el, name); return; }
        // A diagram on a page is there to be read: the view commands only,
        // unless the page asks for more (data-options='{"tools":"all"}').
        var o = $.extend(kind === 'diagram' ? { tools: 'view' } : {},
          optionsFrom($el), { ref: pathOf(name) });
        made.push(Sienna.widgetRegistry.embed($el, kind, o).catch(function (err) {
          $el.text(err.message);
        }));
      });

      if (!running) return Promise.all(made);
      Sienna.Simulation.presetSettings(pathOf(running), models[running].run);
      rerunOnEdit(running);
      // The widgets first, so every plot has said what it wants before the
      // first values come back.
      return Promise.all(made).then(function () { return loadAndRun(running); });
    },

    /** For the console: the store path a page's model lives at. */
    pathOf: pathOf,
  };
})(window.Sienna, window.jQuery);
