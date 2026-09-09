/**
 * The simile app's widget manifest — the ONE place listing its content widgets.
 *
 * The diagram widget will be registered here once built, e.g.:
 *
 *   reg.register('diagram', {
 *     src: 'src/widgets/diagram.js',   // resolved relative to index.html
 *     label: 'Diagram',
 *     title: 'Diagram',
 *   });
 *
 * See the sienna submodule's CLAUDE.md for the content-widget contract.
 *
 * Classic script; no imports/exports.
 */
(function (Sienna) {
  'use strict';
  var reg = Sienna.widgetRegistry;

  // `workingSize` is what the panel's "open to a working size" button opens a
  // shrunken panel to; `thumbnail: false` says a widget has nothing to show
  // once its controls are hidden, so it should never become one.
  reg.register('diagram', {
    src: 'src/widgets/diagram.js', // resolved relative to index.html
    label: 'Diagram',
    title: 'Diagram',
    workingSize: { width: 1040, height: 680 },   // as Sienna.documents.configure
  });

  // Running a model. These two are views onto `Sienna.Simulation` (see
  // src/simulation.js): the run control drives a session, display widgets
  // receive from it. Several of either may be open at once.
  // A transport IS its controls: hide them and a run control is an empty box
  // with a status line, so it stays out of the thumbnail scheme entirely.
  reg.register('runControl', {
    src: 'src/widgets/run-control.js',
    label: 'Run control',
    title: 'Run control',
    thumbnail: false,
  });

  reg.register('plotter', {
    src: 'src/widgets/plotter.js',
    label: 'Plotter',
    title: 'Plotter',
    workingSize: { width: 620, height: 420 },
  });

  reg.register('grid', {
    src: 'src/widgets/grid.js',
    label: 'Spatial grid',
    title: 'Spatial grid',
    workingSize: { width: 560, height: 520 },
  });
})(window.Sienna);
