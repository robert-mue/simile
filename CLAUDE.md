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
  `src/remote.js`) — how the model gallery's
  page, or any link, opens a model in the app. The file File ▸
  Save writes, FETCHED (from any address, Robert: a model is data, never
  run; checked as File ▸ Open checks one), added as a copy that records
  `openedFrom` (so the same address again offers that copy: `askChoice`, buttons "Make
  new copy" / "Open previous copy", Escape does neither — never
  confirm(), whose OK / Cancel do not say what they do, Robert), and opened;
  `?open=` is then taken out of the address bar. Parameter values from
  `&parameters=<address>`, else `<name>.parameters.json` beside it if there
  is one (`Simulation.readParameterFile`, shared with the Parameters
  panel's Load). The one exception to "no fetch": a REMOTE file, when asked
  for; another site must allow it (CORS — GitHub Pages does). Opened in a
  new tab, the app takes over from any other tab of it (sienna's one live
  tab). Opened so, the app starts CLEAN (Robert, 2026-11-15): the last
  session's panels are not brought back, only the default layout with the
  model asked for; a plain start afterwards restores that. Check:
  `tools/headless/scripts/open-address.py` (http and file://).
- **The model file reference** (`help/model-file-reference.md`, first draft
  2026-11-18): the model spec format for someone, or an AI assistant given a
  paper, writing a model WITHOUT the app. Self-contained, so its worked
  examples are written out in it, copied from `examples/models/*.json` by
  `tools/reference-examples.py` (`--check`); change an example there, never
  in the reference. `tools/headless/scripts/model-file.py` holds model spec
  files to the app's checks and runs them (the examples by default). A
  hand-written file has no port positions: placed when it is opened
  (`Diagram.portsMissing`, `opened` in `main.js`, `fresh` in `page.js`).
- **Model properties** (Robert, 2026-11-18: the model is, in effect, the
  top-level submodel, as in Simile's file, whose file-level `properties`
  carry a submodel's keys): the submodel dialog's fields the schema marks
  `atTop` (comment; units in maths, first index 0, enumerated types), held
  in the model spec's own `props` (`Diagram.modelProps` /
  `setModelProperties`, one undo step), shown by `Sienna.modelDialog`
  (`src/dialog.js`). Opened by a double-click on the diagram's background
  or Edit ▸ Model properties…. Exported into, and imported from, the
  file-level `properties` (`notes` in export-simile.js). A type declared
  there is known everywhere (equation-check's `typeNames`); one declared on
  a submodel only inside it. Check: `tools/headless/scripts/model-props.py`.
  Its first tab is **Metadata** (title, description, keywords, web page,
  paper), the model spec's `metadata`, written in the same action as the
  rest; the fields and their conversion are stated once,
  `Sienna.metadataForm` (src/dialog.js), shared with the Metadata panel.
  Not yet: submodels as modules (Robert: think first).
- **Vensim models** (Robert, 2026-11-20: his System Zoo `.mdl` suite, for
  the model gallery): `tools/vensim/mdl2json.py` converts a Vensim text
  model into a model spec. Equations (INTEG to stocks and flows, a net
  inflow that is not a sum of flows to ONE `<stock>_change` flow, Vensim's
  functions to Simile's: RAMP, PULSE, PULSE TRAIN, IF THEN ELSE, XIDZ,
  lookups and WITH LOOKUP to `interpolate`), names lower case with `_`, a
  stock's first letter a capital (Robert: one style across the gallery),
  the sketch's positions at full scale, its pipes' corners as flow BENDS,
  its arrows' curves as bows, its `:GRAPH`s as default displays, INITIAL
  TIME as the run's start time, units listed in the model's comment.
  Elements the sketch does not draw are set out in a block to its right.
  Says what it could not convert (exit 1): `A FUNCTION OF`, Vensim's
  placeholder, means an unfinished model; `DELAY FIXED` is refused (the
  engine's const_delay does not delay). Every delay and smoothing is made of
  STOCKS (the engine's own do not build): x stays what the sketch draws (a
  valve stays a valve), equal to a stock `<x> smoothed` / `<x> delayed` set
  out above it, a third order's stages to its left; `ACTIVE INITIAL`'s initial is used
  in stocks' starting values (World3). For exact agreement with Vensim:
  numbers are written as reals, Vensim's TIME is the time on the step grid
  with the model's literal step (`Expr.now`; the engine's time() and dt()
  drift), and logging is at whole multiples of the step. CHECKED against
  the originals by `tools/vensim/vensim_sim.py`, an independent Vensim
  simulator, and `tools/vensim/compare.py` (the app's end values from
  model-file.py, name by name).
- **A published model reproduced** (Robert, 2026-11-21: "in a year's time,
  will it be straightforward?"): `examples/papers/coral/` — the coral
  acclimation model of Raharinirina et al. 2022, its generator from the
  authors' repository, and how it was checked against their published runs
  (it agrees). THE PRECEDENT for another paper: start from its README, the
  model file reference's section 2 items 13-20 (authors' code first, sudden
  changes as one-step flows, spin-up before 0, forcing data as values over
  time in a parameter file, a binary-exact time step, missing functions,
  derivatives by hand, copying traps) and section 13 (comparing:
  `check_models.py --parameters --csv`, then `tools/compare_series.py`).
  Their data is not in the repo (the parameter files are made from it).
  `coral.ipynb` (Robert, 2026-11-21, "tempting"): the paper's calibration of
  N, projections and sensitivity, in Python, the model staying the diagram;
  runs through **`tools/python/simile_run.py`** — `Session(model,
  parameters).run({...}, variables=[...])` → a pandas DataFrame — a PROTOTYPE
  driving the app's engine in a hidden Chrome here (Simulation's own route:
  values before each reset, then start; compile once, ~0.5 s a run after;
  time limits, closes what it started). A constant is varied as a changed
  COPY of the model spec, not by making it a parameter (engine README fault 8:
  24 variable parameters and a series never finished). Its Python:
  ~/Projects/simile-notebook-env (no pip on this machine's Python: pip was
  installed into the env from its PyPI wheel). **`NOTE-jupyter.md`** (Robert,
  2026-11-21): why (common ground with researchers who write Python to run
  experiments with models), how to make a notebook for ANY model (a template),
  and the DECISION — a pip-installable package (likely Simile's wasm engine
  under Node.js; the GPL of Jasper's run-time to agree first), not
  JupyterLite. A FIXED parameter changed between runs: `run` reloads the
  model first (fault 7 otherwise).
- **A model's FAMILY** (Robert, 2026-11-23): `metadata.family = {title,
  members: [{model, title, summary, file}], current}`, models that are
  alternatives to one another. The Metadata panel lists them, this one
  marked, the others links opening them in this window
  (`Sienna.openFamilyMember`, src/widgets/metadata.js: `file` relative to
  `openedFrom.url`, else `metadata.page`; with neither, a member already among
  the user's models; else it says which file). `Sienna.metadataForm.fromFields
  (f, held)` keeps entries the fields do not edit, so an edited title keeps the
  family. Check: `tools/headless/scripts/family.py`. The gallery's check.py
  verifies every member's file.
- **Converting other people's models** (`~/Projects/models_from_others/`):
  **`tools/python/simile_build.py`** builds model specs from Python, every
  influence drawn from the equations (in, out `[x]`/`{x}`, across associations
  `x_role`). First used for Norman Owen-Smith's TrueBASIC models (his book's CD,
  2007): `models_from_others/wildlife_models_from_owen_smith/convert/`
  (`make_models.py`, `make_gallery.py`, README there) — 20 in the gallery,
  two families (13 descriptive equations; one age-structured model built three
  ways in Simile). Found: `binome(p, n)` needs a whole number n (`int()`); a
  top-level array of a submodel's values needs units `array(1,n)` (the app
  could infer it); a population submodel's births and deaths in one step are
  not ordered as assumed (the individual-based AGEINTR declines; held back,
  question to Robert).
- **`tools/check_models.py`** (Robert, 2026-11-20: for him to run, no
  Python needed beyond typing it): checks model files — the gallery by
  default, or files / folders given — load, are complete, export, compile
  and run (model-file.py through cdp.py, starting serve.py and a headless
  Chrome if they are not running); `--vensim <mdl folder>` adds compare.py;
  `--save` records end values as right in `check-expected.json` (git
  ignores it, and `check-report.txt`), and later runs say SAME / CHANGED.
  The engine's random numbers repeat run to run, so random models compare.
  `--parameters FILE` runs with a parameter file (given before the model is
  first loaded, as the app's Load and ?open=&parameters= do, so fixed
  parameters take it); `--csv FOLDER [--vars a,b]` writes values over the run;
  `--time-limit` (300 s) stops a model that never finishes, and its Chrome
  (a run stuck in the engine keeps a processor at full speed: Robert's fan).
- **Run start time** (`startTime`, a kept run setting and a model's
  `presentation.run.startTime`; Robert, 2026-11-20): the time a run starts
  from and ■ goes back to; the run control's first field. The engine's reset
  takes it (`_startTime` in simulation.js; it was always the engine's 0).
- **Flow bends** (`layout.arcs.<flowArc>.points`, `Diagram.flowBends`):
  a flow's corners, drawn through (`arcPoints`), its valve halfway along its
  path, carried when both its ends are dragged together (`commitDrag`), left
  out of the fan of arcs sharing its ends; Simile's `course` both ways.
  Check: `tools/headless/scripts/bends.py`.
- **Long names wrap** in the diagram (`_wrapLabel`): over 16 characters,
  after underscores; display only.
- `src/widgets/index.js` — the widget **manifest**. A widget's `src` is resolved
  relative to `index.html`, so use `src/widgets/<name>.js`. Each widget's
  `role` (`diagram`, `run-control`, `display`) decides which collection it
  opens in.
- `src/layouts.js` — simile's layouts (sienna `DESIGN.md` Part III). Each
  model gets a Model collection and a Simulation collection (run control +
  tabbed Displays), made from templates. The default, **Model and simulation
  panels**, makes them floating panels opened together with the model;
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
  Another diagram of the same model FOLLOWS a gesture while it is in
  progress (Robert, 2026-11-11): each gesture announces itself and its end
  (sienna's `userData.announce`, `_announce`) and the other views draw the
  same ghost (`_follow`); nothing is written until the drop, which every
  view then hears as a change, once. nkometou, a 1091-element submodel: the
  follower ~105 ms at the start, ~1 ms a frame. Checked:
  `tools/headless/scripts/two-views.py` (every gesture, a click, a cancel).
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
- **No Load; the run control's status a traffic light** (Robert,
  2026-11-15; `src/widgets/run-control.js`): in a model's own Simulation
  panel (bound: a `ref`) there is no model menu and no Load — ▶ prepares the
  model (`viewFor(ref).prepare()`: compiles exactly what is drawn, if it is
  not the one loaded or was edited since) then runs it; ■ prepares it and
  goes to the start. Its settings are the model's own before it is prepared
  (`Simulation.settingsBefore` / `setSettingBefore`, kept as a run's are).
  The status line is bold on green (it can go), orange (in progress), red
  (cannot: a failure, or "N elements are incomplete", counted with
  `equationCheck.completeness` after each edit settles, ▶ and ■ greyed). An
  unbound run control (Free layout, Widgets ▸ Run control) keeps the menu,
  path box and load / unload: the way to SimiLive's demos.
- **Default displays** (Robert, 2026-11-15; `src/presentation.js`,
  `Sienna.presentation`): a model spec's `presentation` — `{ run: {runLength,
  logEach, timeStep}, displays: [{widget: 'plotter', variables: [element
  ids]}, {widget: 'sliders'}] }` — the modeller's recommended view, kept with
  the model like `metadata`. When a model is OPENED (sienna's `documents`
  `opened` hook — not a session or layout bringing panels back) and none of
  its displays is open, they are opened in its Simulation panel, its run
  settings taken unless this user has set their own (`settingsFor`), and it
  is prepared and run once: a gallery model opens with its graphs drawn. Set
  with the Metadata panel's "Use the displays open now" (`snapshot`), Clear.
  A plot keeps its variables over a reload (`plotter.state()`). The model
  gallery's five carry one (its `check/check.py` checks them). Check:
  `tools/headless/scripts/presentation.py`.
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
  later ones ~3 s (up to ~30 s on a first visit over the web: a "Please
  wait" note, `.slx-wait-note`, shows while the tools load, Robert). The work runs in a Web Worker, so the page stays live;
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
- `src/widgets/field3d.js` — **Field in 3D** (Robert, 2026-11-21: glitz,
  for teaching and public engagement; conservation): a fixed-membership
  submodel's instances as ground patches (colour and height from one
  variable, placed by `px`/`py`, else a square grid) on a soil slab, a
  population as low-poly trees (x, y, height, crown radius), the sun
  STRAIGHT OVERHEAD so shadows fall where a vertical-sun model shades.
  Variables guessed by name, chosen under "choose", kept by name. Every
  frame of a run is kept: ▶ plays it back as a time-lapse (~15 s,
  blended between frames), the slider scrubs, "tour" orbits. three.js
  r147 in `vendor/three/` (MIT; the last release with classic-script
  builds of three and OrbitControls, so no bundler), loaded when the first
  one opens. A model may list it in `presentation.displays` (`field3d`).
  First model: ~/Projects/simile_models/agroforestry/ (trees over 1600
  pasture patches, shading by an association with a condition on crown
  distance — the first grid × population association; it builds and runs).
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
  ones used last are kept beside it (slot `fileParameters.v1`, `sienna.simile.` before
  it as the shell's are, so a new-user preview has its own — until
  2026-11-15 `simile.fileParameters.v1`, shared, adopted once; run settings
  likewise, `runSettings.v1`;
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
  page on a web site such as the model gallery's — File ▸ Export model as
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
- `src/demo-*.js` — the built-in models: `growth`, `submodel`, the
  reference models `landuse`, `farmers` and `lamos` (§9), and others. Seeded
  ONLY with `index.html?demos` (Robert, 2026-11-15: a new user's models
  start empty); the checks that use them ask for them.
- **Sample models and the Welcome** (Robert, 2026-11-15):
  `src/widgets/samples.js`, File ▸ Sample models… (`openSamples` in
  `src/main.js`; sienna's `trailingItems`, at the bottom of File). The ONE
  panel about no model: no ref, no role, floats at the top level, keeps its
  own title, closed only by the user, one at a time. A sortable table of the
  model gallery's models, read when it opens: `models/index.json` names
  them; each model spec's `metadata` (title, description, keywords, paper;
  hand-written, kept with the model) and what is INFERRED from its structure,
  never written down: size as submodels/stocks/flows/variables, and its
  Simile features (`Sienna.modelSummary`, `src/model-summary.js`, shared with
  the Metadata panel). Open is the gallery link's
  `openFromAddress` (`Sienna.openModelFromAddress`). A first visit (no
  models, no session, not `?open=`) opens it with a Welcome over it,
  offering it and the tutorials, gone at the first press or key (`welcome`).
  `?gallery=<address>` points it at another copy. File's lists (sienna):
  Recent models under Open, Your models (all, A-Z) lower down. Check:
  `tools/headless/scripts/samples.py` (serves the gallery repo itself).
- **Metadata** (Widgets ▸ Metadata, `src/widgets/metadata.js`; Robert,
  2026-11-15): a model's `metadata` — title, description, keywords, web page
  (`page`: a gallery model's page there), paper (citation, link) — entered
  and shown, the two addresses also as links, empty fields left out, one undoable
  edit per field left; below, the size and features read from the model.
  No role: a panel of its own, the model's, opened at its working size
  (`openWidget` gives a role-less widget its `workingSize`). Checked in
  `samples.py`.
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
