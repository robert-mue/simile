source(program='AME',version= 9.0,edition=standard,date='Wed Feb 06 17:05:29 GMT 2008').

roots([node00002,node00003,node00004,node00005,node00006,node00007,node00008,node00009,node00010,node00011,node00012,node00013,node00014,node00015,node00016,node00017,node00018,node00019,node00022,node00023]).

properties([complete-true,file_name-'C:/Inetpub/wwwroot/www/examples/catalogue/models/bob/competition1/competition1.sml',name-predator_prey32]).

node(node00002,compartment,[],[complete=true,description='Prey',name=x],[caption_offset=[0,0],centre=[267,78]]).
node(node00003,function,[],[complete=true,name=fn1,spec=[49,48],units=1,value=10],[]).
node(node00004,compartment,[],[complete=true,description=predator,name=y],[caption_offset=[0,0],centre=[279,210]]).
node(node00005,function,[],[complete=true,name=fn2,spec=[48,46,48,50],units=1,value= 0.02],[]).
node(node00006,cloud,[],[complete=true,name=cd1],[centre=[68,83]]).
node(node00007,function,[],[complete=true,name=fn3,spec=[114,42,120,42,40,49,45,40,120,47,75,41,41,45,97,42,120,42,120,47,40,120,42,120,43,76,41,42,121],units=1,value=r*x*(1-x/'K')-a*x*x/(x*x+'L')*y],[]).
node(node00008,cloud,[],[complete=true,name=cd2],[centre=[62,192]]).
node(node00009,function,[],[complete=true,name=fn4,spec=[103,42,121,42,40,97,42,120,42,120,47,40,120,42,120,43,76,41,41,45,109,42,121],units=1,value=g*y*(a*x*x/(x*x+'L'))-m*y],[]).
node(node00010,variable,[],[complete=true,name=r],[caption_offset=[-8,-3],centre=[125,-3]]).
node(node00011,function,[],[complete=true,name=fn5,spec=[48,46,48,54],units=1,value= 0.06],[]).
node(node00012,variable,[],[complete=true,name='K'],[caption_offset=[-15,-18],centre=[203,-3]]).
node(node00013,function,[],[complete=true,name=fn6,spec=[49,48,48,48],units=1,value=1000],[]).
node(node00014,variable,[],[complete=true,name=a],[caption_offset=[15,-15],centre=[11,145]]).
node(node00015,function,[],[complete=true,name=fn7,spec=[53],units=1,value=5],[]).
node(node00016,variable,[],[complete=true,name=g],[caption_offset=[-10,-27],centre=[51,264]]).
node(node00017,function,[],[complete=true,name=fn8,spec=[48,46,50],units=1,value= 0.2],[]).
node(node00018,variable,[],[complete=true,name=m],[caption_offset=[-16,-18],centre=[137,255]]).
node(node00019,function,[],[complete=true,name=fn9,spec=[48,46,57],units=1,value= 0.9],[]).
node(node00022,variable,[],[complete=true,name='L'],[caption_offset=[0,0],centre=[18,30]]).
node(node00023,function,[],[complete=true,name=fn1_0,spec=[53,48],units=int,value=50],[]).

arc(arc00001,node00003,node00002,influence,[name=i1],[]).
arc(arc00002,node00005,node00004,influence,[name=i2],[]).
arc(arc00003,node00006,node00002,flow,[complete=true,name=repro1],[caption_offset=[-33,1],curve=[550,500]]).
arc(arc00004,node00007,arc00003,influence,[name=i3],[]).
arc(arc00013,node00002,node00007,influence,[complete=true,name=i11,role=[use(none,in_hierarchy,x,1)]],[curve=[2,19]]).
arc(arc00017,node00004,node00007,influence,[complete=true,name=i15,role=[use(none,in_hierarchy,y,1)]],[curve=[-26,24]]).
arc(arc00005,node00008,node00004,flow,[complete=true,name=repro2],[caption_offset=[-34,-38],curve=[550,500]]).
arc(arc00006,node00009,arc00005,influence,[name=i4],[]).
arc(arc00018,node00002,node00009,influence,[complete=true,name=i16,role=[use(none,in_hierarchy,x,1)]],[curve=[24,20]]).
arc(arc00019,node00004,node00009,influence,[complete=true,name=i17,role=[use(none,in_hierarchy,y,1)]],[curve=[-3,21]]).
arc(arc00016,node00010,node00007,influence,[complete=true,name=i14,role=[use(none,in_hierarchy,r,1)]],[curve=[17,-8]]).
arc(arc00007,node00011,node00010,influence,[name=i5],[]).
arc(arc00015,node00012,node00007,influence,[complete=true,name=i13,role=[use(none,in_hierarchy,'K',1)]],[curve=[18,7]]).
arc(arc00008,node00013,node00012,influence,[name=i6],[]).
arc(arc00025,node00014,node00009,influence,[complete=true,name=i3_0,role=[use(none,in_hierarchy,a,1)]],[curve=[-15,-13]]).
arc(arc00027,node00014,node00007,influence,[complete=true,name=i5_0,role=[use(none,in_hierarchy,a,1)]],[curve=[-27,9]]).
arc(arc00009,node00015,node00014,influence,[name=i7],[]).
arc(arc00020,node00016,node00009,influence,[complete=true,name=i18,role=[use(none,in_hierarchy,g,1)]],[curve=[-4,-6]]).
arc(arc00010,node00017,node00016,influence,[name=i8],[]).
arc(arc00021,node00018,node00009,influence,[complete=true,name=i19,role=[use(none,in_hierarchy,m,1)]],[curve=[-10,-5]]).
arc(arc00011,node00019,node00018,influence,[name=i9],[]).
arc(arc00024,node00022,node00007,influence,[complete=true,name=i2_0,role=[use(none,in_hierarchy,'L',int)]],[curve=[14,-30]]).
arc(arc00026,node00022,node00009,influence,[complete=true,name=i4_0,role=[use(none,in_hierarchy,'L',int)]],[curve=[-18,22]]).
arc(arc00023,node00023,node00022,influence,[name=i1_0],[]).

