# Note: nkometou.pl — what stands between it and running (2026-10-31)

Jasper's large old-Simile model (Robert's request; `~/Projects/simile_models/nkometou.pl`,
1.75 MB, plain Prolog, Simile v7.5). Robert's aim: if the app handles this,
the model-representation language is essentially covered (events apart).

## Size

99 submodels (66 `count=[]`, 30 fixed memberships of 2–36, 1 population;
nesting several deep), 962 variables, 108 compartments, 264 flows, 5213
influences, 22 role arrows (associations and satellites), 17 conditions,
1 each of creation / loss / reproduction.

## Where it stands

- **Import: works**, in 0.3 s → 1567 nodes, 2883 arcs, 99 submodels.
- **Export: refused.** First, ~40 variables "have no value". Given a
  placeholder value (a probe only), ten problems remain (below).
- Compiling and running: not reached yet.

## 1. File parameters — the main gap (also ALL 11 refused catalogue models)

50 variables are Simile **file parameters**: `param_type=file`, often
`spec=[]`, no `value`. Their values are not in the model; Simile reads them
from a parameter file when the model runs. We import them as variables with
no value, and the exporter refuses them.

Every one of the 11 catalogue models we still refuse
(ArcieroAggressiveTumorMode, assoc_from_data1/2, johadP,
labour_by_priority1, Molusc_june06, TestJarvisStomata…, Thornthwaite,
chemical1, prime) fails the same way: "X has no value", nearly all
`param_type=file` (Molusc_june06 has 105). So supporting file parameters
should move the catalogue from 61/72 towards 72/72 AND unblock nkometou.

Needs deciding: what our model holds for one (a kind of parameter whose
value comes from a data file), and where its value comes from when run here
— the user supplies a parameter file (Simile's `.spf`?), or a value is kept
with the model. A question for Jasper: the format of a parameter file, and
whether SimiLive/the generator take the values at load time.

## 2. Tables read from CSV files (`table_data`) — 56 in nkometou

e.g. `prices`: `param_type=file, table_data=[current=[0,950,…],
file='C:/…/nkmtouprices.csv', data='PRICE', indices=['PD_ID'], dims=[20]],
value=makearray(table(place_in(1)),21)`. The values last read from the file
ARE in the model (`current=`). We currently IGNORE `table_data` (import note
"a table read from a data file, not a sketched graph"), so these lose their
data. Supporting it means keeping `current` (and the file's name and column)
and writing it back.

## 3. Crossing forms the catalogue never showed us (the ten problems)

- **An influence carrying an association role AND a satellite role at
  once**: `use(2,in_base,{[actions_owner]},list(array(1,60))),
  use(5,in_assoc,[actions_link_to_satellite],array(1,60))` (6 arcs; the
  "land_allocation" and "village" problems).
- **Lists of arrays**, `{[x]}` (63 names): out of a fixed membership inside
  a many-instanced one — `list(array(1,36))`. Nested arrays `[[x]]` (4).
- Some names leaving a fixed membership that Simile writes as SCALAR
  (`use(none,in_hierarchy,task_labour_needed,1)`), which our check wants as
  `[task_labour_needed]` — to be looked at arc by arc.
- One arc supplying TWO names (`disease_plantain` and `disease_plantain_0`;
  6 arcs).
- `size('decision\nadoption')` as an array dimension (144).

Already handled: `usr(name)` (173), names with spaces/newlines (renamed),
`exclusive`.

## Suggested order

1. File parameters (unblocks the 11 catalogue models too; needs the design
   decision above, and probably a question to Jasper).
2. `table_data` tables.
3. The crossing forms, each with a small test model as for satellites.
4. Then compile nkometou in the page and see what the generator says.
