/**
 * simile's layouts — how the workspace is arranged (sienna DESIGN.md §20).
 *
 * The default, "Model and simulation", gives each open model TWO collections
 * (§19.1): one for the model itself — its diagram, and in time its equations
 * or an overview — and one for running it — the run control above a tabbed set
 * of displays. They are kept apart because a modeller often compares two
 * structures, and separately two runs: all the Model collections sit in one
 * area and all the Simulation collections in another, each area tabbed by
 * model, so either comparison is one mode switch (tile the area) away.
 *
 * Collections are made from templates, on demand: a model's first diagram
 * makes its Model collection, its first run control or display its Simulation
 * collection, which always comes with a run control at the top. Each carries the model's `ref`, so it wears the model's colour
 * and only that model's panels go in it. A collection closes when its last
 * panel does.
 *
 * "Free" is the floating workspace simile had before.
 *
 * Classic script; no imports/exports. Load after sienna's layouts.js.
 */
(function (Sienna) {
  'use strict';

  Sienna.layouts.register('model-simulation', {
    label: 'Model and simulation',
    default: true,
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
            {
              widget: 'container',
              title: 'Simulation',
              options: {
                mode: 'tiled',
                direction: 'column',
                accepts: ['run-control'],
                children: [
                  // A Simulation comes with its run control, so the transport
                  // is always at the top rather than wherever it arrived;
                  // asking for one when the collection is made gets this one.
                  { widget: 'runControl', title: 'Run control' },
                  // More than the run control's share — the displays are what
                  // you look at — but not so much that its fields scroll.
                  {
                    widget: 'container', title: 'Displays', share: 1.5,
                    options: { mode: 'tabbed', accepts: ['display'] },
                  },
                ],
              },
            },
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
