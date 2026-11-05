#!/bin/bash
# The C++ that Simile's generator writes for every catalogue model, and for
# nkometou when it is there (outside the repo, its model spec exported as the
# app exports it), into <out dir>, its line 2 (the date) removed. Run it before and after a change, then compare:
#
#   tools/engine/check/generate-all.sh <out dir> [<git ref>]
#   diff -r <before> <after>
#
# With a git ref, the generator (generator/headless.pl, struct_db.pl) is
# taken as it was at that commit, so "before" can be made after the change:
#   generate-all.sh /tmp/before HEAD; generate-all.sh /tmp/after
# The Simile checkout is $SIMILE_SRC (default ~/Projects/simile-src): to see
# what an update of Simile changes, run it once against each checkout.
# Runs natively (swipl), at low priority, each model time-capped; a model
# for which no C++ is written gets <name>.failed instead, so a change in
# which models generate shows in the diff too. nkometou takes about 30 s.
set -e
OUT=$(realpath -m "${1:?usage: generate-all.sh <out dir> [<git ref>]}")
REF=$2
SRC=$(cd "${SIMILE_SRC:-$HOME/Projects/simile-src}" && pwd)
HERE=$(cd "$(dirname "$0")" && pwd)
ROOT=$(cd "$HERE/../../.." && pwd)
GEN=$ROOT/tools/engine/generator
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT
if [ -n "$REF" ]; then
  (cd "$ROOT" && git archive "$REF" tools/engine/generator) | tar x -C "$WORK"
  GEN=$WORK/tools/engine/generator
fi
mkdir -p "$OUT"
rm -f "$OUT"/*.cpp "$OUT"/*.failed
models=("$ROOT"/reference/catalogue/*.pl)
# nkometou: Simile's own file does not generate headless, so the model spec,
# exported by the app's exporter (export-pl.js), as the app would send it.
NK=$HOME/Projects/reference_models/nkometou/nkometou.json
if [ -f "$NK" ]; then
  { printf 'Simile.model("nkometou", '; cat "$NK"; printf ', {});\n'; } > "$WORK/nkometou.js"
  $(echo ~/emsdk/node/*/bin/node) "$ROOT/tools/engine/export-pl.js" "$WORK/nkometou.js" "$WORK/nkometou.pl" > /dev/null
  models+=("$WORK/nkometou.pl")
fi
ok=0; failed=0
for f in "${models[@]}"; do
  n=$(basename "$f" .pl)
  cap=60; [ "$n" = nkometou ] && cap=300
  if (cd "$GEN" && timeout $cap nice -n 19 swipl headless.pl --structdb=prolog \
        "$SRC" "$f" "$WORK/$n.cpp" > "$WORK/$n.log" 2>&1) && [ -s "$WORK/$n.cpp" ]; then
    sed 2d "$WORK/$n.cpp" > "$OUT/$n.cpp"; ok=$((ok+1))
  else
    tail -3 "$WORK/$n.log" > "$OUT/$n.failed"; failed=$((failed+1))
  fi
done
echo "$OUT: C++ for $ok models, none for $failed"
