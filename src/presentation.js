/**
 * `Sienna.presentation` — a model's DEFAULT DISPLAYS and run settings: how
 * its modeller recommends looking at it (Robert, 2026-11-15). Held in the
 * model spec, beside `metadata`, so it goes wherever the model goes — File ▸
 * Save, the model gallery, the Sample models panel:
 *
 *   "presentation": {
 *     "run": { "runLength": 50, "logEach": 0.5, "timeStep": "0.1" },
 *     "displays": [
 *       { "widget": "plotter", "variables": ["node1", "node2"] },
 *       { "widget": "sliders" }
 *     ]
 *   }
 *
 * Variables are named by element id, so a variable renamed stays on its plot.
 * Displays are plots and the Sliders panel: what needs no more than a list
 * of variables to say what it shows.
 *
 * When a model is OPENED (sienna's `documents` `opened`) and has default
 * displays, and none of its displays is open, they are opened in its
 * Simulation panel, the run settings are taken unless this user has set
 * their own, and the model is prepared and run once — so a gallery model
 * opens with its graphs drawn. A session or a layout bringing panels back is
 * not an opening. Set from what is open now with `snapshot` (the Metadata
 * panel's "Use the displays open now").
 *
 * Classic script; no imports/exports.
 */
(function (Sienna) {
  'use strict';

  var WIDGETS = { plotter: true, sliders: true, field3d: true };
  var RUN = ['startTime', 'runLength', 'logEach', 'timeStep'];

  /** A variable's name as displays give it: its submodels from the top, then its own. */
  function nameOf(m, id) {
    var n = ((m && m.nodes) || {})[id];
    if (!n || !n.label) return null;
    var subs = m.submodels || {};
    var path = [];
    for (var p = n.parent; p && subs[p]; p = subs[p].parent) path.unshift(subs[p].label || p);
    return path.concat([n.label]).join('/');
  }

  function idOf(m, name) {
    return Object.keys((m && m.nodes) || {}).filter(function (id) { return nameOf(m, id) === name; })[0] || null;
  }

  /** The model's presentation, tidied: `{run, displays}`, or null if it has none. */
  function of(m) {
    var p = m && m.presentation;
    if (!p || typeof p !== 'object') return null;
    var run = {};
    RUN.forEach(function (k) { if (p.run && p.run[k] != null && p.run[k] !== '') run[k] = p.run[k]; });
    var displays = (Array.isArray(p.displays) ? p.displays : []).filter(function (d) {
      return d && WIDGETS[d.widget];
    }).map(function (d) {
      return d.widget === 'plotter'
        ? { widget: 'plotter', variables: (d.variables || []).filter(function (id) { return nameOf(m, id); }) }
        : { widget: d.widget };
    }).filter(function (d) { return d.widget !== 'plotter' || d.variables.length; });
    if (!displays.length && !Object.keys(run).length) return null;
    return { run: run, displays: displays };
  }

  /** In words, for the Metadata panel. */
  function describe(m) {
    var p = of(m);
    if (!p) return '';
    var parts = p.displays.map(function (d) {
      return d.widget === 'plotter'
        ? 'a plot of ' + d.variables.map(function (id) { return nameOf(m, id); }).join(', ')
        : 'the sliders';
    });
    var r = p.run;
    var run = [];
    if (r.startTime) run.push('start at ' + r.startTime);
    if (r.runLength != null) run.push('run for ' + r.runLength);
    if (r.logEach != null) run.push('log each ' + r.logEach);
    if (r.timeStep != null) run.push('time step ' + r.timeStep);
    return (parts.length ? parts.join('; ') : 'no displays') + (run.length ? '; ' + run.join(', ') : '') + '.';
  }

  /** Every display panel of the model's that is open, in panel order. */
  function openDisplays(app, path) {
    return app.panels().filter(function ($p) {
      return $p.panel('ref') === path && WIDGETS[app.widgetOf($p)];
    });
  }

  /**
   * The presentation of what is open now: the model's plots and sliders,
   * and the run settings it would run with. Null if no display is open.
   */
  function snapshot(app, path) {
    var m = Sienna.userData.get(path);
    if (!m) return null;
    var displays = [];
    openDisplays(app, path).forEach(function ($p) {
      var w = app.widgetOf($p);
      if (w !== 'plotter') { displays.push({ widget: w }); return; }
      var inst = $p.panel('content').plotter('instance');
      var ids = (inst ? inst.variableNames() : []).map(function (n) { return idOf(m, n); }).filter(Boolean);
      if (ids.length) displays.push({ widget: 'plotter', variables: ids });
    });
    if (!displays.length) return null;
    var s = Sienna.Simulation.viewFor(path).settings;
    return {
      run: $.extend(Number(s.startTime) ? { startTime: Number(s.startTime) } : {},
        { runLength: Number(s.runLength), logEach: Number(s.logEach), timeStep: String(s.timeStep) }),
      displays: displays,
    };
  }

  /**
   * A model just opened: its default displays, if it has some and none of
   * its displays is open; then prepared and run once.
   */
  function apply(app, path) {
    var m = Sienna.userData.get(path);
    var p = of(m);
    if (!p || !p.displays.length || openDisplays(app, path).length) return Promise.resolve(false);
    var sim = Sienna.Simulation;
    // This user's own settings for it win; the modeller's are the default.
    if (Object.keys(p.run).length && !sim.settingsFor(path)) sim.presetSettings(path, p.run);
    var opened = p.displays.reduce(function (chain, d) {
      return chain.then(function () {
        return app.addPanel({
          widget: d.widget,
          ref: path,
          options: d.widget === 'plotter'
            ? { variables: d.variables.map(function (id) { return nameOf(m, id); }) } : undefined,
        });
      });
    }, Promise.resolve());
    return opened.then(function () {
      // The first display in front: it is the one the modeller put first.
      var first = openDisplays(app, path)[0];
      if (first) app.$workspace.workspace('reveal', first);
      var view = sim.viewFor(path);
      return view.prepare().then(function () { view.start(); return true; });
    }).catch(function () { return false; /* said in the run control */ });
  }

  Sienna.presentation = {
    of: of,
    describe: describe,
    snapshot: snapshot,
    apply: apply,
    nameOf: nameOf,
    idOf: idOf,
  };
})(window.Sienna);
