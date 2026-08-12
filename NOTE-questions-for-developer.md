# Questions for the Simile developer — drafted as issues

**2026-08-12.** A first batch, in priority order. Each is written to be answerable
in minutes rather than hours, because each asks for **one small model** rather
than an explanation.

*Why models rather than prose.* The single hardest question in
`NOTE-export-to-simile.md` — §4's dimensional term, called "the one thing we
cannot resolve ourselves" — was answered on 2026-08-12 by reading two `.sml`
files and nothing else. The rule fell straight out of `landuse1b.pl` and
`fire_rect.sml`. Segmentation (`links`, `border` nodes, which segment carries the
role) came the same way. So a two-minute model exercising one feature transfers
more, and more reliably, than twenty minutes of writing — and it doubles as a
regression fixture we keep forever.

Where we state a belief, **it is offered to be broken.** "Is this complete?" is a
thirty-second answer; "how do dimensions work?" is an essay nobody writes.

Context: we have built a schema-driven diagram editor that now converts its
models to Simile Prolog, uploads them to SimiLive and runs them, with results
drawn in our own panels. `growth` and a five-instance submodel both agree with
Euler to thirteen figures. What stops us handling *production* models is a short
list of features we can see in saved files but cannot safely reproduce.

---

## 0 — The catalogue, in bulk *(no design work at all)*

**What we need.** A zip of the model catalogue's `.sml` files, or the URL pattern
to fetch them.

**Why.** The catalogue is indexed by feature keyword — "Association submodel",
"Age-class modelling", "Disaggregated population" — which is already the
conformance suite we would otherwise ask you to build. Individual files are not
at guessable URLs (the path in `landuse1b.pl`'s own `file_name` 404s) and there
is a login wall.

**This may answer half the list below before you write a word**, so it is first.

---

## 1 — Association submodels and role arcs *(the blocker)*

**What we need.** Two minimal models: one association between two different
submodels, and one association of a submodel with itself (neighbours).

**Why.** This is the single thing standing between us and the reference models.
We refuse role arcs rather than guess.

**What we believe, from `landuse1b.pl` and `fire_rect.sml`.** A role term can
hold several `use(…)`, and the first argument is a role INDEX rather than the
`none` we see for containment:

```prolog
role=[use(0,in_base,state,1),use(1,in_base,state_0,1)]
role=[use(2,in_assoc,{crop_neighbour},list(1)),use(3,in_assoc,{crop_neighbour_0},list(1))]
role=[use(-2,in_8_nbrs,{from_8_nbrs_lit},list(boolean)),use(none,in_hierarchy,lit,boolean)]
```

So we guess: `0`/`1` are the two ends of the base submodel, `2`/`3` the
association's own two roles, the `_0` suffix distinguishes the second end, and
negative indices are built-in spatial relations (`in_8_nbrs`). **Is any of that
right?** In particular: what fixes the numbering, and is it stable, or an
allocation order we must not depend on?

**The models that would settle it.** (a) Two submodels A and B, an association
between them, one variable in the association reading a value from each end. (b)
A grid submodel with an 8-neighbour relation, one variable reading a neighbour's
value — the `fire_rect` pattern, but minimal.

---

## 2 — `usr(…)` in a role term

**What we need.** One sentence, or a model where the same alias appears both
ways.

**Why.** We emit bare aliases. If `usr(…)` is load-bearing we are producing
subtly different models.

**Evidence.** Both forms appear in *the same file* (`fire_rect.sml`):

```prolog
role=[use(none,in_hierarchy,usr(nbr_lit),boolean)]
role=[use(none,in_hierarchy,fuel,1)]
```

**What we believe.** `usr(x)` marks an alias the modeller typed, against one
Simile defaulted. **Is it decorative, or does the engine treat the two
differently?**

---

## 3 — `use_sofar` and `enabled_roles`

**What we need.** What they mean and when they must be written.

**Evidence.** `fire_rect.sml`:

```prolog
arc(arc00013,…,role=[use(none,in_hierarchy,usr(nbr_lit),boolean)],use_sofar=0],…)
arc(arc00010,…,enabled_roles=[-2],name=i8,role=[use(-2,in_8_nbrs,…),use(none,in_hierarchy,…)],use_sofar=0],…)
```

We omit both and our models run. **Are they optional in general, or only for the
cases we have happened to test?**

---

## 4 — The four population symbols: what are they called in the file?

**What we need.** One model containing an initialiser, a migrator, an
exterminator and a reproduction symbol.

**Why.** Our palette has all four; the file format we have seen has `loss` and
`immigration`. Two of ours are probably those two, but guessing WHICH would
produce a model that loads and quietly means something else — so we refuse all
four by name.

**Evidence.** `forest.sml` has `node(node00009,loss,…)` named "Chance of Death"
and `node(node00011,immigration,…)` named "Saplings".

---

## 5 — Is our minimal `.sml` a supported input?

**What we need.** Confirmation, or a correction.

**Why.** We depend on this, and we found it by experiment rather than from
documentation, which is an uncomfortable place to be.

**What we found.** Posting raw Prolog fails — the build dies in
`file join $mimedir *.so`. A `.sml` whose only part is the model fails
identically. Adding a second part, 27 bytes of "Simile package description"
(`modelRunning 1 running_c 1`), makes it build and run. Everything else a real
`.sml` carries — Tcl canvas, helper and parameter XML, generated C++, a compiled
ELF — appears to be optional.

**Is a two-part file a legitimate input we can rely on, or are we exploiting
something incidental that might change?** And is there a documented minimum?

---

## 6 — The dimensional rule: confirm or break it

**What we need.** Yes/no, plus any exception.

**What we believe.** For a containment crossing:

- **inward** references are scalars — `use(none,in_hierarchy,state,1)`;
- **outward** references are lists, and the alias carries brackets that the
  consumer's equation uses verbatim — `use(none,in_hierarchy,{volume},list(1))`
  beside `sum({volume})`;
- **curly** braces for variable membership, **square** for fixed, one bracket
  level per dimension (`fire_rect` crosses a 200×300 grid and writes
  `any(any([[lit]]))`);
- a **conditional** submodel counts as multi-instance even at `count=[]` —
  `landuse1b`'s `Forest` exports `{volume}` as `list(1)` and is the one submodel
  there holding a condition.

**Is "multi-instance or conditional ⇒ outward is a list" complete, or are there
cases where an outward reference stays scalar?**

---

## 7 — `references(…)`, and `obsolete`

**What we need.** Whether we must emit it.

**Evidence.** `landuse1b.pl`:

```prolog
references(node00002,[obsolete,obsolete,local(arc00018),local(arc00019)]).
references(node00042,[local(arc00018),local(arc00019)]).
```

We omit it and our models run. **What is it for, and is omitting it safe for
models more complex than ours?** The literal `obsolete` entries suggest a list
whose positions matter.

---

## 8 — `spec=`, and the values we do not hold

**What we need.** Confirmation that these are cosmetic.

**Evidence.** Function nodes carry the user's typed text as character codes
alongside the parsed value:

```prolog
node(node00014,function,[],[…,spec=[114,97,110,100,95,99,111,110,115,116,40,48,44,49,48,48,41],units=1,value=rand_const(0,100)],[]).
```

We emit `value` and omit `spec`, `min_val`, `max_val` and `fill_colour`. Models
run. **Is anything there load-bearing, or is it all round-tripping for the
editor's benefit?**

---

## 9 — `course=[…]`: arcs have waypoints?

**What we need.** Confirmation, and whether they are purely visual.

**Evidence.** `landuse1b.pl` arcs carry `course=[[22,…],[…]]` — a list of points.

**Why it matters to us beyond drawing.** We currently have curvature but no
waypoints, and had it down as a possible future feature. If Simile has had them
all along, that settles a design question for us (`DESIGN-diagram.md` §7.5).

---

## 10 — Which Prolog, and how separable is the C++ back end?

**What we need.** A rough answer; this one is architecture, not a model.

**Why.** Set out at length in `NOTE-export-to-simile.md` §6. Since the generator
is itself Prolog, a **JavaScript back end** would make the whole pipeline run in
the browser with no compiler and no server. Two things decide whether that is
realistic: how separable the emitter is from an internal representation, and
**how large the runtime library the generated code links against** is — we
suspect the latter, not the code emission, is the real work.

A cheap experiment settles the first half: try loading the generator into
SWI-Prolog and see how far it gets. Dialect distance is usually obvious within
an hour.

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
