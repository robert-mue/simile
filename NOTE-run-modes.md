# Note: running, pacing and interventions — a proposal (2026-11-16)

For discussion; nothing built. Decisions marked as Robert's are open.

## The problem

The Trees model's lollipop display jumps straight to the final state. In the
page the whole run is ONE request to the engine (`src/simulation.js`, the
`ExecuteMulti` in `_step`: "a run here is over in milliseconds"), so every
logged point is emitted at once; the lollipop keeps only the latest values and
draws at the next animation frame, by which time the last point has arrived.
The plotter hides the same thing because it draws the whole history. On
SimiLive, chunks and network delays made it animate.

Original Simile, when no slider is being moved, animates ALL displays, plots
over time included: the user sees the progression, and the lollipop diagram
and the plot are in step. So the pacing belongs to the run control, not to
each display.

## Requirement (Robert)

Simile's handling of a parameter slider is a requirement: moving it during a
run changes the value FROM THAT MOMENT, and the run continues. In an
ecological model it lets a human agent make an intervention (a rainfall
event, a harvest) at a point in time, perhaps in response to what the model
has done so far.

(An earlier version of this proposal — compute the whole run, then show it up
to a time T — was dropped because of this: it makes a slider act from t = 0.)

## The proposal: the engine runs alongside the display

The engine computes only as far as the display has got, a small chunk ahead.
Paused at time T, the model IS at T, as in Simile. A slider move changes the
value from T on and the run carries on; nothing before T is recomputed.

The run control does all the pacing. Every display gets the same points at
the same moments (plot and lollipops in step) and draws what it is given, as
now, so added widgets need no change (`WIDGET_API` 1 unchanged).

## Two ways a slider can act — the one place "mode" is needed

| | Instant | Timed (animate or step) |
|---|---|---|
| The run | computed in one go, shown at once | moves at a set interval, or one point per click (held down: as animate) |
| A slider move | **a setting for the whole run**: re-runs from t = 0 at once (as now; for "what if" sweeps) | **an intervention**: the value changes from the current time, and the run continues |

A slider means something different in each, so the panel should show which
mode it is in. A "step" is one LOGGED point (Log each), not an integration
step.

## ▶ and ■

- **■** goes back to the start, as now.
- **▶** carries on from the current time (Simile's); at the end of a run, or
  at the start, it runs from the beginning.
- Perhaps a separate **"Run from start"**, so ■ then ▶ is never needed.

## Questions it raises

1. **Which sliders can intervene.** Only variable parameters (read every time
   step). A starting value means nothing mid-run: its slider greyed while a
   timed run is under way, active again at the start.
2. **A slider moved at the end of a run.** Nothing to continue: it is simply
   the value the next run uses from t = 0, as in Simile.
3. **What ■ does to interventions** (Robert's). In Simile a slider stays where
   it was left: after ■ the LAST value applies from t = 0 and the history of
   moves is gone — simple, and what Simile users expect. The alternative is to
   RECORD each move as "from time T, this value". The page already takes a
   variable parameter's values over time (`Simulation.readInputValue`), so a
   recorded run — a scenario, "rain at 20, harvest at 50" — could be replayed,
   saved and compared. A later step, but within reach.
4. **The time slider** (Robert's). Looking back in time works: a display keeps
   what it has been shown. Intervening while looking back is a BRANCH ("what
   if I had harvested at 30 instead"): re-run 0–30 with the earlier
   interventions, then go on with the new value. Suggested for now, Robert's
   original rule: sliders disabled while looking back, active again on return
   to the current time.
5. **Random numbers.** The page's engine takes a fresh seed at every reset
   (`src/engine-local.js`, `Reset`). Irrelevant today; a replay (3) or a
   branch (4) must reproduce the same past exactly, so the seed would have to
   be kept with the run. Not needed for the basic design.
6. **Default for a newly opened model** (Robert's). Timed (animate) seems
   right for a gallery model that runs itself; a model's `presentation` could
   recommend the mode and interval.

## Engine work to check before building

- **A value changed in the page mid-run, without a reset.** The page's engine
  is given slider values BEFORE a reset (`src/engine-local.js` header,
  `Parameterize`). SimiLive already changes a rate in place (`Parameterize`
  with `NOW v`), so the remote path already behaves as Simile does. Whether
  the page's engine can take a value mid-run is the first thing to find out —
  likely, since values over time are already read every step
  (`sx_param_series`).
- **Speed.** Small chunks are a little slower than one call; at animation
  speed irrelevant. Instant mode keeps the single call.

## Lost against the first version

Plot axes cannot be scaled to the whole run in advance in timed mode — the
future is not known — so they keep growing as now. In instant mode they could
be.

## For Robert to decide

- Is the instant / timed split the right single notion of mode?
- What does ■ do with interventions (question 3)?
- The rule for the time slider (question 4)?
- The default mode for a newly opened model (question 6)?
