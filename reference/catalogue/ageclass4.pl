source(program='AME',version= 9.0,edition=standard,date='Mon Feb 04 23:15:03 GMT 2008').

roots([node00002,node00003,node00004,node00005,node00006,node00007,node00008,node00009,node00010,node00011,node00012,node00013,node00014,node00015,node00016,node00017,node00018,node00019,node00020,node00021,node00022,node00025,node00026,node00027,node00028,node00029,node00030,node00033,node00034,node00035,node00036,node00037,node00038,node00039,node00040,node00042,node00043,node00044,node00045,node00046,node00047,node00048,node00049]).

properties([complete-true,file_name-'C:/Inetpub/wwwroot/www/examples/catalogue/models/bob/ageclass4/ageclass4.sml',name-ageclass4]).

node(node00002,compartment,[],[complete=true,name='pop size 1'],[caption_offset=[0,0],centre=[104,82]]).
node(node00003,function,[],[complete=true,name=fn1,units=1,value=2],[]).
node(node00004,compartment,[],[complete=true,name='pop size 2'],[caption_offset=[0,0],centre=[224,82]]).
node(node00005,function,[],[complete=true,name=fn2,units=1,value=0],[]).
node(node00006,compartment,[],[complete=true,name='pop size 3'],[caption_offset=[0,0],centre=[339,80]]).
node(node00007,function,[],[complete=true,name=fn3,units=1,value=0],[]).
node(node00008,compartment,[],[complete=true,name='pop size 4'],[caption_offset=[0,0],centre=[448,79]]).
node(node00009,function,[],[complete=true,name=fn4,units=1,value=0],[]).
node(node00010,cloud,[],[complete=true,name=cd1],[centre=[8,82]]).
node(node00011,function,[],[complete=true,name=fn5,units=1*1,value=births_2+births_3+births_4],[]).
node(node00012,function,[],[complete=true,name=fn6,units=1,value=pop_size_1],[]).
node(node00013,function,[],[complete=true,name=fn7,units=1,value= 0.2 *pop_size_2],[]).
node(node00014,function,[],[complete=true,name=fn8,units=1,value= 0.1 *pop_size_3],[]).
node(node00015,cloud,[],[complete=true,name=cd2],[centre=[103,-16]]).
node(node00016,function,[],[complete=true,name=fn9,units=1*1,value=m1*pop_size_1],[]).
node(node00017,cloud,[],[complete=true,name=cd3],[centre=[224,-14]]).
node(node00018,function,[],[complete=true,name=fn10,units=1*1,value=m2*pop_size_2],[]).
node(node00019,cloud,[],[complete=true,name=cd4],[centre=[337,-13]]).
node(node00020,function,[],[complete=true,name=fn11,units=1*1,value=m3*pop_size_3],[]).
node(node00021,cloud,[],[complete=true,name=cd5],[centre=[447,-14]]).
node(node00022,function,[],[complete=true,name=fn12,units=1*1,value=m4*pop_size_4],[]).
node(node00025,variable,[],[complete=true,name='births 2'],[caption_offset=[5,3],centre=[92,157]]).
node(node00026,function,[],[complete=true,name=fn14,units=1*1,value=r2*pop_size_2],[]).
node(node00027,variable,[],[complete=true,name='births 3'],[caption_offset=[4,2],centre=[150,168]]).
node(node00028,function,[],[complete=true,name=fn15,units=1*1,value=r3*pop_size_3],[]).
node(node00029,variable,[],[complete=true,name='births 4'],[caption_offset=[7,2],centre=[229,165]]).
node(node00030,function,[],[complete=true,name=fn16,units=1*1,value=r4*pop_size_4],[]).
node(node00033,variable,[],[complete=true,name=r2],[caption_offset=[0,0],centre=[138,224]]).
node(node00034,function,[],[complete=true,name=fn18,units=1*1,value= 0.05 *(1-pop_size/100)],[]).
node(node00035,variable,[],[complete=true,name=r3],[caption_offset=[0,0],centre=[198,215]]).
node(node00036,function,[],[complete=true,name=fn19,units=1*1,value= 0.2 *(1-pop_size/100)],[]).
node(node00037,variable,[],[complete=true,name=r4],[caption_offset=[0,0],centre=[258,205]]).
node(node00038,function,[],[complete=true,name=fn20,units=1*1,value= 0.1 *(1-pop_size/100)],[]).
node(node00039,variable,[],[complete=true,name='pop size'],[caption_offset=[0,0],centre=[351,238]]).
node(node00040,function,[],[complete=true,name=fn21,units=1,value=pop_size_1+pop_size_2+pop_size_3+pop_size_4],[]).
node(node00042,variable,[],[complete=true,name=m1],[caption_offset=[0,0],centre=[64,-7]]).
node(node00043,function,[],[complete=true,name=fn22,units=1,value= 0.05],[]).
node(node00044,variable,[],[complete=true,name=m2],[caption_offset=[0,0],centre=[183,-10]]).
node(node00045,function,[],[complete=true,name=fn23,units=1,value= 0.01],[]).
node(node00046,variable,[],[complete=true,name=m3],[caption_offset=[0,0],centre=[296,-8]]).
node(node00047,function,[],[complete=true,name=fn24,units=1,value= 0.01],[]).
node(node00048,variable,[],[complete=true,name=m4],[caption_offset=[0,0],centre=[412,-10]]).
node(node00049,function,[],[complete=true,name=fn25,units=1,value= 0.05],[]).

arc(arc00001,node00003,node00002,influence,[name=i1],[]).
arc(arc00007,node00002,node00004,flow,[complete=true,name='ageing 1'],[caption_offset=[-17,-38],curve=[550,500]]).
arc(arc00002,node00005,node00004,influence,[name=i2],[]).
arc(arc00009,node00004,node00006,flow,[complete=true,name='ageing 2'],[caption_offset=[-17,-39],curve=[550,507]]).
arc(arc00003,node00007,node00006,influence,[name=i3],[]).
arc(arc00011,node00006,node00008,flow,[complete=true,name='ageing 3'],[caption_offset=[-17,-39],curve=[550,507]]).
arc(arc00004,node00009,node00008,influence,[name=i4],[]).
arc(arc00005,node00010,node00002,flow,[complete=true,name=births],[caption_offset=[-20,-40],curve=[550,507]]).
arc(arc00006,node00011,arc00005,influence,[name=i5],[]).
arc(arc00008,node00012,arc00007,influence,[name=i6],[]).
arc(arc00021,node00002,node00012,influence,[complete=true,name=i1_0,role=[use(none,in_hierarchy,pop_size_1,1)]],[curve=[0,-17]]).
arc(arc00010,node00013,arc00009,influence,[name=i7],[]).
arc(arc00025,node00004,node00013,influence,[complete=true,name=i2_0,role=[use(none,in_hierarchy,pop_size_2,1)]],[curve=[-2,-18]]).
arc(arc00012,node00014,arc00011,influence,[name=i8],[]).
arc(arc00033,node00006,node00014,influence,[complete=true,name=i3_0,role=[use(none,in_hierarchy,pop_size_3,1)]],[curve=[0,-20]]).
arc(arc00013,node00002,node00015,flow,[complete=true,name='deaths 1'],[caption_offset=[18,-20],curve=[550,690]]).
arc(arc00014,node00016,arc00013,influence,[name=i9],[]).
arc(arc00057,node00002,node00016,influence,[complete=true,name=i49,role=[use(none,in_hierarchy,pop_size_1,1)]],[curve=[-11,0]]).
arc(arc00015,node00004,node00017,flow,[complete=true,name='deaths 2'],[caption_offset=[16,-20],curve=[550,671]]).
arc(arc00016,node00018,arc00015,influence,[name=i10],[]).
arc(arc00058,node00004,node00018,influence,[complete=true,name=i50,role=[use(none,in_hierarchy,pop_size_2,1)]],[curve=[-11,0]]).
arc(arc00017,node00006,node00019,flow,[complete=true,name='deaths 3'],[caption_offset=[17,-21],curve=[550,652]]).
arc(arc00018,node00020,arc00017,influence,[name=i11],[]).
arc(arc00059,node00006,node00020,influence,[complete=true,name=i51,role=[use(none,in_hierarchy,pop_size_3,1)]],[curve=[-10,0]]).
arc(arc00019,node00008,node00021,flow,[complete=true,name='deaths 4'],[caption_offset=[15,-21],curve=[550,662]]).
arc(arc00020,node00022,arc00019,influence,[name=i12],[]).
arc(arc00060,node00008,node00022,influence,[complete=true,name=i52,role=[use(none,in_hierarchy,pop_size_4,1)]],[curve=[-10,0]]).
arc(arc00046,node00025,node00011,influence,[complete=true,name=i38,role=[use(none,in_hierarchy,births_2,1*1)]],[curve=[-14,7]]).
arc(arc00022,node00026,node00025,influence,[name=i14],[]).
arc(arc00035,node00004,node00026,influence,[complete=true,name=i27,role=[use(none,in_hierarchy,pop_size_2,1)]],[curve=[7,10]]).
arc(arc00047,node00027,node00011,influence,[complete=true,name=i39,role=[use(none,in_hierarchy,births_3,1*1)]],[curve=[-20,21]]).
arc(arc00023,node00028,node00027,influence,[name=i15],[]).
arc(arc00037,node00006,node00028,influence,[complete=true,name=i29,role=[use(none,in_hierarchy,pop_size_3,1)]],[curve=[-2,14]]).
arc(arc00048,node00029,node00011,influence,[complete=true,name=i40,role=[use(none,in_hierarchy,births_4,1*1)]],[curve=[-20,41]]).
arc(arc00024,node00030,node00029,influence,[name=i16],[]).
arc(arc00039,node00008,node00030,influence,[complete=true,name=i31,role=[use(none,in_hierarchy,pop_size_4,1)]],[curve=[8,18]]).
arc(arc00036,node00033,node00026,influence,[complete=true,name=i28,role=[use(none,in_hierarchy,r2,1)]],[curve=[-14,9]]).
arc(arc00026,node00034,node00033,influence,[name=i18],[]).
arc(arc00038,node00035,node00028,influence,[complete=true,name=i30,role=[use(none,in_hierarchy,r3,1)]],[curve=[-10,9]]).
arc(arc00027,node00036,node00035,influence,[name=i19],[]).
arc(arc00040,node00037,node00030,influence,[complete=true,name=i32,role=[use(none,in_hierarchy,r4,1)]],[curve=[-8,4]]).
arc(arc00028,node00038,node00037,influence,[name=i20],[]).
arc(arc00041,node00039,node00038,influence,[complete=true,name=i33,role=[use(none,in_hierarchy,pop_size,1)]],[curve=[-7,20]]).
arc(arc00042,node00039,node00036,influence,[complete=true,name=i34,role=[use(none,in_hierarchy,pop_size,1)]],[curve=[-5,35]]).
arc(arc00043,node00039,node00034,influence,[complete=true,name=i35,role=[use(none,in_hierarchy,pop_size,1)]],[curve=[-4,50]]).
arc(arc00029,node00040,node00039,influence,[name=i21],[]).
arc(arc00030,node00002,node00040,influence,[complete=true,name=i22,role=[use(none,in_hierarchy,pop_size_1,1)]],[curve=[34,-56]]).
arc(arc00031,node00006,node00040,influence,[complete=true,name=i23,role=[use(none,in_hierarchy,pop_size_3,1)]],[curve=[34,-3]]).
arc(arc00032,node00008,node00040,influence,[complete=true,name=i24,role=[use(none,in_hierarchy,pop_size_4,1)]],[curve=[34,21]]).
arc(arc00061,node00004,node00040,influence,[complete=true,name=i53,role=[use(none,in_hierarchy,pop_size_2,1)]],[curve=[33,-28]]).
arc(arc00053,node00042,node00016,influence,[complete=true,name=i45,role=[use(none,in_hierarchy,m1,1)]],[curve=[3,-6]]).
arc(arc00049,node00043,node00042,influence,[name=i41],[]).
arc(arc00054,node00044,node00018,influence,[complete=true,name=i46,role=[use(none,in_hierarchy,m2,1)]],[curve=[4,-6]]).
arc(arc00050,node00045,node00044,influence,[name=i42],[]).
arc(arc00055,node00046,node00020,influence,[complete=true,name=i47,role=[use(none,in_hierarchy,m3,1)]],[curve=[4,-6]]).
arc(arc00051,node00047,node00046,influence,[name=i43],[]).
arc(arc00056,node00048,node00022,influence,[complete=true,name=i48,role=[use(none,in_hierarchy,m4,1)]],[curve=[5,-6]]).
arc(arc00052,node00049,node00048,influence,[name=i44],[]).

