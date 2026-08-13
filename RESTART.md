# Restart note

*Written 2026-08-13 at the end of a two-day run on the Simile importer. If you
are picking this up cold — a new session, a new machine, or a week later — this
is the page to read first. `STATUS.md` is the full record; this is the part you
need to get moving again.*

---

## Where things stand

**Everything is committed and pushed.** Working tree clean at `7d1e2d3` on
`main`. Nothing is half-finished, and there is no branch to remember.

The loop is closed in both directions: a model built in this editor converts to
Simile Prolog, uploads, compiles and runs on the Simile engine with its results
drawn in our own panels; and a Simile `.pl` or `.sml` reads back into one of our
models. Items 27–42 of `STATUS.md` are that work.

**Standing numbers.** Quote these only after re-running the checks below, since
they are what a regression would change:

| | |
|---|---|
| catalogue round trip | **45 of 72 identical, 0 differ, 27 refused, 1 lossy** |
| fixtures | 6 of 6 reach a fixed point and audit clean |
| equation grammar | 1388 of 1409 parse, 21 known exclusions |

## Check nothing has rotted, in three minutes

No build, no npm, no server. Open each page and read the coloured bar.

1. **`test/fixtures.html`** — needs nothing. Green means the converters and the
   completeness check still agree with all six demo fixtures.
2. **`test/index.html`** — needs nothing. The equation grammar over the corpus.
3. **`test/roundtrip.html`** — press the button and select **all 72 `.pl` files**
   in `~/Projects/Simile_model_catalogue`. This is the slow one and the one that
   matters most.

Then open `index.html` itself and check the devtools console is clean.

## The two jobs queued

Both are **schema / model-layer** work, not converter work. Neither is started.

### 1. Per-role aliases — the last real blocker

**Ten catalogue models refuse to export because of this one thing.** We hold
**one alias per influence**; Simile holds **one per role**. So an `attribute`
crossing into a two-role association arrives in Simile under two names, and our
exporter derives them as `<alias>_<role>`.

That derivation is wrong, and the re-saves proved it: Simile writes back
whatever the modeller typed, **byte-identical after eighteen years**, and uses at
least three conventions (role name, ordinal `_0`, and plain unrelated names) —
all three inside 2008 v9.0 files. **Simile imposes no convention at all.**

So the fix is to store an alias per role on the arc, which touches the model
layer (`src/diagram.js`), the property dialog, and both converters.
`Diagram.namesSuppliedBy` is already the single place that answers "which names
does this influence supply", so start there — the exporter and the completeness
check both call it.

### 2. Event-based modelling

Deliberately set aside at the start; Robert has never used it. `alarm` is
**declared, drawn as a bell, read and written faithfully, and disabled in the
palette** (greyed, dashed, titled "Not yet implemented", from a `notImplemented`
flag in the schema). One symbol is almost certainly not enough to do event
modelling — what else it needs is unknown and unasked.

## Waiting on the developer

`NOTE-email-population-symbols.md` is **drafted and NOT sent**. It is down to two
questions, both about meaning rather than spelling, because six re-saves answered
the rest:

1. Is our `migrator` dialog mislabelled? It asks for a "migration condition", but
   every `immigration` node in the catalogue holds a **number**.
2. Is `loss` a probability or a condition? The catalogue shows both.

`NOTE-questions-for-developer.md` has the rest; §A1, §A2(a), §A2(d) and §A4 are
now marked answered.

## Things that will bite you

- **The scratch directory is `/tmp` and does not survive a reboot.** A machine
  restart on 13 August wiped every analysis harness. That is why the regression
  net now lives in `test/` as pages — put anything you want to keep in the repo.
- **Chrome caches the app's scripts hard.** A change can appear not to work. In
  the devtools console:
  `for (const u of ['src/schema/simile-v1.js','src/import-simile.js']) await fetch(u,{cache:'reload'}); location.reload();`
- **`file://` and `http://localhost` are different origins**, so they have
  separate stored models. A test on one cannot see the other's.
- **Never delete stored models** from `Sienna.userData` without asking — not on
  localhost, not "test clutter". `models/johad-test`, `models/prime-test` and
  `models/hexagon-test` are mine, on the localhost profile, and can go whenever
  you like.
- **A "fixed point" does not mean nothing was lost.** Where the importer drops
  something, the export never sees it and the comparison comes back clean. The
  round-trip page reports losses separately for exactly this reason.

## The catalogues are now in the repo

Both live in `reference/` as of 2026-08-13 — `catalogue/` (the 72 `.pl` files)
and `catalogue-2026/` (the six Simile 7.4 re-saves). They were in no git
repository before that, and the re-saves could only have been replaced by
redoing the work in Simile.

`~/Projects/Simile_model_catalogue*` still exist on Robert's machine and are
what the harnesses point at by default; `reference/` is the copy that survives
the machine. If the two ever disagree, `reference/` is the one to trust.

## Environment

- **Run it:** open `index.html`. No build, no server, no npm.
- **First checkout:** `git clone --recurse-submodules`, or
  `git submodule update --init` — the `sienna/` shell is a submodule and the app
  will not start without it.
- **SimiLive:** `https://similive.simulistics.com`, authorised for dev and test.
  `Widgets ▸ Run control` loads and runs a model there.
- **Current Simile is 7.4**, file format 11.4, `edition=free`. The catalogue is
  all format 9.0 or older, which is why the re-saves were worth doing.
