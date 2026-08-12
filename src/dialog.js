/**
 * `Sienna.propertyDialog` — the settings dialog for one diagram element.
 *
 * DESIGN-diagram.md §3 splits this face of the schema in two:
 *
 *   - a **field model**, which is mandatory and is the source of truth: what
 *     properties this type has, what each is called, and what kind of value it
 *     holds (expression / text / number / boolean / choice);
 *   - a **presentation**, which is optional: a per-type HTML template. Without
 *     one, a form is generated from the field model.
 *
 * The binding between the two is one rule: **any control carrying
 * `data-field="<name>"` is bound to that field**. A template therefore needs no
 * code of its own — it is layout and wording only — and the generated form uses
 * exactly the same mechanism, so there is one code path rather than two.
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

  /** One row of the generated form. Templates may replace this wholesale. */
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

    var body;
    if (typeof spec.dialog === 'function') {
      // A per-type template: layout and wording only. It is bound by the same
      // data-field rule as the generated form.
      body = spec.dialog({ element: el, id: id, value: function (n) { return readValue(el, { name: n }); } });
    } else {
      body = fields.map(function (f) { return fieldHtml(f, readValue(el, f)); }).join('');
    }

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
    $dlg.find('.slx-dlg-fields').html(body);

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
