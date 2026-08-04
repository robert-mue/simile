/**
 * `simile-v1` — the schema for Simile's System Dynamics notation.
 *
 * A schema declares a notation: its **vocabulary** (which node/arc types exist
 * and how they behave), its **grammar** (what may connect to what, and what may
 * contain what), its **dialog fields** (what each type stores), and its
 * **styling** (how each type is drawn). DESIGN-diagram.md §3 calls these the
 * four faces. Swapping this file for another (e.g. SBML) is what makes the
 * editor notation-neutral, so **nothing here may be hard-wired in the editor**.
 *
 * Delivered as a `.js` file registering on `window.Sienna`, not as fetched
 * JSON, because the app runs from `file://` where `fetch` is blocked (§3).
 * Everything below is nevertheless plain data — no code, no regexes beyond the
 * naming rule — so it stays exportable to other tools.
 *
 * STATUS: partial and honest about it. The vocabulary is close to complete; the
 * grammar is the deliberately incomplete starter set of §12.7 (each rule tagged
 * `known` or `guess`, pending the Simile developer's catalogue), and **no rule
 * is enforced yet** — there is no grammar engine. The rules are here so that
 * the engine, when written, has something real to run against.
 *
 * Classic script; no imports/exports. Load before `src/diagram.js`.
 */
(function (Sienna) {
  'use strict';

  // --- a minimal schema registry (app-level; the shell has no opinion) ------
  if (!Sienna.schemas) {
    var registry = {};
    Sienna.schemas = {
      register: function (name, schema) { registry[name] = schema; return schema; },
      get: function (name) {
        var s = registry[name];
        if (!s) throw new Error('Unknown schema "' + name + '".');
        return s;
      },
      has: function (name) { return Object.prototype.hasOwnProperty.call(registry, name); },
      list: function () { return Object.keys(registry); },
    };
  }

  Sienna.schemas.register('simile-v1', {
    name: 'simile-v1',
    label: 'Simile (System Dynamics)',

    // =====================================================================
    // 1. NAMING (§14)
    // =====================================================================
    // A label IS the equation name (they are enforced identical), so equation
    // syntax constrains what a user may type. Only the no-spaces rule is
    // confirmed; the rest of Simile's rules are still to come.
    naming: {
      forbidPattern: '\\s',
      message: 'Labels may not contain spaces.',
    },

    // =====================================================================
    // 2. VOCABULARY (§3.1)
    // =====================================================================
    // Per-type declarations. `label` says whether the type carries a
    // user-editable label (which doubles as its equation name); `autoCreated`
    // marks types the editor creates as a side effect of another gesture,
    // never from the palette.
    nodes: {
      compartment:  { label: true,  fields: ['initial'] },
      variable:     { label: true,  fields: ['value'] },
      cloud:        { label: 'optional', autoCreated: true, fields: [] },
      valve:        { label: true,  autoCreated: true, fields: ['rate'] },
      condition:    { label: true,  fields: ['expr'] },
      initialiser:  { label: true,  fields: ['expr'] },
      migrator:     { label: true,  fields: ['expr'] },
      exterminator: { label: true,  fields: ['expr'] },
      reproduction: { label: true,  fields: ['expr'] },
    },

    arcs: {
      // A flow carries no label: its name lives on its valve, which also holds
      // the rate equation and is what influences into a flow actually target
      // (§4). `blankEnd` is the node auto-created when a flow is drawn from or
      // to empty space. `branches:false` because branching a flow would divide
      // the quantity it carries (§13.3).
      flow: {
        label: false,
        branches: false,
        attachmentNode: 'valve',
        blankEnd: 'cloud',
        fields: [],
      },
      // An influence carries information rather than stuff, so it may branch
      // freely. It has no label, but it does carry the local name (alias) the
      // target's equation uses for the imported value (§14.1).
      influence: {
        label: false,
        branches: true,
        alias: true,
        fields: [],
      },
      // The one arc type with a label. A role arc runs from a submodel to the
      // submodel that thereby becomes an association (§4: S1→S3 and S2→S3,
      // never S1→S2).
      role: {
        label: true,
        branches: false,
        fields: [],
      },
    },

    // Membership kinds only. *Conditional* and *association* are INFERRED from
    // contents and role arcs, never stored (§4, decision #3).
    submodelKinds: ['single', 'fixed-membership', 'population'],

    // =====================================================================
    // 3. GRAMMAR (§12) — starter set, NOT YET ENFORCED
    // =====================================================================
    // `enforcement` picks the class from §12.3:
    //   'preventive'  — structural; refuse the gesture, show `message`
    //   'behavioural' — no gesture can violate it; it configures what the
    //                   editor does, carries no message, never surfaces
    //   'deferred'    — content; report via completeness colouring, never block
    // `confidence` is 'known' or 'guess' (§12.7): a wrong guess is one line.
    rules: [
      { id: 'flow-ends', subject: 'arc:flow', ends: ['compartment', 'cloud'],
        enforcement: 'preventive', confidence: 'known',
        message: 'A flow must run between compartments or clouds.' },

      { id: 'flow-not-cloud-to-cloud', subject: 'arc:flow',
        not: { ends: ['cloud', 'cloud'] },
        enforcement: 'preventive', confidence: 'guess',
        message: 'A flow must have a compartment at at least one end.' },

      { id: 'role-ends', subject: 'arc:role', ends: ['submodel', 'submodel'],
        enforcement: 'preventive', confidence: 'known',
        message: 'A role arc must run from a submodel to an association submodel.' },

      { id: 'influence-target', subject: 'arc:influence',
        toTypes: ['variable', 'valve', 'condition', 'compartment'],
        enforcement: 'preventive', confidence: 'guess',
        message: 'An influence must end at a variable, valve, condition or compartment.' },

      // NO cardinality limit on conditions: a submodel may hold any number, and
      // they are AND-ed together (Simile developer, 2026-08-04). The earlier
      // `one-condition` rule guessed max:1 and was simply wrong — removed rather
      // than relaxed, since there is nothing left to constrain.

      // (4) A condition may not sit in a population submodel.
      { id: 'condition-not-in-population', subject: 'node:condition',
        not: { parentKind: 'population' },
        enforcement: 'preventive', confidence: 'known',
        message: 'A condition symbol may not appear inside a population submodel.' },

      // (2) Roles between two submodels are one-directional: given S1->S2, the
      // reverse S2->S1 is refused. `noReverse` is a new vocabulary term — the
      // rule quantifies over the arcs that already exist, which the endpoint
      // tables could not express.
      { id: 'no-reverse-role', subject: 'arc:role', noReverse: true,
        enforcement: 'preventive', confidence: 'known',
        message: 'These two submodels already have a role arc in the other direction.' },

      { id: 'population-symbols',
        subject: 'node:initialiser|migrator|exterminator|reproduction',
        parentKind: 'population',
        enforcement: 'preventive', confidence: 'known',
        message: 'Population symbols may only appear inside a population submodel.' },

      // Behavioural: no gesture can violate these, so they carry no message.
      // They tell the arc-drawing routine what to do (§12.3, §12.4 q4).
      { id: 'influence-branches', subject: 'arc:influence', branches: true,
        enforcement: 'behavioural', confidence: 'known' },

      { id: 'flow-role-no-branch', subject: 'arc:flow|arc:role', branches: false,
        enforcement: 'behavioural', confidence: 'known' },

      { id: 'no-arc-on-arc', subject: 'arc', endsOn: 'node|submodel',
        enforcement: 'behavioural', confidence: 'known' },
    ],

    // =====================================================================
    // 4. STYLING (§6) — the cascade's base layer
    // =====================================================================
    // Only the part that has a structural consequence is filled in: `resizable`
    // decides whether an element's layout carries w/h at all (§6). Glyphs,
    // colours and fonts arrive with the renderer.
    style: {
      compartment:  { shape: 'rect',    resizable: true,  w: 60, h: 40 },
      variable:     { shape: 'circle',  resizable: false, w: 30, h: 30 },
      cloud:        { shape: 'cloud',   resizable: false, w: 40, h: 26 },
      valve:        { shape: 'valve',   resizable: false, w: 20, h: 20 },
      condition:    { shape: 'diamond', resizable: false, w: 30, h: 30 },
      submodel:     { shape: 'rect',    resizable: true,  w: 200, h: 140 },
    },
  });
})(window.Sienna);
