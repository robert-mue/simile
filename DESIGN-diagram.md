# Diagram Library — Design Summary (restart / discussion draft)

*Status: design in progress, no code yet. Draft for review — including a meeting with the Simile developer, 2026-07-28. Sections marked **[ASK]** are questions to put to him.*

This is the design of a **diagramming library** and, on top of it, a **sienna diagram-editor widget**. The long-term aim is to replace the diagram editor of **Simile** (simulistics.com) with something notation-neutral and schema-driven. It sits inside sienna (static jQuery SPA, runs from `file://`, no build/server — see `CLAUDE.md`).

---

## 1. Scope

- We are building the **diagram editor only**.
  - The **simulation engine already exists** (Prolog → C++) — out of scope; how we feed it a model is a substantial *later* question.
  - **Results-display widgets** exist only as Tcl/Tk desktop today; to become sienna widgets eventually — not a current constraint.
- The editor **stores** per-element equations, values, units and properties but **never evaluates** them.

## 2. The core idea

A node-and-arc diagram in which the **vocabulary and rules are declared in a schema, not hard-wired in code**. One library can render Simile today and other notations (e.g. SBML) tomorrow by swapping the schema — this was proven before in the user's earlier tool **Systo** (a `.js` schema switched System Dynamics ↔ SBML).

Three first-class object **families**:

- **node** — schema-typed (compartment, variable, cloud, condition, population symbols, …)
- **arc** — schema-typed (flow, influence, role, …)
- **submodel** — *one* object, NOT schema-typed; its *kind* is a property or is inferred from use

A submodel is **not** a kind of node (some libraries model containers that way; we reject that here).

## 3. The schema — four faces

1. **Vocabulary** — the node/arc types this notation has (and the submodel's allowed kinds).
2. **Grammar** — a graph grammar: which types may connect to which, and what may be contained where (e.g. a flow's ends must be compartment or cloud; population symbols only inside a population submodel). *Open: rule language + preventive-vs-validation enforcement.*
3. **Property / dialog spec** — the fields each type exposes in its settings dialog (equations/values/units/props). A mandatory **field model** (the data — source of truth) separated from an optional **presentation** (per-type HTML template; auto-generated form as fallback).
4. **Styling** — glyphs, colours, line/fill/font (see §6).

Delivered as a **`.js` file registering on `window.Sienna`**, not fetched JSON — because `file://` blocks `fetch` (same reason widgets load by `<script>` injection). Bonus: dialog HTML templates can be JS template strings.

## 4. Object model (the current strawman)

The model lives in sienna `userData` at a path like `models/landuse`. It is **flat, id-keyed maps** (not a nested tree) — a submodel's contents are found by scanning for `parent === <submodel-id>`. This suits sienna's path-addressed store: granular watch / undo / replay, and moving an element between submodels is a single field write.

```js
// userData path: models/landuse
{
  id: "landuse", name: "Land-use change", schema: "simile-v1", enums: {},

  // --- LOGICAL model (three maps, one per family) = the shared truth, the format seed ---
  submodels: {
    submodel1: { kind:"fixed-membership", parent:null,       label:"PATCH",  props:{ dimensions:"400" } },
    submodel2: { kind:"single",           parent:"submodel1", label:"FOREST", props:{} },
    submodel3: { kind:"single",           parent:"submodel1", label:"CROP",   props:{} },
    submodel4: { kind:"single",           parent:null,       label:"NEXT TO", props:{} }
  },
  nodes: {
    node1: { type:"compartment", parent:"submodel1", label:"state",  props:{ initial:"…" } },
    node2: { type:"cloud",       parent:"submodel1", label:"",       props:{} },  // label optional
    node3: { type:"condition",   parent:"submodel2", label:"is_forest",    props:{ expr:"state = 1" } },
    node4: { type:"condition",   parent:"submodel3", label:"is_crop",      props:{ expr:"state = 2" } },
    node5: { type:"valve",       parent:"submodel1", label:"change_state", props:{ rate:"…" } }   // auto-created with arc1
  },
  arcs: {
    arc1: { type:"flow",      from:"node2",     to:"node1",     valve:"node5", props:{} },   // no label — the valve carries it
    arc2: { type:"influence", from:"node1",     to:"node5",     alias:"state", props:{} },   // targets the valve, not the arc
    arc3: { type:"role",      from:"submodel1", to:"submodel4", label:"role1", props:{} },
    arc4: { type:"role",      from:"submodel1", to:"submodel4", label:"role2", props:{} }
  },

  // --- LAYOUT (presentation-geometry, editor-only, per-instance) ---
  layout: {   // one map; ids are globally unique thanks to the family prefix
    submodel1:{x:180,y:40,w:560,h:300}, submodel2:{x:430,y:60,w:270,h:110,collapsed:false},
    node1:{x:300,y:200,w:44,h:36}, node2:{x:250,y:250}, arc1:{waypoints:[]}
  }
}
```

Key points:

- **Three logical maps** (`nodes` / `arcs` / `submodels`) rather than one — chosen for familiarity (almost every graph library splits node/arc). The map *is* the family, so no `family` field is needed.
- **Ids** are numerically incremented, prefixed by family: `node1`, `arc1`, `submodel1`. The prefix also names which map to look in.
- **Arcs** carry `from`/`to` as element-id strings, and **no `parent`** — a cross-boundary arc is *one* arc, drawn as several segments (§13). Arcs never terminate on arcs: an influence into a flow targets the flow's **valve** (`arc2 → node5`). Only **role** arcs carry a `label`; flow and influence arcs do not (§14).
- **Valves** are real, auto-created node elements, one per flow, holding the flow's label/name and its rate equation. They are the System Dynamics instance of a general **attachment node** — the node a notation creates so that things can be hung off an arc; in other notations (e.g. webakt causal links) the same node has no glyph. Visible-or-not is a **style** fact (§6), not a model fact.
- **Submodel `kind`** = membership only (`single` / `fixed-membership` / `population`). *Conditional* and *association* are **inferred**, not stored: a submodel is conditional if it contains a condition node; it is an association if role arcs point into it. (Per-record and special-grid kinds deferred.)
- **Clouds** are real, auto-created node elements (created at a flow's blank end). Traditionally unnamed (a stock whose value we don't care about) but **optionally nameable** — e.g. "atmosphere"/"ocean" in a hydrological model. A cloud may carry **several** in/outflows, so it is deleted only when the flow being deleted was its **last** connection — unlike a valve, which is one-to-one with its flow and dies with it.
- **Completeness** (Simile's red-until-defined, black-when-complete) is **derived** from whether props are filled, not stored.
- **Enumerated types** live at model level.
- **Equations are stored verbatim, never resolved** by the editor.

## 5. Settled decisions (rulings, 2026-07-27)

1. Logical/layout split — **yes**.
2. Three maps `nodes`/`arcs`/`submodels` — **yes** (over a single `elements` map).
3. Conditional/association — **inferred, no explicit flag**.
4. Arc parentage + cross-boundary arcs — ~~deferred~~ **largely resolved 2026-07-30, see §13** (rulings 7–9 below); fan-in and port placement remain open.
5. Clouds as real auto-created nodes, **optionally named** — **yes**.
6. Ids — **sequential, family-prefixed** (`node1`/`arc1`/`submodel1`).

*Rulings added 2026-07-30 (see §13, §14):*

7. A cross-boundary connection is **one arc** in the model, **several segments** in the drawing — the visual split is kept. **Yes.**
8. Segments are **shared**, not per-arc: all arcs leaving `a` share `a`'s exit through each boundary. **Yes.**
9. Arc `parent` — **not stored**; derivable as the nearest common ancestor of the endpoints. **Confirmed 2026-07-30.**
10. **Valve = a real node**, not a property of the flow arc; influences into a flow land on it. **Yes.**
11. Cloud deletion is **refcounted** (last connection only); valve deletion follows its flow. **Yes.**
12. Vocabulary: **ID / label / name**, with "identifier" dropped, and **label ≡ name** enforced typographically. **Yes** (§14).
13. An influence carries a **local name (alias)** for the value it imports; equations never use path-qualified names. **Yes** (§14).

## 6. Three orthogonal concerns: model / layout / style

A marker we are planting now but only partly building:

| Concern | Holds | Key | Sharing |
|---|---|---|---|
| **Model** (logical) | types, connectivity, equations | element id | the shared truth |
| **Layout** | position, size, waypoints, collapsed | element id — **per-instance** | a model may have several *named layouts*; users may prefer different ones |
| **Style** | glyph, colour, line, fill, font | mostly **type**; id for rare overrides | a model may have several *named styles*; users may prefer different ones |

The distinguishing axis (why this isn't over-engineering): **layout is per-instance, style is mostly per-type**, so style is small — a **cascade**, not a big table:

```
schema default (the notation defines its glyphs)
  → document/user style override ("compartments blue in this diagram")
    → per-element override (rare: this one node is red)
```

Simile's red/black completeness colouring is a **computed** style layer on top of that cascade.

**Costs nothing now** — we just keep the three unfused: never a colour in `layout`, never an `x` in the model. Whether they end up as sibling subtrees / separate userData paths / separate files (so two users can swap styles over one shared model) is deferred alongside #4. One resolved ripple: whether `layout` carries `w/h` is governed by the type's **style** — a compartment is a resizable box (has `w/h`); a cloud or variable is a fixed glyph (`x/y` only).

## 7. Open threads

1. **#4 — Arc parentage & cross-boundary arcs.** **LARGELY RESOLVED 2026-07-30 → see §13.** One arc, many shared segments; arc `parent` not stored. Still open within it: **fan-in symmetry** (is a target-side segment shared by target, as source-side segments are shared by source?) and whether **ports are user-dragged or auto-placed**.
2. ~~**Build vs. buy.**~~ **RESOLVED 2026-07-30 → build. See §11.** (Was: from-scratch SVG vs. vendoring an engine such as JointJS. Note the original phrasing of this thread said "SVG + jQuery-UI draggable"; the jQuery-UI part is withdrawn — see §11.1.)
3. **Grammar rule language.** **PARTLY RESOLVED 2026-07-30 → see §12**: the rule *shape*, the escape hatch and the enforcement split are decided; the rule **catalogue** stays open pending a list of specific checks from the Simile developer (requested).
4. **Persistence shape** for model/layout/style (see §6) — deferred with #4.

## 8. Questions for the Simile developer **[ASK]**

- ~~**#4:** How does Simile decide which submodel an arc "belongs to"?~~ **ANSWERED 2026-07-30** (§13): Simile splits a cross-boundary arc into three arcs both on the diagram *and* in the model declarations — but stores no arc-parent fact, each split arc's parentage being recoverable from its endpoints. We keep the visual split, reject the model split, and likewise do not store arc parentage. Remaining sub-question: **fan-in** — does Simile share the target-side segment across several incoming arcs, as it shares the source-side one? **[ASK]**
- **Association inference:** In the saved model, is a submodel's *association* nature truly implicit (recoverable only from its role arcs), or is there an explicit marker? Same question for *conditional* (the contained condition symbol) — stored flag or inferred?
- **Storage separation:** Does the `.sml` (Prolog) format separate logical structure from diagram layout at all? Any notion of style separate from layout?
- **Ghosts:** How is a ghost (a second on-diagram appearance of a node) stored — and confirm only nodes are ghostable, never arcs/submodels?
- **Condition symbol:** At most one per submodel? Any placement constraints? What exactly may its expression reference? *(Partly answered 2026-07-30: condition nodes do carry a label, indicating what the condition is based on.)*
- **Label typography:** the full rule set for legal variable names — spaces are excluded (confirmed 2026-07-30); what else? And is name-uniqueness scoped to the containing submodel?
- **Completeness (red/black):** The precise rule for when an element flips from red (incomplete) to black — per element type.
- **Vocabulary drift:** Are `event` / `state` / `squirt` / `satellite` / per-record & special-grid submodels genuinely later additions to the canonical set (compartment, variable, submodel, flow, influence, role, condition, initialiser, migrator, reproducer, exterminator)? Anything else we've missed?
- **Anything about the model that is hard to express as flat id-keyed maps + parent pointers** — deep nesting (FLORES: Village▸Household▸5 submodels, 900+ patches), associations between deeply-nested submodels, array access (`element()`/`index()`).

## 9. Test cases

- **Land-use change** (reference; §4) — PATCH fixed-membership + FOREST/CROP conditional + NEXT TO **self-association** (both roles from the same submodel).
- **Farmers & fields** (Muetzelfeldt 2010, CCAFS) — VILLAGE contains FARMER (population: initialiser/migrator/exterminator), FIELD (fixed-membership), OWNERSHIP (**two-party association**, roles "owns"/"owned" from two *different* submodels of *different* kinds). Complements land-use: covers the second association topology plus population-only nodes. Confirmed the strawman needs nothing new for it.

## 10. Representation — flat vs tree, and file vs in-memory

*Decided 2026-07-29 (after review with a colleague). This settles the object-model representation question left open in §4/§7.*

### 10.1 Flat (parent pointers) vs tree (containment hierarchy)

The question: store hierarchy as flat id-keyed records each carrying a `parent` id (the strawman, and what Simile does), or as a **tree** where submodels physically contain their children so containment is structural, not a computed query.

**What a real tree buys you:**
1. **Containment invariants for free.** In a tree an element is in exactly one place → you cannot represent an orphan (parent id → nothing), a cycle (A in B in A), or a dangling parent. In the flat model `parent` is a foreign key you must *validate*; all three bad states are expressible.
2. **Traversal/scoping = natural recursion** (bounding boxes, collapse/expand, z-order, containment hit-testing). Flat does the same by filtering on `parent` or via an index.
3. **Extraction looks trivial** — a submodel *is* its subtree, so "save as module" = serialise that node.
4. **Namespacing on insert** — ids can be relative within a subtree, so pasting a module re-keys only the root.

**The catch — a diagram is a graph *over* a containment tree, not a tree.** Containment nests cleanly; **connectivity does not.** Arcs' `from`/`to` frequently span different submodels; a **ghost** is a second appearance of a node living elsewhere; cross-boundary influences reach across nesting. None respect the tree → even a "tree" stores arcs/ghosts as id references, i.e. a hybrid: tree for containment + flat id-refs for the graph. The tree only ever modelled *half* the diagram — and that other half is exactly **#4** (which submodel owns a cross-boundary arc?), which a tree relocates to "where in the tree does a boundary-crossing arc sit?" (arguably harder), not dissolves.

**Why flat fits *this* substrate especially well:**
- **Stable id = stable address.** userData is path-addressed; undo/replay/pub-sub key on paths. Flat gives every element a short *stable* address (`…/nodes/node1/props/rate`) that survives **re-parenting** (move a node → its `parent` field changes, its identity/address don't: one write, one undo entry, one event). In a tree the address *is* the path from root, so re-parenting **moves the address** — identity and structural position are fused, awkward for path-keyed undo/replay.
- **One join key** across model/layout/style (§6) — a single global id space. A logical tree + flat layout/style would be an impedance mismatch.

**On modularity/extraction specifically** (the colleague's headline concern): what makes a submodel a reusable *module* is not that its contents are physically nested — it's a **well-defined boundary** (contents + interface). The interface is the set of references crossing the boundary (arcs with one end outside, in/out influences, ghosts) — which *neither* representation gives for free, and which a tree can *hide* (they live "elsewhere" in the tree). Flat `extractSubmodel(id)` walks parent pointers to gather the closure (O(n), trivial) and, in the same pass, classifies each arc as **internal** (travels with the module) vs **boundary-crossing** (defines the module's ports) — forcing the interface to be enumerated. The tree cheapens only the trivial half (containment) and still leaves the boundary hunt. **Existence proof:** Simile already extracts submodels from a flat parent-pointer model, so the capability isn't in question — only ergonomics.

**Decision:** **flat maps are the source of truth**; the tree is recovered as a **derived child-index** (`parent → [child ids]`, cached, invalidated on structural change) giving O(1) child lookup + easy recursion for rendering/extraction — the tree's ergonomics without its storage costs. The one thing not free from the index is relative namespacing on insert (flat global ids must be re-minted + references remapped on paste) — a once-per-insert mechanical op, not a per-edit cost.

### 10.2 The file/in-memory distinction (the key that resolves it)

The flat-vs-tree tension largely dissolves once we separate **the serialised external file** from **the in-memory runtime form**. Three layers:

- **Canonical core** — the DRY set of *independent* facts, present in both forms and the only thing that is authoritative. This is the flat maps: `parent` pointers, arc `from`/`to`, `props`, user-set geometry, enums.
- **File-only concerns** — canonical **ordering** (sort keys for stable, git-friendly diffs; memory uses unordered hash maps) and format/versioning. Ids (not pointers) are the only cross-references — a pointer can't be serialised; the loader resolves id→object once.
- **Memory-only derived structures** — everything computable from the core, kept for fast **bidirectional** lookup and never serialised: the **child-index** (down: parent→children; the core stores only up: child→parent), a **reverse arc index** (node→incident arcs; the core stores only arc→endpoints), a **ghost/appearance index** (node↔its appearances), cached **completeness** (red/black), and auto-computed geometry (auto-routed waypoints, bounding boxes).

**The DRY inclusion rule for the file:** store a fact **iff it is independent** (not derivable from other stored facts). Applying it — and note it *justifies* several earlier decisions rather than adding new ones:
- `parent` → **in file** (independent: you choose containment). Child lists → **memory only** (derivable → storing them violates DRY, can go stale).
- Submodel *conditional*/*association* kind → **NOT stored** (inferred from a contained condition node / role arcs — decision #3). DRY *explains why* #3 is right: an association flag would be redundant with the role arcs.
- Completeness (red/black) → **NOT stored** (derived from `props`).
- Layout: **user-set** geometry (independent input) → **in file**; **auto-computed** geometry (routing, bboxes) → **memory only**. (Refines §6 — layout is itself split into independent vs derived.)

**Architectural placement in sienna maps onto this split cleanly:** **`userData` = the DRY canonical core = what gets serialised** (it autosaves to localStorage / exports to file). The derived indices must **NOT** live in `userData` (or they'd be persisted and could drift, and would pollute undo/replay); they live in the **diagram widget's runtime**, rebuilt from `userData` via `subscribe`/`_watchModel`. So: mutate only the core (through the userData API); indices are updated by the same code or rebuilt from events → they cannot drift, and `userData` stays DRY.

**External-tools trade-off** (a stated project goal — make it easy for others to process models): strict-DRY files give consumers minimal, canonical, unambiguous data but push derivation onto each consumer. Preferred stance: **DRY file + a reference loader** that builds the convenient indices — ship the denormalisation as *code*, not as file bloat (a redundant file must be trusted/validated and makes diffs noisy). If any convenience redundancy is ever added to the file, mark it explicitly as derived/non-authoritative and regenerate it on write.

**Net:** the "flat store as truth + derived tree/index view" recommendation of 10.1 *is* the file/in-memory split of 10.2 — DRY parent-pointers persisted, fast child/reverse indices held only in memory and rebuilt on load. Adopt both together.

## 11. Build vs buy — **decided: build**

*Decided 2026-07-30, after checking JointJS's current free/commercial split. This closes open thread §7.2. Recorded in this much detail so the decision is auditable and does not get re-litigated later; the facts it rests on are dated and checkable.*

### 11.1 Two assumptions checked (and corrected)

Both unknowns that were blocking the decision resolved **in JointJS's favour** — the case for build does not rest on them:

- **Containment/nesting is in the free core**, not the paid tier. `element.embed(child)`, a `parent` property plus an `embeds` child-list, `embeddingMode` on the paper, and translation cascading from parent to children. There are container-layout demos. "Might be impractical" is off the table.
- **Styling-by-type exists too**, via `dia.Element` subclasses carrying markup + `attrs` on the prototype `defaults`, and via CSS classes on the SVG. What is *not* provided is our §6 three-level cascade (schema default → document → per-element); that would be ours to build either way.

Two claims made earlier **against** buying are also withdrawn as wrong:

- **`file://` does not block vendoring.** A library would go in `sienna/vendor` like the existing vendored ones. (It *does* rule out loading from an external URL at runtime — that breaks offline use, which matters for field/teaching use — but local vendoring was never obstructed.)
- **"jQuery-UI draggable"** was never the plan and is withdrawn as a straw man; see 11.3, dragging is easy but not via that plugin.

### 11.2 Why build anyway — the two reasons that decide it

**1. The free tier is a renderer, not an editor.** Everything that constitutes a diagram *editor* sits behind the commercial JointJS+ licence: undo/redo (CommandManager), Stencil (element palette), Inspector (property editor), Selection & Halo, Toolbar, Clipboard, keyboard shortcuts, zoom & scroll (PaperScroller), Minimap, inline text editing, validation, image/SVG export, print. The free core gives shapes, links, routers/connectors/anchors, element & link tools, events, highlighters, embedding, geometry/Vectorizer, JSON import/export, dagre integration.

That matters *here* specifically because **sienna already provides that paid layer** — panels, menu, action log, undo/redo, session replay. So the offer on the table is not "buy the hard parts cheaply"; it is "take a renderer, then either buy an editor layer we already have, or duplicate it against sienna's". Much weaker than it first appears.

**2. It conflicts with who owns the truth.** JointJS's `dia.Graph` wants to *be* the model — geometry and connectivity in Backbone models. §10.2 rules that **`userData` is the DRY canonical core**, with undo/replay/pub-sub keyed on paths. Reconciling those means either two stores under bidirectional sync (drift, doubled undo), or demoting JointJS to a pure view rendered from `userData` — at which point we use perhaps a third of it and fight the rest. This is the real fit crunch; containment never was.

**Supporting (weaker, but aligned):**

- **No build step.** JointJS v4 is ESM-first; we would pin a UMD bundle and be unable to upgrade without introducing a build chain — a poor bet for a tool intended to outlive its current author's involvement.
- **Contributor entry cost.** A stated project goal is that others can pick this up. One fewer library to internalise, and no bottom of the dependency we cannot see. (Licence is *not* an obstacle — JointJS core is MPL-2.0, compatible with an open-source project.)
- **Owning the whole stack** is also a stated preference and a source of enjoyment. Named as a preference, not dressed as engineering — but for this project it is legitimate weight, and the goal being serious academic use *reinforces* rather than undercuts the choice: a small owned SVG layer with no build step is more durable over a decade than a vendored library we cannot upgrade.

### 11.3 What build actually costs

**Straightforward — do not over-plan these:**

- **Dragging.** Hand-rolled SVG dragging is ~60–80 lines: `pointerdown`/`pointermove`/`pointerup` (prefer pointer events + `setPointerCapture` over mouse+touch branches — touch and pen come free, and the drag survives the cursor outrunning the element), `getScreenCTM()` to map screen pixels into user space, write a transform. Use the full inverse (`createSVGPoint` + `matrixTransform(getScreenCTM().inverse())`) rather than the `(clientX - CTM.e) / CTM.a` shortcut, so it stays correct once pan/zoom exists. *Prior art: the author has already built an SVG graph editor with dragging.*
- **Hit-testing thin curved arcs.** Render an invisible fat-stroke twin of each arc path as the pointer target. Solved cheaply.
- **Orthogonal / obstacle-avoiding routing.** Genuinely hard — and **declined**. Simile uses straight/curved arcs with a bend point, and §4 already stores explicit `waypoints`. Avoid the hard problem by notation choice.

**The actual work — what a "drag" *means* in this editor:**

1. **Dragging a submodel must move its contents.** With flat world coordinates (11.4) this means explicitly translating every descendant — walk the derived child-index, which is where §10's index earns its keep.
2. **Drop-target detection for re-parenting.** Dragging a node into a submodel is a *logical-model* edit (`parent` changes) triggered by a gesture. Needs hit-testing against submodel rects, a rule for ambiguity when submodels nest/overlap (innermost wins?), and a decision on whether the grammar may **refuse** a drop mid-drag — which ties directly into the preventive-vs-validation question of §7.3.
3. **One undo entry per drag, not per `pointermove`.** Otherwise sienna's action log records hundreds of writes. Live geometry during the drag; a single committed write on `pointerup`.
4. **Arc-to-arc attachment.** §4 requires an influence to target an arc (`arc2 → arc1`, as Simile does). Keeping the endpoint glued to a moving arc needs point-on-path projection. This is the one item on this list the free JointJS core would have given us; budget for it.

Note that items 1 and 2 are exactly the places a library would have imposed its own opinions — further reason the choice is close to cost-neutral rather than a sacrifice.

### 11.4 Foundational calls to make before drawing anything

- **One flat world coordinate space**, with a single pan/zoom transform on a root `<g>` — *not* nested `<g transform>` per submodel. Nested transforms would make 11.3(1) free, but would force coordinate-space conversion on every cross-boundary arc, and cross-boundary arcs (#4) are the case we cannot afford to make awkward. **This is a real trade, consciously taken**, not a free win.
- **Explicit layer groups**, because SVG has no `z-index` — paint order is document order. Suggested layers: submodel bodies → arcs → nodes → labels → interaction overlay. Cheap to set up now, painful to retrofit.
- **Text has no auto-wrap in SVG.** Labels need either manual measurement or `foreignObject` (acceptable — we only target browsers).

### 11.5 Escape hatch

Keep rendering behind a **thin interface** (create/update/remove a visual for an element id; hit-test at a point; report gestures as intents). Then a JointJS-backed renderer remains implementable if from-scratch stalls, and the decision above is reversible at the cost of one adapter rather than a rewrite. This also keeps the §10 discipline honest: the renderer consumes the core plus derived indices and owns nothing authoritative.

**Sources for the free/paid split (checked 2026-07-30):** [jointjs.com/comparison](https://www.jointjs.com/comparison), [JointJS API docs v4.0](https://resources.jointjs.com/docs/jointjs), [container layout demos](https://www.jointjs.com/demos/jointjs-layouts).

## 12. Graph grammar — principles and machinery

*Decided 2026-07-30. This partly resolves open thread §7.3.*

**Deliberately scoped.** What is settled here is the **machinery**: the shape of a rule, the escape hatch for cases the declarative form cannot express, and *when* rules are enforced. What is **not** settled, and is explicitly not being settled yet, is the **catalogue** of actual rules — a list of the specific checks Simile performs (and when) has been requested from the Simile developer and will land as an appendix. Enumerating every possible check now would be premature: passing a model to the Simile execution phase is a long way off, and the checks that matter *for the editor* are a much smaller set (see 12.3).

### 12.1 Declarative first

The default is that a rule is **data**, not code — inspectable, enumerable, serialisable, and writable by someone who is not a programmer. This can be pushed a good deal further than endpoint tables alone: connectivity, containment, and **cardinality** ("what type and how many symbols may this kind of submodel hold") all express declaratively.

```js
// endpoint / connectivity
{ id:"flow-ends", subject:"arc:flow", ends:["compartment","cloud"],
  message:"A flow must run between compartments or clouds." }

// containment + cardinality
{ id:"one-condition", subject:"submodel", contains:{ condition:{ max:1 } },
  message:"A submodel may hold at most one condition." }

{ id:"population-symbols", subject:"node:initialiser|migrator|exterminator",
  parentKind:"population",
  message:"Population symbols may only appear inside a population submodel." }
```

Each rule carries an `id` (so it can be cited, suppressed, or tested) and a human `message` (so the error text lives with the rule rather than in the engine).

### 12.2 The escape hatch — named predicates, never code strings

There is a limit to what templates can express, and the un-expressed cases must be reachable. The mechanism: a rule may **name a predicate** implemented in JavaScript and registered in a table, which the developer (not the user) extends as required. The predicate receives the full model.

```js
{ id:"no-self-containment", subject:"submodel", predicate:"notAncestorOfSelf",
  message:"A submodel cannot contain itself." }

Sienna.grammar.predicates.notAncestorOfSelf = (ctx, el, model) => { … };
```

*This is a refinement of the originally proposed single `check_action()` function holding a growing list of cases.* A predicate **registry** is preferred over one accumulating function because it keeps the ruleset **enumerable** (one can ask "what rules apply to a flow?" — needed for 12.4), keeps the message attached per case, and keeps the rules exportable to other tools even when a few of them delegate. The imperative part still lives in code, keyed by name; the schema stays declarative.

**Hard constraint:** a rule may hold a predicate **name**, never a code **string**. Evaluating rule text at runtime is rejected outright — it is the `eval` road, and it would break the goal of a JSON-friendly, tool-friendly declarative format (§ project goals). Shipping predicates as code in the schema `.js` is not `eval` and carries none of its problems.

### 12.3 When rules are enforced — structural preventive, content deferred

Enforcement is **not** the binary "preventive vs validation pass" it first appeared to be. Simile has in effect already drawn the line, and §4 records half of it: connectivity is refused outright, whereas an element with unfilled props is *permitted and coloured red* until complete. Adopt that split as the principle:

| Class | Holds | Enforcement | Why |
|---|---|---|---|
| **Structural** | connectivity, containment, cardinality | **Preventive** — refuse the gesture | States with no meaning are never reachable; must be cheap and local, as these run mid-gesture |
| **Content** | equations, values, units, required props | **Deferred** — report, never block | Half-finished work must stay editable; also required to import legacy or partial models |

Completeness (red/black, §4 — derived, not stored) *is* the content-rule reporting channel; it is not a separate mechanism.

A consequence worth stating: **only the structural rules are needed now.** Content rules are what matter for handing a model to the execution engine, which is exactly the distant concern this section defers.

### 12.4 One engine, three questions

The same rules are consulted by three callers, and the call signature should be fixed with all three in mind:

1. **"May I do this?"** — mid-gesture, e.g. may this arc connect, may this element be dropped into this submodel (§11.3(2)).
2. **"What may I create/place here?"** — palette filtering, menu enable/disable, legal-drop-target highlighting.
3. **"Is this whole model sound?"** — a validation pass over everything.

(2) falls out of (1) by dry-run — ask the rules about each candidate and keep those that pass — provided rules are enumerable by subject (12.2). Greyed-out illegal palette entries and highlighted legal drop targets then cost no extra rules. Cheap to allow for now, awkward to retrofit.

### 12.5 Rules quantify over *derived* facts

A consequence of §4/§10 that shapes where the engine sits: *conditional* and *association* are **inferred**, not stored (decision #3). So `parentKind:"population"`-style rules quantify over derived properties, which means:

- the grammar runs against the **in-memory denormalised form** (§10.2's indices), not the DRY core alone;
- inference is **non-monotonic in practice** — adding a condition node changes a submodel's inferred kind, which can render previously-legal contents illegal. Legitimate, but it means a structural edit can invalidate elements it did not touch.

Eventually each rule should therefore declare **what it depends on**, so re-checking after an edit is incremental rather than whole-model. Noted as a direction, **not built now** — with rule counts in the tens and models in the hundreds of elements, whole-model re-checking is affordable.

### 12.6 Left open

- The **rule catalogue** — awaiting the Simile developer's list of specific checks and their timing.
- The exact **rule vocabulary** (`ends` / `contains` / `parentKind` above are illustrative, not final) — best fixed against that catalogue plus the SBML cross-check, so it is not over-fitted to Simile.
- Whether rules live **in the schema file** alongside vocabulary/dialogs/styling (§3's second face) or as a separable ruleset. Assumed in-schema for now.

## 13. Arcs, segments and ports — cross-boundary connections

*Decided 2026-07-30. This largely closes open thread #4 (§7.1), the "murkiest corner". Two sub-questions remain open at the end.*

### 13.1 Vocabulary

- **Arc** — the *semantic* link, `a → b`. One object in the model, with one type, one set of props, and (for roles) one label.
- **Segment** — one *drawn* piece of an arc. Segments are not stored; they are derived.
- **Port** — the point at which a drawn connection crosses a submodel boundary.

### 13.2 One arc in the model, several segments in the drawing

If `a ∈ S1` influences `b ∈ S2`, that is semantically **one** influence. Simile splits it into three arcs on the diagram (`a`→S1 boundary, S1 boundary→S2 boundary, S2 boundary→`b`) *and* into three arcs in the model declarations. **We keep the visual split and reject the model split.**

The number of segments is **never stored**. The renderer walks the containment path from `a` up to the nearest common ancestor of `a` and `b` and back down, emitting a segment per boundary crossed: same submodel → one segment, the example above → three, deeply nested pairs → more.

**Why keep the visual split** (it is not merely fidelity to Simile):

1. **Collapse falls out for free.** Collapse S1 and the inner segment disappears while the boundary-to-boundary segment remains, now terminating on S1's edge. With a single polyline this needs special-casing.
2. **Ports are real layout facts.** Where an arc pierces a boundary is something a user may position and expects to persist, and several arcs compete for room along one edge — so it needs to be addressable.
3. **Hit-testing and waypoints** are naturally per-segment.
4. **Fan-out keeps the diagram clean** *(the strongest reason)*. If `a` influences several nodes outside S1, there is **one** segment from `a` to S1's boundary (and to each further ancestor boundary) serving all of them — not one per destination.

### 13.3 Segments are shared, so a segment is not a function of one arc

Reason 4 above means segments cannot be derived per arc. All arcs leaving `a` share their exit through S1, and through S1's ancestors, up to the point where their paths diverge: the picture is a **tree rooted at `a`**, not *n* independent polylines.

That gives an identity rule needing no invented ids. A port is determined by the pair **(boundary submodel, endpoint element)** — `(S1, a)`. Every arc out of `a` crossing S1 uses port `(S1, a)`; if S1 is inside S0 they also share `(S0, a)`, because the path from `a` upward is unique. Segments are then simply the links between consecutive ports.

Consequences:

- **Layout keys on ports, not on arcs** — e.g. `port:submodel1/node_a → {edge:"top", t:0.4}`. Dragging `a`'s exit from S1 moves it for every arc out of `a` at once, which is the wanted behaviour, and it comes from the keying rather than from bookkeeping. Per §10.2, a *user-set* port position is independent (file); an auto-placed one is derived (memory only).
- **Deletion needs no refcounting.** Delete one arc out of `a` and the shared exit segment survives because the remaining arcs still derive it. The derivation just recomputes.
- **Labels and aliases belong to the arc**, never the segment — a shared segment cannot carry any one arc's data (§14).

### 13.4 Arc parentage dissolves

If a cross-boundary connection is one arc, `parent` on an arc is either derived (nearest common ancestor of the endpoints) or simply absent. Either way it stops being something the user chooses or the file records — which is the outcome we want, since a stored arc-parent can contradict the endpoints and would then need repair logic. Consistent with §10.2's DRY rule: not independent, so not stored.

**Ruling #9, confirmed 2026-07-30 — and there is an existence proof, not merely an argument.** Simile's own saved model carries no arc-parent fact: the parentage of each of its split arcs is recoverable from that arc's endpoints. So a format that omits it demonstrably loses nothing. Our version derives the parent of the *whole* arc rather than of each split piece, but the same reasoning applies — endpoints determine containment, so containment need not be stored alongside them.

### 13.5 Left open

- **Fan-in symmetry.** Source-side sharing is settled. Is the target side symmetric — one segment from S2's boundary in to `b` shared by all arcs arriving at `b`, or one per arc? If symmetric, only the middle segment (last source port → first target port) is per-arc, and target ports key as `(S2, b)`. If not, target ports key as `(S2, b, arc)`. The cleanliness argument applies equally to both sides, but there is a genuine asymmetry in *reading*: everything leaving port `(S1, a)` demonstrably came from `a`, whereas a merged arrival at `b` no longer shows which outside node it came from. **[ASK]** what Simile does.
- **Port placement** — user-dragged or auto-placed from geometry? This decides whether ports appear in the file at all (see §10.2).

## 14. Naming — ID, label, name

*Decided 2026-07-30. Supersedes the strawman's loose use of `label` in §4.*

Four words were in circulation; three survive, with fixed meanings:

- **ID** — system-generated, family-prefixed, e.g. `arc1`. Never user-facing, never user-editable, stable across re-parenting (§10.1).
- **Label** — the user-editable text attached to an element on the model diagram.
- **Name** — the variable's name as used in equations.
- **~~Identifier~~** — **dropped**; it was being used for both ID and name.

**Label ≡ name is enforced.** A label need not in principle be the equation name, but a model in which they differ is very confusing, so we insist they are typographically the same. Two consequences:

- **One stored field, not two.** There is no `name` beside `label`; the label *is* the name for those types that have one, and whether a type has an equation-name is a fact about the type. A named cloud ("atmosphere") is simply a type whose label is not referenceable.
- **Equation syntax constrains what may be typed as a label.** Confirmed: **no spaces**. The remaining rules, and whether name-uniqueness is scoped to the containing submodel, are **[ASK]** (§8).

**Which elements have labels:** nodes (including valves, clouds — optional — and condition nodes, whose label indicates what the condition is based on), submodels, and **role** arcs. **Flow and influence arcs have none** — a flow's name belongs to its **valve** (§4), which is the element that holds the rate equation and that influences actually target.

### 14.1 Local names (aliases) on influences

An influence carries the name under which the target's equation refers to the imported value. Simile defaults this to the source's label and suffixes on collision (`growth_rate`, `growth_rate1`, disambiguated by mouseover to `S1:growth_rate` / `S2:growth_rate`); the modeller may rename it. **We keep this, including renaming.**

- **Renaming is a real requirement, not a workaround.** The naming in the source submodel and in the target submodel may come from different sources, and a modeller may legitimately wish to keep both conventions from the scientific literature.
- **It is also what makes rename safe.** §4 stores equations verbatim and never resolves them, so the editor *cannot* rewrite equation text when a source is renamed. Because the alias is copied at arc creation and not re-synced, renaming a source changes only that element — no downstream equation breaks. (Accepted cost: the alias may go stale relative to the source's new label; mouseover still tells the truth.)
- **Path-qualified names never appear in equation text** (`S1:growth_rate + S2:growth_rate` is rejected). It solves the collision problem but locks an equation to the presence of S1 and S2, which defeats modularity — an equation must survive being lifted into another model.
- The alias lives on the **arc**, which is exactly one source→target pair — correctly *not* on a segment, which may be shared (§13.3).
