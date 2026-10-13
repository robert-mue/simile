for pg in ['index','fixtures']:
    await nav('file:///home/user/Projects/simile/test/%s.html' % pg); await sleep(6)
    t = await ev("document.body.innerText")
    print(pg, '::', t[300:900].replace('\n',' | '))
