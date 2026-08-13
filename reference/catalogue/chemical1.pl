source(program='AME',version= 9.0,edition=standard,date='Tue Feb 05 17:10:29 GMT 2008').

roots([node00002,node00003,node00004,node00005,node00006,node00007,node00008,node00009,node00010,node00011,node00012,node00013,node00014,node00015,node00016,node00017,node00018,node00020,node00021,node00022,node00023]).

properties([complete-true,file_name-'C:/Inetpub/wwwroot/www/examples/catalogue/models/bob/chemical1/chemical1.sml',name-chemical1]).

node(node00002,compartment,[],[complete=true,name='CO2'],[caption_offset=[0,0],centre=[58,48]]).
node(node00003,compartment,[],[complete=true,name='H2O'],[caption_offset=[0,0],centre=[66,154]]).
node(node00004,compartment,[],[complete=true,name='C6H12O6'],[caption_offset=[0,0],centre=[377,49]]).
node(node00005,compartment,[],[complete=true,name='O2'],[caption_offset=[0,0],centre=[377,148]]).
node(node00006,cloud,[],[complete=true,name=cd1],[centre=[158,-4]]).
node(node00007,function,[],[complete=true,name=fn1,spec=[54,42,114,97,116,101],units=1,value=6*rate],[]).
node(node00008,cloud,[],[complete=true,name=cd2],[centre=[156,207]]).
node(node00009,function,[],[complete=true,name=fn2,units=1,value=6*rate],[]).
node(node00010,cloud,[],[complete=true,name=cd3],[centre=[257,-1]]).
node(node00011,function,[],[complete=true,name=fn3,units=1,value=rate],[]).
node(node00012,cloud,[],[complete=true,name=cd4],[centre=[257,208]]).
node(node00013,function,[],[complete=true,name=fn4,units=1,value=6*rate],[]).
node(node00014,cloud,[],[complete=true,name=cd5],[centre=[-38,47]]).
node(node00015,function,[],[complete=true,name=fn5,spec=[48],units=int,value=0],[]).
node(node00016,variable,[],[complete=true,name=rate],[caption_offset=[7,-2],centre=[205,80]]).
node(node00017,function,[],[complete=true,name=fn6,spec=[48,46,48,49,42,67,79,50,42,50,42,40,116,101,109,112,101,114,97,116,117,114,101,47,49,48,41],units=1,value= 0.01 *'CO2'*2*(temperature/10)],[]).
node(node00018,variable,[],[complete=true,max_val=40,min_val=0,name=temperature,spec=[],units=1],[caption_offset=[0,0],centre=[-11,118]]).
node(node00020,function,[],[complete=true,spec=[49,48,48],units=1,value=100],[]).
node(node00021,function,[],[complete=true,spec=[49,48,48],units=1,value=100],[]).
node(node00022,function,[],[complete=true,spec=[48],units=1,value=0],[]).
node(node00023,function,[],[complete=true,spec=[48],units=1,value=0],[]).

arc(arc00001,node00002,node00006,flow,[complete=true,name='CO2_used'],[caption_offset=[27,-15],curve=[588,505]]).
arc(arc00002,node00007,arc00001,influence,[name=i1],[]).
arc(arc00003,node00003,node00008,flow,[complete=true,name='H2O_used'],[caption_offset=[30,-21],curve=[597,495]]).
arc(arc00004,node00009,arc00003,influence,[name=i2],[]).
arc(arc00005,node00010,node00004,flow,[complete=true,name=sugar_made],[caption_offset=[-74,-21],curve=[596,500]]).
arc(arc00006,node00011,arc00005,influence,[name=i3],[]).
arc(arc00007,node00012,node00005,flow,[complete=true,name='O2_made'],[caption_offset=[-62,-20],curve=[591,504]]).
arc(arc00008,node00013,arc00007,influence,[name=i4],[]).
arc(arc00009,node00014,node00002,flow,[complete=true,name=from_atmos],[caption_offset=[-20,-41],curve=[550,508]]).
arc(arc00010,node00015,arc00009,influence,[name=i5],[]).
arc(arc00012,node00016,node00007,influence,[complete=true,name=i7,role=[use(none,in_hierarchy,rate,1)]],[curve=[-13,18]]).
arc(arc00013,node00016,node00011,influence,[complete=true,name=i8,role=[use(none,in_hierarchy,rate,1)]],[curve=[-13,-24]]).
arc(arc00014,node00016,node00013,influence,[complete=true,name=i9,role=[use(none,in_hierarchy,rate,1)]],[curve=[22,-26]]).
arc(arc00015,node00016,node00009,influence,[complete=true,name=i10,role=[use(none,in_hierarchy,rate,1)]],[curve=[22,18]]).
arc(arc00011,node00017,node00016,influence,[name=i6],[]).
arc(arc00016,node00002,node00017,influence,[complete=true,name=i11,role=[use(none,in_hierarchy,'CO2',1)]],[curve=[-12,16]]).
arc(arc00018,node00018,node00017,influence,[complete=true,name=i13,role=[use(none,in_hierarchy,temperature,1)]],[curve=[33,24]]).
arc(arc00019,node00020,node00002,influence,[],[]).
arc(arc00020,node00021,node00003,influence,[],[]).
arc(arc00021,node00022,node00004,influence,[],[]).
arc(arc00022,node00023,node00005,influence,[],[]).

