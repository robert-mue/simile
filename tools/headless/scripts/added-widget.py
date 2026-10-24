# Widgets the user adds: examples/widgets/big-number.js (written from the
# brief for an AI assistant alone) added by URL to a fresh session, shown on
# Growth as it runs, then broken on purpose to see its error on the panel.
# Over http (tools/serve.py). Prints PASS/FAIL lines.
import json
B='http://localhost:8731/'
await nav(B+'index.html?newuser=fresh'); await sleep(4)
async def check(what, ok, got): print(('PASS ' if ok else 'FAIL ') + what + ('' if ok else '  got: ' + str(got)))
await ev("Sienna.documents.openOrShow(app, 'models/growth')"); await sleep(3)
await ev("Sienna.addedWidgets.add({url:%s})" % json.dumps(B+'examples/widgets/big-number.js')); await sleep(1)
said = await ev("document.querySelector('.slx-dialog').innerText")
await check('added by URL', 'Big number' in (said or ''), said)
await ev("document.querySelectorAll('.slx-dialog-overlay').forEach(o=>o.remove())")
await ev("app.addPanel({title:'Big', widget:'bigNumber', ref:'models/growth'})"); await sleep(1.5)
await check('opens with no model loaded', await ev("$('.bigNumber-num').text()") == 'Run the model to see values', await ev("$('.bigNumber-num').text()"))
await ev("(()=>{const v=Sienna.Simulation.viewFor('models/growth'); return v.loadOwn('models/growth').then(()=>{v.start(); return 1})})()")
for i in range(80):
    if await ev("Sienna.Simulation.status") == 'ready' and i > 2: break
    await sleep(0.5)
opts = await ev("$('.bigNumber-bar select option').map((i,o)=>o.textContent).get().join(',')")
await check('lists the variables once loaded', 'biomass' in opts, opts)
await ev("(()=>{const s=$('.bigNumber-bar select'); s.val(s.find('option').filter((i,o)=>o.textContent==='biomass').val()).trigger('change')})()"); await sleep(1)
v = await ev("$('.bigNumber-num').text()")
await check('shows a value at once (query)', v == '210000', v)
await ev("(()=>{const v=Sienna.Simulation.viewFor('models/growth'); return v.reset().then(()=>{v.start(); return 1})})()"); await sleep(3)
t = await ev("$('.bigNumber-time').text()")
await check('follows the run', t.startswith('t = 100'), t)
# Break it: a mistake in its data handling must show on the panel.
await ev("$.sienna.bigNumber.prototype._show = function () { this.nope(); }")
await ev("(()=>{const v=Sienna.Simulation.viewFor('models/growth'); return v.reset().then(()=>{v.start(); return 1})})()"); await sleep(3)
bar = await ev("$('.slx-widget-error').text()")
await check('an error shows on the panel', 'Error in Big number' in (bar or ''), bar)
