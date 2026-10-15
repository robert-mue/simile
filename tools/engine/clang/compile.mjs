// Step 4 spike: compile a model's C++ to the engine's side module with clang
// running as WebAssembly (npm @yowasp/clang), exactly as a page would, and
// compare with emcc's (README, step 4).
//
//   node compile.mjs <@yowasp/clang gen/bundle.js> <simile src> <model.cpp> <out.wasm>
//
// The headers it hands clang are the ones emcc reads for this model (emsdk's
// `em++ -M`), from emsdk's sysroot: a page would ship that set (~170 files).
// The flags are emcc's own, but for one (flags.json).
import fs from 'node:fs';
import path from 'node:path';
import { execFileSync } from 'node:child_process';

const [bundle, simileSrc, modelCpp, out] = process.argv.slice(2);
if (!out) { console.error('usage: compile.mjs <yowasp bundle.js> <simile src> <model.cpp> <out.wasm>'); process.exit(2); }
const { runClang, runLLVM } = await import(path.resolve(bundle));
const SRC = path.resolve(simileSrc);
const HERE = path.dirname(new URL(import.meta.url).pathname);
const STUBS = path.join(HERE, '../stubs');
const SYS = process.env.HOME + '/emsdk/upstream/emscripten/cache/sysroot';
const EMXX = process.env.HOME + '/emsdk/upstream/emscripten/em++';

// The model's C++ names Simile's sources by absolute path: make them /simile.
const cpp = fs.readFileSync(modelCpp, 'utf8').replace(/#include "[^"]*\/Functions\/procs\.cpp"/, '#include "/simile/Functions/procs.cpp"');
const tmp = fs.mkdtempSync(path.join(path.dirname(path.resolve(out)), '.compile-'));
fs.writeFileSync(path.join(tmp, 'model.cpp'), cpp.replace('/simile/', SRC + '/'));
const deps = (file) => execFileSync(EMXX, ['-O2', '-fPIC', '-I' + STUBS, '-I' + SRC + '/Run', '-M', file], { encoding: 'utf8' })
  .split(/[\s\\]+/).filter((f) => f.startsWith('/'));
const headers = new Set([...deps(path.join(tmp, 'model.cpp')), ...deps(SRC + '/Run/support.cpp')]);
fs.rmSync(tmp, { recursive: true });

const tree = {};
const put = (p, data) => {
  const parts = p.split('/').filter(Boolean); let t = tree;
  for (const d of parts.slice(0, -1)) t = (t[d] ||= {});
  t[parts.at(-1)] = data;
};
for (const f of headers) {
  if (f.startsWith(SYS)) put('sysroot' + f.slice(SYS.length), fs.readFileSync(f));
  else if (f.startsWith(SRC)) put('simile' + f.slice(SRC.length), fs.readFileSync(f));
}
put('simile/Run/support.cpp', fs.readFileSync(SRC + '/Run/support.cpp'));
put('stubs/portaudio.h', fs.readFileSync(STUBS + '/portaudio.h'));
put('model.cpp', cpp);

const { compile: flags, link } = JSON.parse(fs.readFileSync(path.join(HERE, 'flags.json'), 'utf8'));
const opts = { stdout: (b) => b && process.stdout.write(b), stderr: (b) => b && process.stderr.write(b) };
const timed = async (what, f) => { const t = performance.now(); const r = await f(); console.log(what, Math.round(performance.now() - t), 'ms'); return r; };

let r = await timed('compile model.cpp (first call: clang starting too)',
  () => runClang(['clang++', ...flags, '/model.cpp', '-o', '/model.o'], tree, opts));
r = await timed('compile model.cpp again', () => runClang(['clang++', ...flags, '/model.cpp', '-o', '/model.o'], tree, opts));
// support.cpp never changes: a page would ship its object, made once.
r = await timed('compile support.cpp', () => runClang(['clang++', ...flags, '/simile/Run/support.cpp', '-o', '/support.o'], r, opts));
r = await timed('link', () => runLLVM(['wasm-ld', '-o', '/model.wasm', ...link, '/model.o', '/support.o'], r, opts));
fs.writeFileSync(out, r['model.wasm']);
console.log('wrote', out, r['model.wasm'].length, 'bytes');
