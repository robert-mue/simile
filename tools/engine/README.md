# Simile's simulation engine in the browser

Work towards running models locally (RESTART.md, "Now").

**Terms** (Robert, 2026-10-16). The ENGINE is what makes a runnable model:
Simile's generator and a C++ compiler. What it makes for one model is the
COMPILED MODEL (a WebAssembly side module), never "the engine". A compiled
model runs linked to Simile's RUN-TIME LIBRARY, `Run/shank.cpp` compiled once
(`vendor/simile-runtime/simile-runtime.js`). Names in this file before
2026-10-16 were changed to match: `simile-engine.js` is `simile-runtime.js`,
`build-engine.sh` is `build-runtime.sh`, `<name>.engine.js` is
`<name>.compiled.js` (calling `Simile.compiledModel`), `engine-file.js` is
`compiled-file.js`, `src/engine-build.js` is `src/model-compiler.js` (the
step 2 spike, `page.html` with its own `engine-web.js`, kept its names).

Simile's source is https://github.com/jal-frezie/simile (GPL v3). This folder keeps what the spikes
need, because the scratch directory does not survive a reboot.

**The Simile checkout lives at `~/Projects/simile-src`**, built as below: a
separate clone, beside this repository and not in it. Both build scripts take
it as their first argument. If it is missing, clone and build it again.

## Step 1: Simile from source, writing a model's C++ (done 2026-10-15)

Needs `swi-prolog-nox gprolog tcl-dev tk-dev libxcursor-dev portaudio19-dev`
(all installed) and a display, because the Tk GUI is started.

    git clone https://github.com/jal-frezie/simile.git ~/Projects/simile-src
    cd ~/Projects/simile-src
    # patchelf is not installed, and only sets rpaths: a do-nothing one will do
    PE=$(mktemp -d) && printf '#!/bin/sh\nexit 0\n' > $PE/patchelf && chmod +x $PE/patchelf
    PATH=$PE:$PATH make PROLOG=SWI         # then run with LD_LIBRARY_PATH
    cp <this folder>/zz_export_cpp.tcl Extensions/   # loaded at start-up

    mkdir -p /tmp/simhome/.simile && cp Run/mdlrinfo.swi /tmp/simhome/.simile/mdlrinfo.txt
    HOME=/tmp/simhome LD_LIBRARY_PATH=$PWD/System/lib \
      SIMILE_EXPORT_IN=/abs/model.pl SIMILE_EXPORT_OUT=/abs/model.cpp \
      tclsh System/bin/simile

The separate `HOME` is there to leave the installed Simile's `~/.simile` (set to
GNU Prolog) alone. The extension opens the model, runs the menu command
`code build_c` (which is what Scripting.tcl's commented-out `ExportCppCode`
did; `buildShareLib`, "added for building models on web server", is the
SimiLive route), and exits. The output compiles into a model library the way
Simile builds one:

    g++ -c -fPIC -I Run -o model.o model.cpp
    g++ -c -fPIC -std=c++11 -I Run -o support.o Run/support.cpp
    g++ -shared -fPIC -o model.so model.o support.o -L System/lib -l5d

The extension leaves `~/.simile/handover.txt` behind (Simile's one-copy-only
check), and the next start then hangs trying to hand its model to a copy that
has gone. **Delete `$HOME/.simile/handover.txt` before each run.**

Our own models: `export-pl.js` runs the app's exporter under Node (there is no
system node; use emsdk's, `source ~/emsdk/emsdk_env.sh`):

    node tools/engine/export-pl.js pages/trees/trees.js /abs/trees.pl

`predator-prey.cpp.sample` and `trees.cpp.sample` are what Simile made of the
two sample pages' models.

## Step 2: the run-time library in WebAssembly (done 2026-10-15)

`driver.cpp` drives a model through the run-time library's C API, single-threaded, as a
display would: `load_model`, `fetch_top_instance`, `setstep` for phases 1–7,
then per run `reset(…, -2)` and `execute` one log interval at a time, reading
each named node with `get_raw_values` after each interval.

    R=<simile>/Run
    # native, for comparison
    g++ -O2 -c -fPIC -I$R -o m.o model.cpp && g++ -shared -fPIC -o model.so m.o support.o -L<simile>/System/lib -l5d
    g++ -O2 -std=c++11 -Istubs -I$R -o driver driver.cpp -L<simile>/System/lib -l5d
    # WebAssembly: the model is a side module, the run-time library the main module
    emcc -O2 -fPIC -Istubs -I$R -sSIDE_MODULE=1 -o model.wasm model.cpp $R/support.cpp
    em++ -O2 -std=c++11 -Istubs -I$R -sMAIN_MODULE=1 -sALLOW_MEMORY_GROWTH=1 \
         -sNODERAWFS=1 -o engine.js driver.cpp $R/shank.cpp        # for node
    em++ … -sSINGLE_FILE=1 -sMODULARIZE=1 -sEXPORT_NAME=SimileEngine -sINVOKE_RUN=0 \
         -sEXIT_RUNTIME=0 -sEXPORTED_RUNTIME_METHODS=callMain,FS -o engine-web.js …  # for a page

    driver <model> <run length> <time step> <log every> <runs> node00002:rabbits …

`page.html` loads `engine-web.js` and `model-<name>.js` (the side module as
base64, `window.SIMILE_MODELS[name]`) by `<script>`, so it works over
`file://`, writes the bytes into the run-time library's file system and dlopens them.

**What it took:** nothing in Simile's source changed. `stubs/portaudio.h`
stands in for PortAudio (only the wave commands use sound). Link with `em++`,
not `emcc`, or the C++ runtime is missing from the main module.

**Results.** Identical numbers native and in WebAssembly; predator-prey
469.5042746 / 79.75123252 at t=50, the tutorial's. Trees is stochastic
(`rand_const` per tree), so runs differ slightly. Per run, after the first:

| model (as on its sample page) | wasm, node | wasm, Chrome, file:// | native | first run (wasm) |
|---|---|---|---|---|
| predator-prey, 50 × dt 0.1, log 1 | 0.58 ms | 0.55 ms | 0.43 ms | ~3 ms |
| Trees, 60 × dt 0.1, log 1, ~57 trees, every size read | 1.43 ms | 1.45 ms | 1.12 ms | ~5–9 ms |

SimiLive for the same: Run again ~1.2 s, a rate slider ~1.5 s, initial_trees
(rebuild) 5–11 s. The run-time library was ready 75–135 ms after the page opened;
`engine-web.js` is 2.1 MB because `MAIN_MODULE=1` exports all of libc
(`MAIN_MODULE=2` with an export list should shrink it a lot).

**Found:**

- **Populations read as `UNSTABLE`** through the single-threaded calls:
  `GetRawValues` withholds a population while `userStop.completed` is 0, which
  only the threaded path changes. The driver calls
  `((ExecutingModel*)inst)->set_completion(2)` after each `execute`.
- **Two models in one run-time instance collide.** Whichever is dlopened first works;
  the second reads nothing (each model carries its own copies of support2's
  globals, and the first binding wins). Avoided, not solved: the page starts
  one run-time instance per model (`Sienna.LocalEngine.open`).
- Value blocks: `dimSpecs[0]` is the TYPE for a single value (`REAL` = -1;
  types are zero or negative), `SPARSEARRAY` (-5) for a population, whose
  contents are a `sizeAndPtr` {count, pointer to doubles}.
- `go_reset`/`go_execute` start threads; WebAssembly threads need
  SharedArrayBuffer and so COOP/COEP headers, which neither `file://` nor
  GitHub Pages can give. `reset`/`execute` ("single-threaded versions for
  external clients") avoid them. The run-time code still calls `pthread_create` for
  group members (1467, 1537); not exercised yet.

## In the app and the pages (done 2026-10-15)

A model with a compiled model file runs in the page; any other runs on
SimiLive, as before. Nothing is compiled in the page yet (that is step 3).

- **`bridge.cpp`** — the run-time library's C API as a few calls for JavaScript
  (`sx_load`, `sx_describe`, `sx_reset`, `sx_execute`, `sx_value`,
  `sx_param`, …), answering in SimiLive's shapes.
- **`build-runtime.sh <simile source>`** → `vendor/simile-runtime/simile-runtime.js`
  (2.1 MB, one script, so `file://` works). Applies `patches/*.patch` to a copy
  of `shank.cpp` first.
- **`build-model.sh <simile source> <model script> <out .compiled.js>`** — model
  script → `.pl` (the app's exporter) → C++ (Simile from source, ~10 s, opens
  its window briefly) → side module → `<name>.compiled.js`, which calls
  `Simile.compiledModel(name, {prolog, wasm})`. `prolog` is a fingerprint of the
  exported Prolog (`Sienna.LocalEngine.fingerprint`), so the compiled model is used
  only for exactly that model: edit it and it runs on SimiLive, undo the edit
  and it runs here again.
- **`src/engine-local.js`** — `Sienna.LocalEngine`: holds the compiled models,
  starts a run-time instance per model, and answers SimiLive's requests
  (`web_embed.tcl`'s `ResponseTo`, ported). Checked against a recorded
  SimiLive session: predator-prey's Describe, Reset and ExecuteMulti identical
  to the last digit; Trees' Describe identical in structure (populations as
  `{member: value}`, member numbers kept for life).
- **`src/simulation.js`** — `loadOwn` runs the model in the page when a compiled
  model is registered for the model; `_post` goes to it instead of the network. A run
  is one request rather than `updateEach` chunks.
- **Sliders** — in the page, the run follows the slider as it is dragged
  (`previewParameter`; runs are coalesced, only the latest is made), and the
  value let go at is the setting (`setParameter`, one action). Starting values
  need no rebuild: the slider values are sent BEFORE the reset, as the whole
  set, and the reset keeps them (the run-time library's "slider rollover", `how_int` -1).
- Pages: `pages/<name>/<name>.compiled.js` beside `<name>.js`, loaded by a
  script tag; `embed.js` queues `Simile.compiledModel` like `Simile.model`.

Measured in Chrome over `file://` (a slider let go, to the run drawn):
predator-prey 37–47 ms; Trees 60–140 ms. SimiLive: ~1.5 s, and 3–11 s for a
starting value. A drag of 40 mouse moves made ~40 runs.

**Faults found on the way, in Simile's run-time code and in how it is driven:**

- **Slider values lost at a reset** — a bug in Simile's run-time library:
  `VarParamData`'s constructor never sets `inheritSeries` (6d.h:110), and
  `InitTimeSeries` frees a parameter's value at every reset when it is true
  (shank.cpp ~1190). Whether it is depends on what the heap held: it worked
  until `Describe` had run. `patches/varparam-inheritseries.patch` sets it.
  **For the Simile developer.** It could misfire on SimiLive too.
- **"Model values" crashed the run** (memory access out of bounds) — a
  second bug in Simile's run-time library: `~FileParamData()` is not virtual (6d.h:64),
  so `forget_param_array`, deleting a slider's `VarParamData` through a
  `FileParamData*`, never runs `~VarParamData`, which takes it off the
  instance's `varParamArrayBase`. The next reset that keeps sliders walks
  the freed block. Node survived it (the memory not yet reused); the page
  did not. `patches/fileparam-virtual-destructor.patch` makes it virtual
  (only shank.cpp includes 6d.h, not a model). **For the Simile developer**:
  `clearparamarray` in `ame_cmx.c` does the same.
- **Every run drew the same random numbers** — `setup_randoms` raises
  `rand_inits_updated`, and every reset and execute that sees it starts the
  stream again from the seed. The threaded path lowers it after its first job
  (`check_thread`); the single-threaded calls did not, so each call restarted
  it (in Trees, every tree of a year at the same place with the same growth
  rate). The bridge lowers it after each call. Also: the single-threaded
  `reset` does not seed; `sx_reset` seeds on the first, full reset, as
  `go_reset` does from the clock.

**Not yet:** grid renderings (`{format: 'binary'}` notes answer null), values
that are arrays or records, integration methods other than Euler's fixed step,
models in the app (only pages register compiled models), and the run-time
library's size.

## Step 3: Simile's generator with no Tcl, then in WebAssembly (done 2026-10-15)

`generator/` — Simile's own Prolog, unchanged, writing a model's C++ with no
Tcl/Tk, natively or in SWI-Prolog's WebAssembly build.

    swipl generator/headless.pl [--structdb=prolog] ~/Projects/simile-src in.pl out.cpp
    node generator/run-wasm.js <swipl-wasm package> ~/Projects/simile-src generator in.pl out.cpp

**How.** Simile's Prolog talks to Tcl over a pipe; recording that traffic
during a real "open model, export C++" session (`SIMILE_PIPE_LOG` in
`zz_export_cpp.tcl`) showed what it asks: ~40 kinds of request, most of them
drawing. `headless.pl` replaces the one predicate that sends a request
(`tcltk:any_tcl_eval/3`) with answers made in Prolog — files directly,
drawing and progress ignored, the two file choices from settings — and then
calls the three goals Tcl would (`tk_make_desktop_node`, `tk_menu(…open)`,
`tk_code(…build_c…)`). Answers that needed care, each checked:

- `ControlDraw` (start-up): version, temp and preference folders, edition.
- `MakeDesktopNode` at start-up: `none dummy`, as Simile's scripting mode
  answers — the canvas "dummy" is how `kickoff` knows there is no window.
- `EatNumber`: the expression parser reads each number through Tcl's
  `scan` and prints it back as Tcl's `expr` does. Ported, and compared with
  real `tclsh` on 25 inputs (ints, `.5`, `5.`, `1e20`, `2e-310`, …): same.
- `compile_c`: only its renaming of `model.cpp` to `model1.cpp`.
- `PrefValue` "1" (flowRouting on, the GUI default; an empty answer is a
  type error in `name/2`), `ColourExists` "1" as Simile with no window says.
- Tcl lists: file names with spaces (`List handling.pl`) must be braced.

**The model database in Prolog.** `struct_db` is a C library loaded into
Prolog, and the published WebAssembly SWI-Prolog cannot load ours (no
`dlopen`). `generator/struct_db.pl` is the same thing as clauses, quirks
kept; `--structdb=prolog` (always, in WebAssembly) uses it.

**Checked against Simile, on the 72-model catalogue:**

| | |
|---|---|
| headless (C database) vs Simile's own GUI export | predator-prey, Trees: same C++ but for names (`Desktop1`/`Desktop2`) and the order of independent lines; both run to the same numbers (469.5042746 / 79.75123252; and with sliders) |
| headless C++ that compiles | 67 of 72; the other 5 fail in Simile 7.5's GUI too, at the same point with the same error (`type_error(atomic,[])` in `name/2`, after the function library is read): ArcieroAggressiveTumorMode, chemical1, TestJarvisStomataMode, TestJarvisStomataModel_V4_P, Thornthwaite. **For the developer.** |
| Prolog database vs C database | 67 of 67 byte-identical |
| WebAssembly (SWI-Prolog 10.1.18, npm `swipl-wasm`) vs native (9.0.4) | 66 of 67 identical; edinburgh1 differs only in an equation's display text, `1.0e-6` vs `1.0e-06` (the two SWI versions print a float differently) |

**Time to generate** (Simile's 1.1 MB of Prolog loaded each time): native
~1 s; WebAssembly mean 1.9 s, Molusc_june06 30 s (12.5 s native).
In Chrome over `file://`: SWI-Prolog ready in 0.22 s, predator-prey's C++ in
1.3 s. Loading once and generating many times, or a saved state, would cut
most of that; not tried.

**Not yet:** a page that does this as part of the app (the spike page packed
Simile's Prolog into one script, 1.5 MB, beside the 6.3 MB `swipl-bundle.js`),
and compiling the C++ in the page (step 4).

## Step 4 spike: compiling the C++ in the page (done 2026-10-15)

`clang/` — a model's `model.cpp` made into a compiled model (side module) by clang
running as WebAssembly: npm `@yowasp/clang` 22.0.0-git20542-10 (LLVM 22
with lld, built for WASI, ISC/Apache 2), not installed in the repo.

    node clang/compile.mjs <@yowasp/clang gen/bundle.js> ~/Projects/simile-src model.cpp out.wasm
    node clang/run-model.cjs out.wasm > values.txt        # every value, 100 steps, fixed seed
    python3 -I clang/repack-classic.py <@yowasp/clang gen/> <dir>   # for file://

**How.** emcc's own commands (`emcc -v … -sSIDE_MODULE=1`): one `clang -c`
per file with `-target wasm32-unknown-emscripten -fPIC -O2` and emsdk's
sysroot headers, then `wasm-ld -shared --unresolved-symbols=import-dynamic`
with no libraries. Repeated with YoWASP's clang and wasm-ld, one change: LLVM
22 does not mark default-visibility symbols exported as emsdk's LLVM 24 does,
so `--no-export-dynamic` must go (else a 505-byte module with nothing in it).
A model needs ~170 of emsdk's headers (620 KB, 126 KB gzipped) and 17 of
clang's own. `support.cpp` never changes, so a page would ship its object.

**Checked.** predator-prey and Trees (populations, random numbers), compiled
and linked wholly by YoWASP and run in the page's run-time library: every variable for
100 steps byte-identical to the emcc build (Trees: 713 KB of values).

**Sizes.** `llvm.core.wasm` 75.5 MB (22.6 MB gzipped, 14.1 MB xz): 66 MB of
it code, no names to strip. It is already WebAssembly-only (`--print-targets`:
wasm32, wasm64) but built with assertions. `wasm-opt -Oz` makes it 55.9 MB
(20.2 MB gzipped; 4.5 min, output not checked). Smaller still only by
building LLVM ourselves with less in it.
Its `llvm-resources.tar`, 30 MB, is a WASI C/C++ library Simile never uses:
cut to the 17 headers (60 KB) the output is byte-identical.

**Times** (this machine):

| | Node | Chrome, http | Chrome, file:// |
|---|---|---|---|
| getting clang (fetch, compile its WebAssembly) | | ~1 s | ~4 s to load the 100 MB script |
| first model compile (clang starting) | 3.5–3.8 s | 3.9 s (1.8 s on reload, code cached) | 1.4–3.6 s |
| a model compile after that, -O2 | 1.1–1.4 s | 0.9–1.4 s | 0.9–1.4 s |
| link | 70–90 ms | 25–60 ms | 25–55 ms |
| load into the run-time library + 100 steps | | 60–130 ms | 70–130 ms |

`-O0` compiles in 0.7 s instead of 1.2 (output speed not compared).

**file://.** Chrome refuses ES modules and `fetch` there, so
`repack-classic.py` makes the package two classic scripts: `clang.js` (its
bundle, fetch answered from `window.YOWASP_DATA`) and `clang-data.js`, the
WebAssembly as base64, 100 MB. It works: same output, same compile times,
~4 s to load. It now ships gzipped before the base64 (30 MB), unpacked by
the browser's own `DecompressionStream` while clang's WebAssembly compiles:
the same results, a first build about 1 s slower. A page would load it only when a model is edited, as
`engine-local.js` loads the run-time library.

**What it means for an edit in the page:** generating the C++ (step 3, ~1–2 s
for these models) + compiling (~1 s) + load ≈ 2–3 s, all local — about
SimiLive's time for a small model, and no server. The first edit also pays
for getting SWI-Prolog and clang (~5 s from file://).

## Steps 3 and 4 in the app and the pages (done 2026-10-15)

A model with no `<name>.compiled.js` — an edited one, or any of the app's —
is now compiled in the page, and runs there; SimiLive only if that
fails. `src/simulation.js` (`loadOwn`) asks `Sienna.LocalEngine.build`, which
loads `src/model-compiler.js`, which loads the tools on first use:

    tools/engine/build-browser-tools.sh ~/Projects/simile-src

| file | size | what |
|---|---|---|
| `vendor/swipl/swipl-bundle.js` | 6.3 MB | SWI-Prolog 10.1.18 (npm swipl-wasm 8.2.3) |
| `vendor/simile-generator/simile-generator.js` | 1.5 MB | Simile's Prolog and function library, `generator/headless.pl`, `struct_db.pl` |
| `vendor/clang/clang.js`, `clang-data.js` | 0.25 + 30 MB | clang and wasm-ld (npm @yowasp/clang), as classic scripts, gzipped |
| `vendor/simile-runtime/model-kit.js` | 0.9 MB | the headers a model needs, support.cpp compiled (`clang/model-kit.mjs`) |

Each model compiled is kept for the visit under the model's fingerprint, so an
undo finds it made. Each generation has a Prolog of its own (below).

**Checked**, Chrome headless, `file://`:
- predator-prey page: the slider at 0.6 on the shipped compiled model, and the model
  edited to 0.6 and built in the page, give all 14 variables identical.
- Trees page: an edited model builds and runs (populations, random numbers).
- the app: growth, landuse, pangolin, none with a compiled model file, load and run
  in the page.

**Times** from an edit (after the page's 1.2 s pause): first edit of a visit
~9 s (C++ 1.3 s, loading clang ~6 s, compile 1.4 s, start 0.25 s); later
edits ~3 s; undo to a model built before, at once. In the app, a model's
first load ~9 s, later ones ~3 s. Both run on the page's thread, so the
page is frozen while each runs; the status line says which stage it is in.

**One Prolog for many models: no.** Loading Simile's Prolog once (~1 s
saved a model) works only by opening each model in a new desktop, as the GUI
would — starting Simile again empties the model database while its own facts
about the models open remain, and opening the same file name twice just
raises its window. Then all 67 catalogue models generate, but Simile numbers
each model's nodes after the last's, which reorders the C++ (declarations,
independent equations) — harmless for the arithmetic, but it could change
which random number each variable draws — and generation slows as models
pile up (Molusc 67 s, against 30 s fresh). A fresh Prolog writes exactly what
desktop Simile writes, so that is what the page does.

**Not yet:** a worker (so the page is not frozen), preparing the next Prolog
ahead of time, a smaller clang. (Keeping compiled models between visits:
below.)

## Compiled models kept between visits; pages ship theirs (2026-10-16)

Robert's choice: an embedded-widget page may ship its model compiled
(`<name>.compiled.js`, so a reader sees it run at once, with no tools to
load); the app ships none, compiling each model from the model itself, and
keeps what it compiles in the browser's own storage (IndexedDB database
`simile-compiled-models`, by fingerprint, the 50 used last), so only the
first visit waits. Pages (`SIENNA_EPHEMERAL`) keep nothing. A kept model is
keyed with `KIT` in `src/engine-local.js` as well: change it whenever the
run-time library, the model kit or clang's flags change, so models compiled
against the old ones are not used.

**Checked**, Chrome headless, `file://`, a fresh profile: the app's growth
6.5 s and landuse 3.3 s on the first visit, 0.17 s and 0.43 s on the next;
the predator-prey page creates no database; the slider/edit comparison
still 14 of 14.

**clang's size.** `clang-data.js` now holds gzip before the base64: 30 MB
rather than 100. What else could make it smaller, measured on
`llvm.core.wasm` (75.5 MB): it is already WebAssembly-only; `wasm-opt -Oz`
→ 55.9 MB (20.2 MB gzipped; not yet checked that it compiles the same);
xz → 14.1 MB but needs a decoder in JavaScript (the browser has gzip only);
an LLVM built by us (no assertions, clang and lld alone, no Objective-C,
OpenMP, CUDA or static analyser) perhaps 10–15 MB gzipped — a guess, and an
LLVM build for WASI to set up and keep.

## What the source shows

- **Generated per model:** only `model.cpp`. It holds a class with a field per
  variable, `evalmodel` (equations, with phase <= -2 for constants and 0 for
  initial values), `updatemodel` (stocks, via `stage_incr`), and `nodedata`, the
  table that describes each variable to the run-time library.
- **Fixed:** `Run/support1.cpp`, `support2.cpp` (included by the model),
  `support.cpp` (pipes, threads), `Functions/procs.cpp` (the function library),
  and `lib5d` = `Run/shank.cpp` (the run-time library, 3.3k lines). They are compiled once,
  so a WebAssembly build of them is made once, by us.
- **The run-time library's API** is what the R package calls
  (`Extensions/Simile/R/clientmmii.R`): `loadmodel`, `CreateModel` (many
  instances of one model), `c_setstepmodel`, `DoResetModel`, `DoExecuteModel`,
  `GetPairedValues`, parameter setting. A browser version should offer the same.
- **The generator is parameterised by language.** C++ and Tcl (`model.tcl`,
  evaluated by `Run/exec.tcl` with no compiler) both exist, so a JavaScript
  target would be a third (`render.pl`, `language.pl`, `compile.pl`).
- **The Prolog is the whole of desktop Simile** (41 files, ~27.5k lines, GUI
  included), and calls into Tcl (`safe_tcl_eval`) during generation. The model
  database is a C extension to it (`Prolog/struct_db.c`), which a SWI-Prolog
  WebAssembly build would have to include.
