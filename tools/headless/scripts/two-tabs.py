# The app open in two tabs (sienna's persistence.js, "one live tab"): the tab
# opened last takes over, the other stops writing and says so; its button
# takes the app back; a page that keeps nothing takes no part; a tab that
# missed the hand-over refuses its next write. Runs in a new-user preview,
# so the real store is not touched. Standalone, not through cdp.py (it needs
# several tabs), against the headless Chrome on :9350 (tools/headless/README.md):
#   python3 tools/headless/scripts/two-tabs.py          # over http (tools/serve.py)
#   python3 tools/headless/scripts/two-tabs.py file     # from file://
import asyncio, json, os, sys, urllib.request, websockets
ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))
BASE = ('file://' + ROOT + '/') if sys.argv[1:] == ['file'] else 'http://localhost:8731/'
B = 'http://127.0.0.1:9350'
def new_tab(url):
    req = urllib.request.Request(B + '/json/new?' + url, method='PUT')
    return json.load(urllib.request.urlopen(req))
class Tab:
    def __init__(s, t): s.t = t; s.n = 0
    async def open(s): s.ws = await websockets.connect(s.t['webSocketDebuggerUrl'], max_size=None); return s
    async def ev(s, js):
        s.n += 1; i = s.n
        await s.ws.send(json.dumps({'id': i, 'method': 'Runtime.evaluate', 'params': {'expression': js, 'returnByValue': True, 'awaitPromise': True}}))
        while True:
            r = json.loads(await s.ws.recv())
            if r.get('id') == i:
                res = r['result']
                if 'exceptionDetails' in res: return 'JSERR ' + str(res['exceptionDetails'].get('exception', {}).get('description'))
                return res['result'].get('value')
ok = [0, 0]
def check(name, cond):
    ok[0 if cond else 1] += 1; print(('PASS ' if cond else 'FAIL ') + name)
async def main():
    U = BASE + 'index.html?newuser'
    A = await Tab(new_tab(BASE + 'index.html?newuser=fresh')).open(); await asyncio.sleep(5)
    check('A is live on its own', await A.ev('Sienna.persistence.live()') is True)
    await A.ev("Sienna.userData.set('scratch/a', 1); 1")
    Bt = await Tab(new_tab(U)).open(); await asyncio.sleep(5)
    check('B is live once opened', await Bt.ev('Sienna.persistence.live()') is True)
    check('A stood down', await A.ev('Sienna.persistence.live()') is False)
    check('A shows the notice', await A.ev("!!document.querySelector('.slx-elsewhere')") is True)
    print('   notice:', await A.ev("document.querySelector('.slx-elsewhere').innerText.replace(/\\n+/g,' | ')"))
    check('B has what A wrote', await Bt.ev("Sienna.userData.get('scratch/a')") == 1)
    check('B shows no notice', await Bt.ev("!document.querySelector('.slx-elsewhere')") is True)
    await A.ev("Sienna.userData.set('scratch/fromA', 1); 1")
    await Bt.ev("Sienna.userData.set('scratch/b', 2); 1")
    stored = await Bt.ev("JSON.parse(localStorage.getItem(Sienna.storageKey('userData.v1'))).scratch")
    check('A\'s later write was not saved, B\'s was', stored == {'a': 1, 'b': 2})
    # An embedded-widget page keeps nothing and takes no part.
    P = await Tab(new_tab(BASE + 'pages/trees/index.html')).open(); await asyncio.sleep(4)
    check('a page that keeps nothing leaves B live', await Bt.ev('Sienna.persistence.live()') is True)
    # Use it in this tab: A reloads and takes over.
    await A.ev("document.querySelector('.slx-elsewhere-use').click(); 1"); await asyncio.sleep(5)
    A = await Tab(A.t).open()             # the reload closed the old connection
    check('A live again after its button', await A.ev('Sienna.persistence.live()') is True)
    check('A has B\'s work', await A.ev("Sienna.userData.get('scratch/b')") == 2)
    check('B stood down', await Bt.ev('Sienna.persistence.live()') is False)
    # A tab asleep through the hand-over: no event, but the write checks.
    await A.ev("localStorage.setItem(Sienna.storageKey('liveTab'), 'someone-else'); 1")
    await A.ev("Sienna.userData.set('scratch/late', 3); 1")
    check('a write after a missed hand-over is refused', await A.ev("JSON.parse(localStorage.getItem(Sienna.storageKey('userData.v1'))).scratch.late === undefined") is True)
    check('and that tab then stands down', await A.ev("!!document.querySelector('.slx-elsewhere')") is True)
    print(ok[0], 'passed,', ok[1], 'failed')
    for t in (A, Bt, P):
        urllib.request.urlopen(B + '/json/close/' + t.t['id'])
asyncio.run(main())
