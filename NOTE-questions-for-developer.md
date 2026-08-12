# Questions for the Simile developer — drafted as issues

**2026-08-12.** A first batch, in priority order. Each is written to be answerable
in minutes rather than hours.

*Why so few.* An earlier draft of this note had eleven questions. Then the 72
`.pl` files of the model catalogue arrived on disk, and **four of them answered
themselves** — including most of the one we had called the blocker. They are kept
below, marked ANSWERED, with what the corpus says, because a derived rule wants
confirming and because the derivation is the evidence for it.

This is the pattern worth noting: the hardest question in
`NOTE-export-to-simile.md` — §4's dimensional term, "the one thing we cannot
resolve ourselves" — was settled by reading two files. Segmentation (`links`,
`border` nodes, which segment carries the role) came the same way. Now
associations have too. **Models transfer this knowledge better than prose**, and
they double as regression fixtures we keep.

So where a belief is stated below, **it is offered to be broken.** "Is this
right?" is a thirty-second answer; "how do associations work?" is an essay nobody
writes.

*Context.* We have built a schema-driven diagram editor that converts its models
to Simile Prolog, uploads them to SimiLive and runs them, with results drawn in
our own panels. A flat model and a five-instance submodel both agree with Euler
to thirteen figures.

---

# Answered by the corpus — please confirm or correct

## A0 — The catalogue *(withdrawn)*

We have it: 72 `.pl` files. Nothing needed.

## A1 — Associations and `relation` arcs *(was the blocker)*

`ranking1.pl` is a complete minimal example and appears to settle it. What we
now believe:

- An association is an ordinary submodel that is the **target** of `relation`
  arcs — `arc(Id, BaseSubmodel, AssocSubmodel, relation, [complete=true,
  name=RoleName])`. In 49 of the corpus's 60 relation arcs the association end
  is `count=[]`; its membership comes from the relation and its `condition`.
- **`references(S, [local(arcId), …])` lists the relation arcs a submodel takes
  part in**, and appears on both ends.
- **The role index in `use(N, …)` is the position in that `references` list.**
  `landuse1b` proves it: its list is `[obsolete,obsolete,local(arc00018),local(arc00019)]`
  and the roles use indices **2 and 3**, not 0 and 1.
- `in_base` is a reference crossing from the base **into** the association — one
  `use(…)` per role, scalar per end:
  `role=[use(0,in_base,attribute_role1,1),use(1,in_base,attribute_role2,1)]`
  beside an equation `(attribute_role1>attribute_role2)`.
- `in_assoc` is the reference coming back **out** to the base — one per role, and
  a list, since many association instances meet one base instance:
  `role=[use(0,in_assoc,{one_role1},list(int)),use(1,in_assoc,{one_role2},list(int))]`
  beside `count({one_role2})+1`.
- Alias naming differs between versions (`attribute_role1` in a 2008 file,
  `crop_neighbour` / `crop_neighbour_0` in a 2003 one). We do not need to
  reproduce it — the alias is whatever our equation says — but it suggests we
  should not depend on any convention.

**Questions that remain.** (a) Is "index = position in `references`" right, and
is that position **stable**, or an allocation order we must not rely on? (b) What
are the `obsolete` and `ancestor(0)` entries we see in some `references` lists —
must we ever emit them? (c) Anything different about a self-association (both
relation arcs from the same base, as in `ranking1`) that we would not see there?

## A2 — The population symbols *(answered)*

The corpus census settles the spellings. Ours → Simile's:

| ours | Simile | seen as |
|---|---|---|
| initialiser | `creation` | "initial number", "initial pop size" |
| exterminator | `loss` | "death", "tanks destroyed" |
| migrator | `immigration` | "new tanks constructed" |
| reproduction | `reproduction` | "birth" |

**Confirm the middle two**, which are the ones we are inferring from names rather
than from anything structural.

**And one we do not have at all: `alarm`** (3 in the corpus — "done checks",
"found prime"). What is it, and does the diagram editor need it?

## A3 — `references(…)` *(answered — see A1)*

It lists relation arcs. The remaining part is `obsolete` / `ancestor(0)`, asked
in A1(b).

## A4 — `border` *(answered)*

448 in the corpus, so it is the current spelling for a boundary stub and our
choice was right. Older files use a plain `variable` in the same position — we
assume that is legacy and emit `border`. **Correct?**

---

# Still open

## 0 — A robustness report, not a question

`value=a>b` is not legal Prolog — `=` and `>` are both `xfx` priority 700, so the
right argument of `=` may not itself be a 700 operator. It needs
`value=(a>b)`, which is what Simile itself writes.

**When we emitted the unparenthesised form, Simile did not complain.** It
dropped the property, and the component disappeared from the model: a
membership condition stopped filtering, an association returned every pair, and
a ranking model answered 5,5,5,5 where it should have answered 4,3,2,1. It
compiled, ran, and produced confident wrong numbers.

Our bug, and fixed. But **a warning on a property that failed to parse would
have saved an afternoon**, and would presumably help anyone else generating
`.pl` files.

## 1 — `usr(…)` in a role term

Both forms appear in **the same file** (`fire_rect.sml`):

```prolog
role=[use(none,in_hierarchy,usr(nbr_lit),boolean)]
role=[use(none,in_hierarchy,fuel,1)]
```

We guess `usr(x)` marks an alias the modeller typed against one Simile
defaulted. We emit bare aliases throughout. **Decorative, or does the engine
treat the two differently?**

## 2 — `use_sofar` and `enabled_roles`

```prolog
arc(arc00013,…,role=[…],use_sofar=0],…)
arc(arc00010,…,enabled_roles=[-2],…,role=[use(-2,in_8_nbrs,{from_8_nbrs_lit},list(boolean)),…],use_sofar=0],…)
```

We omit both and our models run. **Optional in general, or only for the cases we
happen to have tested?** And is `in_8_nbrs` with its negative index one of a
fixed set of built-in spatial relations — if so, what is the set?

## 3 — Is our minimal `.sml` a supported input?

We depend on this and found it by experiment, which is an uncomfortable place to
be. Posting raw Prolog fails — the build dies in `file join $mimedir *.so`. A
`.sml` whose only part is the model fails identically. Adding a second part, 27
bytes of "Simile package description" (`modelRunning 1 running_c 1`), makes it
build and run. Everything else a real `.sml` carries — Tcl canvas, helper and
parameter XML, generated C++, a compiled ELF — appears optional.

**Is a two-part file legitimate and stable, or are we exploiting something
incidental?**

## 4 — The dimensional rule: confirm or break it

For a containment crossing we believe: **inward** references are scalars;
**outward** are lists whose alias carries brackets the consumer's equation uses
verbatim (`{volume}` beside `sum({volume})`); **curly** for variable membership,
**square** for fixed, one bracket level per dimension (`fire_rect` crosses a
200×300 grid and writes `any(any([[lit]]))`); and a **conditional** submodel
counts as multi-instance even at `count=[]`.

**Is "multi-instance or conditional ⇒ outward is a list" complete, or are there
cases where an outward reference stays scalar?**

## 5 — `multiplication_spec` kinds we do not have

The corpus shows `count=[N]`, `type=population`, and two we cannot make:

- **`type=records`** — data-specified membership.
- **`count=[size(Patch)]`** — a count that is an expression over another
  submodel.

Our editor offers single / fixed-membership / population. **Is that the complete
set of kinds, with records a variant of one of them, or a fourth thing?**

## 6 — `spec=`, and the values we do not hold

Function nodes carry the user's typed text as character codes beside the parsed
value (`spec=[114,97,…]` next to `value=rand_const(0,100)`). We emit `value` and
omit `spec`, `min_val`, `max_val`, `fill_colour`; models run. **Is anything there
load-bearing, or is it all round-tripping for the editor's benefit?**

## 7 — `course=[…]`: arcs have waypoints?

Arcs carry `course=[[22,…],[…]]` — a list of points. We have curvature but no
waypoints, and had them down as a possible future feature. **Are they purely
visual?** If Simile has had them all along, that settles a design question for us
rather than leaving it to taste (`DESIGN-diagram.md` §7.5).

## 8 — Which Prolog, and how separable is the C++ back end?

Architecture rather than a model; set out at length in
`NOTE-export-to-simile.md` §6. Since the generator is itself Prolog, a
**JavaScript back end** would put the whole pipeline in the browser with no
compiler and no server. Two things decide whether that is realistic: how
separable the emitter is from an internal representation, and **how large the
runtime library the generated code links against** is — we suspect the latter,
not the code emission, is the real work.

A cheap experiment settles the first half: load the generator into SWI-Prolog and
see how far it gets. Dialect distance is usually obvious within an hour.

---

## What we can offer back

Not a one-way ask:

- **An equation-grammar conformance corpus.** 1500 equations harvested from the
  reference models against our PEG of the Simile expression language; 1488
  parse, the exclusions being comma-as-`and` and a few similar spellings we chose
  to drop. Runnable as a page.
- **A completeness checker that found a real inconsistency in a shipped model** —
  `landuse`'s `check_spark` refers to `spark_` while the element is labelled
  `spark?`.
- **An independent test of Simile's own loader.** Our exporter produces Prolog
  from a different program; it has already been caught by your consistency check
  on a genuine modelling error, with a better message than we would have written.
