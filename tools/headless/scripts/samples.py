# Sample models and a first visit (main.js `welcome`, src/widgets/samples.js):
# a new user's models start empty; the Welcome and the Sample models panel
# appear, the Welcome gone at the first key; the panel lists the gallery's
# models with their metadata and the size and features read from each model
# spec; its columns sort; Open makes a copy, metadata kept; a reload brings
# back the panel and no Welcome; File's lists in their places; `?demos` seeds
# the built-in models; a gallery out of reach is said. Serves a copy of the
# model gallery (~/Projects/model_gallery, or argv[1]) on :8734, CORS on.
# Runs in a new-user preview, so the real store is not touched. Standalone;
# Chrome on :9350, the app over http (tools/serve.py):
#   python3 tools/headless/scripts/samples.py [gallery directory]
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

B = 'http://127.0.0.1:9350'
class Tab:
    def __init__(s, t): s.t = t; s.n = 0
    async def open(s):
        s.ws = await websockets.connect(s.t['webSocketDebuggerUrl'], max_size=None)
        await s.cmd('Page.enable')
        await s.cmd('Page.addScriptToEvaluateOnNewDocument', {'source': 'window.alert = function () {}; window.confirm = function () { return true; };'})
        return s
    async def cmd(s, m, p=None):
        s.n += 1; i = s.n
        await s.ws.send(json.dumps({'id': i, 'method': m, 'params': p or {}}))
        while True:
            r = json.loads(await s.ws.recv())
            if r.get('method') == 'Page.javascriptDialogOpening':
                await s.ws.send(json.dumps({'id': 99999, 'method': 'Page.handleJavaScriptDialog', 'params': {'accept': True}}))
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

def expected(name):
    """Size and features from the spec, worked out here independently."""
    m = json.load(open(os.path.join(GALLERY, 'models', name, name + '.json')))
    n = list(m['nodes'].values()); c = lambda t: sum(1 for x in n if x['type'] == t)
    return '%d/%d/%d/%d' % (len(m.get('submodels') or {}), c('stock'), c('valve'), c('variable')), m['metadata']

async def main():
    names = json.load(open(os.path.join(GALLERY, 'models', 'index.json')))['models']
    t = json.load(urllib.request.urlopen(urllib.request.Request(B + '/json/new?about:blank', method='PUT')))
    T = await Tab(t).open()
    await T.go(APP + '?newuser=fresh&gallery=' + G, 8)
    check('a new user has no models', await T.ev('Sienna.documents.list().length') == 0)
    check('the Welcome is shown', await T.ev("!!document.querySelector('.slx-welcome')") is True)
    check('it offers the three tutorials', await T.ev("document.querySelectorAll('.slx-welcome a').length") == 3)
    panel = "app.windows().filter($p => app.widgetOf($p) === 'samples')"
    check('the Sample models panel is open', await T.ev(panel + '.length') == 1)
    check('it is about no model', await T.ev(panel + "[0].panel('ref')") in ('', None))
    rows = "[...document.querySelectorAll('.slx-samples-table tbody tr')].map(tr => [...tr.cells].map(c => c.textContent))"
    got = await T.ev(rows)
    check('it lists every model in the gallery', isinstance(got, list) and len(got) == len(names), got)
    for name in names:
        size, meta = expected(name)
        row = [r for r in (got or []) if r[0].startswith(meta['title'])]
        check(name + ': title, description, keywords, size', len(row) == 1 and meta['description'] in row[0][0]
              and row[0][1] == ', '.join(meta['keywords']) and row[0][2] == size, row)
        if 'paper' in meta:
            check(name + ': its paper is linked', await T.ev("[...document.querySelectorAll('.slx-samples-links a')].some(a => a.href === %s)" % json.dumps(meta['paper']['url'])) is True)
    trees = [r for r in got if r[0].startswith('Trees')]
    check('features read from the structure (trees: population, creation, immigration, loss)',
          trees and trees[0][3] == 'population, creation, immigration, loss', trees)
    lamos = [r for r in got if r[0].startswith('LAMOS')]
    check('features read from the structure (LAMOS: association among them)', lamos and 'association' in lamos[0][3], lamos)
    check('sorted by title at first', [r[0] for r in got] == sorted([r[0] for r in got], key=str.lower))
    await T.ev("$('th[data-sort=size]').click(); 1")
    total = lambda r: sum(int(x) for x in r[2].split('/'))
    by = await T.ev(rows)
    check('Size sorts by the total', [total(r) for r in by] == sorted(total(r) for r in by), [r[2] for r in by])
    await T.ev("$('th[data-sort=size]').click(); 1")
    by = await T.ev(rows)
    check('and again, the other way', [total(r) for r in by] == sorted((total(r) for r in by), reverse=True), [r[2] for r in by])

    await T.cmd('Input.dispatchKeyEvent', {'type': 'keyDown', 'key': 'Shift'})
    await T.cmd('Input.dispatchKeyEvent', {'type': 'keyUp', 'key': 'Shift'})
    check('a key and the Welcome is gone', await T.ev("!!document.querySelector('.slx-welcome')") is False)

    # File: Recent models under Open, Your models, Sample models… last.
    labels = await T.ev("Sienna.documents.menuItems(app).map(i => i.separator ? '--' : i.label)")
    check('File: Recent models right under Open', labels[1:3] == ['Open model file…', 'Recent models'], labels)
    check('File: Your models, then Sample models… at the bottom', labels[-3:] == ['Your models', '--', 'Sample models…'], labels)
    check('Your models: none yet', await T.ev("Sienna.documents.menuItems(app).find(i => i.label === 'Your models').items().map(i => i.label)") == ['(none yet)'])
    check('not in the Widgets menu', await T.ev("[...document.querySelectorAll('*')].some(e => e.children.length === 0 && e.textContent === 'Widgets')") is True
          and await T.ev("Sienna.widgetRegistry.list().some(w => w.name === 'samples')") is True)

    # Open: a copy, opened, its metadata kept; the panel stays.
    await T.ev("$('button[data-open$=\"bank-account.json\"]').click(); 1"); await asyncio.sleep(4)
    cur = await T.ev('Sienna.documents.current(app)')
    check('Open: the model is one of yours, and current', await T.ev('Sienna.documents.list().length') == 1 and bool(cur), cur)
    check('its metadata is kept', await T.ev("(Sienna.userData.get(%s).metadata || {}).title" % json.dumps(cur)) == 'Bank account')
    check('it records where it came from', (await T.ev("(Sienna.userData.get(%s).openedFrom || {}).url" % json.dumps(cur)) or '').endswith('bank-account.json'))
    check('the panel stays open', await T.ev(panel + '.length') == 1)
    await T.ev("Sienna.documents.menuItems(app).find(i => i.label === 'Sample models…').onSelect(); 1"); await asyncio.sleep(1)
    check('Sample models… again: still one panel', await T.ev(panel + '.length') == 1)

    # The Metadata panel (src/widgets/metadata.js) on that model: shows what
    # it holds and what is read from it; an edit is one undoable change.
    await T.ev("app.addPanel({ widget: 'metadata', ref: %s, title: 'meta' }).then(() => 1)" % json.dumps(cur)); await asyncio.sleep(2)
    val = lambda k: "$('.slx-meta [data-key=%s]').val()" % k
    check('Metadata: shows the title and keywords', await T.ev(val('title')) == 'Bank account'
          and await T.ev(val('keywords')) == 'introductory, compound interest, stock and flow')
    page = 'https://robert-mue.github.io/model_gallery/models/bank-account/'
    check('Metadata: its gallery page, shown and linked', await T.ev(val('page')) == page
          and await T.ev("[...document.querySelectorAll('.slx-meta-links a')].map(a => a.href + ' ' + a.target).join()") == page + ' _blank')
    read = await T.ev("$('.slx-meta-read').text()")
    check('Metadata: size and features read from the model', 'Size: 0/1/2/1 (0 submodels, 1 stock, 2 flows, 1 variable)' in (read or ''), read)
    held = "JSON.stringify(Sienna.userData.get(%s).metadata)" % json.dumps(cur)
    await T.ev("$('.slx-meta [data-key=title]').val('My bank account').trigger('change'); 1")
    check('an edit is held in the model', json.loads(await T.ev(held)).get('title') == 'My bank account')
    await T.ev("$('.slx-meta [data-key=keywords]').val('').trigger('change'); 1")
    check('an emptied field is left out', 'keywords' not in json.loads(await T.ev(held)))
    await T.ev("Sienna.history.undo(); 1"); await asyncio.sleep(0.5)
    check('undo: back, field and model', 'keywords' in json.loads(await T.ev(held)) and await T.ev(val('keywords')) != '')
    await T.ev("Sienna.history.undo(); 1"); await asyncio.sleep(0.5)
    check('undo again: the title back', await T.ev(val('title')) == 'Bank account')
    await T.ev("$('.slx-meta [data-key=citation]').val('Someone (2020). A paper.').trigger('change'); 1")
    await T.ev("$('.slx-meta [data-key=url]').val('doi.org/10.1/x').trigger('change'); 1")
    p = json.loads(await T.ev(held)).get('paper')
    check('a paper: citation and link held', p == {'citation': 'Someone (2020). A paper.', 'url': 'doi.org/10.1/x'}, p)
    check('a link that is not a web address is said', 'should be a web address' in (await T.ev("$('.slx-meta-warn:visible').text()") or ''))
    await T.ev("Sienna.history.undo(); Sienna.history.undo(); 1"); await asyncio.sleep(0.5)
    await T.ev("$('.slx-meta').closest('.slx-panel').panel('close'); 1")
    # From the Widgets menu, as a user would: a panel of the model's, at its working size.
    async def menu(label):
        r = await T.ev("(() => { const e = [...document.querySelectorAll('.slx-menu-label')].find(e => e.textContent.trim() === %r && e.offsetParent); if (!e) return null; const b = e.getBoundingClientRect(); return [b.x + b.width / 2, b.y + b.height / 2]; })()" % label)
        if not r: return False
        for ty in ('mouseMoved', 'mousePressed', 'mouseReleased'):
            await T.cmd('Input.dispatchMouseEvent', {'type': ty, 'x': r[0], 'y': r[1], 'button': 'left', 'clickCount': 1})
        await asyncio.sleep(0.4); return True
    check('Widgets ▸ Metadata is there', await menu('Widgets') and await menu('Metadata'))
    await asyncio.sleep(1.5)
    m = await T.ev("(() => { const p = app.windows().find($p => app.widgetOf($p) === 'metadata'); return p && [p.panel('ref'), p.outerWidth()]; })()")
    check('it opens on the current model, at its working size', m and m[0] == cur and m[1] >= 440, m)
    await T.ev("$('.slx-meta').closest('.slx-panel').panel('close'); 1")

    # Again, a reload: the panel back, no Welcome.
    await T.go(APP + '?newuser&gallery=' + G, 7)
    check('a reload: the panel is back', await T.ev(panel + '.length') == 1)
    check('a reload: no Welcome', await T.ev("!!document.querySelector('.slx-welcome')") is False)
    check('Recent models has the model', await T.ev("Sienna.documents.menuItems(app).find(i => i.label === 'Recent models').items().map(i => i.label)") == ['Bank account'])

    # ?demos seeds the built-in models; a fresh preview without it has none (above).
    await T.go(APP + '?newuser=fresh&demos', 6)
    check('?demos: the built-in models', await T.ev('Sienna.documents.list().length') >= 9)
    check('?demos: no Welcome (there are models)', await T.ev("!!document.querySelector('.slx-welcome')") is False)

    # The gallery out of reach: said, with Try again.
    await T.go(APP + '?newuser=fresh&gallery=http://localhost:8735/', 7)
    said = await T.ev("document.querySelector('.slx-samples') && document.querySelector('.slx-samples').textContent")
    check('a gallery out of reach is said, with Try again', bool(said) and 'Could not fetch the sample models' in said and 'Try again' in said, said)
    print(ok[0], 'passed,', ok[1], 'failed')
    urllib.request.urlopen(B + '/json/close/' + t['id'])
asyncio.run(main())
