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
    node3: { type:"condition",   parent:"submodel2", label:"exists", props:{ expr:"state = 1" } },
    node4: { type:"condition",   parent:"submodel3", label:"exists", props:{ expr:"state = 2" } }
  },
  arcs: {
    arc1: { type:"flow",      parent:"submodel1"/*#4*/, from:"node2",     to:"node1",     label:"change state", props:{ rate:"…" } },
    arc2: { type:"influence", parent:"submodel1"/*#4*/, from:"node1",     to:"arc1",      label:"",             props:{} },
    arc3: { type:"role",      parent:null,             from:"submodel1", to:"submodel4", label:"role1",        props:{} },
    arc4: { type:"role",      parent:null,             from:"submodel1", to:"submodel4", label:"role2",        props:{} }
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
- **Arcs** carry `from`/`to` as element-id strings; `parent` is a submodel id. An influence may target an arc (`arc2 → arc1`), matching Simile.
- **Submodel `kind`** = membership only (`single` / `fixed-membership` / `population`). *Conditional* and *association* are **inferred**, not stored: a submodel is conditional if it contains a condition node; it is an association if role arcs point into it. (Per-record and special-grid kinds deferred.)
- **Clouds** are real, auto-created node elements (created at a flow's blank end). Traditionally unnamed (a stock whose value we don't care about) but **optionally nameable** — e.g. "atmosphere"/"ocean" in a hydrological model.
- **Completeness** (Simile's red-until-defined, black-when-complete) is **derived** from whether props are filled, not stored.
- **Enumerated types** live at model level.
- **Equations are stored verbatim, never resolved** by the editor.

## 5. Settled decisions (rulings, 2026-07-27)

1. Logical/layout split — **yes**.
2. Three maps `nodes`/`arcs`/`submodels` — **yes** (over a single `elements` map).
3. Conditional/association — **inferred, no explicit flag**.
4. Arc parentage + cross-boundary arcs — **deferred, to be discussed** (see §7 / §8).
5. Clouds as real auto-created nodes, **optionally named** — **yes**.
6. Ids — **sequential, family-prefixed** (`node1`/`arc1`/`submodel1`).

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

1. **#4 — Arc parentage & cross-boundary arcs.** Does an arc belong to a submodel, and if so which one when its endpoints are in different submodels? Options floated: nearest common ancestor / `null` / derive from endpoints. The murkiest corner. **[ASK]**
2. ~~**Build vs. buy.**~~ **RESOLVED 2026-07-30 → build. See §11.** (Was: from-scratch SVG vs. vendoring an engine such as JointJS. Note the original phrasing of this thread said "SVG + jQuery-UI draggable"; the jQuery-UI part is withdrawn — see §11.1.)
3. **Grammar rule language.** Expressiveness (declarative endpoint tables vs. general constraints) and *when* enforced (preventively during editing vs. as a validation pass — Simile leans preventive).
4. **Persistence shape** for model/layout/style (see §6) — deferred with #4.

## 8. Questions for the Simile developer **[ASK]**

- **#4:** How does Simile decide which submodel an arc "belongs to"? Can arcs cross submodel boundaries, and how are such arcs stored and drawn? Is arc-parent even a stored fact, or is it always derived from the endpoints?
- **Association inference:** In the saved model, is a submodel's *association* nature truly implicit (recoverable only from its role arcs), or is there an explicit marker? Same question for *conditional* (the contained condition symbol) — stored flag or inferred?
- **Storage separation:** Does the `.sml` (Prolog) format separate logical structure from diagram layout at all? Any notion of style separate from layout?
- **Ghosts:** How is a ghost (a second on-diagram appearance of a node) stored — and confirm only nodes are ghostable, never arcs/submodels?
- **Condition symbol:** At most one per submodel? Any placement constraints? What exactly may its expression reference?
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
