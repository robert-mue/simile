/**
 * An example of an ADDED display widget for simile (Widgets ▸ Add a widget…):
 * one variable of the running model, shown large.
 *
 * Written (2026-10-24) from the brief for an AI assistant ALONE — Widgets ▸
 * Instructions for an AI assistant…, i.e. sienna's `widget-brief.js` plus
 * `src/widget-brief-simile.js` — as a check that the brief is enough. If a
 * change to `Simulation.forWidget` breaks this file, the brief is out of date
 * too: fix both.
 */
Sienna.widget({
  name: 'bigNumber',
  label: 'Big number',
  title: 'Big number',
  notes: 'Shows one variable of the running model as a large number.',
  author: 'simile examples', version: '1.0',
  contract: 1,
  role: 'display',
  options: { variable: '', digits: 3 },
  widget: {
    options: { variable: '', digits: 3 },

    _create: function () {
      this._sim = Sienna.Simulation.forWidget(this._ref());
      this._owner = (this._panelId() || 'w' + Math.random().toString(36).slice(2)) + ':';
      this._id = null;
      this._bar = $('<div class="slx-chrome bigNumber-bar">').appendTo(this.element);
      this._pick = $('<select>').appendTo(this._bar).on('change', () => {
        const c = this._list.find((x) => x.id === this._pick.val());
        this.options.variable = c ? c.label : '';
        this._bind();
      });
      this._num = $('<div class="bigNumber-num">').css({ fontSize: '40px', fontWeight: 600, textAlign: 'center', marginTop: '10px' }).appendTo(this.element);
      this._time = $('<div class="bigNumber-time">').css({ textAlign: 'center', color: '#666' }).appendTo(this.element);
      this._off = this._sim.subscribe((e) => this._onEvent(e));
      this._sync();
    },

    _sync: function () {
      this._list = this._sim.scalarComponents();
      this._pick.empty();
      $('<option>').val('').text(this._list.length ? 'choose…' : '(no model loaded)').appendTo(this._pick);
      this._list.forEach((c) => $('<option>').val(c.id).text(c.label).appendTo(this._pick));
      const c = this._list.find((x) => x.label === this.options.variable);
      this._pick.val(c ? c.id : '');
      this._bind();
    },

    _bind: function () {
      this._id = this._pick.val() || null;
      if (this._id) {
        this._sim.addTarget(this._owner + 'value', this._id);
        this._sim.query([this._id]).then((v) => this._show(v[this._id]), () => {});
      } else {
        this._sim.removeTarget(this._owner + 'value');
        this._show(null);
      }
    },

    _show: function (v, t) {
      this._num.text(typeof v === 'number' ? Number(v.toPrecision(this.options.digits)) : (this._sim.base ? '–' : 'Run the model to see values'));
      if (t != null) this._time.text('t = ' + t + ' ' + this._sim.unitName);
    },

    _onEvent: function (e) {
      if (e.type === 'describe') this._sync();
      else if (e.type === 'data' && this._id) this._show(e.values[this._id], e.time);
      else if (e.type === 'status' && !this._sim.base) this._sync();
    },

    state: function () { return { variable: this.options.variable }; },

    _destroy: function () {
      this._off();
      this._sim.removeTarget(this._owner + 'value');
    },
  },
});
