source(program='AME',version= 9.0,edition=standard,date='Wed Feb 06 15:34:01 GMT 2008').

roots([node00002]).

properties([complete-true,file_name-'C:/Inetpub/wwwroot/www/examples/catalogue/models/bob/hunter1/hunter1.sml',name-hunter1]).

node(node00002,submodel,[node00003,node00004,node00005,node00006,node00007,node00008,node00009,node00010,node00011,node00012,node00013,node00014,node00015,node00016,node00017,node00018,node00019,node00020],[complete=true,fill_colour='#ffaeae',multiplication_spec=[count=[10]],name='PREDATOR',separate=0],[bounding_box=[-24,-17,273,215],caption_offset=[13,-1],internal_extent=[-2,-2,298,233]]).
node(node00003,compartment,[],[complete=true,name='XNW'],[caption_offset=[-1,-48],centre=[246,42]]).
node(node00004,compartment,[],[complete=true,name='Dir'],[caption_offset=[0,0],centre=[43,77]]).
node(node00005,compartment,[],[complete=true,name='Y'],[caption_offset=[0,0],centre=[252,169]]).
node(node00006,cloud,[],[complete=true,name=cd5],[centre=[123,35]]).
node(node00007,function,[],[complete=true,name=fn8,units=1,value=(if outside==1 then speed*cos(dir+ 3.14) else speed*cos(dir))],[]).
node(node00008,cloud,[],[complete=true,name=cd6],[centre=[130,77]]).
node(node00009,function,[],[complete=true,name=fn9,units=1,value=(if outside==1 then  3.14/dt(1) else rand( -0.4, 0.4)/dt(1))],[]).
node(node00010,cloud,[],[complete=true,name=cd7],[centre=[94,169]]).
node(node00011,function,[],[complete=true,name=fn10,units=1,value=(if outside==1 then speed*sin(dir+ 3.14) else speed*sin(dir))],[]).
node(node00012,variable,[],[complete=true,name=speed],[caption_offset=[10,-31],centre=[259,105]]).
node(node00013,function,[],[complete=true,name=fn11,units=1,value=5],[]).
node(node00014,variable,[],[complete=true,name=size],[caption_offset=[0,0],centre=[36,190]]).
node(node00015,function,[],[complete=true,name=fn1,units=1,value=3],[]).
node(node00016,variable,[],[complete=true,name=outside],[caption_offset=[34,-13],centre=[176,99]]).
node(node00017,function,[],[complete=true,name=fn21,units=1,value=(if (x<0;x>100;y<0;y>100) then 1 else 0)],[]).
node(node00018,function,[],[complete=true,units=1,value=rand(30,70)],[]).
node(node00019,function,[],[complete=true,units=1,value=rand(0, 6.28)],[]).
node(node00020,function,[],[complete=true,units=1,value=rand(30,70)],[]).

arc(arc00001,node00006,node00003,flow,[complete=true,name=xchange],[caption_offset=[-23,-40],curve=[550,495]]).
arc(arc00002,node00007,arc00001,influence,[name=i8],[]).
arc(arc00009,node00004,node00007,influence,[complete=true,name=i13,role=[use(none,in_hierarchy,dir,1)]],[curve=[2,-64]]).
arc(arc00003,node00008,node00004,flow,[complete=true,name=dirchange],[caption_offset=[-4,-38],curve=[550,500]]).
arc(arc00004,node00009,arc00003,influence,[name=i9],[]).
arc(arc00005,node00010,node00005,flow,[complete=true,name=ychange],[caption_offset=[-10,-1],curve=[550,500]]).
arc(arc00006,node00011,arc00005,influence,[name=i10],[]).
arc(arc00010,node00004,node00011,influence,[complete=true,name=i14,role=[use(none,in_hierarchy,dir,1)]],[curve=[18,-25]]).
arc(arc00008,node00012,node00007,influence,[complete=true,name=i12,role=[use(none,in_hierarchy,speed,1)]],[curve=[-14,11]]).
arc(arc00011,node00012,node00011,influence,[complete=true,name=i15,role=[use(none,in_hierarchy,speed,1)]],[curve=[14,14]]).
arc(arc00007,node00013,node00012,influence,[name=i11],[]).
arc(arc00012,node00015,node00014,influence,[name=i1],[]).
arc(arc00016,node00016,node00007,influence,[complete=true,name=i55,role=[use(none,in_hierarchy,outside,1)]],[curve=[-12,-1]]).
arc(arc00017,node00016,node00009,influence,[complete=true,name=i56,role=[use(none,in_hierarchy,outside,1)]],[curve=[-5,18]]).
arc(arc00018,node00016,node00011,influence,[complete=true,name=i57,role=[use(none,in_hierarchy,outside,1)]],[curve=[12,1]]).
arc(arc00013,node00017,node00016,influence,[name=i52],[]).
arc(arc00014,node00003,node00017,influence,[complete=true,name=i53,role=[use(none,in_hierarchy,x,1)]],[curve=[8,12]]).
arc(arc00015,node00005,node00017,influence,[complete=true,name=i54,role=[use(none,in_hierarchy,y,1)]],[curve=[-14,14]]).
arc(arc00019,node00018,node00003,influence,[],[]).
arc(arc00020,node00019,node00004,influence,[],[]).
arc(arc00021,node00020,node00005,influence,[],[]).

