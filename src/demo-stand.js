/**
 * A worked example with a SUBMODEL, and the fixture the Simile export is tested
 * against — the smallest model that crosses a boundary in both directions.
 *
 *     r ─────────────▶ ┌ PLANT ×5 ──────────────────┐
 *                      │ cloud ─growth─▶ [biomass] │ ──▶ total
 *                      └───────────────────────────┘
 *
 * Five plants, each growing at rate `r` from outside; `total` outside sums the
 * five biomasses. So one influence crosses INWARD (a scalar, seen by every
 * instance) and one crosses OUTWARD (a list of five).
 *
 * The outward alias is **`[biomass]`, not `biomass`** — and that is the point of
 * the fixture. A value leaving a multi-instance submodel arrives as a list, and
 * both the alias and the equation that uses it have to say so: square brackets
 * for a fixed membership, curly for a variable one. Simile's own models are
 * written this way (`sum({volume})` beside `role=[…,{volume},list(1)…]`), and
 * `Sienna.exportSimile` refuses an outward crossing whose alias is bare rather
 * than quietly inventing the brackets.
 *
 * Run it from the browser console:  demoStand()
 * Export it:                        Sienna.exportSimile.prolog(Sienna.userData.get('models/stand'))
 * Run it for real:                  Widgets ▸ Run control, model "Stand", load
 *
 * Classic script; no imports/exports.
 */
(function (Sienna) {
  'use strict';

  function demoStand(path) {
    var p = path || 'models/stand';
    var d = Sienna.Diagram.create(p, { name: 'Stand' });

    // Five instances — a fixed membership, so what leaves it is `[…]`.
    var plant = d.addSubmodel({
      label: 'PLANT', x: 300, y: 240, w: 260, h: 160,
      kind: 'fixed-membership', props: { dimensions: '5' },
    });

    var biomass = d.addNode('compartment', {
      label: 'biomass', parent: plant, x: 360, y: 240, w: 36, h: 24,
      props: { initial: '1' },
    });

    var flow = d.addFlow({
      to: biomass, label: 'growth', parent: plant,
      x: 260, y: 240, fromXY: { x: 190, y: 240 },
      props: { rate: 'r * biomass' },
    });

    var r = d.addNode('variable', { label: 'r', x: 120, y: 90, props: { value: '0.05' } });
    var total = d.addNode('variable', {
      label: 'total', x: 640, y: 240, props: { value: 'sum([biomass])' },
    });

    // Same level: the flow's rate uses the compartment it fills.
    d.addInfluence(biomass, flow.valve);
    // Inward across the boundary: one scalar, seen by every instance.
    d.addInfluence(r, flow.valve);
    // Outward across the boundary: five values, so the alias is bracketed.
    var out = d.addInfluence(biomass, total);
    Sienna.userData.set(p + '/arcs/' + out + '/alias', '[biomass]');

    demoStand.d = d;
    return { model: p, plant: plant, biomass: biomass, valve: flow.valve, r: r, total: total };
  }

  Sienna.demoStand = demoStand;
  window.demoStand = demoStand; // handy in the console
})(window.Sienna);
