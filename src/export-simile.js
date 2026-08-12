/**
 * `Sienna.exportSimile` — turn one of our models into something Simile will run.
 *
 * Two outputs, one on top of the other:
 *
 *   - `prolog(model)` — the model as **Simile Prolog**, the `.pl` form.
 *   - `sml(model)` — that wrapped in the **MIME container** Simile calls `.sml`.
 *
 * ## Why the wrapper is not optional
 *
 * The obvious plan was to POST raw Prolog: Simile loads it, and SimiLive's
 * upload form advertises `.pl`. Measured, it does not work — the build dies in
 * `file join $mimedir *.so`, a Tcl variable that is never set for a bare file.
 * A `.sml` with the model as its ONLY part fails the same way. What makes it
 * build is a second part, 27 bytes of "Simile package description"
 * (`modelRunning 1 running_c 1`), which is evidently what sets `mimedir`.
 *
 * Everything else a real `.sml` carries — the Tcl canvas description, the
 * helper and parameter XML, the generated C++, a compiled ELF of the model — is
 * optional. Verified by uploading a two-part file built here and running it.
 *
 * ## The representation gap, and what this file does about it
 *
 * Three differences between our model and Simile's, all handled here:
 *
 *   1. **A valued element is TWO nodes in Simile.** A `variable` holds the name
 *      and the graphics; a second `function` node holds the units and the
 *      equation, and an influence arc runs function → variable. So each of our
 *      compartments and variables emits a pair.
 *   2. **Influences terminate on the function, not on the visible node.** An
 *      influence into `biomass` actually arrives at `biomass`'s function node —
 *      which makes sense, since it is the equation that uses the value.
 *   3. **A flow has no valve node.** Our valve carries the flow's name and its
 *      rate equation; Simile puts the name on the flow ARC and the rate in a
 *      function node listed in the arc's `attached=[…]`. So a valve emits no
 *      visible node at all.
 *
 * The alias each of our influences carries maps exactly onto Simile's
 * `role=[use(none,in_hierarchy,ALIAS,DIM)]` — both are "the local name the
 * consumer's equation uses", and in both systems the equation references the
 * alias rather than the source's label. That correspondence is the reason this
 * conversion is as short as it is.
 *
 * ## Submodels: one arc of ours becomes a chain of Simile's
 *
 * We store a cross-boundary influence as ONE arc end to end and derive the
 * visual segments (DESIGN-diagram §13). Simile stores the segments. So export
 * walks the containment tree from the source's scope up to the common ancestor
 * and down to the target's, and emits one arc per level:
 *
 *   - **Leaving** a submodel S: the current segment ends at a `border` node
 *     INSIDE S, and the next starts at S's own node (which lives in S's parent).
 *   - **Entering** a submodel S: the current segment ends at S's own node, and
 *     the next starts at a `border` node inside S.
 *   - Consecutive segments are paired in `links(S, [Upstream-Downstream, …])`,
 *     recorded against the submodel whose boundary they cross. The pair is
 *     ordered along the direction of influence.
 *   - Only the LAST segment — the one landing on the consumer's function —
 *     carries the `role`.
 *
 * Read off `landuse1b.pl` and `forest.pl` rather than guessed, including the
 * three-segment case (`Next to` → `Patch`) which pins the ordering and shows
 * the pairs recorded under two different submodels.
 *
 * A happy correspondence: Simile shares the inner segment of an outward
 * crossing between several consumers (`arc00022` appears in two `links` pairs)
 * and gives each consumer its own inner segment on the way in. That is exactly
 * our ports rule — shared on the source side, per-arc on the target side — so
 * our port map and Simile's segments describe the same thing.
 *
 * ## The dimensional term, measured rather than asked
 *
 * `NOTE-export-to-simile.md` §4 calls `1` vs `list(1)` the blocker. The
 * reference models answer it for containment:
 *
 *   - **Inward** references are scalars: `use(none,in_hierarchy,state,1)`.
 *   - **Outward** references are lists, and the alias carries brackets that the
 *     consumer's equation uses VERBATIM: `use(none,in_hierarchy,{volume},list(1))`
 *     beside an equation reading `sum({volume})`. Curly braces for variable
 *     membership; square for fixed — `fire_rect` crosses a 200×300 grid and
 *     writes `any(any([[lit]]))`, one bracket level per dimension.
 *
 * So the alias is emitted exactly as our model holds it, and an outward
 * crossing of a multi-instance submodel whose alias is NOT bracketed is
 * refused — that is a real modelling error (a list referenced as a scalar), and
 * inventing the brackets here would edit the modeller's equations behind their
 * back.
 *
 * What is still refused: **role arcs / association submodels**. Their roles use
 * a different form (`use(0,in_base,…)`, `use(2,in_assoc,…)`) with per-end
 * indices, and nothing in the editor produces them yet.
 *
 * Classic script; no imports/exports.
 */
(function (Sienna) {
  'use strict';

  // Simile writes `edition=enterprise` in every file on hand, including the
  // demo models the SimiLive server itself serves. It is what the format looks
  // like rather than a claim about us, but it IS the field a licence check
  // would read — worth knowing it is here rather than finding it later.
  var SOURCE_LINE = "source(program='Simile v7.1',version=11.1,edition=enterprise,date=";

  // The part that makes the build work. See the header.
  var PACKAGE_DESC = 'modelRunning 1 running_c 1\n';

  // ---- Prolog term helpers ---------------------------------------------

  /**
   * A Prolog atom: bare when it can be, quoted when it must be. Simile's own
   * files quote anything that is not `[a-z][a-zA-Z0-9_]*`, and double an
   * internal quote to escape it.
   */
  function atom(s) {
    var t = String(s == null ? '' : s);
    if (/^[a-z][a-zA-Z0-9_]*$/.test(t)) return t;
    return "'" + t.replace(/\\/g, '\\\\').replace(/'/g, "''") + "'";
  }

  /** A Simile element id: `node00007`, `arc00012`. */
  function simId(prefix, n) {
    var s = String(n);
    while (s.length < 5) s = '0' + s;
    return prefix + s;
  }

  function list(items) {
    return '[' + items.join(',') + ']';
  }

  // ---- the conversion ---------------------------------------------------

  /**
   * How our node types map onto Simile's. A `valve` is deliberately absent: it
   * becomes an attached function plus the flow arc's name, never a node.
   *
   * The population symbols are left out because their Simile spellings are not
   * confirmed — `forest.sml` shows `loss` and `immigration`, which are probably
   * two of ours, but guessing which would produce a model that loads and means
   * something else. Refusing says so; guessing would not.
   */
  var NODE_TYPE = {
    compartment: 'compartment',
    variable: 'variable',
    cloud: 'cloud',
    condition: 'condition',
  };

  function Emitter(model) {
    this.m = model;
    this.schema = Sienna.schemas.get(model.schema || 'simile-v1');
    this.nodeN = 0;
    this.arcN = 0;
    this.fnN = 0;
    this.infN = 0;
    this.cloudN = 0;
    this.borderN = 0;
    this.vis = {};      // our id -> Simile id of the VISIBLE node
    this.fn = {};       // our id -> Simile id of the FUNCTION node
    this.borders = {};  // key -> {id, sub} for boundary stubs
    this.extra = {};    // our submodel id -> [Simile ids of borders inside it]
    this.links = {};    // our submodel id -> ['arcA-arcB', …]
    this.arcLines = [];
  }

  Emitter.prototype = {
    /** The schema's first expression field for a type — what holds its equation. */
    exprField: function (type) {
      var spec = (this.schema.nodes || {})[type] || {};
      var f = (spec.fields || []).filter(function (x) { return x.type === 'expression'; })[0];
      return f ? f.name : null;
    },

    /**
     * Refuse early and by name. A model that exports to something Simile loads
     * but misreads is far worse than one that will not export: the first is
     * found by a modeller wondering why the numbers are wrong.
     */
    check: function () {
      var m = this.m;
      var self = this;
      var problems = [];

      Object.keys(m.nodes).forEach(function (id) {
        var n = m.nodes[id];
        var name = n.label || id;
        if (n.type !== 'valve' && !NODE_TYPE[n.type] && n.type !== 'valve') {
          problems.push('"' + name + '" is a ' + n.type + ', which has no confirmed Simile spelling');
          return;
        }
        var field = self.exprField(n.type);
        if (field && !String((n.props || {})[field] || '').trim()) {
          problems.push('"' + name + '" has no ' + field);
        }
      });

      Object.keys(m.arcs).forEach(function (id) {
        var a = m.arcs[id];
        if (a.type === 'role') {
          problems.push('it has a role arc — association submodels are not converted yet');
          return;
        }
        if (a.type !== 'influence') return;

        // An outward crossing of a multi-instance submodel produces a LIST, and
        // the alias has to say so, because the consumer's equation uses the
        // alias verbatim. Adding the brackets here would silently disagree with
        // the equation the modeller wrote.
        var alias = (a.alias || '').trim();
        var left = self.crossings(a.from, a.to).out.filter(function (s) { return self.isMulti(s); });
        if (left.length && !/^[{[]/.test(alias)) {
          // Square brackets for a fixed membership, curly for a variable one —
          // the distinction the reference models draw, and the answer to the
          // question §4 of the note could not resolve without them.
          var sub = (self.m.submodels || {})[left[0]] || {};
          var want = sub.kind === 'fixed-membership' ? '[' + alias + ']' : '{' + alias + '}';
          problems.push('"' + alias + '" comes out of "' + (sub.label || left[0])
            + '", which has more than one instance, so it arrives as a LIST. Reference it as '
            + want + ' — in the alias, and in the equation that uses it');
        }
      });

      if (problems.length) {
        // A long model produces a long list — LAMOS gives forty lines — and a
        // wall of text is read as a crash rather than as a to-do list. Show
        // enough to act on and count the rest.
        var SHOWN = 8;
        var shown = problems.slice(0, SHOWN);
        if (problems.length > SHOWN) {
          shown.push('…and ' + (problems.length - SHOWN) + ' more');
        }
        throw new Error('This model cannot be exported yet:\n  • ' + shown.join('\n  • '));
      }
    },

    /**
     * Assign every Simile id up front. `roots(…)` has to be written before the
     * nodes it names, so nothing can be emitted until all the numbering exists.
     */
    allocate: function () {
      var m = this.m;
      var self = this;

      Object.keys(m.submodels || {}).forEach(function (id) {
        self.vis[id] = simId('node', ++self.nodeN);
      });
      Object.keys(m.nodes).forEach(function (id) {
        var n = m.nodes[id];
        // A valve has no visible node — it IS its equation, which the flow arc
        // will carry as `attached`.
        if (n.type !== 'valve') self.vis[id] = simId('node', ++self.nodeN);
        if (self.exprField(n.type)) self.fn[id] = simId('node', ++self.nodeN);
      });
    },

    // ---- containment ----------------------------------------------------

    /** The submodel an element sits in, or null for the top level. */
    parentOf: function (id) {
      var el = this.m.nodes[id] || (this.m.submodels || {})[id];
      return (el && el.parent) || null;
    },

    /**
     * A valve lives wherever its flow does. It has no visible node, so its
     * scope has to be read off the element itself.
     */
    scopeOf: function (id) {
      return this.parentOf(id);
    },

    /** [innermost, …, outermost] — the submodels containing an element. */
    chain: function (id) {
      var out = [];
      var p = this.scopeOf(id);
      var guard = 0;
      while (p && guard++ < 100) { out.push(p); p = this.parentOf(p); }
      return out;
    },

    /**
     * The boundaries an influence crosses: which submodels it leaves, then
     * which it enters, in the order it does so.
     */
    crossings: function (from, to) {
      var a = this.chain(from);
      var b = this.chain(to);
      var common = null;
      for (var i = 0; i < a.length; i++) {
        if (b.indexOf(a[i]) >= 0) { common = a[i]; break; }
      }
      var cutA = common ? a.indexOf(common) : a.length;
      var cutB = common ? b.indexOf(common) : b.length;
      return {
        out: a.slice(0, cutA),                 // leaving, innermost first
        into: b.slice(0, cutB).reverse(),      // entering, outermost first
      };
    },

    /**
     * Does a value coming OUT of this submodel arrive as a list?
     *
     * Yes when the submodel has more than one instance, and also when it has a
     * `condition` — a conditional submodel may or may not exist for a given
     * instance, so what leaves it is still a list. Read off `landuse1b.pl`,
     * where `Forest` is `count=[]` yet exports `{volume}` as `list(1)`, and it
     * is the one submodel there containing a condition.
     */
    isMulti: function (subId) {
      var s = (this.m.submodels || {})[subId];
      if (!s) return false;
      if (s.kind && s.kind !== 'single') return true;
      var m = this.m;
      var self = this;
      return Object.keys(m.nodes).some(function (id) {
        return m.nodes[id].type === 'condition' && self.parentOf(id) === subId;
      });
    },

    /** How many list-making boundaries an influence leaves — 0 for a scalar. */
    listCrossings: function (from, to) {
      var self = this;
      return this.crossings(from, to).out.filter(function (s) {
        return self.isMulti(s);
      }).length;
    },

    /**
     * The stub inside a submodel where a segment starts or ends. Shared per
     * source on the way out, per arc on the way in — which is our own ports
     * rule, and Simile's too (`arc00022` serves two consumers in `landuse1b`).
     */
    border: function (subId, key) {
      var k = subId + '|' + key;
      if (this.borders[k]) return this.borders[k];
      var id = simId('node', ++this.nodeN);
      this.borders[k] = id;
      (this.extra[subId] = this.extra[subId] || []).push({
        id: id,
        name: 'brd' + (++this.borderN),
        sub: subId,
        owner: key,
      });
      return id;
    },

    link: function (subId, upstream, downstream) {
      (this.links[subId] = this.links[subId] || []).push(upstream + '-' + downstream);
    },

    /** `centre=[x,y]` — our layout stores the centre already (`box()` reads x as cx). */
    centre: function (id) {
      var g = (this.m.layout || {})[id] || {};
      return 'centre=[' + (g.x || 0) + ',' + (g.y || 0) + ']';
    },

    /** The visible half of one element. */
    emitNode: function (id, out) {
      var n = this.m.nodes[id];
      if (n.type === 'valve') return;

      var props = ['complete=true'];
      // A cloud has no user-visible name, but Simile still wants one.
      props.push('name=' + atom(n.label || (n.type === 'cloud' ? 'cd' + (++this.cloudN) : id)));

      out.push('node(' + this.vis[id] + ',' + NODE_TYPE[n.type] + ',[],'
        + list(props.sort()) + ',' + list([this.centre(id), 'caption_offset=[0,0]']) + ').');
    },

    /**
     * The equation half. Its `value` is our expression text emitted verbatim —
     * our PEG parses the Simile expression language, so what we hold is already
     * in the target syntax and needs no translation.
     */
    emitFunction: function (id, out) {
      var n = this.m.nodes[id];
      var fnId = this.fn[id];
      if (!fnId) return;

      var field = this.exprField(n.type);
      var units = String((n.props || {}).units || '').trim() || '1';
      var props = [
        'complete=true',
        'name=' + atom('fn' + (++this.fnN)),
        'units=' + units,
        'value=' + String((n.props || {})[field]).trim(),
      ];

      // A valve's function rides on its flow; `along` is where along the arc.
      var layout = n.type === 'valve' ? ['along=500'] : [];
      out.push('node(' + fnId + ',function,[],' + list(props) + ',' + list(layout) + ').');
    },

    /** function → its own visible node: the pairing arc, which carries no role. */
    emitPairing: function (id) {
      var n = this.m.nodes[id];
      if (n.type === 'valve' || !this.fn[id]) return;
      this.arcLines.push('arc(' + simId('arc', ++this.arcN) + ',' + this.fn[id] + ',' + this.vis[id]
        + ',influence,' + list(['attached=[]', 'name=' + atom('i' + (++this.infN))]) + ',[]).');
    },

    /**
     * Where an influence really lands: on the target's equation, never on the
     * target's visible node.
     */
    targetOf: function (ourId) {
      return this.fn[ourId] || this.vis[ourId];
    },

    emitArc: function (id) {
      var a = this.m.arcs[id];

      if (a.type === 'flow') {
        var valve = this.m.nodes[a.valve] || {};
        var props = [
          'attached=' + list(this.fn[a.valve] ? [this.fn[a.valve]] : []),
          'complete=true',
          'name=' + atom(valve.label || 'flow'),
        ];
        this.arcLines.push('arc(' + simId('arc', ++this.arcN) + ',' + this.vis[a.from] + ','
          + this.vis[a.to] + ',flow,' + list(props) + ',' + list(['caption_offset=[0,0]']) + ').');
        return;
      }

      // An influence, possibly crossing boundaries — see the header. One arc of
      // ours becomes one Simile arc per level, with the role on the last.
      var cross = this.crossings(a.from, a.to);
      var cursor = this.vis[a.from];
      var segs = [];
      var bounds = [];

      cross.out.forEach((sub) => {
        segs.push(this.plainSeg(cursor, this.border(sub, a.from)));
        bounds.push(sub);
        cursor = this.vis[sub];
      });
      cross.into.forEach((sub) => {
        segs.push(this.plainSeg(cursor, this.vis[sub]));
        bounds.push(sub);
        cursor = this.border(sub, id);
      });

      // The final segment lands on the consumer's equation and carries the
      // role: the alias exactly as the model holds it (the equation uses it
      // verbatim) and one `list(…)` wrapper per list-making boundary left.
      var alias = a.alias || (this.m.nodes[a.from] || {}).label || '';
      var dim = '1';
      for (var i = 0; i < this.listCrossings(a.from, a.to); i++) dim = 'list(' + dim + ')';

      var last = simId('arc', ++this.arcN);
      this.arcLines.push('arc(' + last + ',' + cursor + ',' + this.targetOf(a.to)
        + ',influence,' + list([
          'attached=[]', 'complete=true', 'name=' + atom('i' + (++this.infN)),
          'role=[use(none,in_hierarchy,' + alias.trim() + ',' + dim + ')]',
        ]) + ',[]).');
      segs.push(last);

      // Pair each segment with the next, under the boundary between them.
      for (var j = 0; j < bounds.length; j++) this.link(bounds[j], segs[j], segs[j + 1]);
    },

    /** A segment with no role — everything but the last one in a chain. */
    plainSeg: function (from, to) {
      var id = simId('arc', ++this.arcN);
      this.arcLines.push('arc(' + id + ',' + from + ',' + to + ',influence,'
        + list(['attached=[]', 'complete=true', 'name=' + atom('i' + (++this.infN))]) + ',[]).');
      return id;
    },

    /** What a submodel's `multiplication_spec` says about its instances. */
    spec: function (subId) {
      var s = (this.m.submodels || {})[subId] || {};
      if (s.kind === 'population') return '[type=population]';
      if (s.kind === 'fixed-membership') {
        var n = String((s.props || {}).dimensions || '').trim();
        return '[count=[' + n + ']]';
      }
      return '[count=[]]';
    },

    /** Everything Simile should list as living inside this submodel. */
    childrenOf: function (subId) {
      var m = this.m;
      var self = this;
      var kids = [];

      Object.keys(m.submodels || {}).forEach(function (id) {
        if (m.submodels[id].parent === subId) kids.push(self.vis[id]);
      });
      Object.keys(m.nodes).forEach(function (id) {
        if (self.parentOf(id) !== subId) return;
        // A valve is not a node at all, and its function belongs to its arc.
        if (m.nodes[id].type === 'valve') return;
        if (self.vis[id]) kids.push(self.vis[id]);
        if (self.fn[id]) kids.push(self.fn[id]);
      });
      (this.extra[subId] || []).forEach(function (b) { kids.push(b.id); });
      return kids;
    },

    emitSubmodel: function (id, out) {
      var s = this.m.submodels[id];
      var g = (this.m.layout || {})[id] || {};
      var w = g.w || 200;
      var h = g.h || 130;
      var x = (g.x || 0) - w / 2;
      var y = (g.y || 0) - h / 2;

      out.push('node(' + this.vis[id] + ',submodel,' + list(this.childrenOf(id)) + ','
        + list([
          'complete=true',
          'multiplication_spec=' + this.spec(id),
          'name=' + atom(s.label || id),
          'separate=0',
        ]) + ',' + list([
          'bounding_box=[' + x + ',' + y + ',' + (x + w) + ',' + (y + h) + ']',
          'caption_offset=[0,-8]',
          'internal_extent=[0,0,' + w + ',' + h + ']',
        ]) + ').');
    },

    /**
     * A boundary stub. `along` is where it sits on the submodel's edge — purely
     * cosmetic, and we hold the port as a point rather than a perimeter
     * distance, so it is approximated from the port's position and nothing
     * depends on it being right.
     */
    emitBorder: function (b, out) {
      var ports = ((this.m.layout || {}).ports || {})[b.sub] || {};
      var p = ports[b.owner];
      var g = (this.m.layout || {})[b.sub] || {};
      var along = 500;
      if (p && g.w && g.h) {
        var dx = (p.x - ((g.x || 0) - g.w / 2)) / g.w;
        along = Math.max(0, Math.min(999, Math.round(dx * 1000)));
      }
      out.push('node(' + b.id + ',border,[],'
        + list(['complete=true', 'name=' + atom(b.name)]) + ',[along=' + along + ']).');
    },

    run: function () {
      var m = this.m;
      var self = this;
      this.check();
      this.allocate();

      // Arcs FIRST: walking them is what creates the boundary stubs, and a
      // submodel cannot list its children until they all exist.
      Object.keys(m.nodes).forEach(function (id) { self.emitPairing(id); });
      Object.keys(m.arcs).forEach(function (id) { self.emitArc(id); });

      var out = [];
      out.push(SOURCE_LINE + atom(new Date().toString()) + ').');
      out.push('');

      // Everything at the top level, both halves of each pair. An attached
      // function is NOT a root — it belongs to its arc.
      var roots = [];
      Object.keys(m.submodels || {}).forEach(function (id) {
        if (!m.submodels[id].parent) roots.push(self.vis[id]);
      });
      Object.keys(m.nodes).forEach(function (id) {
        if (self.parentOf(id)) return;
        if (m.nodes[id].type === 'valve') return;
        if (self.vis[id]) roots.push(self.vis[id]);
        if (self.fn[id]) roots.push(self.fn[id]);
      });
      (self.extra[null] || []).forEach(function (b) { roots.push(b.id); });
      out.push('roots(' + list(roots) + ').');
      out.push('');

      out.push('properties(' + list([
        'complete-true',
        'fix_math_args-0',
        'multiplication_spec-[count=[]]',
        'name-' + atom(m.name || m.id || 'Desktop'),
        'separate-0',
      ]) + ').');
      out.push('');

      Object.keys(m.submodels || {}).forEach(function (id) {
        self.emitSubmodel(id, out);
        // `links` sits with the submodel whose boundary the segments cross.
        if (self.links[id]) out.push('links(' + self.vis[id] + ',' + list(self.links[id]) + ').');
      });
      Object.keys(m.nodes).forEach(function (id) {
        self.emitNode(id, out);
        self.emitFunction(id, out);
      });
      Object.keys(self.extra).forEach(function (sub) {
        self.extra[sub].forEach(function (b) { self.emitBorder(b, out); });
      });

      out.push('');
      return out.concat(this.arcLines).join('\n') + '\n';
    },
  };

  // ---- MIME ------------------------------------------------------------

  /** UTF-8 → base64, wrapped at 76 columns as every Simile file is. */
  function base64(text) {
    var bytes = new TextEncoder().encode(text);
    var bin = '';
    for (var i = 0; i < bytes.length; i++) bin += String.fromCharCode(bytes[i]);
    var b64 = window.btoa(bin);
    var lines = [];
    for (var j = 0; j < b64.length; j += 76) lines.push(b64.substr(j, 76));
    return lines.join('\n');
  }

  function part(boundary, filename, description, body) {
    return ['--' + boundary,
      'MIME-Version: 1.0',
      'Content-Disposition: inline; filename="' + filename + '"',
      'Content-Description: ' + description,
      'Content-Transfer-Encoding: base64',
      'Content-Type: application/x-simile',
      '',
      base64(body),
      ''].join('\n');
  }

  Sienna.exportSimile = {
    /** @returns {string} the model as Simile Prolog */
    prolog: function (model) {
      return new Emitter(model).run();
    },

    /**
     * @returns {string} the model as a `.sml` — the two parts that are load
     * bearing, plus the run settings so the run control opens on sensible
     * numbers rather than the server's defaults.
     */
    sml: function (model, run) {
      var r = run || {};
      var boundary = '----- =_SIENNA' + Date.now().toString(36).toUpperCase();
      var status = 'execTime ' + (r.execTime || 100)
        + ' timeUnit ' + (r.timeUnit || 'unit')
        + ' displayInt ' + (r.displayInt || 1)
        + ' intMethod ' + (r.intMethod || 'Euler')
        + ' phaseList ' + (r.phaseList || 0.1) + '\n';

      return ['MIME-Version: 1.0',
        'Content-Type: multipart/mixed;',
        '              boundary="' + boundary + '"',
        '',
        part(boundary, '/model.pl', 'Simile model', this.prolog(model)),
        part(boundary, '/model.spj', 'Simile package description', PACKAGE_DESC),
        part(boundary, '/model.sts', 'Run Status', status),
        '--' + boundary + '--',
        ''].join('\n');
    },
  };
})(window.Sienna);
