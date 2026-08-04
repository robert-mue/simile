/**
 * The §13 worked example: a submodel, arcs crossing its boundary, and the
 * fan-out that makes segments *shared* rather than per-arc.
 *
 *                    k ──┐
 *      ┌─ PLANT ─────────┼──────────────┐
 *      │  cloud ─growth─▶│ [biomass] ───┼──▶ harvest
 *      │                 │      │       │
 *      └─────────────────┼──────┼───────┘
 *                        └──────┴───────────▶ cover
 *
 * Three things to look at in the result:
 *
 *  1. `k` is OUTSIDE PLANT and influences the valve INSIDE it. That is ONE arc
 *     in the model — `from:'k'`, `to:'<valve>'` — drawn as two segments, with a
 *     port where it pierces PLANT's boundary. The model knows nothing of the
 *     split (§13.7).
 *  2. `biomass` is INSIDE PLANT and influences TWO things outside it. Both arcs
 *     leave through the SAME port `port:<PLANT>/<biomass>`, so there is one
 *     shared segment from biomass to the boundary and two beyond it — reason 4
 *     of §13.2, the strongest argument for keeping the visual split.
 *  3. There is no fan-in: the descent into PLANT is owned by the arc, not by
 *     the target (ruling 14), so `k`'s crossing is its own.
 *
 * Run from the console:  demoSubmodel()
 * Then:                  demoSubmodel.d.portsFor('arc3')
 *                        demoSubmodel.d.arcPoints('arc3')
 *
 * Classic script; no imports/exports.
 */
(function (Sienna) {
  'use strict';

  function demoSubmodel(path) {
    var p = path || 'models/plant';
    var d = Sienna.Diagram.create(p, { name: 'Plant' });

    // The container. Everything below with parent:plant sits inside it.
    var plant = d.addSubmodel({ label: 'PLANT', kind: 'single', x: 250, y: 220, w: 200, h: 130 });

    // --- inside PLANT ---
    var biomass = d.addNode('compartment', {
      label: 'biomass', parent: plant, x: 330, y: 220, w: 36, h: 24,
    });
    var flow = d.addFlow({
      to: biomass, label: 'growth', parent: plant,
      x: 220, y: 220,
      fromXY: { x: 140, y: 220 },
      props: { rate: 'k * biomass' },
    });

    // --- outside PLANT ---
    var k = d.addNode('variable', { label: 'k', x: 150, y: 60, props: { value: '0.1' } });
    var harvest = d.addNode('variable', { label: 'harvest', x: 560, y: 150 });
    var cover = d.addNode('variable', { label: 'cover', x: 560, y: 300 });

    // 1. Crossing INTO the submodel: one arc, two segments.
    var inArc = d.addInfluence(k, flow.valve);

    // 2. Crossing OUT, twice from the same source: the exit segment is shared.
    var outA = d.addInfluence(biomass, harvest);
    var outB = d.addInfluence(biomass, cover);

    demoSubmodel.d = d;
    return {
      model: p,
      plant: plant,
      biomass: biomass,
      valve: flow.valve,
      k: k,
      crossingIn: inArc,
      crossingOut: [outA, outB],
      sharedPort: d.portKey(plant, biomass),
    };
  }

  Sienna.demoSubmodel = demoSubmodel;
  window.demoSubmodel = demoSubmodel;
})(window.Sienna);
