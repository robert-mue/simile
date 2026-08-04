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
  },

  // Layers, painted in this order (SVG has no z-index).
  _LAYERS: ['bodies', 'arcs', 'nodes', 'labels', 'overlay'],

  // Arrowhead length per arc type, in world units — must match the marker
  // paths built in _buildCanvas, since the line is shortened by exactly this.
  _ARROW_LEN: { flow: 10, influence: 7, role: 7 },

  _create() {
    this.element.addClass('slx-diagram');

    this._view = { x: 0, y: 0, k: 1 }; // pan/zoom: the one root transform
    this._tool = null;                 // null = select/drag; else a palette tool

    this._buildPalette();
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

    this._on(bar, {
      'click button': (e) => {
        const tool = $(e.currentTarget).attr('data-tool');
        this._tool = this._tool === tool ? null : tool;   // click again to drop it
        this._syncPalette();
      },
    });
    this._on($(document), {
      keydown: (e) => {
        if (e.key === 'Escape') { this._tool = null; this._syncPalette(); }
      },
    });
  },

  _syncPalette() {
    this._palette.find('button').each((i, b) => {
      $(b).toggleClass('slx-active', $(b).attr('data-tool') === this._tool);
    });
    this.element.toggleClass('slx-placing', !!this._tool);
  },

  // ---- canvas ---------------------------------------------------------

  _buildCanvas() {
    const svg = this._svg = this._el('svg', { class: 'slx-diagram-svg' });
    this.element.append(svg);

    // Arrowheads: one marker per arc type, so the schema's styling can grow.
    const defs = this._el('defs');
    defs.appendChild(this._marker('slx-arrow-flow', 'M0,0 L10,4 L0,8 z', 10, 4));
    defs.appendChild(this._marker('slx-arrow-influence', 'M0,1 L7,4 L0,7 z', 7, 4));
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
        if (this._tool) { this._placeAt(e); return; }                  // creating, not panning
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
    const g = this._el('g', { class: 'slx-submodel slx-submodel-' + sub.kind, 'data-id': id });
    g.appendChild(this._el('rect', {
      x: b.cx - b.w / 2, y: b.cy - b.h / 2, width: b.w, height: b.h, rx: 4,
    }));
    if (this._drag && this._drag.dropTarget === id) g.setAttribute('class', g.getAttribute('class') + ' slx-drop-target');
    g.addEventListener('pointerdown', (e) => this._beginElementDrag(e, d, id));
    g.addEventListener('dblclick', () => this._editLabel(d, id));
    this._layer.bodies.appendChild(g);

    if (sub.label) {
      const t = this._text(b.cx - b.w / 2 + 8, b.cy - b.h / 2 + 15, sub.label, 'slx-label slx-submodel-label');
      t.setAttribute('text-anchor', 'start');
      this._layer.labels.appendChild(t);
    }
  },

  _renderNode(d, id, node) {
    const b = this._box(d, id);
    const g = this._el('g', { class: 'slx-node slx-node-' + node.type, 'data-id': id });

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
          d: `M${b.cx - 9},${b.cy - 7} L${b.cx + 9},${b.cy + 7} L${b.cx + 9},${b.cy - 7} L${b.cx - 9},${b.cy + 7} z`,
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
      // A compartment holds its label. A valve's goes BELOW its glyph, because
      // influences into it bow overhead and would collide. Everything else sits
      // above its glyph.
      let ly;
      if (b.shape === 'rect') ly = b.cy + 4;
      else if (b.shape === 'valve') ly = b.cy + b.h / 2 + 13;
      else ly = b.cy - b.h / 2 - 6;
      this._layer.labels.appendChild(this._text(b.cx, ly, node.label, 'slx-label'));
    }
  },

  /**
   * Draw an arc as its **segments** (§13). The point chain comes from the model
   * layer — source, each port it passes through, target — so the number of
   * segments is derived here too, never stored. Each segment is its own path
   * element, which is what later makes per-segment hit-testing and collapse
   * possible; only the last one carries the arrowhead.
   */
  _renderArc(d, id, arc) {
    const pts = this._chainFor(d, id, arc);
    if (pts.length < 2) return;

    // "Split" means a boundary was crossed — NOT merely that the polyline has a
    // bend, which a flow gets from routing through its valve.
    const crossings = d.portsFor(id).length;
    const marker = arc.type === 'flow' ? 'slx-arrow-flow' : 'slx-arrow-influence';
    const bowed = arc.type === 'influence' && !crossings && pts.length === 2;

    for (let i = 0; i < pts.length - 1; i++) {
      const p1 = pts[i];
      const p2 = pts[i + 1];
      const path = this._el('path', {
        class: 'slx-arc slx-arc-' + arc.type + (crossings ? ' slx-arc-split' : ''),
        'data-id': id,
        'data-segment': i,
        d: bowed ? this._bow(p1, p2) : `M${p1.x},${p1.y} L${p2.x},${p2.y}`,
      });
      if (i === pts.length - 2) path.setAttribute('marker-end', 'url(#' + marker + ')');
      this._layer.arcs.appendChild(path);
    }
  },

  /**
   * The points an arc is drawn through, with the two ends pulled back to the
   * glyph edges. A flow with no boundary to cross is routed through its valve;
   * the valve of a *crossing* flow is left where it lies for now.
   */
  _chainFor(d, id, arc) {
    const pts = d.arcPoints(id, this._overrides()).slice();
    if (pts.length < 2) return pts;

    // Every box lookup here must see the drag override, or a dragged glyph
    // slides away from the arc that is attached to it.
    const ov = this._overrides();

    if (arc.type === 'flow' && arc.valve && pts.length === 2) {
      const v = d.box(arc.valve, ov);
      pts.splice(1, 0, { x: v.cx, y: v.cy });
    }

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
    // With a placing tool armed, a press on an existing element is still a
    // placement, not a drag — otherwise nothing could ever be put INSIDE a
    // submodel, since the submodel's own body covers its whole interior.
    if (this._tool) { e.stopPropagation(); return this._placeAt(e); }
    if (this._drag || this._portDrag) return;
    e.preventDefault();
    e.stopPropagation();

    const isSub = id.indexOf('submodel') === 0;
    const carried = isSub ? d.descendantsOf(id) : [];
    const keys = [id].concat(carried);
    // A submodel's boundary ports travel with it, as do those of its contents.
    const portKeys = [];
    if (isSub) {
      [id].concat(carried).forEach((k) => {
        if (k.indexOf('submodel') === 0) portKeys.push(...d.portsOn(k));
      });
    }

    const start = {};
    keys.concat(portKeys).forEach((k) => {
      const g = k.indexOf('ports/') === 0 ? d.layout(k) : d.appearanceOf(k);
      if (g) start[k] = { x: g.x, y: g.y, w: g.w, h: g.h };
    });

    const origin = this._toWorld(e.clientX, e.clientY);
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
      if (drag && drag.moves[id] && (drag.moves[id].x !== start[id].x || drag.moves[id].y !== start[id].y)) {
        const newParent = drag.dropTarget !== undefined ? drag.dropTarget : null;
        const changed = !isSub && newParent !== d.parentOf(id);
        d.commitDrag(drag.moves, changed ? { id, parent: newParent } : null);
      }
      this._render();
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
    if (!el || (id.indexOf('arc') === 0 && !d.arcType(el.type).label)) return;
    // Position from the element as actually rendered, rather than recomputing
    // the world->screen transform by hand: the glyph knows where it is, and
    // this cannot drift out of step with pan/zoom or the palette's height.
    const g = this.element[0].querySelector(`[data-id="${id}"]`);
    const host = this.element[0].getBoundingClientRect();
    const gr = g ? g.getBoundingClientRect() : null;
    const left = (gr ? gr.left + gr.width / 2 - host.left : 20) - 50;
    const top = (gr ? gr.top + gr.height / 2 - host.top : 20) - 10;

    this.element.find('.slx-label-edit').remove();
    const input = $('<input class="slx-label-edit" type="text">')
      .val(el.label || '')
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

  /** A single-segment influence keeps Simile's slight bow. */
  _bow(p1, p2) {
    const mx = (p1.x + p2.x) / 2;
    const my = (p1.y + p2.y) / 2;
    const nx = -(p2.y - p1.y) * 0.25;
    const ny = (p2.x - p1.x) * 0.25;
    return `M${p1.x},${p1.y} Q${mx + nx},${my + ny} ${p2.x},${p2.y}`;
  },

  /**
   * Frame the content (world coords; the view transform does the work). Re-runs
   * whenever the panel is resized — but stops as soon as the user pans or zooms,
   * since after that the view is theirs, not ours.
   */
  _fit() {
    if (this._userView) return;
    const box = this._root.getBBox ? this._root.getBBox() : null;
    if (!box || !box.width) return;
    const r = this.element[0].getBoundingClientRect();
    if (!r.width) return;
    const pad = this.options.padding;
    // Scale up to fill the panel, but only so far: a two-node model blown up
    // to full screen looks absurd.
    const k = Math.min(this.options.maxFitScale, (r.width - pad * 2) / box.width, (r.height - pad * 2) / box.height);
    this._view = { k, x: pad - box.x * k, y: pad - box.y * k };
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
