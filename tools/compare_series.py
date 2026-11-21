#!/usr/bin/env python3
"""Compare a model's run in Simile with published results, value by value.

    python3 tools/compare_series.py OURS.csv THEIRS.csv [options]

OURS.csv is what `check_models.py --csv` writes: a `time` column, then a
column per variable. THEIRS.csv is the paper's results as CSV, a column of
times and a column per quantity (convert them first if they come in another
form: examples/papers/coral/results_to_csv.py does it for numpy pickles).

Options:
  --map Coral=CORAL,Trait=TRAIT   our column = theirs, where the names differ
                                  (columns with the same name are matched anyway)
  --time TIME                     their time column (default: the first)
  --offset 24012                  added to THEIR times to give ours (a different
                                  origin: theirs counts from the spin-up's start)
  --scale 1                       their times are multiplied by this first
  --at 0,120,1752                 the times to print (default: 12 evenly spaced)
  --tolerance 0.001               relative difference counted as agreeing

Prints each matched quantity at those times, ours beside theirs, then for
each its largest relative difference over every shared time and how many
times agree within the tolerance. A model with random numbers cannot agree
value for value: compare its trends, or several runs' range.
"""
import argparse, csv, sys

ap = argparse.ArgumentParser(description='Compare a Simile run (CSV) with published results (CSV).')
ap.add_argument('ours'); ap.add_argument('theirs')
ap.add_argument('--map', default='')
ap.add_argument('--time')
ap.add_argument('--offset', type=float, default=0.0)
ap.add_argument('--scale', type=float, default=1.0)
ap.add_argument('--at', default='')
ap.add_argument('--tolerance', type=float, default=1e-3)
a = ap.parse_args()


def read(path):
    with open(path, newline='') as fh:
        rows = list(csv.reader(fh))
    head, body = rows[0], rows[1:]
    cols = {h: [] for h in head}
    for r in body:
        for h, v in zip(head, r):
            try:
                cols[h].append(float(v))
            except ValueError:
                cols[h].append(None)
    return head, cols


oh, ours = read(a.ours)
th, theirs = read(a.theirs)
ttime = a.time or th[0]
pairs = dict(x.split('=', 1) for x in a.map.split(',') if '=' in x)
for h in oh[1:]:
    if h not in pairs and h in theirs and h != ttime:
        pairs[h] = h
pairs = {o: t for o, t in pairs.items() if o in ours and t in theirs}
if not pairs:
    sys.exit('No columns to compare: name them with --map ours=theirs.\n  ours: %s\n  theirs: %s'
             % (', '.join(oh[1:]), ', '.join(h for h in th if h != ttime)))

# Times on both sides, matched to a millionth of a unit.
key = lambda t: round(t, 6)
our_at = {key(t): i for i, t in enumerate(ours['time']) if t is not None}
their_at = {key(t * a.scale + a.offset): i for i, t in enumerate(theirs[ttime]) if t is not None}
shared = sorted(set(our_at) & set(their_at))
if not shared:
    sys.exit('No times in common: check --offset and --scale (ours run %g to %g; theirs, shifted, %g to %g).'
             % (min(our_at), max(our_at), min(their_at), max(their_at)))

if a.at:
    show = [key(float(x)) for x in a.at.split(',')]
    show = [t for t in show if t in our_at and t in their_at]
else:
    step = max(1, len(shared) // 11)
    show = shared[::step][:11] + [shared[-1]]


def rel(x, y):
    if x is None or y is None:
        return None
    return abs(x - y) / max(abs(x), abs(y), 1e-300)


print('%-10s' % 'time' + ''.join('%26s' % ('%s (ours | theirs)' % o)[:26] for o in pairs))
for t in show:
    cells = []
    for o, th_ in pairs.items():
        x, y = ours[o][our_at[t]], theirs[th_][their_at[t]]
        cells.append('%26s' % ('%.5g | %.5g' % (x, y) if x is not None and y is not None else '-'))
    print('%-10g' % t + ''.join(cells))

print('\nOver %d shared times:' % len(shared))
for o, th_ in pairs.items():
    ds = [rel(ours[o][our_at[t]], theirs[th_][their_at[t]]) for t in shared]
    ds = [d for d in ds if d is not None]
    worst = max(ds) if ds else float('nan')
    agree = sum(1 for d in ds if d <= a.tolerance)
    print('  %-20s largest relative difference %.3g; %d of %d within %g' % (o, worst, agree, len(ds), a.tolerance))
