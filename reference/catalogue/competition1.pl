source(program='AME',version= 9.0,edition=standard,date='Tue Feb 05 17:12:26 GMT 2008').

roots([node00002,node00003,node00004,node00005,node00006,node00007,node00008,node00009,node00010,node00011,node00012,node00013,node00014,node00015,node00016,node00017,node00018,node00019,node00020,node00021]).

properties([complete-true,file_name-'C:/Inetpub/wwwroot/www/examples/catalogue/models/bob/competition1/competition1.sml',name-competition1]).

node(node00002,compartment,[],[complete=true,name='N1'],[caption_offset=[0,0],centre=[220,75]]).
node(node00003,function,[],[complete=true,name=fn1,units=1,value=1],[]).
node(node00004,compartment,[],[complete=true,name='N2'],[caption_offset=[0,0],centre=[221,135]]).
node(node00005,function,[],[complete=true,name=fn2,units=1,value=1],[]).
node(node00006,cloud,[],[complete=true,name=cd1],[centre=[123,80]]).
node(node00007,function,[],[complete=true,name=fn3,units=1*1*1,value=r1*'N1'*(1-b1*'N1'-c1*'N2')],[]).
node(node00008,cloud,[],[complete=true,name=cd2],[centre=[124,134]]).
node(node00009,function,[],[complete=true,name=fn4,units=1*1*1,value=r2*'N2'*(1-b2*'N1'-c2*'N1')],[]).
node(node00010,variable,[],[complete=true,name=r1],[caption_offset=[-8,-3],centre=[124,44]]).
node(node00011,function,[],[complete=true,name=fn5,units=1,value= 0.1],[]).
node(node00012,variable,[],[complete=true,name=b1],[caption_offset=[-15,-18],centre=[165,44]]).
node(node00013,function,[],[complete=true,name=fn6,units=1,value= 0.01],[]).
node(node00014,variable,[],[complete=true,name=c1],[caption_offset=[15,-15],centre=[192,44]]).
node(node00015,function,[],[complete=true,name=fn7,units=1,value= 0.005],[]).
node(node00016,variable,[],[complete=true,name=r2],[caption_offset=[-10,-27],centre=[120,166]]).
node(node00017,function,[],[complete=true,name=fn8,units=1,value= 0.1],[]).
node(node00018,variable,[],[complete=true,name=b2],[caption_offset=[-16,-18],centre=[160,169]]).
node(node00019,function,[],[complete=true,name=fn9,units=1,value= 0.01],[]).
node(node00020,variable,[],[complete=true,name=c2],[caption_offset=[17,-15],centre=[184,166]]).
node(node00021,function,[],[complete=true,name=fn10,units=1,value= 0.02],[]).

arc(arc00001,node00003,node00002,influence,[name=i1],[]).
arc(arc00002,node00005,node00004,influence,[name=i2],[]).
arc(arc00003,node00006,node00002,flow,[complete=true,name=repro1],[caption_offset=[-33,1],curve=[550,254]]).
arc(arc00004,node00007,arc00003,influence,[name=i3],[]).
arc(arc00013,node00002,node00007,influence,[complete=true,name=i11,role=[use(none,in_hierarchy,'N1',1)]],[curve=[2,30]]).
arc(arc00017,node00004,node00007,influence,[complete=true,name=i15,role=[use(none,in_hierarchy,'N2',1)]],[curve=[-10,11]]).
arc(arc00005,node00008,node00004,flow,[complete=true,name=repro2],[caption_offset=[-34,-38],curve=[550,254]]).
arc(arc00006,node00009,arc00005,influence,[name=i4],[]).
arc(arc00018,node00002,node00009,influence,[complete=true,name=i16,role=[use(none,in_hierarchy,'N1',1)]],[curve=[10,11]]).
arc(arc00019,node00004,node00009,influence,[complete=true,name=i17,role=[use(none,in_hierarchy,'N2',1)]],[curve=[2,21]]).
arc(arc00016,node00010,node00007,influence,[complete=true,name=i14,role=[use(none,in_hierarchy,r1,1)]],[curve=[5,-4]]).
arc(arc00007,node00011,node00010,influence,[name=i5],[]).
arc(arc00015,node00012,node00007,influence,[complete=true,name=i13,role=[use(none,in_hierarchy,b1,1)]],[curve=[4,1]]).
arc(arc00008,node00013,node00012,influence,[name=i6],[]).
arc(arc00014,node00014,node00007,influence,[complete=true,name=i12,role=[use(none,in_hierarchy,c1,1)]],[curve=[6,7]]).
arc(arc00009,node00015,node00014,influence,[name=i7],[]).
arc(arc00020,node00016,node00009,influence,[complete=true,name=i18,role=[use(none,in_hierarchy,r2,1)]],[curve=[-6,-6]]).
arc(arc00010,node00017,node00016,influence,[name=i8],[]).
arc(arc00021,node00018,node00009,influence,[complete=true,name=i19,role=[use(none,in_hierarchy,b2,1)]],[curve=[-4,1]]).
arc(arc00011,node00019,node00018,influence,[name=i9],[]).
arc(arc00022,node00020,node00009,influence,[complete=true,name=i20,role=[use(none,in_hierarchy,c2,1)]],[curve=[-6,5]]).
arc(arc00012,node00021,node00020,influence,[name=i10],[]).

