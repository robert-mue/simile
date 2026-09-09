# Restart note

*Rewritten 2026-08-29, when the editor was first used to BUILD a model by hand
rather than by a test; brought forward 2026-09-01 after two days on the node
properties dialog, and again 2026-09-09 at the end of a session that cleared
Robert's whole list of UI refinements. If you are picking this up cold — a new
session, a new machine, or a week later — read this first. `STATUS.md` is the
full record; this is the part you need to get moving again.*

**When to rewrite this note.** By event, not by the calendar — a note that
restates the diff goes stale faster and gets trusted less. Rewrite it when:

1. **the queue changes** — a job finishes, a new one appears, or a decision is
   deliberately left open;
2. **before any deliberate stop** — end of session, end of day, before travel;
3. **when a trap is found**, while it is fresh and while the wrong version of it
   is still doing damage.

Not for code that merely accumulates: the commit messages here are long on
purpose and `git log` reconstructs the rest. This note carries only what the log
cannot — what is next, what is undecided, and what will bite you. Whoever is
working the keyboard should do this unprompted; it should not need asking for.

---

## Where things stand

**Everything is committed and pushed**, in both repositories. Working tree clean
on `main` here and in `sienna/`; run `git log --oneline -1` in each for where.
Nothing is half-finished and there is no branch to remember.

The loop is closed in both directions: a model built in this editor converts to
Simile Prolog, uploads, compiles and runs on the Simile engine with its results
drawn in our own panels; and a Simile `.pl` or `.sml` reads back into one of our
models. `STATUS.md` items 27–45 are that work.

**What changed on 2026-09-09.** Robert worked through a numbered list of UI
refinements from hand-testing and every item is done, verified in a running
browser and pushed. They are small individually and the design record is where
the reasoning lives (§24 the current model, §25 naming and colouring panels by
subject, §26 thumbnails and the size ladder). In one line each:

| | |
|---|---|
| 7 | a stock's label moved below the box — inside, it sat where you press to drag |
| 10 | **the current model is now an explicit, stored thing** (§24), not "whichever panel is in front"; the Run control follows it |
| 11 | the arrow cursor over elements; the hand survives only on the canvas |
| 12 | only a bendable arc shows the adjust cursor |
| 13 | a valve answers over its whole box, not just the bow-tie's ink |
| 14 | a valve's rate reads "Rate of flow." |
| 16 | **runs were 5× slower than they needed to be** — one HTTP round trip per logged point, because `updateEach` was taken from `displayInt` |
| 18–19 | the Simile menu folded into File; `Recent` and `All models` submenus |
| 20–21 | panels are titled `growth: plotter/2` and tinted per model |
| — | **thumbnails** (§26): a panel too small to work in hides its chrome and shows a miniature, with a third titlebar button between minimise and maximise |

Four of those were reported a second time after the first fix, and every one of
the second reports was the same class of fault: **a decision made from state the
user cannot see** — a title cached from creation, a toggle keyed on invisible
history, a widget waiting on an observer that never fires. Read §26.4 before
writing anything that reacts to a resize.

**What changed on 2026-08-29**, and it is a different KIND of change from
everything before it: Robert opened the app and built a model, and four bugs
fell out within minutes that no test on this repo could have caught, because
every test drives the model layer directly and never touches the store, the
view, or the undo stack the way a hand does. See "What hand-use found" below —
the lesson is worth more than the individual fixes.

**Standing numbers.** Quote these only after re-running the checks below, since
they are exactly what a regression would change. The two no-file pages were
re-run repeatedly through 2026-09-01 and have not moved; the catalogue round
trip was last measured 2026-08-29, after the naming change:

| | |
|---|---|
| catalogue round trip | **54 of 72 identical, 0 differ, 18 refused, 1 lossy import** |
| fixtures | 6 of 6 reach a fixed point and audit clean *(re-run 2026-09-09, green)* |
| equation grammar | 1391 of 1412 parse, 21 known exclusions |

The 2026-09-09 work was all above the model layer, so only `fixtures.html` was
re-run. The other two are unchanged since 2026-09-01 and 2026-08-29 respectively
— re-run them before quoting them.

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

## The node properties dialog (2026-08-31 / 09-01)

Two days' work, all of it in `src/dialog.js`, the schema, and `src/styles.css`.
DESIGN-diagram.md §23 is the record; the short version:

- **It is a NODE PROPERTIES dialog that opens on its equation**, not an equation
  dialog. Tabbed, with `Equation` first; only tabs with content are built, so
  there is one today and Styling goes beside it later without rearranging.
- **OK checks before writing.** If anything is wrong it raises a modal listing
  every finding, each with the offending stretch of the equation marked, and two
  buttons: return to the equation (nothing written, dialog still open) or close
  anyway (commits verbatim, as §19.9 rules). Checking a DRAFT rather than the
  stored element is what makes "fix it now" possible and keeps Cancel honest.
- **Aids above, equation below** — Simile's own arrangement
  (`help/equations/dialogue.htm`), which was settled by looking at the
  screenshot rather than reasoning about it. Functions and Variables are in that
  row; the KEYPAD is the third panel and is not built (parked deliberately).
- **Functions** is a collapsible tree of Simile's five groups under a `Built-in`
  root, 87 entries, each inserting `name(arg1, arg2)` at the caret with the
  first placeholder selected, and each carrying a tooltip quoted from Simile's
  help.
- **Nothing in the aids may take the keyboard**: insert buttons and disclosure
  triangles both suppress `mousedown`, or the caret leaves the equation and
  typed characters vanish.

**Open, and recorded as open:**

- `Variables` vs `influence`. The panel says Variables (a "parameter" is a
  variable whose value is a number, so Simile's word was wrong); the checker
  says "influence"; one of our node types is already called `variable`. To be
  reconciled deliberately, not with a third hasty word.
- Eight functions we know — `firsttrue`, `graph`, `howmanytrue`, `pi`,
  `posgreatest`, `posleast`, `rand`, `table` — are in no group, because Simile's
  help does not group them. Legal to type, absent from the tree. A sixth group
  is Robert's call.
- `hypot` appears in two groups, as it does in the help.

## Jobs queued

### 1. A regression net for the EDITOR — still the first job, and now overdue

Everything above argues for it. What is missing is a page that drives the
*widget*: arm a tool, click, and assert where the element landed and what the
view did. Hard, because it needs a DOM and a real panel; worth it, because five
bugs in one afternoon all lived exactly there and the three existing pages
cannot see any of them.

**2026-09-09 made the case worse.** Eleven UI changes went in, and every one was
verified by probing the live DOM from the console — cursors, hit areas, menu
structure, panel titles, titlebar colours, the thumbnail threshold. All of it
correct, none of it repeatable: those probes exist nowhere but in a transcript.
Four items had to be reported twice. A page that opened a panel and asserted on
it would have caught at least the panel-title and thumbnail-toggle faults.

Note that a harness of this kind now has a hazard of its own, learned the hard
way — see the ResizeObserver trap below. Anything driven from an automated
browser may be running in a hidden tab, where `ResizeObserver` never fires and
`requestAnimationFrame` never resolves. A test that resizes a panel and waits
for a repaint will hang or silently assert on stale geometry.

### 2. Dialogs — well under way, see the section above

The node dialog is built and in use. What is left of it:

- **the numeric keypad**, the third panel in the aids row. Parked by Robert, and
  cheap when wanted: buttons carrying `data-insert`, since the caret machinery
  is already shared.
- **a second tab** — styling was the motivating example for making it tabbed.
- **the submodel dialog**, which shares the generated form but has had no
  attention of its own.

`Sienna.dialogs.register(key, renderer)` owns the presentation, so a custom
dialog is a script that registers itself; a renderer is handed the element, the
field model, the whole schema, the `Diagram`, and `ctx.field(name)` /
`ctx.fields()` / `ctx.influences()` / `ctx.functions()` — the standard blocks —
so it can replace one part without hand-writing the whole form. Item 45.

**Still untouched: there is no arc dialog at all.** An influence's alias
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
`documents.current` (and now decides a panel's title and titlebar colour, §25),
and `panel.add` goes into the replay log. Item 45 has
the detail.

### 5. Two things Robert has parked, and one he owes us

- **The numeric keypad** in the equation dialog (see job 2) — parked, cheap.
- **`Variables` vs `influence`** in the dialog's wording — deliberately left
  open, to be settled when the arc dialog exists.
- **Touchscreen (his item 24).** "Some UI operations do not work on a small
  touchscreen (my phone)." He is to send specifics; nothing has been done. The
  diagram is `pointerdown`/`pointermove` throughout, which should be
  touch-clean, but there is a double-click rule and a press-versus-drag
  distinction on labels that will not survive a finger, and the palette buttons
  are small. **Do not guess at this — wait for the details.**

His written list of UI refinements is otherwise **finished**; he ticked the last
of it off on 2026-09-09. There is no backlog of his sitting unaddressed, which
means the next session starts from the queue above rather than from his notes.

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
- **Chrome caches the app's scripts hard, and it lies convincingly.** Serve with
  **`python3 tools/serve.py`** rather than `python3 -m http.server`: the plain
  server sends only `Last-Modified`, so Chrome caches heuristically and can run
  a file that changed on disk minutes ago. On 2026-08-31 that produced
  `test/fixtures.html` reporting "4 of 6 failed — Unknown node type
  compartment" two days after that rename was committed, and a new dialog
  reported as doing nothing when the browser simply had the version from before
  it was written. Both looked exactly like real faults.
  **Ctrl+Shift+R is not enough**, because widgets and dialogs are injected at run
  time rather than listed in `index.html`. The escape hatch, if you are stuck on
  a plain server, is every script the page actually loaded:
  `for (const s of document.querySelectorAll('script[src]')) await fetch(s.getAttribute('src'),{cache:'reload'}); location.reload();`
  and the quickest test of whether you have the current code is to ask for
  something only it has, e.g. `typeof Sienna.dialogs.problems`.
- **`tools/serve.py` holds the terminal it is started in.** It runs in the
  foreground until Ctrl-C, so the shell that is serving cannot also run Claude,
  and Ctrl-C to get the prompt back takes the server with it — the browser tab
  stays open with nothing left to load from, which reads like the app broke.
  Give it a terminal of its own, or detach it before starting Claude:
  `nohup python3 tools/serve.py > /tmp/serve.log 2>&1 &` (stop it later with
  `pkill -f tools/serve.py`). An agent can start it detached too, but a server
  belonging to this session's process tree may not outlive a reboot or a hard
  kill, so after a power cut start it yourself first.
- **`file://` and `http://localhost` are different origins**, so they have
  separate stored models. A test on one cannot see the other's.
- **Chrome's automation extension refuses `file://` URLs outright**, so an agent
  driving the browser cannot open `index.html` the way you do. Serve the
  directory instead — `python3 tools/serve.py` from the repo root, then
  `http://localhost:8731/index.html` — and remember the origin trap above: that
  tab has its own stored models and cannot see the `file://` ones. Note also
  that a synthetic drag through the extension does NOT reliably draw an arc,
  though clicks and typing work; arc gestures have to be checked by hand, or
  driven through `Diagram.addArc` from the console.
- **A ResizeObserver does not fire in a tab that is not being painted**, and
  `requestAnimationFrame` never resolves there either. This cost time twice on
  2026-09-09: once as a real bug (opening a thumbnail left the diagram at
  thumbnail scale until a reload, because the widget was waiting on its own
  observer), and once as a phantom, when a rAF probe from the automation
  extension hung the renderer outright and made a working feature look broken.
  **When a browser-driven test behaves impossibly, check
  `document.visibilityState` first.** The rule the code now follows: whoever
  causes a change announces it (the panel triggers `slxpanelresize`, taken with
  `widgetBase._watchPanelResize`), and an observer is only for changes nobody
  announced, such as the window resizing.
- **The models are in NO repository.** They live in localStorage, on one
  machine, in one browser profile, on one origin — a dead disk takes them, and
  git will not help. `File ▸ Export all models…` writes every one of them to a
  single JSON bundle; it is the only backup there is, and it takes a few
  seconds. (There is deliberately no import for that bundle yet: reading one
  back has to answer what happens to an id that already exists, and the wrong
  answer destroys work silently.)
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
