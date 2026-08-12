/**
 * The fixture for a FLOW that crosses a submodel boundary — the case item 33's
 * round trip found the exporter could not write.
 *
 *              ┌ TANK ────────────────┐
 *     cd1 ─inflow─▶ [store] ─outflow─▶ cd2
 *              └──────────────────────┘
 *
 * Both clouds sit OUTSIDE the submodel and the compartment sits inside, so one
 * flow crosses inward and one crosses outward, and each becomes two Simile flow
 * arcs paired by `links` — the same segmentation an influence gets, which is
 * what `johadP.pl` showed and what nothing in this repo previously exercised.
 *
 * The two valves both live INSIDE `TANK`, which is the point of putting them
 * there: the rate rides on the segment in the valve's own scope, so `inflow`
 * carries it on its SECOND segment and `outflow` on its FIRST. A fixture where
 * every rate landed on segment 0 would not have tested that.
 *
 * ## The number
 *
 *     dS/dt = 3 − 0.1·S,  S(0) = 0   ⟹   S(t) = 30(1 − e^−0.1t)
 *
 * so at t = 10 the analytic answer is 18.963617. Simile, running Euler at step
 * 0.001, returns **18.964168607012084** — and that is not an error to excuse,
 * it is the exact Euler answer: 30(1 − 0.9999^10000) = 18.9641686…, agreeing to
 * every figure returned. Measured on the public server, 2026-08-12.
 *
 * The fixture checks arithmetic rather than merely that the model loads — the
 * standing lesson of item 31, where a wrong model compiled and ran.
 *
 * Run it from the browser console:  demoDrain()
 * Export it:                        Sienna.exportSimile.prolog(Sienna.userData.get('models/drain'))
 * Run it for real:                  Widgets ▸ Run control, model "Drain", load
 *
 * Classic script; no imports/exports.
 */
(function (Sienna) {
  'use strict';

  function demoDrain(path) {
    var p = path || 'models/drain';
    var d = Sienna.Diagram.create(p, { name: 'Drain' });

    // One instance: this fixture is about the boundary, not about membership.
    var tank = d.addSubmodel({
      label: 'TANK', x: 400, y: 240, w: 240, h: 160, kind: 'single',
    });

    var store = d.addNode('compartment', {
      label: 'store', parent: tank, x: 400, y: 240, w: 40, h: 26,
      props: { initial: '0' },
    });

    // Both clouds outside, so each flow crosses the boundary once.
    var cd1 = d.addNode('cloud', { label: '', x: 180, y: 240 });
    var cd2 = d.addNode('cloud', { label: '', x: 640, y: 240 });

    // Valves inside TANK: the rate rides on the segment in the valve's scope,
    // which is the LAST for `inflow` and the FIRST for `outflow`.
    var inflow = d.addFlow({
      from: cd1, to: store, label: 'inflow', parent: tank,
      x: 300, y: 240, props: { rate: '3' },
    });
    var outflow = d.addFlow({
      from: store, to: cd2, label: 'outflow', parent: tank,
      x: 520, y: 240, props: { rate: 'store * 0.1' },
    });

    // The outflow's rate uses the compartment it empties — same scope, so this
    // one does not cross anything.
    d.addInfluence(store, outflow.valve);

    demoDrain.d = d;
    return { model: p, tank: tank, store: store, inflow: inflow, outflow: outflow };
  }

  Sienna.demoDrain = demoDrain;
  window.demoDrain = demoDrain; // handy in the console
})(window.Sienna);
