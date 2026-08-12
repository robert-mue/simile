# Email to the Simile developer — the population symbols

*Drafted 2026-08-12. The covering letter for §A2 of `NOTE-questions-for-developer.md`.
Self-contained: everything needed to answer is below, and the link at the end is
only for the other, unrelated questions.*

---

**Subject: Simile's population symbols — three spellings to confirm, and one we may have wrong**

Hi [name],

Robert here — this is from the notation-neutral diagram editor we've been
building. It now converts its models to Simile Prolog, uploads them to SimiLive
and runs them, so most of what we needed we've been able to work out from the
model catalogue rather than by asking. Thank you for that: 72 `.pl` files
answered more questions than a long conversation would have.

Four questions left, all on the population symbols. Each should be a one-line
answer — and if it's easier to send a small model than to write prose, that is
genuinely better for us. We can read the Prolog, and a model doubles as a test we
keep.

**1. Three spellings we've inferred, one we're sure of.**

A census across all 72 catalogue models turns up five node types we don't
currently emit. Our palette names are on the left, and the last column is what
the *function* behind each node actually holds — which is what raises question 2:

| ours | we think | seen in the corpus as | its function holds |
|---|---|---|---|
| initialiser | `creation` | "initial number", "initial pop size" | plain counts — `100`, `10`, `4` |
| exterminator | `loss` | "death", "tanks destroyed" | `0.6` · `(x<0)` · `if rand_var(0,1)<opposition/25/360 then 1 else 0` |
| migrator | `immigration` | "new tanks constructed" | `10` · `0.1` · `if effort<=0 then 0 else labour_input/effort` |
| reproduction | `reproduction` | "birth" | `rand(0,2*0.7)` · `if rand_var(0,1)<r then 1 else 0` |

Are the first three right? `reproduction` matches by name so we're confident of
that one. We refuse to export any of them until we know, because a wrong guess
gives a model that loads and quietly means something else.

**2. We think our own `migrator` is mis-labelled — this is the one we'd most like
your view on.**

Our property dialog asks for a "migration condition", i.e. a boolean. But every
`immigration` node in the corpus holds a **number** — `10`, `0.1`,
`if effort<=0 then 0 else labour_input/effort`. That reads as *how many new
instances arrive per time unit*, not a condition.

If that's right, it isn't a gap in what we can export — it's a wrong dialog that
has been in the editor since we wrote the schema, and would mislead anyone using
it. We only noticed by looking at what the symbols hold rather than what they're
called.

**3. Is `loss` a probability or a condition?**

The corpus shows both: a bare `0.6` in one model, `(x<0)` in another, and
`if rand_var(0,1)<opposition/25/360 then 1 else 0` in a third. Is it a
per-instance probability per time unit, with the boolean forms just people
writing 1/0 explicitly?

**4. What is `alarm`?**

We have no equivalent and hadn't known it existed. Three in the corpus, always
`units=boolean`:

- `not found_divisor` and `(found_divisor or quotient>check_limit)` — a
  prime-number model
- `(abs('Gs'-'Gs_0')<0.001)` — BallBerry

It looks like "fire when this becomes true" — a convergence or termination
signal. Is that right, and should a general-purpose Simile editor offer it?

---

**One thing that may be useful to you in return.** When we emitted `value=a>b`
instead of `value=(a>b)` — not legal Prolog, since `=` and `>` are both priority
700 — Simile silently dropped the property. The model compiled, ran, and gave
confidently wrong answers; it took an afternoon to find. A warning when a
property fails to parse would save that for anyone generating `.pl` files.

There are eight further questions, none of them about population symbols, here if
you have appetite for them:
https://github.com/robert-mue/simile/blob/main/NOTE-questions-for-developer.md

Best,
Robert
