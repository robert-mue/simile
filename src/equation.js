/**
 * `Sienna.equation` — parse a Simile equation.
 *
 * The grammar itself is `Sienna.equationGrammar` (see `src/equation-grammar.js`
 * for what the language is and where it comes from). This compiles it with the
 * vendored Peggy and wraps the result in the two calls the editor wants.
 *
 * The editor NEVER evaluates an equation, so there is no evaluator here and no
 * error recovery: one error position is all an underline needs. What it wants
 * is exactly two things —
 *
 *   `parse(text)`       does this parse, and if not, where? — the red/black
 *                       completeness colouring (§19.1).
 *   `references(text)`  which model elements does it name? — so the names an
 *                       equation uses can be cross-checked against the
 *                       influence arrows actually drawn into that element.
 *
 * The second is the valuable one. It catches errors in both directions: a name
 * used with no arrow feeding it, and an arrow feeding a name the equation never
 * mentions. Note that a reference carries its FORM — `x`, `{x}` or `[x]` — so
 * the check can be sharper than "is there an arrow?": a `{x}` reference wants
 * an influence out of a variable-membership submodel, and its absence is a real
 * error rather than a stylistic one.
 *
 * What this does NOT do is decide whether `sum` is a function that exists, or
 * takes one argument. Function names live in the schema (name + arity), so that
 * adding one — or letting a user declare one — never touches the grammar, and
 * so that "no such function" reads as a different report from "that is not an
 * expression". Ruled 2026-08-06.
 *
 * Classic script; no imports/exports. Load after `vendor/peggy.min.js` and
 * `src/equation-grammar.js`.
 */
(function (Sienna) {
  'use strict';

  var parser = null;

  /**
   * Compile the grammar, once, on first use — which is the first equation
   * anyone parses, not page load, so opening the app costs nothing. Measured at
   * ~70 ms in Chrome, against ~0.3 ms for a parse afterwards. Worth it to avoid
   * a generated parser checked in beside the grammar, which is a second
   * artefact that can silently go stale.
   */
  function compiled() {
    if (parser) return parser;
    if (typeof peggy === 'undefined') throw new Error('Sienna.equation: peggy is not loaded');
    parser = peggy.generate(Sienna.equationGrammar);
    return parser;
  }

  // Parsing is pure, so the text is a sound cache key. This matters because the
  // red/black colouring is DERIVED at every render (§19.9) rather than stored,
  // which without a cache would re-parse every equation in the model on every
  // frame of a drag. Bounded rather than unbounded: a model has a few hundred
  // equations, but a rename box firing per keystroke would otherwise grow this
  // without limit.
  var CACHE_MAX = 500;
  var cache = Object.create(null);
  var cacheCount = 0;

  /**
   * @param {string} text
   * @returns {{ok: boolean, ast?: object, error?: {message: string, offset: number,
   *            line: number, column: number, found: string|null}}}
   */
  function parse(text) {
    if (text == null || String(text).trim() === '') {
      return { ok: false, error: { message: 'Empty equation', offset: 0, line: 1, column: 1, found: null } };
    }
    var key = String(text);
    if (cache[key]) return cache[key];
    var result = uncached(key);
    if (cacheCount >= CACHE_MAX) { cache = Object.create(null); cacheCount = 0; }
    cache[key] = result;
    cacheCount++;
    return result;
  }

  function uncached(text) {
    try {
      return { ok: true, ast: compiled().parse(String(text)) };
    } catch (e) {
      if (!e || !e.location) throw e;                 // not a syntax error: a bug here
      var start = e.location.start;
      return {
        ok: false,
        error: {
          message: e.message,
          offset: start.offset,
          line: start.line,
          column: start.column,
          found: e.found == null ? null : e.found,
        },
      };
    }
  }

  /**
   * Every model element the equation names, in source order.
   *
   * A bare name is a scalar reference. A `{…}` or `[…]` holding exactly ONE
   * bare name is a list or array reference to that element — and holding
   * anything else is a literal built out of whatever is inside it, whose parts
   * are themselves walked. That single-name test is the whole of the
   * disambiguation the parser cannot do (`[weight]` is either the array
   * variable `weight` or a one-element array made from the scalar `weight`);
   * resolving it properly needs the influences, so a caller that has them may
   * override this reading.
   *
   * Function names are not references — `sum` is not an element — and neither
   * are the local names bound by a `(a = …, expr)` form, which are internal to
   * the equation. Names bound locally are therefore SUBTRACTED from the result,
   * or the cross-check would demand an arrow for each of them.
   *
   * @param {string|object} input  equation text, or an AST from parse()
   * @returns {Array<{name: string, form: 'scalar'|'list'|'array', at: number}>}
   */
  function references(input) {
    var ast = input;
    if (typeof input === 'string') {
      var r = parse(input);
      if (!r.ok) return [];
      ast = r.ast;
    }
    if (!ast) return [];

    var out = [];
    var bound = {};

    function soleName(node) {
      if (!node || !node.items || node.items.length !== 1) return null;
      return node.items[0] && node.items[0].t === 'name' ? node.items[0] : null;
    }

    function walk(n) {
      if (!n || typeof n !== 'object') return;
      switch (n.t) {
        case 'name':
          out.push({ name: n.name, form: 'scalar', at: n.at });
          return;
        case 'list':
        case 'array': {
          var only = soleName(n);
          if (only) {
            out.push({ name: only.name, form: n.t === 'list' ? 'list' : 'array', at: only.at });
            return;
          }
          n.items.forEach(walk);
          return;
        }
        case 'call':
          n.args.forEach(walk);       // the function's NAME is not a reference
          return;
        case 'binary':
          walk(n.left); walk(n.right);
          return;
        case 'unary':
        case 'not':
          walk(n.operand);
          return;
        case 'if':
          n.clauses.forEach(function (c) { walk(c.cond); walk(c.value); });
          walk(n.otherwise);
          return;
        case 'let':
          n.bindings.forEach(function (b) { bound[b.target] = true; walk(b.value); });
          walk(n.body);
          return;
        default:                      // num, str: nothing to collect
          return;
      }
    }

    walk(ast);
    return out.filter(function (ref) { return !bound[ref.name]; });
  }

  Sienna.equation = { parse: parse, references: references };
}(window.Sienna));
