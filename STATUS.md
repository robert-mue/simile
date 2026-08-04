# simile — build status

*A quick-reference companion to `DESIGN-diagram.md`, which remains the design record.
Last updated 2026-08-04.*

Ordering follows the implementation plan agreed on 2026-08-01: schema → model layer →
render → §13 ports/segments → creation → deletion → dragging → grammar engine.

---

## Done

**1. Schema — `src/schema/simile-v1.js`**
All four faces of §3 in one file: naming rule, vocabulary (node/arc types with
per-type facts — `has_label`, `autoCreated`, `positionedBy`, `branches`,
`attachmentNode`, `blankEnd`), the grammar rules, the styling defaults, and the
dialog **field model**. Swapping this file is what changes notation.
*Caveat: rules are declared but nothing consults them (see Not started).*

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

**9. Property dialogs — `src/dialog.js`**
Modal, per element type, driven by the schema's field model; an optional HTML
template can replace the generated form, bound by the same `data-field` rule.
OK writes label + props + direct fields in one action; props are merged, not
replaced. Labels are validated, equations are not (stored verbatim).
*Caveat: the property lists themselves are first drafts — to be checked against
Simile type by type.*

---

## Not started

**6. Deletion.** No way to remove anything; undo is the only way back. Needs the
lifecycle rules already decided: a valve dies with its flow, a cloud is
refcounted, and an element's arcs must go with it.

**8. Grammar engine.** The rules exist in the schema and are **never consulted**,
so any connection or containment can currently be made. Design is settled
(§12): three enforcement classes — preventive, deferred, behavioural — and four
callers. Awaiting more rules from the Simile developer, though enough exist to
build against.

**Saving to a file.** Models live in browser `localStorage` only. No export or
import, so a hand-built model does not survive a different browser.

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

---

## Open questions for the Simile developer

Carried in `DESIGN-diagram.md` §8, still outstanding: the full label-typography
rules and whether name-uniqueness is submodel-scoped; how ghosts are stored (only
if we revive them); the remaining grammar rules; and the exact per-type
completeness (red/black) rule.
