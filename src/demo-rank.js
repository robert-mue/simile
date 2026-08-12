/**
 * A worked example with an ASSOCIATION — the fixture the association export is
 * tested against, and a close copy of the catalogue's `ranking1`.
 *
 *     ┌ individual ×4 ─────────┐        ┌ ranking ────────────┐
 *     │ attribute = index(1)   │══higher══▶ beats:            │
 *     │ rank = count({one_lower})+1 │══lower═══▶  attribute_higher
 *     └────────────────────────┘        │         > attribute_lower
 *                                       │ one = 1             │
 *                                       └─────────────────────┘
 *
 * Four individuals with attributes 1–4, related to each other pairwise. A pair
 * exists only where the first beats the second, so counting the pairs in which
 * you are the loser gives your rank: **[4, 3, 2, 1]**.
 *
 * ## Two things this fixture is here to pin down
 *
 * **An association renames.** Our model holds one alias per influence; Simile
 * needs one name per ROLE, so `attribute` crossing into the association arrives
 * as `attribute_higher` AND `attribute_lower`, and the equation must use those.
 * Coming back out it is a list per role — `{one_lower}`. The exporter derives
 * those names and refuses to export if the consumer's equation uses none of
 * them, since the alternative is a model that compiles and means something else.
 *
 * **Equations must be parenthesised on the way out.** `beats` is the only
 * fixture whose equation has a top-level comparison, which is exactly the case
 * that breaks: `value=a>b` is not legal Prolog (`=` and `>` are both xfx 700),
 * Simile drops the property silently, and the condition stops filtering — every
 * pair exists and every rank comes back 5. See `src/export-simile.js`.
 *
 * Run it from the browser console:  demoRank()
 * Run it for real:                  Widgets ▸ Run control, model "Rank", load
 *
 * Classic script; no imports/exports.
 */
(function (Sienna) {
  'use strict';

  function demoRank(path) {
    var p = path || 'models/rank';
    var d = Sienna.Diagram.create(p, { name: 'Rank' });

    var indiv = d.addSubmodel({
      label: 'individual', x: 220, y: 240, w: 260, h: 200,
      kind: 'fixed-membership', props: { dimensions: '4' },
    });
    // The association: an ordinary submodel that role arcs point AT. Neither we
    // nor Simile store "association" as a kind — both infer it (§4).
    var ranking = d.addSubmodel({ label: 'ranking', x: 620, y: 240, w: 220, h: 180, kind: 'single' });

    var attribute = d.addNode('variable', {
      label: 'attribute', parent: indiv, x: 220, y: 190, props: { value: 'index(1)' },
    });
    var rank = d.addNode('variable', {
      label: 'rank', parent: indiv, x: 220, y: 290, props: { value: 'count({one_lower})+1' },
    });
    var beats = d.addNode('condition', {
      label: 'beats', parent: ranking, x: 620, y: 200,
      props: { expr: 'attribute_higher > attribute_lower' },
    });
    var one = d.addNode('variable', {
      label: 'one', parent: ranking, x: 620, y: 285, props: { value: '1' },
    });

    // The two roles. Their LABELS become the suffixes the equations above use.
    d.addRole(indiv, ranking, { label: 'higher' });
    d.addRole(indiv, ranking, { label: 'lower' });

    d.addInfluence(attribute, beats);  // base → association: one name per role
    d.addInfluence(one, rank);         // association → base: one list per role

    demoRank.d = d;
    return { model: p, indiv: indiv, ranking: ranking, attribute: attribute, rank: rank,
      beats: beats, one: one };
  }

  Sienna.demoRank = demoRank;
  window.demoRank = demoRank; // handy in the console
})(window.Sienna);
