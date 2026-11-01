# Note: file parameters — what Simile does, and a proposal (2026-10-31)

Robert asked to look at these after tables (nkometou has 50; they are the
reason ALL 11 refused catalogue models are refused). Findings from Simile's
own source (`~/Projects/simile-src`) and the generator, then a proposal with
the decisions that are Robert's.

## What a file parameter is (Simile)

- In the `.pl`: a variable with `param_type=file` and NO equation (often no
  function node at all; sometimes `spec=[]`). Its `units` give its shape:
  `1`, `int`, `array(1,5)`.
- The generator (`paramness_setup`, Prolog/library.pl) classes an element
  with no equation as a PARAMETER: without `param_type=file` a *variable
  parameter* (what our sliders move), with it a *fixed parameter* whose value
  is put in from outside.
- In the C++ (checked: `labour_by_priority1.pl` through our generator,
  2026-10-31) each becomes a slot the model fills when it is RESET:
  `collect(&Desktop1pointer->time_available, 120, 0)`,
  `collect(&…->priorities[i], 119, 1, i)`. So the model compiles without the
  values; they must be supplied before a run.
- Simile supplies them from a **parameter file** (`.spf`), read by its Tcl
  side (Run/params.tcl) and pushed into the run-time library through
  `use_array_for_params` / `paste_param_data` — the same entry point our
  sliders use (`sx_param` in tools/engine/bridge.cpp, single REAL numbers
  only so far). When a model with file parameters is run, Simile shows its
  **file parameter dialogue** (`FileParamDialogue`): every file parameter,
  a field for each, Load / Save of a `.spf`.
- The point of keeping them out of the model: ONE model, SEVERAL parameter
  files — scenarios, sites, countries (Molusc_june06 has `CountryID`,
  `scenario`). `TreesFP.tcl` loads one, runs, then `MergeParams` another.
- `.spf` comes in two formats:
  - old text (MIME): one line per parameter, `path=literal=value` or
    `path=literal=NOW value` (`/r=literal=10`;
    `start/hole=literal=NOW 8`);
  - XML (`<spf>`, Simile 6+): `<submodel label=…>` nesting, `<variables>`,
    `<single_value>` / `<byte_array label=… type="REAL|INTEGER|FLAG">` with
    `<value index=… val=…>` giving the dimensions and the values as base64
    binary.
- **Typed vs saved (checked 2026-10-31, Simile source of 2026-10-09).**
  What is TYPED in the dialogue's field is JSON for several values
  (`[1,2,3]`, `{"a":1,…}`; a field starting `[` or `{` goes to a JSON
  parser — `UglifyValList`, Run/hai2mmii.tcl), a plain number otherwise.
  It is converted at once to Simile's internal Tcl index/value list. What
  **Save** writes is still the XML `.spf` (`fileparams::Save`,
  Run/params.tcl): `<single_value val=…>`; `<multi_value>` with nested
  `<value index=… value=…>`; `<byte_array>` (base64) for values read from
  data; and `<csv_columns>` / `<image>` / `<geotiff>` / `<csv_grid>` for a
  parameter that REFERS to a data file. So Simile does use two formats.
  Robert (2026-10-31): we should save JSON. Agreed: our parameter file is
  JSON, in the same notation as the field; Simile's XML `.spf` at most
  READ, as an import.
- Five catalogue models also fail in Simile 7.5's own GUI
  (`type_error(atomic,[])`, tools/engine/README.md) — exactly the ones whose
  file parameters carry `spec=[]`. Probably that; to confirm, and maybe a
  question for Jasper.

## Proposal

1. **In our model**: a variable can be a *file parameter* (a checkbox in its
   dialog, "Value comes from a parameter file"), needing no equation, so not
   red. Imported from `param_type=file`; exported as Simile's single-node
   form with `param_type=file`. Its shape from its units, as now
   (`array(1,5)`).
2. **Values**: a **Parameter values** window for a model — every file
   parameter with its path, units/shape and a field (a row of fields, or a
   table, for an array); **Load .spf…** and **Save .spf…** (both formats
   read; one written). Opened from the run control, and automatically, as
   Simile does, when ▶ is pressed and a value is missing.
3. **Run**: before each reset, the values go into the engine (extend
   `sx_param` to arrays and integers/flags — `paste_param_data`). A missing
   value stops the run with a list of what is missing. On SimiLive, the
   values go as a `.spf`.

## Robert's decisions (2026-10-31)

- Values are NOT saved with the model, but in separate parameter files
  (`.spf`), as JSON. Until there is a "project file" (a model, several
  alternative `.spf`s and other parts, as Simile's `.sml` is now) the app
  also keeps the values used last, beside the model: "both", for
  convenience.
- A **Parameters panel**, a widget like the others. When and where it
  appears (Simile shows it only on Run, which Robert does not like) is for
  later.
- Parameters are grouped by submodel, as in Simile's documentation.

## Built (2026-10-31)

- **Model**: a variable's dialog has a "File parameter" tick box
  (`props.fileParam`); its equation is then not required (schema
  `exemptWhen`), and one given is a default. Imported from
  `param_type=file` (not on a table read from a data file, which Simile
  marks the same way: that keeps running on its `current` values).
  Exported as Simile's one node: `param_type=file`, units, range, and
  `value` only for a default — never `spec=[]`.
- **Panel** (`src/widgets/parameters.js`, Widgets ▸ Parameters): grouped by
  submodel; one field each, a number or JSON (`[1, 2, 3]`; brackets per
  dimension, outermost first: enclosing fixed memberships, then the
  variable's own array); the count is checked against the shape; a
  missing value is shown. Load… / Save… / Clear. A change reruns from the
  start, as a slider does.
- **File**: JSON, `{simile: "parameters", version: 1, model, variables:
  {name: value}, submodels: {name: {variables, submodels}}}`, saved as
  `<model>.spf`. Loading one gives every value in it and takes away the
  rest; names not in the model are reported. A Simile XML `.spf` is
  recognised and said to be unreadable.
- **Run**: the values used last are kept per model
  (`simile.fileParameters.v1`). Before each reset they go to the engine
  (`FileParameters` in engine-local.js → `sx_param_fill`, bridge.cpp, any
  fixed shape, REAL/INTEGER/FLAG); a missing one (no value, no default)
  stops the run, naming each. In the page only: SimiLive refuses, saying so.
- **Results**: labour_by_priority1, ArcieroAggressiveTumorMode,
  assoc_from_data1/2, drainage1, SolarRadiationDNDCP (a default), and
  Thornthwaite (12 per-instance values; it fails in Simile 7.5's own
  window) now compile and run in the page. Round trip: 64/72 identical
  (was 61), 6 refused — every one for a genuinely unfinished element in
  the file — and 2 differing (assoc_from_data1/2, below).
- Found on the way: Simile writes `if'Ta'>0`; the importer took the quotes
  off and made `ifTa`. Fixed (`plainNames`), which also mended broomgrass1.

## Open

- **A variable with NO value and no `param_type`** (nkometou: 25, e.g.
  `establish oilpalm`, `spec=[]`, `units=boolean`). By `paramness_setup`
  that is a *variable* parameter with no value: in Simile, presumably given
  in the same dialogue. Should the Parameters panel take these too?
  (Question for Robert.)
- **File parameters in a population** (nkometou's `village`: 4) — per
  member, so no fixed shape. Not given here yet.
- **Simile's XML `.spf`** — read only if real ones need using.
- When and where the panel appears.
- assoc_from_data1/2: the two roles' names (ID1, ID2) on one influence swap
  in the round trip — a crossing form, for that list (NOTE-nkometou.md).

## Fixed and variable parameters (checked in Simile's source, 2026-10-31)

Robert: Simile's equation dialogue offers "Fixed parameter" or "Variable
parameter"; the latter changes at time points during the run (values from
the parameter file / dialogue) or by a slider. What the source says:

- The dialogue's "Data source" (Run/equation.tcl) is three radio buttons:
  **Variable parameter** (with Minimum / Maximum), **Fixed parameter**,
  **Derived** (an equation).
- In the file (`paramness_setup`, Prolog/library.pl), for a variable:
  - Derived: has a function node.
  - Variable parameter: NO function node and NO `param_type`. Any value on
    the node is its default.
  - Fixed parameter: no function node, `param_type=file`.
- Compiled (`get_assignment`, Prolog/compile.pl): a fixed parameter is
  collected once, at reset; a variable parameter is collected EVERY time
  step (`update(Dest)`, `on_step`), its equation, clamped to min/max, being
  the value used when none is given (`apply_minmax`).
- Run time (shank.cpp `UseArrayForParams`): eval `INPUT` (variable) gets a
  `VarParamData` — a list of time points, each with values, plus a fill
  method between them (`use_last`, `use_closest`, `interpolate`), a wrap
  time and an interval. Others (`TABLE` eval: fixed) get a plain slot.
  Simile's dialogue gives a variable parameter TIME as an extra outermost
  dimension (`readMany`, `FirstIndexCheck`): JSON `[a, b, c]` is times 0,
  1, 2 (× interval), `{"0": a, "10": b}` times 0 and 10. A slider sets the
  current value (`NOW v`), not a time point.

So what was built 2026-10-31 is **fixed parameters**. Our sliders are
already Simile's variable parameters (the single-node form, `INPUT`), but
only those with a value and a range; the rest of the kind is missing:

1. A variable parameter with NO value (nkometou's 25, `spec=[]`) — we read
   it as an unfinished variable.
2. Values over time from the panel / a parameter file, with a fill method.
3. The dialogue's choice. Ours infers a slider parameter (a number, a
   range, nothing influencing it) and has a separate "File parameter" tick.
   Simile's rule is simpler and explicit: no function node → a parameter.
   (So in Simile, chao.pl's `gain`, a constant with no range, is a
   variable parameter too.)

### Proposal

- **Dialog**: replace the tick box with Simile's choice, "Data source":
  Derived / Variable parameter / Fixed parameter (`props.paramKind`). The
  equation is optional for both parameter kinds (a default); Minimum /
  Maximum go with Variable parameter (a slider needs them).
- **Import / export**: by Simile's rule — no function node: variable
  parameter (fixed with `param_type=file`); function node: derived. Both
  parameter kinds written as one node.
- **Panel**: both kinds, grouped by submodel, the kind shown. A fixed
  parameter: a number or array, as now. A variable parameter: a number
  (held through the run) or a series over time — `{"0": 5, "10": 7}`, or
  an array per interval — with the fill method; a slider still moves one
  live. A value-less one is "needed", like a fixed one.
- **Engine**: bridge calls for time points (`create_time_point`,
  `get_timepoint_ptr_and_dims`, fill method, wrap); first a check that the
  page's single-threaded run applies them.
- **File**: `{"time": {"0": 5, "10": 7}, "fill": "interpolate"}` for a
  series, beside plain values.

### Decisions for Robert

- Make the kind EXPLICIT, as Simile does (so a constant with no function
  node imported from Simile is a variable parameter, and our sliders list
  those with a range), or keep inferring slider parameters as now and add
  only "variable parameter with no value"? Explicit matches Simile and the
  file; it changes what existing models show (their constants become
  parameters on import).
- Time series now, or variable parameters as single values first?

### Robert's decisions (2026-10-31): explicit kinds; values over time

### Built (2026-10-31)

- **Dialog**: "Data source" — Derived / Variable parameter / Fixed
  parameter (`props.paramKind`, `parameterKind` in export-simile.js). The
  "File parameter" tick box is gone (`fileParam` is still read, as fixed).
  A variable with no kind stored shows what the older rule reads it as
  (`inferWith` in the schema), so OK does not change it.
- **Import** by Simile's rule: function node → derived; none (and
  `complete=true`) → variable, or fixed with `param_type=file`; tables and
  unfinished nodes stay derived. The kind is stored only where the older
  rule would read it differently (`plainKinds`), so models round-trip as
  before. **Export**: both kinds as one node.
- **Panel**: both kinds, a badge for each ("variable", "fixed", "+ slider").
  A variable parameter takes a number/array held through the run, or
  values over time (`{"0": 5, "10": 7}`, or `[5, 7, 9]` for times 0, 1,
  2), and "Between times: last value / closest value / interpolated". The
  file keeps fill methods in a `fill` map beside `variables`, per submodel.
- **Engine**: `sx_param_series` (time points, fill method, interval) and
  `sx_param_unseries` in bridge.cpp; times are model time (interval = days
  per unit). A slider moved last beats a number from the panel; values
  over time take over at their first time point (Simile's own rule:
  `update_from_points` copies a point's values only when the run passes
  it).
- **Results**: of the 20 catalogue models with parameters, 17 now compile
  and run in the page; the other 3 are refused for elements genuinely
  unfinished in the file. Round trip 66/72 identical. nkometou: 31 variable and 15
  fixed parameters; no "has no value" left — only the crossing forms.
- Found on the way: `"false"` (a literal) exported bare, which Prolog reads
  as a string (life_input would not build). Written as Simile's atom
  `'"false"'` now, and read back as `"false"`.

### Still open

- A population's parameters (per member).
- Wrap time (a series repeating), and an interval other than 1 time unit.
- ~~Simile's XML `.spf`.~~ Read since 2026-11-02: XML (`single_value`,
  `multi_value`, `byte_array` incl. time series and fill method) and the
  first, MIME text format (`NOW v`, time-value pairs). Data-file references
  and per-record (population) values are reported, not read. nkometou.spf:
  all 15 values taken.
- When and where the panel appears.
- SimiLive: values cannot be sent there yet.

## AD HOC, TO BE REVISITED (Robert, 2026-11-02)

Two defaults for a VARIABLE parameter with no value, so that models like
nkometou run (`inputParametersOf` in src/simulation.js, `midpoint`):

- with a Minimum and Maximum: the middle of the range (Robert's rule);
- a boolean (`units=boolean`) with no range: **false** — nkometou's 15
  innovation switches (`establish oilpalm`, …), which have `spec=[]` and
  are in neither the model nor its `.spf`. Robert: "an ad hoc decision
  that needs to be re-visited, presumably by making it a formal requirement
  that a default value must be provided."

Neither is written into the model; both are sent at reset and shown in the
Parameters panel. Revisit: require a default for every parameter (the
dialog and the importer saying so), and drop these.

## File names (Robert, 2026-11-02)

Ours are JSON and saved as `<model>.parameters.json` (not `.spf`: an
extension says what is inside). Simile's own keep their names — `.pl`,
`.spf` — never renamed. Load… takes both, telling them apart by content.
