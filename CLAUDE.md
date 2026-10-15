# CLAUDE.md

Guidance for Claude Code (claude.ai/code) when working in this repository.

## Overview

**simile** is a schema-driven **diagram editor** application. It is the first app
built on **sienna**, a static jQuery shell (menu + workspace + panels, with a
user-data store, action log, undo/redo and session replay). The long-term goal is
to replace the diagram editor of Simile (simulistics.com) with a notation-neutral,
schema-driven editor. See **`DESIGN-diagram.md`** for the design record.

Scope is the **diagram editor**, plus a **client for the existing simulation
engine** — not the engine itself, which exists already. The distinction is that
we compute nothing: `src/simulation.js` drives a model running on a SimiLive
server and the display widgets show what comes back, but no integrator, equation
or numerical method lives here. Results-display widgets are in scope on that
footing (`src/widgets/grid.js` is the first).

## Structure

- `sienna/` — **git submodule** = the shell (`window.Sienna`). Do NOT edit files
  here to change the app; changes here belong in the sienna repo. Its own
  `sienna/CLAUDE.md` documents the framework (userData, actions, history, replay,
  the panel/workspace/menu widgets, and the content-widget contract).
- `index.html` — loads the shell from `sienna/vendor` + `sienna/src/core` (in
  dependency order), then this app's `src/widgets/index.js` and `src/main.js`.
- `src/main.js` — the app bootstrap: constructs `Sienna.App`, tells the shell
  what a simile document IS (`Sienna.documents.configure`, including the panel
  geometry a model opens at), builds the Edit /
  Widgets / View / Session menus, registers the replay handlers for this app's
  layout actions, and seeds the demo models.
- `src/widgets/index.js` — the widget **manifest**. A widget's `src` is resolved
  relative to `index.html`, so use `src/widgets/<name>.js`. Each widget's
  `role` (`diagram`, `run-control`, `display`) decides which collection it
  opens in.
- `src/layouts.js` — simile's layouts (sienna `DESIGN.md` Part III). Each
  model gets a Model collection and a Simulation collection (run control +
  tabbed Displays), made from templates. The default, **Model and simulation
  windows**, makes them floating windows opened together with the model;
  **Model and simulation areas** gathers them into two tabbed areas; **Free**
  is the old floating workspace. View ▸ Layout switches.
- `src/widgets/diagram.js` — the diagram widget: renders the model as SVG and
  handles every editing gesture. The one place that knows about pixels.
- `src/diagram.js` — the **model layer** (`Sienna.Diagram`): nodes, arcs,
  submodels, parentage, naming. Notation-neutral; knows nothing about drawing.
- `src/schema/simile-v1.js` — the **notation**, as plain data: vocabulary,
  grammar rules, field model, styling, and the function table. Changing how
  Simile is drawn or what it permits should mean changing this file.
- `src/grammar.js` + `src/predicates.js` — evaluate the schema's rules; named
  predicates are the escape hatch for what data cannot express (§12.2).
- `src/equation-grammar.js` / `equation.js` / `equation-check.js` — the PEG, the
  parser wrapper with its cache, and the join of parser + model + schema that
  produces the red/black completeness findings.
- `src/export-simile.js` / `src/import-simile.js` — the converters to and from
  **Simile Prolog** (`.pl`, and `.sml`'s MIME wrapper). The exporter's header is
  the specification of the mapping; the importer reads it backwards. Menu:
  `Simile ▸ Import model… / Export current model…`.
- `src/simulation.js` — the SimiLive session layer (no DOM): upload, compile,
  step, query. Its results feed the `plotter`, `grid` and `lollipop` widgets
  (a population variable is sent as `{member: value}`, keys kept for a
  member's life: the plotter draws a line per member, `lollipop` a lollipop at
  x, y as tall as size). ONE session:
  panels bound to a model (`ref`) see it through `Simulation.viewFor(ref)`,
  which shows it only while it is that model's (`loadedFor` / `modelPath`), so
  another model's run control and displays read "no model loaded".
- `src/engine-local.js` — **Simile's engine in the page** (`Sienna.LocalEngine`):
  Simile's own `shank.cpp` (github.com/jal-frezie/simile, GPL v3) compiled to
  WebAssembly once (`vendor/simile-engine/simile-engine.js`), and a model
  compiled by Simile into a `<name>.engine.js` that calls `Simile.engine(…)`.
  It answers SimiLive's requests in SimiLive's shapes, so `simulation.js`
  sends them there instead of over the network (`Simulation.local`), but only
  while the model is exactly the one its engine was built from (a fingerprint
  of the exported Prolog); an edited model runs on SimiLive. A run takes
  milliseconds, a slider runs as it is dragged, and a starting value needs no
  rebuild. Nothing is compiled in the page yet. Build tools, findings and
  patches to Simile's engine: `tools/engine/README.md`.
- `src/widgets/sliders.js` — a slider per **parameter**: a variable with a
  numeric value, a Minimum and a Maximum (dialog fields `min`/`max`), and no
  influence into it (`exportSimile.isParameter`, `Simulation.parametersOf`).
  A slider's value is a RUN setting (`Simulation.setParameter`), never an edit
  to the model. A rate is changed in place (`Parameterize` with `NOW v`, sent
  again after every reset, which restores defaults); a parameter with an
  influence path to a stock (a starting value) is changed by loading the model
  again with the value written in. The exporter writes a parameter as Simile's
  single-node "variable parameter" (value, `spec`, `min_val`, `max_val` on the
  variable node, no function node) — the only form SimiLive describes as
  `INPUT`; see the comment on `isParameter`.
- `src/page.js` — **embedded-widget pages** (`window.Simile`): widgets placed
  straight into an ordinary web page, no workspace. A model ships as a script
  calling `Simile.model(name, model, runSettings)` — File ▸ Export model as
  script writes one (`exportScriptFile` in `src/main.js`, with the run
  settings chosen for the model, `Simulation.settingsFor`); elements say
  `data-simile="diagram|plotter|lollipop|…|controls"` and `data-model`
  (`data-show` = a plot's variables, `data-options` = JSON); `Simile.page({ base })`
  fills them, loads the first model on SimiLive and runs it, and re-runs after
  an edit. A diagram there shows the view commands only (its `tools: 'view'`
  option). Pages set `SIENNA_EPHEMERAL`, so a reader's edits are not kept.
  ONE model runs per page (one session). A page loads everything with ONE
  script, **`embed.js`** (repo root: loads the shell and simile from its own
  location, sets `SIENNA_EPHEMERAL`, queues `Simile.*` calls until loaded).
  Samples live in `pages/<name>/` (`pages/pages.css` is their own look; what
  any page needs is in `src/styles.css`). The author's guide is
  `help/pages.html`.
- `src/demo-*.js` — fixtures seeded on first run: `growth`, `submodel`, and the
  three reference models `landuse`, `farmers` and `lamos` (§9).
- `src/styles.css` — app-specific styles, loaded after the shell's.
- `vendor/peggy.min.js` — this app's own vendored library (the shell's live in
  `sienna/vendor`). Compiles `src/equation-grammar.js`, which is the sole
  statement of the Simile expression language; there is no generated parser.
- `vendor/simile-engine/simile-engine.js` — **generated**, by
  `tools/engine/build-engine.sh` from a Simile source checkout; do not edit.
  Loaded on first use by `src/engine-local.js`, not by `index.html`.
- `tools/engine/` — building the engine and a model's `<name>.engine.js`
  (`build-model.sh`, needs Simile built from source in `~/Projects/simile-src`
  and emsdk in `~/emsdk`),
  the patches to Simile's engine, and the record of what was found
  (`README.md`).
- `reference/` — **data, not code.** `catalogue/` is the 72-model Simile
  catalogue (all format 9.0 or older) that `test/roundtrip.html` and
  `test/corpus.js` are built from; `catalogue-2026/` is six of them re-saved by
  Simile 7.4. Committed because the repository is the durable copy. Do not edit
  either — their value is that they do not change. See `reference/README.md`.
- `test/` — pages, not a test framework. Open one and read the bar.
  - `index.html` — the grammar over `corpus.js`, 1409 equations harvested from
    the catalogue **through the importer**, so it tests the pipeline too.
  - `fixtures.html` — every demo fixture built, round-tripped and audited.
    Needs no files, so this is the one that survives a wiped scratch directory.
  - `roundtrip.html` — takes `.pl` files (select the whole model catalogue) and
    checks that `.pl` → our model → `.pl` reaches a fixed point, reporting what
    each import LOST as well, since a fixed point cannot show that.

  The last two stub `userData`/`actions` rather than loading the shell: the real
  store autosaves to localStorage, and a test page must not be able to touch
  saved models.

## Running

No build/server/npm. Open `index.html` in a browser. First checkout needs the
submodule: `git clone --recurse-submodules …` (or `git submodule update --init`).
Verify by opening the page and checking the devtools console.

Over http instead — needed when driving the app from Chrome's automation
extension, which refuses `file://` — use **`python3 tools/serve.py`** (port 8731)
and NOT `python3 -m http.server`. The plain server lets Chrome cache the app's
scripts, which has twice produced convincing false results: green code reported
as broken, and new code reported as doing nothing. Note that `file://` and
`http://localhost` are separate origins with separate stored models.

Touching the equation grammar? Open `test/index.html` and read the bar — green
means every equation in the corpus still parses.

## Key constraints (inherited from sienna)

- **Classic scripts only** — no `import`/`export`; everything hangs off the global
  `window.Sienna`. Runs from `file://`, so no `fetch`/`import()`.
- **Load order matters** — see `index.html`. Content widgets are injected on
  demand by the widget registry, not listed in `index.html`.
- **Content widgets** register via `$.widget('sienna.<name>', {…})` and call
  `Sienna.widgetRegistry._loaded('<name>', '<name>')` at the end; add a line to
  the manifest. A widget holding shared data should extend `$.sienna.widgetBase`.
  Full contract: `sienna/CLAUDE.md`.
