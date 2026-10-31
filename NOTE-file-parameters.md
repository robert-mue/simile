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
