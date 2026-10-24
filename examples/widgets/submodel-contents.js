/**
 * An example of an ADDED widget for simile (Widgets ▸ Add a widget…): for
 * each submodel, its stocks, flows and variables, grouped, with each one's
 * name and equation; read only, following edits as they happen.
 *
 * Written (2026-10-25) by Claude, in a chat, from the instructions for an AI
 * assistant (Widgets ▸ Instructions for an AI assistant…) and this request,
 * Robert's, word for word:
 *
 *   "I would like a widget that displays, for each submodel, the stocks,
 *    flows and variables in the submodel, grouped, listing their name and
 *    equation."
 *
 * It worked first time. Unchanged from what Claude gave, apart
 * from this comment. Unlike big-number.js it reads the MODEL SPEC
 * (`this._model()`, `this._watchModel`), not the running model.
 */
Sienna.widget({
  name: 'submodelContents',
  label: 'Submodel contents',
  title: 'Submodel contents',
  notes: 'Lists, for each submodel, its stocks, flows and variables, grouped, with each one\'s name and equation. Read only.',
  author: 'Claude',
  version: '1.0',
  contract: 1,
  options: { collapsed: [], filter: '' },
  widget: {
    options: { collapsed: [], filter: '' },

    _create: function () {
      var self = this;
      this._addStyle();
      this._collapsed = new Set(Array.isArray(this.options.collapsed) ? this.options.collapsed : []);
      this._known = [];

      this.element.addClass('submodelContents-root');

      var bar = $('<div class="slx-chrome submodelContents-bar"></div>').appendTo(this.element);
      this._filterBox = $('<input type="search" class="submodelContents-filter" placeholder="Filter by name or equation">')
        .val(this.options.filter || '')
        .appendTo(bar)
        .on('input', function () {
          self.options.filter = this.value;
          self._render();
        });
      $('<button type="button" class="submodelContents-btn">Expand all</button>')
        .appendTo(bar)
        .on('click', function () {
          self._collapsed.clear();
          self._render();
        });
      $('<button type="button" class="submodelContents-btn">Collapse all</button>')
        .appendTo(bar)
        .on('click', function () {
          self._known.forEach(function (k) { self._collapsed.add(k); });
          self._render();
        });

      this._bar = bar;
      this._body = $('<div class="submodelContents-body"></div>').appendTo(this.element);

      this._watchPanelResize(function () { self._fit(); });
      this._watchModel(function () { self._render(); });
      this._render();
      this._fit();
    },

    _destroy: function () {
      this.element.removeClass('submodelContents-root').empty();
    },

    state: function () {
      return {
        collapsed: Array.from(this._collapsed),
        filter: this.options.filter || ''
      };
    },

    _fit: function () {
      var h = this.element.height() - (this._bar.is(':visible') ? this._bar.outerHeight(true) : 0);
      this._body.css('height', Math.max(0, h) + 'px');
    },

    _addStyle: function () {
      if (document.getElementById('submodelContents-style')) return;
      var css = [
        '.submodelContents-root { box-sizing: border-box; font-size: 13px; }',
        '.submodelContents-bar { display: flex; gap: 6px; align-items: center; padding: 4px 6px; border-bottom: 1px solid rgba(128,128,128,0.35); }',
        '.submodelContents-filter { flex: 1; min-width: 60px; padding: 2px 6px; font: inherit; }',
        '.submodelContents-btn { font: inherit; padding: 2px 8px; cursor: pointer; }',
        '.submodelContents-body { overflow: auto; padding: 4px 8px 8px; box-sizing: border-box; }',
        '.submodelContents-msg { padding: 12px; opacity: 0.7; }',
        '.submodelContents-section { margin: 6px 0; border: 1px solid rgba(128,128,128,0.3); border-radius: 4px; }',
        '.submodelContents-head { display: flex; gap: 8px; align-items: baseline; padding: 4px 8px; cursor: pointer; background: rgba(128,128,128,0.12); user-select: none; }',
        '.submodelContents-arrow { display: inline-block; width: 1em; }',
        '.submodelContents-name { font-weight: 600; }',
        '.submodelContents-kind { font-size: 11px; opacity: 0.7; }',
        '.submodelContents-count { margin-left: auto; font-size: 11px; opacity: 0.7; }',
        '.submodelContents-content { padding: 2px 8px 6px; }',
        '.submodelContents-group { margin-top: 6px; }',
        '.submodelContents-gtitle { font-size: 11px; text-transform: uppercase; letter-spacing: 0.04em; opacity: 0.75; margin-bottom: 2px; }',
        '.submodelContents-row { display: grid; grid-template-columns: minmax(90px, 30%) 1fr auto; gap: 8px; padding: 2px 0; border-top: 1px solid rgba(128,128,128,0.15); }',
        '.submodelContents-label { font-weight: 500; word-break: break-word; }',
        '.submodelContents-eq { font-family: Consolas, Menlo, monospace; white-space: pre-wrap; word-break: break-word; }',
        '.submodelContents-none { opacity: 0.5; font-style: italic; }',
        '.submodelContents-units { font-size: 11px; opacity: 0.7; white-space: nowrap; }',
        '.submodelContents-empty { opacity: 0.6; font-style: italic; padding-top: 4px; }'
      ].join('\n');
      $('<style id="submodelContents-style"></style>').text(css).appendTo(document.head);
    },

    _render: function () {
      var self = this;
      var body = this._body.empty();
      var spec = this._model();

      if (!spec || !spec.nodes) {
        $('<div class="submodelContents-msg"></div>').text('No model is open in this panel.').appendTo(body);
        return;
      }

      var nodes = spec.nodes || {};
      var subs = spec.submodels || {};
      var filter = String(this.options.filter || '').trim().toLowerCase();

      var GROUPS = [
        { type: 'stock', title: 'Stocks', field: 'initial', what: 'initial value' },
        { type: 'valve', title: 'Flows', field: 'rate', what: 'rate' },
        { type: 'variable', title: 'Variables', field: 'value', what: 'equation' }
      ];

      // Collect stocks, flows and variables by the submodel they are in ('' = top level).
      var bySub = {};
      Object.keys(nodes).forEach(function (id) {
        var n = nodes[id];
        if (!n || (n.type !== 'stock' && n.type !== 'valve' && n.type !== 'variable')) return;
        var p = (n.parent && subs[n.parent]) ? n.parent : '';
        var g = bySub[p] || (bySub[p] = { stock: [], valve: [], variable: [] });
        g[n.type].push(n);
      });

      // Submodel tree, children sorted by label.
      var children = {};
      Object.keys(subs).forEach(function (id) {
        var s = subs[id] || {};
        var p = (s.parent && subs[s.parent]) ? s.parent : '';
        (children[p] || (children[p] = [])).push(id);
      });
      var byLabel = function (a, b) {
        return String((subs[a] || {}).label || a).localeCompare(String((subs[b] || {}).label || b));
      };
      Object.keys(children).forEach(function (k) { children[k].sort(byLabel); });

      // Depth-first order: top level first, then each submodel under its parent.
      var order = [{ id: '', path: '', depth: 0 }];
      var seen = {};
      (function walk(parentId, parentPath, depth) {
        (children[parentId] || []).forEach(function (id) {
          if (seen[id]) return;
          seen[id] = true;
          var label = String((subs[id] || {}).label || id);
          var path = parentPath ? parentPath + '/' + label : label;
          order.push({ id: id, path: path, depth: depth });
          walk(id, path, depth + 1);
        });
      })('', '', 1);

      this._known = order.map(function (o) { return o.id === '' ? '(top)' : o.path; });

      var matches = function (n, field) {
        if (!filter) return true;
        var eq = (n.props && n.props[field] != null) ? String(n.props[field]) : '';
        return String(n.label || '').toLowerCase().indexOf(filter) >= 0 ||
               eq.toLowerCase().indexOf(filter) >= 0;
      };

      var shown = 0;
      order.forEach(function (o) {
        var g = bySub[o.id] || { stock: [], valve: [], variable: [] };
        var lists = GROUPS.map(function (G) {
          return {
            G: G,
            items: g[G.type]
              .filter(function (n) { return matches(n, G.field); })
              .sort(function (a, b) { return String(a.label || '').localeCompare(String(b.label || '')); })
          };
        });
        var total = lists.reduce(function (s, l) { return s + l.items.length; }, 0);
        if (filter && total === 0) return;
        shown++;

        var key = o.id === '' ? '(top)' : o.path;
        var collapsed = self._collapsed.has(key);
        var section = $('<div class="submodelContents-section"></div>')
          .css('margin-left', (o.depth * 14) + 'px')
          .appendTo(body);

        var head = $('<div class="submodelContents-head"></div>').appendTo(section);
        $('<span class="submodelContents-arrow"></span>').text(collapsed ? '\u25B8' : '\u25BE').appendTo(head);
        $('<span class="submodelContents-name"></span>')
          .text(o.id === '' ? 'Top level' + (spec.name ? ' \u2014 ' + spec.name : '') : o.path)
          .appendTo(head);
        if (o.id !== '') {
          var s = subs[o.id] || {};
          var kind = s.kind || 'single';
          if (kind === 'fixed-membership' && s.props && s.props.dimensions != null) {
            kind += ' \u00D7 ' + s.props.dimensions;
          }
          $('<span class="submodelContents-kind"></span>').text(kind).appendTo(head);
        }
        $('<span class="submodelContents-count"></span>')
          .text(lists.map(function (l) { return l.items.length + ' ' + l.G.title.toLowerCase(); }).join(', '))
          .appendTo(head);

        head.on('click', function () {
          if (self._collapsed.has(key)) self._collapsed.delete(key);
          else self._collapsed.add(key);
          self._render();
        });

        if (collapsed) return;
        var content = $('<div class="submodelContents-content"></div>').appendTo(section);

        if (total === 0) {
          $('<div class="submodelContents-empty"></div>').text('No stocks, flows or variables.').appendTo(content);
          return;
        }

        lists.forEach(function (l) {
          if (!l.items.length) return;
          var grp = $('<div class="submodelContents-group"></div>').appendTo(content);
          $('<div class="submodelContents-gtitle"></div>').text(l.G.title + ' (' + l.items.length + ')').appendTo(grp);
          l.items.forEach(function (n) {
            var props = n.props || {};
            var row = $('<div class="submodelContents-row"></div>').appendTo(grp);
            $('<div class="submodelContents-label"></div>').text(n.label || '(unnamed)').appendTo(row);
            var eq = props[l.G.field];
            var eqCell = $('<div class="submodelContents-eq"></div>').appendTo(row);
            if (eq == null || String(eq).trim() === '') {
              eqCell.addClass('submodelContents-none').text('no ' + l.G.what);
            } else {
              eqCell.text(String(eq)).attr('title', l.G.what);
            }
            $('<div class="submodelContents-units"></div>').text(props.units ? String(props.units) : '').appendTo(row);
          });
        });
      });

      if (shown === 0) {
        $('<div class="submodelContents-msg"></div>')
          .text(filter ? 'Nothing matches \u201C' + this.options.filter + '\u201D.' : 'The model has no stocks, flows or variables yet.')
          .appendTo(body);
      }
    }
  }
});