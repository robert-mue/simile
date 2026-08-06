/**
 * `Sienna.demoLanduse` — the **land-use change** reference model (§4, §9).
 *
 * The model the object design was reasoned about, built for real. Its point is
 * to exercise the three things nothing else does:
 *
 *   - a **fixed-membership** submodel with many instances (PATCH, 1600 of
 *     them — the real model is a 40×40 grid);
 *   - **conditional** submodels, which are inferred and never stored: FOREST
 *     and CROP are conditional purely by containing a condition node (§4);
 *   - a **self-association**: NEXT_TO becomes an association by having TWO
 *     role arcs from the SAME submodel, `me` and `my_neighbour` (§4's rule that
 *     an association is a third submodel, never an arc between the two).
 *
 * It also crosses boundaries in both directions: `state` lives in PATCH and is
 * read by conditions inside FOREST and CROP, so those influences leave one
 * submodel and enter another, seeding ports on both boundaries (§13).
 *
 * Faithful to `Simile reference/landuse1b.pl` in structure and naming, but not
 * in size: the original carries ~60 nodes of crop and forest dynamics, and
 * nothing is learnt by copying the arithmetic. Names follow the original —
 * Patch, Forest, Crop, Next to, state, volume, biomass, time under crop — with
 * spaces replaced by underscores, because §14 requires a label to be a legal
 * equation name. That the original does NOT is a finding in its own right; see
 * STATUS.
 *
 * Classic script; no imports/exports. Load after `src/diagram.js`.
 */
(function (Sienna) {
  'use strict';

  function demoLanduse(path) {
    var p = path || 'models/landuse';
    var d = Sienna.Diagram.create(p, { name: 'Land use' });

    // ---- PATCH: 1600 instances, the grid ---------------------------------
    var patch = d.addSubmodel({
      label: 'PATCH', parent: null, kind: 'fixed-membership',
      x: 300, y: 250, w: 480, h: 300,
      props: { dimensions: '1600' },
    });

    // The land-use state of this patch: 1 = forest, 2 = crop.
    var state = d.addNode('compartment', {
      label: 'state', parent: patch, x: 200, y: 200, w: 40, h: 26,
      props: { initial: '1' },
    });

    // What changes it. The flow's cloud and valve are auto-created (§4).
    var change = d.addFlow({
      to: state, parent: patch,
      label: 'change_state',
      x: 130, y: 200,
      fromXY: { x: 80, y: 200 },
      props: { rate: 'if state==1 and pressure>0.5 then 1 else 0' },
    });

    // A variable the rate reads, so the rate's names are all supplied.
    var pressure = d.addNode('variable', {
      label: 'pressure', parent: patch, x: 130, y: 120,
      props: { value: 'rand_var(0,1)' },
    });
    d.addInfluence(pressure, change.valve);
    d.addInfluence(state, change.valve);

    // ---- FOREST and CROP: conditional by containing a condition ----------
    // Neither carries a "conditional" flag: the kind is INFERRED from the
    // condition node inside it (§4, decision #3). Both are `single`, which is
    // the membership kind; conditionality is orthogonal to it.
    var forest = d.addSubmodel({
      label: 'FOREST', parent: patch, x: 330, y: 180, w: 180, h: 90,
    });
    d.addNode('condition', {
      label: 'is_forest', parent: forest, x: 300, y: 180,
      props: { expr: 'state==1' },
    });

    var crop = d.addSubmodel({
      label: 'CROP', parent: patch, x: 330, y: 320, w: 180, h: 90,
    });
    d.addNode('condition', {
      label: 'is_crop', parent: crop, x: 300, y: 320,
      props: { expr: 'state==2' },
    });

    // Cross-boundary in both directions: out of PATCH's interior and into the
    // conditional submodels. These are what seed ports on two boundaries.
    d.addInfluence(state, d.childrenOf(forest)[0]);
    d.addInfluence(state, d.childrenOf(crop)[0]);

    // What each land use accumulates, so the conditionals are not empty shells.
    d.addNode('compartment', {
      label: 'volume', parent: forest, x: 400, y: 180, w: 40, h: 26,
      props: { initial: '0' },
    });
    d.addNode('compartment', {
      label: 'biomass', parent: crop, x: 400, y: 320, w: 40, h: 26,
      props: { initial: '0' },
    });

    // ---- NEXT_TO: the self-association -----------------------------------
    // TWO role arcs from the SAME submodel. That is what makes NEXT_TO an
    // association, and it is the case a two-party association does not cover:
    // both ends are PATCH. Labels follow the original model's `me` and
    // `my neighbour`.
    var nextTo = d.addSubmodel({
      label: 'NEXT_TO', parent: null, x: 700, y: 130, w: 160, h: 90,
    });
    d.addRole(patch, nextTo, { label: 'me' });
    d.addRole(patch, nextTo, { label: 'my_neighbour' });

    demoLanduse.d = d;
    return { model: p, patch: patch, forest: forest, crop: crop, nextTo: nextTo, state: state };
  }

  Sienna.demoLanduse = demoLanduse;
})(window.Sienna);
