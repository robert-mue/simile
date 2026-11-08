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
- **Widgets the user adds** (sienna's `added-widgets.js`, loaded by
  `index.html`, not by `embed.js`): Widgets ▸ Add a widget… / Add a toolkit…
  / Manage added widgets…, appended by `main.js` after the app's own
  (`openWidget`, so they bind to the current model as built-ins do). A widget
  file is one `Sienna.widget({…})` call. Design and trust: `NOTE-external-widgets.md`;
  the API: `sienna/CLAUDE.md`; examples: `sienna/examples/added/`.
  **Instructions for an AI assistant** (Widgets ▸ …, and a link in Add a
  widget…): sienna's `widget-brief.js` is the generic contract;
  `src/widget-brief-simile.js` adds simile's part — roles, the model spec,
  and how a display gets a running model's values (`Simulation.viewFor`:
  `scalarComponents`, `addTarget`, the `data`/`describe`/`status` events).
  `examples/widgets/big-number.js` was written from the brief alone: keep
  the two in step. What an added display may use is **`Simulation.forWidget(ref)`**
  (`WIDGET_API` 1: read the run, never drive it) — change it only with the
  brief, the guide **`help/widgets.html`** (Help ▸ Writing a widget, for
  coders) and the example; `tools/headless/scripts/added-widget.py` checks
  all of it.
- **Opening a model from an address**: `index.html?open=<address of a
  model's .json>` (`openFromAddress` in `src/main.js`, fetching through
  `src/remote.js`) — how a model
  library's page, or any link, opens a model in the app. The file File ▸
  Save writes, FETCHED (from any address, Robert: a model is data, never
  run; checked as File ▸ Open checks one), added as a copy that records
  `openedFrom` (so the same address again offers that copy), and opened;
  `?open=` is then taken out of the address bar. Parameter values from
  `&parameters=<address>`, else `<name>.parameters.json` beside it if there
  is one (`Simulation.readParameterFile`, shared with the Parameters
  panel's Load). The one exception to "no fetch": a REMOTE file, when asked
  for; another site must allow it (CORS — GitHub Pages does). Opened in a
  new tab, the app takes over from any other tab of it (sienna's one live
  tab). Check: `tools/headless/scripts/open-address.py` (http and file://).
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
  A drag of elements is **ghosted** (`_ghostBegin`): nothing is redrawn
  until the drop. At the start, from the graph's reverse lookups (`_index`,
  made with each drawing), it sorts what it carries — rigid (moved by one
  transform per layer), cut arcs (redrawn alone each frame), and a cut
  flow's valve with the arcs at it; no third order. A label drag moves only
  the label; a resize, a port drag and a bend redraw only the box, handle
  and arcs they change (`_ghostResize`, `_ghostStill`). Checked: `test/editor-tests.js` (the ghost is what the drop draws).
  It redraws ONCE per model change, however many writes (`_renderSoon`), and
  keeps each element's red/black until the model changes in anything but
  layout (`_incomplete`). A drawing runs inside **`Diagram.memo`**: for a
  pass that only reads, the whole-model facts (arcs at an element, an
  association's roles, conditions, a valve's flow) are found by one scan
  and looked up; outside one, derived afresh as before. The audit uses it
  too. nkometou: a redraw 33 s → 0.5 s.
  **Scaled submodels**, as in Simile: `layout/<sub>.scale` draws its
  contents smaller (`Diagram.scaleIn` / `scaleOf` / `contentScale`); positions
  stay in one world space, sizes follow — `Diagram.box` scales a node's
  glyph, and styles.css multiplies line widths and names by `--k`
  (`_scaled`); an arc segment is drawn at the scale of the submodel it runs
  through (`_segments`, `_markerFor`). Imported from Simile's
  box / `internal_extent` (77 of nkometou's 99), exported back the same way.
- `src/diagram.js` — the **model layer** (`Sienna.Diagram`): nodes, arcs,
  submodels, parentage, naming. Notation-neutral; knows nothing about drawing.
- `src/schema/simile-v1.js` — the **notation**, as plain data: vocabulary,
  grammar rules, field model, styling, and the function table. Changing how
  Simile is drawn or what it permits should mean changing this file.
- **Crossings** — what an influence delivers where it arrives, and so the
  brackets its name is written in, is ONE rule in the model layer,
  `Diagram.valueAt` (Simile's own, from its source): the source's units
  wrapped once per dimension added by each submodel left — `list(…)`/`{x}`
  where instances come and go, `array(…,N)`/`[x]` per fixed size — to any
  depth, never matched against patterns. Associations crossed:
  `Diagram.associationCrossings` (several per influence possible). The
  exporter writes it, the completeness check and the exporter's check
  hold equations to it, the dialog inserts it. Checked against every term
  Simile wrote: `tools/headless/scripts/crossings.py`.
- `src/grammar.js` + `src/predicates.js` — evaluate the schema's rules; named
  predicates are the escape hatch for what data cannot express (§12.2).
- **The submodel dialog** follows Simile's (`Disaggregate`, Run/forms.tcl):
  tabs Instances, Styling, Notes, Advanced, declared in the schema (a field's
  `tab`; `firstTab`; `layout` for what is kept with layout, not props; types
  `scale`, `colour`, `longtext`; `explain`, `showWhen`). Relative scale is
  `Diagram._setScale`, Simile's `refatten`: box and positions stay, a nested
  submodel keeps its contents' size up to scale 1. Hide contents: `layout.hide`,
  `Diagram.isHidden`, `_segments`. All imported and exported (`notesOf`,
  `submodelNotes`). Not there, nothing could act on them: a background image,
  external code, threads, the data-records and grid kinds.
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
- `src/engine-local.js` — **Simile's simulation engine in the page**
  (`Sienna.LocalEngine`). Terms: the ENGINE is what makes a runnable model;
  the COMPILED MODEL is one model's WebAssembly (a side module), never "the
  engine"; it runs linked to Simile's **run-time library**, its own
  `shank.cpp` (github.com/jal-frezie/simile, GPL v3) compiled once
  (`vendor/simile-runtime/simile-runtime.js`). It answers SimiLive's requests
  in SimiLive's shapes, so `simulation.js` sends them there instead of over
  the network (`Simulation.local`). A compiled model is used only while the
  model is exactly the one it was compiled from (a fingerprint of the
  exported Prolog). An embedded-widget page may ship one, `<name>.compiled.js`
  calling `Simile.compiledModel(…)`; any other model — edited, or any of the
  app's — is compiled in the page (`build`, below), kept for the visit, and
  in the app also between visits (IndexedDB, the 50 used last; pages keep
  nothing); only if compiling fails does it go to SimiLive. A run takes
  milliseconds, a slider runs as it is dragged, and a starting value needs
  no recompile. Build tools, findings and patches to Simile's run-time
  code: `tools/engine/README.md`.
- `src/model-compiler.js` — **a model compiled in the page**
  (`Sienna.ModelCompiler`, loaded by `engine-local.js` when first needed):
  Simile's own generator in SWI-Prolog (WebAssembly) writes the C++, clang
  (WebAssembly) compiles it. Loads its large tools on first use, from
  `vendor/swipl/`, `vendor/simile-generator/`, `vendor/clang/` (30 MB,
  gzipped) and `vendor/simile-runtime/model-kit.js`, all **generated** by
  `tools/engine/build-browser-tools.sh`. First compile of a visit ~7–9 s,
  later ones ~3 s. The work runs in a Web Worker, so the page stays live;
  from file:// a worker can be made only from text, so each tool script
  defines ONE function (`SIMILE_TOOL_SWIPL`, `SIMILE_TOOL_CLANG`) whose text
  the page sends it. No worker to be had: the same code runs in the page.
- **Parameters** — a variable's "Data source" (its dialog; Simile's own
  choice), `exportSimile.parameterKind`: **Derived** (an equation, on a
  function node), **Variable parameter** (read every time step: a slider,
  or values over time), **Fixed parameter** (`param_type=file`, read once at
  reset). Held as `props.paramKind`; a variable without one is read by the
  older rule (a number, a range, nothing influencing it → variable). For
  both parameter kinds the equation is optional, a default; both are
  exported as Simile's ONE node (value, range, units on the variable, no
  function node), and imported by Simile's rule (no function node → a
  parameter). See `NOTE-file-parameters.md`.
- `src/widgets/sliders.js` — a slider per variable parameter with a numeric
  value, a Minimum and a Maximum (`exportSimile.isParameter`,
  `Simulation.parametersOf`). A slider's value is a RUN setting
  (`Simulation.setParameter`), never an edit to the model. On SimiLive a
  rate is changed in place (`Parameterize` with `NOW v`, sent again after
  every reset) and a starting value by loading the model again with the
  value written in; in the page, both are a reset.
- `src/widgets/parameters.js` — the **Parameters** panel: every fixed and
  variable parameter (`Simulation.inputParametersOf`), grouped by submodel.
  A value is a number or JSON (`[1, 2, 3]`, one bracket level per
  dimension: enclosing fixed memberships, then the variable's own array);
  a variable parameter may instead be given values OVER TIME — `{"0": 5,
  "10": 7}`, or one bracket deeper, `[5, 7, 9]` for times 0, 1, 2 — with
  what the run sees between times (last, closest, interpolated)
  (`Simulation.readInputValue`). Values are NEVER in the model spec: the
  ones used last are kept beside it (`simile.fileParameters.v1`,
  `Simulation.setInputValues`), and Load / Save write a JSON parameter file
  (`<model>.parameters.json`, nested by submodel); Simile's own (`.spf`, never renamed) are READ too, XML and its first, text format (`_fromSimileXml`, `_fromSimileText`), not written. Before
  each reset they go to the engine (`FileParameters`, ours, in
  `engine-local.js` → `sx_param_fill` / `sx_param_series` in bridge.cpp); a
  missing one stops the run, naming it — except a variable parameter with no
  value but a range, which runs at the middle of it (Robert). A slider moved last beats a value
  through the run; values over time take over at their first time. In the
  page only, and not for a population's members. Check:
  `tools/headless/scripts/file-params.py`.
- `src/page.js` — **embedded-widget pages** (`window.Simile`): widgets placed
  straight into an ordinary web page, no workspace. A model ships as a script
  calling `Simile.model(name, model, runSettings)` — or is given by its
  ADDRESS, `Simile.model(name, '<model>.json', run, { parameters? })`: the
  model spec fetched as the page fills (`src/remote.js`, shared with the
  app's `?open=`), with `<model>.parameters.json` beside it if there; for a
  page on a web site such as a model library's — File ▸ Export model as
  script writes one (`exportScriptFile` in `src/main.js`, with the run
  settings chosen for the model, `Simulation.settingsFor`); elements say
  `data-simile="diagram|plotter|lollipop|…|controls"` and `data-model`
  (`data-show` = a plot's variables, `data-options` = JSON); `Simile.page({ base })`
  fills them, loads the first model and runs it (in the page, see
  `engine-local.js`), and re-runs after
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
- `vendor/simile-runtime/simile-runtime.js` — **generated**, by
  `tools/engine/build-runtime.sh` from a Simile source checkout; do not edit.
  Loaded on first use by `src/engine-local.js`, not by `index.html`. So are
  the files `src/model-compiler.js` loads (above).
- `tools/engine/` — building the run-time library (`build-runtime.sh`), a
  page's `<name>.compiled.js` (`build-model.sh`) and the in-page tools
  (`build-browser-tools.sh`); they need Simile built from source in
  `~/Projects/simile-src` and emsdk in `~/emsdk`; the patches to Simile's
  run-time code, and the record of what was found (`README.md`). **How to
  change the engine** (a fix to Simile's code, the generator, a newer Simile:
  where each change goes, what to rebuild, the checks):
  `tools/engine/MAINTAINING.md`. Simile's checkout is never edited; our
  changes to Simile's code are patches and replacement predicates here.
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
    Also test-only fixtures, `test/fixture-*.js` (satellite, table), which
    are never seeded into a user's models.
  - `roundtrip.html` — takes `.pl` files (select the whole model catalogue) and
    checks that `.pl` → our model → `.pl` reaches a fixed point, reporting what
    each import LOST as well, since a fixed point cannot show that.
  - `editor.html` — the EDITOR regression net: gestures (arm a tool, press,
    drag, type) on the real diagram widget, with real pointer events landing
    where a hand's would (`elementFromPoint`), then checks on the model and
    the drawing. Tests in `editor-tests.js`; each gesture bug found should
    leave one. Loads through `embed.js`, so nothing is kept. Keep the tab in
    front while it runs. Headless: `tools/headless/scripts/editor.py`.

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
