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
