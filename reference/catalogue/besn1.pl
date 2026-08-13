source(program='AME',version= 9.0,edition=standard,date='Tue Feb 05 11:26:57 GMT 2008').

roots([node00002,node00003,node00004,node00005,node00006,node00007,node00008,node00009,node00010,node00011,node00012,node00013,node00014,node00015,node00016,node00017,node00018,node00019,node00020,node00021]).

properties([complete-true,file_name-'C:/Inetpub/wwwroot/www/examples/catalogue/models/bob/besn1/besn1.sml',name-besn1]).

node(node00002,compartment,[],[complete=true,name=canopy],[caption_offset=[0,-48],centre=[154,-18]]).
node(node00003,compartment,[],[complete=true,name=harvest],[caption_offset=[0,0],centre=[-29,-20]]).
node(node00004,compartment,[],[complete=true,name=litter],[caption_offset=[0,0],centre=[-9,143]]).
node(node00005,compartment,[],[complete=true,name=wood],[caption_offset=[0,0],centre=[289,135]]).
node(node00006,compartment,[],[complete=true,name=soil],[caption_offset=[-25,1],centre=[147,204]]).
node(node00007,function,[],[complete=true,name=fn1,units=1,value= 0.9 *canopy],[]).
node(node00008,cloud,[],[complete=true,name=cd1],[centre=[314,-22]]).
node(node00009,function,[],[complete=true,name=fn2,units=1,value=50],[]).
node(node00010,function,[],[complete=true,name=fn3,units=1,value= 0.9 *canopy],[]).
node(node00011,function,[],[complete=true,name=fn4,units=1,value= 0.9 *litter],[]).
node(node00012,function,[],[complete=true,name=fn5,units=1,value= 0.01 *wood],[]).
node(node00013,function,[],[complete=true,name=fn6,units=1,value= 0.5 *canopy],[]).
node(node00014,function,[],[complete=true,name=fn7,units=1,value= 0.5 *soil],[]).
node(node00015,cloud,[],[complete=true,name=cd2],[centre=[151,292]]).
node(node00016,function,[],[complete=true,name=fn8,units=1,value= 0.01 *soil],[]).
node(node00017,function,[],[complete=true,units=1,value=0],[]).
node(node00018,function,[],[complete=true,units=1,value=0],[]).
node(node00019,function,[],[complete=true,units=1,value=0],[]).
node(node00020,function,[],[complete=true,units=1,value=0],[]).
node(node00021,function,[],[complete=true,units=1,value=0],[]).

arc(arc00001,node00002,node00003,flow,[complete=true,name=flow1],[caption_offset=[-7,-44],curve=[550,776]]).
arc(arc00005,node00002,node00004,flow,[complete=true,name=flow3],[caption_offset=[0,0],curve=[602,499]]).
arc(arc00011,node00002,node00005,flow,[complete=true,name=flow6],[caption_offset=[0,0],curve=[593,498]]).
arc(arc00007,node00004,node00006,flow,[complete=true,name=flow4],[caption_offset=[-41,-9],curve=[595,496]]).
arc(arc00009,node00005,node00006,flow,[complete=true,name=flow5],[caption_offset=[0,0],curve=[608,497]]).
arc(arc00013,node00006,node00002,flow,[complete=true,name=flow7],[caption_offset=[0,0],curve=[550,500]]).
arc(arc00002,node00007,arc00001,influence,[name=i1],[]).
arc(arc00017,node00002,node00007,influence,[complete=true,name=i9,role=[use(none,in_hierarchy,canopy,1)]],[curve=[0,26]]).
arc(arc00003,node00008,node00002,flow,[complete=true,name=flow2],[caption_offset=[-17,-43],curve=[550,504]]).
arc(arc00004,node00009,arc00003,influence,[name=i2],[]).
arc(arc00006,node00010,arc00005,influence,[name=i3],[]).
arc(arc00019,node00002,node00010,influence,[complete=true,name=i11,role=[use(none,in_hierarchy,canopy,1)]],[curve=[14,18]]).
arc(arc00008,node00011,arc00007,influence,[name=i4],[]).
arc(arc00021,node00004,node00011,influence,[complete=true,name=i13,role=[use(none,in_hierarchy,litter,1)]],[curve=[4,-15]]).
arc(arc00010,node00012,arc00009,influence,[name=i5],[]).
arc(arc00022,node00005,node00012,influence,[complete=true,name=i14,role=[use(none,in_hierarchy,wood,1)]],[curve=[4,12]]).
arc(arc00012,node00013,arc00011,influence,[name=i6],[]).
arc(arc00018,node00002,node00013,influence,[complete=true,name=i10,role=[use(none,in_hierarchy,canopy,1)]],[curve=[16,-12]]).
arc(arc00014,node00014,arc00013,influence,[name=i7],[]).
arc(arc00020,node00006,node00014,influence,[complete=true,name=i12,role=[use(none,in_hierarchy,soil,1)]],[curve=[-23,0]]).
arc(arc00015,node00006,node00015,flow,[complete=true,name=flow8],[caption_offset=[18,-15],curve=[550,492]]).
arc(arc00016,node00016,arc00015,influence,[name=i8],[]).
arc(arc00023,node00006,node00016,influence,[complete=true,name=i15,role=[use(none,in_hierarchy,soil,1)]],[curve=[6,0]]).
arc(arc00024,node00017,node00002,influence,[],[]).
arc(arc00025,node00018,node00003,influence,[],[]).
arc(arc00026,node00019,node00004,influence,[],[]).
arc(arc00027,node00020,node00005,influence,[],[]).
arc(arc00028,node00021,node00006,influence,[],[]).

