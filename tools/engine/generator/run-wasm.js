// Simile's generator in SWI-Prolog's WebAssembly build (npm swipl-wasm), under node:
//   node run-wasm.js <swipl-wasm package dir> <simile source> <this folder> <in .pl> <out .cpp>
const fs = require('fs'), path = require('path');
const [pkg, simile, gen, input, output] = process.argv.slice(2);
const SWIPL = require(path.join(pkg, 'dist/swipl/swipl-bundle.js'));
function copyTree(FS, from, to, filter) {
  FS.mkdirTree(to);
  for (const e of fs.readdirSync(from, { withFileTypes: true })) {
    const f = path.join(from, e.name), t = to + '/' + e.name;
    if (e.isDirectory()) copyTree(FS, f, t, filter);
    else if (!filter || filter(e.name)) FS.writeFile(t, fs.readFileSync(f));
  }
}
(async () => {
  const t0 = Date.now();
  const swipl = await SWIPL({ arguments: ['-q'] });
  const FS = swipl.FS;
  console.log('SWI-Prolog', swipl.prolog.query('current_prolog_flag(version, V)').once().V, 'ready in', Date.now() - t0, 'ms');
  copyTree(FS, path.join(simile, 'Prolog'), '/simile/Prolog', n => n.endsWith('.pl'));
  copyTree(FS, path.join(simile, 'Functions'), '/simile/Functions');
  FS.writeFile('/simile/Makefile', fs.readFileSync(path.join(simile, 'Makefile')));
  FS.mkdirTree('/gen');
  for (const f of ['headless.pl', 'struct_db.pl']) FS.writeFile('/gen/' + f, fs.readFileSync(path.join(gen, f)));
  FS.writeFile('/in.pl', fs.readFileSync(input));
  const t1 = Date.now();
  const q = (g) => { const r = swipl.prolog.query(g).once(); return r; };
  console.log('consult:', JSON.stringify(q("consult('/gen/headless.pl')")).slice(0, 300));
  console.log('generate:', JSON.stringify(q("assertz(hl_setting(structdb, prolog)), catch(generate('/simile', '/in.pl', '/out.cpp'), E, (print_message(error, E), fail))")).slice(0, 300));
  console.log('took', Date.now() - t1, 'ms');
  try { fs.writeFileSync(output, FS.readFile('/out.cpp')); console.log('wrote', output); } catch (e) { console.log('no /out.cpp:', e.message); }
})();
