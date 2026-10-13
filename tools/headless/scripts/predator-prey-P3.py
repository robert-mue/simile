exec(open('lib.py').read(), globals())
await defsim()
before = await ev("JSON.stringify([...document.querySelectorAll('.slx-plot')].map(p=>$(p).plotter('instance')._series[0].pts.map(q=>+q[1].toFixed(3))))")
async def arcmid(fromL, toL, frac=0.5):
    return await ev("""(()=>{const m=Sienna.userData.get(Sienna.documents.current(app)); const id=k=>Object.keys(m.nodes).find(n=>m.nodes[n].label===k);
      const a=Object.keys(m.arcs).find(k=>m.arcs[k].type==='influence'&&m.arcs[k].from===id(%r)&&m.arcs[k].to===id(%r));
      const p=document.querySelector('.slx-diagram path.slx-arc[data-id='+a+']'); const L=p.getTotalLength(); const c=p.getScreenCTM();
      for (const f of [0.5,0.4,0.6,0.3,0.7,0.25,0.75]) { const pt=p.getPointAtLength(L*f); const x=pt.x*c.a+pt.y*c.c+c.e, y=pt.x*c.b+pt.y*c.d+c.f;
        const e=document.elementFromPoint(x,y); if (e && e.getAttribute('data-id')===a) return [x,y]; }
      return null})()""" % (fromL, toL))
async def delarc(fromL, toL):
    p = await arcmid(fromL, toL); await click(p[0],p[1]); await sleep(0.3)
    sel = await ev("$('.slx-diagram').diagram('instance')._sel.join(',')")
    if fromL == 'rabbits': await canvas_shot('pp/s3-selected.png')
    await press('Delete','Delete',46); await sleep(0.3)
    return sel
print('del1', await delarc('rabbits','predation'))

print('del2', await delarc('predation','fox_repro'))
print('influences:', await ev("JSON.stringify(Object.values(Sienna.userData.get(Sienna.documents.current(app)).arcs).filter(a=>a.type==='influence').map(a=>a.alias))"))
await place('variable', 470, 430, 'eaten_per_fox')
await place('variable', 180, 430, 'rfox')
await influence('rabbits','eaten_per_fox')
await influence('eaten_per_fox','rfox')
await influence('eaten_per_fox','predation')
await influence('rfox','fox_repro')
await influence('foxes','fox_repro')
await seteq('eaten_per_fox','0.01*rabbits')
await seteq('rfox','0.01*eaten_per_fox')
await seteq('predation','eaten_per_fox*foxes')
await seteq('fox_repro','rfox*foxes')
await click(600,650); await canvas_shot('pp/s3-diagram.png')
print('incomplete:', await ev("$('.slx-diagram .slx-incomplete').length"))
await win('Predator-prey: Simulation')
await runall()
after = await ev("JSON.stringify([...document.querySelectorAll('.slx-plot')].map(p=>$(p).plotter('instance')._series[0].pts.map(q=>+q[1].toFixed(3))))")
print('same results as stage 2:', before == after, len(before), len(after))
await shot('pp/s3-run.png')
