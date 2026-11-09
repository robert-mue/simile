exec(open('lib.py').read(), globals())
# Builds Tutorial 1, Bank account (help/tutorials/bank-account.html), from a
# fresh new-user session, step by step as the text says, and takes its
# pictures (ba/…, the names the tutorial uses). Prints what it checks: the
# values the text quotes ($618.75 after 10 years, $1,445.50 after 20,
# $1,010.63 at 15%).
async def desel():
    await ev("$('.slx-diagram').diagram('instance')._sel=[]; $('.slx-diagram').diagram('instance')._render()")
async def hover(label):
    p = await at("[...document.querySelectorAll('.slx-menu-label')].find(e=>e.textContent.trim()===%r && e.offsetParent)" % label)
    await mouse('mouseMoved', p[0], p[1], 'none', buttons=0); await sleep(0.3)
async def menu_shot(name, minw=420, minh=0):
    # The menu bar's left end and every open menu below it.
    r = await ev("(()=>{let r=0,b=0; document.querySelectorAll('.slx-menu-list .slx-submenu').forEach(s=>{ if(!s.offsetParent) return; const q=s.getBoundingClientRect(); r=Math.max(r,q.right); b=Math.max(b,q.bottom); }); return [r,b]})()")
    await shot(name, (0, 0, max(minw, r[0] + 20), max(minh, r[1] + 12)))
async def closemenus():
    await press('Escape', 'Escape', 27); await mouse('mouseMoved', 900, 600, 'none', buttons=0); await sleep(0.3)
async def panel_shot(name, title):
    r = await ev("(()=>{const p=[...document.querySelectorAll('.slx-panel')].find(p=>$(p).panel('option','title')===%r); const b=p.getBoundingClientRect(); return [b.x,b.y,b.width,b.height]})()" % title)
    await shot(name, (r[0], r[1], r[2], min(r[3], 200)))
async def dlgtop():
    # Scroll the dialog back to its tabs, so the FUNCTIONS and VARIABLES
    # lists show above the equation, as the captions describe.
    await ev("(()=>{let e=document.querySelector('.slx-dlg textarea.slx-expression'); while(e&&e!==document.body){ if(e.scrollHeight>e.clientHeight+2&&/(auto|scroll)/.test(getComputedStyle(e).overflowY)) e.scrollTop=0; e=e.parentElement;} })()"); await sleep(0.2)
async def account():
    return await ev("(()=>{const p=$(__sim().querySelector('.slx-plot')).plotter('instance'); const s=p._series[0]; const q=s.pts[s.pts.length-1]; return q[0]+'@'+q[1].toFixed(2)})()")

# ---------------- Step 1
await nav('file:///home/user/Projects/simile/index.html?newuser=fresh'); await sleep(2.5)
await menu('File'); await hover('New model'); await menu_shot('ba/01-file-menu.png', 420, 330)
await menu('New model'); await sleep(1.5); await defsim()
await ev("window.prompt=()=>'Bank account'")
await menu('File'); await hover('Rename model…'); await menu_shot('ba/01b-file-rename.png', 420, 420)
await menu('Rename model…'); await sleep(0.6)
await mouse('mouseMoved', 900, 600, 'none', buttons=0); await sleep(0.3)
await shot('ba/02-new-model.png')

# ---------------- Step 2
await tool('stock'); await click(330, 440); await sleep(0.3); await typekeys('account')
r = await at("document.querySelector('.slx-label-edit')")
await shot('ba/03-stock.png', (r[0] - 124, r[1] - 150, 248, 225))
await enter()
a = await node('account')
await flow_from(a[0] - 200, a[1], a[0], a[1], 'interest')
await flow_from(a[0], a[1], a[0] + 200, a[1], 'withdrawal')
await desel(); await canvas_shot('ba/04-flows.png')
i = await node('interest')
await tool('variable'); await click(i[0] - 20, i[1] - 120); await sleep(0.3); await typekeys('interest rate'); await enter()
r = await ev("(()=>{const e=document.querySelector('.slx-label-edit').getBoundingClientRect(); const f=document.querySelector('.slx-flash'); const g=f?f.getBoundingClientRect():e; return [Math.min(e.left,g.left),Math.min(e.top,g.top),Math.max(e.right,g.right),Math.max(e.bottom,g.bottom)]})()")
await shot('ba/05a-bad-name.png', (r[0] - 60, r[1] - 60, r[2] - r[0] + 120, r[3] - r[1] + 120))
await ev("document.querySelector('.slx-label-edit').select()"); await typekeys('interest_rate'); await enter()
await desel(); await canvas_shot('ba/05-variable.png')
await influence('account', 'interest'); await influence('interest_rate', 'interest')
await desel(); await canvas_shot('ba/06-influences.png')
# Bend the influence from account up, clear of the flow.
p = await ev("""(()=>{const m=Sienna.userData.get(Sienna.documents.current(app)); const id=k=>Object.keys(m.nodes).find(n=>m.nodes[n].label===k);
  const a=Object.keys(m.arcs).find(k=>m.arcs[k].type==='influence'&&m.arcs[k].from===id('account'));
  const p=document.querySelector('.slx-diagram path.slx-arc[data-id='+a+']'); const L=p.getTotalLength(); const c=p.getScreenCTM(); const pt=p.getPointAtLength(L*0.5);
  return [pt.x*c.a+pt.y*c.c+c.e, pt.x*c.b+pt.y*c.d+c.f]})()""")
await drag([(p[0], p[1]), (p[0], p[1] - 30), (p[0], p[1] - 60)])
await desel(); await canvas_shot('ba/07-arranged.png')

# ---------------- Step 3
await dlg('account'); await expr('300'); await dlgtop(); await dlgshot('ba/08-dlg-account.png'); await ok()
await dlg('interest'); await expr('account*interest_rate'); await dlgtop(); await dlgshot('ba/09-dlg-interest.png'); await ok()
await seteq('withdrawal', '10'); await seteq('interest_rate', '0.1')
await desel(); await canvas_shot('ba/10-complete.png')
print('incomplete', await ev("$('.slx-diagram .slx-incomplete').length"), 'dialogs', await ev("$('.slx-dlg').length"))

# ---------------- Step 4
await win('Bank account: Simulation')
await shot('ba/11-simulation.png')
b = await at("[...__sim().querySelectorAll('.slx-run button')].find(e=>e.textContent==='load')"); await click(b[0], b[1]); await sleep(0.5)
print(await waitready())
await field('Time step(s)', '1'); await field('Execute for', '10')
await panel_shot('ba/12-runcontrol.png', 'Bank account: runControl/1')

# ---------------- Step 5
await menu('Widgets'); await hover('Plotter'); await menu_shot('ba/13-widgets-menu.png', 500, 300)
await closemenus()
await addplot('account')

# ---------------- Step 6
await runall(); print('after 10 years', await account())
await shot('ba/17-run10.png')
await runall(); print('after 20 years', await account())
await shot('ba/18-run20.png')

# ---------------- Step 7
await win('Bank account: Model')
await seteq('interest_rate', '0.15')
await win('Bank account: Simulation')
await panel_shot('ba/19-edited.png', 'Bank account: runControl/1')
await runall(); print('at 15%, after 10 years', await account())
await shot('ba/20-rerun.png')

# ---------------- Step 8
await menu('File'); await hover('Save model as file…'); await menu_shot('ba/21-file-save.png', 420, 460)
await closemenus()
await menu('File'); await menu('Recent'); await sleep(0.3); await hover('Bank account')
await menu_shot('ba/22-file-recent.png', 700, 600)
await closemenus()
