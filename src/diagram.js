/**
 * `Sienna.Diagram` — the app's model layer for one diagram, over `userData`.
 *
 * This is a **thin wrapper**, not a model object: it stores no diagram state of
 * its own. Every read is a `Sienna.userData.get`, every write a
 * `Sienna.userData.set` through `Sienna.actions.dispatch`. Throw a Diagram away
 * and build a new one on the same path and nothing is lost. (The same shape as
 * the shell's own `Sienna.models` — see sienna/CLAUDE.md.) The reason is that
 * undo rewinds `userData` directly, so any private copy of the model would
 * silently drift out of step; see DESIGN-diagram.md §10.2, §11.2.
 *
 * One call = one **user action** = one undo step. `addFlow` writes up to three
 * elements (two clouds and a valve can come with it), and undo takes them all
 * back together, because that is one gesture in the GUI.
 *
 * Shape written (DESIGN-diagram.md §4): flat id-keyed maps `submodels`/`nodes`/
 * `arcs`, plus a separate `layout` map. Arcs carry `from`/`to` and **no**
 * `parent` (§13). Ids are sequential and family-prefixed, minted by scanning
 * existing keys — the counter is derived, never stored.
 *
 * NOT here yet: deletion, re-parenting, the grammar engine, rendering.
 *
 * Classic script; no imports/exports. Load after the shell core.
 */
(function (Sienna) {
  'use strict';

  // --- helpers ----------------------------------------------------------

  // Which map an id lives in, from its family prefix (§4: the prefix names it).
  function mapOf(id) {
    var m = /^([a-z]+)\d+$/.exec(String(id || ''));
    if (!m) return null;
    return m[1] === 'submodel' ? 'submodels' : m[1] + 's';
  }

  /**
   * Where the segment p→q crosses the boundary of `rect` (centre cx/cy, w/h),
   * or null if it does not. Used to seed a port's position on the boundary it
   * pierces.
   */
  function crossRect(p, q, rect) {
    var x1 = rect.cx - rect.w / 2, x2 = rect.cx + rect.w / 2;
    var y1 = rect.cy - rect.h / 2, y2 = rect.cy + rect.h / 2;
    var dx = q.x - p.x, dy = q.y - p.y;
    var best = null;
    function consider(t, x, y) {
      if (t <= 0 || t >= 1) return;
      if (x < x1 - 0.01 || x > x2 + 0.01 || y < y1 - 0.01 || y > y2 + 0.01) return;
      if (!best || t < best.t) best = { t: t, x: x, y: y };
    }
    if (dx) {
      consider((x1 - p.x) / dx, x1, p.y + dy * ((x1 - p.x) / dx));
      consider((x2 - p.x) / dx, x2, p.y + dy * ((x2 - p.x) / dx));
    }
    if (dy) {
      consider((y1 - p.y) / dy, p.x + dx * ((y1 - p.y) / dy), y1);
      consider((y2 - p.y) / dy, p.x + dx * ((y2 - p.y) / dy), y2);
    }
    return best ? { x: best.x, y: best.y } : null;
  }

  /**
   * A new element is born named after its own id ('node5'), not nameless.
   * A nameless element is invisible in equations and awkward to point at, and
   * an id is at least a legal, unique name the user can then improve on.
   * Types the notation marks as optionally-labelled (has_label:'optional', the
   * clouds) are left blank.
   */
  function defaultLabel(spec, id, given) {
    if (given) return given;
    return spec && spec.has_label === true ? id : '';
  }

  function Diagram(path) {
    if (!(this instanceof Diagram)) return new Diagram(path);
    this.path = String(path);
  }

  /**
   * The on-disk shape of a model. Stamped into every new model and checked on
   * import (see `validateModel` in src/main.js), so a file written by a later
   * version is refused with a sentence rather than half-loaded. Bump it when
   * the stored shape changes in a way older code cannot read; files written
   * before it existed have no `format` key and are read as 1.
   *
   * It exists from the start because it cannot be added retrospectively: a file
   * already saved without a version can never be told apart from a future one.
   */
  Diagram.FORMAT = 1;

  /**
   * What an empty model looks like — the one statement of it. Both `create`
   * below and the shell's document factory (src/main.js) go through here, so
   * the shape cannot drift between "new model from the File menu" and "new
   * model from code".
   *
   * @param {string} id
   * @param {{name?:string, schema?:string}} [props]
   */
  Diagram.emptyModel = function (id, props) {
    var p = props || {};
    return {
      id: id,
      name: p.name || id,
      format: Diagram.FORMAT,
      schema: p.schema || 'simile-v1',
      enums: {},
      submodels: {},
      nodes: {},
      arcs: {},
      layout: {},
    };
  };

  /**
   * Create an empty model at `path` and return a Diagram on it.
   * @param {string} path e.g. 'models/growth'
   * @param {{name?:string, schema?:string}} [props]
   */
  Diagram.create = function (path, props) {
    var p = props || {};
    var id = String(path).split('/').pop();
    Sienna.actions.dispatch(
      { type: 'diagram.create', target: path, payload: { name: p.name || id } },
      function () { Sienna.userData.set(path, Diagram.emptyModel(id, p)); }
    );
    return new Diagram(path);
  };

  Diagram.prototype = {
    constructor: Diagram,

    // ---- the schema (the notation; nothing about it is hard-wired here) ----

    /** The schema this model declares, from `Sienna.schemas`. */
    schema: function () {
      var m = this.model();
      return Sienna.schemas.get((m && m.schema) || 'simile-v1');
    },

    /** Vocabulary entry for a node type, e.g. `nodeType('valve')`. */
    nodeType: function (type) {
      var t = this.schema().nodes[type];
      if (!t) throw new Error('Unknown node type "' + type + '" in schema ' + this.schema().name + '.');
      return t;
    },

    /** Vocabulary entry for an arc type, e.g. `arcType('flow').attachmentNode`. */
    arcType: function (type) {
      var t = this.schema().arcs[type];
      if (!t) throw new Error('Unknown arc type "' + type + '" in schema ' + this.schema().name + '.');
      return t;
    },

    /**
     * §14: a label is also the equation name, so it must be a legal variable
     * name. The rule belongs to the notation, so it comes from the schema.
     */
    checkLabel: function (label) {
      if (label == null || label === '') return label; // optional (e.g. clouds)
      var naming = this.schema().naming || {};
      if (naming.forbidPattern && new RegExp(naming.forbidPattern).test(String(label))) {
        throw new Error('Invalid label "' + label + '": ' + (naming.message || 'not a legal name.'));
      }
      return label;
    },

    /**
     * Is any SIBLING of `id` already called `label`?
     *
     * Uniqueness is scoped to the containing submodel, not to the model — the
     * same name may, and often will, appear in several submodels (confirmed
     * 2026-08-06 from the reference models: 493 names repeat across submodels,
     * 3 within one). So the question is only ever about siblings.
     */
    siblingNamed: function (parent, label, exceptId) {
      if (!label) return null;
      var self = this;
      var found = null;
      ['nodes', 'submodels'].forEach(function (fam) {
        self.ids(fam).forEach(function (el) {
          if (found || el === exceptId) return;
          if (self.parentOf(el) !== (parent == null ? null : parent)) return;
          if ((self.get(el) || {}).label === label) found = el;
        });
      });
      return found;
    },

    /**
     * Refuse a rename that collides with a sibling.
     *
     * PREVENTIVE here, where the same clash arising from a MOVE is silently
     * resolved (see `commitDrag`) — and the difference is the user's intent.
     * Typing a name is asserting that name, so being told it is taken is the
     * answer they need. Dragging an element into a submodel is asserting
     * containment; the name clash is incidental, and stopping the drag to
     * argue about it would be obstructive.
     */
    checkSiblingName: function (id, label) {
      var clash = this.siblingNamed(this.parentOf(id), label, id);
      if (clash) {
        throw new Error('There is already something called "' + label + '" here.');
      }
      return label;
    },

    /**
     * `label`, or the first free `label_1`, `label_2`, … among `parent`'s
     * children. Used when a move creates a clash the user did not ask for and
     * cannot be asked about mid-gesture (see `commitDrag`).
     */
    freeSiblingName: function (parent, label, exceptId) {
      if (!label || !this.siblingNamed(parent, label, exceptId)) return label;
      var n = 1;
      while (this.siblingNamed(parent, label + '_' + n, exceptId)) n++;
      return label + '_' + n;
    },

    // ---- reads (straight through to userData) ----

    /** The whole model object. */
    model: function () {
      return Sienna.userData.get(this.path);
    },

    /** One element by id, whichever family it belongs to. */
    get: function (id) {
      var map = mapOf(id);
      return map ? Sienna.userData.get(this.path + '/' + map + '/' + id) : undefined;
    },

    /** An element's label, or '' — used to default influence aliases (§14.1). */
    label: function (id) {
      var el = this.get(id);
      return (el && el.label) || '';
    },

    /** All ids in a family: 'nodes' | 'arcs' | 'submodels'. */
    ids: function (family) {
      return Sienna.userData.keys(this.path + '/' + family);
    },

    /** Layout record for an element (see appearanceOf below). */
    layout: function (id) {
      return Sienna.userData.get(this.path + '/layout/' + id);
    },

    /**
     * The single door through which rendering reads layout (§15, ruling 18).
     * Today an element has exactly one appearance; ghosts would make this a
     * lookup rather than an identity, and this accessor is where that change
     * would land. Renderer code must never index `layout[id]` directly.
     */
    appearanceOf: function (id) {
      return this.layout(id);
    },

    /** Deep copy, handy for inspection in the console. */
    toJSON: function () {
      return Sienna.userData.toJSON(this.path);
    },

    // ---- containment (§10.2: the model stores only child->parent) ----

    /** The submodel an element sits in, or null at top level. */
    parentOf: function (id) {
      var el = this.get(id);
      return el && el.parent != null ? el.parent : null;
    },

    /** Containment path upward: [immediate parent, …, outermost]. */
    ancestorsOf: function (id) {
      var out = [];
      var p = this.parentOf(id);
      while (p != null && out.indexOf(p) < 0) {
        out.push(p);
        p = this.parentOf(p);
      }
      return out;
    },

    /**
     * Elements whose parent is `id` (null = top level). Derived by scanning —
     * the model stores only child->parent (§10.2); a cached child-index is the
     * documented optimisation, not needed at this size.
     */
    childrenOf: function (id) {
      var self = this;
      var out = [];
      ['nodes', 'submodels'].forEach(function (fam) {
        self.ids(fam).forEach(function (k) {
          if (self.parentOf(k) === (id == null ? null : id)) out.push(k);
        });
      });
      return out;
    },

    /** Everything inside `id`, at any depth. */
    descendantsOf: function (id) {
      var out = [];
      var stack = this.childrenOf(id);
      while (stack.length) {
        var k = stack.pop();
        if (out.indexOf(k) >= 0) continue;
        out.push(k);
        stack = stack.concat(this.childrenOf(k));
      }
      return out;
    },

    /** Arcs with `id` at either end (the reverse index of §10.2, derived). */
    arcsAt: function (id) {
      var self = this;
      return this.ids('arcs').filter(function (a) {
        var arc = self.get(a);
        return arc && (arc.from === id || arc.to === id || arc.valve === id);
      });
    },

    /** Port layout keys sitting on a given submodel's boundary. */
    portsOn: function (boundary) {
      var base = this.path + '/layout/ports/' + boundary;
      return Sienna.userData.keys(base).map(function (owner) {
        return 'ports/' + boundary + '/' + owner;
      });
    },

    /**
     * Deepest submodel containing both, or null for "the diagram itself".
     * This is the turning point of an arc's path (§13.2).
     */
    nearestCommonAncestor: function (a, b) {
      var up = this.ancestorsOf(a);
      var down = this.ancestorsOf(b);
      for (var i = 0; i < up.length; i++) {
        if (down.indexOf(up[i]) >= 0) return up[i];
      }
      return null;
    },

    // ---- geometry (shared by the renderer; no DOM involved) ----

    /**
     * An element's box in world coordinates: its layout position, with the size
     * its *type* gets from the schema unless layout overrides it (§6 — whether
     * a type is resizable is a style fact).
     */
    box: function (id, override) {
      var el = this.get(id);
      var geom = (override && override[id]) || this.appearanceOf(id) || { x: 0, y: 0 };

      // Some types are positioned BY something else rather than in their own
      // right — a valve rides at the midpoint of its flow, so dragging either
      // end node carries it. Derived, hence never stored (§10.2).
      if (el && mapOf(id) === 'nodes' && (this.schema().nodes[el.type] || {}).positionedBy === 'arc') {
        var host = this.hostArcOf(id);
        if (host) {
          var a = this.box(host.from, override);
          var z = this.box(host.to, override);
          geom = { x: (a.cx + z.cx) / 2, y: (a.cy + z.cy) / 2 };
        }
      }
      var style = (this.schema().style || {})[el ? el.type : 'submodel'] || {};
      if (el && mapOf(id) === 'submodels') style = (this.schema().style || {}).submodel || style;
      return {
        cx: geom.x || 0,
        cy: geom.y || 0,
        w: geom.w != null ? geom.w : style.w || 30,
        h: geom.h != null ? geom.h : style.h || 30,
        shape: style.shape,
      };
    },

    // ---- ports and segments (§13) ----

    /** The arc an attachment node (e.g. a valve) belongs to, or null. */
    hostArcOf: function (nodeId) {
      var self = this;
      var found = null;
      this.ids('arcs').some(function (a) {
        var arc = self.get(a);
        if (arc && arc.valve === nodeId) { found = arc; return true; }
        return false;
      });
      return found;
    },

    /**
     * A label's offset from its element's default anchor, in world units.
     * Absent means "wherever the notation puts it".
     */
    labelOffset: function (id) {
      return this.layout('labels/' + id) || null;
    },

    /**
     * An arc's curvature: signed sagitta as a fraction of its chord. Negative
     * bends the other way. Absent means the notation's default.
     */
    arcBow: function (id) {
      var rec = this.layout('arcs/' + id);
      return rec && typeof rec.bow === 'number' ? rec.bow : null;
    },

    /** Set an arc's curvature — one action per drag. */
    setArcBow: function (id, bow) {
      var self = this;
      Sienna.actions.dispatch(
        { type: 'diagram.setArcBow', target: this.path, payload: { id: id, bow: bow } },
        function () {
          Sienna.userData.set(self.path + '/layout/arcs/' + id, { bow: bow });
        }
      );
    },

    /** Move a label relative to its element — one action, one undo step. */
    moveLabel: function (id, dx, dy) {
      var self = this;
      Sienna.actions.dispatch(
        { type: 'diagram.moveLabel', target: this.path, payload: { id: id, dx: dx, dy: dy } },
        function () {
          Sienna.userData.set(self.path + '/layout/labels/' + id, { dx: dx, dy: dy });
        }
      );
    },

    /**
     * A port is named by **(boundary submodel, the element it serves)** — no
     * invented ids (§13.3). On the ascent out of the source's containers the
     * owner is the *source element*, so every arc leaving it shares that port;
     * on the descent into the target's containers the owner is the *arc*,
     * because there is no fan-in (ruling 14).
     *
     * The pair becomes a path under `layout/ports/` rather than a single
     * compound key, because `/` is userData's path separator: nesting keeps
     * ports out of the element-id namespace in `layout`, and lets a subscriber
     * watch one boundary's ports.
     */
    portKey: function (boundary, owner) {
      return 'ports/' + boundary + '/' + owner;
    },

    /**
     * The ports an arc passes through, source-side first. Empty when both ends
     * live in the same submodel — then the arc is a single segment.
     */
    portsFor: function (arcId) {
      var arc = this.get(arcId);
      if (!arc) return [];
      var nca = this.nearestCommonAncestor(arc.from, arc.to);
      var self = this;

      function upTo(id) {                     // containers crossed, innermost first
        var path = self.ancestorsOf(id);
        var stop = nca == null ? path.length : path.indexOf(nca);
        return path.slice(0, stop < 0 ? path.length : stop);
      }

      var ascent = upTo(arc.from).map(function (b) {
        return { boundary: b, owner: arc.from, key: self.portKey(b, arc.from), shared: true };
      });
      // Descent is walked outermost-first: that is the order they are crossed.
      var descent = upTo(arc.to).reverse().map(function (b) {
        return { boundary: b, owner: arcId, key: self.portKey(b, arcId), shared: false };
      });
      return ascent.concat(descent);
    },

    /**
     * The polyline an arc is drawn along: source centre, each port, target
     * centre. One entry per point, so `points.length - 1` segments — the count
     * is derived, never stored (§13.2).
     */
    arcPoints: function (arcId, override) {
      var arc = this.get(arcId);
      if (!arc) return [];
      var a = this.box(arc.from, override);
      var z = this.box(arc.to, override);
      var pts = [{ x: a.cx, y: a.cy }];
      var self = this;
      this.portsFor(arcId).forEach(function (p) {
        // `override` lets a drag preview a new position without writing to the
        // store: mid-drag values are not model changes, only the drop is.
        var pos = (override && override[p.key]) || self.layout(p.key);
        if (pos) pts.push({ x: pos.x, y: pos.y, port: p.key });
      });
      pts.push({ x: z.cx, y: z.cy });
      return pts;
    },

    /**
     * Every port currently in the diagram, derived by asking each arc which it
     * passes through. Ports have no existence of their own to enumerate (§13.4)
     * — this IS the derivation.
     */
    allPorts: function () {
      var seen = {};
      var out = [];
      var self = this;
      this.ids('arcs').forEach(function (arcId) {
        self.portsFor(arcId).forEach(function (p) {
          if (seen[p.key]) { seen[p.key].arcs.push(arcId); return; }
          seen[p.key] = { key: p.key, boundary: p.boundary, owner: p.owner, shared: p.shared, arcs: [arcId] };
          out.push(seen[p.key]);
        });
      });
      return out.map(function (p) {
        var pos = self.layout(p.key) || { x: 0, y: 0 };
        p.x = pos.x; p.y = pos.y;
        return p;
      });
    },

    /**
     * Rename an element. The label IS the equation name (§14), so this is a
     * model change, validated against the notation's naming rule.
     *
     * Note what is deliberately NOT done: no equation anywhere is rewritten,
     * and no influence alias is re-synced. Equations are stored verbatim and
     * the editor never resolves them (§4), which is exactly why an alias is
     * copied at arc creation rather than linked (§14.1) — so a rename cannot
     * break a stored equation.
     */
    setLabel: function (id, label) {
      this.checkLabel(label);
      this.checkSiblingName(id, label);
      var self = this;
      var map = mapOf(id);
      if (!map) return;
      Sienna.actions.dispatch(
        { type: 'diagram.setLabel', target: this.path, payload: { id: id, label: label } },
        function () {
          Sienna.userData.set(self.path + '/' + map + '/' + id + '/label', label || '');
        }
      );
    },

    /**
     * Write an element's settings — label, props, and any fields that address
     * the element itself (a submodel's `kind`) — as ONE action, so a visit to
     * its dialog is a single undo step.
     *
     * Props are MERGED, not replaced: a dialog shows the fields its type
     * declares, and must not silently drop anything it did not show.
     *
     * The label is validated (it is the equation name, §14); values and
     * equations are not, because they are stored verbatim and never evaluated,
     * and content rules report rather than block (§12.3).
     */
    setProperties: function (id, changes) {
      var self = this;
      var map = mapOf(id);
      if (!map) return;
      var c = changes || {};
      if (c.label !== undefined) {
        this.checkLabel(c.label);
        this.checkSiblingName(id, c.label);   // the dialog renames through here too
      }
      var base = this.path + '/' + map + '/' + id;

      Sienna.actions.dispatch(
        { type: 'diagram.setProperties', target: this.path, payload: { id: id, fields: Object.keys(c.props || {}) } },
        function () {
          if (c.label !== undefined) Sienna.userData.set(base + '/label', c.label || '');
          Object.keys(c.direct || {}).forEach(function (k) {
            Sienna.userData.set(base + '/' + k, c.direct[k]);
          });
          if (c.props) {
            var merged = Object.assign({}, self.get(id).props || {}, c.props);
            Sienna.userData.set(base + '/props', merged);
          }
        }
      );
    },

    /**
     * Everything that must go when `ids` go — the closure of a deletion.
     *
     * The lifecycle rules were settled in §4, and they differ per type:
     *   - a **submodel** takes its contents with it, at any depth. (Dissolving
     *     the box but KEEPING its contents is the separate `ungroup` command
     *     below, which promotes them first and then asks for this closure —
     *     which by then covers the box and its arcs, but not the contents.)
     *   - any element takes the **arcs** attached to it, since an arc with one
     *     missing end is not a thing;
     *   - a **flow** takes its valve, which is one-to-one with it;
     *   - a **valve** takes its flow, for the same reason, from the other side;
     *   - a **cloud** is REFCOUNTED: it goes only when the last flow touching
     *     it goes, because a cloud may serve several (§4).
     *
     * Computed to a fixpoint, since removing one element can orphan another.
     */
    deletionClosure: function (ids) {
      var self = this;
      var set = {};
      (ids || []).forEach(function (i) { if (self.get(i)) set[i] = true; });

      var grew = true;
      while (grew) {
        grew = false;
        var mark = function (id) {
          if (id && !set[id] && self.get(id)) { set[id] = true; grew = true; }
        };

        Object.keys(set).forEach(function (id) {
          if (mapOf(id) === 'submodels') self.descendantsOf(id).forEach(mark);
        });

        this.ids('arcs').forEach(function (a) {
          var arc = self.get(a);
          if (!arc) return;
          if (set[a]) { mark(arc.valve); return; }              // a flow takes its valve
          if (set[arc.from] || set[arc.to] || (arc.valve && set[arc.valve])) mark(a);
        });

        // Clouds last: a cloud goes only if every arc that touches it is going.
        this.ids('nodes').forEach(function (n) {
          var el = self.get(n);
          if (!el || set[n]) return;
          var spec = (self.schema().nodes[el.type] || {});
          if (!spec.autoCreated || spec.positionedBy) return;   // clouds, not valves
          var incident = self.arcsAt(n);
          if (incident.length && incident.every(function (a) { return set[a]; })) mark(n);
        });
      }
      return Object.keys(set);
    },

    /**
     * Delete elements and everything that must go with them — ONE action, so a
     * whole cascade is a single undo step. Layout owned by the removed elements
     * goes too: their geometry, label offsets, arc curvature, and any ports
     * they owned or hosted, since a port's existence is derived from the arcs
     * and containment that no longer exist (§13.4).
     */
    remove: function (ids) {
      var self = this;
      var doomed = this.deletionClosure(Array.isArray(ids) ? ids : [ids]);
      if (!doomed.length) return [];

      Sienna.actions.dispatch(
        { type: 'diagram.remove', target: this.path, payload: { ids: doomed } },
        function () { self._purge(doomed); }
      );
      return doomed;
    },

    /**
     * The writes of a removal, with no action of their own — so that a command
     * which deletes as PART of a larger gesture (ungroup) stays one undo step.
     * Must be called inside a dispatched action.
     */
    _purge: function (doomed) {
      var self = this;
      doomed.forEach(function (id) {
        Sienna.userData.remove(self.path + '/' + mapOf(id) + '/' + id);
        Sienna.userData.remove(self.path + '/layout/' + id);
        Sienna.userData.remove(self.path + '/layout/labels/' + id);
        Sienna.userData.remove(self.path + '/layout/arcs/' + id);
        // Ports hosted BY a removed submodel.
        Sienna.userData.remove(self.path + '/layout/ports/' + id);
      });
      // Ports OWNED by a removed element, on boundaries that survive.
      Sienna.userData.keys(self.path + '/layout/ports').forEach(function (b) {
        Sienna.userData.keys(self.path + '/layout/ports/' + b).forEach(function (owner) {
          if (doomed.indexOf(owner) >= 0) {
            Sienna.userData.remove(self.path + '/layout/ports/' + b + '/' + owner);
          }
        });
      });
    },

    /**
     * Dissolve a submodel but KEEP its contents, promoting them to the
     * submodel's own parent. The opposite intention to deleting it, which takes
     * the contents with it (§17) — hence a separate command rather than a
     * modifier on delete.
     *
     * Only the IMMEDIATE children move: anything deeper stays inside its own
     * submodel, which is itself promoted intact. The box's own layout goes, and
     * so do the ports hosted on the boundary being dissolved, a port's existence
     * being derived from a boundary that no longer exists (§13.4).
     *
     * Arcs attached to the BOX ITSELF cannot survive it — a role arc to a
     * submodel has no end once the submodel is gone — so those go, with the
     * usual valve/cloud consequences. That is what `deletionClosure` computes,
     * and by the time it is asked the contents have already been promoted out,
     * so the closure covers the box and its arcs but not the contents. The
     * caller is told what went, since it is more than the box.
     *
     * One dispatched action however many submodels are dissolved, so a gesture
     * is one undo step. Ports are re-seeded afterwards for every arc touching
     * what moved: port existence is derived from containment, which has changed.
     *
     * Legality is REPORTED, not refused, exactly as submodel capture is (§12.5):
     * promoting a child to its grandparent can break a containment rule, and
     * refusing here would trap the contents inside the box for good.
     *
     * @param {string|string[]} ids  submodels to dissolve; anything else ignored
     * @returns {{promoted: string[], removed: string[]}}
     */
    ungroup: function (ids) {
      var self = this;
      var list = (Array.isArray(ids) ? ids : [ids]).filter(function (id) {
        return mapOf(id) === 'submodels' && self.get(id);
      });
      if (!list.length) return { promoted: [], removed: [] };

      var promoted = [];
      var removed = [];
      Sienna.actions.dispatch(
        { type: 'diagram.ungroup', target: this.path, payload: { ids: list } },
        function () {
          list.forEach(function (id) {
            if (!self.get(id)) return;              // an earlier step took it
            var up = self.parentOf(id);
            var kids = self.childrenOf(id);
            kids.forEach(function (k) {
              Sienna.userData.set(self.path + '/' + mapOf(k) + '/' + k + '/parent', up);
              // Same reasoning as a drop: promotion is asserting containment,
              // and a name that was unique inside the box may not be unique
              // outside it.
              self._renameIfClashing(k, up);
              promoted.push(k);
            });
            // Read AFTER the promotion, so the closure no longer sees contents.
            var doomed = self.deletionClosure([id]);
            self._purge(doomed);
            removed = removed.concat(doomed);
          });

          var seen = {};
          promoted.forEach(function (el) {
            if (!self.get(el)) return;              // promoted, then deleted with an arc
            [el].concat(self.descendantsOf(el)).forEach(function (sub) {
              self.arcsAt(sub).forEach(function (a) {
                if (!seen[a] && self.get(a)) { seen[a] = true; self._seedPorts(a); }
              });
            });
          });
        }
      );
      return { promoted: promoted, removed: removed };
    },

    /**
     * Commit a drag: a map of layout keys to new positions, and optionally a
     * change of containment. ONE action, so however many elements moved — a
     * submodel carries its contents and its boundary's ports — the whole
     * gesture is a single undo step.
     *
     * Re-parenting is a MODEL change (it is `parent`, not geometry), so it is
     * written alongside the layout in the same transaction. Afterwards the
     * affected arcs may cross different boundaries than before, so their ports
     * are re-seeded: port existence is derived from containment (§13.4), and
     * containment has just changed.
     *
     * NOTE: drop legality is NOT checked — the grammar engine does not exist
     * yet, so an illegal containment can currently be created (§12.3 would make
     * this preventive).
     */
    commitDrag: function (moves, reparent) {
      var self = this;
      var ids = Object.keys(moves || {});
      if (!ids.length && !reparent) return;
      Sienna.actions.dispatch(
        {
          type: 'diagram.drag',
          target: this.path,
          payload: { moved: ids.length, reparent: reparent || null },
        },
        function () {
          if (reparent) {
            var map = mapOf(reparent.id);
            Sienna.userData.set(self.path + '/' + map + '/' + reparent.id + '/parent', reparent.parent);
            // Landing next to a sibling of the same name: rename rather than
            // refuse. The user asserted CONTAINMENT by dropping here, not a
            // name, so the clash is incidental and the drop should not fail
            // over it (ruled 2026-08-06). Renaming the incomer is safe because
            // an influence's alias is copied at arc creation and never
            // re-synced (§14.1): every equation downstream refers to its own
            // alias, not to this label, so nothing breaks.
            self._renameIfClashing(reparent.id, reparent.parent);
          }
          ids.forEach(function (k) {
            Sienna.userData.set(self.path + '/layout/' + k, moves[k]);
          });
          if (reparent) {
            var touched = [reparent.id].concat(self.descendantsOf(reparent.id));
            var seen = {};
            touched.forEach(function (el) {
              self.arcsAt(el).forEach(function (a) {
                if (!seen[a]) { seen[a] = true; self._seedPorts(a); }
              });
            });
          }
        }
      );
    },

    /**
     * Move a port — one user action, hence one undo step, however many
     * pointermove events the drag took. Because the position is keyed on
     * (boundary, owner), moving a shared port moves it for every arc that uses
     * it at once (§13.3): that is the keying doing the work, not bookkeeping.
     */
    movePort: function (key, x, y) {
      var self = this;
      Sienna.actions.dispatch(
        { type: 'diagram.movePort', target: this.path, payload: { port: key, x: x, y: y } },
        function () {
          Sienna.userData.set(self.path + '/layout/' + key, { x: x, y: y });
        }
      );
    },

    /**
     * Seed any missing port positions for an arc. Auto-placement is a ONE-TIME
     * SEED, not a standing derivation (ruling 15): a later arc from the same
     * source attaches to the port where the first one put it, and the user may
     * drag it afterwards — so the position is persisted from the moment the
     * port exists. Existence itself stays derived from arcs + containment.
     *
     * Called inside the action that creates an arc, so it is part of that one
     * undo step.
     */
    _seedPorts: function (arcId) {
      var arc = this.get(arcId);
      if (!arc) return;
      var ports = this.portsFor(arcId);
      if (!ports.length) return;

      var from = this.box(arc.from);
      var to = this.box(arc.to);
      var cur = { x: from.cx, y: from.cy };
      var self = this;

      ports.forEach(function (p) {
        var existing = self.layout(p.key);
        if (existing) { cur = existing; return; }   // an earlier arc placed it
        var rect = self.box(p.boundary);
        var hit = crossRect(cur, { x: to.cx, y: to.cy }, rect);
        var pos = hit || { x: rect.cx, y: rect.cy };
        Sienna.userData.set(self.path + '/layout/' + p.key, { x: pos.x, y: pos.y });
        cur = pos;
      });
    },

    // ---- id minting (derived, never stored) ----

    /** Highest number currently used in a family (0 if empty). */
    _maxId: function (prefix) {
      var family = prefix === 'submodel' ? 'submodels' : prefix + 's';
      var max = 0;
      this.ids(family).forEach(function (k) {
        var m = new RegExp('^' + prefix + '(\\d+)$').exec(k);
        if (m) max = Math.max(max, parseInt(m[1], 10));
      });
      return max;
    },

    /** Next free id in a family, by scanning existing keys (§4). */
    _mintId: function (prefix) {
      return prefix + (this._maxId(prefix) + 1);
    },

    /**
     * Mint several ids in one family at once. Needed when one gesture creates
     * several elements (a flow with its valve and clouds): they are all written
     * in a single action, so nothing is in `userData` to scan between mints.
     */
    _mintIds: function (prefix, count) {
      var next = this._maxId(prefix) + 1;
      var out = [];
      for (var i = 0; i < count; i++) out.push(prefix + (next + i));
      return out;
    },

    // ---- writes (each is one dispatched action = one undo step) ----

    /** Write one element + optional layout. Caller supplies the action wrapper. */
    _put: function (family, id, el, geom) {
      Sienna.userData.set(this.path + '/' + family + '/' + id, el);
      if (geom) Sienna.userData.set(this.path + '/layout/' + id, geom);
    },

    _geom: function (o) {
      if (!o || (o.x == null && o.y == null)) return null;
      var g = { x: o.x || 0, y: o.y || 0 };
      if (o.w != null) g.w = o.w;
      if (o.h != null) g.h = o.h;
      return g;
    },

    /**
     * Add a node.
     * @param {string} type 'compartment' | 'variable' | 'cloud' | 'valve' | …
     * @param {{label?:string, parent?:string, props?:object, x?:number, y?:number}} [o]
     * @returns {string} the new node id
     */
    addNode: function (type, o) {
      var opt = o || {};
      var spec = this.nodeType(type);   // the schema decides what types exist
      this.checkLabel(opt.label);
      var self = this;
      var id = this._mintId('node');
      var label = defaultLabel(spec, id, opt.label);
      Sienna.actions.dispatch(
        { type: 'diagram.addNode', target: this.path, payload: { id: id, nodeType: type, label: label } },
        function () {
          self._put('nodes', id, {
            type: type,
            parent: opt.parent != null ? opt.parent : null,
            label: label,
            props: opt.props || {},
          }, self._geom(opt));
        }
      );
      return id;
    },

    /**
     * Add a submodel — which **captures whatever it encloses**.
     *
     * This is how structure gets imposed on a model that already exists: draw a
     * box round part of a flat model and those parts become its contents; draw
     * one round the whole thing and declare it a population, and you have many
     * copies of what you drew. So:
     *
     *   - enclosed **nodes** (and enclosed submodels) take the new submodel as
     *     their parent;
     *   - **arcs** that now cross the new boundary are treated exactly as if
     *     they had been drawn that way — their ports are seeded, so they split
     *     into segments (§13) with no special case.
     *
     * Capture is part of the same action, so the whole thing is one undo step.
     *
     * Only **siblings** are captured — elements whose parent is the same as the
     * new submodel's. Something already inside another submodel is not stolen
     * merely because the boxes overlap on screen. Enclosure means FULLY inside:
     * an element straddling the new edge is left alone, since it is ambiguous
     * whether the user meant to include it.
     */
    addSubmodel: function (o) {
      var opt = o || {};
      this.checkLabel(opt.label);
      var self = this;
      var id = this._mintId('submodel');
      var label = opt.label || id;
      var parent = opt.parent != null ? opt.parent : null;
      var rect = this._geom(opt);
      var captured = rect ? this.enclosedBy(rect, parent) : [];

      Sienna.actions.dispatch(
        {
          type: 'diagram.addSubmodel',
          target: this.path,
          payload: { id: id, label: label, captured: captured.length },
        },
        function () {
          self._put('submodels', id, {
            kind: opt.kind || 'single',
            parent: parent,
            label: label,
            props: opt.props || {},
          }, rect);

          captured.forEach(function (el) {
            Sienna.userData.set(self.path + '/' + mapOf(el) + '/' + el + '/parent', id);
          });

          // Every arc may now cross a boundary it did not before. Re-seeding is
          // idempotent — it only fills in ports that are missing.
          if (captured.length) self._seedAllPorts();
        }
      );
      return id;
    },

    /**
     * Ids of elements lying wholly within `rect` whose parent is `parent`.
     * Used by submodel capture AND by the widget's rubber-band selection, so
     * that "encloses" means one thing in the editor and not two. The geometry
     * test is on the element's box, so it matches what the user can see.
     */
    enclosedBy: function (rect, parent) {
      var self = this;
      var x1 = rect.x - (rect.w || 0) / 2;
      var x2 = rect.x + (rect.w || 0) / 2;
      var y1 = rect.y - (rect.h || 0) / 2;
      var y2 = rect.y + (rect.h || 0) / 2;
      var out = [];
      ['nodes', 'submodels'].forEach(function (fam) {
        self.ids(fam).forEach(function (el) {
          if (self.parentOf(el) !== parent) return;      // siblings only
          var b = self.box(el);
          if (b.cx - b.w / 2 < x1 || b.cx + b.w / 2 > x2) return;
          if (b.cy - b.h / 2 < y1 || b.cy + b.h / 2 > y2) return;
          out.push(el);
        });
      });
      return out;
    },

    /**
     * Give `id` a free name among its new siblings, if the one it has is
     * taken. Must be called INSIDE the action that re-parented it, so the
     * rename is part of the same undo step as the move that caused it.
     */
    _renameIfClashing: function (id, parent) {
      var el = this.get(id);
      if (!el || !el.label) return;
      var free = this.freeSiblingName(parent, el.label, id);
      if (free !== el.label) {
        Sienna.userData.set(this.path + '/' + mapOf(id) + '/' + id + '/label', free);
      }
    },

    /** Seed ports for every arc (idempotent; used after containment changes). */
    _seedAllPorts: function () {
      var self = this;
      this.ids('arcs').forEach(function (a) { self._seedPorts(a); });
    },

    /**
     * Draw an arc of any type the notation declares — the general form, of
     * which `addFlow`, `addInfluence` and `addRole` are named shorthands.
     *
     * Everything those three used to differ on is DECLARED in the schema's arc
     * entry, so this is one path and not a switch:
     *
     *   - `blankEnd`       — what a blank end auto-creates (a flow's cloud);
     *   - `attachmentNode` — a node the arc brings with it, which then carries
     *                        the label and its equation (a flow's valve);
     *   - `has_label`      — the arc itself carries a label (a role);
     *   - `alias`          — the arc carries the local name the target's
     *                        equation uses for the imported value (§14.1).
     *
     * So a notation with a fourth kind of arc needs a schema entry and no code
     * here. That is the point of it: `addNode` has always taken its type from
     * the schema, while arcs had three hard-wired methods, which made the claim
     * that the vocabulary lives in the schema only two-thirds true.
     *
     * @param {string} type an arc type the schema declares
     * @param {?string} from source id, or null for a blank end
     * @param {?string} to target id, or null for a blank end
     * @param {{label?:string, alias?:string, props?:object, parent?:string,
     *          fromXY?:object, toXY?:object}} [o]
     * @returns {{arc:string, from:string, to:string, attachment:?string}}
     */
    addArc: function (type, from, to, o) {
      var opt = o || {};
      var self = this;
      var spec = this.arcType(type);   // the notation decides what this arc brings
      var parent = opt.parent != null ? opt.parent : null;

      // A blank end auto-creates a node, but only where the notation says what
      // to create. Anywhere else a missing end is a mistake, not a gesture.
      var blank = { from: from == null, to: to == null };
      if ((blank.from || blank.to) && !spec.blankEnd) {
        throw new Error('a ' + type + ' arc needs both ends');
      }

      this.checkLabel(opt.label);
      var alias;
      if (spec.alias) {
        alias = opt.alias != null ? opt.alias : this.label(from);
        this.checkLabel(alias);
      }

      // Ids are minted up-front, all at once, so the action's payload can name
      // them: nothing reaches userData until the dispatch below runs.
      var want = (blank.from ? 1 : 0) + (blank.to ? 1 : 0) + (spec.attachmentNode ? 1 : 0);
      var ids = want ? this._mintIds('node', want) : [];
      var made = [];
      var fromId = from;
      var toId = to;
      if (blank.from) { fromId = ids.shift(); made.push({ id: fromId, xy: opt.fromXY }); }
      if (blank.to) { toId = ids.shift(); made.push({ id: toId, xy: opt.toXY }); }
      var attachId = spec.attachmentNode ? ids.shift() : null;
      var arcId = this._mintId('arc');

      // The action type stays `diagram.addFlow` / `addInfluence` / `addRole`,
      // so existing session logs keep reading as they did.
      var payload = { id: arcId, from: fromId, to: toId };
      if (attachId) payload[spec.attachmentNode] = attachId;
      if (spec.has_label || spec.attachmentNode) payload.label = opt.label || '';
      if (alias !== undefined) payload.alias = alias;

      Sienna.actions.dispatch(
        {
          type: 'diagram.add' + type.charAt(0).toUpperCase() + type.slice(1),
          target: this.path,
          payload: payload,
        },
        function () {
          // Auto-created nodes at blank ends.
          made.forEach(function (m) {
            self._put('nodes', m.id, {
              type: spec.blankEnd, parent: parent, label: '', props: {},
            }, self._geom(m.xy));
          });
          // The attachment node is a real node, and the element that carries
          // the name. No layout is written — it rides at its arc's midpoint
          // (see box()).
          if (attachId) {
            self._put('nodes', attachId, {
              type: spec.attachmentNode,
              parent: parent,
              label: defaultLabel(self.nodeType(spec.attachmentNode), attachId, opt.label),
              props: opt.props || {},
            }, null);
          }
          // The arc itself. Where there is an attachment node it holds the
          // label and the properties, so the arc carries neither (§4).
          var el = { type: type, from: fromId, to: toId };
          if (attachId) el[spec.attachmentNode] = attachId;
          if (spec.has_label) el.label = opt.label || '';
          el.props = attachId ? {} : (opt.props || {});
          if (alias !== undefined) el.alias = alias;
          self._put('arcs', arcId, el, null);
          self._seedPorts(arcId);   // §13: ports are placed when the arc is drawn
        }
      );
      return { arc: arcId, from: fromId, to: toId, attachment: attachId };
    },

    /**
     * Draw a flow. Mimics the GUI gesture: a blank end auto-creates a cloud,
     * and the flow's **valve** is auto-created as a real node carrying the
     * flow's label and rate equation (§4). All of it is one undo step.
     *
     * @param {{from?:string, to?:string, label?:string, props?:object,
     *          parent?:string, fromXY?:object, toXY?:object}} o
     *   `from`/`to` omitted or null => a cloud is created at that end.
     *   `fromXY`/`toXY` position the auto-created clouds.
     * @returns {{arc:string, valve:string, from:string, to:string}}
     */
    addFlow: function (o) {
      var opt = o || {};
      var r = this.addArc('flow', opt.from == null ? null : opt.from,
                          opt.to == null ? null : opt.to, opt);
      return { arc: r.arc, valve: r.attachment, from: r.from, to: r.to };
    },

    /**
     * Draw an influence. The `alias` is the name the target's equation uses for
     * the imported value: it defaults to the source's label and is **copied,
     * not linked**, so renaming the source later cannot break stored equations
     * (§14.1). Influences have no label.
     *
     * @param {string} from source element id
     * @param {string} to target element id (a valve, for an influence into a flow)
     * @param {{alias?:string, props?:object}} [o]
     * @returns {string} the new arc id
     */
    addInfluence: function (from, to, o) {
      return this.addArc('influence', from, to, o).arc;
    },

    /**
     * Draw a role arc, from a submodel to the submodel that thereby becomes an
     * association (§4: S1->S3 and S2->S3, never S1->S2). Roles are the one arc
     * type that carries a label.
     *
     * @returns {string} the new arc id
     */
    addRole: function (from, to, o) {
      return this.addArc('role', from, to, o).arc;
    },
  };

  Sienna.Diagram = Diagram;
})(window.Sienna);
