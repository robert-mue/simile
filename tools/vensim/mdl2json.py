#!/usr/bin/env python3
"""Convert a Vensim model (.mdl, text form) into a Simile model spec (.json).

    python3 tools/vensim/mdl2json.py model.mdl [-o model.json]

What it reads (Vensim's text format):

  EQUATIONS   `name = expression ~ units ~ comment |`, up to the sketch.
              A stock is `INTEG(net inflow, initial value)`. Lookups,
              `name( [(xmin,ymin)-(xmax,ymax)], (x1,y1), ... )`, become
              `interpolate(x, [xs], [ys])` where they are used.
              `.Control`: INITIAL TIME, FINAL TIME, TIME STEP, SAVEPER.
  SKETCH      after `\\\\\\---///`, one record per line, positions as centres
              and half-sizes:
                10,id,name,x,y,w,h,shape,...   a variable (shape 3 = a stock)
                11,id,...,x,y,...              a valve; the next 10 is its flow
                12,id,48,x,y,...               a cloud (48 = the cloud glyph)
                1,id,from,to,f,...|(x,y)|      an arrow: a pipe from a valve
                                               (f 100 at its source, 4 at its
                                               end), or an influence through
                                               the point (x,y)
  GRAPHS      `:GRAPH` ... `:VAR name` — the book's plots, as default displays.

What it writes: the model spec of help/model-file-reference.md. Names are
Vensim's with every run of spaces or other characters made `_`. Each flow is a
valve between the stocks its INTEG terms name (a cloud where a flow has only
one), placed as the sketch places them, scaled. Influences are what each
equation USES (Simile needs one for every name), curved as Vensim draws them
where Vensim has the arrow. Units are left out, as the reference says, and
listed in the model's comment instead.

TIME: the run starts at Vensim's INITIAL TIME (`presentation.run.startTime`),
and `TIME` is the run's time on the step grid (`Expr.now`), so every time in
an equation is as Vensim has it and comparisons with it land on the step.

Prints what it could not convert, and exits 1 if anything.
"""
import json, math, re, sys

SCALE = 1.0            # Vensim sketch units to Simile's: full size, room for the names
problems = []


def warn(msg):
    problems.append(msg)


# ---------------------------------------------------------------- reading

def read(path):
    raw = open(path, 'rb').read().decode('latin-1').replace('\r', '')
    if raw.startswith('{UTF-8}'):
        raw = open(path, 'rb').read().decode('utf-8').replace('\r', '')[7:]
    cut = raw.find('\\\\\\---///')
    eqtext = raw if cut < 0 else raw[:cut]
    rest = '' if cut < 0 else raw[cut:]
    sk_end = rest.find('///---\\\\\\')
    sketch = rest[:sk_end] if sk_end >= 0 else rest
    after = rest[sk_end:] if sk_end >= 0 else ''
    return eqtext, sketch, after


def equations(eqtext):
    """[(lhs, rhs, units, comment)] in file order, the control group included."""
    out = []
    text = re.sub(r'\\\n\s*', '', eqtext)          # continued lines
    for entry in text.split('|'):
        entry = entry.strip()
        if not entry or entry.startswith('*'):
            if '.Control' in entry:
                entry = entry[entry.find('~') + 1:] if False else ''
            continue
        parts = entry.split('~')
        body = parts[0].strip()
        units = parts[1].strip() if len(parts) > 1 else ''
        comment = parts[2].strip() if len(parts) > 2 else ''
        if body.startswith('*'):
            continue
        m = re.match(r'^(.*?)\s*(:=|==|=)\s*(.*)$', body, re.S)
        lk = re.match(r'^([^=(\[]+?)\s*\(\s*(\[.*|\(\s*[-+0-9.eE]+\s*,.*)\)\s*$', body, re.S)
        if lk and (not m or m.start(2) > lk.end(1) + 3):
            out.append((lk.group(1).strip(), ('LOOKUP', lk.group(2)), units, comment))
        elif m:
            out.append((m.group(1).strip(), m.group(3).strip(), units, comment))
        else:
            warn('could not read the equation: ' + body[:60])
    return out


def real(num):
    """A number written as a real: Vensim's numbers all are, and Simile's
    generator will not build an `if` whose branches are an int and a real
    (`else 0` beside `0.1*x`): it fails without saying why."""
    return num if re.search(r'[.eE]', num) else num + '.0'


def norm(name):
    """Vensim's name equality: case, spaces and underscores do not count."""
    return re.sub(r'[\s_]+', ' ', name.strip().strip('"')).lower()


def label_of(name, stock=False):
    """A Simile label: lower case, `_` for spaces, a stock's first letter a
    capital (Robert, 2026-11-20: one style across the gallery's models)."""
    s = name.strip().strip('"').lower()
    for a, b in (('ä', 'ae'), ('ö', 'oe'), ('ü', 'ue'), ('ß', 'ss'), ('é', 'e'), ('è', 'e')):
        s = s.replace(a, b)
    s = re.sub(r'[^A-Za-z0-9_]+', '_', s).strip('_')
    s = re.sub(r'_+', '_', s)
    if not s or s[0].isdigit():
        s = 'v_' + s
    return s[0].upper() + s[1:] if stock else s


def lookup_points(spec):
    """'[(0,0)-(10,1)],(0,0),(5,.5),(10,1)' -> ([xs], [ys])."""
    body = re.sub(r'^\s*\[[^\]]*\]\s*,?', '', spec)
    body = re.sub(r'\[\s*\(.*?\)\s*\]', '', body)   # reference lines Vensim may add
    pts = re.findall(r'\(\s*([-+0-9.eE]+)\s*,\s*([-+0-9.eE]+)\s*\)', body)
    return [p[0] for p in pts], [p[1] for p in pts]


# ---------------------------------------------------------------- expressions

TOKEN = re.compile(r'''
    (?P<num>\d+\.?\d*(?:[eE][-+]?\d+)?|\.\d+(?:[eE][-+]?\d+)?)
  | (?P<quoted>"[^"]*")
  | (?P<logic>:AND:|:OR:|:NOT:)
  | (?P<op><>|<=|>=|[-+*/^(),<>=])
  | (?P<name>[^\W\d][\w $'&%.]*)
  | (?P<ws>\s+)
''', re.X)


def tokens(text):
    pos, out = 0, []
    while pos < len(text):
        m = TOKEN.match(text, pos)
        if not m:
            raise ValueError('cannot read "%s"' % text[pos:pos + 20])
        pos = m.end()
        kind = m.lastgroup
        if kind == 'ws':
            continue
        val = m.group(kind)
        if kind == 'name':
            val = val.rstrip()
        out.append((kind, val))
    return out


class Expr:
    """Vensim expression -> Simile expression, and the names it uses."""

    def __init__(self, names, lookups, t0):
        self.names = names          # norm -> label
        self.lookups = lookups      # norm -> (xs, ys)
        self.t0 = t0

    def convert(self, text):
        self.toks = tokens(text)
        self.i = 0
        self.used = set()
        out = self.expr()
        if self.i != len(self.toks):
            raise ValueError('unexpected "%s"' % self.toks[self.i][1])
        return out, self.used

    def peek(self):
        return self.toks[self.i] if self.i < len(self.toks) else (None, None)

    def take(self, val=None):
        t = self.peek()
        if val is not None and t[1] != val:
            raise ValueError('expected "%s"' % val)
        self.i += 1
        return t

    def args(self):
        self.take('(')
        out = []
        if self.peek()[1] != ')':
            out.append(self.expr())
            while self.peek()[1] == ',':
                self.take(',')
                out.append(self.expr())
        self.take(')')
        return out

    # A flat walk: operators copied (translated), operands converted.
    def expr(self):
        parts = []
        depth = 0
        while self.i < len(self.toks):
            kind, val = self.peek()
            if val in (',', ')') and depth == 0:
                break
            if val == '(':
                depth += 1
                self.take()
                parts.append('(')
                continue
            if val == ')':
                depth -= 1
                self.take()
                parts.append(')')
                continue
            if kind == 'op':
                self.take()
                parts.append({'=': '==', '<>': '!='}.get(val, val))
            elif kind == 'logic':
                self.take()
                parts.append({':AND:': ' and ', ':OR:': ' or ', ':NOT:': ' not '}[val])
            elif kind == 'num':
                self.take()
                parts.append(real(val))
            else:
                parts.append(self.operand())
        return ''.join(parts)

    def now(self):
        """Vensim's TIME: the run's time snapped to the step grid. The
        engine's time() adds up the steps, so at a step meant to be t=2 it can
        be 1.9999999, and a comparison `Time<2` (EZ214), or a PULSE TRAIN
        landing on its interval (the Z_ models), goes the wrong way. The step
        is the model's own number, not dt() (see `time step`)."""
        t0, h = self.t0, self.step
        if float(t0):
            return '(%s+round((time()-%s)/%s)*%s)' % (t0, t0, h, h)
        return '(round(time()/%s)*%s)' % (h, h)

    def operand(self):
        kind, val = self.take()
        key = norm(val)
        is_call = self.peek()[1] == '('
        if key in self.lookups and is_call:
            a = self.args()
            xs, ys = self.lookups[key]
            return 'interpolate(%s, [%s], [%s])' % (a[0], ', '.join(xs), ', '.join(ys))
        if is_call and key not in self.names:
            return self.function(key, self.args())
        if key == 'time':
            return self.now()
        if key == 'time step':
            # The number itself: the engine's dt() is not exactly 0.1, and
            # the Z_ models' INTEGER(10*…) then lands on the wrong cell.
            return self.step
        if key in getattr(self, 'constants', {}):
            return self.constants[key]
        if getattr(self, 'initial', False) and key in getattr(self, 'ai', {}):
            sub = Expr(self.names, self.lookups, self.t0)
            sub.constants, sub.ai, sub.initial = self.constants, self.ai, True
            out, used = sub.convert(self.ai[key])
            self.used |= used
            return '(' + out + ')'
        if key in self.names:
            self.used.add(key)
            return self.names[key]
        raise ValueError('unknown name "%s"' % val)

    def function(self, f, a):
        simple = {'min': 'min', 'max': 'max', 'abs': 'abs', 'exp': 'exp', 'ln': 'log',
                  'sqrt': 'sqrt', 'sin': 'sin', 'cos': 'cos', 'tan': 'tan',
                  'arctan': 'atan', 'integer': 'int', 'modulo': 'fmod',
                  'smooth': 'smth1', 'smooth3': 'smth3', 'delay1': 'delay1',
                  'delay3': 'delay3', 'smoothi': 'smth1', 'smooth3i': 'smth3',
                  'delay1i': 'delay1', 'delay3i': 'delay3', 'step': 'step',
                  'random uniform': None}
        if f == 'if then else':
            return '(if %s then %s else %s)' % tuple(a)
        if f == 'ramp':
            s, t1 = a[0], a[1]
            t = self.now()
            if len(a) == 2:
                return '(if %s<%s then 0.0 else %s*(%s-%s))' % (t, t1, s, t, t1)
            t2 = a[2]
            return '(if %s<%s then 0.0 elseif %s<%s then %s*(%s-%s) else %s*(%s-%s))' % (
                t, t1, t, t2, s, t, t1, s, t2, t1)
        if f == 'pulse':
            t = self.now()
            return '(if %s>=%s and %s<%s+%s then 1.0 else 0.0)' % (t, a[0], t, a[0], a[1])
        if f == 'xidz':
            return '(if %s==0.0 then %s else %s/%s)' % (a[1], a[2], a[0], a[1])
        if f == 'zidz':
            return '(if %s==0.0 then 0.0 else %s/%s)' % (a[1], a[0], a[1])
        if f == 'log' and len(a) == 2:
            return '(log(%s)/log(%s))' % (a[0], a[1])
        if f == 'pulse train':
            t = self.now()
            return '(if %s>=%s and %s<=%s and fmod(%s-%s,%s)<%s then 1.0 else 0.0)' % (
                t, a[0], t, a[3], t, a[0], a[2], a[1])
        if f == 'delay fixed':
            # A pure lag: Simile's const_delay is its equivalent, but in the
            # page's engine it does not delay (tools/engine/README.md, "Known
            # faults"), and a lag has no stock form. Left out (Robert).
            raise ValueError('DELAY FIXED (a pure time lag) cannot be converted until the engine\'s '
                             'const_delay works: see tools/engine/README.md, "Known faults"')
        if f == 'random uniform':
            return 'rand_var(%s,%s)' % (a[0], a[1])
        if f == 'step':
            # Vensim STEP(height, time) is Simile's step(height, time), time absolute.
            return '(if %s>=%s then %s else 0.0)' % (self.now(), a[1], a[0])
        if f in simple and simple[f]:
            return '%s(%s)' % (simple[f], ', '.join(a))
        raise ValueError('no Simile equivalent for the function %s' % f.upper())


# ---------------------------------------------------------------- sketch

def sketch_records(sketch):
    recs = []
    for line in sketch.split('\n'):
        if not re.match(r'^\d+,', line):
            continue
        head, _, pts = line.partition('|')
        f = next(__import__('csv').reader([head]))
        recs.append((f, pts))
    return recs


def bends_of(path):
    """The corners of a path: its points less repeats and those on a straight
    line between their neighbours. The two ends are not corners."""
    pts = []
    for p in path:
        if not pts or math.hypot(p[0] - pts[-1][0], p[1] - pts[-1][1]) > 0.5:
            pts.append(p)
    changed = True
    while changed and len(pts) > 2:
        changed = False
        for i in range(1, len(pts) - 1):
            (x0, y0), (x1, y1), (x2, y2) = pts[i - 1], pts[i], pts[i + 1]
            cross = (x1 - x0) * (y2 - y0) - (y1 - y0) * (x2 - x0)
            span = math.hypot(x2 - x0, y2 - y0) or 1
            if abs(cross) / span < 3:          # within 3 units of the line
                del pts[i]
                changed = True
                break
    return pts[1:-1]


def bow_through(a, z, p):
    """The bow (signed sagitta / chord) of an arc from a to z through p."""
    dx, dy = z[0] - a[0], z[1] - a[1]
    c = math.hypot(dx, dy)
    if c < 1:
        return 0.0
    nx, ny = -dy / c, dx / c
    mx, my = (a[0] + z[0]) / 2, (a[1] + z[1]) / 2
    h = (p[0] - mx) * nx + (p[1] - my) * ny
    return max(-0.45, min(0.45, h / c))


# ---------------------------------------------------------------- converting

def convert(path):
    eqtext, sketch, after = read(path)
    eqs = equations(eqtext)
    control = {}
    model_eqs = []
    for lhs, rhs, units, comment in eqs:
        key = norm(lhs)
        if key in ('initial time', 'final time', 'time step', 'saveper'):
            control[key] = rhs
        else:
            model_eqs.append((lhs, rhs, units, comment))

    def num(v, default):
        try:
            return float(v)
        except (TypeError, ValueError):
            return default
    t0 = num(control.get('initial time'), 0)
    t1 = num(control.get('final time'), 100)
    dt = num(control.get('time step'), 1)
    sp = control.get('saveper', '')
    save = dt if norm(sp) == 'time step' else num(sp, dt)
    t0s = ('%g' % t0)

    # `WITH LOOKUP(input, ( [..], (x,y), ... ))`: the table taken out as a
    # lookup of its own, used as `name(input)`.
    lookups = {}
    inline = [0]

    def unwrap(text):
        while True:
            m = re.search(r'WITH\s+LOOKUP\s*\(', text, re.I)
            if not m:
                return text
            i, depth, comma, end = m.end(), 1, None, None
            while i < len(text):
                ch = text[i]
                if ch == '(':
                    depth += 1
                elif ch == ')':
                    depth -= 1
                    if depth == 0:
                        end = i
                        break
                elif ch == ',' and depth == 1 and comma is None:
                    comma = i
                i += 1
            if end is None or comma is None:
                return text
            inline[0] += 1
            name = 'with lookup table %d' % inline[0]
            lookups[name] = lookup_points(text[comma + 1:end].strip()[1:-1])
            text = text[:m.start()] + name + '(' + text[m.end():comma] + ')' + text[end + 1:]

    model_eqs = [(l, r if isinstance(r, tuple) else unwrap(r), u, c) for l, r, u, c in model_eqs]

    # `x = ACTIVE INITIAL(active, initial)`: `active` while running, `initial`
    # while the model is set up — where a stock's starting value would
    # otherwise depend on stocks (World3). So x's equation is `active`, and in
    # every stock's starting value x is read as `initial` (Expr.initial).
    active_initial = {}
    stripped = []
    for l, r, u, c in model_eqs:
        m = None if isinstance(r, tuple) else re.match(r'^\s*ACTIVE\s+INITIAL\s*\((.*)\)\s*$', r, re.S | re.I)
        if m:
            depth, cut = 0, None
            for i, ch in enumerate(m.group(1)):
                depth += {'(': 1, ')': -1}.get(ch, 0)
                if ch == ',' and depth == 0:
                    cut = i
            if cut is not None:
                active_initial[norm(l)] = m.group(1)[cut + 1:].strip()
                r = m.group(1)[:cut].strip()
        stripped.append((l, r, u, c))
    model_eqs = stripped

    # A delay or smoothing WITH a starting value, as a whole equation —
    # `x = DELAY1I(input, time, start)` — is its stocks, as System Dynamics
    # defines it: Simile's engine will not build delay1/delay3/smth1 with a
    # third argument. First order: a stock from `start`, changing by
    # (input − it)/time. Third order: two stages and it, each with a third of
    # the time. x itself stays what the sketch draws it as (a valve stays a
    # valve), equal to that stock, `<x> smoothed` / `<x> delayed`, set out
    # just above it, its stages to its left (`stage_of`: name -> (placed
    # from, dx, dy)). A helper pulled out of a larger expression has no place
    # in the sketch: it is the stock itself, set out beside what uses it.
    stage_of = {}
    helper_names = set()
    def top_args(text):
        out, depth, cur = [], 0, ''
        for ch in text:
            if ch == '(':
                depth += 1
            elif ch == ')':
                depth -= 1
            if ch == ',' and depth == 0:
                out.append(cur.strip()); cur = ''
            else:
                cur += ch
        out.append(cur.strip())
        return out
    # Simile's own delay1/delay3/smth1/smth3 do not build in the page's engine
    # at all (2026-11-20: their definitions are "fragments" it lacks), so
    # every one of these is made of stocks. Without a starting value it starts
    # where its input does, as in Vensim. One inside a larger expression is
    # first taken out as a helper of its own, `<name> delay <n>`.
    DELAYS = r'(DELAY1I|SMOOTHI|DELAY3I|SMOOTH3I|DELAY1|DELAY3|SMOOTH3|SMOOTH)'
    def pull_out(l, r):
        helpers = []
        while True:
            m = re.search(r'\b' + DELAYS + r'\s*\(', r, re.I)
            if not m:
                return r, helpers
            i, depth = m.end(), 1
            while i < len(r) and depth:
                depth += {'(': 1, ')': -1}.get(r[i], 0)
                i += 1
            call = r[m.start():i]
            if call.strip() == r.strip():
                return r, helpers
            h = '%s delay %d' % (l, len(helpers) + 1)
            helpers.append((h, call))
            r = r[:m.start()] + h + r[i:]
    pulled = []
    for l, r, u, c in model_eqs:
        if isinstance(r, tuple):
            pulled.append((l, r, u, c))
            continue
        r2, helpers = pull_out(l, r)
        for h, call in helpers:
            pulled.append((h, call, u, ''))
            stage_of[norm(h)] = (norm(l), 260, 110 * (len(helper_names) % 3 + 1))
            helper_names.add(norm(h))
        pulled.append((l, r2, u, c))
    model_eqs = pulled

    expanded = []
    for l, r, u, c in model_eqs:
        m = None if isinstance(r, tuple) else re.match(
            r'^\s*' + DELAYS + r'\s*\((.*)\)\s*$', r, re.S | re.I)
        if not m:
            expanded.append((l, r, u, c))
            continue
        f, a = m.group(1).upper(), top_args(m.group(2))
        if len(a) == 2:
            a = a + [a[0]]                     # no starting value: its input's
            f = f + 'I' if not f.endswith('I') else f
        if len(a) != 3:
            expanded.append((l, r, u, c))
            continue
        f = {'SMOOTHI': 'SMOOTHI', 'SMOOTH3I': 'SMOOTH3I'}.get(f, f)
        inp, T, init = a
        st = l
        if norm(l) not in helper_names:
            st = l + (' smoothed' if f.startswith('SMOOTH') else ' delayed')
            expanded.append((l, st, u, c))
            stage_of[norm(st)] = (norm(l), 0, -120)
        if f in ('DELAY1I', 'SMOOTHI'):
            expanded.append((st, 'INTEG((%s-%s)/(%s), %s)' % (inp, st, T, init), u, ''))
        else:
            s1, s2 = l + ' stage 1', l + ' stage 2'
            third = '((%s)/3)' % T
            expanded.append((s1, 'INTEG((%s-%s)/%s, %s)' % (inp, s1, third, init), u, ''))
            expanded.append((s2, 'INTEG((%s-%s)/%s, %s)' % (s1, s2, third, init), u, ''))
            expanded.append((st, 'INTEG((%s-%s)/%s, %s)' % (s2, st, third, init), u, ''))
            stage_of[norm(s1)] = (norm(st), -600, 0)
            stage_of[norm(s2)] = (norm(st), -300, 0)
    model_eqs = expanded

    # Stocks first: their names are capitalised.
    stock_keys = set(norm(l) for l, r, u, c in model_eqs
                     if not isinstance(r, tuple) and re.match(r'^INTEG\s*\(', r, re.I))
    names = {}
    for lhs, rhs, units, comment in model_eqs:
        if '[' in lhs:
            warn('subscripted (array) variable not converted: ' + lhs)
            continue
        if isinstance(rhs, tuple):
            lookups[norm(lhs)] = lookup_points(rhs[1])
        else:
            names[norm(lhs)] = label_of(lhs, norm(lhs) in stock_keys)

    # Labels must be unique.
    seen = {}
    for k, lab in list(names.items()):
        while lab.lower() in seen and seen[lab.lower()] != k:
            lab += '_'
        seen[lab.lower()] = k
        names[k] = lab

    X = Expr(names, lookups, t0s)
    X.constants = {'initial time': '%g' % t0, 'final time': '%g' % t1, 'saveper': '%g' % save}
    X.step = real('%r' % dt if dt != int(dt) else '%d' % dt)
    X.ai = active_initial

    # Stocks: INTEG(net, init).
    stocks = {}       # norm -> {'net': terms, 'init': text}
    for lhs, rhs, units, comment in model_eqs:
        if isinstance(rhs, tuple) or norm(lhs) not in names:
            continue
        m = re.match(r'^INTEG\s*\((.*)\)\s*$', rhs, re.S | re.I)
        if m:
            inner = m.group(1)
            depth, cut = 0, None
            for i, ch in enumerate(inner):
                if ch == '(':
                    depth += 1
                elif ch == ')':
                    depth -= 1
                elif ch == ',' and depth == 0:
                    cut = i
            stocks[norm(lhs)] = {'net': inner[:cut].strip(), 'init': inner[cut + 1:].strip()}

    # Each stock's net inflow, as signed flow names. A net inflow that is not
    # a plain sum of names — `(+growth-catch)*limit 1+new state 1` — becomes
    # ONE flow, `<stock>_change`, of that rate; the names in it stay
    # variables.
    inflow, outflow = {}, {}     # flow norm -> stock norm
    net_flows = {}               # flow norm -> (stock norm, expression)
    for s, st in stocks.items():
        terms = re.findall(r'^\s*([-+]?)\s*([^-+()*/]+?)\s*(?=[-+]|$)', st['net']) and \
            re.findall(r'([-+]?)\s*([^-+]+)', st['net'])
        # Plain: a sum of names none of which is itself a stock (a stock made
        # from a DELAY1I can be another stock's inflow).
        plain = not re.search(r'[()*/]', st['net']) and all(
            norm(t) in names and norm(t) not in stocks for _, t in terms if norm(t))
        if plain:
            for sign, term in terms:
                k = norm(term)
                if k:
                    (outflow if sign == '-' else inflow).setdefault(k, []).append(s)
        else:
            k = norm(names[s] + ' change')
            names[k] = label_of(names[s] + '_change')
            net_flows[k] = (s, st['net'])
            inflow.setdefault(k, []).append(s)
    flows = set(inflow) | set(outflow)

    # The sketch.
    recs = sketch_records(sketch)
    pos, kind_at, valve_name = {}, {}, {}
    by_name = {}
    title = None
    prev_valve = None
    for f, pts in recs:
        t = f[0]
        if t == '10' and len(f) > 6:
            sid, nm = f[1], f[2]
            pos[sid] = (float(f[3]), float(f[4]))
            if prev_valve is not None:
                valve_name[prev_valve] = norm(nm)
                prev_valve = None
            k = norm(nm)
            if k not in by_name:
                by_name[k] = sid
            kind_at[sid] = 'var'
        elif t == '11':
            pos[f[1]] = (float(f[3]), float(f[4]))
            kind_at[f[1]] = 'valve'
            prev_valve = f[1]
            continue
        elif t == '12':
            pos[f[1]] = (float(f[3]), float(f[4]))
            kind_at[f[1]] = 'cloud' if f[2] == '48' else 'comment'
            if f[2] != '48' and title is None:
                title = 'next'
        elif title == 'next' and not re.match(r'^\d', t):
            pass
        prev_valve = None if t != '10' else prev_valve
    # A comment box's text is on the line after its record.
    lines = sketch.split('\n')
    for i, line in enumerate(lines):
        if line.startswith('12,') and not line.split(',')[2] == '48' and i + 1 < len(lines):
            if not re.match(r'^\d+,', lines[i + 1]) and lines[i + 1].strip():
                title = lines[i + 1].strip()
                break
    if title == 'next':
        title = None

    pipes = {}        # valve id -> {'src': id, 'dst': id, 'src_pts': [...], 'dst_pts': [...]}
    arrows = []       # (from id, to id, point)
    for f, pts in recs:
        if f[0] != '1':
            continue
        a, b, flag = f[2], f[3], f[4]
        p = re.findall(r'\((-?[\d.]+),(-?[\d.]+)\)', pts)
        if kind_at.get(a) == 'valve' and flag in ('4', '100'):
            end = 'dst' if flag == '4' else 'src'
            pipes.setdefault(a, {})[end] = b
            pipes[a][end + '_pts'] = [(float(x), float(y)) for x, y in p]
        else:
            arrows.append((a, b, (float(p[0][0]), float(p[0][1])) if p else None))

    # ---- build the spec
    nodes, arcs, layout = {}, {}, {'labels': {}, 'arcs': {}}
    nid = [0]
    aid = [0]
    ids = {}          # norm -> node id

    def node(**n):
        nid[0] += 1
        i = 'node%d' % nid[0]
        nodes[i] = dict({'parent': None, 'props': {}}, **n)
        return i

    def place(i, sid):
        if sid in pos:
            x, y = pos[sid]
            layout[i] = {'x': round(x * SCALE, 1), 'y': round(y * SCALE, 1)}

    def arc(**a):
        aid[0] += 1
        i = 'arc%d' % aid[0]
        arcs[i] = dict({'props': {}}, **a)
        return i

    units_of = {}
    for lhs, rhs, units, comment in model_eqs:
        k = norm(lhs)
        if isinstance(rhs, tuple) or k not in names:
            continue
        units_of[k] = units
        if k in stocks:
            continue
        if k in flows:
            continue
        ids[k] = node(type='variable', label=names[k], props={'value': '', 'units': ''})
        place(ids[k], by_name.get(k))
    for k in stocks:
        ids[k] = node(type='stock', label=names[k], props={'initial': '', 'units': ''})
        place(ids[k], by_name.get(k))

    # Flows: a valve, its two ends.
    unplaced_clouds = []     # (cloud, its stock, 'src'|'dst'): placed with the stock, below
    for k in sorted(flows):
        srcs, dsts = outflow.get(k, []), inflow.get(k, [])
        if len(srcs) > 1 or len(dsts) > 1:
            warn('flow %s leaves or enters more than one stock' % k)
        valve_sid = next((v for v, n in valve_name.items() if n == k), None)
        pipe = pipes.get(valve_sid, {})

        def end(stock_list, which):
            if stock_list:
                return ids[stock_list[0]]
            c = node(type='cloud', label='')
            sid = pipe.get(which)
            if sid in pos:
                place(c, sid)
            else:
                other = layout.get(ids[(dsts or srcs)[0]])
                if valve_sid in pos:
                    ox, oy = pos[valve_sid][0] * SCALE, pos[valve_sid][1] * SCALE
                elif other:
                    ox, oy = other['x'], other['y']
                else:
                    unplaced_clouds.append((c, ids[(dsts or srcs)[0]], which))
                    return c
                layout[c] = {'x': ox + (-150 if which == 'src' else 150), 'y': oy}
            return c
        a_end = end(srcs, 'src')
        z_end = end(dsts, 'dst')
        v = node(type='valve', label=names[k], props={'rate': '', 'units': ''})
        ids[k] = v
        fa = arc(type='flow', **{'from': a_end, 'to': z_end, 'valve': v})
        # Its bends: the corners of Vensim's two pipes, source to end.
        if valve_sid in pos and (pipe.get('src_pts') or pipe.get('dst_pts')):
            ax, ay = layout[a_end]['x'] / SCALE, layout[a_end]['y'] / SCALE
            zx, zy = layout[z_end]['x'] / SCALE, layout[z_end]['y'] / SCALE
            route = [(ax, ay)] + list(reversed(pipe.get('src_pts', []))) + [pos[valve_sid]] \
                + pipe.get('dst_pts', []) + [(zx, zy)]
            corners = bends_of(route)
            if corners:
                layout['arcs'][fa] = {'points': [{'x': round(x * SCALE, 1), 'y': round(y * SCALE, 1)}
                                                 for x, y in corners]}

    # Equations, and the influences they need.
    curve = {}
    for a, b, p in arrows:
        ka = next((n for n, s in by_name.items() if s == a), None) or valve_name.get(a)
        kb = next((n for n, s in by_name.items() if s == b), None) or valve_name.get(b)
        if ka and kb and p:
            curve[(ka, kb)] = (pos.get(a) or pos.get(b), pos.get(b), p)
    todo = [(l, r, u, c) for l, r, u, c in model_eqs] + \
        [(names[k], net, '', '') for k, (st, net) in net_flows.items()]
    for lhs, rhs, units, comment in todo:
        k = norm(lhs)
        if isinstance(rhs, tuple) or k not in ids:
            continue
        text = stocks[k]['init'] if k in stocks else rhs
        X.initial = k in stocks            # a starting value: ACTIVE INITIAL's initial
        try:
            out, used = X.convert(text)
        except ValueError as e:
            warn('%s: %s  [%s]' % (lhs, e, text[:80]))
            out, used = '', set()
        n = nodes[ids[k]]
        field = 'initial' if k in stocks else ('rate' if k in flows else 'value')
        n['props'][field] = out
        for u in sorted(used):
            if u not in ids:
                continue
            i = arc(type='influence', **{'from': ids[u], 'to': ids[k], 'alias': names[u]})
            c = curve.get((u, k))
            if c and c[0] and c[1]:
                layout['arcs'][i] = {'bow': round(bow_through(c[0], c[1], c[2]), 3)}

    # What the sketch does not draw (Pensions4 keeps a whole second copy of
    # its model off the diagram): set out in a block to the right of what it
    # does, stocks first, each such stock's clouds either side of it.
    placed = [g for i, g in layout.items() if i.startswith('node') and isinstance(g, dict)]
    if placed:
        x0 = max(g['x'] for g in placed) + 200
        y0 = min(g['y'] for g in placed)
    else:
        x0 = y0 = 100
    # A delay's or smoothing's stocks, from what they are placed from (which
    # may itself be one of them: a stage from its last stock).
    # A valve has no place of its own (the app puts it halfway along its
    # flow): there, from its flow's ends.
    def at(i):
        if i in layout:
            return layout[i]
        f = next((x for x in arcs.values() if x.get('type') == 'flow' and x.get('valve') == i), None)
        if f and f['from'] in layout and f['to'] in layout:
            p, q = layout[f['from']], layout[f['to']]
            return {'x': (p['x'] + q['x']) / 2, 'y': (p['y'] + q['y']) / 2}
        return None
    more = True
    while more:
        more = False
        for k2, (main, dx, dy) in stage_of.items():
            g = at(ids[main]) if main in ids else None
            if k2 in ids and ids[k2] not in layout and g:
                layout[ids[k2]] = {'x': g['x'] + dx, 'y': g['y'] + dy}
                more = True
    # A stock's cloud far enough off that its valve's name (halfway) clears
    # the stock's.
    for c, st, which in list(unplaced_clouds):
        if st in layout:
            g = layout[st]
            layout[c] = {'x': g['x'] + (-150 if which == 'src' else 150), 'y': g['y']}
            unplaced_clouds.remove((c, st, which))
    loose = [i for i, n in nodes.items() if i not in layout and n['type'] in ('stock', 'variable')]
    loose.sort(key=lambda i: (nodes[i]['type'] != 'stock', nodes[i]['label']))
    for j, i in enumerate(loose):
        layout[i] = {'x': x0 + (j % 4) * 400, 'y': y0 + (j // 4) * 110}
    for c, st, which in unplaced_clouds:
        g = layout.get(st, {'x': x0, 'y': y0})
        layout[c] = {'x': g['x'] + (-150 if which == 'src' else 150), 'y': g['y']}

    # Presentation: the book's graphs, the run.
    displays = []
    for g in re.split(r'\n:GRAPH', after)[1:]:
        vs = [norm(v) for v in re.findall(r'\n:VAR (.+)', g)]
        got = []
        for v in vs:
            if v in ids and ids[v] not in got:
                got.append(ids[v])
        if got:
            displays.append({'widget': 'plotter', 'variables': got})
    # A log interval a whole number of time steps: logging between steps
    # makes the engine take a short step to reach the log time, which
    # changes the run (EZ107 drifted by 1 in 10,000). A long run at a small
    # step logs every so many steps, about 400 points.
    log_each = save
    if (t1 - t0) / max(save, 1e-9) > 1000:
        log_each = (t1 - t0) / 400
    steps_per_log = max(1, int(math.ceil(round(log_each / dt, 9))))
    log_each = float('%.12g' % (steps_per_log * dt))
    pres = {'run': {'startTime': t0, 'runLength': t1 - t0, 'logEach': log_each, 'timeStep': '%g' % dt}}
    if not t0:
        del pres['run']['startTime']
    if displays:
        pres['displays'] = displays

    unit_lines = ['%s: %s' % (names[k], u) for k, u in units_of.items() if u and k in ids]
    comment = ('Converted from the Vensim model %s.\n\nUnits:\n' % path.split('/')[-1]
               + '\n'.join(unit_lines))
    spec = {
        'id': label_of(path.split('/')[-1].rsplit('.', 1)[0]).lower(),
        'name': title or path.split('/')[-1].rsplit('.', 1)[0],
        'format': 3, 'schema': 'simile-v1',
        'metadata': {'title': title or path.split('/')[-1].rsplit('.', 1)[0]},
        'props': {'comment': comment},
        'presentation': pres,
        'enums': {}, 'submodels': {}, 'nodes': nodes, 'arcs': arcs, 'layout': layout,
    }
    if not layout['labels']:
        del layout['labels']
    return spec


if __name__ == '__main__':
    args = sys.argv[1:]
    out = None
    if '-o' in args:
        out = args[args.index('-o') + 1]
        args = args[:args.index('-o')]
    spec = convert(args[0])
    text = json.dumps(spec, indent=1, ensure_ascii=False)
    if out:
        open(out, 'w').write(text)
    else:
        print(text)
    for p in problems:
        print('NOT CONVERTED: ' + p, file=sys.stderr)
    sys.exit(1 if problems else 0)
