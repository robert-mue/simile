"""Run Simile models from Python, and get their results as pandas tables.

A PROTOTYPE (2026-11-21), for notebooks: the model runs in Simile's own
engine, the one in the web app, inside a hidden Chrome driven over its
debugging port. So it needs this repository and Google Chrome on the same
machine; it does not yet work in a notebook somewhere else (that would be the
app's engine as a notebook widget, or a Python package compiling models
natively). What it shows is the workflow: the model is a Simile diagram, and
everything done WITH it — many runs, calibration, sensitivity, plots — is
ordinary Python.

    from simile_run import Session
    with Session('coral.json', parameters='coral-GBR-RCP26.parameters.json') as s:
        df = s.run({'N': 5.54e-13}, variables=['coral_cover', 'Trait'])
        df.plot()

A session compiles the model once (a few seconds; the same model compiled
before is remembered by the browser) and then runs it as often as asked, each
run with other parameter values: about a second for 2000 simulated years.
A run that does not finish within `time_limit` seconds is stopped, its page
closed, and SimileError raised; the session also closes, on `close()`, at the
end of a `with`, or when Python exits, the Chrome and web server it started.
"""
import atexit, base64, copy, json, os, shutil, socket, subprocess, sys, tempfile, time, urllib.request

import pandas as pd
from websockets.sync.client import connect

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
REF = 'models/notebook'


class SimileError(RuntimeError):
    pass


def _listening(port):
    with socket.socket() as s:
        s.settimeout(0.5)
        return s.connect_ex(('127.0.0.1', port)) == 0


def _wait_for(port, what, seconds=20):
    for _ in range(seconds * 4):
        if _listening(port):
            return
        time.sleep(0.25)
    raise SimileError('could not start %s (nothing answers on port %d)' % (what, port))


def _chrome():
    for c in ('/opt/google/chrome/chrome', 'google-chrome', 'google-chrome-stable', 'chromium', 'chromium-browser'):
        p = c if os.path.isabs(c) and os.path.exists(c) else shutil.which(c)
        if p:
            return p
    raise SimileError('Google Chrome was not found')


def _load(x):
    """A model spec or parameter file: a dict, or the path of a JSON file."""
    if x is None or isinstance(x, dict):
        return copy.deepcopy(x)
    with open(os.path.expanduser(x)) as fh:
        return json.load(fh)


def equations(model):
    """A model's equations, as Simile holds them, as Markdown tables: its
    stocks (each with its starting value and the flows that change it), flows,
    variables, and parameters. For a notebook: `Markdown(equations(spec))`."""
    spec = _load(model)
    nodes, arcs, subs = spec.get('nodes', {}), spec.get('arcs', {}), spec.get('submodels', {})

    def where(n):
        path, p = [], n.get('parent')
        while p and p in subs:
            path.insert(0, subs[p].get('label') or p)
            p = subs[p].get('parent')
        return '/'.join(path)

    def cell(text):
        return '`' + str(text).replace('|', '\\|').replace('`', "'") + '`' if str(text).strip() else ''

    kind = lambda n: (n.get('props') or {}).get('paramKind') or ''
    any_sub = any(where(n) for n in nodes.values())
    col = (lambda n: ' | ' + (where(n) or 'top level')) if any_sub else (lambda n: '')
    head = (lambda *h: '| ' + ' | '.join(h + (('In',) if any_sub else ())) + ' |\n|' + '---|' * (len(h) + any_sub) + '\n')
    flows = [a for a in arcs.values() if a.get('type') == 'flow']
    out = []
    stocks = [n for n in nodes.values() if n['type'] == 'stock']
    if stocks:
        out.append('**Stocks**\n\n' + head('Stock', 'Starting value', 'Changed by'))
        for n in stocks:
            sid = next(k for k, v in nodes.items() if v is n)
            terms = ['+ ' + nodes[a['valve']]['label'] for a in flows if a['to'] == sid] + \
                    ['− ' + nodes[a['valve']]['label'] for a in flows if a['from'] == sid]
            out.append('| **%s** | %s | %s%s |\n' % (n['label'], cell(n['props'].get('initial', '')), ' '.join(terms), col(n)))
    valves = [n for n in nodes.values() if n['type'] == 'valve']
    if valves:
        out.append('\n**Flows**\n\n' + head('Flow', 'Rate'))
        out += ['| %s | %s%s |\n' % (n['label'], cell(n['props'].get('rate', '')), col(n)) for n in valves]
    def number(n):
        try:
            float(n['props'].get('value', ''))
            return True
        except ValueError:
            return False
    derived = [n for n in nodes.values() if n['type'] == 'variable' and not kind(n) and not number(n)]
    constants = [n for n in nodes.values() if n['type'] == 'variable' and not kind(n) and number(n)]
    if derived:
        out.append('\n**Variables**\n\n' + head('Variable', 'Equation'))
        out += ['| %s | %s%s |\n' % (n['label'], cell(n['props'].get('value', '')), col(n)) for n in derived]
    if constants:
        out.append('\n**Constants**\n\n' + head('Constant', 'Value'))
        out += ['| %s | %s%s |\n' % (n['label'], cell(n['props'].get('value', '')), col(n)) for n in constants]
    other = [n for n in nodes.values() if n['type'] in ('condition', 'initialiser', 'migrator', 'reproduction', 'exterminator')]
    if other:
        names = {'condition': 'condition', 'initialiser': 'creation', 'migrator': 'immigration',
                 'reproduction': 'reproduction', 'exterminator': 'loss'}
        out.append('\n**Conditions and population changes**\n\n' + head('Name', 'Kind', 'Expression'))
        out += ['| %s | %s | %s%s |\n' % (n['label'], names[n['type']], cell(n['props'].get('expr', '')), col(n)) for n in other]
    params = [n for n in nodes.values() if n['type'] == 'variable' and kind(n)]
    if params:
        out.append('\n**Parameters** (default values; a parameter file or a run may give others)\n\n' + head('Parameter', 'Default', 'Kind'))
        out += ['| %s | %s | %s%s |\n' % (n['label'], cell(n['props'].get('value', '')),
                {'variable': 'variable', 'fixed': 'fixed'}[kind(n)], col(n)) for n in params]
    return ''.join(out)


class Session:
    """One model, run as often as asked. `model`: a model spec (dict) or its
    file. `parameters`: a parameter file (dict or path) every run starts
    from. `run_settings`: overrides of the model's own presentation.run
    (startTime, runLength, logEach, timeStep), fixed for the session."""

    def __init__(self, model, parameters=None, run_settings=None, time_limit=120,
                 app_port=8731, chrome_port=9350):
        self.spec = _load(model)
        self.base = _load(parameters) or {'variables': {}}
        self.base.setdefault('variables', {})
        self.run_settings = dict((self.spec.get('presentation') or {}).get('run') or {})
        self.run_settings.update(run_settings or {})
        self.time_limit = time_limit
        self._cdp = 'http://127.0.0.1:%d' % chrome_port
        self._app = 'http://localhost:%d/index.html' % app_port
        self._started, self._ws, self._target, self._n = [], None, None, 0
        self._work = tempfile.mkdtemp(prefix='simile-run-')
        atexit.register(self.close)
        if not _listening(app_port):
            self._started.append(subprocess.Popen([sys.executable, os.path.join(REPO, 'tools/serve.py'), str(app_port)],
                                                  cwd=REPO, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL))
            _wait_for(app_port, 'the web server')
        if not _listening(chrome_port):
            self._started.append(subprocess.Popen([_chrome(), '--headless=new', '--remote-debugging-port=%d' % chrome_port,
                '--user-data-dir=' + os.path.join(self._work, 'chrome'), '--no-first-run', '--noerrdialogs',
                '--ozone-platform=headless', 'about:blank'], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL))
            _wait_for(chrome_port, 'Chrome')
            time.sleep(1.5)
        req = urllib.request.Request(self._cdp + '/json/new?about:blank', method='PUT')
        self._target = json.load(urllib.request.urlopen(req, timeout=10))
        self._ws = connect(self._target['webSocketDebuggerUrl'], max_size=None, open_timeout=10)
        self._cmd('Page.navigate', {'url': self._app + '?newuser=fresh'}, 30)
        for _ in range(120):
            if self._ev('!!(window.Sienna && Sienna.Simulation && Sienna.userData)', 5):
                break
            time.sleep(0.25)
        else:
            raise SimileError('the app did not load')
        time.sleep(1)
        self._set_model(self.spec)

    # ---- talking to the page --------------------------------------------------

    def _cmd(self, method, params, timeout):
        self._n += 1
        n = self._n
        self._ws.send(json.dumps({'id': n, 'method': method, 'params': params or {}}))
        end = time.time() + timeout
        while True:
            left = end - time.time()
            if left <= 0:
                self._abort()
                raise SimileError('no answer within %g seconds (%s); the page was closed' % (timeout, method))
            try:
                msg = json.loads(self._ws.recv(timeout=left))
            except TimeoutError:
                continue
            if msg.get('id') == n:
                return msg.get('result', {})

    def _ev(self, js, timeout=None):
        r = self._cmd('Runtime.evaluate', {'expression': js, 'returnByValue': True, 'awaitPromise': True},
                      timeout or self.time_limit)
        if 'exceptionDetails' in r:
            raise SimileError((r['exceptionDetails'].get('exception') or {}).get('description')
                              or r['exceptionDetails'].get('text'))
        return (r.get('result') or {}).get('value')

    def _abort(self):
        """A page stuck in the engine keeps a processor busy: close it."""
        try:
            urllib.request.urlopen(self._cdp + '/json/close/' + self._target['id'], timeout=5)
        except Exception:
            pass
        self._ws = None

    def _set_model(self, spec):
        self._ev("Sienna.userData.set(%s, %s); Sienna.Simulation.presetSettings(%s, %s); 1"
                 % (json.dumps(REF), json.dumps(spec), json.dumps(REF), json.dumps(self.run_settings)))
        self.spec = spec

    # ---- what a notebook calls ------------------------------------------------

    def run(self, parameters=None, variables=None, model=None):
        """Run once. `parameters`: {name: value} over the session's parameter
        file (a value over time as {time: value} or a list for times 0, 1, 2…).
        `variables`: names to return (a variable's own name, or its path, e.g.
        'tree/Height'), default every variable with one value. `model`: a
        changed model spec to run instead (compiled first, once). Returns a
        DataFrame indexed by time, a column per variable."""
        if self._ws is None:
            raise SimileError('this session has ended (a run did not finish, or it was closed)')
        if model is not None and model != self.spec:
            self._set_model(model)
            self._ev('window.__nbFixed = undefined; 1')
        doc = copy.deepcopy(self.base)
        doc['variables'].update(parameters or {})
        js = r"""(async () => {
          const ref = %s, sim = Sienna.Simulation, v = sim.viewFor(ref), want = %s, limit = %d;
          const got = sim.readParameterFile(ref, %s);
          if (got.unknown.length || got.bad.length)
            return {error: 'parameter values not taken: ' + got.unknown.map(x => x + ' (no such parameter)').concat(got.bad).join('; ')};
          // A FIXED parameter is read when the model is first reset, and
          // given a new value after that it keeps its old one (engine README
          // fault 7): when one changes, the model is loaded afresh (its
          // compiled copy is remembered, so that is quick).
          const fixed = JSON.stringify(sim.inputParametersOf(ref).filter(p => p.kind === 'fixed').map(p => [p.id, got.values[p.id]]));
          if (window.__nbFixed !== undefined && window.__nbFixed !== fixed && v.base) await v.unload();
          window.__nbFixed = fixed;
          await sim.setInputValues(ref, got.values, true, got.fills);
          await v.prepare();
          if (v.status === 'error') return {error: v.message};
          const comps = v.components, path = k => comps[k].captpath.replace(/^\//, '');
          const ids = Object.keys(comps).filter(k => comps[k].type !== 'VALUELESS' && (comps[k].dims || []).length === 1
            && (!want || want.includes(path(k)) || want.includes(path(k).split('/').pop())));
          if (want) {
            const found = ids.map(k => path(k)), short = found.map(p => p.split('/').pop());
            const missing = want.filter(w => !found.includes(w) && !short.includes(w));
            if (missing.length) return {error: 'no variable with one value called ' + missing.join(', ')};
          }
          (window.__nbTargets || []).forEach(t => v.removeTarget(t));
          window.__nbTargets = ids.map((k, i) => 'notebook:' + i);
          ids.forEach((k, i) => v.addTarget('notebook:' + i, k));
          const rows = [];
          const unsub = v.subscribe(e => { if (e.type === 'data') rows.push([e.time].concat(ids.map(k => e.values[k]))); });
          await v.reset();
          rows.length = 0;
          const first = await v.query(ids);
          rows.push([Number(v.settings.current)].concat(ids.map(k => first[k])));
          const s = v.settings, end = Number(s.startTime || 0) + Number(s.runLength), began = performance.now();
          v.start();
          while (Number(v.settings.current) < end - 1e-9 && v.status !== 'error' && performance.now() - began < limit * 1000)
            await new Promise(r => setTimeout(r, 25));
          unsub();
          if (v.status === 'error') return {error: v.message};
          if (Number(v.settings.current) < end - 1e-9) return {error: 'the run stopped at ' + v.settings.current};
          return {names: ids.map(path), rows: rows};
        })()""" % (json.dumps(REF), json.dumps(list(variables) if variables else None), int(self.time_limit),
                   json.dumps(doc))
        r = self._ev(js)
        if not r or 'error' in r:
            raise SimileError((r or {}).get('error', 'no answer'))
        df = pd.DataFrame(r['rows'], columns=['time'] + r['names']).drop_duplicates('time', keep='last')
        return df.set_index('time')

    def diagram(self, scale=2):
        """The model's diagram as Simile draws it, a PNG (bytes). For a
        notebook: `Image(data=s.diagram())`."""
        self._cmd('Emulation.setDeviceMetricsOverride',
                  {'width': 1600, 'height': 1200, 'deviceScaleFactor': 1, 'mobile': False}, 10)
        # A fresh user's Welcome, and the compiler's "please wait", are not drawn over it.
        self._ev("""(()=>{ document.dispatchEvent(new PointerEvent('pointerdown', {bubbles: true}));
          if (!document.getElementById('nb-no-overlays')) { const st = document.createElement('style'); st.id = 'nb-no-overlays';
            st.textContent = '.slx-welcome,.slx-wait-note{display:none!important}'; document.head.appendChild(st); }
          app.panels().filter($p => app.widgetOf($p) === 'diagram').forEach($p => app.closeWindow ? app.closeWindow($p) : $p.panel('close'));
          Sienna.documents.open(app, %s); return 1 })()""" % json.dumps(REF), 30)
        time.sleep(2.5)
        self._ev("""(()=>{ const $p = app.panels().filter($p => app.widgetOf($p) === 'diagram').pop();
          if ($p) { app.showWindow($p); $p.find('[title*=aximi]').first().click(); } return 1 })()""", 10)
        time.sleep(1)
        self._ev("$('.slx-diagram:visible button').filter((i, b) => b.textContent === 'fit').last().click(); 1", 10)
        time.sleep(1)
        box = self._ev("""(()=>{ const svgs = [...document.querySelectorAll('.slx-diagram svg')].filter(s => s.getBoundingClientRect().width > 0);
          const svg = svgs[svgs.length - 1]; if (!svg) return null; const sr = svg.getBoundingClientRect(); let b = null;
          svg.querySelectorAll('[data-id], [data-label-for]').forEach(e => { const r = e.getBoundingClientRect(); if (!r.width && !r.height) return;
            b = b ? {l: Math.min(b.l, r.left), t: Math.min(b.t, r.top), r: Math.max(b.r, r.right), b: Math.max(b.b, r.bottom)}
                  : {l: r.left, t: r.top, r: r.right, b: r.bottom}; });
          return b && {x: Math.max(b.l - 12, sr.left), y: Math.max(b.t - 12, sr.top),
                       w: Math.min(b.r + 12, sr.right) - Math.max(b.l - 12, sr.left), h: Math.min(b.b + 12, sr.bottom) - Math.max(b.t - 12, sr.top)} })()""", 10)
        if not box:
            raise SimileError('the diagram could not be drawn')
        shot = self._cmd('Page.captureScreenshot', {'format': 'png', 'clip': {'x': box['x'], 'y': box['y'],
                         'width': box['w'], 'height': box['h'], 'scale': scale}}, 30)
        return base64.b64decode(shot['data'])

    def close(self):
        if self._target:
            try:
                urllib.request.urlopen(self._cdp + '/json/close/' + self._target['id'], timeout=5)
            except Exception:
                pass
            self._target = None
        self._ws = None
        for p in self._started:
            p.terminate()
        # Wait until they have gone: a session opened straight after would
        # otherwise find the port still answering, and a Chrome shutting down.
        for p in self._started:
            try:
                p.wait(timeout=15)
            except subprocess.TimeoutExpired:
                p.kill()
        self._started = []
        shutil.rmtree(self._work, ignore_errors=True)

    def __enter__(self):
        return self

    def __exit__(self, *exc):
        self.close()
