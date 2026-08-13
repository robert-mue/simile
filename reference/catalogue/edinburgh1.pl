source(program='AME',version= 9.0,edition=standard,date='Tue Feb 05 17:20:49 GMT 2008').

roots([node00002,node00003,node00004,node00005,node00006,node00007,node00008,node00009,node00010,node00011,node00012,node00013,node00014,node00015,node00016,node00017,node00018,node00019,node00020,node00021,node00022,node00023,node00024,node00025,node00026,node00027,node00028,node00029,node00030,node00031,node00032,node00033,node00042,node00043,node00044,node00045,node00046,node00047,node00048,node00049]).

properties([complete-true,file_name-'C:/Inetpub/wwwroot/www/examples/catalogue/models/bob/edinburgh1/edinburgh1.sml',name-edinburgh1]).

node(node00002,compartment,[],[complete=true,min_val=0,name='Population size'],[caption_offset=[-14,-50],centre=[155,182]]).
node(node00003,cloud,[],[complete=true,name=cd1],[centre=[43,185]]).
node(node00004,function,[],[complete=true,name=fn1,units=1,value=15000],[]).
node(node00005,cloud,[],[complete=true,name=cd2],[centre=[258,180]]).
node(node00006,function,[],[complete=true,name=fn2,units=1,value=9000],[]).
node(node00007,variable,[],[complete=true,name='Total cars'],[caption_offset=[29,-4],centre=[199,122]]).
node(node00008,function,[],[complete=true,name=fn3,units=1,value=cars_per_head*population_size],[]).
node(node00009,variable,[],[complete=true,name='Cars per head'],[caption_offset=[0,0],centre=[127,79]]).
node(node00010,function,[],[complete=true,name=fn4,table_data=[file='/graph/',data=[3,0,400],indices=[0,200,400,1],current=[3,134,146,158,167,175,188,202,216,226,236,246,254,263,267,272,279,284,287,288,289],units=1,bounds=1,dims=21],units=1,value=graph(road_pricing)],[]).
node(node00011,variable,[],[complete=true,name='Road pricing'],[caption_offset=[0,0],centre=[-49,99]]).
node(node00012,function,[],[complete=true,name=fn5,units=1,value=0],[]).
node(node00013,variable,[],[complete=true,name='Emissions'],[caption_offset=[-36,-22],centre=[228,73]]).
node(node00014,function,[],[complete=true,name=fn7,units=1,value= 1.0e-06 *total_cars],[]).
node(node00015,variable,[],[complete=true,name='Pollution'],[caption_offset=[0,0],centre=[301,75]]).
node(node00016,function,[],[complete=true,name=fn8,table_data=[file='/graph/',data=[1,0,400],indices=[0,10,400,1],current=[1,89,126,151,168,181,200,215,225,234,242,252,263,271,279,283,293,300,307,315,319],units=1,bounds=1,dims=21],units=1,value=emissions*graph(wind)],[]).
node(node00017,variable,[],[comment='Note: temperature and age_structure are (at this stage) 0-1 multipliers that cause the effect of pollution to be even worse if either is suboptimal',complete=true,name='Health'],[caption_offset=[-25,-18],centre=[357,121]]).
node(node00018,function,[],[complete=true,name=fn9,table_data=[file='/graph/',data=[100,0,400],indices=[0,5,400,1],current=[70,71,72,80,88,97,102,112,120,128,135,147,157,166,173,183,190,196,202,207,210],units=1,bounds=1,dims=21],units=1,value=temperature*age_structure*graph(pollution)],[]).
node(node00019,variable,[],[complete=true,name='Wind'],[caption_offset=[23,-19],centre=[282,38]]).
node(node00020,function,[],[complete=true,name=fn10,units=1,value=2],[]).
node(node00021,variable,[],[complete=true,name='Temperature'],[caption_offset=[5,-30],centre=[354,59]]).
node(node00022,function,[],[complete=true,name=fn11,units=1,value=1],[]).
node(node00023,variable,[],[complete=true,name='Age structure'],[caption_offset=[1,-1],centre=[344,171]]).
node(node00024,function,[],[complete=true,name=fn12,units=1,value=1],[]).
node(node00025,function,[],[complete=true,units=1,value=500000],[]).
node(node00026,variable,[],[complete=true,name='CO2'],[caption_offset=[-17,-3],centre=[221,5]]).
node(node00027,function,[],[complete=true,name=fn1_0,units=1,value= 0.5 *emissions+100*industrial_capital+ 0.5 *decomposition],[]).
node(node00028,compartment,[],[complete=true,name='Industrial capital'],[caption_offset=[0,-48],centre=[132,-35]]).
node(node00029,function,[],[complete=true,name=fn2_0,units=1,value=1000],[]).
node(node00030,cloud,[],[complete=true,name=cd1_0],[centre=[-51,-30]]).
node(node00031,function,[],[complete=true,name=fn3_0,table_data=[file='/graph/',data=[20,0,400],indices=[0,200,400,1],current=[266,241,224,203,191,181,175,162,155,149,143,139,139,139,139,139,139,139,139,139,139],units=1,bounds=1,dims=21],units=1,value=graph(road_pricing)],[]).
node(node00032,cloud,[],[complete=true,name=cd2_0],[centre=[274,-40]]).
node(node00033,function,[],[complete=true,name=fn4_0,units=1,value=10],[]).
node(node00042,compartment,[],[complete=true,name='Landfill'],[caption_offset=[0,0],centre=[157,264]]).
node(node00043,function,[],[complete=true,name=fn9_0,units=1,value=1000000],[]).
node(node00044,cloud,[],[complete=true,name=cd6],[centre=[2,265]]).
node(node00045,function,[],[complete=true,name=fn10_0,table_data=[file='/graph/',data=[ 0.5,0,400],indices=[0,100,400,1],current=[16,30,73,162,197,228,245,259,267,273,278,281,284,284,284,284,284,284,284,285,285],units=1,bounds=1,dims=21],units=1,value=graph(uplift_charge)*population_size],[]).
node(node00046,cloud,[],[complete=true,name=cd7],[centre=[275,265]]).
node(node00047,function,[],[complete=true,name=fn11_0,units=1,value= 0.2 *landfill],[]).
node(node00048,variable,[],[complete=true,name='Uplift charge'],[caption_offset=[0,0],centre=[-44,167]]).
node(node00049,function,[],[complete=true,name=fn1_1,units=1,value=0],[]).

arc(arc00001,node00003,node00002,flow,[complete=true,name='Reproduction'],[caption_offset=[-55,-2],curve=[550,500]]).
arc(arc00002,node00004,arc00001,influence,[complete=true,name=i1],[]).
arc(arc00003,node00002,node00005,flow,[complete=true,name='Mortality'],[caption_offset=[-8,0],curve=[550,493]]).
arc(arc00004,node00006,arc00003,influence,[complete=true,name=i2],[]).
arc(arc00005,node00008,node00007,influence,[complete=true,name=i3],[]).
arc(arc00014,node00002,node00008,influence,[complete=true,name=i13,role=[use(none,in_hierarchy,population_size,1)]],[curve=[-10,-7]]).
arc(arc00016,node00009,node00008,influence,[complete=true,name=i15,role=[use(none,in_hierarchy,cars_per_head,1)]],[curve=[8,-15]]).
arc(arc00006,node00010,node00009,influence,[complete=true,name=i4],[]).
arc(arc00017,node00011,node00010,influence,[complete=true,name=i16,role=[use(none,in_hierarchy,road_pricing,1)]],[curve=[-5,-40]]).
arc(arc00007,node00012,node00011,influence,[name=i5],[]).
arc(arc00008,node00014,node00013,influence,[complete=true,name=i7],[]).
arc(arc00015,node00007,node00014,influence,[complete=true,name=i14,role=[use(none,in_hierarchy,total_cars,1)]],[curve=[-9,-6]]).
arc(arc00009,node00016,node00015,influence,[complete=true,name=i8],[]).
arc(arc00018,node00013,node00016,influence,[complete=true,name=i18,role=[use(none,in_hierarchy,emissions,1)]],[curve=[0,-16]]).
arc(arc00010,node00018,node00017,influence,[complete=true,name=i9],[]).
arc(arc00020,node00015,node00018,influence,[complete=true,name=i20,role=[use(none,in_hierarchy,pollution,1)]],[curve=[8,-12]]).
arc(arc00019,node00019,node00016,influence,[complete=true,name=i19,role=[use(none,in_hierarchy,wind,1)]],[curve=[6,-3]]).
arc(arc00011,node00020,node00019,influence,[complete=true,name=i10],[]).
arc(arc00021,node00021,node00018,influence,[complete=true,name=i21,role=[use(none,in_hierarchy,temperature,1)]],[curve=[12,0]]).
arc(arc00012,node00022,node00021,influence,[complete=true,name=i11],[]).
arc(arc00022,node00023,node00018,influence,[complete=true,name=i22,role=[use(none,in_hierarchy,age_structure,1)]],[curve=[-10,-2]]).
arc(arc00013,node00024,node00023,influence,[complete=true,name=i12],[]).
arc(arc00023,node00025,node00002,influence,[],[]).
arc(arc00024,node00027,node00026,influence,[name=i1_0],[]).
arc(arc00025,node00013,node00027,influence,[complete=true,name=i2_0,role=[use(none,in_hierarchy,emissions,1)]],[curve=[-14,2]]).
arc(arc00047,arc00045,node00027,influence,[complete=true,name=i17,role=[use(none,in_hierarchy,decomposition,1)]],[curve=[132,14]]).
arc(arc00031,node00028,node00027,influence,[complete=true,name=i6,role=[use(none,in_hierarchy,industrial_capital,1)]],[curve=[7,-15]]).
arc(arc00026,node00029,node00028,influence,[name=i3_0],[]).
arc(arc00027,node00030,node00028,flow,[complete=true,name='Construction'],[caption_offset=[-66,-39],curve=[550,500]]).
arc(arc00028,node00031,arc00027,influence,[name=i4_0],[]).
arc(arc00051,node00011,node00031,influence,[complete=true,name=i1_1,role=[use(none,in_hierarchy,road_pricing,1)]],[curve=[-28,-19]]).
arc(arc00029,node00028,node00032,flow,[complete=true,name='Closures'],[caption_offset=[-17,-39],curve=[550,500]]).
arc(arc00030,node00033,arc00029,influence,[name=i5_0],[]).
arc(arc00042,node00043,node00042,influence,[name=i14_0],[]).
arc(arc00043,node00044,node00042,flow,[complete=true,name='Refuse collection'],[caption_offset=[-71,0],curve=[550,496]]).
arc(arc00044,node00045,arc00043,influence,[name=i15_0],[]).
arc(arc00048,node00002,node00045,influence,[complete=true,name=i18_0,role=[use(none,in_hierarchy,population_size,1)]],[curve=[15,14]]).
arc(arc00045,node00042,node00046,flow,[complete=true,name='Decomposition'],[caption_offset=[-9,-2],curve=[550,494]]).
arc(arc00046,node00047,arc00045,influence,[name=i16_0],[]).
arc(arc00049,node00042,node00047,influence,[complete=true,name=i19_0,role=[use(none,in_hierarchy,landfill,1)]],[curve=[0,-10]]).
arc(arc00053,node00048,node00045,influence,[complete=true,name=i3_1,role=[use(none,in_hierarchy,uplift_charge,1)]],[curve=[22,-26]]).
arc(arc00052,node00049,node00048,influence,[name=i2_1],[]).

