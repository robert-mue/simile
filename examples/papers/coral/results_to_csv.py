#!/usr/bin/env python3
"""The authors' published runs (their Results/*.dat, numpy arrays pickled by
Python 2) as CSV, for tools/compare_series.py:

    python3 results_to_csv.py their-code/Results GBR RCP26 > theirs-GBR-RCP26.csv

Columns: month (counted from the start of their 2000-year spin-up; our time
is month - 24012, so compare with --offset -24012), CORAL, TRAIT, SYMB.

Read WITHOUT numpy and without running anything in the files: a pickle can
run code when loaded, so only numpy's array-rebuilding names are allowed,
each a harmless stand-in that keeps the raw numbers.
"""
import csv, pickle, struct, sys


class _DType:
    def __init__(self, *a):
        self.code = a[0] if a else None

    def __setstate__(self, state):
        pass


class _Array:
    def __setstate__(self, state):
        _, self.shape, dtype, _fortran, raw = state
        if isinstance(raw, str):
            raw = raw.encode('latin1')
        if dtype.code != 'f8':
            raise ValueError('expected doubles, found ' + str(dtype.code))
        self.flat = struct.unpack('<%dd' % (len(raw) // 8), raw)


class _Safe(pickle.Unpickler):
    ALLOWED = {('numpy.core.multiarray', '_reconstruct'): lambda cls, shape, dtype: _Array(),
               ('numpy', 'ndarray'): _Array, ('numpy', 'dtype'): _DType}

    def find_class(self, module, name):
        if (module, name) not in self.ALLOWED:
            raise pickle.UnpicklingError('not allowed in these files: %s.%s' % (module, name))
        return self.ALLOWED[(module, name)]


def load(path):
    with open(path, 'rb') as fh:
        return _Safe(fh, encoding='latin1').load().flat


if __name__ == '__main__':
    folder, reg, rcp = sys.argv[1], sys.argv[2], sys.argv[3]
    cols = {k: load('%s/%s-%s-%s.dat' % (folder, k, rcp, reg)) for k in ('CORAL', 'TRAIT', 'SYMB')}
    w = csv.writer(sys.stdout)
    w.writerow(['month', 'CORAL', 'TRAIT', 'SYMB'])
    for k in range(len(cols['CORAL'])):
        w.writerow([k, cols['CORAL'][k], cols['TRAIT'][k], cols['SYMB'][k]])
