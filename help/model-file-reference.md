# Simile model file reference

**Writing a Simile model as a file, without the app.** For people who write
one by hand, and for an AI assistant (Claude, or any other) given a paper
that describes a model in words and equations and asked for the model file.

*First draft, 2026-11-18; conditional submodels, curves, enumerated types
and associations added 2026-11-18. Covers stocks, flows, variables,
parameters, the three kinds of submodel, conditional submodels, curves given
as a graph or a table, enumerated types and associations. Not covered:
events, which the app cannot run yet.*

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
- **Submodel**: a box of elements. A *single* submodel is one part of the
  model, boxed. A *fixed-membership* submodel has a set number of copies
  (instances), like 5 plants or 10 fields. A *population* submodel has
  members that are created and removed as the model runs, like trees in a
  forest.
- **Condition** (a diamond): a true-or-false expression inside a single or
  fixed-membership submodel. The submodel, or each instance of it, exists
  only while its condition is true. Such a submodel is called
  *conditional*. It is how a model says "this only happens while…": a
  fishery open only above a stock level, a crop only in the growing
  season.
- **Enumerated type**: a named set of categories, such as `species: oak,
  beech, pine`. A fixed-membership submodel sized by it has one instance
  per member, and each instance knows which member it is.
- **Association**: a submodel holding facts about **pairs** of instances
  of other submodels: which farmer owns which field, which animal is
  larger than which, which patches are neighbours. A **role arrow** runs
  to it from each submodel taking part, named for the part it plays
  (`owner`, `land`). Two role arrows from the same submodel make a
  *self-association*, pairing its instances with each other. A condition
  in the association says which pairings exist.
- **Sketched graph**: a relationship given as a curve rather than an
  equation, held by the variable or flow that uses it, and read in its
  equation as `graph(x)`.
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
8. **"Only while…"**: a process that happens only while something is true
   is a conditional submodel (section 4.2) if it involves several
   elements, or simply `if … then … else 0` in one equation if it does
   not.
9. **Named categories** ("for each of three species…", age classes, land
   uses) are an enumerated type, and the things that differ between them a
   fixed-membership submodel sized by it (section 4.4).
10. **Relationships between individuals** ("each farmer owns some
   fields", "each animal competes with the larger ones") are an
   association (section 4.5).
11. **A relationship given as a table or a figure** (a curve read off a
   graph, monthly values) is `interpolate(x, [xs], [ys])` when the paper
   gives the numbers, or a sketched graph when it gives only a curve
   (section 4.3).
12. **Choose the run settings** from the paper's figures: how long, and how
   often to record (section 9).

What a published model often needs beyond that, each found reproducing one
(the coral model, `examples/papers/coral/`, which agrees with its authors'
published runs):

13. **Read the authors' code first**, when it is published. It settles what
    the paper leaves open: which reading of an equation, the exact constants
    (often more precise than the paper's table), the initial values, the
    time unit, and how events are applied. Their published results are what
    the model is checked against (section 13).
14. **A sudden change in a stock** (a harvest, a fire, bleaching that cuts a
    population at once) is a flow that makes the whole change in one time
    step: `(1-kept)*symbionts/dt()` with `kept` the fraction left, or 1 when
    nothing happens. The flow is multiplied by that same `dt()`, so the
    change is exact. Decide in the paper's terms when it happens (`if … then
    … else 1.0`).
15. **A spin-up** (years at constant conditions to reach equilibrium, then
    the real forcing): start the run before 0 (`"startTime": -24012`) and
    make the forcing constant until 0:
    `T = if time()<0 then T_spinup else T_data`. Time 0 is then the first
    forcing data (January 1955, say).
16. **Forcing data** (a temperature or rainfall series): a variable
    parameter given values over time in a parameter file, beside the model
    as `<model>.parameters.json`: `{"variables": {"T_data": [25.9, 22.9,
    …]}, "fill": {"T_data": "use_last"}}`, the values for times 0, 1, 2, …
    (`use_last` holds each until the next). Scenarios, or regions that
    differ only in constants, are one model and a parameter file each. For
    now give those constants as variable parameters, not fixed ones (section
    5.3).
17. **The time step: a number exact in binary** (0.5, 0.25, 0.125, 0.0625),
    not 0.1. Simile adds the step up to get `time()`, so with 0.1 it drifts,
    and a test on the time (`time()>=10`, the start of a month) can go the
    wrong way for one step. With 0.125, `time()` is exact.
18. **A function Simile lacks** is built from those it has, as variables:
    the normal distribution's cumulative function, for instance, from
    Abramowitz and Stegun's approximation to `erf` (7.1.26, error under
    1.5e-7). A function of one input only can also be a table,
    `interpolate(x, [xs], [ys])`, computed from the paper's formula.
19. **A derivative in the paper** (`dU/dt = N·∂F/∂U`): Simile does not
    differentiate. Work it out by hand and write it as an equation; check it
    against the authors' code.
20. **Copying an equation, watch for:** `-z^2`, which is `(-z)^2` in Simile
    (section 7); an `if` with a whole number in one branch and a decimal in
    another, which may not build: write `1.0`, not `1`; very large or small
    numbers (10^21 cells), which are fine; and small numbers the authors add
    to denominators to keep them off zero, which belong in the model too.

## 3. The file

A model spec is one JSON object.

| Key | Required | What it is |
|---|---|---|
| `format` | yes | Always `3`. |
| `schema` | yes | Always `"simile-v1"`. |
| `id` | yes | A short identifier: letters, digits and underscores. |
| `name` | yes | The model's name as shown in the app. |
| `nodes` | yes | Every element except submodels: `{ "node1": {…}, … }`. |
| `arcs` | yes | Every flow, influence and role: `{ "arc1": {…}, … }`. |
| `submodels` | yes | `{ "submodel1": {…} }`, or `{}`. |
| `layout` | yes | Where each element is drawn (section 8). |
| `enums` | yes | Always `{}`. |
| `props` | no | The whole model's own settings, as a submodel has them: `enumTypes` (section 4.4) and `comment`. |
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
| `stock` | a stock | `initial`: an expression for the starting value. `units`: `""` | `initial` |
| `valve` | a flow's valve: its name and rate | `rate`: the amount flowing per unit of time. `units`: `""`. `graph` (4.3) | `rate` |
| `cloud` | the outside end of a flow | `{}` | |
| `variable` | a value | `value`: the equation, or a parameter's default. `paramKind`: `""`, `"variable"` or `"fixed"` (5.3). `min`, `max`: a slider's range. `units`: `""`. `graph` (4.3) | `value`, unless a parameter |
| `condition` | a submodel's condition (not in a population) | `expr`: true or false, e.g. `fish>closure_level` | `expr` |
| `initialiser` | *creation* (population only) | `expr`: the number of members at the start | `expr` |
| `migrator` | *immigration* (population only) | `expr`: new members per unit of time | `expr` |
| `reproduction` | *reproduction* (population only) | `expr`: new members per member per unit of time | `expr` |
| `exterminator` | *loss* (population only) | `expr`: probability of removal per unit of time, or a condition | `expr` |

### 4.1 Flows need three nodes and one arc

A flow is a `valve` node, plus a `flow` arc (section 5.1) that names the
valve and the two ends. An end that is not a stock is a `cloud` node. Give
**each cloud to one flow only**, and put the valve, its clouds and its
stock(s) **in the same submodel** (the same `parent`).

### 4.2 Submodels

```json
"submodel1": { "kind": "fixed-membership", "parent": null, "label": "plant", "props": { "dimensions": "5" } }
```

- `kind`: `"single"`, `"fixed-membership"` or `"population"`.
- `parent`: the submodel it is in, or `null`.
- `label`: its name, shown on the box.
- `props`: `{ "dimensions": "5" }` for a fixed-membership submodel: the
  number of instances (`"4,44"` is a 4 × 44 grid). `{}` for the others.

Its elements say `"parent": "submodel1"`. A submodel needs a `layout`
entry with its size (section 8).

**A conditional submodel** is a single (or fixed-membership) submodel with
one or more `condition` nodes in it. It exists while all its conditions
are true, and while it does not exist its elements have no values. So a
value leaving it is a **list** (section 6), with no members while it does
not exist: `sum({catch})` is the catch while the fishery is open and 0
while it is closed. A flow that should run only while the condition holds
is therefore drawn OUTSIDE the submodel, with its rate taken from inside:
see the fishery (14.4). A condition may use values from outside, along
influences, like any equation. A population submodel cannot have one.

### 4.3 Curves: interpolate, or a sketched graph

A relationship the paper gives as a **table** (monthly rainfall, a dose
and its response) is best written with `interpolate`, which keeps the
numbers exactly:

```
interpolate(month, [0, 3, 6, 9, 12], [160, 80, 10, 90, 160])
```

The first argument is the x value, then the x values of the table in
increasing order, then the y value for each. Between two x values it
interpolates in a straight line.

A relationship given only as a **curve**, or one the user should be able
to redraw by hand in the app (its Graph tab), is a **sketched graph**:
the variable or valve holds it in `props.graph`, and its equation reads it
with `graph(x)`:

```json
"props": {
  "value": "graph(month)", "units": "",
  "graph": {
    "xmin": 0, "xmax": 12, "ymin": 0, "ymax": 200,
    "points": [0.8, 0.7, 0.55, 0.4, 0.25, 0.1, 0.05, 0.1, 0.25, 0.45, 0.65, 0.75, 0.8],
    "outside": "truncate", "between": "interpolate"
  }
}
```

- `xmin`, `xmax`, `ymin`, `ymax`: the axes, as **numbers** (not strings).
- `points`: the curve's heights at evenly spaced x values from `xmin` to
  `xmax` (13 points from 0 to 12 is one per month), each a **fraction of
  the y range** from 0 to 1: the value is `ymin + point × (ymax − ymin)`.
  So 0.8 above is 160. At least 2 points. Heights are kept to 1/400 of the
  y range, as in Simile.
- `outside`: what x beyond the axes gives: `"truncate"` (the nearest end),
  `"extrapolate"` or `"wraparound"`.
- `between`: `"interpolate"` (a straight line between points) or
  `"round"` (the nearest point).

One graph per element. The x value comes along an influence, as usual
(`month → rainfall`).

### 4.4 Enumerated types

Declare a type in the **whole model's** `props`, one line per type, its
name, a colon, then its members:

```json
"props": { "enumTypes": "species: oak, beech, pine\nage_class: young, mature, old" }
```

(`\n` separates two types.) A type can also be declared in a submodel's
`props.enumTypes`, but then it is known only inside that submodel, and a
value leaving the submodel to the top level will not build. Declare it for
the whole model.

**Use it as the size of a fixed-membership submodel**: `"dimensions":
"species"` gives one instance per member. Inside, `index(1)` is the
instance's **member, not a number**:

- compare it with a member, written in double quotes:
  `if index(1)=="oak" then 0.05 elseif index(1)=="beech" then 0.08 else 0.12`
- `as_number(index(1))` is its position, 1, 2, 3, for arithmetic or for
  `element([0.05, 0.08, 0.12], as_number(index(1)))`;
- `first(index(1))` is true for the first member.

**Arithmetic on the member itself (`1+index(1)`) does not build.** A value
leaving the submodel is an array, one value per member, as for any fixed
membership: `sum([biomass])`.

### 4.5 Associations

An association is a `single` submodel with a **role arc** to it from each
submodel taking part (section 5.4), and **a condition** saying which
pairings exist. It has one instance per pairing for which the condition is
true. Always give it a condition: without one every possible pairing
exists, and its values come out in a form that is hard to use.

**Into the association**, a value from a submodel taking part arrives
**once per role** that submodel plays, named `<label>_<role>`. The
influence runs straight from the element to the element in the
association, and its `alias` is the plain label as always; only the
equation adds the role:

```
condition owns:   owner_id_land == farmer_id_owner
```

Here `owner_id` comes from `field` (role `land`) and `farmer_id` from
`farmer` (role `owner`). In a self-association, the same value arrives
twice, once per role: `size_larger > size_smaller`.

**Out of the association**, into an element of a submodel taking part, a
value arrives as a **list** for each role that submodel plays: the values
of the pairings in which this instance plays that role, written
`{<label>_<role>}` and used through `sum`, `count` and the like:

```
income (in farmer):  sum({field_yield_owner})
rank (in individual): count({outranks_smaller})+1
```

A value is used across an association only through the element in the
association: an influence from `field` straight to `farmer` would mean
every field, not the farmer's own.

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
  default. **For now, give a fixed parameter no default if its value is to
  come from a parameter file**: a default in the model wins over the file's
  value (a fault, to be fixed). Or make it a variable parameter, which a
  file's value does replace.

Give a parameter a plain number as its `value`, and draw no influence into
it.

**A value outside its slider's range is clamped.** If a parameter has `min`
and `max`, its `value` must lie between them: `"value": "9.2e8"` with
`"max": "76000"` runs with 76000, and nothing says so. Choose a range wide
enough for every value the source uses, or leave `min` and `max` out.

### 5.4 Role

```json
"arc1": { "type": "role", "from": "submodel1", "to": "submodel3", "label": "owner", "props": {} }
```

From a submodel taking part, to the association. `label` is the role's
name, a label like any other (letters, digits, underscores), and is added
to the names of values crossing (section 4.5). An association has exactly
**two** role arcs: one from each of two submodels, or both from the same
one (a self-association). Both roles' names must differ.

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

  - out of a **conditional** submodel (section 4.2): curly brackets, a
    list, as for a population: `sum({catch})`
  - into or out of an **association**: the role is added to the name,
    `x_role`, and out of it the value is a list, `{x_role}` (section 4.5)

  The alias stays bare (`"biomass"`); only the equation has the brackets.
  Use such a value through a function that combines them (`sum`, `count`,
  `greatest`, `least`, `any`, `all`, `product`, `element`).
- Out of a **single** submodel with no condition, a value is one value,
  written plainly.
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

**A minus sign binds before `^`.** In Simile `-z^2` is `(-z)^2`, so with
`z = 3` it is 9, not −9 as in mathematics, Python or R. A paper's −z²/2
(a normal density, say) is written `-(z^2)/2` or `-0.5*z*z`.

**Functions.** The ones most often needed:

| | |
|---|---|
| Arithmetic | `abs(x)`, `exp(x)`, `log(x)` (natural), `log10(x)`, `sqrt(x)`, `pow(x,y)`, `min(x,y)`, `max(x,y)`, `floor(x)`, `ceil(x)`, `round(x)`, `int(x)`, `sgn(x)`, `fmod(x,y)`, `hypot(x,y)`, `pi()` |
| Trigonometry | `sin(x)`, `cos(x)`, `tan(x)`, `asin(x)`, `acos(x)`, `atan(x)`, `atan2(x,y)`, `sinh`, `cosh`, `tanh` (radians) |
| Time | `time()` the current time; `dt()` the time step; `prev(n)` this element's own value n steps ago; `last(x)` x's value at the previous step |
| Inputs over time | `step(height, time)`, `ramp(slope, time)`, `pulse(magnitude, first_time [, interval])` |
| Random | `rand_const(lo,hi)` uniform, drawn once (at the start, or when a member is created); `rand_var(lo,hi)` uniform, drawn every step; `gaussian_var(mean, sd)` normal, every step; `poidev(mean)`; `exprnd(mean)`; `binome(prob, n)` |
| Arrays and lists | `sum(…)`, `count(…)`, `product(…)`, `greatest(…)`, `least(…)`, `any(…)`, `all(…)`, `element([x], i)`, `makearray(x, n)`, `index(1)` |
| Delays and smoothing | `delay1(input, duration)`, `delay3(input, duration)`, `smth1(input, time)`, `smth3(input, time)` |
| Curves | `interpolate(x, [xs], [ys])` a table; `graph(x)` this element's sketched graph (section 4.3) |

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

**A flow that turns corners** — round the outside of the diagram, or
because another flow runs straight between the same two stocks — lists its
corners, in order from its source, under `layout.arcs`, keyed by the FLOW
ARC's id:

```json
"layout": {
  "arcs": { "arc3": { "points": [ {"x": 565, "y": 347}, {"x": 565, "y": 450},
                                  {"x": 131, "y": 450}, {"x": 131, "y": 345} ] } }
}
```

The flow runs straight from its source to the first corner, between the
corners, and from the last to its end; its valve sits halfway along. A flow
with no entry is straight.

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

- `startTime` (optional, 0 if absent): the time a run starts from. A
  model in calendar years that uses them in its equations (a change from
  1970, say) starts at its first year: `"startTime": 1850`, and
  `time()` is then the year.
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

**A family of models.** Models that are alternatives to one another (several
forms of an equation, several ways of building the same model) can each list
the whole set, so a reader can open the others beside it:

```json
"family": {
  "title": "Descriptive population models: thirteen forms of density dependence",
  "members": [
    { "model": "descrpop-logistic", "title": "Logistic", "summary": "…", "file": "../descrpop-logistic/descrpop-logistic.json" },
    { "model": "descrpop-ricker", "title": "Ricker", "summary": "…", "file": "../descrpop-ricker/descrpop-ricker.json" }
  ],
  "current": "descrpop-logistic"
}
```

`file` is each member's model file, relative to this model's own address
(as the model gallery lays them out, `../<model>/<model>.json`); `current`
is this model's own `model`. Simile's Metadata panel lists them, this one
marked and each other a link that opens it in the same window.

**An array of a submodel's values, at the top level** (a variable whose
equation is `[ageing_out]`, read back inside the submodel): give that
variable's `units` its size, `"array(1,5)"` for 5 instances, and write it
`[ageing]` where it is used. This is the one exception to section 11: without
it the model does not build.

## 11. Units: leave them empty

**Always write `"units": ""`.** Say what the units are in the model's
`description` instead ("time is in years; populations are numbers of
animals").

`units` is not a free-text note. It goes straight to Simile's engine as
part of the value's type, and two things go wrong there, neither shown as a
red element:

- **A name the engine does not know** (`individuals`, `animals`, `USD`)
  stops the model being built. The app says only "Simile could not make C++
  of this model", or that the C++ would not compile.
- **A unit of time** (`1/year`, `kg/day`) is converted to the engine's own
  time unit, which is not a year, so a `/year` silently divides a rate by
  365 and the model runs with the wrong values.

Empty units lose nothing: the model runs exactly as it would with them.

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
7. Equality is `==`. No `=` in an equation. Every parameter's `value` lies
   between its `min` and `max`.
8. Population symbols are only in population submodels; every population
   has a creation or an immigration. Conditions are only in single or
   fixed-membership submodels, and a value leaving a conditional submodel
   is written `{x}`. An enumerated type is declared in the model's `props`,
   and a member is compared as `index(1)=="oak"`, never added to.
   An association has a role arc from each submodel taking part, and a
   condition; a value crossing it is named `x_role`, and leaves it as
   `{x_role}`.
9. Every node except valves, and every submodel, has a `layout` entry;
   everything in a submodel is drawn inside its box, and nothing else is.
10. Every `units` is `""`.
11. `presentation` is there, with a sensible `timeStep`, and plots the
    stocks that matter.
12. A sketched graph's axes are numbers and its `points` fractions from 0
    to 1, and the element's equation reads it with `graph(x)`.

### Common mistakes

- Writing a flow's rate on the arc. The rate is the **valve's** `rate`.
- Influencing the flow arc instead of its valve.
- Forgetting the influence from a stock to its own flow's valve
  (`prey_birth_rate*prey` needs `prey → prey_births`).
- Numbers instead of strings: `"initial": 10`.
- Names with spaces, or a paper's symbols with primes or subscripts
  (`N'`, `K_{max}`): write `N_dash`, `K_max`.
- Using `=` for equality, or `if … then … else` without the `then`.
- Anything in `units`, such as `individuals` or `1/year` (section 11).

## 13. Checking a model

**Checking against a paper's results.** `tools/check_models.py` (it starts
what it needs) runs a model with a parameter file and writes its values over
the run as CSV, and `tools/compare_series.py` compares them with the
authors' results, value by value:

```
python3 tools/check_models.py coral.json --parameters coral-SEA-RCP85.parameters.json \
    --csv results --vars Coral,Trait,Symbiont
python3 tools/compare_series.py results/coral.csv theirs.csv \
    --map Coral=CORAL,Trait=TRAIT,Symbiont=SYMB --offset -24012
```

`--offset` is added to their times to give the model's, where the two count
from different origins. It prints the values side by side at a dozen times,
then for each quantity its largest difference over every shared time. A
model with random numbers cannot agree value for value: compare the
quantities the randomness does not dominate, and several runs' range. The
worked example, its commands and results: `examples/papers/coral/README.md`.

In the app, a model that is not complete shows its incomplete elements in
**red**, and the Simulation panel's status line says how many there are.
Click on one to see what is wrong. A complete model runs when you press ▶.

For developers, `tools/headless/scripts/model-file.py` takes model spec
files and applies the app's own checks: it reads the file as File ▸ Open
does, reports each incomplete element and grammar breach, exports it to
Simile's own format, compiles it, runs it with the file's run settings and
prints the values at the end of the run. If the model cannot be built, it
names the elements that have `units`, the usual cause. It also names any
parameter whose value lies outside its slider's range.

It needs:

- the repository cloned **with its submodule**: `git clone
  --recurse-submodules …`, or `git submodule update --init` afterwards.
  Without it, `sienna/` is empty and the app does not load, so every file
  fails with "no answer";
- the app served over http: `python3 tools/serve.py`;
- Chrome running headless, started as in `tools/headless/README.md`;
- Python's `websockets` package.

Then, from the repository root:

```
MODEL_FILES="my-model.json" python3 tools/headless/cdp.py tools/headless/scripts/model-file.py
```

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
    "node1": { "type": "stock",    "parent": "submodel1", "label": "biomass",     "props": { "initial": "1", "units": "" } },
    "node2": { "type": "cloud",    "parent": "submodel1", "label": "",            "props": {} },
    "node3": { "type": "valve",    "parent": "submodel1", "label": "growth",      "props": { "rate": "growth_rate*biomass*(1-biomass/max_biomass)", "units": "" } },
    "node4": { "type": "variable", "parent": "submodel1", "label": "growth_rate", "props": { "value": "base_rate*(0.5+0.25*index(1))", "units": "" } },

    "node5": { "type": "variable", "parent": null, "label": "base_rate",   "props": { "paramKind": "variable", "value": "0.1", "units": "", "min": "0.02", "max": "0.3" } },
    "node6": { "type": "variable", "parent": null, "label": "max_biomass", "props": { "paramKind": "fixed",    "value": "50",  "units": "" } },
    "node7": { "type": "variable", "parent": null, "label": "total",       "props": { "value": "sum([biomass])", "units": "" } }
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
    "node1":  { "type": "stock",        "parent": "submodel1", "label": "size",        "props": { "initial": "3", "units": "" } },
    "node2":  { "type": "cloud",        "parent": "submodel1", "label": "",            "props": {} },
    "node3":  { "type": "valve",        "parent": "submodel1", "label": "growth",      "props": { "rate": "growth_rate*(1-size/25)", "units": "" } },
    "node4":  { "type": "variable",     "parent": "submodel1", "label": "growth_rate", "props": { "value": "rand_const(0.1,0.3)", "units": "" } },
    "node5":  { "type": "initialiser",  "parent": "submodel1", "label": "initial",     "props": { "expr": "5" } },
    "node6":  { "type": "migrator",     "parent": "submodel1", "label": "recruitment", "props": { "expr": "recruits_per_year" } },
    "node7":  { "type": "exterminator", "parent": "submodel1", "label": "death",       "props": { "expr": "size>17" } },
    "node9":  { "type": "variable",     "parent": "submodel1", "label": "x",           "props": { "value": "rand_const(0,100)", "units": "" } },
    "node10": { "type": "variable",     "parent": "submodel1", "label": "y",           "props": { "value": "rand_const(0,100)", "units": "" } },

    "node8":  { "type": "variable", "parent": null, "label": "number_of_trees",   "props": { "value": "count({size})", "units": "" } },
    "node11": { "type": "variable", "parent": null, "label": "total_size",        "props": { "value": "sum({size})", "units": "" } },
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

### 14.4 A fishery: a conditional submodel

A fish stock grows logistically. While it is above `closure_level`, the
`fishing` submodel exists and `catch` takes `effort` of the stock a year;
below it, the fishery is closed. The `harvest` flow, outside, takes
`sum({catch})`: the catch while open, 0 while closed. The stock is fished
down to the closure level and held there.

<!-- example: examples/models/fishery.json -->

```json
{
  "id": "fishery",
  "name": "Fishery",
  "format": 3,
  "schema": "simile-v1",
  "metadata": {
    "title": "A fishery closed below a threshold",
    "description": "A fish stock grows logistically and is fished in proportion to its size, but only while it is above a closure level: fishing is a conditional submodel, which exists only while its condition is true. Time is in years. A worked example for the model file reference.",
    "keywords": ["fishery", "harvesting", "conditional submodel"]
  },
  "presentation": {
    "run": { "runLength": 50, "logEach": 0.25, "timeStep": "0.05" },
    "displays": [
      { "widget": "plotter", "variables": ["node1"] },
      { "widget": "plotter", "variables": ["node5"] },
      { "widget": "sliders" }
    ]
  },
  "enums": {},
  "submodels": {
    "submodel1": {
      "kind": "single",
      "parent": null,
      "label": "fishing",
      "props": {}
    }
  },
  "nodes": {
    "node1":  { "type": "stock", "parent": null, "label": "fish", "props": { "initial": "800", "units": "" } },
    "node2":  { "type": "cloud", "parent": null, "label": "", "props": {} },
    "node3":  { "type": "valve", "parent": null, "label": "births",  "props": { "rate": "growth_rate*fish*(1-fish/capacity)", "units": "" } },
    "node4":  { "type": "cloud", "parent": null, "label": "", "props": {} },
    "node5":  { "type": "valve", "parent": null, "label": "harvest", "props": { "rate": "sum({catch})", "units": "" } },

    "node6":  { "type": "variable", "parent": null, "label": "growth_rate",   "props": { "paramKind": "variable", "value": "0.5", "units": "", "min": "0.1", "max": "1" } },
    "node7":  { "type": "variable", "parent": null, "label": "capacity",      "props": { "paramKind": "fixed",    "value": "1000", "units": "" } },
    "node8":  { "type": "variable", "parent": null, "label": "closure_level", "props": { "paramKind": "variable", "value": "500", "units": "", "min": "0", "max": "800" } },
    "node9":  { "type": "variable", "parent": null, "label": "effort",        "props": { "paramKind": "variable", "value": "0.3", "units": "", "min": "0", "max": "1" } },

    "node10": { "type": "condition", "parent": "submodel1", "label": "open",  "props": { "expr": "fish>closure_level" } },
    "node11": { "type": "variable",  "parent": "submodel1", "label": "catch", "props": { "value": "effort*fish", "units": "" } }
  },
  "arcs": {
    "arc1":  { "type": "flow", "from": "node2", "to": "node1", "valve": "node3", "props": {} },
    "arc2":  { "type": "flow", "from": "node1", "to": "node4", "valve": "node5", "props": {} },

    "arc3":  { "type": "influence", "from": "node1",  "to": "node3",  "alias": "fish",          "props": {} },
    "arc4":  { "type": "influence", "from": "node6",  "to": "node3",  "alias": "growth_rate",   "props": {} },
    "arc5":  { "type": "influence", "from": "node7",  "to": "node3",  "alias": "capacity",      "props": {} },
    "arc6":  { "type": "influence", "from": "node1",  "to": "node10", "alias": "fish",          "props": {} },
    "arc7":  { "type": "influence", "from": "node8",  "to": "node10", "alias": "closure_level", "props": {} },
    "arc8":  { "type": "influence", "from": "node1",  "to": "node11", "alias": "fish",          "props": {} },
    "arc9":  { "type": "influence", "from": "node9",  "to": "node11", "alias": "effort",        "props": {} },
    "arc10": { "type": "influence", "from": "node11", "to": "node5",  "alias": "catch",         "props": {} }
  },
  "layout": {
    "node1":  { "x": 250, "y": 110 },
    "node2":  { "x": 110, "y": 110 },
    "node4":  { "x": 430, "y": 110 },
    "node6":  { "x": 130, "y": 40 },
    "node7":  { "x": 230, "y": 40 },
    "node8":  { "x": 200, "y": 250 },
    "node9":  { "x": 560, "y": 290 },
    "submodel1": { "x": 400, "y": 270, "w": 220, "h": 120 },
    "node10": { "x": 350, "y": 250 },
    "node11": { "x": 450, "y": 290 }
  }
}
```

### 14.5 A reservoir: a sketched graph

Rain follows a seasonal curve, drawn as a graph of rainfall against the
month (`fmod(time(),12)`, time in months). Written from a table instead,
`rainfall` would be `interpolate(month, [0,3,6,9,12], [160,80,10,90,160])`
with no `graph`.

<!-- example: examples/models/reservoir.json -->

```json
{
  "id": "reservoir",
  "name": "Reservoir",
  "format": 3,
  "schema": "simile-v1",
  "metadata": {
    "title": "A reservoir fed by seasonal rain",
    "description": "A reservoir filled by rain that follows a seasonal curve, drawn as a sketched graph of rainfall against the month, and emptied by a release in proportion to what it holds. Time is in months. A worked example for the model file reference.",
    "keywords": ["water", "seasonal", "sketched graph"]
  },
  "presentation": {
    "run": { "runLength": 48, "logEach": 0.25, "timeStep": "0.05" },
    "displays": [
      { "widget": "plotter", "variables": ["node1"] },
      { "widget": "plotter", "variables": ["node6"] },
      { "widget": "sliders" }
    ]
  },
  "enums": {},
  "submodels": {},
  "nodes": {
    "node1": { "type": "stock", "parent": null, "label": "water", "props": { "initial": "200", "units": "" } },
    "node2": { "type": "cloud", "parent": null, "label": "", "props": {} },
    "node3": { "type": "valve", "parent": null, "label": "inflow",  "props": { "rate": "rainfall*catchment", "units": "" } },
    "node4": { "type": "cloud", "parent": null, "label": "", "props": {} },
    "node5": { "type": "valve", "parent": null, "label": "release", "props": { "rate": "release_fraction*water", "units": "" } },

    "node6": { "type": "variable", "parent": null, "label": "rainfall", "props": {
      "value": "graph(month)", "units": "",
      "graph": {
        "xmin": 0, "xmax": 12, "ymin": 0, "ymax": 200,
        "points": [0.8, 0.7, 0.55, 0.4, 0.25, 0.1, 0.05, 0.1, 0.25, 0.45, 0.65, 0.75, 0.8],
        "outside": "truncate", "between": "interpolate"
      } } },
    "node7": { "type": "variable", "parent": null, "label": "month",            "props": { "value": "fmod(time(),12)", "units": "" } },
    "node8": { "type": "variable", "parent": null, "label": "catchment",        "props": { "paramKind": "fixed",    "value": "0.5", "units": "" } },
    "node9": { "type": "variable", "parent": null, "label": "release_fraction", "props": { "paramKind": "variable", "value": "0.2", "units": "", "min": "0", "max": "0.5" } }
  },
  "arcs": {
    "arc1": { "type": "flow", "from": "node2", "to": "node1", "valve": "node3", "props": {} },
    "arc2": { "type": "flow", "from": "node1", "to": "node4", "valve": "node5", "props": {} },

    "arc3": { "type": "influence", "from": "node6", "to": "node3", "alias": "rainfall",         "props": {} },
    "arc4": { "type": "influence", "from": "node8", "to": "node3", "alias": "catchment",        "props": {} },
    "arc5": { "type": "influence", "from": "node7", "to": "node6", "alias": "month",            "props": {} },
    "arc6": { "type": "influence", "from": "node1", "to": "node5", "alias": "water",            "props": {} },
    "arc7": { "type": "influence", "from": "node9", "to": "node5", "alias": "release_fraction", "props": {} }
  },
  "layout": {
    "node1": { "x": 260, "y": 120 },
    "node2": { "x": 120, "y": 120 },
    "node4": { "x": 400, "y": 120 },
    "node6": { "x": 150, "y": 50 },
    "node7": { "x": 60,  "y": 50 },
    "node8": { "x": 240, "y": 50 },
    "node9": { "x": 360, "y": 190 }
  }
}
```

### 14.6 Three tree species: an enumerated type

The type `species` is declared for the whole model, and the `stand`
submodel has one instance for each species. Each grows at its own rate,
chosen by comparing `index(1)` with a member, and `total`, at the top
level, sums the three.

<!-- example: examples/models/species.json -->

```json
{
  "id": "species",
  "name": "Species",
  "format": 3,
  "schema": "simile-v1",
  "metadata": {
    "title": "Three tree species",
    "description": "The biomass of three tree species, oak, beech and pine, each growing logistically at its own rate towards a shared maximum, and their total. The species are an enumerated type, declared for the whole model, and the submodel has one instance per member. Time is in years. A worked example for the model file reference.",
    "keywords": ["enumerated type", "fixed membership", "array"]
  },
  "props": { "enumTypes": "species: oak, beech, pine" },
  "presentation": {
    "run": { "runLength": 100, "logEach": 1, "timeStep": "0.5" },
    "displays": [
      { "widget": "plotter", "variables": ["node1"] },
      { "widget": "plotter", "variables": ["node6"] }
    ]
  },
  "enums": {},
  "submodels": {
    "submodel1": {
      "kind": "fixed-membership",
      "parent": null,
      "label": "stand",
      "props": { "dimensions": "species" }
    }
  },
  "nodes": {
    "node1": { "type": "stock",    "parent": "submodel1", "label": "biomass",     "props": { "initial": "5", "units": "" } },
    "node2": { "type": "cloud",    "parent": "submodel1", "label": "",            "props": {} },
    "node3": { "type": "valve",    "parent": "submodel1", "label": "growth",      "props": { "rate": "growth_rate*biomass*(1-biomass/max_biomass)", "units": "" } },
    "node4": { "type": "variable", "parent": "submodel1", "label": "growth_rate", "props": { "value": "if index(1)==\"oak\" then 0.05 elseif index(1)==\"beech\" then 0.08 else 0.12", "units": "" } },

    "node5": { "type": "variable", "parent": null, "label": "max_biomass", "props": { "paramKind": "variable", "value": "300", "units": "", "min": "100", "max": "500" } },
    "node6": { "type": "variable", "parent": null, "label": "total",       "props": { "value": "sum([biomass])", "units": "" } }
  },
  "arcs": {
    "arc1": { "type": "flow",      "from": "node2", "to": "node1", "valve": "node3", "props": {} },
    "arc2": { "type": "influence", "from": "node1", "to": "node3", "alias": "biomass",     "props": {} },
    "arc3": { "type": "influence", "from": "node4", "to": "node3", "alias": "growth_rate", "props": {} },
    "arc4": { "type": "influence", "from": "node5", "to": "node3", "alias": "max_biomass", "props": {} },
    "arc5": { "type": "influence", "from": "node1", "to": "node6", "alias": "biomass",     "props": {} }
  },
  "layout": {
    "submodel1": { "x": 300, "y": 180, "w": 260, "h": 160 },
    "node1": { "x": 380, "y": 210 },
    "node2": { "x": 210, "y": 210 },
    "node4": { "x": 260, "y": 140 },
    "node5": { "x": 90,  "y": 210 },
    "node6": { "x": 510, "y": 180 }
  }
}
```

### 14.7 Farmers and fields: an association between two submodels

Three farmers and six fields. `ownership` has a role from each, `owner`
and `land`, and its condition `owner_id_land==farmer_id_owner` makes one
pairing for each field with the farmer who owns it. Each field's yield
comes into the association as `yield_land`; it goes out to its owner's
`income` as `sum({field_yield_owner})`.

<!-- example: examples/models/farmers.json -->

```json
{
  "id": "farmers",
  "name": "Farmers and fields",
  "format": 3,
  "schema": "simile-v1",
  "metadata": {
    "title": "Farmers and the fields they own",
    "description": "Three farmers and six fields. Which farmer owns which field is an association, ownership, with a role from each: a pairing exists where the field's owner_id is the farmer's id. Each field yields in proportion to its area, and each farmer's wealth grows by the yield of the fields they own, less what they spend. Time is in years. A worked example for the model file reference.",
    "keywords": ["association", "ownership", "fixed membership"]
  },
  "presentation": {
    "run": { "runLength": 20, "logEach": 1, "timeStep": "0.1" },
    "displays": [
      { "widget": "plotter", "variables": ["node1"] },
      { "widget": "sliders" }
    ]
  },
  "enums": {},
  "submodels": {
    "submodel1": { "kind": "fixed-membership", "parent": null, "label": "farmer",    "props": { "dimensions": "3" } },
    "submodel2": { "kind": "fixed-membership", "parent": null, "label": "field",     "props": { "dimensions": "6" } },
    "submodel3": { "kind": "single",           "parent": null, "label": "ownership", "props": {} }
  },
  "nodes": {
    "node1":  { "type": "stock",    "parent": "submodel1", "label": "wealth",    "props": { "initial": "100", "units": "" } },
    "node2":  { "type": "cloud",    "parent": "submodel1", "label": "",          "props": {} },
    "node3":  { "type": "valve",    "parent": "submodel1", "label": "income",    "props": { "rate": "sum({field_yield_owner})", "units": "" } },
    "node4":  { "type": "cloud",    "parent": "submodel1", "label": "",          "props": {} },
    "node5":  { "type": "valve",    "parent": "submodel1", "label": "spending",  "props": { "rate": "spending_rate*wealth", "units": "" } },
    "node6":  { "type": "variable", "parent": "submodel1", "label": "farmer_id", "props": { "value": "index(1)", "units": "" } },

    "node7":  { "type": "variable", "parent": "submodel2", "label": "owner_id",  "props": { "value": "ceil(index(1)/2)", "units": "" } },
    "node8":  { "type": "variable", "parent": "submodel2", "label": "area",      "props": { "value": "index(1)", "units": "" } },
    "node9":  { "type": "variable", "parent": "submodel2", "label": "yield",     "props": { "value": "yield_per_area*area", "units": "" } },

    "node10": { "type": "condition", "parent": "submodel3", "label": "owns",        "props": { "expr": "owner_id_land==farmer_id_owner" } },
    "node11": { "type": "variable",  "parent": "submodel3", "label": "field_yield", "props": { "value": "yield_land", "units": "" } },

    "node12": { "type": "variable", "parent": null, "label": "yield_per_area", "props": { "paramKind": "variable", "value": "5",   "units": "", "min": "0", "max": "10" } },
    "node13": { "type": "variable", "parent": null, "label": "spending_rate",  "props": { "paramKind": "variable", "value": "0.2", "units": "", "min": "0", "max": "0.5" } }
  },
  "arcs": {
    "arc1":  { "type": "role", "from": "submodel1", "to": "submodel3", "label": "owner", "props": {} },
    "arc2":  { "type": "role", "from": "submodel2", "to": "submodel3", "label": "land",  "props": {} },

    "arc3":  { "type": "flow", "from": "node2", "to": "node1", "valve": "node3", "props": {} },
    "arc4":  { "type": "flow", "from": "node1", "to": "node4", "valve": "node5", "props": {} },

    "arc5":  { "type": "influence", "from": "node1",  "to": "node5",  "alias": "wealth",         "props": {} },
    "arc6":  { "type": "influence", "from": "node13", "to": "node5",  "alias": "spending_rate",  "props": {} },
    "arc7":  { "type": "influence", "from": "node8",  "to": "node9",  "alias": "area",           "props": {} },
    "arc8":  { "type": "influence", "from": "node12", "to": "node9",  "alias": "yield_per_area", "props": {} },
    "arc9":  { "type": "influence", "from": "node6",  "to": "node10", "alias": "farmer_id",      "props": {} },
    "arc10": { "type": "influence", "from": "node7",  "to": "node10", "alias": "owner_id",       "props": {} },
    "arc11": { "type": "influence", "from": "node9",  "to": "node11", "alias": "yield",          "props": {} },
    "arc12": { "type": "influence", "from": "node11", "to": "node3",  "alias": "field_yield",    "props": {} }
  },
  "layout": {
    "submodel1": { "x": 170, "y": 150, "w": 280, "h": 170 },
    "submodel2": { "x": 560, "y": 150, "w": 220, "h": 170 },
    "submodel3": { "x": 360, "y": 380, "w": 220, "h": 120 },
    "node1":  { "x": 170, "y": 170 },
    "node2":  { "x": 70,  "y": 170 },
    "node4":  { "x": 270, "y": 170 },
    "node6":  { "x": 90,  "y": 105 },
    "node7":  { "x": 500, "y": 110 },
    "node8":  { "x": 590, "y": 110 },
    "node9":  { "x": 590, "y": 190 },
    "node10": { "x": 310, "y": 370 },
    "node11": { "x": 410, "y": 400 },
    "node12": { "x": 720, "y": 190 },
    "node13": { "x": 220, "y": 30 }
  }
}
```

### 14.8 Ranking: a self-association

Ten individuals ranked by size. `ranking` has two roles from `individual`,
`larger` and `smaller`; a pairing exists where `size_larger>size_smaller`.
An individual's rank is one more than the number of pairings in which it
is the smaller: `count({outranks_smaller})+1`. After Simile's own
`ranking1`.

<!-- example: examples/models/ranking.json -->

```json
{
  "id": "ranking",
  "name": "Ranking",
  "format": 3,
  "schema": "simile-v1",
  "metadata": {
    "title": "Ranking the members of a population",
    "description": "Ten individuals, each with a random size, ranked by it: 1 for the largest. Comparing members with each other is a self-association, ranking, with two roles from the same submodel, larger and smaller; a pairing exists where the larger one's size is greater. An individual's rank is one more than the number of pairings in which it is the smaller. After Simile's ranking1. A worked example for the model file reference.",
    "keywords": ["association", "self-association", "population"]
  },
  "presentation": {
    "run": { "runLength": 1, "logEach": 1, "timeStep": "1" },
    "displays": [
      { "widget": "plotter", "variables": ["node2"] }
    ]
  },
  "enums": {},
  "submodels": {
    "submodel1": { "kind": "population", "parent": null, "label": "individual", "props": {} },
    "submodel2": { "kind": "single",     "parent": null, "label": "ranking",    "props": {} }
  },
  "nodes": {
    "node1": { "type": "variable",    "parent": "submodel1", "label": "size",    "props": { "value": "rand_const(0,100)", "units": "" } },
    "node2": { "type": "variable",    "parent": "submodel1", "label": "rank",    "props": { "value": "count({outranks_smaller})+1", "units": "" } },
    "node3": { "type": "initialiser", "parent": "submodel1", "label": "initial", "props": { "expr": "10" } },

    "node4": { "type": "condition",   "parent": "submodel2", "label": "is_larger", "props": { "expr": "size_larger>size_smaller" } },
    "node5": { "type": "variable",    "parent": "submodel2", "label": "outranks",  "props": { "value": "1", "units": "" } }
  },
  "arcs": {
    "arc1": { "type": "role", "from": "submodel1", "to": "submodel2", "label": "larger",  "props": {} },
    "arc2": { "type": "role", "from": "submodel1", "to": "submodel2", "label": "smaller", "props": {} },

    "arc3": { "type": "influence", "from": "node1", "to": "node4", "alias": "size",     "props": {} },
    "arc4": { "type": "influence", "from": "node5", "to": "node2", "alias": "outranks", "props": {} }
  },
  "layout": {
    "submodel1": { "x": 160, "y": 160, "w": 220, "h": 180 },
    "submodel2": { "x": 470, "y": 160, "w": 180, "h": 140 },
    "node1": { "x": 140, "y": 130 },
    "node2": { "x": 140, "y": 200 },
    "node3": { "x": 90,  "y": 95 },
    "node4": { "x": 440, "y": 140 },
    "node5": { "x": 500, "y": 190 }
  }
}
```
