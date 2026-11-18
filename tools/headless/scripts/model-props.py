# Model properties (Robert, 2026-11-18: the model is, in effect, the top-level
# submodel): the whole model's own settings, the submodel dialog's fields the
# schema marks `atTop` (Notes: comment; Advanced: units in maths, first index
# 0, enumerated types), in the model's `props`. Opened by a double-click on the
# diagram's background (real pointer events, where a hand's would land) and by
# Edit > Model properties...; OK is one undoable action, an untouched OK writes
# nothing; Simile's file-level properties carry them out and back; a type
# declared there is known everywhere in the model (a fixed membership sized
# by it is complete, and a value from it reaches the top level).
#   python3 tools/headless/cdp.py tools/headless/scripts/model-props.py
# Over http (tools/serve.py); a new-user preview, so the real store is untouched.
ok = [0, 0]
def check(name, cond, detail=''):
    ok[0 if cond else 1] += 1; print(('PASS ' if cond else 'FAIL ') + name + ('' if cond else '  ' + str(detail)))

import urllib.parse
await nav('http://localhost:8731/index.html?newuser=fresh&open=' + urllib.parse.quote('http://localhost:8731/examples/models/predator-prey.json', safe=''))
await sleep(14)
path = await ev("Sienna.documents.current(app)")
check('a model is open', bool(path), path)

# A blank point on the diagram: one where the press lands on the canvas itself.
blank = await ev("""(()=>{const svg=document.querySelector('.slx-diagram svg'); const r=svg.getBoundingClientRect();
  for (let y=r.bottom-20; y>r.top+20; y-=15) for (let x=r.left+20; x<r.right-20; x+=15) {
    const e=document.elementFromPoint(x,y); if (e===svg || (e && e.classList && e.classList.contains('slx-root'))) return [x,y]; }
  return null})()""")
check('a blank point on the diagram', blank is not None)
async def dbl(x, y):
    for cc in (1, 2):
        await mouse('mousePressed', x, y, cc=cc); await mouse('mouseReleased', x, y, cc=cc)
    await sleep(0.6)
await dbl(*blank)
head = await ev("$('.slx-dlg-model h2').text()")
check('double-click on the background: Model properties', head.startswith('Model properties'), head)
tabs = await ev("$('.slx-dlg-model .slx-dlg-tab').map((i,b)=>b.textContent).get().join('|')")
check('its tabs: Notes, Advanced', tabs == 'Notes|Advanced', tabs)
fields = await ev("$('.slx-dlg-model [data-field]').map((i,f)=>f.getAttribute('data-field')).get().join('|')")
check('its fields: the submodel fields marked atTop', fields == 'comment|eqnUnits|index0|enumTypes', fields)

# An untouched OK writes nothing.
await ev("$('.slx-dlg-model [data-act=ok]').click(); 1"); await sleep(0.5)
check('an untouched OK writes nothing', await ev("JSON.stringify(Sienna.userData.get(%s).props || null)" % json.dumps(path)) == 'null')

# Set a type and a comment, OK: one action, kept in the model's props.
await dbl(*blank)
await ev("""$('.slx-dlg-model [data-field=enumTypes]').val('species: oak, beech, pine');
  $('.slx-dlg-model [data-field=comment]').val('Lotka and Volterra.'); $('.slx-dlg-model [data-act=ok]').click(); 1""")
await sleep(0.5)
props = await ev("JSON.stringify(Sienna.userData.get(%s).props)" % json.dumps(path))
check('kept in the model\'s props', json.loads(props or 'null') == {"enumTypes": "species: oak, beech, pine", "comment": "Lotka and Volterra."}, props)
await ev("Sienna.history.undo(); 1"); await sleep(0.5)
check('one undo takes both back', await ev("JSON.stringify(Sienna.userData.get(%s).props || null)" % json.dumps(path)) == 'null')
await ev("Sienna.history.redo(); 1"); await sleep(0.5)
check('redo puts them back', 'beech' in (await ev("JSON.stringify(Sienna.userData.get(%s).props || null)" % json.dumps(path)) or ''))

# Edit > Model properties... opens the same dialog, showing what is kept.
await ev("$('.slx-menubar, .sienna-menubar, [role=menubar]').find('*').filter((i,e)=>e.textContent.trim()==='Edit').first().click(); 1"); await sleep(0.4)
await ev("$('*').filter((i,e)=>e.children.length===0 && e.textContent.trim()==='Model properties…').first().click(); 1"); await sleep(0.6)
shown = await ev("$('.slx-dlg-model [data-field=enumTypes]').val()")
check('Edit > Model properties...: the same dialog, with what is kept', shown == 'species: oak, beech, pine', shown)
await ev("$('.slx-dlg-model [data-act=cancel]').click(); 1")

# Out to Simile's format and back: the file-level properties.
pl = await ev("Sienna.exportSimile.prolog(Sienna.userData.get(%s))" % json.dumps(path))
line = [l for l in pl.split('\n') if l.startswith('properties(')][0]
check('exported in the file-level properties', 'enum_types-[species-[oak,beech,pine]]' in line and "comment-'Lotka and Volterra.'" in line, line)
back = await ev("JSON.stringify(Sienna.importSimile.read(%s).model.props)" % json.dumps(pl))
check('imported back into the model\'s props', json.loads(back or 'null') == json.loads(props or 'null'), back)

# A type declared for the whole model, used in a submodel's size and leaving it.
spec = {"id": "e", "name": "E", "format": 3, "schema": "simile-v1", "enums": {}, "props": {"enumTypes": "species: oak, beech, pine"},
  "submodels": {"submodel1": {"kind": "fixed-membership", "parent": None, "label": "tree", "props": {"dimensions": "species"}}},
  "nodes": {"node1": {"type": "variable", "parent": "submodel1", "label": "n", "props": {"value": "as_number(index(1))", "units": ""}},
            "node2": {"type": "variable", "parent": None, "label": "total", "props": {"value": "sum([n])", "units": ""}}},
  "arcs": {"arc1": {"type": "influence", "from": "node1", "to": "node2", "alias": "n", "props": {}}},
  "layout": {"submodel1": {"x": 200, "y": 150, "w": 200, "h": 150}, "node1": {"x": 200, "y": 150}, "node2": {"x": 360, "y": 150}}}
await ev("Sienna.userData.set('models/__types', %s); 1" % json.dumps(spec))
audit = await ev("Sienna.equationCheck.audit(new Sienna.Diagram('models/__types')).map(r=>r.message)")
check('a whole-model type: complete where it is used', audit == [], audit)
await ev("Sienna.userData.remove('models/__types'); 1")
print('%d passed, %d failed' % tuple(ok))
