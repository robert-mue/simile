# Fixed parameters: labour_by_priority1 (three of them, two arrays) imported,
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
fp = await ev("JSON.stringify(Sienna.Simulation.inputParametersOf('models/labour').map(p=>[p.label,p.kind,p.shape,p.default]))")
await check('three fixed parameters, shaped', fp == '[["priorities","fixed",[5],""],["time_available","fixed",[],""],["times_required","fixed",[5],""]]', fp)
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

# Variable parameters: values over time. p (a variable parameter, default 1,
# range 0..100, so also a slider) drives q = 2p. Given 10, 20, 40 at times
# 0, 3, 6, interpolated, q must follow 2 × that.
await ev("""(()=>{const d=Sienna.Diagram.create('models/ser',{name:'ser'});
  const p=d.addNode('variable',{label:'p',props:{value:'1',min:'0',max:'100',paramKind:'variable'},x:100,y:100});
  const q=d.addNode('variable',{label:'q',props:{value:'p*2'},x:220,y:100}); d.addInfluence(p,q); return 1})()""")
pl = await ev("Sienna.exportSimile.prolog(Sienna.userData.get('models/ser'))")
pline = [l for l in pl.split('\n') if 'name=p,' in l or 'name=p]' in l]
await check('variable parameter exported as one node, no param_type', len(pline) == 1 and 'param_type' not in pline[0] and 'value=1' in pline[0], pline)
kinds = await ev("JSON.stringify(Sienna.Simulation.inputParametersOf('models/ser').map(p=>[p.label,p.kind,p.slider]))")
await check('listed as variable, with a slider', kinds == '[["p","variable",true]]', kinds)
async def qs():
    return await ev("""(async()=>{const S=Sienna.Simulation; const v=S.viewFor('models/ser');
      for(let i=0;i<60 && (S.status==='loading'||S.status==='running'||S._rerunning);i++) await new Promise(r=>setTimeout(r,250));
      const cs=S.components; const q=Object.keys(cs).find(i=>cs[i].captpath==='/q');
      const rows=[]; const off=S.subscribe(e=>{ if(e.type==='data' && e.values && q in e.values) rows.push(Math.round(e.time)+':'+(+e.values[q].toFixed(2))) });
      S.addTarget('fp-test', q); await S.reset(); S.start();
      for(let i=0;i<80 && S.status==='running';i++) await new Promise(r=>setTimeout(r,250));
      off(); S.removeTarget('fp-test'); return S.status+' '+rows.slice(0,9).join(' ')})()""")
await ev("Sienna.documents.openOrShow(app, 'models/ser')"); await sleep(2)
await ev("(()=>{Sienna.Simulation.setSetting('runLength', 8); return Sienna.Simulation.viewFor('models/ser').loadOwn('models/ser').catch(e=>e.message)})()")
r = await qs()
await check('runs on its default (q = 2)', r.startswith('ready 0:2 1:2'), r)
await ev("app.addPanel({title:'P', widget:'parameters', ref:'models/ser'})"); await sleep(1.2)
await ev("(()=>{const r=$('.slx-param').filter((i,e)=>$(e).find('.slx-param-name').text()==='p').last(); r.find('input').val('{\"0\": 10, \"3\": 20, \"6\": 40}').trigger('change')})()"); await sleep(0.5)
shown = await ev("$('.slx-param').filter((i,e)=>$(e).find('.slx-param-name').text()==='p').last().find('.slx-param-fill').is(':visible')")
await check('values over time show the between-times choice', shown, shown)
await ev("(()=>{const r=$('.slx-param').filter((i,e)=>$(e).find('.slx-param-name').text()==='p').last(); r.find('select').val('interpolate').trigger('change')})()"); await sleep(0.5)
r = await qs()
await check('interpolated over time', r == 'ready 0:20 1:26.67 2:33.33 3:40 4:53.33 5:66.67 6:80 7:80 8:80', r)
await ev("(()=>{const r=$('.slx-param').filter((i,e)=>$(e).find('.slx-param-name').text()==='p').last(); r.find('select').val('use_last').trigger('change')})()"); await sleep(0.5)
r = await qs()
await check('last value between times', r == 'ready 0:20 1:20 2:20 3:40 4:40 5:40 6:80 7:80 8:80', r)
await ev("(()=>{const r=$('.slx-param').filter((i,e)=>$(e).find('.slx-param-name').text()==='p').last(); r.find('input').val('[5, 6, 7]').trigger('change')})()"); await sleep(0.5)
r = await qs()
await check('an array is values at times 0, 1, 2', r == 'ready 0:10 1:12 2:14 3:14 4:14 5:14 6:14 7:14 8:14', r)
await ev("(()=>{const r=$('.slx-param').filter((i,e)=>$(e).find('.slx-param-name').text()==='p').last(); r.find('input').val('7').trigger('change')})()"); await sleep(0.5)
r = await qs()
await check('a number holds through the run', r.startswith('ready 0:14 1:14') and r.endswith('8:14'), r)
await ev("Sienna.Simulation.setParameter('models/ser', Object.keys(Sienna.userData.get('models/ser').nodes).find(k=>Sienna.userData.get('models/ser').nodes[k].label==='p'), 30)"); await sleep(0.5)
r = await qs()
await check('a slider moved last wins over a number', r.startswith('ready 0:60'), r)
await ev("""(()=>{const r=$('.slx-param').filter((i,e)=>$(e).find('.slx-param-name').text()==='p').last(); r.find('input').val('{"0": 10, "3": 20}').trigger('change'); r.find('select').val('interpolate').trigger('change')})()"""); await sleep(0.8)
txt = await ev("$('.slx-params').last().parameters('instance')._fileText()")
doc2 = json.loads(txt)
await check('values over time and fill saved in the file', doc2['variables'] == {'p': {'0': 10, '3': 20}} and doc2.get('fill') == {'p': 'interpolate'}, txt)
await ev("$('.slx-params').last().parameters('instance')._clear()"); await sleep(0.8)
await ev("$('.slx-params').last().parameters('instance')._read(%s, 'ser.spf')" % json.dumps(txt)); await sleep(0.8)
back = await ev("JSON.stringify(Sienna.Simulation.inputValues('models/ser'))")
await check('loaded back with its fill', '"interpolate"' in back and '"3":20' in back, back)
