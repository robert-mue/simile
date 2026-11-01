# Crossing forms: for every influence in the catalogue and nkometou, what
# Simile's file says the consumer receives (the `use` term's units, e.g.
# list(array(1,4))) against what our rule gives (Diagram.valueAt). Units'
# base (1, int, boolean) is not compared, only the nesting and the sizes;
# size(x) counts as x's number of instances. Prints a summary and every
# kind of mismatch with an example. Over http (tools/serve.py).
import json, glob
files = sorted(glob.glob('/home/user/Projects/simile/reference/catalogue/*.pl')) + ['/home/user/Projects/simile/reference/large/nkometou.pl']
await nav('http://localhost:8731/index.html?newuser=fresh'); await sleep(4)
await ev(r"""window.__shape = function (term, model) {
  // 'list(array(1,4))' -> 'L A4'; base dropped; size(x) -> x's count
  const t = String(term).replace(/\s+(?=(?:[^']*'[^']*')*[^']*$)/g, '');
  const out = [];
  let rest = t;
  for (;;) {
    let m;
    if ((m = /^list\((.*)\)$/.exec(rest))) { out.push('L'); rest = m[1]; continue; }
    if ((m = /^array\((.*)\)$/.exec(rest))) {
      // split at the LAST top-level comma
      const inner = m[1]; let depth = 0, cut = -1;
      for (let i = 0; i < inner.length; i++) { const c = inner[i];
        if ('([{'.includes(c)) depth++; else if (')]}'.includes(c)) depth--;
        else if (c === ',' && !depth) cut = i; }
      let size = inner.slice(cut + 1); rest = inner.slice(0, cut);
      const sm = /^size\((.*)\)$/.exec(size);
      if (sm) {
        const key = x => String(x).replace(/\\n/g, ' ').replace(/[^A-Za-z0-9]/g, '').toLowerCase();
        const want = key(sm[1].replace(/^'|'$/g, ''));
        const s = Object.values(model.submodels || {}).find(s => key(s.label) === want);
        if (s && s.props && s.props.dimensions) size = String(s.props.dimensions).replace(/\s+/g, '');
      }
      out.push('A' + size); continue;
    }
    break;
  }
  return out.join(' ') || '-';
}; 1""")
total = {'ok': 0, 'bad': 0}
kinds = {}
for f in files:
    await ev("window.__pl=%s; 1" % json.dumps(open(f, errors='replace').read()))
    r = await ev(r"""(()=>{ try {
      const r = Sienna.importSimile.read(__pl); const m = r.model; const D = Sienna.Diagram;
      const out = [];
      r.uses.forEach(u => {
        const arc = m.arcs[u.arc]; if (!arc) return;
        const hier = u.uses.filter(x => x.dir === 'in_hierarchy');
        const assoc = u.uses.filter(x => x.dir === 'in_base' || x.dir === 'in_assoc');
        const roles = D.rolesCrossedBy(m, u.arc);
        if (assoc.length && roles.length) {
          const want = assoc.map(x => __shape(x.dim, m)).sort().join(' | ');
          const got = [...new Set(roles.map(rid => __shape(D.valueAt(m, u.arc, rid).term, m)))].sort();
          const wantSet = [...new Set(assoc.map(x => __shape(x.dim, m)))].sort();
          out.push([wantSet.join(' | '), got.join(' | '), assoc[0].dir + ' ' + assoc[0].alias + ' ' + assoc[0].dim]);
        } else if (hier.length) {
          out.push([__shape(hier[0].dim, m), __shape(D.valueAt(m, u.arc).term, m), 'in_hierarchy ' + hier[0].alias + ' ' + hier[0].dim]);
        }
      });
      return JSON.stringify(out);
    } catch (e) { return JSON.stringify([['ERR', e.message, e.stack.slice(0,200)]]); } })()""")
    for want, got, ex in json.loads(r):
        if want == got: total['ok'] += 1; continue
        total['bad'] += 1
        k = (want, got)
        kinds.setdefault(k, []).append(f.split('/')[-1] + ': ' + ex)
print('influences: %d agree with Simile, %d do not' % (total['ok'], total['bad']))
for (want, got), exs in sorted(kinds.items(), key=lambda x: -len(x[1])):
    print('%4d  Simile %-14s ours %-14s e.g. %s' % (len(exs), want, got, exs[0][:120]))
    files_ = sorted(set(e.split(':')[0] for e in exs))
    print('        in', ', '.join(files_[:8]) + (' …' if len(files_) > 8 else ''))
