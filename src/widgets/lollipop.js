/**
 * `sienna.lollipop` — the members of a population drawn as lollipops standing
 * on a gridded patch of ground, refreshed as the model runs.
 *
 * Simile's "Lollipop diagram" helper, rebuilt (help/run/tools/lollipop.htm).
 * It is the standard way of showing many individuals at once, because one
 * picture carries three things about each: where it is (x, y), and how big it
 * is (the stick's height and the size of the ball together) — and, for trees,
 * it looks like what it shows. The Trees tutorial's last stage is built on it.
 *
 * ## What it needs
 *
 * Three variables with a value per member of the SAME population (Simulation
 * `memberComponents`): x, y and size, chosen in that order as Simile asks.
 * Where the model has variables called `x`, `y` and `size` they are chosen
 * already. A member is drawn when all three have a value for it; the engine
 * keys values by member, so the three are matched by key, not by position.
 *
 * ## The picture
 *
 * The ground is viewed from a point on a sphere around it, set by two sliders
 * as Simile's are — **turn** (Simile's "view angle", round the vertical) and
 * **tilt** (its "view elevation", from level to overhead) — or by dragging
 * across the picture. The projection is orthographic, not perspective: a tree
 * at the back is drawn the same size as one at the front, so sizes can be
 * compared anywhere on the ground, which is the point of the display.
 *
 *   - A stick's height is the size, in the ground's own units, and the ball's
 *     radius a third of it, as Simile's do: "size … used to calculate both the
 *     length of the trunk and branches". For best results Simile's help asks
 *     for x and y in 0–100 and sizes under 25; the ground here is 0–100 unless
 *     the data reaches further, when it grows to the next ten — it never
 *     shrinks back mid-run, so the picture does not jump about.
 *   - Members are drawn from the back forwards, so nearer ones cover further
 *     ones, as they would.
 *   - The scale fits the ground and the tallest member seen so far into the
 *     panel, and likewise only grows during a run.
 *
 * Classic script, injected on demand by the widget registry.
 */
$.widget('sienna.lollipop', $.sienna.widgetBase, {
  options: {
    /** The chosen variables, by display name — names survive a model reload, ids do not. */
    x: '',
    y: '',
    size: '',
    /** Degrees round the vertical; 0 looks along the y axis. */
    turn: -25,
    /** Degrees above level: 90 is straight down. */
    tilt: 35,
  },

  _STICK: '#8a4b2a',
  _BALL: '#3f9b4c',
  _BALL_EDGE: '#2a6b33',
  _GRID: '#d6d3c8',
  _GROUND: '#f6f4ec',
  _INK: '#52514e',

  _create() {
    this.element.addClass('slx-lolly');
    this._sim = Sienna.Simulation.viewFor(this._ref());
    this._owner = this._panelId() || ('lolly' + Math.random().toString(36).slice(2));
    this._ids = { x: null, y: null, size: null };
    this._frame = null;            // { t, x: {k: v}, y: {...}, size: {...} }
    this._extent = { x0: 0, x1: 100, y0: 0, y1: 100, top: 25 };

    this._buildBar();
    this._buildView();

    this._unsub = this._sim.subscribe((e) => this._onEvent(e));
    this._watchPanelResize(() => this._draw());
    if (window.ResizeObserver) {
      this._ro = new ResizeObserver(() => this._draw());
      this._ro.observe(this._view[0]);
    }
    this._syncComponents();
  },

  // ---- construction ---------------------------------------------------

  _buildBar() {
    const bar = $('<div class="slx-palette slx-chrome slx-lolly-bar">').appendTo(this.element);
    this._picks = {};
    [['x', 'Where each member stands, across'],
      ['y', 'Where each member stands, from front to back'],
      ['size', 'How big each member is: its height, and the size of its ball']].forEach(([role, title]) => {
      $('<span class="slx-palette-group">').text(role).appendTo(bar);
      this._picks[role] = $('<select class="slx-lolly-pick">').attr('title', title).appendTo(bar);
      this._on(this._picks[role], {
        change: () => {
          const c = this._byId[this._picks[role].val()];
          this.options[role] = c ? c.label : '';
          this._bind();
        },
      });
    });

    const view = $('<div class="slx-palette slx-chrome slx-lolly-bar">').appendTo(this.element);
    $('<span class="slx-palette-group">').text('turn').appendTo(view);
    this._turn = $('<input type="range" min="-180" max="180" step="1" class="slx-lolly-slider">')
      .attr('title', 'Turn the ground round (Simile: view angle). Or drag across the picture.')
      .val(this.options.turn).appendTo(view);
    $('<span class="slx-palette-group">').text('tilt').appendTo(view);
    this._tilt = $('<input type="range" min="0" max="90" step="1" class="slx-lolly-slider">')
      .attr('title', 'Look from level (0) to straight down (90) (Simile: view elevation).')
      .val(this.options.tilt).appendTo(view);
    $('<button type="button">').attr('title', 'Back to the starting view').text('reset view')
      .appendTo(view).on('click', () => this._setView(-25, 35));

    this._on(this._turn, { input: () => this._setView(Number(this._turn.val()), null) });
    this._on(this._tilt, { input: () => this._setView(null, Number(this._tilt.val())) });
  },

  _buildView() {
    this._view = $('<div class="slx-lolly-view">').appendTo(this.element);
    this._canvas = $('<canvas class="slx-lolly-canvas">').appendTo(this._view);
    this._note = $('<div class="slx-lolly-note">').appendTo(this._view);
    this._tip = $('<div class="slx-plot-tip" hidden>').appendTo(this._view);

    // Drag to look round: across turns, up and down tilts.
    this._on(this._canvas, {
      pointerdown: (e) => {
        const ev = e.originalEvent;
        const start = { x: ev.clientX, y: ev.clientY, turn: this.options.turn, tilt: this.options.tilt };
        const el = this._canvas[0];
        if (el.setPointerCapture) el.setPointerCapture(ev.pointerId);
        const move = (m) => {
          this._setView(start.turn + (m.clientX - start.x) * 0.5,
            start.tilt + (m.clientY - start.y) * 0.3);
        };
        const up = () => {
          el.removeEventListener('pointermove', move);
          el.removeEventListener('pointerup', up);
          el.removeEventListener('pointercancel', up);
        };
        el.addEventListener('pointermove', move);
        el.addEventListener('pointerup', up);
        el.addEventListener('pointercancel', up);
        this._tip.prop('hidden', true);
      },
      mousemove: (e) => { if (!e.buttons) this._hover(e); },
      mouseleave: () => this._tip.prop('hidden', true),
    });
  },

  _setView(turn, tilt) {
    if (turn != null) {
      let t = turn;
      while (t > 180) t -= 360;
      while (t < -180) t += 360;
      this.options.turn = Math.round(t);
      this._turn.val(this.options.turn);
    }
    if (tilt != null) {
      this.options.tilt = Math.round(Math.max(0, Math.min(90, tilt)));
      this._tilt.val(this.options.tilt);
    }
    this._draw();
  },

  // ---- choosing the variables ---------------------------------------

  _syncComponents() {
    const list = this._sim.memberComponents ? this._sim.memberComponents() : [];
    this._byId = {};
    list.forEach((c) => { this._byId[c.id] = c; });

    // Names the modeller chose earlier, else the obvious ones by name.
    const tail = (label) => String(label).split('/').pop();
    const find = (label) => list.find((c) => c.label === label)
      || list.find((c) => label && tail(c.label) === tail(label));
    const guess = { x: find(this.options.x || 'x'), y: find(this.options.y || 'y'), size: find(this.options.size || 'size') };

    Object.keys(this._picks).forEach((role) => {
      const pick = this._picks[role].empty();
      if (!list.length) {
        $('<option>').val('').text(this._sim.base ? '(no population)' : '(no model loaded)').appendTo(pick);
        return;
      }
      $('<option>').val('').text('choose…').appendTo(pick);
      list.forEach((c) => $('<option>').val(c.id).text(c.label).appendTo(pick));
      const c = guess[role];
      pick.val(c ? c.id : '');
      if (c) this.options[role] = c.label;
    });
    this._bind();
  },

  /** Ask the session for whichever of the three are chosen, and show a frame now. */
  _bind() {
    ['x', 'y', 'size'].forEach((role) => {
      const id = this._picks[role].val() || null;
      this._ids[role] = id;
      if (id) this._sim.addTarget(this._owner + ':' + role, id);
      else this._sim.removeTarget(this._owner + ':' + role);
    });
    this._frame = null;
    this._draw();
    if (!this._ready() || !this._sim.base) return;
    const ids = [this._ids.x, this._ids.y, this._ids.size];
    this._sim.query(ids).then((values) => {
      if (this._frame) return;                 // the model has stepped since
      this._take(Number(this._sim.settings.current), values);
    }).catch(() => { /* drawn when the model next steps */ });
  },

  _ready() {
    return !!(this._ids.x && this._ids.y && this._ids.size);
  },

  // ---- data ------------------------------------------------------------

  _onEvent(e) {
    switch (e.type) {
      case 'describe':
        this._syncComponents();
        break;
      case 'data':
        if (this._ready()) this._take(e.time, e.values);
        break;
      case 'status':
        if (!this._sim.base) { this._frame = null; this._syncComponents(); }
        this._draw();
        break;
      default: break;
    }
  },

  /** Keep the latest values and grow the extent to cover them. */
  _take(t, values) {
    const obj = (v) => (v && typeof v === 'object' ? v : {});
    this._frame = {
      t,
      x: obj(values[this._ids.x]),
      y: obj(values[this._ids.y]),
      size: obj(values[this._ids.size]),
    };
    const ext = this._extent;
    const up = (v) => Math.ceil(v / 10) * 10;
    const down = (v) => Math.floor(v / 10) * 10;
    this._members().forEach((m) => {
      if (m.x < ext.x0) ext.x0 = down(m.x);
      if (m.x > ext.x1) ext.x1 = up(m.x);
      if (m.y < ext.y0) ext.y0 = down(m.y);
      if (m.y > ext.y1) ext.y1 = up(m.y);
      if (Math.abs(m.size) > ext.top) ext.top = Math.abs(m.size);
    });
    this._schedule();
  },

  /** Members with all three values, as {key, x, y, size}. */
  _members() {
    const f = this._frame;
    if (!f) return [];
    return Object.keys(f.size).filter((k) => k in f.x && k in f.y).map((k) => ({
      key: k, x: Number(f.x[k]), y: Number(f.y[k]), size: Number(f.size[k]),
    })).filter((m) => isFinite(m.x) && isFinite(m.y) && isFinite(m.size));
  },

  _schedule() {
    if (this._pending) return;
    this._pending = window.requestAnimationFrame(() => {
      this._pending = null;
      this._draw();
    });
  },

  // ---- drawing ---------------------------------------------------------

  /**
   * World → screen. Ground point (x, y) at height z: centred on the ground's
   * middle, turned round the vertical, then tilted towards the viewer.
   * Returns screen x, y and a depth (larger is further away).
   */
  _projector() {
    const e = this._extent;
    const cx = (e.x0 + e.x1) / 2;
    const cy = (e.y0 + e.y1) / 2;
    const th = this.options.turn * Math.PI / 180;
    const ph = this.options.tilt * Math.PI / 180;
    const ct = Math.cos(th); const st = Math.sin(th);
    const cp = Math.cos(ph); const sp = Math.sin(ph);
    return (x, y, z) => {
      const X = x - cx; const Y = y - cy;
      const u = X * ct - Y * st;
      const v = X * st + Y * ct;
      return { u, w: -v * sp - z * cp, depth: v };
    };
  },

  _draw() {
    const canvas = this._canvas[0];
    const box = this._view[0].getBoundingClientRect();
    const W = Math.max(120, Math.round(box.width));
    const H = Math.max(90, Math.round(box.height));
    const dpr = window.devicePixelRatio || 1;
    if (canvas.width !== Math.round(W * dpr) || canvas.height !== Math.round(H * dpr)) {
      canvas.width = Math.round(W * dpr);
      canvas.height = Math.round(H * dpr);
      canvas.style.width = W + 'px';
      canvas.style.height = H + 'px';
    }
    const g = canvas.getContext('2d');
    g.setTransform(dpr, 0, 0, dpr, 0, 0);
    g.clearRect(0, 0, W, H);
    this._placed = [];

    if (!this._sim.base) { this._say('Load a model in a Run control panel.'); return; }
    if (!this._ready()) {
      this._say(this._sim.memberComponents && this._sim.memberComponents().length
        ? 'Choose the variables for x, y and size.'
        : 'This display shows the members of a population. The model loaded has none.');
      return;
    }
    this._say('');

    const e = this._extent;
    const P = this._projector();

    // Fit: the ground's corners, and the same corners raised by the tallest
    // member plus its ball, must all land inside the panel with a margin.
    const lift = e.top * (1 + 2 / 3);
    let u0 = Infinity; let u1 = -Infinity; let w0 = Infinity; let w1 = -Infinity;
    [[e.x0, e.y0], [e.x1, e.y0], [e.x0, e.y1], [e.x1, e.y1]].forEach(([x, y]) => {
      [0, lift].forEach((z) => {
        const p = P(x, y, z);
        u0 = Math.min(u0, p.u); u1 = Math.max(u1, p.u);
        w0 = Math.min(w0, p.w); w1 = Math.max(w1, p.w);
      });
    });
    const M = { l: 34, r: 24, t: 30, b: 30 };
    const k = Math.min((W - M.l - M.r) / Math.max(1e-6, u1 - u0), (H - M.t - M.b) / Math.max(1e-6, w1 - w0));
    const ox = M.l + ((W - M.l - M.r) - (u1 - u0) * k) / 2 - u0 * k;
    const oy = M.t + ((H - M.t - M.b) - (w1 - w0) * k) / 2 - w0 * k;
    const S = (x, y, z) => {
      const p = P(x, y, z);
      return { x: ox + p.u * k, y: oy + p.w * k, depth: p.depth };
    };

    // --- the ground
    const c = [S(e.x0, e.y0, 0), S(e.x1, e.y0, 0), S(e.x1, e.y1, 0), S(e.x0, e.y1, 0)];
    g.beginPath();
    c.forEach((p, i) => (i ? g.lineTo(p.x, p.y) : g.moveTo(p.x, p.y)));
    g.closePath();
    g.fillStyle = this._GROUND;
    g.fill();

    g.strokeStyle = this._GRID;
    g.lineWidth = 1;
    g.font = '11px system-ui, sans-serif';
    g.fillStyle = this._INK;
    const step = this._step(Math.max(e.x1 - e.x0, e.y1 - e.y0));
    const num = (v) => String(Math.round(v * 1e6) / 1e6);
    // Labels are placed most important first, and one that would land on a
    // label already placed is left out: an edge seen nearly end-on has its
    // numbers crowded together, and a heap of digits says nothing.
    this._labels = [];
    g.font = '600 11px system-ui, sans-serif';
    this._label(g, S, (e.x0 + e.x1) / 2, e.y0, 'x', [0, -2.4]);
    this._label(g, S, e.x0, (e.y0 + e.y1) / 2, 'y', [-2.4, 0]);
    g.font = '11px system-ui, sans-serif';
    for (let x = Math.ceil(e.x0 / step) * step; x <= e.x1 + 1e-9; x += step) {
      const a = S(x, e.y0, 0); const b = S(x, e.y1, 0);
      g.beginPath(); g.moveTo(a.x, a.y); g.lineTo(b.x, b.y); g.stroke();
    }
    for (let y = Math.ceil(e.y0 / step) * step; y <= e.y1 + 1e-9; y += step) {
      const a = S(e.x0, y, 0); const b = S(e.x1, y, 0);
      g.beginPath(); g.moveTo(a.x, a.y); g.lineTo(b.x, b.y); g.stroke();
    }
    // The two ends of each edge first, then what fits between them.
    const ticks = (lo, hi) => {
      const out = [];
      for (let v = Math.ceil(lo / step) * step; v <= hi + 1e-9; v += step) out.push(v);
      return out.length > 2 ? [out[0], out[out.length - 1]].concat(out.slice(1, -1)) : out;
    };
    ticks(e.x0, e.x1).forEach((x) => this._label(g, S, x, e.y0, num(x), [0, -1]));
    ticks(e.y0, e.y1).forEach((y) => this._label(g, S, e.x0, y, num(y), [-1, 0]));

    // --- the members, back to front
    const members = this._members().map((m) => Object.assign(m, { base: S(m.x, m.y, 0) }));
    members.sort((a, b) => b.base.depth - a.base.depth);
    members.forEach((m) => {
      const h = Math.max(0, m.size);
      const top = S(m.x, m.y, h);
      const r = Math.max(1.5, (h / 3) * k);
      g.strokeStyle = this._STICK;
      g.lineWidth = Math.max(1.5, Math.min(4, r / 4));
      g.lineCap = 'round';
      g.beginPath(); g.moveTo(m.base.x, m.base.y); g.lineTo(top.x, top.y); g.stroke();
      g.beginPath();
      g.arc(top.x, top.y - r * 0.85, r, 0, Math.PI * 2);
      g.fillStyle = this._BALL;
      g.fill();
      g.strokeStyle = this._BALL_EDGE;
      g.lineWidth = 1;
      g.stroke();
      this._placed.push({ m, x: top.x, y: top.y - r * 0.85, r, bx: m.base.x, by: m.base.y });
    });

    // --- time and count, top left
    const f = this._frame;
    g.font = '12px system-ui, sans-serif';
    g.fillStyle = this._INK;
    g.textAlign = 'left';
    g.textBaseline = 'top';
    const unit = this._sim.unitName ? ' ' + this._sim.unitName : '';
    g.fillText((f ? 't = ' + this._fmt(f.t) + unit + '   ' : '') + members.length
      + (members.length === 1 ? ' member' : ' members'), 8, 6);
  },

  /**
   * A label just outside the ground, `away` ground-steps from the edge point —
   * unless it would overlap one already placed this frame.
   */
  _label(g, S, x, y, text, away) {
    const e = this._extent;
    const d = Math.max(e.x1 - e.x0, e.y1 - e.y0) * 0.045;
    const p = S(x + away[0] * d, y + away[1] * d, 0);
    const w = g.measureText(text).width / 2 + 3;
    const h = 8;
    if (this._labels.some((q) => Math.abs(q.x - p.x) < q.w + w && Math.abs(q.y - p.y) < h * 2)) return;
    this._labels.push({ x: p.x, y: p.y, w });
    g.textAlign = 'center';
    g.textBaseline = 'middle';
    g.fillText(text, p.x, p.y);
  },

  /** Grid spacing: about ten lines across, on 1, 2 or 5 × a power of ten. */
  _step(range) {
    const raw = range / 10;
    const mag = Math.pow(10, Math.floor(Math.log10(raw)));
    const n = raw / mag;
    return (n <= 1 ? 1 : n <= 2 ? 2 : n <= 5 ? 5 : 10) * mag;
  },

  _fmt(v) {
    const r = Number(Number(v).toPrecision(6));
    return r.toLocaleString('en-US', { maximumFractionDigits: 4 });
  },

  /** Which member is under the pointer: its ball, or its stick, nearest first. */
  _hover(e) {
    if (!this._placed || !this._placed.length) { this._tip.prop('hidden', true); return; }
    const box = this._canvas[0].getBoundingClientRect();
    const px = e.clientX - box.left;
    const py = e.clientY - box.top;
    let hit = null;
    for (let i = this._placed.length - 1; i >= 0 && !hit; i--) {     // front first
      const p = this._placed[i];
      if (Math.hypot(px - p.x, py - p.y) <= p.r + 2) hit = p;
    }
    if (!hit) { this._tip.prop('hidden', true); return; }
    const m = hit.m;
    const name = (role) => String(this.options[role] || role).split('/').pop();
    this._tip.empty().prop('hidden', false);
    $('<div class="slx-plot-tip-t">').text('member ' + m.key).appendTo(this._tip);
    [['x', m.x], ['y', m.y], ['size', m.size]].forEach(([role, v]) => {
      const row = $('<div class="slx-plot-tip-row">').appendTo(this._tip);
      $('<b>').text(this._fmt(v)).appendTo(row);
      $('<span class="slx-plot-name">').text(name(role)).appendTo(row);
    });
    const tw = this._tip.outerWidth();
    const left = px + 14 + tw > box.width ? px - 14 - tw : px + 14;
    this._tip.css({ left: Math.max(2, left) + 'px', top: (py + 12) + 'px' });
  },

  _say(text) {
    this._note.text(text).toggle(!!text);
  },

  _destroy() {
    if (this._unsub) this._unsub();
    if (this._ro) this._ro.disconnect();
    if (this._pending) window.cancelAnimationFrame(this._pending);
    ['x', 'y', 'size'].forEach((role) => this._sim.removeTarget(this._owner + ':' + role));
    this.element.removeClass('slx-lolly').empty();
  },

  /** View state: the three variables, by name, and the viewpoint. */
  state() {
    return {
      x: this.options.x, y: this.options.y, size: this.options.size,
      turn: this.options.turn, tilt: this.options.tilt,
    };
  },
});

window.Sienna.widgetRegistry._loaded('lollipop', 'lollipop');
