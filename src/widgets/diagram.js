/**
 * `sienna.diagram` — renders a model as SVG. Read-only for now.
 *
 * The foundational calls of DESIGN-diagram.md §11.4 are made here, because they
 * are painful to retrofit:
 *
 *   - **One flat world coordinate space.** Every element's layout is in world
 *     coordinates, and a *single* transform on one root `<g>` does pan/zoom.
 *     There are deliberately NO nested per-submodel transforms: they would make
 *     dragging a submodel's children free, but would force a coordinate-space
 *     conversion on every cross-boundary arc, and cross-boundary arcs are the
 *     case we cannot afford to make awkward (§11.4, a conscious trade).
 *   - **Explicit layer groups**, because SVG has no z-index — paint order is
 *     document order. Bodies, then arcs, then nodes, then labels, then overlay.
 *   - **Layout is read only through `d.appearanceOf(id)`** (ruling 18), never
 *     by indexing the layout map, so that ghosts stay a one-place change.
 *
 * Glyphs and sizes come from the **schema's** style face, not from code here —
 * swapping the schema must be able to change how a notation looks (§3, §6).
 *
 * Arcs are drawn as straight/curved links between element edges. The §13
 * segment-and-port machinery is NOT here yet: it only bites once submodels are
 * on the diagram, which this milestone does not cover.
 *
 * Classic script, injected on demand by the widget registry.
 */
$.widget('sienna.diagram', $.sienna.widgetBase, {
  options: {
    /** Model path to view when the panel is unbound (no `ref`). */
    path: 'models/growth',
    padding: 40,
    maxFitScale: 2,
    /**
     * What the view bar's "100%" restores. The notation's world units are small
     * enough that a true 1:1 is unreadably tiny, so the default zoom is a
     * setting rather than the identity — destined for the Diagram widget's
     * Settings dialog when there is one.
     */
    defaultScale: 1.8,
    /** Influence curvature: sagitta as a fraction of the chord (§ _bow). */
    bowFraction: 0.12,
    /**
     * How far apart to fan arcs that share both endpoints, in the same units.
     * Without this they are drawn identically and a two-role association looks
     * like one arc (§7.5, and see `_bowFor`).
     */
    fanBow: 0.18,
  },

  // Layers, painted in this order (SVG has no z-index).
  _LAYERS: ['bodies', 'arcs', 'nodes', 'labels', 'overlay'],

  // Arrowhead length per arc type, in world units — must match the marker
  // paths built in _buildCanvas, since the line is shortened by exactly this.
  _ARROW_LEN: { flow: 9, influence: 6.75, role: 6.75 },

  // Sagitta as a fraction of the chord may not reach 0.5: at 0.5 the arc is a
  // semicircle, and beyond it the drawn arc is no longer the one intended.
  _MAX_BOW: 0.48,

  _create() {
    this.element.addClass('slx-diagram');

    this._view = { x: 0, y: 0, k: 1 }; // pan/zoom: the one root transform
    this._tool = null;                 // null = select/drag; else a palette tool
    this._sel = [];                    // selected element ids

    // Declare what this panel is a view of, so the shell's File commands can
    // find it (see widgetBase._bindPathOption).
    this._bindPathOption();

    this._buildPalette();
    this._buildViewBar();
    this._buildCanvas();
    this._bindView();

    if (window.ResizeObserver) {
      this._ro = new ResizeObserver(() => this._fit());
      this._ro.observe(this.element[0]);
    }

    // Live-update on model change (undo, a sibling panel, an import).
    if (this._bound()) this._watchModel(this._render);
    else this._unsub = Sienna.userData.subscribe(this.options.path, () => this._render());

    this._render();
  },

  /** The diagram this panel views: its `ref` when bound, else the option. */
  _diagram() {
    const path = this._bound() ? this._ref() : this.options.path;
    return Sienna.userData.get(path) ? new Sienna.Diagram(path) : null;
  },

  // ---- palette --------------------------------------------------------

  /**
   * The palette is generated from the schema's vocabulary, so a different
   * notation gets a different palette with no code change (§3). Types marked
   * `autoCreated` (cloud, valve) are omitted: they arrive as a side effect of
   * drawing a flow and are never placed by hand.
   */
  _buildPalette() {
    const bar = this._palette = $('<div class="slx-palette">').appendTo(this.element);
    const d = this._diagram();
    const schema = d ? d.schema() : null;
    if (!schema) return;

    const add = (kind, name, label, title) => {
      $('<button type="button">')
        .attr({ 'data-tool': kind + ':' + name, title: title || label })
        .text(label)
        .appendTo(bar);
    };

    $('<span class="slx-palette-group">').text('add').appendTo(bar);
    Object.keys(schema.nodes).forEach((t) => {
      if (!schema.nodes[t].autoCreated) add('node', t, t);
    });
    add('submodel', 'submodel', 'submodel');

    $('<span class="slx-palette-group">').text('connect').appendTo(bar);
    Object.keys(schema.arcs).forEach((t) => add('arc', t, t));

    // Acts on the selection the moment it is clicked, so it is a command and
    // not an armable tool — the palette above arms, this does.
    $('<span class="slx-palette-group">').text('edit').appendTo(bar);
    $('<button type="button" data-act="ungroup">')
      .attr('title', 'Dissolve the selected submodel, keeping its contents')
      .text('ungroup')
      .appendTo(bar);

    $('<span class="slx-palette-group">').text('check').appendTo(bar);
    $('<button type="button" data-act="validate">').text('check model').appendTo(bar);

    this._on(bar, {
      'click button': (e) => {
        const act = $(e.currentTarget).attr('data-act');
        if (act === 'validate') return this._validate();
        if (act === 'ungroup') return this._ungroupSelection();
        const tool = $(e.currentTarget).attr('data-tool');
        this._tool = this._tool === tool ? null : tool;   // click again to drop it
        this._syncPalette();
      },
    });
    this._on($(document), {
      keydown: (e) => {
        // Never while typing: the rename box and the property dialog own the
        // keyboard when they are open.
        const tag = (e.target && e.target.tagName) || '';
        if (/^(INPUT|TEXTAREA|SELECT)$/.test(tag) || e.target.isContentEditable) return;
        if (e.key === 'Escape') { this._tool = null; this._syncPalette(); return; }
        if (e.key === 'Delete' || e.key === 'Backspace') {
          if (!this._sel.length) return;
          e.preventDefault();
          this._deleteSelection();
        }
      },
    });
  },

  _syncPalette() {
    // Both bars hold armable tools, so both show which one is armed.
    this._palette.add(this._viewBar).find('button').each((i, b) => {
      $(b).toggleClass('slx-active', $(b).attr('data-tool') === this._tool);
    });
    this.element.toggleClass('slx-placing', !!this._tool && this._tool !== 'select:box');
    this.element.toggleClass('slx-banding', this._tool === 'select:box');
  },

  // ---- view bar --------------------------------------------------------

  /**
   * A second row: the view commands, plus rubber-band selection. These are
   * notation-independent — unlike the palette above, nothing here is read from
   * the schema, because zooming means the same thing whatever is being drawn.
   *
   * Select box is an ARMED TOOL rather than a modifier-drag, because dragging
   * blank canvas already means pan. Arming it the way the palette tools are
   * armed resolves that conflict with a mode the user can see, and one that
   * Escape cancels like any other.
   */
  _buildViewBar() {
    const bar = this._viewBar = $('<div class="slx-palette slx-viewbar">').appendTo(this.element);

    $('<span class="slx-palette-group">').text('view').appendTo(bar);
    const cmd = (act, label, title) =>
      $('<button type="button">').attr({ 'data-act': act, title }).text(label).appendTo(bar);

    cmd('zoom-in', '+', 'Zoom in');
    cmd('zoom-out', '−', 'Zoom out');
    cmd('fit', 'fit', 'Zoom to fit the whole model in the panel');
    cmd('reset', '100%', 'Back to the default zoom level');
    cmd('recentre', 're-centre', 'Centre the model without changing the zoom');

    $('<span class="slx-palette-group">').text('select').appendTo(bar);
    $('<button type="button" data-tool="select:box">')
      .attr('title', 'Drag a box to select what it encloses')
      .text('select box')
      .appendTo(bar);

    this._on(bar, {
      'click button': (e) => {
        const el = $(e.currentTarget);
        const tool = el.attr('data-tool');
        if (tool) {
          this._tool = this._tool === tool ? null : tool;   // click again to drop it
          this._syncPalette();
          return;
        }
        switch (el.attr('data-act')) {
          case 'zoom-in':   this._zoomStep(1.25); break;
          case 'zoom-out':  this._zoomStep(1 / 1.25); break;
          case 'fit':       this._fit(true); break;
          case 'reset':     this._restoreDefault(); break;
          case 'recentre':  this._recentre(); break;
        }
      },
    });
  },

  /** The panel centre in client coordinates — the anchor the buttons zoom about. */
  _centre() {
    const r = this._svg.getBoundingClientRect();
    return { x: r.left + r.width / 2, y: r.top + r.height / 2 };
  },

  _zoomStep(factor) { this._zoomTo(this._view.k * factor); },

  /**
   * Zoom to an absolute scale, holding the panel's centre point still — the
   * stepped counterpart of the wheel, which holds the pointer still instead.
   */
  _zoomTo(k) {
    k = Math.min(4, Math.max(0.2, k));
    const c = this._centre();
    const p = this._toWorld(c.x, c.y);
    this._userView = true;
    this._view.x += p.x * (this._view.k - k);
    this._view.y += p.y * (this._view.k - k);
    this._view.k = k;
    this._applyView();
  },

  /**
   * Back to the default zoom — and centred, unlike the stepped buttons, which
   * hold the panel centre still. That is deliberate: this is the command you
   * reach for when the view has got away from you, so it must always end up
   * looking at the model. Anchoring it to the centre instead would faithfully
   * keep whatever distant spot happened to be there, which is the one outcome
   * a restore-default is meant to rescue you from.
   */
  _restoreDefault() {
    if (this._centreContent(this.options.defaultScale)) {
      this._userView = true;
      this._applyView();
    }
  },

  /** Centre the content in the panel at the current zoom. */
  _recentre() {
    if (this._centreContent(this._view.k)) {
      this._userView = true;
      this._applyView();
    }
  },

  /**
   * Put the content's centre at the panel's centre, at scale `k`. Shared by
   * re-centre and by fit, which is a scale followed by exactly this. Returns
   * false when there is nothing to centre or nothing to centre it in.
   */
  _centreContent(k) {
    const box = this._root.getBBox ? this._root.getBBox() : null;
    if (!box || !box.width) return false;
    // The SVG, not the whole widget: the toolbars above it are not canvas, and
    // the view transform is measured from the SVG's own top-left (see _toWorld).
    const r = this._svg.getBoundingClientRect();
    if (!r.width) return false;
    this._view = {
      k,
      x: r.width / 2 - (box.x + box.width / 2) * k,
      y: r.height / 2 - (box.y + box.height / 2) * k,
    };
    return true;
  },

  /**
   * Rubber-band selection. "Encloses" means exactly what it means for submodel
   * capture — wholly inside, siblings only — so the same gesture over the same
   * picture selects the same things it would have captured (see
   * `Diagram.enclosedBy`). Which siblings is decided by where the drag STARTED:
   * begin inside a submodel and you band its children, begin outside and you
   * band the top level.
   *
   * Shift or Ctrl adds to the selection, as it does for a click.
   */
  _beginBandSelect(e) {
    const d = this._diagram();
    if (!d) return;
    const origin = this._toWorld(e.clientX, e.clientY);
    const parent = this._dropTargetAt(d, origin, null);
    const add = e.shiftKey || e.ctrlKey || e.metaKey;
    const band = this._el('rect', { class: 'slx-band', rx: 2 });
    this._layer.overlay.appendChild(band);

    let cur = origin;
    const move = (ev) => {
      cur = this._toWorld(ev.clientX, ev.clientY);
      band.setAttribute('x', Math.min(origin.x, cur.x));
      band.setAttribute('y', Math.min(origin.y, cur.y));
      band.setAttribute('width', Math.abs(cur.x - origin.x));
      band.setAttribute('height', Math.abs(cur.y - origin.y));
    };
    const end = () => {
      $(document).off('pointermove', move).off('pointerup pointercancel', end);
      band.remove();
      const w = Math.abs(cur.x - origin.x);
      const h = Math.abs(cur.y - origin.y);
      if (w < 4 || h < 4) return;              // not a drag: tool stays armed
      const rect = { x: (origin.x + cur.x) / 2, y: (origin.y + cur.y) / 2, w, h };
      const hit = d.enclosedBy(rect, parent);
      this._sel = add ? this._sel.concat(hit.filter((id) => this._sel.indexOf(id) < 0)) : hit;
      this._tool = null;                       // one band per pick, as for placing
      this._syncPalette();
      this._render();
    };
    $(document).on('pointermove', move).on('pointerup pointercancel', end);
  },

  // ---- canvas ---------------------------------------------------------

  _buildCanvas() {
    const svg = this._svg = this._el('svg', { class: 'slx-diagram-svg' });
    this.element.append(svg);

    // Arrowheads: one marker per arc type, so the schema's styling can grow.
    const defs = this._el('defs');
    defs.appendChild(this._marker('slx-arrow-flow', 'M0,0 L9,3.75 L0,7.5 z', 9, 3.75));
    defs.appendChild(this._marker('slx-arrow-influence', 'M0,0.75 L6.75,3.75 L0,6.75 z', 6.75, 3.75));
    svg.appendChild(defs);

    // THE root transform — pan/zoom lives here and nowhere else.
    this._root = this._el('g', { class: 'slx-diagram-root' });
    svg.appendChild(this._root);

    this._layer = {};
    this._LAYERS.forEach((name) => {
      this._layer[name] = this._el('g', { class: 'slx-layer-' + name });
      this._root.appendChild(this._layer[name]);
    });
  },

  _bindView() {
    const el = this.element;

    // Wheel = zoom about the pointer; drag on blank canvas = pan.
    this._on(el, {
      wheel: (e) => {
        e.preventDefault();
        this._userView = true;
        const ev = e.originalEvent;
        const p = this._toWorld(ev.clientX, ev.clientY);
        const k = Math.min(4, Math.max(0.2, this._view.k * (ev.deltaY < 0 ? 1.1 : 1 / 1.1)));
        // Keep the world point under the cursor fixed.
        this._view.x += p.x * (this._view.k - k);
        this._view.y += p.y * (this._view.k - k);
        this._view.k = k;
        this._applyView();
      },
      pointerdown: (e) => {
        if (e.target !== this._svg && e.target !== this._root) return; // blank only
        if (this._tool && this._tool.indexOf('arc:') === 0) {
          this._beginArcDraw(e, this._diagram(), null);                // from blank space
          return;
        }
        if (this._tool === 'submodel:submodel') {
          this._beginSubmodelDraw(e);                                  // drag out a box
          return;
        }
        if (this._tool === 'select:box') {
          this._beginBandSelect(e);                                    // drag out a band
          return;
        }
        if (this._tool) { this._placeAt(e); return; }                  // creating, not panning
        if (this._sel.length) { this._sel = []; this._render(); }       // click away = deselect
        this._userView = true;
        const start = { x: e.clientX, y: e.clientY, vx: this._view.x, vy: this._view.y };
        const move = (ev) => {
          this._view.x = start.vx + (ev.clientX - start.x);
          this._view.y = start.vy + (ev.clientY - start.y);
          this._applyView();
        };
        const up = () => {
          $(document).off('pointermove', move).off('pointerup', up);
        };
        $(document).on('pointermove', move).on('pointerup', up);
      },
    });
  },

  /**
   * Place a new element where the user clicked. Its parent is whichever
   * submodel it lands in — containment follows from the drop point, exactly as
   * it does when an existing element is dragged in.
   */
  _placeAt(e) {
    const d = this._diagram();
    if (!d || !this._tool) return;
    const [kind, type] = this._tool.split(':');
    if (kind === 'arc') return;                    // arcs are drawn, not placed

    const p = this._toWorld(e.clientX, e.clientY);
    const parent = this._dropTargetAt(d, p, null);

    if (kind !== 'submodel') {
      const verdict = Sienna.grammar.mayContain(d, type, parent);
      if (!verdict.ok) { this._flash(verdict.message); return; }
    }

    let id;
    if (kind === 'submodel') {
      id = d.addSubmodel({ parent, x: p.x, y: p.y, label: '' });
    } else {
      id = d.addNode(type, { parent, x: p.x, y: p.y, label: '' });
    }
    this._tool = null;                             // one placement per pick
    this._syncPalette();
    this._render();
    this._editLabel(d, id);                        // straight into naming it
  },

  /**
   * Draw a submodel by dragging out its rectangle. This is the ONLY way to make
   * one: a submodel is drawn AROUND things, and it captures whatever it
   * encloses, so its size is part of the gesture. A click that never becomes a
   * drag creates nothing and leaves the tool armed to try again — one mode, not
   * two, and no default size to be surprised by.
   */
  _beginSubmodelDraw(e) {
    const d = this._diagram();
    if (!d) return;
    const origin = this._toWorld(e.clientX, e.clientY);
    const ghost = this._el('rect', { class: 'slx-ghost-box', rx: 4 });
    this._layer.overlay.appendChild(ghost);

    let cur = origin;
    const move = (ev) => {
      cur = this._toWorld(ev.clientX, ev.clientY);
      ghost.setAttribute('x', Math.min(origin.x, cur.x));
      ghost.setAttribute('y', Math.min(origin.y, cur.y));
      ghost.setAttribute('width', Math.abs(cur.x - origin.x));
      ghost.setAttribute('height', Math.abs(cur.y - origin.y));
    };
    const end = () => {
      $(document).off('pointermove', move).off('pointerup pointercancel', end);
      ghost.remove();
      const w = Math.abs(cur.x - origin.x);
      const h = Math.abs(cur.y - origin.y);
      if (w < 20 || h < 20) return;              // not a drag: nothing made, tool stays armed
      const box = { x: (origin.x + cur.x) / 2, y: (origin.y + cur.y) / 2, w: w, h: h };
      this._tool = null;
      this._syncPalette();
      const id = d.addSubmodel(Object.assign({ parent: this._dropTargetAt(d, origin, null), label: '' }, box));
      this._render();
      // Capture is NOT refused when it creates an illegal containment: boxing a
      // flat model and then declaring the box a population is a workflow we
      // deliberately support, and it passes through exactly this state. So the
      // breach is REPORTED, in the manner of the validation pass (§12.5).
      const bad = Sienna.grammar.validate(d).filter((v) => d.parentOf(v.id) === id);
      if (bad.length) this._flash(`${bad[0].message} (${bad.length} to fix)`);
      this._editLabel(d, id);
    };
    $(document).on('pointermove', move).on('pointerup pointercancel', end);
  },

  _applyView() {
    const v = this._view;
    this._root.setAttribute('transform', `translate(${v.x},${v.y}) scale(${v.k})`);
  },

  /** Screen point -> world coordinates (the inverse of the root transform). */
  _toWorld(clientX, clientY) {
    const r = this._svg.getBoundingClientRect();
    return {
      x: (clientX - r.left - this._view.x) / this._view.k,
      y: (clientY - r.top - this._view.y) / this._view.k,
    };
  },

  // ---- geometry -------------------------------------------------------

  /** An element's box — computed in the model layer, which owns the geometry. */
  _box(d, id) {
    return d.box(id, this._drag && this._drag.moves);
  },

  /**
   * Where a line aimed at `towards` leaves the boundary of box `b` — so arcs
   * stop at the glyph's edge rather than at its centre.
   */
  _edge(b, towards) {
    const dx = towards.x - b.cx;
    const dy = towards.y - b.cy;
    const len = Math.hypot(dx, dy) || 1;
    if (b.shape === 'rect') {
      const sx = b.w / 2 / Math.abs(dx || 1e-6);
      const sy = b.h / 2 / Math.abs(dy || 1e-6);
      const s = Math.min(sx, sy);
      return { x: b.cx + dx * s, y: b.cy + dy * s };
    }
    const r = Math.max(b.w, b.h) / 2;
    return { x: b.cx + (dx / len) * r, y: b.cy + (dy / len) * r };
  },

  // ---- render ---------------------------------------------------------

  _render() {
    const d = this._diagram();
    this._LAYERS.forEach((n) => { this._layer[n].textContent = ''; });
    if (!d) {
      this._layer.labels.appendChild(
        this._text(20, 30, 'No model at ' + (this._bound() ? this._ref() : this.options.path), 'slx-empty')
      );
      return;
    }

    const model = d.model();

    // Bodies first (submodels sit under everything), then arcs, then nodes.
    Object.keys(model.submodels || {}).forEach((id) => this._renderSubmodel(d, id, model.submodels[id]));
    Object.keys(model.arcs || {}).forEach((id) => this._renderArc(d, id, model.arcs[id]));
    Object.keys(model.nodes || {}).forEach((id) => this._renderNode(d, id, model.nodes[id]));
    d.allPorts().forEach((p) => this._renderPort(d, p));

    // The selection ring sits in the overlay, so it is never painted over.
    this._sel.forEach((sid) => {
      if (!d.get(sid)) return;
      const b = d.box(sid, this._overrides());
      this._layer.overlay.appendChild(this._el('rect', {
        class: 'slx-selected',
        x: b.cx - b.w / 2 - 4, y: b.cy - b.h / 2 - 4,
        width: b.w + 8, height: b.h + 8, rx: 3,
      }));
    });

    // Frame the model ONCE, when it first has content. Never re-frame after an
    // edit: adding or moving an element changes the bounding box, and a view
    // that re-scales every time you place something is unusable. Resizing the
    // panel still re-fits (via the ResizeObserver), until the user takes the
    // view over by panning or zooming.
    if (!this._drag && !this._portDrag && !this._fittedOnce) {
      this._fit();
      if (this._root.getBBox && this._root.getBBox().width) this._fittedOnce = true;
    }
  },

  /** A submodel: a box in the bodies layer, labelled along its top edge. */
  _renderSubmodel(d, id, sub) {
    const b = this._box(d, id);
    const g = this._el('g', {
      class: 'slx-submodel slx-submodel-' + sub.kind + (this._incomplete(d, id) ? ' slx-incomplete' : ''),
      'data-id': id,
    });
    // The kind's decoration goes on FIRST, so the box itself paints over it and
    // the stack reads as sitting behind. Which decoration is the schema's to
    // say (`style.submodel.byKind`); how to draw one is this renderer's.
    this._decorateKind(g, b, ((d.schema().style || {}).submodel || {}).byKind, sub.kind);

    g.appendChild(this._el('rect', {
      x: b.cx - b.w / 2, y: b.cy - b.h / 2, width: b.w, height: b.h, rx: 4,
    }));
    if (this._drag && this._drag.dropTarget === id) g.setAttribute('class', g.getAttribute('class') + ' slx-drop-target');
    g.addEventListener('pointerdown', (e) => this._beginElementDrag(e, d, id));
    g.addEventListener('dblclick', () => this._editLabel(d, id));
    this._layer.bodies.appendChild(g);

    if (sub.label) {
      const t = this._placeLabel(d, id, sub.label, b.cx - b.w / 2 + 8, b.cy - b.h / 2 + 15,
        'slx-label slx-submodel-label');
      t.setAttribute('text-anchor', 'start');
    }
  },

  /**
   * Draw how many instances a submodel has (§6, ruled 2026-08-06).
   *
   *   stack        a known number: `layers` outlines stepped up and to the
   *                right, a deck seen from the front. Up-right rather than
   *                down-right because the label sits at the top LEFT and the
   *                contents fill downwards, so that corner is the free one.
   *   open-shadow  an unknown, changing number: a shadow edge along top-and-left
   *                and another along bottom-and-right, NOT meeting at the two
   *                corners between them. The gaps are the point — an outline
   *                that does not close says the membership is not fixed.
   *
   * Decoration only: the box itself remains the hit target, so selecting,
   * dragging and dropping are untouched.
   */
  _decorateKind(g, b, byKind, kind) {
    const spec = (byKind || {})[kind];
    if (!spec) return;                       // `single` — one instance, no mark

    const x1 = b.cx - b.w / 2, y1 = b.cy - b.h / 2;
    const x2 = b.cx + b.w / 2, y2 = b.cy + b.h / 2;

    if (spec.decoration === 'stack') {
      const step = spec.step || 3;
      // Back to front, so each sits over the one behind it.
      for (let i = (spec.layers || 3) - 1; i >= 1; i--) {
        g.appendChild(this._el('rect', {
          class: 'slx-kind-stack',
          x: x1 + i * step, y: y1 - i * step, width: b.w, height: b.h, rx: 4,
        }));
      }
      return;
    }

    if (spec.decoration === 'open-shadow') {
      const o = spec.offset || 4;
      const gx = b.w * (spec.gap || 0.2);    // how far short of each open corner
      const gy = b.h * (spec.gap || 0.2);
      g.appendChild(this._el('path', {
        class: 'slx-kind-shadow',
        d: `M${x2 - gx - o},${y1 - o} L${x1 - o},${y1 - o} L${x1 - o},${y2 - gy - o}`,
      }));
      g.appendChild(this._el('path', {
        class: 'slx-kind-shadow',
        d: `M${x1 + gx + o},${y2 + o} L${x2 + o},${y2 + o} L${x2 + o},${y1 + gy + o}`,
      }));
    }
  },

  /**
   * Red/black completeness (§19.9). Derived at render, never stored, because it
   * depends on the arrows as much as on the equation: drawing an influence into
   * an element can make it incomplete without its equation changing. The parse
   * cache in `src/equation.js` is what makes deriving it per render affordable.
   */
  _incomplete(d, id) {
    if (!Sienna.equationCheck) return false;
    return !Sienna.equationCheck.completeness(d, id).complete;
  },

  _renderNode(d, id, node) {
    const b = this._box(d, id);
    const g = this._el('g', {
      class: 'slx-node slx-node-' + node.type + (this._incomplete(d, id) ? ' slx-incomplete' : ''),
      'data-id': id,
    });

    switch (b.shape) {
      case 'rect':
        g.appendChild(this._el('rect', { x: b.cx - b.w / 2, y: b.cy - b.h / 2, width: b.w, height: b.h }));
        break;
      case 'cloud':
        g.appendChild(this._el('path', { d: this._cloudPath(b) }));
        break;
      case 'valve':
        // The System Dynamics valve: a bow-tie sitting on its flow.
        g.appendChild(this._el('path', {
          d: `M${b.cx - b.w / 2},${b.cy - b.h / 2} L${b.cx + b.w / 2},${b.cy + b.h / 2}`
           + ` L${b.cx + b.w / 2},${b.cy - b.h / 2} L${b.cx - b.w / 2},${b.cy + b.h / 2} z`,
        }));
        break;
      case 'diamond':
        g.appendChild(this._el('path', {
          d: `M${b.cx},${b.cy - b.h / 2} L${b.cx + b.w / 2},${b.cy} L${b.cx},${b.cy + b.h / 2} L${b.cx - b.w / 2},${b.cy} z`,
        }));
        break;
      default:
        g.appendChild(this._el('circle', { cx: b.cx, cy: b.cy, r: Math.max(b.w, b.h) / 2 }));
    }
    g.addEventListener('pointerdown', (e) => this._beginElementDrag(e, d, id));
    g.addEventListener('dblclick', () => this._editLabel(d, id));
    this._layer.nodes.appendChild(g);

    if (node.label) {
      // The notation's default anchor: a compartment holds its label; a valve's
      // goes BELOW its glyph, since influences into it bow overhead; everything
      // else sits above. The user's own offset is added on top.
      let ly;
      if (b.shape === 'rect') ly = b.cy + 4;
      else if (b.shape === 'valve') ly = b.cy + b.h / 2 + 13;
      else ly = b.cy - b.h / 2 - 6;
      this._placeLabel(d, id, node.label, b.cx, ly);
    }
  },

  /**
   * Draw an arc as its **segments** (§13). The point chain comes from the model
   * layer — source, each port it passes through, target — so the number of
   * segments is derived here too, never stored. Each segment is its own path
   * element, which is what later makes per-segment hit-testing and collapse
   * possible; only the last one carries the arrowhead.
   */
  /**
   * Draw a label at the notation's default anchor plus any offset the user has
   * dragged it to, and make it draggable. The offset is layout, stored per
   * element — the default stays the schema's business, so a label that has
   * never been moved follows the notation if that changes.
   */
  _placeLabel(d, id, text, ax, ay, cls) {
    const off = (this._labelDrag && this._labelDrag.id === id)
      ? this._labelDrag.off
      : (d.labelOffset(id) || { dx: 0, dy: 0 });
    // The label carries the completeness class too: it lives in its own layer,
    // so the class on the glyph's group does not reach it — and the NAME going
    // red is the part of the convention a modeller actually reads.
    const full = (cls || 'slx-label') + (this._incomplete(d, id) ? ' slx-incomplete' : '');
    const t = this._text(ax + (off.dx || 0), ay + (off.dy || 0), text, full);
    t.setAttribute('data-label-for', id);
    t.addEventListener('pointerdown', (e) => this._beginLabelDrag(e, d, id, off));
    this._layer.labels.appendChild(t);
    return t;
  },

  _beginLabelDrag(e, d, id, off) {
    if (this._tool) return;                       // placing/connecting takes precedence
    if (this._isDoubleClick(id)) {
      e.preventDefault();
      e.stopPropagation();
      // (c) A label sitting INSIDE its node's rectangle counts as part of the
      // node, so double-clicking it opens the node's dialog. A label that has
      // been dragged clear of the glyph is just a label — nothing to open.
      const inside = this._insideBox(d.box(id), this._toWorld(e.clientX, e.clientY));
      if (inside) return this._openDialog(d, id);
      return;
    }
    e.preventDefault();
    e.stopPropagation();                          // not a drag of the element itself
    const origin = this._toWorld(e.clientX, e.clientY);
    const start = { dx: off.dx || 0, dy: off.dy || 0 };
    const handle = e.currentTarget;
    if (handle.setPointerCapture) {
      try { handle.setPointerCapture(e.pointerId); } catch (err) { /* not captured */ }
    }

    const move = (ev) => {
      const w = this._toWorld(ev.clientX, ev.clientY);
      this._labelDrag = {
        id,
        off: { dx: start.dx + (w.x - origin.x), dy: start.dy + (w.y - origin.y) },
      };
      this._render();
    };
    const end = () => {
      $(document).off('pointermove', move).off('pointerup pointercancel', end);
      const final = this._labelDrag && this._labelDrag.off;
      this._labelDrag = null;
      const moved = final && (final.dx !== start.dx || final.dy !== start.dy);
      if (moved) {
        d.moveLabel(id, final.dx, final.dy);      // one action per drag
        this._render();
        return;
      }
      // (b) A press on a label that never moved is a request to EDIT it — one
      // click, not two. (A click that moved nothing must not re-render: that is
      // what used to destroy the DOM node mid-double-click.)
      this._editLabel(d, id);
    };
    $(document).on('pointermove', move).on('pointerup pointercancel', end);
  },

  _renderArc(d, id, arc) {
    const pts = this._chainFor(d, id, arc);
    if (pts.length < 2) return;

    const crossings = d.portsFor(id).length;
    const marker = arc.type === 'flow' ? 'slx-arrow-flow' : 'slx-arrow-influence';
    const bow = this._bowFor(d, id, arc);
    const curved = Math.abs(bow) > 0.001;
    const head = this._ARROW_LEN[arc.type] || 4.5;
    const ov = this._overrides();

    for (let i = 0; i < pts.length - 1; i++) {
      const last = i === pts.length - 2;
      let dAttr;

      if (curved) {
        // Only the true ends have a glyph to trim against; a port is a bare
        // point on a boundary, so the segment runs right up to it.
        const boxA = i === 0 ? d.box(arc.from, ov) : null;
        const boxZ = last ? d.box(arc.to, ov) : null;
        const seg = this._arcPath(pts[i], pts[i + 1], boxA, boxZ, bow, last ? head : 0);
        if (!seg) continue;
        dAttr = seg.d;
      } else {
        dAttr = `M${pts[i].x},${pts[i].y} L${pts[i + 1].x},${pts[i + 1].y}`;
      }

      // A wide invisible twin under the visible stroke: a 0.8px hairline is
      // impossible to hit otherwise, so this is what the pointer actually grabs.
      const hit = this._el('path', {
        class: 'slx-arc-hit', 'data-id': id, 'data-segment': i, d: dAttr,
      });
      if (curved) {
        hit.addEventListener('pointerdown', (e) => this._beginBowDrag(e, d, id, pts[i], pts[i + 1]));
      }
      this._layer.arcs.appendChild(hit);

      const path = this._el('path', {
        class: 'slx-arc slx-arc-' + arc.type + (crossings ? ' slx-arc-split' : ''),
        'data-id': id,
        'data-segment': i,
        d: dAttr,
      });
      if (last) path.setAttribute('marker-end', 'url(#' + marker + ')');
      this._layer.arcs.appendChild(path);
    }

    // An arc type may carry a label — in this notation only `role` does (§14),
    // and until the reference models were built nothing drew it, so a
    // two-role association showed as two unnamed arcs. It sits at the middle of
    // the chain, pushed out along the bow so that fanned siblings do not stack
    // their labels on one another, and it is draggable like any other.
    if (arc.label && d.arcType(arc.type).has_label) {
      const mid = Math.max(0, Math.floor((pts.length - 1) / 2));
      const a = pts[mid];
      const z = pts[mid + 1] || pts[mid];
      const len = Math.hypot(z.x - a.x, z.y - a.y) || 1;
      this._placeLabel(
        d, id, arc.label,
        (a.x + z.x) / 2 - ((z.y - a.y) / len) * (len * bow) / 2,
        (a.y + z.y) / 2 + ((z.x - a.x) / len) * (len * bow) / 2 - 3,
        'slx-label slx-arc-label'
      );
    }
  },

  /**
   * Where this arc sits among those sharing the same pair of endpoints, as
   * {i, n}. Direction is ignored: A→B and B→A would still be drawn on top of
   * one another.
   */
  _fanOf(d, id, arc) {
    const key = [arc.from, arc.to].sort().join('|');
    const set = d.ids('arcs').filter((a) => {
      const x = d.get(a);
      return x && [x.from, x.to].sort().join('|') === key;
    });
    return { i: Math.max(0, set.indexOf(id)), n: set.length };
  },

  /**
   * How much this arc bows. Three sources, in order: what the user dragged or
   * stored; a FAN, when several arcs share the same two endpoints; else the
   * notation's default for the type (influences curve, everything else is
   * straight — §7.5).
   *
   * The fan is why this exists. Two arcs between the same pair are otherwise
   * drawn identically, pixel for pixel — which is exactly the shape of a
   * self-association, where `me` and `my_neighbour` both run from PATCH to
   * NEXT_TO. The land-use reference model rendered them as one arc until this
   * was added (2026-08-06). Spreading them is a RENDERING decision, derived at
   * paint time from the endpoint pairs, with nothing stored: drag one and the
   * stored bow takes over, as it always did.
   */
  _bowFor(d, id, arc) {
    if (this._bowDrag && this._bowDrag.id === id) return this._bowDrag.bow;
    const stored = d.arcBow(id);
    if (stored != null) return stored;

    const base = arc.type === 'influence' ? this.options.bowFraction : 0;
    const fan = this._fanOf(d, id, arc);
    if (fan.n < 2) return base;
    return base + (fan.i - (fan.n - 1) / 2) * this.options.fanBow;
  },

  /**
   * Drag an influence's curvature. The new bow is the pointer's signed
   * perpendicular distance from the segment's chord, as a fraction of it — so
   * dragging across the chord flips the bend to the other side. Nothing is
   * written until the drop: one action, one undo step.
   */
  _beginBowDrag(e, d, id, a, z) {
    if (this._tool || this._drag || this._portDrag || this._bowDrag) return;
    e.preventDefault();
    e.stopPropagation();
    const handle = e.currentTarget;
    if (handle.setPointerCapture) {
      try { handle.setPointerCapture(e.pointerId); } catch (err) { /* not captured */ }
    }
    const start = this._bowOf(d, id);

    const move = (ev) => {
      const w = this._toWorld(ev.clientX, ev.clientY);
      const dx = z.x - a.x;
      const dy = z.y - a.y;
      const c = Math.hypot(dx, dy);
      if (c < 1) return;
      // Signed distance from the chord, positive on the side the default bows.
      const side = ((w.x - a.x) * dy - (w.y - a.y) * dx) / c;
      // Clamped so the sagitta stays under half the chord: beyond that the arc
      // exceeds a semicircle, which a large-arc-flag of 0 cannot express, and
      // the curve would silently snap to the minor arc on the far side.
      this._bowDrag = { id, bow: Math.max(-this._MAX_BOW, Math.min(this._MAX_BOW, -side / c)) };
      this._render();
    };
    const end = () => {
      $(document).off('pointermove', move).off('pointerup pointercancel', end);
      const final = this._bowDrag && this._bowDrag.bow;
      this._bowDrag = null;
      if (final != null && final !== start) d.setArcBow(id, final);
      this._render();
    };
    $(document).on('pointermove', move).on('pointerup pointercancel', end);
  },

  /**
   * The points an arc is drawn through, with the two ends pulled back to the
   * glyph edges. A flow runs STRAIGHT from one end to the other: its valve sits
   * at the midpoint (derived — see Diagram.box) and rides on the line rather
   * than being a bend in it.
   */
  _chainFor(d, id, arc) {
    const pts = d.arcPoints(id, this._overrides()).slice();
    if (pts.length < 2) return pts;

    // Every box lookup here must see the drag override, or a dragged glyph
    // slides away from the arc that is attached to it.
    const ov = this._overrides();

    // An INFLUENCE keeps the raw centres: its arc is defined THROUGH them and
    // trimmed where it crosses each glyph (see _arcPath), which is what makes
    // it look like it leaves the node rather than a point on its rim. Straight
    // arcs can be clipped here, since chord and curve coincide.
    if (arc.type === 'influence') return pts;

    pts[0] = this._edge(d.box(arc.from, ov), pts[1]);
    pts[pts.length - 1] = this._edge(d.box(arc.to, ov), pts[pts.length - 2]);

    // Stop the line short so the arrowhead — anchored at its base — reaches the
    // glyph edge on its own. Without this the stroke's square end shows through
    // the point of the arrow.
    const n = pts.length - 1;
    const head = this._ARROW_LEN[arc.type] || 7;
    const dx = pts[n].x - pts[n - 1].x;
    const dy = pts[n].y - pts[n - 1].y;
    const len = Math.hypot(dx, dy);
    if (len > head) {
      pts[n] = { x: pts[n].x - (dx / len) * head, y: pts[n].y - (dy / len) * head };
    }
    return pts;
  },

  /**
   * A port handle. Ports are auto-placed but user-owned (ruling 15), so they
   * are draggable — constrained to the boundary they belong to, since a port
   * that left its boundary would not be a crossing point at all.
   *
   * A drag writes NOTHING until it is dropped: mid-drag positions are previewed
   * through `_portDrag`, and the drop is one `movePort` action, so the whole
   * gesture is a single undo step.
   */
  _renderPort(d, port) {
    const ov = this._overrides();
    const pos = (ov && ov[port.key]) || port;
    const h = this._el('circle', {
      class: 'slx-port' + (port.shared ? ' slx-port-shared' : ''),
      cx: pos.x, cy: pos.y, r: 5,
      'data-port': port.key,
    });
    const title = this._el('title');
    title.textContent = port.shared
      ? `shared exit of ${d.label(port.owner) || port.owner} (${port.arcs.length} arc${port.arcs.length > 1 ? 's' : ''})`
      : `crossing of ${port.owner}`;
    h.appendChild(title);

    h.addEventListener('pointerdown', (e) => this._beginPortDrag(e, d, port));
    this._layer.overlay.appendChild(h);
  },

  _beginPortDrag(e, d, port) {
    e.preventDefault();
    e.stopPropagation();               // never let this start a canvas pan
    if (this._portDrag) return;        // a drag is already in flight
    const rect = d.box(port.boundary);
    const start = { x: port.x, y: port.y };

    // Capture the pointer so we still hear move/up if it leaves the handle —
    // and so a lost pointerup cannot strand the document-level listeners.
    const handle = e.currentTarget;
    if (handle.setPointerCapture) {
      try { handle.setPointerCapture(e.pointerId); } catch (err) { /* not captured */ }
    }

    const move = (ev) => {
      const w = this._toWorld(ev.clientX, ev.clientY);
      this._portDrag = { [port.key]: this._ontoRect(w, rect) };
      this._render();
    };
    const end = () => {
      $(document).off('pointermove', move).off('pointerup pointercancel', end);
      const final = this._portDrag && this._portDrag[port.key];
      this._portDrag = null;
      // A click that never moved is not an edit: no action, so no undo entry.
      if (final && (final.x !== start.x || final.y !== start.y)) {
        d.movePort(port.key, final.x, final.y);          // ONE action per drag
      }
      this._render();
    };
    $(document).on('pointermove', move).on('pointerup pointercancel', end);
  },

  /** Positions being previewed by an in-flight drag (ports or elements). */
  _overrides() {
    if (this._portDrag) return this._portDrag;
    return this._drag ? this._drag.moves : null;
  },

  /**
   * Drag an element. A submodel carries everything inside it — and the ports on
   * its own boundary — because §11.4 chose ONE flat coordinate space with no
   * nested transforms: translation is explicit, computed through the derived
   * child index, which is the cost that choice deliberately accepted.
   *
   * Like a port drag, nothing is written until the drop, so the gesture is one
   * undo step. On drop the element may also change parent, which is a model
   * change rather than a layout one.
   */
  /**
   * Draw an arc: press on the source, release on the target. A flow released
   * over blank canvas gets a cloud there, because the schema says a flow's
   * blank end is a cloud — the same path the API takes (§4).
   *
   * NOTE: nothing checks that the connection is legal. The grammar engine does
   * not exist yet, so the rules in the schema are declared and unconsulted
   * (§12.3 would make these preventive, refusing the gesture mid-drag).
   */
  _beginArcDraw(e, d, fromId) {
    if (!d) return;
    e.preventDefault();
    e.stopPropagation();
    const type = this._tool.split(':')[1];
    // A null source means the gesture began on blank canvas: the anchor is the
    // press point, and a flow will grow a cloud there (the schema's blankEnd).
    const start = fromId ? d.box(fromId) : (() => {
      const w = this._toWorld(e.clientX, e.clientY);
      return { cx: w.x, cy: w.y };
    })();
    const rubber = this._el('path', { class: 'slx-rubber' });
    this._layer.overlay.appendChild(rubber);

    const move = (ev) => {
      const w = this._toWorld(ev.clientX, ev.clientY);
      rubber.setAttribute('d', `M${start.cx},${start.cy} L${w.x},${w.y}`);
      const over = this._elementAt(ev);
      this._layer.overlay.querySelectorAll('.slx-arc-target').forEach((n) => n.classList.remove('slx-arc-target'));
      const g = over && this.element[0].querySelector(`[data-id="${over}"]`);
      if (g) g.classList.add('slx-arc-target');
    };
    const end = (ev) => {
      $(document).off('pointermove', move).off('pointerup pointercancel', end);
      rubber.remove();
      this.element[0].querySelectorAll('.slx-arc-target').forEach((n) => n.classList.remove('slx-arc-target'));
      const toId = this._elementAt(ev);
      const w = this._toWorld(ev.clientX, ev.clientY);
      this._tool = null;
      this._syncPalette();
      this._createArc(d, type, fromId, toId, w, { x: start.cx, y: start.cy });
      this._render();
    };
    $(document).on('pointermove', move).on('pointerup pointercancel', end);
  },

  _createArc(d, type, fromId, toId, dropPoint, anchor) {
    // §12.3: structural rules are PREVENTIVE — refuse the gesture and say why.
    const verdict = Sienna.grammar.mayConnect(d, type, fromId, toId);
    if (!verdict.ok) { this._flash(verdict.message); return; }

    if (type === 'flow') {
      if (!fromId && !toId) return;                // a flow with neither end is nothing
      // Either blank end becomes a cloud: addFlow does that when an end is null,
      // and the valve sits midway between the two ends.
      const a = fromId ? d.box(fromId) : anchor && { cx: anchor.x, cy: anchor.y };
      const z = toId ? d.box(toId) : { cx: dropPoint.x, cy: dropPoint.y };
      const made = d.addFlow({
        from: fromId || null,
        to: toId || null,
        x: (a.cx + z.cx) / 2, y: (a.cy + z.cy) / 2,        // the valve
        fromXY: fromId ? null : { x: anchor.x, y: anchor.y },
        toXY: toId ? null : { x: dropPoint.x, y: dropPoint.y },
        parent: d.parentOf(fromId || toId),
      });
      this._editLabel(d, made.valve);
      return;
    }
    // An influence or role needs two real ends.
    if (!fromId || !toId || toId === fromId) return;
    if (type === 'influence') d.addInfluence(fromId, toId);
    else if (type === 'role') d.addRole(fromId, toId, { label: '' });
  },

  /** The topmost model element under a pointer event, or null for blank canvas. */
  _elementAt(ev) {
    const el = document.elementFromPoint(ev.clientX, ev.clientY);
    const g = el && el.closest('[data-id]');
    return g ? g.getAttribute('data-id') : null;
  },

  _beginElementDrag(e, d, id) {
    if (this._tool && this._tool.indexOf('arc:') === 0) return this._beginArcDraw(e, d, id);
    if (!this._tool && this._isDoubleClick(id)) {
      e.preventDefault();
      e.stopPropagation();
      return this._openDialog(d, id);            // (c) the node's own dialog
    }
    // With a placing tool armed, a press on an existing element is still a
    // placement, not a drag — otherwise nothing could ever be put INSIDE a
    // submodel, since the submodel's own body covers its whole interior.
    if (this._tool === 'submodel:submodel') { e.stopPropagation(); return this._beginSubmodelDraw(e); }
    if (this._tool) { e.stopPropagation(); return this._placeAt(e); }
    if (this._drag || this._portDrag) return;
    e.preventDefault();
    e.stopPropagation();

    // Dragging one of a multiple selection drags all of it.
    const group = this._sel.indexOf(id) >= 0 && this._sel.length > 1 ? this._sel.slice() : [id];
    const isSub = id.indexOf('submodel') === 0;
    let carried = [];
    group.forEach((gid) => {
      carried.push(gid);
      if (gid.indexOf('submodel') === 0) carried = carried.concat(d.descendantsOf(gid));
    });
    const keys = carried.filter((v, i, a) => a.indexOf(v) === i);
    // A submodel's boundary ports travel with it, as do those of its contents.
    const portKeys = [];
    keys.forEach((k) => {
      if (k.indexOf('submodel') === 0) portKeys.push(...d.portsOn(k));
    });

    const start = {};
    keys.concat(portKeys).forEach((k) => {
      const g = k.indexOf('ports/') === 0 ? d.layout(k) : d.appearanceOf(k);
      if (g) start[k] = { x: g.x, y: g.y, w: g.w, h: g.h };
    });

    const origin = this._toWorld(e.clientX, e.clientY);
    const additive = e.shiftKey || e.ctrlKey || e.metaKey;
    const handle = e.currentTarget;
    if (handle.setPointerCapture) {
      try { handle.setPointerCapture(e.pointerId); } catch (err) { /* not captured */ }
    }

    const move = (ev) => {
      const w = this._toWorld(ev.clientX, ev.clientY);
      const dx = w.x - origin.x;
      const dy = w.y - origin.y;
      const moves = {};
      Object.keys(start).forEach((k) => {
        moves[k] = Object.assign({}, start[k], { x: start[k].x + dx, y: start[k].y + dy });
        if (moves[k].w === undefined) delete moves[k].w;
        if (moves[k].h === undefined) delete moves[k].h;
      });
      this._drag = { id, moves, dropTarget: isSub ? null : this._dropTargetAt(d, w, id) };
      this._render();
    };
    const end = () => {
      $(document).off('pointermove', move).off('pointerup pointercancel', end);
      const drag = this._drag;
      this._drag = null;
      const moved = drag && drag.moves[id]
        && (drag.moves[id].x !== start[id].x || drag.moves[id].y !== start[id].y);
      // (a) A press that never moved is a SELECTION, not a drag.
      if (!moved) {
        this._select(id, additive);
        this._render();
        return;
      }
      if (moved) {
        const newParent = drag.dropTarget !== undefined ? drag.dropTarget : null;
        const changed = !isSub && newParent !== d.parentOf(id);
        if (changed) {
          const verdict = Sienna.grammar.mayContain(d, id, newParent);
          if (!verdict.ok) {
            // Refuse the whole drop, not just the re-parenting: leaving the
            // element sitting inside a submodel it does not belong to would be
            // a diagram that lies about its own model.
            this._flash(verdict.message);
            this._render();
            return;
          }
        }
        d.commitDrag(drag.moves, changed ? { id, parent: newParent } : null);
      }
      if (moved || drag) this._render();
    };
    $(document).on('pointermove', move).on('pointerup pointercancel', end);
  },

  /**
   * The submodel a dropped point lands in: the DEEPEST one containing it, so
   * nesting resolves inward. `exclude` keeps an element from being dropped into
   * itself or its own contents.
   */
  _dropTargetAt(d, pt, exclude) {
    let best = null;
    let bestDepth = -1;
    d.ids('submodels').forEach((sid) => {
      if (sid === exclude || d.ancestorsOf(sid).indexOf(exclude) >= 0) return;
      const b = d.box(sid, this._drag && this._drag.moves);
      if (pt.x < b.cx - b.w / 2 || pt.x > b.cx + b.w / 2) return;
      if (pt.y < b.cy - b.h / 2 || pt.y > b.cy + b.h / 2) return;
      const depth = d.ancestorsOf(sid).length;
      if (depth > bestDepth) { best = sid; bestDepth = depth; }
    });
    return best;
  },

  /**
   * Rename in place. An HTML input floated over the glyph, NOT a browser
   * prompt: a modal dialog blocks the page, and the label needs validating
   * against the schema's naming rule as it is typed (§14 — no spaces).
   */
  _editLabel(d, id) {
    const el = d.get(id);
    if (!el || (id.indexOf('arc') === 0 && !d.arcType(el.type).has_label)) return;
    // Position over the LABEL where it actually sits — which may have been
    // dragged away from its glyph — falling back to the glyph when there is no
    // label drawn. Taken from the rendered node rather than recomputing the
    // world->screen transform, so it cannot drift out of step with pan/zoom or
    // the palette's height.
    const g = this.element[0].querySelector(`[data-label-for="${id}"]`)
      || this.element[0].querySelector(`[data-id="${id}"]`);
    const host = this.element[0].getBoundingClientRect();
    const gr = g ? g.getBoundingClientRect() : null;
    const left = (gr ? gr.left + gr.width / 2 - host.left : 20) - 50;
    const top = (gr ? gr.top + gr.height / 2 - host.top : 20) - 10;

    this.element.find('.slx-label-edit').remove();
    const input = $('<input class="slx-label-edit" type="text">')
      // Empty label? Offer the id, so a label that was deleted can be revived
      // by double-clicking the glyph and pressing Enter.
      .val(el.label || id)
      .css({ left, top })
      .appendTo(this.element);

    let live = false;
    const commit = (save) => {
      if (!input.parent().length) return;
      const text = String(input.val() || '').trim();
      input.remove();
      if (!save) return;
      try {
        d.setLabel(id, text);
      } catch (err) {
        this._flash(err.message);                 // the schema refused the name
      }
      this._render();
    };
    input.on('keydown', (e) => {
      e.stopPropagation();
      if (e.key === 'Enter') commit(true);
      else if (e.key === 'Escape') commit(false);
    });
    // Only honour a blur once the field has actually held focus: the mouseup of
    // the very click that created the element would otherwise blur it away
    // before the user can type.
    input.on('focus', () => { live = true; });
    input.on('blur', () => { if (live) commit(true); });
    // preventScroll matters: this element is the panel's scrollable content, so
    // focusing a field near the edge would otherwise scroll the whole diagram.
    setTimeout(() => {
      if (!input.parent().length) return;
      input[0].focus({ preventScroll: true });
      input[0].select();
    }, 0);
  },

  /** Transient message — used for a rule the schema refused. */
  _flash(text) {
    const note = $('<div class="slx-flash">').text(text).appendTo(this.element);
    setTimeout(() => note.fadeOut(200, () => note.remove()), 2200);
  },

  /**
   * (a) Selection. A plain click replaces the selection; shift/ctrl/cmd adds to
   * or removes from it. Selection is the hook everything else hangs off — a
   * properties panel, dragging several elements at once, and later deletion.
   */
  _select(id, additive) {
    if (!additive) {
      this._sel = id ? [id] : [];
      return;
    }
    if (!id) return;
    const i = this._sel.indexOf(id);
    if (i >= 0) this._sel.splice(i, 1);
    else this._sel.push(id);
  },

  /**
   * (3) The whole-model pass. Reports, never blocks — it catches states reached
   * by routes the preventive checks do not sit on: a submodel capture, an
   * import, or a kind changed under contents that were legal before (§12.5's
   * non-monotonicity).
   *
   * Two passes, deliberately kept apart and merely concatenated here: the graph
   * rules from the schema (`Sienna.grammar`) and the equations against the
   * diagram (`Sienna.equationCheck`). Neither knows about the other, and the
   * user has no reason to care which found what — one report, graph breaches
   * first because they are the structural ones.
   */
  _validate() {
    const d = this._diagram();
    if (!d) return;
    const found = Sienna.grammar.validate(d).concat(
      Sienna.equationCheck ? Sienna.equationCheck.audit(d) : []
    );
    if (!found.length) { this._flash('No problems found'); return; }
    this._sel = found.map((v) => v.id).filter((id, i, a) => a.indexOf(id) === i);
    this._render();
    this._flash(`${found.length} problem${found.length > 1 ? 's' : ''}: ${found[0].label} — ${found[0].message}`);
  },

  /**
   * Delete what is selected, with everything the schema says must go with it —
   * a submodel's contents, an element's arcs, a flow's valve, a cloud that has
   * just lost its last flow. One action, so one undo step, however wide the
   * cascade; the count is reported since a delete can reach much further than
   * what was selected.
   */
  _deleteSelection() {
    const d = this._diagram();
    if (!d || !this._sel.length) return;
    const asked = this._sel.length;
    const gone = d.remove(this._sel);
    this._sel = [];
    this._render();
    if (gone.length > asked) {
      this._flash(`Deleted ${gone.length} elements (${asked} selected, ${gone.length - asked} attached)`);
    }
  },

  /**
   * Ungroup the selected submodels: dissolve the box, keep the contents. The
   * counterpart to deleting one, which takes the contents with it.
   *
   * The promoted contents are left SELECTED — they are what the user still has
   * in hand, and the box they were selected inside no longer exists. Anything
   * that had to go with the box (an arc attached to the box itself) is
   * reported, as a delete's cascade is, since it is more than was asked for.
   * A breach of containment created by the promotion is reported too, never
   * refused, in the manner of submodel capture (§12.5).
   */
  _ungroupSelection() {
    const d = this._diagram();
    if (!d) return;
    const boxes = this._sel.filter((id) => id.indexOf('submodel') === 0 && d.get(id));
    if (!boxes.length) { this._flash('Select a submodel to ungroup'); return; }

    const { promoted, removed } = d.ungroup(boxes);
    this._sel = promoted.filter((id) => d.get(id));
    this._render();

    const extra = removed.length - boxes.length;
    if (extra > 0) {
      this._flash(`Ungrouped, keeping ${promoted.length} — ${extra} attached element${extra > 1 ? 's' : ''} went with the box`);
      return;
    }
    const bad = Sienna.grammar.validate(d).filter((v) => promoted.indexOf(v.id) >= 0);
    if (bad.length) this._flash(`${bad[0].message} (${bad.length} to fix)`);
  },

  /**
   * (c) The element's own settings dialog, built from the schema's field model
   * for its type (see src/dialog.js). It writes through the model layer, so the
   * widget re-renders from the resulting userData change like any other edit.
   */
  _openDialog(d, id) {
    this._select(id, false);
    this._render();
    if (Sienna.propertyDialog) Sienna.propertyDialog(d, id, this.element);
  },

  /**
   * Our own double-click detection, keyed on the element ID rather than the DOM
   * node. The native `dblclick` cannot be relied on here: every gesture ends in
   * a re-render that REPLACES the SVG element, so the browser sees two clicks
   * on two different nodes and never pairs them.
   */
  _isDoubleClick(id) {
    const now = Date.now();
    const prev = this._lastClick;
    this._lastClick = { id, t: now };
    return !!(prev && prev.id === id && now - prev.t < 450);
  },

  /** Nearest point on a rectangle's perimeter — a port lives ON its boundary. */
  _ontoRect(p, rect) {
    const x1 = rect.cx - rect.w / 2, x2 = rect.cx + rect.w / 2;
    const y1 = rect.cy - rect.h / 2, y2 = rect.cy + rect.h / 2;
    const x = Math.min(x2, Math.max(x1, p.x));
    const y = Math.min(y2, Math.max(y1, p.y));
    // Snap to whichever edge is closest.
    const d4 = [x - x1, x2 - x, y - y1, y2 - y];
    const m = Math.min.apply(null, d4);
    if (m === d4[0]) return { x: x1, y };
    if (m === d4[1]) return { x: x2, y };
    if (m === d4[2]) return { x, y: y1 };
    return { x, y: y2 };
  },

  /**
   * An influence, drawn as an ARC OF A CIRCLE **through the two node centres**,
   * then trimmed where it crosses each glyph. Defining the circle by the
   * centres is what makes the arrow appear to come from the node rather than
   * from an arbitrary point on its rim. (Simile does not do this; we take the
   * chance to correct it.)
   *
   * For chord c and SIGNED sagitta h, radius = (c² / 4 + h²) / 2|h|. The sign
   * of h chooses the side, so a negative bow bends the other way.
   *
   * Trimming walks the arc rather than solving circle-against-glyph
   * analytically: glyphs are rects, circles, clouds and bow-ties, and a walk is
   * exact enough at these sizes while working for all of them.
   */
  _arcPath(a, z, boxA, boxZ, bow, head) {
    const dx = z.x - a.x;
    const dy = z.y - a.y;
    const c = Math.hypot(dx, dy);
    if (c < 1) return null;

    const h = c * Math.max(-this._MAX_BOW, Math.min(this._MAX_BOW, bow));
    if (Math.abs(h) < 0.5) return this._straightTrim(a, z, boxA, boxZ, head);

    const sgn = h < 0 ? -1 : 1;
    const r = (c * c / 4 + h * h) / (2 * Math.abs(h));
    const nx = -dy / c;
    const ny = dx / c;
    const cx = (a.x + z.x) / 2 - nx * sgn * (r - Math.abs(h));
    const cy = (a.y + z.y) / 2 - ny * sgn * (r - Math.abs(h));

    const a1 = Math.atan2(a.y - cy, a.x - cx);
    const a2 = Math.atan2(z.y - cy, z.x - cx);
    let delta = a2 - a1;
    while (delta > Math.PI) delta -= 2 * Math.PI;
    while (delta < -Math.PI) delta += 2 * Math.PI;

    const at = (t) => ({
      x: cx + r * Math.cos(a1 + delta * t),
      y: cy + r * Math.sin(a1 + delta * t),
    });

    const STEPS = 240;
    let t0 = 0;
    if (boxA) while (t0 < 1 && this._insideBox(boxA, at(t0))) t0 += 1 / STEPS;
    let t1 = 1;
    if (boxZ) while (t1 > t0 && this._insideBox(boxZ, at(t1))) t1 -= 1 / STEPS;
    if (head) {
      const arcLen = Math.abs(delta) * r;
      if (arcLen > 0) t1 -= head / arcLen;
    }
    if (t1 <= t0) return null;

    const p0 = at(t0);
    const p1 = at(t1);
    return { d: `M${p0.x},${p0.y} A${r},${r} 0 0,${delta > 0 ? 1 : 0} ${p1.x},${p1.y}`, from: p0, to: p1 };
  },

  /** The straight case of the above, used when the bow is ~0. */
  _straightTrim(a, z, boxA, boxZ, head) {
    const p0 = boxA ? this._edge(boxA, z) : a;
    let p1 = boxZ ? this._edge(boxZ, a) : z;
    const dx = p1.x - p0.x;
    const dy = p1.y - p0.y;
    const len = Math.hypot(dx, dy);
    if (head && len > head) p1 = { x: p1.x - (dx / len) * head, y: p1.y - (dy / len) * head };
    return { d: `M${p0.x},${p0.y} L${p1.x},${p1.y}`, from: p0, to: p1 };
  },

  /** Is a point within a glyph's own shape? */
  _insideBox(b, p) {
    const dx = p.x - b.cx;
    const dy = p.y - b.cy;
    if (b.shape === 'rect') return Math.abs(dx) <= b.w / 2 && Math.abs(dy) <= b.h / 2;
    const r = Math.max(b.w, b.h) / 2;
    return dx * dx + dy * dy <= r * r;
  },

  /** An arc's curvature: a live drag, else the stored value, else the default. */
  _bowOf(d, id) {
    if (this._bowDrag && this._bowDrag.id === id) return this._bowDrag.bow;
    const stored = d.arcBow(id);
    return stored == null ? this.options.bowFraction : stored;
  },


  /**
   * Frame the content (world coords; the view transform does the work). Re-runs
   * whenever the panel is resized — but stops as soon as the user pans or zooms,
   * since after that the view is theirs, not ours. `force` is the view bar's
   * "fit" command: asking for it explicitly overrides that, and leaves the view
   * flagged as the user's, so the next resize does not silently re-fit.
   */
  _fit(force) {
    if (this._userView && !force) return;
    const box = this._root.getBBox ? this._root.getBBox() : null;
    if (!box || !box.width) return;
    const r = this._svg.getBoundingClientRect();
    if (!r.width) return;
    const pad = this.options.padding;
    // Scale up to fill the panel, but only so far: a two-node model blown up
    // to full screen looks absurd. Then CENTRE — with that cap in play, framing
    // from the top-left corner leaves a small model stranded up there.
    const k = Math.min(this.options.maxFitScale, (r.width - pad * 2) / box.width, (r.height - pad * 2) / box.height);
    if (!this._centreContent(k)) return;
    if (force) this._userView = true;
    this._applyView();
  },

  // ---- small SVG helpers ----------------------------------------------

  _el(name, attrs) {
    const n = document.createElementNS('http://www.w3.org/2000/svg', name);
    Object.keys(attrs || {}).forEach((k) => n.setAttribute(k, attrs[k]));
    return n;
  },

  _text(x, y, str, cls) {
    const t = this._el('text', { x, y, class: cls });
    t.textContent = str;
    return t;
  },

  /**
   * An arrowhead anchored at its BASE (refX 0), not its tip. The line is then
   * shortened by the head's length (see ARROW_LEN), so the stroke stops where
   * the triangle begins. With the line running all the way to the tip instead,
   * its flat cap is wider than the triangle's apex and pokes out either side —
   * the blunt-tipped arrow this avoids.
   */
  _marker(id, path, w, h) {
    const m = this._el('marker', {
      id, markerWidth: w, markerHeight: h * 2, refX: 0, refY: h,
      orient: 'auto', markerUnits: 'userSpaceOnUse',
    });
    m.appendChild(this._el('path', { d: path }));
    return m;
  },

  _cloudPath(b) {
    const { cx, cy, w, h } = b;
    const r = h / 2;
    return `M${cx - w / 2},${cy + r * 0.4}
            a${r * 0.7},${r * 0.7} 0 0 1 ${r * 0.2},-${r}
            a${r * 0.8},${r * 0.8} 0 0 1 ${r * 1.4},-${r * 0.4}
            a${r * 0.8},${r * 0.8} 0 0 1 ${r * 1.5},${r * 0.5}
            a${r * 0.7},${r * 0.7} 0 0 1 ${r * 0.1},${r * 0.9} z`.replace(/\s+/g, ' ');
  },

  _destroy() {
    if (this._ro) this._ro.disconnect();
    if (this._unsub) this._unsub();
    this.element.removeClass('slx-diagram').empty();
  },
});

window.Sienna.widgetRegistry._loaded('diagram', 'diagram');
