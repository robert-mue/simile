/**
 * `Sienna.propertyDialog` — the settings dialog for one diagram element —
 * and `Sienna.dialogs`, the registry that makes its BODY replaceable.
 *
 * DESIGN-diagram.md §3 splits this face of the schema in two:
 *
 *   - a **field model**, which is mandatory and is the source of truth: what
 *     properties this type has, what each is called, and what kind of value it
 *     holds (expression / text / number / boolean / choice);
 *   - a **presentation**, which is optional: a per-type renderer. Without one,
 *     a form is generated from the field model.
 *
 * The binding between the two is one rule: **any control carrying
 * `data-field="<name>"` is bound to that field**. A renderer therefore needs no
 * code of its own to save anything — it is layout and wording — and the
 * generated form uses exactly the same mechanism, so there is one code path.
 *
 * ## Why a registry rather than a field on the schema
 *
 * The presentation used to be `spec.dialog`, a FUNCTION hung on the schema's
 * type entry. That contradicted the schema's own first claim — "everything
 * below is plain data… so it stays exportable to other tools" — because a
 * function is exactly what cannot be exported. `Sienna.dialogs.register()`
 * moves the code out, leaving the schema data again, and gives a custom dialog
 * somewhere to live that is neither the schema nor this file: a script that
 * registers itself, in the manner of a widget.
 *
 * That was the whole benefit of "dialogs as widgets" (2026-08-13) without the
 * costs — panel persistence, `ref` colliding with `documents.currentPath`,
 * replay recreating dialogs, and the loss of one-visit-one-undo-step. An
 * INSPECTOR — a persistent, editable side panel following the selection — is a
 * different thing and genuinely does want to be a widget; the line between it
 * and a dialog is lifetime and modality, not inspect-versus-edit.
 *
 * ## What a renderer gets
 *
 * `renderer(ctx)` returns an HTML string, or an element. `ctx` carries the
 * element, its id and type, the field model, **the whole schema** (so a
 * renderer can build something from `schema.functions`, which is what Simile's
 * own equation dialog does with its function list), the `Diagram`, and:
 *
 *   - `ctx.value(name)`  — the current value of one field;
 *   - `ctx.field(name)`  — the STANDARD row for one field, so a custom layout
 *     can reuse the ordinary control for the parts it does not want to
 *     reinvent and hand-write only the part it does;
 *   - `ctx.fields()`     — every standard row, the generated form entire.
 *
 * Those last two are the point: before, a custom dialog had to hand-write every
 * control, which made "change one field's presentation" cost the whole form.
 *
 * ## Everything else
 *
 * Values live where the model already keeps them: `props[name]`, except for
 * fields marked `target`, which address the element itself (a submodel's
 * `kind`). The element's **label** is always offered first — it is also the
 * equation name (§14), so it belongs at the top of its own dialog.
 *
 * OK writes everything in ONE action, so a visit to the dialog is one undo
 * step. Cancel and Escape discard. Nothing here validates equations or values:
 * they are stored verbatim and never evaluated (§1, §4), and content rules are
 * deferred and reported, never blocking (§12.3). The label IS validated,
 * because a bad name is a structural problem.
 *
 * Classic script; no imports/exports.
 */
(function (Sienna, $) {
  'use strict';

  // ---- the presentation registry ---------------------------------------

  var renderers = {};

  Sienna.dialogs = {
    /**
     * Claim the dialog body for a type.
     * @param {string} key  `'variable'`, or `'simile-v1:variable'` to bind it
     *   to one notation — a qualified entry wins over a bare one, so a schema
     *   can specialise a type another schema also has.
     * @param {function} renderer  `ctx => html | element`
     */
    register: function (key, renderer) {
      if (typeof renderer !== 'function') throw new Error('a dialog renderer must be a function');
      renderers[key] = renderer;
      return renderer;
    },

    /** The renderer for a type in a notation, or null for the generated form. */
    rendererFor: function (schemaName, type) {
      return renderers[schemaName + ':' + type] || renderers[type] || null;
    },

    list: function () { return Object.keys(renderers); },

    /**
     * Report what is wrong with the element being edited, and offer a way out
     * in each direction.
     *
     * Raised by OK **before anything is written**, so the modeller has a real
     * choice: go back and fix it, or keep it as it stands. Two buttons, and the
     * distinction between them is the whole point —
     *
     *   - *Return to the equation* — nothing is saved, the property dialog is
     *     still open behind this with their text in it, and they carry on. This
     *     is the reason the check runs on a DRAFT rather than on the stored
     *     element (see `equationCheck.completeness`): reporting after the commit
     *     would mean the only route back was to re-open the dialog and find the
     *     mistake again.
     *   - *Close anyway* — commits verbatim and closes, exactly as §19.9 rules.
     *     A wrong equation is never refused; the arrows usually arrive after the
     *     equation, so "I will finish this in a minute" has to stay possible.
     *
     * So this is not a gate: every door leads somewhere, and no work is ever
     * lost through it. Modal, at Robert's call and matching what Simile does
     * here — Simile blocks on OK, which we still decline to. A popup earns
     * attention; a caption next to a field does not, and the whole problem being
     * fixed is that a signal existed and nobody saw it.
     *
     * Each finding shows its message and, where it has a position, the offending
     * stretch of the equation marked in place. `unused` never has one: it is a
     * name the equation does NOT contain, and there is no position for something
     * absent.
     *
     * @param {object} o
     * @param {Sienna.Diagram} o.diagram
     * @param {string} o.id
     * @param {object} o.draft     the element as edited (source of the excerpts)
     * @param {Array} o.findings   as `equationCheck.completeness().reasons`
     * @param {function} o.onEdit  chose to go back; nothing has been written
     * @param {function} o.onClose chose to keep it; the caller commits
     * @param {JQuery} [o.host]
     */
    problems: function (o) {
      var d = o.diagram;
      var id = o.id;
      var findings = o.findings;
      if (!findings || !findings.length) return null;
      var el = o.draft || d.get(id) || {};
      var props = el.props || {};
      var spec = specFor(d, id) || { fields: [] };

      function labelOf(name) {
        var f = (spec.fields || []).filter(function (x) { return x.name === name; })[0];
        return f ? f.label : name;
      }

      // The equation, with `len` characters from `at` marked. Clamped, because a
      // stale offset must not be able to garble the text it is explaining.
      function excerpt(f) {
        var text = String(props[f.field] == null ? '' : props[f.field]);
        if (!text || f.at == null) return '';
        var at = Math.max(0, Math.min(f.at, text.length));
        var end = Math.max(at + 1, Math.min(at + (f.len || 1), text.length));
        return '<pre class="slx-problem-code">' + esc(text.slice(0, at))
          + '<mark>' + esc(text.slice(at, end)) + '</mark>'
          + esc(text.slice(end)) + '</pre>';
      }

      var rows = findings.map(function (f) {
        var where = f.field ? '<span class="slx-problem-field">' + esc(labelOf(f.field)) + '</span>' : '';
        return '<li class="slx-problem slx-problem-' + esc(f.kind || 'other') + '">'
          + where + '<span class="slx-problem-message">' + esc(f.message) + '</span>'
          + excerpt(f) + '</li>';
      }).join('');

      var $host = o.host && o.host.length ? o.host : $('body');
      var $back = $('<div class="slx-dlg-backdrop slx-dlg-over">').appendTo($host);
      var $dlg = $(
        '<div class="slx-dlg slx-dlg-problems" role="dialog" aria-modal="true">'
        + '<h2>' + esc(el.label || id) + ' — '
        + findings.length + ' problem' + (findings.length > 1 ? 's' : '') + '</h2>'
        + '<ul class="slx-problem-list">' + rows + '</ul>'
        + '<p class="slx-dlg-note">Nothing has been saved yet. '
        + 'You can go back and fix these, or keep the element as it is — '
        + 'it will stay marked until they are resolved.</p>'
        + '<div class="slx-dlg-buttons">'
        + '<button type="button" data-act="close">Close anyway</button>'
        + '<button type="button" data-act="edit">Return to the equation</button>'
        + '</div></div>'
      ).appendTo($back);

      var done = false;
      function finish(fn) {
        if (done) return;                  // one answer only, whatever the route
        done = true;
        $(document).off('keydown.slxproblems');
        $back.remove();
        if (typeof fn === 'function') fn();
      }
      $dlg.on('click', '[data-act=edit]', function () { finish(o.onEdit); });
      $dlg.on('click', '[data-act=close]', function () { finish(o.onClose); });
      // Dismissing without choosing means going back to the equation: it is the
      // option that discards nothing, so it is the safe reading of a stray click
      // or an Escape.
      $back.on('mousedown', function (e) { if (e.target === $back[0]) finish(o.onEdit); });
      $(document).on('keydown.slxproblems', function (e) {
        if (e.key === 'Escape') { e.preventDefault(); finish(o.onEdit); }
        else if (e.key === 'Enter') { e.preventDefault(); finish(o.onEdit); }
      });
      $dlg.find('[data-act=edit]').focus();
      return { close: function () { finish(null); }, element: $dlg };
    },
  };

  function esc(s) {
    return String(s == null ? '' : s).replace(/[&<>"']/g, function (c) {
      return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c];
    });
  }

  /** The field model for an element: whatever the schema says about its type. */
  function specFor(d, id) {
    var el = d.get(id);
    if (!el) return null;
    var schema = d.schema();
    if (String(id).indexOf('submodel') === 0) {
      return schema.submodel || { has_label: true, fields: [] };
    }
    return schema.nodes[el.type] || { has_label: true, fields: [] };
  }

  /** Current value of one field, from the element. */
  function readValue(el, f) {
    var v = f.target ? el[f.target] : (el.props || {})[f.name];
    return v == null ? '' : v;
  }

  /** One row of the generated form. A renderer can reuse these via `ctx.field`. */
  function fieldHtml(f, value) {
    var id = 'fld-' + f.name;
    var control;
    if (f.type === 'choice') {
      control = '<select id="' + id + '" data-field="' + esc(f.name) + '">'
        + (f.options || []).map(function (o) {
          var sel = String(o.value) === String(value) ? ' selected' : '';
          return '<option value="' + esc(o.value) + '"' + sel + '>' + esc(o.label || o.value) + '</option>';
        }).join('')
        + '</select>';
    } else if (f.type === 'boolean') {
      control = '<input type="checkbox" id="' + id + '" data-field="' + esc(f.name) + '"'
        + (value ? ' checked' : '') + '>';
    } else if (f.type === 'number') {
      control = '<input type="number" id="' + id + '" data-field="' + esc(f.name) + '" value="' + esc(value) + '">';
    } else if (f.type === 'expression' || f.type === 'expression-list') {
      // Expressions can be long and are stored verbatim, so give them room. A
      // LIST of them is edited the same way — it is one piece of text with
      // commas in it, which is also how Simile stores a multi-dimensional
      // membership; the field's `help` says so.
      control = '<textarea id="' + id + '" rows="2" data-field="' + esc(f.name) + '">' + esc(value) + '</textarea>';
    } else {
      control = '<input type="text" id="' + id + '" data-field="' + esc(f.name) + '" value="' + esc(value) + '">';
    }
    return '<div class="slx-dlg-row">'
      + '<label for="' + id + '">' + esc(f.label || f.name) + '</label>'
      + control
      + (f.help ? '<p class="slx-dlg-help">' + esc(f.help) + '</p>' : '')
      + '</div>';
  }

  /**
   * Open the dialog for one element.
   * @param {object} d   a Sienna.Diagram
   * @param {string} id  element id
   * @param {jQuery} [host] element to overlay (defaults to the document body)
   */
  Sienna.propertyDialog = function (d, id, host) {
    var el = d.get(id);
    if (!el) return null;
    var spec = specFor(d, id);
    var fields = spec.fields || [];
    var typeName = String(id).indexOf('submodel') === 0 ? 'submodel' : el.type;

    // The standard row for one field, by name — what a custom renderer reuses
    // for the parts it does not want to reinvent.
    function rowFor(name) {
      var f = fields.filter(function (x) { return x.name === name; })[0];
      return f ? fieldHtml(f, readValue(el, f)) : '';
    }
    function allRows() {
      return fields.map(function (f) { return fieldHtml(f, readValue(el, f)); }).join('');
    }

    var schema = d.schema();
    var renderer = Sienna.dialogs.rendererFor(schema.name, typeName);
    var body = renderer
      ? renderer({
        element: el,
        id: id,
        type: typeName,
        spec: spec,
        schema: schema,          // e.g. `schema.functions` for a function list
        diagram: d,
        value: function (n) { return readValue(el, { name: n }); },
        field: rowFor,
        fields: allRows,
      })
      : allRows();

    var $host = host && host.length ? host : $('body');
    $host.find('.slx-dlg-backdrop').remove();

    var $back = $('<div class="slx-dlg-backdrop">').appendTo($host);
    var $dlg = $(
      '<div class="slx-dlg" role="dialog" aria-modal="true">'
      + '<h2>' + esc(typeName) + '</h2>'
      + '<div class="slx-dlg-row"><label for="fld-label">Name</label>'
      + '<input type="text" id="fld-label" data-field=":label" value="' + esc(el.label || '') + '"></div>'
      + '<div class="slx-dlg-fields"></div>'
      + '<div class="slx-dlg-buttons">'
      + '<button type="button" data-act="cancel">Cancel</button>'
      + '<button type="button" data-act="ok">OK</button>'
      + '</div></div>'
    ).appendTo($back);
    $dlg.find('.slx-dlg-fields').html(body);   // a string or an element; jQuery takes either

    function close() {
      $(document).off('keydown.slxdlg');
      $back.remove();
    }

    function commit() {
      var label = $dlg.find('[data-field=":label"]').val();
      var props = {};
      var direct = {};
      $dlg.find('[data-field]').each(function () {
        var name = $(this).attr('data-field');
        if (name === ':label') return;
        var f = fields.filter(function (x) { return x.name === name; })[0] || { name: name };
        var v = this.type === 'checkbox' ? this.checked : $(this).val();
        if (f.target) direct[f.target] = v;
        else props[name] = v;
      });

      function reject(message) {
        $dlg.find('.slx-dlg-error').remove();
        $('<p class="slx-dlg-error">').text(message).insertBefore($dlg.find('.slx-dlg-buttons'));
      }

      // ONE action: label, direct fields and props together, so a visit to the
      // dialog is a single undo step — including a visit that went round by way
      // of the problem report, since nothing is written until the end.
      function write() {
        try {
          d.setProperties(id, { label: label, props: props, direct: direct });
        } catch (err) {
          reject(err.message);
          return false;                            // the label was rejected; stay open
        }
        close();
        return true;
      }

      // The LABEL is checked first and on its own, because it is structural: a
      // bad name breaks other elements' equations and is refused outright
      // (§12.3, §19.9). Doing it before the equation report also stops the
      // report offering "close anyway" on a change that cannot be saved at all.
      try {
        d.checkLabel(label);
        d.checkSiblingName(id, label);
      } catch (err) {
        reject(err.message);
        return;
      }

      // Then the equations — on a DRAFT, before writing, so "return to the
      // equation" is a real option and not a re-opening. §19.9 stands: the
      // report cannot refuse the edit, only ask.
      if (Sienna.equationCheck) {
        var draft = $.extend({}, el, direct, { label: label, props: $.extend({}, el.props, props) });
        var verdict = Sienna.equationCheck.completeness(d, id, draft);
        if (!verdict.complete) {
          Sienna.dialogs.problems({
            diagram: d, id: id, draft: draft, findings: verdict.reasons, host: host,
            onEdit: function () { $dlg.find('[data-field]').first().focus(); },
            onClose: write,
          });
          return;
        }
      }

      write();
    }

    $dlg.on('click', '[data-act=ok]', commit);
    $dlg.on('click', '[data-act=cancel]', close);
    $back.on('mousedown', function (e) { if (e.target === $back[0]) close(); });
    $(document).on('keydown.slxdlg', function (e) {
      // The problem report is modal OVER this dialog and owns the keyboard while
      // it is up. Without this, Escape would close the dialog underneath it and
      // lose the very text the report is asking about, and Enter would commit
      // the edit the modeller is still being asked about.
      if ($host.find('.slx-dlg-problems').length) return;
      if (e.key === 'Escape') close();
      else if (e.key === 'Enter' && e.target.tagName !== 'TEXTAREA') commit();
    });

    $dlg.find('#fld-label').focus().select();
    return { close: close, element: $dlg };
  };
})(window.Sienna, window.jQuery);
