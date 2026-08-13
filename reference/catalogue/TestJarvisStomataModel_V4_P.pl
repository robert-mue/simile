source(program='AME',version=8.9,edition=standard,date='Fri Nov 30 09:56:41 GMT 2007').

roots([node00004,node00005]).

properties([complete-true,file_name-'C:/Documents and Settings/jmm.KONTIKI/My Documents/Program Files/ExampleModels/Maestra/StomatalConductance/TestJarvisStomataModel.sml',name-'TestJarvisStomataModel_V4_P',separate-0]).

node(node00004,submodel,[node00006,node00007,node00008,node00009,node00010,node00011,node00012,node00013,node00014,node00015,node00016,node00017],[complete=true,fill_colour='#cff845',multiplication_spec=[count=[]],name='JarvisStomatal Conductance',separate=0],[bounding_box=[-81,73,595,343],caption_offset=[0,0],hide_contents=0,internal_extent=[0,69,676,338]]).
links(node00004,[arc00038-arc00004,arc00039-arc00011,arc00040-arc00018,arc00041-arc00037]).
node(node00006,variable,[],[complete=true,max_val=1,min_val=0,name='Gs_max',param_type=file,spec=[],units=1],[bounding_box=[31,141,45,155],caption_offset=[0,0]]).
node(node00007,function,[],[comment='No comment',max_val=2500,min_val=0,name=fn1_0,units=1,value='PFD'],[]).
node(node00008,variable,[],[name=var3_0],[]).
node(node00009,variable,[],[complete=true,name='Gs'],[bounding_box=[47,251,61,265],caption_offset=[0,0]]).
node(node00010,function,[],[comment='No comment',complete=true,description='Stomatal conductance to water vapour Jarvis model',name=fn4_1,spec=[71,115,95,109,97,120,42,71,115,95,80,70,68,42,71,115,86,80,68,42,71,115,84,42,71,115,67,79,50],units=1,value='Gs_max'*'Gs_PFD'*'GsVPD'*'GsT'*'GsCO2'],[]).
node(node00011,variable,[],[name=var6],[]).
node(node00012,submodel,[node00018,node00019,node00020,node00021,node00022,node00023],[comment='Gs as a normalised function of PFD',complete=true,file_name='C:/Documents and Settings/jmm.KONTIKI/My Documents/Program Files/ExampleModels/Maestra/StomatalConductance/PFD/gs_pfd_ecocraft.sml',fill_colour='#ffff00',multiplication_spec=[count=[]],name='GsPFD',separate=0],[bounding_box=[108,118,210,262],caption_offset=[3,-6],hide_contents=0,internal_extent=[-8,47,100,199]]).
links(node00012,[arc00004-arc00009,arc00010-arc00005]).
node(node00018,variable,[],[complete=true,description='Intial slope of of stomatal conductance to PFD curve',max_val=1,min_val=0,name='Gsl',param_type=file,spec=[],units=1],[bounding_box=[68,108,80,121],caption_offset=[9,1]]).
node(node00019,variable,[],[complete=true,description='Stomatal conductance in the dark',max_val=1,min_val=0,name='Gdark',param_type=file,spec=[],units=1],[bounding_box=[28,153,40,165],caption_offset=[20,-3]]).
node(node00020,variable,[],[complete=true,name='Gs_PFD'],[bounding_box=[12,79,24,92],caption_offset=[33,-22]]).
node(node00021,function,[],[comment='No comment',complete=true,max_val=1,min_val=0,name=fn2,units=1,value='Gsl'*('PFD'+'Gdark'/'Gsl')/(1+'Gsl'*('PFD'+'Gdark'/'Gsl'))],[]).
node(node00022,variable,[],[name=var12],[]).
node(node00023,variable,[],[name=var13],[]).
node(node00013,submodel,[node00024,node00025,node00026,node00027,node00028,node00029],[comment='Gs as a normalised function of PFD',complete=true,file_name='C:/Documents and Settings/jmm.KONTIKI/My Documents/Program Files/ExampleModels/Maestra/StomatalConductance/VPD/gsvpd_maestro1991.sml',fill_colour='#80ffff',multiplication_spec=[count=[]],name='GsVPD',separate=0],[bounding_box=[231,119,316,260],caption_offset=[-5,-8],hide_contents=0,internal_extent=[-22,-18,63,123]]).
links(node00013,[arc00011-arc00016,arc00017-arc00012]).
node(node00024,variable,[],[complete=true,name='GsVPD'],[bounding_box=[-6,39,0,45],caption_offset=[14,-1]]).
node(node00025,function,[],[complete=true,name=fn3,spec='g=1-(VPD-Dthresh)/(D0-Dthresh),\nmax(min(g,1.0),0)',units=1,value=(g=1-('VPD'-'Dthresh')/('D0'-'Dthresh'),max(min(g,1.0),0))],[]).
node(node00026,variable,[],[complete=true,max_val=3000,min_val=0,name='D0',param_type=file,spec=[],units=1],[bounding_box=[34,78,40,84],caption_offset=[5,0]]).
node(node00027,variable,[],[complete=true,name='Dthresh',param_type=file,spec=[],units=1],[bounding_box=[35,-8,44,1],caption_offset=[0,0]]).
node(node00028,variable,[],[name=var2],[]).
node(node00029,variable,[],[name=var3],[]).
node(node00014,variable,[],[name=var9],[]).
node(node00015,submodel,[node00030,node00031,node00032,node00033,node00034,node00035,node00036,node00037,node00038],[complete=true,file_name='F:/ame/Maestro/StomatalConductance/temperature/gstmaestro1991.sml',fill_colour='#ff8080',multiplication_spec=[count=[]],name='GsT',separate=0],[bounding_box=[336,119,491,260],caption_offset=[1,-4],hide_contents=0,internal_extent=[-25,41,130,182]]).
links(node00015,[arc00018-arc00020,arc00030-arc00019]).
node(node00030,variable,[],[name=var8],[]).
node(node00031,variable,[],[complete=true,name='GsT'],[bounding_box=[-21,89,-9,101],caption_offset=[25,-26]]).
node(node00032,function,[],[complete=true,max_val=1,min_val=0.1,name=fn4,spec='g=(Temperature-Tmin)*(Tmax-Temperature)^p/((T0-Tmin)*(Tmax-T0)^p),\nmin(max(g,0),1)',units=1,value=(g=('Temperature'-'Tmin')*('Tmax'-'Temperature')^p/(('T0'-'Tmin')*('Tmax'-'T0')^p),min(max(g,0),1))],[]).
node(node00033,variable,[],[complete=true,max_val=30,min_val=10,name='Topt',param_type=file,spec=[],units=1],[bounding_box=[47,136,58,147],caption_offset=[11,2]]).
node(node00034,variable,[],[complete=true,max_val=10,min_val=0,name='Tmin',param_type=file,spec=[],units=1],[bounding_box=[1,145,12,156],caption_offset=[21,0]]).
node(node00035,variable,[],[complete=true,max_val=40,min_val=10,name='Tmax',param_type=file,spec=[],units=1],[bounding_box=[94,116,105,128],caption_offset=[9,4]]).
node(node00036,variable,[],[complete=true,name=p],[bounding_box=[54,74,65,85],caption_offset=[13,-17]]).
node(node00037,function,[],[complete=true,name=fn3_0,units=1/1,value=('Tmax'-'Topt')/('Topt'-'Tmin')],[]).
node(node00038,variable,[],[],[]).
node(node00016,submodel,[node00039,node00040,node00041,node00042,node00043,node00044],[complete=true,enum_types=[],file_name='C:/Documents and Settings/jmm.KONTIKI/My Documents/Program Files/ExampleModels/Maestra/StomatalConductance/CO2/gsco2linearmaestroecocraft.sml',fill_colour='#c0c0c0',multiplication_spec=[count=[]],name='GsCO2',separate=0],[bounding_box=[504,115,646,256],caption_offset=[6,-6],hide_contents=0,internal_extent=[-63,-28,79,113]]).
links(node00016,[arc00036-arc00031,arc00037-arc00035]).
node(node00039,variable,[],[complete=true,name='GsCO2'],[bounding_box=[-12,27,-6,33],caption_offset=[35,-28]]).
node(node00040,function,[],[complete=true,max_val=1.0,min_val=0.0,name=fn5,spec='g=1-gsja*(CO2Conc-averageCO2),\nmax(min(g,1.0),0.0)',units=1,value=(g=1-gsja*('CO2Conc'-averageCO2),max(min(g,1.0),0.0))],[]).
node(node00041,variable,[],[complete=true,max_val=0.01,min_val=0,name=gsja,param_type=file,spec=[],units=1],[bounding_box=[13,92,19,98],caption_offset=[31,-15]]).
node(node00042,variable,[],[complete=true,max_val=700,min_val=200,name=averageCO2,param_type=file,spec=[],units=1],[bounding_box=[36,47,42,53],caption_offset=[4,-5]]).
node(node00043,variable,[],[name=var2],[]).
node(node00044,variable,[],[name=var3],[]).
node(node00017,variable,[],[name=var11],[]).
node(node00005,submodel,[node00047,node00048,node00049,node00050,node00051,node00052,node00053,node00054,node00055,node00056,node00064,node00070],[complete=true,file_name='C:/Documents and Settings/jmm.KONTIKI/My Documents/Program Files/ExampleModels/Maestra/StomatalConductance/Environment/EnvironmentFromDataFile.sml',fill_colour='#b3f8ff',multiplication_spec=[count=[]],name='Environment',separate=0],[bounding_box=[25,-78,532,11],caption_offset=[6,-1],hide_contents=0,internal_extent=[-10,-2,513,90]]).
links(node00005,[arc00053-arc00038,arc00054-arc00039,arc00055-arc00040,arc00056-arc00041]).
node(node00047,variable,[],[name=var5_0],[]).
node(node00048,variable,[],[name=var6_0],[]).
node(node00049,variable,[],[name=var7],[]).
node(node00050,variable,[],[name=var8_0],[]).
node(node00051,variable,[],[complete=true,max_val=2000,min_val=0,name='PFD',units=1],[bounding_box=[60,46,75,61],caption_offset=[0,0]]).
node(node00052,variable,[],[complete=true,max_val=1,min_val=0,name='RH',units=1],[bounding_box=[142,24,157,39],caption_offset=[-21,-6]]).
node(node00053,variable,[],[complete=true,max_val=2.5,min_val=0,name='VPD',units=1],[bounding_box=[169,43,184,58],caption_offset=[0,0]]).
node(node00054,variable,[],[complete=true,max_val=40,min_val= -40,name='Temperature',units=1],[bounding_box=[288,47,303,62],caption_offset=[0,0]]).
node(node00055,variable,[],[complete=true,max_val=400,min_val=300,name='CO2Conc',units=1],[bounding_box=[440,44,455,59],caption_offset=[0,0]]).
node(node00056,function,[],[complete=true,name='VPD_0',spec='SVP*(1-RH)',units=1,value='SVP'*(1-'RH')],[]).
node(node00064,variable,[],[complete=true,name='SVP'],[bounding_box=[227,33,242,48],caption_offset=[0,0]]).
node(node00070,function,[],[comment='temperature is in degrees C \nsvp is the saturated vapour pressure,in kPa from the                                  \nTetens\' formula from Montieth and Unsworth, 1990, Principles of    \nEnvironmental Physics p10, adapted for T in deg C                 \nValues are within 1 Pa upto 35 deg C',complete=true,description='Saturated Vapour Pressure',name='SVP_0',spec=[48,46,54,49,49,42,101,120,112,40,49,55,46,50,55,42,84,101,109,112,101,114,97,116,117,114,101,47,40,84,101,109,112,101,114,97,116,117,114,101,43,50,51,55,46,49,53,41,41],units=1,value=0.611*exp(17.27*'Temperature'/('Temperature'+237.15))],[]).

arc(arc00002,node00010,node00009,influence,[name=i7_1],[]).
arc(arc00003,node00006,node00010,influence,[complete=true,name=i12_0,role=[use(none,in_hierarchy,'Gs_max',1)]],[course=[[53,250],[48,208],[39,156]]]).
arc(arc00004,node00008,node00012,influence,[complete=true,name=i3],[course=[[141,118],[156,95],[146,69]]]).
arc(arc00005,node00012,node00010,influence,[complete=true,name=i11_0,role=[use(none,in_hierarchy,'Gs_PFD',1/1)]],[course=[[62,259],[88,261],[108,243]]]).
arc(arc00006,node00018,node00021,influence,[complete=true,name=i2_0,role=[use(none,in_hierarchy,'Gsl',1)]],[course=[[24,91],[52,116],[66,113]]]).
arc(arc00007,node00019,node00021,influence,[complete=true,name=i4,role=[use(none,in_hierarchy,'Gdark',1)]],[course=[[20,93],[25,123],[32,152]]]).
arc(arc00008,node00021,node00020,influence,[name=i2],[]).
arc(arc00009,node00022,node00021,influence,[complete=true,name=i2_2,role=[use(none,in_hierarchy,'PFD',1)]],[course=[[20,78],[31,64],[27,47]]]).
arc(arc00010,node00020,node00023,influence,[complete=true,name=i11_0,role=[use(none,in_hierarchy,'Gs_PFD',1/1)]],[course=[[-8,179],[26,142],[19,93]]]).
arc(arc00011,node00011,node00013,influence,[complete=true,name=i7],[course=[[254,119],[266,94],[254,69]]]).
arc(arc00012,node00013,node00010,influence,[complete=true,name=i10_0,role=[use(none,in_hierarchy,'GsVPD',1/1)]],[course=[[61,260],[161,293],[243,260]]]).
arc(arc00013,node00025,node00024,influence,[name=i3],[]).
arc(arc00014,node00026,node00025,influence,[complete=true,name=i12,role=[use(none,in_hierarchy,'D0',1)]],[course=[[1,49],[14,65],[31,77]]]).
arc(arc00015,node00027,node00025,influence,[complete=true,name=i3_0,role=[use(none,in_hierarchy,'Dthresh',1)]],[course=[[4,39],[21,23],[35,3]]]).
arc(arc00016,node00028,node00025,influence,[complete=true,name=i6,role=[use(none,in_hierarchy,'VPD',1)]],[course=[[0,35],[12,9],[1,-18]]]).
arc(arc00017,node00024,node00029,influence,[complete=true,name=i10_0,role=[use(none,in_hierarchy,'GsVPD',1/1)]],[course=[[-10,123],[5,90],[-2,50]]]).
arc(arc00018,node00014,node00015,influence,[complete=true,name=i11],[course=[[365,119],[383,97],[377,69]]]).
arc(arc00019,node00015,node00010,influence,[complete=true,name=i9_0,role=[use(none,in_hierarchy,'GsT',1*(1*1)/1*(1*1))]],[course=[[61,259],[222,335],[343,256]]]).
arc(arc00020,node00030,node00032,influence,[complete=true,name=i10,role=[use(none,in_hierarchy,'Temperature',1)]],[course=[[-13,88],[7,68],[3,41]]]).
arc(arc00021,node00032,node00031,influence,[name=i4],[]).
arc(arc00022,node00033,node00032,influence,[complete=true,name=i6_0,role=[use(none,in_hierarchy,'T0',1)]],[course=[[-10,101],[16,131],[45,140]]]).
arc(arc00023,node00034,node00032,influence,[complete=true,name=i3_0,role=[use(none,in_hierarchy,'Tmin',1)]],[course=[[-13,102],[-6,126],[3,144]]]).
arc(arc00024,node00035,node00032,influence,[complete=true,name=i7_0,role=[use(none,in_hierarchy,'Tmax',1)]],[course=[[-9,100],[34,135],[92,120]]]).
arc(arc00025,node00036,node00032,influence,[complete=true,name=i1_2,role=[use(none,in_hierarchy,p,1/1)]],[course=[[-8,96],[34,100],[54,84]]]).
arc(arc00026,node00037,node00036,influence,[name=i4_2],[]).
arc(arc00027,node00034,node00037,influence,[complete=true,name=i5_2,role=[use(none,in_hierarchy,'Tmin',1)]],[course=[[53,84],[21,107],[11,144]]]).
arc(arc00028,node00033,node00037,influence,[complete=true,name=i6_2,role=[use(none,in_hierarchy,'Topt',1)]],[course=[[59,87],[58,108],[54,134]]]).
arc(arc00029,node00035,node00037,influence,[complete=true,name=i7_2,role=[use(none,in_hierarchy,'Tmax',1)]],[course=[[62,87],[70,110],[94,116]]]).
arc(arc00030,node00031,node00038,influence,[complete=true,name=i9_0,role=[use(none,in_hierarchy,'GsT',1*(1*1)/1*(1*1))]],[course=[[-19,178],[-10,146],[-14,102]]]).
arc(arc00031,node00016,node00010,influence,[complete=true,name=i2,role=[use(none,in_hierarchy,'GsCO2',1/1)]],[course=[[61,261],[289,381],[516,255]]]).
arc(arc00032,node00040,node00039,influence,[name=i5],[]).
arc(arc00033,node00041,node00040,influence,[complete=true,name=i4_1,role=[use(none,in_hierarchy,gsja,1)]],[course=[[-9,37],[-10,76],[10,91]]]).
arc(arc00034,node00042,node00040,influence,[complete=true,name=i6_1,role=[use(none,in_hierarchy,averageCO2,1)]],[course=[[-3,34],[12,45],[34,44]]]).
arc(arc00035,node00043,node00040,influence,[complete=true,name=i13,role=[use(none,in_hierarchy,'CO2Conc',1)]],[course=[[-9,22],[2,-4],[-13,-28]]]).
arc(arc00036,node00039,node00044,influence,[complete=true,name=i8_1,role=[use(none,in_hierarchy,'Gs1CO2',1)]],[course=[[-51,112],[-22,77],[-11,37]]]).
arc(arc00037,node00017,node00016,influence,[complete=true,name=i14],[course=[[554,115],[560,89],[543,69]]]).
arc(arc00038,node00005,node00004,influence,[complete=true,name=i4_0],[course=[[65,73],[89,43],[89,11]]]).
arc(arc00039,node00005,node00004,influence,[complete=true,name=i8],[course=[[173,73],[195,42],[193,11]]]).
arc(arc00040,node00005,node00004,influence,[complete=true,name=i12],[course=[[296,73],[318,42],[317,11]]]).
arc(arc00041,node00005,node00004,influence,[complete=true,name=i24],[course=[[462,73],[480,40],[475,11]]]).
arc(arc00053,node00051,node00047,influence,[complete=true,name=i1],[course=[[57,90],[69,77],[65,60]]]).
arc(arc00054,node00053,node00048,influence,[complete=true,name=i5],[course=[[164,90],[177,76],[174,57]]]).
arc(arc00055,node00054,node00049,influence,[complete=true,name=i9],[course=[[292,90],[300,76],[295,61]]]).
arc(arc00056,node00055,node00050,influence,[complete=true,name=i22],[course=[[454,90],[459,73],[449,59]]]).
arc(arc00042,node00056,node00053,influence,[complete=true,name=i2],[]).
arc(arc00043,node00052,node00056,influence,[complete=true,name=i3_0,role=[use(none,in_hierarchy,usr('RH'),1)]],[course=[[171,44],[163,36],[157,30]]]).
arc(arc00051,node00064,node00056,influence,[complete=true,name=i4_0,role=[use(none,in_hierarchy,usr('SVP'),1)]],[course=[[183,48],[207,38],[227,40]]]).
arc(arc00057,node00070,node00064,influence,[name=i1_0],[]).
arc(arc00058,node00054,node00070,influence,[complete=true,name=i5_1,role=[use(none,in_hierarchy,usr('Temperature'),1)]],[course=[[242,43],[266,43],[288,51]]]).

