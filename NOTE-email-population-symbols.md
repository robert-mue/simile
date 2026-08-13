# Email to the Simile developer — two questions about meaning

*Drafted 2026-08-12, **cut down 2026-08-13 and not yet sent.** The first draft
had four questions. Re-saving six catalogue models in Simile 7.4 answered two of
them by observation — the spellings, and what `alarm` is — so those are gone.
What is left is the half a file cannot answer: what two of the symbols MEAN.*

*The other, unrelated questions are in `NOTE-questions-for-developer.md`, and
three of those (§A1 associations, §A2a spellings, §A4 `border`) are now answered
too.*

---

**Subject: Simile's population symbols — two questions about meaning, and one we think we have wrong**

Hi [name],

Robert here — this is from the notation-neutral diagram editor we've been
building. It converts its models to Simile Prolog, uploads them to SimiLive and
runs them, so most of what we needed we've worked out from the model catalogue
rather than by asking. Thank you for that: 72 `.pl` files answered more questions
than a long conversation would have, and opening a few of them in Simile 7.4 and
re-saving answered several more.

Two questions left, and both are about **meaning**, which is the part no file
tells us. Each should be a one-line answer — and if it's easier to send a small
model than to write prose, that is genuinely better for us. We can read the
Prolog, and a model doubles as a test we keep.

**1. We think our own `migrator` is mis-labelled — this is the one we'd most
like your view on.**

Our property dialog asks for a "migration condition", i.e. a boolean. But every
`immigration` node in the catalogue holds a **number** — `10`, `0.1`,
`if effort<=0 then 0 else labour_input/effort`. That reads as *how many new
instances arrive per time unit*, not a condition.

If that's right, it isn't a gap in what we can export — it's a wrong dialog that
has been in the editor since we wrote the schema, and would mislead anyone using
it. We only noticed by looking at what the symbols hold rather than what they're
called.

**2. Is `loss` a probability or a condition?**

The catalogue shows both: a bare `0.6` in one model, `(x<0)` in another, and
`if rand_var(0,1)<opposition/25/360 then 1 else 0` in a third. Is it a
per-instance probability per time unit, with the boolean forms just people
writing 1/0 explicitly? Or is it genuinely either, and Simile reads whichever it
is given?

The same question probably applies to `creation` and `reproduction`, so if
there's one rule covering all of them, that one sentence would do.

---

**Two things that may be useful to you in return.**

**A bug of ours that your loader could have caught.** When we emitted `value=a>b`
instead of `value=(a>b)` — not legal Prolog, since `=` and `>` are both priority
700 — Simile silently dropped the property. The model compiled, ran, and gave
confidently wrong answers; it took an afternoon to find. A warning when a
property fails to parse would save that for anyone generating `.pl` files.

**What re-saving told us**, in case it's useful as a record of what 7.4 does to
an old file. Opening six catalogue models (2003–2008, formats 7.1 and 9.0) in
7.4, running them and exporting model declarations: all six loaded and ran with
no warnings; the population symbols and `alarm` come back **unchanged**; legacy
boundary stubs written as plain `variable` are converted to `border`; every
coordinate becomes a float; `attached=[…]` appears on every flow segment; and
7.4 **derives units it did not have before**, writing `units=1/day` on flow rates
that carried `units=1` in 2008. Apart from those and some pretty-printing, the
models are element-for-element identical across twenty-three years — which is a
better compatibility record than most software can claim.

Best,
Robert
