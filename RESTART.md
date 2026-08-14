# Restart note

*Rewritten 2026-08-13, at the end of two days on the Simile converters and one
afternoon on dialogs. If you are picking this up cold — a new session, a new
machine, or a week later — read this first. `STATUS.md` is the full record;
this is the part you need to get moving again.*

---

## Where things stand

**Everything is committed and pushed.** Working tree clean on `main`; run
`git log --oneline -1` for where. Nothing is half-finished and there is no
branch to remember.

The loop is closed in both directions: a model built in this editor converts to
Simile Prolog, uploads, compiles and runs on the Simile engine with its results
drawn in our own panels; and a Simile `.pl` or `.sml` reads back into one of our
models. `STATUS.md` items 27–45 are that work.

**Standing numbers.** Quote these only after re-running the checks below, since
they are exactly what a regression would change:

| | |
|---|---|
| catalogue round trip | **54 of 72 identical, 0 differ, 18 refused, 1 lossy import** |
| fixtures | 6 of 6 reach a fixed point and audit clean |
| equation grammar | 1391 of 1412 parse, 21 known exclusions |

**But note what "identical" does and does not mean** — see the traps below. It
is the strongest cheap check, not a complete one.

## Check nothing has rotted, in three minutes

No build, no npm, no server. Open each page and read the coloured bar.

1. **`test/fixtures.html`** — needs nothing. Green means the converters and the
   completeness check still agree with all six demo fixtures.
2. **`test/index.html`** — needs nothing. The equation grammar over the corpus.
3. **`test/roundtrip.html`** — press the button and select all 72 `.pl` files in
   **`reference/catalogue/`**. The slow one, and the one that matters most.

Then open `index.html` itself and check the devtools console is clean.

## Jobs queued

### 1. Dialogs — where the work was heading

This is what Robert wants to get onto: **the dialog boxes for nodes and
submodels**, plus cosmetic adjustments towards Simile's look and feel (without
being bound by it).

Groundwork is done. `Sienna.dialogs.register(key, renderer)` now owns the
presentation, so a custom dialog is a script that registers itself; a renderer
is handed the element, the field model, the whole schema, the `Diagram`, and
`ctx.field(name)` / `ctx.fields()` — the standard rows — so it can replace one
field's presentation without hand-writing the whole form. Item 45.

**The obvious first job: there is no arc dialog at all.** An influence's alias
has never been editable, and `Diagram.setRoleAlias` (item 43) has nothing
calling it. Adding one finishes per-role aliases properly *and* fills a real gap
— `specFor` in `src/dialog.js` only looks at `schema.nodes` and the submodel, so
an arc currently falls through to an empty field list.

**One thing owed:** the dialog registry change has NOT been seen on screen.
Chrome's extension was disconnected when it was written. The generated-form path
is byte-for-byte the same expression as before, but open a dialog and confirm.

### 2. Event-based modelling

Deliberately set aside at the start; Robert has never used it. `alarm` is
declared, drawn as a bell, read and written faithfully, and **disabled in the
palette** (greyed, dashed, titled "Not yet implemented", from a
`notImplemented` flag in the schema). One symbol is not enough to do event
modelling; what else it needs is unknown and unasked.

### 3. An inspector widget — noted, not started

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
3. *(New, question 0b in `NOTE-questions-for-developer.md`.)* **What does N mean
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
- **The scratch directory is `/tmp` and does not survive a reboot.** It has been
  wiped twice, taking every analysis harness with it. That is why the regression
  net lives in `test/` as pages. Put anything you want to keep in the repo.
- **Chrome caches the app's scripts hard.** A change can appear not to work. In
  the devtools console:
  `for (const u of ['src/schema/simile-v1.js','src/dialog.js']) await fetch(u,{cache:'reload'}); location.reload();`
- **`file://` and `http://localhost` are different origins**, so they have
  separate stored models. A test on one cannot see the other's.
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
- **Current Simile is 7.4**, file format 11.4, `edition=free` — which is what
  our exporter's `source(…)` line now claims, measured rather than copied.
