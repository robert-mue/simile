# A model's default displays and the run control with no Load (Robert,
# 2026-11-15; src/presentation.js, src/widgets/run-control.js): a model of
# one's own needs no Load, its status a traffic light (green ready, orange
# in progress, red cannot run, with how many elements are incomplete, ▶
# greyed); a setting typed before the first ▶ is kept; ▶ prepares and runs;
# Metadata's "Use the displays open now" keeps them in the model spec,
# undoably; a plot keeps its variables over a reload; opened again, the
# model's default plot is opened and run once. And from the model gallery
# (served from ~/Projects/model_gallery, or argv[1], on :8734): each model
# opened from the Sample models panel opens with its plots, run to the end
# with its run settings. Runs in a new-user preview, so the real store is not
# touched. Standalone; Chrome on :9350, the app over http (tools/serve.py):
#   python3 tools/headless/scripts/presentation.py [gallery directory]
import asyncio, functools, http.server, json, os, sys, threading, time, urllib.request, websockets
GALLERY = sys.argv[1] if sys.argv[1:] else os.path.expanduser('~/Projects/model_gallery')
class Cors(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header('Access-Control-Allow-Origin', '*'); self.send_header('Cache-Control', 'no-store')
        super().end_headers()
    def log_message(self, *a): pass
srv = http.server.ThreadingHTTPServer(('127.0.0.1', 8734), functools.partial(Cors, directory=GALLERY))
threading.Thread(target=srv.serve_forever, daemon=True).start()
B='http://127.0.0.1:9350'; APP='http://localhost:8731/index.html'
ok=[0,0]
def check(name,cond,detail=''):
    ok[0 if cond else 1]+=1; print(('PASS ' if cond else 'FAIL ')+name+('' if cond else '  '+str(detail)))
async def main():
    t=json.load(urllib.request.urlopen(urllib.request.Request(B+'/json/new?about:blank',method='PUT')))
    ws=await websockets.connect(t['webSocketDebuggerUrl'],max_size=None); n=[0]; logs=[]
    async def cmd(m,p=None):
        n[0]+=1;i=n[0]; await ws.send(json.dumps({'id':i,'method':m,'params':p or {}}))
        while True:
            r=json.loads(await ws.recv())
            if r.get('method')=='Runtime.exceptionThrown': logs.append(json.dumps(r['params'])[:600])
            if r.get('id')==i: return r.get('result',{})
    async def ev(js):
        r=await cmd('Runtime.evaluate',{'expression':js,'returnByValue':True,'awaitPromise':True})
        if 'exceptionDetails' in r: return 'JSERR '+str(r['exceptionDetails'].get('exception',{}).get('description'))
        return r.get('result',{}).get('value')
    async def wait(js, secs=60):
        t0=time.time()
        while time.time()-t0<secs:
            v=await ev(js)
            if v: return v
            await asyncio.sleep(0.25)
        return None
    RC="app.panels().find($p=>app.widgetOf($p)==='runControl'&&$p.panel('ref')==='models/growth').panel('content')"
    st=lambda: ev("(()=>{const s=%s.find('.slx-run-status');return [s.attr('class').replace('slx-run-status','').trim(), s.text()]})()" % RC)
    await cmd('Page.enable'); await cmd('Runtime.enable')
    await cmd('Page.addScriptToEvaluateOnNewDocument',{'source':'window.alert=function(){};window.confirm=function(){return true};'})
    await cmd('Page.navigate',{'url':APP+'?newuser=fresh&demos'}); await asyncio.sleep(6)
    await ev("document.dispatchEvent(new KeyboardEvent('keydown',{key:'x'}))")
    await ev("Sienna.documents.openOrShow(app,'models/growth')"); await asyncio.sleep(2)
    s=await st()
    check('a model of ones own: green, ready to run, before any Load', s[0]=='slx-run-go' and s[1].startswith('Ready to run'), s)
    check('no Load in its own Simulation panel', await ev(RC+".find('button').filter((i,b)=>b.textContent==='load').length")==0)
    check('▶ enabled', await ev(RC+".find('.slx-run-btn').eq(1).prop('disabled')") is False)
    check('no plots: nothing ran by itself', await ev("Sienna.Simulation.status") in ('idle',''), await ev("Sienna.Simulation.status"))
    # set Execute for 20 before preparing
    await ev(RC+".find('.slx-run-field').filter((i,f)=>$(f).find('.slx-run-label').text()==='Execute for').find('input').val('20').trigger('change')")
    check('a setting typed before ▶ is kept', await ev(RC+".find('.slx-run-field').filter((i,f)=>$(f).find('.slx-run-label').text()==='Execute for').find('input').val()")=='20')
    # Every class the status line takes, as it takes it: a compiled model kept
    # from an earlier run prepares faster than a poll would see.
    await ev("window.__seen=[]; (()=>{const e="+RC+".find('.slx-run-status')[0]; new MutationObserver(()=>__seen.push(e.className)).observe(e,{attributes:true,childList:true,characterData:true,subtree:true})})(); 1")
    await ev(RC+".find('.slx-run-btn').eq(1).click()")
    seen=set(); t0=time.time()
    while time.time()-t0<60:
        s=await st(); seen.add(s[0])
        if s[0]=='slx-run-go' and s[1].startswith('Ready —') and await ev("Sienna.Simulation.settings.current")==20: break
        await asyncio.sleep(0.2)
    seen |= set(c for x in await ev("__seen") for c in x.split() if c.startswith('slx-run-'))
    check('▶ prepares (orange) and runs to 20, then green', 'slx-run-busy' in seen and s[0]=='slx-run-go' and await ev("Sienna.Simulation.settings.current")==20, (s, seen))
    # make it incomplete
    await ev("(()=>{const m=Sienna.userData.get('models/growth');const id=Object.keys(m.nodes).find(k=>m.nodes[k].type==='valve');Sienna.userData.set('models/growth/nodes/'+id+'/props/rate','');})()")
    await asyncio.sleep(1.2); s=await st()
    check('an incomplete model: red, says how many', s[0]=='slx-run-error' and 'incomplete' in s[1], s)
    check('▶ greyed while it is', await ev(RC+".find('.slx-run-btn').eq(1).prop('disabled')") is True)
    await ev("(()=>{const m=Sienna.userData.get('models/growth');const id=Object.keys(m.nodes).find(k=>m.nodes[k].type==='valve');Sienna.userData.set('models/growth/nodes/'+id+'/props/rate','k * biomass');})()"); await asyncio.sleep(1.2); s=await st()
    check('put right: green again', s[0]=='slx-run-go', s)
    # a plot, then Use as default
    await ev("app.addPanel({widget:'plotter',ref:'models/growth',options:{variables:['biomass']}})"); await asyncio.sleep(1.5)
    await ev("app.addPanel({widget:'metadata',ref:'models/growth'})"); await asyncio.sleep(1.5)
    MD="$('.slx-meta')"
    await ev(MD+".find('button').filter((i,b)=>b.textContent.startsWith('Use')).click()"); await asyncio.sleep(0.5)
    pr=await ev("JSON.stringify(Sienna.userData.get('models/growth/presentation'))")
    check('Use the displays open now: kept in the model spec', pr and '"plotter"' in pr and '"runLength":20' in pr, pr)
    txt=await ev(MD+".find('.slx-meta-present').text()")
    check('said in words', 'a plot of biomass' in (txt or '') and 'run for 20' in (txt or ''), txt)
    await ev("Sienna.history.undo()"); await asyncio.sleep(0.3)
    check('undone', await ev("Sienna.userData.get('models/growth/presentation')") is None)
    await ev("Sienna.history.redo()"); await asyncio.sleep(0.3)
    await ev("app.persist && app.persist()"); await asyncio.sleep(0.5)
    await cmd('Page.reload'); await asyncio.sleep(6)
    v=await ev("JSON.stringify(app.panels().filter($p=>app.widgetOf($p)==='plotter').map($p=>$p.panel('content').plotter('instance').variableNames()))")
    check('a plot keeps its variables over a reload', v=='[["biomass"]]', v)
    # close growth and open again: defaults apply
    await ev("app.windows().filter($w=>$w.panel('ref')==='models/growth').forEach($w=>$w.panel('close'))"); await asyncio.sleep(1)
    await ev("Sienna.documents.openOrShow(app,'models/growth')")
    ran=await wait("Sienna.Simulation.modelPath==='models/growth' && Sienna.Simulation.status==='ready' && Sienna.Simulation.settings.current==20", 60)
    check('opened again: its default plot, run once to 20', ran and await ev("app.panels().filter($p=>app.widgetOf($p)==='plotter'&&$p.panel('ref')==='models/growth').length")==1, await ev("JSON.stringify([Sienna.Simulation.status,Sienna.Simulation.settings])"))
    # ---- the gallery's models, from the Sample models panel
    names = json.load(open(os.path.join(GALLERY, 'models', 'index.json')))['models']
    for name in names:
        m = json.load(open(os.path.join(GALLERY, 'models', name, name + '.json')))
        pr = m.get('presentation')
        if not pr: continue
        await cmd('Page.navigate', {'url': APP + '?newuser=fresh&gallery=http://localhost:8734/'}); await asyncio.sleep(5)
        await ev("document.dispatchEvent(new KeyboardEvent('keydown',{key:'x'}))")
        await wait("document.querySelectorAll('button[data-open]').length", 20)
        await ev("[...document.querySelectorAll('button[data-open]')].find(b=>b.dataset.open.endsWith('/%s.json')).click()" % name)
        want = pr['run'].get('runLength')
        done = await wait("Sienna.Simulation.status==='ready' && Number(Sienna.Simulation.settings.current)===%s" % want, 90)
        plots = await ev("JSON.stringify(app.panels().filter($p=>app.widgetOf($p)==='plotter').map($p=>$p.panel('content').plotter('instance')._series.map(s=>[s.label, s.pts.length + Object.keys(s.lines||{}).length])))")
        nplots = sum(1 for d in pr['displays'] if d['widget'] == 'plotter')
        p = json.loads(plots or '[]')
        check(name + ': opens with its %d plot(s), run to %s, each drawn' % (nplots, want),
              done and len(p) == nplots and all(all(x[1] > 0 for x in pl) for pl in p), plots)
        cls = await ev("document.querySelector('.slx-run-status').className")
        check(name + ': and its status green', 'slx-run-go' in (cls or ''), cls)
    for l in logs: print('LOG',l)
    print('%d passed, %d failed' % tuple(ok))
asyncio.run(main())
sys.exit(1 if ok[1] else 0)
