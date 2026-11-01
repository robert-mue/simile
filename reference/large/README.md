# Large models, with their parameter files

Reference data, not application code — models too big or too far from the
catalogue's style to be in `catalogue/`, kept here so they can be loaded
from any checkout. Like the catalogue: **do not edit these files**; their
value is that they do not change.

## `nkometou.pl` and `nkometou.spf`

A large old-Simile model (Simile 7.5, file format 11.5, plain Prolog,
1.75 MB) with its parameter file, forwarded to Robert by Jasper in October
2026. It descends from FLORES (whose development Robert co-led) by way of
CamFlores; Robert has established its source and context, and that it is
free to distribute (2026-11-02). Its provenance in full: below, when added.

- 99 submodels, about 1500 elements and 5000 influences; associations,
  satellites, fixed memberships, populations, conditional submodels.
- **`nkometou.spf`** — Simile's XML parameter file: the values of its 15
  fixed parameters (village birth and departure rates, healthcare, initial
  cash of a new household, crop diseases, rainfall variation).
- Its 15 innovation switches (`establish oilpalm`, …) are boolean variable
  parameters with no value in either file; the app runs them as false — an
  AD HOC choice, to be revisited (`NOTE-file-parameters.md`).

To run it in the app:

1. **Simile ▸ Import model…** and select `nkometou.pl`.
2. **Widgets ▸ Parameters**, then **Load…** and select `nkometou.spf`.
   The panel should say every parameter has a value.
3. ▶ in the run control. The first run compiles the model in the page,
   which takes several minutes (about 8); it is kept afterwards, so later
   runs start at once until the model is edited. 100 time units take about
   a minute.

What it took to get here, and what is still open: `NOTE-nkometou.md`.
