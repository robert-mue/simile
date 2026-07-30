# Graph grammar: alternatives considered

**A note for review — simile diagram editor, 2026-07-30**

*Written for the Simile developer. This is the argued version of §12 of `DESIGN-diagram.md`: not
just what was decided, but what the alternatives were and why each was set aside. It is offered
for criticism — particularly where an assumption about how Simile actually behaves is wrong.*

---

## 0. What this is about, in one paragraph

We are building a **notation-neutral diagram editor**: node/arc/submodel diagrams in which the
vocabulary and rules are declared in a **schema** rather than hard-wired, so that one editor can
render Simile's notation today and another (SBML, say) tomorrow. The editor stores equations,
values and units per element but **never evaluates them** — the simulation engine is out of scope.
The question addressed here is the schema's second face: the **graph grammar** — which types may
connect to which, what may be contained where, and how many of what a container may hold.

Three terms used below, since they are ours rather than Simile's:

- **element** — any node, arc or submodel; everything has a stable id.
- **structural** rule — about connectivity or containment (what is joined to what, what sits inside what).
- **content** rule — about what is written *in* an element (equations, values, units, required properties).

---

## 1. How should rules be expressed?

### The options

**(a) Hard-wire the rules in code.** Simplest, fastest, and what most editors do. Rejected because
it defeats the project's central premise: if the grammar is JavaScript spread through the editor,
then supporting a second notation means editing the editor, and the claim of notation-neutrality is
empty. The schema must carry the rules or it is not a schema.

**(b) Pure declarative data — templates only.** Rules as records: endpoint tables, containment
tables, cardinality limits. Attractive because rules are then inspectable, enumerable, serialisable,
and writable by a modeller rather than a programmer. Rejected **as a complete answer** for the
obvious reason: there will always be a constraint the template vocabulary cannot express, and a
scheme with no escape hatch either grows templates forever or quietly forces rules back into code
(option (a) by the back door).

**(c) An embedded expression language, evaluated at runtime.** Rules carry constraint *text* which
the editor parses or `eval`s. This is the traditional answer and it is **rejected outright**. It
means shipping an interpreter, or `eval`, for no gain we cannot get more safely; it makes the file
format executable rather than declarative, which undermines the goal of a format other tools can
process; and it converts every rule into something that must be parsed and validated before it can
be trusted.

**(d) Declarative records, with named predicates as the escape hatch.** — **chosen.** The common
cases are data. A rule that cannot be expressed as data instead *names* a predicate implemented in
JavaScript and registered in a table which the developer extends as required:

```js
// the common case — pure data
{ id:"flow-ends", subject:"arc:flow", ends:["compartment","cloud"],
  message:"A flow must run between compartments or clouds." }

{ id:"one-condition", subject:"submodel", contains:{ condition:{ max:1 } },
  message:"A submodel may hold at most one condition." }

// the escape hatch — still a rule record, but delegating
{ id:"no-self-containment", subject:"submodel", predicate:"notAncestorOfSelf",
  message:"A submodel cannot contain itself." }
```

The predicate receives the whole model, so anything computable is reachable.

### Why a registry rather than one check function

Robert's original proposal was a single `check_action()` function with access to the full model,
extended case by case (by the developer, not the user) as new checks were discovered. That is the
right instinct — it puts the imperative escape hatch in code, where it belongs, and keeps users out
of it — but a single accumulating function has three drawbacks that a **registry of named
predicates** avoids:

1. **The ruleset stops being enumerable.** With rules as records one can ask "what rules apply to a
   flow?" That question has to be answerable, because the editor uses it to decide what may be
   offered in the palette at all (see §3). An if-chain inside one function cannot answer it.
2. **Error messages drift from rules.** Each rule record carries its own human-readable message, so
   the wording lives with the constraint rather than in a switch statement in the engine.
3. **The ruleset stops being exportable.** A stated aim is that other tools can process these
   models. A list of rule records can be published; a function body cannot.

The escape hatch is deliberately reachable only by a developer, not by a user, and rules may name a
predicate but **never carry a code string** — that would be option (c) reintroduced.

The honest open question is **what fraction of real rules need the escape hatch**. If it turns out
most do, the declarative layer is decoration and the design is wrong. This is the main reason for
asking about your checks (§5): the catalogue is the evidence.

---

## 2. When should rules be enforced?

### The options

**(a) Preventively — refuse the illegal gesture.** The user cannot draw the wrong thing. Best
feedback, and our reading is that Simile largely works this way for connectivity.

**(b) As a validation pass — permit anything, report afterwards.** Necessary if a model may be
imported, half-finished, or edited into a temporarily inconsistent state.

**(c) A split by rule class** — **chosen**, and we think this is what Simile already does rather
than a new invention.

### The argument

Presented as a binary, (a) and (b) trade real goods against each other: (a) gives better feedback
but makes some legitimate intermediate states unreachable and makes importing a partial model
awkward; (b) keeps editing free but lets meaningless structures accumulate.

The observation that dissolves it: **Simile does not treat all rules the same way.** It will not, as
we understand it, let you connect a flow to a variable — that is refused outright. But it *will*
let you create a compartment with no equation; the element is drawn in red until it is complete.
So connectivity is enforced preventively, while completeness is deferred and *reported*. Red/black
colouring is already a deferred-validation channel.

Adopting that as the principle:

| Class | Covers | Enforcement | Rationale |
|---|---|---|---|
| **Structural** | connectivity, containment, cardinality | **preventive** — refuse the gesture | prevents states with no meaning; must be cheap, as it runs during a drag |
| **Content** | equations, values, units, required properties | **deferred** — report, never block | half-finished work must stay editable; needed for importing partial or legacy models |

A practical consequence: **only the structural rules are needed now.** The content rules matter
when a model is handed to the execution engine, which is a long way off for us. That is why this
note settles machinery and not the rule catalogue.

**This is the argument most dependent on an assumption about Simile's behaviour**, and it is the
one we would most like corrected if wrong.

---

## 3. One engine, three questions

Worth stating because it constrains the design more than it first appears. The same rules get asked:

1. **"May I do this?"** — during a gesture: may this arc connect, may this element be dropped here.
2. **"What may I place here?"** — to filter the palette and highlight legal drop targets.
3. **"Is this model sound?"** — a whole-model pass.

If the engine can answer (1), then (2) is the same question asked speculatively of each candidate —
so greyed-out illegal palette entries cost no extra rules, *provided* rules can be enumerated by
subject. That requirement is what rules out the single-function design in §1, and it is cheap to
allow for now and awkward to retrofit later.

---

## 4. A wrinkle: rules quantify over inferred facts

In our object model, some properties of a submodel are **not stored but inferred** — a submodel is
*conditional* because it contains a condition symbol, and an *association* because role arcs point
into it. We prefer this to storing a flag, on the grounds that a flag would be redundant with the
facts that imply it, and could disagree with them.

The consequence for the grammar is that a rule such as *"population symbols only inside a population
submodel"* quantifies over a **derived** property. Two things follow:

- Rule evaluation must run against a form of the model in which those inferences have been computed.
- Inference is **non-monotonic in practice**: adding a condition symbol changes a submodel's inferred
  nature, which can make contents that were legal a moment ago illegal — an edit can invalidate
  elements it did not touch.

We think this is acceptable and inherent to inferring rather than storing. It does mean that, in
time, each rule should declare what it depends on so re-checking can be incremental. We have not
built that, and at realistic model sizes we do not expect to need it soon — though FLORES-scale
models (village ▸ household ▸ several submodels ▸ 900+ patches) are the case that would test it.

---

## 5. What we are deliberately not deciding, and what we would like from you

Not decided: the **catalogue** of actual rules; the final rule vocabulary (`ends`, `contains`,
`parentKind` above are illustrative); and whether rules live inside the schema file or as a
separable ruleset.

The questions where your answer would change what we build:

1. **What checks does Simile actually perform, and at what moment** — as the user draws, on closing
   a dialog, on saving, on export to the engine? A list, however rough, is the single most useful
   thing: it is the evidence for whether the declarative-plus-escape-hatch split in §1 has the
   balance right.
2. **Is the structural/content split in §2 a fair description of Simile's behaviour?** Specifically:
   is connectivity always refused outright, and is completeness always deferred to colouring — or
   are there structural things Simile permits and complains about later, or content things it
   refuses outright?
3. **Which checks are genuinely awkward to state as a rule?** The ones you would expect to write as
   code rather than as a table. Those are the test of the escape hatch.
4. **Are there rules that are not local** — that depend on the whole model rather than on an element
   and its neighbours? Cycles among influences, or anything of that character?
5. **Condition symbols:** at most one per submodel? Any placement constraints, and what may the
   expression refer to?
6. **Completeness:** the precise rule for when an element turns from red to black, per type.

The related question of **arc parentage** — whether an arc belongs to a submodel, and which one when
its ends are in different submodels — is being handled separately, but bears on this, since a
containment rule presupposes an answer to what an arc is contained *by*.
