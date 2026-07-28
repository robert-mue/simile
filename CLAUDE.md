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
- `src/main.js` — the app bootstrap: constructs `Sienna.App`, builds the menu,
  restores saved panels. Minimal skeleton for now.
- `src/widgets/index.js` — the widget **manifest** (currently empty; the diagram
  widget registers here once built). A widget's `src` is resolved relative to
  `index.html`, so use `src/widgets/<name>.js`.
- `src/styles.css` — app-specific styles, loaded after the shell's.

## Running

No build/server/npm. Open `index.html` in a browser. First checkout needs the
submodule: `git clone --recurse-submodules …` (or `git submodule update --init`).
Verify by opening the page and checking the devtools console.

## Key constraints (inherited from sienna)

- **Classic scripts only** — no `import`/`export`; everything hangs off the global
  `window.Sienna`. Runs from `file://`, so no `fetch`/`import()`.
- **Load order matters** — see `index.html`. Content widgets are injected on
  demand by the widget registry, not listed in `index.html`.
- **Content widgets** register via `$.widget('sienna.<name>', {…})` and call
  `Sienna.widgetRegistry._loaded('<name>', '<name>')` at the end; add a line to
  the manifest. A widget holding shared data should extend `$.sienna.widgetBase`.
  Full contract: `sienna/CLAUDE.md`.
