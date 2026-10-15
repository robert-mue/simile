// Run a compiled model (side module) in the page's run-time library (vendor/simile-runtime) and
// print every variable's value at each of T whole time units, so two builds of
// one model can be compared with `cmp`.
//
//   node run-model.cjs <model.wasm> [T=100] > values.txt
'use strict';
const fs = require('fs'), path = require('path');
const SimileRuntime = require(path.resolve(__dirname, '../../../vendor/simile-runtime/simile-runtime.js'));

(async () => {
  const E = await SimileRuntime();
  const c = (fn, ret, types, args) => E.ccall(fn, ret, types, args);
  E.FS.writeFile('/model.wasm', fs.readFileSync(process.argv[2]));
  const problem = c('sx_load', 'string', ['string'], ['/model.wasm']);
  if (problem) { console.error('load:', problem); process.exit(1); }
  const ids = Object.keys(JSON.parse(c('sx_describe', 'string', [], [])));
  const T = Number(process.argv[3] || 100);
  const values = () => ids.map((id) => c('sx_value', 'string', ['string'], [id])).join(' ');
  c('sx_reset', 'number', ['number', 'number', 'number'], [0, -2, 12345]);   // fixed seed
  const rows = [];
  for (let t = 0; t < T; t++) {
    rows.push(values());
    c('sx_execute', 'number', ['number', 'number'], [t, t + 1]);
  }
  rows.push(values());
  console.log(rows.join('\n'));
})();
