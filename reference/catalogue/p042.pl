source(program='AME',version= 9.0,edition=standard,date='Wed Feb 06 16:59:59 GMT 2008').

roots([node00002,node00003,node00004,node00005,node00006,node00007,node00008,node00009,node00010,node00011,node00012,node00013,node00014,node00015,node00016,node00017,node00018,node00019,node00021,node00022,node00023,node00024,node00025,node00026,node00027,node00028,node00029,node00030,node00031,node00032,node00033,node00034,node00035,node00036,node00037,node00038,node00039,node00040,node00041,node00043,node00044,node00045,node00046,node00047,node00048,node00049,node00050]).

properties([complete-true,file_name-'C:/Inetpub/wwwroot/www/examples/catalogue/models/mono3/p042.sml',name-p042,separate-0]).

node(node00002,compartment,[],[comment='Amount of water in lake, KAF (thousand acre-feet) (Don''t blame me! - all I''m doing is re-implementing Ford''s model!)',complete=true,name='water\nin lake'],[caption_offset=[-25,-65],centre=[226,23]]).
node(node00003,function,[],[complete=true,name=fn1,units=1,value=2228],[]).
node(node00004,cloud,[],[complete=true,name=cd1],[centre=[85,23]]).
node(node00005,function,[],[complete=true,name=fn2,units=1,value=sierra_gauged_runoff-exports],[]).
node(node00006,cloud,[],[complete=true,name=cd2],[centre=[95,-66]]).
node(node00007,function,[],[complete=true,name=fn3,units=1*1,value=surface_area*precipitation_rate],[]).
node(node00008,cloud,[],[complete=true,name=cd3],[centre=[37,203]]).
node(node00009,function,[],[complete=true,name=fn4,units=1,value=ungauged_sierra_runoff+non_sierra_runoff+land_surface_precipitation+diversion_inflows],[]).
node(node00010,cloud,[],[complete=true,name=cd4],[centre=[370,-35]]).
node(node00011,function,[],[complete=true,name=fn5,units=1*1,value=surface_area*evaporation_rate],[]).
node(node00012,cloud,[],[complete=true,name=cd5],[centre=[229,289]]).
node(node00013,function,[],[complete=true,name=fn6,units=1,value=evapotranspiration+exposed_lake_bottom_evaporation+net_grant_lake_evaporation+ground_water_export],[]).
node(node00014,variable,[],[comment='thousand acre',complete=true,name='surface area'],[caption_offset=[-4,-30],centre=[274,-49]]).
node(node00015,function,[],[complete=true,name=fn7,table_data=[file='/graph/',data=[100,0,400],indices=[0,10000,400,0],current=[400,301,259,206,183,171,154,136,121,121,121],units=1,bounds=1,dims=11],units=1,value=graph(water_in_lake)],[]).
node(node00016,variable,[],[complete=true,name=elevation],[caption_offset=[41,-14],centre=[241,-94]]).
node(node00017,variable,[],[comment='thousand acre-feet/year',complete=true,name='sierra gauged runoff'],[caption_offset=[-12,0],centre=[55,36]]).
node(node00018,function,[],[complete=true,name=fn8,units=1,value=150],[]).
node(node00019,variable,[],[comment='thousand acre-feet/year',complete=true,max_val=100,min_val=0,name=exports,units=1,value=100],[caption_offset=[0,0],centre=[73,72]]).
node(node00021,variable,[],[comment='feet/year',complete=true,name='precipitation rate'],[caption_offset=[-69,-17],centre=[76,-40]]).
node(node00022,function,[],[complete=true,name=fn10,units=1,value= 0.667],[]).
node(node00023,variable,[],[comment='feet/year',complete=true,name='evaporation rate'],[caption_offset=[46,-34],centre=[368,41]]).
node(node00024,function,[],[complete=true,name=fn11,units=1,value= 3.75 *evaporation_rate_multiplier_from_specific_gravity],[]).
node(node00025,function,[],[complete=true,name=fn1_0,table_data=[file='/graph/',data=[6500,6200,400],indices=[0,10000,400,0],current=[368,220,174,144,117,93,71,49,30,23,20],units=1,bounds=1,dims=11],units=1,value=graph(water_in_lake)],[]).
node(node00026,variable,[],[comment='thousand acre-feet/year',complete=true,name='ungauged sierra runoff'],[caption_offset=[-82,-17],centre=[111,108]]).
node(node00027,function,[],[complete=true,name=fn2_0,units=1,value=17],[]).
node(node00028,variable,[],[comment='thousand acre-feet/year',complete=true,name='non sierra runoff'],[caption_offset=[-64,-15],centre=[94,130]]).
node(node00029,function,[],[complete=true,name=fn3_0,units=1,value=20],[]).
node(node00030,variable,[],[comment='thousand acre-feet/year',complete=true,name='land surface precipitation'],[caption_offset=[-88,-16],centre=[76,153]]).
node(node00031,function,[],[complete=true,name=fn4_0,units=1,value=9],[]).
node(node00032,variable,[],[comment='thousand acre-feet/year',complete=true,name='diversion inflows'],[caption_offset=[-63,-15],centre=[58,172]]).
node(node00033,function,[],[complete=true,name=fn5_0,units=1,value= 1.6],[]).
node(node00034,variable,[],[comment='thousand acre-feet/year',complete=true,name=evapotranspiration],[caption_offset=[68,-16],centre=[277,177]]).
node(node00035,function,[],[complete=true,name=fn6_0,units=1,value=13],[]).
node(node00036,variable,[],[comment='thousand acre-feet/year',complete=true,name='exposed lake\nbottom evaporation'],[caption_offset=[71,-18],centre=[281,206]]).
node(node00037,function,[],[complete=true,name=fn7_0,units=1,value=12],[]).
node(node00038,variable,[],[comment='thousand acre-feet/year',complete=true,name='net grant lake\nevaporation'],[caption_offset=[54,-12],centre=[280,239]]).
node(node00039,function,[],[complete=true,name=fn8_0,units=1,value= 1.3],[]).
node(node00040,variable,[],[comment='thousand acre-feet/year',complete=true,name='ground water export'],[caption_offset=[74,-5],centre=[276,277]]).
node(node00041,function,[],[complete=true,name=fn9_0,units=1,value= 7.3],[]).
node(node00043,variable,[],[complete=true,name='specific gravity'],[caption_offset=[4,-3],centre=[272,122]]).
node(node00044,function,[],[complete=true,name=fn1_1,units=1*1/1,value=(water_in_lake*mass_of_fresh_water+total_dissolved_solids)/(water_in_lake*mass_of_fresh_water)],[]).
node(node00045,variable,[],[comment='million tons',complete=true,name='total dissolved solids'],[caption_offset=[75,-16],centre=[330,103]]).
node(node00046,function,[],[complete=true,name=fn2_1,units=1,value=230],[]).
node(node00047,variable,[],[comment='million tons per thousand acre-feet',complete=true,name='mass of fresh water'],[caption_offset=[69,-16],centre=[329,132]]).
node(node00048,function,[],[complete=true,name=fn3_1,units=1,value= 1.359],[]).
node(node00049,variable,[],[complete=true,name='evaporation rate multiplier\nfrom specific gravity'],[caption_offset=[96,-21],centre=[295,71]]).
node(node00050,function,[],[complete=true,name=fn4_1,table_data=[file='/graph/',data=[1, 0.5,400],indices=[1, 1.5,400,0],current=[0,30,64,97,136,172,210,250,289,323,356],units=1,bounds=1,dims=11],units=1,value=graph(specific_gravity)],[]).

arc(arc00001,node00003,node00002,influence,[name=i1],[]).
arc(arc00002,node00004,node00002,flow,[comment='thousand acre-feet/year',complete=true,name='flow past\ndiversion points'],[caption_offset=[-72,-56],curve=[550,351]]).
arc(arc00003,node00005,arc00002,influence,[name=i2],[]).
arc(arc00004,node00006,node00002,flow,[comment='thousand acre-feet/year',complete=true,name=precipitation],[caption_offset=[-30,-40],curve=[600,206]]).
arc(arc00005,node00007,arc00004,influence,[name=i3],[]).
arc(arc00006,node00008,node00002,flow,[comment='thousand acre-feet/year',complete=true,name='other in'],[caption_offset=[-46,2],curve=[596,263]]).
arc(arc00007,node00009,arc00006,influence,[name=i4],[]).
arc(arc00008,node00002,node00010,flow,[comment='thousand acre-feet/year',complete=true,name=evaporation],[caption_offset=[-58,0],curve=[598,259]]).
arc(arc00009,node00011,arc00008,influence,[name=i5],[]).
arc(arc00010,node00002,node00012,flow,[comment='thousand acre-feet/year',complete=true,name='other out'],[caption_offset=[-74,-9],curve=[550,824]]).
arc(arc00011,node00013,arc00010,influence,[name=i6],[]).
arc(arc00017,node00014,node00007,influence,[complete=true,name=i12,role=[use(none,in_hierarchy,surface_area,1)]],[curve=[-3,30]]).
arc(arc00021,node00014,node00011,influence,[complete=true,name=i16,role=[use(none,in_hierarchy,surface_area,1)]],[curve=[12,-4]]).
arc(arc00012,node00015,node00014,influence,[name=i7],[]).
arc(arc00023,node00002,node00015,influence,[complete=true,name=i1_0,role=[use(none,in_hierarchy,water_in_lake,1)]],[curve=[-14,-9]]).
arc(arc00018,node00017,node00005,influence,[complete=true,name=i13,role=[use(none,in_hierarchy,sierra_gauged_runoff,1)]],[curve=[6,20]]).
arc(arc00013,node00018,node00017,influence,[name=i8],[]).
arc(arc00019,node00019,node00005,influence,[complete=true,name=i14,role=[use(none,in_hierarchy,exports,1)]],[curve=[16,17]]).
arc(arc00016,node00021,node00007,influence,[complete=true,name=i11,role=[use(none,in_hierarchy,precipitation_rate,1)]],[curve=[14,10]]).
arc(arc00015,node00022,node00021,influence,[name=i10],[]).
arc(arc00022,node00023,node00011,influence,[complete=true,name=i17,role=[use(none,in_hierarchy,evaporation_rate,1)]],[curve=[-4,12]]).
arc(arc00020,node00024,node00023,influence,[name=i15],[]).
arc(arc00024,node00025,node00016,influence,[name=i1_1],[]).
arc(arc00041,node00002,node00025,influence,[complete=true,name=i18,role=[use(none,in_hierarchy,water_in_lake,1)]],[curve=[-24,-3]]).
arc(arc00029,node00026,node00009,influence,[complete=true,name=i6_0,role=[use(none,in_hierarchy,ungauged_sierra_runoff,1)]],[curve=[18,-3]]).
arc(arc00025,node00027,node00026,influence,[name=i2_0],[]).
arc(arc00030,node00028,node00009,influence,[complete=true,name=i7_0,role=[use(none,in_hierarchy,non_sierra_runoff,1)]],[curve=[12,-5]]).
arc(arc00026,node00029,node00028,influence,[name=i3_0],[]).
arc(arc00031,node00030,node00009,influence,[complete=true,name=i8_0,role=[use(none,in_hierarchy,land_surface_precipitation,1)]],[curve=[8,-10]]).
arc(arc00027,node00031,node00030,influence,[name=i4_0],[]).
arc(arc00032,node00032,node00009,influence,[complete=true,name=i9_0,role=[use(none,in_hierarchy,diversion_inflows,1)]],[curve=[4,-14]]).
arc(arc00028,node00033,node00032,influence,[name=i5_0],[]).
arc(arc00037,node00034,node00013,influence,[complete=true,name=i14_0,role=[use(none,in_hierarchy,evapotranspiration,1)]],[curve=[12,10]]).
arc(arc00033,node00035,node00034,influence,[name=i10_0],[]).
arc(arc00038,node00036,node00013,influence,[complete=true,name=i15_0,role=[use(none,in_hierarchy,exposed_lake_bottom_evaporation,1)]],[curve=[4,9]]).
arc(arc00034,node00037,node00036,influence,[name=i11_0],[]).
arc(arc00039,node00038,node00013,influence,[complete=true,name=i16_0,role=[use(none,in_hierarchy,net_grant_lake_evaporation,1)]],[curve=[-1,8]]).
arc(arc00035,node00039,node00038,influence,[name=i12_0],[]).
arc(arc00040,node00040,node00013,influence,[complete=true,name=i17_0,role=[use(none,in_hierarchy,ground_water_export,1)]],[curve=[-8,8]]).
arc(arc00036,node00041,node00040,influence,[name=i13_0],[]).
arc(arc00042,node00044,node00043,influence,[name=i1_2],[]).
arc(arc00046,node00002,node00044,influence,[complete=true,name=i5_1,role=[use(none,in_hierarchy,water_in_lake,1)]],[curve=[19,-9]]).
arc(arc00048,node00045,node00044,influence,[complete=true,name=i7_1,role=[use(none,in_hierarchy,total_dissolved_solids,1)]],[curve=[10,1]]).
arc(arc00043,node00046,node00045,influence,[name=i2_1],[]).
arc(arc00047,node00047,node00044,influence,[complete=true,name=i6_1,role=[use(none,in_hierarchy,mass_of_fresh_water,1)]],[curve=[2,2]]).
arc(arc00044,node00048,node00047,influence,[name=i3_1],[]).
arc(arc00050,node00049,node00024,influence,[complete=true,name=i9_1,role=[use(none,in_hierarchy,evaporation_rate_multiplier_from_specific_gravity,1)]],[curve=[-6,-15]]).
arc(arc00045,node00050,node00049,influence,[name=i4_1],[]).
arc(arc00049,node00043,node00050,influence,[complete=true,name=i8_1,role=[use(none,in_hierarchy,specific_gravity,1*1/1)]],[curve=[-10,-5]]).

