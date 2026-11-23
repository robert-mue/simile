"""Build Simile model specs (.json) from Python, for converting models written
in other languages (TrueBASIC, Vensim, papers' equations) without drawing
them by hand.

    from simile_build import Model
    m = Model('logistic', 'Logistic growth')
    N = m.stock('N', '10', at=(300, 200))
    m.flow('growth', 'r*N*(1-N/K)', into=N)
    m.param('r', 0.5, 0, 3, at=(200, 100))
    m.param('K', 1000, 100, 5000, at=(300, 100))
    m.run(runLength=50, logEach=1, timeStep='1')
    m.plot(N); m.sliders()
    m.write('logistic.json')

Influences are not listed: `write` draws one wherever an equation uses
another element's name: within a submodel, in from an enclosing one (a plain
name), out of a submodel (written `[x]` or `{x}` in the equation), and across
an association (`x_role` in, `{x_role}` out), as the model file reference
(help/model-file-reference.md) says Simile wants them. A flow's cloud is
placed beside its stock unless given. Every `units` is "" (the reference,
section 11).
"""
import json, re

KEYWORDS = {'if', 'then', 'else', 'elseif', 'and', 'or', 'xor', 'not', 'is', 'true', 'false'}


class Model:
    def __init__(self, id, name):
        self.id, self.name = id, name
        self.nodes, self.arcs, self.subs = {}, {}, {}
        self.layout = {'arcs': {}}
        self.props, self.metadata, self.presentation = {}, {}, {}
        self._clouds = {}          # stock id -> number of clouds placed each side

    # ---- elements -------------------------------------------------------------

    def _node(self, typ, label, at, parent, **props):
        i = 'node%d' % (len(self.nodes) + 1)
        if typ in ('stock', 'valve', 'variable'):
            props.setdefault('units', '')
        self.nodes[i] = {'type': typ, 'parent': parent, 'label': label,
                         'props': {k: str(v) for k, v in props.items() if v is not None}}
        if at:
            self.layout[i] = {'x': at[0], 'y': at[1]}
        return i

    def submodel(self, label, kind='single', dims=None, parent=None, at=(300, 300, 300, 200)):
        """kind: 'single', 'fixed-membership' (dims '5', or an enumerated type) or 'population'."""
        i = 'submodel%d' % (len(self.subs) + 1)
        self.subs[i] = {'kind': kind, 'parent': parent, 'label': label,
                        'props': {'dimensions': str(dims)} if dims else {}}
        self.layout[i] = dict(zip('xywh', at))
        return i

    def stock(self, label, initial, at, parent=None):
        return self._node('stock', label, at, parent, initial=initial)

    def var(self, label, value, at, parent=None, units=''):
        """A variable. `units` stays "" except for an array a submodel's values
        make, which Simile must be told the size of: 'array(1,5)'."""
        return self._node('variable', label, at, parent, value=value, units=units)

    def param(self, label, value, lo=None, hi=None, at=None, parent=None, kind='variable'):
        """A parameter: with lo and hi, a slider."""
        return self._node('variable', label, at, parent, paramKind=kind, value=value,
                          min=lo, max=hi)

    def condition(self, label, expr, at, parent):
        return self._node('condition', label, at, parent, expr=expr)

    def creation(self, label, expr, at, parent):
        return self._node('initialiser', label, at, parent, expr=expr)

    def immigration(self, label, expr, at, parent):
        return self._node('migrator', label, at, parent, expr=expr)

    def reproduction(self, label, expr, at, parent):
        return self._node('reproduction', label, at, parent, expr=expr)

    def loss(self, label, expr, at, parent):
        return self._node('exterminator', label, at, parent, expr=expr)

    def flow(self, label, rate, into=None, out_of=None, cloud_at=None):
        """A flow into a stock, out of one, or between two (`out_of` to `into`).
        A missing end is a cloud, beside the stock unless `cloud_at` says where."""
        stock = into or out_of
        parent = self.nodes[stock]['parent']
        v = self._node('valve', label, None, parent, rate=rate)
        ends = []
        s = self.layout[stock]
        for end, side in ((out_of, 'source'), (into, 'end')):
            if end:
                ends.append(end)
                continue
            # A cloud: an inflow's source to the left of its stock, an outflow's
            # end to the right, a second one on a side below the first.
            n = self._clouds.get((stock, side), 0)
            self._clouds[(stock, side)] = n + 1
            where = cloud_at or (s['x'] + (-130 if side == 'source' else 130), s['y'] + 45 * n)
            ends.append(self._node('cloud', '', where, parent))
        self._arc('flow', **{'from': ends[0], 'to': ends[1], 'valve': v})
        return v

    def role(self, base, association, label):
        return self._arc('role', **{'from': base, 'to': association, 'label': label})

    def _arc(self, typ, **a):
        i = 'arc%d' % (len(self.arcs) + 1)
        self.arcs[i] = dict({'type': typ, 'props': {}}, **a)
        return i

    # ---- run settings, displays, about --------------------------------------------

    def run(self, **settings):
        self.presentation['run'] = {k: (str(v) if k == 'timeStep' else v) for k, v in settings.items()}

    def plot(self, *nodes):
        self.presentation.setdefault('displays', []).append({'widget': 'plotter', 'variables': list(nodes)})

    def sliders(self):
        self.presentation.setdefault('displays', []).append({'widget': 'sliders'})

    def about(self, title, description, keywords, paper=None, page=None, family=None):
        self.metadata = {'title': title, 'description': description, 'keywords': keywords}
        if page:
            self.metadata['page'] = page
        if paper:
            self.metadata['paper'] = paper
        if family:
            self.metadata['family'] = family

    # ---- influences, from the equations ------------------------------------------

    def _ancestors(self, sub):
        out = []
        while sub:
            out.append(sub)
            sub = self.subs[sub]['parent']
        return out

    def _field(self, n):
        return {'stock': 'initial', 'valve': 'rate', 'variable': 'value'}.get(n['type'], 'expr')

    def _wire(self):
        roles = {a['label']: a for a in self.arcs.values() if a['type'] == 'role'}
        have = {(a['from'], a['to']) for a in self.arcs.values() if a['type'] == 'influence'}
        for dst, n in list(self.nodes.items()):
            text = n['props'].get(self._field(n), '')
            if not text or n['type'] == 'cloud':
                continue
            text = re.sub(r'"[^"]*"', '', text)
            names = {m.group(1) for m in re.finditer(r'([A-Za-z_][A-Za-z0-9_]*)\s*(\()?', text)
                     if not m.group(2) and m.group(1).lower() not in KEYWORDS}
            up = self._ancestors(n['parent'])
            for name in sorted(names):
                src = self._resolve(name, n['parent'], up, roles)
                if src is None:
                    raise ValueError('%s: "%s" is not an element it can see' % (n['label'], name))
                if src != dst and (src, dst) not in have:
                    self._arc('influence', **{'from': src, 'to': dst, 'alias': self.nodes[src]['label']})
                    have.add((src, dst))

    def _resolve(self, name, here, up, roles):
        labelled = [(k, v) for k, v in self.nodes.items() if v['label'] == name]
        # the same submodel, then those enclosing it, out to the top level
        for scope in (up + [None] if here else [None]):
            for k, v in labelled:
                if v['parent'] == scope:
                    return k
        # out of a submodel inside this one (written [x] or {x} in the equation)
        for k, v in labelled:
            if v['parent'] and (here is None or here in self._ancestors(v['parent'])[1:]):
                return k
        # across an association: x_role, from a submodel taking part
        for role, a in roles.items():
            if name.endswith('_' + role):
                base = name[:-len(role) - 1]
                for k, v in self.nodes.items():
                    if v['label'] == base and v['parent'] == a['from'] and here != a['from']:
                        return k              # into the association, from a base
                    if v['label'] == base and v['parent'] == a['to'] and here == a['from']:
                        return k              # out of the association, into a base
        return None

    # ---- out ---------------------------------------------------------------------

    def spec(self):
        self._wire()
        out = {'format': 3, 'schema': 'simile-v1', 'id': self.id, 'name': self.name, 'enums': {},
               'nodes': self.nodes, 'arcs': self.arcs, 'submodels': self.subs, 'layout': self.layout}
        if self.props:
            out['props'] = self.props
        if self.metadata:
            out['metadata'] = self.metadata
        if self.presentation:
            out['presentation'] = self.presentation
        return out

    def write(self, path):
        with open(path, 'w') as fh:
            json.dump(self.spec(), fh, indent=1)
        return path
