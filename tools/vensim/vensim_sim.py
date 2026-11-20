#!/usr/bin/env python3
"""An independent simulator for Vensim text models, to check conversions.

    python3 tools/vensim/vensim_sim.py model.mdl          # values at FINAL TIME, as JSON

It reads the `.mdl`'s equations itself and runs them by Euler at the model's
TIME STEP, with Vensim's meaning for each function — sharing nothing with
mdl2json.py but the reading of the file (`equations`, `norm`, lookup points),
so a value that agrees with the converted model's run in the app says the
conversion, Simile's engine and the start time are all right. Labels in the
output are the converted model's (`label_of`), so the two can be compared
name by name (tools/vensim/compare.py).

Supported: INTEG; SMOOTH, SMOOTHI, SMOOTH3, SMOOTH3I, DELAY1, DELAY1I,
DELAY3, DELAY3I (their stock definitions); lookups and WITH LOOKUP (linear,
held at the ends); IF THEN ELSE, MIN, MAX, ABS, EXP, LN, LOG, SQRT, SIN,
COS, TAN, ARCTAN, INTEGER, MODULO, RAMP, STEP, PULSE, PULSE TRAIN, XIDZ,
ZIDZ, ACTIVE INITIAL; TIME, TIME STEP, INITIAL TIME, FINAL TIME, SAVEPER.
Random functions and DELAY FIXED are not: such a model is reported, not run.
"""
import json, math, os, re, sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import mdl2json as M          # read, equations, norm, lookup_points, label_of


class Unsupported(Exception):
    pass


TOK = re.compile(r'''
    (?P<num>\d+\.?\d*(?:[eE][-+]?\d+)?|\.\d+(?:[eE][-+]?\d+)?)
  | (?P<logic>:AND:|:OR:|:NOT:)
  | (?P<op><>|<=|>=|[-+*/^(),<>=])
  | (?P<name>"[^"]*"|[^\W\d][\w $'&%.]*)
  | (?P<ws>\s+)
''', re.X)

STATEFUL = {'smooth': (1, False), 'smoothi': (1, True), 'smooth3': (3, False), 'smooth3i': (3, True),
            'delay1': (1, False), 'delay1i': (1, True), 'delay3': (3, False), 'delay3i': (3, True)}


class Model:
    def __init__(self, path):
        eqtext, _, _ = M.read(path)
        self.eqs, self.lookups, self.ai, self.stocks = {}, {}, {}, {}
        self.control = {}
        self.cells = []            # stateful calls: {kind order, given init?, input, T, init, state}
        lines = M.equations(eqtext)
        # Lookups first: an equation may use one the file defines later (World3).
        for lhs, rhs, units, comment in lines:
            if isinstance(rhs, tuple):
                self.lookups[M.norm(lhs)] = tuple(list(map(float, v)) for v in M.lookup_points(rhs[1]))
        for lhs, rhs, units, comment in lines:
            k = M.norm(lhs)
            if '[' in lhs:
                raise Unsupported('subscripts')
            if isinstance(rhs, tuple):
                self.lookups[k] = tuple(list(map(float, v)) for v in M.lookup_points(rhs[1]))
                continue
            if k in ('initial time', 'final time', 'time step', 'saveper'):
                self.control[k] = rhs
                continue
            m = re.match(r'^\s*ACTIVE\s+INITIAL\s*\((.*)\)\s*$', rhs, re.S | re.I)
            if m:
                a = self.split(m.group(1))
                self.ai[k] = self.compile(a[1])
                rhs = a[0]
            m = re.match(r'^\s*INTEG\s*\((.*)\)\s*$', rhs, re.S | re.I)
            if m:
                a = self.split(m.group(1))
                self.stocks[k] = {'net': self.compile(a[0]), 'init': self.compile(a[1]), 'label': M.label_of(lhs, True)}
                continue
            self.eqs[k] = {'code': self.compile(rhs), 'label': M.label_of(lhs)}

        def num(key, default):
            v = self.control.get(key)
            try:
                return float(v)
            except (TypeError, ValueError):
                return default
        self.t0, self.t1 = num('initial time', 0.0), num('final time', 100.0)
        self.dt = num('time step', 1.0)

    @staticmethod
    def split(text):
        out, depth, cur = [], 0, ''
        for ch in text:
            depth += {'(': 1, ')': -1}.get(ch, 0)
            if ch == ',' and depth == 0:
                out.append(cur); cur = ''
            else:
                cur += ch
        out.append(cur)
        return [x.strip() for x in out]

    # Vensim text -> a Python expression over V(name), F_*(…), cells
    def compile(self, text):
        text = self.unwrap_lookups(text)
        toks = []
        pos = 0
        while pos < len(text):
            m = TOK.match(text, pos)
            if not m:
                raise Unsupported('cannot read %r' % text[pos:pos + 15])
            pos = m.end()
            if m.lastgroup != 'ws':
                toks.append((m.lastgroup, m.group(m.lastgroup).rstrip()))
        self._t, self._i = toks, 0
        out = self.seq()
        return compile(out, '<vensim>', 'eval')

    def unwrap_lookups(self, text):
        while True:
            m = re.search(r'WITH\s+LOOKUP\s*\(', text, re.I)
            if not m:
                return text
            i, depth, comma = m.end(), 1, None
            while depth:
                ch = text[i]
                depth += {'(': 1, ')': -1}.get(ch, 0)
                if ch == ',' and depth == 1 and comma is None:
                    comma = i
                i += 1
            name = '__lookup %d' % len(self.lookups)
            pts = M.lookup_points(text[comma + 1:i - 1].strip()[1:-1])
            self.lookups[M.norm(name)] = (list(map(float, pts[0])), list(map(float, pts[1])))
            text = text[:m.start()] + '"' + name + '"(' + text[m.end():comma] + ')' + text[i:]

    def seq(self):
        parts = []
        depth = 0
        while self._i < len(self._t):
            kind, val = self._t[self._i]
            if val in (',', ')') and depth == 0:
                break
            self._i += 1
            if val == '(':
                depth += 1; parts.append('(')
            elif val == ')':
                depth -= 1; parts.append(')')
            elif kind == 'op':
                parts.append({'=': '==', '<>': '!=', '^': '**'}.get(val, val))
            elif kind == 'logic':
                parts.append({':AND:': ' and ', ':OR:': ' or ', ':NOT:': ' not '}[val])
            elif kind == 'num':
                parts.append('float(%r)' % val)
            else:
                parts.append(self.term(val))
        return ''.join(parts)

    def args(self):
        self._i += 1                      # (
        out = []
        if self._t[self._i][1] != ')':
            out.append(self.seq())
            while self._t[self._i][1] == ',':
                self._i += 1
                out.append(self.seq())
        self._i += 1                      # )
        return out

    def term(self, val):
        k = M.norm(val)
        call = self._i < len(self._t) and self._t[self._i][1] == '('
        if call and k in self.lookups:
            return 'LK(%r, %s)' % (k, self.args()[0])
        if call:
            a = self.args()
            if k in STATEFUL:
                order, given = STATEFUL[k]
                cell = len(self.cells)
                self.cells.append({'order': order, 'input': compile(a[0], '<in>', 'eval'),
                                   'T': compile(a[1], '<T>', 'eval'),
                                   'init': compile(a[2], '<init>', 'eval') if given else None})
                return 'CELL(%d)' % cell
            if k == 'if then else':
                return '(IFTE(%s, lambda: (%s), lambda: (%s)))' % tuple(a)
            if k in ('random uniform', 'random normal', 'delay fixed', 'a function of'):
                raise Unsupported(k.upper())
            fn = {'min': 'min', 'max': 'max', 'abs': 'abs', 'exp': 'math.exp', 'ln': 'math.log',
                  'sqrt': 'math.sqrt', 'sin': 'math.sin', 'cos': 'math.cos', 'tan': 'math.tan',
                  'arctan': 'math.atan', 'integer': 'INTEGER', 'modulo': 'MODULO', 'ramp': 'RAMP',
                  'step': 'STEP', 'pulse': 'PULSE', 'pulse train': 'PULSE_TRAIN', 'xidz': 'XIDZ',
                  'zidz': 'ZIDZ', 'log': 'LOG'}.get(k)
            if not fn:
                raise Unsupported('function ' + k.upper())
            return '%s(%s)' % (fn, ', '.join(a))
        if k == 'time':
            return 'TIME'
        if k == 'time step':
            return 'DT'
        if k in ('initial time', 'final time', 'saveper'):
            return 'CONTROL(%r)' % k
        return 'V(%r)' % k

    # ---- running
    def run(self):
        self.time = self.t0
        self.state = {}
        env = {
            'math': math, 'min': min, 'max': max, 'abs': abs,
            'IFTE': lambda c, a, b: a() if c else b(),
            'INTEGER': lambda x: float(int(x)), 'MODULO': lambda a, b: math.fmod(a, b),
            'LOG': lambda x, b=None: math.log(x) / math.log(b) if b is not None else math.log10(x),
            'XIDZ': lambda a, b, x: x if b == 0 else a / b,
            'ZIDZ': lambda a, b: 0.0 if b == 0 else a / b,
            'RAMP': lambda s, a, b=None: 0.0 if self.time < a else s * ((self.time if b is None or self.time < b else b) - a),
            'STEP': lambda h, t: h if self.time >= t else 0.0,
            'PULSE': lambda s, w: 1.0 if s <= self.time < s + w else 0.0,
            'PULSE_TRAIN': lambda s, w, i, e: 1.0 if (s <= self.time <= e and math.fmod(self.time - s, i) < w) else 0.0,
            'LK': self.lookup, 'V': self.value, 'CELL': self.cell,
            'CONTROL': lambda k: {'initial time': self.t0, 'final time': self.t1, 'saveper': self.dt}[k],
        }
        self.env = env
        # Initial values: stocks and cells, in dependency order (recursion, memoised).
        self.initialising = True
        self.memo = {}
        self.cellstate = {}
        for k in self.stocks:
            self.value(k)
        for c in range(len(self.cells)):
            self.cell(c)
        self.state = {k: self.memo[k] for k in self.stocks}
        self.initialising = False
        steps = int(round((self.t1 - self.t0) / self.dt))
        for n in range(steps):
            self.time = self.t0 + n * self.dt
            env['TIME'] = self.time
            self.memo = {}
            net = {k: self.ev(s['net']) for k, s in self.stocks.items()}
            dcell = {}
            for c, cell in enumerate(self.cells):
                x = self.ev(cell['input'])
                T = self.ev(cell['T']) / cell['order']
                st = self.cellstate[c]
                prev = [x] + st[:-1]
                dcell[c] = [(prev[j] - st[j]) / T for j in range(cell['order'])]
            for k in self.stocks:
                self.state[k] += self.dt * net[k]
            for c in dcell:
                self.cellstate[c] = [v + self.dt * d for v, d in zip(self.cellstate[c], dcell[c])]
        self.time = self.t1
        env['TIME'] = self.time
        self.memo = {}
        out = {}
        for k, s in self.stocks.items():
            out[s['label']] = self.state[k]
        for k, e in self.eqs.items():
            try:
                out[e['label']] = self.value(k)
            except ZeroDivisionError:
                pass
        return out

    def ev(self, code):
        self.env['TIME'] = self.time
        self.env['DT'] = self.dt
        return eval(code, self.env)

    def value(self, k):
        if k in self.memo:
            v = self.memo[k]
            if v is None:
                raise Unsupported('a circular definition through ' + k)
            return v
        if not self.initialising and k in self.stocks:
            return self.state[k]
        self.memo[k] = None
        if k in self.stocks:
            v = self.ev(self.stocks[k]['init'])
        elif self.initialising and k in self.ai:
            v = self.ev(self.ai[k])
        elif k in self.eqs:
            v = self.ev(self.eqs[k]['code'])
        else:
            raise Unsupported('no equation for ' + k)
        self.memo[k] = float(v)
        return self.memo[k]

    def cell(self, c):
        if c not in self.cellstate:
            cell = self.cells[c]
            start = self.ev(cell['init'] if cell['init'] is not None else cell['input'])
            self.cellstate[c] = [float(start)] * cell['order']
        return self.cellstate[c][-1]

    def lookup(self, name, x):
        xs, ys = self.lookups[name]
        if x <= xs[0]:
            return ys[0]
        if x >= xs[-1]:
            return ys[-1]
        for i in range(1, len(xs)):
            if x <= xs[i]:
                t = (x - xs[i - 1]) / (xs[i] - xs[i - 1])
                return ys[i - 1] + t * (ys[i] - ys[i - 1])
        return ys[-1]


if __name__ == '__main__':
    try:
        print(json.dumps(Model(sys.argv[1]).run()))
    except Unsupported as e:
        print(json.dumps({'unsupported': str(e)}))
