/**
 * The hardest export case we can currently make: one influence that crosses a
 * **containment** boundary AND an **association** boundary, carrying a list.
 *
 *     ┌ individual ×4 ───────────────┐        ┌ ranking ──────────────┐
 *     │ ┌ traits ×2 ──────────────┐  │══higher══▶ beats:              │
 *     │ │ attribute = index(2)    │  │══lower═══▶  sum([attribute_higher])
 *     │ └─────────────────────────┘  │        │  > sum([attribute_lower])
 *     │ rank = count({one_lower})+1  │        │ one = 1               │
 *     └──────────────────────────────┘        └───────────────────────┘
 *
 * `attribute` leaves `traits` (two instances, so it becomes a list), leaves
 * `individual`, then enters `ranking` — four segments for one arc of ours. Each
 * individual's traits are both its own index, so the sums are 2, 4, 6, 8 and the
 * ranks come back **[4, 3, 2, 1]**.
 *
 * ## Why this fixture exists
 *
 * It was going to be a refusal. The mixed case looked like the one thing the
 * segment walk could not do — and then it turned out the walk needed no change
 * at all, because a base and an association are just ordinary scopes. Only the
 * role on the final segment differs. Keeping the model as a fixture is what
 * stops that being re-broken.
 *
 * It also settled a detail no reference model shows: when a value reaches an
 * association ALREADY a list, the role's alias stays **bare** and the equation
 * brackets it — `use(0,in_base,attribute_higher,list(1))` beside
 * `sum([attribute_higher])`. That is the opposite of a containment crossing,
 * where the brackets live in the alias (`{volume}` beside `sum({volume})`).
 * Established by running it, not by reading.
 *
 * Run it from the browser console:  demoMixed()
 * Run it for real:                  Widgets ▸ Run control, model "Mixed", load
 *
 * Classic script; no imports/exports.
 */
(function (Sienna) {
  'use strict';

  function demoMixed(path) {
    var p = path || 'models/mixed';
    var d = Sienna.Diagram.create(p, { name: 'Mixed' });

    var indiv = d.addSubmodel({
      label: 'individual', x: 240, y: 260, w: 320, h: 260,
      kind: 'fixed-membership', props: { dimensions: '4' },
    });
    // Nested, and multi-instance — which is what makes the value a list before
    // it ever reaches the association.
    var traits = d.addSubmodel({
      label: 'traits', x: 240, y: 200, w: 200, h: 90, parent: indiv,
      kind: 'fixed-membership', props: { dimensions: '2' },
    });
    var ranking = d.addSubmodel({ label: 'ranking', x: 680, y: 260, w: 220, h: 180, kind: 'single' });

    // index(2) is the INDIVIDUAL's index seen from inside `traits`, so each
    // individual gets a distinct pair — without that every sum ties, no pair
    // exists, and the fixture passes while proving nothing.
    var attribute = d.addNode('variable', {
      label: 'attribute', parent: traits, x: 240, y: 200, props: { value: 'index(2)' },
    });
    var rank = d.addNode('variable', {
      label: 'rank', parent: indiv, x: 240, y: 340, props: { value: 'count({one_lower})+1' },
    });
    var beats = d.addNode('condition', {
      label: 'beats', parent: ranking, x: 680, y: 220,
      props: { expr: 'sum([attribute_higher]) > sum([attribute_lower])' },
    });
    var one = d.addNode('variable', {
      label: 'one', parent: ranking, x: 680, y: 300, props: { value: '1' },
    });

    d.addRole(indiv, ranking, { label: 'higher' });
    d.addRole(indiv, ranking, { label: 'lower' });

    d.addInfluence(attribute, beats);   // traits → individual → ranking
    d.addInfluence(one, rank);          // ranking → individual

    demoMixed.d = d;
    return { model: p, indiv: indiv, traits: traits, ranking: ranking,
      attribute: attribute, rank: rank, beats: beats, one: one };
  }

  Sienna.demoMixed = demoMixed;
  window.demoMixed = demoMixed; // handy in the console
})(window.Sienna);
