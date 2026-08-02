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

  function Diagram(path) {
    if (!(this instanceof Diagram)) return new Diagram(path);
    this.path = String(path);
  }

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
      function () {
        Sienna.userData.set(path, {
          id: id,
          name: p.name || id,
          schema: p.schema || 'simile-v1',
          enums: {},
          submodels: {},
          nodes: {},
          arcs: {},
          layout: {},
        });
      }
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
      this.nodeType(type);          // the schema decides what types exist
      this.checkLabel(opt.label);
      var self = this;
      var id = this._mintId('node');
      Sienna.actions.dispatch(
        { type: 'diagram.addNode', target: this.path, payload: { id: id, nodeType: type, label: opt.label || '' } },
        function () {
          self._put('nodes', id, {
            type: type,
            parent: opt.parent != null ? opt.parent : null,
            label: opt.label || '',
            props: opt.props || {},
          }, self._geom(opt));
        }
      );
      return id;
    },

    /**
     * Add a submodel. (Kept minimal — creating one *around* existing elements
     * needs re-parenting, which is not built yet.)
     */
    addSubmodel: function (o) {
      var opt = o || {};
      this.checkLabel(opt.label);
      var self = this;
      var id = this._mintId('submodel');
      Sienna.actions.dispatch(
        { type: 'diagram.addSubmodel', target: this.path, payload: { id: id, label: opt.label || '' } },
        function () {
          self._put('submodels', id, {
            kind: opt.kind || 'single',
            parent: opt.parent != null ? opt.parent : null,
            label: opt.label || '',
            props: opt.props || {},
          }, self._geom(opt));
        }
      );
      return id;
    },

    /**
     * Draw a flow. Mimics the GUI gesture: a blank end auto-creates a cloud,
     * and the flow's **valve** is auto-created as a real node carrying the
     * flow's label and rate equation (§4). All of it is one undo step.
     *
     * @param {{from?:string, to?:string, label?:string, props?:object,
     *          x?:number, y?:number, fromXY?:object, toXY?:object}} o
     *   `from`/`to` omitted or null => a cloud is created at that end.
     *   `x`/`y` position the valve; `fromXY`/`toXY` position auto-clouds.
     * @returns {{arc:string, valve:string, from:string, to:string}}
     */
    addFlow: function (o) {
      var opt = o || {};
      this.checkLabel(opt.label);
      var self = this;
      var spec = this.arcType('flow');   // the notation decides what a flow brings

      // Ids are minted up-front, all at once, so the action's payload can name
      // them: nothing reaches userData until the dispatch below runs.
      var needCloud = { from: opt.from == null, to: opt.to == null };
      var ids = this._mintIds('node', 1 + (needCloud.from ? 1 : 0) + (needCloud.to ? 1 : 0));
      var made = [];
      var fromId = opt.from;
      var toId = opt.to;
      if (needCloud.from) { fromId = ids.shift(); made.push({ id: fromId, xy: opt.fromXY }); }
      if (needCloud.to) { toId = ids.shift(); made.push({ id: toId, xy: opt.toXY }); }
      var valveId = ids.shift();
      var arcId = this._mintId('arc');

      Sienna.actions.dispatch(
        { type: 'diagram.addFlow', target: this.path, payload: { id: arcId, from: fromId, to: toId, valve: valveId, label: opt.label || '' } },
        function () {
          // Auto-created clouds at blank ends.
          made.forEach(function (m) {
            self._put('nodes', m.id, {
              type: spec.blankEnd, parent: opt.parent != null ? opt.parent : null,
              label: '', props: {},
            }, self._geom(m.xy));
          });
          // The valve: a real node, and the element that carries the name.
          self._put('nodes', valveId, {
            type: spec.attachmentNode,
            parent: opt.parent != null ? opt.parent : null,
            label: opt.label || '',
            props: opt.props || {},
          }, self._geom(opt));
          // The flow arc itself: no label (the valve has it), no parent (§13).
          self._put('arcs', arcId, {
            type: 'flow', from: fromId, to: toId, valve: valveId, props: {},
          }, null);
        }
      );
      return { arc: arcId, valve: valveId, from: fromId, to: toId };
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
      var opt = o || {};
      var self = this;
      // The notation says whether this arc type carries a local name at all.
      var alias = this.arcType('influence').alias
        ? (opt.alias != null ? opt.alias : this.label(from))
        : undefined;
      this.checkLabel(alias);
      var id = this._mintId('arc');
      Sienna.actions.dispatch(
        { type: 'diagram.addInfluence', target: this.path, payload: { id: id, from: from, to: to, alias: alias } },
        function () {
          var el = { type: 'influence', from: from, to: to, props: opt.props || {} };
          if (alias !== undefined) el.alias = alias;
          self._put('arcs', id, el, null);
        }
      );
      return id;
    },

    /**
     * Draw a role arc, from a submodel to the submodel that thereby becomes an
     * association (§4: S1→S3 and S2→S3, never S1→S2). Roles are the one arc
     * type that carries a label.
     */
    addRole: function (from, to, o) {
      var opt = o || {};
      this.checkLabel(opt.label);
      var self = this;
      var id = this._mintId('arc');
      Sienna.actions.dispatch(
        { type: 'diagram.addRole', target: this.path, payload: { id: id, from: from, to: to, label: opt.label || '' } },
        function () {
          self._put('arcs', id, {
            type: 'role', from: from, to: to, label: opt.label || '', props: opt.props || {},
          }, null);
        }
      );
      return id;
    },
  };

  Sienna.Diagram = Diagram;
})(window.Sienna);
