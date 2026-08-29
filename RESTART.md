# Restart note

*Rewritten 2026-08-29, at the end of the first day the editor was used to BUILD
a model by hand rather than by a test. If you are picking this up cold — a new
session, a new machine, or a week later — read this first. `STATUS.md` is the
full record; this is the part you need to get moving again.*

---

## Where things stand

**Everything is committed and pushed**, in both repositories. Working tree clean
on `main` here and in `sienna/`; run `git log --oneline -1` in each for where.
Nothing is half-finished and there is no branch to remember.

The loop is closed in both directions: a model built in this editor converts to
Simile Prolog, uploads, compiles and runs on the Simile engine with its results
drawn in our own panels; and a Simile `.pl` or `.sml` reads back into one of our
models. `STATUS.md` items 27–45 are that work.

**What changed on 2026-08-29**, and it is a different KIND of change from
everything before it: Robert opened the app and built a model, and four bugs
fell out within minutes that no test on this repo could have caught, because
every test drives the model layer directly and never touches the store, the
view, or the undo stack the way a hand does. See "What hand-use found" below —
the lesson is worth more than the individual fixes.

**Standing numbers.** Quote these only after re-running the checks below, since
they are exactly what a regression would change. All three re-measured
2026-08-29, after the naming change:

| | |
|---|---|
| catalogue round trip | **54 of 72 identical, 0 differ, 18 refused, 1 lossy import** |
| fixtures | 6 of 6 reach a fixed point and audit clean |
| equation grammar | 1391 of 1412 parse, 21 known exclusions |

**But note what "identical" does and does not mean** — see the traps below. It
is the strongest cheap check, not a complete one. The complete one is running a
model on SimiLive, which `growth` and `drain` both did on 2026-08-29.

## Check nothing has rotted, in three minutes

No build, no npm, no server. Open each page and read the coloured bar.

1. **`test/fixtures.html`** — needs nothing. Green means the converters and the
   completeness check still agree with all six demo fixtures.
2. **`test/index.html`** — needs nothing. The equation grammar over the corpus.
3. **`test/roundtrip.html`** — press the button and select all 72 `.pl` files in
   **`reference/catalogue/`**. The slow one, and the one that matters most.

Then open `index.html` itself and check the devtools console is clean.

**None of that exercises the editor.** Add a stock, drag it, name it, undo it.
Four of the day's five bugs lived in the half-second between a click and the
picture, and all four pages above were green throughout.

## What hand-use found (2026-08-29)

Recorded because the pattern matters more than the bugs, and because the same
blind spot will produce the next four.

- **A node placed by hand vanished.** `_put` wrote an element and its layout as
  two `userData.set` calls, and `set` notifies subscribers synchronously — so
  there was a render BETWEEN them in which the node existed with no position.
  An element with no layout draws at the origin, `_fit` framed the view on that
  phantom, and the real position then put the node off-screen. Layout is now
  written first, so the intermediate state renders as nothing at all.
- **The initial fit fired on content the user placed.** Fit is for content that
  ARRIVES — opened, imported, restored. `_placedByHand` rules it out ahead of
  the write.
- **Symbols drew at half size.** The view started at k=1, which is not what this
  app calls 100%: the view bar's "100%" restores `defaultScale` (1.8). It starts
  there now — and that exposed a third fault, that nothing applied the initial
  view to the root transform, so `_view` was believed by `_toWorld` and not by
  the picture.
- **Undo appeared dead**, from two unrelated causes at once. In the shell,
  `menu.select` wraps a menu item's effect in a transaction, so Edit ▸ Undo was
  captured into it and pushed back onto the undo stack — the menu alternated
  undo and redo forever while Ctrl-Z worked perfectly (`actions.detached`). In
  the app, committing an unchanged rename recorded a no-op transaction, so every
  element left with its default name laid a dead step on the stack.

The common thread: **the tests own the model layer, and every one of these lived
above it.** A regression net for the editor itself does not exist. That is the
most valuable thing this note can tell you.

## Naming, as of 2026-08-29

- A **`compartment` is a `stock`** throughout the code — schema, rules, messages,
  style, CSS, demos. `.pl` and `.sml` still say `compartment`, because that word
  belongs to Simile's format; both converters map through an explicit table.
- **Stored models are migrated, not aliased.** `Diagram.migrate` rewrites the old
  spelling, `FORMAT` is 2, and it runs over the store at startup and over
  anything File ▸ Open reads. A file saved now is refused by an older build.
- A new element is **named after its type** — `stock1`, `variable2`, not
  `node5`. Numbering restarts inside each parent (uniqueness is a sibling rule).
- A **valve is called `flow1`**: the node is a valve and holds the rate, but what
  a modeller names is the process. One `labelStem` in the schema. Confusing, and
  adopted knowing it — see DESIGN-diagram.md §22.

## Jobs queued

### 1. A regression net for the EDITOR — new, and now the first job

Everything above argues for it. What is missing is a page that drives the
*widget*: arm a tool, click, and assert where the element landed and what the
view did. Hard, because it needs a DOM and a real panel; worth it, because five
bugs in one afternoon all lived exactly there and the three existing pages
cannot see any of them.

### 2. Dialogs — where the work was heading before

**The dialog boxes for nodes and submodels**, plus cosmetic adjustments towards
Simile's look and feel (without being bound by it).

Groundwork is done and CONFIRMED on screen. `Sienna.dialogs.register(key,
renderer)` owns the presentation, so a custom dialog is a script that registers
itself; a renderer is handed the element, the field model, the whole schema, the
`Diagram`, and `ctx.field(name)` / `ctx.fields()` — the standard rows — so it
can replace one field's presentation without hand-writing the whole form.
Item 45.

**The obvious first job: there is no arc dialog at all.** An influence's alias
has never been editable, and `Diagram.setRoleAlias` (item 43) has nothing
calling it. Adding one finishes per-role aliases properly *and* fills a real gap
— `specFor` in `src/dialog.js` only looks at `schema.nodes` and the submodel, so
an arc currently falls through to an empty field list.

### 3. Event-based modelling

Deliberately set aside at the start; Robert has never used it. `alarm` is
declared, drawn as a bell, read and written faithfully, and **disabled in the
palette** (greyed, dashed, titled "Not yet implemented", from a
`notImplemented` flag in the schema). One symbol is not enough to do event
modelling; what else it needs is unknown and unasked.

### 4. An inspector widget — noted, not started

A persistent, editable side panel following the selection. Genuinely wants to be
a widget, unlike a dialog. Robert is right that the dialog/inspector line is
blurred — an editable side panel does a dialog's job. The real difference is
**lifetime and modality**, and that is what an inspector has to answer for:
panels are persisted and restored, their `ref` is seen by
`documents.currentPath`, and `panel.add` goes into the replay log. Item 45 has
the detail.

## Waiting on the developer

`NOTE-email-population-symbols.md` is **drafted and NOT sent**. Three questions
now, all things a file cannot answer:

1. Is our `migrator` dialog mislabelled? It asks for a "migration condition",
   but every `immigration` node in the catalogue holds a **number**.
2. Is `loss` a probability or a condition? The catalogue shows both.
3. *(Question 0b in `NOTE-questions-for-developer.md`.)* **What does N mean
   in `use(N,in_assoc,…)`?** `feeding1`'s association joins two different bases
   and writes index 0 for BOTH consumers. Our reading says the second should be
   1; we tried it and Simile rejected the model outright. We refuse to export
   `feeding1` rather than guess — one model, and no wrong answers.

Six re-saves in Simile 7.4 already answered the population-symbol spellings, the
association-alias convention (there isn't one), `border` vs the legacy plain
`variable`, and what `alarm` is.

## Things that will bite you

- **Round-tripping is not running.** A model can reach a perfect fixed point and
  still produce Prolog that Simile refuses to build — the comparison is our
  model against itself and never asks Simile anything. Sampled 14 of the 54: 12
  build; `lamos1a` and `embryo1` do not, *though their originals do*. Item 44.
  `Sienna.Simulation.loadOwn('models/growth')` from the console is the short way
  to ask the engine; `unload()` afterwards, it is a shared public host.
- **The scratch directory is `/tmp` and does not survive a reboot.** It has been
  wiped twice, taking every analysis harness with it. That is why the regression
  net lives in `test/` as pages. Put anything you want to keep in the repo.
- **Chrome caches the app's scripts hard.** A change can appear not to work. In
  the devtools console:
  `for (const u of ['src/schema/simile-v1.js','src/dialog.js']) await fetch(u,{cache:'reload'}); location.reload();`
- **`file://` and `http://localhost` are different origins**, so they have
  separate stored models. A test on one cannot see the other's.
- **Chrome's automation extension refuses `file://` URLs outright**, so an agent
  driving the browser cannot open `index.html` the way you do. Serve the
  directory instead — `python3 -m http.server 8731` from the repo root, then
  `http://localhost:8731/index.html` — and remember the origin trap above: that
  tab has its own stored models and cannot see the `file://` ones. Note also
  that a synthetic drag through the extension does NOT reliably draw an arc,
  though clicks and typing work; arc gestures have to be checked by hand, or
  driven through `Diagram.addArc` from the console.
- **Never delete stored models** from `Sienna.userData` without asking — not on
  localhost, not "test clutter". `models/johad-test`, `models/prime-test` and
  `models/hexagon-test` are mine, on the localhost profile, and can go whenever.
- **`test/corpus.js` is generated and can go stale.** Adding an
  expression-bearing node type changes it; `alarm` was added on 2026-08-13 and
  its three equations were missing until the next regeneration. The generator
  now reads the types from the schema so it cannot happen silently again, but it
  is not run automatically.

## The catalogues are in the repo

`reference/catalogue/` (the 72 `.pl` files, all format 9.0 or older) and
`reference/catalogue-2026/` (six re-saved by Simile 7.4). Neither was in any git
repository before 2026-08-13, and the re-saves could only have been replaced by
redoing the work at the keyboard. `reference/README.md` records what they
settled. **Do not edit either** — their value is that they do not change.

## Environment

- **Run it:** open `index.html`. No build, no server, no npm.
- **First checkout:** `git clone --recurse-submodules`, or
  `git submodule update --init` — the `sienna/` shell is a submodule and the app
  will not start without it.
- **SimiLive:** `https://similive.simulistics.com`, authorised for dev and test.
  `Widgets ▸ Run control` loads and runs a model there. Uploading an exported
  model and building it is the only check that answers "does it actually run".
  `growth` and `drain` both built and ran correctly on 2026-08-29, `drain`
  confirming that flows still segment across a submodel boundary with the rate
  on the inside segment.
- **Current Simile is 7.4**, file format 11.4, `edition=free` — which is what
  our exporter's `source(…)` line now claims, measured rather than copied.
