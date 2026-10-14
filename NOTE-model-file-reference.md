# A model file reference: writing models without the app

*Recorded 2026-10-14 from a conversation with Robert. Queued as job 6 in
`RESTART.md`; nothing has been built yet.*

## The question

Some people will want a model built by describing it to Claude, without using
the app at all. Claude then needs a reference document that tells it about
Simile: the modelling concepts, our JSON format, and so on. Should that be a
stand-alone document written to be the best way of specifying Simile for
Claude, or can it simply be the Simile reference manual, which was written for
human readers?

## The answer: its own document, but not a Claude-only one

### Why the manual is not enough

1. **It never describes the format Claude would write.** Our JSON model format
   (stocks, flows, influences, layout, submodels, `FORMAT: 3`, the name rule) is
   ours. Today it is described only in pieces, across `DESIGN-diagram.md`, the
   schema and the code. Concepts alone cannot produce a file that opens.
2. **It is written for someone using the GUI.** Much of it says "click here,
   drag that", which is no help to someone writing a file. It is also long,
   which buries the parts that matter.
3. **It sometimes disagrees with us.** We call a `compartment` a `stock`, names
   use underscores instead of spaces, and the two products each have features
   the other lacks (alarms and the keypad are not implemented here). A model
   built from the manual would follow Simile's rules where ours differ.

Claude already knows the general ideas: system dynamics, stocks and flows, the
Lotka-Volterra equations. What it lacks is exact detail: field names, what is
required, what is refused, how equations are written, and how names refer to
each other.

### "Optimised for Claude" is not a different kind of document

What makes a spec work for Claude is the same thing that makes it work for a
careful person writing a model by hand:

- **Precise and complete.** Every node type, every field, which fields are
  required, and the default for each.
- **Short on concepts.** One paragraph per idea, in the manual's own terms so a
  reader can look each one up there.
- **Several complete worked examples.** These matter most. Predator-prey
  (Robert's), a model with a submodel, and a population model, each one a file
  that is known to load and run. Claude copies a pattern from examples more
  reliably than it follows a description.
- **The rules that get a file refused:** names, units, equation grammar, the
  list of functions, and the naming convention (`a`, `S3/f`, `/c`).
- **Common mistakes,** stated outright.

So the plan is one "Model file reference" in the simile repo, for humans and
Claude alike. It would also be a natural chapter of the embedded-widget pages guide,
since "make a page about any dynamic system" needs a way to write a model
without the app.

## How Claude learns the JSON format

**The document states it directly**, in tables that humans can read too. For
every node type it lists each field, whether it is required, its default, and
what gets refused. The examples show the format in use, but they do not define
it. If Claude learned only from examples, anything no example happened to use
would be guessed, and Claude would guess confidently. Writing the format out
also means a person can see exactly what Claude is working from and correct it.

## Checking is part of the document, not the prompt

The document can include a required "check your model" step, and Claude
follows procedural steps in a reference it has been pointed at. The user would
not have to ask. The step would be:

1. Import the file and run the completeness check.
2. Build and run it on SimiLive.
3. Fix whatever is reported, and repeat.
4. Report the outcome, quoting the check's actual output. A reader cannot
   otherwise tell whether the check was really run or only claimed.

There are two catches, and the document has to deal with both:

- **Claude needs a way to run the check.** Some pieces exist: the importer, the
  `Diagram` checks, `Simulation.loadOwn` and `tools/headless/`. But nothing yet
  takes a file from outside and returns a list of problems. That route has to
  be built, and it is the bigger part of the job.
- **Some Claude setups cannot run anything.** Plain claude.ai chat, for
  example, has no tools. For that case the document tells Claude to hand over
  the file with the check written out for the user to do.

SimiLive is a shared public host, so the procedure must `unload()` afterwards.

## Two things that matter more than the document itself

- **A way to check the result.** Claude will produce plausible files that are
  slightly wrong. If it, or the user, can run a file through the checks and get
  back a list of problems, Claude can fix them. That loop is what makes the
  method reliable; a better document alone will not.
- **Keeping it in step with the code.** A hand-written format reference goes
  out of date the way `test/corpus.js` did. The worked examples should be
  checked by the same tests as the fixtures, and where possible the field lists
  should be generated from the schema.

## Not `.pl`

Claude could write Simile's own `.pl` format and let our importer convert it.
That is not advised: the format is harder to get right, and errors would come
back through the importer instead of from our own checks. JSON is the target.

## Where to start

A first draft written from the schema and the existing demo models, with
Robert's predator-prey model as the first worked example.
