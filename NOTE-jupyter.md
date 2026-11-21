# Simile models in Jupyter notebooks

*Robert, 2026-11-21. For coming back to this.*

## Why

Research is a main audience for Simile, and its strength there is that large
ecosystem models can be built as diagrams rather than programs. Researchers,
especially in climate science, work in **Jupyter notebooks**: they write or
edit Python to run experiments with models, then analyse and plot the
results. The aim is **common ground with them**. The model stays a Simile
diagram, and everything done *with* it (many runs, calibration, sensitivity,
plots, comparison with data) is their own Python.

**Decision (Robert, 2026-11-21):** the route is a **pip-installable
package**, `pip install …`, that runs Simile models wherever Python runs: a
laptop, a group's JupyterHub (the usual set-up in hackathons and climate
workshops), Colab or Binder. JupyterLite (notebooks running in the reader's
browser) and read-only pages are possible later additions, not the aim.

## What exists now

The coral model of Raharinirina et al. (2022), reproduced in Simile
(`examples/papers/coral/`, see its README), with a notebook:

| File | What it is |
|---|---|
| `examples/papers/coral/coral.ipynb` | the notebook, saved with its results: the model's diagram and equations; one run against the authors' published run; calibrating N against observed coral cover (their Fig 2); projections to 2100 under three scenarios; sensitivity to N and ten parameters (Figs 5-6) |
| `examples/papers/coral/make_notebook.py` | writes the notebook afresh (without results) |
| `tools/python/simile_run.py` | the Python side: `Session`, `run`, `diagram`, `equations` (below) |
| `~/Projects/simile-notebook-env/` | the Python used: Jupyter, numpy, pandas, matplotlib, websockets (472 MB; delete the folder to remove it) |

To open the notebook (Jupyter opens it in your web browser, and you can edit
and re-run any cell):

```
~/Projects/simile-notebook-env/bin/jupyter lab ~/Projects/simile/examples/papers/coral/coral.ipynb
```

**The present engine is a PROTOTYPE.** `simile_run` runs the model in Simile's
own engine, the one in the web app, by driving a hidden Chrome and the app's
web server on the same machine. So it works only where this repository and
Google Chrome are. The package (below) is about removing that limitation; the
Python interface would stay the same.

## How to make a notebook for any model

### 1. What you need

- the model's file, `<model>.json` (File › Save model as file… in Simile);
- if its parameters should have values other than the model's defaults, a
  parameter file, `<model>.parameters.json` (Widgets › Parameters › Save);
- the Python above, and this repository (for now).

Start a new notebook (in JupyterLab: File › New › Notebook), or copy
`coral.ipynb` and change it.

### 2. The first cell: set up

```python
import sys, json
from pathlib import Path
import numpy as np, pandas as pd, matplotlib.pyplot as plt
from IPython.display import Image, Markdown, display
sys.path.insert(0, str(Path.home() / 'Projects/simile/tools/python'))
from simile_run import Session, SimileError, equations

MODEL = json.loads(Path('mymodel.json').read_text())
```

### 3. Show the model: its diagram and its equations

```python
with Session(MODEL) as s:
    display(Image(data=s.diagram(), width=950))
display(Markdown(equations(MODEL)))
```

Both are read from the model when the notebook runs, so they always match it.

### 4. Run it

```python
with Session(MODEL, parameters='mymodel.parameters.json') as s:
    df = s.run(variables=['prey', 'predators'])
df.plot()
```

- `df` is a pandas table: one row per recorded time (its index), one column
  per variable asked for. Leave out `variables` to get every variable with a
  single value.
- A variable inside a submodel is named by its path, `tree/Height`, or just by
  its own name if that's unique. A variable with a value per instance (a
  population's) isn't returned yet: only single values.
- The run uses the model's own run settings (its presentation in the
  Metadata panel). To change them for the session:
  `Session(MODEL, run_settings={'runLength': 200, 'logEach': 1, 'startTime': 1900})`.

### 5. Many runs: an experiment

One session compiles the model once (a few seconds), then runs it as often
as asked, each run with other **parameter** values (about half a second for
the coral model's 2146 years):

```python
results = {}
with Session(MODEL, parameters='mymodel.parameters.json') as s:
    for rate in np.linspace(0.1, 1.0, 10):
        results[rate] = s.run({'birth_rate': rate}, variables=['prey'])
```

`s.run({...})` takes `{name: value}` for any parameter (a variable whose
Data source is Variable or Fixed parameter). A value over time is
`{time: value, …}`, or a list for times 0, 1, 2, ….

**To vary something that is not a parameter** (a constant in an equation),
run a changed copy of the model. Each new version is compiled once, then runs
as fast:

```python
def with_value(model, label, new_value):
    out = json.loads(json.dumps(model))
    node = next(n for n in out['nodes'].values() if n['label'] == label)
    node['props']['value'] = str(new_value)
    return out

with Session(MODEL) as s:
    df = s.run(model=with_value(MODEL, 'K', 500))
```

This is the Simile way of asking "what if this constant were different":
change the model, not code that restates it. (Making many constants into
parameters instead is not safe for now: engine fault 8.)

### 6. When a run does not finish

Each run has a time limit (`Session(…, time_limit=120)`, in seconds). A run
that goes past it is stopped, its page closed, and `SimileError` raised. For
a sweep, catch it, record the run as missing, and open a new session, as the
coral notebook's sensitivity section does. That happened there with one
parameter combination (engine fault 8). A session closes everything it
started when it ends: at the end of a `with`, on `s.close()`, or when Python
exits.

### 7. Things to know

- **Random numbers:** the engine starts them afresh for each run, so a model
  with random events (the coral model's bleaching) gives a slightly different
  result each time. Average several runs, or show their range.
- **The time step:** choose one exact in binary (0.125, not 0.1) if equations
  test the time (engine fault 5; the model file reference, section 2, item 17).
- **Fixed parameters** take a run's values too: when one changes, `run`
  loads the model afresh before the run (a tenth of a second), which avoids
  engine fault 7.
- **The first run of a session** includes compiling, several seconds; later
  runs don't.

## The plan: a pip-installable package

The same interface (`Session`, `run`, `diagram`, `equations`), installable
with `pip install <name>`, with no Chrome and no copy of this repository.

**The likely route** (still to be tried): Simile's whole engine already runs as
JavaScript and WebAssembly, which is the model generator (SWI-Prolog), the
compiler (clang) and the run-time library, all files in `vendor/`. They should
also run under **Node.js**, JavaScript outside a browser, which is usually
present on JupyterHubs and Colab, and can be installed with Python itself (a
package bundling Node exists on PyPI; to be checked). The Python package would
start Node, hand it a model and parameter values, and read back the results.

Steps:

1. **A trial:** run the coral model once under Node, from a small script, using
   the code paths of `src/engine-local.js` and `src/model-compiler.js`. What in
   them assumes a browser (the page, Web Workers, IndexedDB, fetching files)
   needs replacing. This step settles whether the route works.
2. **The Python side:** `simile_run`'s interface over that Node process, with
   messages in JSON both ways; the coral notebook unchanged and its results
   the same.
3. **The package:** the engine files (about 30 MB compressed) in the package,
   or fetched on first use; `pip install` on a laptop, a JupyterHub, Colab and
   Binder, each tried.
4. **`diagram()`** without a browser, which still needs one to draw: the
   diagram as SVG, or the browser kept for that alone.

**Later, if large models need it:** models compiled to native code rather than
WebAssembly. That means faster runs and long batches, at the cost of needing
SWI-Prolog and a C++ compiler where it runs.

**To decide before publishing a package:**
- its name;
- **the licence.** The run-time library is Jasper's Simile code, under GPL
  version 3, and a package containing it must respect that. Agree it with
  Jasper; Simile itself has no licence yet;
- whether it runs models from the gallery by address, as the app does.

## Related

- `examples/papers/coral/README.md`: the coral model, how it was checked.
- `help/model-file-reference.md`, section 2 items 13-20 and section 13:
  reproducing a published model, and comparing with its authors' results.
- `tools/engine/README.md`, faults 5, 7, 8: engine faults met on the way, with
  Jasper.
- `NOTE-run-modes.md`: multiple runs inside Simile itself, for those who don't
  write Python. The notebook route doesn't replace it.
- Recreating the Python environment on this machine (its Python has no pip):
  `python3 -m venv --without-pip ~/Projects/simile-notebook-env`, then install
  pip from its wheel (download it from PyPI;
  `~/Projects/simile-notebook-env/bin/python pip-*.whl/pip install pip-*.whl`),
  then `~/Projects/simile-notebook-env/bin/python -m pip install jupyterlab
  numpy pandas matplotlib websockets`.
