# Email to the Simile developer — the remaining questions

*Drafted 2026-10-19, to replace sending `NOTE-questions-for-developer.md` whole.
That note dates from 2026-08-12 and has gone stale in places: 0 was in the
population-symbols email, 8 we answered ourselves, 6 is half-done, and 3
matters only for the SimiLive fallback now. Numbers here are that note's, so
an answer can be filed against it; the longer write-ups and evidence are there.*

---

**Subject: Simile — six questions left, one of them blocking**

Hi Jasper,

Thanks for the answers on the population symbols — that settles loss
(probability per unit time), and it turned up a label of ours that was wrong
(reproduction is per member per unit time, not a total). And thanks for taking
the two run-time library patches. On whether they are real problems: the
second (the destructor that is not virtual, 6d.h:64) is not only on our path.
Simile's own `clearparamarray` command (`ame_cmx.c:552`) calls the same
`forget_param_array`, so Simile itself deletes a slider's `VarParamData`
through a `FileParamData*`, and `~VarParamData` never runs. Whether that
crashes depends on what reuses the memory next; in the browser it did.

These are the last questions we have. The numbers are from a longer note we
keep, so we can file the answers against it. Only the first one blocks
anything; the rest are "is this right?", each of which should be a one-line
answer. As before, a small model can be easier than prose, and we can read the
Prolog.

**0b. What does N mean in `use(N,in_assoc,…)`? (blocking)**

We took N to be the position in the association's `references` list. That
reads every catalogue model whose association joins roles from ONE base, but
not `feeding1`, whose association `eats` joins two DIFFERENT bases:

```prolog
arc(arc00001,node00002,node00003,relation,[complete=true,name=eater]).
arc(arc00002,node00004,node00003,relation,[complete=true,name=food]).
references(node00003,[local(arc00001),local(arc00002)]).
```

Both consumers, one in each base, are given index 0:

```prolog
role=[use(0,in_assoc,{eaten},list(1)),use(none,in_hierarchy,{eaten_0},list(1))]
role=[use(0,in_assoc,{pop_size},list(1)),use(none,in_hierarchy,{pop_size_0},list(1))]
```

By our reading the `food` consumer should be index 1. We tried that, and
Simile refused the model: "The equation for component `eaten` refers to an
input parameter called `{eaten}`. This is not a valid parameter in the context
of that component." So N means something we have not understood. We now
refuse to export `feeding1` rather than guess. **What does N select?**

**4. The dimensional rule — confirm or break it.**

For a reference crossing a submodel boundary we believe: **inward** references
are scalars; **outward** ones are lists, whose alias carries the brackets the
consumer's equation uses (`{volume}` beside `sum({volume})`); **curly** for
variable membership, **square** for fixed, one bracket level per dimension
(`fire_rect` crosses a 200×300 grid and writes `any(any([[lit]]))`); and a
**conditional** submodel counts as multi-instance even at `count=[]`.
**Is "multi-instance or conditional ⇒ outward is a list" the whole rule, or
does an outward reference ever stay scalar?**

**5. Submodel kinds we cannot make.**

The catalogue has `count=[N]` and `type=population`, which we do, and two we
don't: `type=records` (membership from data) and `count=[size(Patch)]` (a count
that is an expression over another submodel). We offer single,
fixed-membership and population. **Is that the complete set, with records a
variant of one of them, or is records a fourth kind?**

**7. Are `course=[…]` points on arcs purely visual?**

Arcs carry `course=[[22,…],[…]]`, a list of points. We draw arcs as curves
with no waypoints and drop `course` on import. If Simile has had waypoints all
along, that settles a design question for us instead of leaving it to taste.

**1. `usr(…)` in a role term.**

Both forms appear in the same file (`fire_rect.sml`):
`use(none,in_hierarchy,usr(nbr_lit),boolean)` and
`use(none,in_hierarchy,fuel,1)`. We guess `usr(x)` marks an alias the modeller
typed rather than one Simile defaulted, strip it on import and never write it.
**Decorative, or does the engine treat the two differently?**

**2. `use_sofar` and `enabled_roles`.**

We omit both and our models run. **Optional in general, or only for the cases
we have tested?** And is `in_8_nbrs` with its negative index
(`enabled_roles=[-2]`, `use(-2,in_8_nbrs,…)`) one of a fixed set of built-in
spatial relations? If so, what is the set?

---

**News, in case it interests you.** The question we once had down as "which
Prolog, and how separable is the C++ back end?" answered itself when your
source went up. Your generator runs **unchanged** in SWI-Prolog compiled to
WebAssembly (with the Tcl calls stubbed), and clang in WebAssembly compiles
the C++ it writes against `shank.cpp`, also compiled to WebAssembly. So the
editor now builds and runs models entirely in the browser: about 3 seconds to
prepare a model, milliseconds to run one, and sliders re-run the model as they
are dragged. SimiLive is now only the fallback for when that fails. On the
catalogue, the generated C++ is identical to what native Simile writes.

Best,
Robert
