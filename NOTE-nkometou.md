# Note: nkometou.pl — what stands between it and running (2026-10-31)

A large old-Simile model of the CamFlores lineage, forwarded by Jasper at Robert's request (not Jasper's own; kept outside the repo in `~/Projects/reference_models/nkometou/`; `~/Projects/simile_models/nkometou.pl`,
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

## Done 2026-10-31: tables (`table_data`)

Kept as `props.table` = { file, column, indices, values, units, bounds,
dims } (`readTable` in import-simile.js), written back on the node holding
the `table(…)` equation (`tableFromFile` in export-simile.js), where the
generator reads `dims`, `bounds`, `current`, `units` (inters.pl,
`table_const`). Shown read-only in the property dialog's **Table** tab
(source, then the values). nkometou: 43 tables kept — every one in use; the
3 other file tables and all 10 sketched graphs are on ORPHAN function nodes
(nothing points to them; Simile never uses them either). Checked by
compiling and running a small table model in the page (v = [5,7,9] per
field, total 21, whole array) — now the test-only fixture
`test/fixture-table.js`. Re-reading the CSV, or editing values: not done.
Found on the way: an array-valued influence (`[whole]` into
`element([whole],2)`) needs `array(1,N)` as its role dimension, not
`list(1)` — part of section 3's `[x]` forms.

## Done 2026-10-31: file parameters

See NOTE-file-parameters.md. nkometou now has 15 fixed and 31 variable
parameters (4 in the population `village`, not given here yet), and no
"has no value" left: what stops its export is the crossing forms alone. Also for the crossing
list: assoc_from_data1/2, two roles' names on one influence swapping.

## Suggested order

1. ~~File parameters.~~ Done 2026-10-31.
2. ~~`table_data` tables.~~ Done 2026-10-31.
3. The crossing forms, each with a small test model as for satellites.
4. Then compile nkometou in the page and see what the generator says.

## Done 2026-11-01: crossing forms

Not patterns: Simile's own rule, read from its source (m_update.pl
`get_unit_conversion`, `add_brackets`; ame_gen.pl `get_all_dims`), as
`Diagram.valueAt` — the units wrapped once per dimension of each submodel
left (list where instances come and go, array per fixed size), brackets
read off that, to any depth. Checked against all 4783 `use` terms in the
catalogue and nkometou: 4763 agree; the 20 others are stale terms (veg_mixed
was resized after its links were drawn), unfinished sources (var3, var6), a
renamed submodel (markov1), and test02's pre-9.0 form.

What the ten problems really were:
- **Role arrows crossing boundaries.** A role's base can be nested
  (`land patches` inside `land`; `coop_house` inside `household`), the
  arrow segmented through borders like an influence. We read the outer
  segment's start as the base — hence the "lost" 1492 and 2 dimensions and
  the scalars "Simile writes". Importer now follows the chain; properties
  from the segment where the ends meet; exporter segments roles and lists
  each submodel's own segment in `references`.
- **Two association crossings on one influence** (`village`, base AND
  satellite of `land allocation`): `Diagram.associationCrossings`, a `use`
  per role of each.
- **Same name, two forms** (`ID1` and `[ID1]` in assoc_from_data): the
  brackets are part of the input's identity.
- **`size('decision\nadoption')`**: renamed with its submodel.
- assoc_from_data's ID1/ID2 swap: the stem alias was taken from whichever
  role term came first.

Result: nkometou EXPORTS, and Simile's generator writes its C++ (1.2 MB,
native, 14 s). Catalogue: round trip no differences, 65/72 identical; 61
models run with values identical to before (fixed seed), associations
included; no new compile failures. test02's three files are now refused,
rightly: their equations use the array `Var1` bare (pre-9.0 implicit
array arithmetic).

**Compiled and run in the page (2026-11-01):** the in-page build takes
~470 s (Simile's generator plus clang, both WebAssembly, on 1.2 MB of C++;
kept afterwards, so once per edit), then reset 0.3 s and 3 time steps 0.6 s
for 1354 components. Run with placeholder values (1) for its 30 parameters
without defaults — real ones are in its parameter file, `~/Projects/reference_models/nkometou/nkometou.spf`.
Without values a fixed parameter left unfilled stops it ("null function"),
which the run control already prevents by asking for them.

What the page cannot do yet: READ most of its values. `sx_value`
(tools/engine/bridge.cpp) reads a number, one fixed dimension, and a
population or association's sparse array; nkometou's commonest shapes are
fixed memberships with single submodels nested inside (`dims
[1492,0,0,0]`: 412 components; `[1492,0,0,0,0,0]`: 129), and per-member
values of a submodel inside a population inside a patch (`["MEMBERS",0,1492,
"MEMBERS",0,0]`). Those answer null. A display-side job: reading nested
shapes, and widgets that can show them.

Open questions for Robert: its parameter files (`.spf`, XML) for real
values; whether the 470 s build is acceptable or wants a lighter path.

## Run in the app with its parameter file's values (2026-11-02)

Imported, opened, `nkometou.spf` loaded in the Parameters panel (all 15
fixed values; the 15 boolean innovation switches false, AD HOC — see
NOTE-file-parameters.md), then ▶ with the default run settings (100 time
units, step 0.1, log each 1). Compiled in the page in 493 s (once per
edit), ran to t = 100 in 74 s. Values move: household 7 has left the
population by t = 100, patch soil fertility has changed, and nested values
read (`nutex_maize` per patch, null where no maize crop exists). Not yet
checked against Simile's own results — Jasper or Robert would have to say
what a run should look like.
