#!/usr/bin/env python3
"""Compare converted models' runs in the app with the Vensim originals'.

    python3 tools/vensim/compare.py <model-file.py output> <dir of .mdl>

The first is what tools/headless/scripts/model-file.py printed for the
converted models (their values at the end of each run); for each, the `.mdl`
of the same name is run by vensim_sim.py, and every value the two share is
compared. A value agrees when the relative difference is under 1e-6 (or the
absolute under 1e-9). Prints a line per model and a summary.
"""
import glob, json, os, re, subprocess, sys

out_file, mdl_dir = sys.argv[1], sys.argv[2]
here = os.path.dirname(os.path.abspath(__file__))
mdls = {os.path.basename(p)[:-4]: p for p in glob.glob(os.path.join(mdl_dir, '**', '*.mdl'), recursive=True)}

runs, cur = {}, None
for line in open(out_file):
    m = re.match(r'^== (.*)\.json$', line.strip())
    if m:
        cur = os.path.basename(m.group(1)); runs[cur] = {'values': {}, 'pass': False}
        continue
    if cur is None:
        continue
    if 'PASS loads, complete, exports, runs' in line:
        runs[cur]['pass'] = True
    m = re.match(r'^\s+/(\S+) = (.*)$', line)
    if m:
        try:
            runs[cur]['values'][m.group(1)] = float(m.group(2))
        except ValueError:
            pass                                   # a population's summary

agree, differ, skipped = [], [], []
for name in sorted(runs):
    r = runs[name]
    if not r['pass']:
        skipped.append((name, 'did not pass the app\'s check'))
        continue
    if name not in mdls:
        skipped.append((name, 'no .mdl')); continue
    ref = json.loads(subprocess.run([sys.executable, '-I', os.path.join(here, 'vensim_sim.py'), mdls[name]],
                                    capture_output=True, text=True).stdout or '{}')
    if 'unsupported' in ref or not ref:
        skipped.append((name, 'reference cannot run it: %s' % ref.get('unsupported', 'no output'))); continue
    shared = sorted(set(ref) & set(r['values']))
    bad = []
    for k in shared:
        a, b = r['values'][k], ref[k]
        if abs(a - b) > max(1e-9, 1e-6 * max(abs(a), abs(b))):
            bad.append('%s: app %.10g, Vensim %.10g' % (k, a, b))
    (differ if bad else agree).append((name, len(shared), bad))

for name, n, bad in agree:
    print('AGREE   %-40s %d values' % (name, n))
for name, n, bad in differ:
    print('DIFFER  %-40s %d of %d values: %s' % (name, len(bad), n, '; '.join(bad[:3])))
for name, why in skipped:
    print('SKIPPED %-40s %s' % (name, why))
print('\n%d agree, %d differ, %d not compared' % (len(agree), len(differ), len(skipped)))
