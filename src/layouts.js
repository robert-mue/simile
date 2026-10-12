/**
 * simile's layouts — how the workspace is arranged (sienna DESIGN.md §20).
 *
 * Every layout gives each open model TWO collections (§19.1): one for the
 * model itself — its diagram, and in time its equations or an overview — and
 * one for running it — the run control above a tabbed set of displays. They
 * are kept apart because a modeller often compares two structures, and
 * separately two runs. The layouts differ in where the collections go:
 *
 *   - **Model and simulation windows** (the default): floating windows, as in
 *     Simile, both opened with the model — see where it is registered.
 *   - **Model and simulation areas**: all the Model collections in one area
 *     and all the Simulation collections in another, side by side, each area
 *     tabbed by model, so either comparison is one switch (tile the area).
 *   - **Free**: the floating workspace simile had before, with no collections.
 *
 * Collections are made from templates: a model's first diagram makes its
 * Model collection, its first run control or display its Simulation
 * collection, which always comes with a run control at the top (and in the
 * windows layout, either makes both). Each carries the model's `ref`, so it
 * wears the model's colour and only that model's panels go in it. A
 * collection closes when its last panel does.
 *
 * Classic script; no imports/exports. Load after sienna's layouts.js.
 */
(function (Sienna) {
  'use strict';

  // The default, for a modeller starting out — Simile's own arrangement: a
  // model WINDOW and a simulation WINDOW, floating, each more than half the
  // width of the screen, since each holds a lot. Opening a model opens both,
  // so it is plain where to build it and where to run it. A second model's
  // pair arrives offset from the first, and dragging them apart compares two
  // structures or two runs. Sizes are fractions of the workspace.
  var SIMULATION = {
    widget: 'container',
    title: 'Simulation',
    options: {
      mode: 'tiled',
      direction: 'column',
      accepts: ['run-control'],
      children: [
        // A Simulation comes with its run control, so the transport is always
        // at the top rather than wherever it arrived; asking for one when the
        // collection is made gets this one.
        // Sized to fit its controls (`fit`); the displays take the rest.
        { widget: 'runControl', title: 'Run control', fit: true },
        {
          widget: 'container', title: 'Displays',
          options: { mode: 'tabbed', accepts: ['display'] },
        },
      ],
    },
  };

  Sienna.layouts.register('windows', {
    label: 'Model and simulation windows',
    default: true,
    mode: 'floating',
    templates: [
      {
        widget: 'container',
        title: 'Model',
        openWithDocument: true,
        // Closing the model window closes the model, simulation window too.
        primary: true,
        geometry: { left: 0.01, top: 0.02, width: 0.56, height: 0.92 },
        // Tiled, so a lone diagram fills the window.
        options: { mode: 'tiled', accepts: ['diagram'] },
      },
      $.extend(true, {
        openWithDocument: true,
        geometry: { left: 0.43, top: 0.05, width: 0.56, height: 0.92 },
      }, SIMULATION),
    ],
    panels: [],
  });

  // Every model's collections gathered into two areas, each tabbed by model.
  Sienna.layouts.register('model-simulation', {
    label: 'Model and simulation areas',
    mode: 'tiled',
    direction: 'row',
    panels: [
      {
        widget: 'container',
        title: 'Models',
        share: 3,
        options: {
          mode: 'tabbed',
          templates: [
            // Tiled, so a lone diagram fills it rather than opening at its
            // floating size and running off the edge.
            { widget: 'container', title: 'Model', options: { mode: 'tiled', accepts: ['diagram'] } },
          ],
        },
      },
      {
        widget: 'container',
        title: 'Simulations',
        share: 2,
        options: {
          mode: 'tabbed',
          templates: [
            SIMULATION,
          ],
        },
      },
    ],
  });

  Sienna.layouts.register('free', {
    label: 'Free (floating)',
    mode: 'floating',
    panels: [],
  });
})(window.Sienna);
