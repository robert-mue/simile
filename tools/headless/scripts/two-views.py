exec(open('lib.py').read(), globals())
# Two diagrams of one model: a gesture in one is FOLLOWED by the other while
# it is in progress (sienna's userData.announce; `_follow` in
# src/widgets/diagram.js), with nothing written until the drop, one write
# then, and a click or a cancelled drag leaving the other view as it was.
# Every gesture: an element, a submodel, a label, an arrow's bend, a
# submodel's edge, a port. Over http (tools/serve.py); a new-user preview, so
# the real store is not touched. PASS/FAIL lines.
ok = [0, 0]
def check(name, c, detail=''):
    ok[0 if c else 1] += 1; print(('PASS ' if c else 'FAIL ') + name + ('' if c else '  ' + str(detail)))
def near(a, b, tol=3): return bool(a and b) and abs(a[0]-b[0]) <= tol and abs(a[1]-b[1]) <= tol
async def press_move(x0, y0, steps):
    await mouse('mouseMoved', x0, y0, 'none', buttons=0); await mouse('mousePressed', x0, y0)
    for (x, y) in steps: await mouse('mouseMoved', x, y, buttons=1); await sleep(0.03)
    await sleep(0.2)
async def release(x, y): await mouse('mouseReleased', x, y); await sleep(0.4)

async def two_views(M):
    await nav('http://localhost:8731/index.html?newuser=fresh'); await sleep(3)
    await ev("Sienna.documents.open(app,%r); 1" % M); await sleep(2)
    await menu('Widgets', 'Diagram'); await sleep(2)
    P = "app.panels().filter(p=>p.panel('ref')===%r&&app.widgetOf(p)==='diagram')" % M
    await ev("window.__P=()=>%s; window.__w=0; Sienna.userData.subscribe(%r, ()=>window.__w++); 1" % (P, M))
    check(M + ': two diagrams open', await ev("__P().length") == 2)
async def centre(i, sel):
    return await ev("(()=>{const e=__P()[%d][0].querySelector(%r); if(!e) return null; const b=e.getBoundingClientRect(); return [b.x+b.width/2,b.y+b.height/2]})()" % (i, sel))
async def k(i): return await ev("__P()[%d].find('.slx-diagram').diagram('instance')._view.k" % i)
async def written(): return await ev('window.__w')
async def unwritten(): await ev('window.__w=0; 1')

# ---- Growth: an element, an arrow's bend, a label, a click, a cancel
await two_views('models/growth')
k0, k1 = await k(0), await k(1)
a0 = await centre(0, '[data-id=node4]'); b0 = await centre(1, '[data-id=node4]')
await press_move(a0[0], a0[1], [(a0[0]+10, a0[1]+5), (a0[0]+30, a0[1]+15), (a0[0]+40, a0[1]+20)])
want = (b0[0] + 40/k0*k1, b0[1] + 20/k0*k1)
check('element: the other view follows mid-drag', near(await centre(1, '[data-id=node4]'), want), (b0, want))
check('element: nothing written mid-drag', await written() == 0)
await release(a0[0]+40, a0[1]+20)
check('element: written at the drop', await written() >= 1)
check('element: the other view drawn from the model after it', near(await centre(1, '[data-id=node4]'), want)
      and await ev("__P()[1][0].querySelectorAll('.slx-ghost-carried,.slx-ghost').length") == 0)

await unwritten()
arc = await ev("(()=>{const m=Sienna.userData.get('models/growth'); return Object.keys(m.arcs).find(a=>m.arcs[a].type==='influence')})()")
sel = "path.slx-arc[data-id=%s]" % arc
d1 = await ev("__P()[1][0].querySelector(%r).getAttribute('d')" % sel)
m = await ev("(()=>{const p=__P()[0][0].querySelector(%r); const L=p.getTotalLength(); const c=p.getScreenCTM(); const q=p.getPointAtLength(L/2); return [q.x*c.a+q.y*c.c+c.e, q.x*c.b+q.y*c.d+c.f]})()" % sel)
await press_move(m[0], m[1], [(m[0]+5, m[1]-5), (m[0]+15, m[1]-25), (m[0]+20, m[1]-35)])
g1 = await ev("(()=>{const g=__P()[1][0].querySelector('path[data-ghost-for=%s]'); return g && g.getAttribute('d')})()" % arc)
check('bend: the other view draws it mid-drag', bool(g1) and g1 != d1, (d1, g1))
check('bend: nothing written mid-drag', await written() == 0)
await release(m[0]+20, m[1]-35)
check('bend: the other view has it after the drop', await ev("__P()[1][0].querySelector(%r).getAttribute('d')" % sel) != d1)

await unwritten()
lb0 = await centre(1, '[data-label-for=node1]'); la = await centre(0, '[data-label-for=node1]')
await press_move(la[0], la[1], [(la[0]+5, la[1]+5), (la[0]+20, la[1]+16), (la[0]+30, la[1]+24)])
want = (lb0[0] + 30/k0*k1, lb0[1] + 24/k0*k1)
check('label: the other view follows mid-drag', near(await centre(1, '[data-label-for=node1]'), want))
check('label: nothing written mid-drag', await written() == 0)
await release(la[0]+30, la[1]+24)
check('label: where it was dropped, after the drop', near(await centre(1, '[data-label-for=node1]'), want))

await ev("window.__r=0; const D=__P()[1].find('.slx-diagram').diagram('instance'); const o=D._render.bind(D); D._render=()=>{window.__r++; o();}; 1")
c = await centre(0, '[data-id=node4]'); await click(c[0], c[1]); await sleep(0.4)
check('a click in one view does not redraw the other', await ev('window.__r') == 0, await ev('window.__r'))

c = await centre(0, '[data-id=node4]'); b0 = await centre(1, '[data-id=node4]')
await press_move(c[0], c[1], [(c[0]+20, c[1]), (c[0]+40, c[1])])
await ev("document.dispatchEvent(new PointerEvent('pointercancel', {bubbles:true})); 1"); await sleep(0.4)
await mouse('mouseReleased', c[0]+40, c[1]); await sleep(0.3)
check('a cancelled drag: the other view put back', near(await centre(1, '[data-id=node4]'), b0, 2))

# ---- Plant: a submodel's edge, a port, a whole submodel
await two_views('models/plant')
await ev("""window.__box=(i)=>{const g=__P()[i][0].querySelector('.slx-submodel[data-id=submodel1]'); const r=[...g.querySelectorAll(':scope > rect:not(.slx-resize)')].pop(); const b=r.getBoundingClientRect(); return [b.x,b.y,b.width,b.height]}; 1""")
h = await ev("(()=>{for (const ed of ['s','n','e','w']) { const e=__P()[0][0].querySelector('[data-id=submodel1] .slx-resize-'+ed); const b=e.getBoundingClientRect(); const x=b.x+b.width/2, y=b.y+b.height/2; if (document.elementFromPoint(x,y)===e) return [x,y,ed]; } return null})()")
D = {'s': (0, 1), 'n': (0, -1), 'e': (1, 0), 'w': (-1, 0)}[h[2]]
await unwritten()
s0 = await ev('__box(1)')
await press_move(h[0], h[1], [(h[0]+s*D[0], h[1]+s*D[1]) for s in (10, 25, 40)])
sm = await ev('__box(1)')
check('resize: the other view follows mid-drag', abs(sm[2]-s0[2]) + abs(sm[3]-s0[3]) > 10, (s0, sm))
check('resize: nothing written mid-drag', await written() == 0)
await release(h[0]+40*D[0], h[1]+40*D[1])
sd = await ev('__box(1)')
check('resize: the new size after the drop', abs(sd[2]-sm[2]) < 2 and abs(sd[3]-sm[3]) < 2, (sm, sd))

await unwritten()
pk = 'ports/submodel1/node1'
pa = await centre(0, '[data-port="%s"]' % pk); pb = await centre(1, '[data-port="%s"]' % pk)
await press_move(pa[0], pa[1], [(pa[0], pa[1]+s) for s in (5, 15, 30)])
pm = await centre(1, '[data-port="%s"]' % pk)
check('port: the other view follows mid-drag', pm and abs(pm[1]-pb[1]) > 5, (pb, pm))
check('port: nothing written mid-drag', await written() == 0)
await release(pa[0], pa[1]+30)
check('port: where it was dropped, after the drop', near(await centre(1, '[data-port="%s"]' % pk), pm, 2))

s0 = await ev("(()=>{const b=__P()[0][0].querySelector('.slx-submodel[data-id=submodel1]').getBoundingClientRect(); return [b.x,b.y,b.width,b.height]})()")
t0 = await ev('__box(1)')
x, y = s0[0] + s0[2]/2, s0[1] + s0[3] - 20
await press_move(x, y, [(x+s, y+s) for s in (5, 20, 35)])
tm = await ev('__box(1)')
check('submodel: the other view follows mid-drag', tm[0] > t0[0] + 5, (t0, tm))
await release(x+35, y+35)
check('submodel: where it was dropped, after the drop', near(await ev('__box(1)'), tm, 2))
print(ok[0], 'passed,', ok[1], 'failed')
