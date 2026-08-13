source(program='AME',version= 9.0,edition=standard,date='Wed Feb 06 17:25:59 GMT 2008').

roots([node00002,node00003,node00004,node00005,node00006,node00007,node00009,node00010,node00011,node00012,node00013,node00014,node00015,node00016,node00017,node00018,node00019,node00020,node00021,node00022,node00023,node00024,node00025,node00026,node00027,node00028,node00029,node00030,node00031,node00032,node00033,node00034]).

properties([comment-'Climate submodel from DNDC 7.1\n   daylength and horizontal potential insolation for day\n      from Swift (1976) Water Resour Res 12:108 and Sellers (1965) Physical Climatology\n   Half daylength and declination equations from:\n       Swift, L.W.Jr.(1976). Algorithm for solar radiation on mountain\n       slopes. Water Resources Research, 12(1) 118-112.\nFixed minor bug in DNDC 7.4 which didn''t handle the south pole properly.',complete-true,file_name-'C:/Documents and Settings/jmm.KONTIKI/My Documents/Program Files/ExampleModels/DNDC/DNDC7.4/climate.sml',multiplication_spec-[count=[]],name-'SolarRadiationDNDCP',separate-0]).

node(node00002,variable,[],[complete=true,description='Latitude (degrees)',max_val=90,min_val= -90,name='Latitude',spec=[53,52],units=1,value=54],[caption_offset=[0,0],centre=[-386,180]]).
node(node00003,variable,[],[comment='Values from 0 (totally opaque) to 1 (no cloud). Of course clouds are not totally opaque.',complete=true,description='Cloud transmissivity (dimensionless)',max_val= 1.0,min_val=0,name=cloud,spec=[48,46,52,56],units=1,value= 0.48],[caption_offset=[0,0],centre=[-392,-82]]).
node(node00004,variable,[],[comment='abs(lat) < 90 degrees',complete=true,description='Latitude (radians)',name=lat],[caption_offset=[0,0],centre=[-282,178]]).
node(node00005,function,[],[complete=true,name=fn2,spec=[108,61,76,97,116,105,116,117,100,101,42,112,105,40,41,47,49,56,48,46,48,44,10,105,102,32,97,98,115,40,108,42,49,46,48,41,62,61,112,105,40,41,47,50,32,116,104,101,110,32,115,103,110,40,108,42,49,46,48,41,42,40,112,105,40,41,47,50,45,48,46,48,49,41,32,101,108,115,101,32,108],units=1,value=(l='Latitude'*pi('')/ 180.0,if abs(l* 1.0)>=pi('')/2 then sgn(l* 1.0)*(pi('')/2- 0.01) else l)],[]).
node(node00006,variable,[],[comment='solar max Lean 1991 Rev. Geophysics 29',complete=true,description='Solar constant (W m^2)',name='Solar Constant'],[caption_offset=[0,0],centre=[-300,34]]).
node(node00007,function,[],[complete=true,name=fn3,spec=[49,51,54,55,46,48],units=1,value= 1367.0],[]).
node(node00009,variable,[],[comment='r = 1.0 - .0167 * (float)cos(.0172 * (Jday - 3))',complete=true,description='radius vector of the sun',name=r,param_type=file,spec=[],units=1],[caption_offset=[0,0],centre=[-250,-30]]).
node(node00010,variable,[],[complete=true,name='Z'],[caption_offset=[0,0],centre=[-280,102]]).
node(node00011,variable,[],[complete=true,description='Day of Year',name='Jday'],[caption_offset=[0,0],centre=[-394,-22]]).
node(node00012,function,[],[complete=true,name=fn2_0,spec=[116,105,109,101,40,41],units=1,value=time('')],[]).
node(node00013,function,[],[complete=true,name=fn3_0,units=1,value= 1.0 - 0.0167 *cos( 0.0172*('Jday'-3))],[]).
node(node00014,function,[],[complete=true,name=fn1_0,spec=[46,51,57,56,32,42,32,115,105,110,40,52,46,56,54,57,32,43,32,46,48,49,55,50,32,42,32,74,100,97,121,32,43,32,46,48,51,51,52,32,42,32,115,105,110,40,54,46,50,50,52,32,43,32,46,48,49,55,50,32,42,32,74,100,97,121,41,41],units=1,value= 0.398 *sin( 4.869+ 0.0172 *'Jday'+ 0.0334 *sin( 6.224+ 0.0172 *'Jday'))],[]).
node(node00015,variable,[],[complete=true,description='Declination of the sun (radians)',name=decl],[caption_offset=[0,0],centre=[-222,104]]).
node(node00016,function,[],[complete=true,name=fn1_1,spec=[105,102,32,97,98,115,40,90,41,32,60,32,46,55,32,116,104,101,110,32,97,116,97,110,40,90,32,47,32,40,40,49,32,45,32,90,32,94,50,41,94,48,46,53,41,41,10,101,108,115,101,32,112,105,40,41,47,32,50,32,45,32,97,116,97,110,40,40,49,32,45,32,90,94,50,41,94,48,46,53,32,47,32,90,41],units=1,value=(if abs('Z')< 0.7 then atan('Z'/(1-'Z'^2)^ 0.5) else pi('')/2-atan((1-'Z'^2)^ 0.5 /'Z'))],[]).
node(node00017,variable,[],[complete=true,name=z2],[caption_offset=[0,0],centre=[-164,172]]).
node(node00018,function,[],[complete=true,name=fn2_1,spec=[45,116,97,110,40,100,101,99,108,41,32,42,32,116,97,110,40,108,97,116,41],units=1,value= - (tan(decl)*tan(lat))],[]).
node(node00019,variable,[],[complete=true,name='AC'],[caption_offset=[0,0],centre=[-106,134]]).
node(node00020,function,[],[complete=true,name=fn1_2,spec=[84,65,32,61,32,97,98,115,40,122,50,41,44,10,105,102,32,84,65,32,60,32,46,55,32,116,104,101,110,32,49,46,53,55,49,32,45,32,97,116,97,110,40,84,65,32,47,32,40,49,32,45,32,84,65,94,50,41,94,48,46,53,41,10,101,108,115,101,32,97,116,97,110,40,40,49,32,45,32,84,65,94,50,41,94,48,46,53,32,47,32,84,65,41],units=1,value=('TA'=abs(z2),if'TA'< 0.7 then  1.571-atan('TA'/(1-'TA'^2)^ 0.5) else atan((1-'TA'^2)^ 0.5 /'TA'))],[]).
node(node00021,variable,[],[complete=true,name=acos],[caption_offset=[0,0],centre=[-42,170]]).
node(node00022,function,[],[complete=true,name=fn2_2,spec=[105,102,32,122,50,60,48,32,116,104,101,110,32,51,46,49,52,49,54,45,65,67,32,10,101,108,115,101,32,65,67],units=1,value=(if z2<0 then  3.1416-'AC' else 'AC')],[]).
node(node00023,variable,[],[complete=true,description='Sun elevation angle at noon (radians)',name='H'],[caption_offset=[0,0],centre=[66,168]]).
node(node00024,function,[],[complete=true,name=fn1_3,spec=[105,102,32,122,50,62,61,49,32,116,104,101,110,32,48,32,10,101,108,115,101,105,102,32,122,50,60,61,32,45,49,32,116,104,101,110,32,112,105,40,41,10,101,108,115,101,32,97,99,111,115],units=1,value=(if z2>=1 then 0 elseif z2<= -1 then pi('') else acos)],[]).
node(node00025,variable,[],[complete=true,description='potential insolation on a horizontal plane, J/m^2/day',name=psolrad],[caption_offset=[0,0],centre=[104,10]]).
node(node00026,function,[],[complete=true,name=fn1_4,spec=[105,115,99,32,42,32,40,56,54,52,48,48,32,47,32,40,51,46,49,52,49,54,32,42,32,114,42,114,41,41,32,42,32,40,72,32,42,32,115,105,110,40,108,97,116,41,32,42,32,115,105,110,40,100,101,99,108,41,32,43,99,111,115,40,108,97,116,41,32,42,32,99,111,115,40,100,101,99,108,41,32,42,32,115,105,110,40,72,41,41],units=1,value=isc*(86400/( 3.1416*r*r))*('H'*sin(lat)*sin(decl)+cos(lat)*cos(decl)*sin('H'))],[]).
node(node00027,variable,[],[complete=true,description='Insolation (MJ/m^2/day)',name=solrad],[caption_offset=[0,0],centre=[134,-60]]).
node(node00028,function,[],[complete=true,name=fn2_3,spec=[112,115,111,108,114,97,100,32,42,32,99,108,111,117,100,32,47,32,49,48,48,48,48,48,48,46,48],units=1,value=psolrad*cloud/ 1000000.0],[]).
node(node00029,variable,[],[complete=true,description='PAR (moles/m^2/day)',name='DayPAR'],[caption_offset=[0,0],centre=[216,-28]]).
node(node00030,function,[],[complete=true,name=fn1_5,spec=[115,111,108,114,97,100,42,50,46,48,53],units=1,value=solrad* 2.05],[]).
node(node00031,variable,[],[complete=true,description='Length of day (hr)',name='Day_Hrs'],[caption_offset=[0,0],centre=[136,172]]).
node(node00032,function,[],[complete=true,name=fn1_6,spec=[50,32,42,32,40,72,32,42,32,50,52,41,32,47,32,40,50,32,42,32,51,46,49,52,49,54,41],units=1,value=2*('H'*24)/(2* 3.1416)],[]).
node(node00033,variable,[],[complete=true,description='Daily instantaneous PAR (umol m^-2 s^-1)',name='PARc'],[caption_offset=[0,0],centre=[272,64]]).
node(node00034,function,[],[complete=true,name=fn1_7,units=1,value='DayPAR'/('Day_Hrs'* 0.0036)],[]).

arc(arc00002,node00005,node00004,influence,[name=i2],[]).
arc(arc00003,node00002,node00005,influence,[complete=true,name=i3,role=[use(none,in_hierarchy,'Latitude',1)]],[curve=[-4,0]]).
arc(arc00004,node00007,node00006,influence,[name=i4],[]).
arc(arc00006,node00012,node00011,influence,[name=i2_0],[]).
arc(arc00007,node00013,node00009,influence,[name=i3_0],[]).
arc(arc00008,node00011,node00013,influence,[complete=true,name=i4_0,role=[use(none,in_hierarchy,usr('Jday'),1)]],[curve=[29,-2]]).
arc(arc00005,node00014,node00010,influence,[name=i1_0],[]).
arc(arc00009,node00011,node00014,influence,[complete=true,name=i2_1,role=[use(none,in_hierarchy,'Jday',1)]],[curve=[-37,66]]).
arc(arc00010,node00016,node00015,influence,[name=i1_1],[]).
arc(arc00011,node00010,node00016,influence,[complete=true,name=i2_2,role=[use(none,in_hierarchy,'Z',1)]],[curve=[14,-2]]).
arc(arc00012,node00018,node00017,influence,[name=i3_1],[]).
arc(arc00013,node00004,node00018,influence,[complete=true,name=i1_2,role=[use(none,in_hierarchy,lat,1)]],[curve=[30,-5]]).
arc(arc00014,node00015,node00018,influence,[complete=true,name=i2_3,role=[use(none,in_hierarchy,decl,1)]],[curve=[8,8]]).
arc(arc00015,node00020,node00019,influence,[name=i1_3],[]).
arc(arc00016,node00017,node00020,influence,[complete=true,name=i2_4,role=[use(none,in_hierarchy,z2,1)]],[curve=[-10,-2]]).
arc(arc00017,node00022,node00021,influence,[name=i3_2],[]).
arc(arc00018,node00019,node00022,influence,[complete=true,name=i4_1,role=[use(none,in_hierarchy,'AC',1)]],[curve=[8,11]]).
arc(arc00019,node00017,node00022,influence,[complete=true,name=i5,role=[use(none,in_hierarchy,z2,1)]],[curve=[-2,-4]]).
arc(arc00020,node00024,node00023,influence,[name=i1_4],[]).
arc(arc00022,node00021,node00024,influence,[complete=true,name=i3_3,role=[use(none,in_hierarchy,acos,1)]],[curve=[4,-6]]).
arc(arc00023,node00017,node00024,influence,[complete=true,name=i4_2,role=[use(none,in_hierarchy,z2,1)]],[curve=[-8,74]]).
arc(arc00021,node00026,node00025,influence,[name=i1_5],[]).
arc(arc00025,node00006,node00026,influence,[complete=true,name=i3_4,role=[use(none,in_hierarchy,usr(isc),1)]],[curve=[108,-8]]).
arc(arc00026,node00009,node00026,influence,[complete=true,name=i4_3,role=[use(none,in_hierarchy,r,1)]],[curve=[48,6]]).
arc(arc00027,node00023,node00026,influence,[complete=true,name=i5_0,role=[use(none,in_hierarchy,'H',1)]],[curve=[4,-32]]).
arc(arc00028,node00004,node00026,influence,[complete=true,name=i6,role=[use(none,in_hierarchy,lat,1)]],[curve=[78,-28]]).
arc(arc00029,node00015,node00026,influence,[complete=true,name=i7,role=[use(none,in_hierarchy,decl,1)]],[curve=[-2,-22]]).
arc(arc00024,node00028,node00027,influence,[name=i2_5],[]).
arc(arc00030,node00025,node00028,influence,[complete=true,name=i1_6,role=[use(none,in_hierarchy,psolrad,1)]],[curve=[-2,-4]]).
arc(arc00031,node00003,node00028,influence,[complete=true,name=i2_6,role=[use(none,in_hierarchy,cloud,1)]],[curve=[-62,-50]]).
arc(arc00032,node00030,node00029,influence,[name=i1_7],[]).
arc(arc00033,node00027,node00030,influence,[complete=true,name=i2_7,role=[use(none,in_hierarchy,solrad,1)]],[curve=[7,-2]]).
arc(arc00034,node00032,node00031,influence,[name=i1_8],[]).
arc(arc00035,node00023,node00032,influence,[complete=true,name=i2_8,role=[use(none,in_hierarchy,'H',1)]],[curve=[13,0]]).
arc(arc00036,node00034,node00033,influence,[name=i1_9],[]).
arc(arc00037,node00029,node00034,influence,[complete=true,name=i2_9,role=[use(none,in_hierarchy,'DayPAR',1)]],[curve=[13,18]]).
arc(arc00038,node00031,node00034,influence,[complete=true,name=i3_5,role=[use(none,in_hierarchy,usr('Day_Hrs'),1)]],[curve=[21,-14]]).

