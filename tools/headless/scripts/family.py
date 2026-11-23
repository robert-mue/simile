# A model's FAMILY (Robert, 2026-11-23; metadata.family, src/widgets/metadata.js):
# a model opened from the gallery (served here from ~/Projects/model_gallery,
# or argv[1], on :8734) lists its family in the Metadata panel, itself marked;
# a click on another member opens it in the same window, beside the first;
# editing a field (title) keeps the family; with no address to look beside and
# not among the user's models, it says which file to open.
# Standalone; Chrome on :9350, the app over http (tools/serve.py):
#   python3 tools/headless/scripts/family.py [gallery directory]
import asyncio, functools, http.server, json, os, sys, threading, urllib.request, websockets
GALLERY = sys.argv[1] if sys.argv[1:] else os.path.expanduser('~/Projects/model_gallery')
APP = 'http://localhost:8731/index.html'
G = 'http://localhost:8734/'


class Cors(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header('Access-Control-Allow-Origin', '*'); self.send_header('Cache-Control', 'no-store')
        super().end_headers()
    def log_message(self, *a): pass


srv = http.server.ThreadingHTTPServer(('127.0.0.1', 8734), functools.partial(Cors, directory=GALLERY))
threading.Thread(target=srv.serve_forever, daemon=True).start()
ok = [0, 0]
def check(name, cond, detail=''):
    ok[0 if cond else 1] += 1; print(('PASS ' if cond else 'FAIL ') + name + ('' if cond else '  ' + str(detail)), flush=True)


async def main():
    B = 'http://127.0.0.1:9350'
    t = json.load(urllib.request.urlopen(urllib.request.Request(B + '/json/new?about:blank', method='PUT')))
    ws = await websockets.connect(t['webSocketDebuggerUrl'], max_size=None)
    n = [0]
    async def cmd(m, p=None):
        n[0] += 1; i = n[0]
        await ws.send(json.dumps({'id': i, 'method': m, 'params': p or {}}))
        while True:
            r = json.loads(await asyncio.wait_for(ws.recv(), 60))
            if r.get('id') == i: return r.get('result', {})
    async def ev(js):
        r = await cmd('Runtime.evaluate', {'expression': js, 'returnByValue': True, 'awaitPromise': True})
        return (r.get('result') or {}).get('value')
    async def wait(js, secs=30):
        for _ in range(secs * 4):
            if await ev(js): return True
            await asyncio.sleep(0.25)
        return False
    try:
        await cmd('Page.enable')
        # askChoice / confirm would hold a run up: none expected, but never block.
        await cmd('Page.addScriptToEvaluateOnNewDocument', {'source': 'window.confirm = function () { return true; };'})
        await cmd('Page.navigate', {'url': APP + '?newuser=fresh&open=' + G + 'models/descrpop-logistic/descrpop-logistic.json'})
        mine = "Sienna.documents.list().map(d => Sienna.userData.get(d.path)).filter(m => m && m.id === %s).length"
        check('the logistic model opened from the gallery', await wait(mine % '"descrpop_logistic"'))
        ref = await ev("Sienna.documents.list().find(d => (Sienna.userData.get(d.path) || {}).id === 'descrpop_logistic').path")
        await ev("app.addPanel({ widget: 'metadata', ref: %s, title: 'meta' }).then(() => 1)" % json.dumps(ref))
        await wait("$('.slx-meta-family li').length > 0", 10)
        items = await ev("$('.slx-meta-family li').length")
        check('the Metadata panel lists its family of 13', items == 13, items)
        this_one = await ev("$('.slx-meta-family li.slx-meta-family-this strong').text()")
        check('itself marked, not a link', this_one == 'Logistic', this_one)
        links = await ev("$('.slx-meta-family a[data-member]').length")
        check('the other 12 are links', links == 12, links)
        head = await ev("$('.slx-meta-family .slx-meta-read-head').text()")
        check('under the family\'s title', head.startswith('Descriptive population models'), head)

        # A click: Ricker opens in this window, beside the logistic.
        await ev("$('.slx-meta-family a').filter((i, a) => a.textContent === 'Ricker').click(); 1")
        check('a click opens Ricker in this window', await wait(mine % '"descrpop_ricker"'))
        both = await ev("""(() => { const refs = new Set(app.panels().map($p => $p.panel('ref')).filter(Boolean));
            return Sienna.documents.list().filter(d => refs.has(d.path)).map(d => Sienna.userData.get(d.path).id).sort() })()""")
        check('both models have panels open', both == ['descrpop_logistic', 'descrpop_ricker'], both)

        # Editing the title keeps the family.
        await ev("""(() => { const i = $('.slx-meta [data-key=title]').first(); i.val('Logistic, edited').trigger('change'); return 1 })()""")
        await asyncio.sleep(0.5)
        held = await ev("JSON.stringify(Sienna.userData.get(%s).metadata)" % json.dumps(ref))
        m = json.loads(held or '{}')
        check('a title edited, the family kept', m.get('title') == 'Logistic, edited' and len((m.get('family') or {}).get('members', [])) == 13,
              (m.get('title'), list(m)))
        await ev("Sienna.history.undo(); 1"); await asyncio.sleep(0.3)
        back = await ev("Sienna.userData.get(%s).metadata.title" % json.dumps(ref))
        check('and undone', back.startswith('Logistic'), back)

        # No address and not among the user's models: it says which file.
        await ev("""(() => { const m = JSON.parse(JSON.stringify(Sienna.userData.get(%s)));
            delete m.openedFrom; delete m.metadata.page; m.id = 'loose_copy';
            Sienna.userData.set('models/__loose', m); return 1 })()""" % json.dumps(ref))
        said = await ev("""new Promise(res => Sienna.openFamilyMember('models/__loose',
            Sienna.userData.get('models/__loose').metadata.family.members[12], res))""")
        check('with no address: says which file to open', 'descrpop-allee.json' in (said or ''), said)
        await ev("Sienna.userData.remove('models/__loose'); 1")
    finally:
        await ws.close()
        urllib.request.urlopen(B + '/json/close/' + t['id'])
    print('%d passed, %d failed' % tuple(ok))

asyncio.run(main())
