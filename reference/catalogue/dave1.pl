source(program='AME',version= 9.0,edition=standard,date='Tue Feb 05 17:15:29 GMT 2008').

roots([node00002,node00003,node00004,node00005,node00006,node00007,node00008]).

properties([complete-true,file_name-'C:/Inetpub/wwwroot/www/examples/catalogue/models/bob/dave1/dave1.sml',name-dave1]).

node(node00002,submodel,[node00009,node00010,node00011,node00012,node00013,node00014,node00015,node00016,node00017,node00018,node00019,node00020,node00021,node00022,node00023,node00024,node00025,node00026,node00027,node00028,node00029],[complete=true,fill_colour='#ffff80',multiplication_spec=[type=population],name='Consumer'],[bounding_box=[-414,-176,-166,43],caption_offset=[13,-10],internal_extent=[-63,0,181,219]]).
links(node00002,[arc00021-arc00023,arc00021-arc00056,arc00031-arc00030,arc00033-arc00035,arc00049-arc00048,arc00052-arc00054]).
references(node00002,[local(arc00004),local(arc00038),local(arc00057)]).
node(node00009,variable,[],[complete=true,name='consumer ID'],[caption_offset=[0,0],centre=[-13,27]]).
node(node00010,function,[],[complete=true,name=fn4,units=1,value=index(1)],[]).
node(node00011,creation,[],[complete=true,name='initial\nnumber'],[caption_offset=[-29,-8],centre=[133,22]]).
node(node00012,function,[],[complete=true,name=fn7,units=1,value=4],[]).
node(node00013,variable,[],[complete=true,name=request],[caption_offset=[0,0],centre=[85,180]]).
node(node00014,function,[],[complete=true,name=fn12,units=1,value=(if rand_var(0,1)< 0.2 then 1 else 0)],[]).
node(node00015,border,[],[name=var18],[centre=[182,158]]).
node(node00016,variable,[],[complete=true,name='mediator\nchosen'],[caption_offset=[-40,-14],centre=[135,74]]).
node(node00017,function,[],[complete=true,name=fn15,units=1,value=greatest({mediator})],[]).
node(node00018,border,[],[name=var25],[centre=[182,65]]).
node(node00019,border,[],[name=var27],[centre=[182,76]]).
node(node00020,variable,[],[complete=true,name=bank],[caption_offset=[0,0],centre=[145,176]]).
node(node00021,function,[],[complete=true,name=fn19,units=1,value=sum({bank})],[]).
node(node00022,border,[],[name=var33],[centre=[183,176]]).
node(node00023,border,[],[name=var35],[centre=[167,219]]).
node(node00024,compartment,[],[complete=true,name=money],[caption_offset=[0,0],centre=[61,118]]).
node(node00025,function,[],[complete=true,name=fn1,units=1,value=0],[]).
node(node00026,cloud,[],[complete=true,name=cd1],[centre=[-36,116]]).
node(node00027,function,[],[complete=true,name=fn2,units=1,value=0],[]).
node(node00028,cloud,[],[complete=true,name=cd2],[centre=[136,118]]).
node(node00029,function,[],[complete=true,name=fn3,units=1,value=100],[]).
node(node00003,submodel,[node00030,node00031,node00032,node00033,node00034,node00035,node00036,node00037,node00038,node00039,node00040,node00041,node00042,node00043,node00044,node00045],[complete=true,fill_colour='#80ff80',multiplication_spec=[count=[]],name='CM'],[bounding_box=[-109,-181,-8,27],caption_offset=[9,-7],internal_extent=[0,-31,101,178]]).
links(node00003,[arc00023-arc00022,arc00028-arc00027,arc00029-arc00031,arc00035-arc00034,arc00043-arc00042,arc00047-arc00049]).
references(node00003,[local(arc00004),local(arc00005)]).
node(node00030,condition,[],[complete=true,name=condition],[caption_offset=[-3,-46],centre=[58,3]]).
node(node00031,function,[],[complete=true,name=fn6,units=boolean,value=(rand_const(0,1)< 0.5)],[]).
node(node00032,variable,[],[complete=true,name=request],[caption_offset=[-4,-2],centre=[40,133]]).
node(node00033,function,[],[complete=true,name=fn13,units=1,value=(if mediator==mediator_chosen then request else 0)],[]).
node(node00034,border,[],[name=var19],[centre=[0,125]]).
node(node00035,variable,[],[complete=true,name=mediator],[caption_offset=[0,-32],centre=[48,48]]).
node(node00036,function,[],[complete=true,name=fn14,units=1,value=mediator_id],[]).
node(node00037,border,[],[name=var23],[centre=[101,21]]).
node(node00038,border,[],[name=var24],[centre=[0,30]]).
node(node00039,variable,[],[complete=true,name='mediator\nchosen'],[caption_offset=[-1,8],centre=[40,71]]).
node(node00040,function,[],[complete=true,name=fn16,units=1,value=mediator_chosen],[]).
node(node00041,border,[],[name=var28],[centre=[0,52]]).
node(node00042,variable,[],[complete=true,name=bank],[caption_offset=[-5,4],centre=[75,148]]).
node(node00043,function,[],[complete=true,name=fn18,units=1,value=(if mediator==mediator_chosen then bank else 0)],[]).
node(node00044,border,[],[name=var30],[centre=[101,153]]).
node(node00045,border,[],[name=var32],[centre=[0,151]]).
node(node00004,submodel,[node00046,node00047,node00048,node00049,node00050,node00051],[complete=true,fill_colour='#ffff80',multiplication_spec=[count=[3]],name='Mediator'],[bounding_box=[93,-192,207,34],caption_offset=[23,-7],internal_extent=[0,0,114,226]]).
links(node00004,[arc00012-arc00014,arc00012-arc00043,arc00026-arc00028]).
references(node00004,[local(arc00005),local(arc00009)]).
node(node00046,variable,[],[complete=true,name='mediator ID'],[caption_offset=[0,0],centre=[71,53]]).
node(node00047,function,[],[complete=true,name=fn5,units=1,value=index(1)],[]).
node(node00048,variable,[],[complete=true,name=bank],[caption_offset=[-6,-34],centre=[54,168]]).
node(node00049,function,[],[complete=true,name=fn10,units=1,value= -1*floor(rand(1, 2.9999))],[]).
node(node00050,border,[],[name=var12],[centre=[7,222]]).
node(node00051,border,[],[name=var22],[centre=[0,54]]).
node(node00005,submodel,[node00052,node00053,node00054,node00055],[complete=true,fill_colour='#80ff80',multiplication_spec=[count=[]],name='MB'],[bounding_box=[80,83,284,162],caption_offset=[6,-11],internal_extent=[0,0,204,79]]).
links(node00005,[arc00014-arc00013,arc00017-arc00016]).
references(node00005,[local(arc00009),local(arc00010)]).
node(node00052,condition,[],[complete=true,name=condition],[caption_offset=[12,-1],centre=[119,35]]).
node(node00053,function,[],[complete=true,name=fn9,units=boolean,value=(bank==bank_id)],[]).
node(node00054,border,[],[name=var13],[centre=[95,0]]).
node(node00055,border,[],[name=var15],[centre=[92,79]]).
node(node00006,submodel,[node00056,node00057,node00058,node00059,node00060,node00061,node00062,node00063,node00064,node00065,node00066],[complete=true,fill_colour='#ffff80',multiplication_spec=[type=population],name='Bank'],[bounding_box=[54,208,298,360],caption_offset=[31,-11],internal_extent=[0,0,245,152]]).
links(node00006,[arc00015-arc00017,arc00015-arc00051]).
references(node00006,[local(arc00010),local(arc00039),local(arc00058)]).
node(node00056,variable,[],[complete=true,name='bank ID'],[caption_offset=[0,0],centre=[89,51]]).
node(node00057,function,[],[complete=true,name=fn8,units=1,value=index(1)],[]).
node(node00058,border,[],[name=var14],[centre=[79,0]]).
node(node00059,creation,[],[complete=true,name='initial\nnumber'],[caption_offset=[-29,-8],centre=[203,35]]).
node(node00060,function,[],[complete=true,name=fn11,units=1,value=2],[]).
node(node00061,compartment,[],[complete=true,name=money],[caption_offset=[0,0],centre=[129,107]]).
node(node00062,function,[],[complete=true,name=fn5,units=1,value=100000],[]).
node(node00063,cloud,[],[complete=true,name=cd5],[centre=[13,103]]).
node(node00064,function,[],[complete=true,name=fn8_0,units=1,value= 0.1 *money],[]).
node(node00065,cloud,[],[complete=true,name=cd6],[centre=[228,107]]).
node(node00066,function,[],[complete=true,name=fn9,units=1,value=0],[]).
node(node00007,submodel,[node00067,node00068,node00069,node00070,node00071],[complete=true,fill_colour='#80ff80',multiplication_spec=[count=[]],name='CB request'],[bounding_box=[-395,156,-255,326],caption_offset=[12,-9],internal_extent=[0,0,140,171]]).
links(node00007,[arc00051-arc00050,arc00054-arc00053,arc00056-arc00055]).
references(node00007,[local(arc00038),local(arc00039)]).
node(node00067,condition,[],[complete=true,name=condition],[caption_offset=[0,0],centre=[80,38]]).
node(node00068,function,[],[complete=true,name=fn17,units=boolean,value=(bank==bank_id&&request>0)],[]).
node(node00069,border,[],[name=var34],[centre=[140,45]]).
node(node00070,border,[],[name=var36],[centre=[132,3]]).
node(node00071,border,[],[name=var37],[centre=[102,0]]).
node(node00008,submodel,[node00072,node00073,node00074,node00075],[complete=true,fill_colour='#80ff80',multiplication_spec=[count=[]],name='CB account'],[bounding_box=[-183,86,11,222],caption_offset=[66,-10],internal_extent=[-58,0,136,137]]).
references(node00008,[local(arc00057),local(arc00058)]).
node(node00072,compartment,[],[complete=true,name=money],[caption_offset=[0,0],centre=[1,64]]).
node(node00073,function,[],[complete=true,name=fn4,units=1,value=0],[]).
node(node00074,cloud,[],[complete=true,name=cd4],[centre=[98,59]]).
node(node00075,function,[],[complete=true,name=fn7,units=1,value=0],[]).

arc(arc00001,node00010,node00009,influence,[complete=true,name=i4],[curve=[0,0]]).
arc(arc00006,node00012,node00011,influence,[name=i13],[curve=[0,0]]).
arc(arc00019,node00014,node00013,influence,[name=i24],[curve=[0,0]]).
arc(arc00021,node00013,node00015,influence,[complete=true,name=i26],[curve=[-6,-23]]).
arc(arc00025,node00017,node00016,influence,[name=i30],[curve=[0,0]]).
arc(arc00030,node00018,node00017,influence,[complete=true,name=i35,role=[use(0,in_assoc,{mediator},list(1)),use(none,in_hierarchy,{mediator_0},list(1))]],[curve=[0,-6]]).
arc(arc00033,node00016,node00019,influence,[complete=true,name=i38],[curve=[10,7]]).
arc(arc00046,node00021,node00020,influence,[name=i49],[curve=[0,0]]).
arc(arc00048,node00022,node00021,influence,[complete=true,name=i51,role=[use(0,in_assoc,{bank},list(1)),use(none,in_hierarchy,{bank_0},list(1))]],[curve=[-1,10]]).
arc(arc00052,node00020,node00023,influence,[complete=true,name=i55],[curve=[8,-9]]).
arc(arc00059,node00025,node00024,influence,[name=i1],[curve=[0,0]]).
arc(arc00060,node00026,node00024,flow,[complete=true,name=allocation],[caption_offset=[-38,3],curve=[550,500]]).
arc(arc00061,node00027,arc00060,influence,[name=i2],[]).
arc(arc00062,node00024,node00028,flow,[complete=true,name=expenditure],[caption_offset=[10,3],curve=[550,500]]).
arc(arc00063,node00029,arc00062,influence,[name=i3],[]).
arc(arc00004,node00002,node00003,relation,[complete=true,name=role1],[caption_offset=[-3,-10],curve=[0,-14]]).
arc(arc00023,node00002,node00003,influence,[complete=true,name=i28],[curve=[-2,-14]]).
arc(arc00031,node00003,node00002,influence,[complete=true,name=i36],[curve=[2,14]]).
arc(arc00035,node00002,node00003,influence,[complete=true,name=i40],[curve=[0,2]]).
arc(arc00049,node00003,node00002,influence,[complete=true,name=i52],[curve=[0,14]]).
arc(arc00003,node00031,node00030,influence,[name=i6],[curve=[0,0]]).
arc(arc00020,node00033,node00032,influence,[name=i25],[curve=[0,0]]).
arc(arc00022,node00034,node00033,influence,[complete=true,name=i27,role=[use(0,in_base,request,1),use(none,in_hierarchy,{request_0},list(1))]],[curve=[1,-8]]).
arc(arc00037,node00035,node00033,influence,[complete=true,name=i42,role=[use(none,in_hierarchy,mediator,1)]],[curve=[18,1]]).
arc(arc00024,node00036,node00035,influence,[name=i29],[curve=[0,0]]).
arc(arc00027,node00037,node00036,influence,[complete=true,name=i32,role=[use(1,in_base,mediator_id,1),use(none,in_hierarchy,[mediator_id_0],array(1,3))]],[curve=[4,9]]).
arc(arc00029,node00035,node00038,influence,[complete=true,name=i34],[curve=[-4,8]]).
arc(arc00036,node00039,node00033,influence,[complete=true,name=i41,role=[use(none,in_hierarchy,mediator_chosen,1)]],[curve=[10,-4]]).
arc(arc00032,node00040,node00039,influence,[name=i37],[curve=[0,0]]).
arc(arc00034,node00041,node00040,influence,[complete=true,name=i39,role=[use(0,in_base,mediator_chosen,1),use(none,in_hierarchy,{mediator_chosen_0},list(1))]],[curve=[2,-4]]).
arc(arc00041,node00043,node00042,influence,[name=i44],[curve=[0,0]]).
arc(arc00044,node00039,node00043,influence,[complete=true,name=i47,role=[use(none,in_hierarchy,mediator_chosen,1)]],[curve=[14,-10]]).
arc(arc00045,node00035,node00043,influence,[complete=true,name=i48,role=[use(none,in_hierarchy,mediator,1)]],[curve=[21,-6]]).
arc(arc00042,node00044,node00043,influence,[complete=true,name=i45,role=[use(1,in_base,bank,1),use(none,in_hierarchy,[bank_0],array(1,3))]],[curve=[-2,2]]).
arc(arc00047,node00042,node00045,influence,[complete=true,name=i50],[curve=[0,15]]).
arc(arc00005,node00004,node00003,relation,[complete=true,name=role2],[caption_offset=[-1,9],curve=[0,26]]).
arc(arc00028,node00004,node00003,influence,[complete=true,name=i33],[curve=[2,26]]).
arc(arc00043,node00004,node00003,influence,[complete=true,name=i46],[curve=[-7,29]]).
arc(arc00002,node00047,node00046,influence,[name=i5],[]).
arc(arc00011,node00049,node00048,influence,[name=i16],[]).
arc(arc00012,node00048,node00050,influence,[complete=true,name=i17],[curve=[2,4]]).
arc(arc00026,node00046,node00051,influence,[complete=true,name=i31],[curve=[0,14]]).
arc(arc00009,node00004,node00005,relation,[complete=true,name=role3],[caption_offset=[26,-1],curve=[6,-2]]).
arc(arc00014,node00004,node00005,influence,[complete=true,name=i19],[curve=[-28,-2]]).
arc(arc00008,node00053,node00052,influence,[name=i15],[]).
arc(arc00013,node00054,node00053,influence,[complete=true,name=i18,role=[use(0,in_base,bank,1),use(none,in_hierarchy,[bank_0],array(1,3))]],[curve=[4,-4]]).
arc(arc00016,node00055,node00053,influence,[complete=true,name=i21,role=[use(1,in_base,bank_id,1),use(none,in_hierarchy,{bank_id_0},list(1))]],[curve=[-8,-4]]).
arc(arc00010,node00006,node00005,relation,[complete=true,name=role4],[caption_offset=[22,0],curve=[-10,1]]).
arc(arc00017,node00006,node00005,influence,[complete=true,name=i22],[curve=[0,1]]).
arc(arc00007,node00057,node00056,influence,[name=i14],[]).
arc(arc00015,node00056,node00058,influence,[complete=true,name=i20],[curve=[-11,2]]).
arc(arc00018,node00060,node00059,influence,[name=i23],[]).
arc(arc00065,node00062,node00061,influence,[name=i5],[]).
arc(arc00068,node00063,node00061,flow,[complete=true,name=revenue],[caption_offset=[-16,0],curve=[550,500]]).
arc(arc00069,node00064,arc00068,influence,[name=i8],[]).
arc(arc00072,node00061,node00064,influence,[complete=true,name=i10,role=[use(none,in_hierarchy,money,1)]],[curve=[0,9]]).
arc(arc00070,node00061,node00065,flow,[complete=true,name=allocation],[caption_offset=[0,0],curve=[550,500]]).
arc(arc00071,node00066,arc00070,influence,[name=i9],[]).
arc(arc00038,node00002,node00007,relation,[complete=true,name=role5],[caption_offset=[-17,8],curve=[32,-2]]).
arc(arc00039,node00006,node00007,relation,[complete=true,name=role6],[caption_offset=[1,8],curve=[-2,77]]).
arc(arc00051,node00006,node00007,influence,[complete=true,name=i54],[curve=[-26,119]]).
arc(arc00054,node00002,node00007,influence,[complete=true,name=i57],[curve=[32,6]]).
arc(arc00056,node00002,node00007,influence,[complete=true,name=i59],[curve=[32,12]]).
arc(arc00040,node00068,node00067,influence,[name=i43],[]).
arc(arc00050,node00069,node00068,influence,[complete=true,name=i53,role=[use(1,in_base,bank_id,1),use(none,in_hierarchy,{bank_id_0},list(1))]],[curve=[-2,11]]).
arc(arc00053,node00070,node00068,influence,[complete=true,name=i56,role=[use(0,in_base,bank,1),use(none,in_hierarchy,{bank_0},list(1))]],[curve=[6,9]]).
arc(arc00055,node00071,node00068,influence,[complete=true,name=i58,role=[use(0,in_base,request,1),use(none,in_hierarchy,{request_0},list(1))]],[curve=[5,4]]).
arc(arc00057,node00002,node00008,relation,[complete=true,name=role7],[caption_offset=[24,2],curve=[10,-12]]).
arc(arc00058,node00006,node00008,relation,[complete=true,name=role8],[caption_offset=[-6,15],curve=[-8,13]]).
arc(arc00064,node00073,node00072,influence,[name=i4],[]).
arc(arc00066,node00072,node00074,flow,[complete=true,name=allocation],[caption_offset=[0,0],curve=[550,492]]).
arc(arc00067,node00075,arc00066,influence,[name=i7],[]).

