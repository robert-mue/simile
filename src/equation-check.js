/**
 * `Sienna.equationCheck` — hold a model's equations up against its diagram.
 *
 * The join between three things that each stay ignorant of the others: the
 * parser (`src/equation.js`) knows syntax and nothing about models; the model
 * layer (`src/diagram.js`) knows elements and arcs and nothing about equations;
 * the schema says which fields hold an expression and what functions exist.
 * Only this file knows all three, which is why it is its own file rather than
 * an addition to any of them. In particular it is NOT part of `src/grammar.js`,
 * whose contract is that it contains no rule of its own and evaluates only the
 * schema's graph rules — an equation is not a graph rule.
 *
 * Four findings, all **deferred** in the sense of §12.3: reported, never
 * blocking. An equation is stored verbatim however wrong it is (§4).
 *
 *   syntax    it does not parse, and where.
 *   function  a call to something the schema's function table does not list,
 *             or with the wrong number of arguments.
 *   undeclared  a name with no influence arrow supplying it. In Simile a value
 *             may only reach an equation along an arrow, so this is the check
 *             that catches an equation written faster than the diagram.
 *   unused    the mirror: an influence drawn into the element whose name the
 *             equation never mentions — an arrow that promises something the
 *             equation does not use.
 *
 * The last two are the point of the whole exercise, and neither is available to
 * a parser or a diagram alone. They are compared on the influence's **alias**,
 * which is exactly the name the target's equation is supposed to use (§14.1),
 * defaulting to the source's label.
 *
 * `unused` is only reported for an element that HAS an equation: while a model
 * is being built the arrows normally arrive first, and complaining about every
 * fresh arrow would make the report worthless.
 *
 * A reference's FORM is not checked yet — that a `{x}` wants an influence out
 * of a variable-membership submodel and `[x]` out of a fixed one is a sharper
 * check the parser already provides the information for. Left until the
 * dimensional rules are settled with the Simile developer (§8, §19.8).
 *
 * Classic script; no imports/exports. Load after `src/equation.js`.
 */
(function (Sienna) {
  'use strict';

  /** Does `n` satisfy this table entry? A number is exact; an array is a set. */
  function arityOk(spec, n) {
    return Array.isArray(spec) ? spec.indexOf(n) >= 0 : spec === n;
  }

  function arityText(spec) {
    if (!Array.isArray(spec)) return spec + (spec === 1 ? ' argument' : ' arguments');
    return spec.join(' or ') + ' arguments';
  }

  /**
   * A syntax error in a sentence. Peggy's own message lists every token that
   * could have come next, which is a fine thing for a compiler and a poor thing
   * to put in front of a modeller; the position is what an underline needs.
   */
  function describe(error) {
    if (error.found == null) return 'the equation is unfinished';
    return 'unexpected "' + error.found + '" at character ' + error.column;
  }

  /** Every call in the tree, as {name, count, at}. */
  function calls(node, out) {
    out = out || [];
    if (!node || typeof node !== 'object') return out;
    if (node.t === 'call') out.push({ name: node.name, count: node.args.length, at: node.at });
    ['left', 'right', 'operand', 'body', 'otherwise'].forEach(function (k) { calls(node[k], out); });
    (node.items || []).forEach(function (n) { calls(n, out); });
    (node.args || []).forEach(function (n) { calls(n, out); });
    (node.clauses || []).forEach(function (c) { calls(c.cond, out); calls(c.value, out); });
    (node.bindings || []).forEach(function (b) { calls(b.value, out); });
    return out;
  }

  /**
   * The expression-valued fields of an element's type, from the schema's field
   * model — so a notation with different fields is checked without a change
   * here, and a type with two equations has both checked.
   */
  function expressionFields(d, id, el) {
    el = el || d.get(id);
    if (!el) return [];
    var schema = d.schema();
    var spec = String(id).indexOf('submodel') === 0 ? schema.submodel : (schema.nodes[el.type] || schema.arcs[el.type]);
    return ((spec && spec.fields) || []).filter(function (f) {
      return f.type === 'expression' || f.type === 'expression-list';
    });
  }

  /**
   * The expressions a field holds: one, or several separated by top-level
   * commas when the schema says `expression-list`.
   *
   * Each part carries its offset within the field, so an error still underlines
   * the right characters — the reason this returns positions rather than just
   * strings.
   *
   * The split respects brackets, because `count=[size(a,b),4]` is two sizes and
   * `size(a,b)` is one of them. That is the whole reason it is not `.split(',')`.
   */
  function parts(text, field) {
    var t = String(text);
    if (field.type !== 'expression-list') return [{ text: t, at: 0 }];

    var out = [];
    var depth = 0;
    var start = 0;
    for (var i = 0; i < t.length; i++) {
      var c = t.charAt(i);
      if (c === '(' || c === '[' || c === '{') depth++;
      else if (c === ')' || c === ']' || c === '}') depth--;
      else if (c === ',' && depth === 0) {
        out.push({ text: t.slice(start, i), at: start });
        start = i + 1;
      }
    }
    out.push({ text: t.slice(start), at: start });
    return out.filter(function (p) { return p.text.trim() !== ''; });
  }

  /**
   * The names available to this element's equations: one per influence arriving
   * at it, being that arc's alias (§14.1).
   */
  /**
   * The names the influences into `id` supply to its equation.
   *
   * Asked of the MODEL LAYER rather than read off `arc.alias` here, because the
   * alias is not always the name: an outward crossing stores it bracketed
   * (`[biomass]`, which the equation writes but the parser reports as
   * `biomass`), and an association crossing supplies one name per role
   * (`attribute_higher` and `attribute_lower` from one `attribute`). Reading
   * the raw alias made `stand` and `mixed` — two fixtures that run correctly on
   * the Simile engine — report both "undeclared" and "unused" for the same
   * arrow, which is the signature of comparing two spellings of one thing.
   */
  function suppliedNames(d, id) {
    var out = [];
    d.arcsAt(id).forEach(function (a) {
      var arc = d.get(a);
      if (!arc || arc.type !== 'influence' || arc.to !== id) return;
      var model = d.model();
      var roles = Sienna.Diagram.rolesCrossedBy(model, a);
      // Each with the brackets its value has where it arrives
      // (`Diagram.valueAt`): `{x}` a list, `[x]` an array, `{[x]}` …
      if (roles.length) {
        roles.forEach(function (r) {
          var name = Sienna.Diagram.roleAliasFor(model, a, r);
          var v = Sienna.Diagram.valueAt(model, a, r);
          if (name !== '') out.push({ name: name, arc: a, value: v });
        });
        return;
      }
      var v = Sienna.Diagram.valueAt(model, a);
      d.namesSuppliedBy(a).forEach(function (name) {
        out.push({ name: name, arc: a, value: v });
      });
    });
    return out;
  }

  /**
   * What a delivered value is, in words: 'a single value', 'a list (one value
   * per instance or pairing)', 'an array of 5', 'a list of arrays of 60'…
   */
  function valueWords(v) {
    if (!v.dims.length) return 'a single value';
    var words = v.dims.map(function (d, i) {
      var plural = i > 0;
      return d === 'var' ? (plural ? 'lists' : 'a list')
        : (plural ? 'arrays of ' : 'an array of ') + d;
    });
    return words.join(' of ') + (v.dims[0] === 'var' ? ' (one value per instance or pairing)' : '');
  }

  /**
   * Check one element's equations.
   * @returns {Array<{id, label, kind, field, message, at?}>}
   */
  function element(d, id, draft) {
    var el = draft || d.get(id);
    if (!el) return [];
    var fields = expressionFields(d, id, el);
    if (!fields.length) return [];

    var schema = d.schema();
    var table = schema.functions || {};
    var label = el.label || id;
    var props = el.props || {};
    var out = [];
    var usedNames = {};
    var anyEquation = false;
    var anyBroken = false;

    fields.forEach(function (f) {
      var text = props[f.name];
      if (text == null || String(text).trim() === '') return;
      anyEquation = true;

      parts(text, f).forEach(function (part) {
        var parsed = Sienna.equation.parse(part.text);
        if (!parsed.ok) {
          anyBroken = true;
          out.push({
            id: id, label: label, kind: 'syntax', field: f.name,
            at: part.at + parsed.error.offset,
            message: f.label + ': ' + describe(parsed.error),
          });
          return;                                // no tree, so nothing further to say
        }

        // A whole equation that is a list: no model variable can hold one
        // (Simile's words, below); nor can a field that must be ONE number
        // hold an array. Simile's generator lets both through and the C++
        // fails, so say it here.
        var whole = Sienna.equation.wholeForm(parsed.ast);
        if (whole === 'list' || (whole === 'array' && f.scalar)) {
          out.push({
            id: id, label: label, kind: 'form', field: f.name, at: part.at, len: part.text.length,
            message: f.label + ': ' + Sienna.equation.collectionMessage(whole, part.text),
          });
        }

        calls(parsed.ast).forEach(function (c) {
          if (!Object.prototype.hasOwnProperty.call(table, c.name)) {
            out.push({
              id: id, label: label, kind: 'function', field: f.name,
              at: part.at + c.at, len: c.name.length,
              message: f.label + ': no such function "' + c.name + '"',
            });
          } else if (c.name === 'graph' && !props.graph) {
            // `graph(x)` reads THIS element's sketched graph; with none drawn
            // the engine has nothing to read.
            var typeSpec = String(id).indexOf('submodel') === 0 ? schema.submodel : schema.nodes[el.type];
            var canSketch = ((typeSpec && typeSpec.fields) || []).some(function (x) { return x.type === 'sketch'; });
            out.push({
              id: id, label: label, kind: 'function', field: f.name,
              at: part.at + c.at, len: c.name.length,
              message: f.label + ': graph() uses this element\'s sketched graph, '
                + (canSketch ? 'and none has been drawn yet — draw one on the Graph tab'
                  : 'which this kind of element cannot have'),
            });
          } else if (!arityOk(table[c.name], c.count)) {
            out.push({
              id: id, label: label, kind: 'function', field: f.name,
              at: part.at + c.at, len: c.name.length,
              message: f.label + ': ' + c.name + '() takes ' + arityText(table[c.name]) +
                       ', not ' + c.count,
            });
          }
        });

        // Keep WHERE each name was written, not just that it was. An
        // `undeclared` finding is about a name the modeller can see in front of
        // them, so it can be pointed at — and the offsets are already in the
        // AST, which is the only place they can come from.
        Sienna.equation.references(parsed.ast).forEach(function (ref) {
          if (!usedNames[ref.name]) {
            usedNames[ref.name] = { field: f.name, at: part.at + ref.at, len: ref.name.length, onlySize: true };
          }
          if (!ref.sizeOf) usedNames[ref.name].onlySize = false;
          // Every way it was written — its brackets — for the form check below.
          (usedNames[ref.name].forms = usedNames[ref.name].forms || []).push({
            open: ref.open || '', field: f.name, at: part.at + ref.at,
          });
        });
      });
    });

    // Nothing written yet: say nothing. Nothing that PARSES: say nothing more,
    // since an equation we could not read tells us nothing about which names it
    // uses, and every arrow would otherwise be reported as unused on the
    // strength of a missing bracket.
    if (!anyEquation || anyBroken) return out;

    var supplied = suppliedNames(d, id);
    var suppliedSet = {};
    supplied.forEach(function (s) { suppliedSet[s.name] = true; });

    // `size(cell)`, `cell` a submodel: its number of instances, which
    // Simile gives without an arrow (AntsWorld, drainage1, lamos1a/b).
    var key = function (x) { return String(x).replace(/[^A-Za-z0-9]/g, '').toLowerCase(); };
    var submodelNames = {};
    d.ids('submodels').forEach(function (sid) { submodelNames[key((d.get(sid) || {}).label || '')] = true; });

    Object.keys(usedNames).forEach(function (name) {
      if (usedNames[name].onlySize && submodelNames[key(name)]) return;
      if (!suppliedSet[name]) {
        var where = usedNames[name];
        out.push({
          id: id, label: label, kind: 'undeclared', name: name,
          field: where.field, at: where.at, len: where.len,
          message: '"' + name + '" is used but no influence supplies it',
        });
      }
    });

    // A name is written in the brackets its value has where it arrives —
    // one per level, to any depth: `{x}` a list (out of a population, or an
    // association, one per pairing), `[x]` an array (out of a fixed
    // membership, or an array variable), `{[x]}` a list of arrays…
    // (`Diagram.valueAt`, Simile's own rule). Written otherwise, Simile
    // refuses the model (`bad_parameter`) or its C++ does not compile.
    // A name with other brackets may be another input: `ID1` (one value,
    // through a role) beside `[ID1]` (an array, from elsewhere) is two
    // (assoc_from_data1). So a use is wrong only when nothing supplies the
    // name in the brackets it is written in.
    var reported = {};
    supplied.forEach(function (s) {
      var u = usedNames[s.name];
      if (!u || !u.forms || reported[s.name]) return;
      var wrong = u.forms.filter(function (w) {
        return !supplied.some(function (x) { return x.name === s.name && x.value.open === w.open; });
      })[0];
      if (!wrong) return;
      reported[s.name] = true;
      var want = s.value.open + s.name + s.value.close;
      out.push({
        id: id, label: label, kind: 'form', name: s.name,
        field: wrong.field, at: wrong.at, len: s.name.length,
        message: '"' + s.name + '" arrives as ' + valueWords(s.value) + ': write ' + want
          + (s.value.dims[0] === 'var' ? ', e.g. sum(' + want + ')' : ''),
      });
    });

    // `unused` is a question about the ARROW, not about each name — and across
    // an association one arrow supplies several. `demo-mixed`'s ranking uses
    // `count({one_lower})` and never mentions `one_higher`, which is correct
    // and runs correctly; the arrow is doing its job. So an influence is unused
    // only when the equation uses NONE of the names it brings.
    var byArc = {};
    supplied.forEach(function (s) {
      var e = byArc[s.arc] = byArc[s.arc] || { names: [], used: false };
      e.names.push(s.name);
      if (usedNames[s.name]) e.used = true;   // an entry means the name was written
    });
    Object.keys(byArc).forEach(function (arc) {
      if (byArc[arc].used) return;
      var names = byArc[arc].names;
      out.push({
        id: id, label: label, kind: 'unused', name: names[0], arc: arc,
        message: 'an influence supplies "' + names.join('" / "')
                 + '", which the equation does not use',
      });
    });

    return out;
  }

  /**
   * Is this element complete — black rather than red (§19.9)?
   *
   * Incomplete on any of four counts, which is exactly the set of findings
   * above plus one the findings cannot carry: a REQUIRED field left empty,
   * since `element()` has nothing to say about an equation that was never
   * written. Which fields are required is schema data (`required`, and
   * `requiredWhen` for a field that only applies to some kinds), never decided
   * here.
   *
   * An element with no required fields — a cloud — is never incomplete.
   *
   * DERIVED, never stored. Simile keeps a `complete=true` flag in the file; we
   * do not, because completeness depends on the ARROWS as well as the equation
   * (§19.9): drawing an influence into an element can make it incomplete
   * without its equation changing, and a stored flag would be wrong the moment
   * that happened. The cost of deriving it is a parse per equation per render,
   * which is what the cache in `src/equation.js` is for.
   *
   * **`draft`** is an element-shaped object to test INSTEAD of the stored one:
   * what the dialog is holding but has not written. It exists so a dialog can
   * ask "is what I have in my hands correct?" before committing anything, which
   * is what lets OK offer to go back to the equation rather than reporting on a
   * model the modeller has already been given. The arrows are still read from
   * the model, because a dialog does not edit those.
   *
   * @param {Sienna.Diagram} d
   * @param {string} id
   * @param {object} [draft]  an element to test in place of the stored one
   * @returns {{complete: boolean, reasons: Array}}
   */
  function completeness(d, id, draft) {
    var el = draft || d.get(id);
    if (!el) return { complete: true, reasons: [] };

    var reasons = [];
    var props = el.props || {};
    // A role arrow's name is part of every name an influence across the
    // association supplies (`id_farmer`): with none, they end in a bare `_`.
    if (el.type === 'role' && String(id).indexOf('arc') === 0 && !String(el.label || '').trim()) {
      reasons.push({
        id: id, label: id, kind: 'missing', field: 'label',
        message: 'this role arrow has no name — every name an influence across the association supplies is made from it',
      });
    }
    expressionFields(d, id, el).forEach(function (f) {
      if (!isRequired(el, f)) return;
      var text = props[f.name];
      if (text == null || String(text).trim() === '') {
        reasons.push({
          id: id, label: el.label || id, kind: 'missing', field: f.name,
          message: f.label + ' is not set',
        });
      }
    });

    var all = reasons.concat(element(d, id, draft));
    return { complete: !all.length, reasons: all };
  }

  /** A field is required outright, or required given another field's value. */
  function isRequired(el, f) {
    // `exemptWhen`: not needed given other fields' values — a parameter's
    // equation, whose value is given when the model runs. One condition or
    // a list of them, any of which exempts; a list of values matches any.
    var exempt = [].concat(f.exemptWhen || []).some(function (cond) {
      return Object.keys(cond).every(function (k) {
        var v = el[k] !== undefined ? el[k] : (el.props || {})[k];
        return [].concat(cond[k]).indexOf(v) >= 0;
      });
    });
    if (exempt) return false;
    if (f.required) return true;
    if (!f.requiredWhen) return false;
    return Object.keys(f.requiredWhen).every(function (k) {
      return (el[k] !== undefined ? el[k] : (el.props || {})[k]) === f.requiredWhen[k];
    });
  }

  /**
   * Every element, in one pass — the whole-model report behind "check model".
   * Uses `completeness`, not `element`, so that an unwritten required equation
   * is reported alongside a wrong one: both leave the model unable to run.
   */
  function audit(d) {
    // A pass that only reads: the model's whole-model facts found once.
    return Sienna.Diagram.memo(function () {
      var out = [];
      ['nodes', 'submodels', 'arcs'].forEach(function (fam) {
        d.ids(fam).forEach(function (id) { out = out.concat(completeness(d, id).reasons); });
      });
      return out;
    });
  }

  Sienna.equationCheck = {
    element: element,
    completeness: completeness,
    audit: audit,
    calls: calls,
  };
}(window.Sienna));
