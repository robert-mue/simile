# The editor regression page: run it and print the bar and any failures.
await nav('http://localhost:8731/test/editor.html'); await sleep(2)
for i in range(120):
    s = await ev("document.getElementById('summary').textContent")
    if s and 'running' not in s and 'loading' not in s: break
    await sleep(0.5)
print('editor ::', s)
print(await ev("[...document.querySelectorAll('#results tbody tr')].filter(r=>!r.querySelector('td.ok')).map(r=>r.cells[0].textContent+': '+r.cells[2].innerText.replace(/\\n/g,' | ')).join('\\n')"))
