# Diagram Library — Design Summary (restart / discussion draft)

*Status: design and a working editor. §§1–15 were written before the code; §§16–20 record decisions taken while building it, 2026-08-04/07. Sections marked **[ASK]** are questions for the Simile developer. Build state — what exists, what does not — is in `STATUS.md`, which is kept current; this file is the reasoning behind it.*

This is the design of a **diagramming library** (`src/diagram.js` — `Sienna.Diagram`) and, on top of it, a **sienna diagram-editor widget** (`src/widgets/diagram.js`). The two names are confusingly alike; the split between them is real, and the library contains no reference to the DOM or to jQuery. *One honest qualification (2026-08-09): "library" describes the shape, not yet the packaging. `Sienna.Diagram` reaches directly for `Sienna.userData` and `Sienna.actions` on every mutation — 32 and 15 call sites — which is exactly what buys undo, replay and autosave for free, and equally what stops the file being lifted into another project unchanged. Extracting it behind an injected store is deliberately deferred until a second host actually wants it; see §21.* The long-term aim is to replace the diagram editor of **Simile** (simulistics.com) with something notation-neutral and schema-driven. It sits inside sienna (static jQuery SPA, runs from `file://`, no build/server — see `CLAUDE.md`).

---

## 1. Scope

- We are building the **diagram editor only**.
  - The **simulation engine already exists** (Prolog → C++) — out of scope; how we feed it a model is a substantial *later* question.
  - **Results-display widgets** exist only as Tcl/Tk desktop today; to become sienna widgets eventually — not a current constraint.
- The editor **stores** per-element equations, values, units and properties but **never evaluates** them.

## 2. The core idea

A node-and-arc diagram in which the **vocabulary and rules are declared in a schema, not hard-wired in code** — true of node types from the start, and of arc types since `addArc` replaced three hard-wired methods (§21.1). One library can render Simile today and other notations (e.g. SBML) tomorrow by swapping the schema — this was proven before in the user's earlier tool **Systo** (a `.js` schema switched System Dynamics ↔ SBML).

Three first-class object **families**:

- **node** — schema-typed (compartment, variable, cloud, condition, population symbols, …)
- **arc** — schema-typed (flow, influence, role, …)
- **submodel** — *one* object, NOT schema-typed; its *kind* is a property or is inferred from use

A submodel is **not** a kind of node (some libraries model containers that way; we reject that here).

## 3. The schema — four faces

1. **Vocabulary** — the node/arc types this notation has (and the submodel's allowed kinds).
2. **Grammar** — a graph grammar: which types may connect to which, and what may be contained where (e.g. a flow's ends must be compartment or cloud; population symbols only inside a population submodel). *Open: rule language + preventive-vs-validation enforcement.*
3. **Property / dialog spec** — the fields each type exposes in its settings dialog (equations/values/units/props). A mandatory **field model** (the data — source of truth) separated from an optional **presentation** (auto-generated form as fallback). *Revised 2026-08-13:* the presentation is registered through `Sienna.dialogs.register(type, renderer)` and no longer hung on the schema as a function — a function is precisely what a schema claiming to be plain exportable data cannot hold. A renderer is handed the field model, the whole schema, and the standard row-builders, so it can reuse the ordinary control for the fields it does not want to reinvent.
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
- **Valves** are real, auto-created node elements, one per flow, holding the flow's label/name and its rate equation. **A valve has no position of its own** *(2026-08-04)*: it rides at the midpoint of its flow, so dragging either end carries it — the schema marks the type `positionedBy:'arc'` and the geometry is derived, hence never stored (§10.2's rule applied to a *node*, not just to routing). A flow is therefore drawn **straight** end to end, with the valve sitting on the line rather than being a bend in it. They are the System Dynamics instance of a general **attachment node** — the node a notation creates so that things can be hung off an arc; in other notations (e.g. webakt causal links) the same node has no glyph. Visible-or-not is a **style** fact (§6), not a model fact.
- **Submodel `kind`** = membership only (`single` / `fixed-membership` / `population`). *Conditional* and *association* are **inferred**, not stored: a submodel is conditional if it contains a condition node — **any number** are allowed, AND-ed together (§12.8) — and it is an association if role arcs point into it. An association between S1 and S2 is modelled by adding a **third** submodel S3 with role arcs S1→S3 and S2→S3 — **never** S1→S2; S3 becomes the association by virtue of those arcs. (Per-record and special-grid kinds deferred.) **The COUNT of role arcs is what names the kind** *(Simile developer, 2026-08-08)*: **one** makes a **satellite** submodel — a legitimate kind in its own right, hanging off a single other one — **two** makes an association, and **more than two is not legal**. Satellite therefore joins conditional and association as a third inferred kind, computed in `kindsOf` and never stored, so a rule may quantify over `parentKind: 'satellite'` exactly as it does the others. The ceiling is enforced preventively (§12.3: cardinality is structural), refusing the third arc as it is drawn.
- **Clouds** are real, auto-created node elements (created at a flow's blank end). Traditionally unnamed (a stock whose value we don't care about) but **optionally nameable** — e.g. "atmosphere"/"ocean" in a hydrological model. A cloud may carry **several** in/outflows, so it is deleted only when the flow being deleted was its **last** connection — unlike a valve, which is one-to-one with its flow and dies with it.
- **Completeness** (Simile's red-until-defined, black-when-complete) is **derived** from whether props are filled, not stored.
- **Enumerated types** live at model level.
- **Equations are stored verbatim, never resolved** by the editor.

## 5. Settled decisions (rulings, 2026-07-27)

1. Logical/layout split — **yes**.
2. Three maps `nodes`/`arcs`/`submodels` — **yes** (over a single `elements` map).
3. Conditional/association — **inferred, no explicit flag**.
4. Arc parentage + cross-boundary arcs — ~~deferred~~ **RESOLVED 2026-07-30, see §13** (rulings 7–9, 14–15 below).
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
14. **No fan-in** — segment sharing is source-side only; the branching structure always relates to a single source variable. **Yes** (§13.3). *Extended 2026-07-31:* sharing is **influence-only** — role and flow arcs are always one-to-one, so they never branch.
15. Ports are **auto-placed on creation, then draggable**, later arcs attaching to the existing port; port **positions are persisted in `layout`** (never in the model), port *existence* is derived. **Yes** (§13.4, §13.7).
16. §13 governs the **diagram only**. The model stores one arc between two IDs — no segments, no ports — unlike Simile, where diagram and file match. Test: **discarding the layout must not change the model's meaning.** **Yes** (§13.7).

*Ruling added 2026-07-31:*

17. **Ghosts — not built at this stage** (§15). A layout-only concept under §13.7, so adding them later touches `layout` + renderer, not the model or the format.
18. **Renderer reads layout only via `appearanceOf(elementId)`** — never `layout[id]` directly (§15). Accepted as a standing discipline so that ghosts stay a one-place change. **Yes.**

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

**What `layout` actually holds** *(recorded 2026-08-05, after building it)*. The table above said "position, size, waypoints, collapsed". Implementation added three entries, each keyed by something other than a bare element id, which is worth seeing together:

| Key | Holds | Why it is layout, not model |
|---|---|---|
| `<id>` | position, and size for resizable types | as planned |
| `ports/<boundary>/<owner>` | where an arc crosses a boundary (§13) | a drawing fact; the model has one unsplit arc |
| `labels/<id>` | a label's **offset** from the notation's default anchor | the anchor is the schema's business, the nudge is the user's |
| `arcs/<id>` | an influence's **curvature** (signed sagitta fraction) | shape of the line, not of the relation |

Storing an *offset* rather than an absolute label position matters: a label the user has never moved still follows the notation, so changing the schema's default anchor moves every untouched label and leaves the deliberate ones alone.

**Costs nothing now** — we just keep the three unfused: never a colour in `layout`, never an `x` in the model. Whether they end up as sibling subtrees / separate userData paths / separate files (so two users can swap styles over one shared model) is deferred alongside #4. One resolved ripple: whether `layout` carries `w/h` is governed by the type's **style** — a compartment is a resizable box (has `w/h`); a cloud or variable is a fixed glyph (`x/y` only).

## 7. Open threads

1. ~~**#4 — Arc parentage & cross-boundary arcs.**~~ **RESOLVED 2026-07-30 → see §13.** One arc, source-side-shared segments, no fan-in, ports auto-seeded then draggable and persisted, arc `parent` not stored.
2. ~~**Build vs. buy.**~~ **RESOLVED 2026-07-30 → build. See §11.** (Was: from-scratch SVG vs. vendoring an engine such as JointJS. Note the original phrasing of this thread said "SVG + jQuery-UI draggable"; the jQuery-UI part is withdrawn — see §11.1.)
3. **Grammar rule language.** **PARTLY RESOLVED 2026-07-30 → see §12**: the rule *shape*, the escape hatch and the enforcement split are decided; the rule **catalogue** stays open pending a list of specific checks from the Simile developer (requested).
4. ~~**Persistence shape** for model/layout/style (see §6).~~ **RESOLVED → §10 (flat id-keyed maps + parent pointers, indices derived in memory), §6 (what `layout` holds), §18.1 (the file's `format` version).** Built and round-trip tested.
5. **Influence curve geometry.** *(Partly resolved — see §13.6a for how the arc is defined and trimmed; the curve FAMILY is what remains open.)* Influence arcs are drawn as curves, not straight lines — including each segment of one that crosses a boundary. **Provisionally an arc of a circle** (sagitta a fixed fraction of the chord, currently 0.12), chosen 2026-08-04 as the simple option. Quadratic Bézier and spline are the alternatives, and the choice interacts with user-dragged waypoints once those exist. Flows and role arcs are straight **by default** — amended 2026-08-06: any arcs sharing BOTH endpoints now fan apart, whatever their type, because two arcs between the same pair were otherwise drawn pixel-identical and a self-association (two role arcs from one submodel to one association) showed as a single arc. The fan is derived at paint time from the endpoint pairs and stored nowhere; dragging an arc's curvature still overrides it. Whatever curve family is chosen, it will apply to these too.

## 8. Questions for the Simile developer **[ASK]**

- ~~**#4:** How does Simile decide which submodel an arc "belongs to"?~~ **ANSWERED 2026-07-30** (§13): Simile splits a cross-boundary arc into three arcs both on the diagram *and* in the model declarations — but stores no arc-parent fact, each split arc's parentage being recoverable from its endpoints. We keep the visual split, reject the model split, and likewise do not store arc parentage. Sharing is source-side only (no fan-in) and ports are auto-seeded then draggable — both confirmed by the user, so nothing further to ask here. *What this costs a future `.pl` importer is measured in §13.5.*
- **Association inference:** In the saved model, is a submodel's *association* nature truly implicit (recoverable only from its role arcs), or is there an explicit marker? Same question for *conditional* (the contained condition symbol) — stored flag or inferred?
- **Storage separation:** Does the `.sml` (Prolog) format separate logical structure from diagram layout at all? Any notion of style separate from layout?
- ~~**Ghosts:** How is a ghost stored, and confirm only nodes are ghostable?~~ **NOT ASKED — deferred 2026-07-31, see §15.** Jasper confirmed he uses ghosts, to reduce influence-arrow clutter; we are still leaving them out for now. The question returns if and when they do.
- **Condition symbol:** At most one per submodel? Any placement constraints? What exactly may its expression reference? *(Partly answered 2026-07-30: condition nodes do carry a label, indicating what the condition is based on.)*
- ~~**Label typography:** the full rule set for legal variable names.~~ **CLOSED 2026-08-08 — decided rather than asked (§14).** The rule is now the negation of the equation grammar's identifier, `[A-Za-z_][A-Za-z0-9_]*`, so it cannot drift from what an equation can actually reference. Two findings got it there: `landuse1b.pl` names a compartment `time under crop` while its equations say `time_under_crop`, and `lamos1a.pl` labels one `spark?` while its equations say `spark_`. Simile keeps the prettier form to display and substitutes illegal characters in the name; we rule label ≡ name and take the name. *Still worth Jasper's eye, but as a decision to challenge rather than a question outstanding.* Uniqueness was settled separately — scoped to the submodel, §14.2.
- ~~**Completeness (red/black):** the precise rule for when an element flips from red to black, per type.~~ **NOT ASKED — decided ourselves, 2026-08-06, §19.9.** The governing ruling is that we are not bound to reproduce Simile: where we think its behaviour wrong we change it. Our rule is in fact stricter than Simile's, since it also reddens an element whose equation disagrees with the influences drawn into it.
- **Equation function arities:** we have a table of ~110 (schema `functions`), but only the 41 used by the reference models are confirmed; the rest come from the help pages alone. Which are wrong? And is the arity of the `pi(1)` / `time(1)` family really "optional dummy argument", as real models suggest and the help denies? *(§19.8)*
- **Array vs list dimensional rules:** must a `{x}` reference always come from a variable-membership submodel and `[x]` from a fixed one? If so the cross-check can be made much sharper at no cost *(§19.8)*.
- **Vocabulary drift:** Are `event` / `state` / `squirt` / ~~`satellite`~~ *(answered 2026-08-08: a satellite is a submodel with exactly ONE role arc — see §4)* / per-record & special-grid submodels genuinely later additions to the canonical set (compartment, variable, submodel, flow, influence, role, condition, initialiser, migrator, ~~reproducer~~ **reproduction** *(corrected 2026-08-04, §12.8)*, exterminator)? Anything else we've missed?
- **Glyphs:** the four population symbols are now drawn from the *toolbar* icons (a sprouting mound, a zigzag, an egg, an axe) because those were what the help site exposed. Are the **in-diagram** symbols different, and are these close enough? *(§9, `STATUS.md` item 16.)*
- **Anything about the model that is hard to express as flat id-keyed maps + parent pointers** — deep nesting (FLORES: Village▸Household▸5 submodels, 900+ patches), associations between deeply-nested submodels, array access (`element()`/`index()`).

## 9. Test cases

- **Land-use change** (reference; §4) — PATCH fixed-membership + FOREST/CROP conditional + NEXT TO **self-association** (both roles from the same submodel).
- **Farmers & fields** (Muetzelfeldt 2010, CCAFS) — VILLAGE contains FARMER (population: initialiser/migrator/exterminator), FIELD (fixed-membership), OWNERSHIP (**two-party association**, roles "owns"/"owned" from two *different* submodels of *different* kinds). Complements land-use: covers the second association topology plus population-only nodes. Confirmed the strawman needs nothing new for it.

- **LAMOS** (`lamos1a`, added 2026-08-08) — a **medium-complexity real model, reconstructed from a screenshot** rather than designed as a test: 66 named nodes plus 9 flows across 11 submodels, with 58 equations transcribed from `lamos1a.pl`. Different in kind from the other two, which were built to exercise chosen features; this one was not built to exercise anything, which is why it found what it found (below).

Since 2026-08-06 there is also a **running** test: `test/index.html` parses the 1500 equations harvested from the 72 reference models (§19.2).

**Both designed cases are built** — `src/demo-landuse.js` and `src/demo-farmers.js`, 2026-08-06 (LAMOS followed on 2026-08-08, `src/demo-lamos.js`) — and §4 survives them: three id-keyed maps, parent pointers, inferred conditionality and inferred association all hold up, with no field added and nothing awkward. What they *did* break was the layer above, and the pattern is worth noting: **every defect they found was in rendering or in a guessed rule, none in the object model.** Two arcs sharing both endpoints drew pixel-identical, so a self-association looked like one arc; role arcs had no style and drew invisibly; role labels were never drawn at all; and the `influence-target` rule refused an influence into an exterminator. All four are fixed; see `STATUS.md` for the detail.

Two the models exposed were notation questions rather than bugs, and both were ruled on 2026-08-06 (see `STATUS.md` items 16). A **submodel's kind is now drawn** — a four-deep stack for fixed-membership, an open shadow whose corners deliberately do not close for a population, nothing for `single` — because which submodels have many instances is arguably the most important thing a Simile diagram conveys, and all three looked identical. And the four **population symbols now have glyphs**, taken from Simile's toolbar icons and reduced to strokes that survive being zoomed out. In both cases the schema says *which* and the renderer knows *how*, the same split as the `cloud` and `valve` shapes — so the notation stays swappable.

A third thing surfaced from reading `landuse1b.pl` rather than from building: the original names a compartment **`time under crop`**, with spaces, while its equations refer to `time_under_crop`. So in real Simile the display label and the equation name are *not* the same string — the local name is derived by replacing illegal characters. §14 rules them identical, which forces the underscored form on the modeller. That is a defensible simplification, but it is a departure, and it was made without knowing this. **Revisited and kept, 2026-08-08** — see below and §8.

**What the third model was worth.** LAMOS confirmed the pattern the first two established and then extended it. Again nothing in the object model (§4) had to change to hold a real model four times the size of the reference cases. What it *did* break was, again, a guessed rule: `lamos1a` labels a variable **`spark?`**, which the naming rule then rejected, and the question of what characters a label may contain — open in §8 since 2026-07-30, and narrowed but not closed by `landuse1b`'s `time under crop` — was finally settled by *deriving* it rather than guessing again. The rule is now the exact complement of the equation grammar's identifier, so a label is legal precisely when an equation can refer to it (§14). Two labels changed (`spark?` → `spark_`, `is_fire?` → `is_fire_`).

It also gave the completeness checking (§15) its first honest workout, because unlike the hand-built fixtures it was not authored to be green. With the 58 equations in, LAMOS reports **71 findings** — 23 `missing`, 29 `undeclared`, 18 `unused`, 1 `syntax`. That number is a measurement of *my influence tracing from a picture*, not of the model or of the checker: the screenshot does not show which influences feed which equation, so undeclared/unused pairs are exactly where my reconstruction guessed wrong. **Ruling, 2026-08-08: LAMOS stays red — that is the point of it.** Do not "fix" these findings by correcting the tracing against `lamos1a.pl`. Every other fixture is authored green, so all of them would still pass if the checker silently stopped working; this one is the only evidence that it does anything. A red fixture built from a real model is a test, not an unfinished job.

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
- **Memory-only derived structures** — everything computable from the core, kept for fast **bidirectional** lookup and never serialised: the **child-index** (down: parent→children; the core stores only up: child→parent), a **reverse arc index** (node→incident arcs; the core stores only arc→endpoints), a **ghost/appearance index** (node↔its appearances — *not needed while ghosts are deferred, §15; listed because the shape of the split is what matters here*), cached **completeness** (red/black), and auto-computed geometry (auto-routed waypoints, bounding boxes).

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

*(On what `file://` does and does not constrain, see `NOTE-static-vs-dynamic.md` — written 2026-08-08 after the replay work, and the place where the shared-`file://`-origin behaviour was measured.)*

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
- **All layout reads go through `appearanceOf(elementId)`** — never `layout[id]` in renderer code (ruling 18, §15). One indirection now; it is what keeps ghosts a one-place change later.

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

**First real use, 2026-08-06 — and it is not the kind of case that was anticipated.** The two rules in `src/predicates.js` ask whether an element is *drawn* inside the submodel it *belongs to*. The vocabulary could not express that for a structural reason worth naming: every other term quantifies over the **model**, while this compares the model with the **layout** — the two halves §6 deliberately keeps apart. A predicate is the right home precisely because the question crosses that line, and one should be suspicious of any pressure to add layout terms to the rule language itself.

Why check it, when a dropped element cannot disagree with itself: **dropping is not the only way a diagram gets built.** An AI assistant writing a model, or an automatic graph layout moving things about, both bypass the gesture and have no reason to keep model and layout in step (user, 2026-08-06). The rule is insurance against the ways of building a diagram we do not have yet — which is also why it is **deferred** rather than preventive: dragging out of a box is how re-parenting works, and the drop is what decides.

*This is a refinement of the originally proposed single `check_action()` function holding a growing list of cases.* A predicate **registry** is preferred over one accumulating function because it keeps the ruleset **enumerable** (one can ask "what rules apply to a flow?" — needed for 12.4), keeps the message attached per case, and keeps the rules exportable to other tools even when a few of them delegate. The imperative part still lives in code, keyed by name; the schema stays declarative.

**Hard constraint:** a rule may hold a predicate **name**, never a code **string**. Evaluating rule text at runtime is rejected outright — it is the `eval` road, and it would break the goal of a JSON-friendly, tool-friendly declarative format (§ project goals). Shipping predicates as code in the schema `.js` is not `eval` and carries none of its problems.

### 12.3 When rules are enforced — structural preventive, content deferred

Enforcement is **not** the binary "preventive vs validation pass" it first appeared to be. Simile has in effect already drawn the line, and §4 records half of it: connectivity is refused outright, whereas an element with unfilled props is *permitted and coloured red* until complete. Adopt that split as the principle:

| Class | Holds | Enforcement | Why |
|---|---|---|---|
| **Structural** | connectivity, containment, cardinality | **Preventive** — refuse the gesture | States with no meaning are never reachable; must be cheap and local, as these run mid-gesture |
| **Content** | equations, values, units, required props | **Deferred** — report, never block | Half-finished work must stay editable; also required to import legacy or partial models |
| **Behavioural** | facts no gesture can violate | **Silent** — parameterise the editor, never surface | There is nothing to refuse: the rule decides what the editor *does*, not whether the user may |

Completeness (red/black, §4 — derived, not stored) *is* the content-rule reporting channel; it is not a separate mechanism.

**The third row was added 2026-07-31, and it is not a technicality.** "A flow may not branch" looks preventive, but no gesture can break it: dragging two flows out of a compartment is perfectly legal and simply yields two flows. Nor is influence branching something a user *requests* — it happens automatically when the second influence out of the same source crosses the boundary. The rule is never asked "may I?"; it tells the **arc-drawing routine** whether to attach to an existing port or make a new one. Likewise "an arc may not terminate on an arc" never surfaces: dragging an influence at a flow resolves the endpoint to the valve (§4). Same for "a role arc may not branch".

So a behavioural rule needs **no user-facing message at all** — and a rule that would have to explain itself apologetically is a sign it has been put in the wrong row. Such rules are still declared in the schema, for the usual reasons (a second notation may answer differently, and external tools can read the answer); they are simply consumed by the editor's behaviour rather than by its permission checks.

A consequence worth stating: **only the structural and behavioural rules are needed now.** Content rules are what matter for handing a model to the execution engine, which is exactly the distant concern this section defers.

**Two corrections from building the engine (2026-08-04, `src/grammar.js`).**

**(i) Behavioural facts belong in the vocabulary, not in the rules array.** §12.6 seeded three of them as rule records — *influence-branches*, *flow-role-no-branch*, *no-arc-on-arc*. Building the engine showed they were the same fact twice: each type already declares `branches` and `attachmentNode` in the vocabulary (§3.1), which is where the arc-drawing routine reads them, so a parallel list could only drift. They are **removed from the catalogue**; callers ask `Sienna.grammar.behaviour()`, which reads the vocabulary. The behavioural *class* stands — it was a real distinction, and it is what identified these as not-rules — but the class turns out to describe **where a fact lives**, not a third kind of entry in the same list.

**(ii) "Preventive" is a property of the GESTURE, not only of the rule.** The same structural rule can be preventive at one point of entry and reportable at another. The case that forced this: *population symbols only inside a population submodel*.

- **Dropping** an element into a submodel is refused outright — the user is asserting containment, and there is nothing to gain by allowing a state they must then undo.
- **Capturing** by drawing a submodel around existing elements is **allowed and reported**. §5's own workflow requires it: box a flat model, *then* declare the box a population. The moment the box exists it is `single`, so every population symbol inside it breaches the rule — refusing the capture would block the very thing the feature is for. The breach is reported instead, in the manner of the validation pass (§12.4 q3).

So enforcement has two axes, not one: the rule's **class** (structural / content / behavioural) and the gesture's **stance** (refuse / report). A structural rule refuses where the user is asserting the thing the rule governs, and reports where they are doing something else that happens to pass through an illegal state. §12.5's non-monotonicity is the general form of this: an edit elsewhere can invalidate elements it never touched, and those can only ever be reported.

**(iii) The deferred class was never wired up — found 2026-08-06.** `rulesFor` filtered to preventive rules, and the whole-model pass used it, so a rule tagged `deferred` was evaluated by *nobody*. The row had existed in the table above since the section was written, and the schema had a `'deferred'` value for `enforcement`, and neither did anything. It went unnoticed for the plainest of reasons: every rule written until then happened to be preventive, so the dead branch was never taken. `validate` now asks for preventive **and** deferred; the gesture callers still ask only for preventive. Worth recording as a general caution — a class that nothing yet instantiates is a class nothing tests, and the first user of it is as likely to find the mechanism broken as to find it useful.


#### Geometry is structural, and prevented by clamping *(corrected 2026-08-09)*

The two geometry rules — `inside-its-parent`, `not-inside-a-stranger` — were
originally filed as **deferred**, on the reasoning that blocking a gesture
mid-drag would fight the user, and that an automatic layout pass wants freedom to
be momentarily wrong. Testing exposed what that actually meant in the editor: a
submodel could be dragged clean out of its parent, and nothing said so until
**check model** was pressed.

**Simile was then consulted directly, and does the opposite: the drag stops dead
at the boundary.** Parentage is never changed by dragging in either direction;
moving an element between submodels is a cut-and-paste. Having seen it, the
preventive version is plainly the better feel — it does not read as being fought,
it reads as the boundary being solid. The rules are re-tagged `preventive`.

Three details matter in the implementation, and all three came from testing:

- **Clamp, do not refuse.** Refusing at drop-time throws away a whole gesture;
  clamping shows the limit at the moment it is met.
- **Clamp each axis independently**, so an element pressed against a boundary
  *slides* along it rather than freezing whenever a diagonal move is partly
  illegal.
- **Fall back to the last legal offset, not to zero.** Zero snaps the element
  back to where the drag began the instant both axes block. It also matters for
  a different reason: each pointer event is computed from the drag's origin
  rather than from the previous event, so without a last-legal memory a fast
  flick samples only positions beyond an obstacle and sails through it.

The original worry about layout algorithms was not wrong, merely misdirected: it
is an argument about **producers other than the editor**, and those do not drag.
An importer, a graph-layout pass or an AI assistant builds geometry directly, and
for them the rules remain exactly what §12 is for — a check to run over a
finished diagram. Keeping the rules in the catalogue while the editor prevents
them interactively serves both.

**Consequence, and it is not small:** with drag no longer re-parenting, nothing
in the editor can change an element's parent except drawing a new submodel round
it. Cut-and-paste stops being a convenience and becomes the missing gesture.

### 12.4 One engine, four questions

The same rules are consulted by four callers, and the call signature should be fixed with all of them in mind:

1. **"May I do this?"** — mid-gesture, e.g. may this arc connect, may this element be dropped into this submodel (§11.3(2)).
2. **"What may I create/place here?"** — palette filtering, menu enable/disable, legal-drop-target highlighting.
3. **"Is this whole model sound?"** — a validation pass over everything.
4. **"How do I draw/resolve this?"** — *added 2026-07-31.* Does this arc share an existing port or make its own (§13.3)? Where does this endpoint actually land? No answer here is ever refused; the reply configures the gesture rather than judging it.

(2) falls out of (1) by dry-run — ask the rules about each candidate and keep those that pass — provided rules are enumerable by subject (12.2). Greyed-out illegal palette entries and highlighted legal drop targets then cost no extra rules. Cheap to allow for now, awkward to retrofit.

(4) is the caller for the **behavioural** class above, and the reason it is worth naming separately: a rules API designed only around "may I?" would return a boolean plus a message, which is the wrong shape for "which port does this attach to?".

### 12.5 Rules quantify over *derived* facts

A consequence of §4/§10 that shapes where the engine sits: *conditional* and *association* are **inferred**, not stored (decision #3). So `parentKind:"population"`-style rules quantify over derived properties, which means:

- the grammar runs against the **in-memory denormalised form** (§10.2's indices), not the DRY core alone;
- inference is **non-monotonic in practice** — adding a condition node changes a submodel's inferred kind, which can render previously-legal contents illegal. Legitimate, but it means a structural edit can invalidate elements it did not touch.

Eventually each rule should therefore declare **what it depends on**, so re-checking after an edit is incremental rather than whole-model. Noted as a direction, **not built now** — with rule counts in the tens and models in the hundreds of elements, whole-model re-checking is affordable.

### 12.6 Left open

- The **rule catalogue** — **first entries received from the Simile developer 2026-08-04, see §12.8**; more expected. *Seeded 2026-07-31 with the entries we knew independently:* **influences may branch; flows and role arcs may not** (§13.3), and **an arc may not terminate on an arc** (influences into a flow resolve to its valve; §4). All are **behavioural**, not preventive — they carry no message and are consulted by the arc-drawing routine, per §12.3 and question 4 of §12.4. *(First recorded as preventive rules with refusal messages, corrected the same day — no gesture can violate them — and then, on building the engine, moved out of the rule catalogue entirely into the vocabulary where they were already declared: §12.3(i).)*
- The exact **rule vocabulary** (`ends` / `contains` / `parentKind` above are illustrative, not final) — best fixed against that catalogue plus the SBML cross-check, so it is not over-fitted to Simile.
- Whether rules live **in the schema file** alongside vocabulary/dialogs/styling (§3's second face) or as a separable ruleset. Assumed in-schema for now.


### 12.7 Starter rules (illustrative, deliberately incomplete)

*Added 2026-07-31.* These exist to **populate the rule base so the engine can be built and exercised** — not to be a correct or complete grammar for Simile. Completeness is explicitly **not** a precondition for starting the diagramming code: rules are data, so adding the rest later is editing a file, not reworking the engine. Jasper's catalogue, when it arrives, replaces and extends this.

Each is tagged **[known]** (we are confident) or **[guess]** (plausible, to be confirmed — safe because a wrong starter rule is one line to fix).

```js
// --- structural / preventive: connectivity ---
{ id:"flow-ends", subject:"arc:flow", ends:["compartment","cloud"],              // [known]
  message:"A flow must run between compartments or clouds." },

{ id:"flow-not-cloud-to-cloud", subject:"arc:flow", not:{ ends:["cloud","cloud"] },   // [guess]
  message:"A flow must have a compartment at at least one end." },

{ id:"role-ends", subject:"arc:role", ends:["submodel","submodel"],              // [known]
  message:"A role arc must run from a submodel to an association submodel." },

{ id:"influence-target", subject:"arc:influence",                                // [guess]
  toTypes:["variable","valve","condition","compartment"],
  message:"An influence must end at a variable, valve, condition or compartment." },

// --- structural / preventive: containment + cardinality ---
{ id:"one-condition", subject:"submodel", contains:{ condition:{ max:1 } },      // [guess]
  message:"A submodel may hold at most one condition." },

{ id:"population-symbols", subject:"node:initialiser|migrator|exterminator",     // [known]
  parentKind:"population",
  message:"Population symbols may only appear inside a population submodel." },

// --- behavioural (§12.3, silent — no message) ---
{ id:"branching", subject:"arc:influence", branches:true },                      // [known]
{ id:"no-branching", subject:"arc:flow|arc:role", branches:false },              // [known]
```

Two things this small set is *for*, beyond having rules at all:

- it spans **all three enforcement classes minus content** — connectivity, containment/cardinality, and behavioural — so the engine's call signature (§12.4) is exercised by real cases rather than designed against one;
- it includes a `not:` and a multi-type `subject:`, which is where a declarative rule shape usually first shows strain. Better to meet that now, with two rules, than after fifty.

**The vocabulary in these rules is provisional** (§12.6): `ends` / `not` / `toTypes` / `contains` / `parentKind` / `branches` are working names, to be fixed against Jasper's catalogue plus the SBML cross-check so the shape is not over-fitted to Simile.

### 12.8 Rules from the Simile developer (batch 1, 2026-08-04)

Four rules, now in `src/schema/simile-v1.js`. All are **structural, hence preventive** (§12.3) — each is something a user can attempt and must be refused, unlike the behavioural entries of §12.6.

1. **Population symbols only inside a population submodel.** We already had this, guessed correctly and tagged `known`. It brought a vocabulary addition with it: **`reproduction` is a fourth population symbol**, alongside initialiser, migrator and exterminator. Added to the schema's node types and to the rule's subject. *(Note the spelling: `reproduction`, not the "reproducer" of §8's vocabulary list — §8 asked whether that list was right, and this is part of the answer.)*
2. **No reverse role arc.** Given a role arc S1→S2, the reverse S2→S1 is refused.
3. **A conditional submodel may hold ANY NUMBER of condition symbols**, which are **AND-ed** together.
4. **No condition symbol inside a population submodel.**

**(3) corrects us, and the `guess` tagging did its job.** §12.7's starter set contained `one-condition` — *"a submodel may hold at most one condition"* — tagged `guess`. It is simply wrong: there is no limit. The rule is **removed rather than relaxed**, since with no cardinality bound there is nothing left for it to say. This is exactly the outcome the confidence tags were for (§12.7: "a wrong starter rule is one line to fix"), and it is worth recording that the mechanism paid for itself on the first contact with reality. The AND-ing of multiple conditions is a *semantic* fact for the engine, not a grammar rule — the editor stores the conditions and never combines them (§1).

**(2) forced the rule vocabulary to grow, which is the useful signal here.** Every rule so far constrains an arc or element *in isolation* — its endpoint types, its parent's kind, what it may contain. "No reverse role" is the first that quantifies over **the arcs that already exist**: whether S1→S2 is legal depends on whether S2→S1 is already drawn. The endpoint tables of §12.1 cannot express that. It is recorded declaratively as a new term:

```js
{ id:"no-reverse-role", subject:"arc:role", noReverse:true,
  enforcement:"preventive", confidence:"known",
  message:"These two submodels already have a role arc in the other direction." }
```

rather than pushed into a named predicate (§12.2's escape hatch), because "this relation is one-directional between a pair" is a recognisable, reusable pattern that another notation could want — whereas the escape hatch is for genuine one-offs. Worth watching: if the next batch brings two or three more rules of this shape and each needs its own term, that is evidence the rule language wants a general way to talk about *existing* arcs, rather than a growing list of special terms. **Not generalising yet** — one instance is not a pattern (§12.6 keeps the vocabulary open pending exactly this kind of evidence).

**(4) is the first rule that mixes a declared kind with an inferred one.** *Population* is a stored `kind`; *conditional* is inferred from containing a condition (decision #3). So this rule says: a submodel may not be both. It quantifies over derived facts in the way §12.5 anticipated, and it is non-monotonic in the same way — dropping a condition into a population submodel is refused, but *changing a submodel's kind to population* while it already holds a condition is the same violation reached from the other side, and only the second is a change to an element the rule does not mention. Whichever way the engine is built, both routes need checking.

**Still nothing is enforced** — there is no grammar engine. These are declared, so that the engine has real rules to run against when it is written.

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

**Sharing is source-side only — there is no fan-in** *(ruled 2026-07-30)*. The branching structure always relates to a **single source variable**: incoming influences are never merged. So the shape is precisely a tree rooted at `a` — shared on the ascent to the common ancestor, and **not** shared on the descent to each destination. Port keys follow directly:

| | shared by | port key |
|---|---|---|
| ascent (out of the source's containers) | all arcs from `a` | `(boundary, a)` |
| descent (into a destination's containers) | nobody — per arc | `(boundary, arc)` |

The middle segment is per-arc either way. The asymmetry is right, not merely traditional: everything leaving port `(S1, a)` demonstrably came from `a`, so fan-out loses no information — whereas a merged arrival would hide which outside node an arrow came from.

**Two words that must not be confused** *(2026-07-31)*:

- **Segmented** — one arc drawn as several pieces because it crosses boundaries. A **diagram** fact; this whole section.
- **Branched** — one source, several targets. A **model** fact.

An arc may be segmented without being branched, and the two questions have different answers per arc type.

**Sharing applies to *influence* arcs only** *(ruled 2026-07-31)*. Sharing presupposes branching, and only influences branch. **Role** arcs (one submodel → one association) and **flow** arcs (one compartment/cloud → one other) are **always one-to-one**, so no branching structure arises for them and no segment of theirs is ever shared. Note this is about *branching*, not about count: several role arcs may leave the same submodel (the self-association case, `arc3`/`arc4` in §4) — each is still its own one-to-one link.

**Why only influences branch — it is semantic, not conventional.** *Branching is safe exactly for arcs that carry information rather than stuff.* An influence delivers a value; copying it to three targets costs nothing and changes nothing. A flow carries a quantity, so branching one would mean the quantity itself divides — 10 m³/hour becoming 6 and 4. That is a perfectly reasonable and neat thing for a modeller to want, but it forces a flow equation per branch, and the ordering and conservation questions that come with it: a nightmare. **The answer we give the modeller is: draw two flows, and if the total is wanted, add a variable summing them.**

This yields a second, independent reason flows must never share segments *visually*: a shared flow segment would look exactly like the division we are forbidding. For influences no such reading arises, since nothing is being divided.

Consequence: the port-sharing machinery is influence-specific. Whether role and flow arcs are ever **segmented** is a separate question — see §13.6, where flows are confirmed to be and role arcs are pending.

Consequences:

- **Layout keys on ports, not on arcs** — e.g. `port:submodel1/node_a → {edge:"top", t:0.4}`. Dragging `a`'s exit from S1 moves it for every arc out of `a` at once, which is the wanted behaviour, and it comes from the keying rather than from bookkeeping.
- **Deletion needs no refcounting.** Delete one arc out of `a` and the shared exit segment survives because the remaining arcs still derive it. The derivation just recomputes.
- **Labels and aliases belong to the arc**, never the segment — a shared segment cannot carry any one arc's data (§14).

### 13.4 Port placement — auto-seeded, then user-owned

*Ruled 2026-07-30.* A port is **auto-placed when first created**. Later arcs out of the same source **attach to that existing port, where and as it then is** — they do not each get their own placement. A port may afterwards be **dragged** by the user.

This settles whether ports are persisted, and the answer refines §10.2's independent-vs-derived split. Auto-placement is a **one-time seed, not a standing derivation**: once the port exists, the second arc's geometry depends on where the first one put it, so re-deriving on load could move an arrangement the user has come to rely on (and would move it for every arc at once). Therefore **a port's position is persisted from the moment the port exists**, whether or not it has been dragged. The category is "seeded automatically, then owned by the document" — a third case beside §10.2's pure-independent and pure-derived, and worth naming there when that section is next revised.

What is still *not* persisted is the port's **existence**: which ports there are follows from the arcs and the containment hierarchy, so what is held is a position for a port the derivation reconstructs, and a position with no corresponding port is simply ignored on load.

**Persisted where — `layout`, never the model.** *(Clarified 2026-07-31; the earlier phrasing "ports appear in the file" wrongly suggested the model file.)* Ports and segments are **diagram** facts and live in `layout`, which §6 keeps as a concern apart from the model — plausibly a separate file, with several named layouts over one shared model. Nothing about boundary crossings enters `nodes`/`arcs`/`submodels`. See §13.7.

*Small detail left open:* when the last arc through a port is deleted, is the port's dragged position forgotten, or remembered in case an arc is drawn there again? Remembering is friendlier for undo/redo and costs a little orphaned data; forgetting is tidier. Not urgent.

### 13.5 Arc parentage dissolves

If a cross-boundary connection is one arc, `parent` on an arc is either derived (nearest common ancestor of the endpoints) or simply absent. Either way it stops being something the user chooses or the file records — which is the outcome we want, since a stored arc-parent can contradict the endpoints and would then need repair logic. Consistent with §10.2's DRY rule: not independent, so not stored.

**Ruling #9, confirmed 2026-07-30 — and there is an existence proof, not merely an argument.** Simile's own saved model carries no arc-parent fact: the parentage of each of its split arcs is recoverable from that arc's endpoints. So a format that omits it demonstrably loses nothing. Our version derives the parent of the *whole* arc rather than of each split piece, but the same reasoning applies — endpoints determine containment, so containment need not be stored alongside them.

**What this costs a future `.pl` importer** *(measured on `lamos1a.pl`, 2026-08-08)*. Because Simile stores the split pieces and we store the whole arc, an importer cannot map arcs one-to-one: it has to walk chains and collapse them. The file has **239 influence arcs**, of which only **72 join two user-named, non-function nodes** — the remaining 167 run to or from a submodel boundary or through one of the file's **100 `function` nodes**, which are the equation halves of variable records rather than anything the modeller drew. So roughly *seven in ten* influence arcs are machinery that must be traversed and discarded, not imported. An importer that takes the arcs at face value produces a model with the right node set and unreadable connectivity. This is the flip side of §13.2's ruling being right: the same simplification that keeps our model clean makes the import a graph walk rather than a translation.

### 13.6a How an influence is drawn *(2026-08-05)*

An influence's arc is **defined through the two node centres** and then **trimmed** where it crosses each glyph — not drawn between points already on the two rims. The difference is visible: an arc defined by rim points leaves the glyph at an angle that has nothing to do with where it is going, so the arrow appears to start beside the node rather than to come from it. Simile does not do this; correcting it was cheap and is the sort of thing that is invisible when right and irritating when wrong.

Trimming walks the arc rather than solving circle-against-glyph analytically, because the glyphs are rectangles, circles, clouds and bow-ties and one walk serves all of them.

Curvature is per arc and **user-draggable** (stored in `layout`, §6), including bending the other way — a signed sagitta, clamped below half the chord, since at half the chord the arc is a semicircle and beyond it SVG's `large-arc-flag` can no longer express what is meant. Each arc carries a wide transparent twin beneath it, because a hairline cannot be hit with a pointer; that twin is also the selection handle when selection reaches arcs.

### 13.6 Status

**Open thread #4 is closed** as of 2026-07-30: one arc in the model, shared source-side segments, no fan-in, ports auto-seeded then draggable and persisted, arc parentage not stored. Two small residues:

- the port-position-on-last-delete detail (§13.4);
- whether **role** and **flow** arcs are ever **segmented** — i.e. can cross a submodel boundary — as opposed to always being a single straight link. (On *branching*, all three types are settled: influences branch, role and flow arcs never do — §13.3.)

  **Flows: YES, confirmed 2026-07-31.** Flows can connect compartments at different levels of nesting, so a flow is segmented like any other arc — just never with *shared* segments, since flows do not branch. So §13 is **not** an influence-only story.

  **Role arcs: normally nothing is crossed** *(corrected 2026-07-31)*. An association between S1 and S2 is modelled by adding a **third** submodel S3 and drawing two role arcs **S1→S3 and S2→S3** — never S1→S2. S3 thereby *becomes* the association, by inference from the two role arcs pointing at it (decision #3). With S1, S2, S3 siblings under one parent, neither role arc crosses any boundary.

  The reason is worth stating, because it is what makes role arcs different from influences: **a role arc's endpoints are submodels, not nodes inside them.** An arc from a node must exit that node's containers to reach anything outside; an arc *from a submodel* has nothing to exit, since the submodel is itself the endpoint. So a role arc between siblings runs edge-to-edge and crosses nothing.

  What remains open is only the non-sibling case: may a role arc connect submodels at **different nesting levels** — an association involving a submodel nested deeper (the FLORES-style case flagged in §8)? If not, role arcs are never segmented at all. **The user is checking this** (2026-07-31); nothing depends on the answer, since flows already prove the machinery is needed.

### 13.7 None of this reaches the model — the discardable-layout test

*Stated explicitly 2026-07-31, because §13 is all about the drawing and it would be easy to read it as being about the saved model.*

Everything in §13 concerns the **diagram**. The **model** holds a cross-boundary connection as exactly one arc between two element IDs — `arc2: { type:"influence", from:"node1", to:"node5", alias:"state" }` — with no parent, no segments, no ports. **In Simile the diagrammatic representation matches the model file precisely; we deliberately do not follow that.** The gain is the project's stated goal of a declarative, tool-friendly format: someone processing the file to reason about model *structure* reads `a` influences `growth_rate` and never has to reconstruct that from three boundary hops.

The rejected alternative was to store segments and reason over them with a small graph library. Note that the library is needed **either way** — under the one-arc design it is what *derives* the segments for rendering (nearest common ancestor, containment walk, the §10.2 child-index). So the choice was never "arc plus reasoning" versus "segments plus reasoning"; it was where the redundancy sits, and the declarative form wins.

**The test that keeps this honest: discard the layout entirely and the model must mean exactly the same thing.** Ports regenerate by auto-seeding (§13.4) — in different places than before, which is a cosmetic loss, not a structural one — and no fact about model structure is lost. If that ever ceases to hold, something has leaked from the diagram into the model.

## 14. Naming — ID, label, name

*Decided 2026-07-30. Supersedes the strawman's loose use of `label` in §4.*

Four words were in circulation; three survive, with fixed meanings:

- **ID** — system-generated, family-prefixed, e.g. `arc1`. Never user-facing, never user-editable, stable across re-parenting (§10.1).
- **`has_label`** *(added 2026-08-04)* — a schema flag on a *type*, saying whether that type carries a label at all (`true` / `false` / `'optional'` for clouds). Named to keep it clear of a field descriptor's `label`, which is that field's display name in a dialog. Three uses of one word is two too many.
- **Label** — the user-editable text attached to an element on the model diagram.
- **Name** — the variable's name as used in equations.
- **~~Identifier~~** — **dropped**; it was being used for both ID and name.

**Label ≡ name is enforced.** A label need not in principle be the equation name, but a model in which they differ is very confusing, so we insist they are typographically the same. Two consequences:

- **One stored field, not two.** There is no `name` beside `label`; the label *is* the name for those types that have one, and whether a type has an equation-name is a fact about the type. A named cloud ("atmosphere") is simply a type whose label is not referenceable.
- **Equation syntax constrains what may be typed as a label** — and as of 2026-08-08 it constrains it *exactly*: the naming rule is the negation of the equation grammar's identifier, `[A-Za-z_][A-Za-z0-9_]*`. It was `no spaces` alone until reconstructing LAMOS showed the hole: Simile labels an element **`spark?`** and its own equations then refer to **`spark_`**, substituting the illegal character. So `?` was legal as a label here while being unusable in any equation — precisely the split this section exists to prevent. Rule and grammar now agree by construction, and cannot drift apart, because one is defined as the other's complement. The cost is the one already accepted for spaces: `spark?` becomes `spark_`, and the question mark's hint that a value is boolean is lost.

**Reaffirmed 2026-08-06, against contrary evidence, as a deliberate departure from Simile.** Building the land-use model surfaced that the original does *not* do this: `landuse1b.pl` names a compartment **`time under crop`**, with spaces, while its equations refer to `time_under_crop` — Simile keeps a display label and derives the equation name from it by replacing illegal characters. So the identity above is ours, not inherited. Put to the user, the ruling stood: the modeller types `time_under_crop` and that is both the label and the name. The reason is worth recording because it is a judgement rather than a technical necessity — *"a little less natural, but it is valuable to impose a bit of formality on the modelling process, and avoid two ways of expressing the same thing."* One string, one place to change it, and nothing to keep in step.

**Which elements have labels:** nodes (including valves, clouds — optional — and condition nodes, whose label indicates what the condition is based on), submodels, and **role** arcs. **Flow and influence arcs have none** — a flow's name belongs to its **valve** (§4), which is the element that holds the rate equation and that influences actually target.

### 14.1 Local names (aliases) on influences

An influence carries the name under which the target's equation refers to the imported value. Simile defaults this to the source's label and suffixes on collision (`growth_rate`, `growth_rate1`, disambiguated by mouseover to `S1:growth_rate` / `S2:growth_rate`); the modeller may rename it. **We keep this, including renaming.**

- **Renaming is a real requirement, not a workaround.** The naming in the source submodel and in the target submodel may come from different sources, and a modeller may legitimately wish to keep both conventions from the scientific literature.
- **It is also what makes rename safe.** §4 stores equations verbatim and never resolves them, so the editor *cannot* rewrite equation text when a source is renamed. Because the alias is copied at arc creation and not re-synced, renaming a source changes only that element — no downstream equation breaks. (Accepted cost: the alias may go stale relative to the source's new label; mouseover still tells the truth.)
- **Path-qualified names never appear in equation text** (`S1:growth_rate + S2:growth_rate` is rejected). It solves the collision problem but locks an equation to the presence of S1 and S2, which defeats modularity — an equation must survive being lifted into another model.
- The alias lives on the **arc**, which is exactly one source→target pair — correctly *not* on a segment, which may be shared (§13.3).

### 14.2 Name uniqueness — scoped to the submodel, and what happens when a move breaks it

*Settled 2026-08-06. The scope was **measured, not asked**: §8 had carried it as a question for the Simile developer since July.*

**Names are unique among SIBLINGS, not across the model.** Across the 72 reference models, a name repeats in *different* submodels **493** times and within one submodel **3** times (those three being two top-level `fn1`s in `daisyworld1.pl` and one in `animal1.pl` — sloppy models or a mis-read, either way not a counter-case). `AntsWorld.pl` has a variable `x` in four different submodels. Better still, Simile's own auto-generated names restart at `fn1` inside each submodel — the name generator declaring the scope it works in. So the same name may, and often will, appear in several places.

**Three enforcement points, and they differ on purpose.**

| how the clash arises | what happens | why |
|---|---|---|
| the user **types** a name a sibling has | **refused** | typing a name is asserting that name; being told it is taken is the answer they need |
| the user **drops** an element beside a same-named sibling | **auto-renamed** `biomass` → `biomass_1` | dropping asserts *containment*; the clash is incidental, and halting the drag to argue about a name would be obstructive |
| a model **arrives** with clashes (import, or something that is not this editor) | **reported** by the model check | nothing to intervene in; a deferred rule is exactly the channel |

Ungroup promotes children into their grandparent's scope and takes the same auto-rename path, for the same reason. The rename happens *inside* the action that moved the element, so one undo puts back both the move and the name.

**No equation is rewritten, and none needs to be.** The instinct on first meeting this is that renaming `biomass` obliges the editor to hunt down every equation referring to it — and under most designs it would. Not here: §14.1's alias is copied at arc creation and never re-synced, so a target's equation refers to *its own local name for the imported value*, never to the source's current label. Rename the source and every downstream equation still says what it said and still works. This is that ruling earning its keep, some weeks after it was made for a different reason.

The cost, accepted knowingly in §14.1 and now slightly sharper: the alias may read `biomass` while the source is called `biomass_1`. For a *manual* rename that is the modeller's own doing; for an automatic one it is not, so this is the place to look first if the staleness ever proves confusing in practice. Note that rewriting equation text is no longer *impossible* as §14.1 assumed — the parser can locate each identifier exactly (`references()` returns offsets) — so cascading the rename is now an available option rather than a barred one. It is simply not needed for correctness.

## 15. Ghosts — deferred, deliberately

*Decided 2026-07-31.*

A **ghost** is a second on-diagram appearance of an element that lives elsewhere. **We are not building them at this stage.**

**The case both ways, recorded so the decision can be revisited on its merits:**

- *Against* — they obscure interconnections. The user has never used them and dislikes them as seen in other System Dynamics packages (Stella, Vensim): a reader cannot tell from the diagram where a value actually comes from.
- *For* — Jasper (the Simile developer), asked directly, says he does use them and finds them very useful for **reducing influence-arrow clutter**. That is a real problem in large models and this design has no other answer to it.

The point is that both are true, and the trade is about diagram legibility at scale, not about correctness.

**Deferring costs little, and here is why — ghosts are a *layout* concept under §13.7.** A ghost changes nothing about model structure: an arc still connects one element to another, and *which appearance of an element an arc visually attaches to* is a diagram fact. So adding ghosts later touches `layout` and the renderer, and leaves `nodes`/`arcs`/`submodels` and the file format alone. (This is only true because §13.7 separated the two; in Simile, where diagram and file match, ghosts are necessarily a format concern.)

**The one thing that would make it expensive, and the cheap insurance against it.** Today `layout` keys on element id (§4: `node1:{x,y}`), which quietly assumes **one appearance per element**; §13.3's port keys `(boundary, source element)` make the same assumption. Ghosts break that 1:1, so layout and port keys would have to become **appearance**-keyed. That is a mechanical re-keying, but a scattered one if every renderer site indexes `layout[id]` directly.

**The insurance, ACCEPTED 2026-07-31:** the renderer reaches layout through a **single accessor** — `appearanceOf(elementId)` — which today always returns the one and only appearance. No renderer code indexes `layout[id]` directly. Near-zero cost now, and it localises the later change to that accessor plus the port keys.

This is a **discipline for code not yet written** (§11 decided we build the renderer ourselves), so it costs nothing today and must simply be honoured when the renderer is built. It is *not* a request to model appearances now: there is no appearance id, no appearance map, no second appearance — only one indirection, so that adding them later is a change in one place.

**Likely trigger for revisiting:** importing legacy Simile models that already contain ghosts, or clutter becoming unmanageable in a large test model. Not a decision to re-open before then.

## 16. Interaction model

*Ruled 2026-08-04, after a first attempt put renaming on double-click and had nowhere left for a settings dialog.*

| Gesture | On a node or submodel | On a label |
|---|---|---|
| **Click** (press, no movement) | select — a ring, and the hook everything else hangs off | edit the label in place |
| **Drag** | move it | move the label, storing an offset (§6) |
| **Double-click** | open the element's dialog (§3's third face) | the dialog too, if the label lies inside the glyph; otherwise nothing |

Three things this settles, each of which cost something to learn:

**Click and drag are told apart by movement, not by target.** A press only becomes a selection or an edit *on release*, once it is known that nothing moved. Any other rule collides with dragging, which the same press has to be able to start.

**Double-click cannot rely on the browser.** Every gesture ends in a re-render that replaces the SVG element, so the browser sees two clicks on two different nodes and never pairs them into a `dblclick`. Detection is therefore keyed on the **element id**, not the DOM node — and a press that changes nothing must not re-render, or it destroys the node between the two halves of the gesture. This is the kind of defect that a test dispatching a synthetic `dblclick` will happily fail to find, because it skips the very mechanism that is broken.

**Selection is the hook, not a feature.** It is what makes multiple elements draggable together, what Delete acts on, what the validation pass highlights, and where a properties panel will attach. Adding it late would have meant retrofitting all four.

## 17. Deletion

*Built 2026-08-04. The lifecycle rules were settled piecemeal in §4; this is them together.*

Deleting an element deletes the **closure** of what cannot survive it, computed to a fixpoint since removing one element can orphan another:

- a **submodel** takes its contents, at any depth;
- any element takes the **arcs** attached to it — an arc with one missing end is not a thing;
- a **flow** takes its valve, and a valve its flow: they are one-to-one;
- a **cloud** is **refcounted**, going only when the last flow touching it goes (§4).

Layout owned by the removed elements goes with them — geometry, label offset, curvature, and any port they owned or hosted, a port's existence being derived from arcs and containment that no longer exist (§13.4).

The whole cascade is **one action**, hence one undo step; and the editor reports the count when it exceeds the selection, because deleting one element can reach a long way. Deleting a compartment in the reference model removes seven things.

**Deleting a submodel deletes its contents** — ruled deliberately. Dissolving the box while *keeping* its contents is a different intention, so it is the separate **ungroup** command (built 2026-08-06), which re-parents the contents to the submodel's own parent and re-seeds ports, both of which capture and drop-into already do.

Two things ungroup had to settle that delete does not raise. Only the **immediate children** move: anything deeper stays inside its own submodel, which is promoted intact. And an arc attached to the **box itself** — a role arc to a submodel — cannot survive it, since one of its ends is going; so ungroup promotes the contents *first* and then asks for the deletion closure of the box, which by then covers the box and its arcs but not its contents. That reuse is the point: the closure's per-type lifecycle rules (a flow's valve, a refcounted cloud) apply to the fallout of an ungroup without being restated. The extra departures are reported, as a delete's cascade is.

Ungroup **reports** a containment breach rather than refusing it, as submodel capture does (§12.5): promoting a child to its grandparent can break a rule, and refusing would trap the contents in the box for good.

## 18. Where the File menu lives — a boundary, not a feature

*Ruled 2026-08-04. Recorded here because it settles what this design does NOT own.*

sienna is a host that becomes a particular application (`?app=simile`, `?app=webakt`). The conventional furniture along the top of the window should not vary with which one — so **File belongs to the shell**, not to this app and emphatically not to the diagram widget. The second reason is the stronger one: a model will eventually be viewed by *several* widgets, and it would be arbitrary for one of them to own loading and saving it.

The shell therefore owns New / Open / Save / the list of stored documents (`Sienna.documents`), and simile registers only the two things that cannot be generic: **what an empty model looks like**, and **which widget opens one**. The shell never inspects a document's contents — the same boundary `userData` already draws.

The consequence for this design: a widget that views a model must declare it by setting its panel's **`ref`**, which is the shell's own binding. That is how File commands find the current model without knowing that a diagram widget exists, and it is what gives a widget `_model()` / `_watchModel` for nothing.

### 18.1 What simile must supply on its side of that boundary

*Added 2026-08-06, on finding the answer was "not enough".*

Because the shell never inspects a document's contents, **everything that makes a file recognisably ours is simile's job**, and there is more of it than "here is an empty model":

- **A format version** — `Diagram.FORMAT`, stamped into every model. The point of having it from the start is that it cannot be added later: a file already saved without a version can never afterwards be told apart from one written by a future release. Files predating it have no key and are read as 1.
- **A validate that actually refuses.** It first checked only that `nodes` and `arcs` existed, so a model in another notation imported happily, joined the model list, and failed only when a panel tried to draw it — leaving the user a document they could not open and no explanation. Validation must reject a foreign or unnamed notation, and a file from a newer format, each with a sentence that completes the shell's *"Could not open that file: …"*. Naming the notations we *do* have turns a dead end into a hint.
- **One statement of the empty-model shape** — `Diagram.emptyModel`, used by both the shell's document factory and `Diagram.create`. They had been spelling it out separately, which the format stamp would have had to be added to twice.

The general point, worth carrying to the next app built on sienna: a boundary that says "the host never looks inside" hands the guest the whole of the responsibility for what "inside" means, including the unglamorous parts — versioning and refusal.

### 18.2 An inherited assumption, corrected

*2026-08-06, prompted by the user asking why File ▸ Save was a download when webAKT's is a proper Save dialog.*

Saving was a Blob download, on the strength of a comment in the shell reading *"under `file://` a browser cannot write files silently"*. That sentence is true, and it was read as settling the matter. It does not: it rules out writing **without asking**, and says nothing about a dialog. The actual rule is that a page may not write to a file **the user did not choose** — and `showSaveFilePicker` is that choice being made, in the browser's own dialog. It works under `file://`; webAKT had been doing it for years.

The consequence is not cosmetic. The picker returns a **handle**, and a handle can be written through again without re-prompting, so there can be a real **Save** as distinct from **Save as** — where a download can only ever produce `Plant.json`, `Plant (1).json`, `Plant (2).json`. No amount of care over the download path could have reached that; it needed the assumption questioned.

Recorded here because the failure was not technical but epistemic: a constraint was *inherited from a comment* and never tested, and the review that went over file save afterwards checked correctness — round-trip, validation, versioning — without ever asking whether the interaction was the best available. Worth a second look wherever else `file://` is cited as a limit; §3's "no `fetch`" and §11.2's vendoring note are the other two, and both do hold.

The change itself is the shell's (sienna `5bb8468`), since File is the shell's; the Chromium-only reach of the API means Firefox and Safari keep the download, and there Save means Save as.

## 19. Equations — the parser, and the check it exists for

*Built 2026-08-06. This section records the decisions; `STATUS.md` carries the build state and the measurements, and the file headers of `src/equation-grammar.js` and `src/equation-check.js` carry the working detail.*

### 19.1 What it is for — and what it is not

The editor **never evaluates an equation**. That single fact settles most of the design. There is no evaluator, no environment, no units arithmetic, and no error recovery, because one error position is all an underline needs. Two uses justify the whole piece:

1. **Does it parse** — feeding the red/black completeness colouring.
2. **Which model elements does it name** — so the names an equation uses can be cross-checked against the influence arrows actually drawn into that element.

The second is the valuable one, and it is worth being explicit about why: it is a check **Simile's own red/black does not make**. It catches errors in both directions — a name used with no arrow feeding it, and an arrow feeding a name the equation never mentions. Nothing but this combination of parser and diagram can see either.

### 19.2 The language is discovered, not designed

Simile's expression language already exists, so the job was archaeology rather than invention, and the sources disagree in instructive ways:

- **`SimileProlog_SimileXMLv3_MathML.xsg`** (R. Muetzelfeldt, 2007; adapted from the Virtual Cell grammar) turns out to be **the only complete statement of the language**. Its ladder, its `if/then/elseif/else`, and its local-variable form are the backbone of ours.
- **simulistics.com/help/equations/** documents the ~90 functions and the arithmetic operators — including `//` and `%`, which the XSugar ladder lacks — but says nothing whatever about the conditional or the boolean operators.
- **The 72 reference models** are the third and decisive source. Five constructs appear in real equations that *no document mentions*: `&&` and `||`, a bare `!`, `not` without brackets, the quoted `'!='`, and — the one most easily got wrong — that a quoted `'name'` is a **name**, not a string, XSugar mapping it to MathML `<ci>`.

The methodological ruling that follows: **the corpus outranks the documentation**, and a grammar change is justified by a failing real equation rather than by a reading of the help. `test/index.html` exists to keep that honest.

### 19.3 A declarative grammar, compiled at run time

The requirement was a declarative grammar, which rules out the hand-written recursive-descent parser (there the grammar *is* code). That leaves a generator, and PEG — Peggy, the maintained PEG.js — is both the standard answer for expressions and the one already in use in webakt.

The real question was **when generation happens**, and there were three answers. *Generate ahead of time via the Peggy playground* (webakt's workflow) leaves two files to keep in step by hand, and every iteration blocks on a manual browser task. *Generate ahead of time but locally*, driving Peggy from Node, removes the manual step but keeps the two files. *Compile at run time* keeps one artefact and makes drift impossible.

**Ruled: compile at run time.** The grammar text is the only artefact; there is no generated parser that can silently go stale while someone edits the `.peg`. It costs ~70 ms, paid lazily on the first equation parsed rather than at page load. Two consequences worth recording: the grammar has to live in a `.js` template literal rather than a `.peg` file, because `file://` cannot `fetch` (§ the no-build constraint); and the decision is **reversible in two lines** if start-up cost ever becomes visible, which is why it did not warrant more deliberation than it got.

### 19.4 Four deliberate departures from the 2007 grammar

1. **Associativity.** XSugar writes the additive and multiplicative rules right-recursive, so `a-b-c` parses as `a-(b-c)` and `a/b/c` as `a/(b/c)`. That is a bug, not a convention — it never bit because the grammar converted known-good files rather than diagnosing bad ones. Ours are left-associative; `^` stays right-associative, which XSugar has correct.
2. **Strict identifiers.** XSugar's `Name` admits spaces, hyphens and `%`, which cannot coexist with `-` as subtraction. Ours is `[A-Za-z_][A-Za-z0-9_]*` — deliberately **the same rule §14 already enforces for element names**, so that a name legal on the canvas is legal in an equation by construction, and the two can never drift apart.
3. **The Prolog boolean spellings are dropped.** XSugar admits `,` for *and* and `;` for *or*; both collide head-on with argument separators and array literals. Twelve equations in nine reference models use them, and the exclusion was reaffirmed knowing that. Reinstating them is a small, contained change — the collision is avoidable, since it is confined to bare brackets — so this stays cheap to revisit.
4. **Function names are not in the grammar.** See below.

### 19.5 Grammar fixed, vocabulary in the schema

This is §12's principle applied again: the engine holds no notation knowledge, the schema holds it as data. The **expression syntax** — operators, precedence, call form, the conditional, the brackets — is universal enough to fix in one PEG. The **function vocabulary** is not, so it is `functions` in the schema: name → arity, a number meaning exactly that many and an array meaning the *set* of allowed counts.

Three things follow, and they are the reason for the split. Adding a function is a line of data. **Letting a user declare their own functions** becomes possible without touching a grammar. And "no such function" can be reported as something quite different from "that is not an expression" — a distinction the user cares about and a single grammar could not draw.

### 19.6 What the parser deliberately cannot decide

`[weight]` is either the array variable `weight` or a one-element array built from the scalar `weight`; `{volume}` is likewise either a list reference or a one-element list. The syntax is identical and **only the model knows which**. So both parse to one node type, and the caller resolves them using the influences actually drawn. This is the same instinct as everywhere else here — derived facts are derived at the point of use, not frozen into the thing that cannot know them.

### 19.7 The cross-check is its own module

`Sienna.equationCheck` is the only thing that knows all three of the parser, the model layer and the schema; each of those stays ignorant of the others. It is expressly **not** part of `src/grammar.js`, whose contract is that it holds no rule of its own and evaluates only the schema's graph rules — an equation is not a graph rule. This is the same kind of boundary as §18: recorded because it says what a module does *not* own.

Four findings, all **deferred** in §12.3's sense — reported, never blocking, since an equation is stored verbatim however wrong it is (§4): `syntax`, `function` (unknown name or wrong arity), `undeclared` (a name no influence supplies) and `unused` (an influence whose name the equation never mentions).

The last two compare on the influence's **alias**, which is exactly the name the target's equation is meant to use (§14.1), defaulting to the source's label. Two silences are as important as the findings, and both were learnt by running the check rather than by reasoning about it:

- **`unused` says nothing until an equation exists.** While a model is being built the arrows arrive first, and a report that fires on every fresh arrow is a report nobody reads.
- **Neither name check runs when the equation does not parse.** An unreadable equation tells us nothing about which names it uses, so a single missing bracket would otherwise accuse every arrow into that element.

"Check model" runs this pass beside the graph pass and concatenates them; the user has no reason to care which found what.

### 19.8 Deferred, and why

- **Form checking.** A reference carries its form — `x`, `{x}`, `[x]` — so the check could be sharper still: a `{x}` wants an influence out of a *variable-membership* submodel and `[x]` out of a fixed one, and the absence is a real error rather than a stylistic one. The parser already supplies everything needed. Held until the dimensional rules are settled with the Simile developer (§8).
- **Function arities.** The 41 confirmed by the corpus are sound; the rest come from the help pages alone and are a first draft, to be checked type by type as the property lists must be. The corpus already exposed one discrepancy — the help calls `pi()` and `time()` nullary, real models write `pi(1)` and `time(1)`.
- ~~**The red/black rule itself.**~~ **RESOLVED 2026-08-06 → §19.9.** It was listed here as a question for the Simile developer; the ruling is that it is ours to decide, and it is decided.

### 19.9 Red/black completeness

*Ruled 2026-08-06. The governing decision first: **we are not bound to reproduce Simile.** Where its behaviour is worth keeping we keep it, and where we think it wrong we change it, deliberately.*

**An element is red when it is not runnable.** Five counts, and the last is the one Simile does not make:

| | |
|---|---|
| **missing** | a required field is empty — nothing has been written yet |
| **syntax** | what is written does not parse |
| **function** | a call to no such function, or with the wrong number of arguments |
| **undeclared** | a name used that no influence supplies |
| **unused** | an influence drawn in whose name the equation never mentions |

The last deserves its reasoning recorded, because the obvious objection is that such an equation parses and the model would run. It is nevertheless wrong: **the diagram is the specification**. By drawing an influence the modeller has said what this element's value depends on, and an equation that ignores it contradicts that statement. One of the two is a mistake, and the editor cannot tell which — but it can say that they disagree. That is a stronger check than Simile's, and it is available only because the equations and the diagram are checked against each other.

**Which fields are required is schema data**, not a rule in code: `required: true` on a field descriptor, and `requiredWhen: { kind: 'fixed-membership' }` for one that applies only to some kinds. The conditional form is not decoration — a submodel's `dimensions` applies only to fixed-membership submodels, and demanding it of all of them would leave every single-instance submodel permanently red. An element with no required fields, such as a cloud, is never red.

**Completeness is DERIVED at render, never stored.** Simile keeps a `complete=true` flag in the saved file; we deliberately do not. Completeness depends on the *arrows* as much as on the equation, so drawing or deleting an influence elsewhere can change an element's colour without its equation being touched — and a stored flag would be wrong from that moment until someone reopened the dialogue. This is the same instinct as §10.2's refusal to store derived geometry.

That has a cost worth recording, since it is the kind of thing that is discovered too late: colouring at render means parsing every equation on every frame of a drag. Measured, 200 distinct equations cost **46 ms** to parse and **0.2 ms** once cached, so `src/equation.js` memoises on the equation text — parsing being pure, the text is a sound key. Without it a 200-element model would drag at about 20 fps; with it the whole render is ~1.5 ms.

**Leaving the dialogue.** Cancel reverts, as ever. **OK always commits** — in every one of the five cases above. Whatever the modeller typed is kept verbatim, the element is flagged, and it stays red and incomplete. Refusing to accept a wrong equation would mean the only way out is to lose the work, which is not a choice worth offering. This is also what the model layer already does (§4: equations stored verbatim, never validated), so the ruling confirms the code rather than changing it.

One asymmetry, kept on purpose: **a bad label is still refused**, and the dialogue stays open. A label is not merely this element's business — it is the name *other* elements' equations use, so a label with a space in it breaks things elsewhere and can never be referenced at all. That is §12.3's split doing its job: naming is structural and preventive, equations are content and deferred.

## 20. Replay — a session as an artefact

*Built 2026-08-07, from the marker put down the day before. The mechanism is the shell's (`Sienna.actions.replay`); what is recorded here is the part simile had to decide.*

Every model edit already goes through `actions.dispatch`, so a modelling session was always on tape without anything being added for it — and model edits need no replay handler at all, since replay re-applies each entry's captured `changes` and `_watchModel` redraws the bound widgets. What simile had to supply was the **layout** half (six handlers, for panel add/close/move/resize/minimize/maximize) and a way to run the thing.

### 20.1 Pacing is a policy, and belongs to the app

Real timings make poor video. A modeller thinks for two minutes and then fires six actions in a second; replayed faithfully that is two minutes of nothing followed by a blur. The shell offers a `speed` multiplier, which cannot fix it — scaling every gap equally leaves the pauses dominating whatever number you choose.

So simile **clamps every gap into 150–1200 ms** before handing the log over, and asks for `speed: 1`. That is a judgement about what a viewer wants, not a fact about replay, which is why it lives here and not in the shell: a different app might want the true timings, or none.

### 20.2 A destructive command should name what it will destroy

Replay must start from a clean slate — freshly minted panel ids have to line up with the recorded ones — so it clears the workspace and **every stored model** before rebuilding. That is a genuinely destructive act, and it sits on a fault line: **the action log lives in memory while the models live in `localStorage`, so the two part company at every reload.** Come back the next day and you have four models and an empty log; replaying then would delete all four and rebuild nothing.

The ruling: a general warning is not good enough when the condition is *exactly checkable*. The confirmation names the models the log cannot rebuild. And "can rebuild" is tested strictly — a change must write the **whole** model (`models/growth`), never merely something inside it, because a log holding one rename would otherwise claim it could rebuild the model and then replay a stub with a single label in it.

The general form, worth carrying: when a command destroys work, compute what will be lost and say so by name. Anything vaguer leaves the user to guess, and they will guess wrong in the direction that costs them.

### 20.3 What this makes possible

Two things, one of which was not the point:

- **A session is a screencast** — a model being built, reproducible from a few KB of JSON, and shareable as a file.
- **A session is a test fixture.** Build a model once, save the log, and replay it after a refactor to check nothing moved. This only became practical when the shell stopped putting a timer between steps (sienna `414c10a`): an unpaced replay now runs in microtasks, 82 ms for 54 actions where it had been ~54 seconds in a background tab. Whether to adopt this as a real testing practice — alongside `test/index.html`, which does the same job for the equation grammar — is open.

**Known limits**, inherited: replay does not reconstruct `panel.ref` changes made after a panel exists, nor actions with no per-item record such as Clear workspace. Neither has bitten yet, because simile's panels are created with their `ref` already set.

### 20.4 A history has to be immutable — and end-state checks cannot tell you it is

*The most useful thing this exercise produced, and it came from **watching** the replay rather than testing it.*

The first time the land-use model was replayed to be looked at, it did not build up. The panel opened empty, the entire finished model appeared in a single step, and the remaining fifteen actions changed nothing.

**`userData` stores values by reference, and the log captured them by reference too.** So editing a model mutated the very object the log was holding: the recorded *"create an empty model"* had, by the time anyone read it, become the finished model. Replay therefore reproduced the end state at the creating action, and everything after it was a no-op. The log was not a history at all — it was a bundle of live pointers, and it agreed with the present by construction.

The same fault mirrored on the way out: re-applying handed the recorded object straight back to `userData`, so replaying a log put the log's own values into the live store, where the next write mutated them. A log was thus **faithful the first time it was replayed and wrong every time after** — and `history` shared the defect, so undo could rewrite its own stack. All three are fixed by snapshotting, on capture and on apply (sienna `6c47320`).

Two things worth carrying beyond this section:

- **"Stored by reference" is a contract with a long reach.** `userData`'s documentation says it plainly, and the consequence still went unnoticed in two separate places, because both looked like they were storing a *value*. Any component that keeps a copy of user data for later — a log, an undo stack, a cache, a diff — is exposed to it, and the fix is always the same: detach at the boundary.
- **An end-state check cannot distinguish a faithful replay from a lucky one.** Replay had already been "verified": clear everything, replay, compare — identical. That test passed *because* the corruption put the whole answer in the first entry. It was a real check that happened to be blind to the only interesting failure. Where a process is supposed to reach a result *by a particular route*, the route is what has to be observed: here, sampling the model after each step, which is a three-line `onStep` and would have caught it immediately.

## 21. The library boundary — how much of a library is it? *(2026-08-09)*

Prompted by a fair challenge: the design opens by calling this "the design of a
diagramming library", the original sketch was `var diag = new Diagram(...);
diag.add('node', ...)`, and yet a reader opening `diagram.js` finds a jQuery UI
widget. Where is the library?

**It is there, and it is the other file of the same name.** `src/diagram.js`
(1140 lines) is `Sienna.Diagram`: `new Diagram(path)`, `addNode`, `addSubmodel`,
`addArc`, and around them the things a diagramming library owes its caller —
`parentOf`, `ancestorsOf`, `descendantsOf`, `nearestCommonAncestor`, `arcsAt`,
`deletionClosure`, `box`, `arcPoints`, `portsFor`, `commitDrag`. The original
`diag.add('node', …)` became typed methods rather than string dispatch, which is
the only real departure from the sketch. `src/widgets/diagram.js` (1615 lines) is
the widget, and the only place that knows about pixels. Two files, near-identical
names — worth saying out loud, because it is the likeliest reason to conclude the
library is missing.

**The split is genuine, and cheap to verify:** the library mentions the DOM and
jQuery zero times. It could not draw anything if it tried.

### 21.1 Where it fell short, and what was fixed

Node types have always come from the schema — `addNode(type, …)` asks
`nodeType(type)` what exists. **Arcs did not.** There were three hard-wired
methods, `addFlow` / `addInfluence` / `addRole`, each with its type string baked
in, so a notation with a fourth kind of arc needed a code change. §2's claim that
the vocabulary is declared in the schema was therefore true for nodes and
two-thirds true for arcs.

`addArc(type, from, to, opts)` closes that, and it is not a switch: everything
the three differed on was already declared in the schema, and now drives one
path — `blankEnd` (what a blank end auto-creates), `attachmentNode` (a node the
arc brings with it, which carries the label and its equation), `has_label`, and
`alias` (§14.1). The three named methods remain as thin wrappers, since they read
better at 34 call sites and keep the action log's `diagram.addFlow` entries
unchanged.

Verified two ways. **Inertness:** all five demo models, their completeness scores
and every dispatched action are byte-for-byte identical before and after.
**The point of it:** declaring a fourth arc type `constraint` in the schema *at
runtime*, touching no code, produces a correctly stored labelled arc, a sensibly
named `diagram.addConstraint` action, seeded ports — and a refusal of a blank end,
because the new type declares no `blankEnd`.

### 21.2 Where it is still not a library, deliberately

**It cannot leave home.** `Sienna.userData` appears 32 times and
`Sienna.actions` 15; there is no store to inject, because the shell *is* the
store. That coupling is not an oversight — it is what makes every mutation
undoable, replayable and autosaved without the library knowing those features
exist. Decoupling means inventing a persistence interface to hand in, which is
real work for a benefit nothing yet asks for. **Deferred until a second host
wants it**, and recorded here so it is a decision rather than a drift.

**It is not packaged as anything**: no repository, no namespace of its own, no
published surface. If a second notation or a second app ever arrives, that is the
moment to extract it — and §21.1's work is what makes the extraction plausible,
since the notation-specific vocabulary is now data rather than method names.
