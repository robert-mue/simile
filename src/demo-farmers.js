/**
 * `Sienna.demoFarmers` — the **farmers & fields** reference model
 * (Muetzelfeldt 2010, CCAFS; §9).
 *
 * The complement to land-use. Where that one has a submodel associated with
 * ITSELF, this has the other association topology — **two parties**: OWNERSHIP
 * takes a role arc from FARMER and one from FIELD, two *different* submodels of
 * two *different* kinds. Between them the pair cover both shapes §4 reasoned
 * about, which is the whole reason for building them.
 *
 * It is also the only model that exercises the **population** symbols. FARMER
 * is a population, so it may hold an initialiser, a migrator and an
 * exterminator — and the schema rule `population-symbols` refuses them
 * anywhere else, which nothing else here tests.
 *
 * Three membership kinds appear at once: VILLAGE `single`, FARMER `population`,
 * FIELD `fixed-membership`. Nesting is real — everything sits inside VILLAGE —
 * so the association's role arcs run between submodels that are siblings deep
 * in the tree rather than at the top level.
 *
 * Classic script; no imports/exports. Load after `src/diagram.js`.
 */
(function (Sienna) {
  'use strict';

  function demoFarmers(path) {
    var p = path || 'models/farmers';
    var d = Sienna.Diagram.create(p, { name: 'Farmers and fields' });

    // ---- VILLAGE: one of them, holding everything else --------------------
    var village = d.addSubmodel({
      label: 'VILLAGE', parent: null, kind: 'single',
      x: 380, y: 260, w: 660, h: 380,
    });

    // ---- FARMER: a population, with the symbols only a population may hold
    var farmer = d.addSubmodel({
      label: 'FARMER', parent: village, kind: 'population',
      x: 200, y: 180, w: 250, h: 170,
    });

    var wealth = d.addNode('compartment', {
      label: 'wealth', parent: farmer, x: 150, y: 160, w: 40, h: 26,
      props: { initial: '100' },
    });

    // How many farmers there are to begin with, who arrives, and who leaves.
    // `population-symbols` refuses all three outside a population submodel.
    d.addNode('initialiser', {
      label: 'start_farmers', parent: farmer, x: 270, y: 130,
      props: { expr: '20' },
    });
    d.addNode('migrator', {
      label: 'moves_in', parent: farmer, x: 270, y: 180,
      props: { expr: 'rand_var(0,1)<0.05' },
    });
    var leaves = d.addNode('exterminator', {
      label: 'leaves', parent: farmer, x: 270, y: 230,
      props: { expr: 'wealth<10' },
    });
    d.addNode('reproduction', {
      label: 'children', parent: farmer, x: 150, y: 232,
      props: { expr: 'rand_var(0,1)<0.02' },
    });
    // The exterminator reads wealth, so it needs the arrow that says so.
    d.addInfluence(wealth, leaves);

    // ---- FIELD: a fixed number of them ------------------------------------
    var field = d.addSubmodel({
      label: 'FIELD', parent: village, kind: 'fixed-membership',
      x: 560, y: 180, w: 220, h: 170,
      props: { dimensions: '60' },
    });

    d.addNode('compartment', {
      label: 'area', parent: field, x: 560, y: 160, w: 40, h: 26,
      props: { initial: '2.5' },
    });

    // ---- OWNERSHIP: the two-party association -----------------------------
    // The association is a THIRD submodel with a role arc from each party —
    // never an arc from FARMER to FIELD directly (§4). It is what carries facts
    // about the pairing rather than about either side.
    var ownership = d.addSubmodel({
      label: 'OWNERSHIP', parent: village, kind: 'single',
      x: 380, y: 400, w: 200, h: 90,
    });
    d.addRole(farmer, ownership, { label: 'owns' });
    d.addRole(field, ownership, { label: 'owned' });

    d.addNode('variable', {
      label: 'share_of_yield', parent: ownership, x: 380, y: 400,
      props: { value: '0.5' },
    });

    demoFarmers.d = d;
    return { model: p, village: village, farmer: farmer, field: field, ownership: ownership };
  }

  Sienna.demoFarmers = demoFarmers;
})(window.Sienna);
