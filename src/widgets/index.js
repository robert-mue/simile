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
})(window.Sienna);
