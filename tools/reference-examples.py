#!/usr/bin/env python3
"""Keep help/model-file-reference.md's worked examples in step with their files.

The reference has to be self-contained (an assistant given it has nothing
else), so each worked example is written out in it in full. The FILES in
examples/models/ are the ones tools/headless/scripts/model-file.py opens,
checks and runs; this copies each into the reference after its marker,

    <!-- example: examples/models/<name>.json -->

replacing the ```json block there. Run it after changing an example:

    python3 tools/reference-examples.py           # rewrite the reference
    python3 tools/reference-examples.py --check   # exit 1 if it is out of step
"""
import json, os, re, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DOC = os.path.join(ROOT, 'help', 'model-file-reference.md')
MARK = re.compile(r'(<!-- example: (\S+) -->\n)(\n```json\n.*?\n```\n)?', re.S)


def filled(text):
    def one(m):
        body = open(os.path.join(ROOT, m.group(2))).read().rstrip('\n')
        json.loads(body)  # an example that is not JSON is a mistake to stop at
        return m.group(1) + '\n```json\n' + body + '\n```\n'
    return MARK.sub(one, text)


text = open(DOC).read()
new = filled(text)
if '--check' in sys.argv:
    if new != text:
        sys.exit('help/model-file-reference.md is out of step with examples/models/: '
                 'run python3 tools/reference-examples.py')
    print('reference examples in step:', len(MARK.findall(text)))
else:
    open(DOC, 'w').write(new)
    print('wrote', len(MARK.findall(new)), 'examples into', os.path.relpath(DOC, ROOT))
