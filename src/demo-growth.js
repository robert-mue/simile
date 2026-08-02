/**
 * A worked example: build a small model through `Sienna.Diagram`, element by
 * element, in the order a user would draw it in the GUI.
 *
 *     cloud ──growth──▶ [biomass]        k ──▶ growth ◀── biomass
 *
 * i.e. a growth flow from a cloud into a biomass compartment, with the flow
 * rate influenced by a parameter `k` and by `biomass` itself. No submodels.
 *
 * Run it from the browser console:  demoGrowth()
 * Then inspect:                     demoGrowth.d.toJSON()
 * Undo it step by step:             Sienna.history.undo()   (Edit ▸ Undo)
 *
 * Each call below is one user action, hence one undo step — note that undoing
 * the flow takes its auto-created cloud and valve back with it, as one gesture.
 *
 * Classic script; no imports/exports.
 */
(function (Sienna) {
  'use strict';

  function demoGrowth(path) {
    var p = path || 'models/growth';
    var d = Sienna.Diagram.create(p, { name: 'Growth' });

    // 1. The compartment the flow runs into. (x/y are layout only — the model
    //    itself is position-free; see DESIGN-diagram.md §6.)
    var biomass = d.addNode('compartment', { label: 'biomass', x: 320, y: 160, w: 60, h: 40 });

    // 2. The flow. Drawn from blank space, so its source cloud is auto-created,
    //    as is its valve — the node that carries the name 'growth' and will
    //    hold the rate equation. One gesture, one undo step.
    var flow = d.addFlow({
      to: biomass,
      label: 'growth',
      x: 220, y: 180,            // the valve
      fromXY: { x: 120, y: 180 }, // the auto-created cloud
      props: { rate: 'k * biomass' },
    });

    // 3. The parameter.
    var k = d.addNode('variable', { label: 'k', props: { value: '0.1' }, x: 200, y: 60 });

    // 4. Two influences into the flow — which means into its **valve**: an
    //    influence never terminates on an arc (§4). Each carries the local
    //    name the rate equation uses, defaulted from the source's label and
    //    copied, not linked (§14.1).
    var infK = d.addInfluence(k, flow.valve);
    var infB = d.addInfluence(biomass, flow.valve);

    demoGrowth.d = d;
    return {
      model: p,
      cloud: flow.from,
      biomass: biomass,
      flow: flow.arc,
      valve: flow.valve,
      k: k,
      influences: [infK, infB],
    };
  }

  Sienna.demoGrowth = demoGrowth;
  window.demoGrowth = demoGrowth; // handy in the console
})(window.Sienna);
