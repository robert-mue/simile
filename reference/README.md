# The Simile model catalogue, and six re-saves

Reference data, not application code. It is here because the repository is the
durable copy and neither directory was in any git repository before 2026-08-13.

## `catalogue/` — 72 `.pl` files

The Simile model catalogue, as it stood when we received it. **Every file is
format 9.0 or older**: 65 written in 2008, five in 2003, two in 2007. Nothing is
newer, so this is a snapshot rather than a moving target — which is exactly what
makes it usable as a baseline.

It is the input to three things:

- `test/roundtrip.html` — select all 72 files; the round trip is the strongest
  check we have that the converters agree with each other.
- `test/corpus.js` — generated from these, **through the importer**, so the
  grammar test exercises the pipeline rather than raw file bytes.
- Every count in `STATUS.md` items 33–42 and in the audit page.

**Do not add to this directory or edit it.** Its value is that it does not
change; a number measured against it in August 2026 means the same thing later.

## `catalogue-2026/` — six models, re-saved by Simile 7.4

The same models opened in **current Simile (7.4, file format 11.4,
`edition=free`)**, run, and exported with `File ▸ Export ▸ model declarations`
on 12–13 August 2026. Filenames are unchanged, so `diff -r catalogue
catalogue-2026` pairs them up.

| model | from | what it was chosen for |
|---|---|---|
| `ranking1` | 2008, 9.0 | association with two roles; a `creation` symbol |
| `hexagon` | 2008, 9.0 | the ordinal alias convention (`var12` / `var12_0`) |
| `feeding1` | 2008, 9.0 | an association whose two ends are differently named |
| `johadP` | 2008, 9.0 | flows crossing boundaries; `immigration` and `loss` |
| `prime` | 2008, 9.0 | `alarm`, the one symbol we had no equivalent for |
| `lamos1a` | **2003, 7.1** | the oldest format, and a built-in spatial relation |

All six loaded and ran with no warnings or errors.

### What they settled

Questions we had been about to put to the developer, answered by watching what
Simile actually writes:

- **The population symbols** — `creation`, `loss`, `immigration` and `alarm` come
  back **unchanged**. The three spellings we had inferred are current.
- **Association aliases** — the `use(…)` terms are **byte-identical** after
  eighteen years, and the catalogue uses at least three conventions (role name,
  ordinal, plain) *within* 2008 v9.0 files. Simile imposes **no convention**;
  the alias is whatever the modeller typed. Our exporter deriving
  `<alias>_<role>` is imposing a rule that does not exist.
- **`border`** (§A4) — `lamos1a` has 142 variables and no borders in 2003, and 60
  variables and 82 borders after the re-save. Simile converts legacy plain-
  `variable` boundary stubs to `border` on load, confirming the guess.
- **What `alarm` is** — a boolean-valued element whose name sibling equations
  reference, not a membership condition.

### And two bugs of ours that no 9.0 file could reach

- An influence *out of* a flow's rate is drawn from the flow **arc** in 9.0 and
  from the rate **function** in 11.4. Reading the newer spelling as a pairing
  cost `johadP` twelve arcs.
- The legacy boundary stubs above, which we had been importing as real elements:
  82 phantom elements in `lamos1a`, 82 in `lamos1b`, 749 in `Molusc_june06`.

### What 11.4 changes in a file

Float coordinates; `attached=[…]` on every flow segment, not only the one
carrying the rate; `along=` on every border; and the one semantic addition —
Simile now **derives units**, writing `units=1/day` on flow rates that carried
`units=1` in 2008.

Apart from those and some pretty-printing (` 0.005` for `0.005`, a space before
`else`), the re-saved models are **element-for-element identical** to their
originals — across up to twenty-three years and four format revisions.
