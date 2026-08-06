/**
 * `Sienna.grammar` — the graph-grammar engine of DESIGN-diagram.md §12.
 *
 * Rules are DATA, declared in the schema (§12.1). This evaluates them. It never
 * contains a rule itself: everything it knows about a notation comes from the
 * schema's `rules` array, so swapping the schema swaps the grammar.
 *
 * §12.4's callers, which are the whole public surface:
 *
 *   1. `mayConnect(d, type, from, to)` — may this arc be drawn? Mid-gesture.
 *   2. `mayContain(d, id, parent)`     — may this element live in there?
 *   3. `validate(d)`                   — is the whole model sound?
 *   4. `behaviour(d, family, type, n)` — how should the editor DRAW this?
 *
 * (2) doubles as the dry-run behind palette filtering when we build it.
 *
 * §12.3's enforcement classes decide what a caller does with the answer:
 * **structural** rules are preventive (refuse the gesture and say why),
 * **content** rules are deferred (reported, never blocking). **Behavioural**
 * facts are not rules here at all — see `behaviour()`.
 *
 * §12.5: rules quantify over DERIVED facts. A submodel's *conditional* and
 * *association* natures are inferred, never stored, so `parentKind` matches
 * against the inferred set as well as the declared `kind`.
 *
 * The escape hatch of §12.2: a rule may name a predicate registered in
 * `Sienna.grammar.predicates`. It may never carry a code string.
 *
 * Classic script; no imports/exports. Load after `src/diagram.js`.
 */
(function (Sienna) {
  'use strict';

  // ---- helpers ---------------------------------------------------------

  /** The 'type' of an endpoint for rule purposes: submodels are 'submodel'. */
  function endpointType(d, id) {
    if (!id) return null;
    if (String(id).indexOf('submodel') === 0) return 'submodel';
    var el = d.get(id);
    return el ? el.type : null;
  }

  /**
   * Every kind a submodel counts as: its declared membership kind plus the
   * kinds INFERRED from its contents (§4, decision #3). This is what makes the
   * engine depend on derived facts (§12.5).
   */
  function kindsOf(d, submodelId) {
    if (!submodelId) return ['root'];
    var el = d.get(submodelId);
    if (!el) return [];
    var kinds = [el.kind || 'single'];
    var isConditional = d.childrenOf(submodelId).some(function (c) {
      var n = d.get(c);
      return n && n.type === 'condition';
    });
    if (isConditional) kinds.push('conditional');
    var isAssociation = d.ids('arcs').some(function (a) {
      var arc = d.get(a);
      return arc && arc.type === 'role' && arc.to === submodelId;
    });
    if (isAssociation) kinds.push('association');
    return kinds;
  }

  /**
   * Does `subject` ('arc:flow', 'node:a|b', 'submodel', 'arc', '*') match?
   *
   * `'*'` means every element whatever its family — added 2026-08-06 for the
   * first rule that genuinely does not care (an element must be drawn inside
   * the submodel it belongs to, which is as true of a submodel as of a node).
   * The alternative was the same rule written once per family, which is the
   * kind of duplication that later drifts apart.
   */
  function subjectMatches(subject, family, type) {
    if (!subject) return false;
    if (subject === '*') return true;
    var parts = String(subject).split(':');
    if (parts[0] !== family) return false;
    if (parts.length === 1) return true;
    return parts[1].split('|').indexOf(type) >= 0;
  }

  /**
   * Evaluate one rule's terms against a candidate. Returns true when the terms
   * HOLD (i.e. the candidate is fine by this rule).
   *
   * A candidate is `{ family, type, from, to, parent, id }` — a prospective
   * element, which is what lets the same rules answer "may I?" about something
   * that does not exist yet.
   */
  function termsHold(d, terms, cand) {
    if (terms.ends) {
      var a = endpointType(d, cand.from);
      var z = endpointType(d, cand.to);
      if (a && terms.ends.indexOf(a) < 0) return false;
      if (z && terms.ends.indexOf(z) < 0) return false;
    }
    if (terms.toTypes) {
      var t = endpointType(d, cand.to);
      if (t && terms.toTypes.indexOf(t) < 0) return false;
    }
    if (terms.fromTypes) {
      var ft = endpointType(d, cand.from);
      if (ft && terms.fromTypes.indexOf(ft) < 0) return false;
    }
    if (terms.parentKind) {
      if (kindsOf(d, cand.parent).indexOf(terms.parentKind) < 0) return false;
    }
    if (terms.noReverse) {
      var clash = d.ids('arcs').some(function (a) {
        var arc = d.get(a);
        return arc && arc.type === cand.type && a !== cand.id
          && arc.from === cand.to && arc.to === cand.from;
      });
      if (clash) return false;
    }
    if (terms.predicate) {
      // §12.2: a NAME, never a code string. Unknown names fail loudly rather
      // than silently passing, so a typo cannot disable a rule.
      var fn = Sienna.grammar.predicates[terms.predicate];
      if (typeof fn !== 'function') {
        throw new Error('Unknown grammar predicate "' + terms.predicate + '".');
      }
      if (!fn(cand, d)) return false;
    }
    return true;
  }

  /** A rule holds when its terms hold, and its `not:` terms do NOT all hold. */
  function ruleHolds(d, rule, cand) {
    var positive = {};
    Object.keys(rule).forEach(function (k) {
      if (['id', 'subject', 'enforcement', 'confidence', 'message', 'not'].indexOf(k) < 0) {
        positive[k] = rule[k];
      }
    });
    if (Object.keys(positive).length && !termsHold(d, positive, cand)) return false;
    if (rule.not && termsHold(d, rule.not, cand)) return false;
    return true;
  }

  /**
   * Rules applying to a candidate, in schema order.
   *
   * `alsoDeferred` is what separates the two kinds of caller (§12.3). A gesture
   * asks only about **preventive** rules, because those are the ones that may
   * refuse it. The whole-model pass asks about **deferred** ones as well, since
   * reporting is exactly their job.
   *
   * Until 2026-08-06 nothing passed `alsoDeferred`, so a rule tagged `deferred`
   * was evaluated by nobody — the class existed in the schema and in §12.3 and
   * did nothing. It went unnoticed because every rule written so far happened
   * to be preventive.
   */
  function rulesFor(d, cand, alsoDeferred) {
    return (d.schema().rules || []).filter(function (r) {
      var cls = r.enforcement || 'preventive';
      if (cls !== 'preventive' && !(alsoDeferred && cls === 'deferred')) return false;
      return subjectMatches(r.subject, cand.family, cand.type);
    });
  }

  function firstBreach(d, cand) {
    var broken = null;
    rulesFor(d, cand).some(function (r) {
      if (!ruleHolds(d, r, cand)) {
        broken = { rule: r.id, message: r.message || ('Refused by rule ' + r.id) };
        return true;
      }
      return false;
    });
    return broken;
  }

  // ---- the four callers -------------------------------------------------

  Sienna.grammar = {
    /** §12.2's escape hatch: named predicates, registered here by the app. */
    predicates: {},

    /**
     * (1) May this arc be drawn? `from`/`to` are ids; either may be null when
     * the gesture has not landed yet (a flow drawn to blank canvas), and rules
     * simply do not constrain an end that does not exist yet.
     */
    mayConnect: function (d, type, from, to) {
      var breach = firstBreach(d, {
        family: 'arc', type: type, from: from, to: to,
        parent: d.nearestCommonAncestor(from, to),
      });
      return breach ? { ok: false, rule: breach.rule, message: breach.message } : { ok: true };
    },

    /**
     * (2) May this element live in this submodel? Used when placing, when
     * dropping, and — dry-run over the candidates — for palette filtering.
     */
    mayContain: function (d, idOrType, parent) {
      var type = d.get(idOrType) ? endpointType(d, idOrType) : idOrType;
      var family = String(idOrType).indexOf('submodel') === 0 || idOrType === 'submodel'
        ? 'submodel' : 'node';
      var breach = firstBreach(d, { family: family, type: type, parent: parent, id: idOrType });
      return breach ? { ok: false, rule: breach.rule, message: breach.message } : { ok: true };
    },

    /**
     * (3) Is the whole model sound? Every element checked against the rules for
     * its own family and type. Reported, never blocking — this is the pass that
     * catches states reached some other way (a capture, an import, a kind
     * changed under existing contents; §12.5's non-monotonicity).
     *
     * The only caller that evaluates **deferred** rules as well as preventive
     * ones: reporting is what a deferred rule is for.
     */
    validate: function (d) {
      var out = [];
      var check = function (id, family) {
        var el = d.get(id);
        if (!el) return;
        var cand = {
          family: family, type: family === 'submodel' ? 'submodel' : el.type,
          id: id, from: el.from, to: el.to,
          parent: family === 'arc' ? d.nearestCommonAncestor(el.from, el.to) : el.parent,
        };
        rulesFor(d, cand, true).forEach(function (r) {
          if (!ruleHolds(d, r, cand)) {
            out.push({ id: id, label: el.label || id, rule: r.id, message: r.message });
          }
        });
      };
      d.ids('nodes').forEach(function (i) { check(i, 'node'); });
      d.ids('arcs').forEach(function (i) { check(i, 'arc'); });
      d.ids('submodels').forEach(function (i) { check(i, 'submodel'); });
      return out;
    },

    /**
     * (4) How should the editor draw or resolve this? Behavioural facts (§12.3)
     * are NOT rules to be checked — they configure a gesture, carry no message,
     * and no gesture can violate them. They are therefore read from the
     * VOCABULARY, where each type declares them, rather than duplicated in the
     * rules array. This method exists so callers ask the grammar rather than
     * reaching into the schema.
     */
    behaviour: function (d, family, type, name) {
      var spec = family === 'arc' ? d.schema().arcs[type] : d.schema().nodes[type];
      return spec ? spec[name] : undefined;
    },
  };
})(window.Sienna);
