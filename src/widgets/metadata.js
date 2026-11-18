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
    return Sienna.metadataForm.fromFields(typed);
  },

  _commit() {
    const now = this._fromFields();
    const was = this._held();
    if (JSON.stringify(now) === JSON.stringify(was)) return;
    this._action('edit', { metadata: now }, () => this._set('metadata', now));
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

    const s = Sienna.modelSummary(this._model() || {});
    this._size.text('Size: ' + s.size.join('/') + ' (' + Sienna.modelSummary.sizeInWords(s.size) + ')');
    this._features.text('Simile features: ' + (s.features.join(', ') || 'none beyond stocks, flows and variables'));
  },
});

window.Sienna.widgetRegistry._loaded('metadata', 'metadata');
