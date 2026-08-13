source(program='AME',version= 9.0,edition=standard,date='Tue Feb 05 11:37:53 GMT 2008').

roots([node00388,node00389,node00390,node00391,node00392,node00393,node00394,node00395,node00396,node00397,node00398,node00399]).

properties([comment-'Set up for ''medium'' soil',complete-true,file_name-'C:/Inetpub/wwwroot/www/examples/catalogue/models/bob/biome1/biome1.sml',multiplication_spec-[count=[]],name-biome1]).

node(node00388,submodel,[node00400,node00401,node00402,node00403,node00404,node00405,node00406,node00407,node00408,node00409,node00410,node00411,node00412,node00413,node00414,node00415,node00416,node00417,node00418,node00419,node00420,node00421,node00422,node00423,node00424,node00425,node00426,node00427,node00428,node00429,node00430,node00431,node00432,node00433,node00434,node00435,node00436,node00437,node00438,node00439,node00440,node00441,node00442,node00443,node00444,node00445,node00446,node00447,node00448,node00449,node00450,node00451,node00452,node00453,node00454,node00455,node00456],[complete=true,fill_colour='#80ff80',multiplication_spec=[count=[4]],name='VEGETATION TYPE'],[bounding_box=[-254,-85,75,301],caption_offset=[53,-9],internal_extent=[-2,-2,329,387]]).
links(node00388,[arc00449-arc00451,arc00449-arc00453,arc00449-arc00461,arc00450-arc00452,arc00450-arc00454,arc00450-arc00462,arc00468-arc00467,arc00468-arc00470,arc00475-arc00476,arc00475-arc00477,arc00481-arc00482,arc00484-arc00485,arc00487-arc00488]).
node(node00400,variable,[],[comment='Units must be mol(CO2) per month',complete=true,name='Aa'],[caption_offset=[0,0],centre=[208,108]]).
node(node00401,function,[],[complete=true,name=fn23,units=1,value=ap*phi_d*phi_t],[]).
node(node00402,variable,[],[complete=true,name=temp],[caption_offset=[-28,-16],centre=[111,16]]).
node(node00403,function,[],[complete=true,name=fn24,table_data=[file='/graph/',data=[25,5,400],indices=[0,12,400,0],current=[320,314,304,276,232,202,168,112,65,43,32,29,40,64,153,207,262,283,312,315,317],units=1,bounds=1,dims=21],units=1,value=graph(month)],[]).
node(node00404,variable,[],[comment='"Ratio of leaf respiration to photosynthetic capacity" (but also (p.653) described as merely "an empirical parameter")',complete=true,name=a],[caption_offset=[0,0],centre=[27,101]]).
node(node00405,function,[],[complete=true,name=fn25,units=1,value= 0.08],[]).
node(node00406,variable,[],[comment='"sigma is a dimensionless factor that depends only on the fractional daylength (td) and the ratio of leaf respiration to photosynthetic capacity (alpha)"',complete=true,name=sigma],[caption_offset=[0,0],centre=[92,118]]).
node(node00407,function,[],[complete=true,name=fn26,units=1,value=(1-alpha/td)^ 0.5],[]).
node(node00408,variable,[],[comment='"Ap = monthly potential photosynthesis"\nUnits must be mol(CO2) per month',complete=true,name='Ap'],[caption_offset=[0,0],centre=[164,103]]).
node(node00409,function,[],[complete=true,name=fn27,units=1,value=fpar*sigma*phi*im],[]).
node(node00410,variable,[],[comment='Value???   "fraction of incoming PAR absorbed by the green vegetation"',complete=true,name='FPAR'],[caption_offset=[0,0],centre=[131,48]]).
node(node00411,function,[],[complete=true,name=fn28,units=1,value= 0.5],[]).
node(node00412,variable,[],[comment='Value?????   "total monthly incident PAR"\nUnits nust be mol(photons) per month',complete=true,name='Im'],[caption_offset=[-7,-3],centre=[175,29]]).
node(node00413,function,[],[complete=true,name=fn29,table_data=[file='/graph/',data=[15,5,400],indices=[0,12,400,0],current=[258,258,247,239,219,201,168,112,65,43,32,29,40,64,153,202,239,247,252,257,261],units=1,bounds=1,dims=21],units=1,value=graph(month)],[]).
node(node00414,variable,[],[comment='"fractional daylength"',complete=true,name=td],[caption_offset=[-16,-25],centre=[53,78]]).
node(node00415,function,[],[complete=true,name=fn30,units=1,value= 0.5],[]).
node(node00416,variable,[],[comment='"quantum efficiency of gross photosynthesis at prescribed ambient CO2"\n"mol(CO2)/mol(photons)"\n"C3 plants at 13C = 0.07, at 38C = 0.04"\n"C4 plants = 0.054, at any temp"\n"Field values c. 50% lower"',complete=true,name=phi],[caption_offset=[0,0],centre=[86,63]]).
node(node00417,function,[],[complete=true,name=fn31,units=1,value=(if temp<13 then  0.07 else (if temp>38 then  0.04 else  0.04+ 0.03 *(temp-13)/(38-13)))],[]).
node(node00418,variable,[],[comment='"drought scalar, ratio of actual to equilibrium evapotranspiration for the month as calculated by the water flux model"',complete=true,name='PHI D'],[caption_offset=[0,0],centre=[260,126]]).
node(node00419,function,[],[complete=true,name=fn32,units=1,value=e/d],[]).
node(node00420,variable,[],[comment='"monthly temperature scalar, is set to unity across a range of temperatures from T2 to T3.   Below T2 the scalar decreases linearly to a value of zero at a temperature T1, and above T3 the scalar decreases to zero at a temperature T4"',complete=true,name='PHI T'],[caption_offset=[-13,0],centre=[188,142]]).
node(node00421,function,[],[complete=true,name=fn33,units=1,value=(if temp<5 then 0 else (if temp>35 then 0 else (if temp<20 then (temp-5)/(20-5) else (if temp>30 then (temp-30)/(35-30) else 1))))],[]).
node(node00422,variable,[],[complete=true,name=alpha],[caption_offset=[-25,-23],centre=[279,249]]).
node(node00423,function,[],[complete=true,name=fn48,units=1,value=z*w1/(z*w1+(1-z)*w2)],[]).
node(node00424,variable,[],[comment='element([0.5,0,0.5,0],index(1))',complete=true,name=f],[caption_offset=[0,0],centre=[151,268]]).
node(node00425,function,[],[complete=true,name=fn49,units=1,value=element([1,0,0,0],index(1))],[]).
node(node00426,variable,[],[comment='Instantaneous evapotranspiration rate, mm/hour.   In the paper, this is "integrated analytically over the 24 hour period".  In the present model, it is NOT.  Need to think about this: can we do numerically, by integrating over the fractiosn of a "typical day" for each month? (i.e. time unit = 1 month, time step = 0.05 ''day'')',complete=true,name='E'],[caption_offset=[0,0],centre=[176,202]]).
node(node00427,function,[],[complete=true,name=fn50,units=1,value=min(s,d)],[]).
node(node00428,variable,[],[complete=true,name=transp1],[caption_offset=[3,-35],centre=[281,214]]).
node(node00429,function,[],[complete=true,name=fn51,units=1,value=alpha*f*e],[]).
node(node00430,variable,[],[complete=true,name=beta],[caption_offset=[0,0],centre=[286,300]]).
node(node00431,function,[],[complete=true,name=fn52,units=1,value=(1-z)*w2/(z*w1+(1-z)*w2)],[]).
node(node00432,variable,[],[complete=true,name=transp2],[caption_offset=[0,0],centre=[278,353]]).
node(node00433,function,[],[complete=true,name=fn53,units=1,value=beta*f*e],[]).
node(node00434,variable,[],[complete=true,name='Z'],[caption_offset=[8,1],centre=[199,301]]).
node(node00435,function,[],[complete=true,name=fn1,units=1,value=element([ 0.33, 0.33, 0.9, 0.9],index(1))],[]).
node(node00436,border,[],[],[centre=[329,278]]).
node(node00437,border,[],[],[centre=[329,231]]).
node(node00438,border,[],[name=var8],[centre=[329,278]]).
node(node00439,border,[],[name=var9],[centre=[329,231]]).
node(node00440,variable,[],[complete=true,name='Wr'],[caption_offset=[0,0],centre=[125,315]]).
node(node00441,function,[],[complete=true,name=fn4_1,units=1,value=z*w1+(1-z)*w2],[]).
node(node00442,border,[],[name=var5],[centre=[329,276]]).
node(node00443,border,[],[name=var6],[centre=[329,230]]).
node(node00444,variable,[],[comment='mm/hour   "maximum possible rate of evapotranspiration by plant species"\nValue is given in paper.',complete=true,name='C'],[caption_offset=[0,0],centre=[87,235]]).
node(node00445,function,[],[complete=true,name=fn5,units=1,value=1],[]).
node(node00446,variable,[],[comment='"supply function" for plant species.  mm/hour',complete=true,name='S'],[caption_offset=[0,0],centre=[127,225]]).
node(node00447,function,[],[complete=true,name=fn6,units=1,value=c*wr],[]).
node(node00448,border,[],[name=var9_0],[centre=[329,86]]).
node(node00449,border,[],[name=var10],[centre=[329,86]]).
node(node00450,variable,[],[complete=true,name='Pnet'],[caption_offset=[0,0],centre=[237,44]]).
node(node00451,function,[],[complete=true,name=fn7,units=1,value=aa- 0.4 *ap],[]).
node(node00452,border,[],[name=var2],[centre=[310,6]]).
node(node00453,border,[],[name=var3],[centre=[310,6]]).
node(node00454,border,[],[name=var14],[centre=[329,134]]).
node(node00455,border,[],[name=var16],[centre=[329,201]]).
node(node00456,border,[],[name=var18],[centre=[329,298]]).
node(node00389,variable,[],[complete=true,name='D'],[caption_offset=[0,0],centre=[108,-46]]).
node(node00390,function,[],[complete=true,name=fn1,table_data=[file='/graph/',data=[ 0.3,0,400],indices=[0,12,400,0],current=[320,314,304,276,232,202,168,112,65,43,32,29,40,64,153,207,262,283,312,315,317],units=1,bounds=1,dims=21],units=1,value=graph(month)],[]).
node(node00391,variable,[],[complete=true,name=month],[caption_offset=[-10,-32],centre=[126,-91]]).
node(node00392,function,[],[complete=true,name=fn2,units=1,value=fmod(time(1),12)],[]).
node(node00393,variable,[],[complete=true,name=bare],[caption_offset=[0,0],centre=[118,30]]).
node(node00394,function,[],[complete=true,name=fn14,units=1,value=1-sum([f])],[]).
node(node00395,variable,[],[complete=true,name=total_transp1],[caption_offset=[0,0],centre=[117,77]]).
node(node00396,function,[],[complete=true,name=fn15,units=1,value=sum([transp1])],[]).
node(node00397,variable,[],[complete=true,name=total_transp2],[caption_offset=[0,0],centre=[120,216]]).
node(node00398,function,[],[complete=true,name=fn16,units=1,value=sum([transp2])],[]).
node(node00399,submodel,[node00495,node00496,node00497,node00498,node00499,node00500,node00501,node00502,node00503,node00504,node00505,node00506,node00507,node00508,node00509,node00510,node00511,node00512,node00513,node00514,node00515,node00516,node00517,node00518,node00519],[comment='Set up for ''medium'' soil',complete=true,file_name='C:/Dad/simile/DEMOS/Biome/waterb.sml',fill_colour='#3cffff',multiplication_spec=[count=[]],name='WATER'],[bounding_box=[177,-72,462,294],caption_offset=[40,-11],internal_extent=[-256,-124,-37,158]]).
links(node00399,[arc00483-arc00540,arc00486-arc00539,arc00489-arc00551,arc00552-arc00450,arc00553-arc00449]).
node(node00495,compartment,[],[comment=mm,complete=true,name='Water'],[caption_offset=[0,0],centre=[-98,6]]).
node(node00496,function,[],[complete=true,name=fn1,units=1,value=100],[]).
node(node00497,cloud,[],[complete=true,name=cd1],[centre=[-79,-83]]).
node(node00498,function,[],[complete=true,name=fn2,units=1,value=40],[]).
node(node00499,cloud,[],[complete=true,name=cd2],[centre=[-206,-5]]).
node(node00500,function,[],[complete=true,name=fn3,units=1,value=transp+transp2],[]).
node(node00501,cloud,[],[complete=true,name=cd3],[centre=[-172,-79]]).
node(node00502,function,[],[complete=true,name=fn4,units=1,value=20*bare],[]).
node(node00503,variable,[],[complete=true,name='W1'],[caption_offset=[0,0],centre=[-213,48]]).
node(node00504,function,[],[complete=true,name=fn5,units=1,value=water*thetamax1*d1/(d1+d2)],[]).
node(node00505,variable,[],[complete=true,name='W2'],[caption_offset=[0,0],centre=[-204,108]]).
node(node00506,function,[],[complete=true,name=fn6,units=1,value=water*thetamax2*d2/(d1+d2)],[]).
node(node00507,border,[],[complete=true,max_val=1,min_val=0,name=bare,units=1,value= 0.1],[caption_offset=[0,0],centre=[-256,-61]]).
node(node00508,border,[],[complete=true,max_val=500,min_val=0,name=total_transp1,units=1,value=15],[caption_offset=[0,0],centre=[-256,-22]]).
node(node00509,variable,[],[comment='mm: depth of upper layer',complete=true,name=d1],[caption_offset=[0,0],centre=[-155,53]]).
node(node00510,function,[],[complete=true,name=fn10,units=1,value=500],[]).
node(node00511,variable,[],[comment='mm: depth of lower layer',complete=true,name=d2],[caption_offset=[0,0],centre=[-144,90]]).
node(node00512,function,[],[complete=true,name=fn11,units=1,value=1500],[]).
node(node00513,variable,[],[complete=true,name=thetamax2],[caption_offset=[0,0],centre=[-86,89]]).
node(node00514,function,[],[complete=true,name=fn12,units=1,value=200],[]).
node(node00515,variable,[],[complete=true,name=thetamax1],[caption_offset=[0,0],centre=[-85,53]]).
node(node00516,function,[],[complete=true,name=fn13,units=1,value=300],[]).
node(node00517,border,[],[complete=true,max_val=500,min_val=0,name=total_transp2,units=1,value=20],[caption_offset=[0,0],centre=[-256,58]]).
node(node00518,border,[],[name=var3],[centre=[-256,47]]).
node(node00519,border,[],[name=var4],[centre=[-256,126]]).

arc(arc00413,node00401,node00400,influence,[name=i38],[curve=[0,0]]).
arc(arc00414,node00403,node00402,influence,[name=i39],[curve=[0,0]]).
arc(arc00415,node00405,node00404,influence,[name=i40],[curve=[0,0]]).
arc(arc00416,node00407,node00406,influence,[name=i41],[curve=[0,0]]).
arc(arc00426,node00404,node00407,influence,[complete=true,name=i54,role=[use(none,in_hierarchy,alpha,1)]],[curve=[4,-13]]).
arc(arc00422,node00408,node00401,influence,[complete=true,name=i50,role=[use(none,in_hierarchy,ap,1)]],[curve=[1,-8]]).
arc(arc00417,node00409,node00408,influence,[name=i42],[curve=[0,0]]).
arc(arc00423,node00406,node00409,influence,[complete=true,name=i51,role=[use(none,in_hierarchy,sigma,1)]],[curve=[-3,-15]]).
arc(arc00429,node00410,node00409,influence,[complete=true,name=i57,role=[use(none,in_hierarchy,fpar,1)]],[curve=[10,-7]]).
arc(arc00418,node00411,node00410,influence,[name=i43],[curve=[0,0]]).
arc(arc00428,node00412,node00409,influence,[complete=true,name=i56,role=[use(none,in_hierarchy,im,1)]],[curve=[14,-22]]).
arc(arc00419,node00413,node00412,influence,[name=i44],[curve=[0,0]]).
arc(arc00425,node00414,node00407,influence,[complete=true,name=i53,role=[use(none,in_hierarchy,td,1)]],[curve=[8,-8]]).
arc(arc00420,node00415,node00414,influence,[name=i45],[curve=[0,0]]).
arc(arc00424,node00416,node00409,influence,[complete=true,name=i52,role=[use(none,in_hierarchy,phi,1)]],[curve=[9,-16]]).
arc(arc00421,node00417,node00416,influence,[name=i46],[curve=[0,0]]).
arc(arc00427,node00402,node00417,influence,[complete=true,name=i55,role=[use(none,in_hierarchy,temp,1)]],[curve=[8,4]]).
arc(arc00432,node00418,node00401,influence,[complete=true,name=i60,role=[use(none,in_hierarchy,phi_d,1)]],[curve=[-4,10]]).
arc(arc00430,node00419,node00418,influence,[name=i58],[curve=[0,0]]).
arc(arc00433,node00420,node00401,influence,[complete=true,name=i61,role=[use(none,in_hierarchy,phi_t,1)]],[curve=[-6,-4]]).
arc(arc00431,node00421,node00420,influence,[name=i59],[curve=[0,0]]).
arc(arc00455,node00402,node00421,influence,[complete=true,name=i9_0,role=[use(none,in_hierarchy,temp,1)]],[curve=[28,-18]]).
arc(arc00434,node00423,node00422,influence,[name=i87],[curve=[0,0]]).
arc(arc00435,node00425,node00424,influence,[name=i88],[curve=[0,0]]).
arc(arc00471,node00426,node00419,influence,[complete=true,name=i17,role=[use(none,in_hierarchy,e,1)]],[curve=[-18,-18]]).
arc(arc00436,node00427,node00426,influence,[name=i89],[curve=[0,0]]).
arc(arc00437,node00429,node00428,influence,[name=i90],[curve=[0,0]]).
arc(arc00440,node00422,node00429,influence,[complete=true,name=i93,role=[use(none,in_hierarchy,alpha,1)]],[curve=[-6,-1]]).
arc(arc00441,node00424,node00429,influence,[complete=true,name=i94,role=[use(none,in_hierarchy,f,1)]],[curve=[-12,-30]]).
arc(arc00442,node00426,node00429,influence,[complete=true,name=i95,role=[use(none,in_hierarchy,e,1)]],[curve=[2,-24]]).
arc(arc00438,node00431,node00430,influence,[name=i91],[curve=[0,0]]).
arc(arc00439,node00433,node00432,influence,[name=i92],[curve=[0,0]]).
arc(arc00443,node00424,node00433,influence,[complete=true,name=i96,role=[use(none,in_hierarchy,f,1)]],[curve=[19,-29]]).
arc(arc00444,node00426,node00433,influence,[complete=true,name=i97,role=[use(none,in_hierarchy,e,1)]],[curve=[34,-24]]).
arc(arc00445,node00430,node00433,influence,[complete=true,name=i98,role=[use(none,in_hierarchy,beta,1)]],[curve=[10,1]]).
arc(arc00447,node00434,node00423,influence,[complete=true,name=i2,role=[use(none,in_hierarchy,z,1)]],[curve=[-12,-18]]).
arc(arc00448,node00434,node00431,influence,[complete=true,name=i3,role=[use(none,in_hierarchy,z,1)]],[curve=[0,-19]]).
arc(arc00446,node00435,node00434,influence,[name=i1],[curve=[0,0]]).
arc(arc00451,node00436,node00423,influence,[complete=true,name=i9,role=[use(none,in_hierarchy,w2,1)]],[curve=[-7,11]]).
arc(arc00452,node00437,node00431,influence,[complete=true,name=i8,role=[use(none,in_hierarchy,w1,1)]],[curve=[15,10]]).
arc(arc00453,node00438,node00431,influence,[complete=true,name=i14,role=[use(none,in_hierarchy,w2,1)]],[curve=[4,9]]).
arc(arc00454,node00439,node00423,influence,[complete=true,name=i15,role=[use(none,in_hierarchy,w1,1)]],[curve=[3,10]]).
arc(arc00459,node00441,node00440,influence,[name=i5_0],[]).
arc(arc00460,node00434,node00441,influence,[complete=true,name=i6_0,role=[use(none,in_hierarchy,z,1)]],[curve=[2,14]]).
arc(arc00461,node00442,node00441,influence,[complete=true,name=i7_0,role=[use(none,in_hierarchy,w2,1)]],[curve=[9,50]]).
arc(arc00462,node00443,node00441,influence,[complete=true,name=i8_1,role=[use(none,in_hierarchy,w1,1)]],[curve=[20,49]]).
arc(arc00463,node00445,node00444,influence,[name=i9_1],[]).
arc(arc00469,node00446,node00427,influence,[complete=true,name=i15_0,role=[use(none,in_hierarchy,s,1)]],[curve=[-5,-9]]).
arc(arc00464,node00447,node00446,influence,[name=i10_0],[]).
arc(arc00465,node00440,node00447,influence,[complete=true,name=i11_0,role=[use(none,in_hierarchy,wr,1)]],[curve=[-20,0]]).
arc(arc00466,node00444,node00447,influence,[complete=true,name=i12_0,role=[use(none,in_hierarchy,c,1)]],[curve=[-2,-8]]).
arc(arc00467,node00448,node00427,influence,[complete=true,name=i13_0,role=[use(none,in_hierarchy,d,1)]],[curve=[27,36]]).
arc(arc00470,node00449,node00419,influence,[complete=true,name=i16,role=[use(none,in_hierarchy,d,1)]],[curve=[8,15]]).
arc(arc00472,node00451,node00450,influence,[name=i18],[]).
arc(arc00473,node00408,node00451,influence,[complete=true,name=i19,role=[use(none,in_hierarchy,ap,1)]],[curve=[-13,-16]]).
arc(arc00474,node00400,node00451,influence,[complete=true,name=i20,role=[use(none,in_hierarchy,aa,1)]],[curve=[-13,-6]]).
arc(arc00476,node00452,node00403,influence,[complete=true,name=i3_0,role=[use(none,in_hierarchy,month,1)]],[curve=[-40,-2]]).
arc(arc00477,node00453,node00413,influence,[complete=true,name=i4,role=[use(none,in_hierarchy,month,1)]],[curve=[4,32]]).
arc(arc00481,node00424,node00454,influence,[complete=true,name=i28],[curve=[-32,-44]]).
arc(arc00484,node00428,node00455,influence,[complete=true,name=i31],[curve=[-3,-10]]).
arc(arc00487,node00432,node00456,influence,[complete=true,name=i35],[curve=[-12,-12]]).
arc(arc00468,node00389,node00388,influence,[complete=true,name=i14],[curve=[10,8]]).
arc(arc00456,node00390,node00389,influence,[name=i1],[]).
arc(arc00458,node00391,node00390,influence,[complete=true,name=i4,role=[use(none,in_hierarchy,month,1)]],[curve=[8,4]]).
arc(arc00475,node00391,node00388,influence,[complete=true,name=i2_0],[curve=[2,16]]).
arc(arc00457,node00392,node00391,influence,[name=i2],[]).
arc(arc00478,node00394,node00393,influence,[name=i25],[]).
arc(arc00482,node00388,node00394,influence,[complete=true,name=i29,role=[use(none,in_hierarchy,[f],array(1,4))]],[curve=[-5,-10]]).
arc(arc00479,node00396,node00395,influence,[name=i26],[]).
arc(arc00485,node00388,node00396,influence,[complete=true,name=i32,role=[use(none,in_hierarchy,[transp1],array(1,4))]],[curve=[-9,-10]]).
arc(arc00480,node00398,node00397,influence,[name=i27],[]).
arc(arc00488,node00388,node00398,influence,[complete=true,name=i36,role=[use(none,in_hierarchy,[transp2],array(1,4))]],[curve=[0,-10]]).
arc(arc00449,node00399,node00388,influence,[complete=true,name=i9,role=[use(none,in_hierarchy,w2,1)]],[curve=[-16,26]]).
arc(arc00450,node00399,node00388,influence,[complete=true,name=i8,role=[use(none,in_hierarchy,w1,1)]],[curve=[-2,26]]).
arc(arc00483,node00393,node00399,influence,[complete=true,name=i30,role=[use(none,in_hierarchy,bare,1)]],[curve=[-4,-14]]).
arc(arc00486,node00395,node00399,influence,[complete=true,name=i34,role=[use(none,in_hierarchy,total_transp1,1)]],[curve=[-4,-14]]).
arc(arc00489,node00397,node00399,influence,[complete=true,name=i38,role=[use(none,in_hierarchy,total_transp2,1)]],[curve=[-12,-13]]).
arc(arc00528,node00496,node00495,influence,[name=i1],[curve=[0,0]]).
arc(arc00529,node00497,node00495,flow,[comment='mm/month',complete=true,name=rain],[caption_offset=[0,0],curve=[550,508]]).
arc(arc00530,node00498,arc00529,influence,[name=i2],[curve=[0,0]]).
arc(arc00531,node00495,node00499,flow,[complete=true,name=transpiration],[caption_offset=[-27,-2],curve=[550,500]]).
arc(arc00532,node00500,arc00531,influence,[name=i3],[curve=[0,0]]).
arc(arc00533,node00495,node00501,flow,[complete=true,name=evaporation],[caption_offset=[-38,-2],curve=[593,500]]).
arc(arc00534,node00502,arc00533,influence,[name=i4],[curve=[0,0]]).
arc(arc00535,node00504,node00503,influence,[name=i5],[curve=[0,0]]).
arc(arc00537,node00495,node00504,influence,[complete=true,name=i10,role=[use(none,in_hierarchy,water,1)]],[curve=[8,22]]).
arc(arc00536,node00506,node00505,influence,[name=i6],[curve=[0,0]]).
arc(arc00538,node00495,node00506,influence,[complete=true,name=i11,role=[use(none,in_hierarchy,water,1)]],[curve=[20,21]]).
arc(arc00540,node00507,node00502,influence,[complete=true,name=i14,role=[use(none,in_hierarchy,bare,1)]],[curve=[4,-28]]).
arc(arc00539,node00508,node00500,influence,[complete=true,name=i12,role=[use(none,in_hierarchy,transp,1)]],[curve=[7,-23]]).
arc(arc00545,node00509,node00504,influence,[complete=true,name=i19,role=[use(none,in_hierarchy,d1,1)]],[curve=[0,11]]).
arc(arc00550,node00509,node00506,influence,[complete=true,name=i24,role=[use(none,in_hierarchy,d1,1)]],[curve=[11,10]]).
arc(arc00541,node00510,node00509,influence,[name=i15],[curve=[0,0]]).
arc(arc00547,node00511,node00506,influence,[complete=true,name=i21,role=[use(none,in_hierarchy,d2,1)]],[curve=[4,12]]).
arc(arc00549,node00511,node00504,influence,[complete=true,name=i23,role=[use(none,in_hierarchy,d2,1)]],[curve=[-8,14]]).
arc(arc00542,node00512,node00511,influence,[name=i16],[curve=[0,0]]).
arc(arc00548,node00513,node00506,influence,[complete=true,name=i22,role=[use(none,in_hierarchy,thetamax2,1)]],[curve=[4,26]]).
arc(arc00543,node00514,node00513,influence,[name=i17],[curve=[0,0]]).
arc(arc00546,node00515,node00504,influence,[complete=true,name=i20,role=[use(none,in_hierarchy,thetamax1,1)]],[curve=[0,28]]).
arc(arc00544,node00516,node00515,influence,[name=i18],[curve=[0,0]]).
arc(arc00551,node00517,node00500,influence,[complete=true,name=i40,role=[use(none,in_hierarchy,transp2,1)]],[curve=[-12,-24]]).
arc(arc00552,node00503,node00518,influence,[complete=true,name=i1_0],[curve=[0,9]]).
arc(arc00553,node00505,node00519,influence,[complete=true,name=i2_0],[curve=[4,11]]).

