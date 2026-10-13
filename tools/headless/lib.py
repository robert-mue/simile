async def defsim():
    await ev("window.__sim=()=>{const c=Sienna.documents.current(app); const p=app.panels().find(p=>p.panel('ref')===c&&/: Simulation$/.test(p.panel('title'))); return p?p[0]:document}")
async def at(sel_js):
    r = await ev("(()=>{const e=("+sel_js+"); if(!e) return null; const b=e.getBoundingClientRect(); return [b.x+b.width/2,b.y+b.height/2,b.width,b.height]})()")
    return r
async def menu(*labels):
    for l in labels:
        p = await at("[...document.querySelectorAll('.slx-menu-label')].find(e=>e.textContent.trim()===%r && e.offsetParent)" % l)
        if not p: print('no menu', l); return
        await click(p[0],p[1]); await sleep(0.3)
async def tool(name):
    p = await at("[...(app.panels().find(p=>p.panel('ref')===Sienna.documents.current(app)&&app.widgetOf(p)==='diagram')||$())[0].querySelectorAll('.slx-palette button')].find(e=>e.textContent.trim()===%r && e.offsetParent)" % name)
    await click(p[0],p[1])
async def node(label):
    return await at("(()=>{const m=Sienna.userData.get(Sienna.documents.current(app)); const id=Object.keys(m.nodes).find(k=>m.nodes[k].label===%r); return (app.panels().find(p=>p.panel('ref')===Sienna.documents.current(app)&&app.widgetOf(p)==='diagram')||$())[0].querySelector('.slx-diagram [data-id='+id+']')})()" % label)
async def dlg(label):
    a = await node(label)
    await click(a[0],a[1]); await sleep(0.1); await click(a[0],a[1]); await sleep(0.6)
async def ok():
    await ev("document.querySelector('[data-act=ok]').scrollIntoView({block:'nearest'})")
    p = await at("document.querySelector('[data-act=ok]')"); await click(p[0],p[1]); await sleep(0.5)
async def typekeys(s):
    for ch in s:
        await cmd('Input.dispatchKeyEvent',{'type':'keyDown','key':ch,'text':ch})
        await cmd('Input.dispatchKeyEvent',{'type':'keyUp','key':ch})
async def enter(): await press('Enter','Enter',13); await sleep(0.3)
async def canvas_shot(name, pad=40, scale=1.5):
    r = await ev("(()=>{const g=document.querySelector('.slx-diagram svg g[data-id]').ownerSVGElement; let b=null; g.querySelectorAll('[data-id]').forEach(e=>{const r=e.getBoundingClientRect(); if(!r.width&&!r.height) return; b=b?{l:Math.min(b.l,r.left),t:Math.min(b.t,r.top),r:Math.max(b.r,r.right),b:Math.max(b.b,r.bottom)}:{l:r.left,t:r.top,r:r.right,b:r.bottom}}); return b})()")
    await shot(name,(r['l']-pad, r['t']-pad, r['r']-r['l']+2*pad, r['b']-r['t']+2*pad), scale)
async def waitready():
    for i in range(80):
        s = await ev("__sim().querySelector('.slx-run-status').textContent")
        if s.startswith('Ready'): return s
        await sleep(0.5)
    return s
async def field(label, val):
    p = await at("[...__sim().querySelectorAll('.slx-run-field')].find(r=>r.querySelector('.slx-run-label').textContent===%r).querySelector('input')" % label)
    await click(p[0],p[1]); await ev("document.activeElement.select()"); await typekeys(val); await press('Tab','Tab',9); await sleep(0.3)
async def curtime(): return await ev("[...__sim().querySelectorAll('.slx-run-field')][1].querySelector('input').value")
async def runall():
    play = await at("__sim().querySelectorAll('.slx-run-btn')[1]"); await click(play[0],play[1]); await sleep(1.5)
    for i in range(120):
        st = await ev("Sienna.Simulation.status")
        if st != 'running' and st != 'loading': break
        await sleep(0.5)
    await sleep(0.8)
async def win(t):
    await menu('View'); await menu('Windows'); await menu(t); await sleep(0.6)
async def expr(text):
    ta = await at("document.querySelector('textarea.slx-expression')"); await click(ta[0],ta[1]); await ev("document.activeElement.select()"); await typekeys(text)
async def seteq(label, text):
    await dlg(label); await expr(text); await ok()
async def dlgshot(name):
    r = await ev("(()=>{const b=document.querySelector('.slx-dlg').getBoundingClientRect(); return [b.x,b.y,b.width,b.height]})()")
    await shot(name,(r[0]-4,r[1]-4,r[2]+8,r[3]+8))
async def flow_from(x0,y0,x1,y1,name):
    await tool('flow'); await drag([(x0,y0),((x0+x1)/2,(y0+y1)/2),(x1,y1)]); await sleep(0.3); await typekeys(name); await enter()
async def influence(a,b):
    p = await node(a); q = await node(b)
    await tool('influence'); await drag([(p[0],p[1]),((p[0]+q[0])/2+5,(p[1]+q[1])/2+5),(q[0],q[1])]); await sleep(0.3)
async def place(kind, x, y, name):
    await tool(kind); await click(x,y); await sleep(0.3); await typekeys(name); await enter()
async def addplot(varname):
    await menu('Widgets'); await menu('Plotter'); await sleep(1.2)
    # choose the variable in the newest plotter
    await ev("(()=>{const ps=[...__sim().querySelectorAll('.slx-plot')]; const p=ps[ps.length-1]; const s=p.querySelector('select'); const o=[...s.options].find(o=>o.textContent.replace(/  \(from the next run\)$/,'')===%r); s.value=o.value; })()" % varname)
    b = await at("(()=>{const ps=[...__sim().querySelectorAll('.slx-plot')]; return [...ps[ps.length-1].querySelectorAll('button')].find(e=>e.textContent==='add')})()")
    await click(b[0],b[1]); await sleep(0.3)
async def series():
    return await ev("JSON.stringify([...__sim().querySelectorAll('.slx-plot')].map(p=>$(p).plotter('instance')._series.map(s=>s.label+': '+s.pts.length+' pts, last '+(s.pts.length?s.pts[s.pts.length-1].map(v=>+v.toFixed(2)).join('@'):''))))")
async def subdlg(sid='submodel1'):
    r = await ev("(()=>{const e=document.querySelector('.slx-diagram [data-id=%s]'); const b=e.getBoundingClientRect(); return [b.x,b.y,b.width,b.height]})()" % sid)
    x, y = r[0]+r[2]-12, r[1]+r[3]-12
    await click(x,y); await sleep(0.1); await click(x,y,2); await sleep(0.6)
