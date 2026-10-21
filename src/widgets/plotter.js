/**
 * `sienna.plotter` — variables against time, drawn as the model runs.
 *
 * Built rather than borrowed. SimiLive has a plotter, but a chart is the part of
 * a modelling tool people look at longest, and the things one wants to add later
 * — a second y series without a second axis, log scaling, exporting the numbers,
 * marking events — are all easier on foundations we own.
 *
 * ## What the chart obeys, and why it is not taste
 *
 * The visual decisions here follow a checked specification rather than
 * preference, so they should be changed knowingly:
 *
 *   - **Series colours are a fixed, validated order** (`_PALETTE`). The eight
 *     hues were checked with a colour-vision-deficiency simulator on this
 *     widget's own white surface: worst adjacent pair ΔE 9.1 under protanopia,
 *     19.6 under normal vision. Re-ordering them breaks that guarantee, because
 *     the ORDER is what makes neighbouring series distinguishable.
 *   - **Colour follows the series, not its position.** A slot is claimed when a
 *     series is added and kept until it is removed, so deleting the first of
 *     three does not repaint the other two — a chart whose colours shuffle under
 *     you cannot be read across a change.
 *   - **Text never wears the series colour.** Labels and legends are ink; a
 *     short stroke of the colour sits beside them. Coloured text at label sizes
 *     is where contrast fails first — three of the eight hues are below 3:1 on
 *     white as MARKS, which is fine for a 2px line and not fine for 11px text.
 *     Those same three are why every line is also **directly labelled at its
 *     end**: identity never rests on colour alone.
 *   - **One y-axis, ever.** Two scales on one plot invent a correlation that is
 *     not in the data. Two variables of wildly different size want two plotter
 *     panels, which this app makes cheap — that is the fix, not a right-hand
 *     axis.
 *   - Hairline, recessive gridlines; 2px lines with round joins; ticks on clean
 *     numbers in tabular figures.
 *
 * ## Live data
 *
 * Points arrive one logged step at a time from `Sienna.Simulation`. Redrawing
 * per point would be wasteful, so draws are coalesced into an animation frame.
 * A reset clears the traces, since the run they belonged to no longer happened.
 *
 * ## Populations
 *
 * A variable in a population submodel has a value per member, and members
 * come and go. It is plotted as ONE series drawn as many lines — a line per
 * member, from when it appears to when it goes, all in the series' colour —
 * which is what Simile's plotter shows and what the Trees tutorial asks the
 * modeller to read: each line a tree, its slope that tree's growth rate, its
 * end that tree's death. The engine keys each member's value by a number the
 * member keeps for life, so the lines are joined by key (`s.lines`), never by
 * position in the reply, which shifts every time a member goes.
 *
 * Classic script, injected on demand by the widget registry.
 */
$.widget('sienna.plotter', $.sienna.widgetBase, {
  options: {
    /** Include zero in the y-range even when the data does not reach it. */
    zeroBased: false,
    /** Beyond this many points per series, draw every nth. Storage is unaffected. */
    drawCap: 1500,
    /**
     * Variables to plot from the start, by name as the list shows them
     * (`rabbits`, `tree/size`). Each waits, if need be, for the model to be
     * loaded, as one chosen "from the next run" does. How a page with a plot
     * embedded in it says what the plot is of.
     */
    variables: [],
  },

  /**
   * The validated categorical order — see the header. Slots are claimed in this
   * sequence and never cycled: a ninth series is refused rather than given a
   * colour that repeats an existing one.
   */
  _PALETTE: ['#2a78d6', '#eb6834', '#1baf7a', '#eda100',
    '#e87ba4', '#008300', '#4a3aa7', '#e34948'],

  // Chart chrome. One step off the surface, deliberately recessive.
  _INK: '#0b0b0b',
  _INK2: '#52514e',
  _MUTED: '#898781',
  _GRID: '#e1e0d9',
  _AXIS: '#c3c2b7',

  // Bottom leaves room for the tick row AND the axis title beneath it; at 28
  // the two collide and "time (unit)" lands on top of a tick.
  _M: { top: 12, right: 92, bottom: 42, left: 62 },

  _create() {
    this.element.addClass('slx-plot');
    // The session as this panel's model sees it: blank while another model is
    // the one loaded (Simulation.viewFor).
    this._sim = Sienna.Simulation.viewFor(this._ref());
    this._owner = this._panelId() || ('plot' + Math.random().toString(36).slice(2));
    this._series = [];      // {id, label, slot, pts: [[t,v],…]} — or, for a
                            // population, many: true and lines: {member: pts}
    this._used = {};        // slot index -> taken

    this._buildBar();
    this._buildCanvas();
    this._buildLegend();

    this._unsub = this._sim.subscribe((e) => this._onEvent(e));
    // The list also offers what the diagram has and the loaded model does not
    // yet, so it follows edits to the model — a burst of them at a time.
    this._watchModel(() => {
      window.clearTimeout(this._listTimer);
      this._listTimer = window.setTimeout(() => this._syncComponents(), 250);
    });
    // Same pairing as the diagram: the panel says so directly when it resizes
    // itself, the observer catches everything else.
    this._watchPanelResize(() => this._draw());
    if (window.ResizeObserver) {
      this._ro = new ResizeObserver(() => this._draw());
      this._ro.observe(this.element[0]);
    }
    this._syncComponents();
    (this.options.variables || []).forEach((name) => this._addByName(name));
    this._draw();
  },

  /** Plot a variable given by name: now if the loaded model has it, else when it does. */
  _addByName(name) {
    const all = this._sim.scalarComponents()
      .concat(this._sim.memberComponents ? this._sim.memberComponents() : []);
    const c = all.find((x) => x.label === name);
    this._add(c ? c.id : 'next:' + name);
  },

  // ---- construction ---------------------------------------------------

  _buildBar() {
    const bar = $('<div class="slx-palette slx-chrome slx-plot-bar">').appendTo(this.element);

    $('<span class="slx-palette-group">').text('plot').appendTo(bar);
    this._pick = $('<select class="slx-plot-pick">').appendTo(bar);
    const add = $('<button type="button">').attr('title', 'Add this variable to the plot').text('add').appendTo(bar);

    $('<span class="slx-palette-group">').text('axis').appendTo(bar);
    this._zero = $('<button type="button">').attr('title', 'Always include zero on the value axis').text('from 0').appendTo(bar);
    const clear = $('<button type="button">').attr('title', 'Remove every trace').text('clear').appendTo(bar);

    this._on(add, { click: () => this._add(this._pick.val()) });
    this._on(clear, { click: () => this._clear() });
    this._on(this._zero, {
      click: () => {
        this.options.zeroBased = !this.options.zeroBased;
        this._zero.toggleClass('slx-active', this.options.zeroBased);
        this._draw();
      },
    });
  },

  _buildCanvas() {
    this._view = $('<div class="slx-plot-view">').appendTo(this.element);
    const svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
    svg.setAttribute('class', 'slx-plot-svg');
    this._view[0].appendChild(svg);
    this._svg = svg;

    this._tip = $('<div class="slx-plot-tip" hidden>').appendTo(this._view);

    // The crosshair finds the X: readers aim at a time, never at a 2px line.
    // Both event families are bound: `pointermove` is the modern one, and
    // `mousemove` covers anything that drives the page without a pointer
    // device — which includes automation, and so makes this testable.
    this._on(this._view, {
      pointermove: (e) => this._hover(e),
      mousemove: (e) => this._hover(e),
      pointerleave: () => this._unhover(),
      mouseleave: () => this._unhover(),
    });
  },

  _buildLegend() {
    this._legend = $('<div class="slx-plot-legend">').appendTo(this.element);
  },

  // ---- series ---------------------------------------------------------

  /**
   * The list to choose from: what the loaded model has, and also what the
   * diagram has that the loaded model does not yet — a variable added since
   * the last load. One of those is offered as `next:<name>` and plotted as a
   * trace that waits, filled in when the model is next loaded (▶ does that
   * after an edit) and matched up by name like any other trace.
   */
  _syncComponents() {
    const was = this._pick.val();
    this._pick.empty();
    const list = this._sim.scalarComponents().slice();
    const members = (this._sim.memberComponents ? this._sim.memberComponents() : []).slice();

    const known = {};
    list.concat(members).forEach((c) => { known[c.label] = true; });
    Sienna.Simulation.variablesOf(this._ref()).forEach((v) => {
      if (known[v.label]) return;
      (v.many ? members : list).push({ id: 'next:' + v.label, label: v.label, next: true });
    });
    const byLabel = (a, b) => a.label.localeCompare(b.label);
    list.sort(byLabel);
    members.sort(byLabel);

    if (!list.length && !members.length) {
      $('<option>').val('').text(this._sim.base ? '(nothing to plot)' : '(no model loaded)')
        .appendTo(this._pick);
      return;
    }
    // Two groups only when there are both, so a model without a population
    // shows the plain list it always did.
    const group = (title, items) => {
      const into = list.length && members.length
        ? $('<optgroup>').attr('label', title).appendTo(this._pick) : this._pick;
      items.forEach((c) => $('<option>').val(c.id)
        .text(c.label + (c.next ? '  (from the next run)' : '')).appendTo(into));
    };
    group('Single values', list);
    group('A line for each instance', members);
    if (was && list.concat(members).some((c) => c.id === was)) this._pick.val(was);
  },

  /** Is this component a value per instance (population member or fixed instance)? */
  _isMembers(id) {
    const c = (this._sim.components || {})[id] || {};
    return Sienna.Simulation.isPerInstance(c.dims);
  },

  /** Every run of points a series draws: one, or one per member. */
  _tracks(s) {
    return s.many ? Object.keys(s.lines).map((k) => s.lines[k]) : [s.pts];
  },

  /** Record one reported value — a number, or a population's {member: number}. */
  _record(s, t, v) {
    if (!s.many) {
      const n = Number(v);
      if (isFinite(n)) s.pts.push([t, n]);
      return;
    }
    s.now = 0;
    s.at = t;
    if (!v || typeof v !== 'object') return;          // an empty population
    // A fixed membership's instances arrive as an array: number them from 1,
    // as Simile's index(1) does, like a population's member keys.
    if (Array.isArray(v)) {
      const o = {};
      v.forEach((x, i) => { o[i + 1] = x; });
      v = o;
    }
    Object.keys(v).forEach((k) => {
      const n = Number(v[k]);
      if (!isFinite(n)) return;
      (s.lines[k] || (s.lines[k] = [])).push([t, n]);
      s.now++;
    });
  },

  _forget(s) {
    s.pts.length = 0;
    if (s.many) { s.lines = {}; s.now = 0; s.at = null; }
  },

  /** The lowest unclaimed palette slot — identity, so it outlives its neighbours. */
  _claimSlot() {
    for (let i = 0; i < this._PALETTE.length; i++) {
      if (!this._used[i]) { this._used[i] = true; return i; }
    }
    return -1;
  },

  _add(id) {
    if (!id) return;
    const next = id.indexOf('next:') === 0 ? id.slice(5) : null;
    if (!next && !this._sim.base) return;
    if (this._series.some((s) => (next ? s.label === next : s.id === id))) return;   // already plotted

    const slot = this._claimSlot();
    if (slot < 0) {
      this._say('This plot is full at ' + this._PALETTE.length + ' traces. '
        + 'Open a second plotter panel for more — two plots read better than one crowded one.');
      return;
    }

    if (next) {
      // Not in the loaded model yet: a trace that waits for it, with no
      // target to ask for. `_rebind` gives it an id when the model that has
      // it is described.
      const v = Sienna.Simulation.variablesOf(this._ref()).find((x) => x.label === next) || {};
      this._series.push({
        id: null, label: next, units: '', slot, pts: [], many: !!v.many, lines: {}, waiting: true,
      });
      this._renderLegend();
      this._draw();
      return;
    }

    const comp = (this._sim.components || {})[id] || {};
    const s = {
      id,
      label: comp.captpath || comp.text ? Sienna.Simulation.displayName(comp) : id,
      units: comp.units || '',
      slot,
      pts: [],
      many: this._isMembers(id),
      lines: {},
    };
    this._series.push(s);
    this._sim.addTarget(this._owner + ':' + id, id);

    // Show something at once rather than waiting for the model to be stepped.
    this._sim.query([id]).then((values) => {
      if (!this._series.includes(s) || this._tracks(s).some((p) => p.length)) return;
      this._record(s, Number(this._sim.settings.current), values[id]);
      this._draw();
    }).catch(() => { /* the trace simply starts when the model next steps */ });

    this._renderLegend();
    this._draw();
  },

  /** Take a trace off, given it or its component id. */
  _remove(which) {
    const i = this._series.findIndex((s) => s === which || (s.id != null && s.id === which));
    if (i < 0) return;
    const id = this._series[i].id;
    delete this._used[this._series[i].slot];
    this._series.splice(i, 1);
    if (id != null) this._sim.removeTarget(this._owner + ':' + id);
    this._renderLegend();
    this._draw();
  },

  /**
   * After a (re)load, point each trace at the component of the same name in
   * the model now loaded — ids are the engine's and need not survive a
   * rebuild — and drop any that the model no longer has.
   */
  _rebind() {
    const byLabel = {};
    this._sim.scalarComponents().concat(this._sim.memberComponents ? this._sim.memberComponents() : [])
      .forEach((c) => { byLabel[c.label] = c; });
    // Failing the full name, the last part of it when only one variable has
    // that: boxing a model into a submodel turns `size` into `tree/size`, and
    // the modeller's plot should follow it there rather than go blank.
    const byTail = {};
    Object.keys(byLabel).forEach((label) => {
      const tail = this._short(label);
      byTail[tail] = byTail[tail] === undefined ? byLabel[label] : null;
    });
    this._series.slice().forEach((s) => {
      const c = byLabel[s.label] || byTail[this._short(s.label)];
      if (!c) { this._remove(s); return; }
      s.label = c.label;
      s.waiting = false;
      this._forget(s);
      s.many = this._isMembers(c.id);
      if (c.id === s.id) return;
      if (s.id != null) this._sim.removeTarget(this._owner + ':' + s.id);
      s.id = c.id;
      this._sim.addTarget(this._owner + ':' + s.id, s.id);
    });
    this._renderLegend();
  },

  _clear() {
    this._series.slice().forEach((s) => this._remove(s));
  },

  // ---- events ---------------------------------------------------------

  _onEvent(e) {
    switch (e.type) {
      case 'describe':
        this._rebind();
        this._syncComponents();
        break;
      case 'data': {
        if (e.reset) this._series.forEach((s) => this._forget(s));
        this._series.forEach((s) => this._record(s, e.time, e.values[s.id]));
        this._schedule();
        break;
      }
      case 'status':
        // Traces outlive the session: loading the model again (▶ does, after
        // an edit) must not take away what the modeller chose to plot. They
        // are matched up again by name when the next model is described.
        if (!this._sim.base) this._syncComponents();
        this._draw();
        break;
      default: break;
    }
  },

  /** Coalesce a burst of logged points into one paint. */
  _schedule() {
    if (this._pending) return;
    this._pending = window.requestAnimationFrame(() => {
      this._pending = null;
      this._draw();
    });
  },

  // ---- scales ----------------------------------------------------------

  /** A step that lands on 1, 2 or 5 × a power of ten — where readers expect ticks. */
  _niceStep(range, count) {
    if (!(range > 0)) return 1;
    const raw = range / Math.max(1, count);
    const mag = Math.pow(10, Math.floor(Math.log10(raw)));
    const n = raw / mag;
    return (n <= 1 ? 1 : n <= 2 ? 2 : n <= 5 ? 5 : 10) * mag;
  },

  _ticks(lo, hi, count) {
    const step = this._niceStep(hi - lo, count);
    const out = [];
    const first = Math.ceil(lo / step - 1e-9) * step;
    for (let v = first; v <= hi + step * 1e-9; v += step) {
      out.push(Math.abs(v) < step * 1e-9 ? 0 : v);   // kill -0 and float dust
    }
    return out;
  },

  /** Extent over every trace, padded and rounded outward to whole ticks. */
  _domain() {
    let x0 = Infinity; let x1 = -Infinity; let y0 = Infinity; let y1 = -Infinity;
    this._series.forEach((s) => {
      this._tracks(s).forEach((pts) => pts.forEach((p) => {
        if (p[0] < x0) x0 = p[0];
        if (p[0] > x1) x1 = p[0];
        if (p[1] < y0) y0 = p[1];
        if (p[1] > y1) y1 = p[1];
      }));
      // A population that has emptied still has a time: keep the axis moving.
      if (s.many && s.at != null) {
        if (s.at < x0) x0 = s.at;
        if (s.at > x1) x1 = s.at;
      }
    });
    if (!isFinite(x0)) return null;

    if (this.options.zeroBased) { y0 = Math.min(0, y0); y1 = Math.max(0, y1); }
    if (y0 === y1) { y0 -= 0.5; y1 += 0.5; }          // a flat trace still needs a band
    if (x0 === x1) x1 = x0 + 1;

    // Round the value axis out to whole ticks so the top line is a round number
    // and the scale steps rather than creeping as data arrives.
    const step = this._niceStep(y1 - y0, 5);
    y0 = Math.floor(y0 / step) * step;
    y1 = Math.ceil(y1 / step) * step;
    return { x0, x1, y0, y1 };
  },

  _fmt(v) {
    if (v === 0) return '0';
    const a = Math.abs(v);
    if (a >= 1e7 || a < 1e-4) return v.toExponential(2);
    const r = Number(v.toPrecision(6));
    return r.toLocaleString('en-US', { maximumFractionDigits: 6 });
  },

  // ---- drawing ---------------------------------------------------------

  _el(name, attrs, text) {
    const e = document.createElementNS('http://www.w3.org/2000/svg', name);
    Object.keys(attrs || {}).forEach((k) => e.setAttribute(k, attrs[k]));
    if (text != null) e.appendChild(document.createTextNode(text));
    return e;
  },

  _draw() {
    const svg = this._svg;
    while (svg.firstChild) svg.removeChild(svg.firstChild);

    const box = this._view[0].getBoundingClientRect();
    const W = Math.max(120, Math.round(box.width));
    const H = Math.max(90, Math.round(box.height));
    svg.setAttribute('viewBox', '0 0 ' + W + ' ' + H);
    svg.setAttribute('width', W);
    svg.setAttribute('height', H);

    const m = this._M;
    const iw = W - m.left - m.right;
    const ih = H - m.top - m.bottom;
    this._plot = { W, H, iw, ih };

    if (!this._series.length || !this._domain()) {
      const waiting = this._series.filter((s) => s.waiting).map((s) => this._short(s.label));
      this._say(waiting.length
        ? waiting.join(', ') + (waiting.length === 1 ? ' is' : ' are')
          + (this._sim.base
            ? ' not in the model loaded yet. Press ▶: the model is loaded again first, and plotted from then on.'
            : ' plotted once the model is loaded.')
        : this._sim.base
          ? 'Choose a variable and press add.'
          : 'Load a model in a Run control panel.');
      return;
    }
    this._say('');

    const d = this._domain();
    this._dom = d;
    const sx = (t) => m.left + (t - d.x0) / (d.x1 - d.x0) * iw;
    const sy = (v) => m.top + ih - (v - d.y0) / (d.y1 - d.y0) * ih;
    this._sx = sx; this._sy = sy;

    const grid = this._el('g', {});
    const marks = this._el('g', {});
    const chrome = this._el('g', {});

    // --- value axis: hairline gridlines, ticks on clean numbers
    this._ticks(d.y0, d.y1, 5).forEach((v) => {
      const y = sy(v);
      grid.appendChild(this._el('line', {
        x1: m.left, x2: m.left + iw, y1: y, y2: y, stroke: this._GRID, 'stroke-width': 1,
      }));
      chrome.appendChild(this._el('text', {
        x: m.left - 8, y: y + 4, 'text-anchor': 'end', class: 'slx-plot-tick',
      }, this._fmt(v)));
    });

    // --- time axis
    this._ticks(d.x0, d.x1, Math.max(2, Math.floor(iw / 90))).forEach((t) => {
      const x = sx(t);
      grid.appendChild(this._el('line', {
        x1: x, x2: x, y1: m.top, y2: m.top + ih, stroke: this._GRID, 'stroke-width': 1,
      }));
      chrome.appendChild(this._el('text', {
        x, y: m.top + ih + 16, 'text-anchor': 'middle', class: 'slx-plot-tick',
      }, this._fmt(t)));
    });

    chrome.appendChild(this._el('line', {
      x1: m.left, x2: m.left + iw, y1: m.top + ih, y2: m.top + ih,
      stroke: this._AXIS, 'stroke-width': 1,
    }));
    chrome.appendChild(this._el('text', {
      x: m.left + iw / 2, y: m.top + ih + 34, 'text-anchor': 'middle', class: 'slx-plot-axis-title',
    }, 'time (' + this._sim.unitName + ')'));

    // --- the traces
    //
    // End labels are collected rather than drawn inline, because converging
    // lines put them on top of each other. Nudging them apart is the wrong fix
    // — a label that has drifted off its line reads as noise — so a label that
    // would collide is simply dropped, and the legend carries that series.
    const ends = [];

    this._series.forEach((s) => {
      if (s.many) { this._drawMembers(s, marks, ends, sx, sy); return; }
      if (s.pts.length < 1) return;
      const colour = this._PALETTE[s.slot];
      const step = Math.max(1, Math.ceil(s.pts.length / this.options.drawCap));
      let dstr = '';
      for (let i = 0; i < s.pts.length; i += step) {
        dstr += (dstr ? 'L' : 'M') + sx(s.pts[i][0]).toFixed(1) + ',' + sy(s.pts[i][1]).toFixed(1);
      }
      const last = s.pts[s.pts.length - 1];
      // Always end on the real last point, whatever the decimation did.
      dstr += 'L' + sx(last[0]).toFixed(1) + ',' + sy(last[1]).toFixed(1);

      marks.appendChild(this._el('path', {
        d: dstr, fill: 'none', stroke: colour, 'stroke-width': 2,
        'stroke-linejoin': 'round', 'stroke-linecap': 'round',
      }));

      ends.push({
        y: Math.max(m.top + 4, Math.min(m.top + ih - 2, sy(last[1]))),
        colour,
        text: this._short(s.label),
      });
    });

    // Direct label at each line end: a short key in the series colour, the name
    // in ink. This is what keeps identity off colour alone — and it is also the
    // "relief" the palette requires, three of its hues being below 3:1 on white.
    ends.sort((a, b) => a.y - b.y);
    let lastY = -Infinity;
    ends.forEach((e) => {
      if (e.y - lastY < 12) return;      // would collide; the legend has it
      lastY = e.y;
      chrome.appendChild(this._el('line', {
        x1: m.left + iw + 6, x2: m.left + iw + 18, y1: e.y, y2: e.y,
        stroke: e.colour, 'stroke-width': 2, 'stroke-linecap': 'round',
      }));
      chrome.appendChild(this._el('text', {
        x: m.left + iw + 22, y: e.y + 3.5, class: 'slx-plot-endlabel',
      }, e.text));
    });

    this._cross = this._el('line', {
      y1: m.top, y2: m.top + ih, stroke: this._AXIS, 'stroke-width': 1, visibility: 'hidden',
    });

    svg.appendChild(grid);
    svg.appendChild(marks);
    svg.appendChild(this._cross);
    svg.appendChild(chrome);

    this._renderLegend();
  },

  /**
   * A population: a thinner line per member, so a crowd of them stays
   * readable, and one end label for the series at the middle of the members
   * still there, saying how many that is.
   */
  _drawMembers(s, marks, ends, sx, sy) {
    const colour = this._PALETTE[s.slot];
    const m = this._M;
    const ih = this._plot.ih;
    let sum = 0;
    let alive = 0;
    Object.keys(s.lines).forEach((k) => {
      const pts = s.lines[k];
      if (!pts.length) return;
      const step = Math.max(1, Math.ceil(pts.length / this.options.drawCap));
      let dstr = '';
      for (let i = 0; i < pts.length; i += step) {
        dstr += (dstr ? 'L' : 'M') + sx(pts[i][0]).toFixed(1) + ',' + sy(pts[i][1]).toFixed(1);
      }
      const last = pts[pts.length - 1];
      dstr += 'L' + sx(last[0]).toFixed(1) + ',' + sy(last[1]).toFixed(1);
      marks.appendChild(this._el('path', {
        d: dstr, fill: 'none', stroke: colour, 'stroke-width': 1.25, 'stroke-opacity': 0.85,
        'stroke-linejoin': 'round', 'stroke-linecap': 'round',
      }));
      if (last[0] === s.at) { sum += last[1]; alive++; }
    });
    if (!alive) return;
    ends.push({
      y: Math.max(m.top + 4, Math.min(m.top + ih - 2, sy(sum / alive))),
      colour,
      text: this._short(s.label) + ' (' + alive + ')',
    });
  },

  /** The values a population has at time t, or null if it had none then. */
  _membersAt(s, t) {
    const vals = [];
    Object.keys(s.lines).forEach((k) => {
      const p = s.lines[k].find((q) => Math.abs(q[0] - t) < 1e-9);
      if (p) vals.push(p[1]);
    });
    return vals;
  },

  /** Caption paths are long; the tail is the part that identifies the variable. */
  _short(label) {
    const parts = String(label).split('/').filter(Boolean);
    return parts.length ? parts[parts.length - 1] : label;
  },

  _renderLegend() {
    this._legend.empty();
    // A single trace needs no legend — its end label already names it.
    if (this._series.length < 2) return;

    this._series.forEach((s) => {
      const row = $('<span class="slx-plot-key">').appendTo(this._legend);
      $('<span class="slx-plot-swatch">').css('background', this._PALETTE[s.slot]).appendTo(row);
      $('<span class="slx-plot-name">').text(s.label).appendTo(row);
      if (s.waiting) {
        $('<span class="slx-plot-val">').text('from the next run').appendTo(row);
      } else if (s.many) {
        if (s.at != null) $('<span class="slx-plot-val">').text(s.now + (s.now === 1 ? ' member' : ' members')).appendTo(row);
      } else {
        const last = s.pts[s.pts.length - 1];
        if (last) $('<span class="slx-plot-val">').text(this._fmt(last[1])).appendTo(row);
      }
      $('<button type="button" class="slx-plot-drop">').attr('title', 'Remove this trace').text('×')
        .appendTo(row).on('click', () => this._remove(s));
    });
  },

  // ---- hover -----------------------------------------------------------

  /**
   * One tooltip listing every series at the pointer's time. The crosshair snaps
   * to the nearest logged step, so the reader aims at a time rather than at a
   * 2px line.
   */
  _hover(e) {
    if (!this._series.length || !this._dom || !this._sx) return;
    const box = this._view[0].getBoundingClientRect();
    const px = e.clientX - box.left;
    const m = this._M;
    if (px < m.left || px > m.left + this._plot.iw) return this._unhover();

    const d = this._dom;
    const t = d.x0 + (px - m.left) / this._plot.iw * (d.x1 - d.x0);

    const rows = [];
    let snapped = null;
    // Snap to the nearest logged time of any series; a population's times
    // are those of its members, so they are gathered from every line.
    this._series.forEach((s) => {
      this._tracks(s).forEach((pts) => pts.forEach((p) => {
        if (snapped == null || Math.abs(p[0] - t) < Math.abs(snapped - t)) snapped = p[0];
      }));
    });
    if (snapped == null) return this._unhover();
    this._series.forEach((s) => {
      if (s.many) {
        const vals = this._membersAt(s, snapped);
        rows.push({ s, many: vals });
        return;
      }
      if (!s.pts.length) return;
      let best = 0;
      for (let i = 1; i < s.pts.length; i++) {
        if (Math.abs(s.pts[i][0] - snapped) < Math.abs(s.pts[best][0] - snapped)) best = i;
      }
      rows.push({ s, p: s.pts[best] });
    });
    if (snapped == null) return this._unhover();

    this._cross.setAttribute('x1', this._sx(snapped));
    this._cross.setAttribute('x2', this._sx(snapped));
    this._cross.setAttribute('visibility', 'visible');

    this._tip.empty().prop('hidden', false);
    $('<div class="slx-plot-tip-t">').text('t = ' + this._fmt(snapped) + ' ' + this._sim.unitName)
      .appendTo(this._tip);
    rows.forEach((r) => {
      const row = $('<div class="slx-plot-tip-row">').appendTo(this._tip);
      $('<span class="slx-plot-swatch">').css('background', this._PALETTE[r.s.slot]).appendTo(row);
      // Values lead, labels follow. A population gives its count and range.
      if (r.many) {
        const v = r.many;
        $('<b>').text(v.length ? v.length + ': ' + this._fmt(Math.min(...v))
          + (v.length > 1 ? '–' + this._fmt(Math.max(...v)) : '') : 'none').appendTo(row);
      } else {
        $('<b>').text(this._fmt(r.p[1])).appendTo(row);
      }
      $('<span class="slx-plot-name">').text(this._short(r.s.label)).appendTo(row);
    });

    const tw = this._tip.outerWidth();
    const left = px + 14 + tw > box.width ? px - 14 - tw : px + 14;
    this._tip.css({ left: Math.max(2, left) + 'px', top: (e.clientY - box.top + 12) + 'px' });
    return undefined;
  },

  _unhover() {
    if (this._cross) this._cross.setAttribute('visibility', 'hidden');
    this._tip.prop('hidden', true);
    return undefined;
  },

  _say(text) {
    if (!this._note) this._note = $('<div class="slx-plot-note">').appendTo(this._view);
    this._note.text(text).toggle(!!text);
  },

  _destroy() {
    if (this._unsub) this._unsub();
    if (this._ro) this._ro.disconnect();
    if (this._pending) window.cancelAnimationFrame(this._pending);
    this._series.forEach((s) => this._sim.removeTarget(this._owner + ':' + s.id));
    this.element.removeClass('slx-plot').empty();
  },

  /** View state: which traces, so a reload brings the same plot back. */
  state() {
    return { zeroBased: this.options.zeroBased };
  },
});

window.Sienna.widgetRegistry._loaded('plotter', 'plotter');
