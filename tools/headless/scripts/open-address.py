# Opening a model from an address (`index.html?open=…`, main.js): the model
# fetched from ANOTHER site that allows it (CORS, as GitHub Pages does), added
# as a copy and opened; the address taken out of the address bar; parameter
# values from `<name>.parameters.json` beside it, or `&parameters=`; the same
# address again offering the copy; and the errors — no file, not JSON, not a
# model, a site that does not allow it. Runs in a new-user preview, so the
# real store is not touched. Starts its own second site on :8732 (CORS on),
# and :8733 (CORS off). Standalone, like two-tabs.py; Chrome on :9350:
#   python3 tools/headless/scripts/open-address.py          # app over http (tools/serve.py)
#   python3 tools/headless/scripts/open-address.py file     # app from file://
import asyncio, functools, http.server, json, os, sys, tempfile, threading, urllib.request, websockets
ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))
APP = ('file://' + ROOT + '/') if sys.argv[1:] == ['file'] else 'http://localhost:8731/'
SITE = tempfile.mkdtemp(prefix='simile-open-')

class Cors(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header('Access-Control-Allow-Origin', '*'); self.send_header('Cache-Control', 'no-store')
        super().end_headers()
    def log_message(self, *a): pass
class NoCors(http.server.SimpleHTTPRequestHandler):
    def log_message(self, *a): pass
for port, h in ((8732, Cors), (8733, NoCors)):
    srv = http.server.ThreadingHTTPServer(('127.0.0.1', port), functools.partial(h, directory=SITE))
    threading.Thread(target=srv.serve_forever, daemon=True).start()

B = 'http://127.0.0.1:9350'
STUB = """window.__said = []; window.__answer = true;
window.alert = function (m) { __said.push('alert: ' + m); };
window.confirm = function (m) { __said.push('confirm: ' + m); return __answer; };"""
class Tab:
    def __init__(s, t): s.t = t; s.n = 0
    async def open(s):
        s.ws = await websockets.connect(s.t['webSocketDebuggerUrl'], max_size=None)
        await s.cmd('Page.enable'); await s.cmd('Page.addScriptToEvaluateOnNewDocument', {'source': STUB})
        return s
    async def cmd(s, m, p=None):
        s.n += 1; i = s.n
        await s.ws.send(json.dumps({'id': i, 'method': m, 'params': p or {}}))
        while True:
            r = json.loads(await s.ws.recv())
            if r.get('id') == i: return r.get('result', {})
    async def ev(s, js):
        r = await s.cmd('Runtime.evaluate', {'expression': js, 'returnByValue': True, 'awaitPromise': True})
        if 'exceptionDetails' in r: return 'JSERR ' + str(r['exceptionDetails'].get('exception', {}).get('description'))
        return r['result'].get('value')
    async def go(s, url, wait=6):
        await s.cmd('Page.navigate', {'url': url}); await asyncio.sleep(wait)
ok = [0, 0]
def check(name, cond, detail=''):
    ok[0 if cond else 1] += 1; print(('PASS ' if cond else 'FAIL ') + name + ('' if cond else '  ' + str(detail)))

async def main():
    t = json.load(urllib.request.urlopen(urllib.request.Request(B + '/json/new?about:blank', method='PUT')))
    T = await Tab(t).open()
    await T.go(APP + 'index.html?newuser=fresh')
    # The site's files: a model as File > Save writes it, with a parameter file
    # beside it (labour_by_priority1, which has fixed parameters), and one without.
    pl = open(os.path.join(ROOT, 'reference/catalogue/labour_by_priority1.pl'), errors='replace').read()
    made = await T.ev("""(() => { Sienna.importSimile.install('models/probe', Sienna.importSimile.read(%s).model);
      return JSON.stringify(Sienna.userData.get('models/probe')); })()""" % json.dumps(pl))
    labels = await T.ev("Sienna.Simulation.inputParametersOf('models/probe').map(p => [p.label, p.shape])")
    await T.ev("Sienna.userData.remove('models/probe'); 1")
    os.makedirs(SITE + '/labour'); open(SITE + '/labour/labour.json', 'w').write(made)
    growth = await T.ev("JSON.stringify(Sienna.userData.get('models/growth'))")
    os.makedirs(SITE + '/growth'); open(SITE + '/growth/growth.json', 'w').write(growth)
    open(SITE + '/notjson.json', 'w').write('<html>no</html>')
    open(SITE + '/notmodel.json', 'w').write('{"hello": 1}')
    def nest(label, v, doc):
        parts = label.split('/'); node = doc
        for s in parts[:-1]: node = node.setdefault('submodels', {}).setdefault(s, {})
        node.setdefault('variables', {})[parts[-1]] = v
    pdoc = {}
    for label, shape in labels:
        v = 1.5
        for x in reversed(shape): v = [v] * x
        nest(label, v, pdoc)
    open(SITE + '/labour/labour.parameters.json', 'w').write(json.dumps(pdoc))
    other = json.loads(json.dumps(pdoc).replace('1.5', '2.5'))
    open(SITE + '/labour/other-values.json', 'w').write(json.dumps(other))
    check('labour has parameters to give', len(labels) > 0, labels)

    def opened(u, extra=''):
        return APP + 'index.html?newuser&open=' + urllib.request.quote(u, safe='') + extra
    count = "Sienna.documents.list().length"
    before = await T.ev(count)
    await T.go(opened('http://localhost:8732/labour/labour.json'), 9)
    said = await T.ev('__said')
    check('opened with nothing said', said == [], said)
    check('one more model', await T.ev(count) == before + 1)
    path = await T.ev("Sienna.documents.list().filter(d => (Sienna.userData.get(d.path).openedFrom || {}).url === 'http://localhost:8732/labour/labour.json').map(d => d.path)[0]")
    check('the copy records where it came from', bool(path), path)
    check('it is the current model', await T.ev("Sienna.documents.current(app)") == path)
    check('its windows are open', await T.ev("app.panels().filter($p => $p.panel('ref') === %s).length" % json.dumps(path)) >= 2)
    search = await T.ev('location.search')
    check('the address is taken out of the address bar', search == '?newuser', search)
    given = await T.ev("Object.keys(Sienna.Simulation.inputValues(%s).values).length" % json.dumps(path))
    check('its parameter values were loaded from beside it', given == len(labels), given)

    # The same address again: the copy offered. Yes opens it; no makes another.
    await T.go(opened('http://localhost:8732/labour/labour.json'), 7)
    said = await T.ev('__said')
    check('again: the copy is offered', len(said) == 1 and said[0].startswith('confirm: You already have a copy'), said)
    check('again, OK: no new copy', await T.ev(count) == before + 1)
    await T.cmd('Page.addScriptToEvaluateOnNewDocument', {'source': 'window.__answer = false;'})
    await T.go(opened('http://localhost:8732/labour/labour.json'), 9)
    check('again, Cancel: a new copy', await T.ev(count) == before + 2)

    # No parameter file beside it: nothing said. One named: used.
    await T.go(opened('http://localhost:8732/growth/growth.json'), 7)
    check('no parameter file beside it: nothing said', await T.ev('__said') == [], await T.ev('__said'))
    await T.go(opened('http://localhost:8732/labour/labour.json', '&parameters=other-values.json'), 9)
    gp = await T.ev("(() => { const d = Sienna.documents.current(app); return JSON.stringify(Sienna.Simulation.inputValues(d).values); })()")
    check('&parameters= names the file', '2.5' in gp and '1.5' not in gp, gp)

    # Errors, each said in words.
    for name, u, want in (
            ('no file there', 'http://localhost:8732/nothing.json', 'There is no file at that address'),
            ('not JSON', 'http://localhost:8732/notjson.json', 'not JSON'),
            ('not a model', 'http://localhost:8732/notmodel.json', 'not a model this app can open'),
            ('a site that does not allow it', 'http://localhost:8733/growth/growth.json', 'does not allow other sites')):
        n0 = await T.ev(count)
        await T.go(opened(u), 5)
        said = await T.ev('__said')
        check('error, ' + name, len(said) == 1 and want in said[0] and await T.ev(count) == n0, said)
    print(ok[0], 'passed,', ok[1], 'failed')
    urllib.request.urlopen(B + '/json/close/' + t['id'])
asyncio.run(main())
