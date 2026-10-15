#!/bin/bash
# Compile one model for an embedded-widget page:
#   model script (File > Export model as script) -> Simile Prolog (the app's
#   exporter) -> C++ (Simile itself, built from source) -> WebAssembly side
#   module -> <out>.compiled.js, a script calling Simile.compiledModel(name, …).
#
#   tools/engine/build-model.sh <simile source> <model script .js> <out .compiled.js>
#
# Opens Simile's window briefly (it needs a display). Needs emsdk (~/emsdk).
set -e
SRC=$(cd "${1:?usage: build-model.sh <simile source> <model .js> <out .compiled.js>}" && pwd)
MODEL=$(realpath "${2:?model script}")
OUT=$(realpath -m "${3:?out .compiled.js}")
HERE=$(cd "$(dirname "$0")" && pwd)
source ~/emsdk/emsdk_env.sh > /dev/null 2>&1
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

node "$HERE/export-pl.js" "$MODEL" "$WORK/model.pl" > /dev/null

# Simile from source, with its own HOME so the installed Simile's settings
# are left alone, and the export extension in place.
mkdir -p "$WORK/home/.simile"
cp "$SRC/Run/mdlrinfo.swi" "$WORK/home/.simile/mdlrinfo.txt"
cp "$HERE/zz_export_cpp.tcl" "$SRC/Extensions/"
(cd "$SRC" && HOME="$WORK/home" LD_LIBRARY_PATH="$SRC/System/lib" \
  SIMILE_EXPORT_IN="$WORK/model.pl" SIMILE_EXPORT_OUT="$WORK/model.cpp" \
  timeout 120 tclsh System/bin/simile > "$WORK/simile.log" 2>&1) || true
if [ ! -s "$WORK/model.cpp" ]; then
  echo "Simile wrote no C++:"; cat "$WORK/model.cpp.log" "$WORK/simile.log" 2>/dev/null; exit 1
fi

emcc -O2 -fPIC -I"$HERE/stubs" -I"$SRC/Run" -sSIDE_MODULE=1 \
  -o "$WORK/model.wasm" "$WORK/model.cpp" "$SRC/Run/support.cpp"
node "$HERE/compiled-file.js" "$MODEL" "$WORK/model.wasm" "$OUT"
