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
    /** Influence curvature: sagitta as a fraction of the chord (§ _bow). */
    bowFraction: 0.12,
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
      const t = this._placeLabel(d, id, sub.label, b.cx - b.w / 2 + 8, b.cy - b.h / 2 + 15,
        'slx-label slx-submodel-label');
      t.setAttribute('text-anchor', 'start');
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
    const t = this._text(ax + (off.dx || 0), ay + (off.dy || 0), text, cls || 'slx-label');
    t.setAttribute('data-label-for', id);
    t.addEventListener('pointerdown', (e) => this._beginLabelDrag(e, d, id, off));
    this._layer.labels.appendChild(t);
    return t;
  },

  _beginLabelDrag(e, d, id, off) {
    if (this._tool) return;                       // placing/connecting takes precedence
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
      if (final && (final.dx !== start.dx || final.dy !== start.dy)) {
        d.moveLabel(id, final.dx, final.dy);      // one action per drag
      }
      this._render();
    };
    $(document).on('pointermove', move).on('pointerup pointercancel', end);
  },

  _renderArc(d, id, arc) {
    const pts = this._chainFor(d, id, arc);
    if (pts.length < 2) return;

    const crossings = d.portsFor(id).length;
    const marker = arc.type === 'flow' ? 'slx-arrow-flow' : 'slx-arrow-influence';
    const curved = arc.type === 'influence';
    const bow = curved ? this._bowOf(d, id) : 0;
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
    if (this._tool === 'submodel:submodel') { e.stopPropagation(); return this._beginSubmodelDraw(e); }
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
