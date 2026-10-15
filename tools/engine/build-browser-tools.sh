#!/bin/bash
# What a page needs to make a model's engine itself, when it has no
# <name>.engine.js for it (src/engine-build.js), all classic scripts that a
# page opened from file:// can load:
#
#   vendor/swipl/swipl-bundle.js                SWI-Prolog (npm swipl-wasm, BSD-2)
#   vendor/simile-generator/simile-generator.js Simile's Prolog + generator/headless.pl
#   vendor/clang/clang.js, clang-data.js        clang + wasm-ld (npm @yowasp/clang)
#   vendor/simile-engine/model-kit.js           headers, support.cpp compiled
#
#   tools/engine/build-browser-tools.sh <simile source>
#
# Needs emsdk (~/emsdk: its node/npm, its sysroot headers) and network access
# for the two npm packages, at the versions measured (README, steps 3 and 4).
set -e
SRC=$(cd "${1:?usage: build-browser-tools.sh <simile source>}" && pwd)
HERE=$(cd "$(dirname "$0")" && pwd)
ROOT=$(cd "$HERE/../.." && pwd)
SWIPL_WASM=swipl-wasm@8.2.3
YOWASP_CLANG=@yowasp/clang@22.0.0-git20542-10
export PATH=$(echo ~/emsdk/node/*/bin):$PATH
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

(cd "$WORK" && npm pack --silent "$SWIPL_WASM" "$YOWASP_CLANG" > /dev/null)
mkdir "$WORK/swipl" "$WORK/clang"
tar xzf "$WORK"/swipl-wasm-*.tgz -C "$WORK/swipl"
tar xzf "$WORK"/yowasp-clang-*.tgz -C "$WORK/clang"

mkdir -p "$ROOT/vendor/swipl" "$ROOT/vendor/simile-generator" "$ROOT/vendor/clang"
cp "$WORK/swipl/package/dist/swipl/swipl-bundle.js" "$ROOT/vendor/swipl/"
node "$HERE/generator/pack.js" "$SRC" "$ROOT/vendor/simile-generator/simile-generator.js"
python3 -I "$HERE/clang/repack-classic.py" "$WORK/clang/package/gen" "$ROOT/vendor/clang"
node "$HERE/clang/model-kit.mjs" "$WORK/clang/package/gen/bundle.js" "$SRC" "$ROOT/vendor/simile-engine/model-kit.js"
ls -la "$ROOT/vendor/swipl" "$ROOT/vendor/simile-generator" "$ROOT/vendor/clang" "$ROOT/vendor/simile-engine"
