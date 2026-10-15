#!/usr/bin/env node
// Write a model as Simile Prolog, outside the browser, with the app's own
// exporter. Takes a model script made by File > Export model as script
// (a call to Simile.model(name, model, run)) and writes <out>: Prolog for
// .pl, or for .sml the MIME-wrapped form the app uploads to SimiLive.
//
//   node tools/engine/export-pl.js pages/trees/trees.js /tmp/trees.pl
'use strict';
const fs = require('fs'), path = require('path'), vm = require('vm');
const root = path.resolve(__dirname, '../..');
const [modelScript, outFile] = process.argv.slice(2);
if (!modelScript || !outFile) {
  console.error('usage: export-pl.js <model script .js> <out .pl>');
  process.exit(2);
}
const ctx = { console: console, TextEncoder: TextEncoder, btoa: btoa };
ctx.window = ctx;
ctx.Sienna = {};
let captured = null;
ctx.Simile = { model: (name, model, run) => { captured = { name, model, run }; } };
vm.createContext(ctx);
for (const f of ['src/schema/simile-v1.js', 'src/diagram.js', 'src/export-simile.js']) {
  vm.runInContext(fs.readFileSync(path.join(root, f), 'utf8'), ctx, { filename: f });
}
vm.runInContext(fs.readFileSync(modelScript, 'utf8'), ctx, { filename: modelScript });
if (!captured) { console.error('no Simile.model(...) call in ' + modelScript); process.exit(1); }
const ex = ctx.Sienna.exportSimile;
fs.writeFileSync(outFile, /\.sml$/.test(outFile)
  ? ex.sml(captured.model, captured.run) : ex.prolog(captured.model));
console.log(captured.name + ' -> ' + outFile + '  run settings: ' + JSON.stringify(captured.run));
