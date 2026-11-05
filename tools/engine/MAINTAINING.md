# Maintaining Simile's engine in the page

How to change the engine: fix a bug in Simile's code, add a feature, speed
it up, or take a newer Simile. `README.md` beside this file is the history,
in the order it happened. `WHAT-HAPPENS.md` says what happens when a model
runs. This file is for doing the work.

## The rule: our changes live here, Simile's checkout stays as cloned

Simile's source is cloned into `~/Projects/simile-src` from
github.com/jal-frezie/simile (Jasper's, GPL v3). Changes to Simile's code
can be made, and have been, but **never in that checkout**. Each change is
a file in this repository:

- **Simile's run-time code (C++, `Run/shank.cpp`, `Run/6d.h`):** a patch in
  `patches/`. `build-runtime.sh` copies the two files out of the checkout,
  applies every patch to the copies, and compiles those.
- **Simile's generator (Prolog, `Prolog/*.pl`):** a replacement predicate in
  `generator/headless.pl`, or in `generator/struct_db.pl` for the model
  database. It is loaded after Simile's own and takes its place.

The only file of ours in the checkout is `Extensions/zz_export_cpp.tcl`, a
Simile extension that made desktop Simile write a model's C++ (README, step
1). No script needs it now; it changes nothing of Simile's.

Why:

1. The checkout can be updated from Jasper's repository (`git pull`) without
   losing anything, and without our changes tangled up in his.
2. Every way in which our engine differs from Simile's is listed in one
   place: `patches/` and the two generator files. That matters under the
   GPL, and when talking to Jasper.
3. Each fix can be offered to Jasper as it stands: a patch file is what he
   would need. Once his source has it, delete ours (see "Updating Simile").

A large change to the generator might be clearer as a patch to Simile's
Prolog than as replacement predicates. That has not been needed yet, and
`generator/pack.js` would first have to apply `patches/` to the Prolog it
packs, as `build-runtime.sh` does for the C++.

## What you need

- **The Simile checkout**, `~/Projects/simile-src`, at Simile commit
  444290c7 (2026-10-09) when this was written. The scripts read its source
  only; building desktop Simile from it (README, step 1) is needed
  only to compare with what desktop Simile itself writes.
- **emsdk** in `~/emsdk` (Emscripten 6.0.12). It also provides node and npm
  (`~/emsdk/node/*/bin`); there is no system node.
- **SWI-Prolog** for the native generator (9.0.4 here). The page uses
  SWI-Prolog 8.2.3 in WebAssembly, so a check in the page is needed too.
- **Network access** when running `build-browser-tools.sh`: it fetches the
  pinned npm packages `swipl-wasm` and `@yowasp/clang`.
- **For the checks in the page**: `python3 tools/serve.py` (never
  `python3 -m http.server`, whose caching gives false results) and a
  headless Chrome, time-capped and at low priority:

      timeout 900 nice -n 19 /opt/google/chrome/chrome --headless=new \
        --remote-debugging-port=9350 --user-data-dir=/tmp/simile-headless \
        --window-size=1280,800 --no-first-run about:blank &

  Then `python3 tools/headless/cdp.py tools/headless/scripts/<script>.py`
  from the repository root (`tools/headless/README.md`).

## Where a change goes, and what to rebuild

| The change | Goes in | Then run |
|---|---|---|
| A bug in Simile's run-time code | a patch in `patches/` | `build-runtime.sh` |
| What the page can ask a running model (values, parameters, steps) | `bridge.cpp`, and its caller `src/engine-local.js` | `build-runtime.sh` |
| The generator: a bug, a feature, its speed | `generator/headless.pl`, `generator/struct_db.pl` | `node generator/pack.js` |
| clang's flags for a model | `clang/flags.json` AND `src/model-compiler.js` (copied by hand) | `build-browser-tools.sh` |
| The versions of SWI-Prolog or clang in the page | the two constants at the top of `build-browser-tools.sh` | `build-browser-tools.sh` |
| A newer Simile | `git pull` in the checkout | everything: see "Updating Simile" |
| An edited sample page's model | `pages/<name>/<name>.js` | `build-model.sh` for that page |
| Anything that changes what the app's exporter writes | `src/export-simile.js`, the schema | `check/pages-current.sh`, and `build-model.sh` for each stale page |

The commands, from the repository root:

    tools/engine/build-runtime.sh ~/Projects/simile-src
    ~/emsdk/node/*/bin/node tools/engine/generator/pack.js ~/Projects/simile-src \
        vendor/simile-generator/simile-generator.js
    tools/engine/build-browser-tools.sh ~/Projects/simile-src    # includes pack.js
    tools/engine/build-model.sh ~/Projects/simile-src pages/trees/trees.js \
        pages/trees/trees.compiled.js

Everything under `vendor/simile-runtime/`, `vendor/simile-generator/`,
`vendor/swipl/` and `vendor/clang/`, and every `pages/*/*.compiled.js`, is
made by these scripts. Never edit them by hand; commit them after
rebuilding, since the app runs from the repository as it stands.

## A patch to Simile's run-time code

1. Copy the file out of the checkout as `a/Run/<file>` and `b/Run/<file>`,
   both with the existing patches applied (as `build-runtime.sh` does), and
   edit the `b` copy.
2. `diff -u a/Run/shank.cpp b/Run/shank.cpp > patches/<what-it-fixes>.patch`
   from the parent of `a` and `b` (the script applies them with `-p1`). Put
   a comment on the changed line saying what was wrong, as the existing two
   do. Patches are applied in name order.
3. `build-runtime.sh`, then the checks for the run-time library (below).
4. Add a dated note to `README.md`: the bug, how it showed, the fix.

A model's own C++ does not include `6d.h`, and it is compiled against the
headers in `vendor/simile-runtime/model-kit.js`, not against the patched
copies. So a patch that changes what a model sees (a header it includes,
`support.cpp`) needs `build-browser-tools.sh` too, and then the compiled-model
`KIT` (traps, below).

## Changing the generator

`headless.pl` is the whole of desktop Simile's Prolog with its Tcl/Tk side
answered in Prolog (`answer/3`), so no window is needed. To change what
Simile's own predicate does, replace it after loading, as `hl_faster`,
`hl_sorts` and `hl_no_drawing` do. Run it natively first; it is far quicker
to try things there than in the page:

    cd tools/engine/generator
    swipl headless.pl --structdb=prolog ~/Projects/simile-src <in .pl> <out .cpp>

Then `pack.js`, and the checks for the generator (below). A speed-up must
leave every model's C++ exactly as it was. A fix or a feature changes the
C++ on purpose: then see "When the C++ changes on purpose".

## Updating Simile

1. In the checkout: note the current commit (`git log -1`), then `git pull`.
2. Before rebuilding anything here, make the "before" results: the C++ with
   the old checkout (`SIMILE_SRC` pointing at a copy of it, or made before
   pulling) and `run-values.py` with the current vendored tools.
3. Rebuild everything: `build-runtime.sh` and `build-browser-tools.sh`. A
   patch that no longer applies stops `build-runtime.sh`: if Jasper's source
   now has the fix, delete our patch; if not, make it again against the new
   source.
4. Check a replaced generator predicate against the new original in
   `Prolog/`: if Jasper changed the original, the replacement must change to
   match.
5. All the checks below. Changes in the C++ are expected now; each one
   should be explained by Jasper's commits (`git log <old>..` in the
   checkout).
6. Bump `KIT` (`src/engine-local.js`), rebuild the sample pages'
   `.compiled.js`, and record the Simile commit in `README.md`.

## The checks

Make the "before" results first, for the ones that compare.

**1. The generator's C++, natively.** `check/generate-all.sh` writes every
catalogue model's C++ (and nkometou's, from outside the repository, when it
is there) into a directory. Run it at the old and new versions and compare:

    tools/engine/check/generate-all.sh /tmp/gen-before HEAD     # generator as committed
    tools/engine/check/generate-all.sh /tmp/gen-after           # as it is now
    diff -r /tmp/gen-before /tmp/gen-after

Keep the output directories OUTSIDE the repository: nkometou's C++ must not
be committed. nkometou's own Simile file does not generate headless, so the
script exports its model spec with the app's exporter (`export-pl.js`), as
the app would. On 2026-11-05: C++ for 67 catalogue models and nkometou,
none for 5 (ArcieroAggressiveTumorMode, chemical1, TestJarvisStomataMode,
TestJarvisStomataModel_V4_P, Thornthwaite); about 1.6 minutes a run.

**2. Compiled and run in the page.** `run-values.py` compiles every
catalogue model with the vendored tools, runs it twice with a fixed seed,
and records a fingerprint of all its values:

    RUN_VALUES=/tmp/run-before.json python3 tools/headless/cdp.py tools/headless/scripts/run-values.py
    # make the change, rebuild, then:
    RUN_VALUES=/tmp/run-after.json BASELINE=/tmp/run-before.json \
      python3 tools/headless/cdp.py tools/headless/scripts/run-values.py

It prints any model that no longer builds, no longer repeats its own
values, or gives different values. On 2026-11-05, about 4.5 minutes: 54 of
the 72 ran, each repeating its values, all as on 2026-11-03. The other 18,
as before: 7 stop at a fixed parameter with no value ("null function"), 4
are models Simile makes no C++ of, 7 are refused by our exporter. This is the
check that covers SWI-Prolog in WebAssembly, clang, the run-time library
and `bridge.cpp` together.

**3. The test pages and scripts:**

- `tools/headless/scripts/file-params.py`: parameters, values over time,
  parameter files (`bridge.cpp`'s `sx_param_*`). PASS/FAIL lines.
- `tools/headless/scripts/test-pages.py` and `editor.py`: the grammar,
  fixtures, and editor pages.
- `tools/engine/check/pages-current.sh`: is each sample page's shipped
  compiled model still the one for its model? A change to the exporter's
  output, not only to the engine, makes them stale: then every reader's
  page compiles the model itself, with no error. They were stale from
  2026-10-21 to 2026-11-05 unnoticed. Rebuild with `build-model.sh`.
- Open `pages/trees/` and `pages/predator-prey/` over http: the plot draws,
  and a slider reruns the model as it is dragged.
- nkometou, when the generator changed: load it in the app and run it. The
  first build in the page takes about 4 minutes on Robert's machine.

Which to run:

| Changed | 1 C++ | 2 run values | 3 pages |
|---|---|---|---|
| A run-time patch, `bridge.cpp` | | yes | yes |
| The generator | yes | yes | nkometou |
| clang's flags or versions, SWI-Prolog's version | | yes | yes |
| Simile itself | yes | yes | yes |

## When the C++ changes on purpose

A generator fix, a new feature, or a newer Simile changes the C++ that
models get. Then:

- **Bump `KIT`** in `src/engine-local.js` (to the date). Compiled models
  kept in a browser between visits are stored under it; without a new one,
  users go on running models compiled by the old generator.
- **Rebuild the sample pages' `.compiled.js`** with `build-model.sh`. A page
  uses its shipped compiled model only while the model's fingerprint
  matches, but the fingerprint is of the model, not of the C++, so a stale
  compiled model would still be used.
- Explain every difference `generate-all.sh` and `run-values.py` show. The
  baseline for the next change is the new output.

## Traps

- **The command-line exporter needs what the app's needs.** `export-pl.js`
  and `compiled-file.js` load the app's scripts into node by name. When the
  exporter came to use the equation parser (2026-10-21) they broke, and with
  them `build-model.sh`, until 2026-11-05. If they fail with
  "Cannot read properties of undefined", add the missing script to their
  list, in `index.html`'s order.
- **A replacement predicate must answer exactly as the original**, for every
  call, not only the ones you tried: same solutions, same order, same side
  effects. `generate-all.sh` across the catalogue is what shows it.
- **Module qualification.** Simile's predicates live in modules. To assert a
  clause into a module, write `assertz(M:(Head :- Body))`. Written
  `assertz((M:Head :- Body))`, the body runs in the wrong module, and the
  generator fails with no message (it happened with `hl_rename`).
- **SWI-Prolog 9 natively, 8.2.3 in the page.** A built-in used in
  `headless.pl` may exist in one and not the other. `run-values.py` (or
  `node generator/run-wasm.js`, README step 3) tries the page's version.
- **`KIT`**, above: forgetting it leaves stale compiled models in users'
  browsers, with no error.
- **clang's flags are in two places**: `clang/flags.json` and
  `src/model-compiler.js`.
- **The vendored files are generated.** An edit by hand is lost at the
  next build, and the build scripts are then no longer a true record.
- **Do not edit the checkout.** If it has been (`git status` in it shows
  more than the extension and Simile's own build products), put the change
  into a patch and `git checkout` the file.
- **Cap Chrome and the generator** on Robert's machine (`timeout`,
  `nice -n 19`): an uncapped headless page once ran for 30 minutes with
  the fan going.
- **nkometou stays outside the repository** (`~/Projects/reference_models/`),
  and so does anything made from it.

## Record what was done

Add a dated section to `README.md`: what changed and why, what the checks
showed, and the Simile commit it was built from. If the change is a fix to
Simile's code, say whether it has been offered to Jasper.
