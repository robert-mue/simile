# Headless browser harness

How the tutorial screenshots were taken and the app was checked against the
SimiLive engine (2026-10). Kept here because the scratch directory it grew up
in is wiped on reboot. Not a test framework: a script per job.

## Start Chrome once

```
/opt/google/chrome/chrome --headless=new --remote-debugging-port=9350 \
  --user-data-dir=/tmp/simile-headless --window-size=1280,800 --hide-scrollbars \
  --noerrdialogs --no-first-run --ozone-platform=headless \
  --ozone-override-screen-size=800,600 --use-angle=swiftshader-webgl about:blank &
```

It keeps running between scripts, so a script can carry on from where the last
left the app (the model persists in that profile's localStorage).

## Run a script

```
python3 tools/headless/cdp.py tools/headless/scripts/trees.py
```

Needs Python's `websockets`. Screenshots go under the current directory, or
`$HEADLESS_OUT`. A script gets `ev(js)`, `shot(name, clip)`, `click`, `drag`,
`press`, `nav`, `cmd` (raw DevTools), and with `exec(open('lib.py')…)` as its
first line, the app helpers in `lib.py`: `menu('File')`, `tool('stock')`,
`place(kind, x, y, name)`, `flow_from`, `influence(a, b)`, `seteq(label, expr)`,
`dlg`, `subdlg`, `win(title)`, `field(label, value)`, `addplot(name)`,
`runall()`, `series()`, `canvas_shot`, `dlgshot`.

## Scripts

- `scripts/trees.py` — builds the Trees tutorial from a fresh new-user session,
  all four stages, and takes its screenshots (`tr/…`).
- `scripts/predator-prey-P1…P5.py` — the Predator-prey stages, run in order.
- `scripts/test-pages.py` — opens `test/index.html` and `test/fixtures.html`.
- `scripts/editor.py` — runs `test/editor.html` (over http, via `tools/serve.py`)
  and prints its bar and any failing tests.
- `scripts/added-widget.py` — adds `examples/widgets/big-number.js` by URL,
  runs it on Growth, breaks it on purpose; PASS/FAIL lines. Keeps the brief,
  `Simulation.forWidget` and the example in step.
- `scripts/roundtrip.py` — feeds the 72 catalogue files to `test/roundtrip.html`.
- `scripts/help-pages.py` — every tutorial page at phone width: overflow, broken
  images, dead anchors.
- `rawload.js` — `ev(open(...).read())` it into the app to get `__rawLoad(pl)`
  (upload raw Prolog to the engine) and `__series(label, step, len, log)`.

## Traps

- A script that clicks a palette tool that is already armed switches it OFF,
  and the next drag pans the canvas instead.
- The plotter list shows a variable added since the last load as
  `name  (from the next run)`; `addplot` matches either.
- A maximised Displays area hides the run control, so ▶ cannot be pressed.
