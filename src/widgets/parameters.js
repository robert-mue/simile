/**
 * `sienna.parameters` — the values of a model's PARAMETERS, fixed and
 * variable, grouped by submodel, with Load and Save of a parameter file.
 *
 * A parameter is a variable whose "Data source" (its dialog) is not an
 * equation but a value given when the model runs (`exportSimile.
 * parameterKind`, Simile's own distinction):
 *
 * - a FIXED parameter is read once, at reset: a number, or an array;
 * - a VARIABLE parameter is read every time step: a number or array held
 *   through the run, or values OVER TIME — `{"0": 5, "10": 7}` (times in the
 *   model's time unit), or one bracket deeper than a value, `[5, 7, 9]` for
 *   times 0, 1, 2 — with what the run sees between times: the last value
 *   given, the closest, or interpolated. One with a range also has a
 *   slider (the Sliders panel), which moves the same value.
 *
 * Brackets go one level per dimension, outermost first: the instances of
 * an enclosing fixed membership, then the variable's own array. A field
 * left empty uses the model's value (the default), if it has one. A change
 * runs the model again from the start, as a slider does.
 *
 * One model, several parameter files — a scenario, a site, a country each.
 * So the values here are NEVER written into the model: they are kept beside
 * it (the ones used last, `Simulation.inputValues`) and in parameter files,
 * JSON in the same notation, grouped by submodel as Simile's are (`.spf`;
 * Simile's own are XML, and are not read yet):
 *
 *   { "simile": "parameters", "version": 1, "model": "labour",
 *     "variables": { "time_available": 10, "rain": { "0": 5, "10": 7 } },
 *     "fill": { "rain": "interpolate" },
 *     "submodels": { "Activity": { "variables": { "priority": [3, 1, 2] },
 *                                  "submodels": {} } } }
 *
 * Classic script, injected on demand by the widget registry.
 */
$.widget('sienna.parameters', $.sienna.widgetBase, {
  options: {},

  FILLS: [
    { value: 'use_last', label: 'last value' },
    { value: 'use_closest', label: 'closest value' },
    { value: 'interpolate', label: 'interpolated' },
  ],

  _create() {
    this.element.addClass('slx-params');
    this._sim = Sienna.Simulation.viewFor(this._ref());

    const bar = $('<div class="slx-palette slx-chrome slx-params-bar">').appendTo(this.element);
    $('<span class="slx-palette-group">').text('parameters').appendTo(bar);
    this._loadBtn = $('<button type="button">').text('Load…')
      .attr('title', 'Give the parameters their values from a parameter file (.spf)').appendTo(bar);
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
    return Sienna.Simulation.inputParametersOf(this._ref());
  },

  /** How many values a parameter holds, and how to say it. */
  _shapeText(p) {
    if (p.unsized) return 'not given here: ' + p.unsized;
    if (!p.shape.length) return 'one number';
    const n = p.shape.reduce((a, b) => a * b, 1);
    return n + ' values' + (p.shape.length > 1 ? ' (' + p.shape.join(' × ') + ')' : '');
  },

  _build() {
    const params = this._params();
    const sig = JSON.stringify(params.map((p) => [p.id, p.kind, p.label, p.shape, p.unsized, p.default, p.units, p.slider]));
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
        ? 'No parameters. A parameter is a variable whose value is given when the model '
          + 'runs, not by an equation: choose Variable or Fixed parameter as its Data source.'
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
    const row = $('<div class="slx-param">').attr('data-kind', p.kind).appendTo(sec);
    const id = 'slx-param-' + this.uuid + '-' + p.id;
    const head = $('<div class="slx-param-head">').appendTo(row);
    $('<label class="slx-param-name">').attr('for', id).text(p.name).appendTo(head);
    $('<span class="slx-param-kind">').text(p.kind === 'variable' ? 'variable' : 'fixed')
      .attr('title', p.kind === 'variable'
        ? 'A variable parameter: read every time step, so it can be given values over time'
        : 'A fixed parameter: read once, when the run starts')
      .appendTo(head);
    if (p.slider) {
      $('<span class="slx-param-slider">').text('+ slider')
        .attr('title', 'It has a Minimum and a Maximum, so the Sliders panel moves it too; '
          + 'a slider moved last wins over a value given here, until values over time take over')
        .appendTo(head);
    }
    if (p.units && !/^array\s*\(/.test(p.units)) {
      $('<span class="slx-param-units">').text(p.units).appendTo(head);
    }
    $('<span class="slx-param-shape">').text(this._shapeText(p)).appendTo(head);
    const box = $('<input type="text" class="slx-param-value" spellcheck="false">')
      .attr({
        id,
        placeholder: p.default ? 'model value: ' + p.default
          : p.kind === 'variable' ? 'a value is needed — over time: {"0": 5, "10": 7}'
            : 'a value is needed',
      })
      .prop('disabled', !!p.unsized)
      .appendTo(row);
    let fill = null;
    if (p.kind === 'variable') {
      const line = $('<div class="slx-param-fill">').appendTo(row);
      $('<label>').attr('for', id + '-fill').text('Between times:').appendTo(line);
      fill = $('<select>').attr('id', id + '-fill').appendTo(line);
      this.FILLS.forEach((f) => $('<option>').val(f.value).text(f.label).appendTo(fill));
      this._on(fill, { change: () => this._commitFill(p) });
    }
    const err = $('<p class="slx-param-error">').appendTo(row);
    this._rows[p.id] = { p, row, box, err, fill };
    this._on(box, {
      keydown: (e) => { if (e.key === 'Enter') this._commit(p); },
      change: () => this._commit(p),
    });
  },

  /** A value as typed: `{value}`, or `{error}` saying what is wrong. */
  _parse(p, text) {
    const t = String(text).trim();
    if (!t) return { value: null };
    let v;
    try {
      v = JSON.parse(t);
    } catch (e) {
      return { error: p.kind === 'variable'
        ? 'Not a number, nor JSON: several values go in brackets, [1, 2, 3]; values over time as {"0": 5, "10": 7}.'
        : 'Not a number, nor JSON: several values go in brackets, [1, 2, 3].' };
    }
    const r = Sienna.Simulation.readInputValue(p, v);
    return r.error ? { error: r.error } : { value: v };
  },

  _fmt(v) {
    return v == null ? '' : JSON.stringify(v).replace(/,"/g, ', "').replace(/,(?=[-\d[])/g, ', ').replace(/":/g, '": ');
  },

  /** Every row to the value given it, and the note to what is missing. */
  _sync() {
    const given = this._sim.inputValues(this._ref());
    const missing = [];
    Object.keys(this._rows || {}).forEach((id) => {
      const r = this._rows[id];
      if (document.activeElement !== r.box[0] || !r.row.hasClass('slx-param-bad')) {
        r.box.val(this._fmt(given.values[id]));
        r.err.text('');
        r.row.removeClass('slx-param-bad');
      }
      if (r.fill) {
        r.fill.val(given.fill[id] || 'use_last');
        const v = given.values[id];
        const over = v != null && !Sienna.Simulation.readInputValue(r.p, v).error
          && !!Sienna.Simulation.readInputValue(r.p, v).times;
        r.row.toggleClass('slx-param-over-time', over);
      }
      const lacks = given.values[id] == null && !r.p.default;
      r.row.toggleClass('slx-param-missing', lacks);
      if (lacks) missing.push(r.p.name);
    });
    this._note.toggleClass('slx-params-note-warn', missing.length > 0).text(missing.length
      ? missing.length + ' value' + (missing.length === 1 ? ' is' : 's are')
        + ' needed before the model can run.'
      : 'Every parameter has a value. A change runs the model again from the start.');
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
    const was = this._sim.inputValues(this._ref()).values[p.id];
    if (JSON.stringify(was) === JSON.stringify(got.value == null ? undefined : got.value)) return;
    this._action('set', { parameter: p.label, value: got.value }, () => {
      this._sim.setInputValues(this._ref(), { [p.id]: got.value });
    });
  },

  _commitFill(p) {
    const m = this._rows[p.id].fill.val();
    this._action('fill', { parameter: p.label, fill: m }, () => {
      this._sim.setInputValues(this._ref(), {}, false, { [p.id]: m });
    });
  },

  _clear() {
    if (!Object.keys(this._sim.inputValues(this._ref()).values).length) return;
    this._action('clear', {}, () => this._sim.setInputValues(this._ref(), {}, true));
  },

  _modelName() {
    const m = this._model() || {};
    return String(m.name || this._ref() || 'model').split('/').pop();
  },

  // ---- parameter files ---------------------------------------------------

  /** The values given, as a parameter file: nested by submodel. */
  _fileText() {
    const given = this._sim.inputValues(this._ref());
    const top = { variables: {}, submodels: {} };
    this._params().forEach((p) => {
      if (given.values[p.id] == null) return;
      let at = top;
      p.path.forEach((s) => {
        at = at.submodels[s] = at.submodels[s] || { variables: {}, submodels: {} };
      });
      at.variables[p.name] = given.values[p.id];
      if (given.fill[p.id]) (at.fill = at.fill || {})[p.name] = given.fill[p.id];
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
    const fills = {};
    const unknown = [];
    const bad = [];
    const walk = (node, path) => {
      Object.keys((node && node.variables) || {}).forEach((name) => {
        const label = path.concat([name]).join('/');
        const p = params.find((x) => x.label === label);
        if (!p) { unknown.push(label); return; }
        const got = this._parse(p, JSON.stringify(node.variables[name]));
        if (got.error) { bad.push(label + ': ' + got.error); return; }
        values[p.id] = got.value;
        const f = ((node && node.fill) || {})[name];
        if (f && p.kind === 'variable') fills[p.id] = f;
      });
      Object.keys((node && node.submodels) || {}).forEach((s) => walk(node.submodels[s], path.concat([s])));
    };
    walk(doc, []);
    this._action('load', { file: fileName, values, fill: fills }, () => {
      this._sim.setInputValues(this._ref(), values, true, fills);
    });
    const told = [];
    if (unknown.length) told.push('not in this model: ' + unknown.join(', '));
    if (bad.length) told.push('not taken: ' + bad.join('; '));
    if (told.length) say('Loaded ' + fileName + ' — ' + told.join('. ') + '.');
  },
});

window.Sienna.widgetRegistry._loaded('parameters', 'parameters');
