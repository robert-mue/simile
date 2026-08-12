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

  // =======================================================================
  // REPLAY
  // =======================================================================
  // Every model edit already goes through `Sienna.actions.dispatch`, so a whole
  // modelling session is on tape without anything being added for it. What the
  // shell cannot know is how to re-perform this app's LAYOUT actions, so those
  // get handlers here; model edits need none, since replay re-applies each
  // entry's captured `changes` and `_watchModel` redraws the bound widgets.

  function panelById(id) {
    return app.$workspace.workspace('panelById', id);
  }

  Sienna.actions.onReplay('panel.add', function (e) {
    // `ref` is what makes a replayed diagram panel view the right model.
    return app.addPanel({
      title: e.payload.title,
      widget: e.payload.widget || undefined,
      ref: e.payload.ref || '',
    });
  });
  Sienna.actions.onReplay('panel.close', function (e) {
    var $p = panelById(e.target);
    if ($p) $p.panel('close');
  });
  function replayGeometry(e) {
    var $p = panelById(e.target);
    if ($p) $p.panel('setGeometry', e.payload);
  }
  Sienna.actions.onReplay('panel.move', replayGeometry);
  Sienna.actions.onReplay('panel.resize', replayGeometry);
  Sienna.actions.onReplay('panel.minimize', function (e) {
    var $p = panelById(e.target);
    if ($p) $p.panel('minimize', !!e.payload.minimized);
  });
  Sienna.actions.onReplay('panel.maximize', function (e) {
    var $p = panelById(e.target);
    if ($p) $p.panel('maximize', !!e.payload.maximized);
  });

  /**
   * Rewrite the timestamps so a session is worth watching.
   *
   * Real timings are useless as video: a modeller thinks for two minutes, then
   * fires off six actions in a second. Replayed faithfully that is two minutes
   * of nothing followed by a blur. Clamping every gap into a narrow band gives
   * an even pace — which is what someone watching a model being built actually
   * wants, and it costs only a copy of the log.
   *
   * A speed multiplier alone cannot do this: it scales every gap equally, so
   * the pauses still dominate whatever number you pick.
   */
  function paced(entries, minGap, maxGap) {
    var t = entries.length ? entries[0].ts : 0;
    var prev = null;
    return entries.map(function (e) {
      if (prev != null) t += Math.min(Math.max(e.ts - prev, minGap), maxGap);
      prev = e.ts;
      return Object.assign({}, e, { ts: t });
    });
  }

  /**
   * Replay onto a clean slate — which means DESTROYING the current one. Replay
   * needs it: freshly minted panel ids must line up with the recorded ones.
   *
   * Hence the confirmation, and hence its wording. The action log lives in
   * memory only, so it does not survive a reload: after one, the log is empty
   * while `localStorage` still holds the models, and replaying then would clear
   * everything and put nothing back. That is the trap this guards.
   */
  /**
   * Which stored models this log could NOT put back.
   *
   * The trap this exists for: the action log lives in memory, `localStorage`
   * holds the models, and the two part company at every reload. Come back the
   * next day and you have four models and an empty log — and a replay, which
   * must start from a clean slate, would delete all four and rebuild nothing.
   *
   * A general warning is not good enough for that, because the condition is
   * exactly checkable: a model is safe if the log contains the action that
   * created it. So say which ones are about to be lost, by name.
   */
  function modelsNotInLog(session) {
    var created = {};
    session.forEach(function (e) {
      (e.changes || []).forEach(function (c) {
        // The WHOLE model being written — `models/growth`, not
        // `models/growth/nodes/node3/label`. Creating a model writes the whole
        // object at once, whereas an edit writes deep inside one that must
        // already exist. Counting edits would be the dangerous mistake: a log
        // holding nothing but a rename would claim it could rebuild the model,
        // and replaying it would leave a stub with a single label in it.
        var m = /^models\/([^/]+)$/.exec(c.ref || '');
        if (m && c.value !== undefined) created[m[1]] = true;
      });
    });
    return (Sienna.userData.keys('models') || []).filter(function (id) {
      return !created[id];
    });
  }

  function replaySession(watch) {
    var session = Sienna.actions.log();
    if (!session.length) {
      window.alert('Nothing recorded to replay.\n\n'
        + 'The action log is kept in memory only, so it starts empty after a '
        + 'reload. Build something first, or open a saved session log.');
      return;
    }
    var doomed = modelsNotInLog(session);
    if (!window.confirm(
      'Replay ' + session.length + ' recorded actions?\n\n'
      + 'This first CLEARS the workspace and every stored model, then rebuilds '
      + 'from the log.'
      + (doomed.length
        ? '\n\nTHIS LOG CANNOT REBUILD: ' + doomed.join(', ')
          + '.\nThose models will be deleted permanently. Save them first '
          + '(File ▸ Save model) if you want to keep them.'
        : '\n\nEvery stored model is in the log, so all of them come back.'))) return;

    app.clearWorkspace();
    Sienna.userData.clear();
    Sienna.history.clear();
    Sienna.actions
      .replay(watch ? paced(session, 150, 1200) : session, watch ? { speed: 1 } : {})
      .catch(function (e) {
        window.alert('Replay stopped: ' + (e && e.message ? e.message : e));
      });
  }

  /**
   * Pick a file and hand back its TEXT.
   *
   * `Sienna.files.pickFile` parses JSON, which a `.pl` is not. A raw-text
   * picker is generic furniture and belongs in the shell rather than here; it
   * is local for now because sienna is a submodule and this is the first app
   * that has wanted one.
   */
  function pickText(accept, cb) {
    var input = document.createElement('input');
    input.type = 'file';
    input.accept = accept;
    input.addEventListener('change', function () {
      var file = input.files && input.files[0];
      if (!file) return;
      var reader = new FileReader();
      reader.onload = function () { cb(String(reader.result), file.name); };
      reader.readAsText(file);
    });
    input.click();
  }

  /** A model id from a filename: `landuse1b.pl` → `landuse1b`. */
  function idFromFilename(name) {
    var base = String(name).replace(/\.(pl|sml)$/i, '').replace(/[^A-Za-z0-9_-]+/g, '-');
    return base.replace(/^-+|-+$/g, '').toLowerCase() || 'imported';
  }

  /**
   * What the import did, in the order that matters: what it could not do, then
   * what it guessed, then what it threw away. An import that quietly loses
   * something is the failure mode worth spending a dialog on.
   */
  function importReport(r, id) {
    var by = {};
    r.notes.forEach(function (n) { (by[n.kind] = by[n.kind] || []).push(n.text); });
    var lines = ['Imported as "' + id + '": ' + r.stats.nodes + ' nodes, '
      + r.stats.arcs + ' arcs, ' + r.stats.submodels + ' submodels.'];
    ['dropped', 'unsupported', 'incomplete', 'inferred', 'ambiguous', 'renamed', 'ignored']
      .forEach(function (kind) {
        var list = by[kind];
        if (!list) return;
        lines.push('');
        lines.push(kind.toUpperCase() + ' (' + list.length + ')');
        list.slice(0, 6).forEach(function (t) { lines.push('  • ' + t); });
        if (list.length > 6) lines.push('  …and ' + (list.length - 6) + ' more');
      });
    return lines.join('\n');
  }

  function importSimileFile() {
    pickText('.pl,.sml,text/plain', function (text, filename) {
      var r;
      try {
        r = Sienna.importSimile.read(text);
      } catch (e) {
        window.alert('Could not read that file: ' + (e && e.message ? e.message : e));
        return;
      }
      var id = idFromFilename(filename);
      var path = 'models/' + id;
      // Never overwrite a stored model without being asked — an import is not
      // a reason to lose work that happens to share a filename.
      if (Sienna.userData.get(path)) {
        var alt = window.prompt('A model called "' + id + '" already exists.\n'
          + 'Name for the imported one (or Cancel):', id + '-imported');
        if (!alt) return;
        id = idFromFilename(alt);
        path = 'models/' + id;
        if (Sienna.userData.get(path)) { window.alert('"' + id + '" is taken too.'); return; }
      }
      Sienna.importSimile.install(path, r.model);
      window.alert(importReport(r, id));
      app.addPanel({ title: r.model.name || id, widget: 'diagram', ref: path });
    });
  }

  /**
   * The frontmost model, as Prolog, into a file the user picks. The exporter
   * refuses a model it cannot faithfully convert, and that message is worth
   * showing whole — it names the elements to fix.
   */
  function exportSimileFile() {
    var path = Sienna.documents.currentPath(app);
    if (!path) { window.alert('Open a model first — this exports the frontmost one.'); return; }
    var model = Sienna.userData.get(path);
    var text;
    try {
      text = Sienna.exportSimile.prolog(model);
    } catch (e) {
      window.alert(e && e.message ? e.message : String(e));
      return;
    }
    var name = String(path).split('/').pop() + '.pl';
    // `Sienna.files` serialises to JSON; Prolog is text, so this writes its own
    // Blob. Same gap as `pickText` above, and the same reason.
    var url = URL.createObjectURL(new Blob([text], { type: 'text/plain' }));
    var a = document.createElement('a');
    a.href = url;
    a.download = name;
    a.click();
    setTimeout(function () { URL.revokeObjectURL(url); }, 1000);
  }

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
      // Simile's own formats, in and out. The shell's File menu handles OUR
      // format; these two are about the other program, so they are the app's.
      label: 'Simile',
      items: [
        { label: 'Import model (.pl / .sml)…', onSelect: importSimileFile },
        { label: '—' },
        { label: 'Export current model as .pl…', onSelect: exportSimileFile },
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
    {
      // Saving the log is not a nicety: the log is in memory only, so this is
      // the only way a session outlives the tab it was made in.
      label: 'Session',
      items: [
        { label: 'Watch replay', onSelect: function () { replaySession(true); } },
        { label: 'Replay at once', onSelect: function () { replaySession(false); } },
        { label: '—' },
        {
          label: 'Save session log…',
          onSelect: function () {
            Sienna.files.saveAs('simile-session.json', Sienna.actions.toJSON());
          },
        },
        {
          label: 'Open session log…',
          onSelect: function () {
            Sienna.files.pickFile(function (obj) {
              if (!Array.isArray(obj)) {
                window.alert('That is not a session log.');
                return;
              }
              Sienna.actions.fromJSON(obj);
              window.alert(obj.length + ' actions loaded. Session ▸ Watch replay to run them.');
            });
          },
        },
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
  if (!Sienna.userData.get('models/landuse') && Sienna.demoLanduse) Sienna.demoLanduse();
  if (!Sienna.userData.get('models/farmers') && Sienna.demoFarmers) Sienna.demoFarmers();
  if (!Sienna.userData.get('models/lamos') && Sienna.demoLamos) Sienna.demoLamos();
  if (!Sienna.userData.get('models/stand') && Sienna.demoStand) Sienna.demoStand();
  if (!Sienna.userData.get('models/drain') && Sienna.demoDrain) Sienna.demoDrain();
  if (!Sienna.userData.get('models/rank') && Sienna.demoRank) Sienna.demoRank();
  if (!Sienna.userData.get('models/mixed') && Sienna.demoMixed) Sienna.demoMixed();

  app.restore();

  // Handy for tinkering from the browser console.
  window.app = app;
})(window.Sienna);
