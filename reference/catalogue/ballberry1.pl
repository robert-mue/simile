source(program='AME',version= 9.0,edition=enterprise,date='Wed Feb 20 14:02:02 GMT 2008').

roots([node00004,node00020]).

properties([complete-true,file_name-'C:/Documents and Settings/jmm.KONTIKI/My Documents/Program Files/ExampleModels/iteration/BallBerry2.sml',multiplication_spec-[count=[]],name-ballberry1,separate-0,step-1]).

node(node00004,submodel,[node00005,node00006,node00012,node00044,node00045,node00048,node00049,node00054,node00055],[complete=true,name='Environment'],[bounding_box=[110,-325,301,-232],caption_offset=[0,0],internal_extent=[0,0,191,93]]).
links(node00004,[arc00018-arc00039,arc00031-arc00009,arc00032-arc00043]).
node(node00005,border,[],[],[centre=[66,93]]).
node(node00006,border,[],[],[centre=[0,68]]).
node(node00012,border,[],[],[centre=[99,93]]).
node(node00044,variable,[],[comment='Typical diurnal graph (24 hour)',complete=true,description='Relative humidity (proportion)',name='H'],[caption_offset=[0,0],centre=[107,42]]).
node(node00045,function,[],[complete=true,name=fn3,spec='graph(time())',table_data=[file='/graph/',data=[1, 0.7,400],indices=[0,23,400,0],current=[38,28,19,8,1,10,11,20,39,76,353,383,399,397,378,333,282,151,106,66,40],units=1,bounds=1,dims=21],units=1,value=graph(time(''))],[]).
node(node00048,variable,[],[comment='Graph for a sunny day (24 hours)',complete=true,description='Photon flux density (umol m^-2 s^-1)',name='Q'],[caption_offset=[0,0],centre=[35,42]]).
node(node00049,function,[],[complete=true,name=fn5,spec='graph(time())',table_data=[file='/graph/',data=[1500,0,400],indices=[0,23,400,0],current=[399,399,391,365,328,280,202,88,36,4,1,14,34,91,169,265,332,368,400,400,400],units=1,bounds=1,dims=21],units=1,value=graph(time(''))],[]).
node(node00054,variable,[],[comment='Typical diurnal curve in forest canopy',complete=true,description='Carbon dioxide concentration (umol CO2 (mol air)^-1)',name='C_a'],[caption_offset=[0,0],centre=[148,44]]).
node(node00055,function,[],[complete=true,name=fn8,spec='graph(time())',table_data=[file='/graph/',data=[370,340,400],indices=[0,23,400,0],current=[38,28,19,8,0,5,30,119,259,304,353,383,399,397,378,333,282,151,106,66,40],units=1,bounds=1,dims=21],units=1,value=graph(time(''))],[]).
node(node00020,submodel,[node00008,node00009,node00014,node00021,node00022,node00023,node00024,node00025,node00026,node00027,node00050,node00051,node00052,node00053,node00062,node00063],[complete=true,name='Ball-Berry'],[bounding_box=[-259,-179,252,172],caption_offset=[0,0],internal_extent=[0,24,511,375]]).
links(node00020,[arc00009-arc00036,arc00039-arc00049,arc00043-arc00050]).
node(node00008,variable,[],[complete=true,name=errorGs],[caption_offset=[0,0],centre=[224,332]]).
node(node00009,function,[],[complete=true,name=fn1_1,units=1,value=last(errorGs_0)],[]).
node(node00014,submodel,[node00002,node00003,node00007,node00015,node00016,node00017,node00018,node00019,node00028,node00029,node00030,node00031,node00032,node00042,node00043],[complete=true,multiplication_spec=[count=[]],name='Iteration',separate=0,step=2],[bounding_box=[26,54,341,305],caption_offset=[0,0],internal_extent=[0,0,315,251]]).
links(node00014,[arc00036-arc00059,arc00045-arc00062,arc00049-arc00063,arc00050-arc00064,arc00052-arc00065,arc00053-arc00066,arc00054-arc00067,arc00058-arc00048,arc00060-arc00047,arc00061-arc00046]).
node(node00002,submodel,[node00010,node00011,node00013,node00040,node00041,node00046,node00047],[complete=true,name='Assimilation'],[bounding_box=[20,16,202,165],caption_offset=[0,0],internal_extent=[0,0,182,150]]).
links(node00002,[arc00002-arc00056,arc00055-arc00004,arc00055-arc00058,arc00059-arc00057]).
node(node00010,border,[],[],[centre=[92,150]]).
node(node00011,border,[],[],[centre=[182,117]]).
node(node00013,border,[],[],[centre=[109,0]]).
node(node00040,variable,[],[complete=true,description='Assimation (umol CO2 m^-2 s^-1)',name='A'],[caption_offset=[0,0],centre=[74,85]]).
node(node00041,function,[],[complete=true,name=fn1,units=1,value='A_Q'*last('Gs_0')],[]).
node(node00046,variable,[],[comment='Relationship of Assimilation with photon flux density (light) when stomatal conductance (Gs) is maximum',complete=true,description='Assimilation light response curve',name='A_Q'],[caption_offset=[0,0],centre=[42,19]]).
node(node00047,function,[],[complete=true,name=fn4,spec='graph(Q)',table_data=[file='/graph/',data=[15,0,400],indices=[0,1600,400,0],current=[399,369,336,295,257,214,175,135,99,59,32,19,6,0,0,0,0,0,0,0,0],units=1,bounds=1,dims=21],units=1,value=graph('Q')],[]).
node(node00003,variable,[],[complete=true,name=errorGs],[caption_offset=[0,0],centre=[204,210]]).
node(node00007,function,[],[complete=true,name=fn1_1,units=1,value='Gs_0'-last('Gs_0')],[]).
node(node00015,border,[],[],[centre=[126,251]]).
node(node00016,border,[],[],[centre=[172,0]]).
node(node00017,border,[],[],[centre=[205,251]]).
node(node00018,border,[],[],[centre=[279,251]]).
node(node00019,border,[],[],[centre=[315,192]]).
node(node00028,border,[],[],[centre=[315,101]]).
node(node00029,border,[],[],[centre=[315,114]]).
node(node00030,border,[],[],[centre=[315,179]]).
node(node00031,border,[],[],[centre=[315,161]]).
node(node00032,border,[],[],[centre=[243,251]]).
node(node00042,variable,[],[comment='Ball-Berry equation',complete=true,description='Stomatal conductance (mol m^-2 s^-1)',name='Gs'],[caption_offset=[0,0],centre=[266,137]]).
node(node00043,function,[],[complete=true,name=fn2,units=1,value=(if time('')==time then 'Gs' else g_0+g_1*'A'*'H'/'C_a')],[]).
node(node00021,border,[],[],[centre=[418,24]]).
node(node00022,variable,[],[complete=true,name='Gs'],[caption_offset=[0,0],centre=[284,334]]).
node(node00023,function,[],[complete=true,name=fn1_0,units=1,value=(if time('')==0 then g_0 else last('Gs_0'))],[]).
node(node00024,border,[],[],[centre=[447,24]]).
node(node00025,variable,[],[complete=true,name='A'],[caption_offset=[0,0],centre=[154,332]]).
node(node00026,function,[],[complete=true,name=fn2,units=1,value='A'],[]).
node(node00027,border,[],[],[centre=[294,24]]).
node(node00050,variable,[],[complete=true,description='Stomatal conductance in the dark (mol m^-2 s^-1)',name=g_0],[caption_offset=[0,0],centre=[442,229]]).
node(node00051,function,[],[complete=true,name=fn6,spec=[48,46,48,49],units=1,value= 0.01],[]).
node(node00052,variable,[],[complete=true,description='Ball-Berry stomatal conductance coefficient',name=g_1],[caption_offset=[0,0],centre=[445,175]]).
node(node00053,function,[],[complete=true,name=fn7,spec=[50,51],units=1,value=23],[]).
node(node00062,variable,[],[complete=true,name=time],[caption_offset=[0,0],centre=[394,248]]).
node(node00063,function,[],[complete=true,name=fn1,spec=[116,105,109,101,40,41],units=1,value=time('')],[]).

arc(arc00018,node00044,node00005,influence,[complete=true,name=i6,role=[use(none,in_hierarchy,'H',1)]],[curve=[-8,-1]]).
arc(arc00006,node00045,node00044,influence,[name=i5],[]).
arc(arc00031,node00048,node00006,influence,[complete=true,name=i10,role=[use(none,in_hierarchy,'Q',1)]],[curve=[0,-6]]).
arc(arc00010,node00049,node00048,influence,[name=i9],[]).
arc(arc00032,node00054,node00012,influence,[complete=true,name=i16,role=[use(none,in_hierarchy,'C_a',1)]],[curve=[10,-12]]).
arc(arc00016,node00055,node00054,influence,[name=i15],[]).
arc(arc00009,node00004,node00020,influence,[complete=true,name=i10,role=[use(none,in_hierarchy,'Q',1)]],[curve=[14,20]]).
arc(arc00039,node00004,node00020,influence,[complete=true,name=i6,role=[use(none,in_hierarchy,'H',1)]],[curve=[-2,4]]).
arc(arc00043,node00004,node00020,influence,[complete=true,name=i16,role=[use(none,in_hierarchy,'C_a',1)]],[curve=[-4,2]]).
arc(arc00035,node00009,node00008,influence,[name=i1_1],[]).
arc(arc00047,node00014,node00009,influence,[complete=true,name=i3_0,role=[use(none,in_hierarchy,errorGs_0,1)]],[curve=[8,0]]).
arc(arc00055,node00040,node00010,influence,[complete=true,name=i1_0,role=[use(none,in_hierarchy,usr('A'),1)]],[curve=[12,-4]]).
arc(arc00001,node00041,node00040,influence,[name=i1],[]).
arc(arc00056,node00011,node00041,influence,[complete=true,name=i1_1,role=[use(none,in_hierarchy,'Gs_0',1)]],[curve=[-7,24]]).
arc(arc00051,node00046,node00041,influence,[complete=true,name=i8,role=[use(none,in_hierarchy,'A_Q',1)]],[curve=[21,10]]).
arc(arc00008,node00047,node00046,influence,[name=i7],[]).
arc(arc00057,node00013,node00047,influence,[complete=true,name=i10,role=[use(none,in_hierarchy,'Q',1)]],[curve=[4,14]]).
arc(arc00029,node00007,node00003,influence,[name=i1_3],[]).
arc(arc00058,node00002,node00015,influence,[complete=true,name=i2,role=[use(none,in_hierarchy,'A_0',1)]],[curve=[14,-3]]).
arc(arc00059,node00016,node00002,influence,[complete=true,name=i10,role=[use(none,in_hierarchy,'Q',1)]],[curve=[-12,3]]).
arc(arc00060,node00003,node00017,influence,[complete=true,name=i3_0,role=[use(none,in_hierarchy,errorGs,1)]],[curve=[-3,-2]]).
arc(arc00002,node00042,node00002,influence,[complete=true,name=i1_1,role=[use(none,in_hierarchy,'Gs',1)]],[curve=[-4,15]]).
arc(arc00030,node00042,node00007,influence,[complete=true,name=i1_4,role=[use(none,in_hierarchy,'Gs_0',1)]],[curve=[-12,2]]).
arc(arc00061,node00042,node00018,influence,[complete=true,name=i2_1,role=[use(none,in_hierarchy,'Gs',1)]],[curve=[12,6]]).
arc(arc00003,node00043,node00042,influence,[name=i2_0_0],[]).
arc(arc00004,node00002,node00043,influence,[complete=true,name=i1_0,role=[use(none,in_hierarchy,usr('A'),1)]],[curve=[4,-16]]).
arc(arc00062,node00019,node00043,influence,[complete=true,name=i2_0,role=[use(none,in_hierarchy,time,1)]],[curve=[-3,7]]).
arc(arc00063,node00028,node00043,influence,[complete=true,name=i6,role=[use(none,in_hierarchy,'H',1)]],[curve=[12,7]]).
arc(arc00064,node00029,node00043,influence,[complete=true,name=i16,role=[use(none,in_hierarchy,'C_a',1)]],[curve=[10,7]]).
arc(arc00065,node00030,node00043,influence,[complete=true,name=i14,role=[use(none,in_hierarchy,g_0,1)]],[curve=[0,6]]).
arc(arc00066,node00031,node00043,influence,[complete=true,name=i13,role=[use(none,in_hierarchy,g_1,1)]],[curve=[2,6]]).
arc(arc00067,node00032,node00043,influence,[complete=true,name=i2_1,role=[use(none,in_hierarchy,'Gs',1)]],[curve=[-15,-2]]).
arc(arc00049,node00021,node00014,influence,[complete=true,name=i6,role=[use(none,in_hierarchy,'H',1)]],[curve=[30,20]]).
arc(arc00054,node00022,node00014,influence,[complete=true,name=i2_1,role=[use(none,in_hierarchy,'Gs',1)]],[curve=[-4,-1]]).
arc(arc00020,node00023,node00022,influence,[name=i1_0],[]).
arc(arc00046,node00014,node00023,influence,[complete=true,name=i2_1,role=[use(none,in_hierarchy,'Gs_0',1)]],[curve=[4,0]]).
arc(arc00050,node00024,node00014,influence,[complete=true,name=i16,role=[use(none,in_hierarchy,'C_a',1)]],[curve=[32,26]]).
arc(arc00023,node00026,node00025,influence,[name=i4],[]).
arc(arc00048,node00014,node00026,influence,[complete=true,name=i2,role=[use(none,in_hierarchy,'A',1)]],[curve=[-2,-10]]).
arc(arc00036,node00027,node00014,influence,[complete=true,name=i10,role=[use(none,in_hierarchy,'Q',1)]],[curve=[7,24]]).
arc(arc00037,node00050,node00023,influence,[complete=true,name=i1_2,role=[use(none,in_hierarchy,g_0,1)]],[curve=[36,40]]).
arc(arc00052,node00050,node00014,influence,[complete=true,name=i14,role=[use(none,in_hierarchy,g_0,1)]],[curve=[-5,22]]).
arc(arc00012,node00051,node00050,influence,[name=i11],[]).
arc(arc00053,node00052,node00014,influence,[complete=true,name=i13,role=[use(none,in_hierarchy,g_1,1)]],[curve=[4,22]]).
arc(arc00014,node00053,node00052,influence,[name=i12],[]).
arc(arc00045,node00062,node00014,influence,[complete=true,name=i2_0,role=[use(none,in_hierarchy,time,1)]],[curve=[-5,10]]).
arc(arc00024,node00063,node00062,influence,[name=i1],[]).

