#!/bin/bash
# Build the Simile engine for the browser: shank.cpp (Simile's engine) and
# bridge.cpp, as an Emscripten main module packed into ONE script, so a page
# opened from disk can load it with <script> (file:// cannot fetch a .wasm).
#
#   tools/engine/build-engine.sh <simile source>
#
# Writes vendor/simile-engine/simile-engine.js. Needs emsdk (~/emsdk).
# The patches in patches/ are applied to a copy of shank.cpp first: fixes
# to Simile's engine, kept here until they are in Simile's own source.
set -e
SRC=${1:?usage: build-engine.sh <simile source checkout>}
HERE=$(cd "$(dirname "$0")" && pwd)
ROOT=$(cd "$HERE/../.." && pwd)
source ~/emsdk/emsdk_env.sh > /dev/null 2>&1
OUT=$ROOT/vendor/simile-engine
mkdir -p "$OUT"
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT
mkdir -p "$WORK/Run"
cp "$SRC/Run/shank.cpp" "$WORK/Run/"
for p in "$HERE"/patches/*.patch; do
  patch -s -d "$WORK" -p1 < "$p"
done
em++ -O2 -std=c++11 -I"$HERE/stubs" -I"$SRC/Run" \
  -sMAIN_MODULE=1 -sALLOW_MEMORY_GROWTH=1 -sSINGLE_FILE=1 \
  -sMODULARIZE=1 -sEXPORT_NAME=SimileEngine -sEXIT_RUNTIME=0 \
  -sEXPORTED_RUNTIME_METHODS=FS,ccall,UTF8ToString \
  -o "$OUT/simile-engine.js" "$HERE/bridge.cpp" "$WORK/Run/shank.cpp"
echo "built $OUT/simile-engine.js ($(du -h "$OUT/simile-engine.js" | cut -f1))"
