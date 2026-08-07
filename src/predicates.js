/**
 * The named grammar predicates simile's schema refers to (§12.2's escape hatch).
 *
 * A schema is plain data — no code, so that it stays exportable to other tools.
 * Most rules say what they mean in the rule vocabulary (`ends`, `toTypes`,
 * `parentKind`…). A few cannot, and for those the schema names a predicate and
 * this file supplies it. A rule may name one; it may never carry a code string.
 *
 * Right now they are all about **geometry against containment** — whether an
 * element is drawn where the model says it belongs. That could not be expressed
 * in the rule vocabulary because the vocabulary quantifies over the model, and
 * this is the one class of question that compares the model with the LAYOUT.
 *
 * Why check it at all (asked and answered 2026-08-06): dropping is what
 * normally sets parentage, so a hand-built diagram cannot easily disagree with
 * itself. But dropping is not the only way a model gets made — an AI assistant
 * writing one, or an automatic graph layout moving things, both bypass the
 * gesture entirely, and neither has any reason to keep the two in step. The
 * check exists for the ways of building a diagram we do not have yet.
 *
 * Both are **deferred** (§12.3): reported by the model check, never blocking.
 * They must not be preventive, because dragging an element out of a submodel is
 * precisely how you re-parent it — the drop decides, and refusing mid-gesture
 * would fight direct manipulation.
 *
 * Classic script; no imports/exports. Load after `src/grammar.js`.
 */
(function (Sienna) {
  'use strict';

  /** Is `inner` wholly within `outer`? The same test submodel capture uses. */
  function within(inner, outer) {
    return inner.cx - inner.w / 2 >= outer.cx - outer.w / 2
        && inner.cx + inner.w / 2 <= outer.cx + outer.w / 2
        && inner.cy - inner.h / 2 >= outer.cy - outer.h / 2
        && inner.cy + inner.h / 2 <= outer.cy + outer.h / 2;
  }

  /**
   * Has this element a position of its own to judge?
   *
   * No, if it does not exist yet — `mayContain` asks about prospective
   * elements, which have no geometry, and a rule cannot fault what is not
   * there. No, either, for a type positioned BY something else: a valve rides
   * its flow's midpoint (§4), so when a flow crosses a boundary the valve is
   * left outside its parent and the modeller cannot do anything about it. That
   * is a known gap in its own right, not this rule's business.
   */
  function judgeable(d, cand) {
    if (!cand.id || !d.get(cand.id)) return false;
    if (cand.family !== 'node' && cand.family !== 'submodel') return false;
    var el = d.get(cand.id);
    var spec = cand.family === 'submodel' ? {} : (d.schema().nodes[el.type] || {});
    return !spec.positionedBy;
  }

  Sienna.grammar.predicates = Sienna.grammar.predicates || {};

  /**
   * An element must be DRAWN inside the submodel it belongs to.
   *
   * The model says `parent`; the picture should agree. Top-level elements have
   * nothing to be inside, so they always pass.
   */
  Sienna.grammar.predicates.insideItsParent = function (cand, d) {
    if (!cand.parent || !judgeable(d, cand)) return true;
    if (!d.get(cand.parent)) return true;
    return within(d.box(cand.id), d.box(cand.parent));
  };

  /**
   * …and must NOT be drawn inside a submodel it does *not* belong to.
   *
   * The mirror of the above, and the more likely of the two to be produced by a
   * layout algorithm: the element sits squarely inside FOREST while the model
   * says it is a child of PATCH. Ancestors are exempt — being inside your
   * grandparent's box is expected, since your parent is in there too.
   */
  /**
   * A submodel may take at most TWO role arcs.
   *
   * The counts are the whole meaning (Simile developer, 2026-08-08):
   *   one  — a **satellite** submodel, hanging off a single other one;
   *   two  — an **association**, relating its two parties (§4);
   *   more — not legal.
   *
   * This replaces a rule written the day before that had it backwards, on the
   * reading that an association needs two roles and one was therefore a
   * half-built one. One role is not half of anything: it is a different and
   * perfectly good kind of submodel. The lesson is in §4 — a count that looks
   * like an incomplete version of a bigger count may be its own case.
   *
   * PREVENTIVE, unlike the two-roles rule it replaces, and for a reason that
   * inverts with it. A ceiling has no legitimate intermediate state: nobody
   * needs to pass through three roles on the way to something valid, so the
   * third arc can simply be refused as it is drawn (§12.3, cardinality is
   * structural). The floor did need deferring, because every association passes
   * through having one role.
   *
   * Only the arc that would be the THIRD fails, not all three, so an imported
   * model with too many reports once rather than once per arc. A candidate with
   * no id yet — `mayConnect` asking mid-gesture — counts as newest.
   */
  Sienna.grammar.predicates.roleCountWithinLimit = function (cand, d) {
    if (cand.type !== 'role' || !cand.to) return true;
    var order = d.ids('arcs');
    var mine = cand.id ? order.indexOf(cand.id) : Infinity;
    var earlier = order.filter(function (a) {
      var arc = d.get(a);
      if (!arc || arc.type !== 'role' || arc.to !== cand.to || a === cand.id) return false;
      return order.indexOf(a) < mine;
    });
    return earlier.length < 2;
  };

  /**
   * A name must be unique among SIBLINGS — not across the model.
   *
   * Scoped, not global: confirmed from the 72 reference models, where 493
   * names repeat across different submodels against 3 within one. `x` appears
   * in four submodels of AntsWorld, and auto-generated names restart at `fn1`
   * inside each submodel, which is Simile's own name generator telling us the
   * scope it works in.
   *
   * Deferred, because the editor already prevents the two ways a user can
   * cause a clash: renaming is refused outright (`checkSiblingName`), and a
   * move renames the incomer (`commitDrag`). What is left for a rule to catch
   * is a model that arrived some other way — imported, or written by something
   * that is not this editor.
   */
  Sienna.grammar.predicates.siblingNameUnique = function (cand, d) {
    if (!cand.id || !d.get(cand.id)) return true;
    if (cand.family !== 'node' && cand.family !== 'submodel') return true;
    var label = (d.get(cand.id) || {}).label;
    return !label || !d.siblingNamed(cand.parent, label, cand.id);
  };

  Sienna.grammar.predicates.notInsideAStranger = function (cand, d) {
    if (!judgeable(d, cand)) return true;
    var mine = d.box(cand.id);
    var ancestors = d.ancestorsOf(cand.id) || [];
    return !d.ids('submodels').some(function (s) {
      if (s === cand.id || ancestors.indexOf(s) >= 0) return false;
      return within(mine, d.box(s));
    });
  };
}(window.Sienna));
