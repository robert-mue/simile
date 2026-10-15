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
SimiLive route), and exits. `predator_prey32.cpp.sample` is the catalogue
model's output. It compiles into a model library the way Simile builds one:

    g++ -c -fPIC -I Run -o model.o model.cpp
    g++ -c -fPIC -std=c++11 -I Run -o support.o Run/support.cpp
    g++ -shared -fPIC -o model.so model.o support.o -L System/lib -l5d

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
