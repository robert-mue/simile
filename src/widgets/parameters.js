/**
 * `sienna.parameters` — the values of a model's FILE PARAMETERS, grouped by
 * submodel, with Load and Save of a parameter file.
 *
 * A file parameter is a variable marked so in its dialog (Simile's
 * `param_type=file`): its value is not in the model but given when it runs
 * (`Simulation.fileParametersOf`). One model, several parameter files — a
 * scenario, a site, a country each. So the values here are NEVER written into
 * the model: they are kept beside it (the ones used last, `Simulation.
 * fileParameterValues`) and in parameter files.
 *
 * A value is typed as Simile's file parameter dialogue takes it: a number, or
 * JSON for several — `[3, 1, 2]`, one level of brackets per dimension,
 * outermost first (the instances of an enclosing fixed membership, then the
 * variable's own array). A value given changes the run from its start, as a
 * slider does. A field left empty uses the model's value, if it has one.
 *
 * A parameter file is JSON in the same notation, grouped by submodel as
 * Simile's are (`.spf`; Simile's own are XML, and are not read yet):
 *
 *   { "simile": "parameters", "version": 1, "model": "labour",
 *     "variables": { "time_available": 10 },
 *     "submodels": { "Activity": { "variables": { "priority": [3, 1, 2] },
 *                                  "submodels": {} } } }
 *
 * Classic script, injected on demand by the widget registry.
 */
$.widget('sienna.parameters', $.sienna.widgetBase, {
  options: {},

  _create() {
    this.element.addClass('slx-params');
    this._sim = Sienna.Simulation.viewFor(this._ref());

    const bar = $('<div class="slx-palette slx-chrome slx-params-bar">').appendTo(this.element);
    $('<span class="slx-palette-group">').text('file parameters').appendTo(bar);
    this._loadBtn = $('<button type="button">').text('Load…')
      .attr('title', 'Give every file parameter its value from a parameter file (.spf)').appendTo(bar);
    this._saveBtn = $('<button type="button">').text('Save…')
      .attr('title', 'Save the values given here as a parameter file (.spf)').appendTo(bar);
    this._clearBtn = $('<button type="button">').text('Clear')
      .attr('title', 'Take away every value given here').appendTo(bar);
    this._on(this._loadBtn, { click: () => this._load() });
    this._on(this._saveBtn, { click: () => this._save() });
    this._on(this._clearBtn, { click: () => this._clear() });

    this._note = $('<p class="slx-params-note" role="status">').appendTo(this.element);
    this._list = $('<div class="slx-params-list">').appendTo(this.element);

    this._unsub = this._sim.subscribe((e) => {
      if (e.type === 'parameters' && e.path === this._ref()) this._sync();
    });
    this._sig = '';
    this._watchModel(() => {
      window.clearTimeout(this._timer);
      this._timer = window.setTimeout(() => this._build(), 250);
    });
    this._build();
  },

  _destroy() {
    if (this._unsub) this._unsub();
  },

  _params() {
    return Sienna.Simulation.fileParametersOf(this._ref());
  },

  /** How many values a shape holds, and how to say it. */
  _shapeText(p) {
    if (p.unsized) return 'not given here: ' + p.unsized;
    if (!p.shape.length) return 'one number';
    const n = p.shape.reduce((a, b) => a * b, 1);
    return n + ' values' + (p.shape.length > 1 ? ' (' + p.shape.join(' × ') + ')' : '');
  },

  _build() {
    const params = this._params();
    const sig = JSON.stringify(params.map((p) => [p.id, p.label, p.shape, p.unsized, p.default, p.units]));
    if (sig === this._sig) return;
    this._sig = sig;
    this._list.empty();
    this._rows = {};

    const none = !params.length;
    this._loadBtn.prop('disabled', none);
    this._saveBtn.prop('disabled', none);
    this._clearBtn.prop('disabled', none);
    if (none) {
      $('<p class="slx-params-empty">').text(this._bound()
        ? 'No file parameters. A file parameter is a variable whose value is given '
          + 'when the model runs, not in the model: tick “File parameter” in its dialog.'
        : 'Not bound to a model.').appendTo(this._list);
      this._note.text('');
      return;
    }

    // Grouped by submodel, as Simile's parameter files are: the top level
    // first, then each submodel by its path.
    const groups = {};
    params.forEach((p) => {
      const key = p.path.join(' / ');
      (groups[key] = groups[key] || []).push(p);
    });
    Object.keys(groups).sort().forEach((key) => {
      const sec = $('<section class="slx-params-group">').appendTo(this._list);
      $('<h3 class="slx-params-sub">').text(key || 'Top level').appendTo(sec);
      groups[key].sort((a, b) => a.name.localeCompare(b.name)).forEach((p) => this._row(p, sec));
    });
    this._sync();
  },

  _row(p, sec) {
    const row = $('<div class="slx-param">').appendTo(sec);
    const id = 'slx-param-' + this.uuid + '-' + p.id;
    const head = $('<div class="slx-param-head">').appendTo(row);
    $('<label class="slx-param-name">').attr('for', id).text(p.name).appendTo(head);
    if (p.units && !/^array\s*\(/.test(p.units)) {
      $('<span class="slx-param-units">').text(p.units).appendTo(head);
    }
    $('<span class="slx-param-shape">').text(this._shapeText(p)).appendTo(head);
    const box = $('<input type="text" class="slx-param-value" spellcheck="false">')
      .attr({ id, placeholder: p.default ? 'model value: ' + p.default : 'a value is needed' })
      .prop('disabled', !!p.unsized)
      .appendTo(row);
    const err = $('<p class="slx-param-error">').appendTo(row);
    this._rows[p.id] = { p, row, box, err };
    this._on(box, {
      keydown: (e) => { if (e.key === 'Enter') this._commit(p); },
      change: () => this._commit(p),
    });
  },

  /** A value as typed, or a reason it is not one. */
  _parse(p, text) {
    const t = String(text).trim();
    if (!t) return { value: null };
    let v;
    try {
      v = JSON.parse(t);
    } catch (e) {
      return { error: 'Not a number, nor JSON: several values go in brackets, [1, 2, 3].' };
    }
    const numbers = (x) => (Array.isArray(x) ? x.every(numbers) : typeof x === 'number' && isFinite(x));
    if (!numbers(v)) return { error: 'Only numbers, or brackets of numbers, can be given.' };
    const want = p.shape.reduce((a, b) => a * b, 1);
    const have = Array.isArray(v) ? v.flat(Infinity).length : 1;
    if (have !== want) {
      return { error: want + ' value' + (want === 1 ? ' is' : 's are') + ' needed; '
        + have + (have === 1 ? ' is' : ' are') + ' given.' };
    }
    return { value: v };
  },

  _fmt(v) {
    return v == null ? '' : JSON.stringify(v).replace(/,/g, ', ');
  },

  /** Every row to the value given it, and the note to what is missing. */
  _sync() {
    const given = this._sim.fileParameterValues(this._ref());
    const missing = [];
    Object.keys(this._rows || {}).forEach((id) => {
      const r = this._rows[id];
      if (document.activeElement !== r.box[0] || !r.row.hasClass('slx-param-bad')) {
        r.box.val(this._fmt(given[id]));
        r.err.text('');
        r.row.removeClass('slx-param-bad');
      }
      const lacks = given[id] == null && !r.p.default;
      r.row.toggleClass('slx-param-missing', lacks);
      if (lacks) missing.push(r.p.name);
    });
    this._note.toggleClass('slx-params-note-warn', missing.length > 0).text(missing.length
      ? missing.length + ' value' + (missing.length === 1 ? ' is' : 's are')
        + ' needed before the model can run.'
      : 'Every file parameter has a value. A change runs the model again from the start.');
  },

  _commit(p) {
    const r = this._rows[p.id];
    const got = this._parse(p, r.box.val());
    if (got.error) {
      r.err.text(got.error);
      r.row.addClass('slx-param-bad');
      return;
    }
    r.err.text('');
    r.row.removeClass('slx-param-bad');
    const was = this._sim.fileParameterValues(this._ref())[p.id];
    if (JSON.stringify(was) === JSON.stringify(got.value == null ? undefined : got.value)) return;
    this._action('set', { parameter: p.label, value: got.value }, () => {
      this._sim.setFileParameters(this._ref(), { [p.id]: got.value });
    });
  },

  _clear() {
    if (!Object.keys(this._sim.fileParameterValues(this._ref())).length) return;
    this._action('clear', {}, () => this._sim.setFileParameters(this._ref(), {}, true));
  },

  _modelName() {
    const m = this._model() || {};
    return String(m.name || this._ref() || 'model').split('/').pop();
  },

  // ---- parameter files ---------------------------------------------------

  /** The values given, as a parameter file: nested by submodel. */
  _fileText() {
    const given = this._sim.fileParameterValues(this._ref());
    const top = { variables: {}, submodels: {} };
    this._params().forEach((p) => {
      if (given[p.id] == null) return;
      let at = top;
      p.path.forEach((s) => {
        at = at.submodels[s] = at.submodels[s] || { variables: {}, submodels: {} };
      });
      at.variables[p.name] = given[p.id];
    });
    return JSON.stringify($.extend({ simile: 'parameters', version: 1, model: this._modelName() }, top), null, 2) + '\n';
  },

  _save() {
    const url = URL.createObjectURL(new Blob([this._fileText()], { type: 'application/json' }));
    const a = $('<a>').attr({ href: url, download: this._modelName() + '.spf' }).appendTo(document.body);
    a[0].click();
    a.remove();
    window.setTimeout(() => URL.revokeObjectURL(url), 1000);
  },

  _load() {
    const input = $('<input type="file" accept=".spf,.json,application/json" hidden>').appendTo(document.body);
    input.on('change', () => {
      const file = input[0].files && input[0].files[0];
      input.remove();
      if (!file) return;
      const reader = new FileReader();
      reader.onload = () => this._read(String(reader.result), file.name);
      reader.readAsText(file);
    });
    input[0].click();
  },

  /** A parameter file's text: every value in it given, the rest taken away. */
  _read(text, fileName) {
    const say = (msg) => this._note.addClass('slx-params-note-warn').text(msg);
    const t = text.replace(/^﻿/, '').trim();
    if (t.charAt(0) === '<') {
      say(fileName + ' is one of Simile’s own (XML) parameter files, which cannot be read here yet.');
      return;
    }
    let doc;
    try {
      doc = JSON.parse(t);
    } catch (e) {
      say(fileName + ' is not a parameter file this panel can read (it is not JSON).');
      return;
    }
    const params = this._params();
    const values = {};
    const unknown = [];
    const bad = [];
    const walk = (node, path) => {
      Object.keys((node && node.variables) || {}).forEach((name) => {
        const label = path.concat([name]).join('/');
        const p = params.find((x) => x.label === label);
        if (!p) { unknown.push(label); return; }
        const got = this._parse(p, JSON.stringify(node.variables[name]));
        if (got.error) bad.push(label + ': ' + got.error); else values[p.id] = got.value;
      });
      Object.keys((node && node.submodels) || {}).forEach((s) => walk(node.submodels[s], path.concat([s])));
    };
    walk(doc, []);
    this._action('load', { file: fileName, values: values }, () => {
      this._sim.setFileParameters(this._ref(), values, true);
    });
    const told = [];
    if (unknown.length) told.push('not in this model: ' + unknown.join(', '));
    if (bad.length) told.push('not taken: ' + bad.join('; '));
    if (told.length) say('Loaded ' + fileName + ' — ' + told.join('. ') + '.');
  },
});

window.Sienna.widgetRegistry._loaded('parameters', 'parameters');
