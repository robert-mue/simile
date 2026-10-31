/**
 * TEST-ONLY fixture (loaded by test/fixtures.html, never seeded into a user's
 * models): a SATELLITE submodel — an association with ONE role — after
 * Robert's `satellite_submodel` (2026-10-31).
 *
 *     ┌ Trees (population, 100) ┐         ┌ Subtrees ──────────────────┐
 *     │ species = int(rand_const(1,6)) ══Trees══▶ condition: species_Trees == 3 │
 *     │ volume  = 1              │        │ vol3 = volume_Trees        │
 *     └──────────────────────────┘        └────────────────────────────┘
 *                                    sum_vol3 = sum({vol3})   (top level)
 *
 * What it pins down: Subtrees has one instance per tree, so `vol3` leaving it
 * is a LIST — `use(none,in_hierarchy,{vol3},list(1))` — as old Simile writes
 * it (`Diagram.isMultiInstance`).
 */
(function (Sienna) {
  'use strict';

  function fixtureSatellite(path) {
    var p = path || 'models/satellite';
    var d = Sienna.Diagram.create(p, { name: 'Satellite' });
    var trees = d.addSubmodel({
      label: 'Trees', x: 200, y: 200, w: 200, h: 180,
      kind: 'population', props: {},
    });
    var subtrees = d.addSubmodel({ label: 'Subtrees', x: 520, y: 200, w: 200, h: 180, kind: 'single' });
    var species = d.addNode('variable', {
      label: 'species', parent: trees, x: 200, y: 160, props: { value: 'int(rand_const(1,6))' },
    });
    var volume = d.addNode('variable', { label: 'volume', parent: trees, x: 200, y: 240, props: { value: '1' } });
    d.addNode('initialiser', { label: 'initialiser1', parent: trees, x: 140, y: 120, props: { expr: '100' } });
    var cond = d.addNode('condition', {
      label: 'condition1', parent: subtrees, x: 520, y: 160, props: { expr: 'species_Trees == 3' },
    });
    var vol3 = d.addNode('variable', {
      label: 'vol3', parent: subtrees, x: 520, y: 240, props: { value: 'volume_Trees' },
    });
    var sum = d.addNode('variable', { label: 'sum_vol3', x: 760, y: 200, props: { value: 'sum({vol3})' } });
    d.addRole(trees, subtrees, { label: 'Trees' });
    d.addInfluence(species, cond);
    d.addInfluence(volume, vol3);
    // What leaves the satellite is a list, so the alias is bracketed (as
    // `demo-stand.js` does for a fixed membership).
    var out = d.addInfluence(vol3, sum);
    Sienna.userData.set(p + '/arcs/' + out + '/alias', '{vol3}');
    return { model: p };
  }

  Sienna.fixtureSatellite = fixtureSatellite;
})(window.Sienna);
