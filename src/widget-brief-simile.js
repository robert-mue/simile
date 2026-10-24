/**
 * simile's part of the brief for an AI assistant (sienna's
 * `widget-brief.js`): what only simile knows — where a widget opens, the
 * model spec, and above all how a display gets the values of a running model.
 *
 * Written from what the built-in displays actually do (`lollipop.js` is the
 * shortest worked example). Change this when `Simulation.forWidget` changes:
 * an added widget written from an out-of-date brief breaks silently.
 *
 * Classic script; after the shell, before `main.js`.
 */
(function (Sienna) {
  'use strict';
  var brief = Sienna.widgetBrief;
  if (!brief) return;

  brief.setApp('simile (a diagram editor and simulator for Simile models)');

  brief.addSection('In simile: where a widget opens', [
    'Each model has a Model window (its diagram) and a Simulation window (a run',
    'control, which loads and runs the model, and an area of displays). A',
    'widget\'s `role` says which it opens in: `\'display\'` (the usual one for',
    'anything that shows results: plots, tables, gauges) opens among the',
    'model\'s displays; no role opens it as a separate window. The panel is',
    'bound to the model that was current when the user opened it, so',
    '`this._ref()` is that model\'s path.',
  ].join('\n'));

  brief.addSection('In simile: the model spec', [
    '`this._model()` is the model spec (read it; do not change it unless asked):',
    '',
    '- `name`: the model\'s name.',
    '- `nodes`: `{ id: { type, label, parent, props } }`. `type` is \'stock\'',
    '  (compartment), \'variable\', \'valve\' (holds a flow\'s rate), \'cloud\',',
    '  \'condition\', or a population symbol: \'initialiser\' (creation),',
    '  \'migrator\' (immigration), \'reproduction\', \'exterminator\' (loss).',
    '  `label` is its name, `parent` the id of the submodel it is in (absent at',
    '  the top level), `props` its fields: `initial` (a stock), `rate` (a valve),',
    '  `value` (a variable\'s equation), `expr` (a condition or population',
    '  symbol), `units`, `min`, `max`.',
    '- `submodels`: `{ id: { label, parent, kind, props } }`; `kind` is',
    '  \'single\', \'fixed-membership\' (`props.dimensions` the count) or',
    '  \'population\'.',
    '- `arcs`: the flows, influences and roles between nodes.',
    '',
    'Call `this._watchModel(fn)` to hear edits. Most widgets need only the',
    'running model, below, not the spec.',
  ].join('\n'));

  brief.addSection('In simile: values from the running model', [
    'The run control loads and runs the model; a display only listens. Get the',
    'session for this panel\'s model once, in `_create`:',
    '',
    '```js',
    'this._sim = Sienna.Simulation.forWidget(this._ref());',
    'this._owner = (this._panelId() || \'w\' + Math.random().toString(36).slice(2)) + \':\';',
    'this._off = this._sim.subscribe((e) => this._onEvent(e));',
    '```',
    '',
    'and in `_destroy`: `this._off(); this._sim.removeTarget(this._owner + \'value\');`',
    '(one `removeTarget` per target you added).',
    '',
    'What is there to show (empty until a model is loaded, i.e. while',
    '`this._sim.base` is null):',
    '',
    '- `this._sim.scalarComponents()`: `[{ id, label, units }]`, the variables',
    '  that are one number. `label` is the path, e.g. \'Trees/biomass\'.',
    '- `this._sim.memberComponents()`: the same for variables with a value per',
    '  instance (inside a population, a fixed-membership submodel, or an',
    '  association).',
    '',
    'To receive a variable\'s values as the model runs, ask for it by id:',
    '`this._sim.addTarget(this._owner + \'value\', id)`. The owner string is yours:',
    'one per thing you show; adding again with the same owner replaces it;',
    '`removeTarget(owner)` stops it.',
    '',
    'Events (`e.type`):',
    '',
    '- `\'data\'`: `{ time, values, reset }`, once per logged time step.',
    '  `values[id]` is the value of each target: a number; an array for a',
    '  fixed membership (element 0 is instance 1); an object for a population',
    '  `{ \'3\': v, \'7\': v }` (keys are the members\' own numbers, kept for their',
    '  lives) or an association `{ \'3,17\': v }` (one number per role); or null.',
    '  `reset: true` means the run went back to its start: clear any history.',
    '- `\'describe\'`: a model has just been loaded, so the lists above changed.',
    '  IDS CHANGE between loads: re-read the lists and find the user\'s choice',
    '  again by its `label`, then `addTarget` again. Save the choice by label',
    '  (in `state()`), never by id.',
    '- `\'status\'`: `{ status }`, one of \'idle\', \'loading\', \'ready\',',
    '  \'running\', \'error\'. When `this._sim.base` is null there is no model',
    '  loaded: show that (e.g. "Run the model to see values").',
    '- `\'progress\'` `{ fraction }` and `\'settings\'` (the run\'s settings',
    '  changed) can usually be ignored. `this._sim.time()` is the model time',
    '  now and `this._sim.runLength()` the length of the run.',
    '',
    'To show a value at once (after the user picks one, or when the widget',
    'opens on a loaded model), ask without running:',
    '`this._sim.query([id]).then((values) => show(values[id]))`. It rejects when',
    'no model is loaded; catch it.',
    '',
    '`this._sim.unitName` is the name of the time unit (often just \'unit\'),',
    'and `this._sim.status` one of the statuses above.',
    '',
    'That is the whole interface (version 1, `this._sim.version`): use',
    'nothing else of `Sienna.Simulation`, whose insides change. A display reads',
    'the run and never drives it: loading, running and resetting the model are',
    'the run control\'s job, and there is no way to do them from here.',
  ].join('\n'));
})(window.Sienna);
