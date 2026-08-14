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

      try {
        // ONE action: label, direct fields and props together, so a visit to
        // the dialog is a single undo step.
        d.setProperties(id, { label: label, props: props, direct: direct });
      } catch (err) {
        $dlg.find('.slx-dlg-error').remove();
        $('<p class="slx-dlg-error">').text(err.message).insertBefore($dlg.find('.slx-dlg-buttons'));
        return;                                  // the label was rejected; stay open
      }
      close();
    }

    $dlg.on('click', '[data-act=ok]', commit);
    $dlg.on('click', '[data-act=cancel]', close);
    $back.on('mousedown', function (e) { if (e.target === $back[0]) close(); });
    $(document).on('keydown.slxdlg', function (e) {
      if (e.key === 'Escape') close();
      else if (e.key === 'Enter' && e.target.tagName !== 'TEXTAREA') commit();
    });

    $dlg.find('#fld-label').focus().select();
    return { close: close, element: $dlg };
  };
})(window.Sienna, window.jQuery);
