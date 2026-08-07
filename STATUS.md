# simile — build status

*A quick-reference companion to `DESIGN-diagram.md`, which remains the design record.
Last updated 2026-08-06.*

Ordering follows the implementation plan agreed on 2026-08-01: schema → model layer →
render → §13 ports/segments → creation → deletion → dragging → grammar engine.

**Everything on the implementation plan is now built**, and so is the replay
marker that followed it (item 20). What remains is the list of known gaps, and
the questions in `DESIGN-diagram.md` §8 that only the Simile developer can
answer.

---

## Done

**1. Schema — `src/schema/simile-v1.js`**
All four faces of §3 in one file: naming rule, vocabulary (node/arc types with
per-type facts — `has_label`, `autoCreated`, `positionedBy`, `branches`,
`attachmentNode`, `blankEnd`), the grammar rules, the styling defaults, and the
dialog **field model**, and the equation **function table**. Swapping this file
is what changes notation.
*Caveat: the rules are a deliberately incomplete starter set, each tagged
`known` or `guess` pending the Simile developer's catalogue (§12.7). The engine
that runs them is item 8.*

**2. Model layer — `src/diagram.js` (`Sienna.Diagram`)**
A thin wrapper over `userData`: stores no diagram state of its own, so undo and
replay cannot desync it. Every write is one dispatched action = one undo step.
Covers create / add node, submodel, flow, influence, role / setLabel /
setProperties / commitDrag / movePort / moveLabel / setArcBow, plus the derived
indices (`childrenOf`, `descendantsOf`, `arcsAt`, `ancestorsOf`,
`nearestCommonAncestor`, `portsFor`, `allPorts`, `box`).

**3. Rendering — `src/widgets/diagram.js`**
SVG, one flat world coordinate space with a single pan/zoom transform, explicit
layer groups, all layout read through `appearanceOf()`. Glyph shapes and sizes
come from the schema, not from renderer code.

**4. §13 — ports and segments**
Cross-boundary arcs are one arc in the model, drawn as several derived segments.
Ports keyed `(boundary, owner)`: shared on the source side, per-arc on the
target side. Auto-seeded at arc creation, then draggable along their boundary.
Port positions live in `layout/ports/…`, never in the model.

**5. Creation UI**
Palette generated from the schema vocabulary (auto-created types omitted).
Click to place a node; drag out a rectangle for a submodel, which **captures
what it encloses** and re-seeds the ports of arcs that consequently cross.
Arcs drawn source→target, with either end of a flow allowed to be blank canvas.
New elements are born named after their id and open straight into a rename box.

**6. Deletion**
Select and press Delete/Backspace. The cascade follows the lifecycle rules of
§4: a submodel takes its contents at any depth; any element takes the arcs
attached to it; a flow takes its valve and vice versa; a **cloud is refcounted**
and goes only when the last flow touching it does. Layout owned by the removed
elements goes too, ports included. One action, so one undo step however wide the
cascade — and the count is reported, since a delete can reach much further than
what was selected. **Deleting a submodel deletes its contents** (ruled
2026-08-04) — dissolving the box while keeping its contents is the separate
**ungroup** command, item 11.

**7. Dragging, re-parenting, and direct manipulation**
Nodes, submodels (carrying contents and boundary ports), labels (stored as an
offset from the notation's default anchor), ports, and influence curvature — all
one undo step per gesture, with nothing written until the drop. Dropping a node
in a submodel re-parents it. Click selects (blue ring), shift/ctrl adds, and a
multiple selection drags together.

**8. Grammar engine — `src/grammar.js`**
Evaluates the schema's rules; contains no rule of its own. All four §12.4
callers exist: `mayConnect` (refuses an illegal arc mid-gesture), `mayContain`
(placing and dropping), `validate` (whole model, reported never blocking, wired
to a **check model** button), and `behaviour` (how to draw — read from the
vocabulary). Rules quantify over derived facts: `parentKind` matches the
inferred *conditional* and *association* kinds as well as the declared one.
The escape hatch is a named predicate in `Sienna.grammar.predicates`; an unknown
name throws rather than silently passing.
*Note: submodel CAPTURE reports rather than refuses — boxing a flat model and
then declaring the box a population passes through an illegal state on purpose.*

**9. Property dialogs — `src/dialog.js`**
Modal, per element type, driven by the schema's field model; an optional HTML
template can replace the generated form, bound by the same `data-field` rule.
OK writes label + props + direct fields in one action; props are merged, not
replaced. Labels are validated, equations are not (stored verbatim).
*Caveat: the property lists themselves are first drafts — to be checked against
Simile type by type.*

**10. View and selection commands — a second row in `src/widgets/diagram.js`**
Plain text buttons, notation-independent (nothing here is read from the schema,
because zooming means the same whatever is drawn): zoom in / out (stepped, about
the panel centre, where the wheel zooms about the pointer), **fit**, **100%**,
**re-centre**, and **select box**.

"100%" is not the identity: the notation's world units are small enough that a
true 1:1 is unreadable, so what it restores is the `defaultScale` option,
**1.8** (set 2026-08-06 by eye) — the first candidate for the Diagram widget's
Settings dialog when there is one. And unlike the stepped buttons it re-centres
as well as re-scales. That was a bug found in testing: hold the panel centre
still and the command faithfully keeps whatever distant spot happens to be
there, so a view that has got away from you — maximise a panel after panning
and the stale transform maps the new centre a long way off — restores to blank
canvas. Restore-default is the command you reach for when lost, so it now always
ends up looking at the model.

Both open questions were settled as the notes predicted. Select box is an
**armed tool**, like a palette entry — that is what keeps it from colliding with
pan, which owns a blank-canvas drag; Escape drops it, and it disarms after one
band, as placing does. And "encloses" is now literally the same test as submodel
capture: `_enclosedBy` was promoted to `Diagram.enclosedBy` and both call it, so
wholly-inside/siblings-only cannot drift apart between the two. Which siblings
is decided by where the drag *started* — begin inside a submodel and you band
its children. Shift/ctrl adds, as for a click.

Two changes fell out of exposing `_fit()` as a command. It now measures the
**SVG** rather than the whole widget (the toolbars above it are not canvas, and
the view transform is measured from the SVG's own origin — with two rows the old
reckoning was visibly off), and it **centres** rather than framing from the
top-left, since `maxFitScale` otherwise strands a small model in the corner.
That also improves the automatic fit on first paint. An explicit fit counts as
the user's view, so a later resize does not silently re-fit over it.

**11. Ungroup — `Diagram.ungroup` + an `edit` group in the palette**
Dissolve a submodel, keep its contents: the opposite intention to deleting it,
which takes them with it, hence a command of its own rather than a modifier on
delete. Only the **immediate children** move — anything deeper stays inside its
own submodel, which is promoted intact — and the promoted contents are left
selected, being what the user still has in hand.

The reuse that made it small: promote the contents *first*, then ask
`deletionClosure` about the box, which by then covers the box and the arcs
attached to it but not its contents. So an arc that cannot survive the box (a
role arc *to* the submodel) goes with the usual valve/cloud consequences,
without any of those rules being restated. The removal writes were factored out
of `remove` into `_purge` so both can share them inside one action — ungroup
promotes, deletes and re-seeds ports in a single dispatch, so a gesture is one
undo step. A breach created by the promotion is reported, never refused, as
submodel capture is (§12.5); the button flashes when nothing is selected.

The palette's first row now ends `… | EDIT ungroup | CHECK check model`, which
keeps the division the two rows already had: row one changes the model, row two
does not.

**12. Equation parser — `src/equation-grammar.js` + `src/equation.js`**
*(Full account of the reasoning: `DESIGN-diagram.md` §19.)*
A PEG for the Simile expression language, compiled by the vendored Peggy
(`vendor/peggy.min.js`, 4.2.0) on first use. Two calls: `parse(text)` for the
red/black colouring, and `references(text)` for the cross-check against the
influence arrows actually drawn — the latter being the valuable one, since a
reference carries its **form** (`x`, `{x}`, `[x]`), so a `{x}` with no influence
out of a variable-membership submodel is a real error, not a stylistic one.

**Where the language came from.** Not invented: the ladder, the
`if/then/elseif/else` and the local-variable form are from your own
`SimileProlog_SimileXMLv3_MathML.xsg` (2007), which is the only complete
statement of the language — simulistics.com documents the functions and the
arithmetic operators but never the conditional or the boolean layer, whence
`//` and `%`. Rulings of 2026-08-06: strict identifiers (the same rule §14
enforces for element names); comma-as-`and` and semicolon-as-`or` dropped; the
local-variable form kept; **parse only** — function names and arities belong in
the schema, checked afterwards, so that adding a function (or letting a user
declare one) never touches the grammar, and "no such function" reads as a
different report from "that is not an expression".

Four departures from the XSugar grammar, all deliberate: `+ - * / // %` are
left-associative (XSugar writes them right-recursive, making `a-b-c` mean
`a-(b-c)` — a bug); `^` stays right-associative; identifiers are strict; the
Prolog boolean spellings are gone.

**The function table** is `functions` in the schema: name → arity, where a
number is exact and an array is the SET of allowed counts (`at_posn: [1,3]`
means one or three, never two). Names and arities come from the five function
pages of the help; the 41 marked ✓ are confirmed by use in the reference
models, which also settled a discrepancy — the help calls `pi()` and `time()`
nullary, real models write `pi(1)` and `time(1)`, so they take an optional
dummy argument. The rest are a first draft, to check type by type like the
property lists.

**The cross-check** is `src/equation-check.js`, its own file because it is the
only thing that knows all three of parser, model and schema — and expressly not
part of `src/grammar.js`, whose contract is that it holds no rule of its own and
evaluates only the schema's graph rules. Four findings, all deferred: `syntax`,
`function` (unknown name or wrong arity), `undeclared` (a name no influence
supplies) and `unused` (an influence whose name the equation never mentions).
The last two are the point of the exercise and neither a parser nor a diagram
could produce them alone; they compare on the influence's **alias**, which is
exactly the name the target's equation is meant to use (§14.1). `unused` stays
quiet until an equation exists, since arrows are normally drawn first, and both
stay quiet when the equation does not parse — a missing bracket would otherwise
report every arrow as unused. "Check model" now runs the graph pass and this
one and concatenates them.

It found a real error in our own demo fixture on first run: `growth`'s rate is
`k * biomass`, and only `k` has an influence.

**Testing — `test/index.html`.** Open it; it runs the grammar over
`test/corpus.js` and colours a bar. 1500 distinct (model, equation) pairs
harvested from the 72 reference models, of 1678 occurrences: **1488 parse, 12
known exclusions, 0 unexpected, ~200 ms**. No build step, in keeping with the
rest of the project. The corpus is committed because the models it came from
are outside this repository.

The 12 exclusions are all the dropped Prolog notation, `(a,b,c)` for and and
`(a;b;c)` for or, in nine models — confirmed 2026-08-06 to stay out.

Five things the corpus taught that no document states, all now in the grammar:
`&&` and `||`, bare `!`, `not` without brackets, the quoted `'!='`, and that a
quoted `'name'` is a *name* (XSugar maps it to MathML `<ci>`), so
`'Change_coefficient' != 0` is a reference and not a string.

**13. Red/black completeness — `completeness()` + `_incomplete()` in the widget**
*(Reasoning: `DESIGN-diagram.md` §19.9.)*
An element is red when it is not runnable, on five counts: a required field left
empty, an equation that does not parse, an unknown function or wrong arity, a
name no influence supplies, and — the one Simile does not check — an influence
whose name the equation never mentions. That last is a ruling: **the diagram is
the specification**, so an equation that ignores an arrow contradicts what the
modeller has said the value depends on. It parses; it is still wrong.

Which fields are required is schema data — `required`, and `requiredWhen` for
`dimensions`, which applies only to fixed-membership submodels and would
otherwise leave every single-instance one permanently red. A cloud has no
required fields and so is never red.

**Derived at render, never stored.** Simile keeps `complete=true` in the file;
we do not, because completeness depends on the arrows too — drawing an influence
elsewhere can redden an element whose equation nobody touched. The cost is a
parse per equation per render, so `src/equation.js` now memoises on the equation
text: 200 distinct equations cost 46 ms cold and 0.2 ms cached, and a whole
render of the demo model is ~1.5 ms.

**Leaving the dialogue:** Cancel reverts; **OK always commits**, in all five
cases, keeping what was typed and leaving the element red. A bad *label* is
still refused, which is the deliberate asymmetry of §12.3 — naming is structural
and preventive, equations are content and deferred.

Both demo fixtures were wrong and are fixed: `growth`'s rate is `k * biomass`
and only `k` had an influence — found by the check itself, not by reading.

**14. File save and open — mostly the shell's**
New / Open / Save / Save as / the model list live in `Sienna.documents`, with
`Sienna.files` wrapping the Save dialog and the file chooser. Verified by
round-trip: save `models/plant`, re-import the captured JSON, and the model,
layout, ports and props come back identical, at a fresh path so two saves of one
original cannot collide.

*(This item was listed as unstarted long after the shell's File work of
2026-08-04/05 had landed — the entry, not the feature, was missing.)*

What was genuinely missing was on simile's side of that boundary — **what makes
a file ours** (§18.1: the shell never inspects contents):

- **A format version.** `Diagram.FORMAT`, stamped into every new model. Added
  now precisely because it cannot be added later — a file already saved without
  a version can never be told apart from a future one. Files predating it have
  no key and are read as 1.
- **A real `validate`.** It checked only for `nodes` and `arcs`, so a model in
  another notation imported happily, joined the model list, and failed only when
  a panel tried to draw it — a document you could not open and no reason given.
  It now refuses a foreign or unnamed notation, and a file from a newer format,
  each with a sentence that completes the shell's "Could not open that file: …".
- **One empty-model shape.** `Diagram.emptyModel` — the File menu's factory and
  `Diagram.create` were separately spelling out what a new model looks like, and
  the format stamp would have had to go in both.

**A real Save** (shell change, 2026-08-06, sienna `5bb8468`). Save was a
download, so every save made `Plant.json`, `Plant (1).json`, `Plant (2).json` —
a Blob download cannot overwrite. It now uses the **File System Access API**:
the Save dialog returns a *handle*, which can be written through again without
re-prompting, so File ▸ Save writes straight back to the file and File ▸ Save
as… asks for a new one. The assumption that had gone unexamined here is that a
page may not write files at all; the actual rule is that it may not write files
the *user did not choose*, and a handle is that choice. Chromium-only, so
Firefox and Safari keep the download and Save means Save as. The same change
stopped `download()` swallowing a refused download, which had made a failed save
indistinguishable from a successful one.

**15. The two reference models, built — `src/demo-landuse.js`, `src/demo-farmers.js`**
§9's two test cases, built for real at last: **land-use change** (PATCH
fixed-membership of 1600, FOREST and CROP conditional by containing a condition,
NEXT_TO a **self**-association with two role arcs from the same submodel) and
**farmers & fields** (VILLAGE holding FARMER population, FIELD
fixed-membership, and OWNERSHIP as a **two-party** association). Between them
they cover both association topologies, all three membership kinds, the
population symbols, inferred conditionality, and influences crossing boundaries
in both directions. Both now pass the graph rules and the equation check with
nothing reported.

They earned their keep immediately — **four defects, none of which any smaller
model would have shown**:

- **The `influence-target` rule was too narrow.** It refused an influence into
  an exterminator, whose whole expression is `wealth<10`. It was tagged
  `confidence: 'guess'`, so this is §12.7 working exactly as intended. The legal
  targets are now the types that *carry an equation* — the four population
  symbols included, with the reason written down so the next type added is
  considered.
- **Role arcs had no style at all.** No `.slx-arc-role` rule existed, so they
  drew with the browser default: effectively invisible. Now dashed and
  mid-weight — structural rather than a flow of anything.
- **Role arc labels were never drawn**, though §14 calls role "the one arc type
  with a label". An association's whole meaning is in `owns` / `owned`, so it
  was unreadable.
- **Two arcs sharing both endpoints were drawn pixel-identical.** That is
  precisely the shape of a self-association, so land-use showed `me` and
  `my_neighbour` as one arc. Arcs sharing a pair now **fan**, derived at paint
  time from the endpoints with nothing stored; drag one and the stored bow takes
  over as before. See §7.5.

Two more the models expose that are **notation questions, not bugs**, so they
are left for a ruling rather than invented:

- ~~**The four population symbols have no glyph.**~~ **Built 2026-08-06** —
  see item 16.
- ~~**A submodel's kind is invisible.**~~ **RULED and built 2026-08-06** — see
  item 16.

**16. Notation made visible — membership kinds, and the population glyphs**
Ruled 2026-08-06, straight off the reference models, where `single`,
`fixed-membership` and `population` were indistinguishable:

- **fixed-membership** — a **stack four deep**, offset **down and to the
  right**: a known number of instances, drawn as a deck seen from the front.
- **population** — an **open shadow**: one edge along top-and-left, another
  along bottom-and-right, deliberately *not* meeting at the two corners
  between. The gaps carry the meaning — an outline that does not close says the
  membership is not fixed.
- **single** — no mark at all. One instance needs none.

Which decoration is schema data (`style.submodel.byKind`); how to draw one is
the renderer's, exactly as for the `cloud` and `valve` shapes. Decoration only:
the box remains the hit target, so selection and dragging are untouched.

**The four population symbols now have glyphs too**, taken from Simile's
toolbar icons (`simulistics.com/help/concepts/object/`, read off the 16×15 GIFs
themselves since the page describes them only by filename):

| symbol | icon | drawn as |
|---|---|---|
| initialiser | a sprouting mound | dome on the baseline, stem and two rays above |
| migrator | a wandering line | a zigzag |
| reproduction | an egg | an oval narrower at the top |
| exterminator | an axe | diagonal handle, wedge blade |

They are the *idea* of each icon reduced to strokes, not a copy: the originals
are colour bitmaps at one fixed size, these are ~18-unit line drawings that have
to survive being zoomed out. Worth checking against the in-diagram symbols when
convenient — only the toolbar versions were available.

**17. Label ≡ name reaffirmed (§14)**
Building land-use turned up that Simile does *not* do this — `landuse1b.pl`
names a compartment `time under crop` while its equations say
`time_under_crop`, so Simile keeps a display label and derives the name. Put to
the user, the ruling stood: one string, underscores, no spaces. The reason is
recorded in §14 because it is a judgement rather than a technical necessity —
formality is worth a little unnaturalness, and there should not be two ways of
expressing the same thing.

**18. Geometry against containment — `src/predicates.js`, deferred rules**
Does the picture agree with the model about what is inside what? Two rules,
`inside-its-parent` and `not-inside-a-stranger`: an element must be drawn inside
the submodel it belongs to, and not inside one it doesn't. Ancestors are exempt
— being inside your grandparent's box is expected.

Ruled worth having 2026-08-06 even though a *dropped* element cannot disagree
with itself, because dropping is not the only way a model gets built: **an AI
assistant writing one, or an automatic graph layout moving things**, both bypass
the gesture and have no reason to keep model and layout in step. The check
exists for the ways of building a diagram we do not have yet.

**Deferred, never preventive** — dragging an element out of a submodel is
precisely how you re-parent it, and the drop decides; refusing mid-gesture would
fight direct manipulation. Excluded from judgement: elements that do not exist
yet (`mayContain` asks about prospective ones), and types positioned by
something else — a valve rides its flow's midpoint, so a boundary-crossing flow
strands it outside its parent and the modeller can do nothing about it.

The predicates are code, so they live in their own file; the schema names them
and stays plain data (§12.2's escape hatch, first real use).

**Two things this turned up.** `rulesFor` filtered to preventive rules and
`validate` used it, so **a rule tagged `deferred` was evaluated by nobody** —
the class existed in §12.3 and in the schema and did nothing. Unnoticed because
every rule written so far happened to be preventive. And `subject` gained `'*'`,
for a rule that genuinely does not care about family; the alternative was the
same rule written once per family, which drifts.

It found a real fault on its first run: the plant fixture's cloud straddled
PLANT's left edge while being parented to it. Fixed — the third fixture defect
an automated check has caught this session, after growth's missing influence and
`children` sitting outside FARMER.

**19. Name uniqueness — scoped to the submodel (§14.2)**
The scope was **measured, not asked**: across the 72 reference models a name
repeats in *different* submodels 493 times and within one submodel 3 times, and
Simile's own auto-generated names restart at `fn1` inside each submodel. So the
same name may, and often will, appear in several submodels — §8 has carried this
as an open question since July and it is now closed.

Three enforcement points, deliberately different:

- **typing** a name a sibling already has — **refused**, on both paths (inline
  rename and the property dialog). Typing a name asserts that name.
- **dropping** an element beside a same-named sibling — **auto-renamed**,
  `biomass` → `biomass_1`, `_2`… A drop asserts containment; the clash is
  incidental and halting the gesture over it would be obstructive. Ungroup's
  promotion takes the same path. The rename happens inside the action that
  moved the element, so one undo restores both.
- a model that **arrives** with clashes — **reported**, by a third deferred
  rule (`sibling-names-unique`).

**No equation is rewritten, and none needs to be** — the surprise here. §14.1's
alias is copied at arc creation and never re-synced, so a target's equation
refers to its own local name for the imported value, never to the source's
label. Rename a source and every downstream equation still works, verified.
That ruling was made weeks ago for a different reason and this is it earning its
keep. Rewriting equation text is no longer impossible either, now the parser can
locate each identifier exactly — just unnecessary.

**20. Replay — a Session menu, and six handlers**
The marker of 2026-08-06, done. Every model edit already went through
`actions.dispatch`, so a session was always on tape; what was missing was any
way to run it and any way to put the *panels* back.

- **Six `onReplay` handlers** for `panel.add` / `close` / `move` / `resize` /
  `minimize` / `maximize`. Model edits still need none — replay re-applies each
  entry's captured `changes` and `_watchModel` redraws.
- **A Session menu**: Watch replay, Replay at once, Save session log…, Open
  session log… Saving is not a nicety: the log is in memory only, so it is the
  only way a session outlives its tab.
- **Paced timing for "watch".** Real timings are useless as video — think for
  two minutes, then fire six actions in a second. Every gap is clamped into
  150–1200 ms before replaying, which gives an even cadence. A speed multiplier
  cannot do this: it scales every gap equally, so the pauses still dominate.

**Verified:** build a session (demo seeding + a panel + edits + a rename), then
Replay at once through the actual menu — 52 actions, and the result is identical
in models, nodes, arcs, ports, labels, and the panel with its `ref`.

*That check was necessary but not sufficient, as watching a replay then showed
— see below.*

**The guard, which is the interesting part.** The log lives in memory while the
models live in `localStorage`, so the two part company at every reload: come
back later and you have four models and an empty log, and replay — which must
start from a clean slate — would delete all four and rebuild nothing. A general
warning is not good enough when the condition is exactly checkable, so the
confirmation names the models the log *cannot* rebuild. A model counts as
rebuildable only if some change writes the WHOLE of it (`models/growth`), never
merely something inside it: a log holding one rename would otherwise claim it
could rebuild the model and replay a stub with a single label in it.

**Two shell fixes fell out.**

*Timers* (sienna `414c10a`): replay put a `setTimeout` between steps even at
speed 0. A background tab clamps timers to ~1/second, so a 54-action replay took
the better part of a minute and looked hung. Unpaced replay now stays in
microtasks: **~54 s → 82 ms**, which also makes replay-as-test-fixture practical
rather than theoretical.

*The log was not immutable* (sienna `6c47320`) — the serious one, and found only
by **watching** a replay instead of checking its end state. The land-use model
did not build up: the panel opened empty, the whole finished model appeared in
one step, and the remaining fifteen actions changed nothing. `userData` stores
by reference and the log captured by reference, so writing deeper into a model
mutated the very object the log held: the recorded "create an empty model"
quietly became the finished model. The same on the way out — `applyChanges`
handed the recorded object straight back to `userData`, so a log was faithful
the *first* time it was replayed and wrong every time after, and `history` had
it too, so undo could rewrite its own stack. Captured values are now snapshots
in both directions.

**The lesson worth keeping:** checking the end state cannot tell a faithful
replay from a lucky one. The earlier verification passed because the first entry
already contained everything. Only watching the middle catches that.

---

## Known gaps and loose ends

- A flow that crosses a submodel boundary leaves its **valve** where it lies —
  possibly outside its own parent. Types positioned by something else are
  therefore exempt from the geometry rules of item 18, since the modeller can
  do nothing about it; fixing the valve's placement would close both.
- Models built before the valve became derived keep a dead `layout` entry for it.
- **Ghosts** are deliberately out (§15); `appearanceOf()` is the seam for adding
  them later.
- Whether a **role arc** can join submodels at different nesting levels is
  unanswered — nothing depends on it, since flows already prove segments are
  needed.
- When the last arc through a port is deleted, is a dragged port position
  forgotten or remembered? Undecided (§13.4).
- Influence curve geometry is an **arc of a circle** provisionally; quadratic and
  spline remain open (§7.5), and the choice interacts with waypoints if those
  arrive.
- No waypoints on arcs yet — curvature is the only shape control.
- Browser **script caching** bites during development: hard-reload (Ctrl-Shift-R)
  after pulling changes, or the injected widget script may be stale.
- A model **forgets its file on reload**: the Save handle lives in memory only,
  so the first Save after re-opening the page asks where again. Persisting
  handles is possible (IndexedDB) but a document silently remembering a file
  from a previous day wants deciding first.
- A real Save needs the **File System Access API**, which is Chromium-only.
  Firefox and Safari fall back to a download, where Save means Save as.
- **Nothing warns of unsaved changes.** Edits autosave to `localStorage`
  continuously, so nothing is lost, but the *file* on disk goes stale silently
  until the next Save — and no window title or marker says so.
- **The action log does not survive a reload**, while the models do — the
  asymmetry item 20's guard exists to protect against. Session ▸ Save session
  log is the workaround, and it may be answer enough.

  Persisting it automatically is a **sienna** decision, not ours, and a bigger
  one than it looks:

  - *Size.* The log is a history of VALUES, not of references: each entry
    carries the before and after of every path it touched. Measured on nothing
    but the four demo models being seeded — 50 actions, no editing — the log is
    **23.4 KB against 6.3 KB of actual model data, 3.7×**, the largest single
    entry being a `diagram.create` at 2.4 KB. Editing is cheaper (~218 bytes a
    drag), but thousands of actions in an afternoon is ordinary, so ~5,000
    actions ≈ 1 MB. Nothing caps or trims it; `log` is only ever pushed to.
  - *Where it would hurt.* `localStorage` is ~5 MB per origin, SHARED with
    `userData`, which already rewrites its whole blob on every mutation. A
    persisted log would do the same, so edits slow as it grows — and when the
    quota goes, `persistence.js` degrades to a silent no-op. The failure mode is
    that **models stop saving because history filled the disk**, with no error.
  - *It drags undo with it.* `Sienna.history` builds undo from the same entries,
    so "persist the log" immediately asks "does undo survive a reload?" —
    undoing into last week's state is a much larger semantic change, and wants
    separating before either is touched.
  - *The shell has evidently chosen.* `userData` persists, the workspace
    persists, the log does not: two out of three is a pattern, not an oversight.

  If it is ever wanted, the shapes worth considering are a byte cap with
  oldest-first eviction, or persisting only on unload.

---

## Open questions for the Simile developer

Carried in `DESIGN-diagram.md` §8, still outstanding:

- the remaining **label-typography** rules, beyond no-spaces. *(The uniqueness
  half of this question is answered — scoped to the submodel, measured from the
  corpus rather than asked; item 19.)*
- whether the **population glyphs** now drawn (item 16) are close enough to
  the real in-diagram symbols — only the toolbar icons were available;
- the remaining **grammar rules** — §12's catalogue is a starter set, each rule
  tagged `known` or `guess`;
- **association and conditional inference**: stored flag or recoverable?
- whether the `.sml` format separates logical structure from **layout** at all;
- **condition symbols**: placement constraints, and what the expression may
  reference;
- **vocabulary drift** — are `event` / `state` / `squirt` / `satellite` later
  additions to the canonical set?
- how **ghosts** are stored (only if we revive them, §15);
- **equation function arities** — we have ~110, but only the 41 used by the
  reference models are confirmed; the rest are from the help pages alone;
- **array vs list dimensional rules** — must `{x}` always come from a
  variable-membership submodel and `[x]` from a fixed one? If so the equation
  cross-check gets sharper at no cost (§19.8).

**No longer asked:** the per-type **red/black** rule. Ruled ours to decide
(§19.9, 2026-08-06), on the governing principle that we are not bound to
reproduce Simile — and ours is the stricter rule, since it also reddens an
element whose equation disagrees with the influences drawn into it.
