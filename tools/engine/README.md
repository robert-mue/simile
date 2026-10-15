# The Simile engine in the browser: spikes

Work towards running models locally (RESTART.md, "Now"). Simile's source is
https://github.com/jal-frezie/simile (GPL v3). This folder keeps what the spikes
need, because the scratch directory does not survive a reboot.

## Step 1: Simile from source, writing a model's C++ (done 2026-10-15)

Needs `swi-prolog-nox gprolog tcl-dev tk-dev libxcursor-dev portaudio19-dev`
(all installed) and a display, because the Tk GUI is started.

    git clone https://github.com/jal-frezie/simile.git && cd simile
    mkdir -p bin && printf '#!/bin/sh\nexit 0\n' > bin/patchelf && chmod +x bin/patchelf
    PATH=$PWD/bin:$PATH make PROLOG=SWI    # patchelf only sets rpaths: use LD_LIBRARY_PATH
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
  globals, and the first binding wins). Not yet solved: one engine instance
  per model (instances are cheap) or `RTLD_LOCAL`-style loading.
- Value blocks: `dimSpecs[0]` is the TYPE for a single value (`REAL` = -1;
  types are zero or negative), `SPARSEARRAY` (-5) for a population, whose
  contents are a `sizeAndPtr` {count, pointer to doubles}.
- `go_reset`/`go_execute` start threads; WebAssembly threads need
  SharedArrayBuffer and so COOP/COEP headers, which neither `file://` nor
  GitHub Pages can give. `reset`/`execute` ("single-threaded versions for
  external clients") avoid them. The engine still calls `pthread_create` for
  group members (1467, 1537); not exercised yet.

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
