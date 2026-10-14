for page in ['tutorials/trees','tutorials/predator-prey','tutorials/bank-account','pages']:
    await nav('file:///home/user/Projects/simile/help/%s.html' % page)
    await cmd('Emulation.setDeviceMetricsOverride',{'width':390,'height':800,'deviceScaleFactor':1,'mobile':True}); await sleep(0.5)
    print(page, 'phone scrollWidth', await ev("document.documentElement.scrollWidth"), 'images', await ev("document.images.length+' broken '+[...document.images].filter(i=>!i.naturalWidth).length"), 'bad anchors', await ev("[...document.querySelectorAll('a[href^=\"#\"]')].filter(a=>!document.getElementById(a.getAttribute('href').slice(1))).length"))
    await cmd('Emulation.clearDeviceMetricsOverride')
