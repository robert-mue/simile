/**
 * `sienna.grid` — shows one variable of a spatial-grid submodel as a coloured
 * raster, refreshed as the model runs.
 *
 * ## The one idea worth knowing
 *
 * A 200×300 grid is 60000 numbers. Sent as JSON that is roughly a megabyte per
 * frame, and drawing it as 60000 SVG rects would be slower still. So the values
 * never cross the wire: the target is asked for with `format:'binary'`, and the
 * SERVER scales each value to a 0–255 colour index and LZW-encodes the result —
 * which is to say, it returns the *body of a GIF*, a few hundred bytes.
 *
 * This widget supplies the other half: a GIF header (dimensions plus a 256-entry
 * palette) built locally and cached, so each frame costs one string
 * concatenation and one `img.src` assignment. The browser's own image decoder
 * does the drawing. That is why this stays smooth at 60000 cells where a
 * per-cell DOM could not.
 *
 * Two consequences follow from the server doing the scaling, and both are
 * visible in the UI:
 *
 *   - The **range** (min/max) is part of the *request*, not a display setting.
 *     Changing it changes what the server sends from the next frame on; it
 *     cannot recolour a frame already received.
 *   - The palette here and the `nswat` band count in the request must agree, or
 *     the colour bands land between the palette's steps.
 *
 * Rows arrive bottom-up, hence the vertical flip — the same flip SimiLive
 * applies.
 *
 * Classic script, injected on demand by the widget registry.
 */
$.widget('sienna.grid', $.sienna.widgetBase, {
  options: {
    /** Which colour scheme to start in (a key of `_SCHEMES`). */
    scheme: 'fire',
    /** Displayed pixels per cell. */
    magnification: 2,
    min: 0,
    max: 100,
  },

  /**
   * Colour schemes. `swatches` is an explicit list of bands; `points` is a
   * bottom → middle → top ramp quantised into `bands`. "Fire" is the palette
   * the SimiLive fire-spread demo ships in its `.shf`: an orange for the lowest
   * band (the flame front) and then black up through green.
   */
  _SCHEMES: {
    fire: {
      label: 'fire',
      swatches: ['#ffa500'].concat(
        // black → full green in 16 steps, then green → pale in 16 more. Written
        // out rather than computed because it is data from the demo, not a rule.
        ['#000f00', '#001f00', '#002f00', '#003f00', '#004f00', '#005f00', '#006f00',
          '#007f00', '#008f00', '#009f00', '#00af00', '#00bf00', '#00cf00', '#00df00',
          '#00ef00', '#00ff00', '#0efd07', '#1cfa0f', '#2af716', '#38f41e', '#46f225',
          '#54ef2d', '#62ec34', '#70e93c', '#7fe743', '#8de44b', '#9be152', '#a9de5a',
          '#b7dc61', '#c5d969', '#d3d670', '#e1d378'],
      ),
    },
    heat: { label: 'heat', points: ['#000000', '#ff0000', '#ffffff'], bands: 32 },
    green: { label: 'green', points: ['#000000', '#00ff00', '#ffffff'], bands: 32 },
    grey: { label: 'grey', points: ['#000000', '#808080', '#ffffff'], bands: 32 },
  },

  _create() {
    this.element.addClass('slx-grid');
    this._sim = Sienna.Simulation;
    this._owner = this._panelId() || ('grid' + Math.random().toString(36).slice(2));
    this._spec = null;
    this._geom = null;   // {rows, cols, hex} of the chosen component

    this._buildBar();
    this._buildCanvas();

    this._unsub = this._sim.subscribe((e) => this._onEvent(e));
    this._syncComponents();
    this._syncStatus();
  },

  // ---- construction ---------------------------------------------------

  _buildBar() {
    const bar = $('<div class="slx-palette slx-grid-bar">').appendTo(this.element);

    $('<span class="slx-palette-group">').text('show').appendTo(bar);
    this._pick = $('<select class="slx-grid-pick">').appendTo(bar);

    $('<span class="slx-palette-group">').text('range').appendTo(bar);
    this._min = $('<input type="text" class="slx-grid-num">')
      .attr('title', 'Value shown as the bottom of the scale').val(this.options.min).appendTo(bar);
    this._max = $('<input type="text" class="slx-grid-num">')
      .attr('title', 'Value shown as the top of the scale').val(this.options.max).appendTo(bar);
    const half = $('<button type="button">').attr('title', 'Halve the range').text('÷2').appendTo(bar);
    const dbl = $('<button type="button">').attr('title', 'Double the range').text('×2').appendTo(bar);

    $('<span class="slx-palette-group">').text('colour').appendTo(bar);
    this._scheme = $('<select class="slx-grid-scheme">').appendTo(bar);
    Object.keys(this._SCHEMES).forEach((k) => {
      $('<option>').val(k).text(this._SCHEMES[k].label).appendTo(this._scheme);
    });
    this._scheme.val(this.options.scheme);

    $('<span class="slx-palette-group">').text('zoom').appendTo(bar);
    const out = $('<button type="button">').attr('title', 'Smaller cells').text('−').appendTo(bar);
    const inn = $('<button type="button">').attr('title', 'Bigger cells').text('+').appendTo(bar);
    $('<button type="button">').attr('title', 'Fit the grid to the panel').text('fit')
      .appendTo(bar).on('click', () => this._fit());

    this._on(this._pick, { change: () => this._choose(this._pick.val()) });
    this._on(this._scheme, {
      change: () => {
        this.options.scheme = this._scheme.val();
        this._palette = null;           // forces a new header AND a new spec
        this._register();
      },
    });
    this._on(this._min, { change: () => this._range(parseFloat(this._min.val()), null) });
    this._on(this._max, { change: () => this._range(null, parseFloat(this._max.val())) });
    this._on(half, { click: () => this._scale(0.5) });
    this._on(dbl, { click: () => this._scale(2) });
    this._on(out, { click: () => this._zoom(1 / 2) });
    this._on(inn, { click: () => this._zoom(2) });
  },

  _buildCanvas() {
    this._view = $('<div class="slx-grid-view">').appendTo(this.element);
    this._img = $('<img class="slx-grid-img" alt="">').appendTo(this._view);
    this._note = $('<div class="slx-grid-note">').appendTo(this._view);

    const key = $('<div class="slx-grid-key">').appendTo(this.element);
    this._lowLabel = $('<label>').appendTo(key);
    this._ramp = $('<div class="slx-grid-ramp">').appendTo(key);
    this._highLabel = $('<label>').appendTo(key);
    this._time = $('<label class="slx-grid-time">').appendTo(key);
  },

  // ---- the palette ----------------------------------------------------

  /** '#rrggbb' or Simile's '#rrrrggggbbbb' → [r, g, b]. */
  _rgb(hex) {
    return hex.length > 12
      ? [parseInt(hex.substr(1, 2), 16), parseInt(hex.substr(5, 2), 16), parseInt(hex.substr(9, 2), 16)]
      : [parseInt(hex.substr(1, 2), 16), parseInt(hex.substr(3, 2), 16), parseInt(hex.substr(5, 2), 16)];
  },

  /**
   * The 256-entry palette for the current scheme, plus the band count that the
   * server must be told to quantise to. Cached: it only changes with the scheme.
   */
  _colours() {
    if (this._palette) return this._palette;
    const scheme = this._SCHEMES[this.options.scheme] || this._SCHEMES.fire;
    const map = [];

    if (scheme.swatches) {
      // Each swatch owns an equal slice of the 256 entries.
      const n = scheme.swatches.length;
      for (let i = 0; i < n; i++) {
        const c = this._rgb(scheme.swatches[i]);
        for (let j = Math.floor(i * 256 / n); j < Math.floor((i + 1) * 256 / n); j++) map[j] = c;
      }
      // One fewer band than swatches, which is how Simile's own files are
      // written: the extra swatch is the out-of-range colour at the bottom.
      this._palette = { map, bands: n - 1 };
    } else {
      // bottom → middle over the first half, middle → top over the second,
      // stepped into `bands` flat bands rather than a smooth ramp so that a
      // reader can tell two nearby values apart.
      const n = scheme.bands;
      let lo = null;
      for (let x = 0; x < 3; x++) {
        const hi = this._rgb(scheme.points[x]);
        if (x > 0) {
          for (let j = 0; j < 128; j++) {
            const f = n === 1
              ? x - 1
              : 1 + 2 * Math.floor(n * (j + 128 * (x - 1)) / 256) / (n - 1) - x;
            map.push([
              Math.round(f * hi[0] + (1 - f) * lo[0]),
              Math.round(f * hi[1] + (1 - f) * lo[1]),
              Math.round(f * hi[2] + (1 - f) * lo[2]),
            ]);
          }
        }
        lo = hi;
      }
      this._palette = { map, bands: n };
    }

    this._ramp.css('background', 'linear-gradient(to right, '
      + this._palette.map.filter((c, i) => i % 4 === 0)
        .map((c) => 'rgb(' + c.join(',') + ')').join(',') + ')');
    return this._palette;
  },

  /**
   * The GIF prologue for a grid this size: signature, dimensions, the palette,
   * and an image descriptor — everything up to but not including the pixel
   * data, which is what the server sends. Its length is a multiple of three
   * bytes, so the base64 of the two halves can simply be concatenated.
   */
  _header(cols, rows) {
    const c16 = (v) => String.fromCharCode(v & 0xff, (v >> 8) & 0xff);
    const { map } = this._colours();

    let data = 'GIF89a' + c16(cols) + c16(rows)
      // global colour table present, 8 bits per pixel; no background, square
      // pixels.
      + String.fromCharCode(0xf7, 0, 0);
    for (let i = 0; i < 256; i++) {
      const c = map[i] || [0, 0, 0];
      data += String.fromCharCode(c[0], c[1], c[2]);
    }
    data += String.fromCharCode(0x2c) + c16(0) + c16(0) + c16(cols) + c16(rows)
      + String.fromCharCode(0, 8);   // no local table; LZW minimum code size 8

    return 'data:image/gif;base64,' + window.btoa(data);
  },

  // ---- choosing what to show ------------------------------------------

  _syncComponents() {
    const was = this._pick.val();
    this._pick.empty();
    const candidates = this._sim.gridCandidates();

    if (!candidates.length) {
      $('<option>').val('').text(this._sim.base ? '(no grid variables)' : '(no model loaded)')
        .appendTo(this._pick);
      this._spec = null;
      this._sim.removeTarget(this._owner);
      return;
    }

    $('<option>').val('').text('choose a variable…').appendTo(this._pick);
    candidates.forEach((c) => {
      $('<option>').val(c.id)
        .text(c.label + '  [' + c.rows + (c.cols ? '×' + c.cols : '×?') + ']')
        .appendTo(this._pick);
    });
    this._candidates = {};
    candidates.forEach((c) => { this._candidates[c.id] = c; });

    // A reload of the same model should not lose the user's choice.
    if (was && this._candidates[was]) this._pick.val(was);
    else this._choose('');
  },

  _choose(id) {
    const c = id && this._candidates ? this._candidates[id] : null;
    if (!c) {
      this._geom = null;
      this._spec = null;
      this._sim.removeTarget(this._owner);
      this._img.removeAttr('src');
      this._syncStatus();
      return;
    }

    if (!c.cols) {
      // Simile could not tell us the width. Rather than guess an aspect ratio
      // and draw a plausible-looking lie, ask.
      const answer = window.prompt(
        'How many columns has this grid?\n\n'
        + c.label + ' has ' + c.rows + ' cells in all; Simile does not record '
        + 'how they are laid out.', '');
      const cols = parseInt(answer, 10);
      if (!cols || c.rows % cols) {
        this._say(answer == null ? '' : 'That does not divide ' + c.rows + ' cells evenly.');
        this._pick.val('');
        return;
      }
      this._geom = { rows: c.rows / cols, cols, hex: c.hex };
    } else {
      this._geom = { rows: c.rows, cols: c.cols, hex: c.hex };
    }

    this._node = c.id;
    this._headerFor = null;
    this._register();
  },

  /**
   * Build the request spec and register it, then fetch one frame so the grid
   * shows something without waiting for the model to be run.
   */
  _register() {
    if (!this._node || !this._geom) return;
    const { bands } = this._colours();

    // Property order matters: the reply is keyed by this object's JSON.
    this._spec = {
      format: 'binary',
      node: this._node,
      bottom: Number(this.options.min),
      top: Number(this.options.max),
      nswat: bands,
      hex: this._geom.hex,
    };

    // The GIF is twice as wide for a honeycomb — each hexagon is drawn as two
    // half-width columns, offset row by row — and squashed back by CSS.
    const gifCols = this._geom.hex ? this._geom.cols * 2 : this._geom.cols;
    this._headerFor = this._header(gifCols, this._geom.rows);
    this._resize();

    this._sim.addTarget(this._owner, this._spec);
    this._syncStatus();

    if (!this._sim.base) return;
    const spec = this._spec;
    this._sim.query([spec]).then((values) => {
      // Ignore a reply that arrived after the user moved on.
      if (this._spec === spec) this._paint(values[Sienna.Simulation.keyOf(spec)]);
    }).catch((err) => this._say(err.message || String(err)));
  },

  // ---- range and zoom --------------------------------------------------

  _range(min, max) {
    if (min != null && isFinite(min)) this.options.min = min;
    if (max != null && isFinite(max)) this.options.max = max;
    this._min.val(this.options.min);
    this._max.val(this.options.max);
    this._register();
  },

  /** Grow or shrink the range about its bottom, which is usually zero. */
  _scale(factor) {
    const bottom = Number(this.options.min);
    this._range(null, bottom + (Number(this.options.max) - bottom) * factor);
  },

  _zoom(factor) {
    this.options.magnification = Math.max(0.25, Math.min(32, this.options.magnification * factor));
    this._resize();
  },

  _fit() {
    if (!this._geom) return;
    const box = this._view[0].getBoundingClientRect();
    if (!box.width || !box.height) return;
    this.options.magnification = Math.max(0.25, Math.min(
      box.width / this._geom.cols, box.height / this._geom.rows));
    this._resize();
  },

  _resize() {
    if (!this._geom) return;
    const m = this.options.magnification;
    this._img.css({
      width: (this._geom.cols * m) + 'px',
      height: (this._geom.rows * m) + 'px',
    });
  },

  // ---- painting --------------------------------------------------------

  _paint(body) {
    if (!body || !this._headerFor) return;
    this._img.attr('src', this._headerFor + body);
    this._note.text('');
  },

  _onEvent(e) {
    switch (e.type) {
      case 'describe':
        this._syncComponents();
        break;
      case 'data': {
        if (!this._spec) break;
        const v = e.values[Sienna.Simulation.keyOf(this._spec)];
        if (v != null) this._paint(v);
        this._time.text('t = ' + Math.round(e.time * 1e4) / 1e4 + ' ' + this._sim.unitName);
        break;
      }
      case 'status':
        if (!this._sim.base) {
          this._img.removeAttr('src');
          this._syncComponents();
        }
        this._syncStatus();
        break;
      default: break;
    }
  },

  _syncStatus() {
    this._lowLabel.text(Number(this.options.min).toPrecision(3));
    this._highLabel.text(Number(this.options.max).toPrecision(3));
    this._colours();  // makes sure the legend ramp matches the scheme
    if (!this._sim.base) this._say('Load a model in a Run control panel.');
    else if (!this._spec) this._say('Choose a variable to show.');
    else this._say('');
  },

  _say(text) {
    this._note.text(text);
  },

  _destroy() {
    if (this._unsub) this._unsub();
    this._sim.removeTarget(this._owner);
    this.element.removeClass('slx-grid').empty();
  },

  /** View state: what this panel is showing, so a reload brings it back. */
  state() {
    return {
      scheme: this.options.scheme,
      magnification: this.options.magnification,
      min: this.options.min,
      max: this.options.max,
    };
  },
});

window.Sienna.widgetRegistry._loaded('grid', 'grid');
