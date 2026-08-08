/**
 * `Sienna.demoLamos` — **LAMOS**, reconstructed from a screenshot.
 *
 * A landscape fire-and-vegetation model of medium complexity: ~80 elements,
 * five levels of nesting, a self-association, three multi-instance submodels
 * and eleven flows. Built 2026-08-08 from `Simile screenshots/lamos1a.pl.png`
 * ALONE — the original `lamos1a.pl` sits in the reference corpus on the same
 * machine and was deliberately not opened, so that the reconstruction could be
 * scored against it afterwards rather than copied from it.
 *
 * Its point is not the ecology. It is the first model here that was not written
 * by us, and at this size the design either holds up or does not:
 *
 *   - **Depth.** `fire ▸ conditional_fire ▸ fire_patch` and
 *     `patch ▸ plants ▸ plant_species` are three levels each, where the earlier
 *     fixtures managed two.
 *   - **Repeated names in different scopes**, which §14.2 says is normal and
 *     which no fixture had actually exercised: `neighbours` appears in
 *     `fire_patch` and again in `patch_results`; `row` and `col` in
 *     `patch_results` and again in `patch`; `water` is a compartment in
 *     `soil_water` and a variable in `neighbour`; `rain` is a root variable and
 *     a flow inside `soil_water`; `fire` is both a submodel and a variable
 *     inside it.
 *   - **A self-association**: both role arcs, `my_neighbour` and `me`, run from
 *     `patch` to `neighbour` — the NEXT_TO shape of §4, met in the wild.
 *
 * TWO KNOWN DEPARTURES from the original, both forced and both worth seeing:
 *
 * 1. **Spaces become underscores.** The original names elements `water demand`,
 *    `seeds per indiv`, `fire results`, `my neighbour` and a dozen more. §14
 *    rules label ≡ name, so they cannot be written that way here. This is the
 *    `time under crop` finding of §8 again, at scale: roughly a fifth of this
 *    model's labels are affected.
 * 2. **Equations are absent**, so the model is entirely red. That is what the
 *    screenshot shows too — it was supplied as a structural diagram.
 *
 * The influence set is the least certain part: the original has well over a
 * hundred, many crossing and overlapping, and what is recorded here is the
 * subset that could be traced with confidence. Structure — elements, types,
 * nesting, flows, roles — is believed complete.
 *
 * Classic script; no imports/exports. Load after `src/diagram.js`.
 */
(function (Sienna) {
  'use strict';

  function demoLamos(path) {
    var p = path || 'models/lamos';
    var d = Sienna.Diagram.create(p, { name: 'LAMOS' });

    // Screenshot pixels, shifted to put the diagram's top-left near the origin.
    // NOTE: addFlow's x/y and fromXY/toXY take WORLD coordinates, so they are
    // written pre-shifted below — they do not go through at().
    function at(px, py) { return { x: px - 30, y: py - 170 }; }
    function box(x1, y1, x2, y2) {
      return { x: (x1 + x2) / 2 - 30, y: (y1 + y2) / 2 - 170, w: x2 - x1, h: y2 - y1 };
    }
    var S = {};   // submodels by name
    var N = {};   // nodes by name, for wiring influences afterwards

    function sub(name, label, parent, kind, rect) {
      S[name] = d.addSubmodel(Object.assign(
        { label: label, parent: parent ? S[parent] : null, kind: kind || 'single' }, rect));
      return S[name];
    }
    function node(name, type, parent, px, py, extra) {
      N[name] = d.addNode(type, Object.assign(
        { label: name, parent: parent ? S[parent] : null }, at(px, py), extra || {}));
      return N[name];
    }
    function infl(from, to) { d.addInfluence(N[from] || S[from], N[to] || S[to]); }

    // ---- submodels, parents before children so nothing is captured by accident
    sub('fire', 'fire', null, 'fixed-membership', box(35, 175, 830, 1010));
    sub('conditional_fire', 'conditional_fire', 'fire', 'single', box(175, 250, 790, 820));
    sub('fire_patch', 'fire_patch', 'conditional_fire', 'fixed-membership', box(205, 305, 760, 690));
    sub('fire_test', 'fire_test', 'fire', 'single', box(62, 855, 222, 975));
    sub('patch_results', 'patch_results', 'fire', 'fixed-membership', box(295, 855, 610, 990));
    sub('fire_results', 'fire_results', 'fire', 'single', box(630, 890, 800, 990));

    sub('patch', 'patch', null, 'fixed-membership', box(925, 240, 1615, 1000));
    sub('plants', 'plants', 'patch', 'single', box(985, 280, 1500, 700));
    sub('plant_species', 'plant_species', 'plants', 'fixed-membership', box(1000, 312, 1490, 640));
    sub('soil_water', 'soil_water', 'patch', 'single', box(1015, 735, 1570, 985));

    sub('neighbour', 'neighbour', null, 'fixed-membership', box(1740, 395, 1905, 860));

    // ---- root -----------------------------------------------------------
    node('cs', 'variable', null, 875, 495);
    node('fuel_per_indiv', 'variable', null, 880, 745);
    node('water_use', 'variable', null, 878, 888);
    node('rain_input', 'variable', null, 872, 967);
    // The original calls this `rain`, and so does a flow inside soil_water.
    // Both are legal: uniqueness is scoped to the submodel (§14.2), and these
    // are in different ones. Renaming it was over-caution on my part.
    d.setProperties(N.rain_input, { label: 'rain' });
    node('seeds_per_indiv', 'variable', null, 1073, 196);
    node('dispersability', 'variable', null, 1157, 199);
    node('ms', 'variable', null, 1404, 203);

    // ---- fire -----------------------------------------------------------
    node('burnt_per_step', 'variable', 'fire', 513, 224);
    node('always_catch', 'variable', 'fire', 651, 224);
    node('always_starts', 'variable', 'fire', 70, 527);
    node('min_for_fire', 'variable', 'fire', 695, 852);
    node('nrow', 'variable', 'fire', 258, 881);
    node('ncol', 'variable', 'fire', 252, 950);

    // conditional_fire
    node('is_fire', 'condition', 'conditional_fire', 214, 750);
    // `is_fire?` and `spark?` in the original. The question mark is illegal in
    // an equation name, and Simile itself substitutes an underscore — its own
    // equations refer to `spark_`. §14 rules label ≡ name, so we take the name.
    d.setProperties(N.is_fire, { label: 'is_fire_' });
    node('check_spark', 'variable', 'conditional_fire', 401, 763);
    node('burning', 'variable', 'conditional_fire', 489, 773);
    node('other_fires', 'variable', 'conditional_fire', 646, 762);

    // fire_patch
    node('fuel_load', 'compartment', 'fire_patch', 288, 375, { w: 36, h: 24 });
    node('fuel_load_lost', 'compartment', 'fire_patch', 672, 400, { w: 36, h: 24 });
    var burningLosses = d.addFlow({
      from: N.fuel_load, to: N.fuel_load_lost, parent: S.fire_patch,
      label: 'burning_losses', x: 438, y: 205,
    });
    N.burning_losses = burningLosses.valve;
    node('fire_v', 'variable', 'fire_patch', 400, 440);   // labelled `fire` in the original
    d.setProperties(N.fire_v, { label: 'fire' });
    node('new_fire', 'variable', 'fire_patch', 351, 513);
    node('crossover', 'variable', 'fire_patch', 484, 512);
    node('catches', 'variable', 'fire_patch', 613, 480);
    node('neighbour_burns', 'variable', 'fire_patch', 524, 588);
    node('old_fire', 'variable', 'fire_patch', 655, 566);
    node('neighbours', 'variable', 'fire_patch', 570, 660);
    node('starts', 'variable', 'fire_patch', 415, 587);
    node('spark_here', 'variable', 'fire_patch', 296, 618);

    // fire_test / patch_results / fire_results
    node('spark_patch', 'variable', 'fire_test', 135, 881);
    node('spark_q', 'variable', 'fire_test', 178, 928);
    d.setProperties(N.spark_q, { label: 'spark_' });
    node('row_neighbours', 'variable', 'patch_results', 373, 897);
    node('row', 'variable', 'patch_results', 334, 900);
    node('col', 'variable', 'patch_results', 350, 950);
    node('col_neighbours', 'variable', 'patch_results', 434, 943);
    node('nbrs_pr', 'variable', 'patch_results', 522, 918);
    d.setProperties(N.nbrs_pr, { label: 'neighbours' });
    node('fuel_lost_fr', 'variable', 'fire_results', 737, 928);
    d.setProperties(N.fuel_lost_fr, { label: 'fuel_lost' });
    node('time_in_2', 'variable', 'fire_results', 681, 942);

    // ---- patch ----------------------------------------------------------
    node('fuel_load_p', 'variable', 'patch', 949, 645);
    d.setProperties(N.fuel_load_p, { label: 'fuel_load' });
    node('fraction_lost', 'variable', 'patch', 963, 771);
    node('fuel_lost_p', 'variable', 'patch', 950, 823);
    d.setProperties(N.fuel_lost_p, { label: 'fuel_lost' });
    node('row_p', 'variable', 'patch', 1548, 497);
    d.setProperties(N.row_p, { label: 'row' });
    node('col_p', 'variable', 'patch', 1551, 545);
    d.setProperties(N.col_p, { label: 'col' });
    node('elevation', 'variable', 'patch', 1563, 632);

    // plants
    node('numbers', 'variable', 'plants', 1138, 672);
    node('n1', 'variable', 'plants', 1246, 662);
    node('n2', 'variable', 'plants', 1279, 660);
    node('n3', 'variable', 'plants', 1322, 662);
    node('n4', 'variable', 'plants', 1369, 662);
    node('n5', 'variable', 'plants', 1409, 662);

    // plant_species
    node('number', 'compartment', 'plant_species', 1237, 455, { w: 40, h: 30 });
    var repro = d.addFlow({ to: N.number, parent: S.plant_species,
      label: 'reproduction', x: 1130, y: 285, fromXY: { x: 1023, y: 288 } });
    N.reproduction = repro.valve;
    var mort = d.addFlow({ from: N.number, parent: S.plant_species,
      label: 'mortality', x: 1318, y: 288, toXY: { x: 1414, y: 292 } });
    N.mortality = mort.valve;
    var burnt = d.addFlow({ from: N.number, parent: S.plant_species,
      label: 'burnt', x: 1207, y: 358, toXY: { x: 1194, y: 420 } });
    N.burnt = burnt.valve;
    node('seeds_staying', 'variable', 'plant_species', 1070, 337);
    node('seeds_produced', 'variable', 'plant_species', 1188, 361);
    node('seeds_dispersing', 'variable', 'plant_species', 1306, 372);
    node('m', 'variable', 'plant_species', 1389, 391);
    node('c', 'variable', 'plant_species', 1035, 500);
    node('feedback', 'variable', 'plant_species', 1027, 555);
    node('water_multiplier', 'variable', 'plant_species', 1157, 566);
    node('seeds_in', 'variable', 'plant_species', 1350, 576);

    // soil_water
    node('water', 'compartment', 'soil_water', 1180, 843, { w: 40, h: 32 });
    var rainFlow = d.addFlow({ to: N.water, parent: S.soil_water,
      label: 'rain', x: 1083, y: 636, fromXY: { x: 1035, y: 600 } });
    N.rain = rainFlow.valve;
    var inflow = d.addFlow({ to: N.water, parent: S.soil_water,
      label: 'inflow', x: 1083, y: 714, fromXY: { x: 1035, y: 742 } });
    N.inflow = inflow.valve;
    var evap = d.addFlow({ from: N.water, parent: S.soil_water,
      label: 'evapotransp', x: 1372, y: 598, toXY: { x: 1487, y: 600 } });
    N.evapotransp = evap.valve;
    var outflow = d.addFlow({ from: N.water, parent: S.soil_water,
      label: 'outflow', x: 1436, y: 682, toXY: { x: 1495, y: 678 } });
    N.outflow = outflow.valve;
    var drainage = d.addFlow({ from: N.water, parent: S.soil_water,
      label: 'drainage', x: 1345, y: 742, toXY: { x: 1495, y: 745 } });
    N.drainage = drainage.valve;
    node('water_demand', 'variable', 'soil_water', 1188, 760);
    node('water_display', 'variable', 'soil_water', 1172, 923);

    // ---- neighbour (the association) ------------------------------------
    node('seeds_transfer', 'variable', 'neighbour', 1846, 432);
    node('neighbour_condition', 'condition', 'neighbour', 1855, 531);
    node('elevation_diff', 'variable', 'neighbour', 1843, 660);
    node('interflow', 'variable', 'neighbour', 1804, 742);
    node('water_n', 'variable', 'neighbour', 1868, 727);
    d.setProperties(N.water_n, { label: 'water' });

    d.addRole(S.patch, S.neighbour, { label: 'my_neighbour' });
    d.addRole(S.patch, S.neighbour, { label: 'me' });

    // ---- influences: the subset that could be traced with confidence -----
    [['burnt_per_step', 'burning_losses'], ['always_catch', 'catches'],
     ['fuel_load', 'burning_losses'], ['fuel_load', 'catches'],
     ['always_starts', 'starts'], ['min_for_fire', 'catches'],
     ['fire_v', 'crossover'], ['new_fire', 'fire_v'], ['starts', 'new_fire'],
     ['spark_here', 'starts'], ['crossover', 'catches'],
     ['neighbour_burns', 'catches'], ['old_fire', 'neighbour_burns'],
     ['neighbours', 'neighbour_burns'], ['catches', 'fire_v'],
     ['check_spark', 'spark_here'], ['burning', 'other_fires'],
     ['other_fires', 'neighbours'], ['fire_v', 'burning'],
     ['spark_patch', 'spark_q'], ['spark_q', 'check_spark'],
     ['nrow', 'row'], ['ncol', 'col'], ['row', 'row_neighbours'],
     ['col', 'col_neighbours'], ['row_neighbours', 'nbrs_pr'],
     ['col_neighbours', 'nbrs_pr'], ['nbrs_pr', 'neighbours'],
     ['fuel_load_lost', 'fuel_lost_fr'], ['time_in_2', 'fuel_lost_fr'],
     ['seeds_per_indiv', 'seeds_produced'], ['dispersability', 'seeds_dispersing'],
     ['ms', 'm'], ['number', 'seeds_produced'], ['number', 'mortality'],
     ['seeds_produced', 'seeds_staying'], ['seeds_produced', 'seeds_dispersing'],
     ['seeds_staying', 'reproduction'], ['seeds_in', 'reproduction'],
     ['m', 'mortality'], ['c', 'feedback'], ['feedback', 'reproduction'],
     ['water_multiplier', 'reproduction'], ['number', 'numbers'],
     ['numbers', 'n1'], ['numbers', 'n2'], ['numbers', 'n3'],
     ['numbers', 'n4'], ['numbers', 'n5'],
     ['water', 'water_demand'], ['water', 'water_display'],
     ['water_demand', 'evapotransp'], ['water', 'evapotransp'],
     ['water', 'outflow'], ['water', 'drainage'], ['rain_input', 'rain'],
     ['water_use', 'water_demand'], ['cs', 'catches'],
     ['fuel_per_indiv', 'fuel_load_p'], ['fuel_load_p', 'fuel_load'],
     ['fraction_lost', 'fuel_lost_p'], ['fuel_lost_p', 'fraction_lost'],
     ['row_p', 'elevation'], ['col_p', 'elevation'],
     ['elevation', 'elevation_diff'], ['elevation_diff', 'interflow'],
     ['water_n', 'interflow'], ['row_p', 'neighbour_condition'],
     ['col_p', 'neighbour_condition'], ['seeds_dispersing', 'seeds_transfer'],
     ['seeds_transfer', 'seeds_in'], ['interflow', 'water']
    ].forEach(function (pair) {
      if (N[pair[0]] && N[pair[1]]) d.addInfluence(N[pair[0]], N[pair[1]]);
    });

    // ---- equations, recovered from the original ---------------------------
    //
    // Lifted from `lamos1a.pl` after the structure above had been reconstructed
    // from the screenshot, which is why they are a separate pass: the picture
    // gives the shape, the file gives the arithmetic.
    //
    // How they are stored there is worth knowing, because it is not obvious: a
    // drawn variable is TWO nodes in the Prolog — a `variable` node carrying
    // the name and the graphics, immediately followed by a `function` node
    // carrying the units and the equation. Pairing them on document order
    // recovers the lot. The `fnN` names are those second halves, not, as first
    // supposed, intermediates standing on submodel boundaries.
    //
    // Equations reference NAMES, so Simile's habit of storing a cross-boundary
    // influence as segments (§13) does not obstruct this at all — an equation
    // says `fuel_load`, whatever route the value took to reach it.
    //
    // Looked up by (parent label, own label), which is well defined precisely
    // because names are unique among siblings (§14.2).
    [
      [null, "cs", "[[0.005,0.003,0.006,0.007,0.006],[0.002,0.005,0.006,0.007,0.006],[0.002,0.002,0.005,0.006,0.002],[0.002,0.002,0.003,0.004,0.002],[0.002,0.002,0.003,0.002,0.005]]"],
      [null, "ms", "[0.1,0.1,0.1,0.1,0.1]"],
      [null, "water_use", "[0.5,0.5,0.5,0.5,0.5]"],
      ["plant_species", "number", "5"],
      ["plant_species", "feedback", "sum([c]*[numbers])"],
      ["plant_species", "c", "element([[cs]],index(1))"],
      ["plant_species", "m", "element([ms],index(1))"],
      ["plant_species", "water_multiplier", "(if water>100 then 1 elseif water<50 then 0 else(water-50)/50)"],
      ["plant_species", "seeds_produced", "element([seeds_per_indiv],index(1))*number"],
      ["plant_species", "seeds_in", "element(sum({[seeds_transfer_0]}),index(1))"],
      ["plants", "numbers", "[number]"],
      ["plants", "n1", "element([number],1)"],
      ["plants", "n2", "element([number],2)"],
      ["plants", "n4", "element([number],4)"],
      ["plants", "n5", "element([number],5)"],
      ["soil_water", "water", "100"],
      ["soil_water", "water_display", "water"],
      ["patch", "col", "fmod(index(1)-1,15)+1"],
      ["patch", "elevation", "200-10*col*sin(0.7*row)"],
      ["patch", "fuel_load", "sum([number]*[fuel_per_indiv])"],
      ["patch", "fuel_lost", "element([fuel_lost],index(1))"],
      ["patch", "fraction_lost", "fuel_lost/fuel_load"],
      ["neighbour", "interflow", "max(0,0.005*elevation_diff*water)"],
      ["neighbour", "elevation_diff", "elevation-elevation_0"],
      ["neighbour", "water", "water"],
      ["neighbour", "seeds_transfer", "[seeds_dispersing]"],
      [null, "seeds_per_indiv", "[70.0,60.0,25.0,20.0,20.0]"],
      [null, "dispersability", "[0.2,0.2,0.15,0.1,0.05]"],
      [null, "fuel_per_indiv", "[10.0,10.0,10.0,10.0,10.0]"],
      ["fire_patch", "fuel_load", "element([fuel_load],index(1))"],
      ["fire_patch", "fuel_load_lost", "(if fire then fuel_load*burnt_per_step/dt(2)else 0)"],
      ["fire_patch", "fire", "(crossover or new_fire)"],
      ["fire_patch", "new_fire", "(spark_here and starts)"],
      ["fire_patch", "crossover", "(neighbour_burns and catches)"],
      ["fire_patch", "catches", "(rand_var(0,1)<0.7*max(0,min(1,(fuel_load-min_for_fire)/(always_catch-min_for_fire))))"],
      ["fire_patch", "starts", "(fuel_load>rand_const(min_for_fire,always_starts))"],
      ["fire_patch", "spark_here", "(check_spark and spark_patch==index(1))"],
      ["fire_patch", "neighbour_burns", "any(element([other_fires],[neighbours]))"],
      ["fire_patch", "old_fire", "last(fire)"],
      ["fire_patch", "neighbours", "element([[neighbours]],index(1))"],
      ["conditional_fire", "check_spark", "(spark_ and fmod(time(1),dt(1))<dt(2))"],
      ["conditional_fire", "burning", "any([other_fires])"],
      ["conditional_fire", "other_fires", "[old_fire]"],
      ["fire_test", "spark_", "(abs(time(1)-10)<0.001)"],   // `spark?` in the original
      ["fire_test", "spark_patch", "int(rand_var(1,size(fire_patch)+1))"],
      ["patch_results", "row", "floor((index(1)-1)/nrow)+1"],
      ["patch_results", "col", "fmod(index(1)-1,ncol)+1"],
      ["patch_results", "row_neighbours", "[row-1,row,row+1,row]"],
      ["patch_results", "col_neighbours", "[col,col+1,col,col-1]"],
      ["patch_results", "neighbours", "(if ([row_neighbours]>0,[row_neighbours]<=nrow,[col_neighbours]>0,[col_neighbours]<=ncol)then ncol*([row_neighbours]-1)+[col_neighbours]else index(1))"],
      ["fire", "always_catch", "2500"],
      ["fire", "burnt_per_step", "0.6"],
      ["fire", "always_starts", "1500"],
      ["fire", "min_for_fire", "1000"],
      ["fire", "nrow", "15"],
      ["fire", "ncol", "15"],
      ["fire_results", "time_in_2", "fmod(time(1),dt(1))"],
      ["fire_results", "fuel_lost", "(if any({burning})then sum({[fuel_load_lost]})elseif time_in_2>0 and time_in_2<1.5*dt(2)then 0 else prev(1))"],
    ].forEach(function (row) {
      var wantParent = row[0], wantLabel = row[1], equation = row[2];
      var id = d.ids('nodes').filter(function (n) {
        var el = d.get(n);
        var par = el.parent ? d.get(el.parent).label : null;
        return el.label === wantLabel && par === wantParent;
      })[0];
      if (!id) return;
      var field = { compartment: 'initial', variable: 'value',
                    condition: 'expr', valve: 'rate' }[d.get(id).type];
      if (field) {
        var props = {};
        props[field] = equation;
        d.setProperties(id, { props: props });
      }
    });

    demoLamos.d = d;
    return { model: p, submodels: S, nodes: N };
  }

  Sienna.demoLamos = demoLamos;
})(window.Sienna);
