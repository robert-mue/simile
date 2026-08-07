# Static SPA vs. a server: what it costs the replay log

**A note for the record — simile diagram editor, 2026-08-08**

*Occasioned by a question from the user after the replay mechanism was built, and by what
answering it turned up. Kept as a note rather than folded into `DESIGN-diagram.md` because most
of it is not a decision about the diagram editor — it re-examines an architectural choice made
before this project started, and it is honest about one place where the first answer given was
badly framed.*

---

## 0. The question

> *"I have a question regarding my early decision to build a static SPA: if we had gone for a
> (more conventional) dynamic one, with a server etc, would a lot of the limitations you mentioned
> for the replay log have disappeared or at least become much less important?"*

The limitations in question, from `STATUS.md` item 20 and the known-gaps list:

1. the action log does not survive a reload — it lives in memory only;
2. it grows without bound, and `localStorage` is ~5 MB *shared with the model data*;
3. persisting it drags undo semantics along with it;
4. replay must start from a clean slate, so it destroys the current one;
5. panel ids must line up with the recorded ones;
6. `panel.ref` and no-per-item actions are not reconstructed;
7. background tabs throttle timers, which made an unpaced replay look hung.

---

## 1. The first correction: the constraint is `localStorage`, not the SPA

The framing in which those limitations were first written — *"it's a shell decision"*, storage
limits discussed as though they followed from having no server — **conflated two separate
things.** Being a static SPA does not imply small, fragile storage. It implies no *remote*
storage. Local durable storage of a very different order is available to the same architecture,
and §2 below shows two options that were dismissed too quickly.

That matters because it changes what the question is really asking. "Would a server help?" and
"would better local storage help?" have mostly the same answer, and only the second requires
giving anything up.

## 2. What a server would genuinely fix

**Persistence across reloads** — dissolves completely. An append-only log on a server survives
reloads, browsers and machines, and is shareable by URL. Everything downstream goes with it: the
guard that names the models a log cannot rebuild (`STATUS.md` item 20) exists *only* because the
log and the models have different lifetimes.

**The quota interaction** — largely gone. Not because a server has infinite room, but because the
log would stop competing with the model data for one 5 MB allowance. The nasty failure mode —
*models stop saving because history filled the disk, silently* — is specific to sharing a small
quota with the thing you cannot afford to lose.

**Replay from a checkpoint.** Cheap server-side snapshots would let a replay start from state *N*
rather than from zero, which softens (4).

## 3. What a server would not fix

The clean-slate requirement itself, panel-id alignment, unreconstructed `panel.ref`, actions with
no per-item record, and timer throttling in a background tab. None of these are about where bytes
live: they are about *what the log records* and how the browser behaves. And (3), the undo
question, is a design decision that a server merely makes askable rather than answering.

## 4. One place it would have helped, unexpectedly

**The immutability bug would probably never have shipped.** Sending a log to a server means
serialising it, and `JSON.stringify` at that boundary is an accidental snapshot: the by-reference
capture that corrupted the log (§20.4 of `DESIGN-diagram.md`) would have been silently corrected
in transit.

Two caveats keep this from being an argument for a server. It would have been luck rather than
design — nobody would have known the hazard was there. And it would have *hidden* the identical
bug in `history`, which is in-process whatever the backend, so the corruption would still have
been present in undo and merely harder to find.

## 5. What the architecture buys, and would cost to give up

The static SPA buys **offline, zero-install, no-infrastructure** operation. §11.2 of
`DESIGN-diagram.md` records offline use as mattering for field and teaching work, which is
presumably why it was chosen. A server means hosting, auth, backups, uptime and a deployment
story, for one developer.

**For the interactive-tutorial use the user has in mind, the current architecture is arguably the
better fit.** A tutorial log is *authored content*, not user data: written once, shipped alongside
the app as a file, loaded through the existing Session ▸ Open session log. It is never written
back, so none of the persistence limitations apply to it at all.

## 6. The local options, measured

Both keep the architecture. Neither was properly checked before this note, and the check is the
most useful thing in it.

### IndexedDB from `file://` — works, and persists

Tested against Chrome 149 on the user's machine, from genuine `file://` URLs (headless, fresh
profile, no `--allow-file-access-from-files`):

| | |
|---|---|
| `indexedDB` present | yes |
| open → write → read round trip | **works** |
| survives a second browser session | **yes**, record read back intact |
| `localStorage` (control) | works, as the shell already relies on |

So the option flagged as uncertain is real, and it addresses (1) and (2) with no server: durable
across reloads, and a quota far larger than `localStorage`'s and separate from it.

### The File System Access API — already in use

Proven from `file://` by webAKT and now by simile's own File ▸ Save (sienna `5bb8468`). A retained
handle could autosave the log to a real file: durable, unbounded, user-chosen. This is the option
that fits the tutorial case best, since a tutorial log *wants* to be a file.

## 7. What the test turned up, which mattered more than the answer

**Every `file://` page shares one origin.** `location.origin` is literally `"file://"`, and a page
in one directory read back a record written by a page in a completely different directory —
for IndexedDB and for `localStorage` alike.

The consequence is not about replay at all:

> Two sienna apps opened from disk **shared** `sienna.userData.v1` and `sienna.workspace.v1`. Not
> a collision between models — between *applications*, silently overwriting whole stores.

§18 of `DESIGN-diagram.md` anticipates exactly that future (*"sienna is a host that becomes a
particular application (`?app=simile`, `?app=webakt`)"*), so this was a live risk rather than a
hypothetical one. It is also specific to the mode the project is built for: served over http each
origin is distinct and the problem does not exist.

**Fixed** in sienna `a63dde4`: storage keys are namespaced `sienna.<app>.<slot>`, the id settled in
`namespace.js` because nothing later is early enough, with a one-time adoption of any
pre-namespacing store so that nothing already saved appears to vanish. See `STATUS.md` item 22.

## 8. Conclusion

**A server would fix one of the seven limitations outright, largely remove a second, and soften a
third. It would not touch the other four, and it would cost the offline, install-free operation
the project was built around.**

The one limitation it would clearly fix — durability of the log — is equally well fixed by
IndexedDB or by a file handle, both of which are available *now*, from `file://`, and neither of
which requires giving anything up. On the evidence, the static-SPA decision does not look like
what is constraining the replay log; `localStorage` is, and only for as long as we keep using it
for something it was not sized for.

The question was worth asking for a reason unrelated to its answer: checking it is what exposed
the shared-origin behaviour, which had been sitting under the project since its first commit.
