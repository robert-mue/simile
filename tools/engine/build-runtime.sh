#!/bin/bash
# Build Simile's run-time library for the browser: shank.cpp (the support
# code every compiled model is linked to) and bridge.cpp, as an Emscripten
# main module packed into ONE script, so a page opened from disk can load it
# with <script> (file:// cannot fetch a .wasm). A compiled model is a side
# module loaded into it.
#
#   tools/engine/build-runtime.sh <simile source>
#
# Writes vendor/simile-runtime/simile-runtime.js. Needs emsdk (~/emsdk).
# The patches in patches/ are applied to copies of shank.cpp and 6d.h first:
# fixes to Simile's run-time code, kept here until they are in Simile's own
# source. (6d.h is shank.cpp's own header; a model's C++ does not include it.)
set -e
SRC=${1:?usage: build-runtime.sh <simile source checkout>}
HERE=$(cd "$(dirname "$0")" && pwd)
ROOT=$(cd "$HERE/../.." && pwd)
source ~/emsdk/emsdk_env.sh > /dev/null 2>&1
OUT=$ROOT/vendor/simile-runtime
mkdir -p "$OUT"
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT
mkdir -p "$WORK/Run"
cp "$SRC/Run/shank.cpp" "$SRC/Run/6d.h" "$WORK/Run/"
for p in "$HERE"/patches/*.patch; do
  patch -s -d "$WORK" -p1 < "$p"
done
em++ -O2 -std=c++11 -I"$HERE/stubs" -I"$WORK/Run" -I"$SRC/Run" \
  -sMAIN_MODULE=1 -sALLOW_MEMORY_GROWTH=1 -sSINGLE_FILE=1 \
  -sMODULARIZE=1 -sEXPORT_NAME=SimileRuntime -sEXIT_RUNTIME=0 \
  -sEXPORTED_RUNTIME_METHODS=FS,ccall,UTF8ToString \
  -o "$OUT/simile-runtime.js" "$HERE/bridge.cpp" "$WORK/Run/shank.cpp"
echo "built $OUT/simile-runtime.js ($(du -h "$OUT/simile-runtime.js" | cut -f1))"
