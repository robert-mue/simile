exec(open('lib.py').read(), globals())
await defsim()
import math
await win('Predator-prey: Model')
async def tab(name):
    t = await at("[...document.querySelectorAll('.slx-dlg .slx-dlg-tab')].find(e=>e.textContent===%r)" % name); await click(t[0],t[1]); await sleep(0.3)
async def lim(k,v):
    p = await at("document.querySelector('.slx-sketch-lim[data-lim=%s]')" % k); await click(p[0],p[1]); await ev("document.activeElement.select()"); await typekeys(v); await press('Tab','Tab',9); await sleep(0.2)
async def sketch(fn):
    pad = await ev("(()=>{const b=document.querySelector('.slx-sketch-svg').getBoundingClientRect(); return [b.x,b.y,b.width,b.height]})()")
    pts=[(pad[0]+1+u/80*(pad[2]-2), pad[1]+pad[3]*(1-fn(u/80))) for u in range(0,81)]
    await drag(pts); await sleep(0.3)
async def clear_eq():
    ta = await at("document.querySelector('textarea.slx-expression')"); await click(ta[0],ta[1]); await ev("document.activeElement.select()"); await press('Backspace','Backspace',8); await sleep(0.2)

# eaten_per_fox
await dlg('eaten_per_fox'); await clear_eq()
await dlgshot('pp/s4-cleared.png')
await tab('Graph'); await dlgshot('pp/s4-graph-new.png')
await lim('xmax','10000'); await lim('ymax','100')
E=[(0,0),(0.05,0.12),(0.1,0.22),(0.2,0.38),(0.3,0.5),(0.4,0.58),(0.5,0.65),(0.6,0.7),(0.7,0.74),(0.8,0.78),(0.9,0.8),(1,0.81)]
def eaten(u):
    for (a,fa),(b,fb) in zip(E,E[1:]):
        if u<=b: return fa+(fb-fa)*(u-a)/(b-a)
    return E[-1][1]
await sketch(eaten)
await ev('document.activeElement.blur()'); await dlgshot('pp/s4-graph-eaten.png')
await tab('Equation'); await dlgshot('pp/s4-eq-eaten.png')
print('eaten eq:', await ev("$('.slx-dlg textarea.slx-expression').val()"))
await ok()
# rfox
await dlg('rfox'); await clear_eq(); await tab('Graph')
await lim('xmax','100'); await lim('ymax','1')
await sketch(lambda u: 0 if u < 0.12 else min(0.8,(u-0.12)/0.58*0.8))
await ev('document.activeElement.blur()'); await dlgshot('pp/s4-graph-rfox.png')
await tab('Equation')
print('rfox eq:', await ev("$('.slx-dlg textarea.slx-expression').val()"))
await ok()
print('dialogs', await ev("$('.slx-dlg').length"), 'incomplete', await ev("$('.slx-diagram .slx-incomplete').length"))
await win('Predator-prey: Simulation')
await runall()
print('s4', await series())
await shot('pp/s4-run.png')
