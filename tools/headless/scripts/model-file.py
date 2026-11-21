# A model spec written outside the app (help/model-file-reference.md) held up
# to the app's own checks: read as File > Open reads it, every element's
# completeness (red/black), the schema's grammar rules, exported to Simile's
# Prolog (which refuses what Simile could not run), compiled in the page and
# run with the model's own presentation.run settings. Prints what each step
# found, and the values at the end of the run.
#
#   python3 tools/headless/cdp.py tools/headless/scripts/model-file.py
#   MODEL_FILES="a.json b.json" python3 tools/headless/cdp.py tools/headless/scripts/model-file.py
#   MODEL_LIST=files.txt python3 tools/headless/cdp.py tools/headless/scripts/model-file.py
#
#   MODEL_PARAMS=coral-GBR-RCP26.parameters.json ...   a parameter file, its values
#       given before the first reset (as the Parameters panel's Load would)
#   SERIES_DIR=out/ ...   each model's values over the run, <model>.csv: time,
#       then every variable with one value (or SERIES_VARS="Coral,Trait")
#
# Default: the reference's worked examples, examples/models/*.json. Over http
# (tools/serve.py); Chrome on :9350 (tools/headless/README.md). A new-user
# preview, so the real store is not touched.
import csv, glob, os
PARAMS = json.load(open(os.environ['MODEL_PARAMS'])) if os.environ.get('MODEL_PARAMS') else None
SERIES_DIR = os.environ.get('SERIES_DIR') or None
SERIES_VARS = [v.strip() for v in os.environ.get('SERIES_VARS', '').split(',') if v.strip()]
# MODEL_LIST: a file naming one model spec per line (names with spaces).
listed = [l.strip() for l in open(os.environ['MODEL_LIST'])] if os.environ.get('MODEL_LIST') else []
files = [l for l in listed if l] or os.environ.get('MODEL_FILES', '').split() \
    or sorted(glob.glob(os.path.join(os.getcwd(), 'examples/models/*.json')))
if not files: raise SystemExit('run it from the repository root, or set MODEL_FILES')

CHECK = r"""(async () => {
  const say = [];
  let m;
  try { m = JSON.parse(__txt); } catch (e) { return {fatal: 'not JSON: ' + e.message}; }
  if (!m || typeof m !== 'object' || !m.nodes || !m.arcs) return {fatal: 'expected a model with nodes and arcs'};
  Sienna.Diagram.migrate(m);
  if (!(m.format <= Sienna.Diagram.FORMAT)) return {fatal: 'format ' + m.format + ' is newer than ' + Sienna.Diagram.FORMAT};
  if (!m.schema || !Sienna.schemas.has(m.schema)) return {fatal: 'schema missing or unknown: ' + m.schema};
  const bad = ['nodes', 'arcs', 'submodels'].flatMap(f => Object.keys(m[f] || {})
    .filter(id => !new RegExp('^' + (f === 'submodels' ? 'submodel' : f.slice(0, -1)) + '\\d+$').test(id))
    .map(id => f + ': id "' + id + '" should be ' + (f === 'submodels' ? 'submodel' : f.slice(0, -1)) + '<number>'));
  if (bad.length) return {fatal: bad.join('; ')};
  const path = 'models/__check';
  Sienna.userData.set(path, m);
  const d = new Sienna.Diagram(path);
  const unplaced = Object.keys(m.nodes).filter(id => m.nodes[id].type !== 'valve' && !(m.layout || {})[id])
    .concat(Object.keys(m.submodels || {}).filter(id => !(m.layout || {})[id]));
  const incomplete = Sienna.equationCheck.audit(d).map(r => (r.label || r.id || '') + ': ' + (r.message || r.text || JSON.stringify(r)));
  const grammar = Sienna.grammar.validate(d).map(r => r.label + ': ' + r.message);
  let prolog = null, exportErr = null;
  try { prolog = Sienna.exportSimile.prolog(Sienna.userData.get(path)); } catch (e) { exportErr = e.message; }
  // The usual reason a model will not build: `units` is Simile's type
  // expression, and a unit name the engine does not know stops it (the
  // reference, section 11). Named only if the build fails.
  const withUnits = Object.keys(m.nodes).filter(id => String((m.nodes[id].props || {}).units || '').trim())
    .map(id => (m.nodes[id].label || id) + ' (' + m.nodes[id].props.units + ')');
  // A parameter's value outside its slider range is clamped by the engine,
  // silently: it runs with min or max instead (the reference, section 5.3).
  const clamped = Object.keys(m.nodes).map(id => m.nodes[id]).filter(n => n.type === 'variable').filter(n => {
    const p = n.props || {}, v = Number(p.value), lo = parseFloat(p.min), hi = parseFloat(p.max);
    return String(p.value || '').trim() !== '' && isFinite(v) && ((isFinite(lo) && v < lo) || (isFinite(hi) && v > hi));
  }).map(n => n.label + ' = ' + n.props.value + ', range ' + (n.props.min || '') + ' to ' + (n.props.max || '') + ': runs with the nearer end');
  const out = {unplaced, incomplete, grammar, exportErr, withUnits, clamped, run: null, params: []};
  const summary = v => {   // a population's or a fixed membership's values, in one line
    if (typeof v === 'string') { try { v = JSON.parse(v); } catch (x) {} }
    if (v && typeof v === 'object') { const n = Object.keys(v).length; const xs = Object.values(v).map(Number); v = n + ' values' + (n ? ', ' + Math.min(...xs) + ' to ' + Math.max(...xs) : ''); }
    return v;
  };
  const wanted = (cp) => !__series.length || __series.includes(cp.replace(/^\//, '')) || __series.includes(cp.split('/').pop());
  // With a parameter file (MODEL_PARAMS): run as the app runs a model, the
  // values given before it is first loaded (Parameters > Load, or ?open= with
  // &parameters=), so fixed parameters take them (engine README fault 7).
  if (prolog && __params) {
    const run = Object.assign({runLength: 10, logEach: 1, timeStep: '0.1'}, (m.presentation || {}).run || {});
    const sim = Sienna.Simulation, v = sim.viewFor(path);
    const got = sim.readParameterFile(path, __params);
    out.params = got.unknown.map(x => 'not a parameter of this model: ' + x).concat(got.bad);
    try {
      await sim.setInputValues(path, got.values, true, got.fills);
      sim.presetSettings(path, run);
      await v.prepare();
      const comps = v.components, ids = Object.keys(comps).filter(k => comps[k].type !== 'VALUELESS');
      const series = __series ? ids.filter(k => (comps[k].dims || []).length === 1 && wanted(comps[k].captpath)) : [];
      series.forEach((k, i) => v.addTarget('model-file:' + i, k));
      const rows = [];
      const unsub = v.subscribe(e => { if (e.type === 'data') rows.push([e.time].concat(series.map(k => e.values[k]))); });
      await v.reset();
      rows.length = 0;
      if (series.length) { const q = await v.query(series); rows.push([Number(v.settings.current)].concat(series.map(k => q[k]))); }
      const t0 = Number(run.startTime) || 0, end = t0 + Number(run.runLength), began = performance.now();
      v.start();
      while (Number(v.settings.current) < end - 1e-9 && v.status !== 'error' && performance.now() - began < 600000)
        await new Promise(r => setTimeout(r, 100));
      unsub();
      if (v.status === 'error') throw new Error(v.message);
      const q = await v.query(ids), at = {};
      ids.forEach(k => { at[comps[k].captpath] = summary(q[k]); });
      out.run = {completed: Number(v.settings.current) >= end - 1e-9, time: Number(v.settings.current), points: rows.length, values: at};
      if (__series) out.series = {names: series.map(k => comps[k].captpath.replace(/^\//, '')), rows: rows};
    } catch (e) { out.run = {error: String(e.message || e)}; }
    await sim.setInputValues(path, {}, true);
    await v.unload();
    Sienna.userData.remove(path);
    return out;
  }
  if (prolog) {
    const run = Object.assign({runLength: 10, logEach: 1, timeStep: '0.1'}, (m.presentation || {}).run || {});
    try {
      const e = await Sienna.LocalEngine.build('check', prolog, () => {});
      const s = await Sienna.LocalEngine.open(e);
      try {
        const desc = JSON.parse(await s.act('Describe'));
        const ids = Object.keys(desc).filter(k => desc[k].type !== 'VALUELESS');
        s._steps(String(run.timeStep));
        const t0 = Number(run.startTime) || 0;    // presentation.run.startTime
        s._call('sx_reset', 'number', ['number', 'number', 'number'], [t0, -2, 12345]);
        const rows = JSON.parse(await s.act('ExecuteMulti', {current: t0, step: String(run.timeStep),
          runlength: Number(run.runLength), log: Number(run.logEach), note: JSON.stringify(ids)}));
        const ok = rows[rows.length - 1], last = rows[rows.length - 2] || [];
        const at = {};
        ids.forEach((k, i) => {
          at[desc[k].captpath] = summary(last[i]);
        });
        out.run = {completed: !!ok, time: last[last.length - 1], points: rows.length - 1, values: at};
        if (__series) {   // SERIES_DIR: single values only, by name
          const want = ids.map((k, i) => [k, i]).filter(([k]) => (desc[k].dims || []).length === 1 && wanted(desc[k].captpath));
          out.series = {names: want.map(([k]) => desc[k].captpath.replace(/^\//, '')),
            rows: rows.slice(0, -1).map(r => [r[r.length - 1]].concat(want.map(([, i]) => r[i])))};
        }
      } finally { s.exit(); }
    } catch (e) { out.run = {error: String(e.message || e)}; }
  }
  Sienna.userData.remove(path);
  return out;
})()"""

await nav('http://localhost:8731/index.html?newuser=fresh'); await sleep(5)
failed = 0
for n_file, f in enumerate(files):
    # A page's memory grows with each model compiled in it: a fresh page
    # every few, as run-values.py does, for a long batch.
    if n_file and n_file % 6 == 0:
        await nav('http://localhost:8731/index.html?newuser=fresh'); await sleep(5)
    print('==', os.path.relpath(f), flush=True)
    await ev('window.__txt = %s; window.__params = %s; window.__series = %s; 1'
             % (json.dumps(open(f).read()), json.dumps(PARAMS), json.dumps(SERIES_VARS if SERIES_DIR else None)))
    r = await ev(CHECK)
    if r is None: print('  FAIL no answer'); failed += 1; continue
    if 'fatal' in r: print('  FAIL refused:', r['fatal']); failed += 1; continue
    problems = 0
    for key, title in (('unplaced', 'no layout'), ('incomplete', 'incomplete'), ('grammar', 'grammar'), ('clamped', 'outside its range'), ('params', 'parameter file')):
        for line in r[key]: print('  FAIL', title + ':', line); problems += 1
    if r['exportErr']: print('  FAIL export refused:', r['exportErr']); problems += 1
    run = r['run']
    if run is None: pass
    elif 'error' in run:
        print('  FAIL run:', run['error']); problems += 1
        if r['withUnits']:
            print('     the usual cause, units (leave them ""):', ', '.join(r['withUnits']))
    else:
        print('  %s run to t=%s, %d points' % ('PASS' if run['completed'] else 'FAIL', run['time'], run['points']))
        if not run['completed']: problems += 1
        for k, v in sorted(run['values'].items()): print('     ', k, '=', v)
        if SERIES_DIR and run.get('completed') is not None and r.get('series'):
            os.makedirs(SERIES_DIR, exist_ok=True)
            out_csv = os.path.join(SERIES_DIR, os.path.basename(f)[:-5] + '.csv')
            with open(out_csv, 'w', newline='') as fh:
                w = csv.writer(fh); w.writerow(['time'] + r['series']['names']); w.writerows(r['series']['rows'])
            print('  series: %d rows of %d variables -> %s' % (len(r['series']['rows']), len(r['series']['names']), out_csv))
    if not problems: print('  PASS loads, complete, exports, runs')
    failed += 1 if problems else 0
print('%d of %d files had problems' % (failed, len(files)))
