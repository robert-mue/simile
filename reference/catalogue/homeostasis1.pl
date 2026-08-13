source(program='AME',version= 9.0,edition=standard,date='Wed Feb 06 15:32:47 GMT 2008').

roots([node00002,node00003,node00004,node00005,node00006,node00007,node00008,node00009,node00010,node00011]).

properties([complete-true,file_name-'C:/Inetpub/wwwroot/www/examples/catalogue/models/bob/homeostasis1/homeostasis1.sml',name-homeostasis1]).

node(node00002,compartment,[],[complete=true,name='body heat'],[caption_offset=[0,0],centre=[242,136]]).
node(node00003,function,[],[complete=true,name=fn1,units=1,value=1000],[]).
node(node00004,cloud,[],[complete=true,name=cd1],[centre=[122,135]]).
node(node00005,function,[],[complete=true,name=fn2,units=int,value=(if body_temperature<set_point then 10 else 0)],[]).
node(node00006,cloud,[],[complete=true,name=cd2],[centre=[346,137]]).
node(node00007,function,[],[complete=true,name=fn3,units=1,value= 0.1 *body_temperature],[]).
node(node00008,variable,[],[complete=true,name='body temperature'],[caption_offset=[-2,-38],centre=[225,68]]).
node(node00009,function,[],[complete=true,name=fn4,units=1,value= 0.03 *body_heat],[]).
node(node00010,variable,[],[complete=true,name='set point'],[caption_offset=[3,-31],centre=[125,79]]).
node(node00011,function,[],[complete=true,name=fn5,units=int,value=37],[]).

arc(arc00001,node00003,node00002,influence,[name=i1],[]).
arc(arc00002,node00004,node00002,flow,[complete=true,name=metabolism],[caption_offset=[-61,2],curve=[550,500]]).
arc(arc00003,node00005,arc00002,influence,[name=i2],[]).
arc(arc00004,node00002,node00006,flow,[complete=true,name='heat loss'],[caption_offset=[-20,2],curve=[550,493]]).
arc(arc00005,node00007,arc00004,influence,[name=i3],[]).
arc(arc00008,node00008,node00007,influence,[complete=true,name=i6,role=[use(none,in_hierarchy,body_temperature,1)]],[curve=[14,-16]]).
arc(arc00009,node00008,node00005,influence,[complete=true,name=i7,role=[use(none,in_hierarchy,body_temperature,1)]],[curve=[12,8]]).
arc(arc00006,node00009,node00008,influence,[name=i4],[]).
arc(arc00007,node00002,node00009,influence,[complete=true,name=i5,role=[use(none,in_hierarchy,body_heat,1)]],[curve=[-12,2]]).
arc(arc00011,node00010,node00005,influence,[complete=true,name=i9,role=[use(none,in_hierarchy,set_point,int)]],[curve=[12,-7]]).
arc(arc00010,node00011,node00010,influence,[name=i8],[]).

