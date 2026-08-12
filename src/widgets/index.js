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

  reg.register('diagram', {
    src: 'src/widgets/diagram.js', // resolved relative to index.html
    label: 'Diagram',
    title: 'Diagram',
  });

  // Running a model. These two are views onto `Sienna.Simulation` (see
  // src/simulation.js): the run control drives a session, display widgets
  // receive from it. Several of either may be open at once.
  reg.register('runControl', {
    src: 'src/widgets/run-control.js',
    label: 'Run control',
    title: 'Run control',
  });

  reg.register('plotter', {
    src: 'src/widgets/plotter.js',
    label: 'Plotter',
    title: 'Plotter',
  });

  reg.register('grid', {
    src: 'src/widgets/grid.js',
    label: 'Spatial grid',
    title: 'Spatial grid',
  });
})(window.Sienna);
