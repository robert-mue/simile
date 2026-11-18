# A model spec written outside the app (help/model-file-reference.md) held up
# to the app's own checks: read as File > Open reads it, every element's
# completeness (red/black), the schema's grammar rules, exported to Simile's
# Prolog (which refuses what Simile could not run), compiled in the page and
# run with the model's own presentation.run settings. Prints what each step
# found, and the values at the end of the run.
#
#   python3 tools/headless/cdp.py tools/headless/scripts/model-file.py
#   MODEL_FILES="a.json b.json" python3 tools/headless/cdp.py tools/headless/scripts/model-file.py
#
# Default: the reference's worked examples, examples/models/*.json. Over http
# (tools/serve.py); Chrome on :9350 (tools/headless/README.md). A new-user
# preview, so the real store is not touched.
import glob, os
files = os.environ.get('MODEL_FILES', '').split() or sorted(glob.glob(os.path.join(os.getcwd(), 'examples/models/*.json')))
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
  const out = {unplaced, incomplete, grammar, exportErr, run: null};
  if (prolog) {
    const run = Object.assign({runLength: 10, logEach: 1, timeStep: '0.1'}, (m.presentation || {}).run || {});
    try {
      const e = await Sienna.LocalEngine.build('check', prolog, () => {});
      const s = await Sienna.LocalEngine.open(e);
      try {
        const desc = JSON.parse(await s.act('Describe'));
        const ids = Object.keys(desc).filter(k => desc[k].type !== 'VALUELESS');
        s._steps(String(run.timeStep));
        s._call('sx_reset', 'number', ['number', 'number', 'number'], [0, -2, 12345]);
        const rows = JSON.parse(await s.act('ExecuteMulti', {current: 0, step: String(run.timeStep),
          runlength: Number(run.runLength), log: Number(run.logEach), note: JSON.stringify(ids)}));
        const ok = rows[rows.length - 1], last = rows[rows.length - 2] || [];
        const at = {};
        ids.forEach((k, i) => {
          let v = last[i];
          if (typeof v === 'string') { try { v = JSON.parse(v); } catch (x) {} }
          if (v && typeof v === 'object') { const n = Object.keys(v).length; const xs = Object.values(v).map(Number); v = n + ' values' + (n ? ', ' + Math.min(...xs) + ' to ' + Math.max(...xs) : ''); }
          at[desc[k].captpath] = v;
        });
        out.run = {completed: !!ok, time: last[last.length - 1], points: rows.length - 1, values: at};
      } finally { s.exit(); }
    } catch (e) { out.run = {error: String(e.message || e)}; }
  }
  Sienna.userData.remove(path);
  return out;
})()"""

await nav('http://localhost:8731/index.html?newuser=fresh'); await sleep(5)
failed = 0
for f in files:
    print('==', os.path.relpath(f))
    await ev('window.__txt = %s; 1' % json.dumps(open(f).read()))
    r = await ev(CHECK)
    if r is None: print('  FAIL no answer'); failed += 1; continue
    if 'fatal' in r: print('  FAIL refused:', r['fatal']); failed += 1; continue
    problems = 0
    for key, title in (('unplaced', 'no layout'), ('incomplete', 'incomplete'), ('grammar', 'grammar')):
        for line in r[key]: print('  FAIL', title + ':', line); problems += 1
    if r['exportErr']: print('  FAIL export refused:', r['exportErr']); problems += 1
    run = r['run']
    if run is None: pass
    elif 'error' in run: print('  FAIL run:', run['error']); problems += 1
    else:
        print('  %s run to t=%s, %d points' % ('PASS' if run['completed'] else 'FAIL', run['time'], run['points']))
        if not run['completed']: problems += 1
        for k, v in sorted(run['values'].items()): print('     ', k, '=', v)
    if not problems: print('  PASS loads, complete, exports, runs')
    failed += 1 if problems else 0
print('%d of %d files had problems' % (failed, len(files)))
