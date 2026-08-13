source(program='AME',version=7.1,edition=enterprise,date='Wed Jun 25 14:27:25 GMT Daylight Time 2003').



roots([node00020,node00021,node00022,node00025,node00026,node00047,node00048,node00053,node00056,node00064,node00099,node00100,node00113,node00127,node00129,node00092,node00094,node00105,node00119,node00121,node00014,node00019,node00244,node00245,node00093,node00232,node00234,node00235,node00237,node00238,node00239,node00240,node00242]).



properties([complete-true,file_name-'C:/Inetpub/wwwroot/www/examples/catalogue/models/bob/lamos1/lamos1a.sml',name-'Desktop',separate-0]).



node(node00020,function,[],[complete=true,name=fn8,units=array(1,5),value=[0.7,0.6,0.25,0.2,0.2]],[]).

node(node00021,variable,[],[complete=true,name=cs],[bounding_box=[-64.64895090510001,80.58615197309999,-50.64895090510001,94.58615197310002],caption_offset=[-1.9917173660000032,-29.875760489799987]]).

node(node00022,function,[],[complete=true,name=fn9,units=array(array(1,5),5),value=[[0.005,0.003,0.006,0.007,0.006],[0.002,0.005,0.006,0.007,0.006],[0.002,0.002,0.005,0.006,0.002],[0.002,0.002,0.003,0.004,0.002],[0.002,0.002,0.003,0.002,0.005]]],[]).

node(node00025,variable,[],[complete=true,name=ms],[bounding_box=[234.89339423110002,-95.41434207059999,248.89339423109993,-81.4143420706],caption_offset=[24.797259326000017,-12.894574849799994]]).

node(node00026,function,[],[complete=true,name=fn10,units=array(1,size(plant_species)),value=[0.1,0.1,0.1,0.1,0.1]],[]).

node(node00047,variable,[],[complete=true,name=water_use],[bounding_box=[-64.47011698850002,273.69703895699996,-50.4701169885,287.69703895699996],caption_offset=[0,0]]).

node(node00048,function,[],[complete=true,name=fn7,units=array(1,size(plant_species)),value=[0.5,0.5,0.5,0.5,0.5]],[]).

node(node00053,variable,[],[complete=true,description='Rainfall (mm/month)',max_val=500,min_val=0,name=rain,units=int,value=100],[bounding_box=[-63.5139414049,317.34815199099995,-49.513941404899995,331.34815199099995],caption_offset=[0,0]]).

node(node00056,submodel,[node00011,node00030,node00034,node00050,node00054,node00058,node00059,node00060,node00061,node00062,node00063,node00078,node00081,node00082,node00083,node00088,node00095,node00097,node00109,node00122,node00125,node00130,node00246,node00247,node00249,node00250,node00251,node00252,node00253,node00256],[complete=true,fill_colour='#ffdfff',fix_math_args=0,multiplication_spec=[count=[225]],name=patch,separate=0],[bounding_box=[-27.772930445560007,-54.553970518799986,345.1341984179999,348.15352094450014],caption_offset=[21.82158820727,-4.959451865300004],hide_contents=0,internal_extent=[-14.878355595860068,6.943232611299725,358.0287732677001,409.65072407460013]]).

links(node00056,[arc00020-arc00057,arc00028-arc00058,arc00050-arc00059,arc00055-arc00060,arc00064-arc00066,arc00067-arc00069,arc00079-arc00078,arc00082-arc00084,arc00089-arc00091,arc00099-arc00108,arc00118-arc00117,arc00122-arc00121,arc00126-arc00125,arc00225-arc00224,arc00233-arc00240,arc00239-arc00229]).

references(node00056,[local(arc00070),local(arc00071),obsolete,obsolete]).

node(node00011,variable,[],[complete=true,name=row],[bounding_box=[329.2508364687001,185.42673237369993,343.2508364687001,199.42673237369996],caption_offset=[0,0]]).

node(node00030,submodel,[node00002,node00009,node00010,node00032,node00033,node00108,node00120,node00124,node00128,node00154,node00186,node00233,node00236,node00241,node00243,node00248,node00255,node00259,node00260,node00261,node00262,node00269],[complete=true,fill_colour='#80ff80',fix_math_args=0,multiplication_spec=[count=[]],name=plants,separate=0],[bounding_box=[25.840300996429978,27.712883270969023,317.13804304569993,261.32975376076905],caption_offset=[23.745844304300014,-8.919076737700006],hide_contents=0,internal_extent=[9.918903730629971,0,301.21664577990003,233.61687048980005]]).

links(node00030,[arc00045-arc00047,arc00045-arc00223,arc00057-arc00031,arc00058-arc00032,arc00098-arc00099,arc00117-arc00116,arc00121-arc00120,arc00125-arc00124,arc00140-arc00139,arc00250-arc00249]).

references(node00030,[ancestor(0),ancestor(1),ancestor(2),ancestor(3)]).

node(node00002,submodel,[node00003,node00004,node00005,node00006,node00007,node00008,node00012,node00013,node00015,node00016,node00017,node00018,node00023,node00024,node00027,node00028,node00029,node00031,node00051,node00052,node00057,node00069,node00071,node00075,node00091,node00096,node00107,node00111,node00118,node00123,node00126,node00132,node00133,node00136,node00267,node00268],[complete=true,fill_colour='#ffffff',fix_math_args=0,multiplication_spec=[count=[5]],name=plant_species,separate=0],[bounding_box=[21.86829156599,19.902302574849976,272.3851058779,184.89192389115007],caption_offset=[41.72833872140001,-7.955138709500002],hide_contents=0,internal_extent=[0,43.74103107039983,250.5168143119103,208.73065238670029]]).

links(node00002,[arc00007-arc00008,arc00007-arc00045,arc00007-arc00237,arc00007-arc00238,arc00007-arc00241,arc00007-arc00242,arc00007-arc00243,arc00013-arc00012,arc00031-arc00019,arc00032-arc00027,arc00097-arc00098,arc00116-arc00115,arc00120-arc00119,arc00124-arc00123,arc00139-arc00138,arc00249-arc00248]).

references(node00002,[ancestor(0),ancestor(1),ancestor(2),ancestor(3)]).

node(node00003,compartment,[],[complete=true,name=number],[bounding_box=[111.22309321091,103.29960675859999,151.22309321091,133.29960675860002],caption_offset=[13.886465223000016,-44.63506678760015]]).

node(node00004,function,[],[complete=true,name=fn1,units=1,value=5],[]).

node(node00005,cloud,[],[complete=true,name=cd1],[bounding_box=[11.858744220210006,102.3231493885,35.858744220210006,126.3231493885]]).

node(node00006,function,[],[complete=true,name=fn2,units=1,value=0.01*(seeds_staying+seeds_in)*(1-feedback)*water_multiplier],[]).

node(node00007,cloud,[],[complete=true,name=cd2],[bounding_box=[216.64629877691002,105.3054924161,240.64629877691002,129.30549241609998]]).

node(node00008,function,[],[complete=true,name=fn3,units=1,value=m*number],[]).

node(node00012,variable,[],[complete=true,name=feedback],[bounding_box=[41.629203578109944,149.01120954069998,55.629203578109944,163.01120954069998],caption_offset=[-9.115489180000104,0.02210491100001377]]).

node(node00013,function,[],[complete=true,name=fn5,units=1,value=sum([c]*[numbers])],[]).

node(node00015,function,[],[complete=false,name=fn6,units=1,value=element([rs],index(1))],[]).

node(node00016,variable,[],[name=var5],[]).

node(node00017,variable,[],[complete=true,name=c],[bounding_box=[11.827743431010003,136.11584844019998,25.82774343101001,150.11584844019998],caption_offset=[0,0]]).

node(node00018,function,[],[complete=true,name=fn7,units=array(1,5),value=element([[cs]],index(1))],[]).

node(node00023,variable,[],[complete=true,name='seeds\nstaying'],[bounding_box=[44.48044474330991,63.51762320398072,58.48044474330991,77.51762320398072],caption_offset=[-14.87835559590005,0.9918903730000039]]).

node(node00024,variable,[],[name=var10],[]).

node(node00027,variable,[],[complete=true,name=m],[bounding_box=[203.69441740691008,68.559361939,217.69441740691008,82.559361939],caption_offset=[0,0]]).

node(node00028,function,[],[complete=true,name=fn11,units=1,value=element([ms],index(1))],[]).

node(node00029,variable,[],[name=var13],[]).

node(node00031,function,[],[complete=true,name=fn2_0,units=1,value=seeds_produced-seeds_dispersing],[]).

node(node00051,variable,[],[complete=true,name='water\nmultiplier'],[bounding_box=[73.10488601790998,178.62304835468095,87.10488601790998,192.62304835468095],caption_offset=[-14.000000000000057,-10.000000000000028]]).

node(node00052,function,[],[comment='If there is plenty of soil water (>100 mm), then the multiplier for the recruitment of new plants is 1 (i.e. no reduction).\nIf the soil is dry (<50 mm), then no recruitment takes place.\nOtherwise, recruitment is reduced proportionally over the range 50-100 mm soil water.',complete=true,description='Reproduction multiplier for water',name=fn1_2,units=1,value=(if water>100 then 1 elseif water<50 then 0 else(water-50)/50)],[]).

node(node00057,variable,[],[complete=true,name='seeds\ndispersing'],[bounding_box=[158.5478376449102,65.50140395008071,172.5478376449102,79.50140395008071],caption_offset=[17.85402671400007,-37.691834176154096]]).

node(node00069,variable,[],[complete=true,name=seeds_produced],[bounding_box=[106.96953824591006,61.53384245798071,120.96953824591006,75.53384245798071],caption_offset=[0,0]]).

node(node00071,function,[],[complete=true,name=fn1_0,units=1,value=element([seeds_per_indiv],index(1))*number],[]).

node(node00075,function,[],[complete=true,name=fn3_0,units=1,value=seeds_produced*element([dispersability],index(1))],[]).

node(node00091,cloud,[],[complete=true,name=cd1_0],[bounding_box=[111.88844197691012,176.55257759778095,135.88844197691012,200.55257759778095]]).

node(node00096,function,[],[complete=true,name=fn1_1,units=1,value=fraction_lost*number],[]).

node(node00107,variable,[],[name=var9],[]).

node(node00111,function,[],[complete=true,name=fn4,units=int,value=index(1)],[]).

node(node00118,variable,[],[name=var18],[]).

node(node00123,variable,[],[name=var21],[]).

node(node00126,variable,[],[name=var24],[]).

node(node00132,variable,[],[complete=true,name=seeds_in],[bounding_box=[202.19101405991032,147.82830491378093,216.19101405991032,161.82830491378093],caption_offset=[0,0]]).

node(node00133,function,[],[complete=true,name=fn5_0,units=1,value=element(sum({[seeds_transfer_0]}),index(1))],[]).

node(node00136,variable,[],[name=var1],[]).

node(node00267,variable,[],[name=var10_0],[]).

node(node00268,variable,[],[name=var3],[]).

node(node00009,variable,[],[complete=true,name=numbers],[bounding_box=[79.52353131129995,204.73301113979997,93.52353131129993,218.73301113980003],caption_offset=[-30.74860156470004,-12.89457484999997]]).

node(node00010,function,[],[complete=true,name=fn4,units=array(1,5),value=[number]],[]).

node(node00032,variable,[],[],[]).

node(node00033,variable,[],[],[]).

node(node00108,variable,[],[name=var10],[]).

node(node00120,variable,[],[name=var19],[]).

node(node00124,variable,[],[name=var22],[]).

node(node00128,variable,[],[name=var25],[]).

node(node00154,variable,[],[name=var2],[]).

node(node00186,variable,[],[complete=true,name=n1],[bounding_box=[126.85404906590009,209.29214850213083,140.85404906590009,223.29214850213083],caption_offset=[0,0]]).

node(node00233,function,[],[complete=true,max_val=200,min_val=0,name=fn1,units=1,value=element([number],1)],[]).

node(node00236,variable,[],[complete=true,name=n2],[bounding_box=[155.6188698849001,207.30836775613085,169.6188698849001,221.30836775613085],caption_offset=[0,0]]).

node(node00241,function,[],[complete=true,max_val=200,min_val=0,name=fn2,units=1,value=element([number],2)],[]).

node(node00243,variable,[],[complete=true,name=n3],[bounding_box=[191.32692331490017,206.31647738313086,205.32692331490017,220.31647738313086],caption_offset=[0,0]]).

node(node00248,variable,[],[name=var3_0],[]).

node(node00255,function,[],[complete=true,max_val=200,min_val=0,name=fn3,units=1,value=element([number],3)],[]).

node(node00259,variable,[],[complete=true,name=n4],[bounding_box=[225.0511959989002,208.30025812913084,239.0511959989002,222.30025812913084],caption_offset=[0,0]]).

node(node00260,function,[],[complete=true,max_val=200,min_val=0,name=fn4_0,units=1,value=element([number],4)],[]).

node(node00261,variable,[],[complete=true,name=n5],[bounding_box=[257.78357830990024,206.31647738313086,271.78357830990024,220.31647738313086],caption_offset=[0,0]]).

node(node00262,function,[],[complete=true,max_val=200,min_val=0,name=fn5,units=1,value=element([number],5)],[]).

node(node00269,variable,[],[name=var4],[]).

node(node00034,submodel,[node00035,node00036,node00037,node00038,node00039,node00040,node00041,node00042,node00043,node00044,node00045,node00046,node00049,node00055,node00073,node00074,node00077,node00090,node00263,node00264,node00265,node00266],[complete=true,fill_colour='#80ffff',fix_math_args=0,multiplication_spec=[count=[]],name=soil_water,separate=0],[bounding_box=[49.696821247100026,286.1937321696,312.14300766970007,401.46651651260015],caption_offset=[6.958800397599994,-7.952914740000011],hide_contents=0,internal_extent=[0,0,262.4461864226,115.27278434300003]]).

links(node00034,[arc00047-arc00245,arc00059-arc00246,arc00060-arc00054,arc00078-arc00077,arc00078-arc00094,arc00088-arc00089,arc00088-arc00250]).

references(node00034,[ancestor(0),ancestor(1)]).

node(node00035,compartment,[],[complete=true,name=water],[bounding_box=[96.3425136456,43.61493872799997,136.34251364559998,73.61493872799997],caption_offset=[0,0]]).

node(node00036,function,[],[comment='if index(1)==int(rand_const(1,225))then 10000 else 0',complete=true,max_val=1000,min_val=0,name=fn1,units=1,value=100],[]).

node(node00037,cloud,[],[complete=true,name=cd1],[bounding_box=[15.670627852000006,6.3166123609999225,39.67062785200001,30.316612360999923]]).

node(node00038,function,[],[complete=true,name=fn2,units=int,value=rain],[]).

node(node00039,cloud,[],[complete=true,name=cd2],[bounding_box=[18.6462989712,52.93545989399992,42.6462989712,76.93545989399992]]).

node(node00040,function,[],[complete=true,name=fn3,units=1,value=sum({interflow_0})],[]).

node(node00041,cloud,[],[complete=true,name=cd3],[bounding_box=[230.91083880659997,54.91924064099989,254.91083880659997,78.9192406409999]]).

node(node00042,function,[],[complete=true,name=fn4,units=1,value=sum({interflow})],[]).

node(node00043,cloud,[],[complete=true,name=cd4],[bounding_box=[222.97571582259997,10.28417385299991,246.97571582259997,34.28417385299991]]).

node(node00044,function,[],[comment='If there is plenty of water available, evapotranspiration is equal to the total vegetation water demand.  Otherwise, it is reduced pro rata, depending on water availability.',complete=true,description='Evapotranspiration (mm/month)',name=fn5,units=1,value=(if water>100 then water_demand else water_demand*water/100)],[]).

node(node00045,cloud,[],[complete=true,name=cd5],[bounding_box=[201.1541276146,88.64351332399993,225.1541276146,112.64351332399993]]).

node(node00046,function,[],[complete=true,name=fn6,units=1,value=0.2*water],[]).

node(node00049,variable,[],[complete=true,name='water demand'],[bounding_box=[109.1977536026,8.303470960499805,123.1977536026,22.303470960499805],caption_offset=[-2.0,-1.9999999999999964]]).

node(node00055,variable,[],[name=var7],[]).

node(node00073,variable,[],[complete=true,name='water display'],[bounding_box=[86.13539247359996,86.70028071349991,100.13539247359996,100.70028071349991],caption_offset=[0,0]]).

node(node00074,function,[],[complete=true,max_val=200,min_val=0,name=fn1_0,units=1,value=water],[]).

node(node00077,variable,[],[name=var12],[]).

node(node00090,variable,[],[name=var9],[]).

node(node00263,function,[],[complete=true,name=fn1_1,units=1,value=sum([water_use]*[number])],[]).

node(node00264,variable,[],[name=var2],[]).

node(node00265,variable,[],[name=var3],[]).

node(node00266,variable,[],[name=var2_0],[]).

node(node00050,variable,[],[name=var1],[]).

node(node00054,function,[],[complete=true,name=fn1,units=int,value=floor((index(1)-1)/15)+1],[]).

node(node00058,variable,[],[],[]).

node(node00059,variable,[],[],[]).

node(node00060,variable,[],[],[]).

node(node00061,variable,[],[],[]).

node(node00062,variable,[],[complete=true,name=col],[bounding_box=[328.2589460947001,220.14289543109993,342.2589460947001,234.14289543109993],caption_offset=[-3.967561491999959,-1.9837807459999794]]).

node(node00063,function,[],[complete=true,name=fn2,units=1,value=fmod(index(1)-1,15)+1],[]).

node(node00078,variable,[],[name=var13],[]).

node(node00081,variable,[],[complete=true,name=elevation],[bounding_box=[330.2427268417001,269.73741408509994,344.2427268417001,283.73741408509994],caption_offset=[-30.748601565000058,-14.878355596000006]]).

node(node00082,function,[],[complete=true,max_val=300,min_val=0,name=fn2_0,units=1,value=200-10*col*sin(0.7*row)],[]).

node(node00083,variable,[],[name=var3],[]).

node(node00088,variable,[],[name=var7],[]).

node(node00095,variable,[],[name=var2],[]).

node(node00097,variable,[],[name=var4],[]).

node(node00109,variable,[],[name=var11],[]).

node(node00122,variable,[],[name=var20],[]).

node(node00125,variable,[],[name=var23],[]).

node(node00130,variable,[],[name=var26],[]).

node(node00246,variable,[],[complete=true,name='fuel\nload'],[bounding_box=[3.910794103669958,257.8347296071999,17.910794103669957,271.8347296071999],caption_offset=[-20.825729524200007,-28.77275743699994]]).

node(node00247,function,[],[complete=true,max_val=5000,min_val=0,name=fn2_1,units=1,value=sum([number]*[fuel_per_indiv])],[]).

node(node00249,variable,[],[name=var4_0],[]).

node(node00250,variable,[],[complete=true,name='fuel\nlost'],[bounding_box=[1.927013357479951,314.37248087209997,15.927013357479954,328.37248087209997],caption_offset=[19.837807461140017,-17.854026716000078]]).

node(node00251,function,[],[complete=true,name=fn3,units=1,value=element([fuel_lost],index(1))],[]).

node(node00252,variable,[],[complete=true,name='fraction\nlost'],[bounding_box=[8.870245968869963,287.59144079909987,22.870245968869963,301.59144079909987],caption_offset=[-24.781386086642012,-18.873695258000055]]).

node(node00253,function,[],[complete=true,name=fn4,units=1,value=fuel_lost/fuel_load],[]).

node(node00256,variable,[],[name=var9],[]).

node(node00064,submodel,[node00065,node00066,node00067,node00068,node00070,node00072,node00076,node00079,node00080,node00084,node00085,node00086,node00089,node00104,node00106,node00110,node00117],[complete=true,fill_colour='#f3f3f3',fix_math_args=0,multiplication_spec=[count=[]],name=neighbour,separate=0],[bounding_box=[402.640030193,10.914762413210033,475.91293188200007,322.3683395549001],caption_offset=[28.764820819000022,-7.935122984499998],hide_contents=0,internal_extent=[3.9675614919999687,-4.959451865490614,77.24046318100024,306.4941252762002]]).

links(node00064,[arc00066-arc00065,arc00069-arc00068,arc00076-arc00079,arc00084-arc00083,arc00091-arc00090,arc00108-arc00100,arc00114-arc00118]).

references(node00064,[local(arc00070),local(arc00071)]).

node(node00065,condition,[],[complete=true,name='neighbour\ncondition'],[bounding_box=[24.560533933999984,104.99095696990007,54.56053393399998,134.9909569699],caption_offset=[0,0]]).

node(node00066,function,[],[comment='abs(row-row_0)<=1 and abs(col-col_0)<=1 and! (row==row_0 and col==col_0)',complete=true,name=fn3,units=boolean,value=(abs(row-row_0)+abs(col-col_0)==1)],[]).

node(node00067,variable,[],[complete=true,name=interflow],[bounding_box=[30.632309527000096,278.6922056112,44.632309527000096,292.6922056112],caption_offset=[1.991717365999989,-2.9875760489999834]]).

node(node00068,function,[],[complete=true,name=fn4,units=1,value=max(0,0.005*elevation_diff*water)],[]).

node(node00070,variable,[],[name=var5],[]).

node(node00072,variable,[],[name=var7],[]).

node(node00076,variable,[],[name=var11],[]).

node(node00079,variable,[],[complete=true,name=elevation_diff],[bounding_box=[28.64852878100001,206.20881048920003,42.64852878100001,220.20881048920003],caption_offset=[2.95979787899995,-30.740664944999992]]).

node(node00080,function,[],[complete=true,name=fn1,units=1,value=elevation-elevation_0],[]).

node(node00084,variable,[],[name=var4],[]).

node(node00085,variable,[],[complete=true,name=water],[bounding_box=[21.748947579000095,245.90426696120008,35.7489475790001,259.90426696120005],caption_offset=[0,-32.73238231099998]]).

node(node00086,function,[],[complete=true,name=fn3_0,units=1,value=water],[]).

node(node00089,variable,[],[name=var8],[]).

node(node00104,variable,[],[complete=true,name='seeds\ntransfer'],[bounding_box=[19.685800631,30.715644036099533,33.68580063099999,44.71564403609953],caption_offset=[14.878355596000034,6.943232611400013]]).

node(node00106,function,[],[complete=true,name=fn4_0,units=array(1,size(plant_species)),value=[seeds_dispersing]],[]).

node(node00110,variable,[],[name=var12],[]).

node(node00117,variable,[],[name=var17],[]).

node(node00099,variable,[],[complete=true,name='seeds\nper indiv'],[bounding_box=[63.392470007499995,-95.33776785135798,77.3924700075,-81.337767851358],caption_offset=[-29.7567111917,-16.862136342]]).

node(node00100,function,[],[complete=true,name=fn2,units=array(1,size(plant_species)),value=[70.0,60.0,25.0,20.0,20.0]],[]).

node(node00113,function,[],[complete=true,description='Species-specific dispersal distance (grid units)',name=fn5,units=array(int,5),value=[5,5,4,3,2]],[]).

node(node00127,function,[],[name=fn3,units=array(1,5),value=min(1,1/[dispersal_distance])],[]).

node(node00129,function,[],[name=fn4,units=array(1,5),value=min(1,1/[dispersal_distance])],[]).

node(node00092,function,[],[name=fn1,units=boolean,value=(distance<3)],[]).

node(node00094,function,[],[name=fn2,units=1,value=hypot(row-row_0,col-col_0)],[]).

node(node00105,function,[],[name=fn3,units=array(1,5),value=[seeds_produced]*[k1]*exp(-1*[k2]*distance)],[]).

node(node00119,function,[],[name=fn1_0,units=array(1,5),value=min(1,1/[dispersal_distance])],[]).

node(node00121,function,[],[name=fn2_0],[]).

node(node00014,variable,[],[complete=true,name=dispersability],[bounding_box=[114.93108630689996,-96.33362653430001,128.93108630689994,-82.33362653430002],caption_offset=[49.594518652999994,-12.894574849799994]]).

node(node00019,function,[],[complete=true,name=fn1_1,units=array(1,size(plant_species)),value=[0.2,0.2,0.15,0.1,0.05]],[]).

node(node00244,variable,[],[complete=true,name='fuel per\nindiv'],[bounding_box=[-66.43405618459997,199.2735144971,-52.43405618459999,213.27351449710005],caption_offset=[-3.967561492199991,-35.70805342989999]]).

node(node00245,function,[],[complete=true,name=fn1_2,units=array(1,size(plant_species)),value=[10.0,10.0,10.0,10.0,10.0]],[]).

node(node00093,submodel,[node00098,node00101,node00102,node00103,node00112,node00114,node00115,node00116,node00131,node00134,node00135,node00137,node00138,node00139,node00140,node00141,node00142,node00254,node00258],[complete=true,fill_colour='#ff9b9b',fix_math_args=0,multiplication_spec=[count=[]],name=fire,separate=0],[bounding_box=[-507.132302001689,-94.32212268944814,-89.11031328754913,421.53177507009025],caption_offset=[33.72427268399997,-5.951342238400002],hide_contents=0,internal_extent=[35.40393190754099,-122.3717619899018,460.3022994330386,401.9678300825636]]).

links(node00093,[arc00214-arc00239,arc00240-arc00236]).

node(node00098,submodel,[node00144,node00145,node00146,node00147,node00148,node00149,node00150,node00151,node00152,node00153,node00155,node00156,node00157,node00158,node00159,node00160,node00161,node00162,node00163,node00164,node00257],[complete=true,fill_colour='#ffffb9',fix_math_args=0,multiplication_spec=[count=[]],name=conditional_fire,separate=0,step=2],[bounding_box=[73.10674425066809,-64.52938650435075,431.77679665262514,276.3572771537864],caption_offset=[41.444274693000004,-8.880916005700001],hide_contents=0,internal_extent=[0.5375608399324755,-4.000000000000034,313.25243162274614,293.21000753632245]]).

links(node00098,[arc00129-arc00177,arc00147-arc00146,arc00157-arc00156,arc00160-arc00159,arc00164-arc00163,arc00181-arc00180,arc00184-arc00183,arc00212-arc00211,arc00218-arc00220,arc00236-arc00235]).

node(node00144,submodel,[node00143,node00165,node00166,node00167,node00168,node00169,node00170,node00171,node00172,node00173,node00174,node00175,node00176,node00177,node00178,node00179,node00180,node00181,node00182,node00183,node00184,node00185,node00187,node00188,node00189,node00190,node00191,node00192,node00193,node00194,node00195,node00196,node00197,node00198,node00199,node00200,node00201],[complete=true,fill_colour='#e2e2e2',fix_math_args=0,multiplication_spec=[count=[225]],name=fire_patch,separate=0],[bounding_box=[56.44264617430004,17.77894895051994,277.4787778699001,231.90770153092],caption_offset=[22.69567423667101,-5.920610670400006],hide_contents=0,internal_extent=[0,0,221.03613169560003,214.12875258040006]]).

links(node00144,[arc00146-arc00145,arc00156-arc00155,arc00159-arc00158,arc00159-arc00165,arc00163-arc00162,arc00168-arc00169,arc00173-arc00172,arc00180-arc00179,arc00186-arc00185,arc00211-arc00210,arc00217-arc00218,arc00235-arc00234]).

references(node00144,[obsolete,obsolete]).

node(node00143,variable,[],[name=var2_0],[]).

node(node00165,compartment,[],[complete=true,name=fuel_load],[bounding_box=[62.888549385999994,14.603053352129987,102.888549386,44.60305335212999],caption_offset=[0,0]]).

node(node00166,function,[],[complete=true,max_val=3000,min_val=0,name=fn1,units=1,value=element([fuel_load],index(1))],[]).

node(node00167,compartment,[],[complete=true,name=fuel_load_lost],[bounding_box=[172.4198467896001,13.61628490763999,212.4198467896001,43.616284907639994],caption_offset=[-9.707999669101753,0.0]]).

node(node00168,function,[],[complete=true,name=fn2,units=1,value=(if fire then fuel_load*burnt_per_step/dt(2)else 0)],[]).

node(node00169,variable,[],[complete=true,name=fire],[bounding_box=[43.43293049726175,56.72609999440732,57.43293049726175,70.72609999440732],caption_offset=[-16.701544285112597,-21.096687518158205]]).

node(node00170,function,[],[complete=true,name=fn3,units=boolean,value=(crossover or new_fire)],[]).

node(node00171,variable,[],[complete=true,name=new_fire],[bounding_box=[41.70909372155968,93.02105286481655,55.70909372155968,107.02105286481655],caption_offset=[-26.370859397033126,-18.45960157818905]]).

node(node00172,function,[],[complete=true,name=fn4,units=boolean,value=(spark_here and starts)],[]).

node(node00173,variable,[],[complete=true,name=crossover],[bounding_box=[95.1194398131517,86.63526248323824,109.1194398131517,100.63526248323824],caption_offset=[0,0]]).

node(node00174,function,[],[complete=true,name=fn5,units=boolean,value=(neighbour_burns and catches)],[]).

node(node00175,variable,[],[complete=true,name=catches],[bounding_box=[158.7770987716,90.690076062,172.7770987716,104.690076062],caption_offset=[0,0]]).

node(node00176,function,[],[complete=true,name=fn6,units=boolean,value=(rand_var(0,1)<0.7*max(0,min(1,(fuel_load-min_for_fire)/(always_catch-min_for_fire))))],[]).

node(node00177,variable,[],[complete=true,name=starts],[bounding_box=[67.00763338040001,137.06819298040003,81.00763338040001,151.06819298040003],caption_offset=[0,0]]).

node(node00178,function,[],[complete=true,name=fn7,units=boolean,value=(fuel_load>rand_const(min_for_fire,always_starts))],[]).

node(node00179,variable,[],[complete=true,name=spark_here],[bounding_box=[30.49720091270001,173.5786254484,44.49720091270001,187.5786254484],caption_offset=[21.975716164341975,-2.6370859396147353]]).

node(node00180,function,[],[complete=true,name=fn8,units=boolean,value=(check_spark and spark_patch==index(1))],[]).

node(node00181,variable,[],[complete=true,name=neighbour_burns],[bounding_box=[118.31959252360004,142.0020352054,132.31959252360002,156.0020352054],caption_offset=[4.395143232691154,-30.7660026306105]]).

node(node00182,function,[],[complete=true,name=fn9,units=boolean,value=any(element([other_fires],[neighbours]))],[]).

node(node00183,variable,[],[complete=true,name=old_fire],[bounding_box=[186.40661523460003,138.05496142539997,200.40661523460003,152.05496142539997],caption_offset=[-15.822515638574373,-2.63708593961465]]).

node(node00184,function,[],[complete=true,name=fn10,units=boolean,value=last(fire)],[]).

node(node00185,variable,[],[name=var1],[]).

node(node00187,variable,[],[name=var6],[]).

node(node00188,variable,[],[name=var9],[]).

node(node00189,variable,[],[name=var11],[]).

node(node00190,variable,[],[name=var13],[]).

node(node00191,variable,[],[name=var15],[]).

node(node00192,function,[],[name=fn2_0,units=int,value=floor((index(1)-1)/nrow)+1],[]).

node(node00193,function,[],[name=fn3_0,units=1,value=fmod(index(1)-1,ncol)+1],[]).

node(node00194,function,[],[complete=true,max_val=3000,min_val=0,name=fn1_1,units=1,value=0],[]).

node(node00195,variable,[],[name=var2],[]).

node(node00196,variable,[],[name=var11_0],[]).

node(node00197,variable,[],[name=var15_0],[]).

node(node00198,variable,[],[complete=true,name=neighbours],[bounding_box=[148.2646049404809,176.4132660213251,162.2646049404809,190.4132660213251],caption_offset=[32.524059923686906,-24.6128021048429]]).

node(node00199,function,[],[complete=true,name=fn1_0,units=array(1,4),value=element([[neighbours]],index(1))],[]).

node(node00200,variable,[],[name=var3_1],[]).

node(node00201,variable,[],[name=var6_0],[]).

node(node00145,variable,[],[complete=true,name=check_spark],[bounding_box=[114.75589172134316,250.37026809936856,128.75589172134318,264.37026809936856],caption_offset=[0,0]]).

node(node00146,function,[],[complete=true,name=fn11,units=boolean,value=(spark_ and fmod(time(1),dt(1))<dt(2))],[]).

node(node00147,variable,[],[complete=true,name=burning],[bounding_box=[174.6068869422943,252.04798448859685,188.6068869422943,266.04798448859685],caption_offset=[0,0]]).

node(node00148,function,[],[complete=true,name=fn12,units=boolean,value=any([other_fires])],[]).

node(node00149,variable,[],[complete=true,name=other_fires],[bounding_box=[228.10599086494227,252.4475931759547,242.10599086494227,266.4475931759547],caption_offset=[30.7660026306105,-23.733773458304626]]).

node(node00150,function,[],[complete=true,name=fn13,units=array(boolean,size(fire_patch)),value=[old_fire]],[]).

node(node00151,variable,[],[name=var1],[]).

node(node00152,condition,[],[complete=true,name='is_fire?'],[bounding_box=[26.738876168817804,235.36358203554013,56.73887616881783,265.36358203554016],caption_offset=[0,0]]).

node(node00153,function,[],[complete=true,name=fn20,units=boolean,value=(check_spark or burning)],[]).

node(node00155,variable,[],[name=var7],[]).

node(node00156,variable,[],[name=var10],[]).

node(node00157,variable,[],[name=var12],[]).

node(node00158,variable,[],[name=var14],[]).

node(node00159,function,[],[name=fn1,units=boolean,value=(abs(row-row_0)<=1 and abs(col-col_0)<=1 and! (row==row_0 and col==col_0))],[]).

node(node00160,function,[],[name=fn1_0,units=boolean,value=old_fire],[]).

node(node00161,variable,[],[name=var12_0],[]).

node(node00162,variable,[],[name=var14_0],[]).

node(node00163,variable,[],[name=var4_0],[]).

node(node00164,variable,[],[name=var7_0],[]).

node(node00257,variable,[],[name=var3],[]).

node(node00101,submodel,[node00202,node00203,node00204,node00205,node00206,node00207],[complete=true,fill_colour='#ffffff',fix_math_args=0,multiplication_spec=[count=[]],name=fire_test,separate=0],[bounding_box=[44.93999484342978,301.8262613613105,126.32703552570516,369.91328407131056],caption_offset=[13.814758230999995,-6.907379115000026],hide_contents=0,internal_extent=[11.369193154524666,0.0,92.75623383680005,68.08702271000004]]).

links(node00101,[arc00178-arc00181,arc00182-arc00184]).

node(node00202,variable,[],[complete=true,name='spark?'],[bounding_box=[26.292674710867118,10.568887059684787,40.29267471086711,24.56888705968479],caption_offset=[0,0]]).

node(node00203,function,[],[complete=true,name=fn14,units=boolean,value=(abs(time(1)-10)<0.001)],[]).

node(node00204,variable,[],[complete=true,name=spark_patch],[bounding_box=[52.97849187088918,29.703377418298842,66.97849187088917,43.70337741829885],caption_offset=[0,0]]).

node(node00205,function,[],[complete=true,name=fn15,units=int,value=int(rand_var(1,size(fire_patch)+1))],[]).

node(node00206,variable,[],[name=var10],[]).

node(node00207,variable,[],[name=var13],[]).

node(node00102,submodel,[node00208,node00209,node00210,node00211,node00212,node00213,node00214,node00215,node00216,node00217,node00218,node00219,node00220,node00221,node00222,node00223,node00224],[complete=true,fill_colour='#e2e2e2',fix_math_args=0,multiplication_spec=[count=[225]],name=patch_results,separate=0],[bounding_box=[169.63871302022326,297.32113164587,343.796301090181,382.2795990802728],caption_offset=[13.814758231000013,-6.907379115000026],hide_contents=0,internal_extent=[15.788295121099885,-9.867684450999665,189.94588319105767,75.09078298340316]]).

links(node00102,[arc00203-arc00202,arc00203-arc00206,arc00205-arc00204,arc00205-arc00207,arc00209-arc00212]).

node(node00208,function,[],[comment='if fmod(time(1),dt(1))==dt(2)then 0 elseif any({burning})then element(sum({[fuel_load_lost]}),index(1))else prev(1)',max_val=3000,min_val=0,name=fn16,units=1,value=(if any({burning})then element(sum({[fuel_load_lost]}),index(1))elseif fmod(time(1),dt(1))>0 and fmod(time(1),dt(1))<1.5*dt(2)then 0 else prev(1))],[]).

node(node00209,function,[],[max_val=3000,min_val=0,name=fn1_0,units=1,value=element(sum({[fuel_load_lost]}),index(1))],[]).

node(node00210,variable,[],[complete=true,name=row],[bounding_box=[41.737543709614215,2.910561105844296,55.73754370961422,16.9105611058443],caption_offset=[0,0]]).

node(node00211,function,[],[complete=true,name=fn1,units=int,value=floor((index(1)-1)/nrow)+1],[]).

node(node00212,variable,[],[complete=true,name=col],[bounding_box=[44.71928737263631,41.587475414143036,58.7192873726363,55.587475414143036],caption_offset=[0,0]]).

node(node00213,function,[],[complete=true,name=fn2,units=1,value=fmod(index(1)-1,ncol)+1],[]).

node(node00214,variable,[],[complete=true,name=row_neighbours],[bounding_box=[94.10058628208049,4.948412979610476,108.10058628208049,18.94841297961048],caption_offset=[0,0]]).

node(node00215,function,[],[complete=true,name=fn3,units=array(int,4),value=[row-1,row,row+1,row]],[]).

node(node00216,variable,[],[complete=true,name=col_neighbours],[bounding_box=[108.23691943182826,40.57926864122096,122.23691943182824,54.57926864122096],caption_offset=[0,0]]).

node(node00217,function,[],[complete=true,name=fn4,units=array(1,4),value=[col,col+1,col,col-1]],[]).

node(node00218,variable,[],[complete=true,name=neighbours],[bounding_box=[155.38742151579098,20.629516462000044,169.38742151579098,34.62951646200004],caption_offset=[0,0]]).

node(node00219,function,[],[complete=true,name=fn5,units=array(1,4),value=(if ([row_neighbours]>0,[row_neighbours]<=nrow,[col_neighbours]>0,[col_neighbours]<=ncol)then ncol*([row_neighbours]-1)+[col_neighbours]else index(1))],[]).

node(node00220,variable,[],[name=var8],[]).

node(node00221,variable,[],[name=var9],[]).

node(node00222,variable,[],[name=var10],[]).

node(node00223,variable,[],[name=var11],[]).

node(node00224,variable,[],[name=var2],[]).

node(node00103,variable,[],[complete=true,name=always_catch],[bounding_box=[383.26140425133366,-99.83126388547106,397.26140425133366,-85.83126388547112],caption_offset=[-4.048961443338328,-30.36721082513921]]).

node(node00112,function,[],[complete=true,name=fn17,units=int,value=2500],[]).

node(node00114,variable,[],[complete=true,name=burnt_per_step],[bounding_box=[299.8138716570143,-97.20727012146517,313.8138716570144,-83.20727012146517],caption_offset=[3.036721082503732,-31.37945118597378]]).

node(node00115,function,[],[complete=true,name=fn18,units=1,value=0.6],[]).

node(node00116,variable,[],[complete=true,name=always_starts],[bounding_box=[48.945384020877206,111.77841171301898,62.94538402087722,125.778411713019],caption_offset=[18.22032649502256,0.0]]).

node(node00131,function,[],[complete=true,name=fn19,units=int,value=1500],[]).

node(node00134,variable,[],[complete=true,name=min_for_fire],[bounding_box=[380.0813386718974,284.1079766283625,394.0813386718974,298.1079766283625],caption_offset=[36.364237243557795,-17.379753274481402]]).

node(node00135,function,[],[complete=true,name=fn3,units=int,value=1000],[]).

node(node00137,function,[],[max_val=3000,min_val=0,name=fn1,units=array(1,size(fire_patch)),value=[fuel_lost]-prev(1)],[]).

node(node00138,variable,[],[complete=true,name=nrow],[bounding_box=[137.12240662940124,310.7840853310743,151.12240662940124,324.7840853310743],caption_offset=[0,0]]).

node(node00139,function,[],[complete=true,name=fn6,units=int,value=15],[]).

node(node00140,variable,[],[complete=true,name=ncol],[bounding_box=[138.88219055695222,353.4686587925627,152.8821905569522,367.4686587925627],caption_offset=[0,0]]).

node(node00141,function,[],[complete=true,name=fn7,units=int,value=15],[]).

node(node00142,submodel,[node00225,node00226,node00227,node00228,node00229,node00230,node00231],[complete=true,fill_colour='#ffffb9',fix_math_args=0,multiplication_spec=[count=[]],name='fire results',separate=0,step=2],[bounding_box=[366.68983190835013,313.3795121447926,440.13274772159616,394.4873875820337],caption_offset=[11.007284391007545,-6.932851030834513],hide_contents=0,internal_extent=[5.061201804172981,0.0,78.50411761741901,81.10787543724109]]).

links(node00142,[arc00177-arc00176,arc00213-arc00214,arc00220-arc00219]).

node(node00225,variable,[],[name=var2],[]).

node(node00226,variable,[],[complete=true,name=time_in_2],[bounding_box=[23.954273371691915,49.74844289824276,37.954273371691926,63.74844289824276],caption_offset=[0,0]]).

node(node00227,function,[],[complete=true,name=fn1_0,units=1,value=fmod(time(1),dt(1))],[]).

node(node00228,variable,[],[complete=true,name=fuel_lost],[bounding_box=[37.3546841618568,15.863147271464282,51.35468416185682,29.86314727146428],caption_offset=[9.995044029172938,3.9470737810000287]]).

node(node00229,function,[],[comment='if any({burning})then element(sum({[fuel_load_lost]}),index(1))elseif fmod(time(1),dt(1))>0 and fmod(time(1),dt(1))<1.5*dt(2)then 0 else prev(1)',complete=true,max_val=3000,min_val=0,name=fn1,units=array(1,size(fire_patch)),value=(if any({burning})then sum({[fuel_load_lost]})elseif time_in_2>0 and time_in_2<1.5*dt(2)then 0 else prev(1))],[]).

node(node00230,variable,[],[name=var3],[]).

node(node00231,variable,[],[name=var8],[]).

node(node00254,variable,[],[name=var7],[]).

node(node00258,variable,[],[name=var4],[]).

node(node00232,function,[],[complete=false,name=fn1],[]).

node(node00234,function,[],[complete=true,name=fn2,units=1,value=rand_const(1000,3000)],[]).

node(node00235,function,[],[complete=true,name=fn1_1,units=1,value=floor(rand_const(1000,3000))],[]).

node(node00237,function,[],[complete=true,name=fn1_0,units=int,value=floor((index(1)-1)/30)+1],[]).

node(node00238,function,[],[complete=true,name=fn2_0,units=1,value=fmod(index(1)-1,30)+1],[]).

node(node00239,function,[],[complete=false,name=fn3],[]).

node(node00240,function,[],[complete=false,name=fn4],[]).

node(node00242,function,[],[name=fn2_1,units=1,value=element([fuel_lost],index(1))],[]).





arc(arc00016,node00022,node00021,influence,[name=i14],[]).

arc(arc00025,node00026,node00025,influence,[name=i23],[]).

arc(arc00044,node00048,node00047,influence,[name=i7],[]).

arc(arc00020,node00021,node00056,influence,[complete=true,name=i18],[course=[[-26.89691605803072,94.00810962700001],[-32.07631440856535,87.68100147265008],[-50,87]]]).

arc(arc00028,node00025,node00056,influence,[complete=true,name=i26],[course=[[232.20788903350626,-53.99189037299999],[241.41821433900304,-76.31494371409997],[237.028989219,-80.946162879]]]).

arc(arc00050,node00047,node00056,influence,[complete=true,name=i13_0],[course=[[-27.022057494202116,283.008109627],[-37.48937604950108,270.7527428819998],[-50,277]]]).

arc(arc00055,node00053,node00056,influence,[complete=true,name=i18_0],[course=[[-26.050594983349843,311.008109627],[-40.029611815724934,305.30131414000004],[-51,318]]]).

arc(arc00001,node00004,node00003,influence,[name=i1],[]).

arc(arc00002,node00005,node00003,flow,[complete=true,name=reproduction],[bowtie=[66.397000994,104.9823430275,78.397000994,128.9823430275],caption_offset=[-13.917600794700007,0.0],course=[[110.79400198799999,116.9823430275],[34,116.9823430275]]]).

arc(arc00003,node00006,arc00002,influence,[name=i2],[]).

arc(arc00004,node00003,node00007,flow,[complete=true,name=mortality],[bowtie=[177.397000994,106.97645736999999,189.397000994,130.97645737],caption_offset=[-14.911715137999977,-1.9882286849999957],course=[[216,118.97645736999999],[150.794001988,118.97645736999999]]]).

arc(arc00005,node00008,arc00004,influence,[name=i3],[]).

arc(arc00009,node00003,node00008,influence,[complete=true,name=i7,role=[use(none,in_hierarchy,number,1)]],[course=[[177,118],[164,111],[151,118]]]).

arc(arc00024,node00012,node00006,influence,[complete=true,name=i22,role=[use(none,in_hierarchy,feedback,1)]],[course=[[66,120],[46.988228685049975,135.05002808850008],[48.97645737009993,148.10005617699997]]]).

arc(arc00010,node00013,node00012,influence,[name=i8],[]).

arc(arc00012,node00016,node00013,influence,[complete=true,name=i10,role=[use(none,in_hierarchy,[numbers],array(1,5))]],[course=[[42.99999999999995,160.99999999999994],[34.95880039759491,186.5582507936591],[51.99999999999987,207.8810752880181]]]).

arc(arc00021,node00017,node00013,influence,[complete=true,name=i19,role=[use(none,in_hierarchy,[c],array(1,5))]],[course=[[41.99999999999995,150.99999999999994],[34.96389980419997,142.0905762227501],[24,142]]]).

arc(arc00014,node00018,node00017,influence,[name=i12],[]).

arc(arc00095,node00023,node00006,influence,[complete=true,name=i12_0,role=[use(none,in_hierarchy,seeds_staying,1)]],[course=[[66,104],[66,86],[53,76]]]).

arc(arc00019,node00024,node00018,influence,[complete=true,name=i17,role=[use(none,in_hierarchy,[[cs]],array(array(1,5),5))]],[course=[[11.999999999999972,139.04054813449997],[4.008042235199856,139.56409076422506],[-0.8764011929902956,144.91171513765]]]).

arc(arc00029,node00027,node00008,influence,[complete=true,name=i27,role=[use(none,in_hierarchy,m,1)]],[course=[[189,111],[206.89457485000003,92.94447937924998],[208.78914970000008,80.8889587585]]]).

arc(arc00026,node00028,node00027,influence,[name=i24],[]).

arc(arc00027,node00029,node00028,influence,[complete=true,name=i25,role=[use(none,in_hierarchy,[ms],array(1,5))]],[course=[[212,68],[220.92694596605003,45.926922970822744],[214.1235988070102,42.82951706084541]]]).

arc(arc00015,node00031,node00023,influence,[name=i2_0],[]).

arc(arc00049,node00051,node00006,influence,[complete=true,name=i2_2,role=[use(none,in_hierarchy,water_multiplier,1)]],[course=[[73,128],[63,154],[79,178]]]).

arc(arc00046,node00052,node00051,influence,[name=i1_2],[]).

arc(arc00074,node00057,node00031,influence,[complete=true,name=i10_0,role=[use(none,in_hierarchy,seeds_dispersing,1)]],[course=[[57,72],[106.41484891700001,90.00810962690001],[157.82969783400003,71.0162192538]]]).

arc(arc00073,node00069,node00031,influence,[complete=true,name=i9,role=[use(none,in_hierarchy,seeds_produced,1)]],[course=[[57,72],[81.51216444049999,81.00810962695002],[106.024328881,68.0162192539]]]).

arc(arc00101,node00071,node00069,influence,[name=i1_0],[]).

arc(arc00107,node00003,node00071,influence,[complete=true,name=i7_0,role=[use(none,in_hierarchy,number,1)]],[course=[[115.024328881,74.0162192539],[113.51216444049999,90.00810962695002],[121,103]]]).

arc(arc00017,node00075,node00057,influence,[name=i3_1],[]).

arc(arc00075,node00069,node00075,influence,[complete=true,name=i11,role=[use(none,in_hierarchy,seeds_produced,1)]],[course=[[158,70],[138.92701335750002,65.01621925385001],[119.024328881,66.0162192539]]]).

arc(arc00135,node00003,node00091,flow,[complete=true,name=burnt],[bowtie=[119.0,152.5,143.0,164.5],caption_offset=[0,-7.9351229840000315],course=[[131,184],[131,133]]]).

arc(arc00136,node00096,arc00135,influence,[name=i1_1],[]).

arc(arc00141,node00003,node00096,influence,[complete=true,name=i5_0,role=[use(none,in_hierarchy,number,1)]],[course=[[131,152],[135,142],[131,133]]]).

arc(arc00097,node00057,node00107,influence,[complete=true,name=i14],[course=[[250.1235988070103,74.70386703193933],[210.0,52.39607594714471],[171,69]]]).

arc(arc00119,node00123,node00071,influence,[complete=true,name=i29,role=[use(none,in_hierarchy,[seeds_per_indiv],array(1,5))]],[course=[[111,61],[108.51216444049999,47.967010588547794],[98.12359880700994,42.82951706084541]]]).

arc(arc00123,node00126,node00075,influence,[complete=true,name=i33,role=[use(none,in_hierarchy,[dispersability],array(1,5))]],[course=[[159,67],[146.5648770159999,55.9102431999418],[138.12359880701004,42.82951706084541]]]).

arc(arc00143,node00132,node00006,influence,[complete=true,name=i22_0,role=[use(none,in_hierarchy,seeds_in,1)]],[course=[[78,120],[128.39862966350006,158.544602948],[201.7972593270001,151.08920589599998]]]).

arc(arc00115,node00118,node00133,influence,[complete=true,name=i25_0,role=[use(0,in_assoc,{[seeds_transfer]},list(array(1,size(plant_species)))),use(1,in_assoc,{[seeds_transfer_0]},list(array(1,size(plant_species))))]],[course=[[214.7972593270001,154.08920589599998],[237.39862966350003,165.3601642055839],[250.1235988070103,150.54283765281787]]]).

arc(arc00137,node00133,node00132,influence,[name=i16],[]).

arc(arc00138,node00136,node00096,influence,[complete=true,name=i2_1,role=[use(none,in_hierarchy,fraction_lost,1)]],[course=[[121,164],[91.87430078150008,182.1958889905502],[37.1317084340098,207.79007073355024]]]).

arc(arc00007,node00003,node00267,influence,[complete=true,name=i5],[course=[[151.0,207.79387975959617],[161,166],[134,133]]]).

arc(arc00248,node00268,node00052,influence,[complete=true,name=i3_0,role=[use(none,in_hierarchy,water,1)]],[course=[[86,188],[99,207],[123.13170843401001,207.83872849555024]]]).

arc(arc00013,node00009,node00002,influence,[complete=true,name=i11],[course=[[73.86829156599004,184.0423467924679],[68.44899471074496,194.69401404213394],[80,206]]]).

arc(arc00006,node00010,node00009,influence,[name=i4],[]).

arc(arc00008,node00002,node00010,influence,[complete=true,name=i6,role=[use(none,in_hierarchy,[number],array(1,size(plant_species)))]],[course=[[92,209],[139.44899471074487,196.65041627792314],[172.86829156598992,183.95515126404595]]]).

arc(arc00031,node00032,node00002,influence,[complete=true,name=i18],[course=[[20.991890372999997,121.07298664209995],[15.462783719598315,118.60353813816555],[9.027847586096627,127.28711672903094]]]).

arc(arc00032,node00033,node00002,influence,[complete=true,name=i26],[course=[[235.991890373,18.99078856529557],[242.59357129499472,-5.43756090023677],[236.28942273688946,-0.7128832709691156]]]).

arc(arc00098,node00002,node00108,influence,[complete=true,name=i15],[course=[[301.08314841817923,58.28711672903091],[286.49821802848953,46.93256926819467],[271.991890373,50.865138536389395]]]).

arc(arc00116,node00120,node00002,influence,[complete=true,name=i26_0],[course=[[271.991890373,126.70410915726777],[288.49821802848953,128.3520545786339],[301.08314841817923,115.28711672903094]]]).

arc(arc00120,node00124,node00002,influence,[complete=true,name=i30],[course=[[119.99189037299999,18.99078856529557],[119.80762950655486,3.4953942826477498],[106.70197137430971,-0.7128832709691156]]]).

arc(arc00124,node00128,node00002,influence,[complete=true,name=i34],[course=[[159.991890373,18.99078856529557],[166.4020691518604,4.49539428264775],[159.89085066492083,-0.7128832709691156]]]).

arc(arc00139,node00154,node00002,influence,[complete=true,name=i3],[course=[[59.0,183.951342238],[37.960698632900005,200.83211275448454],[18.00000000000002,225.0]]]).

arc(arc00190,node00233,node00186,influence,[name=i1],[]).

arc(arc00237,node00002,node00233,influence,[complete=true,name=i6_0,role=[use(none,in_hierarchy,[number],array(1,size(plant_species)))]],[course=[[139,213],[162.0,204.975671119],[171.0,183.951342238]]]).

arc(arc00215,node00241,node00236,influence,[name=i2],[]).

arc(arc00238,node00002,node00241,influence,[complete=true,name=i7,role=[use(none,in_hierarchy,[number],array(1,size(plant_species)))]],[course=[[165,208],[173.0,196.975671119],[170.0,183.951342238]]]).

arc(arc00045,node00002,node00248,influence,[complete=true,name=i8],[course=[[105.07860273420003,233.287116729031],[150,225],[171,184]]]).

arc(arc00216,node00255,node00243,influence,[name=i3_0],[]).

arc(arc00241,node00002,node00255,influence,[complete=true,name=i8_0,role=[use(none,in_hierarchy,[number],array(1,size(plant_species)))]],[course=[[195,206],[188.0,188.975671119],[170.0,183.951342238]]]).

arc(arc00228,node00260,node00259,influence,[name=i4_0],[]).

arc(arc00242,node00002,node00260,influence,[complete=true,name=i9,role=[use(none,in_hierarchy,[number],array(1,size(plant_species)))]],[course=[[227,209],[206.0,183.975671119],[171.0,183.951342238]]]).

arc(arc00230,node00262,node00261,influence,[name=i5],[]).

arc(arc00243,node00002,node00262,influence,[complete=true,name=i10,role=[use(none,in_hierarchy,[number],array(1,size(plant_species)))]],[course=[[258,208],[223.0,175.975671119],[173.0,183.951342238]]]).

arc(arc00249,node00269,node00002,influence,[complete=true,name=i4_1],[course=[[145,184],[176,230],[233.0786027342001,233.287116729031]]]).

arc(arc00047,node00030,node00034,influence,[complete=true,name=i10],[course=[[149,286],[141,266],[121,261]]]).

arc(arc00250,node00034,node00030,influence,[complete=true,name=i5_0],[course=[[249,261],[265,284],[294,286]]]).

arc(arc00033,node00036,node00035,influence,[name=i1],[]).

arc(arc00034,node00037,node00035,flow,[complete=true,name=rain],[bowtie=[61.05676738849999,24.0,73.05676738849999,48.0],caption_offset=[-24.975671119000012,-37.75671119200001],course=[[96.113534777,49.0],[38,23]]]).

arc(arc00035,node00038,arc00034,influence,[name=i2],[]).

arc(arc00036,node00039,node00035,flow,[complete=true,name=inflow],[bowtie=[62.05676738849999,52.0,74.05676738849999,76.0],caption_offset=[-21.821588207099992,1.9837807459999794],course=[[96.113534777,64.0],[40,64.0]]]).

arc(arc00037,node00040,arc00036,influence,[name=i3],[]).

arc(arc00038,node00035,node00041,flow,[complete=true,name=outflow],[bowtie=[211.12168910660003,45.00810962700001,223.12168910660003,69.00810962700001],caption_offset=[-23.916481632,-2.9637661889999407],course=[[235,57.00810962700001],[136.11353477699998,57.00810962700001]]]).

arc(arc00039,node00042,arc00038,influence,[name=i4],[]).

arc(arc00040,node00035,node00043,flow,[complete=true,name=evapotransp],[bowtie=[173.0567673885,26.0,185.0567673885,50.0],caption_offset=[-28.764820819000022,-37.691834176000015],course=[[222,25],[136.11353477699998,51.0]]]).

arc(arc00041,node00044,arc00040,influence,[name=i5],[]).

arc(arc00048,node00035,node00044,influence,[complete=true,name=i11,role=[use(none,in_hierarchy,water,1)]],[course=[[173,39],[151,35],[136,51]]]).

arc(arc00042,node00035,node00045,flow,[complete=true,name=drainage],[bowtie=[164.5567673885,69.5,176.5567673885,93.5],caption_offset=[-25.789149699999996,0.9918903730000466],course=[[205,96],[136.11353477699998,67.0]]]).

arc(arc00043,node00046,arc00042,influence,[name=i6],[]).

arc(arc00052,node00035,node00046,influence,[complete=true,name=i15,role=[use(none,in_hierarchy,water,1)]],[course=[[164,78],[153,65],[136,66]]]).

arc(arc00247,node00049,node00044,influence,[complete=true,name=i4_0,role=[use(none,in_hierarchy,water_demand,1),use(none,in_hierarchy,water_demand_0,1)]],[course=[[173,35],[152,13],[122,17]]]).

arc(arc00054,node00055,node00038,influence,[complete=true,name=i17,role=[use(none,in_hierarchy,rain,int)]],[course=[[61,36],[26.097315523149973,36.36493321219997],[-0.696821247100047,67.80626783039986]]]).

arc(arc00053,node00074,node00073,influence,[name=i1_0],[]).

arc(arc00072,node00035,node00074,influence,[complete=true,name=i2_0,role=[use(none,in_hierarchy,water,1)]],[course=[[96,87],[104,82],[106,73]]]).

arc(arc00077,node00077,node00040,influence,[complete=true,name=i16_0,role=[use(0,in_assoc,{interflow},list(1)),use(1,in_assoc,{interflow_0},list(1))]],[course=[[74,63],[175,94],[262.30317875289995,32.80626783039986]]]).

arc(arc00094,node00090,node00042,influence,[complete=true,name=i15_0,role=[use(0,in_assoc,{interflow},list(1)),use(0,in_assoc,{interflow_0},list(1)),use(1,in_assoc,{interflow_1},list(1)),use(1,in_assoc,{interflow_2},list(1))]],[course=[[223,53],[247,52],[262.30317875289995,32.80626783039986]]]).

arc(arc00244,node00263,node00049,influence,[name=i1_1],[]).

arc(arc00245,node00264,node00263,influence,[complete=true,name=i2_1,role=[use(none,in_hierarchy,[number],array(1,size(plant_species)))]],[course=[[110,10],[107,2],[99.30317875289995,-0.19373216960013906]]]).

arc(arc00246,node00265,node00263,influence,[complete=true,name=i3_0,role=[use(none,in_hierarchy,[water_use],array(1,size(plant_species)))]],[course=[[109,16],[47,1],[-0.696821247100047,42.80626783039986]]]).

arc(arc00088,node00035,node00266,influence,[complete=true,name=i9_0],[course=[[244.30317875289995,-0.19373216960013906],[178,-3],[136,48]]]).

arc(arc00051,node00054,node00011,influence,[name=i1],[]).

arc(arc00057,node00058,node00030,influence,[complete=true,name=i18],[course=[[24.949244851896633,155],[-1.9819452300670855,147.05271257524987],[-14.002341208330778,155.50531275709983]]]).

arc(arc00058,node00059,node00030,influence,[complete=true,name=i26],[course=[[252.21082000268936,27],[248.20124489109782,9.052712575249846],[245.10246388320638,7.505312757099722]]]).

arc(arc00059,node00060,node00034,influence,[complete=true,name=i13_0],[course=[[49,329],[22.947558082838945,341.908891026],[-14.127482644502175,344.50531275709994]]]).

arc(arc00060,node00061,node00034,influence,[complete=true,name=i18_0],[course=[[49,354],[14.466592881325033,354.05271257524987],[-13.156020133649902,372.50531275709994]]]).

arc(arc00061,node00063,node00062,influence,[name=i2],[]).

arc(arc00078,node00078,node00034,influence,[complete=true,name=i17],[course=[[312,319],[340.4965809120025,355.00484704391147],[357.88773667370504,367.5150068449228]]]).

arc(arc00081,node00082,node00081,influence,[name=i2_0],[]).

arc(arc00085,node00011,node00082,influence,[complete=true,name=i6,role=[use(none,in_hierarchy,row,int)]],[course=[[341,270],[373.60137033650005,228.0187351404],[341,196]]]).

arc(arc00086,node00062,node00082,influence,[complete=true,name=i7,role=[use(none,in_hierarchy,col,1)]],[course=[[342,271],[357.74734362150014,257.94574849955006],[339,232]]]).

arc(arc00082,node00081,node00083,influence,[complete=true,name=i3],[course=[[357.9960296161403,286.7767149382761],[349.5831658912202,277.4816181790881],[343,276]]]).

arc(arc00089,node00034,node00088,influence,[complete=true,name=i10_0],[course=[[357.9960296161403,342.77671493829],[329.55072738322,305.13570109059503],[311,295]]]).

arc(arc00064,node00011,node00095,influence,[complete=true,name=i5],[course=[[357.99638360156246,172.99999999999997],[350.5509043759312,177.24734362145006],[340,187]]]).

arc(arc00067,node00062,node00097,influence,[complete=true,name=i8],[course=[[357.99638360156246,208.0],[348.5509043759312,211.24734362145006],[339,221]]]).

arc(arc00099,node00030,node00109,influence,[complete=true,name=i16],[course=[[357.88926139364014,87.50531275709977],[337.4996161139596,74.99999999999997],[317.00454568397913,86]]]).

arc(arc00117,node00122,node00030,influence,[complete=true,name=i27],[course=[[317.00454568397913,143],[341.4996161139596,146.0],[357.88926139364014,126.5053127570998]]]).

arc(arc00121,node00125,node00030,influence,[complete=true,name=i31],[course=[[122.62336864010967,27],[112.71638185908446,12.999999999999972],[93.70396992775916,7.505312757099722]]]).

arc(arc00125,node00130,node00030,influence,[complete=true,name=i35],[course=[[175.8122479307208,27],[168.2776424755844,13.999999999999972],[152.63761187014802,7.505312757099722]]]).

arc(arc00233,node00246,node00050,influence,[complete=true,name=i1_0],[course=[[-14.025066063284692,225.99999999999997],[3.942864020382684,239.5377512645503],[8,257]]]).

arc(arc00222,node00247,node00246,influence,[name=i2_1],[]).

arc(arc00223,node00030,node00247,influence,[complete=true,name=i3_0,role=[use(none,in_hierarchy,[number],array(1,size(plant_species)))]],[course=[[15.959451865320005,266.68372454900003],[62.96756149227501,269.2255306271001],[121,261]]]).

arc(arc00224,node00249,node00247,influence,[complete=true,name=i4,role=[use(none,in_hierarchy,[fuel_per_indiv],array(1,size(plant_species)))]],[course=[[3,266],[-5.994809493026057,269.16065361110014],[-14.127482644502175,271.5053127570999]]]).

arc(arc00226,node00251,node00250,influence,[name=i6_0],[]).

arc(arc00140,node00252,node00030,influence,[complete=true,name=i4_0],[course=[[33.921397265800024,252.712883270969],[31.88771199033002,265.2429068584845],[18,287]]]).

arc(arc00227,node00253,node00252,influence,[name=i7_0],[]).

arc(arc00231,node00246,node00253,influence,[complete=true,name=i11,role=[use(none,in_hierarchy,fuel_load,1)]],[course=[[14,287],[14.08109626948,282.22273375659995],[11.935122984460005,270.0]]]).

arc(arc00232,node00250,node00253,influence,[complete=true,name=i12,role=[use(none,in_hierarchy,fuel_lost,1)]],[course=[[11.951342238300006,299.740491938],[-1.5608222020649953,306.70931137349976],[4,315]]]).

arc(arc00229,node00256,node00251,influence,[complete=true,name=i9,role=[use(none,in_hierarchy,[fuel_lost],array(1,size(fire_patch)))]],[course=[[1,319],[-5.523193187511058,318.17966973599994],[-14.127482644502175,324.50531275709994]]]).

arc(arc00066,node00056,node00064,influence,[complete=true,name=i7_0],[course=[[402.2430534811438,115.99585868300002],[377.1724311165033,99.24932777645013],[345.1018087518623,111.50279686990015]]]).

arc(arc00069,node00056,node00064,influence,[complete=true,name=i10],[course=[[402.2430534811438,132.99585868300002],[374.6724311165033,125.2493277764501],[345.1018087518623,146.50279686990015]]]).

arc(arc00070,node00056,node00064,relation,[complete=true,name=me],[caption_offset=[-0.9918903729999897,-9.918903730099999],course=[[402.2430534811438,160.99585868300002],[371.6274409118628,146.00198415500012],[345.01182834258105,161.008109627]]]).

arc(arc00071,node00056,node00064,relation,[complete=true,name='my\nneighbour'],[caption_offset=[6.923391061999951,16.870072962000023],course=[[402.2430534811438,175.99585868300002],[371.6443091716636,163.001984155],[345.0455648621828,180.008109627]]]).

arc(arc00079,node00064,node00056,influence,[complete=true,name=i18_1],[course=[[344.99316182400486,306.0178037148229],[376.47944657843505,315.4460089967612],[401.96573133286483,295.8742142786999]]]).

arc(arc00084,node00056,node00064,influence,[complete=true,name=i5],[course=[[402.19758158094453,231.00580588979886],[370.6495181736925,213.64265884898754],[345.1014547664401,225.2795118081762]]]).

arc(arc00091,node00056,node00064,influence,[complete=true,name=i12],[course=[[402.19758158094453,264.53978647234237],[368.6495181736925,258.4096491402661],[345.1014547664401,281.2795118081901]]]).

arc(arc00108,node00056,node00064,influence,[complete=true,name=i18_2],[course=[[402.2430534811438,35.995858683000016],[374.1188700125417,13.001984155000013],[344.99468654393996,26.00810962700001]]]).

arc(arc00118,node00064,node00056,influence,[complete=true,name=i28],[course=[[344.99468654393996,65.00810962700001],[378.98020893840226,86.4411619528503],[401.96573133286483,74.87421427870052]]]).

arc(arc00062,node00066,node00065,influence,[name=i3],[]).

arc(arc00063,node00068,node00067,influence,[name=i4],[]).

arc(arc00065,node00070,node00066,influence,[complete=true,name=i6,role=[use(0,in_base,row,int),use(1,in_base,row_0,int)]],[course=[[24,107],[14.553113933571812,100.8766309510999],[3.570584780143813,100.12164440429963]]]).

arc(arc00068,node00072,node00066,influence,[complete=true,name=i9,role=[use(0,in_base,col,1),use(1,in_base,col_0,1)]],[course=[[24,114],[13.553113933571812,111.37663095109976],[3.570584780143813,117.12164440429967]]]).

arc(arc00076,node00067,node00076,influence,[complete=true,name=i15],[course=[[3.2932626318648284,280.0],[18.490888790432404,293.1193142349],[30,287]]]).

arc(arc00093,node00079,node00068,influence,[complete=true,name=i14,role=[use(none,in_hierarchy,elevation_diff,1)]],[course=[[39,278],[55.045900501000006,246.85221556699997],[37.062119754999934,218.991717366]]]).

arc(arc00080,node00080,node00079,influence,[name=i1],[]).

arc(arc00083,node00084,node00080,influence,[complete=true,name=i4_0,role=[use(0,in_base,elevation,1),use(1,in_base,elevation_0,1)]],[course=[[28,210],[13.606813914472202,203.73661699244943],[3.525112879944524,215.13159161109874]]]).

arc(arc00092,node00085,node00068,influence,[complete=true,name=i13,role=[use(none,in_hierarchy,water,1)]],[course=[[37,278],[39.05961657900001,265.3986296630002],[32.01656526800001,257.028989219]]]).

arc(arc00087,node00086,node00085,influence,[name=i8],[]).

arc(arc00090,node00089,node00086,influence,[complete=true,name=i11,role=[use(0,in_base,water,1),use(1,in_base,water_0,1)]],[course=[[21,248],[9.157023313472244,241.45270585622112],[3.525112879944524,248.6655721936423]]]).

arc(arc00096,node00106,node00104,influence,[name=i13_0],[]).

arc(arc00100,node00110,node00106,influence,[complete=true,name=i17,role=[use(0,in_base,[seeds_dispersing],array(1,size(plant_species))),use(1,in_base,[seeds_dispersing_0],array(1,size(plant_species)))]],[course=[[21,31],[11.087363588571876,20.922699033499967],[3.570584780143813,20.12164440429943]]]).

arc(arc00114,node00104,node00117,influence,[complete=true,name=i24],[course=[[3.2932626318648284,59.00000000000003],[12.948702514432409,55.36187683135026],[21,42]]]).

arc(arc00122,node00099,node00056,influence,[complete=true,name=i32],[course=[[80.80939507805915,-53.99189037299999],[80.42126280697957,-69.96488530904998],[73.0331305359,-81.93788024509999]]]).

arc(arc00102,node00100,node00099,influence,[name=i2],[]).

arc(arc00126,node00014,node00056,influence,[complete=true,name=i36],[course=[[139.74303702044796,-53.99189037299999],[134.908790363224,-69.46281465049998],[123.074543706,-81.933738928]]]).

arc(arc00011,node00019,node00014,influence,[name=i1],[]).

arc(arc00225,node00244,node00056,influence,[complete=true,name=i5_0],[course=[[-27.022057494202116,210.008109627],[-35.41863307255105,208.51511284444993],[-52,206]]]).

arc(arc00221,node00245,node00244,influence,[name=i1_0],[]).

arc(arc00239,node00093,node00056,influence,[complete=true,name=i10_0],[course=[[-27.022057494202116,263.008109627],[-89.21903864959864,265.02002085166487],[-89.39945453699522,321.21415002432957]]]).

arc(arc00240,node00056,node00093,influence,[complete=true,name=i5],[course=[[-89.09762479204049,77.30466440494047],[-59.00863285251254,169.40373063742027],[-26.919640912984633,164.50279686990012]]]).

arc(arc00018,node00166,node00165,influence,[name=i1],[]).

arc(arc00234,node00143,node00166,influence,[complete=true,name=i2_0,role=[use(none,in_hierarchy,[fuel_load],array(1,size(patch)))]],[course=[[102,40],[163.0,76.0],[220.55735382569995,67.22105104948005]]]).

arc(arc00022,node00165,node00167,flow,[complete=true,name=burning_losses],[bowtie=[134.89754424581488,9.119083994369994,146.89754424581488,33.119083994369994],caption_offset=[-48.079358633855094,-37.77619232798347],course=[[172.01323155499995,21.119083994369994],[102,21.119083994369994]]]).

arc(arc00023,node00168,arc00022,influence,[name=i2],[]).

arc(arc00142,node00165,node00168,influence,[complete=true,name=i8_0,role=[use(none,in_hierarchy,fuel_load,1)]],[course=[[134,23],[105.40945490643443,32.65090848932903],[102,32]]]).

arc(arc00144,node00169,node00168,influence,[complete=true,name=i9_0,role=[use(none,in_hierarchy,fire,boolean)]],[course=[[139,33],[136.18763461889998,67.89236207225902],[56,63]]]).

arc(arc00030,node00170,node00169,influence,[name=i3],[]).

arc(arc00149,node00171,node00170,influence,[complete=true,name=i14,role=[use(none,in_hierarchy,new_fire,boolean)]],[course=[[46.12097135346173,69.42737240561735],[39.553963864260695,80.213780167562],[45,93]]]).

arc(arc00056,node00172,node00171,influence,[name=i4],[]).

arc(arc00150,node00173,node00170,influence,[complete=true,name=i15,role=[use(none,in_hierarchy,crossover,boolean)]],[course=[[53,68],[64.0700784508567,86.06057964157283],[94.21765887215169,90.87902864653825]]]).

arc(arc00103,node00174,node00173,influence,[name=i5],[]).

arc(arc00154,node00175,node00174,influence,[complete=true,name=i19,role=[use(none,in_hierarchy,catches,boolean)]],[course=[[107.21765887215169,92.87902864653825],[131.1088294360759,111.43951432326912],[158,99]]]).

arc(arc00104,node00176,node00175,influence,[name=i6],[]).

arc(arc00161,node00165,node00176,influence,[complete=true,name=i26,role=[use(none,in_hierarchy,fuel_load,1)]],[course=[[161,91],[139.58600510699998,55.506615777465],[97.17201021399998,44.01323155493]]]).

arc(arc00152,node00177,node00172,influence,[complete=true,name=i17,role=[use(none,in_hierarchy,starts,boolean)]],[course=[[51.18542969895967,104.18542969851656],[48.59271484947982,128.59271484925833],[68,140]]]).

arc(arc00105,node00178,node00177,influence,[name=i7],[]).

arc(arc00166,node00165,node00178,influence,[complete=true,name=i31,role=[use(none,in_hierarchy,fuel_load,1)]],[course=[[75,137],[83.7634894675394,98.02273036379516],[82,44]]]).

arc(arc00151,node00179,node00172,influence,[complete=true,name=i16,role=[use(none,in_hierarchy,spark_here,boolean)]],[course=[[48.18542969895967,105.18542969851656],[21.592714849479837,138.59271484925833],[34,173]]]).

arc(arc00106,node00180,node00179,influence,[name=i8],[]).

arc(arc00153,node00181,node00174,influence,[complete=true,name=i18,role=[use(none,in_hierarchy,neighbour_burns,boolean)]],[course=[[105.21765887215169,97.87902864653825],[101.10882943607582,128.43951432326912],[119,144]]]).

arc(arc00109,node00182,node00181,influence,[name=i9],[]).

arc(arc00110,node00184,node00183,influence,[name=i10],[]).

arc(arc00167,node00169,node00184,influence,[complete=true,name=i32,role=[use(none,in_hierarchy,fire,boolean)]],[course=[[189,138],[153.32231768828086,71.35261752930369],[56.12097135346173,63.427372405617334]]]).

arc(arc00172,node00185,node00182,influence,[complete=true,name=i1_1,role=[use(none,in_hierarchy,[other_fires],array(boolean,size(fire_patch)))]],[course=[[125,155],[112,185],[128.99399513839995,213.24751415938005]]]).

arc(arc00145,node00187,node00168,influence,[complete=true,name=i10_0,role=[use(none,in_hierarchy,burnt_per_step,1)]],[course=[[146,10],[151,6],[152.55735382569995,-0.778948950519947]]]).

arc(arc00155,node00188,node00176,influence,[complete=true,name=i20,role=[use(none,in_hierarchy,always_catch,int)]],[course=[[167,90],[180.64554710465,58.95368955805],[187.55735382569995,-0.778948950519947]]]).

arc(arc00158,node00189,node00176,influence,[complete=true,name=i23,role=[use(none,in_hierarchy,min_for_fire,int)]],[course=[[164,103],[130,154],[151.26625961639996,213.31367193338002]]]).

arc(arc00162,node00190,node00178,influence,[complete=true,name=i27,role=[use(none,in_hierarchy,always_starts,int)]],[course=[[67,142],[36,117],[-0.7337403836000362,127.31367193338004]]]).

arc(arc00165,node00191,node00178,influence,[complete=true,name=i30,role=[use(none,in_hierarchy,min_for_fire,int)]],[course=[[79,148],[98,198],[151.26625961639996,213.31367193338002]]]).

arc(arc00175,node00194,node00167,influence,[name=i1_3],[]).

arc(arc00168,node00183,node00195,influence,[complete=true,name=i33],[course=[[178.26625961639996,213.31367193338005],[208.7732820815,195.75801532099996],[195,151]]]).

arc(arc00179,node00196,node00180,influence,[complete=true,name=i18_0,role=[use(none,in_hierarchy,spark_patch,int)]],[course=[[34,186],[21,196],[22.993995138399953,213.24751415938005]]]).

arc(arc00185,node00197,node00180,influence,[complete=true,name=i24,role=[use(none,in_hierarchy,check_spark,boolean)]],[course=[[33,186],[28.281679343649998,196.98676844505002],[36.55735382569995,213.22105104948005]]]).

arc(arc00174,node00198,node00182,influence,[complete=true,name=i3_2,role=[use(none,in_hierarchy,[neighbours],array(1,4))]],[course=[[127,155],[132.69082686444034,170.4570149514625],[149.38165372888076,176.91402990292505]]]).

arc(arc00208,node00199,node00198,influence,[name=i1_0],[]).

arc(arc00210,node00200,node00199,influence,[complete=true,name=i3_0,role=[use(none,in_hierarchy,[[neighbours]],array(array(1,4),size(patch_results)))]],[course=[[153.38165372888076,188.91402990292505],[154.6938292952404,200.8332578717725],[167.0,214.0]]]).

arc(arc00217,node00167,node00201,influence,[complete=true,name=i6_1],[course=[[216.99399513839992,200.24751415938002],[205.1680013235931,130.88581764034825],[193,43]]]).

arc(arc00186,node00145,node00144,influence,[complete=true,name=i25],[course=[[93,231],[99.44110120402158,236.51576171467434],[115,252]]]).

arc(arc00111,node00146,node00145,influence,[name=i11],[]).

arc(arc00112,node00148,node00147,influence,[name=i12],[]).

arc(arc00134,node00149,node00148,influence,[complete=true,name=i1,role=[use(none,in_hierarchy,[other_fires],array(boolean,size(fire_patch)))]],[course=[[187,261],[207.20666842141821,270.9619703822557],[227.8862459177422,259.1750062809347]]]).

arc(arc00173,node00149,node00144,influence,[complete=true,name=i2_0],[course=[[185.43664131269998,231.02646310989996],[199.16144361522106,242.10073469541734],[228.8862459177422,254.17500628093472]]]).

arc(arc00113,node00150,node00149,influence,[name=i13],[]).

arc(arc00169,node00144,node00150,influence,[complete=true,name=i34,role=[use(none,in_hierarchy,[old_fire],array(boolean,size(fire_patch)))]],[course=[[236.8862459177422,252.17500628093472],[242.29757585422107,239.63381358241733],[234.7089057907,231.0926208839]]]).

arc(arc00129,node00147,node00151,influence,[complete=true,name=i1_0],[course=[[208.9951476654449,292.40358167467264],[202.6089298555546,263.93749711921447],[187,260]]]).

arc(arc00133,node00153,node00152,influence,[name=i20],[]).

arc(arc00170,node00147,node00153,influence,[complete=true,name=i2,role=[use(none,in_hierarchy,burning,boolean)]],[course=[[55.74624089219501,254.0087503140967],[111.79919224245597,278.31411237254804],[174,260]]]).

arc(arc00171,node00145,node00153,influence,[complete=true,name=i3,role=[use(none,in_hierarchy,check_spark,boolean)]],[course=[[56,254],[82.47674798393044,261.9554068454337],[114.27417187922939,257.0]]]).

arc(arc00146,node00155,node00144,influence,[complete=true,name=i11_0],[course=[[209,17],[209.30164533903326,13.58134599567678],[207.90766955749666,-3.559786088826264]]]).

arc(arc00156,node00156,node00144,influence,[complete=true,name=i21],[course=[[244,17],[252.95784672986105,13.581345995676891],[260.22007233915264,-3.559786088826264]]]).

arc(arc00159,node00157,node00144,influence,[complete=true,name=i24],[course=[[207.7089057907,231.0926208839],[216.08989695536175,278.85680303042113],[256.7752669994537,292.8985070967631]]]).

arc(arc00163,node00158,node00144,influence,[complete=true,name=i28],[course=[[55.7089057907,145.0926208839],[29.087309491212718,132.60918328823846],[-0.2299079288445339,139.40326761239723]]]).

arc(arc00180,node00161,node00144,influence,[complete=true,name=i19],[course=[[79.43664131269999,231.02646310989996],[72.49265939478735,254.07626143237616],[100.85305635630476,292.40358167467264]]]).

arc(arc00183,node00162,node00146,influence,[complete=true,name=i22,role=[use(none,in_hierarchy,spark_,boolean)]],[course=[[114.27417187922939,260.0],[95.27841069786729,270.57879159210034],[87.97899786712146,292.40358167467264]]]).

arc(arc00211,node00163,node00144,influence,[complete=true,name=i4],[course=[[223.44264617430005,231.77894895051995],[214.01557766717738,261.45250435268616],[239.89288803948492,292.40358167467264]]]).

arc(arc00218,node00144,node00164,influence,[complete=true,name=i7],[course=[[299.9718276556739,285.4938900718602],[304.0520450444719,248.1214156309701],[273.4366413127,218.02646310989996]]]).

arc(arc00235,node00257,node00144,influence,[complete=true,name=i3_0],[course=[[277,85],[295.6140481206892,102.47031856870845],[312.53247512080856,93.21815905723723]]]).

arc(arc00181,node00101,node00098,influence,[complete=true,name=i20],[course=[[188.16415723367405,275.4323425469602],[146.1732067522596,285.4228636750353],[115.18225627084524,301.4133848031106]]]).

arc(arc00184,node00101,node00098,influence,[complete=true,name=i23],[course=[[173.39818457179766,275.4323425469602],[126.94492438284846,282.4228636750353],[91.49166419389931,301.4133848031106]]]).

arc(arc00127,node00203,node00202,influence,[name=i14],[]).

arc(arc00128,node00205,node00204,influence,[name=i15],[]).

arc(arc00178,node00204,node00206,influence,[complete=true,name=i17],[course=[[81.61145458194015,-0.412876558199912],[65.73738949954463,11.536930478149404],[59.91793227077917,29.07386095629881]]]).

arc(arc00182,node00202,node00207,influence,[complete=true,name=i21],[course=[[57.92086250499421,-0.412876558199912],[41.77132222756567,-0.5369304786576254],[34.99179322707786,9.92613904268475]]]).

arc(arc00212,node00102,node00098,influence,[complete=true,name=i5],[course=[[347.6366619819396,275.4323425469602],[334.24353994053183,286.3105793219148],[334.85041789912333,298.18881609686974]]]).

arc(arc00191,node00211,node00210,influence,[name=i1],[]).

arc(arc00192,node00213,node00212,influence,[name=i2],[]).

arc(arc00193,node00215,node00214,influence,[name=i3],[]).

arc(arc00196,node00210,node00215,influence,[complete=true,name=i6,role=[use(none,in_hierarchy,row,int)]],[course=[[94,7],[74.0211007462472,-4.497739404772672],[54.04103386562688,6.049240637532524]]]).

arc(arc00194,node00217,node00216,influence,[name=i4],[]).

arc(arc00197,node00212,node00217,influence,[complete=true,name=i7,role=[use(none,in_hierarchy,col,1)]],[course=[[108,44],[81.08675493013215,33.59940267068194],[57.15592868653614,46.090274502142975]]]).

arc(arc00195,node00219,node00218,influence,[name=i5],[]).

arc(arc00198,node00214,node00219,influence,[complete=true,name=i8,role=[use(none,in_hierarchy,[row_neighbours],array(int,4))]],[course=[[156,22],[134.6928591646855,7.520516932305223],[106.1723422323803,10.041033864610446]]]).

arc(arc00199,node00216,node00219,influence,[complete=true,name=i9,role=[use(none,in_hierarchy,[col_neighbours],array(1,4))]],[course=[[155,26],[135.2544099621095,25.041033864610448],[120.29544382722808,44.082067729220896]]]).

arc(arc00202,node00220,node00211,influence,[complete=true,name=i12,role=[use(none,in_hierarchy,nrow,int)]],[course=[[41.14772191361406,8.016413545844156],[27.304561461844518,7.63643688022711],[15.355194997604862,14.068520090410125]]]).

arc(arc00204,node00221,node00213,influence,[complete=true,name=i14,role=[use(none,in_hierarchy,ncol,int)]],[course=[[44.15592868653614,50.090274502142975],[29.808664848305554,46.91622043018343],[15.355194997604862,56.47483690402399]]]).

arc(arc00206,node00222,node00219,influence,[complete=true,name=i16_0,role=[use(none,in_hierarchy,nrow,int)]],[course=[[157,22],[107.12404179491331,-27.44378805979292],[15.355194997604862,14.068520090410125]]]).

arc(arc00207,node00223,node00219,influence,[complete=true,name=i17,role=[use(none,in_hierarchy,ncol,int)]],[course=[[155.21337609699074,24.0],[80.97631988028282,6.357851624111934],[15.355194997604862,56.47483690402399]]]).

arc(arc00209,node00218,node00224,influence,[complete=true,name=i2_0],[course=[[181,-9],[163.2987223814804,4.620433172099953],[162,20]]]).

arc(arc00157,node00103,node00098,influence,[complete=true,name=i22],[course=[[370.9510385566616,-64.02448072166916],[376.70426367711264,-75.5699342924701],[385,-86]]]).

arc(arc00130,node00112,node00103,influence,[name=i17],[]).

arc(arc00147,node00114,node00098,influence,[complete=true,name=i12],[course=[[310.9510385566616,-64.02448072166916],[305.5135762674531,-72.28058383016712],[305,-83]]]).

arc(arc00131,node00115,node00114,influence,[name=i18],[]).

arc(arc00164,node00116,node00098,influence,[complete=true,name=i29],[course=[[72.22649169719968,99.94778524125707],[67.01400512385344,106.45258869948803],[60,113]]]).

arc(arc00132,node00131,node00116,influence,[name=i19],[]).

arc(arc00160,node00134,node00098,influence,[complete=true,name=i25],[course=[[367,276],[370.85423317806385,280.85416581258096],[381.01224036083454,285.9510385566617]]]).

arc(arc00148,node00135,node00134,influence,[name=i13],[]).

arc(arc00203,node00138,node00102,influence,[complete=true,name=i13_0],[course=[[169.20561289672824,321.2573361872798],[159.1808812222297,312.93997225207704],[150,315]]]).

arc(arc00200,node00139,node00138,influence,[name=i10],[]).

arc(arc00205,node00140,node00102,influence,[complete=true,name=i15],[course=[[169.20561289672824,363.66365300089365],[159.06077318600492,354.7566642656276],[151,357]]]).

arc(arc00201,node00141,node00140,influence,[name=i11],[]).

arc(arc00177,node00098,node00142,influence,[complete=true,name=i3_0],[course=[[365.2910584541987,324.3192148040841],[344.21186593212883,308.12198186521766],[312.1983275934362,275.4323425469602]]]).

arc(arc00220,node00098,node00142,influence,[complete=true,name=i9],[course=[[403.2966976791455,312.98191148873997],[419.4206160415873,288.74457249804414],[416.5445344040298,267.5072335073478]]]).

arc(arc00187,node00227,node00226,influence,[name=i1_0],[]).

arc(arc00176,node00225,node00229,influence,[complete=true,name=i2,role=[use(none,in_hierarchy,{burning},list(boolean))]],[course=[[37,18],[21.635450416324286,9.680636795977831],[3.662428350021571,10.93970265929147]]]).

arc(arc00188,node00229,node00228,influence,[name=i1],[]).

arc(arc00189,node00226,node00229,influence,[complete=true,name=i2_0,role=[use(none,in_hierarchy,time_in_2,1)]],[course=[[37.718471699788125,24.98775963916542],[31.932341420274376,36.775515284353496],[30,49]]]).

arc(arc00213,node00228,node00230,influence,[complete=true,name=i4],[course=[[71.43588791079304,-0.36009811796043323],[56.92574262220995,4.977810187851858],[48,16]]]).

arc(arc00219,node00231,node00229,influence,[complete=true,name=i8,role=[use(none,in_hierarchy,{[fuel_load_lost]},list(array(1,size(fire_patch))))]],[course=[[44,15],[44.638270028797685,6.011985138305774],[41.66806757496835,-0.3976006560526457]]]).

arc(arc00214,node00142,node00254,influence,[complete=true,name=i5_1],[course=[[460.00840186738225,300.00000000000006],[447.54076845829866,301.08450381933085],[433.0645180149702,313.0194140268322]]]).

arc(arc00236,node00258,node00098,influence,[complete=true,name=i4],[course=[[430.9510385566616,46.975519278330836],[445.56398395633676,59.95479797246966],[460.315196651782,52.07825171480828]]]).


