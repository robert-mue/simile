source(program='AME',version= 9.0,edition=standard,date='Wed Feb 06 13:00:59 GMT 2008').

roots([node00002,node00003,node00004,node00005,node00006,node00007,node00008,node00009,node00010,node00011,node00012,node00013,node00014,node00015,node00016,node00017,node00018,node00019]).

properties([complete-true,file_name-'C:/Inetpub/wwwroot/www/examples/catalogue/models/ford/p058/p058.sim',name-p058,separate-0]).

node(node00002,compartment,[],[comment='hectares (OK, Ford says acres, but we are in the 21st century now).',complete=true,name='area of flowers'],[caption_offset=[4,-47],centre=[160,-92]]).
node(node00003,function,[],[complete=true,name=fn1,units=1,value=10],[]).
node(node00004,cloud,[],[complete=true,name=cd1],[centre=[29,-92]]).
node(node00005,function,[],[complete=true,name=fn2,units=1*1,value=area_of_flowers*actual_growth_rate],[]).
node(node00006,cloud,[],[complete=true,name=cd2],[centre=[301,-92]]).
node(node00007,function,[],[complete=true,name=fn3,units=1*1,value=area_of_flowers*decay_rate],[]).
node(node00008,variable,[],[comment='I.e. 100% per year',complete=true,name='intrinsic growth rate'],[caption_offset=[-12,-31],centre=[-29,-95]]).
node(node00009,function,[],[complete=true,name=fn4,units=1,value=1],[]).
node(node00010,variable,[],[comment=dimensionless,complete=true,name='actual growth rate'],[caption_offset=[-26,1],centre=[14,-24]]).
node(node00011,function,[],[complete=true,name=fn5,units=1*1,value=intrinsic_growth_rate*growth_rate_multiplier],[]).
node(node00012,variable,[],[complete=true,name='growth rate multiplier'],[caption_offset=[2,3],centre=[79,-2]]).
node(node00013,function,[],[complete=true,name=fn6,table_data=[file='/graph/',data=[1,0,400],indices=[0,1,400,0],current=[0,80,160,240,320,400],units=1,bounds=1,dims=6],units=1,value=graph(fraction_occupied)],[]).
node(node00014,variable,[],[complete=true,name='fraction occupied'],[caption_offset=[4,0],centre=[167,-23]]).
node(node00015,function,[],[complete=true,name=fn7,units=1/1,value=area_of_flowers/suitable_area],[]).
node(node00016,variable,[],[comment='hectares (see ''area of flowers''...)',complete=true,name='suitable area'],[caption_offset=[0,0],centre=[250,-3]]).
node(node00017,function,[],[complete=true,name=fn8,units=1,value=1000],[]).
node(node00018,variable,[],[comment='Proportion decaying (per year)',complete=true,name='decay rate'],[caption_offset=[3,0],centre=[277,-49]]).
node(node00019,function,[],[complete=true,name=fn9,units=1,value= 0.2],[]).

arc(arc00001,node00003,node00002,influence,[name=i1],[]).
arc(arc00002,node00004,node00002,flow,[complete=true,name=growth],[caption_offset=[-35,-39],curve=[550,495]]).
arc(arc00003,node00005,arc00002,influence,[name=i2],[]).
arc(arc00015,node00002,node00005,influence,[complete=true,name=i13,role=[use(none,in_hierarchy,area_of_flowers,1)]],[curve=[2,26]]).
arc(arc00004,node00002,node00006,flow,[complete=true,name=decay],[caption_offset=[-22,-41],curve=[550,500]]).
arc(arc00005,node00007,arc00004,influence,[name=i3],[]).
arc(arc00019,node00002,node00007,influence,[complete=true,name=i17,role=[use(none,in_hierarchy,area_of_flowers,1)]],[curve=[4,-22]]).
arc(arc00006,node00009,node00008,influence,[name=i4],[]).
arc(arc00013,node00010,node00005,influence,[complete=true,name=i11,role=[use(none,in_hierarchy,actual_growth_rate,1)]],[curve=[-15,-16]]).
arc(arc00007,node00011,node00010,influence,[name=i5],[]).
arc(arc00012,node00008,node00011,influence,[complete=true,name=i10,role=[use(none,in_hierarchy,intrinsic_growth_rate,1)]],[curve=[14,-8]]).
arc(arc00014,node00012,node00011,influence,[complete=true,name=i12,role=[use(none,in_hierarchy,growth_rate_multiplier,1)]],[curve=[-1,-10]]).
arc(arc00008,node00013,node00012,influence,[name=i6],[]).
arc(arc00016,node00014,node00013,influence,[complete=true,name=i14,role=[use(none,in_hierarchy,fraction_occupied,1/1)]],[curve=[2,-16]]).
arc(arc00009,node00015,node00014,influence,[name=i7],[]).
arc(arc00017,node00002,node00015,influence,[complete=true,name=i15,role=[use(none,in_hierarchy,area_of_flowers,1)]],[curve=[12,-1]]).
arc(arc00018,node00016,node00015,influence,[complete=true,name=i16,role=[use(none,in_hierarchy,suitable_area,1)]],[curve=[4,-17]]).
arc(arc00010,node00017,node00016,influence,[name=i8],[]).
arc(arc00020,node00018,node00007,influence,[complete=true,name=i18,role=[use(none,in_hierarchy,decay_rate,1)]],[curve=[4,0]]).
arc(arc00011,node00019,node00018,influence,[name=i9],[]).

