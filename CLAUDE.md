# CLAUDE.md

Guidance for Claude Code (claude.ai/code) when working in this repository.

## Overview

**simile** is a schema-driven **diagram editor** application. It is the first app
built on **sienna**, a static jQuery shell (menu + workspace + panels, with a
user-data store, action log, undo/redo and session replay). The long-term goal is
to replace the diagram editor of Simile (simulistics.com) with a notation-neutral,
schema-driven editor. See **`DESIGN-diagram.md`** for the design record.

Scope is the **diagram editor only** — not the simulation engine (exists already)
nor results-display widgets.

## Structure

- `sienna/` — **git submodule** = the shell (`window.Sienna`). Do NOT edit files
  here to change the app; changes here belong in the sienna repo. Its own
  `sienna/CLAUDE.md` documents the framework (userData, actions, history, replay,
  the panel/workspace/menu widgets, and the content-widget contract).
- `index.html` — loads the shell from `sienna/vendor` + `sienna/src/core` (in
  dependency order), then this app's `src/widgets/index.js` and `src/main.js`.
- `src/main.js` — the app bootstrap: constructs `Sienna.App`, tells the shell
  what a simile document IS (`Sienna.documents.configure`), builds the Edit /
  Widgets / View / Session menus, registers the replay handlers for this app's
  layout actions, and seeds the demo models.
- `src/widgets/index.js` — the widget **manifest**. A widget's `src` is resolved
  relative to `index.html`, so use `src/widgets/<name>.js`.
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
- `src/demo-*.js` — fixtures seeded on first run: `growth`, `submodel`, and the
  three reference models `landuse`, `farmers` and `lamos` (§9).
- `src/styles.css` — app-specific styles, loaded after the shell's.
- `vendor/peggy.min.js` — this app's own vendored library (the shell's live in
  `sienna/vendor`). Compiles `src/equation-grammar.js`, which is the sole
  statement of the Simile expression language; there is no generated parser.
- `test/` — `index.html` runs the grammar over `corpus.js`, 1500 equations
  harvested from the reference models. A page, not a test framework.

## Running

No build/server/npm. Open `index.html` in a browser. First checkout needs the
submodule: `git clone --recurse-submodules …` (or `git submodule update --init`).
Verify by opening the page and checking the devtools console.

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
