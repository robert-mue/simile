# simile — build status

*A quick-reference companion to `DESIGN-diagram.md`, which remains the design record.
Last updated 2026-08-06.*

Ordering follows the implementation plan agreed on 2026-08-01: schema → model layer →
render → §13 ports/segments → creation → deletion → dragging → grammar engine.

**Everything on the implementation plan is now built.** What remains is the
list of known gaps below, and the questions in `DESIGN-diagram.md` §8 that only
the Simile developer can answer.

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

**7. Dragging, re-parenting, and direct manipulation**
Nodes, submodels (carrying contents and boundary ports), labels (stored as an
offset from the notation's default anchor), ports, and influence curvature — all
one undo step per gesture, with nothing written until the drop. Dropping a node
in a submodel re-parents it. Click selects (blue ring), shift/ctrl adds, and a
multiple selection drags together.

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

---

## Known gaps and loose ends

- A flow that crosses a submodel boundary leaves its **valve** where it lies.
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

---

## Open questions for the Simile developer

Carried in `DESIGN-diagram.md` §8, still outstanding:

- the full **label-typography** rules, and whether name-uniqueness is
  submodel-scoped;
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
