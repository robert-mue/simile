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

  FIELDS: [
    { key: 'title', label: 'Title', hint: 'A descriptive title, e.g. “Pangolin harvest: bioeconomic drivers of extinction”' },
    { key: 'description', label: 'Description', long: true, hint: 'One to three sentences: what the model is about' },
    { key: 'keywords', label: 'Keywords', hint: 'Separated by commas' },
    { key: 'page', label: 'Web page', hint: 'The model’s page, e.g. in the model gallery: https://…' },
    { key: 'citation', label: 'Paper', long: true, hint: 'If the model is published: the full citation' },
    { key: 'url', label: 'Paper’s link', hint: 'https://doi.org/…' },
  ],

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
    const v = (k) => String(this._inputs[k].val() || '').trim();
    const out = {};
    if (v('title')) out.title = v('title');
    if (v('description')) out.description = v('description');
    const kw = v('keywords').split(',').map((s) => s.trim()).filter(Boolean);
    if (kw.length) out.keywords = kw;
    if (v('page')) out.page = v('page');
    if (v('citation') || v('url')) {
      out.paper = {};
      if (v('citation')) out.paper.citation = v('citation');
      if (v('url')) out.paper.url = v('url');
    }
    return out;
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
    const m = this._held();
    const shown = {
      title: m.title || '',
      description: m.description || '',
      keywords: Array.isArray(m.keywords) ? m.keywords.join(', ') : '',
      page: typeof m.page === 'string' ? m.page : '',
      citation: (m.paper && m.paper.citation) || '',
      url: (m.paper && m.paper.url) || '',
    };
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
