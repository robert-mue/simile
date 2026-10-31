/**
 * TEST-ONLY fixture (loaded by test/fixtures.html, never seeded into a user's
 * models): TABLES read from a data file — Simile's `table_data`, as
 * nkometou.pl has 43 of (2026-10-31; see `readTable` in import-simile.js).
 *
 *   Fields ×3:  v = table(index(1))                 the table [5,7,9], per field
 *   top level:  whole = makearray(table(place_in(1)),3)   units array(1,3)
 *               total = sum([v])                    → 21
 *
 * What it pins down: the table's values (`current`), its source file, column
 * and keys survive the round trip, on the node whose equation says `table`,
 * where Simile's generator looks for them. Checked by compiling and running
 * it in the page on 2026-10-31: v = [5,7,9], total = 21, whole = [5,7,9].
 */
(function (Sienna) {
  'use strict';

  function table() {
    return {
      file: 'C:/data/fields.csv', column: 'YIELD', indices: ['FIELD_ID'],
      values: [5, 7, 9], units: '1', bounds: '[int]', dims: '[3]',
    };
  }

  function fixtureTable(path) {
    var p = path || 'models/table';
    var d = Sienna.Diagram.create(p, { name: 'Table' });
    var fields = d.addSubmodel({
      label: 'Fields', x: 200, y: 200, w: 180, h: 140,
      kind: 'fixed-membership', props: { dimensions: '3' },
    });
    var v = d.addNode('variable', {
      label: 'v', parent: fields, x: 200, y: 200, props: { value: 'table(index(1))', table: table() },
    });
    var total = d.addNode('variable', { label: 'total', x: 460, y: 200, props: { value: 'sum([v])' } });
    d.addNode('variable', {
      label: 'whole', x: 460, y: 300,
      props: { value: 'makearray(table(place_in(1)),3)', units: 'array(1,3)', table: table() },
    });
    var out = d.addInfluence(v, total);
    Sienna.userData.set(p + '/arcs/' + out + '/alias', '[v]');
    return { model: p };
  }

  Sienna.fixtureTable = fixtureTable;
})(window.Sienna);
