# File parameters: labour_by_priority1 (three of them, two arrays) imported,
# exported as Simile's single-node param_type=file, refused a run while
# values are missing, given them in the Parameters panel, run, and a
# parameter file saved and loaded. Over http (tools/serve.py). PASS/FAIL lines.
import json, os
B='http://localhost:8731/'
ROOT=os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..')) if '__file__' in globals() else '/home/user/Projects/simile'
PL=open(ROOT+'/reference/catalogue/labour_by_priority1.pl', errors='replace').read()
await nav(B+'index.html?newuser=fresh'); await sleep(4)
async def check(what, ok, got): print(('PASS ' if ok else 'FAIL ') + what + ('' if ok else '  got: ' + str(got)))
await ev("window.__pl=%s; Sienna.persistence.writeJSON('simile.fileParameters.v1', {}); 1" % json.dumps(PL))
await ev("(()=>{const r=Sienna.importSimile.read(__pl); Sienna.importSimile.install('models/labour', r.model); return 1})()")
fp = await ev("JSON.stringify(Sienna.Simulation.fileParametersOf('models/labour').map(p=>[p.label,p.shape,p.default]))")
await check('three file parameters, shaped', fp == '[["priorities",[5],""],["time_available",[],""],["times_required",[5],""]]', fp)
pl = await ev("Sienna.exportSimile.prolog(Sienna.userData.get('models/labour'))")
lines = [l for l in pl.split('\n') if 'param_type=file' in l]
await check('exported single-node, param_type=file', len(lines) == 3 and all('function' not in l and 'value=' not in l for l in lines) and 'units=array(1,5)' in lines[0], lines)
await ev("Sienna.documents.openOrShow(app, 'models/labour')"); await sleep(3)
await ev("app.addPanel({title:'Parameters', widget:'parameters', ref:'models/labour'})"); await sleep(1.5)
heads = await ev("$('.slx-params-sub').map((i,e)=>e.textContent).get().join('|')")
await check('grouped (all at the top level)', heads == 'Top level', heads)
note = await ev("$('.slx-params-note').text()")
await check('says 3 values are needed', note.startswith('3 values are needed'), note)
await ev("(()=>{const v=Sienna.Simulation.viewFor('models/labour'); return v.loadOwn('models/labour').catch(e=>e.message)})()")
for i in range(80):
    if await ev("Sienna.Simulation.status") in ('error','ready') and i > 2: break
    await sleep(0.5)
msg = await ev("Sienna.Simulation.message")
await check('run refused, naming what is missing', 'Values needed' in msg and 'times_required' in msg, msg)
async def give(name, text):
    await ev("(()=>{const r=$('.slx-param').filter((i,e)=>$(e).find('.slx-param-name').text()===%r); r.find('input').val(%r).trigger('change')})()" % (name, text))
    await sleep(0.3)
await give('priorities', '[1, 2]')
err = await ev("$('.slx-param-error').text()")
await check('a wrong count is refused in the panel', '5 values are needed; 2 are given' in err, err)
await give('priorities', '[3,1,2,5,4]'); await give('time_available', '10'); await give('times_required', '[4,3,2,1,5]')
for i in range(40):
    if await ev("Sienna.Simulation.status") == 'ready': break
    await sleep(0.5)
await check('runs once given', await ev("Sienna.Simulation.status") == 'ready', await ev("Sienna.Simulation.message"))
c = await ev("(()=>{const cs=Sienna.Simulation.components; const id=k=>Object.keys(cs).find(i=>cs[i].captpath===k); return Sienna.Simulation.query([id('/time_available'),id('/priorities'),id('/Activity/time_allocated')]).then(v=>JSON.stringify(Object.values(v)))})()")
await check('the model has the values', c.startswith('[10,[3,1,2,5,4],'), c)
txt = await ev("$('.slx-params').parameters('instance')._fileText()")
doc = json.loads(txt)
await check('saved as JSON grouped by submodel', doc['variables'] == {'priorities':[3,1,2,5,4],'time_available':10,'times_required':[4,3,2,1,5]} and doc['submodels'] == {}, txt)
kept = await ev("JSON.stringify(Sienna.persistence.readJSON('simile.fileParameters.v1'))")
inmodel = await ev("JSON.stringify(Sienna.userData.get('models/labour'))")
await check('kept beside the model, not in it', '[3,1,2,5,4]' in kept and '[3,1,2,5,4]' not in inmodel, kept)
await ev("$('.slx-params').parameters('instance')._clear()"); await sleep(1)
await check('clear: values needed again', (await ev("$('.slx-params-note').text()")).startswith('3 values'), await ev("$('.slx-params-note').text()"))
doc['variables']['time_available'] = 7; doc['variables']['extra'] = 1
await ev("$('.slx-params').parameters('instance')._read(%s, 'x.spf')" % json.dumps(json.dumps(doc)))
await sleep(1.5)
note = await ev("$('.slx-params-note').text()")
await check('load reports a name not in the model', 'not in this model: extra' in note, note)
v = await ev("$('.slx-param input').map((i,e)=>e.value).get().join('|')")
await check('load fills the fields', v == '[3, 1, 2, 5, 4]|7|[4, 3, 2, 1, 5]', v)
x = await ev("$('.slx-params').parameters('instance')._read('<?xml version=\"1.0\"?><spf/>', 'old.spf'); $('.slx-params-note').text()")
await check('Simile XML file: said so', 'XML' in x, x)
