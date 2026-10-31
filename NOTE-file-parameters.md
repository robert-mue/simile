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

## Decisions for Robert

- **Where do the values live?** (a) with the model spec, so a model and its
  values travel together (export, embedded-widget pages), one set per
  model; or (b) apart from the model, as named parameter sets/files — one
  model, several scenarios, as Simile does; or both: the model keeps the
  values last used, and sets can be loaded and saved.
- **Pop up at ▶ when values are missing (as Simile), or only report?**
- **Do we need to READ Simile's `.spf` files now** (only if there are real
  ones to use — Jasper may have nkometou's), or start with our own fields?
