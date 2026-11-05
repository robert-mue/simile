#!/bin/bash
# Is each sample page's shipped compiled model (pages/<name>/<name>.compiled.js)
# still the one for its model? A page uses it only while the fingerprint of the
# model's exported Simile Prolog matches; otherwise every reader's page compiles
# the model itself, loading 39 MB of tools. Prints current/STALE per page;
# exit status 1 if any is stale. Rebuild a stale one with build-model.sh.
#
#   tools/engine/check/pages-current.sh
HERE=$(cd "$(dirname "$0")" && pwd)
ROOT=$(cd "$HERE/../../.." && pwd)
NODE=$(echo ~/emsdk/node/*/bin/node)
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT
stale=0
for c in "$ROOT"/pages/*/*.compiled.js; do
  d=$(dirname "$c"); n=$(basename "$c" .compiled.js)
  "$NODE" "$HERE/../export-pl.js" "$d/$n.js" "$WORK/$n.pl" > /dev/null || { echo "$n: cannot export"; stale=1; continue; }
  now=$("$NODE" -e '
    const vm = require("vm"), fs = require("fs");
    const src = fs.readFileSync(process.argv[1], "utf8");
    const c = {}; vm.createContext(c);
    vm.runInContext(src.match(/function fingerprint\(prolog\) \{[\s\S]*?\n  \}/)[0], c);
    console.log(c.fingerprint(fs.readFileSync(process.argv[2], "utf8")));' \
    "$ROOT/src/engine-local.js" "$WORK/$n.pl")
  shipped=$(grep -o 'prolog: "[0-9a-f]*"' "$c" | head -1 | cut -d'"' -f2)
  if [ "$now" = "$shipped" ]; then echo "$n: current"; else echo "$n: STALE (shipped $shipped, model now $now)"; stale=1; fi
done
exit $stale
