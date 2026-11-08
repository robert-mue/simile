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
 * JSON in the same notation, grouped by submodel as Simile's are, saved as
 * `<model>.parameters.json` — `.json` because it is JSON (Robert); Simile's
 * own keep `.spf`.
 * Simile's own are read too, not written — XML (`_fromSimileXml`) and its
 * first, text format (`_fromSimileText`):
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
      .attr('title', 'Give the parameters their values from a parameter file (ours, .json, or Simile’s, .spf)').appendTo(bar);
    this._saveBtn = $('<button type="button">').text('Save…')
      .attr('title', 'Save the values given here as a parameter file (.parameters.json)').appendTo(bar);
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
        placeholder: p.midpoint != null && String(p.units).trim() === 'boolean' ? 'false unless given (for now)'
          : p.midpoint != null ? 'middle of its range: ' + p.default
          : p.default ? 'model value: ' + p.default
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
    const a = $('<a>').attr({ href: url, download: this._modelName() + '.parameters.json' }).appendTo(document.body);
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
    const t = text.replace(/^\uFEFF/, '').trim();
    const skipped = [];
    let doc;
    if (/^MIME-Version:/i.test(t)) {
      doc = this._fromSimileText(t, skipped);
      if (!doc) {
        say(fileName + ' is not a parameter file this panel can read.');
        return;
      }
    } else if (t.charAt(0) === '<') {
      doc = this._fromSimileXml(t, skipped);
      if (!doc) {
        say(fileName + ' is not a parameter file this panel can read (not Simile’s XML).');
        return;
      }
    } else {
      try {
        doc = JSON.parse(t);
      } catch (e) {
        say(fileName + ' is not a parameter file this panel can read (it is not JSON).');
        return;
      }
    }
    const { values, fills, unknown, bad } = Sienna.Simulation.readParameterFile(this._ref(), doc);
    this._action('load', { file: fileName, values, fill: fills }, () => {
      this._sim.setInputValues(this._ref(), values, true, fills);
    });
    const told = [];
    if (unknown.length) told.push('not in this model: ' + unknown.join(', '));
    if (skipped.length) told.push('not read: ' + skipped.join('; '));
    if (bad.length) told.push('not taken: ' + bad.join('; '));
    if (told.length) say('Loaded ' + fileName + ' — ' + told.join('. ') + '.');
  },
});

/**
 * One of Simile's own parameter files (XML, `.spf`; Run/params.tcl writes
 * and reads them) as the JSON this panel reads: `<submodel label>` nesting
 * (the outermost, "top", is the model), and in each `<variables>`:
 *
 *   <single_value label val>     a number;
 *   <multi_value label>          values by index, `<values index>` per level
 *                                and `<value index value>` at the bottom —
 *                                an array (indices 1…N), else values keyed by
 *                                index: for a variable parameter, by TIME;
 *   <byte_array label type>      values as binary (base64), REAL / INTEGER /
 *                                FLAG, shaped by its `<value val>` children;
 *                                `TIME` first: one point after another, each
 *                                its time then its values; `fill_method`;
 *   csv_columns, csv_grid,       a reference to a data file: not read here,
 *   image, geotiff               and said so (`skipped`).
 *
 * Labels are Simile's captions, newlines and spaces included; they are
 * renamed as the importer renames them ("birth\nrate" → birth_rate).
 */
$.sienna.parameters.prototype._fromSimileXml = function (text, skipped) {
  let xml;
  try {
    xml = new DOMParser().parseFromString(text, 'application/xml');
  } catch (e) {
    return null;
  }
  const root = xml.documentElement;
  if (!root || root.nodeName !== 'spf') return null;
  const ours = (label) => {
    const safe = String(label || '').trim().replace(/[^A-Za-z0-9_]/g, '_');
    return /^[0-9]/.test(safe) ? '_' + safe : safe;
  };
  const kids = (el, name) => Array.from(el.children).filter((c) => !name || c.nodeName === name);
  const num = (v) => Number(String(v).replace(/^\s*NOW\s+/i, '').trim());

  // `<values index>` / `<value index value>` → {index: …}; then an array
  // where the indices are 1…N, else an object keyed by index (a time).
  const literal = (el) => {
    const out = {};
    kids(el).forEach((c) => {
      const idx = c.getAttribute('index');
      if (c.nodeName === 'value') {
        out[idx] = num(c.getAttribute('value') != null ? c.getAttribute('value') : c.getAttribute('val'));
      } else if (c.nodeName === 'values') out[idx] = literal(c);
    });
    return out;
  };
  const shaped = (obj) => {
    if (obj === null || typeof obj !== 'object') return obj;
    const keys = Object.keys(obj).sort((a, b) => Number(a) - Number(b));
    if (keys.every((k, i) => Number(k) === i + 1)) return keys.map((k) => shaped(obj[k]));
    const o = {};
    keys.forEach((k) => { o[k] = shaped(obj[k]); });
    return o;
  };

  const view = (b64) => {
    const bin = atob(String(b64).replace(/\s+/g, ''));
    const u8 = new Uint8Array(bin.length);
    for (let i = 0; i < bin.length; i++) u8[i] = bin.charCodeAt(i);
    return new DataView(u8.buffer);
  };
  const nest = (flat, dims) => {
    if (!dims.length) return flat.shift();
    return Array.from({ length: dims[0] }, () => nest(flat, dims.slice(1)));
  };
  const byteArray = (el, shown) => {
    const type = el.getAttribute('type');
    const size = type === 'REAL' ? 8 : type === 'FLAG' ? 1 : 4;
    const read = (dv, at) => (type === 'REAL' ? dv.getFloat64(at, true)
      : type === 'FLAG' ? dv.getUint8(at) : dv.getInt32(at, true));
    const dimVals = kids(el, 'value').map((v) => v.getAttribute('val'));
    const timed = dimVals[0] === 'TIME';
    const dims = (timed ? dimVals.slice(1) : dimVals).map(Number);
    if (dims.some((d) => !(d > 0))) { skipped.push(shown + ' (a shape not read here)'); return undefined; }
    const per = dims.reduce((a, b) => a * b, 1);
    const data = Array.from(el.childNodes).filter((n) => n.nodeType === 4 || n.nodeType === 3)
      .map((n) => n.nodeValue).join('');
    const dv = view(data);
    const point = (at) => {
      const flat = [];
      for (let i = 0; i < per; i++) flat.push(read(dv, at + i * size));
      return dims.length ? nest(flat, dims) : flat[0];
    };
    if (!timed) return point(0);
    const out = {};
    for (let at = 0; at + 8 <= dv.byteLength; at += 8 + per * size) {
      out[String(dv.getFloat64(at, true))] = point(at + 8);
    }
    return out;
  };

  const walk = (sub) => {
    const node = { variables: {}, submodels: {}, fill: {} };
    kids(sub, 'variables').forEach((vars) => kids(vars).forEach((v) => {
      const label = v.getAttribute('label');
      const name = ours(label);
      const shown = String(label).replace(/\s+/g, ' ');
      if (v.nodeName === 'single_value') node.variables[name] = num(v.getAttribute('val'));
      else if (v.nodeName === 'multi_value') node.variables[name] = shaped(literal(v));
      else if (v.nodeName === 'byte_array') {
        const val = byteArray(v, shown);
        if (val !== undefined) node.variables[name] = val;
        const f = v.getAttribute('fill_method');
        if (f) node.fill[name] = String(f).toLowerCase();
        if (Number(v.getAttribute('wrap_time') || 0)) skipped.push(shown + ': its repeat (wrap time) is ignored');
      } else {
        skipped.push(shown + ' (refers to the data file ' + (v.getAttribute('filename') || '?') + ')');
      }
    }));
    kids(sub, 'submodels').forEach((subs) => kids(subs, 'submodel').forEach((c) => {
      node.submodels[ours(c.getAttribute('label'))] = walk(c);
    }));
    return node;
  };
  const top = kids(root, 'submodel')[0];
  return top ? walk(top) : null;
};

/**
 * Simile's FIRST parameter-file format (before 6; still read by Simile):
 * MIME headers, then — base64 if the headers say so — one line per value,
 * `path/to/name=literal=value`, the value often `NOW v`, `true`/`false` a
 * flag, or time-value pairs `0 13.4 10 15`. A `=reference=` line names a
 * data file: not read here, and said so; anything else unreadable likewise.
 */
$.sienna.parameters.prototype._fromSimileText = function (text, skipped) {
  const cut = text.search(/\r?\n\r?\n/);
  if (cut < 0) return null;
  const head = text.slice(0, cut);
  let body = text.slice(cut).trim();
  if (/Content-Transfer-Encoding:\s*base64/i.test(head)) {
    try { body = atob(body.replace(/\s+/g, '')); } catch (e) { return null; }
  }
  const ours = (label) => {
    const safe = String(label || '').trim().replace(/[^A-Za-z0-9_]/g, '_');
    return /^[0-9]/.test(safe) ? '_' + safe : safe;
  };
  const doc = { variables: {}, submodels: {}, fill: {} };
  body.split(/\r?\n/).forEach((line) => {
    const m = /^(.*?)=(literal|reference)=(.*)$/.exec(line.trim());
    if (!m) return;
    const parts = m[1].replace(/^\/+/, '').split('/');
    const shown = parts.join('/');
    if (m[2] === 'reference') { skipped.push(shown + ' (refers to a data file)'); return; }
    const raw = m[3].replace(/^\s*NOW\s+/i, '').trim();
    const word = (w) => (/^true$/i.test(w) ? 1 : /^false$/i.test(w) ? 0 : Number(w));
    let v = word(raw);
    // `0 13.4`: time-value pairs — a variable parameter's values over time;
    // one pair at time 0 is its value through the run.
    const pairs = raw.split(/\s+/);
    if (!isFinite(v) && pairs.length % 2 === 0 && pairs.every((w) => isFinite(word(w)))) {
      if (pairs.length === 2 && Number(pairs[0]) === 0) v = word(pairs[1]);
      else {
        v = {};
        for (let i = 0; i < pairs.length; i += 2) v[String(Number(pairs[i]))] = word(pairs[i + 1]);
      }
    }
    if (raw === '' || (typeof v === 'number' && !isFinite(v))) { skipped.push(shown + ' (not read)'); return; }
    let at = doc;
    parts.slice(0, -1).forEach((sub) => {
      const k = ours(sub);
      at = at.submodels[k] = at.submodels[k] || { variables: {}, submodels: {}, fill: {} };
    });
    at.variables[ours(parts[parts.length - 1])] = v;
  });
  return doc;
};

window.Sienna.widgetRegistry._loaded('parameters', 'parameters');
