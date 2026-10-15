# The Simile engine in the browser: spikes

Work towards running models locally (RESTART.md, "Now"). Simile's source is
https://github.com/jal-frezie/simile (GPL v3). This folder keeps what the spikes
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

## Step 2: the engine in WebAssembly (done 2026-10-15)

`driver.cpp` drives a model through the engine's C API, single-threaded, as a
display would: `load_model`, `fetch_top_instance`, `setstep` for phases 1–7,
then per run `reset(…, -2)` and `execute` one log interval at a time, reading
each named node with `get_raw_values` after each interval.

    R=<simile>/Run
    # native, for comparison
    g++ -O2 -c -fPIC -I$R -o m.o model.cpp && g++ -shared -fPIC -o model.so m.o support.o -L<simile>/System/lib -l5d
    g++ -O2 -std=c++11 -Istubs -I$R -o driver driver.cpp -L<simile>/System/lib -l5d
    # WebAssembly: the model is a side module, the engine the main module
    emcc -O2 -fPIC -Istubs -I$R -sSIDE_MODULE=1 -o model.wasm model.cpp $R/support.cpp
    em++ -O2 -std=c++11 -Istubs -I$R -sMAIN_MODULE=1 -sALLOW_MEMORY_GROWTH=1 \
         -sNODERAWFS=1 -o engine.js driver.cpp $R/shank.cpp        # for node
    em++ … -sSINGLE_FILE=1 -sMODULARIZE=1 -sEXPORT_NAME=SimileEngine -sINVOKE_RUN=0 \
         -sEXIT_RUNTIME=0 -sEXPORTED_RUNTIME_METHODS=callMain,FS -o engine-web.js …  # for a page

    driver <model> <run length> <time step> <log every> <runs> node00002:rabbits …

`page.html` loads `engine-web.js` and `model-<name>.js` (the side module as
base64, `window.SIMILE_MODELS[name]`) by `<script>`, so it works over
`file://`, writes the bytes into the engine's file system and dlopens them.

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
(rebuild) 5–11 s. The engine was ready 75–135 ms after the page opened;
`engine-web.js` is 2.1 MB because `MAIN_MODULE=1` exports all of libc
(`MAIN_MODULE=2` with an export list should shrink it a lot).

**Found:**

- **Populations read as `UNSTABLE`** through the single-threaded calls:
  `GetRawValues` withholds a population while `userStop.completed` is 0, which
  only the threaded path changes. The driver calls
  `((ExecutingModel*)inst)->set_completion(2)` after each `execute`.
- **Two models in one engine collide.** Whichever is dlopened first works;
  the second reads nothing (each model carries its own copies of support2's
  globals, and the first binding wins). Avoided, not solved: the page starts
  one engine instance per model (`Sienna.LocalEngine.open`).
- Value blocks: `dimSpecs[0]` is the TYPE for a single value (`REAL` = -1;
  types are zero or negative), `SPARSEARRAY` (-5) for a population, whose
  contents are a `sizeAndPtr` {count, pointer to doubles}.
- `go_reset`/`go_execute` start threads; WebAssembly threads need
  SharedArrayBuffer and so COOP/COEP headers, which neither `file://` nor
  GitHub Pages can give. `reset`/`execute` ("single-threaded versions for
  external clients") avoid them. The engine still calls `pthread_create` for
  group members (1467, 1537); not exercised yet.

## In the app and the pages (done 2026-10-15)

A model with a compiled engine runs in the page; any other runs on SimiLive,
as before. Nothing is compiled in the page yet (that is step 3).

- **`bridge.cpp`** — the engine's C API as a few calls for JavaScript
  (`sx_load`, `sx_describe`, `sx_reset`, `sx_execute`, `sx_value`,
  `sx_param`, …), answering in SimiLive's shapes.
- **`build-engine.sh <simile source>`** → `vendor/simile-engine/simile-engine.js`
  (2.1 MB, one script, so `file://` works). Applies `patches/*.patch` to a copy
  of `shank.cpp` first.
- **`build-model.sh <simile source> <model script> <out .engine.js>`** — model
  script → `.pl` (the app's exporter) → C++ (Simile from source, ~10 s, opens
  its window briefly) → side module → `<name>.engine.js`, which calls
  `Simile.engine(name, {prolog, wasm})`. `prolog` is a fingerprint of the
  exported Prolog (`Sienna.LocalEngine.fingerprint`), so the engine is used
  only for exactly that model: edit it and it runs on SimiLive, undo the edit
  and it runs here again.
- **`src/engine-local.js`** — `Sienna.LocalEngine`: holds the engine files,
  starts an engine instance per model, and answers SimiLive's requests
  (`web_embed.tcl`'s `ResponseTo`, ported). Checked against a recorded
  SimiLive session: predator-prey's Describe, Reset and ExecuteMulti identical
  to the last digit; Trees' Describe identical in structure (populations as
  `{member: value}`, member numbers kept for life).
- **`src/simulation.js`** — `loadOwn` uses the engine in the page when one is
  registered for the model; `_post` goes to it instead of the network. A run
  is one request rather than `updateEach` chunks.
- **Sliders** — in the page, the run follows the slider as it is dragged
  (`previewParameter`; runs are coalesced, only the latest is made), and the
  value let go at is the setting (`setParameter`, one action). Starting values
  need no rebuild: the slider values are sent BEFORE the reset, as the whole
  set, and the reset keeps them (the engine's "slider rollover", `how_int` -1).
- Pages: `pages/<name>/<name>.engine.js` beside `<name>.js`, loaded by a
  script tag; `embed.js` queues `Simile.engine` like `Simile.model`.

Measured in Chrome over `file://` (a slider let go, to the run drawn):
predator-prey 37–47 ms; Trees 60–140 ms. SimiLive: ~1.5 s, and 3–11 s for a
starting value. A drag of 40 mouse moves made ~40 runs.

**Two faults found on the way, both in how the engine is driven:**

- **Slider values lost at a reset** — a bug in Simile's engine:
  `VarParamData`'s constructor never sets `inheritSeries` (6d.h:110), and
  `InitTimeSeries` frees a parameter's value at every reset when it is true
  (shank.cpp ~1190). Whether it is depends on what the heap held: it worked
  until `Describe` had run. `patches/varparam-inheritseries.patch` sets it.
  **For the Simile developer.** It could misfire on SimiLive too.
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
models in the app (only pages register engines), and the engine's size.

## What the source shows

- **Generated per model:** only `model.cpp`. It holds a class with a field per
  variable, `evalmodel` (equations, with phase <= -2 for constants and 0 for
  initial values), `updatemodel` (stocks, via `stage_incr`), and `nodedata`, the
  table that describes each variable to the engine.
- **Fixed:** `Run/support1.cpp`, `support2.cpp` (included by the model),
  `support.cpp` (pipes, threads), `Functions/procs.cpp` (the function library),
  and `lib5d` = `Run/shank.cpp` (the engine, 3.3k lines). They are compiled once,
  so a WebAssembly build of them is made once, by us.
- **The engine's API** is what the R package calls
  (`Extensions/Simile/R/clientmmii.R`): `loadmodel`, `CreateModel` (many
  instances of one model), `c_setstepmodel`, `DoResetModel`, `DoExecuteModel`,
  `GetPairedValues`, parameter setting. A browser engine should offer the same.
- **The generator is parameterised by language.** C++ and Tcl (`model.tcl`,
  evaluated by `Run/exec.tcl` with no compiler) both exist, so a JavaScript
  target would be a third (`render.pl`, `language.pl`, `compile.pl`).
- **The Prolog is the whole of desktop Simile** (41 files, ~27.5k lines, GUI
  included), and calls into Tcl (`safe_tcl_eval`) during generation. The model
  database is a C extension to it (`Prolog/struct_db.c`), which a SWI-Prolog
  WebAssembly build would have to include.
