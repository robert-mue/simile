/**
 * `sienna.samples` — the SAMPLE MODELS panel: a sortable table of the model
 * gallery's models, each with an Open button (File ▸ Sample models…).
 *
 * The one panel of the app's that is about no model: it has no `ref`, so it
 * floats at the top level with the shell's own titlebar colour, and nothing
 * closes it but the user (Robert, 2026-11-15).
 *
 * What it shows comes from the gallery, read when the panel opens, so a
 * model added there appears here without a release of the app:
 * `models/index.json` names the models; each one's model spec,
 * `models/<name>/<name>.json`, carries its `metadata` (title, description,
 * keywords, paper), written by hand. Everything that CAN be read from the
 * model's structure is, never written down (Robert): its SIZE, as
 * submodels/stocks/flows/variables, and its Simile FEATURES (`summary`).
 * Open does what the gallery's own link does (`Sienna.openModelFromAddress`,
 * main.js): a copy among the user's models, or the copy they already have.
 *
 * Classic script, injected on demand by the widget registry.
 */
(function () {
  'use strict';

  /**
   * What a model's structure says about it: `size` [submodels, stocks,
   * flows, variables], and `features`, the Simile features it uses, in a
   * fixed order. Conditional, satellite and association are inferred as the
   * grammar infers them (grammar.js `kindsOf`): a condition inside, and how
   * many role arrows point in.
   */
  function summary(spec) {
    var nodes = Object.keys(spec.nodes || {}).map(function (k) { return spec.nodes[k]; });
    var arcs = Object.keys(spec.arcs || {}).map(function (k) { return spec.arcs[k]; });
    var subs = spec.submodels || {};
    var ids = Object.keys(subs);
    var count = function (type) { return nodes.filter(function (n) { return n.type === type; }).length; };
    var has = {};
    ids.forEach(function (id) {
      var s = subs[id];
      if (s.kind === 'fixed-membership') has['fixed membership'] = true;
      if (s.kind === 'population') has.population = true;
      if (s.parent) has['nested submodels'] = true;
      if (nodes.some(function (n) { return n.type === 'condition' && n.parent === id; })) has.conditional = true;
      var roles = arcs.filter(function (a) { return a.type === 'role' && a.to === id; }).length;
      if (roles === 1) has.satellite = true;
      else if (roles >= 2) has.association = true;
    });
    var events = { initialiser: 'creation', migrator: 'immigration', exterminator: 'loss', reproduction: 'reproduction' };
    Object.keys(events).forEach(function (t) { if (count(t)) has[events[t]] = true; });
    if (count('alarm')) has.alarm = true;
    var order = ['fixed membership', 'population', 'nested submodels', 'conditional', 'satellite',
      'association', 'creation', 'immigration', 'loss', 'reproduction', 'alarm'];
    return {
      size: [ids.length, count('stock'), count('valve'), count('variable')],
      features: order.filter(function (f) { return has[f]; }),
    };
  }

  var COLUMNS = [
    { key: 'title', label: 'Model', sort: function (r) { return r.title.toLowerCase(); } },
    { key: 'keywords', label: 'Keywords', sort: function (r) { return r.keywords.join(', ').toLowerCase(); } },
    { key: 'size', label: 'Size', title: 'Submodels / stocks / flows / variables. Sorted by the total.',
      sort: function (r) { return r.size.reduce(function (a, b) { return a + b; }, 0); } },
    { key: 'features', label: 'Simile features', sort: function (r) { return r.features.join(', '); } },
    { key: 'links', label: '' },
    { key: 'open', label: '' },
  ];

  $.widget('sienna.samples', {
    options: {
      // The model gallery: overridden only by a check run against a copy.
      gallery: 'https://robert-mue.github.io/model_gallery/',
    },

    _create() {
      this.element.addClass('slx-samples');
      this._sortBy = 'title';
      this._desc = false;
      this._rows = null;
      this._body = $('<div class="slx-samples-body">').appendTo(this.element);
      this._on(this._body, {
        'click th[data-sort]': (e) => this._sort($(e.currentTarget).attr('data-sort')),
        'click button[data-open]': (e) => this._open($(e.currentTarget).attr('data-open')),
        'click button[data-retry]': () => this._fetch(),
      });
      this._fetch();
    },

    /** The gallery's list of models, then each model spec; one bad one is left out, said. */
    _fetch() {
      const base = Sienna.remote.absolute(this.options.gallery);
      this._say('Fetching the sample models from the model gallery…');
      Sienna.remote.text(base + 'models/index.json').then((body) => {
        let names;
        try { names = JSON.parse(body).models; } catch (e) { names = null; }
        if (!Array.isArray(names)) throw new Error('its list of models could not be read');
        return Promise.all(names.map((name) => {
          const spec = base + 'models/' + name + '/' + name + '.json';
          return Sienna.remote.text(spec).then((t) => {
            const m = JSON.parse(t);
            const meta = m.metadata || {};
            const s = summary(m);
            return {
              name, spec, page: base + 'models/' + name + '/',
              title: meta.title || m.name || name,
              description: meta.description || '',
              keywords: Array.isArray(meta.keywords) ? meta.keywords : [],
              paper: meta.paper && meta.paper.url ? meta.paper : null,
              size: s.size, features: s.features,
            };
          }).catch(() => ({ name, failed: true }));
        }));
      }).then((rows) => {
        this._rows = rows.filter((r) => !r.failed);
        this._failed = rows.filter((r) => r.failed).map((r) => r.name);
        this._draw();
      }).catch((e) => {
        this._say('Could not fetch the sample models from the model gallery: ' + e.message + '.', true);
      });
    },

    _say(text, retry) {
      this._body.empty().append($('<p class="slx-samples-note">').text(text));
      if (retry) {
        this._body.append($('<p>').append($('<button type="button" data-retry>').text('Try again')));
      }
    },

    _sort(key) {
      if (this._sortBy === key) this._desc = !this._desc;
      else { this._sortBy = key; this._desc = false; }
      this._draw();
    },

    _draw() {
      const col = COLUMNS.find((c) => c.key === this._sortBy);
      const rows = this._rows.slice().sort((a, b) => {
        const x = col.sort(a), y = col.sort(b);
        const d = typeof x === 'number' ? x - y : String(x).localeCompare(String(y));
        return (this._desc ? -d : d) || a.title.localeCompare(b.title);
      });
      const table = $('<table class="slx-samples-table">');
      const head = $('<tr>').appendTo($('<thead>').appendTo(table));
      COLUMNS.forEach((c) => {
        const th = $('<th>').text(c.label).appendTo(head);
        if (c.title) th.attr('title', c.title);
        if (c.sort) {
          th.attr('data-sort', c.key).addClass('slx-samples-sortable');
          if (c.key === this._sortBy) th.append($('<span class="slx-samples-arrow">').text(this._desc ? ' ▾' : ' ▴'));
        }
      });
      const tbody = $('<tbody>').appendTo(table);
      rows.forEach((r) => {
        const tr = $('<tr>').appendTo(tbody);
        $('<td class="slx-samples-model">')
          .append($('<div class="slx-samples-title">').text(r.title))
          .append($('<div class="slx-samples-desc">').text(r.description))
          .appendTo(tr);
        $('<td>').text(r.keywords.join(', ')).appendTo(tr);
        $('<td class="slx-samples-size">').text(r.size.join('/'))
          .attr('title', r.size[0] + ' submodels, ' + r.size[1] + ' stocks, ' + r.size[2] + ' flows, ' + r.size[3] + ' variables')
          .appendTo(tr);
        $('<td>').text(r.features.join(', ') || '—').appendTo(tr);
        const links = $('<td class="slx-samples-links">').appendTo(tr);
        $('<a target="_blank" rel="noopener">').attr({ href: r.page, title: 'This model’s page in the model gallery' })
          .text('Gallery page').appendTo(links);
        if (r.paper) {
          $('<a target="_blank" rel="noopener">').attr({ href: r.paper.url, title: r.paper.citation || '' })
            .text('Paper').appendTo(links);
        }
        $('<td>').append($('<button type="button">').attr({ 'data-open': r.spec, title: 'Open this model as one of your models' })
          .text('Open')).appendTo(tr);
      });
      this._body.empty().append(table);
      if (this._failed.length) {
        this._body.append($('<p class="slx-samples-note">')
          .text('Not shown, as it could not be read: ' + this._failed.join(', ') + '.'));
      }
    },

    _open(spec) {
      if (Sienna.openModelFromAddress) Sienna.openModelFromAddress(spec);
    },
  });

  Sienna.samples = { summary };
  window.Sienna.widgetRegistry._loaded('samples', 'samples');
})();
