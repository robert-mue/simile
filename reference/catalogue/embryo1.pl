source(program='AME',version= 9.0,edition=standard,date='Wed Feb 06 13:00:10 GMT 2008').

roots([node00021,node00026,node00050]).

properties([complete-true,file_name-'C:/Inetpub/wwwroot/www/examples/catalogue/models/bob/embryo1/embryo1.sml',name-embryo1]).

node(node00021,submodel,[node00002,node00003,node00004,node00005,node00006,node00007,node00008,node00009,node00010,node00011,node00012,node00013,node00014,node00015,node00016,node00017,node00018,node00019,node00020,node00022,node00023,node00024,node00025,node00031,node00033,node00036,node00038,node00039,node00041,node00042,node00043,node00045,node00047,node00048,node00051,node00053,node00054,node00055,node00057,node00058,node00060,node00065,node00067,node00068,node00070,node00072,node00074,node00076,node00077,node00078,node00079,node00081,node00084,node00085],[complete=true,fill_colour='#ffff80',multiplication_spec=[count=[400]],name='Cell',separate=0],[bounding_box=[-14,-94,330,304],caption_offset=[39,-7],internal_extent=[0,-52,344,345]]).
links(node00021,[arc00026-arc00028,arc00031-arc00030,arc00035-arc00034,arc00040-arc00039,arc00043-arc00045,arc00046-arc00048,arc00050-arc00049,arc00061-arc00060,arc00064-arc00063,arc00067-arc00066,arc00070-arc00069,arc00073-arc00072,arc00075-arc00077]).
references(node00021,[local(arc00024),local(arc00025)]).
node(node00002,compartment,[],[complete=true,name=activin],[caption_offset=[-23,-1],centre=[179,31]]).
node(node00003,function,[],[complete=true,max_val=10000,min_val=0,name=fn1,units=1,value=0],[]).
node(node00004,compartment,[],[complete=true,name='SMAD'],[caption_offset=[0,0],centre=[186,233]]).
node(node00005,function,[],[complete=true,max_val=5000,min_val=0,name=fn2,units=1,value=0],[]).
node(node00006,cloud,[],[complete=true,name=cd1],[centre=[179,-33]]).
node(node00007,function,[],[complete=true,name=fn3,units=int,value=(if time(1)<10 and index(1)==46 then k_activin_create else 0)],[]).
node(node00008,function,[],[name=fn4,units=1,value=k_white_to_black*white*black],[]).
node(node00009,cloud,[],[complete=true,name=cd1_1],[centre=[297,132]]).
node(node00010,function,[],[name=fn5,units=1,value=k_black_excrete*black],[]).
node(node00011,function,[],[complete=true,name=fn1_1,units=1,value=k_activin_breakdown*activin],[]).
node(node00012,function,[],[name=fn6,units=1,value=(if black>enzyme/dt(1) then enzyme else 0)],[]).
node(node00013,cloud,[],[complete=true,name=cd4],[centre=[41,36]]).
node(node00014,function,[],[complete=true,name=fn7,units=1,value=sum({white_interflow_0})],[]).
node(node00015,cloud,[],[complete=true,name=cd5],[centre=[285,29]]).
node(node00016,function,[],[complete=true,name=fn8,units=1,value=k_activin_outflow*activin*n_neighbours/8],[]).
node(node00017,cloud,[],[complete=true,name=cd6],[centre=[45,239]]).
node(node00018,function,[],[complete=true,name=fn9,units=1,value=(if time(1)<'SMAD_competency_time' then k_SMAD_production*bound_receptors else 0)],[]).
node(node00019,variable,[],[complete=true,name='cell type'],[caption_offset=[0,0],centre=[307,289]]).
node(node00020,function,[],[name=fn10,units=1,value=k_black_outflow*black],[]).
node(node00022,variable,[],[complete=true,name=row],[caption_offset=[-5,-29],centre=[318,0]]).
node(node00023,function,[],[complete=true,name=fn11,units=int,value=floor((index(1)-1)/20)+1],[]).
node(node00024,variable,[],[complete=true,name=col],[caption_offset=[-7,-31],centre=[302,-31]]).
node(node00025,function,[],[complete=true,name=fn12,units=1,value=fmod(index(1)-1,20)+1],[]).
node(node00031,function,[],[complete=true,max_val=3,min_val=1,name=fn1_2,units=1,value=(if max_SMAD>1500 then 3 elseif max_SMAD>500 then 2 else 1)],[]).
node(node00033,border,[],[name=var5],[centre=[344,40]]).
node(node00036,border,[],[name=var8],[centre=[344,84]]).
node(node00038,variable,[],[complete=true,name='activin '],[caption_offset=[0,0],centre=[50,68]]).
node(node00039,function,[],[complete=true,name=fn2_1,units=1,value=k_activin_binding*activin],[]).
node(node00041,border,[],[name=var2],[centre=[1,118]]).
node(node00042,function,[],[complete=true,name=fn16,units=1,value=rand_const(97,103)],[]).
node(node00043,border,[],[name=var14],[centre=[344,24]]).
node(node00045,border,[],[name=var16],[centre=[343,-12]]).
node(node00047,compartment,[],[complete=true,name='bound activin'],[caption_offset=[0,0],centre=[179,139]]).
node(node00048,function,[],[complete=true,max_val=8,min_val=0,name=fn1_0,units=1,value=0],[]).
node(node00051,function,[],[name=fn2_0,units=1,value= 0.001 *activin],[]).
node(node00053,cloud,[],[complete=true,name=cd2],[centre=[300,234]]).
node(node00054,function,[],[complete=true,name=fn3_0,units=1,value=k_SMAD_breakdown*'SMAD'],[]).
node(node00055,variable,[],[complete=true,name='max SMAD'],[caption_offset=[0,0],centre=[243,299]]).
node(node00057,function,[],[complete=true,max_val=5000,min_val=0,name=fn4_0,units=1,value=(if'SMAD'>prev(1) then 'SMAD' else prev(1))],[]).
node(node00058,function,[],[complete=true,max_val=100,min_val=0,name=fn1_3,units=1,value=(if activin>100 then 100 else activin)],[]).
node(node00060,border,[],[name=var5_0],[centre=[1,165]]).
node(node00065,border,[],[name=var7],[centre=[1,-4]]).
node(node00067,border,[],[name=var9_0],[centre=[1,43]]).
node(node00068,border,[],[name=var8_0],[centre=[0,213]]).
node(node00070,function,[],[complete=false,name=fn1_4],[]).
node(node00072,variable,[],[complete=true,name='n neighbours'],[caption_offset=[0,0],centre=[279,161]]).
node(node00074,border,[],[name=var12],[centre=[1,240]]).
node(node00076,border,[],[name=var14_0],[centre=[1,263]]).
node(node00077,function,[],[name=fn6_0,units=int,value=5*row],[]).
node(node00078,function,[],[complete=true,name=fn2_2,units=int,value=sum({one_0})],[]).
node(node00079,function,[],[name=fn7_0,units=1,value=5*col],[]).
node(node00081,function,[],[name=fn8_0,units=1,value=black/300],[]).
node(node00084,border,[],[name=var5_1],[centre=[344,161]]).
node(node00085,border,[],[name=var6],[centre=[344,140]]).
node(node00026,submodel,[node00027,node00028,node00029,node00030,node00032,node00034,node00035,node00044,node00046,node00080,node00082,node00083,node00086],[complete=true,fill_colour='#e0e0e0',multiplication_spec=[count=[]],name='Neighbour',separate=0],[bounding_box=[383,-27,526,150],caption_offset=[30,-11],internal_extent=[0,0,143,177]]).
links(node00026,[arc00028-arc00027,arc00029-arc00031,arc00045-arc00044,arc00048-arc00047,arc00071-arc00073,arc00077-arc00076]).
references(node00026,[local(arc00024),local(arc00025)]).
node(node00027,condition,[],[complete=true,name=condition],[caption_offset=[0,0],centre=[81,33]]).
node(node00028,function,[],[complete=true,name=fn13,units=boolean,value=(abs(row-row_0)<=1 and abs(col-col_0)<=1 and not (row==row_0 and col==col_0))],[]).
node(node00029,variable,[],[complete=true,name='activin interflow'],[caption_offset=[17,-2],centre=[58,93]]).
node(node00030,function,[],[complete=true,name=fn14,units=1,value=activin_outflow/n_neighbours],[]).
node(node00032,function,[],[complete=false,name=fn15,units=1,value=black_outflow/8],[]).
node(node00034,border,[],[name=var6],[centre=[0,70]]).
node(node00035,border,[],[name=var7],[centre=[0,91]]).
node(node00044,border,[],[name=var15],[centre=[0,27]]).
node(node00046,border,[],[name=var17],[centre=[2,11]]).
node(node00080,variable,[],[complete=true,name=one],[caption_offset=[0,0],centre=[79,148]]).
node(node00082,function,[],[complete=true,name=fn3,units=int,value=1],[]).
node(node00083,border,[],[name=var4],[centre=[0,146]]).
node(node00086,border,[],[name=var7_0],[centre=[0,110]]).
node(node00050,submodel,[node00037,node00040,node00049,node00052,node00056,node00059,node00061,node00063,node00064,node00066,node00069,node00071,node00073,node00075],[complete=true,fill_colour='#bbffbb',multiplication_spec=[count=[]],name='Parameters',separate=0],[bounding_box=[-147,-84,-43,369],caption_offset=[24,-8],internal_extent=[-38,-31,67,422]]).
links(node00050,[arc00006-arc00035,arc00037-arc00040,arc00042-arc00050,arc00059-arc00061,arc00062-arc00064,arc00065-arc00067,arc00068-arc00070]).
node(node00037,variable,[],[complete=true,max_val= 0.005,min_val=0,name='k activin\nbinding',units=1,value= 0.001],[caption_offset=[1,1],centre=[3,102]]).
node(node00040,border,[],[name=var1],[centre=[66,101]]).
node(node00049,variable,[],[complete=true,max_val= 0.1,min_val=0,name='k activin\nbreakdown',units=1,value=0],[caption_offset=[0,0],centre=[11,174]]).
node(node00052,variable,[],[complete=true,max_val=1000,min_val=0,name='k activin\ncreate',units=int,value=500],[caption_offset=[0,0],centre=[19,-16]]).
node(node00056,variable,[],[complete=true,max_val=1,min_val=0,name='k activin\noutflow',units=1,value= 0.5],[caption_offset=[0,0],centre=[8,40]]).
node(node00059,border,[],[name=var4],[centre=[66,171]]).
node(node00061,variable,[],[complete=true,max_val= 0.5,min_val=0,name='k SMAD\nbreakdown',units=1,value= 0.1],[caption_offset=[0,0],centre=[10,234]]).
node(node00063,border,[],[name=var7],[centre=[67,236]]).
node(node00064,border,[],[name=var6],[centre=[66,-19]]).
node(node00066,border,[],[name=var8],[centre=[66,37]]).
node(node00069,variable,[],[complete=true,max_val=1000,min_val=0,name='k SMAD\nproduction',units=int,value=100],[caption_offset=[0,0],centre=[8,295]]).
node(node00071,variable,[],[complete=true,description='(minutes)',max_val=1000,min_val=0,name='SMAD\ncompetency\ntime',units=int,value=100],[caption_offset=[12,1],centre=[5,356]]).
node(node00073,border,[],[name=var11],[centre=[67,271]]).
node(node00075,border,[],[name=var13],[centre=[67,308]]).

arc(arc00001,node00003,node00002,influence,[name=i1],[]).
arc(arc00002,node00005,node00004,influence,[name=i2],[]).
arc(arc00003,node00006,node00002,flow,[complete=true,name='activin create'],[caption_offset=[-109,-32],curve=[550,514]]).
arc(arc00004,node00007,arc00003,influence,[name=i3],[]).
arc(arc00007,node00002,node00009,flow,[complete=true,name='activin breakdown'],[caption_offset=[-21,-42],curve=[550,494]]).
arc(arc00008,node00011,arc00007,influence,[name=i1_1],[]).
arc(arc00009,node00002,node00011,influence,[complete=true,name=i2_1,role=[use(none,in_hierarchy,activin,1)]],[curve=[8,-10]]).
arc(arc00011,node00013,node00002,flow,[complete=true,name='activin inflow'],[caption_offset=[-56,-40],curve=[550,500]]).
arc(arc00012,node00014,arc00011,influence,[name=i7],[]).
arc(arc00013,node00002,node00015,flow,[complete=true,name='activin outflow'],[caption_offset=[-47,-40],curve=[550,494]]).
arc(arc00014,node00016,arc00013,influence,[name=i8],[]).
arc(arc00038,node00002,node00016,influence,[complete=true,name=i28,role=[use(none,in_hierarchy,activin,1)]],[curve=[-2,11]]).
arc(arc00015,node00017,node00004,flow,[complete=true,name='SMAD production'],[caption_offset=[-88,4],curve=[550,496]]).
arc(arc00016,node00018,arc00015,influence,[name=i9],[]).
arc(arc00019,node00023,node00022,influence,[name=i11],[]).
arc(arc00020,node00025,node00024,influence,[name=i12],[]).
arc(arc00010,node00031,node00019,influence,[name=i1_2],[]).
arc(arc00026,arc00013,node00033,influence,[complete=true,name=i16],[curve=[4,-26]]).
arc(arc00030,node00036,node00014,influence,[complete=true,name=i20,role=[use(0,in_assoc,{white_interflow},list(1)),use(1,in_assoc,{white_interflow_0},list(1))]],[curve=[-8,56]]).
arc(arc00032,node00039,arc00023,influence,[name=i2_0],[]).
arc(arc00033,node00002,node00039,influence,[complete=true,name=i3_0,role=[use(none,in_hierarchy,activin,1)]],[curve=[10,0]]).
arc(arc00034,node00041,node00039,influence,[complete=true,name=i2_3,role=[use(none,in_hierarchy,k_activin_binding,1)]],[curve=[-7,-42]]).
arc(arc00043,node00022,node00043,influence,[complete=true,name=i33],[curve=[0,-8]]).
arc(arc00046,node00024,node00045,influence,[complete=true,name=i36],[curve=[2,-8]]).
arc(arc00023,node00002,node00047,flow,[complete=true,name='activin binding'],[caption_offset=[-113,-5],curve=[550,608]]).
arc(arc00051,node00047,node00018,influence,[complete=true,name=i4,role=[use(none,in_hierarchy,bound_receptors,1)]],[curve=[24,25]]).
arc(arc00005,node00048,node00047,influence,[name=i1_0],[]).
arc(arc00052,node00004,node00053,flow,[complete=true,name='SMAD breakdown'],[caption_offset=[-30,1],curve=[550,500]]).
arc(arc00053,node00054,arc00052,influence,[name=i5],[]).
arc(arc00054,node00004,node00054,influence,[complete=true,name=i6,role=[use(none,in_hierarchy,'SMAD',1)]],[curve=[0,-9]]).
arc(arc00017,node00055,node00031,influence,[complete=true,name=i2_2,role=[use(none,in_hierarchy,max_SMAD,1)]],[curve=[-2,-14]]).
arc(arc00055,node00057,node00055,influence,[name=i7_0],[]).
arc(arc00056,node00004,node00057,influence,[complete=true,name=i8_1,role=[use(none,in_hierarchy,'SMAD',1)]],[curve=[10,-10]]).
arc(arc00018,node00058,node00038,influence,[name=i1_3],[]).
arc(arc00036,node00002,node00058,influence,[complete=true,name=i2_4,role=[use(none,in_hierarchy,activin,1)]],[curve=[7,15]]).
arc(arc00039,node00060,node00011,influence,[complete=true,name=i6_0,role=[use(none,in_hierarchy,k_activin_breakdown,1)]],[curve=[8,2]]).
arc(arc00063,node00065,node00007,influence,[complete=true,name=i8_0,role=[use(none,in_hierarchy,k_activin_create,int)]],[curve=[0,-39]]).
arc(arc00066,node00067,node00016,influence,[complete=true,name=i11_0,role=[use(none,in_hierarchy,k_activin_outflow,1)]],[curve=[-6,-56]]).
arc(arc00049,node00068,node00054,influence,[complete=true,name=i10,role=[use(none,in_hierarchy,k_SMAD_breakdown,1)]],[curve=[-4,-58]]).
arc(arc00074,node00072,node00016,influence,[complete=true,name=i7_1,role=[use(none,in_hierarchy,n_neighbours,int),use(none,in_hierarchy,n_neighbours_0,int)]],[curve=[-30,9]]).
arc(arc00060,node00074,node00018,influence,[complete=true,name=i15,role=[use(none,in_hierarchy,k_SMAD_production,int)]],[curve=[-1,-24]]).
arc(arc00069,node00076,node00018,influence,[complete=true,name=i18,role=[use(none,in_hierarchy,'SMAD_competency_time',int)]],[curve=[-7,-24]]).
arc(arc00057,node00078,node00072,influence,[name=i2_5],[]).
arc(arc00072,node00084,node00078,influence,[complete=true,name=i5_0,role=[use(0,in_assoc,{one},list(int)),use(1,in_assoc,{one_0},list(int))]],[curve=[0,14]]).
arc(arc00075,node00072,node00085,influence,[complete=true,name=i8_2],[curve=[-6,-15]]).
arc(arc00024,node00021,node00026,relation,[complete=true,name=me],[caption_offset=[10,-20],curve=[-4,-14]]).
arc(arc00025,node00021,node00026,relation,[complete=true,name=other],[caption_offset=[3,8],curve=[-4,-14]]).
arc(arc00028,node00021,node00026,influence,[complete=true,name=i18],[curve=[0,-14]]).
arc(arc00031,node00026,node00021,influence,[complete=true,name=i21],[curve=[2,1]]).
arc(arc00045,node00021,node00026,influence,[complete=true,name=i35],[curve=[0,-13]]).
arc(arc00048,node00021,node00026,influence,[complete=true,name=i38],[curve=[2,-12]]).
arc(arc00073,node00026,node00021,influence,[complete=true,name=i6],[curve=[0,11]]).
arc(arc00077,node00021,node00026,influence,[complete=true,name=i10],[curve=[-4,-12]]).
arc(arc00021,node00028,node00027,influence,[name=i13],[]).
arc(arc00022,node00030,node00029,influence,[name=i14],[]).
arc(arc00027,node00034,node00030,influence,[complete=true,name=i17,role=[use(0,in_base,activin_outflow,1),use(1,in_base,activin_outflow_0,1)]],[curve=[0,-11]]).
arc(arc00029,node00029,node00035,influence,[complete=true,name=i19],[curve=[-2,10]]).
arc(arc00044,node00044,node00028,influence,[complete=true,name=i34,role=[use(0,in_base,row,int),use(1,in_base,row_0,int)]],[curve=[0,-7]]).
arc(arc00047,node00046,node00028,influence,[complete=true,name=i37,role=[use(0,in_base,col,1),use(1,in_base,col_0,1)]],[curve=[0,-4]]).
arc(arc00058,node00082,node00080,influence,[name=i3],[]).
arc(arc00071,node00080,node00083,influence,[complete=true,name=i4],[curve=[0,6]]).
arc(arc00076,node00086,node00030,influence,[complete=true,name=i9,role=[use(0,in_base,n_neighbours,int),use(1,in_base,n_neighbours_0,int)]],[curve=[-5,-12]]).
arc(arc00035,node00050,node00021,influence,[complete=true,name=i3],[curve=[-1,-6]]).
arc(arc00040,node00050,node00021,influence,[complete=true,name=i7],[curve=[-2,-8]]).
arc(arc00050,node00050,node00021,influence,[complete=true,name=i11],[curve=[0,-7]]).
arc(arc00061,node00050,node00021,influence,[complete=true,name=i16],[curve=[0,-6]]).
arc(arc00064,node00050,node00021,influence,[complete=true,name=i9],[curve=[0,-6]]).
arc(arc00067,node00050,node00021,influence,[complete=true,name=i12],[curve=[0,-7]]).
arc(arc00070,node00050,node00021,influence,[complete=true,name=i19],[curve=[-2,-7]]).
arc(arc00006,node00037,node00040,influence,[complete=true,name=i1_0],[curve=[-4,-12]]).
arc(arc00037,node00049,node00059,influence,[complete=true,name=i5],[curve=[-4,-10]]).
arc(arc00042,node00061,node00063,influence,[complete=true,name=i9],[curve=[-2,-12]]).
arc(arc00062,node00052,node00064,influence,[complete=true,name=i7],[curve=[1,-8]]).
arc(arc00065,node00056,node00066,influence,[complete=true,name=i10],[curve=[0,-8]]).
arc(arc00059,node00069,node00073,influence,[complete=true,name=i14],[curve=[-2,-12]]).
arc(arc00068,node00071,node00075,influence,[complete=true,name=i17],[curve=[-4,-13]]).

