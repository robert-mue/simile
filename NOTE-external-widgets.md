# Note: widgets from a URL, and toolkits (a generic sienna feature)

Raised by Robert 2026-10-22, to discuss before building. It belongs in
**sienna** (the shell), not in simile: any sienna app would get it.

## Robert's proposal

In another hand-crafted, widget-based app, Robert let the user enter the URL
of a widget that was not built into the app. It could be **local** (one they
made themselves) or **online** (someone else's). This turned out to be
trivially easy: a dialog with one `<input>` field.

He extended it to a **toolkit**: the URLs of several such widgets packaged in
a `.js` file with a single assignment statement (an array of URL strings).
The user gives the toolkit's URL in another very simple dialog with one
`<input>` field.

## Claude's thoughts (2026-10-22)

**It fits sienna almost as it is.** The registry already loads a widget by
injecting a `<script>` tag, which works from file://, and it already passes an
absolute URL through untouched (`scriptUrl` in
`sienna/src/core/widget-registry.js`). So "add a widget from a URL" is mostly
`register(name, { src: url, … })` plus a menu entry. What needs thought is
around that:

1. **The name and menu label are not known until the script runs.** Today
   the manifest names a widget before loading it, and the script's
   `_loaded(name, method)` only fills in the method. For a URL we know only
   the URL. So: load first, and let the script say who it is. Best: the
   widget describes itself (name, label, title, role, default options) in its
   `_loaded` call, or a small `define` call beside it. Then a toolkit stays a
   plain list of URLs, and one file is the whole widget.

2. **It must be remembered.** The added URLs belong in userData, so they
   come back next visit. A saved layout or session that has a panel of an
   external widget must record the URL too, so opening it (or replaying it)
   loads the widget first. If the URL fails, show a placeholder panel ("widget
   X from <url> could not be loaded") rather than losing the panel.

3. **Toolkit format: a call rather than an assignment.** A single assignment
   to a global works, but two toolkits write the same variable. Read it on
   each script's onload, one at a time, and that's safe. A call such as
   `Sienna.toolkit([...])` is tidier and matches how a page ships a model
   (`Simile.model(…)`). Either way, a **relative URL in a toolkit should
   resolve against the toolkit's own URL** (`document.currentScript.src`), so
   a toolkit can be a folder: `toolkit.js` beside its widgets, movable as a
   whole. Robert's string arrays stay valid; objects
   (`{ src, label }`) could be allowed later.

4. **"Local" depends on where the app runs.** From file://, a local widget
   path loads fine. From the public site (https), the browser will not load a
   `file://` script, and will not load `http://` from an `https` page. For the
   public site, "my own widget" means picking the file (`<input type=file>`),
   keeping its text (IndexedDB, as compiled models are kept) and loading it
   from a blob URL. Worth offering both: a URL field, and "or choose a file".

5. **Trust: an external widget can do anything the app can.** It runs in the
   page with full access: every saved model, the user's data, the network.
   There is no realistic sandbox that keeps the jQuery widget contract (an
   iframe would break it). It is like installing a browser extension. So the
   dialog should say so plainly and show the URL, and the list of added
   widgets should be visible and removable. Embedded-widget pages: only the
   page author should add widgets (in the page), never a reader.

6. **The contract becomes public.** Once other people write widgets, the
   widget contract (`sienna/CLAUDE.md`, `widgetBase`) is an API that can't
   change freely. A widget can depend on the shell only (generic), or on an
   app's API as well (a simile display reads `Sienna.Simulation`). A
   contract version a widget can declare, checked on load, would let the
   shell refuse a widget it can't host, with a clear message.

7. **Name clashes.** `$.widget('sienna.x', …)` replaces any existing `x`
   silently. An external widget must not be able to replace a built-in one:
   refuse a name that is already registered (or prefix external names).

8. **Where they appear.** In the Widgets menu, in their own section below the
   built-in ones, with "Add widget from URL…", "Add toolkit…" and "Manage
   added widgets…" (list, remove).

Suggested order, if built: the self-describing `_loaded`/`define` and loading
by URL in sienna; remembering URLs (userData) and the placeholder; toolkits;
then the file-picker route for the public site.

## Robert's answers (2026-10-22), and the two questions he asked

- **#1 Metadata: agreed, and extended.** A widget file carries an OBJECT:
  name, label, title, role, default options, plus notes describing it,
  author, etc. A **toolkit is an object too**, with similar metadata (name,
  notes, author…) and its list of widget URLs.
- **#2** (remember URLs, placeholder), **#3** (relative URLs resolve against
  the toolkit's URL), **#6** (contract version), **#7** (no replacing a
  built-in), **#8** (own section of the Widgets menu): agreed.
- Form of the object: Robert's is a single assignment; #3 suggested a call.
  Same object either way; a call (`Sienna.widget({...})`,
  `Sienna.toolkit({...})`) avoids two files writing one global. To settle
  when building.

**#4, "isn't that restriction only for files like .json, not scripts?"**
Partly. The file:// rule that stops `fetch` of a .json does NOT apply to
`<script>` tags, and scripts are exempt from CORS: that's why the app can load
a script from anywhere when it runs from file://, and why the public site can
load a widget from any https server. Two other rules DO apply to scripts:
- a page served over http(s) may not load anything from `file://`
  ("Not allowed to load local resource"), scripts included;
- an https page may not load a script over plain http (mixed content;
  scripts are the strictest case).
So: app from file:// → local and online widgets both work. Public site →
online https widgets work; a widget on the user's own disk needs the "choose
a file" route.

**#5, "are there security issues, and doesn't that kill the idea?"**
Real issues, but they don't kill it: it is the trust model of browser
extensions, a script from a CDN, or a spreadsheet with macros, and it is
what Robert's other app already does. What an added widget CAN do: read,
change or delete the user's saved models and settings in that browser
(on the public site, storage is shared by everything on
`robert-mue.github.io`, i.e. all of Robert's GitHub pages); send data out;
behave differently tomorrow, since the file at the URL can change. What it
CANNOT do: read the user's files, or other sites' data, cookies or
passwords. The risk falls on the user who chose to add it, in their own
browser. Mitigations, all cheap:
- Load an external widget ONLY on the user's explicit say-so, with the URL
  (and, for a toolkit, every URL in it) shown. The real danger is a silent
  load: a model, layout or session someone sends you that names an external
  widget must ASK before loading it, never load it on opening.
- Added widgets listed and removable (#8); the author and notes from the
  metadata shown in the consent dialog.
- Optional pinning: an `integrity` hash (Subresource Integrity) on a
  toolkit's entries, so a changed file is refused.
- Embedded-widget pages: only the page's author adds widgets.

## Built (2026-10-22)

Decided: the declaration is a call, `Sienna.widget({...})` (and
`Sienna.toolkit({...})`). Built in sienna (559756d) and wired into simile:

- `sienna/src/core/widget-registry.js`: `Sienna.widget`, `Sienna.toolkit`,
  `Sienna.widgetContract` (1), `loadScript(url)`, `unregister`; name clashes
  and too-new contracts refused with a message.
- `sienna/src/core/added-widgets.js`: remembered list (own localStorage slot;
  a chosen file's text is kept), registered at startup without loading; the
  dialogs (Add a widget…, Add a toolkit… — URL or choose files — and Manage
  added widgets…), each with the warning; a toolkit's list shown before any
  of it loads; `menuItems(app, open)` for the end of the Widgets menu.
- `sienna/src/core/workspace.js`: a widget that cannot be loaded leaves a
  placeholder panel, kept and saved.
- Examples: `sienna/examples/added/` (`dice.js`, `stopwatch.js`,
  `toolkit.js`).

Checked headless in the sienna demo and in simile: by URL, by toolkit, from
chosen files (kept across a reload), clashes refused, placeholder after a
removal; simile's editor tests, grammar and fixture pages and both sample
pages unchanged.

Not done yet: an `integrity` pin is supported in a toolkit's entries but
untested (it needs a server sending CORS headers; file:// cannot); a session
or layout from ANOTHER machine names a widget by name only, so it shows the
placeholder rather than offering to add it — offering that (with consent)
would need the URL saved with the panel.

## Next: helping a user CREATE a widget (Claude's thoughts, 2026-10-22, for discussion)

Who writes one decides most of this: a modeller who knows a little
JavaScript, one who knows none, or a programmer. Ideas, cheapest first:

1. **An author's guide** (`help/widgets.html`, like `help/pages.html`): the
   one-call shape, a minimal working example, the methods a widget gets
   (`_ref`, `_get`, `_set`, `_action`, `_watchModel`, `state()`,
   `slx-chrome`), how to share one (a folder with a toolkit, put online).
2. **Templates: Widgets ▸ New widget…** asks for a name and a kind
   (blank / a display of the running model) and saves a ready-to-edit file
   with the name filled in; Add a widget… then loads it.
3. **The edit–reload loop.** Today an added widget cannot be re-added
   without removing it, and jQuery keeps the old definition until the page
   reloads. Wanted: a **Reload** on each added widget (Manage…) that re-runs
   its script and re-creates its open panels. For a selected file, a
   Chromium file handle can re-read it after an edit; elsewhere, select it
   again.
4. **Errors shown where the author is looking.** A widget that throws in
   `_create` (or a script with a syntax error) today shows only in the
   devtools console, which a modeller never opens. Catch it and show it in
   the panel: message, file, line.
5. **A documented simile data API for displays.** What a display needs —
   the variables, values over time, "a run has moved on" — is reached today
   through `Sienna.Simulation` internals (`viewFor(ref)`, `subscribe`). Write
   down a small stable surface (that, plus how series are shaped), and
   version it with the widget contract. Without this, display widgets break
   whenever simulation.js changes.
6. **A brief for an AI assistant.** Many modellers would ask Claude or
   similar to write the widget. One page holding the whole contract and the
   data API, written to be pasted into a chat ("Copy instructions for an AI
   assistant" in the guide), makes that reliable. Cheap, given 1 and 5.
7. **No-code widgets.** A lot of what people want — a big number, a gauge,
   a traffic light on a threshold, a table of chosen variables — is one
   configurable widget plus options, not new code. A "custom display"
   dialog that saves a configured instance reaches the users who will never
   write JavaScript.
8. **An in-app editor** (a code panel with live preview, kept in settings):
   the most self-contained, the most work. Later, if at all.

Suggested order: 4 and 3 (they make every other route bearable), then 5
and 1 with 2, then 6; 7 when it is clear which displays people ask for.

## Built (2026-10-24/25): Robert's order — 6, then 4 and 3 (then 5 and 1)

Robert (2026-10-24): "I was thinking in terms of just 6. However, we might
as well work on supporting coders who are happy to build one themselves."
Dropped: 2 (templates), 7 (no-code), 8 (in-app editor). Order: 6; 4 and 3;
5 and 1.

- **6, instructions for an AI assistant** (sienna eaf44e0; simile fecc412):
  `sienna/src/core/widget-brief.js` (generic) + `src/widget-brief-simile.js`
  (roles, model spec, a running model's values). Widgets ▸ Instructions for
  an AI assistant… (Copy / Save as file), and a link in Add a widget….
  Checked by writing `examples/widgets/big-number.js` from the brief alone:
  it lists the model's variables once loaded, shows a value at once
  (`query`) and follows the run.
- **4, errors on the panel** and **3, Reload** (sienna b3aefeb + the
  count-once fix): a red bar on the widget's panels for an error while it
  runs (with Reload, ×n for repeats); the placeholder, with line and a
  Reload button, if it fails as it starts. FOUND: Chrome hides the details
  of errors from a script on file:// or another site ("Script error."), so
  they are caught in the shell's own code — wrapped widget methods, jQuery's
  event dispatch, userData's and simile's simulation listeners. A syntax
  error in a file added by PATH still cannot be described: said so plainly;
  a selected file gives its line. Reload keeps panels open and their
  `state()`; adding the same URL again reloads.

- **5, the data interface** (2026-10-25): `Simulation.forWidget(ref)`,
  `WIDGET_API` 1 — base, status, time(), runLength(), unitName, the two
  component lists, add/removeTarget, query, subscribe; nothing that drives
  the run. The brief and the example use it.
- **1, the author's guide**: `help/widgets.html` (Help ▸ Writing a widget),
  for coders: the file, inside a widget, showing a running model (the
  interface and events, value shapes), reading the model, trying it out
  (path vs select, errors, Reload), sharing (toolkits), the rules.
- Regression: `tools/headless/scripts/added-widget.py` (6 PASS);
  `help-pages.py` now includes the guide (fits a phone).

All of Robert's list (6, 4, 3, 5, 1) is done; not released.
