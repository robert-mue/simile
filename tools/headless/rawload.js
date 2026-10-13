// Upload raw Prolog text as a model and start a session; resolves to a trace of server acts.
window.__rawLoad = async function (pl) {
  const S = Sienna.Simulation;
  await S.unload();
  const op = S._post.bind(S); const acts = [];
  S._post = function (act, x) { return op(act, x).then(t => { acts.push(act + ': ' + String(t).slice(0, 200)); return t; }); };
  try {
    S.modelLink = 'raw'; S._setStatus('loading', 'Uploading');
    const fd = new FormData();
    fd.append('model_src', 'file'); fd.append('model', new Blob([pl], { type: 'application/octet-stream' }), 'model.pl');
    fd.append('param_src', 'none'); fd.append('helper_src', 'none');
    const html = await $.ajax({ type: 'POST', url: S.SERVER + 'create_model.php', data: fd, processData: false, contentType: false, dataType: 'text' });
    await S._startSession(html);
  } catch (e) { acts.push('THROW ' + e.message); }
  S._post = op;
  return acts.filter(a => !a.startsWith('BuildShareLib') && !a.startsWith('Describe')).join('\n');
};
// Run the loaded model and record one component by label.
window.__series = async function (label, step, len, log) {
  const S = Sienna.Simulation;
  const norm = s => s.replace(/[ _]/g, ''); const id = S.scalarComponents().find(c => norm(c.label) === norm(label)).id;
  S.settings.timeStep = String(step); S.settings.logEach = log; S.settings.runLength = len; S.settings.updateEach = len;
  const vals = []; S.addTarget('rec', id);
  const un = S.subscribe(e => { if (e.type === 'data') vals.push(+e.time.toFixed(3) + ':' + (+e.values[id]).toFixed(3)); });
  await S.reset(); vals.length = 0;
  await new Promise(res => { const u = S.subscribe(e => { if (e.type === 'status' && e.status !== 'running') { u(); res(); } }); S.start(); });
  un(); S.removeTarget('rec');
  return vals.join(' ') + (S.status === 'error' ? ' ERR ' + S.message : '');
};
// Build a two-variable model t=time(), g=graph(t); export; inject table_data; run.
window.__graphProbe = async function (td, len, step, log) {
  const p = Sienna.documents.list().find(d => d.id === 'gtest') ? 'models/gtest' : Sienna.documents.create('gtest');
  if (!Sienna.userData.get(p).nodes || !Object.keys(Sienna.userData.get(p).nodes).length) {
    const d = new Sienna.Diagram(p);
    const t = d.addNode('variable', { label: 't', x: 100, y: 100, props: { value: 'time()' } });
    const g = d.addNode('variable', { label: 'g', x: 200, y: 100, props: { value: 'graph(t)' } });
    d.addInfluence(t, g);
  }
  const pl = Sienna.exportSimile.prolog(Sienna.userData.get(p)).replace('units=1,value=(graph(t))', td + ',units=1,value=(graph(t))');
  const tr = await __rawLoad(pl);
  if (Sienna.Simulation.status !== 'ready') return 'LOAD FAILED ' + tr.split('\n').slice(-2).join(' | ');
  return await __series('g', step, len, log);
};
