# Drive a persistent headless Chrome on :9350. Usage: python3 cdp.py script.py
# The script gets async helpers: ev(js), shot(name, clip=None), click(x,y), drag(pts), key(text), nav(url), sleep
import asyncio, json, sys, base64, urllib.request, websockets
import os
HERE=os.path.dirname(os.path.abspath(__file__))+'/'
# Screenshots land in OUT (relative names such as 'tr/s1-run.png' make subfolders there).
OUT=os.environ.get('HEADLESS_OUT', os.getcwd())+'/'
tabs=json.load(urllib.request.urlopen('http://127.0.0.1:9350/json'))
ws_url=[t for t in tabs if t['type']=='page'][0]['webSocketDebuggerUrl']
async def main():
    async with websockets.connect(ws_url, max_size=None) as ws:
        n=[0]
        async def cmd(m,p=None):
            n[0]+=1; i=n[0]; await ws.send(json.dumps({'id':i,'method':m,'params':p or {}}))
            while True:
                r=json.loads(await ws.recv())
                if r.get('method')=='Runtime.exceptionThrown': print('EXC',r['params']['exceptionDetails'].get('exception',{}).get('description'))
                if r.get('id')==i: return r
        await cmd('Runtime.enable')
        async def ev(js):
            r=await cmd('Runtime.evaluate',{'expression':js,'returnByValue':True,'awaitPromise':True})
            res=r.get('result',{})
            if 'exceptionDetails' in res: print('JSERR',res['exceptionDetails'].get('exception',{}).get('description')); return None
            return res.get('result',{}).get('value')
        async def shot(name, clip=None, scale=1):
            p={'format':'png'}
            if clip: p['clip']=dict(x=clip[0],y=clip[1],width=clip[2],height=clip[3],scale=scale)
            r=await cmd('Page.captureScreenshot',p); os.makedirs(os.path.dirname(OUT+name), exist_ok=True); open(OUT+name,'wb').write(base64.b64decode(r['result']['data']))
        async def mouse(t,x,y,b='left',cc=1,buttons=None):
            await cmd('Input.dispatchMouseEvent',{'type':t,'x':x,'y':y,'button':b,'clickCount':cc,'buttons':(1 if buttons is None and t!='mouseReleased' else (buttons or 0))})
        async def click(x,y,cc=1):
            await mouse('mouseMoved',x,y,'none',buttons=0); await mouse('mousePressed',x,y,cc=cc); await mouse('mouseReleased',x,y,cc=cc); await asyncio.sleep(0.15)
        async def drag(pts):
            await mouse('mouseMoved',*pts[0],'none',buttons=0); await mouse('mousePressed',*pts[0])
            for p in pts[1:]: await mouse('mouseMoved',*p,buttons=1); await asyncio.sleep(0.03)
            await mouse('mouseReleased',*pts[-1]); await asyncio.sleep(0.15)
        async def key(text):
            await cmd('Input.insertText',{'text':text})
        async def press(k, code=None, vk=0):
            await cmd('Input.dispatchKeyEvent',{'type':'keyDown','key':k,'code':code or k,'windowsVirtualKeyCode':vk})
            await cmd('Input.dispatchKeyEvent',{'type':'keyUp','key':k,'code':code or k,'windowsVirtualKeyCode':vk})
        async def nav(url):
            await cmd('Page.navigate',{'url':url}); await asyncio.sleep(1.5)
        g=dict(json=json,open=open,ev=ev,shot=shot,click=click,drag=drag,key=key,press=press,nav=nav,cmd=cmd,sleep=asyncio.sleep,mouse=mouse)
        src=open(sys.argv[1]).read().replace("exec(open('lib.py').read(), globals())", open(HERE+"lib.py").read())
        exec('async def _run():\n'+'\n'.join('    '+l for l in src.splitlines())+'\n    pass', g)
        await g['_run']()
asyncio.run(main())
