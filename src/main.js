/**
 * Bootstrap for the simile app: build the App, define a menu, restore panels.
 *
 * This is a minimal skeleton — the diagram editor is not built yet. The Widgets
 * menu is generated from the (currently empty) manifest, so it fills in
 * automatically as widgets are registered in src/widgets/index.js.
 *
 * Classic script — runs after all shell scripts have loaded. No imports/exports.
 */
(function (Sienna) {
  'use strict';

  var app = new Sienna.App('#app');

  // One Widgets entry per registered widget, in registration order (none yet).
  var widgetItems = Sienna.widgetRegistry.list().map(function (w) {
    return {
      label: w.label,
      onSelect: function () {
        app.addPanel({ title: w.title, widget: w.name, options: w.options });
      },
    };
  });

  app.setMenu([
    {
      label: 'Edit',
      items: [
        { label: 'Undo', onSelect: function () { Sienna.history.undo(); } },
        { label: 'Redo', onSelect: function () { Sienna.history.redo(); } },
      ],
    },
    {
      label: 'Widgets',
      items: widgetItems.length ? widgetItems : [{ label: '(none yet)' }],
    },
    {
      label: 'View',
      items: [
        { label: 'Clear workspace', onSelect: function () { app.clearWorkspace(); } },
      ],
    },
  ]);

  // Keyboard: Ctrl/Cmd-Z = undo, Ctrl/Cmd-Shift-Z (or Ctrl-Y) = redo. Skip when
  // typing in a field so native text undo keeps working there.
  $(document).on('keydown', function (e) {
    var tag = (e.target && e.target.tagName) || '';
    if (/^(INPUT|TEXTAREA|SELECT)$/.test(tag) || e.target.isContentEditable) return;
    var key = (e.key || '').toLowerCase();
    var mod = e.ctrlKey || e.metaKey;
    if (mod && key === 'z' && !e.shiftKey) {
      e.preventDefault();
      Sienna.history.undo();
    } else if (mod && (key === 'y' || (key === 'z' && e.shiftKey))) {
      e.preventDefault();
      Sienna.history.redo();
    }
  });

  // TEMPORARY dev convenience: seed the demo model so Widgets ▸ Diagram has
  // something to draw on a fresh browser. Goes away once models can be created
  // and opened through the UI.
  if (!Sienna.userData.get('models/growth') && Sienna.demoGrowth) Sienna.demoGrowth();
  if (!Sienna.userData.get('models/plant') && Sienna.demoSubmodel) Sienna.demoSubmodel();

  app.restore();

  // Handy for tinkering from the browser console.
  window.app = app;
})(window.Sienna);
