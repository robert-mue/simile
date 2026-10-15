#!/usr/bin/env node
// Wrap a compiled model (a WebAssembly side module) as a script a page can
// load with <script>:  Simile.compiledModel(name, {prolog, wasm})
// where `prolog` is the fingerprint of the Simile Prolog it was made from,
// computed by the app's own exporter and Sienna.LocalEngine.fingerprint, so
// the page uses it only for exactly that model.
//
//   node compiled-file.js <model script .js> <model .wasm> <out .compiled.js>
'use strict';
const fs = require('fs'), path = require('path'), vm = require('vm');
const root = path.resolve(__dirname, '../..');
const [modelScript, wasmFile, outFile] = process.argv.slice(2);
if (!outFile) { console.error('usage: compiled-file.js <model .js> <model .wasm> <out .compiled.js>'); process.exit(2); }
const ctx = { console, TextEncoder, btoa };
ctx.window = ctx;
ctx.Sienna = {};
let captured = null;
ctx.Simile = { model: (name, model, run) => { captured = { name, model, run }; } };
vm.createContext(ctx);
for (const f of ['src/schema/simile-v1.js', 'src/diagram.js', 'src/export-simile.js', 'src/engine-local.js']) {
  vm.runInContext(fs.readFileSync(path.join(root, f), 'utf8'), ctx, { filename: f });
}
vm.runInContext(fs.readFileSync(modelScript, 'utf8'), ctx, { filename: modelScript });
const print = ctx.Sienna.LocalEngine.fingerprint(ctx.Sienna.exportSimile.prolog(captured.model));
const wasm = fs.readFileSync(wasmFile).toString('base64');
fs.writeFileSync(outFile,
  '// ' + captured.name + ': the model compiled for the page (tools/engine/build-model.sh).\n'
  + '// Used only while the model is exactly the one it was compiled from;\n'
  + '// otherwise the page compiles the model itself.\n'
  + 'Simile.compiledModel(' + JSON.stringify(captured.name) + ', {\n'
  + '  prolog: ' + JSON.stringify(print) + ',\n'
  + '  wasm: "' + wasm + '"\n});\n');
console.log(captured.name + ' -> ' + outFile + ' (' + print + ', ' + fs.statSync(wasmFile).size + ' bytes of model)');
