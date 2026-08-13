/**
 * `Sienna.importSimile` — read a Simile model and give back one of ours.
 *
 * The mirror of `src/export-simile.js`, and that file is the specification:
 * every correspondence documented in its header is read here in the opposite
 * direction. Where the two disagree, the exporter is right — it has been run
 * against a live engine and this has not.
 *
 * ## Why this exists
 *
 * Not to open other people's models, though it does that. The exporter has four
 * fixtures and produces models that compile and run, and item 31 still shipped
 * a bug — `value=a>b` — that compiled, ran, and was wrong. What catches that
 * class of thing is a ROUND TRIP: `.pl` → our JSON → `.pl`, over the 72 models
 * of the catalogue, comparing structure at both ends. This is the missing half.
 *
 * ## What it reads
 *
 *   - `.pl` — Simile Prolog, the form the catalogue is in.
 *   - `.sml` — the MIME container, whose model part is found BY CONTENT (the
 *     part whose body starts `source(program=`), never by position: real files
 *     order their parts differently and carry up to six of them.
 *
 * ## The surface reader is deliberately not a Prolog parser
 *
 * A clause is `functor(arg,arg,…).`, an argument is text balanced across
 * `()[]''`, and that is the whole grammar we need. In particular `value=…` is
 * NOT parsed: the right-hand side is kept as raw text, because it is already an
 * expression in the language our own PEG accepts, and re-printing a parsed term
 * would introduce exactly the spacing and parenthesisation differences a round
 * trip is trying to detect. What we store is what the file said.
 *
 * ## The four things that have to be undone
 *
 *   1. **A valued element is two nodes.** A `function` node is not an element
 *      here; it is where a `variable`'s equation and units live. Each is paired
 *      to its visible node by an influence FROM the function — and to a flow by
 *      the flow's `attached=[…]`, or (older files) by an influence from the
 *      function to the ARC id. Both spellings appear in the catalogue.
 *   2. **Influences terminate on functions.** So a segment landing on a
 *      function node is really an influence into that function's owner.
 *   3. **A flow has no valve.** The arc's `name` and its attached function's
 *      `value` are our valve's label and rate.
 *   4. **A cross-boundary influence is a chain.** `links(S,[Up-Down,…])` pairs
 *      consecutive segments; walking `prev` back from the segment that carries
 *      the `role` recovers the single arc we store. The `border` nodes the
 *      chain passes through are not elements and are dropped — we derive ports
 *      from containment (DESIGN-diagram §13), so they come back on export.
 *
 * ## Coordinates
 *
 * Simile stores a child's `centre` relative to its submodel's frame; we store
 * absolute positions. The origin of a submodel's frame is
 * `bounding_box.x1 - internal_extent.x1`, accumulated down the containment
 * tree. Read off the files rather than assumed — `test02_1submodel_1.pl` has a
 * 252-wide box and a `[0,0,252,206]` extent, which pins it.
 *
 * ## Names
 *
 * A label is an equation name (§14), so ours may hold only `[A-Za-z0-9_]` and
 * may not start with a digit. Simile's may hold anything — `Next to`, `spark?`
 * — but its OWN equations already refer to the substituted form (`spark_`), as
 * `src/schema/simile-v1.js` records. So we make the same substitution rather
 * than inventing one: the equations that arrive with the model keep working.
 * Every substitution is reported.
 *
 * ## What is dropped, and said out loud
 *
 * `spec` (the user's typed text beside the parsed value), `min_val`, `max_val`,
 * `fill_colour`, `comment`, `course`, `curve`, `caption_offset`, `enum_types`,
 * `use_sofar`, `enabled_roles`. None is load-bearing for a run — question 6 of
 * `NOTE-questions-for-developer.md` asks the developer to confirm that, and
 * until he does, dropping them silently would be the wrong shape of wrong. The
 * report lists what went.
 *
 * ## Usage
 *
 *     var r = Sienna.importSimile.read(text);   // {model, notes, stats}
 *     Sienna.importSimile.install('models/x', r.model);
 *
 * Classic script; no imports/exports.
 */
(function (Sienna) {
  'use strict';

  // Simile spellings we map onto our own node types. The population symbols are
  // the four whose spellings are INFERRED, not confirmed — §A2 of the questions
  // note. They are imported (a diagram you can look at and correct beats a
  // refusal) and every one of them is reported, so a round trip fails loudly at
  // the export end rather than quietly here.
  var NODE_TYPE = {
    compartment: 'compartment',
    variable: 'variable',
    cloud: 'cloud',
    condition: 'condition',
    // Read and drawn, though the editor cannot create one — see the schema.
    // Until 2026-08-13 this was dropped as unsupported, which made
    // `BallBerry4aP` round-trip "identical" having silently lost an alarm and
    // its three influences.
    alarm: 'alarm',
  };
  var INFERRED_TYPE = {
    creation: 'initialiser',
    loss: 'exterminator',
    immigration: 'migrator',
    reproduction: 'reproduction',
  };

  // Where each type keeps the equation its function node holds.
  var EXPR_FIELD = {
    compartment: 'initial', variable: 'value', condition: 'expr', valve: 'rate',
    initialiser: 'expr', exterminator: 'expr', migrator: 'expr', reproduction: 'expr',
    alarm: 'expr',
  };

  /** Types whose function carries `units=boolean` rather than `units=1`. */
  var BOOLEAN_TYPE = { condition: true, alarm: true };

  var DROPPED = ['spec', 'min_val', 'max_val', 'fill_colour', 'comment', 'course',
    'curve', 'caption_offset', 'enum_types', 'use_sofar', 'enabled_roles',
    'separate', 'complete', 'bounding_box', 'internal_extent', 'centre', 'along',
    'attached', 'name', 'role', 'multiplication_spec', 'units', 'value'];

  // ---- the surface reader ------------------------------------------------

  /**
   * Walk `text` from `i`, returning the index just past the balanced region.
   * Quoted atoms are opaque, and `''` inside one is an escaped quote — which is
   * why this cannot be a regexp.
   */
  function skip(text, i) {
    var depth = 0;
    while (i < text.length) {
      var c = text.charAt(i);
      if (c === "'") {
        i++;
        while (i < text.length) {
          if (text.charAt(i) === "'") {
            if (text.charAt(i + 1) === "'") { i += 2; continue; }
            i++; break;
          }
          i++;
        }
        continue;
      }
      if (c === '(' || c === '[') depth++;
      else if (c === ')' || c === ']') { depth--; if (depth === 0) return i + 1; }
      i++;
    }
    return i;
  }

  /** Split at top-level occurrences of a single-character separator. */
  function splitTop(text, sep) {
    var out = [];
    var start = 0;
    var i = 0;
    while (i < text.length) {
      var c = text.charAt(i);
      if (c === "'" || c === '(' || c === '[') {
        var j = c === "'" ? i : i;
        i = c === "'" ? quoteEnd(text, i) : skip(text, j);
        continue;
      }
      if (c === sep) { out.push(text.slice(start, i)); start = i + 1; }
      i++;
    }
    out.push(text.slice(start));
    return out;
  }

  function quoteEnd(text, i) {
    i++;
    while (i < text.length) {
      if (text.charAt(i) === "'") {
        if (text.charAt(i + 1) === "'") { i += 2; continue; }
        return i + 1;
      }
      i++;
    }
    return i;
  }

  /** `'[a,b(c),d]'` → `['a','b(c)','d']`; anything else → `[]`. */
  function items(raw) {
    var t = String(raw == null ? '' : raw).trim();
    if (t.charAt(0) !== '[' || t.charAt(t.length - 1) !== ']') return [];
    var inner = t.slice(1, -1).trim();
    if (!inner) return [];
    return splitTop(inner, ',').map(function (s) { return s.trim(); });
  }

  var ESCAPE = { n: '\n', t: '\t', r: '\r', a: '\x07', b: '\b', f: '\f', v: '\v' };

  /**
   * Strip one layer of `'…'`, undoubling internal quotes and decoding the
   * backslash escapes.
   *
   * `\n` is not decoration. A third of `johadP`'s labels contain one —
   * `name='water\ndepth'` is Simile wrapping a two-word label onto two lines —
   * and leaving the escape undecoded turned every one of them into a name with
   * a spurious letter in it (`water_ndepth`), which is a corrupted equation
   * identifier, not a cosmetic blemish. Decoded, the newline becomes `_` by the
   * ordinary naming rule and the label reads `water_depth`, which is what
   * Simile's own equations already call it.
   *
   * Found by looking at an imported model on screen. No count of nodes and arcs
   * would have shown it.
   */
  function unquote(raw) {
    var t = String(raw == null ? '' : raw).trim();
    if (t.charAt(0) !== "'" || t.length < 2) return t;
    // The opening quote must close at the very END, or this is not one atom.
    // `'A_Q'*'Gs'` starts and ends with a quote and is an EXPRESSION; testing
    // only the two end characters stripped them and left `A_Q'*'Gs`, which
    // corrupted 111 of the catalogue's equations and looked from the outside
    // like a hole in our grammar.
    if (quoteEnd(t, 0) !== t.length) return t;
    return t.slice(1, -1).replace(/''/g, "'").replace(/\\(.)/g, function (m, c) {
      return Object.prototype.hasOwnProperty.call(ESCAPE, c) ? ESCAPE[c] : c;
    });
  }

  /**
   * A property list — `[complete=true,name=level,value=(a>b)]` — as an object,
   * the value kept as raw text. The separator is `=` in node and arc terms and
   * `-` in the file-level `properties(…)`.
   *
   * The split is at the FIRST top-level separator that is not part of a
   * comparison: `value=a==b` must not be read as key `value`, value `=b`.
   */
  function pairs(raw, sep) {
    var out = {};
    items(raw).forEach(function (entry) {
      var i = firstSep(entry, sep);
      if (i < 0) { out[entry.trim()] = ''; return; }
      out[entry.slice(0, i).trim()] = entry.slice(i + 1).trim();
    });
    return out;
  }

  function firstSep(entry, sep) {
    var depth = 0;
    var i = 0;
    while (i < entry.length) {
      var c = entry.charAt(i);
      if (c === "'") { i = quoteEnd(entry, i); continue; }
      if (c === '(' || c === '[') depth++;
      else if (c === ')' || c === ']') depth--;
      else if (c === sep && depth === 0) {
        // `==`, `>=`, `=<`, `=:=`, `\=` are one token, not a separator.
        var before = entry.charAt(i - 1);
        var after = entry.charAt(i + 1);
        if ('=<>\\:'.indexOf(before) < 0 && '=<>:'.indexOf(after) < 0) return i;
      }
      i++;
    }
    return -1;
  }

  /**
   * The clauses of a file: `functor(arg,…).` with the arguments unparsed.
   * A clause ends at a `.` that is at top level and followed by whitespace —
   * the same rule Prolog itself uses, and the reason `3.5` does not end one.
   */
  function clauses(text) {
    var out = [];
    var i = 0;
    while (i < text.length) {
      var c = text.charAt(i);
      if (c === '%') { while (i < text.length && text.charAt(i) !== '\n') i++; continue; }
      if (/\s/.test(c)) { i++; continue; }

      var m = /^[a-z][A-Za-z0-9_]*/.exec(text.slice(i));
      if (!m) { i++; continue; }
      var functor = m[0];
      var open = i + functor.length;
      if (text.charAt(open) !== '(') { i = open; continue; }
      var close = skip(text, open);
      out.push({ functor: functor, args: splitTop(text.slice(open + 1, close - 1), ',') });
      i = close;
      while (i < text.length && text.charAt(i) !== '.') i++;   // past the full stop
      i++;
    }
    return out;
  }

  /**
   * The model part of a `.sml`. Found by content — the part whose decoded body
   * starts `source(program=` — because real files put their six parts in no
   * fixed order. A `.pl` is passed through unchanged.
   */
  function unwrap(text) {
    if (/^\s*source\s*\(\s*program/.test(text)) return text;
    var bound = /boundary="([^"]+)"/.exec(text);
    if (!bound) return text;
    var parts = text.split('--' + bound[1]);
    for (var i = 0; i < parts.length; i++) {
      var blank = parts[i].indexOf('\n\n');
      if (blank < 0) continue;
      var body = parts[i].slice(blank + 2);
      var decoded = /base64/i.test(parts[i].slice(0, blank)) ? debase64(body) : body;
      if (/^\s*source\s*\(\s*program/.test(decoded)) return decoded;
    }
    throw new Error('No Simile model part in this .sml — no part begins "source(program=".');
  }

  function debase64(body) {
    var bin = window.atob(body.replace(/\s+/g, ''));
    var bytes = new Uint8Array(bin.length);
    for (var i = 0; i < bin.length; i++) bytes[i] = bin.charCodeAt(i);
    return new TextDecoder().decode(bytes);
  }

  // ---- the conversion ----------------------------------------------------

  function Importer(text) {
    this.text = unwrap(text);
    this.N = {};          // simile node id -> {type, kids, p, g}
    this.A = {};          // simile arc id  -> {from, to, type, p, g}
    this.nodeIds = [];
    this.arcIds = [];
    this.links = {};      // simile submodel id -> [[upstream, downstream], …]
    this.refs = {};       // simile submodel id -> [relation arc ids]
    this.roots = [];
    this.title = '';
    this.notes = [];
  }

  Importer.prototype = {
    note: function (kind, text) {
      this.notes.push({ kind: kind, text: text });
    },

    read: function () {
      var self = this;
      clauses(this.text).forEach(function (c) {
        var a = c.args;
        if (c.functor === 'node' && a.length >= 5) {
          self.N[a[0].trim()] = {
            type: a[1].trim(), kids: items(a[2]),
            p: pairs(a[3], '='), g: pairs(a[4], '='),
          };
          self.nodeIds.push(a[0].trim());
        } else if (c.functor === 'arc' && a.length >= 5) {
          self.A[a[0].trim()] = {
            from: a[1].trim(), to: a[2].trim(), type: a[3].trim(),
            p: pairs(a[4], '='), g: pairs(a[5] || '[]', '='),
          };
          self.arcIds.push(a[0].trim());
        } else if (c.functor === 'links' && a.length >= 2) {
          self.links[a[0].trim()] = items(a[1]).map(function (pair) {
            var half = splitTop(pair, '-').map(function (s) { return s.trim(); });
            return [half[0], half[1]];
          });
        } else if (c.functor === 'references' && a.length >= 2) {
          self.refs[a[0].trim()] = items(a[1]).map(function (r) {
            var m = /^local\((.+)\)$/.exec(r.trim());
            return m ? m[1].trim() : r.trim();   // `obsolete`, `ancestor(0)` kept in place
          });
        } else if (c.functor === 'roots') {
          self.roots = items(a[0]);
        } else if (c.functor === 'properties') {
          self.title = unquote(pairs(a[0], '-').name || '');
        }
      });
      return this;
    },

    // ---- containment -----------------------------------------------------

    /** simile id → its containing submodel's simile id, or null at the top. */
    buildParents: function () {
      var self = this;
      this.parent = {};
      this.roots.forEach(function (id) { self.parent[id] = null; });
      this.nodeIds.forEach(function (id) {
        if (self.N[id].type !== 'submodel') return;
        self.N[id].kids.forEach(function (k) { self.parent[k] = id; });
      });
      // Anything named by nothing is treated as top-level rather than dropped:
      // losing an element silently is the one outcome worse than a stray one.
      this.nodeIds.forEach(function (id) {
        if (!(id in self.parent)) self.parent[id] = null;
      });
    },

    /** The absolute origin of a submodel's internal coordinate frame. */
    origin: function (subId) {
      if (subId == null) return { x: 0, y: 0 };
      this._org = this._org || {};
      if (this._org[subId]) return this._org[subId];
      var base = this.origin(this.parent[subId] == null ? null : this.parent[subId]);
      var g = this.N[subId] ? this.N[subId].g : {};
      var bb = nums(g.bounding_box);
      var ie = nums(g.internal_extent);
      var o = {
        x: base.x + (bb[0] || 0) - (ie[0] || 0),
        y: base.y + (bb[1] || 0) - (ie[1] || 0),
      };
      this._org[subId] = o;
      return o;
    },

    /** A node's absolute centre. */
    centre: function (id) {
      var c = nums((this.N[id] || {}).g && this.N[id].g.centre);
      var o = this.origin(this.parent[id] == null ? null : this.parent[id]);
      return { x: o.x + (c[0] || 0), y: o.y + (c[1] || 0) };
    },

    // ---- names -----------------------------------------------------------

    /**
     * Simile's name made legal as one of ours — the substitution Simile itself
     * already makes inside equations, so nothing that arrives stops resolving.
     */
    name: function (raw) {
      var t = unquote(raw).trim();
      if (!t) return '';
      var safe = t.replace(/[^A-Za-z0-9_]/g, '_');
      if (/^[0-9]/.test(safe)) safe = '_' + safe;
      if (safe !== t) this.note('renamed', '"' + t + '" → "' + safe + '"');
      return safe;
    },

    // ---- the build -------------------------------------------------------

    build: function () {
      var self = this;
      this.buildParents();

      var m = Sienna.Diagram.emptyModel('imported', { name: this.title || 'Imported' });
      this.m = m;
      this.ours = {};     // simile id -> our id
      this.n = { node: 0, submodel: 0, arc: 0 };

      this.pairFunctions();
      this.buildChains();
      this.makeSubmodels();
      this.makeNodes();
      this.makeFlows();
      this.makeRelations();
      this.makeInfluences();
      this.reportDropped();

      return m;
    },

    mint: function (fam) {
      return fam + (++this.n[fam]);
    },

    put: function (fam, el, geom) {
      var id = this.mint(fam);
      this.m[fam === 'submodel' ? 'submodels' : fam + 's'][id] = el;
      if (geom) this.m.layout[id] = geom;
      return id;
    },

    /**
     * Which visible element each `function` node belongs to.
     *
     * An influence FROM a function is normally the pairing that joins an
     * equation to the variable it belongs to — but not when that function is a
     * flow's RATE. A rate can feed another equation, and where Simile draws
     * that influence changed between file formats:
     *
     *   - **9.0** drew it from the flow ARC (`edinburgh1`'s
     *     `arc(arc00047,arc00045,node00027,influence,…)`).
     *   - **11.4** draws it from the rate FUNCTION.
     *
     * Reading the newer spelling as a pairing cost `johadP` twelve arcs — every
     * influence into or out of a flow rate — and set `ownerOf` to nonsense
     * besides. So the rate functions are collected FIRST, and pass three skips
     * them. Found by diffing a 2008 model against its 2026 re-save, which is
     * the one thing that could have found it.
     */
    pairFunctions: function () {
      var self = this;
      this.ownerOf = {};      // function node -> visible node id
      this.rateOf = {};       // flow arc id   -> function node
      this.pairing = {};      // arcs that are only a pairing, not an influence
      this.isRate = {};       // function node -> true, if it is some flow's rate

      // 1. `attached=[fn]` on the flow arc. 11.4 writes it on every segment.
      this.arcIds.forEach(function (id) {
        var a = self.A[id];
        if (a.type !== 'flow') return;
        var att = items(a.p.attached)[0];
        if (att) { self.rateOf[id] = att; self.isRate[att] = true; }
      });

      // 2. The older spelling: an influence from the function to the flow ARC.
      this.arcIds.forEach(function (id) {
        var a = self.A[id];
        if (a.type !== 'influence') return;
        var src = self.N[a.from];
        if (!src || src.type !== 'function') return;
        if (!self.A[a.to] || self.A[a.to].type !== 'flow') return;
        self.pairing[id] = true;
        self.rateOf[a.to] = a.from;
        self.isRate[a.from] = true;
      });

      // 3. Everything else out of a function is the pairing to its own visible
      //    node — unless the function is a rate, in which case it is a real
      //    influence carrying that rate somewhere else.
      this.arcIds.forEach(function (id) {
        var a = self.A[id];
        if (a.type !== 'influence' || self.pairing[id]) return;
        var src = self.N[a.from];
        if (!src || src.type !== 'function' || self.isRate[a.from]) return;
        self.pairing[id] = true;
        self.ownerOf[a.from] = a.to;
      });
    },

    /**
     * `links(S,[Up-Down,…])`, read as "what comes before what".
     *
     * FLOWS are segmented too, which the exporter does not yet know: `johadP`
     * runs `overflow` out of a population `Johad`, across the root, and into
     * `River` as three arcs paired under two submodels. So the walk is shared,
     * and a chain is identified by its LAST segment — the one that is nobody's
     * upstream. Source-side segments are shared between consumers, so `prev` is
     * many-to-one in that direction and only the backwards walk is unambiguous.
     */
    buildChains: function () {
      var self = this;
      this.prev = {};
      this.isUpstream = {};
      this.stub = {};
      Object.keys(this.links).forEach(function (sub) {
        self.links[sub].forEach(function (pair) {
          self.prev[pair[1]] = pair[0];
          self.isUpstream[pair[0]] = true;

          // A boundary stub, whatever the file calls it. 9.0 and later declare
          // it `border`; PRE-9.0 FILES WRITE A PLAIN `variable` in the same
          // position, which §A4 of the questions note guessed was legacy and
          // Simile 7.4 confirms by converting them on load — `lamos1a` has 142
          // variables and no borders in 2003, and 60 variables and 82 borders
          // after a re-save, the 82 being exactly the difference.
          //
          // They are identifiable without trusting the type: a `links` pair
          // names the segments either side of one boundary, and of the two
          // inner ends one is the submodel's own node and the other is the
          // stub. Reading them as real variables gave `lamos1a` 82 phantom
          // elements with no equation — which is also why it was refused for
          // "element left unfinished".
          var up = self.A[pair[0]];
          var down = self.A[pair[1]];
          if (!up || !down) return;
          if (down.from === sub) self.stub[up.to] = true;        // leaving
          else if (up.to === sub) self.stub[down.from] = true;   // entering
        });
      });
    },

    /** Every segment of the chain ending at `id`, source-side first. */
    chain: function (id) {
      var out = [id];
      var guard = 0;
      while (this.prev[out[0]] && guard++ < 200) out.unshift(this.prev[out[0]]);
      return out;
    },

    /**
     * The equation and units for an element — from its function node, or from
     * the element itself.
     *
     * A `variable` may carry `value` and `units` DIRECTLY, with no function node
     * at all: `chao.pl` writes `node(node00060,variable,…,[…,name=gain,units=1,
     * value= 1.5],…)`. Every model in the catalogue that our exporter refused
     * for "has no value" was one of these, so it is not a rare spelling — it is
     * what Simile does for a constant, and the function node is what it does for
     * an expression. The function wins where both exist.
     */
    fnProps: function (fnId, type, ownId) {
      var out = {};
      var field = EXPR_FIELD[type];
      var f = this.N[fnId];
      var own = this.N[ownId];
      var src = (f && f.p.value != null) ? f.p : (own && own.p.value != null ? own.p : (f || {}).p);
      if (!src) return out;
      if (field && src.value != null) out[field] = strip(src.value);

      // `units` is dropped when it is exactly what the exporter would have
      // supplied anyway — `1` for a valued element, `boolean` for a condition.
      // Keeping it would put a `units` field on every element of every imported
      // model and make the round trip differ from itself: our four fixtures
      // hold no units and came back holding `1`. A real unit (`kg/ha`, `Kl`)
      // is kept, which is the whole distinction worth drawing.
      var units = src.units != null ? src.units : ((own && own.p.units) || null);
      if (units != null && units !== '') {
        var u = unquote(units);
        if (u !== (BOOLEAN_TYPE[type] ? 'boolean' : '1')) out.units = u;
      }
      return out;
    },

    makeSubmodels: function () {
      var self = this;
      this.nodeIds.forEach(function (id) {
        if (self.N[id].type !== 'submodel') return;
        var g = self.N[id].g;
        var bb = nums(g.bounding_box);
        var o = self.origin(self.parent[id] == null ? null : self.parent[id]);
        var w = Math.max(40, (bb[2] || 0) - (bb[0] || 0));
        var h = Math.max(30, (bb[3] || 0) - (bb[1] || 0));
        var kind = self.kindOf(id);
        self.ours[id] = self.put('submodel', {
          kind: kind.kind,
          parent: null,                    // filled in once every id exists
          label: self.name(self.N[id].p.name || id),
          props: kind.props,
        }, { x: o.x + (bb[0] || 0) + w / 2, y: o.y + (bb[1] || 0) + h / 2, w: w, h: h });
      });
      // Parents second: a submodel may be listed before the one containing it.
      this.nodeIds.forEach(function (id) {
        if (self.N[id].type !== 'submodel') return;
        var p = self.parent[id];
        self.m.submodels[self.ours[id]].parent = p == null ? null : (self.ours[p] || null);
      });
    },

    /** `multiplication_spec` → our membership kind. */
    kindOf: function (id) {
      var spec = pairs(this.N[id].p.multiplication_spec || '[]', '=');
      var label = unquote(this.N[id].p.name || id);
      if ('type' in spec) {
        if (spec.type === 'population') return { kind: 'population', props: {} };
        this.note('unsupported',
          'submodel "' + label + '" is `type=' + spec.type
          + '`, which our editor has no kind for — imported as a single instance');
        return { kind: 'single', props: {} };
      }
      var count = items(spec.count == null ? '[]' : spec.count);
      if (!count.length) return { kind: 'single', props: {} };
      // Multi-dimensional membership is a comma-separated list in one field,
      // which is how our `dimensions` field already reads it.
      return { kind: 'fixed-membership', props: { dimensions: count.join(',') } };
    },

    makeNodes: function () {
      var self = this;
      this.nodeIds.forEach(function (id) {
        var n = self.N[id];
        if (n.type === 'submodel' || n.type === 'function') return;
        // A border is a segment stub, not an element: we derive ports from
        // containment instead (§13), so they are rebuilt on the way out. The
        // `stub` test catches the pre-9.0 spelling, where the same thing is
        // written as a plain `variable` — guarded on carrying no equation, so
        // a real element can never be mistaken for one.
        if (n.type === 'border') return;
        if (self.stub[id] && !self.ownerOf2(id)) return;

        var type = NODE_TYPE[n.type] || INFERRED_TYPE[n.type];
        if (!type) {
          self.note('unsupported', 'node type `' + n.type + '` ("'
            + unquote(n.p.name || id) + '") has no equivalent — dropped');
          return;
        }
        if (INFERRED_TYPE[n.type]) {
          self.note('inferred', '`' + n.type + '` read as our "' + type
            + '" — a spelling we have not had confirmed (§A2)');
        }

        var props = self.fnProps(self.ownerOf2(id), type, id);
        // `node(node00016,variable,[],[name=var5],[])` — no equation, no units,
        // no position, no `complete=true`. Simile lets an element sit unfinished
        // and so do we: it arrives, and our completeness colouring shows it red
        // (`src/equation-check.js`) rather than the import failing. What it will
        // NOT do is export, which is correct — it would not run either.
        var field = EXPR_FIELD[type];
        if (field && !String(props[field] || '').trim()) {
          self.note('incomplete', '"' + unquote(n.p.name || id) + '" has no '
            + field + ' in the file — imported unfinished');
        }
        var p = self.parent[id];
        self.ours[id] = self.put('node', {
          type: type,
          parent: p == null ? null : (self.ours[p] || null),
          // A cloud carries no user-visible name in our notation.
          label: type === 'cloud' ? '' : self.name(n.p.name || id),
          props: props,
        }, self.centre(id));
      });
    },

    /** A simile node's name, for a message — its own, or its type as a fallback. */
    labelOf: function (simId) {
      var n = this.N[simId];
      if (!n) return simId;
      return unquote(n.p.name || '') || ('a ' + n.type);
    },

    /** The function node belonging to a visible node, or null. */
    ownerOf2: function (visId) {
      if (!this._byOwner) {
        var self = this;
        this._byOwner = {};
        Object.keys(this.ownerOf).forEach(function (fn) {
          self._byOwner[self.ownerOf[fn]] = fn;
        });
      }
      return this._byOwner[visId];
    },

    makeFlows: function () {
      var self = this;
      this.valveFor = {};        // any segment's function node -> our valve id
      this.arcIds.forEach(function (id) {
        var a = self.A[id];
        if (a.type !== 'flow') return;
        if (self.isUpstream[id]) return;      // an inner segment; the chain ends later

        var segs = self.chain(id);
        var head = self.A[segs[0]];
        var from = self.ours[head.from];
        var to = self.ours[a.to];
        if (!from || !to) {
          self.note('dropped', 'the flow "' + unquote(a.p.name || '')
            + '" — one of its ends did not survive the import');
          return;
        }

        // The rate lives on ONE segment; the others carry an empty function
        // apiece (`node(node00100,function,[],[name=fn3_1],[])`), which is a
        // placeholder rather than a second equation. Take the first that has a
        // value, and say so if two disagree.
        var fns = segs.map(function (s) { return self.rateOf[s]; }).filter(Boolean);
        var valued = fns.filter(function (f) {
          return self.N[f] && String(self.N[f].p.value || '').trim();
        });
        if (valued.length > 1) {
          self.note('ambiguous', 'the flow "' + unquote(a.p.name || '')
            + '" has an equation on ' + valued.length + ' of its segments; kept the first');
        }

        // The valve belongs in the scope of the segment that holds the rate,
        // not necessarily the first — and a segment's scope is the parent of
        // either of its ends, which for every chain in the corpus agree
        // (`node00156` and `node00033` are both inside `River`).
        var rateSeg = segs.filter(function (s) {
          return self.rateOf[s] && self.N[self.rateOf[s]]
            && String(self.N[self.rateOf[s]].p.value || '').trim();
        })[0] || segs[0];
        var p = self.parent[self.A[rateSeg].from];
        var valve = self.put('node', {
          type: 'valve',
          parent: p == null ? null : (self.ours[p] || null),
          label: self.name(a.p.name || 'flow'),
          props: self.fnProps(valued[0] || fns[0], 'valve'),
        }, null);   // a valve rides at its arc's midpoint; it stores no position
        var ours = self.put('arc', {
          type: 'flow', from: from, to: to, valve: valve, props: {},
        }, null);
        segs.forEach(function (s) { self.ours[s] = ours; });
        // An influence into ANY segment's rate is an influence into the valve.
        fns.forEach(function (f) { self.valveFor[f] = valve; });
      });
    },

    makeRelations: function () {
      var self = this;
      this.arcIds.forEach(function (id) {
        var a = self.A[id];
        if (a.type !== 'relation') return;
        var from = self.ours[a.from];
        var to = self.ours[a.to];
        if (!from || !to) { self.note('dropped', 'a relation arc with a missing end'); return; }
        self.ours[id] = self.put('arc', {
          type: 'role', from: from, to: to, label: self.name(a.p.name || 'role'), props: {},
        }, null);
      });
    },

    /**
     * Segments back into arcs. `links(S,[Up-Down])` gives each segment its
     * predecessor; a chain is identified by its LAST segment — the one carrying
     * the role — and walked backwards to the source. Source-side segments are
     * shared between consumers, so `prev` is many-to-one in that direction and
     * walking forwards would have to branch; backwards it does not.
     */
    makeInfluences: function () {
      var self = this;
      this.arcIds.forEach(function (id) {
        var a = self.A[id];
        if (a.type !== 'influence') return;
        if (self.pairing[id]) return;          // a function joined to its owner
        if (self.isUpstream[id]) return;       // an inner segment; its chain ends later

        var head = self.chain(id)[0];
        var srcSim = self.A[head].from;
        var from = self.ours[srcSim];
        // A flow's own rate can be an input to something else. We draw that
        // from the valve, which is where the rate lives; Simile draws it from
        // the flow ARC (9.0) or from the rate FUNCTION (11.4). Both arrive here.
        if (self.A[srcSim] && self.A[srcSim].type === 'flow') {
          from = (self.m.arcs[self.ours[srcSim]] || {}).valve;
        } else if (self.isRate[srcSim]) {
          from = self.valveOfFn(srcSim);
        }

        // The far end lands on a function (so: on that function's owner), on a
        // flow's rate function (so: on that flow's valve), or straight on the
        // flow ARC — `ageclass5` writes all its rate influences that way, and
        // it means the same thing.
        var toSim = a.to;
        var to = null;
        if (self.ownerOf[toSim]) to = self.ours[self.ownerOf[toSim]];
        else if (self.valveOfFn(toSim)) to = self.valveOfFn(toSim);
        else if (self.A[toSim] && self.A[toSim].type === 'flow') {
          to = (self.m.arcs[self.ours[toSim]] || {}).valve;
        } else to = self.ours[toSim];

        if (!from || !to) {
          // Naming the source is what makes this actionable. `biomewater2` has
          // two influences that run into a border and stop — no `links` pair
          // continues them, so they are half-drawn arcs in the file itself,
          // not something we failed to follow.
          var why = (self.N[toSim] || {}).type === 'border'
            ? 'it ends at a border stub that no `links` pair continues'
            : 'one of its ends did not survive the import';
          self.note('dropped', 'the influence from "'
            + self.labelOf(srcSim) + '" — ' + why);
          return;
        }

        self.ours[id] = self.put('arc', {
          type: 'influence', from: from, to: to,
          alias: self.aliasOf(a, from), props: {},
        }, null);
      });
    },

    /** Our valve id for a function node that is some flow's rate. */
    valveOfFn: function (fnId) {
      return this.valveFor[fnId];
    },

    /**
     * The name the consumer's equation uses for this value.
     *
     * `use(none,in_hierarchy,ALIAS,DIM)` gives it directly, brackets and all —
     * and the brackets matter, since our exporter reads them back to decide
     * whether an outward crossing is a list.
     *
     * `usr(x)` is stripped. Question 1 of the questions note asks whether it is
     * more than a marker for "the modeller typed this name rather than Simile
     * defaulting it"; we emit bare aliases throughout, so reading it as
     * decoration is at least consistent in both directions.
     *
     * ## Associations, and a convention we do not share
     *
     * An association crossing gives one `use(…)` per role. We hold one alias per
     * arc, so the role suffix has to come off — and the corpus shows Simile has
     * used **two** conventions for putting it on:
     *
     *   - the role NAME: `class_this` / `class_next` (`ageclass6`, 2008). This
     *     is what our exporter derives, so it comes off cleanly.
     *   - an ORDINAL: `var12` / `var12_0`, `biomass` / `biomass_0` (`hexagon`,
     *     2003) — the first end unadorned, later ends numbered.
     *
     * Both are undone here. What cannot be undone is that **the consumer's
     * equation uses whichever names the file had**, and our exporter will write
     * the other convention — so an imported association model re-exports with
     * equations naming ends that no longer exist, and the exporter's own check
     * says so and refuses. That is a limitation of holding one alias per arc,
     * not of this file, and it is the first thing the round trip found that the
     * fixtures could not.
     */
    aliasOf: function (a, ourFrom) {
      var uses = items(a.p.role).map(parseUse).filter(Boolean);
      if (!uses.length) {
        var el = this.m.nodes[ourFrom] || this.m.submodels[ourFrom] || {};
        return el.label || '';
      }
      var u = uses[0];
      if (u.dir === 'in_hierarchy') return u.alias;

      // Brackets say "this is a list" and belong to the containment case; an
      // association role carries them on the `use` term, not in our alias.
      var bare = u.name;
      var role = this.roleNameFor(u);
      if (role) {
        var suffix = '_' + String(role).replace(/[^A-Za-z0-9_]/g, '_');
        if (bare.length > suffix.length && bare.slice(-suffix.length) === suffix) {
          return bare.slice(0, -suffix.length);
        }
      }
      // The ORDINAL convention — `var12` / `var12_0` in `hexagon` (2003), where
      // the first end is unadorned and later ones numbered. Only reached when no
      // role name was stripped, and that guard matters: `Molusc`'s
      // `remaining_surplus_4_link` is `remaining_surplus_4` under role `link`,
      // and stripping the `_4` as well renamed a variable that exists.
      return bare.replace(/_\d+$/, '');
    },

    /**
     * The role name whose suffix this alias carries.
     *
     * The obvious route is the `use(…)` INDEX — a position in the association's
     * `references` list, which `landuse1b` proves is not simply 0,1 (its list
     * starts with two `obsolete` placeholders). But finding the association from
     * the arc alone is guesswork when the crossing also climbs the containment
     * tree, and `Molusc_june06` has five relations named `link`, `Link`,
     * `link2`, `link 3`, `link 4` — pick the wrong list and `countryID_link`
     * keeps its suffix and then gets another one appended.
     *
     * So the SUFFIX MATCH goes first, because it is self-validating: a name is
     * only stripped when the alias actually ends with it. The index is the
     * fallback, for the case where a modeller's alias happens not to follow the
     * convention. Longest match wins, so `link2` beats nothing and `link` does
     * not eat the tail of `link2`.
     */
    roleNameFor: function (u) {
      var self = this;
      var best = null;
      this.arcIds.forEach(function (id) {
        if (self.A[id].type !== 'relation') return;
        var n = unquote(self.A[id].p.name || '').replace(/[^A-Za-z0-9_]/g, '_');
        if (!n) return;
        if (u.name.length > n.length + 1 && u.name.slice(-(n.length + 1)) === '_' + n) {
          if (!best || n.length > best.length) best = n;
        }
      });
      if (best) return best;

      if (u.index == null) return null;
      var found = null;
      Object.keys(this.refs).forEach(function (sub) {
        if (found) return;
        var arcId = self.refs[sub][u.index];
        if (arcId && self.A[arcId] && self.A[arcId].type === 'relation') {
          found = unquote(self.A[arcId].p.name || '');
        }
      });
      return found;
    },

    /** Everything present in the file that we did not carry across. */
    reportDropped: function () {
      var self = this;
      var seen = {};
      var look = function (bag) {
        Object.keys(bag).forEach(function (k) {
          if (DROPPED.indexOf(k) >= 0 && k !== 'name' && k !== 'value' && k !== 'units'
              && k !== 'role' && k !== 'attached' && k !== 'multiplication_spec'
              && k !== 'centre' && k !== 'bounding_box' && k !== 'internal_extent'
              && k !== 'complete' && k !== 'along') {
            seen[k] = (seen[k] || 0) + 1;
          }
        });
      };
      this.nodeIds.forEach(function (id) { look(self.N[id].p); look(self.N[id].g); });
      this.arcIds.forEach(function (id) { look(self.A[id].p); look(self.A[id].g); });
      Object.keys(seen).sort().forEach(function (k) {
        self.note('ignored', '`' + k + '` (' + seen[k] + ') — not part of our model');
      });
    },
  };

  /** `use(0,in_base,attribute_higher,list(1))` → its four fields. */
  function parseUse(raw) {
    var m = /^use\s*\((.*)\)$/.exec(String(raw).trim());
    if (!m) return null;
    var f = splitTop(m[1], ',').map(function (s) { return s.trim(); });
    if (f.length < 4) return null;
    var parts = aliasParts(f[2]);
    return {
      index: f[0] === 'none' ? null : parseInt(f[0], 10),
      dir: f[1],
      alias: parts.open + parts.name + parts.close,   // brackets kept: they mean "list"
      name: parts.name,                               // the identifier alone
      dim: f[3],
    };
  }

  /**
   * Pull a `use(…)` alias apart into its brackets and the identifier inside.
   *
   * Three wrappers, in this order, and the order is the point:
   *
   *   `usr(…)`  the modeller typed this name rather than Simile defaulting it
   *             (question 1 of the questions note). Decoration; we emit bare
   *             aliases in both directions.
   *   `{…}` `[…]`  the value arrives as a LIST. Kept — our model stores them and
   *             the equation writes them.
   *   `'…'`    a quoted atom, because the name has a space or a capital in it.
   *
   * Unquoting BEFORE unbracketing is what a first version did, and it silently
   * did nothing: `{'Pheromone_has'}` does not start with a quote, so the quotes
   * survived into the stored alias and every comparison against the equation
   * failed. Then the identifier is legalised the same way a label is — Simile's
   * own equations already use the substituted form.
   */
  function aliasParts(raw) {
    var t = String(raw == null ? '' : raw).trim();
    var usr = /^usr\s*\((.*)\)$/.exec(t);
    if (usr) t = usr[1].trim();

    var open = (/^[{[]+/.exec(t) || [''])[0];
    var close = (/[}\]]+$/.exec(t) || [''])[0];
    var inner = unquote(t.slice(open.length, t.length - close.length).trim());

    var name = inner.replace(/[^A-Za-z0-9_]/g, '_');
    if (/^[0-9]/.test(name)) name = '_' + name;
    return { open: open, close: close, name: name };
  }

  /** `'[203,54,455,260]'` → `[203,54,455,260]`. */
  function nums(raw) {
    return items(raw).map(function (s) { return parseFloat(s); });
  }

  /**
   * An equation as we should store it. Simile writes `value=(…)` and our
   * exporter puts those parentheses on unconditionally (item 31), so one
   * redundant enclosing pair is removed — otherwise every round trip would add
   * a layer. Only when it wraps the WHOLE expression: `(a)+(b)` keeps both.
   */
  function strip(raw) {
    var t = unquote(raw).trim();
    while (t.charAt(0) === '(' && skip(t, 0) === t.length) {
      var inner = t.slice(1, -1).trim();
      if (!inner) break;
      t = inner;
    }
    return t;
  }

  Sienna.importSimile = {
    /**
     * Read a `.pl` or `.sml`.
     * @returns {{model:object, notes:Array, stats:object}}
     */
    read: function (text) {
      var imp = new Importer(String(text)).read();
      var model = imp.build();
      return {
        model: model,
        notes: imp.notes,
        stats: {
          nodes: Object.keys(model.nodes).length,
          arcs: Object.keys(model.arcs).length,
          submodels: Object.keys(model.submodels).length,
        },
      };
    },

    /**
     * Put an imported model in the store at `path`, as one undoable action, and
     * seed the ports every crossing arc needs — those are derived from
     * containment, so they exist the moment the arcs do and only their
     * positions have to be placed.
     * @returns {Sienna.Diagram}
     */
    install: function (path, model) {
      var id = String(path).split('/').pop();
      var m = JSON.parse(JSON.stringify(model));
      m.id = id;
      var d = new Sienna.Diagram(path);
      Sienna.actions.dispatch(
        { type: 'diagram.import', target: path, payload: { name: m.name } },
        function () {
          Sienna.userData.set(path, m);
          // Inside the same transaction, so an import is ONE undo step and the
          // seeded port positions go with it. Ports exist the moment the arcs
          // do (they are derived from containment, §13); only their positions
          // are written, and only where the model does not already have one.
          d._seedAllPorts();
        }
      );
      return d;
    },

    // Exposed for the round-trip harness and for anyone debugging a file.
    _clauses: clauses,
    _unwrap: unwrap,
    _pairs: pairs,
    _items: items,
  };
})(window.Sienna);
