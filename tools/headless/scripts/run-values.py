# Every catalogue model compiled in the page and run: imported, exported,
# compiled (Sienna.LocalEngine.build: the vendored generator, clang and
# run-time library), reset with a fixed seed, run for 3 time units at step
# 0.1, every value logged. Twice each, to see that a run repeats itself.
# Writes a fingerprint of each model's values to $RUN_VALUES (default
# run-values.json in $HEADLESS_OUT or the current directory); with
# $BASELINE, the file of an earlier run, prints every model that differs.
# Run it before a change to the engine and after (tools/engine/MAINTAINING.md).
# Over http (tools/serve.py). About 5 minutes.
import glob, hashlib, os
files = sorted(glob.glob(os.path.join(os.getcwd(), 'reference/catalogue/*.pl')))
if not files: raise SystemExit('run it from the repository root')
out = os.environ.get('RUN_VALUES') or os.path.join(os.environ.get('HEADLESS_OUT', os.getcwd()), 'run-values.json')
RUN = r"""(async()=>{ let pl; try { pl = Sienna.exportSimile.prolog(Sienna.importSimile.read(__pl).model) } catch(e) { return JSON.stringify(['refused', 'refused']) }
  const once = async () => {
    let e; try { e = await Sienna.LocalEngine.build('t', pl, ()=>{}) } catch(x) { return 'NO BUILD ' + String(x.message).slice(0, 80) }
    const s = await Sienna.LocalEngine.open(e);
    try {
      const d = JSON.parse(await s.act('Describe'));
      const ids = Object.keys(d).filter(k => d[k].type !== 'VALUELESS').sort((a,b)=>d[a].captpath<d[b].captpath?-1:1);
      s._steps('0.1'); s._call('sx_reset','number',['number','number','number'],[0,-2,12345]);
      const rows = JSON.parse(await s.act('ExecuteMulti', {current:0, step:'0.1', runlength:3, log:1, note: JSON.stringify(ids)}));
      return JSON.stringify(ids.map(k=>d[k].captpath)) + JSON.stringify(rows);
    } catch(x) { return 'RUN ERROR ' + String(x.message).slice(0, 80) } finally { s.exit() }
  };
  const a = await once(), b = await once();
  return JSON.stringify([a, b]); })()"""
async def fresh():
    await nav('http://localhost:8731/index.html?newuser=fresh'); await sleep(4)
res = {}
await fresh()
for i, f in enumerate(files):
    n = os.path.basename(f)[:-3]
    if i % 6 == 5: await fresh()          # a page's memory grows with each compiled model
    r = None
    for attempt in range(3):
        await ev("window.__pl=%s; 1" % json.dumps(open(f, errors='replace').read()))
        r = await ev(RUN)
        if r is not None: break
        await fresh()
    if r is None: res[n] = {'values': None, 'repeats': False, 'note': 'no answer'}; continue
    a, b = json.loads(r)
    plain = a in ('refused',) or a.startswith(('NO BUILD', 'RUN ERROR'))
    res[n] = {'values': a if plain else hashlib.md5(a.encode()).hexdigest()[:12],
              'repeats': a == b, 'note': ''}
open(out, 'w').write(json.dumps(res, indent=1, sort_keys=True))
ran = [k for k, v in res.items() if v['values'] and len(v['values']) == 12]
print(out + ':', len(res), 'models,', len(ran), 'ran,', sum(1 for k in ran if res[k]['repeats']), 'repeated their values')
for k, v in sorted(res.items()):
    if k not in ran: print('  not run:', k, v['values'] or v['note'])
    elif not v['repeats']: print('  DID NOT REPEAT:', k)
base = os.environ.get('BASELINE')
if base:
    old = json.load(open(base))
    diff = [k for k in sorted(set(old) | set(res)) if (old.get(k) or {}).get('values') != (res.get(k) or {}).get('values')]
    print('against', base + ':', len(diff), 'differ')
    for k in diff: print('  DIFFERS:', k, (old.get(k) or {}).get('values'), '->', (res.get(k) or {}).get('values'))
