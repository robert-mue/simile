source(program='AME',version= 9.0,edition=standard,date='Wed Feb 06 16:58:31 GMT 2008').

roots([node00002,node00003,node00004,node00005,node00006,node00007,node00008,node00009,node00010,node00011,node00012,node00013,node00014,node00015,node00035]).

properties([complete-true,file_name-'C:/Inetpub/wwwroot/www/examples/catalogue/models/bob/modmed1/modmed1.ame',name-modmed1,separate-0]).

node(node00002,compartment,[],[complete=true,min_val=0,name='WATER'],[caption_offset=[0,0],centre=[119,245]]).
node(node00003,cloud,[],[complete=true,name=cd6],[centre=[100,182]]).
node(node00004,function,[],[complete=true,name=fn9,table_data=[file='/graph/',data=[100,0,400],indices=[0,50,400,0],current=[73,80,89,157,215,273,310,346,370,390,390,398,401,384,365,362,340,262,215,123,60],units=1,bounds=1,dims=21],units=1,value=graph(season)],[]).
node(node00005,cloud,[],[complete=true,name=cd7],[centre=[227,246]]).
node(node00006,function,[],[complete=true,name=fn10,units=1,value=(if water>20 then  0.2*(water-20) else 0)],[]).
node(node00007,cloud,[],[complete=true,name=cd8],[centre=[131,180]]).
node(node00008,function,[],[complete=true,name=fn11,units=1,value=(if water>0 then  0.1*sum([leaf]) else 0)],[]).
node(node00009,submodel,[node00016,node00017,node00018,node00019,node00020,node00021,node00022,node00023,node00024,node00025,node00026,node00027,node00028,node00029,node00030,node00031,node00032,node00033,node00034,node00036,node00037,node00038,node00039],[complete=true,multiplication_spec=[count=[5]],name='PLANT SPECIES'],[bounding_box=[-40,-70,322,154],caption_offset=[29,0],internal_extent=[23,-2,389,224]]).
links(node00009,[arc00023-arc00022,arc00026-arc00025,arc00028-arc00027,arc00037-arc00038,arc00045-arc00044]).
node(node00016,compartment,[],[complete=true,min_val=0,name='LEAF'],[caption_offset=[-19,0],centre=[181,97]]).
node(node00017,compartment,[],[complete=true,min_val=0,name='STEM'],[caption_offset=[44,-19],centre=[300,97]]).
node(node00018,compartment,[],[complete=true,min_val=0,name='ROOTS'],[caption_offset=[0,0],centre=[182,180]]).
node(node00019,cloud,[],[complete=true,name=cd1],[centre=[58,99]]).
node(node00020,function,[],[complete=true,name=fn1,table_data=[file='/graph/',data=[1,0,400],indices=[0,50,400,0],current=[357,333,319,219,130,88,70,106,225,271,284,286,282,173,131,103,96,125,172,232,348],units=1,bounds=1,dims=21],units=1,value=element([ 0.4, 0.5, 0.6, 0.7, 0.8],index(1))*leaf*(1-leaf/2)*graph(season)],[]).
node(node00021,function,[],[complete=true,name=fn2,units=1,value= 0.1 *leaf],[]).
node(node00022,function,[],[complete=true,name=fn3,units=1,value= 0.1 *leaf],[]).
node(node00023,cloud,[],[complete=true,name=cd2],[centre=[167,31]]).
node(node00024,function,[],[complete=true,name=fn4,units=1,value=(if leaf>0 then  0.01*goats else 0)],[]).
node(node00025,cloud,[],[complete=true,name=cd3],[centre=[304,175]]).
node(node00026,function,[],[complete=true,name=fn5,units=1,value= 0.1 *roots],[]).
node(node00027,cloud,[],[complete=true,name=cd4],[centre=[301,35]]).
node(node00028,function,[],[complete=true,name=fn6,units=1,value=(if (fire==1,stem>0) then stem/dt(1) else 0)],[]).
node(node00029,cloud,[],[complete=true,name=cd5],[centre=[195,32]]).
node(node00030,function,[],[complete=true,name=fn8,units=1,value=(if (fire==1,leaf>0) then leaf/dt(1) else 0)],[]).
node(node00031,border,[],[name=var2],[centre=[23,41]]).
node(node00032,border,[],[name=var4],[centre=[388,40]]).
node(node00033,border,[],[name=var5],[centre=[388,33]]).
node(node00034,border,[],[name=var6],[centre=[226,222]]).
node(node00036,border,[],[name=var2_0],[centre=[67,223]]).
node(node00037,function,[],[complete=true,units=1,value= 0.1],[]).
node(node00038,function,[],[complete=true,units=1,value=1],[]).
node(node00039,function,[],[complete=true,units=1,value= 0.1],[]).
node(node00010,variable,[],[complete=true,name='GOATS'],[caption_offset=[0,0],centre=[-99,-35]]).
node(node00011,function,[],[complete=true,name=fn12,units=1,value=0],[]).
node(node00012,variable,[],[complete=true,name='FIRE'],[caption_offset=[0,0],centre=[375,-43]]).
node(node00013,function,[],[complete=true,name=fn13,units=1,value=(if (time(1)>0,rand(0,1)< 0.0) then 1 else 0)],[]).
node(node00014,variable,[],[complete=true,name=season],[caption_offset=[0,0],centre=[-6,178]]).
node(node00015,function,[],[complete=true,name=fn14,units=1,value=floor(fmod(time(1),50))],[]).
node(node00035,function,[],[complete=true,units=1,value=0],[]).

arc(arc00015,node00003,node00002,flow,[complete=true,name='RAIN'],[caption_offset=[-63,-18],curve=[550,500]]).
arc(arc00016,node00004,arc00015,influence,[complete=true,name=i9],[]).
arc(arc00017,node00002,node00005,flow,[complete=true,name='DRAINAGE'],[caption_offset=[-32,4],curve=[550,494]]).
arc(arc00018,node00006,arc00017,influence,[complete=true,name=i10],[]).
arc(arc00039,node00002,node00006,influence,[complete=true,name=i30,role=[use(none,in_hierarchy,water,1)]],[curve=[0,-8]]).
arc(arc00019,node00002,node00007,flow,[complete=true,name='EVAPOTRANSP'],[caption_offset=[5,-20],curve=[550,500]]).
arc(arc00020,node00008,arc00019,influence,[complete=true,name=i11],[]).
arc(arc00036,node00002,node00008,influence,[complete=true,name=i27,role=[use(none,in_hierarchy,water,1)]],[curve=[-4,-2]]).
arc(arc00038,node00009,node00008,influence,[complete=true,name=i29,role=[use(none,in_hierarchy,[leaf],array(1,5))]],[curve=[20,6]]).
arc(arc00003,node00016,node00017,flow,[complete=true,name='STEM ALLOC'],[caption_offset=[-53,2],curve=[550,494]]).
arc(arc00005,node00016,node00018,flow,[complete=true,name='ROOT ALLOC'],[caption_offset=[-107,-5],curve=[550,491]]).
arc(arc00001,node00019,node00016,flow,[complete=true,name='GROWTH'],[caption_offset=[-60,-40],curve=[550,495]]).
arc(arc00002,node00020,arc00001,influence,[complete=true,name=i1],[]).
arc(arc00029,node00016,node00020,influence,[complete=true,name=i20,role=[use(none,in_hierarchy,leaf,1)]],[curve=[0,10]]).
arc(arc00004,node00021,arc00003,influence,[complete=true,name=i2],[]).
arc(arc00030,node00016,node00021,influence,[complete=true,name=i21,role=[use(none,in_hierarchy,leaf,1)]],[curve=[0,-9]]).
arc(arc00006,node00022,arc00005,influence,[complete=true,name=i3],[]).
arc(arc00031,node00016,node00022,influence,[complete=true,name=i22,role=[use(none,in_hierarchy,leaf,1)]],[curve=[5,0]]).
arc(arc00007,node00016,node00023,flow,[complete=true,name='GRAZING'],[caption_offset=[-88,-58],curve=[550,500]]).
arc(arc00008,node00024,arc00007,influence,[complete=true,name=i4],[]).
arc(arc00033,node00016,node00024,influence,[complete=true,name=i24,role=[use(none,in_hierarchy,leaf,1)]],[curve=[-4,1]]).
arc(arc00009,node00018,node00025,flow,[complete=true,name='TURNOVER'],[caption_offset=[-25,3],curve=[550,500]]).
arc(arc00010,node00026,arc00009,influence,[complete=true,name=i5],[]).
arc(arc00032,node00018,node00026,influence,[complete=true,name=i23,role=[use(none,in_hierarchy,roots,1)]],[curve=[0,-10]]).
arc(arc00011,node00017,node00027,flow,[complete=true,name='STEM FIRE'],[caption_offset=[1,-57],curve=[550,486]]).
arc(arc00012,node00028,arc00011,influence,[complete=true,name=i6],[]).
arc(arc00035,node00017,node00028,influence,[complete=true,name=i26,role=[use(none,in_hierarchy,stem,1)]],[curve=[-3,0]]).
arc(arc00013,node00016,node00029,flow,[complete=true,name='LEAF FIRE'],[caption_offset=[1,-57],curve=[550,487]]).
arc(arc00014,node00030,arc00013,influence,[complete=true,name=i8],[]).
arc(arc00034,node00016,node00030,influence,[complete=true,name=i25,role=[use(none,in_hierarchy,leaf,1)]],[curve=[-4,-2]]).
arc(arc00022,node00031,node00024,influence,[complete=true,name=i13,role=[use(none,in_hierarchy,goats,1)]],[curve=[5,-33]]).
arc(arc00025,node00032,node00028,influence,[complete=true,name=i16,role=[use(none,in_hierarchy,fire,1)]],[curve=[6,18]]).
arc(arc00027,node00033,node00030,influence,[complete=true,name=i18,role=[use(none,in_hierarchy,fire,1)]],[curve=[7,45]]).
arc(arc00037,node00016,node00034,influence,[complete=true,name=i28],[curve=[27,-10]]).
arc(arc00044,node00036,node00020,influence,[complete=true,name=i3_0,role=[use(none,in_hierarchy,season,1)]],[curve=[-28,-12]]).
arc(arc00043,node00037,node00016,influence,[],[]).
arc(arc00046,node00038,node00017,influence,[],[]).
arc(arc00047,node00039,node00018,influence,[],[]).
arc(arc00023,node00010,node00009,influence,[complete=true,name=i14],[curve=[2,-12]]).
arc(arc00021,node00011,node00010,influence,[complete=true,name=i12],[]).
arc(arc00026,node00012,node00009,influence,[complete=true,name=i17],[curve=[3,12]]).
arc(arc00028,node00012,node00009,influence,[complete=true,name=i19],[curve=[1,12]]).
arc(arc00024,node00013,node00012,influence,[complete=true,name=i15],[]).
arc(arc00041,node00014,node00004,influence,[complete=true,name=i32,role=[use(none,in_hierarchy,season,1)]],[curve=[7,-22]]).
arc(arc00045,node00014,node00009,influence,[complete=true,name=i4],[curve=[-4,-2]]).
arc(arc00040,node00015,node00014,influence,[complete=true,name=i31],[]).
arc(arc00042,node00035,node00002,influence,[],[]).

