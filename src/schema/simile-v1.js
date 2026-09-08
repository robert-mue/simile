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
    // A label IS the equation name (§14), so what may be typed is exactly what
    // the equation grammar will accept as an identifier — `[A-Za-z_][A-Za-z0-9_]*`.
    // This pattern is its negation: any character outside that set, or a
    // leading digit.
    //
    // Tightened 2026-08-08, from `\s` (spaces only). Reconstructing LAMOS
    // showed the hole: Simile labels an element `spark?` and its own equations
    // then refer to `spark_`, substituting the illegal character — so `?` was
    // legal as a label here while being unusable in any equation, which is
    // precisely the split §14 exists to prevent. The rule and the grammar now
    // agree by construction.
    //
    // The cost is the same one §14 already accepted for spaces: `spark?`
    // becomes `spark_`, and the question mark's hint that a value is boolean is
    // lost. Simile makes the same substitution internally; the difference is
    // that it keeps the prettier form to display and we do not.
    naming: {
      forbidPattern: '[^A-Za-z0-9_]|^[0-9]',
      message: 'A label is also the equation name: letters, digits and '
             + 'underscores only, and it may not start with a digit.',
    },

    // =====================================================================
    // 2. VOCABULARY (§3.1)
    // =====================================================================
    // Per-type declarations. `has_label` says whether the type carries a
    // user-editable label at all — distinct from a field descriptor's `label`,
    // which is that field's display name. `autoCreated`
    // marks types the editor creates as a side effect of another gesture,
    // never from the palette.
    // `required: true` on a field means the element is INCOMPLETE (red, §19.9)
    // until it is filled in. Units are not required — a model runs without
    // them. `requiredWhen` makes it conditional on another field's value, which
    // a submodel's `dimensions` needs: demanding it of every submodel would
    // leave every single-instance one permanently red.
    nodes: {
      stock:        { has_label: true,  fields: [
        { name: 'initial', label: 'Initial value', type: 'expression', required: true,
          help: 'Value at the start of the run.' },
        { name: 'units',   label: 'Units', type: 'text' },
      ] },
      variable:     { has_label: true,  fields: [
        { name: 'value', label: 'Value or expression', type: 'expression', required: true },
        { name: 'units', label: 'Units', type: 'text' },
      ] },
      cloud:        { has_label: 'optional', autoCreated: true, fields: [] },
      // A valve has no position of its own: it rides at the midpoint of its
      // flow, so dragging either end carries it along. Derived geometry is
      // never stored (§10.2).
      //
      // `labelStem` is what a new one is CALLED, where that differs from what
      // its type is: a valve's default name is `flow1`, not `valve1`. The node
      // is a valve — that is the symbol on the diagram and the thing that holds
      // the rate — but what the modeller names is the process the flow carries,
      // `growth` or `harvest`. System Dynamics has always named it that way,
      // and a convention borrowed whole is a smaller hurdle than a better one
      // invented here. Every other type takes its own name as the stem.
      valve:        { has_label: true,  labelStem: 'flow', autoCreated: true,
                      positionedBy: 'arc', fields: [
        { name: 'rate',  label: 'Rate', type: 'expression', required: true,
          help: 'Rate of flow.' },
        { name: 'units', label: 'Units', type: 'text' },
      ] },
      condition:    { has_label: true,  fields: [
        { name: 'expr', label: 'Condition', type: 'expression', required: true,
          help: 'The submodel exists for a member when this is true.' },
      ] },
      initialiser:  { has_label: true,  fields: [{ name: 'expr', label: 'Number created', type: 'expression', required: true }] },
      migrator:     { has_label: true,  fields: [{ name: 'expr', label: 'Migration condition', type: 'expression', required: true }] },
      exterminator: { has_label: true,  fields: [{ name: 'expr', label: 'Removal condition', type: 'expression', required: true }] },
      reproduction: { has_label: true,  fields: [{ name: 'expr', label: 'Number of offspring', type: 'expression', required: true }] },

      // ---- event-based modelling: DECLARED, NOT IMPLEMENTED ----
      //
      // `alarm` is Simile's event signal, and event-based modelling was set
      // aside at the start of this exercise as an advanced feature to come back
      // to. It is here because a model that contains one must be readable
      // rather than silently stripped, and because a greyed-out palette entry
      // is a better reminder than a note in a file nobody opens.
      //
      // What it is, measured from `prime.pl` (2026-08-13, confirmed unchanged
      // by Simile 7.4): a **boolean-valued element whose name other equations
      // reference** — `done_checks` in `if done_checks then 0 else prev(0)+1`,
      // `found_prime` in `if found_prime then start_prime else prev(0)+2`. It
      // is NOT a membership condition: `prime` contains no `condition` node at
      // all. So its field model is `condition`'s, and its `units` are
      // `boolean`.
      //
      // `notImplemented` is what the palette reads to grey the button out and
      // title it. One alarm is almost certainly not enough to DO event-based
      // modelling — there will be machinery around it we have not looked at —
      // which is exactly why the button is disabled rather than merely ugly.
      alarm: {
        has_label: true,
        notImplemented: 'Not yet implemented',
        fields: [
          { name: 'expr', label: 'Fires when', type: 'expression', required: true,
            help: 'A condition. Event-based modelling is not implemented yet: '
                + 'an alarm read from a Simile model is kept and drawn, but a '
                + 'new one cannot be drawn and its behaviour is not simulated.' },
        ],
      },
    },

    // A submodel is one object whose KIND is a property (§2), so its dialog is
    // where that gets chosen. `target: 'kind'` says the value is stored on the
    // element itself rather than in its props.
    submodel: {
      has_label: true,
      fields: [
        { name: 'kind', label: 'Membership', type: 'choice', target: 'kind',
          options: [
            { value: 'single', label: 'Single instance' },
            { value: 'fixed-membership', label: 'Fixed membership' },
            { value: 'population', label: 'Population' },
          ] },
        // `expression-list`, not `expression`, because Simile's membership is
        // per DIMENSION: `count=[4,44]` is a 4×44 grid of instances, two sizes
        // and not one expression. Held as the comma-separated text the modeller
        // typed, since that is also exactly what `count=[…]` wants; the
        // completeness check splits it on top-level commas and reads each part
        // as an expression of its own.
        //
        // It was `expression` until 2026-08-12, which meant every
        // multi-dimensional submodel in the catalogue — `hexagon`'s `9,9`, the
        // three `test02` files' `4,44` — was drawn RED with a syntax error on a
        // model that is perfectly legal. Found by harvesting the corpus through
        // the importer (STATUS item 37).
        { name: 'dimensions', label: 'Number of instances', type: 'expression-list',
          requiredWhen: { kind: 'fixed-membership' },
          help: 'Fixed-membership submodels only. One size per dimension, '
              + 'separated by commas — "4,44" is a 4 × 44 grid.' },
      ],
    },

    arcs: {
      // A flow carries no label: its name lives on its valve, which also holds
      // the rate equation and is what influences into a flow actually target
      // (§4). `blankEnd` is the node auto-created when a flow is drawn from or
      // to empty space. `branches:false` because branching a flow would divide
      // the quantity it carries (§13.3).
      flow: {
        has_label: false,
        branches: false,
        attachmentNode: 'valve',
        blankEnd: 'cloud',
        fields: [],
      },
      // An influence carries information rather than stuff, so it may branch
      // freely. It has no label, but it does carry the local name (alias) the
      // target's equation uses for the imported value (§14.1) — and, where it
      // crosses an association, one name PER ROLE in `roleAliases`, since the
      // value arrives once for each. Simile imposes no convention on those
      // names, so they are stored rather than derived; `Diagram.roleAliasFor`
      // is the one place that decides.
      influence: {
        has_label: false,
        branches: true,
        alias: true,
        fields: [],
      },
      // The one arc type with a label. A role arc runs from a submodel to the
      // submodel that thereby becomes an association (§4: S1→S3 and S2→S3,
      // never S1→S2).
      role: {
        has_label: true,
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
      { id: 'flow-ends', subject: 'arc:flow', ends: ['stock', 'cloud'],
        enforcement: 'preventive', confidence: 'known',
        message: 'A flow must run between stocks or clouds.' },

      { id: 'flow-not-cloud-to-cloud', subject: 'arc:flow',
        not: { ends: ['cloud', 'cloud'] },
        enforcement: 'preventive', confidence: 'guess',
        message: 'A flow must have a stock at at least one end.' },

      { id: 'role-ends', subject: 'arc:role', ends: ['submodel', 'submodel'],
        enforcement: 'preventive', confidence: 'known',
        message: 'A role arc must run from a submodel to an association submodel.' },

      // The legal targets are the types that CARRY AN EQUATION — an influence
      // exists to feed a value into one. Keep that reason in mind when adding a
      // type: the list is data (so the schema stays exportable), which means it
      // does not update itself.
      //
      // The population symbols were missing until the farmers & fields
      // reference model was built (2026-08-06) and refused an influence into
      // its exterminator — whose whole expression is `wealth<10`. Exactly what
      // `confidence: 'guess'` is for. Still a guess: it now covers every type
      // we know needs it, but whether a submodel may be influenced (to drive
      // its `dimensions`) is unasked — see §8.
      { id: 'influence-target', subject: 'arc:influence',
        toTypes: ['variable', 'valve', 'condition', 'stock',
                  'initialiser', 'migrator', 'exterminator', 'reproduction'],
        enforcement: 'preventive', confidence: 'guess',
        message: 'An influence must end at something that carries an equation.' },

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

      // (5) The picture must agree with the model about containment. These are
      // the first DEFERRED rules — reported by the model check, never blocking,
      // because dragging an element out of a submodel is how you re-parent it
      // and the drop is what decides. `subject: '*'` because the rule is as
      // true of a submodel as of a node.
      //
      // Worth having even though a dropped element cannot disagree with itself:
      // dropping is not the only way a model gets built. An AI assistant
      // writing one, or an automatic layout moving things, both bypass the
      // gesture and have no reason to keep model and layout in step (user,
      // 2026-08-06). The predicates are code, so they live in
      // `src/predicates.js`; this file stays plain data (§12.2).
      // PREVENTIVE since 2026-08-09: the editor clamps a drag at the boundary,
      // so this cannot be reached by dragging (confirmed as Simile's own
      // behaviour). It stays in the catalogue because a diagram can arrive by
      // other means — an importer, a layout pass, an AI assistant — and those
      // are exactly the producers §12 exists to judge.
      { id: 'inside-its-parent', subject: '*', predicate: 'insideItsParent',
        enforcement: 'preventive', confidence: 'known',
        message: 'This is drawn outside the submodel it belongs to.' },

      { id: 'not-inside-a-stranger', subject: '*', predicate: 'notInsideAStranger',
        enforcement: 'preventive', confidence: 'known',
        message: 'This is drawn inside a submodel it does not belong to.' },

      // (6) Names are unique among SIBLINGS, not across the model — the same
      // name may, and often will, be used in different submodels (confirmed
      // 2026-08-06 against the reference models: 493 repeats across submodels,
      // 3 within one). Deferred because the editor already stops the two ways
      // a user can cause a clash — a rename is refused, a move renames the
      // incomer — so what is left to catch is a model that arrived some other
      // way.
      { id: 'sibling-names-unique', subject: '*', predicate: 'siblingNameUnique',
        enforcement: 'deferred', confidence: 'known',
        message: 'Another element in the same submodel already has this name.' },

      // (7) How many role arcs point at a submodel is what decides its kind
      // (Simile developer, 2026-08-08): ONE makes it a **satellite**, TWO an
      // **association** (§4), and more than two is not legal. Both kinds are
      // inferred in `kindsOf`, never stored, alongside `conditional`.
      //
      // PREVENTIVE, because a ceiling has no legitimate intermediate state —
      // nobody passes through three roles on the way to something valid, so the
      // third arc is refused as it is drawn (§12.3: cardinality is structural).
      //
      // This corrects a rule written the day before which had it the other way
      // up — that an association *needs* two, so one was a half-built one.
      // One role is not half of anything.
      { id: 'role-arcs-at-most-two', subject: 'arc:role',
        predicate: 'roleCountWithinLimit',
        enforcement: 'preventive', confidence: 'guess',
        message: 'A submodel may take at most two role arcs — one makes it a satellite, two an association.' },

      // Behavioural facts — "an influence may branch", "a flow may not", "an
      // arc never terminates on an arc" — are deliberately NOT listed here.
      // They live in the VOCABULARY above, on each type (`branches`,
      // `attachmentNode`), which is where the arc-drawing routine already reads
      // them. Holding them here as well meant the same fact twice. Callers
      // reach them through Sienna.grammar.behaviour(); see §12.3 and §12.4 q4.
    ],

    // =====================================================================
    // 4. EQUATION FUNCTIONS (§19.5) — name → how many arguments
    // =====================================================================
    // Deliberately NOT in the PEG (see src/equation-grammar.js). Keeping the
    // vocabulary here rather than in the grammar means adding a function — or
    // one day letting a user declare their own — is a line of data, and it lets
    // "no such function" be reported differently from "that is not an
    // expression". Ruled 2026-08-06.
    //
    // A number is an exact count. An ARRAY IS A SET OF ALLOWED COUNTS, not a
    // range: `at_posn: [1, 3]` means one argument or three, never two.
    //
    // Provenance. The names and arities come from the five function pages under
    // simulistics.com/help/equations/. The 41 marked ✓ are confirmed by use in
    // the 72 reference models, whose arities also settled a discrepancy: the
    // help documents `pi()`, `time()` and friends as nullary, while real models
    // write `pi(1)` and `time(1)`, so those take an optional dummy argument.
    // The unmarked ones are from the help pages alone and are a first draft, to
    // be checked type by type like the property lists.
    functions: {
      // arithmetic
      abs: 1,           // ✓
      ceil: 1,          // ✓
      exp: 1,           // ✓
      floor: 1,         // ✓
      fmod: 2,          // ✓
      hypot: 2,         // ✓
      inf: [0, 1],
      int: 1,           // ✓
      log: 1,           // ✓
      log10: 1,
      max: 2,           // ✓
      min: 2,           // ✓
      pi: [0, 1],       // ✓
      pow: 2,           // ✓
      round: 1,
      sgn: 1,           // ✓
      sqrt: 1,          // ✓

      // trigonometric
      acos: 1,
      asin: 1,
      atan: 1,          // ✓
      atan2: 2,
      cos: 1,           // ✓
      cosh: 1,
      sin: 1,           // ✓
      sinh: 1,
      tan: 1,           // ✓
      tanh: 1,

      // statistics and random
      binome: 2,
      exprnd: [1, 2],
      gaussian_var: 2,
      hypergeom: 3,
      poidev: 1,
      rand: 2,          // ✓ — used by the models, absent from the help pages
      rand_const: 2,    // ✓
      rand_var: 2,      // ✓

      // list and array handling
      all: 1,           // ✓
      any: 1,           // ✓
      colin: 1,
      count: 1,         // ✓
      element: 2,       // ✓
      firsttrue: 1,
      greatest: 1,      // ✓
      howmanytrue: 1,
      least: 1,         // ✓
      makearray: 2,     // ✓
      order: 1,
      posgreatest: 1,
      posleast: 1,      // ✓
      product: 1,
      rankings: 1,
      subtotals: 1,
      sum: 1,           // ✓
      with_colin: 2,
      with_greatest: 2,
      with_least: 2,

      // time and dynamics
      after: 2,
      at_init: 1,
      const_delay: 2,
      delay1: 2,
      delay3: 2,
      delayn: 3,
      dt: [0, 1],       // ✓
      forcst: [3, 4],
      init_time: [0, 1],// ✓
      last: 1,          // ✓
      prev: 1,          // ✓
      pulse: [2, 3],
      ramp: 2,
      smth1: 2,
      smth3: 2,
      smthn: 3,
      step: 2,
      time: [0, 1],     // ✓
      trend: [2, 3],
      var_delay: 2,

      // model properties
      as_number: 1,
      at_posn: [1, 3],
      channel_is: 1,
      dies_of: 1,
      first: 1,
      following: 1,
      in_preceding: 1,
      in_progenitor: 1,
      index: 1,         // ✓
      iterations: 1,    // ✓
      parent: 1,
      place_in: 1,      // ✓
      preceding: 1,
      size: [1, 2],     // ✓
      sofar: 1,
      trigger_magnitude: [0, 1],

      // graph, table and other lookups
      graph: 1,         // ✓
      interpolate: 3,
      stop: 1,
      table: 1,         // ✓
    },

    // =====================================================================
    // 4b. HOW THE FUNCTIONS ARE GROUPED, for a chooser (§23.1)
    // =====================================================================
    // The five groups Simile's own help divides its built-ins into. Membership
    // comes from each group's page under
    //
    //   simulistics.com/help/equations/builtin.htm — the five
    //   "Built-in functions : …" links at the foot of it
    //
    // but the ORDER and the SPELLING come from the equation dialogue itself
    // (help/equations/dialogue.htm), which is what a Simile user has actually
    // looked at: alphabetical, and `Trigonometry` rather than the index page's
    // "Trigonometric functions". Where the two sources differ about
    // presentation, the screen wins — the point of matching is recognition.
    //
    // Grouping is presentation, but it is the NOTATION's presentation and not
    // this editor's, so it is data here rather than a list in the dialog: a
    // different schema groups its own functions its own way, or omits this and
    // gets no tree. It is deliberately separate from `functions` above, which
    // stays a flat name→arity table because that is what the checker wants and
    // membership of a menu is no business of the arity check.
    //
    // TWO HONEST GAPS, both left visible rather than papered over:
    //
    //   1. `hypot` appears in TWO groups (arithmetic and trigonometric), which
    //      is how the help lists it. Repeated here rather than assigned, since
    //      choosing for Simile would be inventing.
    //   2. Eight functions we know — `firsttrue`, `graph`, `howmanytrue`, `pi`,
    //      `posgreatest`, `posleast`, `rand`, `table` — are in NO group, because
    //      the help's five pages do not list them; most came from the corpus,
    //      which outranks the documentation (§19.2). They are therefore absent
    //      from the tree while remaining perfectly legal to type. Whether they
    //      deserve a sixth group is Robert's call, not a thing to invent here.
    functionGroups: [
      { label: 'Arithmetic', functions: [
        'abs', 'ceil', 'exp', 'floor', 'fmod', 'hypot', 'inf', 'int', 'log',
        'log10', 'max', 'min', 'pow', 'round', 'sgn', 'sqrt'] },
      { label: 'List handling', functions: [
        'all', 'any', 'element', 'greatest', 'interpolate', 'least', 'makearray',
        'order', 'place_in', 'product', 'rankings', 'subtotals', 'sum',
        'with_greatest', 'with_least'] },
      { label: 'Model properties', functions: [
        'after', 'as_number', 'at_init', 'at_posn', 'channel_is', 'const_delay',
        'count', 'delay1', 'delay3', 'delayn', 'dies_of', 'dt', 'first',
        'following', 'forcst', 'in_preceding', 'in_progenitor', 'index',
        'init_time', 'iterations', 'last', 'parent', 'preceding', 'prev',
        'pulse', 'ramp', 'size', 'smth1', 'smth3', 'smthn', 'sofar', 'step',
        'stop', 'time', 'trend', 'trigger_magnitude', 'var_delay'] },
      { label: 'Statistics', functions: [
        'binome', 'colin', 'exprnd', 'gaussian_var', 'hypergeom', 'poidev',
        'rand_const', 'rand_var', 'with_colin'] },
      { label: 'Trigonometry', functions: [
        'acos', 'asin', 'atan', 'atan2', 'cos', 'cosh', 'hypot', 'sin', 'sinh',
        'tan', 'tanh'] },
    ],

    // =====================================================================
    // 4c. WHAT EACH FUNCTION IS, for a tooltip (§23.2)
    // =====================================================================
    // `name: [signature, description]`, both taken from Simile's own help —
    // one page per function under simulistics.com/help/equations/functions/,
    // plus help/equations/trig.htm, which documents its eleven inline.
    //
    // Quoted rather than paraphrased, because a description of `smth3` or
    // `in_progenitor` invented here would be a guess wearing the authority of
    // the tooltip. Sixteen were edited by hand where the page's own layout
    // defeated extraction — a signature given as an example, a description that
    // was really the first bullet of an argument list — and those are the only
    // ones whose wording is ours rather than theirs.
    //
    // `sofar` is honest about a gap at the source: its help page gives the
    // syntax and then says "Result is…" and stops.
    //
    // The signature is Simile's, so its argument names are the ones the help
    // uses; the placeholders actually INSERTED come from the arity table above,
    // which is a different thing and deliberately so — one is documentation,
    // the other is what the checker will judge.
    functionHelp: {
      abs: ['abs(X)', 'Returns the absolute value of X - i.e. ignores its sign.'],
      acos: ['acos(X)', 'Returns the arccos (inverse cosine) of X. Result is in radians.'],
      after: ['after(T, M)', 'Use only as whole equation of derived event. Instead of firing immediately when triggered, event is delayed by value of 1st argument, then fires with…'],
      all: ['all([X])', 'Result is true if all the elements of the array [X] or the list {X} are true.'],
      any: ['any([X])', 'Result is true if any of the elements of the array [X] or the list {X} are true.'],
      as_number: ['as_number(N)', 'Converts integral types to integer.'],
      asin: ['asin(X)', 'Returns the arcsine of X. Result is in radians.'],
      at_init: ['at_init(X)', 'Returns the value the argument had when first used, i.e., on model reset or when the submodel instance containing this equation was created.'],
      at_posn: ['at_posn(C)', 'Must form the whole equation of a component. Sets the component\'s value to the value of a component in an instance of a 2-D submodel representing a gr…'],
      atan: ['atan(X)', 'Returns a value in radians (range -pi/2 to pi/2), being the arctangent of X (the ratio of two sides of a right triangle). Same as arctan(X).'],
      atan2: ['atan2(X,Y)', 'Returns the arctangent of X. Result is in radians.'],
      binome: ['binome(prob, n)', 'The binomial distribution describes the probability of a given number of positive outcomes occurring when a number n of trials are carried out, each w…'],
      ceil: ['ceil(X)', 'Rounds up X to the next whole number (stands for \'ceiling\').'],
      channel_is: ['channel_is(X)', 'X is an immigration, reproduction or creation channel. Returns true if this individual appeared through that channel.'],
      colin: ['colin([Array])', 'Returns a deviate from a distribution whose relative probabilities are given by the values in the argument array.'],
      const_delay: ['const_delay(var,n)', 'This function returns some previous value of another variable, a arbitrary period of time before.'],
      cos: ['cos(X)', 'Returns the cosine of X (an angle in radians).'],
      cosh: ['cosh(X)', 'Hyperbolic cosine of X.'],
      count: ['count([X]) count({X})', 'Number of values in the array [X] or the list {X}.'],
      delay1: ['delay1(input, duration [, initial])', 'Returns input delayed by duration — a first-order material delay.'],
      delay3: ['delay3(input, duration [, initial])', 'Returns input delayed by duration — a third-order material delay.'],
      delayn: ['delayn(input, duration, n [, initial])', 'Returns input delayed by duration — a material delay of order n.'],
      dies_of: ['dies_of(X)', 'Returns true if argument is the loss channel that will cause the individual to disappear at the end of the current time step.'],
      dt: ['dt(I)', 'Returns the duration of the level I time step.'],
      element: ['element([X],I)', 'Picks the I th value from the array [X].'],
      exp: ['exp(X)', 'Returns e (the base of natural logarithms) to the power X.'],
      exprnd: ['exprnd(mean [, seed])', 'value sampled from an exponential distribution (numerical).'],
      first: ['first(T)', 'Takes an argument T that is a member of an enumerated type, and returns "true" if it is the first member of its type, and "false" otherwise.'],
      floor: ['floor(X)', 'Rounds X down to a whole number.'],
      fmod: ['fmod(X,Y)', 'Returns remainder after dividing X by Y.'],
      following: ['following(T)', 'Takes an argument T that is a member of an enumerated type, and returns the next member of the enumerated type.'],
      forcst: ['forcst(input, time, horizon [, initial])', 'Simple trend extrapolation: calculates the trend in input over the averaging time, then extrapolates it horizon into the future.'],
      gaussian_var: ['gaussian_var(mean, sd)', 'A random sample from a Gaussian (normal) distribution with the given mean and standard deviation, redrawn each time step.'],
      greatest: ['greatest([X]) greatest({X})', 'Returns the largest value from an array [X] or the list {X}.'],
      hypergeom: ['hypergeom(Pop, Mark, Sample)', 'Returns a deviate from a hypergeometric distribution for a given population, number of marks, and size of sample.'],
      hypot: ['hypot(X,Y)', 'Returns length of hypotenuse of right-angle triangle with base X and height Y.'],
      in_preceding: ['in_preceding(X)', 'Used in a multi-instance submodel, returns the value of X as it would be in the preceding instance, or 0/false in the first instance.'],
      in_progenitor: ['in_progenitor(X)', 'Used in a population submodel, returns the value of X as it would be in the instance holding the reproduction channel responsible for this one.'],
      index: ['index(I)', 'Returns the index (instance number) of a member of a fixed-membership or population submodel, for the nesting level I.'],
      inf: ['inf()', 'Returns the value of positive infinity.'],
      init_time: ['init_time(1)', 'Returns the time at which this model component first came into existence. This really only has any use for:.'],
      int: ['int(X)', 'Returns integer part of X.'],
      interpolate: ['interpolate(X, [Xarray], [Yarray])', 'X is an input value. The arrays Xarray and Yarray define a series of coordinates.'],
      iterations: ['iterations(X)', 'Returns number of iterations that have been done up to this point in an alarm submodel. Argument is the boolean balue from the alarm symbol.'],
      last: ['last(X)', 'Recalls value of X, another element, from previous time step. X must influence this element in order to be used in the equation.'],
      least: ['least([X]) least({X})', 'Returns the smallest value from an array [X] or the list {X}.'],
      log: ['log(X)', 'Returns natural logarithm of X.'],
      log10: ['log10(X)', 'Returns base-10 logarithm of X.'],
      makearray: ['makearray(X,N)', 'Makes an array consisting of N lots of X.'],
      max: ['max(X,Y)', 'Returns greater of X and Y; i.e. it returns X if X>=Y, otherwise it returns Y.'],
      min: ['min(X,Y)', 'Returns lesser of X and Y; i.e. it returns X if X<=Y, otherwise it returns Y.'],
      order: ['order([X])', 'Takes an array of numeric values and returns an array containing the indices of those values in ascending order.'],
      parent: ['parent(1)', 'Returns the id (instance number) of the individual whose reproduction gave rise to this one, or 0 if the individual being considered was created at th…'],
      place_in: ['place_in(I)', 'When making an array with the makearray function , place_in() returns the current position in the array.'],
      poidev: ['poidev(mean)', 'The poisson distribution describes the probability of a given number of positive outcomes occurring in the limiting case of the binomial distribution,…'],
      pow: ['pow(X,Y)', 'Returns X raised to the power Y.'],
      preceding: ['preceding(T)', 'Takes an argument T that is a member of an enumerated type, and returns the previous member of the enumerated type.'],
      prev: ['prev(N)', 'Returns the value of this element itself, N time steps ago. See last , for a function that returns a previous value of any element other than this one…'],
      product: ['product([X])', 'Result is the product of all elements of the array [X] or the list {X}.'],
      pulse: ['pulse(magnitude, first_time [, interval])', 'Generate a pulse with a duration of a single time step and a given cumulative value.'],
      ramp: ['ramp(time,slope)', 'Generates a ramp of slope slope, starting at time time and zero before that time.'],
      rand_const: ['rand_const(X,Y)', 'Returns a random number between X and Y at the start of the simulation or when the submodel instance is created.'],
      rand_var: ['rand_var(X,Y)', 'Returns a random number between X and Y, with a new value every time step.'],
      rankings: ['rankings([X])', 'Returns an array with the ranks of the corresponding elements: 1 for the largest, the array size for the smallest.'],
      round: ['round(X)', 'Rounds X up or down to the nearest whole number.'],
      sgn: ['sgn(X)', 'Returns -1 if X is negative, or 1 if X is zero or positive.'],
      sin: ['sin(X)', 'Returns the sine of the argument (an angle in radians).'],
      sinh: ['sinh(X)', 'Hyperbolic sine of X.'],
      size: ['size(S)', 'The size() function is used to get a component\'s dimensions. It is used when two components should have the same dimensions without being connected by…'],
      smth1: ['smth1(input, averaging [, initial])', 'Returns input smoothed over the averaging time — first-order smoothing.'],
      smth3: ['smth3(input, averaging [, initial])', 'Returns input smoothed over the averaging time — third-order smoothing.'],
      smthn: ['smthn(input, averaging, n [, initial])', 'Returns input smoothed over the averaging time — smoothing of order n.'],
      sofar: ['sofar([X])', 'Simile’s help page for this function is incomplete: it gives the syntax but no description.'],
      sqrt: ['sqrt(X)', 'Returns the square root of X.'],
      step: ['step(height, time)', 'Creates a step function: output is 0 up until time, and equal to height thereafter.'],
      stop: ['stop(n)', 'When executed, this function halts execution of the model, and produces the following error message:.'],
      subtotals: ['subtotals([X])', 'Returns an array containing the running totals from summing the elements of the original array.'],
      sum: ['sum([X])', 'Result is the sum of all elements of the array [X] or the list {X}.'],
      tan: ['tan(X)', 'Returns the tan of the argument (an angle in radians).'],
      tanh: ['tanh(X)', 'Hyperbolic tangent of X.'],
      time: ['time()', 'Returns the current simulation time.'],
      trend: ['trend(input, time [, initial])', 'Calculates the trend in input over the exponential averaging time, expressed as fractional change in input per unit time.'],
      trigger_magnitude: ['trigger_magnitude()', 'Returns a value representing the magnitude of the triggering event.'],
      var_delay: ['var_delay(var,n)', 'This function returns some previous value of another variable, an arbitrary period of time before.'],
      with_colin: ['with_colin({ProbList},{ValList})', 'Takes two lists with equal size, and returns an element from the second argument, picked at random with the probability of each element proportional t…'],
      with_greatest: ['with_greatest([N], [X]) with_greatest({N}, {X})', 'Returns the value from an array [X] or the list {X} whose position in the array or list corresponds to the largest value in the array [N] or list {N}.'],
      with_least: ['with_least([N], [X]) with_least({N}, {X})', 'Returns the value from an array [X] or the list {X} whose position in the array or list corresponds to the smallest value in the array [N] or list {N}…'],
    },

    // =====================================================================
    // 5. STYLING (§6) — the cascade's base layer
    // =====================================================================
    // Only the part that has a structural consequence is filled in: `resizable`
    // decides whether an element's layout carries w/h at all (§6). Glyphs,
    // colours and fonts arrive with the renderer.
    // Sizes are 60% of the first draft: the glyphs were chunky relative to the
    // spacing between them, which is what a diagram's scale really means here.
    style: {
      stock:        { shape: 'rect',    resizable: true,  w: 36, h: 24 },
      variable:     { shape: 'circle',  resizable: false, w: 18, h: 18 },
      cloud:        { shape: 'cloud',   resizable: false, w: 24, h: 16 },
      valve:        { shape: 'valve',   resizable: false, w: 12, h: 12 },
      condition:    { shape: 'diamond', resizable: false, w: 18, h: 18 },
      // The four population symbols. Shapes follow Simile's toolbar icons —
      // a sprouting mound, a wandering zigzag, an egg, an axe — reduced to
      // strokes that survive being zoomed out (§6). Until 2026-08-06 these had
      // no entry at all and fell through to the renderer's default circle,
      // indistinguishable from a variable and from each other.
      initialiser:  { shape: 'sprout',  resizable: false, w: 18, h: 16 },
      migrator:     { shape: 'zigzag',  resizable: false, w: 20, h: 12 },
      reproduction: { shape: 'egg',     resizable: false, w: 15, h: 19 },
      exterminator: { shape: 'axe',     resizable: false, w: 18, h: 18 },
      // `alarm` is not implemented (see the vocabulary above) but it IS drawn,
      // because a model imported from Simile may contain one and losing it
      // silently is worse than showing something we cannot yet edit. A bell,
      // for want of Simile's own icon — a guess about appearance only, not
      // about meaning, and the one shape here that has not been checked
      // against the real toolbar.
      alarm:        { shape: 'bell',    resizable: false, w: 17, h: 18 },
      // A submodel's MEMBERSHIP KIND is drawn, not just stored (ruled
      // 2026-08-06, on building the reference models: the three kinds were
      // indistinguishable, though how many instances a submodel has is
      // arguably the most important thing a Simile diagram conveys).
      //
      // `byKind` says WHICH decoration; the renderer knows HOW to draw each,
      // exactly as it does for the `cloud` and `valve` shapes. A kind with no
      // entry — `single` — is drawn as a plain box, which is the point: one
      // instance needs no mark.
      submodel: {
        shape: 'rect', resizable: true, w: 120, h: 84,
        byKind: {
          // A known number of instances: a deck of four, offset behind.
          'fixed-membership': { decoration: 'stack', layers: 4, step: 3 },
          // An unknown, changing number: two shadow edges that do not close,
          // the open corners saying the membership is not fixed.
          population: { decoration: 'open-shadow', offset: 4, gap: 0.22 },
        },
      },
    },
  });
})(window.Sienna);
