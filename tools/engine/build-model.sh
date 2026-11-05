#!/bin/bash
# Compile one model for an embedded-widget page:
#   model script (File > Export model as script) -> Simile Prolog (the app's
#   exporter) -> C++ (Simile's generator, headless) -> WebAssembly side
#   module -> <out>.compiled.js, a script calling Simile.compiledModel(name, …).
#
#   tools/engine/build-model.sh <simile source> <model script .js> <out .compiled.js>
#
# Needs emsdk (~/emsdk) and SWI-Prolog. Rebuild a page's after any edit to its
# model, or when the C++ changes (tools/engine/MAINTAINING.md).
set -e
SRC=$(cd "${1:?usage: build-model.sh <simile source> <model .js> <out .compiled.js>}" && pwd)
MODEL=$(realpath "${2:?model script}")
OUT=$(realpath -m "${3:?out .compiled.js}")
HERE=$(cd "$(dirname "$0")" && pwd)
source ~/emsdk/emsdk_env.sh > /dev/null 2>&1
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

node "$HERE/export-pl.js" "$MODEL" "$WORK/model.pl" > /dev/null

# Simile's own generator, headless (generator/headless.pl): the same C++
# desktop Simile writes (README, step 3), with no window.
(cd "$HERE/generator" && timeout 600 swipl headless.pl --structdb=prolog \
  "$SRC" "$WORK/model.pl" "$WORK/model.cpp" > "$WORK/gen.log" 2>&1) || true
if [ ! -s "$WORK/model.cpp" ]; then
  echo "Simile's generator wrote no C++:"; cat "$WORK/gen.log"; exit 1
fi

emcc -O2 -fPIC -I"$HERE/stubs" -I"$SRC/Run" -sSIDE_MODULE=1 \
  -o "$WORK/model.wasm" "$WORK/model.cpp" "$SRC/Run/support.cpp"
node "$HERE/compiled-file.js" "$MODEL" "$WORK/model.wasm" "$OUT"
