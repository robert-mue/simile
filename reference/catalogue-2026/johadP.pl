source(program='Simile v7.4',version= 11.4,edition=free,date='Thu Aug 13 10:38:53 GMT 2026').

roots([node00062,node00087,node00102,node00103,node00109,node00118,node00128,node00130,node00131,node00152,node00161,node00172]).

properties([complete-true,file_name-'C:/Documents and Settings/jvanclay/My Documents/My Documents/_ Realising futures/Johad/Models/microcatch-final3.sml',fill_colour-'#ffffffffffff',name-'Desktop2']).

node(node00062,submodel,[node00025,node00030,node00049,node00054,node00065,node00066,node00067,node00068,node00071,node00114,node00139,node00140,node00141,node00142,node00147,node00150,node00217,node00218,node00219],[complete=true,fill_colour='#80ff80',multiplication_spec=[count=[]],name='Indicators',separate=0],[bounding_box=[ -143.0, 208.0, 11.0, 403.0],caption_offset=[ 0.0, 0.0],internal_extent=[ -5.0, -283.0, 215.0, -4.0]]).
links(node00062,[arc00021-arc00020,arc00152-arc00140,arc00156-arc00155,arc00160-arc00009,arc00160-arc00068]).
node(node00087,variable,[],[complete=true,name='cumulative flow'],[caption_offset=[ 0.0, 0.0],centre=[ 14.0, 416.0]]).
node(node00102,submodel,[node00004,node00005,node00012,node00029,node00031,node00032,node00039,node00041,node00042,node00051,node00052,node00055,node00059,node00061,node00064,node00081,node00083,node00085,node00088,node00093,node00104,node00105,node00106,node00108,node00126,node00133,node00137,node00138,node00144,node00158,node00168,node00209,node00210,node00211,node00212,node00213,node00214,node00215,node00216],[complete=true,fill_colour='#80ffff',multiplication_spec=[type=population],name='Johad',separate=0],[bounding_box=[ 124.0, -72.0, 541.0, 152.0],caption_offset=[ 35.0, -2.0],internal_extent=[ -151.0, 51.0, 406.0, 349.0]]).
links(node00102,[arc00019-arc00021,arc00035-arc00034,arc00053-arc00051,arc00055-arc00163,arc00060-arc00059,arc00063-arc00085,arc00067-arc00024,arc00069-arc00079,arc00072-arc00177,arc00082-arc00187,arc00087-arc00090,arc00100-arc00162,arc00132-arc00131,arc00136-arc00135,arc00137-arc00127]).
node(node00103,submodel,[node00026,node00027,node00028,node00050,node00056,node00057,node00058,node00060,node00063,node00072,node00074,node00076,node00166,node00169],[complete=true,fill_colour='#ff97ff',multiplication_spec=[count=[]],name='People',separate=0],[bounding_box=[ -142.0, -24.0, 6.0, 178.0],caption_offset=[ 3.0, 0.0],internal_extent=[ -1.0, -48.0, 196.0, 221.0]]).
links(node00103,[arc00032-arc00035,arc00052-arc00063,arc00075-arc00184,arc00187-arc00186]).
node(node00109,submodel,[node00035,node00037,node00053,node00073,node00075,node00077,node00082,node00084,node00086,node00089,node00090,node00097,node00098,node00099,node00101,node00220,node00221],[complete=true,fill_colour='#ffff80',multiplication_spec=[count=[]],name='Johad design',separate=0],[bounding_box=[ -135.0, -161.0, 71.0, -53.0],caption_offset=[ -3.0, -1.0],internal_extent=[ -89.0, 155.0, 185.0, 299.0]]).
links(node00109,[arc00023-arc00067,arc00048-arc00053,arc00058-arc00060,arc00079-arc00083,arc00090-arc00089]).
node(node00118,submodel,[node00022,node00023,node00078,node00079,node00096,node00119,node00120,node00121,node00122,node00175,node00179,node00222,node00223],[complete=true,fill_colour='#4aa5ff',multiplication_spec=[count=[]],name='Surface water',separate=0],[bounding_box=[ 383.0, 186.0, 574.0, 281.0],caption_offset=[ 5.0, 0.0],internal_extent=[ -26.0, 11.0, 213.0, 131.0]]).
links(node00118,[arc00139-arc00137,arc00139-arc00164,arc00190-arc00191,arc00195-arc00194]).
node(node00128,function,[],[complete=true,name=fn1_1,spec=[99,117,109,117,108,97,116,105,118,101,95,114,105,118,101,114,95,102,108,111,119,47,49,48,48,48,48,48,48],units=1,value=cumulative_river_flow/1000000],[]).
node(node00130,variable,[],[complete=true,name='area left'],[caption_offset=[ -3.0, -34.0],centre=[ 596.0, -6.0]]).
node(node00131,function,[],[complete=true,name=fn1_0,spec=[105,102,32,116,105,109,101,40,49,41,61,61,48,32,116,104,101,110,32,49,50,48,48,32,101,108,115,101,32,108,97,115,116,40,65,114,101,97,95,110,111,116,95,104,97,114,110,101,115,115,101,100,41],units=1,value=(if time(1)==0 then 1200 else last('Area_not_harnessed'))],[]).
node(node00152,submodel,[node00033,node00034,node00038,node00047,node00080,node00091,node00092,node00094,node00127,node00129,node00153,node00154,node00156,node00159,node00160,node00170],[complete=true,fill_colour='#00ffff',multiplication_spec=[count=[]],name='River',separate=0],[bounding_box=[ 58.0, 318.0, 590.0, 419.0],caption_offset=[ 8.0, -1.0],internal_extent=[ 25.0, 0.0, 690.0, 127.0]]).
links(node00152,[arc00115-arc00123,arc00118-arc00171,arc00162-arc00175,arc00163-arc00172,arc00164-arc00176,arc00169-arc00160,arc00179-arc00165]).
node(node00161,submodel,[node00024,node00045,node00046,node00115,node00116,node00117,node00143,node00148,node00162,node00164,node00167,node00224],[complete=true,fill_colour='#d1a0a0',multiplication_spec=[count=[]],name='Ground water',separate=0],[bounding_box=[ 56.0, 185.0, 296.0, 285.0],caption_offset=[ 5.0, 2.0],internal_extent=[ -58.0, -17.0, 241.0, 108.0]]).
links(node00161,[arc00109-arc00152,arc00133-arc00136,arc00133-arc00156,arc00177-arc00181,arc00178-arc00179,arc00184-arc00183]).
node(node00172,submodel,[node00132,node00171,node00173,node00176,node00177,node00178],[complete=true,enum_types=[],fill_colour='#00ffff',image_posn=none,multiplication_spec=[count=[]],name='Standardize\nweather',separate=0,step= -2],[bounding_box=[ 632.0, 178.0, 734.0, 287.0],caption_offset=[ 0.0, 0.0],internal_extent=[ 11.0, 5.0, 113.0, 114.0]]).
links(node00172,[arc00188-arc00190,arc00193-arc00195]).
node(node00132,variable,[],[complete=true,name=rainrand],[caption_offset=[ 7.0, 7.0],centre=[ 53.0, 22.0]]).
node(node00171,function,[],[complete=true,name=fn1_2,spec=[109,97,107,101,97,114,114,97,121,40,114,97,110,100,95,99,111,110,115,116,40,48,44,49,41,44,49,48,48,48,48,41],units=array(1,10000),value=makearray(rand_const(0,1),10000)],[]).
node(node00173,border,[],[name=var2],[along=576]).
node(node00176,variable,[],[complete=true,name=randday],[caption_offset=[ 9.0, 6.0],centre=[ 61.0, 66.0]]).
node(node00177,function,[],[complete=true,name=fn2,spec=[109,97,107,101,97,114,114,97,121,40,114,97,110,100,95,99,111,110,115,116,40,48,44,49,41,44,49,48,48,48,48,41],units=array(1,10000),value=makearray(rand_const(0,1),10000)],[]).
node(node00178,border,[],[name=var6],[along=456]).
arc(arc00174,node00171,node00132,influence,[attached=[],name=i1_1],[]).
arc(arc00188,node00132,node00173,influence,[attached=[],complete=true,name=i2],[curve=[-6,7]]).
arc(arc00192,node00177,node00176,influence,[attached=[],name=i6],[]).
arc(arc00193,node00176,node00178,influence,[attached=[],complete=true,name=i7],[curve=[2,-16]]).
node(node00024,cloud,[],[complete=true,name=cd1],[centre=[ -40.0, 46.0]]).
node(node00045,compartment,[],[comment='Assume zero groundwater at outset - Rajendra Singh talks about the "dark zone" where no groundwater',complete=true,description='Kl',name='ground\nwater'],[caption_offset=[ 46.0, -31.0],centre=[ 121.0, 45.0]]).
node(node00046,function,[],[complete=true,min_val=0,name=fn21,spec=[48],units=1,value=0],[]).
node(node00115,function,[],[complete=true,name=fn1_0,spec=[55,50,48,48,48,48],units=1,value=720000],[]).
node(node00116,variable,[],[comment='Measure of how "full" of water the ground is - used to adjust percolation and the flow rate of springs into the river.',complete=true,description=ratio,name=proportion],[caption_offset=[ 33.0, -32.0],centre=[ 177.0, 7.0]]).
node(node00117,function,[],[complete=true,name=fn2,spec=[103,114,111,117,110,100,95,119,97,116,101,114,47,99,97,112,97,99,105,116,121],units=1,value=ground_water/capacity],[]).
node(node00143,border,[],[name=var1],[along=466]).
node(node00148,border,[],[name=var3],[along=889]).
node(node00162,border,[],[],[along=184]).
node(node00164,border,[],[],[along=824]).
node(node00167,border,[],[name=var2],[along=521]).
node(node00224,variable,[],[comment='Idea was to represent the volume of ground water stored in the village area.\nAssume that because of topography, the groundwater basin occupies 5% of surface area (60 ha); that the rise and fall in the ground water level can be up to 3 metres; and that the pore space of the substrate is 0.1 (hence effective water depth is 0.1*3 or 0.3); so that the volume of water potentially stored is 60*10,000*0.3 or about 180 000 Kl\n\nSharma (IWMI 2002) suggests that the aquifer capacity could be 9-18 million Kl, but this refers to the River basin (50 300 ha), so this translates to about 0.2-0.4 million for the area in question.',complete=true,description='Kl',name=capacity],[caption_offset=[ 1.0, -4.0],centre=[ 208.0, 73.0]]).
arc(arc00158,node00045,node00024,flow,[attached=[node00135],comment='Assume cannot draw last little bit',complete=true,description='KL',name='water drawn\nfrom wells'],[caption_offset=[10,-64],curve=[550,1000]]).
arc(arc00045,node00046,node00045,influence,[attached=[],name=i40],[curve=[0,0]]).
arc(arc00181,node00164,node00045,flow,[attached=[node00165],name=percolation],[curve=[550,1000]]).
arc(arc00088,node00117,node00116,influence,[attached=[],name=i5],[]).
arc(arc00110,node00224,node00117,influence,[attached=[],complete=true,name=i9_0,role=[use(none,in_hierarchy,capacity,1)]],[curve=[13,7]]).
arc(arc00213,node00045,node00117,influence,[attached=[],complete=true,name=i7,role=[use(none,in_hierarchy,ground_water,1)]],[curve=[-4,-4]]).
arc(arc00109,node00135,node00143,influence,[attached=[],complete=true,name=i1],[curve=[8,22]]).
arc(arc00133,node00116,node00148,influence,[attached=[],complete=true,name=i11_0],[curve=[-5,2]]).
arc(arc00178,node00045,node00162,flow,[attached=[node00036],comment='Chosen to give reasonable behaviour by river - no substance to this figure',complete=true,description='Kl',name=springs],[caption_offset=[-81,0],curve=[550,1000]]).
arc(arc00077,node00115,node00224,influence,[attached=[],name=i4],[]).
node(node00135,function,[],[complete=true,name=fn1,spec=[105,102,32,118,105,108,108,97,103,101,95,119,97,116,101,114,95,117,115,101,60,103,114,111,117,110,100,95,119,97,116,101,114,32,116,104,101,110,32,118,105,108,108,97,103,101,95,119,97,116,101,114,95,117,115,101,32,101,108,115,101,32,48],units=1/day,value=(if village_water_use<ground_water then village_water_use else 0)],[along=500]).
node(node00165,function,[],[complete=false,name=fn8],[along=450]).
node(node00036,function,[],[complete=true,min_val=0,name=fn3,spec=[105,102,32,112,114,111,112,111,114,116,105,111,110,62,48,46,55,32,116,104,101,110,32,48,46,48,48,51,42,103,114,111,117,110,100,95,119,97,116,101,114,42,40,112,114,111,112,111,114,116,105,111,110,45,48,46,52,41,101,108,115,101,32,48],units=1/day,value=(if proportion> 0.7 then  0.003*ground_water*(proportion- 0.4) else 0)],[along=500]).
arc(arc00183,node00167,node00135,influence,[attached=[],complete=true,name=i9,role=[use(none,in_hierarchy,village_water_use,1)]],[curve=[4,-22]]).
arc(arc00185,node00045,node00135,influence,[attached=[],complete=true,name=i11,role=[use(none,in_hierarchy,ground_water,1)]],[curve=[0,14]]).
arc(arc00056,node00045,node00036,influence,[attached=[],complete=true,name=i7_0,role=[use(none,in_hierarchy,ground_water,1)]],[curve=[4,0]]).
arc(arc00117,node00116,node00036,influence,[attached=[],complete=true,name=i10,role=[use(none,in_hierarchy,proportion,1)]],[curve=[16,12]]).
node(node00033,compartment,[],[comment='Assume zero at outset - Rajendra Singh refers to "dead rivers"',complete=true,description='Kl',name=streams],[caption_offset=[ 6.0, -4.0],centre=[ 374.0, 67.0]]).
node(node00034,function,[],[complete=true,min_val=0,name=fn2,spec=[48],units=1,value=0],[]).
node(node00038,compartment,[],[complete=true,name='cumulative\nriver flow'],[caption_offset=[ 0.0, 0.0],centre=[ 109.0, 65.0]]).
node(node00047,variable,[],[comment='Source: ''Rethinking rehabilitation'' article by Shah and Raju says that 550 villages in Alwar cover 6500 sq km, so on average they are 12 sq km or 1200 ha.',complete=true,description=ha,name='Total\ncatchment\narea'],[caption_offset=[ 3.0, 1.0],centre=[ 645.0, 61.0]]).
node(node00080,function,[],[complete=true,name=fn1_0,spec=[49,50,48,48,46,48],units=1,value= 1200.0],[]).
node(node00091,variable,[],[comment='Need to know how water goes direct into streams, and not into tanks',complete=true,description=ha,name='Area not\nharnessed'],[caption_offset=[ -50.0, -41.0],centre=[ 617.0, 33.0]]).
node(node00092,function,[],[complete=true,min_val=0,name=fn2_1,spec=[109,97,120,40,48,44,84,111,116,97,108,95,99,97,116,99,104,109,101,110,116,95,97,114,101,97,45,115,117,109,40,123,99,97,116,99,104,109,101,110,116,95,97,114,101,97,125,41,41],units=1,value=max(0,'Total_catchment_area'-sum({catchment_area}))],[]).
node(node00094,cloud,[],[complete=true,name=cd2],[centre=[ 554.0, 60.0]]).
node(node00127,function,[],[complete=true,name=fn1,spec=[48],units=1,value=0],[]).
node(node00129,border,[],[name=var2],[along=491]).
node(node00153,border,[],[],[along=511]).
node(node00154,border,[],[],[along=561]).
node(node00156,border,[],[],[along=827]).
node(node00159,border,[],[],[along=967]).
node(node00160,border,[],[],[along=882]).
node(node00170,border,[],[name=var11],[along=971]).
arc(arc00040,node00034,node00033,influence,[attached=[],name=i3_1],[curve=[0,0]]).
arc(arc00098,node00094,node00033,flow,[attached=[node00095],comment='the 10 converts mm-ha to Kl',complete=true,description='Kl',name='overland flow'],[caption_offset=[21,0],curve=[550,1000]]).
arc(arc00165,node00154,node00033,flow,[attached=[node00149],name=springs],[curve=[550,1000]]).
arc(arc00172,node00156,node00033,flow,[attached=[node00157],name=overflow],[curve=[550,1000]]).
arc(arc00044,node00033,node00038,flow,[attached=[node00040],comment='When there is overland flow (and when tanks overflow), want most of it to rush into river, and not sit around in streams.\nDon''t want streams to drain empty each day, so keep some (10-50%) till next day.',complete=true,description='Kl',name='river\nflow'],[caption_offset=[-7,-60],curve=[550,1000]]).
arc(arc00114,node00127,node00038,influence,[attached=[],name=i1_1],[]).
arc(arc00039,node00080,node00047,influence,[attached=[],name=i1_0],[]).
arc(arc00096,node00092,node00091,influence,[attached=[],name=i5_0],[]).
arc(arc00097,node00047,node00092,influence,[attached=[],complete=true,name=i6_0,role=[use(none,in_hierarchy,'Total_catchment_area',1)]],[curve=[4,8]]).
arc(arc00175,node00159,node00092,influence,[attached=[],complete=true,name=i8_0,role=[use(none,in_hierarchy,{catchment_area},list(1))]],[curve=[5,8]]).
arc(arc00118,node00038,node00129,influence,[attached=[],complete=true,name=i2],[curve=[3,16]]).
arc(arc00169,node00040,node00153,influence,[attached=[],complete=true,name=i7],[curve=[-21,-45]]).
arc(arc00115,node00091,node00170,influence,[attached=[],complete=true,name=i1_2],[curve=[7,23]]).
node(node00095,function,[],[complete=true,min_val=0,name=fn7,spec=[65,114,101,97,95,110,111,116,95,104,97,114,110,101,115,115,101,100,42,116,121,112,105,99,97,108,95,115,117,114,102,97,99,101,95,102,108,111,119,42,49,48],units=1/day,value='Area_not_harnessed'*typical_surface_flow*10],[along=500]).
node(node00149,function,[],[complete=false,name=fn3_0],[along=450]).
node(node00157,function,[],[complete=false,name=fn6],[along=450]).
node(node00040,function,[],[complete=true,min_val=0,name=fn4,spec=[105,102,32,115,116,114,101,97,109,115,60,49,32,116,104,101,110,32,115,116,114,101,97,109,115,32,101,108,115,101,32,40,115,116,114,101,97,109,115,43,111,118,101,114,108,97,110,100,95,102,108,111,119,41,42,40,105,102,32,115,116,114,101,97,109,115,62,49,48,32,116,104,101,110,32,48,46,53,32,101,108,115,101,32,48,46,57,41],units=1/day,value=(if streams<1 then streams else (streams+overland_flow)*(if streams>10 then  0.5else  0.9))],[along=500]).
arc(arc00176,node00160,node00095,influence,[attached=[],complete=true,name=i24,role=[use(none,in_hierarchy,typical_surface_flow,1)]],[curve=[14,-9]]).
arc(arc00212,node00091,node00095,influence,[attached=[],complete=true,name=i9_0,role=[use(none,in_hierarchy,'Area_not_harnessed',1)]],[curve=[-47,-4]]).
arc(arc00057,node00033,node00040,influence,[attached=[],complete=true,name=i8_1,role=[use(none,in_hierarchy,streams,1)]],[curve=[0,27]]).
arc(arc00214,node00095,node00040,influence,[attached=[],complete=true,name=i1,role=[use(none,in_hierarchy,overland_flow,1)]],[curve=[6,76]]).
node(node00022,variable,[],[comment='We''ve got two lists, one with day number of rainfall, one with amount on that day.\nTest to see if today is a rainday, if so, get the corresponding rainfall amount.\nSounds easy, but is tricky in Simile. Easiest way to to make an array with 30 copies of today''s number, and the sum the rainfall for any of those 30 instances where today matches one of our rain days.\nNote that there is a chance that the list of raindays may contain duplicates - we sum the rain on these days, so that extra big falls can happen sometimes.',complete=true,description=mm,name='today''s\nrainfall'],[caption_offset=[ 48.0, -24.0],centre=[ 65.0, 73.0]]).
node(node00023,function,[],[complete=true,name=fn11,spec=[115,117,109,40,109,97,107,101,97,114,114,97,121,40,105,102,32,102,109,111,100,40,116,105,109,101,40,49,41,44,51,54,48,41,43,49,61,61,101,108,101,109,101,110,116,40,91,114,97,105,110,95,100,97,121,115,93,44,112,108,97,99,101,95,105,110,40,49,41,41,116,104,101,110,32,101,108,101,109,101,110,116,40,91,114,97,105,110,95,97,109,111,117,110,116,93,44,112,108,97,99,101,95,105,110,40,49,41,41,101,108,115,101,32,48,44,51,48,41,41],units=1,value=sum(makearray(if fmod(time(1),360)+1==element([rain_days],place_in(1)) then element([rain_amount],place_in(1)) else 0,30))],[]).
node(node00078,variable,[],[comment='Usually 18-30 days of rain a year (International Water Management Institute)\nwith 1 rainday in first and last quarter, two raindays in second quarter, and most in third quarter (India Travel Guide).\nSo on first day of each year, generate 30 day numbers on which may expect rain to fall,\nwith 1 in Q1, 2 in Q2, 26 in Q3 and 1 in Q4',complete=true,description='Days of year on which rain falls',name='rain\nday'],[caption_offset=[ 33.0, -24.0],centre=[ 138.0, 104.0]]).
node(node00079,function,[],[complete=true,max_val=360,min_val=1,name=fn1,spec=[105,102,32,102,109,111,100,40,116,105,109,101,40,49,41,44,51,54,48,41,62,48,32,116,104,101,110,32,112,114,101,118,40,49,41,101,108,115,101,32,109,97,107,101,97,114,114,97,121,40,102,108,111,111,114,40,57,48,42,101,108,101,109,101,110,116,40,91,114,97,110,100,100,97,121,93,44,102,109,111,100,40,116,105,109,101,40,49,41,44,49,48,48,48,48,41,43,112,108,97,99,101,95,105,110,40,49,41,41,41,44,51,48,41,43,91,48,44,49,44,49,44,50,44,50,44,50,44,50,44,50,44,50,44,50,44,50,44,50,44,50,44,50,44,50,44,50,44,50,44,50,44,50,44,50,44,50,44,50,44,50,44,50,44,50,44,50,44,50,44,50,44,50,44,51,93,42,57,48,43,49],units=array(1,30),value=(if fmod(time(1),360)>0 then prev(1) else makearray(floor(90*element([randday],fmod(time(1),10000)+place_in(1))),30)+[0,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3]*90+1)],[]).
node(node00096,border,[],[name=var2],[along=524]).
node(node00119,variable,[],[comment='Assume that first bit of any rainfall soaks into ground, and that any subsequent rainfall runs off - Wild guess!\nThis infiltration does not reach ground water, but is re-evaporated or used by plants.',complete=true,description=mm,name='typical\ninfiltration'],[caption_offset=[ 51.0, -28.0],centre=[ 6.0, 31.0]]).
node(node00120,function,[],[complete=true,name=fn7,spec=[49,48],units=1,value=10],[]).
node(node00121,variable,[],[comment='Assume that first bit of rainfall (typical infiltration) soaks straight in. After that, assume that most runs off - estimate 80%, based on observation ( Sharma, IWMI, p.5) that before the johad, the seasonal runoff was 35%. This combination of 20mm for inflitration and 0.8 for surface flow gives 35% runoff over a 10-year simulation',complete=true,description='surface flow in mm estimated from rainfall',name='typical\nsurface flow'],[caption_offset=[ 39.0, -3.0],centre=[ -1.0, 80.0]]).
node(node00122,function,[],[complete=true,name=fn8,spec=[40,105,102,32,108,97,115,116,40,116,111,100,97,121,95,115,95,114,97,105,110,102,97,108,108,41,62,116,121,112,105,99,97,108,95,105,110,102,105,108,116,114,97,116,105,111,110,32,116,104,101,110,32,116,111,100,97,121,95,115,95,114,97,105,110,102,97,108,108,32,101,108,115,101,32,109,97,120,40,48,44,116,111,100,97,121,95,115,95,114,97,105,110,102,97,108,108,45,116,121,112,105,99,97,108,95,105,110,102,105,108,116,114,97,116,105,111,110,41,41,42,48,46,53],units=1,value=(if last(today_s_rainfall)>typical_infiltration then today_s_rainfall else max(0,today_s_rainfall-typical_infiltration))* 0.5],[]).
node(node00175,border,[],[name=var4_0],[along=984]).
node(node00179,border,[],[name=var7],[along=38]).
node(node00222,variable,[],[comment='Expect 570 mm rainfall in 18-30 raindays (IWMI), with few falls >50 mm (guess). So generate rainfall amount as cube of rand(1.4,3.95) - gives a day''s rainfall in range 3-60, with half the falls <18 mm and a quarter of the falls >35 mm. Have 30 values, but expect rain on 18-30 of these days, so randomly set some to zero. Assume 24 days of rain, so use rand(0,30)<24 to make 24 rain days on average,with some variation. On this basis, a 10-year simulation gave 560 mm.\n\nSource: Rajasthan Dept Irrigation says Ruparil catchment gets 576 mm, 92%  in June-Sept.',complete=true,description='Rainfall in mm on raindays',name='rain\namount'],[caption_offset=[ 45.0, -25.0],centre=[ 118.0, 31.0]]).
node(node00223,function,[],[complete=true,name=fn4,spec=[105,102,32,102,109,111,100,40,116,105,109,101,40,49,41,44,51,54,48,41,62,48,32,116,104,101,110,32,112,114,101,118,40,49,41,10,101,108,115,101,32,109,97,107,101,97,114,114,97,121,40,40,49,46,52,43,40,51,46,57,53,45,49,46,52,41,42,101,108,101,109,101,110,116,40,91,114,97,105,110,114,97,110,100,93,44,102,109,111,100,40,116,105,109,101,40,49,41,44,49,48,48,48,48,41,43,112,108,97,99,101,95,105,110,40,49,41,41,41,94,51,42,10,40,105,102,32,51,48,42,101,108,101,109,101,110,116,40,91,114,97,105,110,114,97,110,100,93,44,102,109,111,100,40,116,105,109,101,40,49,41,44,49,48,48,48,48,41,43,112,108,97,99,101,95,105,110,40,49,41,41,60,50,52,32,116,104,101,110,32,49,32,101,108,115,101,32,48,41,44,51,48,41],units=array(1,30),value=(if fmod(time(1),360)>0 then prev(1) else makearray(( 1.4+( 3.95- 1.4)*element([rainrand],fmod(time(1),10000)+place_in(1)))^3*(if 30*element([rainrand],fmod(time(1),10000)+place_in(1))<24 then 1 else 0),30))],[]).
arc(arc00026,node00023,node00022,influence,[attached=[],name=i21],[]).
arc(arc00027,node00222,node00023,influence,[attached=[],complete=true,name=i22,role=[use(none,in_hierarchy,[rain_amount],array(1,30))]],[curve=[8,10]]).
arc(arc00138,node00078,node00023,influence,[attached=[],complete=true,name=i2,role=[use(none,in_hierarchy,[rain_days],array(1,30))]],[curve=[-6,14]]).
arc(arc00036,node00079,node00078,influence,[attached=[],name=i1],[]).
arc(arc00194,node00179,node00079,influence,[attached=[],complete=true,name=i8,role=[use(none,in_hierarchy,usr([randday]),array(1,10000))]],[curve=[-6,11]]).
arc(arc00139,node00121,node00096,influence,[attached=[],complete=true,name=i25],[curve=[-6,6]]).
arc(arc00121,node00120,node00119,influence,[attached=[],name=i16],[]).
arc(arc00122,node00122,node00121,influence,[attached=[],name=i17_0],[]).
arc(arc00094,node00022,node00122,influence,[attached=[],complete=true,name=i18,role=[use(none,in_hierarchy,today_s_rainfall,1)]],[curve=[2,17]]).
arc(arc00125,node00119,node00122,influence,[attached=[],complete=true,name=i20,role=[use(none,in_hierarchy,typical_infiltration,1)]],[curve=[6,4]]).
arc(arc00211,node00223,node00222,influence,[attached=[],name=i4_1],[]).
arc(arc00191,node00175,node00223,influence,[attached=[],complete=true,name=i5,role=[use(none,in_hierarchy,[rainrand],array(1,10000))]],[curve=[-24,15]]).
node(node00035,variable,[],[comment='Assumes tank is approx like inverted pyramid.\nSource: New Scientist article says 100 sq m',complete=true,description='Surface area of tank in sq metres when full',max_val=1000,min_val=0,name=area,spec=[49,53,48],units=1,value=150],[caption_offset=[ -24.0, -26.0],centre=[ -39.0, 178.0]]).
node(node00037,variable,[],[comment='Assumes that tank is  approx like an inverted pyramid.\nSource: New Scientist article says 5 m.',complete=true,description='Depth of tank in metres at deepest point',max_val=25,min_val=0,name=depth,spec=[53],units=int,value=5],[caption_offset=[ -26.0, -30.0],centre=[ -35.0, 228.0]]).
node(node00053,border,[],[name=var1],[along=114]).
node(node00073,variable,[],[comment='Rand_const() because johads do not change in area.\nAs people gain confidence, they build bigger tanks, so make each tank bigger than the previous biggest',complete=true,name='next area'],[caption_offset=[ 10.0, -45.0],centre=[ 35.0, 193.0]]).
node(node00075,function,[],[complete=true,name=fn1,units=1,value=(if time(1)==0 then tank_area else max(last(biggest_yet),tank_area))*rand_var( 0.9, 1.2)],[]).
node(node00077,variable,[],[complete=true,name='next depth'],[caption_offset=[ -14.0, 0.0],centre=[ 32.0, 230.0]]).
node(node00082,function,[],[complete=true,name=fn2,units=1,value=(if time(1)==0 then depth else max(last(deepest_yet),depth))*rand_var( 0.9, 1.2)],[]).
node(node00084,border,[],[name=var3],[along=998]).
node(node00086,border,[],[name=var5],[along=83]).
node(node00089,variable,[],[complete=true,name=effort],[caption_offset=[ -35.0, -18.0],centre=[ 97.0, 284.0]]).
node(node00090,function,[],[complete=true,name=fn3,spec=[110,101,120,116,95,100,101,112,116,104,94,50,42,110,101,120,116,95,97,114,101,97,47,49,48],units=1,value=next_depth^2*next_area/10],[]).
node(node00097,variable,[],[complete=true,name='biggest yet'],[caption_offset=[ -10.0, -4.0],centre=[ 147.0, 169.0]]).
node(node00098,function,[],[complete=true,name=fn1_0,spec=[105,102,32,99,111,117,110,116,40,123,115,117,114,102,97,99,101,95,97,114,101,97,95,119,104,101,110,95,102,117,108,108,125,41,61,61,48,32,116,104,101,110,32,48,32,101,108,115,101,32,103,114,101,97,116,101,115,116,40,123,115,117,114,102,97,99,101,95,97,114,101,97,95,119,104,101,110,95,102,117,108,108,125,41],units=1,value=(if count({surface_area_when_full})==0 then 0 else greatest({surface_area_when_full}))],[]).
node(node00099,border,[],[name=var6],[along=934]).
node(node00101,variable,[],[complete=true,name='deepest yet'],[caption_offset=[ -3.0, -35.0],centre=[ 138.0, 236.0]]).
node(node00220,function,[],[complete=true,name=fn2_0,spec=[105,102,32,99,111,117,110,116,40,123,100,101,112,116,104,95,119,104,101,110,95,102,117,108,108,125,41,61,61,48,32,116,104,101,110,32,48,32,101,108,115,101,32,103,114,101,97,116,101,115,116,40,123,100,101,112,116,104,95,119,104,101,110,95,102,117,108,108,125,41],units=1,value=(if count({depth_when_full})==0 then 0 else greatest({depth_when_full}))],[]).
node(node00221,border,[],[name=var9],[along=42]).
arc(arc00023,node00089,node00053,influence,[attached=[],complete=true,name=i1],[curve=[-4,-9]]).
arc(arc00029,node00075,node00073,influence,[attached=[],name=i3],[]).
arc(arc00038,node00035,node00075,influence,[attached=[],complete=true,name=i5,role=[use(none,in_hierarchy,usr(tank_area),1)]],[curve=[-20,28]]).
arc(arc00084,node00097,node00075,influence,[attached=[],complete=true,name=i9,role=[use(none,in_hierarchy,usr(biggest_yet),1)]],[curve=[1,-11]]).
arc(arc00030,node00082,node00077,influence,[attached=[],name=i4],[]).
arc(arc00042,node00037,node00082,influence,[attached=[],complete=true,name=i6,role=[use(none,in_hierarchy,depth,1)]],[curve=[-3,-26]]).
arc(arc00091,node00101,node00082,influence,[attached=[],complete=true,name=i14_0,role=[use(none,in_hierarchy,deepest_yet,1)]],[curve=[10,-2]]).
arc(arc00048,node00073,node00084,influence,[attached=[],complete=true,name=i7],[curve=[26,-14]]).
arc(arc00058,node00077,node00086,influence,[attached=[],complete=true,name=i10],[curve=[36,-20]]).
arc(arc00061,node00090,node00089,influence,[attached=[],name=i13],[]).
arc(arc00062,node00073,node00090,influence,[attached=[],complete=true,name=i14,role=[use(none,in_hierarchy,next_area,1)]],[curve=[38,-14]]).
arc(arc00065,node00077,node00090,influence,[attached=[],complete=true,name=i15,role=[use(none,in_hierarchy,next_depth,1)]],[curve=[41,-8]]).
arc(arc00080,node00098,node00097,influence,[attached=[],name=i7_0],[]).
arc(arc00083,node00099,node00098,influence,[attached=[],complete=true,name=i8,role=[use(none,in_hierarchy,{surface_area_when_full},list(1))]],[curve=[5,-4]]).
arc(arc00086,node00220,node00101,influence,[attached=[],name=i10_0],[]).
arc(arc00089,node00221,node00220,influence,[attached=[],complete=true,name=i12,role=[use(none,in_hierarchy,{depth_when_full},list(1))]],[curve=[-4,12]]).
node(node00026,variable,[],[complete=true,description='person-days',name='labour input'],[caption_offset=[ -52.0, -10.0],centre=[ 166.0, 86.0]]).
node(node00027,function,[],[complete=true,name=fn13,spec=[86,105,108,108,97,103,101,95,112,111,112,117,108,97,116,105,111,110,42,108,97,98,111,117,114,95,99,111,110,116,114,105,98,117,116,101,100,95,112,101,114,95,99,97,112,105,116,97],units=1,value='Village_population'*labour_contributed_per_capita],[]).
node(node00028,variable,[],[comment='Source: Sharmma (IWMI, p.6) mentions two villages in the area which have 566 people between then, so 300/village is in the ball-park.',complete=true,max_val=1000,min_val=0,name='Village\npopulation',spec=[51,48,48],units=int,value=300],[caption_offset=[ -34.0, -7.0],centre=[ 78.0, 123.0]]).
node(node00050,border,[],[],[along=980]).
node(node00056,variable,[],[comment='On average, as a proportion. If no motivation or high opposition (10), then no contribution. If high motivation and no opposition, assume 10% (could be 1 in 10 people working full-time, or everyone working 10% of the time).\n\nSource: The article ''Kiss of life for mother earth'' in The Week 27 Dec 1998 said that TBS would not start work until everyone in the village was willing to contribute labour or money, so presumably opposition works like a veto. Here, only have veto if opposition>=5.\nAnother article said there was, on average, 5 dams in each village, but that a few villages had 11 dams.',complete=true,description='Contribution of labour (per capita) towards tank construction',name='labour contributed\nper capita'],[caption_offset=[ 81.0, -27.0],centre=[ 19.0, 49.0]]).
node(node00057,variable,[],[comment='10 = highly motivated; 0 = no motivation.',complete=true,description='An index of motivation in range 0 to 10',max_val=10,min_val=0,name=motivation,spec=[53],units=1,value=5],[caption_offset=[ 41.0, -29.0],centre=[ 26.0, -21.0]]).
node(node00058,function,[],[complete=true,name=fn1,spec=[105,102,32,111,112,112,111,115,105,116,105,111,110,62,61,53,32,111,114,32,99,111,117,110,116,40,123,115,116,111,114,101,100,95,119,97,116,101,114,125,41,62,61,49,48,32,116,104,101,110,32,48,32,101,108,115,101,32,109,111,116,105,118,97,116,105,111,110,42,40,49,48,45,111,112,112,111,115,105,116,105,111,110,41,47,49,48,48,48],units=1,value=(if opposition>=5 or count({stored_water})>=10 then 0 else motivation*(10-opposition)/1000)],[]).
node(node00060,variable,[],[comment='10 = lots of opposition; 0 = initiatives unopposed\n\nThe article ''Kiss of life for mother earth'' in The Week 27 Dec 1998 said that TBS would not start work until everyone in the village was willing to contribute labout or money, so presumably opposition works like a veto.',complete=true,description='Index (0-10) of opposition to tanks',max_val=10,min_val=0,name=opposition,spec=[51],units=1,value=3],[caption_offset=[ 36.0, -3.0],centre=[ 110.0, -2.0]]).
node(node00063,border,[],[name=var2],[along=879]).
node(node00072,variable,[],[complete=true,description='Kl',name='village\nwater use'],[caption_offset=[ -16.0, 2.0],centre=[ 172.0, 152.0]]).
node(node00074,function,[],[complete=true,name=fn1_0,spec=[119,97,116,101,114,95,117,115,101,95,112,101,114,95,99,97,112,105,116,97,42,86,105,108,108,97,103,101,95,112,111,112,117,108,97,116,105,111,110],units=1,value=water_use_per_capita*'Village_population'],[]).
node(node00076,variable,[],[comment='Water use per person per day in litres\n\nMajor purpose of Johads is to provide water to livestock - Sharma, IWMI, 2002, p.7\nLivestock typically consume 1.04-1.46 ha-metres of water per year (p.10) - this is about 35 Kl per day (or 0.1 Kl/person/day)\nTotal water consumption, including crop irrigation was 8-13 ha-m, or 300 Kl/day (1 Kl/person/day)',complete=true,description='Kl (1000 litres)',max_val=50,min_val=0,name='water use\nper capita',spec=[48,46,53],units=1,value= 0.5],[caption_offset=[ -4.0, 0.0],centre=[ 62.0, 175.0]]).
node(node00166,border,[],[name=var1_0],[along=136]).
node(node00169,border,[],[name=var4],[along=949]).
arc(arc00031,node00027,node00026,influence,[attached=[],name=i26],[]).
arc(arc00025,node00056,node00027,influence,[attached=[],complete=true,name=i6,role=[use(none,in_hierarchy,labour_contributed_per_capita,1)]],[curve=[-24,10]]).
arc(arc00050,node00028,node00027,influence,[attached=[],complete=true,name=i5_0,role=[use(none,in_hierarchy,'Village_population',int)]],[curve=[20,9]]).
arc(arc00052,node00026,node00050,influence,[attached=[],complete=true,name=i38],[curve=[0,-5]]).
arc(arc00208,node00058,node00056,influence,[attached=[],name=i1],[]).
arc(arc00017,node00057,node00058,influence,[attached=[],complete=true,name=i2,role=[use(none,in_hierarchy,motivation,1)]],[curve=[0,6]]).
arc(arc00018,node00060,node00058,influence,[attached=[],complete=true,name=i3,role=[use(none,in_hierarchy,opposition,1)]],[curve=[-16,-8]]).
arc(arc00186,node00169,node00058,influence,[attached=[],complete=true,name=i12,role=[use(none,in_hierarchy,{stored_water},list(1))]],[curve=[7,42]]).
arc(arc00032,node00060,node00063,influence,[attached=[],complete=true,name=i8],[curve=[2,-19]]).
arc(arc00071,node00074,node00072,influence,[attached=[],name=i1_0],[]).
arc(arc00073,node00076,node00074,influence,[attached=[],complete=true,name=i2_1,role=[use(none,in_hierarchy,water_use_per_capita,1)]],[curve=[-10,-1]]).
arc(arc00074,node00028,node00074,influence,[attached=[],complete=true,name=i3_0,role=[use(none,in_hierarchy,'Village_population',int)]],[curve=[8,-6]]).
arc(arc00075,node00072,node00166,influence,[attached=[],complete=true,name=i4],[curve=[4,4]]).
node(node00004,compartment,[],[comment='Tanks are empty when first built.\nSet the minimum to ensure stored water does not go negative. This is possible occasionally, if consumption+percolation+evaporation is greater than the water remaining in the tank. However, checking all of this involves lots of arrows, so for simplicity, omit these, as consequences minor and short-lived.',complete=true,description='KiloLitres or cubic metres of water',name='water\nin tank'],[caption_offset=[ 27.0, -68.0],centre=[ 140.0, 265.0]]).
node(node00005,function,[],[complete=true,min_val=0,name=fn2,spec=[48],units=1,value=0],[]).
node(node00012,cloud,[],[complete=true,name=cd3],[centre=[ 140.0, 118.0]]).
node(node00029,border,[],[],[along=223]).
node(node00031,immigration,[],[comment='Proportion of next tank completed, assuming that only input is labour (materials not limiting), and that 1000 person-days are needed to complete a tank. When this reaches or exceeds 1.0, a new tank is created, and any excess (>1) is put towards next tank.\n\nThe 1000 person days is a guess based on article ''Kiss of life for mother earth'' in The Week 27 Dec 1998 which said that 2 women dug a small percolation pond in four months (say 250 person-days).',complete=true,description='Work done on next tank',name='new tanks\nconstructed'],[caption_offset=[ 0.0, 0.0],centre=[ -100.0, 274.0]]).
node(node00032,function,[],[complete=true,name=fn15,spec=[105,102,32,101,102,102,111,114,116,60,61,48,32,116,104,101,110,32,48,32,101,108,115,101,32,108,97,98,111,117,114,95,105,110,112,117,116,47,101,102,102,111,114,116],units=1,value=(if effort<=0 then 0 else labour_input/effort)],[]).
node(node00039,function,[],[complete=true,name=fn19,spec=[105,102,32,116,105,109,101,40,49,41,61,61,105,110,105,116,95,116,105,109,101,40,49,41,32,116,104,101,110,32,110,101,120,116,95,97,114,101,97,32,101,108,115,101,32,112,114,101,118,40,49,41],units=1,value=(if time(1)==init_time(1) then next_area else prev(1))],[]).
node(node00041,border,[],[complete=true],[along=388]).
node(node00042,function,[],[complete=true,name=fn20,spec=[105,102,32,116,105,109,101,40,49,41,61,61,105,110,105,116,95,116,105,109,101,40,49,41,32,116,104,101,110,32,110,101,120,116,95,100,101,112,116,104,32,101,108,115,101,32,112,114,101,118,40,49,41],units=1,value=(if time(1)==init_time(1) then next_depth else prev(1))],[]).
node(node00051,border,[],[name=var4],[along=339]).
node(node00052,border,[],[],[along=470]).
node(node00055,border,[],[name=var2],[along=480]).
node(node00059,loss,[],[comment='Assume that with average opposition (=5), there is a 20% chance of a tank being destroyed in any given year.\nWith strong opposition (=10), there is a 40% chance of destruction. This is invoked daily, so divide by 360.\nNote that tanks may fail through natural collapse - this not modelled separately, so if opposition=0 it will not be modelled.\nThese probabilities are just guesses!',complete=true,description='Chance of tank being destroyed',name='tanks\ndestroyed'],[caption_offset=[ -6.0, -2.0],centre=[ -94.0, 176.0]]).
node(node00061,function,[],[complete=true,name=fn2_0,spec=[105,102,32,114,97,110,100,95,118,97,114,40,48,44,49,41,60,111,112,112,111,115,105,116,105,111,110,47,50,53,47,51,54,48,32,116,104,101,110,32,49,32,101,108,115,101,32,48],units=1,value=(if rand_var(0,1)<opposition/25/360 then 1 else 0)],[]).
node(node00064,border,[],[name=var3],[along=505]).
node(node00081,variable,[],[comment='Wetted area of soil under tank, assuming there are 4 triangular sides each with length sqrt(depth^2+area/4) and base sqrt(area).',complete=true,description='sq metres',name='wetted\narea'],[caption_offset=[ -42.0, -28.0],centre=[ 90.0, 227.0]]).
node(node00083,function,[],[complete=true,name=fn2_1,spec=[52,42,115,113,114,116,40,97,114,101,97,42,100,101,112,116,104,94,50,43,97,114,101,97,94,50,47,52,41,47,50],units=1,value=4*sqrt(area*depth^2+area^2/4)/2],[]).
node(node00085,border,[],[name=var4_0],[along=584]).
node(node00088,border,[],[name=var6_0],[along=551]).
node(node00093,border,[],[name=var3_0],[along=628]).
node(node00104,variable,[],[comment='Assume tanks vary between 80 and 120 ha\nSource: New Scientist article says first tank had catchment of 100 ha',complete=true,description=hectares,name='catchment\narea'],[caption_offset=[ -26.0, -47.0],centre=[ 364.0, 268.0]]).
node(node00105,function,[],[complete=true,name=fn1,spec=[109,105,110,40,114,97,110,100,95,99,111,110,115,116,40,56,48,44,49,50,48,41,44,97,114,101,97,95,108,101,102,116,41],units=1,value=min(rand_const(80,120),area_left)],[]).
node(node00106,cloud,[],[complete=true,name=cd1_0],[centre=[ 266.0, 256.0]]).
node(node00108,variable,[],[comment='in metres',complete=true,description=depth,name='water\ndepth'],[caption_offset=[ 30.0, -37.0],centre=[ 18.0, 134.0]]).
node(node00126,border,[],[name=var13],[along=175]).
node(node00133,border,[],[name=var5],[along=3]).
node(node00137,variable,[],[comment='Assumes the tank approximates an upturned pyramid - this is probably reasonable even if the tank is like an inverted cone with a few irregulatities.',complete=true,description='cubic metres or Kl',name=capacity],[caption_offset=[ 42.0, -18.0],centre=[ -46.0, 204.0]]).
node(node00138,function,[],[complete=true,name=fn13,spec=[115,117,114,102,97,99,101,95,97,114,101,97,95,119,104,101,110,95,102,117,108,108,42,100,101,112,116,104,47,51],units=1,value=surface_area_when_full*depth/3],[]).
node(node00144,border,[],[name=var6],[along=322]).
node(node00158,border,[],[name=var10],[along=73]).
node(node00168,border,[],[name=var3_1],[along=489]).
node(node00209,function,[],[complete=true,name=fn1_0,spec='if capacity<=0 or stored_water<=0 then 0 else depth*(stored_water/capacity)^(1/3)',units=1,value=(if capacity<=0 or stored_water<=0 then 0 else depth*(stored_water/capacity)^(1/3))],[]).
node(node00210,variable,[],[comment='Surface flow for this tank, recognising that johad slows runoff, so average runoff across two days.',complete=true,description='Surface flow for this microcatchment',name='surface\nflow'],[caption_offset=[ 32.0, -27.0],centre=[ 270.0, 314.0]]).
node(node00211,function,[],[complete=true,name=fn1_1,spec=[40,105,102,32,116,105,109,101,40,49,41,61,61,105,110,105,116,95,116,105,109,101,40,49,41,32,116,104,101,110,32,48,46,53,42,116,121,112,105,99,97,108,95,115,117,114,102,97,99,101,95,102,108,111,119,32,101,108,115,101,32,48,46,53,42,40,116,121,112,105,99,97,108,95,115,117,114,102,97,99,101,95,102,108,111,119,43,108,97,115,116,40,116,121,112,105,99,97,108,95,115,117,114,102,97,99,101,95,102,108,111,119,41,41,41],units=1,value=(if time(1)==init_time(1) then  0.5*typical_surface_flow else  0.5*(typical_surface_flow+last(typical_surface_flow)))],[]).
node(node00212,variable,[],[comment='Surface area of tank - allow some variation around design',complete=true,description='square metres',max_val=200,min_val=0,name='surface area\nwhen full',spec=[49,48,48],units=int,value=100],[caption_offset=[ -55.0, -17.0],centre=[ -22.0, 78.0]]).
node(node00213,variable,[],[comment='introduce some variation around design',complete=true,description='depth in metres',max_val=10,min_val=0,name='depth\nwhen full',spec=[53],units=int,value=5],[caption_offset=[ -30.0, -9.0],centre=[ -65.0, 125.0]]).
node(node00214,variable,[],[comment='Assume surface area changes in prportion with depth, as it would for a inverted pyramid or cone. So when half full, half the surface area.',complete=true,description='sq metres',name='current\nsurface area'],[caption_offset=[ 53.0, -32.0],centre=[ 54.0, 81.0]]).
node(node00215,border,[],[name=var8],[along=568]).
node(node00216,function,[],[complete=true,name=fn5_0,spec=[105,102,32,100,101,112,116,104,60,61,48,32,116,104,101,110,32,48,32,101,108,115,101,32,115,117,114,102,97,99,101,95,97,114,101,97,95,119,104,101,110,95,102,117,108,108,42,119,97,116,101,114,95,100,101,112,116,104,47,100,101,112,116,104],units=1,value=(if depth<=0 then 0 else surface_area_when_full*water_depth/depth)],[]).
arc(arc00101,node00005,node00004,influence,[attached=[],complete=true,name=i2],[curve=[0,0]]).
arc(arc00102,node00106,node00004,flow,[attached=[node00107],comment='Area times depth, multiplied by 10 to convert mm-ha to Kl; \nCatchwater 3(4) of August 2001 reports that a johad fills to the brim in a normal monsoon',complete=true,description='KiloLitres or cubic metres of water',name=inflow],[caption_offset=[-24,4],curve=[550,1000]]).
arc(arc00105,node00004,node00012,flow,[attached=[node00013],comment='Evaporation assumed to be sinous, with 5 mm/day in January and 15 mm/day in June.\nDivide by 1000 to express in metres. Multiply by surface area in sq m to get Kl evaporated.',complete=true,description='Kl',name=evaporation],[caption_offset=[-10,-16],curve=[550,1000]]).
arc(arc00055,node00004,node00029,flow,[attached=[node00043],comment='When the dam is full, it overflows. Need to compare stored-water plus inflows with capacity, otherwise big inflows will remain in dam for a day before overflowing - but allow some delay in overflow, hence 0.9 - but dont allow more than 20% overcapacity',complete=true,description='Kl',name=overflow],[caption_offset=[-11,-2],curve=[550,1000]]).
arc(arc00033,node00032,node00031,influence,[attached=[],name=i28],[curve=[0,0]]).
arc(arc00024,node00055,node00032,influence,[attached=[],complete=true,name=i2_0,role=[use(none,in_hierarchy,effort,1)]],[curve=[8,-12]]).
arc(arc00085,node00052,node00032,influence,[attached=[],complete=true,name=i38,role=[use(none,in_hierarchy,labour_input,1)]],[curve=[5,-3]]).
arc(arc00051,node00085,node00039,influence,[attached=[],complete=true,name=i8,role=[use(none,in_hierarchy,usr(next_area),1)]],[curve=[2,-10]]).
arc(arc00072,node00004,node00041,flow,[attached=[node00048],comment='Assume 25 mm/day across the whole wetted surface of tank - ten times that when water rising and dry soil needs to be wetted.\nAssume tank looks like inverted pyramid, Each side will have a surface of sqrt(2)*ratio*depth^2\n\nFor simplicity, assume that infiltration does not percolate to ground water - this is just percolation from tank.\n\nCalibrated using Rajendra Singh''s observation that water remained in tank for 3 months after end of monsoon.',complete=true,description='Kl',name=percolation],[caption_offset=[-50,-41],curve=[550,1000]]).
arc(arc00059,node00088,node00042,influence,[attached=[],complete=true,name=i11,role=[use(none,in_hierarchy,usr(next_depth),1)]],[curve=[-18,0]]).
arc(arc00019,node00108,node00051,influence,[attached=[],complete=true,name=i4_0],[curve=[46,-3]]).
arc(arc00028,node00061,node00059,influence,[attached=[],name=i7],[curve=[0,0]]).
arc(arc00034,node00064,node00061,influence,[attached=[],complete=true,name=i9_0,role=[use(none,in_hierarchy,opposition,1)]],[curve=[-2,-9]]).
arc(arc00076,node00083,node00081,influence,[attached=[],name=i5_0],[]).
arc(arc00129,node00214,node00083,influence,[attached=[],complete=true,name=i22_0,role=[use(none,in_hierarchy,area,1)]],[curve=[17,-5]]).
arc(arc00130,node00108,node00083,influence,[attached=[],complete=true,name=i23,role=[use(none,in_hierarchy,depth,1)]],[curve=[-4,2]]).
arc(arc00069,node00212,node00093,influence,[attached=[],complete=true,name=i4_1],[curve=[2,8]]).
arc(arc00001,node00105,node00104,influence,[attached=[],name=i1],[]).
arc(arc00131,node00133,node00105,influence,[attached=[],complete=true,name=i6_1,role=[use(none,in_hierarchy,usr(area_left),1)]],[curve=[11,21]]).
arc(arc00104,node00209,node00108,influence,[attached=[],name=i1_0],[]).
arc(arc00144,node00138,node00137,influence,[attached=[],name=i38_0],[]).
arc(arc00128,node00212,node00138,influence,[attached=[],complete=true,name=i21,role=[use(none,in_hierarchy,surface_area_when_full,1)]],[curve=[18,-8]]).
arc(arc00146,node00213,node00138,influence,[attached=[],complete=true,name=i40,role=[use(none,in_hierarchy,depth,1)]],[curve=[14,-13]]).
arc(arc00100,node00104,node00158,influence,[attached=[],complete=true,name=i7_0],[curve=[13,-8]]).
arc(arc00082,node00004,node00168,influence,[attached=[],complete=true,name=i17],[curve=[54,26]]).
arc(arc00141,node00213,node00209,influence,[attached=[],complete=true,name=i15,role=[use(none,in_hierarchy,depth,1)]],[curve=[4,-15]]).
arc(arc00148,node00004,node00209,influence,[attached=[],complete=true,name=i17_1,role=[use(none,in_hierarchy,stored_water,1)]],[curve=[22,-23]]).
arc(arc00149,node00137,node00209,influence,[attached=[],complete=true,name=i18,role=[use(none,in_hierarchy,capacity,1)]],[curve=[-5,-3]]).
arc(arc00106,node00211,node00210,influence,[attached=[],name=i1_1],[]).
arc(arc00127,node00126,node00211,influence,[attached=[],complete=true,name=i22,role=[use(none,in_hierarchy,typical_surface_flow,1)]],[curve=[-6,-18]]).
arc(arc00037,node00039,node00212,influence,[attached=[],name=i32],[]).
arc(arc00041,node00042,node00213,influence,[attached=[],name=i36],[]).
arc(arc00107,node00216,node00214,influence,[attached=[],name=i14],[]).
arc(arc00087,node00213,node00215,influence,[attached=[],complete=true,name=i11_0],[curve=[-32,6]]).
arc(arc00108,node00212,node00216,influence,[attached=[],complete=true,name=i15_0,role=[use(none,in_hierarchy,surface_area_when_full,1)]],[curve=[3,-16]]).
arc(arc00119,node00213,node00216,influence,[attached=[],complete=true,name=i19,role=[use(none,in_hierarchy,depth,1)]],[curve=[-5,-2]]).
arc(arc00126,node00108,node00216,influence,[attached=[],complete=true,name=i20,role=[use(none,in_hierarchy,water_depth,1)]],[curve=[-6,-4]]).
node(node00107,function,[],[complete=true,min_val=0,name=fn3,spec=[49,48,42,99,97,116,99,104,109,101,110,116,95,97,114,101,97,42,115,117,114,102,97,99,101,95,102,108,111,119],units=1/day,value=10*catchment_area*surface_flow],[along=500]).
node(node00013,function,[],[complete=true,name=fn6,spec=[99,117,114,114,101,110,116,95,115,117,114,102,97,99,101,95,97,114,101,97,42,40,40,49,45,99,111,115,40,50,42,112,105,40,41,42,116,105,109,101,40,49,41,47,51,54,48,41,41,42,53,43,53,41,47,49,48,48,48],units=1/day,value=current_surface_area*((1-cos(2*pi('')*time(1)/360))*5+5)/1000],[along=500]).
node(node00043,function,[],[complete=true,min_val=0,name=fn5,spec=[105,102,32,115,116,111,114,101,100,95,119,97,116,101,114,62,99,97,112,97,99,105,116,121,32,111,114,32,115,116,111,114,101,100,95,119,97,116,101,114,43,105,110,102,108,111,119,42,46,57,62,99,97,112,97,99,105,116,121,32,111,114,32,115,116,111,114,101,100,95,119,97,116,101,114,43,105,110,102,108,111,119,62,99,97,112,97,99,105,116,121,42,49,46,50,32,116,104,101,110,32,109,97,120,40,115,116,111,114,101,100,95,119,97,116,101,114,43,105,110,102,108,111,119,42,46,57,45,99,97,112,97,99,105,116,121,44,115,116,111,114,101,100,95,119,97,116,101,114,43,105,110,102,108,111,119,45,99,97,112,97,99,105,116,121,42,49,46,50,41,32,101,108,115,101,32,48],units=1/day,value=(if stored_water>capacity or stored_water+inflow* 0.9 >capacity or stored_water+inflow>capacity* 1.2 then max(stored_water+inflow* 0.9 -capacity,stored_water+inflow-capacity* 1.2) else 0)],[along=500]).
node(node00048,function,[],[complete=true,min_val=0,name=fn22,spec=[40,105,102,32,105,110,105,116,95,116,105,109,101,40,49,41,61,61,116,105,109,101,40,49,41,32,111,114,32,32,108,97,115,116,40,119,101,116,116,101,100,95,97,114,101,97,41,60,119,101,116,116,101,100,95,97,114,101,97,32,116,104,101,110,32,49,48,32,101,108,115,101,32,49,41,42,48,46,48,50,53,42,119,101,116,116,101,100,95,97,114,101,97,42,40,49,45,112,114,111,112,111,114,116,105,111,110,94,50,41],units=1/day,value=(if init_time(1)==time(1) or last(wetted_area)<wetted_area then 10 else 1)* 0.025 *wetted_area*(1-proportion^2)],[along=500]).
arc(arc00016,node00210,node00107,influence,[attached=[],complete=true,name=i4,role=[use(none,in_hierarchy,surface_flow,1)]],[curve=[-11,13]]).
arc(arc00103,node00104,node00107,influence,[attached=[],complete=true,name=i6,role=[use(none,in_hierarchy,catchment_area,1)]],[curve=[-2,36]]).
arc(arc00112,node00214,node00013,influence,[attached=[],complete=true,name=i18_0,role=[use(none,in_hierarchy,current_surface_area,1)]],[curve=[24,-20]]).
arc(arc00142,node00004,node00043,influence,[attached=[],complete=true,name=i36_0,role=[use(none,in_hierarchy,stored_water,1)]],[curve=[8,-2]]).
arc(arc00143,node00107,node00043,influence,[attached=[],complete=true,name=i37_0,role=[use(none,in_hierarchy,inflow,1)]],[curve=[10,10]]).
arc(arc00147,node00137,node00043,influence,[attached=[],complete=true,name=i41_0,role=[use(none,in_hierarchy,capacity,1)]],[curve=[-12,27]]).
arc(arc00135,node00144,node00048,influence,[attached=[],complete=true,name=i12,role=[use(none,in_hierarchy,proportion,1)]],[curve=[-6,4]]).
arc(arc00145,node00081,node00048,influence,[attached=[],complete=true,name=i16_0,role=[use(none,in_hierarchy,wetted_area,1)]],[curve=[17,10]]).
node(node00025,border,[],[name=var2_0],[along=71]).
node(node00030,variable,[],[name=var3],[caption_offset=[ -26.0, -14.0],centre=[ 183.0, -44.0]]).
node(node00049,function,[],[complete=false,name=fn2_1],[]).
node(node00054,border,[],[name=var5_0],[along=81]).
node(node00065,variable,[],[comment='1=water in well; 0=empty\nAssume that all wells empty at outset - Rajendra Singh refres to the "dark zone" where no groundwater.',complete=true,description=binary,name='days with\nwater in wells'],[caption_offset=[ -33.0, -10.0],centre=[ 176.0, -228.0]]).
node(node00066,function,[],[complete=true,name=fn1,spec=[109,97,107,101,97,114,114,97,121,40,105,102,32,112,108,97,99,101,95,105,110,40,49,41,61,61,102,109,111,100,40,116,105,109,101,40,49,41,44,51,54,48,41,43,49,32,116,104,101,110,40,105,102,32,119,97,116,101,114,95,100,114,97,119,110,95,102,114,111,109,95,119,101,108,108,115,62,48,32,116,104,101,110,32,49,32,101,108,115,101,32,48,41,101,108,115,101,105,102,32,116,105,109,101,40,49,41,61,61,48,32,116,104,101,110,32,48,32,101,108,115,101,32,101,108,101,109,101,110,116,40,112,114,101,118,40,49,41,44,112,108,97,99,101,95,105,110,40,49,41,41,44,51,54,48,41],units=array(int,360),value=makearray(if place_in(1)==fmod(time(1),360)+1 then (if water_drawn_from_wells>0 then 1 else 0) elseif time(1)==0 then 0 else element(prev(1),place_in(1)),360)],[]).
node(node00067,variable,[],[comment='0=no flow; 1=flow.\nTo initialize (time=0), assume flow every day in August (days 211-240), since have 18-30 days rain, mainly July-Sept',complete=true,description='Day of year (1-360)',name='days of river flow'],[caption_offset=[ -68.0, -13.0],centre=[ 184.0, -116.0]]).
node(node00068,function,[],[complete=true,name=fn2,spec=[109,97,107,101,97,114,114,97,121,40,105,102,32,112,108,97,99,101,95,105,110,40,49,41,61,61,102,109,111,100,40,116,105,109,101,40,49,41,44,51,54,48,41,43,49,32,116,104,101,110,40,105,102,32,114,105,118,101,114,95,102,108,111,119,62,49,32,116,104,101,110,32,49,32,101,108,115,101,32,48,41,101,108,115,101,105,102,32,116,105,109,101,40,49,41,61,61,48,32,116,104,101,110,40,105,102,32,112,108,97,99,101,95,105,110,40,49,41,62,50,49,48,32,97,110,100,32,112,108,97,99,101,95,105,110,40,49,41,60,61,50,51,52,32,116,104,101,110,32,49,32,101,108,115,101,32,48,41,101,108,115,101,32,101,108,101,109,101,110,116,40,112,114,101,118,40,49,41,44,112,108,97,99,101,95,105,110,40,49,41,41,44,51,54,48,41],units=array(int,360),value=makearray(if place_in(1)==fmod(time(1),360)+1 then (if river_flow>1 then 1 else 0) elseif time(1)==0 then (if place_in(1)>210 and place_in(1)<=234 then 1 else 0) else element(prev(1),place_in(1)),360)],[]).
node(node00071,border,[],[name=var5],[along=71]).
node(node00114,function,[],[complete=true,name=fn2_0,spec=[112,114,111,112,111,114,116,105,111,110,42,49,48],units=1,value=proportion*10],[]).
node(node00139,variable,[],[complete=true,name='% days with water in wells'],[caption_offset=[ 72.0, 3.0],centre=[ 25.0, -197.0]]).
node(node00140,function,[],[complete=true,name=fn14,spec=[49,48,48,42,115,117,109,40,91,100,97,121,115,95,119,105,116,104,95,119,97,116,101,114,95,105,110,95,116,97,110,107,93,41,47,99,111,117,110,116,40,91,100,97,121,115,95,119,105,116,104,95,119,97,116,101,114,95,105,110,95,116,97,110,107,93,41],units=1,value=100*sum([days_with_water_in_tank])/count([days_with_water_in_tank])],[]).
node(node00141,variable,[],[complete=true,name='% days of river flow'],[caption_offset=[ -72.0, -17.0],centre=[ 163.0, -143.0]]).
node(node00142,function,[],[complete=true,name=fn15,spec=[49,48,48,42,115,117,109,40,91,100,97,121,115,95,111,102,95,114,105,118,101,114,95,102,108,111,119,93,41,47,99,111,117,110,116,40,91,100,97,121,115,95,111,102,95,114,105,118,101,114,95,102,108,111,119,93,41],units=1,value=100*sum([days_of_river_flow])/count([days_of_river_flow])],[]).
node(node00147,border,[],[name=var2],[along=919]).
node(node00150,border,[],[name=var4],[along=853]).
node(node00217,variable,[],[comment='Should be a conversion of cubic metres/day of flow to depth in metres. This a rough estimate with no empirical basis.',complete=true,description=m,name='river depth'],[caption_offset=[ 31.0, -29.0],centre=[ 17.0, -78.0]]).
node(node00218,function,[],[complete=true,name=fn1_0,spec=[114,105,118,101,114,95,102,108,111,119,94,46,51,53,47,50,53],units=1,value=river_flow^ 0.35 /25],[]).
node(node00219,variable,[],[comment='This is a guess with no empirical basis - needs checking! Assumes that pore space is 10% of aquifer volume.',complete=true,description=m,name='depth of water in wells'],[caption_offset=[ -80.0, -16.0],centre=[ 185.0, -262.0]]).
arc(arc00020,node00054,node00030,influence,[attached=[],complete=true,name=i5],[curve=[8,7]]).
arc(arc00210,node00049,node00030,influence,[attached=[],name=i3],[]).
arc(arc00054,node00066,node00065,influence,[attached=[],name=i1],[]).
arc(arc00140,node00147,node00066,influence,[attached=[],complete=true,name=i2_0,role=[use(none,in_hierarchy,water_drawn_from_wells,1)]],[curve=[-4,8]]).
arc(arc00064,node00068,node00067,influence,[attached=[],name=i2],[]).
arc(arc00068,node00071,node00068,influence,[attached=[],complete=true,name=i6,role=[use(none,in_hierarchy,river_flow,1)]],[curve=[-6,7]]).
arc(arc00155,node00150,node00114,influence,[attached=[],complete=true,name=i4_0,role=[use(none,in_hierarchy,proportion,1)]],[curve=[2,4]]).
arc(arc00150,node00140,node00139,influence,[attached=[],name=i44],[]).
arc(arc00066,node00065,node00140,influence,[attached=[],complete=true,name=i4,role=[use(none,in_hierarchy,[days_with_water_in_tank],array(1,360))]],[curve=[-16,-32]]).
arc(arc00151,node00142,node00141,influence,[attached=[],name=i45],[]).
arc(arc00070,node00067,node00142,influence,[attached=[],complete=true,name=i8,role=[use(none,in_hierarchy,[days_of_river_flow],array(1,360))]],[curve=[-4,2]]).
arc(arc00209,node00218,node00217,influence,[attached=[],name=i1_0],[]).
arc(arc00009,node00025,node00218,influence,[attached=[],complete=true,name=i2_1,role=[use(none,in_hierarchy,river_flow,1)]],[curve=[3,48]]).
arc(arc00124,node00114,node00219,influence,[attached=[],name=i9],[]).
arc(arc00021,node00102,node00062,influence,[attached=[],complete=true,name=i6],[curve=[48,49]]).
arc(arc00152,node00161,node00062,influence,[attached=[],complete=true,name=i3_1],[curve=[0,6]]).
arc(arc00156,node00161,node00062,influence,[attached=[],complete=true,name=i5_1],[curve=[-106,-55]]).
arc(arc00160,node00152,node00062,influence,[attached=[],complete=true,name=i7],[curve=[-2,-14]]).
arc(arc00116,node00128,node00087,influence,[attached=[],name=i1_0],[]).
arc(arc00035,node00103,node00102,influence,[attached=[],complete=true,name=i10],[curve=[0,-15]]).
arc(arc00053,node00109,node00102,influence,[attached=[],complete=true,name=i9],[curve=[0,-4]]).
arc(arc00060,node00109,node00102,influence,[attached=[],complete=true,name=i12_0],[curve=[-4,12]]).
arc(arc00063,node00103,node00102,influence,[attached=[],complete=true,name=i38,role=[use(none,in_hierarchy,labour_input,1)]],[curve=[0,-16]]).
arc(arc00067,node00109,node00102,influence,[attached=[],complete=true,name=i3],[curve=[-18,-8]]).
arc(arc00132,node00130,node00102,influence,[attached=[],complete=true,name=i7_2],[curve=[0,16]]).
arc(arc00136,node00161,node00102,influence,[attached=[],complete=true,name=i13_0],[curve=[-8,4]]).
arc(arc00137,node00118,node00102,influence,[attached=[],complete=true,name=i23],[curve=[-28,2]]).
arc(arc00187,node00102,node00103,influence,[attached=[],complete=true,name=i13],[curve=[14,-17]]).
arc(arc00079,node00102,node00109,influence,[attached=[],complete=true,name=i6_0],[curve=[68,-23]]).
arc(arc00090,node00102,node00109,influence,[attached=[],complete=true,name=i13_1],[curve=[-6,12]]).
arc(arc00190,node00172,node00118,influence,[attached=[],complete=true,name=i4_0],[curve=[16,27]]).
arc(arc00195,node00172,node00118,influence,[attached=[],complete=true,name=i9_1],[curve=[4,23]]).
arc(arc00171,node00152,node00128,influence,[attached=[],complete=true,name=i3_2,role=[use(none,in_hierarchy,cumulative_river_flow,1)]],[curve=[1,5]]).
arc(arc00120,node00131,node00130,influence,[attached=[],name=i4],[]).
arc(arc00123,node00152,node00131,influence,[attached=[],complete=true,name=i5_0,role=[use(none,in_hierarchy,'Area_not_harnessed',1)]],[curve=[43,26]]).
arc(arc00162,node00102,node00152,influence,[attached=[],complete=true,name=i8_0,role=[use(none,in_hierarchy,{catchment_area},list(1))]],[curve=[73,-40]]).
arc(arc00163,node00102,node00152,flow,[attached=[node00100],name=overflow],[curve=[550,1000]]).
arc(arc00164,node00118,node00152,influence,[attached=[],complete=true,name=i24,role=[use(none,in_hierarchy,typical_surface_flow,1)]],[curve=[-18,2]]).
arc(arc00179,node00161,node00152,flow,[attached=[node00163],name=springs],[curve=[550,1000]]).
arc(arc00177,node00102,node00161,flow,[attached=[node00044],name=percolation],[curve=[550,1000]]).
arc(arc00184,node00103,node00161,influence,[attached=[],complete=true,name=i10_0],[curve=[2,28]]).
node(node00100,function,[],[complete=false,name=fn3_1],[along=450]).
node(node00163,function,[],[complete=false,name=fn7],[along=450]).
node(node00044,function,[],[complete=false,name=fn2_0],[along=450]).
