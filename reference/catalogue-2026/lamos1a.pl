source(program='Simile v7.4',version= 11.4,edition=free,date='Thu Aug 13 11:38:00 GMT 2026').

roots([node00244,node00245,node00334,node00335,node00336,node00337,node00338,node00339,node00340,node00341,node00342,node00343,node00344,node00352,node00353,node00354]).

properties([complete-true,file_name-'C:/Inetpub/wwwroot/www/examples/catalogue/models/bob/lamos1/lamos1a.sml',fill_colour-'#ffffffffffff',name-'Desktop6',separate-0]).

node(node00244,variable,[],[complete=true,name='fuel per\nindiv'],[caption_offset=[ -3.968, -35.708],centre=[ -59.434, 206.274]]).
node(node00245,function,[],[complete=true,name=fn1_2,units=array(1,size(plant_species)),value=[ 10.0, 10.0, 10.0, 10.0, 10.0]],[]).
node(node00334,variable,[],[complete=true,name=cs],[caption_offset=[ -1.992, -29.876],centre=[ -57.649, 87.586]]).
node(node00335,function,[],[complete=true,name=fn9,units=array(array(1,5),5),value=[[ 0.005, 0.003, 0.006, 0.007, 0.006],[ 0.002, 0.005, 0.006, 0.007, 0.006],[ 0.002, 0.002, 0.005, 0.006, 0.002],[ 0.002, 0.002, 0.003, 0.004, 0.002],[ 0.002, 0.002, 0.003, 0.002, 0.005]]],[]).
node(node00336,variable,[],[complete=true,name=ms],[caption_offset=[ 24.797, -12.895],centre=[ 241.893, -88.414]]).
node(node00337,function,[],[complete=true,name=fn10,units=array(1,size(plant_species)),value=[ 0.1, 0.1, 0.1, 0.1, 0.1]],[]).
node(node00338,variable,[],[complete=true,name=water_use],[caption_offset=[ 0.0, 0.0],centre=[ -57.47, 280.697]]).
node(node00339,function,[],[complete=true,name=fn7,units=array(1,size(plant_species)),value=[ 0.5, 0.5, 0.5, 0.5, 0.5]],[]).
node(node00340,variable,[],[complete=true,description='Rainfall (mm/month)',max_val=500,min_val=0,name=rain,units=int,value=100],[caption_offset=[ 0.0, 0.0],centre=[ -56.514, 324.348]]).
node(node00341,submodel,[node00125,node00246,node00247,node00249,node00250,node00251,node00252,node00253,node00256,node00355,node00356,node00357,node00358,node00359,node00360,node00361,node00362,node00363,node00364,node00365,node00366,node00367,node00368,node00369,node00370,node00371,node00372,node00373,node00374,node00375],[complete=true,fill_colour='#ffdfff',multiplication_spec=[count=[225]],name=patch,separate=0],[bounding_box=[ -27.773, -54.554, 345.134, 348.154],caption_offset=[ 21.822, -4.959],internal_extent=[ -14.878, 6.943, 358.029, 409.651]]).
links(node00341,[arc00099-arc00391,arc00225-arc00224,arc00233-arc00240,arc00239-arc00229,arc00308-arc00369,arc00309-arc00370,arc00310-arc00371,arc00311-arc00372,arc00376-arc00389,arc00377-arc00390,arc00378-arc00384,arc00379-arc00385,arc00388-arc00078,arc00392-arc00380,arc00405-arc00381,arc00407-arc00382]).
references(node00341,[local(arc00386),local(arc00387),obsolete,obsolete]).
node(node00342,submodel,[node00070,node00110,node00433,node00434,node00435,node00436,node00437,node00438,node00439,node00440,node00441,node00442,node00443,node00444,node00445,node00446,node00447],[complete=true,fill_colour='#f3f3f3',multiplication_spec=[count=[]],name=neighbour,separate=0],[bounding_box=[ 402.64, 10.915, 475.913, 322.368],caption_offset=[ 28.765, -7.935],internal_extent=[ 3.968, -4.959, 77.24, 306.494]]).
links(node00342,[arc00384-arc00395,arc00385-arc00396,arc00389-arc00399,arc00390-arc00401,arc00391-arc00403,arc00397-arc00388,arc00404-arc00392]).
references(node00342,[local(arc00386),local(arc00387)]).
node(node00343,variable,[],[complete=true,name='seeds\nper indiv'],[caption_offset=[ -29.757, -16.862],centre=[ 70.392, -88.338]]).
node(node00344,function,[],[complete=true,name=fn2,units=array(1,size(plant_species)),value=[ 70.0, 60.0, 25.0, 20.0, 20.0]],[]).
node(node00352,variable,[],[complete=true,name=dispersability],[caption_offset=[ 49.595, -12.895],centre=[ 121.931, -89.334]]).
node(node00353,function,[],[complete=true,name=fn1_1,units=array(1,size(plant_species)),value=[ 0.2, 0.2, 0.15, 0.1, 0.05]],[]).
node(node00354,submodel,[node00112,node00134,node00254,node00258,node00448,node00449,node00450,node00451,node00452,node00453,node00454,node00455,node00456,node00457,node00458,node00459,node00460,node00461,node00462],[complete=true,fill_colour='#ff9b9b',multiplication_spec=[count=[]],name=fire,separate=0],[bounding_box=[ -507.132, -94.322, -89.11, 421.532],caption_offset=[ 33.724, -5.951],internal_extent=[ 35.404, -122.372, 460.302, 401.968]]).
links(node00354,[arc00240-arc00236,arc00471-arc00239]).
node(node00112,function,[],[complete=true,name=fn17,units=int,value=2500],[]).
node(node00134,variable,[],[complete=true,name=min_for_fire],[caption_offset=[ 36.364, -17.38],centre=[ 387.081, 291.108]]).
node(node00254,border,[],[name=var7],[along=103]).
node(node00258,border,[],[name=var4],[along=938]).
node(node00448,submodel,[node00145,node00146,node00151,node00155,node00257,node00463,node00464,node00465,node00466,node00467,node00468,node00469,node00470,node00471,node00472,node00475,node00476,node00477,node00478],[complete=true,fill_colour='#ffffb9',multiplication_spec=[count=[]],name=conditional_fire,separate=0,step=2],[bounding_box=[ 73.107, -64.529, 431.777, 276.357],caption_offset=[ 41.444, -8.881],internal_extent=[ 0.538, -4.0, 313.252, 293.21]]).
links(node00448,[arc00157-arc00443,arc00218-arc00220,arc00236-arc00235,arc00439-arc00466,arc00447-arc00180,arc00448-arc00445,arc00452-arc00446,arc00460-arc00442,arc00462-arc00444,arc00464-arc00159]).
node(node00449,submodel,[node00202,node00203,node00204,node00205,node00206,node00207],[complete=true,fill_colour='#ffffff',multiplication_spec=[count=[]],name=fire_test,separate=0],[bounding_box=[ 44.94, 301.826, 126.327, 369.913],caption_offset=[ 13.815, -6.907],internal_extent=[ 11.369, 0.0, 92.756, 68.087]]).
links(node00449,[arc00182-arc00448,arc00451-arc00447]).
node(node00450,submodel,[node00208,node00494,node00495,node00496,node00497,node00498,node00499,node00500,node00501,node00502,node00503,node00504,node00505,node00506,node00507,node00508,node00509],[complete=true,fill_colour='#e2e2e2',multiplication_spec=[count=[225]],name=patch_results,separate=0],[bounding_box=[ 169.639, 297.321, 343.796, 382.28],caption_offset=[ 13.815, -6.907],internal_extent=[ 15.788, -9.868, 189.946, 75.091]]).
links(node00450,[arc00203-arc00202,arc00203-arc00206,arc00205-arc00204,arc00205-arc00207,arc00458-arc00452]).
node(node00451,variable,[],[complete=true,name=always_catch],[caption_offset=[ -4.049, -30.367],centre=[ 390.261, -92.831]]).
node(node00452,variable,[],[complete=true,name=burnt_per_step],[caption_offset=[ 3.037, -31.379],centre=[ 306.814, -90.207]]).
node(node00453,function,[],[complete=true,name=fn18,units=1,value= 0.6],[]).
node(node00454,variable,[],[complete=true,name=always_starts],[caption_offset=[ 18.22, 0.0],centre=[ 55.945, 118.778]]).
node(node00455,function,[],[complete=true,name=fn19,units=int,value=1500],[]).
node(node00456,function,[],[complete=true,name=fn3,units=int,value=1000],[]).
node(node00457,function,[],[complete=false,max_val=3000,min_val=0,name=fn1,units=array(1,size(fire_patch)),value=[fuel_lost]-prev(1)],[]).
node(node00458,variable,[],[complete=true,name=nrow],[caption_offset=[ 0.0, 0.0],centre=[ 144.122, 317.784]]).
node(node00459,function,[],[complete=true,name=fn6,units=int,value=15],[]).
node(node00460,variable,[],[complete=true,name=ncol],[caption_offset=[ 0.0, 0.0],centre=[ 145.882, 360.469]]).
node(node00461,function,[],[complete=true,name=fn7,units=int,value=15],[]).
node(node00462,submodel,[node00225,node00226,node00227,node00228,node00229,node00230,node00231],[complete=true,fill_colour='#ffffb9',multiplication_spec=[count=[]],name='fire results',separate=0,step=2],[bounding_box=[ 366.69, 313.38, 440.133, 394.487],caption_offset=[ 11.007, -6.933],internal_extent=[ 5.061, 0.0, 78.504, 81.108]]).
links(node00462,[arc00220-arc00219,arc00466-arc00468,arc00470-arc00471]).
node(node00225,border,[],[name=var2],[along=606]).
node(node00226,variable,[],[complete=true,name=time_in_2],[caption_offset=[ 0.0, 0.0],centre=[ 30.954, 56.748]]).
node(node00227,function,[],[complete=true,name=fn1_0,units=1,value=fmod(time(1),dt(1))],[]).
node(node00228,variable,[],[comment='if any({burning})then element(sum({[fuel_load_lost]}),index(1))elseif fmod(time(1),dt(1))>0 and fmod(time(1),dt(1))<1.5*dt(2)then 0 else prev(1)',complete=true,name=fuel_lost],[caption_offset=[ 9.995, 3.947],centre=[ 44.355, 22.863]]).
node(node00229,function,[],[complete=true,max_val=3000,min_val=0,name=fn1,units=array(1,size(fire_patch)),value=(if any({burning}) then sum({[fuel_load_lost]}) elseif time_in_2>0 and time_in_2< 1.5 *dt(2) then 0 else prev(1))],[]).
node(node00230,border,[],[name=var3],[along=849]).
node(node00231,border,[],[name=var8],[along=751]).
arc(arc00467,node00227,node00226,influence,[attached=[],name=i1_0],[]).
arc(arc00469,node00229,node00228,influence,[attached=[],name=i1],[]).
arc(arc00189,node00226,node00229,influence,[attached=[],complete=true,name=i2_0,role=[use(none,in_hierarchy,time_in_2,1)]],[curve=[-2,0]]).
arc(arc00219,node00231,node00229,influence,[attached=[],complete=true,name=i8,role=[use(none,in_hierarchy,{[fuel_load_lost]},list(array(1,size(fire_patch))))]],[curve=[2,-1]]).
arc(arc00468,node00225,node00229,influence,[attached=[],complete=true,name=i2,role=[use(none,in_hierarchy,{burning},list(boolean))]],[curve=[2,-4]]).
arc(arc00470,node00228,node00230,influence,[attached=[],complete=true,name=i4],[curve=[-2,-3]]).
node(node00208,function,[],[complete=false,max_val=3000,min_val=0,name=fn16,units=1,value=(if any({burning}) then element(sum({[fuel_load_lost]}),index(1)) elseif fmod(time(1),dt(1))>0 and fmod(time(1),dt(1))< 1.5 *dt(2) then 0 else prev(1))],[]).
node(node00494,function,[],[complete=false,max_val=3000,min_val=0,name=fn1_0,units=1,value=element(sum({[fuel_load_lost]}),index(1))],[]).
node(node00495,variable,[],[complete=true,name=row],[caption_offset=[ 0.0, 0.0],centre=[ 48.738, 9.911]]).
node(node00496,function,[],[complete=true,name=fn1,units=int,value=floor((index(1)-1)/nrow)+1],[]).
node(node00497,variable,[],[complete=true,name=col],[caption_offset=[ 0.0, 0.0],centre=[ 51.719, 48.587]]).
node(node00498,function,[],[complete=true,name=fn2,units=1,value=fmod(index(1)-1,ncol)+1],[]).
node(node00499,variable,[],[complete=true,name=row_neighbours],[caption_offset=[ 0.0, 0.0],centre=[ 101.101, 11.948]]).
node(node00500,function,[],[complete=true,name=fn3,units=array(int,4),value=[row-1,row,row+1,row]],[]).
node(node00501,variable,[],[complete=true,name=col_neighbours],[caption_offset=[ 0.0, 0.0],centre=[ 115.237, 47.579]]).
node(node00502,function,[],[complete=true,name=fn4,units=array(1,4),value=[col,col+1,col,col-1]],[]).
node(node00503,variable,[],[complete=true,name=neighbours],[caption_offset=[ 0.0, 0.0],centre=[ 162.387, 27.63]]).
node(node00504,function,[],[complete=true,name=fn5,units=array(1,4),value=(if ([row_neighbours]>0,[row_neighbours]<=nrow,[col_neighbours]>0,[col_neighbours]<=ncol) then ncol*([row_neighbours]-1)+[col_neighbours] else index(1))],[]).
node(node00505,border,[],[name=var8],[along=533]).
node(node00506,border,[],[name=var9],[along=459]).
node(node00507,border,[],[name=var10],[along=533]).
node(node00508,border,[],[name=var11],[along=459]).
node(node00509,border,[],[name=var2],[along=922]).
arc(arc00453,node00496,node00495,influence,[attached=[],name=i1],[]).
arc(arc00202,node00505,node00496,influence,[attached=[],complete=true,name=i12,role=[use(none,in_hierarchy,nrow,int)]],[curve=[-1,-3]]).
arc(arc00454,node00498,node00497,influence,[attached=[],name=i2],[]).
arc(arc00204,node00506,node00498,influence,[attached=[],complete=true,name=i14,role=[use(none,in_hierarchy,ncol,int)]],[curve=[1,-6]]).
arc(arc00455,node00500,node00499,influence,[attached=[],name=i3],[]).
arc(arc00196,node00495,node00500,influence,[attached=[],complete=true,name=i6,role=[use(none,in_hierarchy,row,int)]],[curve=[0,-10]]).
arc(arc00456,node00502,node00501,influence,[attached=[],name=i4],[]).
arc(arc00197,node00497,node00502,influence,[attached=[],complete=true,name=i7,role=[use(none,in_hierarchy,col,1)]],[curve=[-1,-11]]).
arc(arc00457,node00504,node00503,influence,[attached=[],name=i5],[]).
arc(arc00198,node00499,node00504,influence,[attached=[],complete=true,name=i8,role=[use(none,in_hierarchy,[row_neighbours],array(int,4))]],[curve=[4,-8]]).
arc(arc00199,node00501,node00504,influence,[attached=[],complete=true,name=i9,role=[use(none,in_hierarchy,[col_neighbours],array(1,4))]],[curve=[-2,-10]]).
arc(arc00206,node00507,node00504,influence,[attached=[],complete=true,name=i16_0,role=[use(none,in_hierarchy,nrow,int)]],[curve=[21,-45]]).
arc(arc00207,node00508,node00504,influence,[attached=[],complete=true,name=i17,role=[use(none,in_hierarchy,ncol,int)]],[curve=[-4,-34]]).
arc(arc00458,node00503,node00509,influence,[attached=[],complete=true,name=i2_0],[curve=[-8,0]]).
node(node00202,variable,[],[complete=true,name='spark?'],[caption_offset=[ 0.0, 0.0],centre=[ 33.293, 17.569]]).
node(node00203,function,[],[complete=true,name=fn14,units=boolean,value=(abs(time(1)-10)< 0.001)],[]).
node(node00204,variable,[],[complete=true,name=spark_patch],[caption_offset=[ 0.0, 0.0],centre=[ 59.978, 36.703]]).
node(node00205,function,[],[complete=true,name=fn15,units=int,value=int(rand_var(1,size(fire_patch)+1))],[]).
node(node00206,border,[],[name=var10],[along=865]).
node(node00207,border,[],[name=var13],[along=777]).
arc(arc00449,node00203,node00202,influence,[attached=[],name=i14],[]).
arc(arc00450,node00205,node00204,influence,[attached=[],name=i15],[]).
arc(arc00451,node00204,node00206,influence,[attached=[],complete=true,name=i17],[curve=[-5,-2]]).
arc(arc00182,node00202,node00207,influence,[attached=[],complete=true,name=i21],[curve=[-4,-6]]).
node(node00145,variable,[],[complete=true,name=check_spark],[caption_offset=[ 0.0, 0.0],centre=[ 121.756, 257.37]]).
node(node00146,function,[],[complete=true,name=fn11,units=boolean,value=(spark_ and fmod(time(1),dt(1))<dt(2))],[]).
node(node00151,border,[],[name=var1],[along=196]).
node(node00155,border,[],[name=var7],[along=803]).
node(node00257,border,[],[name=var3],[along=949]).
node(node00463,submodel,[node00174,node00180,node00181,node00182,node00183,node00184,node00185,node00187,node00188,node00189,node00190,node00191,node00194,node00195,node00196,node00197,node00198,node00199,node00200,node00201,node00479,node00480,node00481,node00482,node00484,node00485,node00486,node00487,node00488,node00489,node00490,node00491,node00492,node00493],[complete=true,fill_colour='#e2e2e2',multiplication_spec=[count=[225]],name=fire_patch,separate=0],[bounding_box=[ 56.443, 17.779, 277.479, 231.908],caption_offset=[ 22.696, -5.921],internal_extent=[ 0.0, 0.0, 221.036, 214.129]]).
links(node00463,[arc00159-arc00427,arc00159-arc00429,arc00168-arc00438,arc00173-arc00424,arc00180-arc00431,arc00217-arc00218,arc00235-arc00234,arc00436-arc00432,arc00442-arc00425,arc00443-arc00426,arc00444-arc00428,arc00446-arc00435]).
references(node00463,[obsolete,obsolete]).
node(node00464,variable,[],[complete=true,name=burning],[caption_offset=[ 0.0, 0.0],centre=[ 181.607, 259.048]]).
node(node00465,function,[],[complete=true,name=fn12,units=boolean,value=any([other_fires])],[]).
node(node00466,variable,[],[complete=true,name=other_fires],[caption_offset=[ 30.766, -23.734],centre=[ 235.106, 259.448]]).
node(node00467,function,[],[complete=true,name=fn13,units=array(boolean,size(fire_patch)),value=[old_fire]],[]).
node(node00468,condition,[],[complete=true,name='is_fire?'],[caption_offset=[ 0.0, 0.0],centre=[ 41.739, 250.364]]).
node(node00469,function,[],[complete=true,name=fn20,units=boolean,value=(check_spark or burning)],[]).
node(node00470,border,[],[name=var10],[along=847]).
node(node00471,border,[],[name=var12],[along=156]).
node(node00472,border,[],[name=var14],[along=506]).
node(node00475,border,[],[name=var12_0],[along=308]).
node(node00476,border,[],[name=var14_0],[along=320]).
node(node00477,border,[],[name=var4_0],[along=168]).
node(node00478,border,[],[name=var7_0],[along=123]).
node(node00174,function,[],[complete=true,name=fn5,units=boolean,value=(neighbour_burns and catches)],[]).
node(node00180,function,[],[complete=true,name=fn8,units=boolean,value=(check_spark and spark_patch==index(1))],[]).
node(node00181,variable,[],[complete=true,name=neighbour_burns],[caption_offset=[ 4.395, -30.766],centre=[ 125.32, 149.002]]).
node(node00182,function,[],[complete=true,name=fn9,units=boolean,value=any(element([other_fires],[neighbours]))],[]).
node(node00183,variable,[],[complete=true,name=old_fire],[caption_offset=[ -15.823, -2.637],centre=[ 193.407, 145.055]]).
node(node00184,function,[],[complete=true,name=fn10,units=boolean,value=last(fire)],[]).
node(node00185,border,[],[name=var1],[along=223]).
node(node00187,border,[],[name=var6],[along=810]).
node(node00188,border,[],[name=var9],[along=849]).
node(node00189,border,[],[name=var11],[along=192]).
node(node00190,border,[],[name=var13],[along=472]).
node(node00191,border,[],[name=var15],[along=192]).
node(node00194,function,[],[complete=true,max_val=3000,min_val=0,name=fn1_1,units=1,value=0],[]).
node(node00195,border,[],[name=var2],[along=160]).
node(node00196,border,[],[name=var11_0],[along=360]).
node(node00197,border,[],[name=var15_0],[along=347]).
node(node00198,variable,[],[complete=true,name=neighbours],[caption_offset=[ 32.524, -24.613],centre=[ 155.265, 183.413]]).
node(node00199,function,[],[complete=true,name=fn1_0,units=array(1,4),value=element([[neighbours]],index(1))],[]).
node(node00200,border,[],[name=var3_1],[along=173]).
node(node00201,border,[],[name=var6_0],[along=114]).
node(node00479,border,[],[name=var2_0],[along=945]).
node(node00480,compartment,[],[complete=true,name=fuel_load],[caption_offset=[ 0.0, 0.0],centre=[ 82.889, 29.603]]).
node(node00481,function,[],[complete=true,max_val=3000,min_val=0,name=fn1,units=1,value=element([fuel_load],index(1))],[]).
node(node00482,compartment,[],[complete=true,name=fuel_load_lost],[caption_offset=[ -9.708, 0.0],centre=[ 192.42, 28.616]]).
node(node00484,variable,[],[complete=true,name=fire],[caption_offset=[ -16.702, -21.097],centre=[ 50.433, 63.726]]).
node(node00485,function,[],[complete=true,name=fn3,units=boolean,value=(crossover or new_fire)],[]).
node(node00486,variable,[],[complete=true,name=new_fire],[caption_offset=[ -26.371, -18.46],centre=[ 48.709, 100.021]]).
node(node00487,function,[],[complete=true,name=fn4,units=boolean,value=(spark_here and starts)],[]).
node(node00488,variable,[],[complete=true,name=crossover],[caption_offset=[ 0.0, 0.0],centre=[ 102.119, 93.635]]).
node(node00489,variable,[],[complete=true,name=catches],[caption_offset=[ 0.0, 0.0],centre=[ 165.777, 97.69]]).
node(node00490,function,[],[complete=true,name=fn6,units=boolean,value=(rand_var(0,1)< 0.7 *max(0,min(1,(fuel_load-min_for_fire)/(always_catch-min_for_fire))))],[]).
node(node00491,variable,[],[complete=true,name=starts],[caption_offset=[ 0.0, 0.0],centre=[ 74.008, 144.068]]).
node(node00492,function,[],[complete=true,name=fn7,units=boolean,value=(fuel_load>rand_const(min_for_fire,always_starts))],[]).
node(node00493,variable,[],[complete=true,name=spark_here],[caption_offset=[ 21.976, -2.637],centre=[ 37.497, 180.579]]).
arc(arc00153,node00181,node00174,influence,[attached=[],complete=true,name=i18,role=[use(none,in_hierarchy,neighbour_burns,boolean)]],[curve=[-11,7]]).
arc(arc00154,node00489,node00174,influence,[attached=[],complete=true,name=i19,role=[use(none,in_hierarchy,catches,boolean)]],[curve=[-1,15]]).
arc(arc00431,node00196,node00180,influence,[attached=[],complete=true,name=i18_0,role=[use(none,in_hierarchy,spark_patch,int)]],[curve=[-7,-3]]).
arc(arc00432,node00197,node00180,influence,[attached=[],complete=true,name=i24,role=[use(none,in_hierarchy,check_spark,boolean)]],[curve=[-7,-2]]).
arc(arc00422,node00182,node00181,influence,[attached=[],name=i9],[]).
arc(arc00424,node00185,node00182,influence,[attached=[],complete=true,name=i1_1,role=[use(none,in_hierarchy,[other_fires],array(boolean,size(fire_patch)))]],[curve=[-15,1]]).
arc(arc00433,node00198,node00182,influence,[attached=[],complete=true,name=i3_2,role=[use(none,in_hierarchy,[neighbours],array(1,4))]],[curve=[-5,4]]).
arc(arc00423,node00184,node00183,influence,[attached=[],name=i10],[]).
arc(arc00167,node00484,node00184,influence,[attached=[],complete=true,name=i32,role=[use(none,in_hierarchy,fire,boolean)]],[curve=[31,-29]]).
arc(arc00168,node00183,node00195,influence,[attached=[],complete=true,name=i33],[curve=[23,14]]).
arc(arc00434,node00199,node00198,influence,[attached=[],name=i1_0],[]).
arc(arc00435,node00200,node00199,influence,[attached=[],complete=true,name=i3_0,role=[use(none,in_hierarchy,[[neighbours]],array(array(1,4),size(patch_results)))]],[curve=[-5,0]]).
arc(arc00217,node00482,node00201,influence,[attached=[],complete=true,name=i6_1],[curve=[0,10]]).
arc(arc00409,node00481,node00480,influence,[attached=[],name=i1],[]).
arc(arc00234,node00479,node00481,influence,[attached=[],complete=true,name=i2_0,role=[use(none,in_hierarchy,[fuel_load],array(1,size(patch)))]],[curve=[2,23]]).
arc(arc00022,node00480,node00482,flow,[attached=[node00483],complete=true,name=burning_losses],[caption_offset=[-48,-38],curve=[550,1000]]).
arc(arc00430,node00194,node00482,influence,[attached=[],name=i1_3],[]).
arc(arc00412,node00485,node00484,influence,[attached=[],name=i3],[]).
arc(arc00413,node00486,node00485,influence,[attached=[],complete=true,name=i14,role=[use(none,in_hierarchy,new_fire,boolean)]],[curve=[-5,-1]]).
arc(arc00415,node00488,node00485,influence,[attached=[],complete=true,name=i15,role=[use(none,in_hierarchy,crossover,boolean)]],[curve=[-9,7]]).
arc(arc00414,node00487,node00486,influence,[attached=[],name=i4],[]).
arc(arc00418,node00491,node00487,influence,[attached=[],complete=true,name=i17,role=[use(none,in_hierarchy,starts,boolean)]],[curve=[-10,7]]).
arc(arc00420,node00493,node00487,influence,[attached=[],complete=true,name=i16,role=[use(none,in_hierarchy,spark_here,boolean)]],[curve=[-19,0]]).
arc(arc00416,node00174,node00488,influence,[attached=[],name=i5],[]).
arc(arc00417,node00490,node00489,influence,[attached=[],name=i6],[]).
arc(arc00161,node00480,node00490,influence,[attached=[],complete=true,name=i26,role=[use(none,in_hierarchy,fuel_load,1)]],[curve=[11,-11]]).
arc(arc00426,node00188,node00490,influence,[attached=[],complete=true,name=i20,role=[use(none,in_hierarchy,always_catch,int)]],[curve=[4,15]]).
arc(arc00427,node00189,node00490,influence,[attached=[],complete=true,name=i23,role=[use(none,in_hierarchy,min_for_fire,int)]],[curve=[-27,-4]]).
arc(arc00419,node00492,node00491,influence,[attached=[],name=i7],[]).
arc(arc00166,node00480,node00492,influence,[attached=[],complete=true,name=i31,role=[use(none,in_hierarchy,fuel_load,1)]],[curve=[6,8]]).
arc(arc00428,node00190,node00492,influence,[attached=[],complete=true,name=i27,role=[use(none,in_hierarchy,always_starts,int)]],[curve=[3,-17]]).
arc(arc00429,node00191,node00492,influence,[attached=[],complete=true,name=i30,role=[use(none,in_hierarchy,min_for_fire,int)]],[curve=[-17,18]]).
arc(arc00421,node00180,node00493,influence,[attached=[],name=i8],[]).
node(node00483,function,[],[complete=true,name=fn2,units=1/day,value=(if fire then fuel_load*burnt_per_step/dt(2) else 0)],[along=557]).
arc(arc00410,node00480,node00483,influence,[attached=[],complete=true,name=i8_0,role=[use(none,in_hierarchy,fuel_load,1)]],[curve=[-13,6]]).
arc(arc00411,node00484,node00483,influence,[attached=[],complete=true,name=i9_0,role=[use(none,in_hierarchy,fire,boolean)]],[curve=[39,20]]).
arc(arc00425,node00187,node00483,influence,[attached=[],complete=true,name=i10_0,role=[use(none,in_hierarchy,burnt_per_step,1)]],[curve=[2,2]]).
arc(arc00111,node00146,node00145,influence,[attached=[],name=i11],[]).
arc(arc00445,node00476,node00146,influence,[attached=[],complete=true,name=i22,role=[use(none,in_hierarchy,spark_,boolean)]],[curve=[-6,-5]]).
arc(arc00439,node00464,node00151,influence,[attached=[],complete=true,name=i1_0],[curve=[5,-12]]).
arc(arc00159,node00471,node00463,influence,[attached=[],complete=true,name=i24],[curve=[-16,17]]).
arc(arc00173,node00466,node00463,influence,[attached=[],complete=true,name=i2_0],[curve=[-8,0]]).
arc(arc00180,node00475,node00463,influence,[attached=[],complete=true,name=i19],[curve=[-18,-7]]).
arc(arc00235,node00257,node00463,influence,[attached=[],complete=true,name=i3_0],[curve=[1,13]]).
arc(arc00436,node00145,node00463,influence,[attached=[],complete=true,name=i25],[curve=[-5,-4]]).
arc(arc00442,node00155,node00463,influence,[attached=[],complete=true,name=i11_0],[curve=[1,8]]).
arc(arc00443,node00470,node00463,influence,[attached=[],complete=true,name=i21],[curve=[1,8]]).
arc(arc00444,node00472,node00463,influence,[attached=[],complete=true,name=i28],[curve=[1,-9]]).
arc(arc00446,node00477,node00463,influence,[attached=[],complete=true,name=i4],[curve=[-17,-1]]).
arc(arc00437,node00465,node00464,influence,[attached=[],name=i12],[]).
arc(arc00134,node00466,node00465,influence,[attached=[],complete=true,name=i1,role=[use(none,in_hierarchy,[other_fires],array(boolean,size(fire_patch)))]],[curve=[0,11]]).
arc(arc00113,node00467,node00466,influence,[attached=[],name=i13],[]).
arc(arc00438,node00463,node00467,influence,[attached=[],complete=true,name=i34,role=[use(none,in_hierarchy,[old_fire],array(boolean,size(fire_patch)))]],[curve=[6,-1]]).
arc(arc00440,node00469,node00468,influence,[attached=[],name=i20],[]).
arc(arc00170,node00464,node00469,influence,[attached=[],complete=true,name=i2,role=[use(none,in_hierarchy,burning,boolean)]],[curve=[-3,21]]).
arc(arc00441,node00145,node00469,influence,[attached=[],complete=true,name=i3,role=[use(none,in_hierarchy,check_spark,boolean)]],[curve=[-3,7]]).
arc(arc00218,node00463,node00478,influence,[attached=[],complete=true,name=i7],[curve=[18,-3]]).
arc(arc00465,node00456,node00134,influence,[attached=[],name=i13],[]).
arc(arc00471,node00462,node00254,influence,[attached=[],complete=true,name=i5_1],[curve=[2,-5]]).
arc(arc00157,node00451,node00448,influence,[attached=[],complete=true,name=i22],[curve=[-1,-1]]).
arc(arc00236,node00258,node00448,influence,[attached=[],complete=true,name=i4],[curve=[1,11]]).
arc(arc00447,node00449,node00448,influence,[attached=[],complete=true,name=i20],[curve=[-5,-3]]).
arc(arc00448,node00449,node00448,influence,[attached=[],complete=true,name=i23],[curve=[-5,-6]]).
arc(arc00452,node00450,node00448,influence,[attached=[],complete=true,name=i5],[curve=[-7,0]]).
arc(arc00460,node00452,node00448,influence,[attached=[],complete=true,name=i12],[curve=[-2,2]]).
arc(arc00462,node00454,node00448,influence,[attached=[],complete=true,name=i29],[curve=[1,0]]).
arc(arc00464,node00134,node00448,influence,[attached=[],complete=true,name=i25],[curve=[-3,0]]).
arc(arc00203,node00458,node00450,influence,[attached=[],complete=true,name=i13_0],[curve=[0,-5]]).
arc(arc00205,node00460,node00450,influence,[attached=[],complete=true,name=i15],[curve=[-1,-5]]).
arc(arc00459,node00112,node00451,influence,[attached=[],name=i17],[]).
arc(arc00461,node00453,node00452,influence,[attached=[],name=i18],[]).
arc(arc00463,node00455,node00454,influence,[attached=[],name=i19],[]).
arc(arc00200,node00459,node00458,influence,[attached=[],name=i10],[]).
arc(arc00201,node00461,node00460,influence,[attached=[],name=i11],[]).
arc(arc00220,node00448,node00462,influence,[attached=[],complete=true,name=i9],[curve=[9,-1]]).
arc(arc00466,node00448,node00462,influence,[attached=[],complete=true,name=i3_0],[curve=[6,9]]).
node(node00070,border,[],[name=var5],[along=651]).
node(node00110,border,[],[name=var12],[along=707]).
node(node00433,condition,[],[comment='abs(row-row_0)<=1 and abs(col-col_0)<=1 and! (row==row_0 and col==col_0)',complete=true,name='neighbour\ncondition'],[caption_offset=[ 0.0, 0.0],centre=[ 39.561, 119.991]]).
node(node00434,function,[],[complete=true,name=fn3,units=boolean,value=(abs(row-row_0)+abs(col-col_0)==1)],[]).
node(node00435,variable,[],[complete=true,name=interflow],[caption_offset=[ 1.992, -2.988],centre=[ 37.632, 285.692]]).
node(node00436,function,[],[complete=true,name=fn4,units=1,value=max(0, 0.005*elevation_diff*water)],[]).
node(node00437,border,[],[name=var7],[along=619]).
node(node00438,border,[],[name=var11],[along=295]).
node(node00439,variable,[],[complete=true,name=elevation_diff],[caption_offset=[ 2.96, -30.741],centre=[ 35.649, 213.209]]).
node(node00440,function,[],[complete=true,name=fn1,units=1,value=elevation-elevation_0],[]).
node(node00441,border,[],[name=var4],[along=332]).
node(node00442,variable,[],[complete=true,name=water],[caption_offset=[ 0.0, -32.732],centre=[ 28.749, 252.904]]).
node(node00443,function,[],[complete=true,name=fn3_0,units=1,value=water],[]).
node(node00444,border,[],[name=var8],[along=307]).
node(node00445,variable,[],[complete=true,name='seeds\ntransfer'],[caption_offset=[ 14.878, 6.943],centre=[ 26.686, 37.716]]).
node(node00446,function,[],[complete=true,name=fn4_0,units=array(1,size(plant_species)),value=[seeds_dispersing]],[]).
node(node00447,border,[],[name=var17],[along=688]).
arc(arc00393,node00434,node00433,influence,[attached=[],name=i3],[]).
arc(arc00395,node00070,node00434,influence,[attached=[],complete=true,name=i6,role=[use(0,in_base,row,int),use(1,in_base,row_0,int)]],[curve=[1,-2]]).
arc(arc00396,node00437,node00434,influence,[attached=[],complete=true,name=i9,role=[use(0,in_base,col,1),use(1,in_base,col_0,1)]],[curve=[0,-4]]).
arc(arc00394,node00436,node00435,influence,[attached=[],name=i4],[]).
arc(arc00092,node00442,node00436,influence,[attached=[],complete=true,name=i13,role=[use(none,in_hierarchy,water,1)]],[curve=[5,-2]]).
arc(arc00093,node00439,node00436,influence,[attached=[],complete=true,name=i14,role=[use(none,in_hierarchy,elevation_diff,1)]],[curve=[17,-1]]).
arc(arc00397,node00435,node00438,influence,[attached=[],complete=true,name=i15],[curve=[2,10]]).
arc(arc00398,node00440,node00439,influence,[attached=[],name=i1],[]).
arc(arc00399,node00441,node00440,influence,[attached=[],complete=true,name=i4_0,role=[use(0,in_base,elevation,1),use(1,in_base,elevation_0,1)]],[curve=[-2,-8]]).
arc(arc00400,node00443,node00442,influence,[attached=[],name=i8],[]).
arc(arc00401,node00444,node00443,influence,[attached=[],complete=true,name=i11,role=[use(0,in_base,water,1),use(1,in_base,water_0,1)]],[curve=[-3,-7]]).
arc(arc00402,node00446,node00445,influence,[attached=[],name=i13_0],[]).
arc(arc00403,node00110,node00446,influence,[attached=[],complete=true,name=i17,role=[use(0,in_base,[seeds_dispersing],array(1,size(plant_species))),use(1,in_base,[seeds_dispersing_0],array(1,size(plant_species)))]],[curve=[-1,-4]]).
arc(arc00404,node00445,node00447,influence,[attached=[],complete=true,name=i24],[curve=[1,5]]).
node(node00125,border,[],[name=var23],[along=691]).
node(node00246,variable,[],[complete=true,name='fuel\nload'],[caption_offset=[ -20.826, -28.773],centre=[ 10.911, 264.835]]).
node(node00247,function,[],[complete=true,max_val=5000,min_val=0,name=fn2_1,units=1,value=sum([number]*[fuel_per_indiv])],[]).
node(node00249,border,[],[name=var4_0],[along=447]).
node(node00250,variable,[],[complete=true,name='fuel\nlost'],[caption_offset=[ 19.838, -17.854],centre=[ 8.927, 321.372]]).
node(node00251,function,[],[complete=true,name=fn3,units=1,value=element([fuel_lost],index(1))],[]).
node(node00252,variable,[],[complete=true,name='fraction\nlost'],[caption_offset=[ -24.781, -18.874],centre=[ 15.87, 294.591]]).
node(node00253,function,[],[complete=true,name=fn4,units=1,value=fuel_lost/fuel_load],[]).
node(node00256,border,[],[name=var9],[along=411]).
node(node00355,variable,[],[complete=true,name=row],[caption_offset=[ 0.0, 0.0],centre=[ 336.251, 192.427]]).
node(node00356,submodel,[node00124,node00186,node00233,node00236,node00241,node00243,node00248,node00255,node00259,node00260,node00261,node00262,node00269,node00376,node00377,node00378,node00379,node00380,node00381,node00382,node00383,node00384],[complete=true,fill_colour='#80ff80',multiplication_spec=[count=[]],name=plants,separate=0],[bounding_box=[ 25.84, 27.713, 317.138, 261.33],caption_offset=[ 23.746, -8.919],internal_extent=[ 9.919, 0.0, 301.217, 233.617]]).
links(node00356,[arc00250-arc00249,arc00347-arc00099,arc00353-arc00047,arc00353-arc00223,arc00369-arc00345,arc00370-arc00346,arc00380-arc00348,arc00381-arc00349,arc00382-arc00350,arc00383-arc00351]).
references(node00356,[ancestor(0),ancestor(1),ancestor(2),ancestor(3)]).
node(node00357,submodel,[node00263,node00264,node00265,node00266,node00415,node00416,node00417,node00419,node00421,node00423,node00425,node00427,node00428,node00429,node00430,node00431,node00432],[complete=true,fill_colour='#80ffff',multiplication_spec=[count=[]],name=soil_water,separate=0],[bounding_box=[ 49.697, 286.194, 312.143, 401.467],caption_offset=[ 6.959, -7.953],internal_extent=[ 0.0, 0.0, 262.446, 115.273]]).
links(node00357,[arc00047-arc00245,arc00078-arc00365,arc00078-arc00366,arc00367-arc00250,arc00367-arc00377,arc00371-arc00246,arc00372-arc00362]).
references(node00357,[ancestor(0),ancestor(1)]).
node(node00358,border,[],[name=var1],[along=485]).
node(node00359,function,[],[complete=true,name=fn1,units=int,value=floor((index(1)-1)/15)+1],[]).
node(node00360,border,[],[],[along=544]).
node(node00361,border,[],[],[along=806]).
node(node00362,border,[],[],[along=399]).
node(node00363,border,[],[],[along=384]).
node(node00364,variable,[],[complete=true,name=col],[caption_offset=[ -3.968, -1.984],centre=[ 335.259, 227.143]]).
node(node00365,function,[],[complete=true,name=fn2,units=1,value=fmod(index(1)-1,15)+1],[]).
node(node00366,border,[],[name=var13],[along=113]).
node(node00367,variable,[],[complete=true,name=elevation],[caption_offset=[ -30.749, -14.878],centre=[ 337.243, 276.737]]).
node(node00368,function,[],[complete=true,max_val=300,min_val=0,name=fn2_0,units=1,value=200-10*col*sin( 0.7*row)],[]).
node(node00369,border,[],[name=var3],[along=64]).
node(node00370,border,[],[name=var7],[along=100]).
node(node00371,border,[],[name=var2],[along=970]).
node(node00372,border,[],[name=var4],[along=0]).
node(node00373,border,[],[name=var11],[along=909]).
node(node00374,border,[],[name=var20],[along=935]).
node(node00375,border,[],[name=var26],[along=735]).
node(node00263,function,[],[complete=true,name=fn1_1,units=1,value=sum([water_use]*[number])],[]).
node(node00264,border,[],[name=var2],[along=669]).
node(node00265,border,[],[name=var3],[along=518]).
node(node00266,border,[],[name=var2_0],[along=925]).
node(node00415,compartment,[],[comment='if index(1)==int(rand_const(1,225))then 10000 else 0',complete=true,name=water],[caption_offset=[ 0.0, 0.0],centre=[ 116.343, 58.615]]).
node(node00416,function,[],[complete=true,max_val=1000,min_val=0,name=fn1,units=1,value=100],[]).
node(node00417,cloud,[],[complete=true,name=cd1],[centre=[ 27.671, 18.317]]).
node(node00419,cloud,[],[complete=true,name=cd2],[centre=[ 30.646, 64.935]]).
node(node00421,cloud,[],[complete=true,name=cd3],[centre=[ 242.911, 66.919]]).
node(node00423,cloud,[],[complete=true,name=cd4],[centre=[ 234.976, 22.284]]).
node(node00425,cloud,[],[complete=true,name=cd5],[centre=[ 213.154, 100.644]]).
node(node00427,variable,[],[complete=true,name='water demand'],[caption_offset=[ -2.0, -2.0],centre=[ 116.198, 15.303]]).
node(node00428,border,[],[name=var7],[along=488]).
node(node00429,variable,[],[complete=true,name='water display'],[caption_offset=[ 0.0, 0.0],centre=[ 93.135, 93.7]]).
node(node00430,function,[],[complete=true,max_val=200,min_val=0,name=fn1_0,units=1,value=water],[]).
node(node00431,border,[],[name=var12],[along=970]).
node(node00432,border,[],[name=var9],[along=970]).
arc(arc00245,node00264,node00263,influence,[attached=[],complete=true,name=i2_1,role=[use(none,in_hierarchy,[number],array(1,size(plant_species)))]],[curve=[3,-3]]).
arc(arc00246,node00265,node00263,influence,[attached=[],complete=true,name=i3_0,role=[use(none,in_hierarchy,[water_use],array(1,size(plant_species)))]],[curve=[-7,-28]]).
arc(arc00367,node00415,node00266,influence,[attached=[],complete=true,name=i9_0],[curve=[-12,-27]]).
arc(arc00354,node00416,node00415,influence,[attached=[],name=i1],[]).
arc(arc00355,node00417,node00415,flow,[attached=[node00418],complete=true,name=rain],[caption_offset=[-25,-38],curve=[550,1000]]).
arc(arc00356,node00419,node00415,flow,[attached=[node00420],complete=true,name=inflow],[caption_offset=[-22,2],curve=[550,1000]]).
arc(arc00357,node00415,node00421,flow,[attached=[node00422],complete=true,name=outflow],[caption_offset=[-24,-3],curve=[550,1000]]).
arc(arc00358,node00415,node00423,flow,[attached=[node00424],comment='If there is plenty of water available, evapotranspiration is equal to the total vegetation water demand.  Otherwise, it is reduced pro rata, depending on water availability.',complete=true,description='Evapotranspiration (mm/month)',name=evapotransp],[caption_offset=[-29,-38],curve=[550,1000]]).
arc(arc00360,node00415,node00425,flow,[attached=[node00426],complete=true,name=drainage],[caption_offset=[-26,1],curve=[550,1000]]).
arc(arc00244,node00263,node00427,influence,[attached=[],name=i1_1],[]).
arc(arc00363,node00430,node00429,influence,[attached=[],name=i1_0],[]).
arc(arc00364,node00415,node00430,influence,[attached=[],complete=true,name=i2_0,role=[use(none,in_hierarchy,water,1)]],[curve=[3,2]]).
node(node00418,function,[],[complete=true,name=fn2,units=int,value=rain],[along=500]).
node(node00420,function,[],[complete=true,name=fn3,units=1/day,value=sum({interflow_0})],[along=500]).
node(node00422,function,[],[complete=true,name=fn4,units=1/day,value=sum({interflow})],[along=818]).
node(node00424,function,[],[complete=true,name=fn5,units=1/day,value=(if water>100 then water_demand else water_demand*water/100)],[along=500]).
node(node00426,function,[],[complete=true,name=fn6,units=1/day,value= 0.2 *water],[along=509]).
arc(arc00362,node00428,node00418,influence,[attached=[],complete=true,name=i17,role=[use(none,in_hierarchy,rain,int)]],[curve=[-4,-16]]).
arc(arc00365,node00431,node00420,influence,[attached=[],complete=true,name=i16_0,role=[use(0,in_assoc,{interflow},list(1)),use(1,in_assoc,{interflow_0},list(1))]],[curve=[7,46]]).
arc(arc00366,node00432,node00422,influence,[attached=[],complete=true,name=i15_0,role=[use(0,in_assoc,{interflow},list(1)),use(0,in_assoc,{interflow_0},list(1)),use(1,in_assoc,{interflow_1},list(1)),use(1,in_assoc,{interflow_2},list(1))]],[curve=[5,9]]).
arc(arc00247,node00427,node00424,influence,[attached=[],complete=true,name=i4_0,role=[use(none,in_hierarchy,water_demand,1),use(none,in_hierarchy,water_demand_0,1)]],[curve=[5,-13]]).
arc(arc00359,node00415,node00424,influence,[attached=[],complete=true,name=i11,role=[use(none,in_hierarchy,water,1)]],[curve=[-3,-10]]).
arc(arc00361,node00415,node00426,influence,[attached=[],complete=true,name=i15,role=[use(none,in_hierarchy,water,1)]],[curve=[3,-7]]).
node(node00124,border,[],[name=var22],[along=688]).
node(node00186,variable,[],[complete=true,name=n1],[caption_offset=[ 0.0, 0.0],centre=[ 133.854, 216.292]]).
node(node00233,function,[],[complete=true,max_val=200,min_val=0,name=fn1,units=1,value=element([number],1)],[]).
node(node00236,variable,[],[complete=true,name=n2],[caption_offset=[ 0.0, 0.0],centre=[ 162.619, 214.308]]).
node(node00241,function,[],[complete=true,max_val=200,min_val=0,name=fn2,units=1,value=element([number],2)],[]).
node(node00243,variable,[],[complete=true,name=n3],[caption_offset=[ 0.0, 0.0],centre=[ 198.327, 213.316]]).
node(node00248,border,[],[name=var3_0],[along=315]).
node(node00255,function,[],[complete=true,max_val=200,min_val=0,name=fn3,units=1,value=element([number],3)],[]).
node(node00259,variable,[],[complete=true,name=n4],[caption_offset=[ 0.0, 0.0],centre=[ 232.051, 215.3]]).
node(node00260,function,[],[complete=true,max_val=200,min_val=0,name=fn4_0,units=1,value=element([number],4)],[]).
node(node00261,variable,[],[complete=true,name=n5],[caption_offset=[ 0.0, 0.0],centre=[ 264.784, 213.316]]).
node(node00262,function,[],[complete=true,max_val=200,min_val=0,name=fn5,units=1,value=element([number],5)],[]).
node(node00269,border,[],[name=var4],[along=156]).
node(node00376,submodel,[node00069,node00123,node00136,node00267,node00268,node00385,node00386,node00387,node00389,node00391,node00392,node00394,node00395,node00396,node00397,node00398,node00399,node00400,node00401,node00402,node00403,node00404,node00405,node00406,node00407,node00408,node00410,node00411,node00412,node00413,node00414],[complete=true,fill_colour='#ffffff',multiplication_spec=[count=[5]],name=plant_species,separate=0],[bounding_box=[ 21.868, 19.902, 272.385, 184.892],caption_offset=[ 41.728, -7.955],internal_extent=[ 0.0, 43.741, 250.517, 208.731]]).
links(node00376,[arc00249-arc00248,arc00334-arc00347,arc00341-arc00237,arc00341-arc00238,arc00341-arc00241,arc00341-arc00242,arc00341-arc00243,arc00341-arc00344,arc00341-arc00353,arc00342-arc00318,arc00345-arc00321,arc00346-arc00324,arc00348-arc00338,arc00349-arc00335,arc00350-arc00336,arc00351-arc00340]).
references(node00376,[ancestor(0),ancestor(1),ancestor(2),ancestor(3)]).
node(node00377,variable,[],[complete=true,name=numbers],[caption_offset=[ -30.749, -12.895],centre=[ 86.524, 211.733]]).
node(node00378,function,[],[complete=true,name=fn4,units=array(1,5),value=[number]],[]).
node(node00379,border,[],[],[along=489]).
node(node00380,border,[],[],[along=845]).
node(node00381,border,[],[name=var10],[along=939]).
node(node00382,border,[],[name=var19],[along=998]).
node(node00383,border,[],[name=var25],[along=756]).
node(node00384,border,[],[name=var2],[along=394]).
node(node00069,variable,[],[complete=true,name=seeds_produced],[caption_offset=[ 0.0, 0.0],centre=[ 113.97, 68.534]]).
node(node00123,border,[],[name=var21],[along=700]).
node(node00136,border,[],[name=var1],[along=381]).
node(node00267,border,[],[name=var10_0],[along=201]).
node(node00268,border,[],[name=var3],[along=254]).
node(node00385,compartment,[],[complete=true,name=number],[caption_offset=[ 13.886, -44.635],centre=[ 131.223, 118.3]]).
node(node00386,function,[],[complete=true,name=fn1,units=1,value=5],[]).
node(node00387,cloud,[],[complete=true,name=cd1],[centre=[ 23.859, 114.323]]).
node(node00389,cloud,[],[complete=true,name=cd2],[centre=[ 228.646, 117.305]]).
node(node00391,variable,[],[complete=true,name=feedback],[caption_offset=[ -9.115, 0.022],centre=[ 48.629, 156.011]]).
node(node00392,function,[],[complete=true,name=fn5,units=1,value=sum([c]*[numbers])],[]).
node(node00394,border,[],[name=var5],[along=366]).
node(node00395,variable,[],[complete=true,name=c],[caption_offset=[ 0.0, 0.0],centre=[ 18.828, 143.116]]).
node(node00396,function,[],[complete=true,name=fn7,units=array(1,5),value=element([[cs]],index(1))],[]).
node(node00397,variable,[],[complete=true,name='seeds\nstaying'],[caption_offset=[ -14.878, 0.992],centre=[ 51.48, 70.518]]).
node(node00398,border,[],[name=var10],[along=477]).
node(node00399,variable,[],[complete=true,name=m],[caption_offset=[ 0.0, 0.0],centre=[ 210.694, 75.559]]).
node(node00400,function,[],[complete=true,name=fn11,units=1,value=element([ms],index(1))],[]).
node(node00401,border,[],[name=var13],[along=880]).
node(node00402,function,[],[complete=true,name=fn2_0,units=1,value=seeds_produced-seeds_dispersing],[]).
node(node00403,variable,[],[comment='If there is plenty of soil water (>100 mm), then the multiplier for the recruitment of new plants is 1 (i.e. no reduction).\nIf the soil is dry (<50 mm), then no recruitment takes place.\nOtherwise, recruitment is reduced proportionally over the range 50-100 mm soil water.',complete=true,description='Reproduction multiplier for water',name='water\nmultiplier'],[caption_offset=[ -14.0, -10.0],centre=[ 80.105, 185.623]]).
node(node00404,function,[],[complete=true,name=fn1_2,units=1,value=(if water>100 then 1 elseif water<50 then 0 else (water-50)/50)],[]).
node(node00405,variable,[],[complete=true,name='seeds\ndispersing'],[caption_offset=[ 17.854, -37.692],centre=[ 165.548, 72.501]]).
node(node00406,function,[],[complete=true,name=fn1_0,units=1,value=element([seeds_per_indiv],index(1))*number],[]).
node(node00407,function,[],[complete=true,name=fn3_0,units=1,value=seeds_produced*element([dispersability],index(1))],[]).
node(node00408,cloud,[],[complete=true,name=cd1_0],[centre=[ 123.888, 188.553]]).
node(node00410,border,[],[name=var9],[along=938]).
node(node00411,border,[],[name=var18],[along=31]).
node(node00412,border,[],[name=var24],[along=774]).
node(node00413,variable,[],[complete=true,name=seeds_in],[caption_offset=[ 0.0, 0.0],centre=[ 209.191, 154.828]]).
node(node00414,function,[],[complete=true,name=fn5_0,units=1,value=element(sum({[seeds_transfer_0]}),index(1))],[]).
arc(arc00328,node00406,node00069,influence,[attached=[],name=i1_0],[]).
arc(arc00341,node00385,node00267,influence,[attached=[],complete=true,name=i5],[curve=[19,-4]]).
arc(arc00312,node00386,node00385,influence,[attached=[],name=i1],[]).
arc(arc00313,node00387,node00385,flow,[attached=[node00388],complete=true,name=reproduction],[caption_offset=[-14,0],curve=[550,1000]]).
arc(arc00314,node00385,node00389,flow,[attached=[node00390],complete=true,name=mortality],[caption_offset=[-15,-2],curve=[550,1000]]).
arc(arc00317,node00392,node00391,influence,[attached=[],name=i8],[]).
arc(arc00318,node00394,node00392,influence,[attached=[],complete=true,name=i10,role=[use(none,in_hierarchy,[numbers],array(1,5))]],[curve=[-12,3]]).
arc(arc00319,node00395,node00392,influence,[attached=[],complete=true,name=i19,role=[use(none,in_hierarchy,[c],array(1,5))]],[curve=[2,-4]]).
arc(arc00320,node00396,node00395,influence,[attached=[],name=i12],[]).
arc(arc00321,node00398,node00396,influence,[attached=[],complete=true,name=i17,role=[use(none,in_hierarchy,[[cs]],array(array(1,5),5))]],[curve=[-1,-2]]).
arc(arc00325,node00402,node00397,influence,[attached=[],name=i2_0],[]).
arc(arc00323,node00400,node00399,influence,[attached=[],name=i24],[]).
arc(arc00324,node00401,node00400,influence,[attached=[],complete=true,name=i25,role=[use(none,in_hierarchy,[ms],array(1,5))]],[curve=[8,-9]]).
arc(arc00326,node00405,node00402,influence,[attached=[],complete=true,name=i10_0,role=[use(none,in_hierarchy,seeds_dispersing,1)]],[curve=[-1,19]]).
arc(arc00327,node00069,node00402,influence,[attached=[],complete=true,name=i9,role=[use(none,in_hierarchy,seeds_produced,1)]],[curve=[1,11]]).
arc(arc00046,node00404,node00403,influence,[attached=[],name=i1_2],[]).
arc(arc00248,node00268,node00404,influence,[attached=[],complete=true,name=i3_0,role=[use(none,in_hierarchy,water,1)]],[curve=[-5,9]]).
arc(arc00330,node00407,node00405,influence,[attached=[],name=i3_1],[]).
arc(arc00329,node00385,node00406,influence,[attached=[],complete=true,name=i7_0,role=[use(none,in_hierarchy,number,1)]],[curve=[-4,2]]).
arc(arc00335,node00123,node00406,influence,[attached=[],complete=true,name=i29,role=[use(none,in_hierarchy,[seeds_per_indiv],array(1,5))]],[curve=[5,-4]]).
arc(arc00331,node00069,node00407,influence,[attached=[],complete=true,name=i11,role=[use(none,in_hierarchy,seeds_produced,1)]],[curve=[1,-3]]).
arc(arc00336,node00412,node00407,influence,[attached=[],complete=true,name=i33,role=[use(none,in_hierarchy,[dispersability],array(1,5))]],[curve=[-1,1]]).
arc(arc00332,node00385,node00408,flow,[attached=[node00409],complete=true,name=burnt],[caption_offset=[0,-8],curve=[550,1000]]).
arc(arc00334,node00405,node00410,influence,[attached=[],complete=true,name=i14],[curve=[0,-20]]).
arc(arc00339,node00414,node00413,influence,[attached=[],name=i16],[]).
arc(arc00338,node00411,node00414,influence,[attached=[],complete=true,name=i25_0,role=[use(0,in_assoc,{[seeds_transfer]},list(array(1,size(plant_species)))),use(1,in_assoc,{[seeds_transfer_0]},list(array(1,size(plant_species))))]],[curve=[5,13]]).
node(node00388,function,[],[complete=true,name=fn2,units=1/day,value= 0.01 *(seeds_staying+seeds_in)*(1-feedback)*water_multiplier],[along=494]).
node(node00390,function,[],[complete=true,name=fn3,units=1/day,value=m*number],[along=492]).
node(node00409,function,[],[complete=true,name=fn1_1,units=1/day,value=fraction_lost*number],[along=510]).
arc(arc00049,node00403,node00388,influence,[attached=[],complete=true,name=i2_2,role=[use(none,in_hierarchy,water_multiplier,1)]],[curve=[-13,1]]).
arc(arc00095,node00397,node00388,influence,[attached=[],complete=true,name=i12_0,role=[use(none,in_hierarchy,seeds_staying,1)]],[curve=[7,-4]]).
arc(arc00316,node00391,node00388,influence,[attached=[],complete=true,name=i22,role=[use(none,in_hierarchy,feedback,1)]],[curve=[-10,1]]).
arc(arc00337,node00413,node00388,influence,[attached=[],complete=true,name=i22_0,role=[use(none,in_hierarchy,seeds_in,1)]],[curve=[-12,24]]).
arc(arc00315,node00385,node00390,influence,[attached=[],complete=true,name=i7,role=[use(none,in_hierarchy,number,1)]],[curve=[0,-7]]).
arc(arc00322,node00399,node00390,influence,[attached=[],complete=true,name=i27,role=[use(none,in_hierarchy,m,1)]],[curve=[8,-3]]).
arc(arc00333,node00385,node00409,influence,[attached=[],complete=true,name=i5_0,role=[use(none,in_hierarchy,number,1)]],[curve=[4,0]]).
arc(arc00340,node00136,node00409,influence,[attached=[],complete=true,name=i2_1,role=[use(none,in_hierarchy,fraction_lost,1)]],[curve=[13,-4]]).
arc(arc00352,node00233,node00186,influence,[attached=[],name=i1],[]).
arc(arc00237,node00376,node00233,influence,[attached=[],complete=true,name=i6_0,role=[use(none,in_hierarchy,[number],array(1,size(plant_species)))]],[curve=[7,7]]).
arc(arc00215,node00241,node00236,influence,[attached=[],name=i2],[]).
arc(arc00238,node00376,node00241,influence,[attached=[],complete=true,name=i7,role=[use(none,in_hierarchy,[number],array(1,size(plant_species)))]],[curve=[6,1]]).
arc(arc00216,node00255,node00243,influence,[attached=[],name=i3_0],[]).
arc(arc00353,node00376,node00248,influence,[attached=[],complete=true,name=i8],[curve=[12,17]]).
arc(arc00241,node00376,node00255,influence,[attached=[],complete=true,name=i8_0,role=[use(none,in_hierarchy,[number],array(1,size(plant_species)))]],[curve=[6,-6]]).
arc(arc00228,node00260,node00259,influence,[attached=[],name=i4_0],[]).
arc(arc00242,node00376,node00260,influence,[attached=[],complete=true,name=i9,role=[use(none,in_hierarchy,[number],array(1,size(plant_species)))]],[curve=[7,-12]]).
arc(arc00230,node00262,node00261,influence,[attached=[],name=i5],[]).
arc(arc00243,node00376,node00262,influence,[attached=[],complete=true,name=i10,role=[use(none,in_hierarchy,[number],array(1,size(plant_species)))]],[curve=[8,-20]]).
arc(arc00249,node00269,node00376,influence,[attached=[],complete=true,name=i4_1],[curve=[-13,22]]).
arc(arc00342,node00377,node00376,influence,[attached=[],complete=true,name=i11],[curve=[-9,0]]).
arc(arc00345,node00379,node00376,influence,[attached=[],complete=true,name=i18],[curve=[0,-5]]).
arc(arc00346,node00380,node00376,influence,[attached=[],complete=true,name=i26],[curve=[7,-14]]).
arc(arc00348,node00382,node00376,influence,[attached=[],complete=true,name=i26_0],[curve=[2,7]]).
arc(arc00349,node00124,node00376,influence,[attached=[],complete=true,name=i30],[curve=[7,-6]]).
arc(arc00350,node00383,node00376,influence,[attached=[],complete=true,name=i34],[curve=[6,-5]]).
arc(arc00351,node00384,node00376,influence,[attached=[],complete=true,name=i3],[curve=[0,-3]]).
arc(arc00343,node00378,node00377,influence,[attached=[],name=i4],[]).
arc(arc00344,node00376,node00378,influence,[attached=[],complete=true,name=i6,role=[use(none,in_hierarchy,[number],array(1,size(plant_species)))]],[curve=[7,1]]).
arc(arc00347,node00376,node00381,influence,[attached=[],complete=true,name=i15],[curve=[0,-7]]).
arc(arc00222,node00247,node00246,influence,[attached=[],name=i2_1],[]).
arc(arc00223,node00356,node00247,influence,[attached=[],complete=true,name=i3_0,role=[use(none,in_hierarchy,[number],array(1,size(plant_species)))]],[curve=[-5,5]]).
arc(arc00224,node00249,node00247,influence,[attached=[],complete=true,name=i4,role=[use(none,in_hierarchy,[fuel_per_indiv],array(1,size(plant_species)))]],[curve=[0,0]]).
arc(arc00226,node00251,node00250,influence,[attached=[],name=i6_0],[]).
arc(arc00229,node00256,node00251,influence,[attached=[],complete=true,name=i9,role=[use(none,in_hierarchy,[fuel_lost],array(1,size(fire_patch)))]],[curve=[1,-4]]).
arc(arc00227,node00253,node00252,influence,[attached=[],name=i7_0],[]).
arc(arc00231,node00246,node00253,influence,[attached=[],complete=true,name=i11,role=[use(none,in_hierarchy,fuel_load,1)]],[curve=[1,4]]).
arc(arc00232,node00250,node00253,influence,[attached=[],complete=true,name=i12,role=[use(none,in_hierarchy,fuel_lost,1)]],[curve=[-10,0]]).
arc(arc00368,node00359,node00355,influence,[attached=[],name=i1],[]).
arc(arc00250,node00357,node00356,influence,[attached=[],complete=true,name=i5_0],[curve=[-6,11]]).
arc(arc00369,node00360,node00356,influence,[attached=[],complete=true,name=i18],[curve=[-7,-8]]).
arc(arc00370,node00361,node00356,influence,[attached=[],complete=true,name=i26],[curve=[0,-8]]).
arc(arc00380,node00374,node00356,influence,[attached=[],complete=true,name=i27],[curve=[4,11]]).
arc(arc00381,node00125,node00356,influence,[attached=[],complete=true,name=i31],[curve=[5,-4]]).
arc(arc00382,node00375,node00356,influence,[attached=[],complete=true,name=i35],[curve=[4,-3]]).
arc(arc00383,node00252,node00356,influence,[attached=[],complete=true,name=i4_0],[curve=[6,-5]]).
arc(arc00047,node00356,node00357,influence,[attached=[],complete=true,name=i10],[curve=[6,-7]]).
arc(arc00078,node00366,node00357,influence,[attached=[],complete=true,name=i17],[curve=[5,12]]).
arc(arc00371,node00362,node00357,influence,[attached=[],complete=true,name=i13_0],[curve=[6,5]]).
arc(arc00372,node00363,node00357,influence,[attached=[],complete=true,name=i18_0],[curve=[-4,-9]]).
arc(arc00233,node00246,node00358,influence,[attached=[],complete=true,name=i1_0],[curve=[7,-1]]).
arc(arc00373,node00365,node00364,influence,[attached=[],name=i2],[]).
arc(arc00081,node00368,node00367,influence,[attached=[],name=i2_0],[]).
arc(arc00374,node00355,node00368,influence,[attached=[],complete=true,name=i6,role=[use(none,in_hierarchy,row,int)]],[curve=[33,-5]]).
arc(arc00375,node00364,node00368,influence,[attached=[],complete=true,name=i7,role=[use(none,in_hierarchy,col,1)]],[curve=[18,7]]).
arc(arc00376,node00367,node00369,influence,[attached=[],complete=true,name=i3],[curve=[0,-4]]).
arc(arc00377,node00357,node00370,influence,[attached=[],complete=true,name=i10_0],[curve=[-4,-14]]).
arc(arc00378,node00355,node00371,influence,[attached=[],complete=true,name=i5],[curve=[2,-3]]).
arc(arc00379,node00364,node00372,influence,[attached=[],complete=true,name=i8],[curve=[1,-3]]).
arc(arc00099,node00356,node00373,influence,[attached=[],complete=true,name=i16],[curve=[0,-12]]).
arc(arc00221,node00245,node00244,influence,[attached=[],name=i1_0],[]).
arc(arc00305,node00335,node00334,influence,[attached=[],name=i14],[]).
arc(arc00306,node00337,node00336,influence,[attached=[],name=i23],[]).
arc(arc00307,node00339,node00338,influence,[attached=[],name=i7],[]).
arc(arc00225,node00244,node00341,influence,[attached=[],complete=true,name=i5_0],[curve=[5,1]]).
arc(arc00239,node00354,node00341,influence,[attached=[],complete=true,name=i10_0],[curve=[-31,-27]]).
arc(arc00308,node00334,node00341,influence,[attached=[],complete=true,name=i18],[curve=[7,-2]]).
arc(arc00309,node00336,node00341,influence,[attached=[],complete=true,name=i26],[curve=[7,-8]]).
arc(arc00310,node00338,node00341,influence,[attached=[],complete=true,name=i13_0],[curve=[2,-9]]).
arc(arc00311,node00340,node00341,influence,[attached=[],complete=true,name=i18_0],[curve=[-1,-9]]).
arc(arc00388,node00342,node00341,influence,[attached=[],complete=true,name=i18_1],[curve=[3,14]]).
arc(arc00392,node00342,node00341,influence,[attached=[],complete=true,name=i28],[curve=[6,16]]).
arc(arc00405,node00343,node00341,influence,[attached=[],complete=true,name=i32],[curve=[3,-2]]).
arc(arc00407,node00352,node00341,influence,[attached=[],complete=true,name=i36],[curve=[4,-1]]).
arc(arc00384,node00341,node00342,influence,[attached=[],complete=true,name=i7_0],[curve=[4,-15]]).
arc(arc00385,node00341,node00342,influence,[attached=[],complete=true,name=i10],[curve=[2,-15]]).
arc(arc00386,node00341,node00342,relation,[attached=[],complete=true,name=me],[caption_offset=[-1,-10],curve=[-1,-15]]).
arc(arc00387,node00341,node00342,relation,[attached=[],complete=true,name='my\nneighbour'],[caption_offset=[7,17],curve=[-1,-15]]).
arc(arc00389,node00341,node00342,influence,[attached=[],complete=true,name=i5],[curve=[-2,-14]]).
arc(arc00390,node00341,node00342,influence,[attached=[],complete=true,name=i12],[curve=[-4,-15]]).
arc(arc00391,node00341,node00342,influence,[attached=[],complete=true,name=i18_2],[curve=[1,-18]]).
arc(arc00406,node00344,node00343,influence,[attached=[],name=i2],[]).
arc(arc00408,node00353,node00352,influence,[attached=[],name=i1],[]).
arc(arc00240,node00341,node00354,influence,[attached=[],complete=true,name=i5],[curve=[-1,48]]).
