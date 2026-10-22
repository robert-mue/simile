# Restart note

*Rewritten 2026-10-13, at the end of two days that took the app public, wrote
all three of the old Simile tutorials, and turned up the next big idea —
embedded-widget pages. Brought up to date on 2026-10-22 (nothing new since 2026-10-21b; the
release is confirmed live). 2026-10-21 was the day
Robert called **a milestone**: a two-party association model (farmers &
fields), built by hand in the editor as he built it in the old Simile, now
checks, compiles in the page, runs and plots — farmers, fields and the
pairings between them. "What could have been show-stoppers weren't."
All of it is RELEASED as **2026-10-21**; then **2026-10-21b** (the latest)
added: submodels have a pastel background that deepens with nesting
(`_submodelFill` in `src/widgets/diagram.js`: hsl(205, 70%, 96% − 5% per
level, not below 80%), Robert's one exception to "styling later", for the
impression it makes. The editor regression net exists
(`test/editor.html`). Item 38 (what the Simulation window is for) is parked
to think through.
If you are picking this up cold — a new session, a new machine, or a week
later — read this first. `STATUS.md` is the full record (items 46–47 are the
last two days it covers); this is the part you need to get moving.*

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

**Everything is committed and pushed**, in both repositories, on `main`. Run
`git log --oneline -1` in each for where. Nothing is half-finished.

**The app is public, and released by date.** https://robert-mue.github.io/simile/
is GitHub Pages built from the **`release` branch**, not `main`: pushing to
`main` publishes nothing. A release (only when Robert says "release"):

1. append an entry at the END of `RELEASES.txt` (oldest first, **ASCII only** —
   a `.txt` opened over `file://` may mis-decode UTF-8);
2. set `window.SIMILE_RELEASE` in `src/release.js` to the same name — it is
   shown at the right of the menu bar, and Help ▸ Release notes opens the file;
3. commit and push `main`, then `git push origin main:release`;
4. an annotated tag of that name, pushed; `gh release create <name> --notes-file …`;
5. wait for `gh api repos/robert-mue/simile/pages/builds/latest` to say `built`,
   then check `…/src/release.js` on the live site.

Names are the date; a second release the same day takes a letter
(`2026-10-13`, `2026-10-13b`, `2026-10-13c` — the latest). No licence yet, the
catalogue stays public, and sienna is not to be made public yet (Robert).

**The tutorials are done.** Help ▸ Tutorials: Bank account, Predator-prey,
Trees (`help/tutorials/`, screenshots under `img/<name>/`). Written as the old
tutorials are; where the app differs, a "Not yet in the web version" note.
Each one was built step by step in the real app, headless, and its numbers
checked — the harness is now in `tools/headless/` (read its README), so
screenshots can be retaken after a UI change.

What the tutorials made us build, in one line each (STATUS 46–47 for detail):

- the **Graph tab** — sketched graphs, the file form measured on the engine;
- **lollipop display** (Widgets ▸ Lollipop diagram) and a **line per member**
  when plotting a population variable;
- the **population symbols export** (creation, immigration, loss, reproduction —
  palette shows Simile's names), and `{size}` for a list leaving a population;
- three exporter bugs that had stopped models running at all (`time()`,
  capitalised names unquoted twice over);
- running fixes: the time step applies from a reset, ▶ reloads an edited
  model, run settings remembered per model;
- File ▸ **Rename model**; renames carried into equations; the **name rule
  imposed** (underscores, no spaces — a red box and a suggestion);
- names shown **like file paths**: relative inside the viewer's own submodel
  (`a`, `S3/f`), absolute with a leading `/` outside it (`/c`, `/S1/a`);
- displays can take a variable **not yet loaded** ("from the next run"),
  filled in when ▶ next loads the model.

**Standing numbers.** Quote these only after re-running the checks below, since
they are exactly what a regression would change. All re-run 2026-10-21:

| | |
|---|---|
| catalogue round trip | **61 of 72 identical, 0 differ, 11 refused, 1 lossy import** |
| fixtures | 6 of 6 reach a fixed point and audit clean |
| equation grammar | 1391 of 1412 parse, 21 known exclusions |
| editor (`test/editor.html`) | 14 of 14 gesture tests pass |

Every remaining refusal is an element left unfinished in its source file.
(`feeding1` was the exception until 2026-10-20 — see 0b below.)

**But note what "identical" does and does not mean** — see the traps below. It
is the strongest cheap check, not a complete one. The complete one is running a
model on SimiLive.

## Now: association submodels and role arrows (Robert, 2026-10-20)

**Latest (2026-10-21, end of day): DONE.** His local rebuild
(`~/Projects/simile_models/farmers_and_fields_rm2.json`) compiled once its
rate summed the list, and now plots everything; see "Done" below for what it
took (a list where one number is needed; plotting fixed instances and
association pairings, with the run-time library rebuilt twice). Released
as 2026-10-21.

**Earlier (2026-10-21): Robert REPEATED the farmers & fields build in his
local copy** (not the release site), to try items 33–37 end to end before a
release. His first
attempt is `~/Projects/simile_models/farmers_and_fields_rm1.json` (roles
unnamed, `flow1` using a list as a value — see "Done" below). What follows
is the background as it was when he started it.

**(2026-10-20, evening) Robert is hand-building the farmers & fields
model** (`src/demo-farmers.js` is our reference copy, §9: FARMER a population,
FIELD fixed membership, OWNERSHIP an association between the two — the
two-party shape that question 0b was about). The seeded copy builds and runs
in the page as of 2026-10-20b, but it has NO influence across its association,
so it never exercised the role index; his, with values passing between farmer
and field through the association, will be the first real test of the 0b fix
in a model built in the editor. Expect `in_assoc` indices taken from each
base's own `references` list (each base lists one role, so 0 for both). If it
fails to build, trace the generator (scratch copy of
`tools/engine/generator/headless.pl` with `hl_setting(trace, true)` forced —
its `Query {…}` line names the fault, as it did for lamos1a).

Before that, he was building two minimal
demo models **himself** (deliberately, so as not to get lazy), in the release
app: one association joining two separate submodels, one with a single
submodel in both roles. The first is the `feeding1` case, which exports and
runs since the developer answered question 0b (2026-10-20, below); both
should run.

**When he hands them over** (File ▸ Export model as script → a `.js` with the
model spec and run settings): make each a `src/demo-<name>.js` like
`src/demo-pangolin.js` (header saying what it shows, the model spec, its run
settings via `Simulation.presetSettings`), add its `<script>` to `index.html`
and a seed line to `src/main.js` (~line 681). A seed runs only when no model
of that id exists, so existing users get it and an edited copy is never
overwritten — the id must not clash. The release site and a local copy keep
separate model stores.

**Term (Robert, 2026-10-20): the model JSON is the MODEL SPEC**, never "model
data" — "data" is kept for numeric data (parameter values, data files such as
soil parameters over a grid), which the app will handle one day.

## Done: Robert's farmers & fields, items 33–37 (2026-10-21, released 2026-10-21)

His hand-built model (`~/Projects/simile_models/farmers_and_fields_rm1.json`)
built but would not compile: `bad_parameter flow1 variable1_`. Fixed:

- **33** a flow drawn from a submodel's empty interior started at the
  submodel and failed: now a press or release there (any arrow but a role)
  is blank space INSIDE the submodel, and a flow grows a cloud there.
- **34** a role arrow's rubber band started at the submodel's centre: now at
  the press.
- **35** a name coming OUT of an association into a base is a LIST (one value
  per pairing) unless its role is EXCLUSIVE — Simile's `exclusive=1` on the
  relation arc (an ant is `at` one location; oom2's `lower`). Found because
  the first, stricter rule refused AntsWorld and oom2. `Diagram.roleNameIsList`
  / `roleAsWritten`: the dialog inserts `{name}`, the completeness check
  reports a bare use (red, kind `form`), the exporter refuses it with the fix
  in the message, and `assocRole` writes `list(…)` or not per role.
  `exclusive` and `can_lookup` are read and written (role `props`), and roles
  are imported in the association's `references` order — oom2 needs it
  (question 9 in the questions note). **No UI sets `exclusive` yet**: there is
  still no arc dialog (job 2). A new role is non-exclusive, so a list.
- **36** role arrows: 2.2 thick, own larger arrowhead (`slx-arrow-role`),
  curved by default (so bendable: only a curved arrow's strip takes the
  drag), a fanned pair bent evenly either way, label just outside the curve.
- **37** names ending in `_`: his role arrows had no names. A new role arrow
  is now named after its base (`farmer`; `farmer2` for a second role from the
  same base), and an unnamed one is drawn red and reported.

**His second build** (`farmers_and_fields_rm2.json`, a remake of a model he
made in the old Simile) was right except that `flow1`'s rate was the list
alone, `{variable1_submodel1}`: Simile's generator does not refuse a list
where one number is needed — it writes C++ that fails (`use of undeclared
identifier 'variable1'`). Now a field marked `scalar: true` in the schema
(stock initial, flow rate, condition, the population symbols — NOT a
variable, which may hold an array) refuses a whole-list value, red and at
export, suggesting `sum(…)`. With `sum({variable1_submodel1})` it runs.
Full type checking (a list used inside arithmetic, say) is not attempted.

**Then: nothing to plot.** Every variable in rm2 is in a fixed membership
(10 farmers, 30 fields) or the association, and the plotter offered only
single values and population members; `submodel3/variable1` was listed
"(from the next run)" because `variablesOf` took the association (kind
stored as `single`) for one instance. Now a fixed membership of ONE
dimension (`dims [n,0]`, `Simulation.isPerInstance`) is plotted as a line per
instance, like a population; association variables are left out. That needed
`sx_value` in `tools/engine/bridge.cpp` to send a 1-D array (it sent null),
so `vendor/simile-runtime/simile-runtime.js` was REBUILT (2026-10-21; the
sample pages' compiled models still run). Then (same day) an ASSOCIATION's
variables too: `sx_value` reads a sparse block with any number of indices
(a population has one, an association one per role) and keys it "i,j" —
farmer i with field j — so the plot draws a line per pairing for as long as
it exists, as for a tree; library rebuilt again. Not yet: 2-D grids on a
plot.

His model, with roles named and `sum({variable1_farmer})`, passes every check,
gets C++ from Simile's generator and runs. Generator on our exports: AntsWorld
now builds (it did not before); feeding1, lamos1a, life_input build.

**Still failing, both ALREADY before 2026-10-21, to chase:** `landuse1b` (the
landuse demo's source; Simile's own file builds, ours fails converting the
association condition `! (column==column_0 and row==row_0) and …`:
`no_such_function !`), and `oom2` (now past the lookup error, at
`circular_evaluation [my_level,hi_level]`). Also: an ARRAY-valued name out of
an association (AntsWorld's `[neighbours_at]`, `array(int,6)`) is written
bare, `1`. Trace with a scratch copy of `tools/engine/generator/headless.pl`,
`hl_setting(trace, true)` forced; the `Query {…}` line names the fault.

## Done: two-party associations and time bases (2026-10-20, released 2026-10-20b)

- **Question 0b answered** ("Waiting on the developer", below): an
  association role's index counts in the list of the submodel holding the
  link's destination. Exporter `refsOf` / `assocRole`, importer
  `resolvedRefs` / `roleAliasesFor`; `ancestor(k)` lists for submodels nested
  in a base. `feeding1` exports, round-trips and runs.
- **Time bases.** Simile's `step=N` on a submodel (it runs on time base N,
  `dt(N)`) was dropped on import, so `lamos1a` would not build. Now the
  submodel's "Time base" field (`timeBase`), read and written. The run's time
  step is padded to one value per base by repeating the last ("0.1 0.1") —
  `padSteps` in `src/simulation.js` — because nothing says what a further
  base's step should be. If Simile has a default for it, match it.
- **`lamos1b`'s GCC warning is the model's own error** (see the traps).

## Done: resizing a submodel (2026-10-20, released)

Robert found he could not resize a submodel: it had never been built (the
schema's `resizable` was read by nothing). Now `_resizeZones` /
`_beginResize` in `src/widgets/diagram.js`: invisible bands ~6 screen px wide
just inside every submodel's edges and corners, present without selecting
(dragging an edge is what people try first), resize cursors in
`src/styles.css`. One drag is one undo step (`commitDrag`), layout only. It
stops at the contents (+4), at 40×30, and — Robert's choices — **10 units**
(`_MARGIN`) inside the outer submodel and short of anything outside it; a
MOVE keeps the same margin (`_clampDrag`). A margin is never forced where the
gap is already smaller. Ports on the boundary stay on their side. Also: a
submodel's name sits just ABOVE its top-left corner; corner radius 8.

**Only submodels are resizable** (Robert): stocks are `resizable: false` like
every node. Node size belongs with node STYLING, to come — as model-level
settings and/or a styling tab in the node dialog. A stock size already stored
is still drawn.

Known: a corner drag meeting something diagonally stops both sides; two
presses on one submodel within 450 ms are a double-click (opens its dialog),
as for a move.

## Done: the Simile engine in the browser (Robert, 2026-10-15; released 2026-10-16)

Priorities changed then: job 7 below became THE job. Its purpose: responsiveness
first (sliders re-plotting at once, multi-run experiments); everything local
second. Stages of a run as Robert names them: A to Prolog (ours), B send,
C Prolog → C++ → binary, D execute, E results to client (the bottleneck),
F display. Choices: #1 wasm for the binary only, C++ still generated on a
server; #2 everything in wasm, no server (preferred). The source is on
GitHub, GPL v3: https://github.com/jal-frezie/simile (see
simulistics.com/source-code-on-github).

**Terms (Robert, 2026-10-16):** the ENGINE is what makes a runnable model;
one model's WebAssembly is the COMPILED MODEL, never "the engine"; `shank.cpp`
compiled is Simile's RUN-TIME LIBRARY (`vendor/simile-runtime/`). Older text
below keeps some old wording; file names are the new ones.

Plan (2026-10-15), each step a spike first: 1 build Simile from source with
SWI-Prolog and get a real `model.cpp` (**DONE**); 2 compile it with the fixed
engine (`shank.cpp`) by Emscripten and time it (**DONE**: unchanged source,
~1000x faster than SimiLive); **then, ahead of 3, the engine in the app and
the pages (DONE 2026-10-15)**: `src/engine-local.js` answers SimiLive's
requests from a model running in the page, for a model with a
`<name>.compiled.js` (both sample pages have one) and only while it is exactly
that model. Sliders run as they are dragged (37–140 ms a run, drawn), and a
starting value needs no rebuild. 3 run the generator in SWI-Prolog
WebAssembly, with the Tcl calls stubbed (**DONE 2026-10-15**: Simile's own
Prolog, unchanged, writes C++ with no Tcl, natively and in WebAssembly — in
Chrome over file:// in 1.3 s for predator-prey; the model database ported to
Prolog; identical C++ on the catalogue, README step 3); 4 compile the C++ in
the page — **clang spike DONE 2026-10-15** (`tools/engine/clang/`): npm
`@yowasp/clang` (LLVM 22 in WebAssembly) makes the side module, byte-identical
results to emcc's for predator-prey and Trees; ~1 s a compile once clang is
up, also from file:// (repacked as a 100 MB classic script, ~4 s to load);
download 22.6 MB gzipped. **Steps 3 + 4 in the app and the pages DONE
2026-10-15**: a model with no compiled file (edited, or any of the app's) is
generated and compiled in the page (`src/model-compiler.js`, tools in
`vendor/` from `tools/engine/build-browser-tools.sh`) and runs there; SimiLive
only if that fails. First build ~9 s, later ~3 s, undo at once; checked
identical to a slider run (README, "Steps 3 and 4 in the app"). Found and
patched a second run-time library bug on the way ("model values" crashed it: a
non-virtual destructor, `patches/fileparam-virtual-destructor.patch`).
The vendor/ tools are committed (Robert, 2026-10-16, option 1);
clang-data.js ships gzipped, 30 MB. **2026-10-16 (Robert):** embedded-widget
pages keep shipping their compiled model (`<name>.compiled.js`); the app
ships none and keeps what it compiles in IndexedDB between visits (first
visit ~7 s, then instant); names changed to the terms above (README, top).
Compiling now runs in a Web Worker, so the page stays live (README,
"Compiling in a worker"). Not yet: a smaller clang (prospects in README,
"Compiled models kept between visits").

Recipe, measurements and findings: **`tools/engine/README.md`**. Emscripten is
in `~/emsdk` (`source ~/emsdk/emsdk_env.sh`); Simile's source, built with
SWI-Prolog, is in `~/Projects/simile-src` (a separate clone; both build
scripts take it as their first argument; README step 1 rebuilds it). GPL v3 is acceptable for simile (Robert, 2026-10-15); no
LICENSE file added yet. The two run-time library bugs (README, "Slider values
lost at a reset" and "Model values crashed the run", each a one-line patch in
`tools/engine/patches/`) were reported 2026-10-19; the developer is taking
both patches.

**After an edit to a sample model, rebuild its compiled file**
(`tools/engine/build-model.sh`), or every reader's page compiles it (~10 s,
38 MB of tools) instead of running it at once.

**Parked, to come back to** (the queue on 2026-10-15, in no settled order;
Pangolin went out in release 2026-10-16): infer `units=boolean`; warn when a value is outside
min/max; a submodel's OWN background colour (Simile's `fill_colour`, still
dropped by the importer; the pastel nesting shade, done 2026-10-21b, is only
the default); the model file reference (job 6); MORE tests for the editor
regression net (job 1, started 2026-10-21); the arc dialog (a role's
"exclusive" needs it); automatic layout (below);
node sizing and styling (2026-10-20, with model-level settings).

## Parked: what the Simulation window is FOR (Robert's item 38, 2026-10-21) — think first, then build once

Robert: decide this definitively rather than rush in and change it again.
The discussion itself, near verbatim: `NOTE-run-control-loading-model.md`.
What is settled and what is open:

- **Settled (his view):** anyone who opens or starts a model expects its
  Simulation window to apply to it, with no explicit "load". Inside a model's
  Simulation collection the run control already belongs to that model
  (`_ref()`, `Simulation.viewFor`); its model menu, path box and load/unload
  are left over from when it was a general SimiLive client. Proposed then:
  ▶ loads (or reloads) and runs; reset loads and goes to the start.
- **Where SimiLive's own demos go** (fire spread, Game of Life, diffusion,
  three-body, branching plant — reachable today only through that menu): NOT a
  specific top-level menu (he dislikes it). Under File ▸ Models instead — but
  File ▸ Models should first become a rich, grouped collection (sub-menus),
  which we are not ready for.
- **Open: more than one model at once.** Today there is ONE session: ▶ on B
  ends A's run. Robert can see a user wanting several models loaded together
  and SHARING ONE Simulation window — the same variable in two
  similar-but-different models, plotted together. That changes the model:
  sessions per model (the in-page engine makes several cheap), and displays
  whose series name a model as well as a variable. Settle this before
  touching the run control, since it decides what the window is.

## Parked: automatic layout (Robert, 2026-10-19) — discussed, not started

Parked by Robert 2026-10-20 in favour of association submodels and role
arrows (he is building two demo models himself). Pangolin was laid out by hand (by Claude, on a grid of round
numbers); nothing in the repo computes a layout. Robert wants a layout tool
users can run, for: tidying a messy model; re-laying out after a big
deletion; laying out a model written as text (job 6: no coordinates to
write); and shrinking submodels whose contents are hidden, closing up the
diagram.

Proposed: **ELK** (`elkjs`, ~1.5 MB, EPL-2.0), loaded on first use like the
model compiler — the one library that does nested graphs (submodels, arcs
crossing their boundary). Its layered layout gives the same result for the
same model (no random repositioning), and can start from the current order.
Robert's question was **pinning**: per submodel, yes (ELK's `fixed`
setting leaves its contents alone); per element, only relative (layer /
position-in-layer constraints) in the layered layout, exact only in the
"stress" layout; and a cheap stand-in: shift the result so one chosen key
stock lands where it was. All from memory of ELK, NOT yet tried.

Constraints: a stock's flow chain (clouds, valves) stays straight and moves
as one; influences left to our own curve drawing; a layout changes `layout`
only, one undoable step. **Hiding a submodel's contents does not exist yet**
(only planned: `collapsed` in `DESIGN-diagram.md`) — it comes before the
layout can shrink one.

Suggested order: 1 a spike of ELK on Pangolin, the three reference models and
one with submodels, trying relative pinning and fixed submodels; 2 hiding a
submodel's contents; 3 a "Tidy layout" command combining them.

## Done: embedded-widget pages (Robert, 2026-10-13)

Finished 2026-10-14; kept for its findings. Robert's idea: the
widgets are self-contained, so they can sit in an **ordinary web page** — an
editable diagram, a graph of chosen variables further down, and a
**multiple-slider widget** (not yet built) so readers vary parameters and see
results live. "Not YAME (yet another modelling environment), but a simple way
of making dynamic web pages" — and "a way that anyone can document some, any,
dynamic system, not just for us to present some models." The whole model
catalogue could be built this way.

**Decided** (narrowed by Robert, 2026-10-14):

1. reader edits are **not kept** — fresh each visit, with a **reset** button;
2. the model **runs as soon as the page opens**, graphs already drawn;
3. the point is **independence**: documentation on how ANYONE can do it, kept
   in the simile repo. The guide is the product; the samples are its worked
   examples.
4. **One new command for now: File ▸ Export model as script** — a `.js` file
   loaded by `<script>` (which DOES work over `file://`; a page opened from disk
   cannot fetch a file beside it). Proposed form, a call rather than a bare
   assignment so two models on a page cannot collide:
   `Simile.model('predator-prey', {…})`. Export as a self-contained web page is
   **not** in the goal now.
5. the **multiple-slider widget is needed by the app itself**, not only by the
   pages — it is an ordinary widget first. It offers every variable that has a
   **value specified and a min/max**.

**Plan:**

1. **Predator-prey page**, using the **re-cast model of Stage 3, Step 3** of the
   tutorial (`help/tutorials/predator-prey.html#stage3`, picture
   `img/predator-prey/s3-diagram.png`: `eaten_per_fox` and `rfox` between the
   two populations). Mathematically the same as Stage 2's Lotka-Volterra form,
   but it does not hide important design aspects in an equation (Robert).
   Diagram, rabbit and fox plots, runs on open.
   **DONE 2026-10-14**: `pages/predator-prey/` (model in `predator-prey.js`,
   made by running the tutorial scripts P1–P3 headless; `src/page.js` is the
   runtime; `pages/pages.css` shared). Runs on open (final values 469.50 /
   79.75, as the tutorial's), an edit re-runs it after 1.2 s of quiet, **Run
   again** and **Reset model** work, nothing is kept. sienna gained
   `SIENNA_EPHEMERAL`, a widget `ref` option, `widgetRegistry.embed`/`setBase`
   (its demo: `examples/demo/embedded/`). On a page the diagram shows only
   the view commands (Robert chose this over hiding the palette entirely);
   elements still open by double-click.
   **Parameters (2026-10-14, Robert):** on the page, every constant in the
   rate equations is a parameter variable (nothing influences it) with a range
   of 0.5–2× its value: `rabbit_birth_rate` 0.5, `attack_rate` 0.01,
   `conversion_rate` 0.01, `fox_death_rate` 0.2. Results unchanged. The range
   is `props.min` / `props.max` on a variable (schema fields Minimum/Maximum,
   strings as the dialog writes them). The starting populations are
   parameters too, `initial_rabbits` 5000 and `initial_foxes` 45, each
   influencing its stock, whose initial value is the parameter's name.
2. **The multi-slider widget** — **DONE 2026-10-14**: `src/widgets/sliders.js`
   (Widgets ▸ Sliders in the app; `data-simile="sliders"` on a page, which the
   predator-prey page now has). Measured on the page: a rate slider re-runs in
   ~1.5 s, a starting population in ~3 s (the model is rebuilt), "model values"
   puts them back. Slider values never touch the stored model. How it works,
   and what was found getting there, is under "Sliders" below.
3. **File ▸ Export model as script** — **DONE 2026-10-14** (`exportScriptFile`
   in `src/main.js`): `<name>.js` holding `Simile.model(name, model, run)`,
   the name made from the model's (`Predator-prey` → `predator-prey`), the run
   settings those chosen for it. The sample page's `predator-prey.js` IS such
   an export, checked identical to the hand-made one.
   **The guide — DONE 2026-10-14**: `help/pages.html` (Help ▸ Live models in
   your own web pages). It rests on **`embed.js`** at the top of the repo: the
   ONE script tag a page needs, which loads the rest from wherever it came
   from, sets SIENNA_EPHEMERAL, and queues `Simile.model`/`Simile.page` calls
   until loaded. The guide's example page uses the PUBLIC address,
   `https://robert-mue.github.io/simile/embed.js`, which exists only from the
   next release. Checked: the example exactly as printed (pointed at the local
   copy), and an author's page in an unrelated folder. sienna's `styles.css`
   now keeps its whole-window rules off a page that is not the app's
   (`slx-embedding` on `<html>`). The lollipop's names (`tree/x` …) were
   checked with Trees: they are right, and the lollipop picks variables
   called x, y and size by itself, which the guide now says.
4. **One more sample only: Trees** — **DONE 2026-10-14**: `pages/trees/`
   ("A stand of trees"), the tutorial's Stage 4 model, built by
   `tools/headless/scripts/trees.py`, re-cast as for predator-prey: four
   top-level parameters with influences INTO the population — initial_trees
   (2.5–10), recruitment_rate (1–4), max_size (12.5–50), death_size
   (3.5–14, value 7, see below) — and `trees.js` is an actual export. Diagram, multi-line plot
   of tree/size, total, lollipop, sliders. Found on the way:
   - A parameter feeding a CREATION (`initialiser`) is a starting value too:
     `reachesStock` now counts it, so initial_trees rebuilds the model.
     Simile truncates a fractional count (7.5 → 7 trees).
   - The run was fetched in 60 chunks, not 20: `updateEach` was worked out
     from the model's default run length (100), and the page's 300 applied
     after. Now it follows the run length in force, on load and when
     runLength/logEach change (unless set by hand in Update each). Run again
     8 s → 4.3 s. The app had the same fault when a run was lengthened.
   - With death_size 17 and 300 years (the tutorial's), ~280 trees and ≈5 MB
     per run: a slider took 8–11 s. Robert: fewer trees tell the story as
     well, so death_size is now 7 (3.5–14) and the run 60 years — the stand
     settles by ~35 years at ~50–60 trees. Run again 1.2 s, a rate slider
     1.5 s, initial_trees (rebuild) 5–11 s.

**What is known already:**

- A widget finds its model through its host PANEL's `ref`
  (`widgetBase._ref`). Outside a workspace there is no panel, so the shell
  needs a way to give a widget its `ref` directly — a small sienna change.
  Everything else a widget needs is the shell scripts and a model in
  `userData`; one `Sienna.Simulation` session serves the page.
- **Sliders — what SimiLive does (measured 2026-10-14):**
  - Only a variable written in Simile's SINGLE-NODE form — value, `spec`,
    `min_val`, `max_val` on the `variable` node, no function node — is described
    as `eval: "INPUT"`. The same on a function node is just a `DERIVED` value's
    range, and `Parameterize` silently does nothing to it. Adding
    `param_type=variable` or `fixed` to either form stops the build
    ("Failed to build executable", or a Prolog stack overflow).
  - `Parameterize {captpath: "NOW v"}` sets a variable parameter at once; every
    Reset (any depth) puts it back to the model's value. So values are sent
    again after each reset (`Simulation.reset`).
  - A stock's starting value is fixed at reset from the parameter's DEFAULT,
    so `Parameterize` cannot move it (Simile's own equation dialog refuses
    variable parameters for initial values). `param_type=file` ("fixed
    parameter", `eval: "TABLE"`) does take a plain value at the next reset —
    but then the equation's value is ignored (an unset one started rabbits at
    6.9e-310), which would change the model's meaning in desktop Simile. So
    instead a parameter leading to a stock reloads the model with the value
    written in.
  - Simile 7.5's help and Tcl are installed locally:
    `/usr/share/doc/simile-7.5/run/sliders.htm`, `…/equations/dialogue.htm`,
    `/usr/share/simile-7.5/Run/equation.tcl`.
- The importer now keeps a variable's `min_val`/`max_val` (as `props.min`/
  `max`, from either form) and the exporter writes them back, so the catalogue
  round trip is unchanged: 60 of 72 identical, 0 differ, 12 refused.
- Ask the Simile developer whether SimiLive can bear public pages' load.

**After that:** a submodel's own background colour (`fill_colour`, still
dropped by the importer; the default nesting shade is done, 2026-10-21b), and the model's own **time units** (displays say
"unit") — **PARKED 2026-10-14 (Robert):** more than naming the unit; e.g.
different submodels can have different time units. Found trying "year" on
Trees (reverted, nothing committed):
  - In Simile the unit is a RUN setting (run control "Time unit", saved in
    the `.sts`), not in the `.pl`: no catalogue `properties(...)` has one.
  - SimiLive takes `timeUnit year` in the `.sts`, and we already scale
    times to days (`TIME_LIB`, step/runlength/log × 365) as desktop Simile
    does (`runmodel.tcl` unitLength, `exec.tcl`). But the compiled model's
    rates stay per DAY: predator-prey in years blew up to Inf/NaN in its
    first step (step 36.5), and Trees made ~155 trees/yr, not 2. So a
    unit is only meaningful with rates given time dimensions (`units=…`,
    e.g. `units=day` appears in indivpop1.pl) — the units system proper.
  - A display-only label (say "year" while the engine runs plain units)
    would be the cheap option if wanted before then. Two small TODOs from the tutorials: caret insertion in the equation
dialog tracks `keyup` only (on-screen keyboards).

## Pangolin harvest, converted from R (2026-10-14)

Robert brought an R model (Almeida et al. 2023, `AAE_OE`: pangolins, a
common species, harvest effort — three ODEs). Built as data, not step by
step: `src/demo-pangolin.js`, seeded as File ▸ Models ▸ Pangolin harvest
(1000 years preset). How it was converted and checked is in its header —
identical to the R Euler loop to ~1e-15 in three scenarios. Found:

- **The exporter wrote 1.0e12 as thirteen digits** (`String()`), and
  SimiLive's C++ then failed: "call of overloaded min(long int, …) is
  ambiguous" — a parameter's range is applied as
  `min(max_val, max(min_val, value))`. `prologNumber` now keeps an exponent
  (with a fraction) and makes a whole number past an int's range real.
  Round trip unchanged (60/72 identical, 12 refused).
- **A condition variable needs `units=boolean`**, or the model does not
  build (`mismatched_units`). Desktop Simile infers it; we do not — set by
  hand on `feasible`. TODO: infer `boolean` from an equation whose top is a
  comparison / and / or / not.
- **`if c then x else 0` does not build** when x is real: write `0.0`.
- **SimiLive clamps a parameter to its min/max**, silently. A value typed
  outside the range runs as the nearer limit — the dialog should say so.
- Not converted: the script's state noise `g` (0 in the paper's main runs)
  and its experiments (sweeps, 1000-run Monte Carlo) — no batch runs yet.

## Layouts (2026-10-09, merged)

The workspace is no longer one floating pile. sienna gained containers,
tiled/tabbed modes, placement by role, per-document collections and layouts
(sienna `DESIGN.md` Part III), and simile now uses them — `src/layouts.js`:

- **Model and simulation windows** (the default since 2026-10-12, Robert's
  choice for the novice): Simile's own arrangement — a model window and a
  simulation window, floating, each 56% of the workspace wide, both opened
  when a model is. A second model's pair arrives offset from the first.
  Closing the model window (or its diagram) closes its simulation window too.
  View ▸ **Windows** lists every window to bring one forward; View ▸ **Arrange
  windows** puts this model beside its simulation, two models side by side,
  or two simulations side by side. "Window" means a top-level collection,
  "panel" what holds one widget (sienna DESIGN.md §19.2).
- **Model and simulation areas**: Models | Simulations side by side,
  each tabbed by model. A model's first diagram makes its **Model collection**;
  its first run control or display makes its **Simulation collection** — a run
  control above a tabbed **Displays**. Each collection carries the model's
  `ref`, so its colour, and closes when its last panel does.
- **Free (floating)**: what simile had before. View ▸ Layout switches, and
  re-opens every panel into the new arrangement.
- Roles in `src/widgets/index.js`: `diagram`, `run-control`, `display`.

**One session at a time still.** `Sienna.Simulation` is a single SimiLive
session. A run control or display in a model's Simulation collection sees it
through `Simulation.viewFor(ref)`: only while its own model's run control
loaded it (or its model is what an unbound one loaded). Loading from another
model's run control replaces it, and the first model's displays go blank. A
session per model — two runs side by side — is the obvious next step and was
deliberately deferred.

Every collection has an **Arrange contents** button (its titlebar, or its tab
in a tabbed area) to switch it between floating, tiled and tabbed. Every panel
is titled `<model>: <widget>/<n>` from the moment it appears (a template's run
control included), and keeps its number across a refresh.

## Check nothing has rotted, in three minutes

No build, no npm, no server. Open each page and read the coloured bar.

1. **`test/fixtures.html`** — needs nothing. Green means the converters and the
   completeness check still agree with all six demo fixtures.
2. **`test/index.html`** — needs nothing. The equation grammar over the corpus.
3. **`test/roundtrip.html`** — press the button and select all 72 `.pl` files in
   **`reference/catalogue/`**. The slow one, and the one that matters most.

Then open `index.html` itself and check the devtools console is clean.

All three can be run without a hand: `tools/headless/scripts/test-pages.py`
and `roundtrip.py` (see `tools/headless/README.md`).

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
  spelling, and it runs over the store at startup and over anything File ▸ Open
  reads. A file saved now is refused by an older build. `FORMAT` is now 3:
  node glyphs were shrunk to 70% (2026-10-13; text unchanged), and `migrate`
  scales a format-2 model's stored stock sizes to match.
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

The older queue, still true (embedded-widget pages and the engine, which went ahead of it, are done):

### 1. A regression net for the EDITOR — STARTED 2026-10-21

**`test/editor.html`** + `test/editor-tests.js`: 14 tests, all green, ~0.4 s.
Real diagram widget (through `embed.js`, so real store/actions/history and
nothing kept), real PointerEvents dispatched at `elementFromPoint`, positions
in diagram units at a fixed view `{0,0,1}`. Covers placing, drawing
submodels, Robert's items 33/34/37, resize + its margins and undo, move +
undo, the submodel label. Proved by breaking three fixes on purpose (item 33,
`_MARGIN`, the label's `text-anchor`): each turned exactly its test red.
**Next for it:** the property dialog (open by double-click, edit, OK — the
equation names offered, item 35's `{…}` insert), influences and their
bending, ports (drag along the boundary), delete + undo, band select,
copy/ungroup, and the panel-level things this page cannot reach (titles,
thumbnails — those need the whole app). Each gesture bug Robert finds:
add its test here first.

(The original case for it, kept:)


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

Deliberately set aside at the start; Robert has never used it. **Learned
2026-10-19 from the developer:** immigration, reproduction and loss can each
be a discrete EVENT instead of a rate, signified by an incoming event
influence, adding or removing members at once when the event occurs — so event
modelling needs at least an event influence besides `alarm`. `alarm` is
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

### 6. A model file reference — writing models without the app (2026-10-14)

Robert's question: someone who wants a model built by describing it to Claude,
without using the app, needs a document to point Claude at. The full reasoning
is in `NOTE-model-file-reference.md`. Settled:

- **Its own document, not the Simile manual.** The manual never describes our
  JSON format, is written around the GUI, and differs from us in places
  (`compartment`/`stock`, the name rule, what is not implemented). Not
  "optimised for Claude" either — what serves Claude (precise, complete,
  example-heavy) serves a person writing a file by hand. One "Model file
  reference" in this repo, for both; also a chapter of the embedded-widget pages guide.
- **The format is STATED, in field tables** — every node type, every field,
  required or not, defaults, what is refused. Examples illustrate it; they do not
  define it (anything no example happens to use would otherwise be guessed).
  Concepts get a paragraph each, in the manual's words, so they can be looked up.
- **Complete worked examples**, each one a file known to load and run:
  predator-prey (Robert's), one with a submodel, one population model.
- **Checking is part of the procedure, written in the document** as a required
  step, not something the user has to ask for: import + completeness check, then
  build and run on SimiLive, fix, repeat, and report the result. It needs a
  route that takes a file and returns a list of problems — the pieces exist
  (importer, `Diagram` checks, `Simulation.loadOwn`, `tools/headless/`) but
  nothing yet accepts a file from outside. The document must also say what to do
  where Claude cannot run anything (claude.ai chat): hand over the file with the
  check spelled out for the user. Remember SimiLive is a shared host — `unload()`.
- **It must not rot.** The examples are checked with the fixtures; field lists
  generated from the schema where possible (the `test/corpus.js` lesson).
- Do not target `.pl`: harder to get right, and errors would come back through
  the importer instead of our own checks.

### 7. The Simile engine in the browser (Robert, 2026-10-14) — DONE, released 2026-10-16

See "Now" above; kept for why it was wanted.

Run models on the client instead of SimiLive — the whole chain, Prolog
interpreter and C++ compiler included (WebAssembly, presumably) — for far
better responsiveness: a model re-run CONTINUOUSLY as a slider moves, rather
than ~1.5 s after it is let go (~3 s for a starting value, which rebuilds).
It would also remove the public-load question for embedded-widget pages. For
another day; a discussion first, not a job to start.

## Waiting on the developer

**The population-symbols email was sent and answered 2026-10-19**: creation is
the starting count (a fraction ignored); immigration a rate overall,
reproduction a rate per member; loss a probability per time unit, or a boolean
as 1/0. Recorded under A2 in `NOTE-questions-for-developer.md`; the dialog
labels follow it.

**Sent 2026-10-20: `NOTE-email-followup-questions.md`**, the questions
of `NOTE-questions-for-developer.md` still worth asking, numbered as there:

1. *(0b)* **ANSWERED 2026-10-20**: "N is the position of the role in the
   reference list of the submodel containing the destination node of the
   link." So `in_base` indexes the association's list (as we did) and
   `in_assoc` the BASE's own list (we used the association's) — the two
   differ only when an association joins two different bases. Both the
   exporter and importer now follow it, including the `ancestor(k)` lists of
   a submodel nested in a base. `feeding1` round-trips identically, its
   `use(…)` terms match Simile's own file, and it compiles and runs in the
   page. Recorded under 0b in `NOTE-questions-for-developer.md`.
2. Still awaited: *(4)* the dimensional rule for references across a boundary; *(5)* the
   submodel kinds `type=records` and `count=[size(…)]`; *(7)* whether arc
   `course` points are visual only; *(1)* `usr(…)`; *(2)* `use_sofar`,
   `enabled_roles`, `in_8_nbrs`.

Dropped: whether SimiLive can take the load of public embedded-widget pages —
pages now run their model in the reader's browser, and SimiLive is only the
fallback.

Six re-saves in Simile 7.4 already answered the population-symbol spellings, the
association-alias convention (there isn't one), `border` vs the legacy plain
`variable`, and what `alarm` is.

## Things that will bite you

- **A stylesheet beats an SVG presentation attribute.** `text-anchor`,
  `fill`, `stroke` set by the renderer as ATTRIBUTES lose to any CSS rule
  that names them: `.slx-label`'s `text-anchor: middle` silently centred
  every submodel name for months, despite `setAttribute('text-anchor',
  'start')`. Say it in `src/styles.css` with a more specific class.
- **Headless scripts and the diagram's timings and bands.** Two presses on
  the same element within 450 ms are a double-click (`_isDoubleClick`) — a
  script that drags twice in a row opens a dialog instead: pause 0.6 s. A
  press within ~6 px of a submodel's edge now RESIZES it rather than moving
  it, and a port sits on the edge where an arc crosses it.
- **`pkill -f <pattern>` kills its own shell** when the pattern appears in
  the command line running it. Anchor it: `pkill -f "^/opt/google/chrome/chrome --headless"`.
- **Round-tripping is not running.** A model can reach a perfect fixed point and
  still produce Prolog that Simile refuses to build — the comparison is our
  model against itself and never asks Simile anything. Sampled 14 of the 54: 12
  build; `lamos1a` and `embryo1` do not, *though their originals do*. Item 44.
  (2026-10-20: `lamos1a`'s failure FOUND — we dropped Simile's `step=2` on
  its submodels, so the `dt(2)` its equations use named a time base the
  model no longer had: `bad_index_number(2,dt,1)`. Now the submodel's "Time
  base"; it compiles and runs in the page. `lamos1b` compiles in the page
  too, original and ours. Robert's Simile reports a GCC warning compiling it,
  "iteration 225 invokes undefined behavior": the FILE is wrong — enlarging
  lamos1a's grid to 1600 changed `patch` and `fire_patch` but left
  `patch_results` at 225, so a loop over 1600 reads past its end. Our export
  copies it faithfully; clang does not warn. Not run.)
  `Sienna.Simulation.loadOwn('models/growth')` from the console is the short way
  to ask the engine; `unload()` afterwards, it is a shared public host.
- **The scratch directory is `/tmp` and does not survive a reboot.** It has been
  wiped twice, taking every analysis harness with it. That is why the regression
  net lives in `test/` as pages, and the headless harness in `tools/headless/`.
  Put anything you want to keep in the repo.
- **Changes to sienna must be copied into `simile/sienna` to be tried** —
  Robert tests the app, which loads the submodule. On "commit and push both":
  commit and push sienna, then in `simile/sienna` check out `origin/main`
  (after making sure the copied files match), then commit simile.
- **Offer Robert choices numbered #1, #2…** — he answers by number.
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
