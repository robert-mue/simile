/**
 * `Sienna.equationGrammar` — the Simile expression language, as a PEG.
 *
 * This file is the ONLY statement of the grammar. Peggy compiles it on first
 * use (see `src/equation.js`), rather than it being generated ahead of time
 * into a checked-in parser, so there is no second artefact that can silently
 * fall out of step with this one. Compiling costs ~70 ms, paid once and not at
 * page load; parses after that are a fraction of a millisecond.
 *
 * Provenance — the language is not invented here:
 *
 *   - The precedence ladder and the `if/then/elseif/else` and local-variable
 *     forms come from `SimileProlog_SimileXMLv3_MathML.xsg` (R. Muetzelfeldt,
 *     2007), itself adapted from the Virtual Cell grammar. That file is the
 *     only complete statement of the language: simulistics.com documents the
 *     functions and the arithmetic operators, but never the conditional or the
 *     boolean layer.
 *   - `//` (integer division) and `%` (modulo) come from the operator table at
 *     simulistics.com/help/equations/components.htm; they are absent from the
 *     XSugar ladder.
 *   - Everything is checked against the 72 real models in
 *     `Simile reference/Simile_XSugar/Models_SimileProlog/`.
 *
 * Four deliberate departures from the XSugar grammar, all ruled 2026-08-06:
 *
 *   1. `+ - * / // %` are LEFT-associative. XSugar writes them right-recursive,
 *      which makes `a-b-c` mean `a-(b-c)`. That is simply a bug; `^` stays
 *      right-associative, which XSugar has right.
 *   2. Identifiers are strict — `[A-Za-z_][A-Za-z0-9_]*`, the same rule the
 *      diagram schema enforces for element names (§14). XSugar's `Name` admits
 *      spaces and hyphens, which cannot coexist with `-` as subtraction; it got
 *      away with it because it converted known-good files rather than
 *      diagnosing bad ones.
 *   3. Comma-as-`and` and semicolon-as-`or` (Prolog heritage, in XSugar's token
 *      definitions) are dropped: they collide head-on with argument separators
 *      and array literals.
 *   4. Function names are NOT enumerated here. An unknown function is a
 *      question for the schema's function table (name + arity), checked after
 *      the parse, so that "no such function" is a different report from "that
 *      is not an expression" — and so adding a function, or letting a user
 *      declare one, never touches this grammar.
 *
 * Two things the parser deliberately does NOT resolve, because it cannot:
 * `[weight]` is either the array variable `weight` or a one-element array built
 * from the scalar `weight`, and `{volume}` is likewise a list reference or a
 * one-element list. Only the model knows which. Both parse to a `list`/`array`
 * node and the caller decides, using the influences actually drawn — the same
 * split as everywhere else here: syntax fixed, notation knowledge outside.
 *
 * Whitespace around word operators is OPTIONAL, because real models contain
 * `rand_var(250,400)and n_crop_neighbour>1.9`. Each keyword is therefore
 * guarded with `!IdentRest` so that `order(…)` is not read as `or der(…)`.
 *
 * Classic script; no imports/exports. Load before `src/equation.js`.
 */
(function (Sienna) {
  'use strict';

  Sienna.equationGrammar = String.raw`
{{
  function leftAssoc(head, tail) {
    return tail.reduce(function (left, item) {
      return { t: 'binary', op: item[1], left: left, right: item[3] };
    }, head);
  }
}}

// An equation is one expression, optionally preceded by local definitions.
Equation
  = _ e:LetExpression _ { return e; }

// ( a = expr, b = expr, finalExpr ) — Simile's local intermediate variables.
// Root-level only, as in the reference grammar. Tried before a plain bracketed
// expression, and falls back to it when there is no binding to be found.
LetExpression
  = "(" _ bindings:Bindings _ "," _ body:Conditional _ ")"
    { return { t: 'let', bindings: bindings, body: body }; }
  / Conditional

Bindings
  = head:Binding tail:(_ "," _ Binding)*
    { return [head].concat(tail.map(function (x) { return x[3]; })); }

// "=" and not "==" — an assignment, not a comparison.
Binding
  = target:BindTarget _ "=" !"=" _ value:Conditional
    { return { target: target.name, form: target.form, value: value }; }

// A target may be quoted — models contain ('TA'=abs(z2), … ) — and quoting is
// how Simile writes a name it needs to set apart, not a string literal.
BindTarget
  = "[[" _ n:AnyName _ "]]" { return { name: n.name, form: 'array2' }; }
  / "[" _ n:AnyName _ "]"   { return { name: n.name, form: 'array' }; }
  / n:AnyName               { return { name: n.name, form: 'scalar' }; }

AnyName
  = n:QuotedName &{ return n.t === 'name'; } { return n; }
  / Identifier

// ---- the precedence ladder -------------------------------------------------

Conditional
  = IfKw _ c:OrExpr _ ThenKw _ v:OrExpr rest:ElseTail
    { return { t: 'if', clauses: [{ cond: c, value: v }].concat(rest.clauses), otherwise: rest.otherwise }; }
  / OrExpr

// An 'else' is optional: the reference grammar permits a conditional with none.
ElseTail
  = _ ElseIfKw _ c:OrExpr _ ThenKw _ v:OrExpr rest:ElseTail
    { return { clauses: [{ cond: c, value: v }].concat(rest.clauses), otherwise: rest.otherwise }; }
  / _ ElseKw _ v:OrExpr
    { return { clauses: [], otherwise: v }; }
  / ""
    { return { clauses: [], otherwise: null }; }

OrExpr
  = head:AndExpr tail:(_ OrOp _ AndExpr)* { return leftAssoc(head, tail); }

OrOp = OrKw / XorKw / "||" { return 'or'; }

AndExpr
  = head:Relational tail:(_ AndOp _ Relational)* { return leftAssoc(head, tail); }

AndOp = AndKw / "&&" { return 'and'; }

// One comparison, not a chain — as in the reference grammar.
Relational
  = left:Additive rest:(_ RelOp _ Additive)?
    { return rest ? { t: 'binary', op: rest[1], left: left, right: rest[3] } : left; }

// The quoted "'!='" is not a typo: that is how Simile stores inequality, and
// the XSugar token definition spells it the same way.
RelOp
  = "==" / "!=" / "'!='" { return '!='; } / "<=" / ">=" / "<" / ">" / IsKw

Additive
  = head:Multiplicative tail:(_ AddOp _ Multiplicative)* { return leftAssoc(head, tail); }

AddOp = "+" / "-"

Multiplicative
  = head:Power tail:(_ MulOp _ Power)* { return leftAssoc(head, tail); }

// "//" before "/", or integer division is read as division then a comment-less
// second division and the parse fails in a baffling place.
MulOp = "//" / "*" / "/" / "%"

// Right-associative: 2^3^2 is 2^(3^2).
Power
  = left:Unary rest:(_ "^" _ Power)?
    { return rest ? { t: 'binary', op: '^', left: left, right: rest[3] } : left; }

// Negation is a prefix operator, not a function: real models contain both
// "not found_divisor" with no brackets and "!(a and b)". It binds tighter than
// "and", so "not a and b" is "(not a) and b"; wrap in brackets for the other
// reading, which is what every model that means it actually does.
Unary
  = NotOp _ operand:Unary { return { t: 'not', operand: operand }; }
  / op:[+\-] _ operand:Unary { return { t: 'unary', op: op, operand: operand }; }
  / Primary

NotOp = NotKw / "!" !"="        // "!" must not swallow the "!" of "!="

// ---- primaries -------------------------------------------------------------

Primary
  = Call
  / "{" _ items:ExprList _ "}" { return { t: 'list', items: items }; }
  / "[" _ items:ExprList _ "]" { return { t: 'array', items: items }; }
  / QuotedName
  / Number
  / Identifier
  / "(" _ e:Conditional _ ")" { return e; }

// Before Identifier, so sum(x) is a call and not the name 'sum'.
Call
  = !(Keyword) name:$IdentifierText _ "(" _ args:ExprList? _ ")"
    { return { t: 'call', name: name, args: args || [], at: location().start.offset }; }

ExprList
  = head:Conditional tail:(_ "," _ Conditional)*
    { return [head].concat(tail.map(function (x) { return x[3]; })); }

Number
  = n:$([0-9]+ ("." [0-9]+)? ([eE] [+\-]? [0-9]+)?)
    { return { t: 'num', v: parseFloat(n), text: n }; }

// A quoted form is a NAME, not a string: XSugar maps 'x' to MathML <ci>, and
// models reference elements that way ('Change_coefficient' != 0). Only when the
// content is not a legal name is it a literal — which covers the two real uses,
// the empty argument of time('') and the boolean '"false"'.
QuotedName
  = "'" s:$[^']* "'"
    {
      return /^[A-Za-z_][A-Za-z0-9_]*$/.test(s)
        ? { t: 'name', name: s, quoted: true, at: location().start.offset }
        : { t: 'str', v: s, at: location().start.offset };
    }

Identifier
  = !(Keyword) name:$IdentifierText
    { return { t: 'name', name: name, at: location().start.offset }; }

IdentifierText = [A-Za-z_] [A-Za-z0-9_]*

// ---- keywords --------------------------------------------------------------
// Every one is boundary-guarded, so 'order', 'index' and 'notch' are names.

Keyword  = (IfKw / ThenKw / ElseIfKw / ElseKw / AndKw / OrKw / XorKw / NotKw / IsKw)
IfKw     = "if"     !IdentRest
ThenKw   = "then"   !IdentRest
ElseIfKw = "elseif" !IdentRest
ElseKw   = "else"   !IdentRest
AndKw    = "and"    !IdentRest { return 'and'; }
OrKw     = "or"     !IdentRest { return 'or'; }
XorKw    = "xor"    !IdentRest { return 'xor'; }
NotKw    = "not"    !IdentRest
IsKw     = "is"     !IdentRest { return 'is'; }
IdentRest = [A-Za-z0-9_]

_ = [ \t\r\n]*
`;
}(window.Sienna));
