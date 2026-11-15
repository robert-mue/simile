/**
 * `Sienna.modelSummary(spec)` — what a model spec's STRUCTURE says about it,
 * worked out, never written down (Robert, 2026-11-15): its size and the
 * Simile features it uses. Shown by the Sample models panel (for the
 * gallery's models) and the Metadata panel (for one of the user's).
 *
 *   { size: [submodels, stocks, flows, variables],
 *     features: ['population', 'creation', …] }   — in a fixed order
 *
 * Takes the plain model spec (as File ▸ Save writes it), so it works on a
 * model fetched from the gallery as well as one in the store. Conditional,
 * satellite and association are inferred as the grammar infers them
 * (grammar.js `kindsOf`): a condition inside, and how many role arrows
 * point in.
 *
 * Classic script; no imports/exports.
 */
(function (Sienna) {
  'use strict';

  var ORDER = ['fixed membership', 'population', 'nested submodels', 'conditional', 'satellite',
    'association', 'creation', 'immigration', 'loss', 'reproduction', 'alarm'];
  var EVENTS = { initialiser: 'creation', migrator: 'immigration', exterminator: 'loss', reproduction: 'reproduction' };

  Sienna.modelSummary = function (spec) {
    spec = spec || {};
    var values = function (o) { return Object.keys(o || {}).map(function (k) { return o[k]; }); };
    var nodes = values(spec.nodes);
    var arcs = values(spec.arcs);
    var subs = spec.submodels || {};
    var ids = Object.keys(subs);
    var count = function (type) { return nodes.filter(function (n) { return n && n.type === type; }).length; };
    var has = {};
    ids.forEach(function (id) {
      var s = subs[id] || {};
      if (s.kind === 'fixed-membership') has['fixed membership'] = true;
      if (s.kind === 'population') has.population = true;
      if (s.parent) has['nested submodels'] = true;
      if (nodes.some(function (n) { return n && n.type === 'condition' && n.parent === id; })) has.conditional = true;
      var roles = arcs.filter(function (a) { return a && a.type === 'role' && a.to === id; }).length;
      if (roles === 1) has.satellite = true;
      else if (roles >= 2) has.association = true;
    });
    Object.keys(EVENTS).forEach(function (t) { if (count(t)) has[EVENTS[t]] = true; });
    if (count('alarm')) has.alarm = true;
    return {
      size: [ids.length, count('stock'), count('valve'), count('variable')],
      features: ORDER.filter(function (f) { return has[f]; }),
    };
  };

  /** The size in words, for a tooltip: "1 submodel, 1 stock, 1 flow, 4 variables". */
  Sienna.modelSummary.sizeInWords = function (size) {
    var w = function (n, one) { return n + ' ' + one + (n === 1 ? '' : 's'); };
    return [w(size[0], 'submodel'), w(size[1], 'stock'), w(size[2], 'flow'), w(size[3], 'variable')].join(', ');
  };
})(window.Sienna);
