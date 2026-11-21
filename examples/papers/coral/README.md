# Coral acclimation: a published model reproduced in Simile

Raharinirina NA, Acevedo-Trejos E, Merico A (2022) Modelling the acclimation
capacity of coral reefs to a warming ocean. *PLoS Comput Biol* 18(5):
e1010099. <https://doi.org/10.1371/journal.pcbi.1010099>. Their code and data:
<https://github.com/systemsecologygroup/CoralZooxProjection> (Python 2).

Built on 2026-11-21 as a test of how well Simile can take on a published
model. **It agrees with the authors' own published runs.** This folder is the
precedent for doing the same with another paper: the techniques are listed in
`help/model-file-reference.md`, section 2, items 13–20.

## The model

Three state variables, monthly time step:

- **Coral** (cm², a coral community's abundance)
- **Symbiont** (cells, its algae)
- **Trait** (the energy corals invest in the symbiosis), which moves up the
  gradient of coral fitness at the speed of acclimation N

The sea temperature is forced by monthly data, 1955 to 2100, after a
2000-year spin-up at a constant temperature. When the temperature exceeds the
optimum for coral growth by a regional threshold, the symbionts are cut to a
random fraction at the start of that month (bleaching). There are three
regions (the Great Barrier Reef, South East Asia, the Caribbean) and three
emission scenarios (RCP 2.6, 4.5 and 8.5).

## Files

| File | What it is |
|---|---|
| `coral.json` | the model spec (57 elements); its parameters' defaults are the GBR's |
| `make_coral.py` | writes `coral.json` and the nine parameter files from the authors' repository |
| `results_to_csv.py` | the authors' published runs (numpy pickles) as CSV, read safely without numpy |

The nine parameter files, `coral-<GBR|SEA|CAR>-<RCP26|RCP45|RCP85>.parameters.json`,
are not in the repository, because they hold the authors' temperature data.
They are made from it in one command (below).

## Reproducing the check

From the simile repository's root:

```
git clone --depth 1 https://github.com/systemsecologygroup/CoralZooxProjection /tmp/coral-src
python3 examples/papers/coral/make_coral.py /tmp/coral /tmp/coral-src
python3 tools/check_models.py /tmp/coral/coral.json \
    --parameters /tmp/coral/coral-SEA-RCP85.parameters.json \
    --csv /tmp/coral/results --vars Coral,Trait,Symbiont
python3 -I examples/papers/coral/results_to_csv.py /tmp/coral-src/Results SEA RCP85 > /tmp/coral/theirs.csv
python3 tools/compare_series.py /tmp/coral/results/coral.csv /tmp/coral/theirs.csv \
    --map Coral=CORAL,Trait=TRAIT,Symbiont=SYMB --offset -24012 --tolerance 0.01
```

A whole run, 2146 years at eight steps a month, takes about a second.

## How closely it agrees

Coral cover as a percentage of the region's carrying capacity; theirs, then ours.

| Region, scenario | End of spin-up | 2000 | 2100 | Trait |
|---|---|---|---|---|
| GBR, RCP 2.6 | 25.05, 24.99 | 22.98, 22.94 | 18.90, 18.82 | same to 3–4 figures |
| SEA, RCP 8.5 | 46.00, 46.00 | 31.80, 31.83 | 14.09, 14.40 | same to 3–4 figures |
| CAR, RCP 4.5 | 27.72, 27.67 | 21.89, 21.89 | 10.16; ours 10.96–11.63 over 5 runs | same to 3–4 figures |

For SEA RCP 8.5, over all 25 764 months: coral within 1% in 25 571 (the
largest difference 1.6%), the trait within 0.07% in every month.

The symbionts agree except where a random bleaching event falls differently,
as the authors' own runs differ from each other. Their published run is one
realisation of the random draws, and ours are others.

## What differs from the authors' code, and why

- **Solver:** they used an adaptive stiff solver (`vode`, BDF), month by
  month; we use Euler at 0.125 months, which is exact in binary, so
  `time()` does not drift.
- **Bleaching:** they cut the symbionts and then integrate the month; we cut
  them within the month's first step, as a flow `(1-kept)*Symbiont/dt()`, so
  that step's growth uses the uncut value.
- **The growth curve's normal CDF:** Simile has no `erf`, so it is
  Abramowitz and Stegun's 7.1.26 (error under 1.5e-7).
- **Random numbers:** `rand_var(0.05, keep_max)` is drawn every step and used
  at the start of a month; a different sequence from Python's.
- **Regional constants** are variable parameters, not fixed ones: a fixed
  parameter with a default ignores a parameter file loaded after the model
  (`tools/engine/README.md`, known fault 7).

## What Simile cannot do from this paper yet

The calibration of the speed of acclimation N (their Fig 2) and the
sensitivity analysis (Figs 5 and 6) each need hundreds of runs over a range
of parameter values. That is the multiple-run modes proposed in
`NOTE-run-modes.md`.
