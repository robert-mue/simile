# Simile model file reference

**Writing a Simile model as a file, without the app.** For people who write
one by hand, and for an AI assistant (Claude, or any other) given a paper
that describes a model in words and equations and asked for the model file.

*First draft, 2026-11-18. Covers stocks, flows, variables, parameters and
the three kinds of submodel. Not covered yet: associations (role arrows),
conditional submodels, enumerated types, sketched graphs and events. Build
those in the app.*

## How to use it

**If you are a person:** give this whole document to the assistant, with the
paper or a description of the model, and ask for "the Simile model file
for this model". Save what it writes as `<name>.json`, then in Simile choose
**File ▸ Open model file…**. The model opens with its diagram, its run
settings and its graphs. An element drawn in **red** is incomplete. The
status line of the Simulation panel says how many there are. Click on one to
see what is wrong, and give that back to the assistant.

**If you are an assistant:** the rest of this document is written for you.
Write ONE JSON file, the *model spec*, exactly in the format below. Copy the
pattern of the worked examples at the end; they are known to open and run.
Go through the checklist (section 12) before you hand the file over. Then
say what you assumed: every value or equation the source did not give you.

---

## 1. The ideas, in a paragraph each

These are Simile's terms. Simile's own manual explains each at more length.

- **Stock** (Simile calls it a *compartment*): a quantity that accumulates
  over time, like a population or the water in a tank. It has an *initial
  value*. Only flows change it.
- **Flow**: the movement of the quantity into or out of a stock. It is drawn
  as a thick arrow with a **valve** in the middle. The valve holds the flow's
  name and its **rate** (amount per unit of time). A flow runs from one stock
  to another, or from a **cloud** (outside the model) into a stock, or from a
  stock out to a cloud. The rate of change of a stock is the sum of its
  inflows minus the sum of its outflows: Simile integrates for you.
- **Variable**: a value computed from an equation (*derived*), or a
  **parameter** whose value is given when the model runs.
- **Influence**: a thin arrow saying "this value is used in that equation".
  **An equation may only use a name that arrives along an influence.** That
  includes the stock a flow's own rate depends on.
- **Submodel**: a box of elements that is repeated. A *fixed-membership*
  submodel has a set number of copies (instances), like 5 plants or 10
  fields. A *population* submodel has members that are created and removed
  as the model runs, like trees in a forest.
- **Population symbols**, inside a population submodel only: *creation*
  (how many members at the start), *immigration* (new members per unit of
  time), *reproduction* (new members per member per unit of time), *loss*
  (the probability that a member is removed in a unit of time, or a
  condition that removes it when true).

## 2. From a paper to a model

1. **Find the state variables.** Every `dX/dt = …` gives a stock `X` with
   the stated initial value.
2. **Split each right-hand side into flows.** Each term with a meaning of
   its own (births, deaths, predation, harvest) becomes a flow. A positive
   term flows *into* the stock, a negative term *out of* it. A term that
   moves the quantity from one stock to another (e.g. infection from
   susceptible to infected) is one flow between the two stocks, not two
   flows. A single flow holding the whole net rate also works, but separate
   flows make a much clearer diagram.
3. **Every constant becomes a variable**, named after its meaning
   (`birth_rate`, not `a`, if the paper says what `a` is). If the paper
   gives a value and a plausible range, make it a parameter with a slider
   (section 5.3).
4. **Every algebraic relation becomes a variable** with that equation, e.g.
   `total = prey + predators`.
5. **Draw an influence for every name each equation uses.**
6. **Repeated things are a submodel.** "Each of N patches/animals/fields
   has …" is a fixed-membership submodel of size N. "Individuals are born,
   grow and die" is a population submodel.
7. **A discrete-time model** `x(t+1) = x(t) + f(x(t))` is a stock `x` with
   one flow of rate `f`, run with time step 1. For `x(t+1) = g(x(t))`
   write the flow as `g(x) - x`.
8. **Choose the run settings** from the paper's figures: how long, and how
   often to record (section 9).

## 3. The file

A model spec is one JSON object.

| Key | Required | What it is |
|---|---|---|
| `format` | yes | Always `3`. |
| `schema` | yes | Always `"simile-v1"`. |
| `id` | yes | A short identifier: letters, digits and underscores. |
| `name` | yes | The model's name as shown in the app. |
| `nodes` | yes | Every element except submodels: `{ "node1": {…}, … }`. |
| `arcs` | yes | Every flow and influence: `{ "arc1": {…}, … }`. |
| `submodels` | yes | `{ "submodel1": {…} }`, or `{}`. |
| `layout` | yes | Where each element is drawn (section 8). |
| `enums` | yes | Always `{}` for now. |
| `metadata` | no | Title, description, keywords, paper (section 10). |
| `presentation` | no | Run settings and the graphs to open (section 9). Strongly recommended. |

**Ids** are a family name and a number: `node1`, `node2`, … for nodes,
`arc1`, … for arcs, `submodel1`, … for submodels. Nothing else. Number them
from 1 in any order; they never appear on screen.

## 4. Nodes

Every node has the same four keys:

```json
"node1": { "type": "stock", "parent": null, "label": "prey", "props": { "initial": "10", "units": "" } }
```

- `type`: one of the types in the table below.
- `parent`: the id of the submodel it is in, or `null` for the top level.
- `label`: its name, which is also the name its value has in equations
  (section 6). Clouds have `""`.
- `props`: the fields for its type. **Every value is a string**, even a
  number: `"10"`, not `10`.

| `type` | Is | `props` | Required |
|---|---|---|---|
| `stock` | a stock | `initial`: an expression for the starting value. `units` | `initial` |
| `valve` | a flow's valve: its name and rate | `rate`: the amount flowing per unit of time. `units` | `rate` |
| `cloud` | the outside end of a flow | `{}` | |
| `variable` | a value | `value`: the equation, or a parameter's default. `paramKind`: `""`, `"variable"` or `"fixed"` (5.3). `min`, `max`: a slider's range. `units` | `value`, unless a parameter |
| `initialiser` | *creation* (population only) | `expr`: the number of members at the start | `expr` |
| `migrator` | *immigration* (population only) | `expr`: new members per unit of time | `expr` |
| `reproduction` | *reproduction* (population only) | `expr`: new members per member per unit of time | `expr` |
| `exterminator` | *loss* (population only) | `expr`: probability of removal per unit of time, or a condition | `expr` |

### 4.1 Flows need three nodes and one arc

A flow is a `valve` node, plus a `flow` arc (section 5.1) that names the
valve and the two ends. An end that is not a stock is a `cloud` node. Give
**each cloud to one flow only**, and put the valve, its clouds and its
stock(s) **in the same submodel** (the same `parent`).

## 5. Arcs

### 5.1 Flow

```json
"arc1": { "type": "flow", "from": "node3", "to": "node1", "valve": "node7", "props": {} }
```

`from` and `to` are stocks or clouds, at least one of them a stock. `valve`
is the flow's valve node. The direction is the direction of a positive
rate.

### 5.2 Influence

```json
"arc5": { "type": "influence", "from": "node1", "to": "node7", "alias": "prey", "props": {} }
```

`from` is the element whose value is used; `to` is the element whose
equation uses it. **Into a flow means into its valve.** `to` must be
something with an equation: a variable, a valve, a stock (for its initial
value) or a population symbol. `alias` is the name the value has in that
equation: always the source's `label`, without brackets.

### 5.3 Parameters

A variable is one of three kinds, by `paramKind`:

- `""` (derived): its `value` is an equation, computed every time step.
- `"variable"`: a **variable parameter**, read every time step. With `min`
  and `max` it gets a slider; the user can also give it values over time.
  `value` is its default. Use it for anything a reader may want to vary.
- `"fixed"`: a **fixed parameter**, read once at the start. `value` is its
  default.

Give a parameter a plain number as its `value`, and draw no influence into
it.

## 6. Names and how equations refer to them

- A label is **letters, digits and underscores**, not starting with a
  digit: `birth_rate`, `N0`, `x2`. **No spaces**, no hyphens, no `?`.
- Labels must differ between elements in the **same submodel** (and between
  elements at the top level). The same label in different submodels is
  allowed.
- An equation refers to an element by its label, and only to elements that
  influence it (the influence's `alias`).
- **Crossing a submodel's edge.** A value coming *in* to a submodel from
  outside is one value, written plainly: `r`. A value going *out* of a
  multi-instance submodel is one value per instance, and the equation must
  write it in brackets:
  - out of a **fixed-membership** submodel: square brackets, an array:
    `sum([biomass])`, `greatest([biomass])`
  - out of a **population** submodel: curly brackets, a list:
    `sum({size})`, `count({size})`

  The alias stays bare (`"biomass"`); only the equation has the brackets.
  Use such a value through a function that combines them (`sum`, `count`,
  `greatest`, `least`, `any`, `all`, `product`, `element`).
- **Inside a submodel**, `index(1)` is the instance's number (1, 2, …), so
  instances can differ: `base_rate*(0.5+0.25*index(1))`.

## 7. Equations

Written as Simile writes them:

| | |
|---|---|
| Numbers | `3`, `0.25`, `1e-3` |
| Arithmetic | `+ - * /`, `^` for power, `//` integer division, `%` remainder |
| Comparison | `==`, `!=`, `<`, `<=`, `>`, `>=`. **Equality is `==`**, not `=`. |
| Logic | `and`, `or`, `xor`, `not` |
| Conditional | `if x > 10 then 1 elseif x > 5 then 0.5 else 0` |
| Brackets | `( … )` for grouping. `[ … ]` and `{ … }` mean arrays and lists (section 6), never grouping. |

**Functions.** The ones most often needed:

| | |
|---|---|
| Arithmetic | `abs(x)`, `exp(x)`, `log(x)` (natural), `log10(x)`, `sqrt(x)`, `pow(x,y)`, `min(x,y)`, `max(x,y)`, `floor(x)`, `ceil(x)`, `round(x)`, `int(x)`, `sgn(x)`, `fmod(x,y)`, `hypot(x,y)`, `pi()` |
| Trigonometry | `sin(x)`, `cos(x)`, `tan(x)`, `asin(x)`, `acos(x)`, `atan(x)`, `atan2(x,y)`, `sinh`, `cosh`, `tanh` (radians) |
| Time | `time()` the current time; `dt()` the time step; `prev(n)` this element's own value n steps ago; `last(x)` x's value at the previous step |
| Inputs over time | `step(height, time)`, `ramp(time, slope)`, `pulse(magnitude, first_time [, interval])` |
| Random | `rand_const(lo,hi)` uniform, drawn once (at the start, or when a member is created); `rand_var(lo,hi)` uniform, drawn every step; `gaussian_var(mean, sd)` normal, every step; `poidev(mean)`; `exprnd(mean)`; `binome(prob, n)` |
| Arrays and lists | `sum(…)`, `count(…)`, `product(…)`, `greatest(…)`, `least(…)`, `any(…)`, `all(…)`, `element([x], i)`, `makearray(x, n)`, `index(1)` |
| Delays and smoothing | `delay1(input, duration)`, `delay3(input, duration)`, `smth1(input, time)`, `smth3(input, time)` |

Do not use a function that is not listed in Simile's manual, and do not
invent new ones. `pow(x,y)` and `x^y` are the same.

## 8. Layout

`layout` says where each element is drawn on the diagram, in pixels, with
y increasing **downwards**:

```json
"layout": {
  "node1": { "x": 250, "y": 110 },
  "submodel1": { "x": 300, "y": 180, "w": 260, "h": 160 }
}
```

- `x`, `y` are the element's **centre**. A submodel also has `w` and `h`,
  its width and height, so it spans `x ± w/2`, `y ± h/2`.
- **Every node has an entry except valves.** A valve is drawn halfway along
  its flow, so it has no entry.
- **Every submodel has an entry**, and every element inside it must be
  drawn well inside its box, clear of its edge. No element outside a
  submodel may be drawn inside its box.
- Sizes to plan with: a stock is 25 × 17, a variable a circle of 13, a cloud
  17 × 11.

A layout that works:

- Lay each stock's flows out on one horizontal line: `cloud — valve — stock
  — valve — cloud`, about 140 apart, so each valve sits midway.
- Put stocks that a flow joins on the same line. Put unrelated stocks on
  separate lines about 140 apart.
- Put each variable about 60 above or below the valve or variable it feeds.
- Leave at least 80 between labels: a label is written under its element
  and can be wide.

The app places the points where arrows cross a submodel's edge itself.

## 9. Run settings and displays: `presentation`

```json
"presentation": {
  "run": { "runLength": 30, "logEach": 0.1, "timeStep": "0.01" },
  "displays": [
    { "widget": "plotter", "variables": ["node1", "node2"] },
    { "widget": "sliders" }
  ]
}
```

When the model is opened, these displays open and the model runs once.

- `runLength`: how long a run is, in the model's time units.
- `logEach`: how often a value is recorded for the graphs.
- `timeStep`: the integration step, **a string**. Small enough to be
  accurate: for a rate constant `k`, well under `1/k`. With 1000 or more
  steps per run, choose a `logEach` that gives a few hundred points.
- `displays`: `plotter` draws the listed elements (by node id) against
  time; give one plotter per group of values on a similar scale. `sliders`
  shows a slider for every variable parameter that has `min` and `max`.

## 10. About the model: `metadata`

```json
"metadata": {
  "title": "…", "description": "…", "keywords": ["…"],
  "paper": { "citation": "Author (Year) Title. Journal.", "url": "https://doi.org/…" }
}
```

All optional. `description`: what the model is about, in two or three
sentences. If the model came from a paper, give the paper.

## 11. Units: leave time out of them

`units` is optional. **Do not put a unit of time in it** (`1/year`,
`kg/day`, `m/year`). The engine converts time units to its own, and the
model's time unit is not a year or a day, so a `/year` silently divides a
rate by 365. A unit with no time in it (`kg`, `m`, `individuals`) is safe.
When in doubt, leave `units` as `""`, and say in the description what the
time unit is ("time is in years").

## 12. Checklist

Before handing over the file, check every point:

1. `format` is `3`, `schema` is `"simile-v1"`, and every id is `node<n>`,
   `arc<n>` or `submodel<n>`.
2. Every value in `props` is a string.
3. Every label is letters, digits and underscores only, and unique within
   its submodel.
4. Every flow arc has a `valve` node and two ends, each a stock or a cloud,
   with at least one stock. Each cloud belongs to one flow.
5. **Every name in every equation has an influence** into that element
   (into the valve, for a flow) whose `alias` is that name. **No influence
   is left unused.**
6. A value leaving a submodel is written `[x]` (fixed membership) or `{x}`
   (population) in the equation, inside a function such as `sum`.
7. Equality is `==`. No `=` in an equation.
8. Population symbols are only in population submodels; every population
   has a creation or an immigration.
9. Every node except valves, and every submodel, has a `layout` entry;
   everything in a submodel is drawn inside its box, and nothing else is.
10. No unit of time in any `units`.
11. `presentation` is there, with a sensible `timeStep`, and plots the
    stocks that matter.

### Common mistakes

- Writing a flow's rate on the arc. The rate is the **valve's** `rate`.
- Influencing the flow arc instead of its valve.
- Forgetting the influence from a stock to its own flow's valve
  (`prey_birth_rate*prey` needs `prey → prey_births`).
- Numbers instead of strings: `"initial": 10`.
- Names with spaces, or a paper's symbols with primes or subscripts
  (`N'`, `K_{max}`): write `N_dash`, `K_max`.
- Using `=` for equality, or `if … then … else` without the `then`.
- A unit of time in `units`.

## 13. Checking a model

In the app, a model that is not complete shows its incomplete elements in
**red**, and the Simulation panel's status line says how many there are.
Click on one to see what is wrong. A complete model runs when you press ▶.

For developers, `tools/headless/scripts/model-file.py` takes model spec
files and applies the app's own checks: it reads the file as File ▸ Open
does, reports each incomplete element and grammar breach, exports it to
Simile's own format, compiles it, runs it with the file's run settings and
prints the values at the end of the run.

## 14. Worked examples

Each one below is also a file in `examples/models/`, and each is checked
by `tools/headless/scripts/model-file.py`: it opens, is complete, and runs.

### 14.1 Predator-prey: stocks, flows, parameters with sliders

The Lotka-Volterra equations, `dprey/dt = a·prey − b·prey·predators` and
`dpredators/dt = c·b·prey·predators − d·predators`, with each term a flow
and each constant a variable parameter with a slider.

<!-- example: examples/models/predator-prey.json -->

```json
{
  "id": "predator_prey",
  "name": "Predator-prey",
  "format": 3,
  "schema": "simile-v1",
  "metadata": {
    "title": "Predator-prey (Lotka-Volterra)",
    "description": "Prey grow exponentially and are eaten by predators; predators grow in proportion to what they eat and die at a constant rate. The two populations cycle. A worked example for the model file reference.",
    "keywords": ["predator-prey", "population dynamics", "differential equations"]
  },
  "presentation": {
    "run": { "runLength": 30, "logEach": 0.1, "timeStep": "0.01" },
    "displays": [
      { "widget": "plotter", "variables": ["node1", "node2"] },
      { "widget": "sliders" }
    ]
  },
  "enums": {},
  "submodels": {},
  "nodes": {
    "node1":  { "type": "stock", "parent": null, "label": "prey",      "props": { "initial": "10", "units": "" } },
    "node2":  { "type": "stock", "parent": null, "label": "predators", "props": { "initial": "5",  "units": "" } },

    "node3":  { "type": "cloud", "parent": null, "label": "", "props": {} },
    "node4":  { "type": "cloud", "parent": null, "label": "", "props": {} },
    "node5":  { "type": "cloud", "parent": null, "label": "", "props": {} },
    "node6":  { "type": "cloud", "parent": null, "label": "", "props": {} },

    "node7":  { "type": "valve", "parent": null, "label": "prey_births",     "props": { "rate": "prey_birth_rate*prey", "units": "" } },
    "node8":  { "type": "valve", "parent": null, "label": "predation",       "props": { "rate": "predation_rate*prey*predators", "units": "" } },
    "node9":  { "type": "valve", "parent": null, "label": "predator_births", "props": { "rate": "conversion*predation_rate*prey*predators", "units": "" } },
    "node10": { "type": "valve", "parent": null, "label": "predator_deaths", "props": { "rate": "predator_death_rate*predators", "units": "" } },

    "node11": { "type": "variable", "parent": null, "label": "prey_birth_rate",     "props": { "paramKind": "variable", "value": "1",    "units": "", "min": "0.5",  "max": "2" } },
    "node12": { "type": "variable", "parent": null, "label": "predation_rate",      "props": { "paramKind": "variable", "value": "0.1",  "units": "",       "min": "0.05", "max": "0.2" } },
    "node13": { "type": "variable", "parent": null, "label": "conversion",          "props": { "paramKind": "variable", "value": "0.75", "units": "",       "min": "0.25", "max": "1" } },
    "node14": { "type": "variable", "parent": null, "label": "predator_death_rate", "props": { "paramKind": "variable", "value": "1.5",  "units": "", "min": "0.5",  "max": "3" } }
  },
  "arcs": {
    "arc1":  { "type": "flow", "from": "node3", "to": "node1", "valve": "node7",  "props": {} },
    "arc2":  { "type": "flow", "from": "node1", "to": "node4", "valve": "node8",  "props": {} },
    "arc3":  { "type": "flow", "from": "node5", "to": "node2", "valve": "node9",  "props": {} },
    "arc4":  { "type": "flow", "from": "node2", "to": "node6", "valve": "node10", "props": {} },

    "arc5":  { "type": "influence", "from": "node1",  "to": "node7",  "alias": "prey",                "props": {} },
    "arc6":  { "type": "influence", "from": "node11", "to": "node7",  "alias": "prey_birth_rate",     "props": {} },
    "arc7":  { "type": "influence", "from": "node1",  "to": "node8",  "alias": "prey",                "props": {} },
    "arc8":  { "type": "influence", "from": "node2",  "to": "node8",  "alias": "predators",           "props": {} },
    "arc9":  { "type": "influence", "from": "node12", "to": "node8",  "alias": "predation_rate",      "props": {} },
    "arc10": { "type": "influence", "from": "node1",  "to": "node9",  "alias": "prey",                "props": {} },
    "arc11": { "type": "influence", "from": "node2",  "to": "node9",  "alias": "predators",           "props": {} },
    "arc12": { "type": "influence", "from": "node12", "to": "node9",  "alias": "predation_rate",      "props": {} },
    "arc13": { "type": "influence", "from": "node13", "to": "node9",  "alias": "conversion",          "props": {} },
    "arc14": { "type": "influence", "from": "node2",  "to": "node10", "alias": "predators",           "props": {} },
    "arc15": { "type": "influence", "from": "node14", "to": "node10", "alias": "predator_death_rate", "props": {} }
  },
  "layout": {
    "node1":  { "x": 250, "y": 110 },
    "node2":  { "x": 250, "y": 250 },
    "node3":  { "x": 110, "y": 110 },
    "node4":  { "x": 390, "y": 110 },
    "node5":  { "x": 110, "y": 250 },
    "node6":  { "x": 390, "y": 250 },
    "node11": { "x": 150, "y": 50 },
    "node12": { "x": 350, "y": 50 },
    "node13": { "x": 150, "y": 310 },
    "node14": { "x": 350, "y": 310 }
  }
}
```

### 14.2 Five plants: a fixed-membership submodel

Five plants, each growing logistically at its own rate, `base_rate`
coming in from outside, and `total` going out as `sum([biomass])`.
`max_biomass` is a fixed parameter.

<!-- example: examples/models/plants.json -->

```json
{
  "id": "plants",
  "name": "Plants",
  "format": 3,
  "schema": "simile-v1",
  "metadata": {
    "title": "Five plants",
    "description": "Five plants, each growing logistically towards a shared maximum at its own rate, and their total biomass. Shows a fixed-membership submodel, with values crossing its boundary in both directions. A worked example for the model file reference.",
    "keywords": ["submodel", "fixed membership", "array"]
  },
  "presentation": {
    "run": { "runLength": 60, "logEach": 1, "timeStep": "0.1" },
    "displays": [
      { "widget": "plotter", "variables": ["node1"] },
      { "widget": "plotter", "variables": ["node7"] }
    ]
  },
  "enums": {},
  "submodels": {
    "submodel1": {
      "kind": "fixed-membership",
      "parent": null,
      "label": "plant",
      "props": { "dimensions": "5" }
    }
  },
  "nodes": {
    "node1": { "type": "stock",    "parent": "submodel1", "label": "biomass",     "props": { "initial": "1", "units": "kg" } },
    "node2": { "type": "cloud",    "parent": "submodel1", "label": "",            "props": {} },
    "node3": { "type": "valve",    "parent": "submodel1", "label": "growth",      "props": { "rate": "growth_rate*biomass*(1-biomass/max_biomass)", "units": "" } },
    "node4": { "type": "variable", "parent": "submodel1", "label": "growth_rate", "props": { "value": "base_rate*(0.5+0.25*index(1))", "units": "" } },

    "node5": { "type": "variable", "parent": null, "label": "base_rate",   "props": { "paramKind": "variable", "value": "0.1", "units": "", "min": "0.02", "max": "0.3" } },
    "node6": { "type": "variable", "parent": null, "label": "max_biomass", "props": { "paramKind": "fixed",    "value": "50",  "units": "kg" } },
    "node7": { "type": "variable", "parent": null, "label": "total",       "props": { "value": "sum([biomass])", "units": "kg" } }
  },
  "arcs": {
    "arc1": { "type": "flow",      "from": "node2", "to": "node1", "valve": "node3", "props": {} },
    "arc2": { "type": "influence", "from": "node1", "to": "node3", "alias": "biomass",     "props": {} },
    "arc3": { "type": "influence", "from": "node4", "to": "node3", "alias": "growth_rate", "props": {} },
    "arc4": { "type": "influence", "from": "node5", "to": "node4", "alias": "base_rate",   "props": {} },
    "arc5": { "type": "influence", "from": "node6", "to": "node3", "alias": "max_biomass", "props": {} },
    "arc6": { "type": "influence", "from": "node1", "to": "node7", "alias": "biomass",     "props": {} }
  },
  "layout": {
    "submodel1": { "x": 300, "y": 180, "w": 260, "h": 160 },
    "node1": { "x": 380, "y": 210 },
    "node2": { "x": 210, "y": 210 },
    "node4": { "x": 250, "y": 140 },
    "node5": { "x": 90,  "y": 120 },
    "node6": { "x": 90,  "y": 240 },
    "node7": { "x": 510, "y": 180 }
  }
}
```

### 14.3 Trees: a population submodel

Trees are created (5 at the start), arrive (`recruits_per_year`), grow,
and are lost once they reach a size of 17. Each has a random growth rate
and position. Outside, `count({size})` and `sum({size})`.

<!-- example: examples/models/trees.json -->

```json
{
  "id": "trees",
  "name": "Trees",
  "format": 3,
  "schema": "simile-v1",
  "metadata": {
    "title": "A population of trees",
    "description": "Trees start as a few, more arrive each year, each grows towards a maximum size at its own rate, and a tree dies once it is big enough. Each has a position. Shows a population submodel, whose members come and go. A worked example for the model file reference.",
    "keywords": ["population", "individual-based", "spatial"]
  },
  "presentation": {
    "run": { "runLength": 200, "logEach": 1, "timeStep": "1" },
    "displays": [
      { "widget": "plotter", "variables": ["node8"] },
      { "widget": "plotter", "variables": ["node11"] }
    ]
  },
  "enums": {},
  "submodels": {
    "submodel1": {
      "kind": "population",
      "parent": null,
      "label": "tree",
      "props": {}
    }
  },
  "nodes": {
    "node1":  { "type": "stock",        "parent": "submodel1", "label": "size",        "props": { "initial": "3", "units": "m" } },
    "node2":  { "type": "cloud",        "parent": "submodel1", "label": "",            "props": {} },
    "node3":  { "type": "valve",        "parent": "submodel1", "label": "growth",      "props": { "rate": "growth_rate*(1-size/25)", "units": "" } },
    "node4":  { "type": "variable",     "parent": "submodel1", "label": "growth_rate", "props": { "value": "rand_const(0.1,0.3)", "units": "" } },
    "node5":  { "type": "initialiser",  "parent": "submodel1", "label": "initial",     "props": { "expr": "5" } },
    "node6":  { "type": "migrator",     "parent": "submodel1", "label": "recruitment", "props": { "expr": "recruits_per_year" } },
    "node7":  { "type": "exterminator", "parent": "submodel1", "label": "death",       "props": { "expr": "size>17" } },
    "node9":  { "type": "variable",     "parent": "submodel1", "label": "x",           "props": { "value": "rand_const(0,100)", "units": "m" } },
    "node10": { "type": "variable",     "parent": "submodel1", "label": "y",           "props": { "value": "rand_const(0,100)", "units": "m" } },

    "node8":  { "type": "variable", "parent": null, "label": "number_of_trees",   "props": { "value": "count({size})", "units": "" } },
    "node11": { "type": "variable", "parent": null, "label": "total_size",        "props": { "value": "sum({size})", "units": "m" } },
    "node12": { "type": "variable", "parent": null, "label": "recruits_per_year", "props": { "paramKind": "variable", "value": "2", "units": "", "min": "0", "max": "5" } }
  },
  "arcs": {
    "arc1": { "type": "flow",      "from": "node2",  "to": "node1", "valve": "node3", "props": {} },
    "arc2": { "type": "influence", "from": "node1",  "to": "node3", "alias": "size",              "props": {} },
    "arc3": { "type": "influence", "from": "node4",  "to": "node3", "alias": "growth_rate",       "props": {} },
    "arc4": { "type": "influence", "from": "node1",  "to": "node7", "alias": "size",              "props": {} },
    "arc5": { "type": "influence", "from": "node1",  "to": "node8", "alias": "size",              "props": {} },
    "arc6": { "type": "influence", "from": "node1",  "to": "node11", "alias": "size",             "props": {} },
    "arc7": { "type": "influence", "from": "node12", "to": "node6", "alias": "recruits_per_year", "props": {} }
  },
  "layout": {
    "submodel1": { "x": 250, "y": 160, "w": 260, "h": 180 },
    "node1":  { "x": 330, "y": 200 },
    "node2":  { "x": 170, "y": 200 },
    "node4":  { "x": 210, "y": 140 },
    "node5":  { "x": 170, "y": 95 },
    "node6":  { "x": 240, "y": 95 },
    "node7":  { "x": 330, "y": 95 },
    "node9":  { "x": 300, "y": 240 },
    "node10": { "x": 340, "y": 240 },
    "node8":  { "x": 460, "y": 120 },
    "node11": { "x": 460, "y": 200 },
    "node12": { "x": 240, "y": 20 }
  }
}
```
