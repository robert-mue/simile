source(program='AME',version= 9.0,edition=standard,date='Wed Feb 06 16:59:32 GMT 2008').

roots([node00002,node00003,node00004,node00005,node00006,node00007,node00008,node00009,node00010,node00011,node00012,node00013,node00014,node00015,node00017,node00018,node00019,node00020,node00021,node00022,node00023,node00024]).

properties([complete-true,file_name-'C:/Inetpub/wwwroot/www/examples/catalogue/models/mono2/p040.sml',name-p040,separate-0]).

node(node00002,compartment,[],[comment='Amount of water in lake, KAF (thousand acre-feet) (Don''t blame me! - all I''m doing is re-implementing Ford''s model!)',complete=true,name='water\nin lake'],[caption_offset=[3,7],centre=[219,113]]).
node(node00003,function,[],[complete=true,name=fn1,units=1,value=2228],[]).
node(node00004,cloud,[],[complete=true,name=cd1],[centre=[78,113]]).
node(node00005,function,[],[complete=true,name=fn2,units=1,value=sierra_gauged_runoff-exports],[]).
node(node00006,cloud,[],[complete=true,name=cd2],[centre=[88,23]]).
node(node00007,function,[],[complete=true,name=fn3,units=1*1,value=surface_area*precipitation_rate],[]).
node(node00008,cloud,[],[complete=true,name=cd3],[centre=[106,203]]).
node(node00009,function,[],[complete=true,name=fn4,units=1,value= 47.6],[]).
node(node00010,cloud,[],[complete=true,name=cd4],[centre=[363,54]]).
node(node00011,function,[],[complete=true,name=fn5,units=1*1,value=surface_area*evaporation_rate],[]).
node(node00012,cloud,[],[complete=true,name=cd5],[centre=[317,200]]).
node(node00013,function,[],[complete=true,name=fn6,units=1,value= 33.6],[]).
node(node00014,variable,[],[comment='thousand acre',complete=true,name='surface area'],[caption_offset=[-4,-30],centre=[267,40]]).
node(node00015,function,[],[complete=true,name=fn7,table_data=[file='/graph/',data=[100,0,400],indices=[0,10000,400,0],current=[400,301,259,206,183,171,154,136,121,121,121],units=1,bounds=1,dims=11],units=1,value=graph(water_in_lake)],[]).
node(node00017,variable,[],[comment='thousand acre-feet/year',complete=true,name='sierra gauged runoff'],[caption_offset=[-14,1],centre=[48,126]]).
node(node00018,function,[],[complete=true,name=fn8,units=1,value=150],[]).
node(node00019,variable,[],[comment='thousand acre-feet/year',complete=true,name=exports],[caption_offset=[0,0],centre=[66,162]]).
node(node00020,function,[],[complete=true,name=fn9,units=1,value=100],[]).
node(node00021,variable,[],[comment='feet/year',complete=true,name='precipitation rate'],[caption_offset=[-65,-16],centre=[69,49]]).
node(node00022,function,[],[complete=true,name=fn10,units=1,value= 0.667],[]).
node(node00023,variable,[],[comment='feet/year',complete=true,name='evaporation rate'],[caption_offset=[0,0],centre=[356,133]]).
node(node00024,function,[],[complete=true,name=fn11,units=1,value= 3.75],[]).

arc(arc00001,node00003,node00002,influence,[name=i1],[]).
arc(arc00002,node00004,node00002,flow,[comment='thousand acre-feet/year',complete=true,name='flow past\ndiversion points'],[caption_offset=[-75,-55],curve=[550,351]]).
arc(arc00003,node00005,arc00002,influence,[name=i2],[]).
arc(arc00004,node00006,node00002,flow,[comment='thousand acre-feet/year',complete=true,name=precipitation],[caption_offset=[-22,-38],curve=[600,206]]).
arc(arc00005,node00007,arc00004,influence,[name=i3],[]).
arc(arc00006,node00008,node00002,flow,[comment='thousand acre-feet/year',complete=true,name='other in'],[caption_offset=[-40,3],curve=[598,218]]).
arc(arc00007,node00009,arc00006,influence,[name=i4],[]).
arc(arc00008,node00002,node00010,flow,[comment='thousand acre-feet/year',complete=true,name=evaporation],[caption_offset=[11,-25],curve=[598,259]]).
arc(arc00009,node00011,arc00008,influence,[name=i5],[]).
arc(arc00010,node00002,node00012,flow,[comment='thousand acre-feet/year',complete=true,name='other out'],[caption_offset=[-52,1],curve=[595,778]]).
arc(arc00011,node00013,arc00010,influence,[name=i6],[]).
arc(arc00017,node00014,node00007,influence,[complete=true,name=i12,role=[use(none,in_hierarchy,surface_area,1)]],[curve=[-3,30]]).
arc(arc00021,node00014,node00011,influence,[complete=true,name=i16,role=[use(none,in_hierarchy,surface_area,1)]],[curve=[12,-5]]).
arc(arc00012,node00015,node00014,influence,[name=i7],[]).
arc(arc00023,node00002,node00015,influence,[complete=true,name=i1_0,role=[use(none,in_hierarchy,water_in_lake,1)]],[curve=[-14,-10]]).
arc(arc00018,node00017,node00005,influence,[complete=true,name=i13,role=[use(none,in_hierarchy,sierra_gauged_runoff,1)]],[curve=[6,20]]).
arc(arc00013,node00018,node00017,influence,[name=i8],[]).
arc(arc00019,node00019,node00005,influence,[complete=true,name=i14,role=[use(none,in_hierarchy,exports,1)]],[curve=[16,17]]).
arc(arc00014,node00020,node00019,influence,[name=i9],[]).
arc(arc00016,node00021,node00007,influence,[complete=true,name=i11,role=[use(none,in_hierarchy,precipitation_rate,1)]],[curve=[14,10]]).
arc(arc00015,node00022,node00021,influence,[name=i10],[]).
arc(arc00022,node00023,node00011,influence,[complete=true,name=i17,role=[use(none,in_hierarchy,evaporation_rate,1)]],[curve=[16,-1]]).
arc(arc00020,node00024,node00023,influence,[name=i15],[]).

