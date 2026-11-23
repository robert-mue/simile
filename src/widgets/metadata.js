/**
 * `sienna.metadata` — a model's METADATA, entered and shown (Widgets ▸
 * Metadata): its descriptive title, a description, keywords, its web page
 * (a model gallery model's page there), and the paper it was published in,
 * if any. Held in the model spec, `<model>/metadata`
 * (Robert, 2026-11-15), so it travels with the model: File ▸ Save writes
 * it, and the Sample models panel shows it for the model gallery's models.
 *
 *   "metadata": { "title": "…", "description": "…", "keywords": ["…"],
 *                 "page": "https://…",
 *                 "paper": { "citation": "…", "url": "https://…" } }
 *
 * A field left empty is left out. The web page and the paper's link are
 * also shown as links, opened in a new tab. Below the fields, what is read from the
 * model's structure and never entered: its size and its Simile features
 * (`Sienna.modelSummary`), kept up to date as the model is edited.
 *
 * And its DEFAULT DISPLAYS (`<model>/presentation`, src/presentation.js):
 * the plots and sliders it opens with, and the run settings, shown in words;
 * "Use the displays open now" takes them from its Simulation panel, Clear
 * takes them away. Each one undoable edit.
 *
 * And its FAMILY, if it has one (Robert, 2026-11-23; `metadata.family`, see
 * `Sienna.metadataForm` in src/dialog.js): the models it is one of a set of
 * alternatives with, this one marked and each other a link that opens it in
 * this window, beside this one, with its own panels.
 *
 * Each change is one undoable edit, made when a field is left (or Enter in
 * a one-line field), not at every key. Another view of the same model, or
 * an undo, shows here at once — except in the field being typed in.
 *
 * Classic script, injected on demand by the widget registry.
 */
$.widget('sienna.metadata', $.sienna.widgetBase, {
  options: {},

  // The fields and their conversion are stated once, in src/dialog.js
  // (`Sienna.metadataForm`), shared with Model properties' Metadata tab.
  FIELDS: Sienna.metadataForm.FIELDS,

  _create() {
    this.element.addClass('slx-meta');
    if (!this._bound()) {
      this.element.append($('<p class="slx-meta-note">').text('Open a model first: metadata belongs to a model.'));
      return;
    }
    const form = $('<div class="slx-meta-form">').appendTo(this.element);
    this._inputs = {};
    this.FIELDS.forEach((f) => {
      const id = 'slx-meta-' + f.key + '-' + Math.random().toString(36).slice(2, 8);
      $('<label>').attr('for', id).text(f.label).appendTo(form);
      const input = (f.long ? $('<textarea rows="3">') : $('<input type="text">'))
        .attr({ id, placeholder: f.hint, 'data-key': f.key }).appendTo(form);
      this._inputs[f.key] = input;
    });
    this._warn = $('<p class="slx-meta-note slx-meta-warn">').hide().appendTo(this.element);
    this._links = $('<div class="slx-meta-links">').appendTo(this.element);
    this._family = $('<div class="slx-meta-read slx-meta-family">').hide().appendTo(this.element);
    this._on(this._family, {
      'click [data-member]': (e) => {
        e.preventDefault();
        const fam = this._held().family || {};
        const member = (fam.members || [])[Number($(e.currentTarget).attr('data-member'))];
        if (member) Sienna.openFamilyMember(this._ref(), member, (text) => this._familyNote.text(text).show());
      },
    });

    const shown = $('<div class="slx-meta-read slx-meta-present">').appendTo(this.element);
    $('<div class="slx-meta-read-head">').text('Default displays').appendTo(shown);
    this._present = $('<div>').appendTo(shown);
    const buttons = $('<div class="slx-meta-buttons">').appendTo(shown);
    this._useBtn = $('<button type="button">').text('Use the displays open now')
      .attr('title', 'The plots and sliders in this model’s Simulation panel, and its run settings, '
        + 'become what the model opens with')
      .appendTo(buttons);
    this._clearBtn = $('<button type="button">').text('Clear').appendTo(buttons);
    this._presentNote = $('<p class="slx-meta-note">').hide().appendTo(shown);
    this._on(this._useBtn, { click: () => this._usePresentation() });
    this._on(this._clearBtn, {
      click: () => this._action('presentation', { presentation: null }, () => Sienna.userData.remove(this._ref() + '/presentation')),
    });
    const read = $('<div class="slx-meta-read">').appendTo(this.element);
    $('<div class="slx-meta-read-head">').text('Read from the model').appendTo(read);
    this._size = $('<div>').appendTo(read);
    this._features = $('<div>').appendTo(read);

    this._on(form, {
      'change [data-key]': () => this._commit(),
      'keydown input[data-key]': (e) => { if (e.key === 'Enter') { e.preventDefault(); this._commit(); } },
    });
    this._watchModel(this._refresh);
    this._refresh();
  },

  /** The metadata as held, always an object. */
  _held() {
    const m = this._get('metadata');
    return m && typeof m === 'object' ? m : {};
  },

  /** The metadata as the fields say, empty fields left out. */
  _fromFields() {
    const typed = {};
    Object.keys(this._inputs).forEach((k) => { typed[k] = this._inputs[k].val(); });
    return Sienna.metadataForm.fromFields(typed, this._held());
  },

  _commit() {
    const now = this._fromFields();
    const was = this._held();
    if (JSON.stringify(now) === JSON.stringify(was)) return;
    this._action('edit', { metadata: now }, () => this._set('metadata', now));
  },

  /** The family: its title, then each member, this one marked, the others links. */
  _showFamily(fam) {
    const members = fam && Array.isArray(fam.members) ? fam.members : [];
    this._family.empty().toggle(members.length > 0);
    if (!members.length) return;
    $('<div class="slx-meta-read-head">').text(fam.title || 'Family').appendTo(this._family);
    const list = $('<ol class="slx-meta-family-list">').appendTo(this._family);
    members.forEach((mb, i) => {
      const li = $('<li>').appendTo(list);
      if (mb.model === fam.current) {
        li.addClass('slx-meta-family-this');
        $('<strong>').text(mb.title).appendTo(li);
        li.append(document.createTextNode(' (this model)'));
      } else {
        $('<a href="#">').attr({ 'data-member': i, title: 'Open ' + mb.title + ' in this window' })
          .text(mb.title).appendTo(li);
      }
      if (mb.summary) li.append(document.createTextNode(': ' + mb.summary));
    });
    this._familyNote = $('<p class="slx-meta-note">').hide().appendTo(this._family);
  },

  _usePresentation() {
    const snap = Sienna.presentation.snapshot(window.app, this._ref());
    if (!snap) {
      this._presentNote.text('Open a plot or the sliders in this model’s Simulation panel first.').show();
      return;
    }
    this._presentNote.hide();
    this._action('presentation', { presentation: snap }, () => this._set('presentation', snap));
  },

  _refresh() {
    if (!this._inputs) return;
    const said = Sienna.presentation.describe(this._model() || {});
    this._present.text(said ? 'Opens with ' + said : 'None: the model opens with an empty Displays area.');
    this._clearBtn.prop('disabled', !said);
    const shown = Sienna.metadataForm.toFields(this._held());
    Object.keys(shown).forEach((k) => {
      const input = this._inputs[k];
      if (input[0] !== document.activeElement && input.val() !== shown[k]) input.val(shown[k]);
    });
    const web = (u) => /^https?:\/\//i.test(u);
    const url = shown.url;
    if (shown.page && !web(shown.page)) this._warn.text('The web page should be a web address, starting https://').show();
    else if (url && !web(url)) this._warn.text('The paper’s link should be a web address, starting https://').show();
    else if (shown.citation && !url) this._warn.text('Give the paper’s link too, if it has one (its DOI address).').show();
    else this._warn.hide();
    this._links.empty();
    [[shown.page, 'The model’s web page'], [url, 'The paper']].forEach(([href, text]) => {
      if (!web(href)) return;
      $('<a target="_blank" rel="noopener">').attr({ href, title: href }).text(text + ' ↗').appendTo(this._links);
    });
    this._links.toggle(this._links.children().length > 0);
    this._showFamily(this._held().family);

    const s = Sienna.modelSummary(this._model() || {});
    this._size.text('Size: ' + s.size.join('/') + ' (' + Sienna.modelSummary.sizeInWords(s.size) + ')');
    this._features.text('Simile features: ' + (s.features.join(', ') || 'none beyond stocks, flows and variables'));
  },
});

/**
 * Open a FAMILY member (`metadata.family.members[i]`) in this window. Its
 * `file` is relative to where this model came from: the address it was
 * opened from (`openedFrom`), else its own web page (`metadata.page`, the
 * gallery's page beside which its family's files sit). With no address, a
 * member already among the user's models is opened (same id, or a page
 * ending in its name); else `say` is told which file to open.
 */
Sienna.openFamilyMember = function (ref, member, say) {
  const m = Sienna.userData.get(ref) || {};
  const base = (m.openedFrom && m.openedFrom.url) || ((m.metadata || {}).page) || '';
  if (/^https?:/i.test(base) && Sienna.openModelFromAddress) {
    let url;
    try { url = new URL(member.file, base).href; } catch (e) { url = null; }
    if (url) {
      Promise.resolve(Sienna.openModelFromAddress(url)).catch((e) => say('Could not open ' + member.title + ': ' + (e.message || e)));
      return;
    }
  }
  const slug = String(member.model || '');
  const id = slug.replace(/-/g, '_');
  const mine = (Sienna.documents.list() || []).map((d) => d.path || d).find((path) => {
    const other = Sienna.userData.get(path) || {};
    const page = String((other.metadata || {}).page || '');
    return other.id === id || (slug && page.replace(/\/$/, '').endsWith('/' + slug));
  });
  if (mine) { Sienna.documents.open(window.app, mine); return; }
  say('Open ' + member.title + ' with File ▸ Open model file… (' + slug + '.json).');
};

window.Sienna.widgetRegistry._loaded('metadata', 'metadata');
