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
  function expressionFields(d, id) {
    var el = d.get(id);
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
      d.namesSuppliedBy(a).forEach(function (name) {
        out.push({ name: name, arc: a });
      });
    });
    return out;
  }

  /**
   * Check one element's equations.
   * @returns {Array<{id, label, kind, field, message, at?}>}
   */
  function element(d, id) {
    var el = d.get(id);
    if (!el) return [];
    var fields = expressionFields(d, id);
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

        calls(parsed.ast).forEach(function (c) {
          if (!Object.prototype.hasOwnProperty.call(table, c.name)) {
            out.push({
              id: id, label: label, kind: 'function', field: f.name, at: part.at + c.at,
              message: f.label + ': no such function "' + c.name + '"',
            });
          } else if (!arityOk(table[c.name], c.count)) {
            out.push({
              id: id, label: label, kind: 'function', field: f.name, at: part.at + c.at,
              message: f.label + ': ' + c.name + '() takes ' + arityText(table[c.name]) +
                       ', not ' + c.count,
            });
          }
        });

        Sienna.equation.references(parsed.ast).forEach(function (ref) {
          usedNames[ref.name] = true;
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

    Object.keys(usedNames).forEach(function (name) {
      if (!suppliedSet[name]) {
        out.push({
          id: id, label: label, kind: 'undeclared', name: name,
          message: '"' + name + '" is used but no influence supplies it',
        });
      }
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
      if (usedNames[s.name]) e.used = true;
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
   * @returns {{complete: boolean, reasons: Array}}
   */
  function completeness(d, id) {
    var el = d.get(id);
    if (!el) return { complete: true, reasons: [] };

    var reasons = [];
    var props = el.props || {};
    expressionFields(d, id).forEach(function (f) {
      if (!isRequired(el, f)) return;
      var text = props[f.name];
      if (text == null || String(text).trim() === '') {
        reasons.push({
          id: id, label: el.label || id, kind: 'missing', field: f.name,
          message: f.label + ' is not set',
        });
      }
    });

    var all = reasons.concat(element(d, id));
    return { complete: !all.length, reasons: all };
  }

  /** A field is required outright, or required given another field's value. */
  function isRequired(el, f) {
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
    var out = [];
    ['nodes', 'submodels'].forEach(function (fam) {
      d.ids(fam).forEach(function (id) { out = out.concat(completeness(d, id).reasons); });
    });
    return out;
  }

  Sienna.equationCheck = {
    element: element,
    completeness: completeness,
    audit: audit,
    calls: calls,
  };
}(window.Sienna));
