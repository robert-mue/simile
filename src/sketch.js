/**
 * `Sienna.sketch` — the **sketched graph**: a relationship drawn by hand and
 * used in an equation as `graph(x)`. The data shape is the schema's (see
 * `SKETCH` in `src/schema/simile-v1.js`); this file is the graph pad that edits
 * it, on the properties dialog's Graph tab, and the arithmetic that reads it.
 *
 * Simile's own graph pad, as its help describes it and as the Predator-prey
 * tutorial uses it: a fixed number of points evenly spaced along X, joined by
 * straight lines, each dragged up or down with the mouse — sweeping across the
 * pad redraws every point it passes. Min and max for each axis; the number of
 * points doubled or halved; what happens beyond the ends (truncate,
 * extrapolate, wraparound) and between points (interpolate, round). A new
 * graph is a flat line through the middle, with 21 points, as Simile's is.
 *
 * Classic script; no imports/exports.
 */
(function (Sienna, $) {
  'use strict';

  var NS = 'http://www.w3.org/2000/svg';
  var W = 480;              // the pad's own coordinate space; CSS scales it
  var H = 240;
  var MIN_SEGMENTS = 2;
  var MAX_SEGMENTS = 160;

  var OUTSIDE = [
    ['truncate', 'Truncate', 'Flat beyond each end'],
    ['extrapolate', 'Extrapolate', 'Carry on along the first and last segments'],
    ['wraparound', 'Wraparound', 'Repeat — for a cycle such as a day or a year'],
  ];
  var BETWEEN = [
    ['interpolate', 'Interpolate', 'A straight line between points'],
    ['round', 'Round', 'The value at the nearest point: steps'],
  ];

  function defaults() {
    var points = [];
    for (var i = 0; i < 21; i++) points.push(0.5);
    return { xmin: 0, xmax: 100, ymin: 0, ymax: 100, points: points,
      outside: 'truncate', between: 'interpolate' };
  }

  /** A complete, sane copy of a stored graph — or the default for none. */
  function normalise(g) {
    var d = defaults();
    if (!g || typeof g !== 'object') return d;
    var out = {
      xmin: num(g.xmin, d.xmin), xmax: num(g.xmax, d.xmax),
      ymin: num(g.ymin, d.ymin), ymax: num(g.ymax, d.ymax),
      points: Array.isArray(g.points) && g.points.length >= 2
        ? g.points.map(function (f) { return clamp01(num(f, 0.5)); }) : d.points,
      outside: OUTSIDE.some(function (o) { return o[0] === g.outside; }) ? g.outside : d.outside,
      between: BETWEEN.some(function (o) { return o[0] === g.between; }) ? g.between : d.between,
    };
    if (!(out.xmax > out.xmin)) { out.xmin = d.xmin; out.xmax = d.xmax; }
    if (!(out.ymax > out.ymin)) { out.ymin = d.ymin; out.ymax = d.ymax; }
    return out;
  }

  function num(v, dflt) {
    var n = Number(v);
    return isFinite(n) && v !== '' && v != null ? n : dflt;
  }

  function clamp01(f) { return Math.max(0, Math.min(1, f)); }

  /** The curve's height (as a fraction) at fractional position `u` along X. */
  function shapeAt(points, u) {
    var n = points.length - 1;
    var p = Math.max(0, Math.min(n, u * n));
    var i = Math.min(n - 1, Math.floor(p));
    return points[i] + (points[i + 1] - points[i]) * (p - i);
  }

  /** The same curve with `count` points, sampled from the old one. */
  function resample(points, count) {
    var out = [];
    for (var i = 0; i < count; i++) out.push(shapeAt(points, i / (count - 1)));
    return out;
  }

  /**
   * `graph(x)` — what the engine returns, as measured against SimiLive
   * (2026-10-13): linear interpolation, or the nearest point when rounding
   * (a tie goes up); beyond the ends, the end value, the end segments carried
   * on, or the curve repeated with period xmax − xmin. Rounding takes
   * precedence over extrapolation, as it does in the engine.
   */
  function evaluate(g, x) {
    g = normalise(g);
    var span = g.xmax - g.xmin;
    var n = g.points.length - 1;
    var u = (x - g.xmin) / span;
    if (g.outside === 'wraparound') u = u - Math.floor(u);
    var y;
    if (g.between === 'round') {
      var k = Math.max(0, Math.min(n, Math.floor(u * n + 0.5)));
      y = g.points[k];
    } else if (g.outside === 'extrapolate' && (u < 0 || u > 1)) {
      var a = u < 0 ? 0 : n - 1;
      var slope = (g.points[a + 1] - g.points[a]) * n;   // per unit of u
      y = g.points[u < 0 ? 0 : n] + slope * (u < 0 ? u : u - 1);
    } else {
      y = shapeAt(g.points, Math.max(0, Math.min(1, u)));
    }
    return g.ymin + y * (g.ymax - g.ymin);
  }

  /** Numbers as a person would type them: no float noise. */
  function show(v) {
    var n = Number(v);
    if (!isFinite(n)) return '';
    return String(Number(n.toPrecision(6)));
  }

  function el(name, attrs) {
    var e = document.createElementNS(NS, name);
    Object.keys(attrs || {}).forEach(function (k) { e.setAttribute(k, attrs[k]); });
    return e;
  }

  /**
   * The graph pad, built into `host`. `value` is a stored graph or nothing.
   * Returns `{ value(), touched() }`: the graph as it now stands, and whether
   * the modeller changed anything — a dialog visited without drawing must not
   * give an element a graph it never asked for.
   */
  function pad(host, value, opts) {
    opts = opts || {};
    var g = normalise(value);
    var touched = false;
    var $host = $(host).empty().addClass('slx-sketch');

    function changed() {
      touched = true;
      if (opts.onChange) opts.onChange(g);
    }

    // ---- the axes' limits: Y beside the pad, X beneath it ---------------
    function axisInput(key, title) {
      return $('<input type="text" class="slx-sketch-lim">')
        .attr({ 'data-lim': key, title: title, 'aria-label': title })
        .val(show(g[key]));
    }
    var $ymax = axisInput('ymax', 'Y max');
    var $ymin = axisInput('ymin', 'Y min');
    var $xmin = axisInput('xmin', 'X min');
    var $xmax = axisInput('xmax', 'X max');

    var $row = $('<div class="slx-sketch-row">').appendTo($host);
    $('<div class="slx-sketch-yaxis">').append($ymax, $('<span class="slx-sketch-axis-name">').text('Y'), $ymin)
      .appendTo($row);
    var $padBox = $('<div class="slx-sketch-pad">').appendTo($row);
    $('<div class="slx-sketch-xaxis">').append($xmin, $('<span class="slx-sketch-axis-name">').text('X'), $xmax)
      .appendTo($host);

    var svg = el('svg', { viewBox: '0 0 ' + W + ' ' + H, preserveAspectRatio: 'none',
      class: 'slx-sketch-svg', role: 'img', 'aria-label': 'Sketched graph: drag to draw' });
    $padBox[0].appendChild(svg);
    var gridG = el('g', { class: 'slx-sketch-grid' });
    var midLine = el('line', { class: 'slx-sketch-mid', x1: 0, x2: W, y1: H / 2, y2: H / 2 });
    var line = el('polyline', { class: 'slx-sketch-line' });
    var dotsG = el('g', { class: 'slx-sketch-dots' });
    svg.appendChild(gridG);
    svg.appendChild(midLine);
    svg.appendChild(line);
    svg.appendChild(dotsG);

    var $readout = $('<div class="slx-sketch-readout">').appendTo($host);

    // ---- the options ------------------------------------------------------
    var $opts = $('<div class="slx-sketch-opts">').appendTo($host);
    var $count = $('<span class="slx-sketch-count">');
    var $fewer = $('<button type="button" class="slx-sketch-fewer" title="Halve the number of segments">fewer</button>');
    var $more = $('<button type="button" class="slx-sketch-more" title="Double the number of segments">more</button>');
    $('<span class="slx-sketch-opt">').append($('<label>').text('Points'), $count, $fewer, $more).appendTo($opts);

    function choice(label, key, list) {
      var $s = $('<select>').attr('data-opt', key);
      list.forEach(function (o) {
        $('<option>').val(o[0]).text(o[1]).attr('title', o[2]).appendTo($s);
      });
      $s.val(g[key]);
      $('<span class="slx-sketch-opt">').append($('<label>').text(label), $s).appendTo($opts);
      $s.on('change', function () { g[key] = $s.val(); changed(); });
      return $s;
    }
    choice('Out of range', 'outside', OUTSIDE);
    choice('Between points', 'between', BETWEEN);

    // ---- drawing ----------------------------------------------------------
    function px(i) { return (i / (g.points.length - 1)) * W; }
    function py(f) { return (1 - f) * H; }

    function draw() {
      var n = g.points.length;
      while (gridG.firstChild) gridG.removeChild(gridG.firstChild);
      while (dotsG.firstChild) dotsG.removeChild(dotsG.firstChild);
      for (var i = 0; i < n; i++) {
        gridG.appendChild(el('line', { x1: px(i), x2: px(i), y1: 0, y2: H }));
      }
      // Tenths of the Y range, as Simile's pad has, to read heights off by.
      for (var r = 1; r < 10; r++) {
        if (r === 5) continue;                        // the dashed middle line
        gridG.appendChild(el('line', { x1: 0, x2: W, y1: H * r / 10, y2: H * r / 10 }));
      }
      line.setAttribute('points', g.points.map(function (f, i) { return px(i) + ',' + py(f); }).join(' '));
      // Dots only while they can be told apart; beyond that they are a smear.
      if (n <= 41) {
        g.points.forEach(function (f, i) {
          dotsG.appendChild(el('circle', { cx: px(i), cy: py(f), r: 3.5 }));
        });
      }
      $count.text(n);
      $fewer.prop('disabled', (n - 1) / 2 < MIN_SEGMENTS || (n - 1) % 2 !== 0);
      $more.prop('disabled', (n - 1) * 2 > MAX_SEGMENTS);
    }

    // Pointer → pad coordinates, through the full inverse transform so that
    // CSS scaling of the pad (it stretches to the dialog's width) is honoured.
    function toPad(e) {
      var pt = svg.createSVGPoint();
      pt.x = e.clientX;
      pt.y = e.clientY;
      var m = svg.getScreenCTM();
      if (!m) return { x: 0, y: 0 };
      var p = pt.matrixTransform(m.inverse());
      return { x: Math.max(0, Math.min(W, p.x)), y: Math.max(0, Math.min(H, p.y)) };
    }

    function say(p) {
      var u = p.x / W;
      var x = g.xmin + u * (g.xmax - g.xmin);
      var y = g.ymin + (1 - p.y / H) * (g.ymax - g.ymin);
      $readout.text('x = ' + show(x) + ', y = ' + show(y));
    }

    // Set every point whose x lies between two successive pointer positions —
    // ONLY those — its height along the straight line between them, so a quick
    // sweep leaves no point behind. A press (no movement yet) sets the nearest
    // point. Rounding the ends of the range instead, as this first did, let a
    // small movement just past a point reach BACK and re-set it from where the
    // pointer had got to: a curve drawn from the origin lifted its first point
    // off zero, and a predator then ate prey there were none of.
    function paint(a, b) {
      var n = g.points.length - 1;
      if (a.x === b.x) {
        g.points[Math.round(a.x / W * n)] = clamp01(1 - b.y / H);
        return;
      }
      var lo = Math.min(a.x, b.x);
      var hi = Math.max(a.x, b.x);
      // An end point sits on the border itself, which a pointer nearly always
      // stops a pixel short of. So a stroke HEADING for an edge, and within
      // half a column of it, takes the end point there too; one moving away
      // from an edge leaves it alone — a curve drawn out of the origin keeps
      // its start where it was pressed.
      var half = W / n / 2;
      if (b.x > a.x && b.x >= W - half) hi = W;
      if (b.x < a.x && b.x <= half) lo = 0;
      for (var i = Math.ceil(lo / W * n); i <= Math.floor(hi / W * n); i++) {
        var t = Math.max(0, Math.min(1, (px(i) - a.x) / (b.x - a.x)));
        g.points[i] = clamp01(1 - (a.y + (b.y - a.y) * t) / H);
      }
    }

    // Listened for on the pad's BOX, border included, not just the drawing:
    // a stroke begun on the edge — as one aimed at the first point often is —
    // must still draw, and positions outside are clamped onto the pad.
    var surface = $padBox[0];
    var last = null;
    surface.addEventListener('pointerdown', function (e) {
      if (e.button !== undefined && e.button !== 0) return;
      e.preventDefault();
      if (surface.setPointerCapture) { try { surface.setPointerCapture(e.pointerId); } catch (err) { /* synthetic */ } }
      last = toPad(e);
      paint(last, last);
      draw();
      say(last);
    });
    surface.addEventListener('pointermove', function (e) {
      var p = toPad(e);
      say(p);
      if (!last) return;
      paint(last, p);
      last = p;
      draw();
    });
    function up() {
      if (!last) return;
      last = null;
      changed();
    }
    surface.addEventListener('pointerup', up);
    surface.addEventListener('pointercancel', up);
    surface.addEventListener('pointerleave', function () { if (!last) $readout.text(''); });

    // ---- the controls -----------------------------------------------------
    function resize(count) {
      g.points = resample(g.points, count);
      draw();
      changed();
    }
    $fewer.on('click', function () { resize((g.points.length - 1) / 2 + 1); });
    $more.on('click', function () { resize((g.points.length - 1) * 2 + 1); });

    // A limit that would leave an axis empty or backwards is refused by
    // putting the old one back, as the run control refuses a non-number.
    $host.on('change', '.slx-sketch-lim', function () {
      var key = $(this).attr('data-lim');
      var v = Number(String($(this).val()).trim());
      var lo = key === 'xmin' || key === 'ymin';
      var other = g[key.charAt(0) + (lo ? 'max' : 'min')];
      if (!isFinite(v) || String($(this).val()).trim() === '' || (lo ? v >= other : v <= other)) {
        $(this).val(show(g[key])).addClass('slx-sketch-lim-bad');
        var self = this;
        setTimeout(function () { $(self).removeClass('slx-sketch-lim-bad'); }, 900);
        return;
      }
      g[key] = v;
      $(this).val(show(v));
      changed();
    });
    // Enter in a limit box commits that box, not the whole dialog.
    $host.on('keydown', '.slx-sketch-lim', function (e) {
      if (e.key === 'Enter') { e.preventDefault(); e.stopPropagation(); $(this).trigger('change'); }
    });

    draw();

    return {
      value: function () { return JSON.parse(JSON.stringify(g)); },
      touched: function () { return touched; },
    };
  }

  Sienna.sketch = {
    defaults: defaults,
    normalise: normalise,
    evaluate: evaluate,
    resample: resample,
    pad: pad,
  };
})(window.Sienna, window.jQuery);
