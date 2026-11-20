# Flow BENDS (Robert, 2026-11-20): a flow's corners, `layout.arcs.<id>.points`,
# as Simile's `course` and Vensim's pipes have them. Two stocks with a flow
# each way, one of them bent round below: the bent one is drawn through its
# corners, its valve halfway along its path, the straight one not fanned;
# dragging BOTH stocks carries the bends (as the drag's ghost shows), dragging
# one leaves them; undo puts them back; out to Simile's Prolog and back keeps
# them (`course`).
#   python3 tools/headless/cdp.py tools/headless/scripts/bends.py
# Over http (tools/serve.py); a new-user preview.
ok = [0, 0]
def check(name, cond, detail=''):
    ok[0 if cond else 1] += 1; print(('PASS ' if cond else 'FAIL ') + name + ('' if cond else '  ' + str(detail)))

spec = {"id": "bends", "name": "Bends", "format": 3, "schema": "simile-v1", "enums": {}, "submodels": {},
  "nodes": {
    "node1": {"type": "stock", "parent": None, "label": "A", "props": {"initial": "100"}},
    "node2": {"type": "stock", "parent": None, "label": "B", "props": {"initial": "0"}},
    "node3": {"type": "valve", "parent": None, "label": "there", "props": {"rate": "0.1*A"}},
    "node4": {"type": "valve", "parent": None, "label": "back", "props": {"rate": "0.05*B"}}},
  "arcs": {
    "arc1": {"type": "flow", "from": "node1", "to": "node2", "valve": "node3", "props": {}},
    "arc2": {"type": "flow", "from": "node2", "to": "node1", "valve": "node4", "props": {}},
    "arc3": {"type": "influence", "from": "node1", "to": "node3", "alias": "A", "props": {}},
    "arc4": {"type": "influence", "from": "node2", "to": "node4", "alias": "B", "props": {}}},
  "layout": {"node1": {"x": 100, "y": 100}, "node2": {"x": 300, "y": 100},
    "arcs": {"arc2": {"points": [{"x": 340, "y": 100}, {"x": 340, "y": 200}, {"x": 60, "y": 200}, {"x": 60, "y": 100}]}}}}

await nav('http://localhost:8731/index.html?newuser=fresh'); await sleep(5)
P = "'models/__bends'"
await ev("Sienna.userData.set(%s, %s); 1" % (P, json.dumps(spec)))
D = "new Sienna.Diagram(%s)" % P

valve = await ev("(()=>{const b=%s.box('node4'); return [b.cx,b.cy]})()" % D)
check('the bent flow\'s valve: halfway along its path', valve == [200, 200], valve)
straight = await ev("(()=>{const b=%s.box('node3'); return [b.cx,b.cy]})()" % D)
check('the straight flow\'s valve: between its ends', straight == [200, 100], straight)
pts = await ev("%s.arcPoints('arc2').map(p=>[p.x,p.y])" % D)
check('its path: source, the four corners, its end', pts == [[300, 100], [340, 100], [340, 200], [60, 200], [60, 100], [100, 100]], pts)

# Drawn: open it, read the paths.
await ev("Sienna.documents.open(app, %s); 1" % P); await sleep(4)
drawn = await ev("$('.slx-diagram path.slx-arc-flow[data-id=arc2]').length")
check('drawn as one path per segment, through its corners', drawn == 5, drawn)
bent_d = await ev("$('.slx-diagram path.slx-arc-flow[data-id=arc1]').attr('d')")
check('the straight flow is not fanned (no curve)', bent_d and 'A' not in bent_d and 'C' not in bent_d and 'Q' not in bent_d, bent_d)

# Both ends dragged together: the bends go with them. One end: they stay.
await ev("%s.commitDrag({node1: {x: 110, y: 120}, node2: {x: 310, y: 120}}); 1" % D)
moved = await ev("%s.flowBends('arc2').map(p=>[p.x,p.y])" % D)
check('both ends dragged by (10, 20): the bends with them', moved == [[350, 120], [350, 220], [70, 220], [70, 120]], moved)
await ev("Sienna.history.undo(); 1"); await sleep(0.3)
back = await ev("%s.flowBends('arc2').map(p=>[p.x,p.y])" % D)
check('one undo: stocks and bends back', back == [[340, 100], [340, 200], [60, 200], [60, 100]], back)
await ev("%s.commitDrag({node1: {x: 100, y: 150}}); 1" % D)
stay = await ev("%s.flowBends('arc2').map(p=>[p.x,p.y])" % D)
check('one end dragged: the bends stay', stay == [[340, 100], [340, 200], [60, 200], [60, 100]], stay)
await ev("Sienna.history.undo(); 1"); await sleep(0.3)

# Out to Simile's format and back.
pl = await ev("Sienna.exportSimile.prolog(Sienna.userData.get(%s))" % P)
line = [l for l in pl.split('\n') if ',flow,' in l and 'course=' in l]
check('exported as Simile\'s course', len(line) == 1 and 'course=[[' in line[0], line)
again = await ev("JSON.stringify(Sienna.importSimile.read(%s).model)" % json.dumps(pl))
m2 = json.loads(again)
bent2 = [v.get('points') for v in (m2['layout'].get('arcs') or {}).values() if v.get('points')]
check('imported back with its four corners', len(bent2) == 1 and [[round(p['x']), round(p['y'])] for p in bent2[0]]
      == [[340, 100], [340, 200], [60, 200], [60, 100]], bent2)
await ev("Sienna.userData.remove(%s); 1" % P)
print('%d passed, %d failed' % tuple(ok))
