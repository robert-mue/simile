/**
 * `sienna.runControl` — the transport for a simulation run: load a model, then
 * play / pause / reset it, with the five timing settings that decide what a run
 * means.
 *
 * All state lives in `Sienna.Simulation` (see `src/simulation.js`); this widget
 * owns no numbers of its own. That is what lets a second run-control panel show
 * the same run, and what stops two panels each driving the poll loop.
 *
 * ## What the five fields actually do
 *
 * They are easy to confuse, and only two of them are about the model:
 *
 *   - **Time step** is the integration step — genuinely part of the model's
 *     numerics. A multi-phase model gives several, space separated.
 *   - **Log each** is how often the server records a point during a chunk. It
 *     sets how many frames a display gets.
 *   - **Update each** is how big a chunk is — how much model time passes per
 *     request. It is a NETWORK setting: small chunks mean smoother display and
 *     more round trips, large chunks mean fewer round trips and a display that
 *     arrives in bursts. Nothing about the model's results depends on it.
 *   - **Execute for** is how long the run lasts, and **Current time** is where
 *     it has got to.
 *
 * Classic script, injected on demand by the widget registry.
 */
$.widget('sienna.runControl', $.sienna.widgetBase, {
  options: {
    /** Pre-filled model path on the SimiLive server. */
    model: 'demos/fire_rect.sml',
    /** Optional `.spf` parameter file to go with it. */
    params: '',
  },

  /**
   * The demos worth offering: SimiLive's own, minus the ones whose displays we
   * have no widget for yet. Fire spread is first because it is the one this was
   * built against.
   */
  _DEMOS: [
    { label: 'Fire spread (grid)', model: 'demos/fire_rect.sml' },
    { label: 'Game of Life (grid)', model: 'demos/life_file.sml', params: 'demos/life_allin1.spf' },
    { label: 'Particle diffusion', model: 'demos/diffusion.sml' },
    { label: 'Three-body problem', model: 'demos/nbody.sml' },
    { label: 'Branching plant', model: 'demos/branch.sml' },
  ],

  // label, settings key, title
  _FIELDS: [
    ['Execute for', 'runLength', 'How much model time this run covers'],
    ['Current time', 'current', 'Where the model has got to'],
    ['Update each', 'updateEach', 'Model time per request to the server — display smoothness, not results'],
    ['Log each', 'logEach', 'How often the server records a point'],
    ['Time step(s)', 'timeStep', 'The integration step; space-separated for a multi-phase model'],
  ],

  _create() {
    this.element.addClass('slx-run');
    this._sim = Sienna.Simulation;

    this._buildSource();
    this._buildTransport();
    this._buildFields();

    this._unsub = this._sim.subscribe((e) => this._onEvent(e));
    this._syncAll();
  },

  // ---- construction ---------------------------------------------------

  _buildSource() {
    const bar = $('<div class="slx-palette slx-run-source">').appendTo(this.element);

    $('<span class="slx-palette-group">').text('model').appendTo(bar);

    this._demo = $('<select class="slx-run-demo">')
      .attr('title', 'Demo models on the SimiLive server')
      .appendTo(bar);
    this._DEMOS.forEach((d, i) => {
      $('<option>').val(String(i)).text(d.label).appendTo(this._demo);
    });
    $('<option>').val('custom').text('other…').appendTo(this._demo);

    this._path = $('<input type="text" class="slx-run-path">')
      .attr('title', 'Path to a model on the SimiLive server')
      .val(this.options.model)
      .appendTo(bar);

    this._loadBtn = $('<button type="button">').text('load').appendTo(bar);
    this._unloadBtn = $('<button type="button">')
      .attr('title', 'End the session on the server')
      .text('unload')
      .appendTo(bar);

    this._on(this._demo, {
      change: () => {
        const v = this._demo.val();
        if (v === 'custom') return;
        const d = this._DEMOS[Number(v)];
        this._path.val(d.model);
        this.options.params = d.params || '';
      },
    });
    this._on(this._path, { input: () => this._demo.val('custom') });
    this._on(this._loadBtn, { click: () => this._load() });
    this._on(this._unloadBtn, { click: () => this._sim.unload() });

    // Where a load's progress and any failure is reported. A run control with
    // nowhere to say "the model would not compile" is a play button that
    // silently does nothing.
    this._status = $('<div class="slx-run-status">').appendTo(this.element);
  },

  _buildTransport() {
    const bar = $('<div class="slx-run-transport">').appendTo(this.element);

    this._resetBtn = $('<button type="button" class="slx-run-btn">')
      .attr('title', 'Back to the start')
      .html('<span class="slx-glyph-stop"></span>')
      .appendTo(bar);

    this._playBtn = $('<button type="button" class="slx-run-btn">')
      .attr('title', 'Run')
      .html('<span class="slx-glyph-play"></span>')
      .appendTo(bar);

    this._progress = $('<div class="slx-run-progress"><div></div></div>').appendTo(bar);

    this._on(this._resetBtn, { click: () => this._reset() });
    this._on(this._playBtn, {
      click: () => {
        if (this._sim.status === 'running') this._action('pause', {}, () => this._sim.stop());
        else this._action('start', {}, () => this._sim.start());
      },
    });
  },

  _buildFields() {
    const table = $('<table class="slx-run-fields">').appendTo(this.element);
    this._inputs = {};

    this._FIELDS.forEach(([label, key, title]) => {
      const row = $('<tr>').attr('title', title).appendTo(table);
      $('<td>').text(label).appendTo(row);
      const cell = $('<td>').appendTo(row);
      const input = $('<input type="text">').appendTo(cell);
      $('<label class="slx-run-unit">').appendTo(cell);
      this._inputs[key] = input;

      // Commit on change, not on every keystroke: half a typed number is a
      // different number, and the run loop reads these live.
      this._on(input, {
        change: () => this._commit(key, input.val()),
        blur: () => this._commit(key, input.val()),
      });
    });
  },

  // ---- actions --------------------------------------------------------

  _load() {
    const model = String(this._path.val()).trim();
    if (!model) return;
    const v = this._demo.val();
    const params = v === 'custom' ? this.options.params : (this._DEMOS[Number(v)].params || '');
    this.options.model = model;

    this._action('load', { model, params }, () => {
      this._sim.load(model, params).catch(() => { /* reported through status */ });
    });
  },

  _reset() {
    this._action('reset', {}, () => {
      this._sim.reset().catch(() => { /* reported through status */ });
    });
  },

  /**
   * Write one setting back to the session. `timeStep` stays a string (it may
   * hold several phases); the rest are numbers, and a value that is not one is
   * refused by putting the old one back rather than by an alert.
   */
  _commit(key, raw) {
    if (key === 'timeStep') {
      this._sim.settings.timeStep = String(raw).trim();
    } else {
      const n = parseFloat(raw);
      if (!isFinite(n)) return this._syncFields();
      this._sim.settings[key] = n;
    }
    return undefined;
  },

  // ---- keeping in step ------------------------------------------------

  _onEvent(e) {
    switch (e.type) {
      case 'status': this._syncStatus(); break;
      case 'settings': this._syncFields(); break;
      case 'progress': this._progress.children().css('width', (e.fraction * 100) + '%'); break;
      default: break;
    }
  },

  _syncAll() {
    this._syncStatus();
    this._syncFields();
  },

  _syncStatus() {
    const sim = this._sim;
    const running = sim.status === 'running';
    const live = !!sim.base;

    this._status
      .toggleClass('slx-run-error', sim.status === 'error')
      .text(this._statusText());

    this._playBtn.prop('disabled', !live)
      .attr('title', running ? 'Pause' : 'Run')
      .find('span')
      .attr('class', running ? 'slx-glyph-pause' : 'slx-glyph-play');
    this._resetBtn.prop('disabled', !live);
    this._unloadBtn.prop('disabled', !live);
    this._loadBtn.prop('disabled', sim.status === 'loading');

    this.element.find('.slx-run-unit').text(sim.unitName);
  },

  _statusText() {
    const sim = this._sim;
    if (sim.status === 'error') return sim.message;
    if (sim.status === 'loading') return sim.message;
    if (!sim.base) return 'No model loaded.';
    const what = sim.modelLink + (sim.params ? ' — ' + sim.params.intMethod : '');
    if (sim.status === 'running') return 'Running ' + what;
    return (sim.message ? sim.message + ' — ' : 'Ready — ') + what;
  },

  _syncFields() {
    const s = this._sim.settings;
    this._FIELDS.forEach(([, key]) => {
      const input = this._inputs[key];
      // Never overwrite the field being typed into: the run loop updates
      // `current` several times a second, and doing so under the cursor would
      // make the other fields unusable while a model runs.
      if (input.is(':focus')) return;
      const v = s[key];
      const text = key === 'timeStep' ? String(v) : this._short(v);
      if (input.val() !== text) input.val(text);
    });
  },

  /** Times are display, not data: six significant figures is plenty. */
  _short(v) {
    const n = Number(v);
    if (!isFinite(n)) return String(v);
    return String(Math.round(n * 1e6) / 1e6);
  },

  _destroy() {
    if (this._unsub) this._unsub();
    this.element.removeClass('slx-run').empty();
  },
});

window.Sienna.widgetRegistry._loaded('runControl', 'runControl');
