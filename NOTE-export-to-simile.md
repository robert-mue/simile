# Running our models: exporting to Simile Prolog

**A note for the Simile developer — 2026-08-10**

*Context: we are building a notation-neutral, schema-driven diagram editor (see `DESIGN-diagram.md`)
as a static browser application. The editor is well advanced; what it cannot do is **run** anything.
SimiLive already runs an uploaded model and streams results to a browser, so the missing piece is a
converter from our model format into Simile's. This note sets out a proposed approach and the
questions we would like your view on. Nothing here is decided.*

---

## 1. The proposal

A **two-stage, stand-alone converter**, deliberately not AI-dependent:

1. **Our JSON → Prolog facts**, one-to-one, mechanical and lossless. Deliberately stupid: one fact
   per element, our names preserved, no interpretation.
2. **Prolog → Simile Prolog**, by rules.

The reason for the split is testability rather than tidiness. If stage one is obviously correct by
inspection, then every judgement lives in stage two as pure Prolog, which can be run against the 72
reference models offline — no browser, no editor, no AI in the loop. That is a real regression
harness rather than a hope.

Prolog is also simply the right tool for stage two. The hard part (below) is graph rewriting over a
containment tree, which is what it is good at, and the target syntax *is* Prolog, so emitting it is
free.

## 2. What is already settled

- **`.sml` is Simile Prolog in hex, and Simile will equally load raw Prolog.** So the converter's
  output is directly loadable with no encoding step. This removes the main risk from the plan.
- **`.smx` is an edit log**, not a snapshot — a list of `add(...)` / `remove(...)` operations. We
  noticed because our own editor records every change as an action and can replay a whole modelling
  session from that log. The parallel is close enough to be worth remarking on, and it raises a
  question we had not thought to ask (§5).

## 3. The representation gap

You will know all of this; it is here so the size of stage two is explicit, and because our
measurements may be new.

- **A drawn variable is two nodes.** In `chao.pl`, `level` is a `compartment` whose rate equation
  lives in a separate `function` node (`fn1`), which then **influences the flow arc**. Our model puts
  the rate on the valve, as one element. So the converter splits one of ours into a node pair and
  creates influences whose target is an arc rather than a node.
- **Influences must be re-split into segments — this is the crux.** We deliberately store a
  cross-boundary influence as ONE arc end to end, deriving the visual segments and ports (our §13);
  Simile stores the pieces, with submodel boundaries as endpoints. Measured on `lamos1a.pl`: **239
  influence arcs, of which only 72 join two user-named, non-`function` nodes.** The rest run to or
  from a submodel boundary or through one of the file's 100 `function` nodes. So export must
  *generate* roughly three times the arcs it starts with, by walking the containment tree. This is
  the single largest piece of work, and the best argument for doing it in Prolog.
- **Aliases map cleanly, which is the good news.** `role=[use(none,in_hierarchy,volume,1)]` is
  exactly the local name the consumer's equation uses — we already hold that per influence, copied at
  arc creation. Branching arcs carrying one `use(...)` per consumer match our shared-segment model
  directly.
- **Our field model is closer than expected**: `units` on compartments, variables and valves;
  `dimensions` on submodels, which is your `multiplication_spec=[count=[1600]]`. We do **not** hold
  `min_val`/`max_val`, `fill_colour`, or `spec` (the user's typed text stored as character codes
  alongside the parsed value).
- **Equations already parse.** We have a PEG for the Simile expression language, validated against
  **1500 equations harvested from the 72 reference models — 1488 parse**, the exclusions being
  comma-as-`and` and a few similar spellings we chose to drop. Function names and arities live in the
  schema as data (~110 entries).

## 4. The one thing we cannot resolve ourselves

**The dimensional term in a role: `1` versus `list(1)`, and `{volume}` versus `[volume]`.**

We had this on our list as a "nice to have" — it would sharpen the editor's completeness checking.
**For export it becomes load-bearing**, because we would have to emit it correctly. The specific
question: must a `{x}` reference always come from a variable-membership submodel and `[x]` from a
fixed one, or are there cases where that does not hold?

## 5. Questions

1. **The dimensional rule above** — the blocker.
2. **Is `.smx`, the add/remove edit log, a better export target than a `.pl` snapshot?** We produce
   exactly that shape natively. It may well be the wrong idea — a log presumably assumes a starting
   state and a schema version — but we would rather ask than guess.
3. **Is there an HTTP interface to SimiLive?** The page mentions "hidden forms to create a direct
   link to execute any model". If there is a documented endpoint that returns results data, we can
   host our own plotter and table widgets. Without one, the realistic first step is handing the model
   to SimiLive's own interface: that gets models *running*, but not results inside our application.
4. **The 25-equation limit** for non-Enterprise use — our reference models are well past it. What
   does testing at realistic size require?

## 6. Where the converter runs — and the C++ question

This is the architectural decision, and it is worth stating carefully because two separate things are
easily conflated.

Our editor is a **static** application: files opened from disk or served as static assets, no server,
works offline. The attraction of compiling the converter to **WASM** is that it keeps that property
while running the same stand-alone Prolog — SWI-Prolog has a WASM build, so stage two could run
in the browser with no install and no AI.

**But conversion is not simulation, and the pipeline has three stages, not one:**

| Stage | What it does | In the browser? |
|---|---|---|
| 1. Convert | our JSON → Simile Prolog | **Yes** — SWI-Prolog WASM, straightforward |
| 2. Generate | Simile engine produces C++ from the model | Depends entirely on what the generator is written in |
| 3. Build & run | compile that C++, execute it | **This is the hard one** |

Stage 3 is the real obstacle. Compiling C++ in a browser means shipping a compiler as WASM
(clang/LLVM builds exist, but they are tens of megabytes and slow to start) — technically possible,
practically unattractive.

So there are four honest options, and the choice is yours rather than ours:

**(a) Keep simulation server-side.** SimiLive already does this. Worth being clear that **a static
application calling an HTTP API is still a static application** — you keep zero-install hosting and
lose only *offline running*. Editing, and conversion, would still work with no network.

**(b) Give the code generator a JavaScript or WASM backend.** If the generator emits C++ from a model
by fairly mechanical means, an alternative backend emitting JavaScript would run natively in the
browser at respectable speed with no compiler needed. This is the option we find most interesting,
and the one we are least able to judge — it depends on how separable the generator's back end is.

**(c) A single interpreting kernel instead of per-model code generation.** One fixed WASM engine that
walks the model structure as data. Slower than compiled C++, but likely ample for typical models. A
substantial engine change, so probably only of interest if it serves other purposes too.

**(d) Hybrid, and probably the pragmatic first step**: conversion in the browser, simulation on the
server. Offline editing and export; network needed only to *run*.

**The question we would put to you: is the C++ generation itself Prolog?** If it is, option (b) is a
new back end for existing code rather than a new program, and the picture changes considerably.

## 7. Suggested order of work

**Build the importer first, or alongside.** It is the same mapping read backwards, and it buys two
things at once: the 72 reference models available in our format immediately, and **round-trip testing
(`.pl` → our JSON → `.pl`) as the correctness measure for the exporter**. Without it, the test loop
is "hand-build a model, export, upload, see whether it runs", which is slow and never demonstrates
fidelity.

We would hold off on results-display widgets until question 3 is answered, since the shape of the
data contract determines the widget design entirely.
