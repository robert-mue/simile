/**
 * `sienna.sliders` — a slider for each of a model's parameters, so a reader
 * can vary them and watch the displays follow.
 *
 * A PARAMETER is a variable with a number for its value, a Minimum and a
 * Maximum (its dialog), and nothing influencing it — what Simile calls a
 * "variable parameter" (`Simulation.parametersOf`). The list comes from the
 * model, not the engine, so it is there before anything is loaded.
 *
 * Moving a slider does NOT change the model. Its value is a setting for running
 * the model (`Simulation.setParameter`), kept for this visit, and the model is
 * run again from the start with it once the slider is let go: in about a second
 * for a rate, which the engine changes in place, and in a few for a starting
 * value, which means building the model again. The number box beside each
 * slider takes a value typed exactly (Enter); "model values" puts every slider
 * back where the model has it.
 *
 * Classic script, injected on demand by the widget registry.
 */
$.widget('sienna.sliders', $.sienna.widgetBase, {
  options: {},

  _create() {
    this.element.addClass('slx-sliders');
    this._sim = Sienna.Simulation.viewFor(this._ref());

    const bar = $('<div class="slx-palette slx-chrome slx-sliders-bar">').appendTo(this.element);
    $('<span class="slx-palette-group">').text('parameters').appendTo(bar);
    this._resetBtn = $('<button type="button">')
      .attr('title', 'Put every slider back to the value in the model, and run again')
      .text('model values').appendTo(bar);
    this._on(this._resetBtn, { click: () => this._sim.clearParameters(this._ref()) });

    this._list = $('<div class="slx-sliders-list">').appendTo(this.element);

    this._unsub = this._sim.subscribe((e) => {
      if (e.type === 'parameters' && e.path === this._ref()) this._sync();
    });
    // Rebuilt when the SET of parameters or their ranges change, not on every
    // edit to the model — a slider must not be replaced under the hand.
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

  /** The parameters as they stand, and a signature of what the rows show. */
  _params() {
    return Sienna.Simulation.parametersOf(this._ref());
  },

  _build() {
    const params = this._params();
    const sig = JSON.stringify(params.map((p) => [p.id, p.label, p.min, p.max, p.value, p.units]));
    if (sig === this._sig) return;
    this._sig = sig;
    this._list.empty();
    this._rows = {};

    if (!params.length) {
      $('<p class="slx-sliders-empty">').text(this._bound()
        ? 'No parameters. A parameter is a variable whose value is a number, '
          + 'with a Minimum and a Maximum, that nothing influences.'
        : 'Not bound to a model.').appendTo(this._list);
      this._resetBtn.prop('disabled', true);
      return;
    }
    this._resetBtn.prop('disabled', false);
    params.forEach((p) => this._row(p));
    this._sync();
  },

  /**
   * How finely a slider moves: a round step — 1, 2 or 5 × a power of ten —
   * giving at least 200 positions, so round values such as the model's own
   * can be reached exactly. (A plain range/200 from a minimum of 0.1 steps
   * past 0.3 to 0.2995.) A range input counts its steps FROM ITS MINIMUM,
   * so the step must also divide the minimum and the model's value — with a
   * minimum of 22.5, steps of 0.2 never reach 45 — and is made finer until it
   * does. Whole numbers where the range is whole and wide.
   */
  _step(p) {
    const whole = [p.min, p.max, p.value].every((v) => Number.isInteger(v));
    if (whole && p.max - p.min >= 20) return 1;
    const raw = (p.max - p.min) / 200;
    if (!(raw > 0)) return 'any';
    const fits = (step) => [p.min, p.value].every((v) => {
      const k = v / step;
      return Math.abs(k - Math.round(k)) < 1e-6;
    });
    let mag = Math.pow(10, Math.floor(Math.log10(raw)));
    const n = raw / mag;
    let m = n >= 5 ? 5 : n >= 2 ? 2 : 1;
    for (let i = 0; i < 9; i++) {
      const step = m * mag;
      if (fits(step)) return Number(step.toPrecision(12));
      if (m === 5) m = 2; else if (m === 2) m = 1; else { m = 5; mag /= 10; }
    }
    return 'any';
  },

  _fmt(v) {
    return String(Number(Number(v).toPrecision(4)));
  },

  _row(p) {
    const row = $('<div class="slx-slider">').appendTo(this._list);
    const head = $('<div class="slx-slider-head">').appendTo(row);
    $('<label class="slx-slider-name">').text(p.label)
      .attr('title', p.needsLoad
        ? 'A starting value: the model is built again with it (a few seconds)'
        : 'Changes the run in place')
      .appendTo(head);
    const box = $('<input type="number" class="slx-slider-value">')
      .attr({ step: 'any', min: p.min, max: p.max, 'aria-label': p.label + ' value' })
      .appendTo(head);
    if (p.units) $('<span class="slx-slider-units">').text(p.units).appendTo(head);

    const track = $('<div class="slx-slider-track">').appendTo(row);
    $('<span class="slx-slider-end">').text(this._fmt(p.min)).appendTo(track);
    const range = $('<input type="range">')
      .attr({ min: p.min, max: p.max, step: this._step(p), 'aria-label': p.label })
      .appendTo(track);
    $('<span class="slx-slider-end">').text(this._fmt(p.max)).appendTo(track);

    this._rows[p.id] = { p, row, box, range };

    this._on(range, {
      input: () => { box.val(this._fmt(range.val())); this._mark(p.id); },
      change: () => this._commit(p, Number(range.val())),
    });
    this._on(box, {
      keydown: (e) => { if (e.key === 'Enter') this._commit(p, Number(box.val())); },
      change: () => this._commit(p, Number(box.val())),
    });
  },

  /** Show a row as differing from the model, or not. */
  _mark(id, value) {
    const r = this._rows[id];
    if (!r) return;
    const v = value == null ? Number(r.range.val()) : value;
    r.row.toggleClass('slx-slider-changed', Math.abs(v - r.p.value) > 1e-12);
  },

  /** Every row to the value it runs with: the slider's, or the model's. */
  _sync() {
    const vals = this._sim.parameterValues(this._ref());
    Object.keys(this._rows || {}).forEach((id) => {
      const r = this._rows[id];
      const v = id in vals ? vals[id] : r.p.value;
      r.range.val(v);
      r.box.val(this._fmt(v));
      this._mark(id, v);
    });
  },

  _commit(p, value) {
    if (!isFinite(value)) { this._sync(); return; }
    const v = Math.min(p.max, Math.max(p.min, value));
    const was = this._sim.parameterValues(this._ref())[p.id];
    if (v === (was == null ? p.value : was)) { this._sync(); return; }
    this._action('set', { parameter: p.label, value: v }, () => {
      this._sim.setParameter(this._ref(), p.id, v);
    });
  },
});

window.Sienna.widgetRegistry._loaded('sliders', 'sliders');
