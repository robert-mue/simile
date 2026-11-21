#!/usr/bin/env python3
"""The coral acclimation model of Raharinirina, Acevedo-Trejos & Merico (2022),
"Modelling the acclimation capacity of coral reefs to a warming ocean", PLoS
Comput Biol 18(5): e1010099, as a Simile model spec, and a parameter file per
region and RCP scenario (the authors' monthly sea-surface temperatures).

    git clone https://github.com/systemsecologygroup/CoralZooxProjection their-code
    python3 make_coral.py <out folder> their-code

Writes coral.json and coral-<GBR|SEA|CAR>-<RCP26|RCP45|RCP85>.parameters.json.
Every equation is the paper's, checked against their Model_RCP_ode_monthly.py;
README.md says how it was checked, what differs, and why.
"""
import csv, io, json, math, os, sys, zipfile

OUT, REPO = sys.argv[1], sys.argv[2]
SST_ZIP = zipfile.ZipFile(os.path.join(REPO, 'Monthly-SST-scenarios-csv.zip'))


def series(kind, reg, rcp):
    """One of their CSV files: a number per line, January 1955 to December 2100."""
    text = SST_ZIP.read('Monthly-SST-scenarios-csv/%s-%s-%s-MPI.csv' % (kind, reg, rcp)).decode()
    return [float(x) for row in csv.reader(io.StringIO(text)) for x in row if x.strip()]


# Per region, as their code computes them: the skew-normal growth curve's
# maximum and its optimum T_opt, on their grid of 1500 temperatures from 0 to
# 75 degrees C; the spin-up's temperature, the mean of the data to December 2000.
pdf_ = lambda z: math.exp(-z * z / 2) / math.sqrt(2 * math.pi)
cdf_ = lambda z: 0.5 * (1 + math.erf(z / math.sqrt(2)))
SHAPE = {'GBR': (26.78, 1.0, 0.0002), 'SEA': (28.13, 0.81, 3.82), 'CAR': (27.10, 0.89, 1.06)}
GRID = [75 * i / 1499 for i in range(1500)]
CONSTS = {}
for reg, (T0, rho, sk) in SHAPE.items():
    vals = [pdf_((T - T0) / rho) * cdf_(sk * (T - T0) / rho) for T in GRID]
    m = max(vals)
    for rcp in ('RCP26', 'RCP45', 'RCP85'):
        sst, months = series('SST', reg, rcp), series('Months', reg, rcp)
        spin = [t for t, y in zip(sst, months) if y <= 2000 + 11 / 12]
        CONSTS[reg + '-' + rcp] = {'G_norm_max': m, 'T_opt': GRID[vals.index(m)], 'T_spinup': sum(spin) / len(spin)}

nodes, arcs, layout = {}, {}, {'arcs': {}}

def node(typ, label, at, **props):
    i = 'node%d' % (len(nodes) + 1)
    if typ in ('stock', 'valve', 'variable'):
        props.setdefault('units', '')
    nodes[i] = {'type': typ, 'parent': None, 'label': label, 'props': {k: str(v) for k, v in props.items()}}
    if at:
        layout[i] = {'x': at[0], 'y': at[1]}
    return i

def arc(typ, **a):
    i = 'arc%d' % (len(arcs) + 1)
    arcs[i] = dict({'type': typ, 'props': {}}, **a)
    return i

def flow(frm, to, valve):
    return arc('flow', **{'from': frm, 'to': to, 'valve': valve})

def uses(target, *sources):
    for s in sources:
        arc('influence', **{'from': s, 'to': target, 'alias': nodes[s]['label']})

const = lambda label, v, at: node('variable', label, at, value=v)
# Region parameters: VARIABLE parameters (read every step), not fixed ones,
# while a fixed parameter with a default ignores a parameter file loaded
# after the model (tools/engine/README.md fault 7, open).
fixed = lambda label, v, at: node('variable', label, at, paramKind='variable', value=v)

# ---- constants, the same in every region (Table 1; their code's values)
G_max = const('G_max', '0.8333333333333334', (60, 40))       # 10/12 per month
a = const('a', '0.08973333333333333', (900, 560))             # 1.0768/12
b = const('b', '0.0633', (980, 560))
alpha = const('alpha', '0.001', (520, 40))
M_C = const('M_C', '0.0008333333333333334', (620, 40))
Ksmax = const('Ksmax', '3000000', (1060, 640))
beta = const('beta', '1200', (420, 300))
gammaH = const('gammaH', '1000000', (260, 330))
r = const('r', '12000', (520, 300))
tiny = const('tiny', '0.01', (720, 640))       # their `error`: keeps denominators off 0

# ---- per region: fixed parameters, from the region's parameter file (GBR here)
c = CONSTS['GBR-RCP26']
K_C = fixed('K_C', '4387189023360000.0', (820, 40))
T_bar = fixed('T_bar', '26.78', (60, 120))
sigma = fixed('sigma', '1.0', (60, 180))
skew = fixed('skew', '0.0002', (60, 240))
G_norm_max = fixed('G_norm_max', repr(c['G_norm_max']), (60, 300))
T_opt = fixed('T_opt', repr(c['T_opt']), (1180, 360))
N = fixed('N', '5.54e-13', (620, 220))
T_spinup = fixed('T_spinup', repr(c['T_spinup']), (160, 640))
tier1 = fixed('tier1', '2', (1180, 420))
tier2 = fixed('tier2', '4', (1180, 470))
tier3 = fixed('tier3', '99', (1180, 520))
keep1 = fixed('keep1', '0.9', (1260, 420))
keep2 = fixed('keep2', '0.4', (1260, 470))
keep3 = fixed('keep3', '0.4', (1260, 520))

# ---- temperature: the spin-up's constant, then the monthly data from 1955
T_data = node('variable', 'T_data', (60, 640), paramKind='variable', value=repr(c['T_spinup']))
T = node('variable', 'T', (160, 560), value='if time()<0 then T_spinup else T_data')
uses(T, T_spinup, T_data)

# The temperature-limited coral growth rate (Eqs 7-8): a skew-normal, its
# normal CDF by Abramowitz & Stegun 7.1.26 (Simile has no erf; error < 1.5e-7).
z = node('variable', 'z', (160, 150), value='(T-T_bar)/sigma')
uses(z, T, T_bar, sigma)
pdf = node('variable', 'pdf', (250, 110), value='exp(-0.5*z*z)/sqrt(2*pi())')
uses(pdf, z)
w = node('variable', 'w', (250, 190), value='abs(skew*z)/sqrt(2)')
uses(w, skew, z)
tt = node('variable', 'tt', (330, 230), value='1/(1+0.3275911*w)')
uses(tt, w)
erf_w = node('variable', 'erf_w', (330, 170),
             value='1-(0.254829592*tt-0.284496736*tt^2+1.421413741*tt^3-1.453152027*tt^4'
                   '+1.061405429*tt^5)*exp(-(w*w))')
uses(erf_w, tt, w)
cdf = node('variable', 'cdf', (410, 150), value='0.5*(1+sgn(skew*z)*erf_w)')
uses(cdf, skew, z, erf_w)
G_C = node('variable', 'G_C', (360, 80), value='G_max*pdf*cdf/G_norm_max')
uses(G_C, G_max, pdf, cdf, G_norm_max)

# ---- the three state variables
coral = node('stock', 'Coral', (700, 150), initial='0.75*K_C')
uses(coral, K_C)
trait = node('stock', 'Trait', (700, 360), initial='0.0000005')
symb = node('stock', 'Symbiont', (700, 560), initial='0.001')
c1 = node('cloud', '', (560, 150))
c2 = node('cloud', '', (560, 360))
c3 = node('cloud', '', (560, 560))
c4 = node('cloud', '', (840, 560))

K_S = node('variable', 'K_S', (900, 640), value='Ksmax*Coral')
uses(K_S, Ksmax, coral)
kappa = node('variable', 'kappa', (420, 380), value='Symbiont/(gammaH*Coral+Symbiont+tiny)')
uses(kappa, symb, gammaH, coral, tiny)
E = node('variable', 'E', (470, 230), value='1-exp(-beta*Trait)')
uses(E, beta, trait)
cost = node('variable', 'cost', (820, 300), value='Symbiont/(K_S+tiny)')
uses(cost, symb, K_S, tiny)
fitness = node('variable', 'fitness', (560, 80),
               value='G_C*kappa*E*(1-Coral/K_C)-alpha*exp(r*Trait)*cost-M_C')
uses(fitness, G_C, kappa, E, coral, K_C, alpha, r, trait, cost, M_C)
coral_change = node('valve', 'coral_change', None, rate='fitness*Coral')
flow(c1, coral, coral_change)
uses(coral_change, fitness, coral)

gradient = node('variable', 'gradient', (560, 290),
                value='G_C*beta*kappa*(1-Coral/K_C)*exp(-beta*Trait)-r*alpha*cost*exp(r*Trait)')
uses(gradient, G_C, beta, kappa, coral, K_C, trait, r, alpha, cost)
acclimation = node('valve', 'acclimation', None, rate='N*gradient')
flow(c2, trait, acclimation)
uses(acclimation, N, gradient)

G_S = node('variable', 'G_S', (940, 500), value='a*exp(b*T)')
uses(G_S, a, b, T)
symbiont_growth = node('valve', 'symbiont_growth', None, rate='G_S*(1-Symbiont/(K_S+tiny))*Symbiont')
flow(c3, symb, symbiont_growth)
uses(symbiont_growth, G_S, symb, K_S, tiny)

# Bleaching (Eq 11), as their code does it: at the start of each month, if
# T is far enough above T_opt, the symbionts are cut to a random fraction,
# kept between 5% and the tier's maximum. In Simile: a flow taking the rest
# in one time step.
excess = node('variable', 'excess', (1060, 360), value='T-T_opt')
uses(excess, T, T_opt)
keep_max = node('variable', 'keep_max', (1060, 440),
                value='if excess>=tier3 then keep3 elseif excess>=tier2 then keep2 '
                      'elseif excess>=tier1 then keep1 else 1.0')
uses(keep_max, excess, tier1, tier2, tier3, keep1, keep2, keep3)
month_start = node('variable', 'month_start', (1200, 600), value='abs(time()-round(time()))<dt()/2')
kept = node('variable', 'kept', (980, 470),
            value='if month_start and keep_max<1.0 then rand_var(0.05,keep_max) else 1.0')
uses(kept, month_start, keep_max)
bleaching = node('valve', 'bleaching', None, rate='(1-kept)*Symbiont/dt()')
flow(symb, c4, bleaching)
uses(bleaching, kept, symb)

# ---- what is plotted
coral_cover = node('variable', 'coral_cover', (840, 100), value='100*Coral/K_C')
uses(coral_cover, coral, K_C)
symbionts_per_cm2 = node('variable', 'symbionts_per_cm2', (840, 620), value='Symbiont/(Coral+tiny)')
uses(symbionts_per_cm2, symb, coral, tiny)

spec = {
    'format': 3, 'schema': 'simile-v1', 'id': 'coral_acclimation', 'name': 'Coral acclimation',
    'enums': {}, 'nodes': nodes, 'arcs': arcs, 'submodels': {}, 'layout': layout,
    'props': {'comment': ''},
    'metadata': {
        'title': 'Acclimation capacity of coral reefs to a warming ocean',
        'description': 'A trait-based model of a coral community (Coral, cm2), its symbiotic algae '
                       '(Symbiont, cells) and the energy corals invest in the symbiosis (Trait), which '
                       'moves up the gradient of coral fitness at the speed of acclimation N. Forced by '
                       'monthly sea-surface temperature 1955-2100 after a 2000-year spin-up; symbionts '
                       'are expelled (bleaching) when the temperature exceeds the optimum for coral '
                       'growth by a regional threshold. Time is in months; time 0 is January 1955. '
                       'One region and RCP scenario at a time, from a parameter file.',
        'keywords': ['coral', 'bleaching', 'acclimation', 'climate change', 'trait-based'],
        'paper': {'citation': 'Raharinirina NA, Acevedo-Trejos E, Merico A (2022) Modelling the '
                              'acclimation capacity of coral reefs to a warming ocean. PLoS Comput '
                              'Biol 18(5): e1010099.',
                  'url': 'https://doi.org/10.1371/journal.pcbi.1010099'},
    },
    'presentation': {
        'run': {'startTime': -24012, 'runLength': 25764, 'logEach': 1, 'timeStep': '0.125'},
        'displays': [
            {'widget': 'plotter', 'variables': [coral_cover]},
            {'widget': 'plotter', 'variables': [trait]},
            {'widget': 'plotter', 'variables': [symbionts_per_cm2]},
            {'widget': 'plotter', 'variables': [T]},
        ],
    },
}
os.makedirs(OUT, exist_ok=True)
json.dump(spec, open(os.path.join(OUT, 'coral.json'), 'w'), indent=1)

# ---- a parameter file per region and scenario
REG = {
    'GBR': dict(K_C=438718.902336e10, T_bar=26.78, sigma=1.0, skew=0.0002, N=0.0554e-11,
                tier1=2, tier2=4, tier3=99, keep1=0.9, keep2=0.4, keep3=0.4),
    'SEA': dict(K_C=1191704.68901e10, T_bar=28.13, sigma=0.81, skew=3.82, N=0.0265e-11,
                tier1=1, tier2=99, tier3=99, keep1=0.75, keep2=0.75, keep3=0.75),
    'CAR': dict(K_C=190374.697987e10, T_bar=27.10, sigma=0.89, skew=1.06, N=0.02375e-11,
                tier1=1, tier2=3, tier3=6, keep1=0.85, keep2=0.65, keep3=0.2),
}
for reg, p in REG.items():
    for rcp in ('RCP26', 'RCP45', 'RCP85'):
        c = CONSTS[reg + '-' + rcp]
        sst = series('SST', reg, rcp)
        v = dict(p, G_norm_max=c['G_norm_max'], T_opt=c['T_opt'], T_spinup=c['T_spinup'])
        v['T_data'] = [round(t, 6) for t in sst]           # months 0, 1, 2, ... from January 1955
        json.dump({'variables': v, 'fill': {'T_data': 'use_last'}},
                  open(os.path.join(OUT, 'coral-%s-%s.parameters.json' % (reg, rcp)), 'w'))
print('%d nodes, %d arcs; 9 parameter files -> %s' % (len(nodes), len(arcs), OUT))
