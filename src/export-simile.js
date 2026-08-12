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
 *      visible node at all — but it does get an id, because a rate can be an
 *      INPUT to something else and Simile draws that influence from the flow
 *      ARC (`edinburgh1`). The flow's id is therefore the valve's.
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
 * **Flows segment the same way**, which was missed until the importer read
 * `johadP.pl` back: one `overflow` leaves a population, crosses the root and
 * enters another submodel as three flow arcs, every one repeating the flow's
 * name, paired by `links` under the two boundaries. Only the rate differs — it
 * sits on the segment in the valve's own scope. See `emitFlow`.
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
 * ## Associations
 *
 * A role arc is Simile's **`relation`**, its label the role name. An association
 * is not a stored kind in either system — it is a submodel that relation arcs
 * point AT, inferred (our §4, and Simile's too). `references(S,[local(arc),…])`
 * lists the relation arcs a submodel takes part in: all of them on the
 * association, its own on each base. The index in `use(N,in_base|in_assoc,…)`
 * is the position in the ASSOCIATION's list — `landuse1b` proves it by starting
 * its list with two `obsolete` placeholders and using indices 2 and 3.
 *
 * The segment machinery above needs no change for an association: base and
 * association are ordinary scopes, so the walk already produces the right
 * chain — even when the influence ALSO climbs the containment tree first. Only
 * the role on the last segment differs.
 *
 * An association RENAMES. We hold one alias per influence; Simile needs one per
 * role, so `attribute` crossing in arrives as `attribute_higher` AND
 * `attribute_lower`. Those are derived here as `<alias>_<role>` (Simile's own
 * convention) and the consumer's equation must use them, which `check`
 * verifies — the alternative being a model that compiles and means something
 * else.
 *
 * One asymmetry, established by running it rather than by reading: when a value
 * reaches an association already a list (because it left a multi-instance
 * submodel on the way), the role's alias stays BARE and the equation brackets
 * it — `use(0,in_base,attribute_higher,list(1))` beside
 * `sum([attribute_higher])`. That is the opposite of the containment case,
 * where the brackets live in the alias.
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
    this.relArc = {};   // our role arc id -> Simile relation arc id
    this.flowArc = {};  // our flow arc id -> Simile flow arc id (= its valve's id)
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
          if (!(m.submodels || {})[a.from] || !(m.submodels || {})[a.to]) {
            problems.push('a role arc joins something that is not a submodel');
          }
          return;
        }
        if (a.type !== 'influence') return;

        var cr = self.crossings(a.from, a.to);

        // An outward crossing of a multi-instance submodel produces a LIST, and
        // the alias has to say so, because the consumer's equation uses the
        // alias verbatim. Adding the brackets here would silently disagree with
        // the equation the modeller wrote.
        var alias = (a.alias || '').trim();

        // An association crossing renames: our one alias becomes one name per
        // role, `<alias>_<role>`, because Simile needs a name per end. So the
        // consumer's equation cannot be using the bare alias — say what it
        // should use rather than letting the model compile into nonsense.
        var pr = self.assocPair(cr);
        if (pr) {
          var names = self.assocNames(a, pr);
          var eq = String((m.nodes[a.to] || {}).props
            ? (m.nodes[a.to].props[self.exprField(m.nodes[a.to].type)] || '') : '');
          if (names.length && !names.some(function (n) { return eq.indexOf(n) >= 0; })) {
            problems.push('across the association "'
              + ((m.submodels || {})[pr.assoc] || {}).label + '", "' + alias
              + '" arrives once per role, under ' + names.map(function (n) {
                return pr.dir === 'in_assoc' ? '{' + n + '}' : n;
              }).join(' and ') + ' — but the equation for "'
              + ((m.nodes[a.to] || {}).label || a.to) + '" uses none of those');
          }
          return;
        }

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

      // Flow arc ids up front, because a valve can be the SOURCE of an
      // influence — a rate feeding some other equation — and Simile draws that
      // from the flow ARC (`arc(arc00047,arc00045,node00027,influence,…)` in
      // `edinburgh1`). So the flow's id is the valve's "visible" id, and it has
      // to exist before any influence is emitted.
      //
      // Found by the round trip, not by a fixture: none of the four has a rate
      // used elsewhere, and this wrote `arc(…,undefined,…)` for six catalogue
      // models before that.
      Object.keys(m.arcs).forEach(function (id) {
        var a = m.arcs[id];
        if (a.type !== 'flow') return;
        self.flowArc[id] = simId('arc', ++self.arcN);
        if (a.valve) self.vis[a.valve] = self.flowArc[id];
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

    // ---- associations ----------------------------------------------------
    //
    // An association is not a stored kind — it is INFERRED from role arcs, in
    // our model (§4) and in Simile's alike, where it is simply a submodel that
    // `relation` arcs point at. Two systems, one inference.

    /** The role arcs pointing at this submodel, in a stable order. */
    rolesOf: function (subId) {
      var m = this.m;
      return Object.keys(m.arcs).filter(function (id) {
        return m.arcs[id].type === 'role' && m.arcs[id].to === subId;
      });
    },

    isAssoc: function (subId) {
      return this.rolesOf(subId).length > 0;
    },

    /**
     * If this crossing is between an association and one of its bases, say
     * which way round. Returns null for an ordinary containment crossing.
     */
    assocPair: function (cross) {
      if (cross.out.length < 1 || cross.into.length < 1) return null;
      var left = cross.out[cross.out.length - 1];
      var entered = cross.into[0];
      var self = this;
      var joins = function (assoc, base) {
        return self.rolesOf(assoc).some(function (r) { return self.m.arcs[r].from === base; });
      };
      if (this.isAssoc(entered) && joins(entered, left)) {
        return { dir: 'in_base', assoc: entered, base: left };
      }
      if (this.isAssoc(left) && joins(left, entered)) {
        return { dir: 'in_assoc', assoc: left, base: entered };
      }
      return null;
    },

    /**
     * The role term for an association crossing.
     *
     * One `use(…)` per relation arc joining this base to this association — so
     * a self-association, where the base is related twice, contributes two, and
     * the consumer's equation gets a name for each end. The INDEX is the
     * position of that relation arc in the ASSOCIATION's `references` list;
     * `landuse1b` shows it is not simply 0,1 (its list starts with two
     * `obsolete` placeholders and its roles use 2 and 3), and `feeding1` shows
     * each base lists only its own arcs while the association lists them all.
     *
     * The per-role ALIAS is derived — `<alias>_<role>` — because our model
     * holds one alias per arc and Simile needs one per role. That is Simile's
     * own convention (`attribute` + `role1` → `attribute_role1`), and the
     * equation must use those names, which `check` verifies.
     */
    assocRole: function (a, pair, cross) {
      var self = this;
      var refs = this.rolesOf(pair.assoc);
      var mine = refs.filter(function (r) { return self.m.arcs[r].from === pair.base; });
      var alias = (a.alias || '').trim();

      // The association hop is the LAST boundary left; anything left before it
      // is ordinary containment, and each multi-instance one makes the value a
      // list on the way past — so a value from a submodel nested inside the
      // base arrives at the association already a list, and the role has to say
      // so. Entering boundaries never do this, which is why only `out` counts.
      var extra = cross.out.slice(0, -1).filter(function (s) { return self.isMulti(s); }).length;

      return mine.map(function (r) {
        var idx = refs.indexOf(r);
        var name = self.roleAlias(alias, r);
        var dim = '1';
        var i;
        if (pair.dir === 'in_assoc') {
          for (i = 0; i < extra + 1; i++) dim = 'list(' + dim + ')';
          return 'use(' + idx + ',in_assoc,{' + name + '},' + dim + ')';
        }
        for (i = 0; i < extra; i++) dim = 'list(' + dim + ')';
        return 'use(' + idx + ',in_base,' + name + ',' + dim + ')';
      }).join(',');
    },

    /** `<alias>_<role label>`, made safe to be a Prolog atom and an identifier. */
    roleAlias: function (alias, roleArcId) {
      var label = (this.m.arcs[roleArcId] || {}).label || 'role';
      return alias + '_' + String(label).trim().replace(/\W+/g, '_');
    },

    /** Every name an association crossing gives the consumer's equation. */
    assocNames: function (a, pair) {
      var self = this;
      var alias = (a.alias || '').trim();
      return this.rolesOf(pair.assoc)
        .filter(function (r) { return self.m.arcs[r].from === pair.base; })
        .map(function (r) { return self.roleAlias(alias, r); });
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
      // `units` is not decoration: it is how Simile knows what KIND of value the
      // equation yields. A condition whose function says `units=1` compiles and
      // then never filters — every association pair exists, and a ranking model
      // returns 5,5,5,5 where it should return 4,3,2,1. Every condition in the
      // 72-model corpus carries `boolean` (28) or `cond_spec` (9); none carries 1.
      var units = String((n.props || {}).units || '').trim()
        || (n.type === 'condition' ? 'boolean' : '1');
      // The equation is ALWAYS parenthesised, and that is not cosmetic.
      // `value=…` is a Prolog `=`, an xfx operator of priority 700, so neither
      // argument may itself be a 700 operator — and every comparison is one.
      // `value=a>b` therefore does not parse, and Simile drops the property
      // rather than complaining: the component vanishes from the model, a
      // membership condition silently stops filtering, and an association
      // returns every pair. That cost an afternoon. Parentheses are harmless
      // around anything, so they go on unconditionally.
      var props = [
        'complete=true',
        'name=' + atom('fn' + (++this.fnN)),
        'units=' + units,
        'value=(' + String((n.props || {})[field]).trim() + ')',
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

    /**
     * The scope each segment of a crossing arc lies in, source-side first.
     *
     * Walked without emitting anything, because a flow has to know WHICH of its
     * segments will carry the rate before it starts writing them — that segment
     * keeps the id the valve was allocated (see `allocate`).
     */
    segScopes: function (from, to) {
      var cross = this.crossings(from, to);
      var scope = this.scopeOf(from);
      var out = [];
      var self = this;
      cross.out.forEach(function (sub) { out.push(scope); scope = self.parentOf(sub); });
      cross.into.forEach(function (sub) { out.push(scope); scope = sub; });
      out.push(scope);
      return out;
    },

    /**
     * A flow, which may cross boundaries exactly as an influence does.
     *
     * `johadP.pl` runs one `overflow` out of a population `Johad`, across the
     * root and into `River` as THREE flow arcs paired by `links` under two
     * submodels — the same shape as an influence chain, and read off the file
     * rather than guessed. Every segment repeats the flow's `name`.
     *
     * The RATE sits on one segment only: the one lying in the valve's own
     * scope. Simile's other segments carry an empty function apiece
     * (`node(node00100,function,[],[name=fn3_1],[])`); we write `attached=[]`
     * instead, on the grounds that an empty function is a placeholder for the
     * editor rather than something the engine reads — and if that turns out to
     * be wrong it is one line here.
     *
     * That segment also keeps the arc id the valve was given, so an influence
     * whose SOURCE is this rate still starts from the right place.
     */
    emitFlow: function (id, a) {
      var self = this;
      var valve = this.m.nodes[a.valve] || {};
      var name = atom(valve.label || 'flow');
      var scopes = this.segScopes(a.from, a.to);
      var at = scopes.indexOf(this.parentOf(a.valve));
      if (at < 0) at = 0;          // a valve out of its flow's scopes: use the first

      var cross = this.crossings(a.from, a.to);
      var cursor = this.vis[a.from];
      var segs = [];
      var bounds = [];
      var k = 0;

      function seg(from, to) {
        var sid = k === at ? self.flowArc[id] : simId('arc', ++self.arcN);
        self.arcLines.push('arc(' + sid + ',' + from + ',' + to + ',flow,' + list([
          'attached=' + list(k === at && self.fn[a.valve] ? [self.fn[a.valve]] : []),
          'complete=true',
          'name=' + name,
        ]) + ',' + list(['caption_offset=[0,0]']) + ').');
        k++;
        return sid;
      }

      cross.out.forEach(function (sub) {
        segs.push(seg(cursor, self.border(sub, a.from)));
        bounds.push(sub);
        cursor = self.vis[sub];
      });
      cross.into.forEach(function (sub) {
        segs.push(seg(cursor, self.vis[sub]));
        bounds.push(sub);
        cursor = self.border(sub, id);
      });
      segs.push(seg(cursor, this.vis[a.to]));

      for (var j = 0; j < bounds.length; j++) this.link(bounds[j], segs[j], segs[j + 1]);
    },

    emitArc: function (id) {
      var a = this.m.arcs[id];

      // A role arc is Simile's `relation`, and its label is the role name — the
      // name the consumer's equation will end up using as a suffix.
      if (a.type === 'role') {
        var rid = simId('arc', ++this.arcN);
        this.relArc[id] = rid;
        this.arcLines.push('arc(' + rid + ',' + this.vis[a.from] + ',' + this.vis[a.to]
          + ',relation,' + list(['complete=true', 'name=' + atom(a.label || 'role')])
          + ',' + list(['caption_offset=[0,0]']) + ').');
        return;
      }

      if (a.type === 'flow') { this.emitFlow(id, a); return; }

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
      var pair = this.assocPair(cross);
      var role;
      if (pair) {
        role = this.assocRole(a, pair, cross);
      } else {
        var alias = a.alias || (this.m.nodes[a.from] || {}).label || '';
        var dim = '1';
        for (var i = 0; i < this.listCrossings(a.from, a.to); i++) dim = 'list(' + dim + ')';
        role = 'use(none,in_hierarchy,' + alias.trim() + ',' + dim + ')';
      }

      var last = simId('arc', ++this.arcN);
      this.arcLines.push('arc(' + last + ',' + cursor + ',' + this.targetOf(a.to)
        + ',influence,' + list([
          'attached=[]', 'complete=true', 'name=' + atom('i' + (++this.infN)),
          'role=[' + role + ']',
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

        // `references` lists the relation arcs this submodel takes part in: all
        // of them for an association, and its own for a base. The ORDER on the
        // association is what the role indices point into, so it is written
        // once, from `rolesOf`, and read back by `assocRole`.
        var refs = self.isAssoc(id)
          ? self.rolesOf(id)
          : Object.keys(m.arcs).filter(function (r) {
            return m.arcs[r].type === 'role' && m.arcs[r].from === id;
          });
        if (refs.length) {
          out.push('references(' + self.vis[id] + ',' + list(refs.map(function (r) {
            return 'local(' + self.relArc[r] + ')';
          })) + ').');
        }
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
