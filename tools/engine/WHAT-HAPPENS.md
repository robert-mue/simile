# What happens when a page is loaded and a model is run

State on 2026-10-16 (commit c026d7e). The details are in `README.md` beside
this file.

## Terms

- **Engine:** what makes a runnable model. That is Simile's generator, which
  turns a model into C++, plus a C++ compiler (clang).
- **Compiled model:** one model's WebAssembly, made by the engine. It is not
  "the engine".
- **Run-time library:** Simile's own fixed support code (`shank.cpp`),
  compiled to WebAssembly once
  (`vendor/simile-runtime/simile-runtime.js`, 2.1 MB). Every compiled model
  runs linked to it.
- **WebAssembly:** compiled code that runs inside a web page at close to
  native speed, with nothing installed.
- **Fingerprint:** a short code computed from the model's exported Simile
  Prolog. A compiled model is used only for the model whose fingerprint it
  carries, so any edit means compiling again.

## A. Someone visits an embedded-widget page (e.g. `pages/predator-prey/`)

1. The browser loads the page's HTML, then `embed.js`.
2. `embed.js` loads about 20 small scripts: the shell, the model layer, the
   equation parser, the widgets and the simulation code.
3. The page loads its two files:
   - `predator-prey.js`, the model itself (diagram, equations, run
     settings);
   - `predator-prey.compiled.js`, the same model already compiled (about
     35 KB, made in advance by `tools/engine/build-model.sh`).
4. The page fills in its widgets (diagram, plot, sliders) and starts a run
   straight away. It works out the model's fingerprint, and it matches the
   compiled model's.
5. On that first run, the page loads Simile's run-time library (once per
   visit), loads the compiled model into it, and runs it. The run takes
   about a millisecond, and the first results appear in under a second from
   opening the page.
6. The plot draws the results. When the reader moves a slider, the model runs
   again with the new value as the slider is dragged, in milliseconds. No
   server is involved.
7. The page keeps nothing. Reader edits and compiled models are gone when
   the page is closed.

## B. A model with no compiled model to match (edited, or one of the app's)

8. When the model is run, step 4 finds no compiled model with its
   fingerprint, so the page compiles it.
9. **The worker.** Compiling happens in a background worker, so the page
   keeps drawing and responding meanwhile. The status line shows each
   stage.
10. **Make the C++.** The first time, the page loads SWI-Prolog (6.3 MB) and
    Simile's generator (1.5 MB) and hands them to the worker. The worker
    starts a fresh Prolog, gives it the model, and the generator writes the
    C++. This is the same C++ desktop Simile writes, in about 1 s.
11. **Compile it.** Meanwhile, the first time, the page loads clang (30 MB)
    and the model kit (0.9 MB, Simile's header files) and hands them to the
    worker. The worker compiles and links the C++ in about 1–1.5 s, and the
    result is the compiled model.
12. **Run it.** The compiled model is loaded into the run-time library and
    run, as in step 5. From then on, sliders behave as in step 6.
13. The compiled model is kept for the rest of the visit, so undoing back to
    an earlier version runs it at once.
14. If compiling fails, the model is sent to SimiLive, at simulistics.com, as
    it was before. Compiling can fail if the tools are missing or Simile
    can't generate the model. If the browser can't make a worker at all, the
    same steps run in the page itself, which then freezes for a second or so
    at a time.

Typical times: the first compile of a visit is 6–9 s, mostly loading the
tools; later compiles take about 3 s.

## C. The app (`index.html` at the repo root)

15. On a visit, the app loads the same kind of small scripts as step 2, plus
    the demo models. The user's own models are stored in the browser.
16. The app ships no compiled models. The first time any model is run, it
    is compiled as in steps 8–13.
17. The app keeps each compiled model in the browser's own storage
    (IndexedDB), up to the 50 used most recently. On later visits, a model
    whose fingerprint is unchanged runs at once, in about 0.2–0.4 s, with no
    tools loaded. Measured: Growth took 6.5 s on the first visit and 0.17 s
    on the next.

## Caveats

- The times above were measured with the files on the local disk. On a real
  web site, the first compile of a visit also has to download about 39 MB of
  tools. After that the browser usually caches them.
- Embedded-widget pages that ship a compiled model never download the tools,
  unless the reader edits the model.
- After a sample model is edited, its `<name>.compiled.js` must be rebuilt
  with `tools/engine/build-model.sh`. Otherwise every reader's page compiles
  the model itself.
