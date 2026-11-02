/**
 * The editor regression net: gestures on the real diagram widget.
 *
 * Every test starts from an empty model on the stage, does what a person does
 * — arms a tool, presses, drags, types — and checks the model spec and the
 * drawing. A gesture is a sequence of real PointerEvents dispatched where the
 * press would land: `elementFromPoint` picks the target, so what is on top
 * wins, as it does for a hand. That is the point of the page: Robert's items
 * 33 and 34 (2026-10-21) were a press on a submodel's interior landing on the
 * submodel, which no test that builds a model spec could ever have seen.
 *
 * Adding a test: push `{ name, guards, run }` onto TESTS. `run(t)` is async;
 * `t` is the toolkit below — `t.tool`, `t.click`, `t.drag`, `t.type`,
 * `t.model()`, `t.check(…)`. Each found bug should leave a test here.
 *
 * Classic script; no imports/exports.
 */
(function () {
  'use strict';

  var PATH = 'models/editor-test';
  var stage = document.getElementById('stage');

  // ---- the toolkit --------------------------------------------------------

  function emptyModel() {
    return {
      id: 'editor-test', name: 'editor test', format: Sienna.Diagram.FORMAT,
      schema: 'simile-v1', enums: {}, submodels: {}, nodes: {}, arcs: {}, layout: {},
    };
  }

  function Toolkit(inst) {
    this.inst = inst;
    this.d = new Sienna.Diagram(PATH);
    this.failures = [];
  }

  Toolkit.prototype = {
    model: function () { return Sienna.userData.get(PATH); },

    /** Diagram units → the client point where they are drawn. */
    at: function (x, y) {
      var r = this.inst._svg.getBoundingClientRect();
      var v = this.inst._view;
      return { x: r.left + v.x + x * v.k, y: r.top + v.y + y * v.k };
    },

    pointer: function (type, p, target) {
      var el = target || document.elementFromPoint(p.x, p.y) || document;
      el.dispatchEvent(new PointerEvent(type, {
        bubbles: true, cancelable: true, composed: true,
        clientX: p.x, clientY: p.y, pointerId: 1, pointerType: 'mouse',
        isPrimary: true, button: 0, buttons: type === 'pointerup' ? 0 : 1,
      }));
      return el;
    },

    /**
     * Press at the first point, move through the rest, release at the last.
     * Points are diagram units. The double-click memory is cleared first: two
     * gestures a test makes back to back are not a double-click.
     */
    drag: function (pts) {
      var self = this;
      this.inst._lastClick = null;
      var ps = pts.map(function (q) { return self.at(q[0], q[1]); });
      this.pointer('pointerdown', ps[0]);
      // Several steps per leg, as a hand moves, so a clamp sees the approach.
      for (var i = 1; i < ps.length; i++) {
        for (var s = 1; s <= 8; s++) {
          this.pointer('pointermove', {
            x: ps[i - 1].x + (ps[i].x - ps[i - 1].x) * s / 8,
            y: ps[i - 1].y + (ps[i].y - ps[i - 1].y) * s / 8,
          });
        }
      }
      this.pointer('pointerup', ps[ps.length - 1]);
    },

    /** A press and release in one place. */
    click: function (x, y) {
      this.inst._lastClick = null;
      var p = this.at(x, y);
      var el = this.pointer('pointerdown', p);
      this.pointer('pointerup', p);
      el.dispatchEvent(new MouseEvent('click', { bubbles: true, clientX: p.x, clientY: p.y }));
    },

    /** Arm a palette tool by its `data-tool` (`node:stock`, `arc:flow`, …). */
    tool: function (name) {
      var b = this.inst.element[0].querySelector('button[data-tool="' + name + '"]');
      if (!b) throw new Error('no palette button for ' + name);
      b.click();
    },

    /** Type into the open label editor and press Enter. */
    type: function (text) {
      var input = this.inst.element[0].querySelector('input.slx-label-edit');
      if (!input) throw new Error('the gesture made nothing to name (no label editor opened)');
      input.value = text;
      input.dispatchEvent(new Event('input', { bubbles: true }));
      input.dispatchEvent(new KeyboardEvent('keydown', { key: 'Enter', bubbles: true }));
    },

    /** Ids of a family (`nodes`, `arcs`, `submodels`) whose element matches. */
    find: function (family, pred) {
      var m = this.model()[family] || {};
      return Object.keys(m).filter(function (k) { return pred(m[k], k); });
    },
    node: function (label) {
      return this.find('nodes', function (n) { return n.label === label; })[0];
    },
    sub: function (label) {
      return this.find('submodels', function (s) { return s.label === label; })[0];
    },
    /** A layout box as edges: l, r, t, b. */
    box: function (id) {
      var b = this.d.box(id);
      return { l: b.cx - b.w / 2, r: b.cx + b.w / 2, t: b.cy - b.h / 2, b: b.cy + b.h / 2 };
    },

    check: function (ok, what) {
      if (!ok) this.failures.push(what);
      return ok;
    },
    near: function (a, b, what, tol) {
      return this.check(Math.abs(a - b) <= (tol == null ? 0.6 : tol),
        what + ': ' + round(a) + ', expected ' + round(b));
    },
    equal: function (a, b, what) {
      return this.check(a === b, what + ': ' + JSON.stringify(a) + ', expected ' + JSON.stringify(b));
    },

    // ---- what is on screen ----

    /**
     * Where each arc segment starts and ends, each glyph's centre and each
     * port handle, on screen — whichever element is drawing it, so a ghost
     * and the drawing after the drop can be compared.
     */
    shown: function () {
      var out = {};
      var root = this.inst._svg;
      root.querySelectorAll('path.slx-arc').forEach(function (p) {
        if (p.style.display === 'none' || !p.getAttribute('d')) return;
        var id = p.getAttribute('data-id') || p.getAttribute('data-ghost-for');
        var m = p.getScreenCTM();
        var n = p.getTotalLength();
        [0, n].forEach(function (l, k) {
          var q = p.getPointAtLength(l);
          out[id + '/' + p.getAttribute('data-segment') + (k ? '>' : '<')] =
            { x: m.a * q.x + m.c * q.y + m.e, y: m.b * q.x + m.d * q.y + m.f };
        });
      });
      root.querySelectorAll('.slx-node[data-id], .slx-submodel[data-id], [data-port]').forEach(function (g) {
        var r = g.getBoundingClientRect();
        out[g.getAttribute('data-id') || g.getAttribute('data-port')] =
          { x: r.left + r.width / 2, y: r.top + r.height / 2, w: r.width, h: r.height };
      });
      return out;
    },
    /** The ghost (from `shown`) against what the drop drew. */
    sameAs: function (ghost, drawn, what) {
      var self = this;
      var keys = Object.keys(drawn);
      this.check(keys.length === Object.keys(ghost).length,
        what + ': ghost shows ' + Object.keys(ghost).length + ' things, the drop ' + keys.length);
      keys.forEach(function (k) {
        var g = ghost[k], r = drawn[k];
        var ok = g && Math.hypot(g.x - r.x, g.y - r.y) < 0.5
          && (r.w == null || (Math.abs(g.w - r.w) < 0.5 && Math.abs(g.h - r.h) < 0.5));
        self.check(ok, what + ': ' + k + ' ghosted at ' + (g ? round(g.x) + ',' + round(g.y) : '(none)')
          + ', drawn at ' + round(r.x) + ',' + round(r.y));
      });
    },
    /**
     * Press at `from`, move to `to` in steps, paint the ghost as the next frame
     * would, and drop: the ghost must be what the drop draws. `target` is
     * pressed directly when given (a port handle, an arc's strip).
     */
    ghostDrag: function (from, to, what, target) {
      this.inst._lastClick = null;
      this.pointer('pointerdown', this.at(from[0], from[1]), target);
      for (var i = 1; i <= 4; i++) {
        this.pointer('pointermove', this.at(from[0] + (to[0] - from[0]) * i / 4, from[1] + (to[1] - from[1]) * i / 4));
      }
      var g = this.inst._ghost;
      if (!this.check(!!g, what + ': no ghost')) { this.pointer('pointerup', this.at(to[0], to[1])); return; }
      g.paint();
      var ghost = this.shown();
      this.pointer('pointerup', this.at(to[0], to[1]));
      this.check(!this.inst._ghost, what + ': the ghost outlived the drop');
      this.sameAs(ghost, this.shown(), what);
    },

    // ---- building, through the gestures ----

    /** A submodel dragged out with the tool, from (x1,y1) to (x2,y2), named. */
    submodel: function (x1, y1, x2, y2, name) {
      this.tool('submodel:submodel');
      this.drag([[x1, y1], [(x1 + x2) / 2, (y1 + y2) / 2], [x2, y2]]);
      this.type(name);
      return this.sub(name);
    },
    /** A node placed with its tool at (x,y) and named. */
    place: function (type, x, y, name) {
      this.tool('node:' + type);
      this.click(x, y);
      try { this.type(name); } catch (e) { throw new Error('placing ' + name + ': ' + e.message); }
      return this.node(name);
    },
  };

  function round(v) { return typeof v === 'number' ? Math.round(v * 100) / 100 : v; }

  // ---- the tests ------------------------------------------------------------

  var TESTS = [
    {
      name: 'place a stock',
      guards: 'arming a tool and clicking places the node where clicked, named as typed',
      run: function (t) {
        var id = t.place('stock', 100, 100, 'wealth');
        if (!t.check(!!id, 'no stock called "wealth"')) return;
        var g = t.model().layout[id];
        t.near(g.x, 100, 'x'); t.near(g.y, 100, 'y');
        t.equal(t.model().nodes[id].type, 'stock', 'type');
      },
    },
    {
      name: 'draw a submodel',
      guards: 'dragging out a box with the submodel tool makes one that size',
      run: function (t) {
        var id = t.submodel(50, 50, 250, 200, 'farmer');
        if (!t.check(!!id, 'no submodel called "farmer"')) return;
        var b = t.box(id);
        t.near(b.l, 50, 'left'); t.near(b.r, 250, 'right');
        t.near(b.t, 50, 'top'); t.near(b.b, 200, 'bottom');
      },
    },
    {
      name: 'place inside a submodel',
      guards: 'a press on a submodel\'s interior with a node tool places the node IN it',
      run: function (t) {
        var s = t.submodel(50, 50, 250, 200, 'farmer');
        var id = t.place('stock', 150, 125, 'wealth');
        if (!t.check(!!id, 'no stock placed')) return;
        t.equal(t.model().nodes[id].parent, s, 'parent');
      },
    },
    {
      name: 'flow from inside a submodel (item 33)',
      guards: 'a flow drawn from a submodel\'s empty interior to a stock in it starts at a cloud inside the submodel',
      run: function (t) {
        var s = t.submodel(50, 50, 250, 200, 'farmer');
        var stock = t.place('stock', 200, 125, 'wealth');
        t.tool('arc:flow');
        t.drag([[80, 125], [140, 125], [200, 125]]);
        t.type('income');
        var flows = t.find('arcs', function (a) { return a.type === 'flow'; });
        if (!t.check(flows.length === 1, 'flows made: ' + flows.length + ', expected 1')) return;
        var a = t.model().arcs[flows[0]];
        t.equal(a.to, stock, 'flow goes to');
        var cloud = t.model().nodes[a.from] || {};
        t.equal(cloud.type, 'cloud', 'flow comes from');
        t.equal(cloud.parent, s, 'the cloud\'s parent');
      },
    },
    {
      name: 'flow out to inside a submodel',
      guards: 'a flow drawn from a stock to empty space inside its submodel ends at a cloud inside it',
      run: function (t) {
        var s = t.submodel(50, 50, 250, 200, 'farmer');
        var stock = t.place('stock', 100, 125, 'wealth');
        t.tool('arc:flow');
        t.drag([[100, 125], [150, 125], [210, 125]]);
        t.type('spending');
        var flows = t.find('arcs', function (a) { return a.type === 'flow'; });
        if (!t.check(flows.length === 1, 'flows made: ' + flows.length + ', expected 1')) return;
        var a = t.model().arcs[flows[0]];
        t.equal(a.from, stock, 'flow comes from');
        t.equal((t.model().nodes[a.to] || {}).parent, s, 'the cloud\'s parent');
      },
    },
    {
      name: 'drag a label',
      guards: 'mid-drag only the label moves, and the drop keeps it where it was let go',
      run: function (t) {
        var id = t.place('stock', 150, 100, 'wealth');
        var label = function () { return t.inst._svg.querySelector('[data-label-for="' + id + '"]'); };
        var r0 = label().getBoundingClientRect();
        var p = { x: r0.left + r0.width / 2, y: r0.top + r0.height / 2 };
        var k = t.inst._view.k;
        t.inst._lastClick = null;
        t.pointer('pointerdown', p, label());
        t.pointer('pointermove', { x: p.x + 15 * k, y: p.y + 10 * k });
        t.pointer('pointermove', { x: p.x + 30 * k, y: p.y + 20 * k });
        var r1 = label().getBoundingClientRect();
        t.near((r1.left - r0.left) / k, 30, 'mid-drag, moved right');
        t.near((r1.top - r0.top) / k, 20, 'mid-drag, moved down');
        t.pointer('pointerup', { x: p.x + 30 * k, y: p.y + 20 * k });
        var off = t.d.labelOffset(id) || {};
        t.near(off.dx, 30, 'offset x'); t.near(off.dy, 20, 'offset y');
        var r2 = label().getBoundingClientRect();
        t.near((r2.left - r0.left) / k, 30, 'dropped, right');
        t.near((r2.top - r0.top) / k, 20, 'dropped, down');
      },
    },
    {
      name: 'a drag is ghosted, and the ghost is what the drop draws',
      guards: 'mid-drag only what moves is touched (a submodel with its contents and ports, a selection; a cut flow\'s valve and the arcs at it), and every arc end and glyph is where the drop then puts it',
      run: function (t) {
        var s = t.submodel(300, 50, 460, 220, 'patch');
        var a = t.place('stock', 350, 110, 'soil');
        var w = t.place('variable', 410, 180, 'rain');
        var b = t.place('stock', 150, 110, 'store');
        var v = t.place('variable', 180, 200, 'rate');
        var flow = t.d.addFlow({ from: a, to: b });
        var valve = flow.valve;
        t.d.addInfluence(v, valve);
        t.d.addInfluence(w, a);
        t.d.addInfluence(w, v);
        t.inst._render();

        function ghosted(id, from, to, what) {
          t.inst._lastClick = null;
          t.pointer('pointerdown', t.at(from[0], from[1]));
          for (var i = 1; i <= 4; i++) {
            t.pointer('pointermove', t.at(from[0] + (to[0] - from[0]) * i / 4, from[1] + (to[1] - from[1]) * i / 4));
          }
          var g = t.inst._ghost;
          if (!t.check(!!g, what + ': no ghost')) return;
          t.inst._ghostDraw(g);
          var ghost = t.shown();
          t.pointer('pointerup', t.at(to[0], to[1]));
          t.check(!t.inst._ghost, what + ': the ghost outlived the drop');
          t.sameAs(ghost, t.shown(), what);
        }

        // A submodel: its contents ride along, the flow out of it is cut and
        // its valve slides, and so the influence into the valve is cut too.
        ghosted(s, [440, 70], [480, 100], 'submodel');
        t.near(t.d.box(a).cx, 390, 'soil carried');
        // A selection of two, one of them feeding the valve of a cut flow.
        t.inst._sel = [b, v];
        ghosted(b, [150, 110], [120, 150], 'selection');
        t.near(t.d.box(v).cy, 240, 'rate carried');
      },
    },
    {
      name: 'resizing, a port and a bend are ghosted too',
      guards: 'a submodel resized, a port dragged along its boundary and an influence bent each redraw only what they change, and the ghost is what the drop draws',
      run: function (t) {
        var s = t.submodel(250, 50, 420, 210, 'patch');
        var a = t.place('stock', 300, 110, 'soil');
        var w = t.place('variable', 350, 170, 'rain');
        var b = t.place('stock', 120, 110, 'store');
        var v = t.place('variable', 120, 200, 'rate');
        var flow = t.d.addFlow({ from: a, to: b });
        t.d.addInfluence(v, flow.valve);
        t.d.addInfluence(w, v);
        var inner = t.d.addInfluence(w, a);
        t.inst._render();

        // Resize from the top-left corner: the box grows, and the ports on
        // its left edge (the flow and the influence leaving it) go with it.
        t.ghostDrag([251, 51], [235, 40], 'resize');
        t.near(t.box(s).l, 234, 'resized left edge');    // pressed 1 inside it

        // A port, along its edge.
        var ports = t.d.portsOn(s);
        if (t.check(ports.length > 0, 'no port on the submodel')) {
          var p = t.d.layout(ports[0]);
          var h = t.inst._svg.querySelector('[data-port="' + ports[0] + '"]');
          t.ghostDrag([p.x, p.y], [p.x, p.y + 15], 'port', h);
        }

        // A bend, by its strip at the middle of the arc.
        var strip = t.inst._svg.querySelector('path.slx-arc-hit[data-id="' + inner + '"]');
        if (t.check(!!strip, 'no strip for the inner influence')) {
          var mid = strip.getPointAtLength(strip.getTotalLength() / 2);
          t.ghostDrag([mid.x, mid.y], [mid.x + 12, mid.y - 12], 'bend', strip);
          t.check(t.d.arcBow(inner) != null, 'the bend was not kept');
        }
      },
    },
    {
      name: 'role arrows named after the base (items 34, 37)',
      guards: 'a role arrow drawn from a submodel\'s interior attaches to it, is named after it, and a second one is numbered; the line starts at the press',
      run: function (t) {
        var farmer = t.submodel(30, 50, 200, 200, 'farmer');
        var owns = t.submodel(300, 50, 450, 200, 'owns');
        t.tool('arc:role');
        // The rubber band, mid-gesture: it must start where the press was.
        t.inst._lastClick = null;
        t.pointer('pointerdown', t.at(60, 180));
        t.pointer('pointermove', t.at(200, 160));
        var rubber = t.inst.element[0].querySelector('path.slx-rubber');
        var d0 = rubber ? rubber.getAttribute('d') : '';
        var m = /^M([-\d.]+),([-\d.]+)/.exec(d0);
        t.check(!!m && Math.abs(+m[1] - 60) < 1 && Math.abs(+m[2] - 180) < 1,
          'rubber band starts at ' + (m ? round(+m[1]) + ',' + round(+m[2]) : '(none)') + ', expected 60,180');
        t.pointer('pointermove', t.at(375, 125));
        t.pointer('pointerup', t.at(375, 125));
        t.tool('arc:role');
        t.drag([[60, 80], [200, 100], [375, 110]]);
        var roles = t.find('arcs', function (a) { return a.type === 'role'; }).map(function (k) { return t.model().arcs[k]; });
        if (!t.check(roles.length === 2, 'role arrows made: ' + roles.length + ', expected 2')) return;
        t.equal(roles[0].from + '→' + roles[0].to, farmer + '→' + owns, 'first role joins');
        t.equal(roles.map(function (r) { return r.label; }).join(','), 'farmer,farmer2', 'role names');
      },
    },
    {
      name: 'an unnamed role arrow is red',
      guards: 'a role with no name makes every name across the association end in "_", so it shows as incomplete',
      run: function (t) {
        var a = t.submodel(30, 50, 200, 200, 'farmer');
        var b = t.submodel(300, 50, 450, 200, 'owns');
        t.d.addRole(a, b, { label: '' });
        t.inst._render();
        t.check(t.inst.element[0].querySelectorAll('path.slx-arc-role.slx-incomplete').length > 0,
          'no red role arrow drawn');
      },
    },
    {
      name: 'submodel name above its box',
      guards: 'the name starts at the box\'s left edge and sits above its top (a stylesheet once centred it)',
      run: function (t) {
        var s = t.submodel(50, 60, 250, 200, 'farmer');
        var text = t.inst.element[0].querySelector('text[data-label-for="' + s + '"]');
        if (!t.check(!!text, 'no name drawn')) return;
        var box = text.getBBox();
        t.near(box.x, 50, 'name\'s left edge', 1);
        t.check(box.y + box.height <= 60 + 1, 'name\'s bottom ' + round(box.y + box.height) + ' is below the top edge, 60');
      },
    },
    {
      name: 'resize by an edge',
      guards: 'dragging a submodel\'s right edge resizes it, as one undoable step',
      run: function (t) {
        var s = t.submodel(50, 50, 250, 200, 'farmer');
        // Pressed 2 inside the edge, so the edge follows the press: +70.
        t.drag([[248, 80], [280, 80], [318, 80]]);
        t.near(t.box(s).r, 320, 'right edge after the drag');
        t.near(t.box(s).l, 50, 'left edge unmoved');
        Sienna.history.undo();
        t.near(t.box(s).r, 250, 'right edge after one undo');
      },
    },
    {
      name: 'resize stops short of a node',
      guards: 'a growing edge stops 10 units (_MARGIN) short of a node outside the submodel',
      run: function (t) {
        var s = t.submodel(50, 50, 250, 200, 'farmer');
        var v = t.place('variable', 330, 80, 'price');
        var left = t.box(v).l;
        t.drag([[248, 150], [300, 150], [420, 150]]);
        t.near(t.box(s).r, left - 10, 'right edge');
      },
    },
    {
      name: 'resize cannot shrink past the contents',
      guards: 'a shrinking edge stops 4 units outside what the submodel holds',
      run: function (t) {
        var s = t.submodel(50, 50, 250, 200, 'farmer');
        var st = t.place('stock', 180, 125, 'wealth');
        var right = t.box(st).r;
        t.drag([[248, 80], [150, 80], [60, 80]]);
        t.near(t.box(s).r, right + 4, 'right edge');
      },
    },
    {
      name: 'margins inside the outer submodel',
      guards: 'an inner submodel, moved or resized, stops 10 units inside the outer one',
      run: function (t) {
        var outer = t.submodel(40, 40, 360, 260, 'region');
        var inner = t.submodel(80, 90, 180, 190, 'farm');
        t.equal(t.model().submodels[inner].parent, outer, 'inner\'s parent');
        // Move: press on the inner body, well away from its edges.
        t.drag([[130, 150], [250, 150], [500, 150]]);
        t.near(t.box(inner).r, 350, 'inner right edge after a move');
        // Resize: its bottom edge, downwards.
        var b = t.box(inner);
        t.drag([[(b.l + b.r) / 2, b.b - 2], [(b.l + b.r) / 2, 300], [(b.l + b.r) / 2, 400]]);
        t.near(t.box(inner).b, 250, 'inner bottom edge after a resize');
      },
    },
    {
      name: 'a click on an edge selects',
      guards: 'pressing a submodel\'s edge without moving selects it rather than resizing',
      run: function (t) {
        var s = t.submodel(50, 50, 250, 200, 'farmer');
        t.click(248, 120);
        t.check(t.inst._sel.indexOf(s) >= 0, 'not selected: ' + JSON.stringify(t.inst._sel));
        t.near(t.box(s).r, 250, 'right edge unmoved');
      },
    },
    {
      name: 'move a node, then undo',
      guards: 'dragging a node moves it, and one undo puts it back',
      run: function (t) {
        var id = t.place('variable', 100, 100, 'price');
        t.drag([[100, 100], [140, 120], [180, 140]]);
        t.near(t.model().layout[id].x, 180, 'x after the drag');
        t.near(t.model().layout[id].y, 140, 'y after the drag');
        Sienna.history.undo();
        t.near(t.model().layout[id].x, 100, 'x after one undo');
      },
    },
  ];

  // ---- running them ---------------------------------------------------------

  function freshDiagram() {
    stage.innerHTML = '';
    Sienna.userData.set(PATH, emptyModel());
    var el = $('<div style="flex: 1 1 auto; min-height: 0; display: flex; flex-direction: column;">').appendTo(stage);
    return Sienna.widgetRegistry.embed(el, 'diagram', { ref: PATH, tools: 'all' }).then(function (inst) {
      inst._view = { x: 0, y: 0, k: 1 };
      inst._userView = true;           // keep it there: no fitting to the content
      inst._fittedOnce = true;
      inst._applyView();
      return inst;
    });
  }

  function snapshot(inst) {
    var svg = inst._svg.cloneNode(true);
    var root = inst._root;
    var bb = root.getBBox();
    var pad = 20;
    svg.setAttribute('viewBox', [bb.x - pad, bb.y - pad, bb.width + 2 * pad, bb.height + 2 * pad].join(' '));
    svg.querySelector('g').removeAttribute('transform');
    return svg;
  }

  function row(test, failures, error, svg) {
    var tr = $('<tr>');
    $('<td class="name">').text(test.name).appendTo(tr);
    $('<td>').text(test.guards).appendTo(tr);
    var ok = !error && !failures.length;
    $('<td>').addClass(ok ? 'ok' : 'bad')
      .html(ok ? 'pass' : (error ? 'error: ' + error : failures.join('<br>'))).appendTo(tr);
    var shot = $('<td class="shot">').appendTo(tr);
    if (svg) shot.append(svg);
    $('#results tbody').append(tr);
    return ok;
  }

  function runAll() {
    var passed = 0;
    var started = Date.now();
    var chain = Promise.resolve();
    TESTS.forEach(function (test) {
      chain = chain.then(freshDiagram).then(function (inst) {
        var t = new Toolkit(inst);
        var error = null;
        return Promise.resolve().then(function () { return test.run(t); })
          .catch(function (e) { error = e.message || String(e); })
          .then(function () {
            inst._render();
            if (row(test, t.failures, error, snapshot(inst))) passed++;
          });
      });
    });
    return chain.then(function () {
      stage.classList.add('done');
      var failed = TESTS.length - passed;
      var el = document.getElementById('summary');
      el.className = failed ? 'fail' : 'pass';
      el.textContent = (failed ? '✗ ' + failed + ' of ' + TESTS.length + ' failed'
        : '✓ all ' + TESTS.length + ' editor tests pass') + ', ' + (Date.now() - started) + ' ms';
    });
  }

  Simile.ready().then(function () {
    document.getElementById('summary').textContent = 'running…';
    return Sienna.widgetRegistry.loadWidget('diagram');
  }).then(runAll).catch(function (e) {
    var el = document.getElementById('summary');
    el.className = 'fail';
    el.textContent = '✗ could not run: ' + (e.message || e);
  });
})();
