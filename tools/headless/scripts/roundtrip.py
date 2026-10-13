import glob
await nav('file:///home/user/Projects/simile/test/roundtrip.html'); await sleep(1)
await cmd('DOM.enable')
doc = await cmd('DOM.getDocument')
q = await cmd('DOM.querySelector', {'nodeId': doc['result']['root']['nodeId'], 'selector': '#pick'})
files = sorted(glob.glob('/home/user/Projects/simile/reference/catalogue/*.pl'))
await cmd('DOM.setFileInputFiles', {'nodeId': q['result']['nodeId'], 'files': files})
for i in range(120):
    s = await ev("document.getElementById('summary').textContent")
    if s and 'waiting' not in s and 'reading' not in s: break
    await sleep(1)
print(len(files), 'files ->', s)
print(await ev("[...document.querySelectorAll('#detail tr')].filter(r=>/refus/i.test(r.textContent)).map(r=>r.textContent.replace(/\\s+/g,' ').slice(0,160)).join('\\n')"))
