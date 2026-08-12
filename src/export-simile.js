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
 * ## What it will not do yet
 *
 * **Submodels.** Not because containment is hard, but because a *cross-boundary
 * influence* is: we store one arc end to end, Simile stores segments joined by
 * `border` nodes and paired in a `links(…)` fact (see `NOTE-export-to-simile.md`
 * §3, and DESIGN-diagram §13). Rather than emit a model that loads and is
 * quietly wrong, a model with submodels is refused by name.
 *
 * That restriction also keeps us clear of the one question we cannot answer
 * ourselves — the dimensional term, `1` vs `list(1)` (§4 of the note). It only
 * arises when an influence crosses a boundary; within one level every reference
 * is a scalar, and `1` is right by construction.
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
    this.vis = {};   // our id -> Simile id of the VISIBLE node
    this.fn = {};    // our id -> Simile id of the FUNCTION node (equation half)
    this.attachedFn = {}; // Simile fn ids that hang off an arc, not the tree
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

      var subs = Object.keys(m.submodels || {});
      if (subs.length) {
        problems.push('it has submodels (' + subs.map(function (s) {
          return m.submodels[s].label || s;
        }).join(', ') + '), and cross-boundary influences are not converted yet');
      }

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
        if (a.type === 'role') problems.push('it has a role arc, which needs submodels');
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

      Object.keys(m.nodes).forEach(function (id) {
        var n = m.nodes[id];
        // A valve has no visible node — it IS its equation, which the flow arc
        // will carry as `attached`.
        if (n.type !== 'valve') self.vis[id] = simId('node', ++self.nodeN);
        if (self.exprField(n.type)) self.fn[id] = simId('node', ++self.nodeN);
      });
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
    emitPairing: function (id, out) {
      var n = this.m.nodes[id];
      if (n.type === 'valve' || !this.fn[id]) return;
      out.push('arc(' + simId('arc', ++this.arcN) + ',' + this.fn[id] + ',' + this.vis[id]
        + ',influence,' + list(['attached=[]', 'name=' + atom('i' + (++this.infN))]) + ',[]).');
    },

    /**
     * Where an influence really lands: on the target's equation, never on the
     * target's visible node.
     */
    targetOf: function (ourId) {
      return this.fn[ourId] || this.vis[ourId];
    },

    emitArc: function (id, out) {
      var a = this.m.arcs[id];

      if (a.type === 'flow') {
        var valve = this.m.nodes[a.valve] || {};
        var props = [
          'attached=' + list(this.fn[a.valve] ? [this.fn[a.valve]] : []),
          'complete=true',
          'name=' + atom(valve.label || 'flow'),
        ];
        out.push('arc(' + simId('arc', ++this.arcN) + ',' + this.vis[a.from] + ','
          + this.vis[a.to] + ',flow,' + list(props) + ',' + list(['caption_offset=[0,0]']) + ').');
        return;
      }

      // An influence. The alias is what the consumer's equation says, and the
      // trailing `1` is the dimensional term — correct by construction while
      // every reference is a same-level scalar (see the header).
      var alias = a.alias || (this.m.nodes[a.from] || {}).label || '';
      var iprops = [
        'attached=[]',
        'complete=true',
        'name=' + atom('i' + (++this.infN)),
        'role=[use(none,in_hierarchy,' + atom(alias) + ',1)]',
      ];
      out.push('arc(' + simId('arc', ++this.arcN) + ',' + this.vis[a.from] + ','
        + this.targetOf(a.to) + ',influence,' + list(iprops) + ',[]).');
    },

    run: function () {
      var m = this.m;
      var self = this;
      this.check();
      this.allocate();

      var out = [];
      out.push(SOURCE_LINE + atom(new Date().toString()) + ').');
      out.push('');

      // Everything at the top level, both halves of each pair. An attached
      // function is NOT a root — it belongs to its arc.
      var roots = [];
      Object.keys(m.nodes).forEach(function (id) {
        if (m.nodes[id].parent) return;
        if (self.vis[id]) roots.push(self.vis[id]);
        if (self.fn[id] && m.nodes[id].type !== 'valve') roots.push(self.fn[id]);
      });
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

      Object.keys(m.nodes).forEach(function (id) {
        self.emitNode(id, out);
        self.emitFunction(id, out);
      });
      out.push('');

      Object.keys(m.nodes).forEach(function (id) { self.emitPairing(id, out); });
      Object.keys(m.arcs).forEach(function (id) { self.emitArc(id, out); });

      return out.join('\n') + '\n';
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
