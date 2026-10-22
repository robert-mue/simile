# Note: loading a model in the Run control (item 38)

The discussion of 2026-10-21, more or less verbatim. Parked by Robert, to be
thought through and settled once rather than rushed. The summary of where it
stands is in `RESTART.md`, "Parked: what the Simulation window is FOR".

---

**Robert** (10:25):

> 38. I think the Run control dialog should be tied to a particular model.
> Therefore there should be no need for the bit that asks you to select and
> load a model. Say if you can see a flaw in this.

---

**Claude** (10:28):

**38: I agree, with one real flaw and one consequence to be aware of.**

Inside a model's Simulation window, the run control already belongs to that
model: it shows only that model's run. So the chooser is mostly left over
from when it was a general SimiLive client. The change would be:

- remove the model menu, the path box, and the load and unload buttons;
- make ▶ load the model if it isn't loaded (or has been edited), then run it;
- make reset load the model and go back to the start, which covers the one
  use left for "load without running": seeing the starting values;
- report load progress and errors, such as "this model cannot be exported
  yet", in the status line as now.

**The flaw: SimiLive's own demos.** Fire spread, Game of Life, Particle
diffusion, Three-body problem and Branching plant can be reached only through
that menu, so removing it removes them. Either:

1. drop them, since they were scaffolding for testing the grid display; or
2. move them to a menu, for example Simile ▸ SimiLive demos, each opening its
   own run control.

**The consequence: the app runs one model at a time, and still would.**
Pressing ▶ on model B ends model A's run, and A's displays then show "no
model loaded". The load button does the same today; it would just become
implicit. That's cheap to recover from, because compiled models are kept, so
▶ on A again reloads it at once. But you'd lose A's place in its run. If you
often want two models running side by side, that's a bigger change (one
session per model), and worth deciding separately.

A run control opened on its own (the Free layout, or Widgets ▸ Run control)
would follow whichever model is current, and show its name.

Which do you want for the SimiLive demos, 1 or 2? Then I'll build it.

---

**Robert** (10:56):

> OK, park this for the time being. I still think that anyone who opens a
> model, or starts a new model, would expect the Simulation window to apply
> to it, and shouldn't have to explicitly load that model. I don't like the
> idea of having such a specific top-level menu, but a more acceptable
> alternative is to add the models under File>Models. But then I think that
> File>Models should have a rich collection of readily-available models,
> grouped into sub-menus, and we are not ready for that yet. Another thought
> is that it is conceivable that a user might want more than one model loaded
> at the same time, and for them to SHARE A SIMULATION WINDOW - e.g. to
> compare the same variable in two similar-but-different models. Bottom line:
> we need to think this through and come up with a definitive solution,
> rather than rushing in and maybe having to change again later.

---

**Claude** (10:56):

I've recorded item 38 in `RESTART.md` as a parked design question. The note
covers:

- **Settled:** a model's Simulation window applies to that model, with no
  explicit load.
- **Where SimiLive's demos go:** under File ▸ Models, once that becomes a
  proper grouped collection, not in a new top-level menu.
- **Open:** several models loaded at once, sharing one Simulation window to
  compare the same variable.

The open question decides what the window *is*, so it comes first. It also
looks feasible now: with models compiled and run in the page, several can be
loaded at once cheaply, which wasn't true when everything went through one
SimiLive session. A plot would then need to say which model each line comes
from as well as which variable. That's the part to design carefully.
