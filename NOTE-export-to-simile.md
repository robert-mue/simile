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
5. **Which Prolog dialect is the generator written in, and how separable is its C++ back end?** See
   §6 — this now decides the whole deployment shape.

## 6. Where it runs — and what changes now the generator is Prolog

This is the architectural decision, and one answer has already reshaped it: **the C++ generation is
done by Prolog.** That matters more than it may appear, so the reasoning is set out in full.

Our editor is a **static** application: opened from disk or served as static files, no server, works
offline. The attraction of **WASM** is that it preserves that while running a genuine stand-alone
Prolog — SWI-Prolog has a WASM build.

The pipeline has three stages, and it is worth separating them because "run it in the browser" means
something different at each:

| Stage | What it does | Written in | In the browser? |
|---|---|---|---|
| 1. Convert | our JSON → Simile Prolog | new code, ours | **Yes** — SWI-Prolog WASM |
| 2. Generate | model → simulation code | **Prolog (yours)** | **Yes, in principle — same process** |
| 3. Build & run | compile and execute that code | C++ toolchain | **The obstacle** |

Stage 3 was the sticking point: compiling C++ in a browser means shipping clang/LLVM as WASM — tens
of megabytes, slow to start, unattractive. WASM removes the *install*, not the *compiler*.

**But if stage 2 is Prolog, stages 1 and 2 collapse into one process.** Our converter's output would
feed your generator inside the *same* SWI-Prolog instance — no file handoff, no second tool. And the
interesting consequence follows: what stage 2 emits is a *choice*. **A back end emitting JavaScript
instead of C++ would need no compiler at all** — the browser runs it directly. That turns the whole
pipeline into one WASM Prolog instance producing runnable code, with no server anywhere.

So the options, re-ordered now that we know:

**(a) A JavaScript back end for the existing generator — now the most promising.** It is a new back
end for existing Prolog code rather than a new program. Two things determine whether it is realistic,
and both are questions for you:

  - **How separable is the back end?** If emitting C++ is a distinct layer over an internal
    representation, adding a second emitter is modest. If C++ assumptions are spread through the
    generator, much less so.
  - **How big is the runtime the generated code links against?** This is the part we suspect is the
    real work. The emitted code presumably calls a library — integration methods, array and
    aggregation operations, random-number functions, the submodel instance machinery. *That library
    would have to be re-implemented in JavaScript*, and its size, not the code emission, sets the
    cost. Could you say roughly how large it is, and how much of it a typical model touches?

**(b) Keep simulation server-side** — SimiLive already does this. Worth stating plainly: **a static
application calling an HTTP API is still a static application.** You keep zero-install hosting and
lose only *offline running*; editing and conversion still work with no network.

**(c) A single interpreting kernel** instead of per-model code generation — one fixed engine walking
the model as data. Slower, likely ample for typical models, but a substantial engine change.

**(d) Hybrid**: conversion in the browser, simulation on the server. The pragmatic first step, and
compatible with (a) arriving later.

### The pivotal unknown: which Prolog?

Everything above assumes your Prolog can become **SWI-Prolog**, since that is what has a maintained
WASM build. The saved models identify the program as `AME`, and we do not know what dialect the
generator is written in. If it is close to SWI, this is straightforward; if it depends on a
particular vendor's modules, foreign-language interface or string handling, porting is the dominant
cost and options (b)/(d) look better.

**A cheap experiment would settle it**, and would be worth doing before committing to anything: try
loading the generator into SWI-Prolog and see how far it gets. Dialect distance is usually obvious
within an hour, and it decides which of (a)–(d) is actually available.

## 7. Suggested order of work

**Build the importer first, or alongside.** It is the same mapping read backwards, and it buys two
things at once: the 72 reference models available in our format immediately, and **round-trip testing
(`.pl` → our JSON → `.pl`) as the correctness measure for the exporter**. Without it, the test loop
is "hand-build a model, export, upload, see whether it runs", which is slow and never demonstrates
fidelity.

We would hold off on results-display widgets until question 3 is answered, since the shape of the
data contract determines the widget design entirely.
