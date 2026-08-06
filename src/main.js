/**
 * Bootstrap for the simile app: build the App, define the menus, restore panels.
 *
 * The Widgets menu is generated from the manifest in src/widgets/index.js, so
 * it fills in automatically as widgets are registered. The File menu handles
 * model lifecycle and interchange: under `file://` a browser cannot write
 * silently, so saving is a download and opening is a file chooser — the shell's
 * `Sienna.files` wraps both.
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

  /**
   * Is this parsed file a model this editor can open?
   *
   * Deliberately more than a shape check. The shell hands over anything the
   * user picked, and without a schema test a file from another notation
   * imports happily, joins the model list, and only fails when a panel tries
   * to draw it — leaving the user a document they cannot open and no
   * explanation. Refusing here means one clear sentence instead.
   *
   * Content validation belongs to simile and not to the shell (§18): the shell
   * never inspects a document's contents.
   */
  function validateModel(obj) {
    if (!obj || typeof obj !== 'object') throw new Error('that is not a model file');
    if (!obj.nodes || !obj.arcs) throw new Error('expected a model with nodes and arcs');

    var format = obj.format == null ? 1 : obj.format;
    if (!(format <= Sienna.Diagram.FORMAT)) {
      throw new Error('it was saved by a newer version of simile (format ' + format
                      + '; this one reads up to ' + Sienna.Diagram.FORMAT + ')');
    }

    // A model names the notation it is written in, and we can only draw a
    // notation we have. Naming what IS available turns a dead end into a hint.
    var schema = obj.schema;
    if (!schema) throw new Error('the file does not say which notation it uses');
    if (!Sienna.schemas.has(schema)) {
      throw new Error('it uses the notation "' + schema + '", which this editor does not have'
                      + ' (available: ' + Sienna.schemas.list().join(', ') + ')');
    }
  }

  // Tell the shell what a simile document IS. The File menu itself — New,
  // Open, Save as, and the list of stored models — belongs to the shell
  // (Sienna.documents), because it is conventional furniture that should not
  // vary between the applications sienna hosts, and because a model will
  // eventually be viewed by several widgets, none of which should own saving
  // it. All simile supplies is the shape of an empty model and which widget
  // opens one.
  Sienna.documents.configure({
    root: 'models',
    label: 'model',
    widget: 'diagram',
    // The empty-model shape lives in the model layer, not here, so that a
    // model made from the File menu and one made from code cannot differ.
    create: function (id) { return Sienna.Diagram.emptyModel(id); },
    validate: validateModel,
  });

  function buildMenu() {
    return [
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
    ];
  }

  app.setMenu(buildMenu());

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
