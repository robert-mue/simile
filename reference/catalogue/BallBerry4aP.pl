source(program='AME',version= 9.0,edition=standard,date='Mon Feb 04 23:32:45 GMT 2008').

roots([node00020,node00021]).

properties([complete-true,file_name-'C:/Documents and Settings/jmm.KONTIKI/My Documents/Program Files/ExampleModels/iteration/BallBerry3.sml',fill_colour-'#ffffff',fix_math_args-0,image_posn-none,multiplication_spec-[count=[]],name-'BallBerry4aP',separate-0,step-1]).

node(node00020,submodel,[node00022,node00023,node00024,node00025,node00026,node00027,node00028,node00029,node00030],[complete=true,enum_types=[],fill_colour='#ffffff',image_posn=none,multiplication_spec=[count=[]],name='Environment',separate=0],[bounding_box=[90,-331,281,-238],caption_offset=[0,0],internal_extent=[0,0,191,93]]).
links(node00020,[arc00011-arc00018,arc00013-arc00017,arc00015-arc00019]).
node(node00022,border,[],[],[centre=[61,93]]).
node(node00023,border,[],[],[centre=[0,72]]).
node(node00024,border,[],[],[centre=[98,93]]).
node(node00025,variable,[],[comment='Typical diurnal graph (24 hour)',complete=true,description='Relative humidity (proportion)',name='H'],[caption_offset=[-2,-34],centre=[90,45]]).
node(node00026,function,[],[complete=true,name=fn3,spec='graph(time())',table_data=[file='/graph/',data=['1','0.7','400'],indices=['0','24','400','2'],current=['54','61','61','62','61','57','56','54','54','53','52','52','52','52','53','53','53','52','52','51','50','50','52','53','54','55','55','55','54','53','55','58','63','67','72','82','99','106','114','123','133','151','175','185','192','199','202','206','216','238','243','248','250','253','255','258','259','259','258','258','257','255','252','250','247','242','236','229','220','211','203','192','183','173','162','153','142','120','85','66','51'],units=1,bounds=1,dims='81'],units=1,value=graph(time(''))],[]).
node(node00027,variable,[],[comment='Graph for a sunny day (24 hours)',complete=true,description='Photon flux density (umol m^-2 s^-1)',name='Q'],[caption_offset=[-1,-35],centre=[44,45]]).
node(node00028,function,[],[complete=true,name=fn5,spec='graph(time())',table_data=[file='/graph/',data=['1500','0','400'],indices=['0','24','400','0'],current=['395','395','395','388','319','167','119','103','85','75','71','74','83','100','135','191','374','394','395','394','398'],units=1,bounds=1,dims='21'],units=1,value=graph(time(''))],[]).
node(node00029,variable,[],[comment='Typical diurnal curve in forest canopy',complete=true,description='Carbon dioxide concentration (umol CO2 (mol air)^-1)',name='C_a'],[caption_offset=[-2,-34],centre=[136,44]]).
node(node00030,function,[],[complete=true,name=fn8,spec='graph(time())',table_data=[file='/graph/',data=['370','340','400'],indices=['0','23','400','0'],current=['53','51','51','53','60','80','157','231','300','347','368','381','382','370','356','339','304','262','184','90','55'],units=1,bounds=1,dims='21'],units=1,value=graph(time(''))],[]).
node(node00021,submodel,[node00031,node00032,node00033,node00034,node00035,node00036,node00037,node00038,node00039,node00040],[complete=true,enum_types=[],fill_colour='#ffffff',image_posn=none,multiplication_spec=[count=[]],name='Ball-Berry',separate=0],[bounding_box=[-259,-179,252,241],caption_offset=[54,-2],internal_extent=[0,24,511,444]]).
links(node00021,[arc00017-arc00021,arc00018-arc00022,arc00019-arc00023]).
node(node00031,border,[],[],[centre=[376,24]]).
node(node00032,variable,[],[complete=true,name='Gs_start'],[caption_offset=[0,0],centre=[428,312]]).
node(node00033,function,[],[complete=true,name=fn4,spec='if time()==0 then g_0 else last(Gs_0)',units=1,value=(if time('')==0 then g_0 else last('Gs_0'))],[]).
node(node00034,border,[],[],[centre=[402,24]]).
node(node00035,border,[],[],[centre=[221,24]]).
node(node00036,submodel,[node00041,node00042,node00043,node00044,node00045,node00046,node00047,node00048,node00049,node00050,node00051,node00052,node00053,node00054,node00055,node00056],[complete=true,enum_types=[],fill_colour='#ffffff',fix_math_args=0,image_posn=none,multiplication_spec=[count=[]],name='Iteration time step',separate=0],[bounding_box=[22,51,387,378],caption_offset=[36,-1],internal_extent=[0,0,365,327]]).
links(node00036,[arc00021-arc00040,arc00022-arc00046,arc00023-arc00047,arc00025-arc00036,arc00043-arc00024,arc00050-arc00048,arc00053-arc00049]).
node(node00041,submodel,[node00057,node00058,node00059,node00060,node00061,node00062,node00063],[complete=true,enum_types=[],fill_colour='#ffffff',image_posn=none,multiplication_spec=[count=[]],name='Assimilation',separate=0],[bounding_box=[32,32,215,182],caption_offset=[0,0],internal_extent=[0,0,182,150]]).
links(node00041,[arc00026-arc00045,arc00033-arc00028,arc00040-arc00031]).
node(node00057,border,[],[],[centre=[72,0]]).
node(node00058,border,[],[name=var2],[centre=[182,82]]).
node(node00059,border,[],[name=var4],[centre=[101,150]]).
node(node00060,variable,[],[complete=true,description='Assimation (umol CO2 m^-2 s^-1)',name='A'],[caption_offset=[-18,-2],centre=[74,85]]).
node(node00061,function,[],[complete=true,name=fn1,spec='A_Q*Gs',units=1,value='A_Q'*'Gs'],[]).
node(node00062,variable,[],[comment='Relationship of Assimilation with photon flux density (light) when stomatal conductance (Gs) is maximum',complete=true,description='Assimilation light response curve',name='A_Q'],[caption_offset=[-24,-14],centre=[42,19]]).
node(node00063,function,[],[complete=true,name=fn4,spec='graph(Q)',table_data=[file='/graph/',data=['15','0','400'],indices=['0','1600','400','0'],current=['337','284','250','225','207','186','155','107','53','22','16','8','0','0','0','0','0','1','3','1','0'],units=1,bounds=1,dims='21'],units=1,value=graph('Q')],[]).
node(node00042,alarm,[],[complete=true,name=al1],[caption_offset=[0,0],centre=[275,208]]).
node(node00043,function,[],[complete=true,name=fn1,spec='abs(Gs-Gs_0)<0.001',units=boolean,value=(abs('Gs'-'Gs_0')< 0.001)],[]).
node(node00044,variable,[],[complete=true,name='Gs'],[caption_offset=[0,0],centre=[174,280]]).
node(node00045,function,[],[complete=true,name=fn3,spec='if loop_count==0 then Gs_start else Gs_0',units=1,value=(if loop_count==0 then 'Gs_start' else 'Gs_0')],[]).
node(node00046,border,[],[name=var8],[centre=[365,215]]).
node(node00047,border,[],[name=var9],[centre=[365,264]]).
node(node00048,variable,[],[complete=true,name=loop_count],[caption_offset=[-13,1],centre=[322,234]]).
node(node00049,function,[],[complete=true,name=fn5,spec='iterations(al1)',units=int,value=iterations(al1)],[]).
node(node00050,border,[],[],[centre=[156,0]]).
node(node00051,border,[],[],[centre=[337,2]]).
node(node00052,border,[],[],[centre=[351,10]]).
node(node00053,variable,[],[comment='Ball-Berry equation',complete=true,description='Stomatal conductance (mol m^-2 s^-1)',name='Gs_0'],[caption_offset=[-21,-32],centre=[272,112]]).
node(node00054,function,[],[complete=true,name='Gs_0_0',spec='g_0+g_1*A*H/C_a',units=1,value=g_0+g_1*'A'*'H'/'C_a'],[]).
node(node00055,border,[],[],[centre=[365,141]]).
node(node00056,border,[],[],[centre=[365,78]]).
node(node00037,variable,[],[complete=true,description='Stomatal conductance in the dark (mol m^-2 s^-1)',name=g_0],[caption_offset=[-1,-33],centre=[467,217]]).
node(node00038,function,[],[complete=true,name=fn6,spec='0.01',units=1,value= 0.01],[]).
node(node00039,variable,[],[complete=true,description='Ball-Berry stomatal conductance coefficient',name=g_1],[caption_offset=[-1,-34],centre=[488,92]]).
node(node00040,function,[],[complete=true,name=fn7,spec='23',units=1,value=23],[]).

arc(arc00011,node00025,node00022,influence,[complete=true,name=i6,role=[use(none,in_hierarchy,'H',1)]],[curve=[10,6]]).
arc(arc00012,node00026,node00025,influence,[name=i5],[]).
arc(arc00013,node00027,node00023,influence,[complete=true,name=i10,role=[use(none,in_hierarchy,'Q',1)]],[curve=[6,10]]).
arc(arc00014,node00028,node00027,influence,[name=i9],[]).
arc(arc00015,node00029,node00024,influence,[complete=true,name=i16,role=[use(none,in_hierarchy,'C_a',1)]],[curve=[10,8]]).
arc(arc00016,node00030,node00029,influence,[name=i15],[]).
arc(arc00017,node00020,node00021,influence,[complete=true,name=i10,role=[use(none,in_hierarchy,'Q',1)]],[curve=[20,32]]).
arc(arc00018,node00020,node00021,influence,[complete=true,name=i6,role=[use(none,in_hierarchy,'H',1)]],[curve=[15,8]]).
arc(arc00019,node00020,node00021,influence,[complete=true,name=i16,role=[use(none,in_hierarchy,'C_a',1)]],[curve=[14,12]]).
arc(arc00020,node00033,node00032,influence,[name=i21],[]).
arc(arc00021,node00035,node00036,influence,[complete=true,name=i10,role=[use(none,in_hierarchy,'Q',1)]],[curve=[6,12]]).
arc(arc00022,node00031,node00036,influence,[complete=true,name=i6,role=[use(none,in_hierarchy,'H',1)]],[curve=[6,4]]).
arc(arc00023,node00034,node00036,influence,[complete=true,name=i16,role=[use(none,in_hierarchy,'C_a',1)]],[curve=[10,7]]).
arc(arc00024,node00036,node00033,influence,[complete=true,name=i23,role=[use(none,in_hierarchy,'Gs_0',1)]],[curve=[10,-9]]).
arc(arc00025,node00032,node00036,influence,[complete=true,name=i26],[curve=[0,8]]).
arc(arc00026,node00060,node00058,influence,[complete=true,name=i1_0,role=[use(none,in_hierarchy,usr('A'),1)]],[curve=[-1,-26]]).
arc(arc00027,node00061,node00060,influence,[name=i1],[]).
arc(arc00028,node00059,node00061,influence,[complete=true,name=i9,role=[use(none,in_hierarchy,'Gs',1)]],[curve=[-15,6]]).
arc(arc00029,node00062,node00061,influence,[complete=true,name=i8,role=[use(none,in_hierarchy,'A_Q',1)]],[curve=[13,-6]]).
arc(arc00030,node00063,node00062,influence,[name=i7],[]).
arc(arc00031,node00057,node00063,influence,[complete=true,name=i10,role=[use(none,in_hierarchy,'Q',1)]],[curve=[4,6]]).
arc(arc00032,node00043,node00042,influence,[name=i1],[]).
arc(arc00033,node00044,node00041,influence,[complete=true,name=i11],[curve=[-22,9]]).
arc(arc00034,node00044,node00043,influence,[complete=true,name=i20,role=[use(none,in_hierarchy,usr('Gs'),1)]],[curve=[-14,-20]]).
arc(arc00035,node00045,node00044,influence,[name=i7],[]).
arc(arc00036,node00047,node00045,influence,[complete=true,name=i25,role=[use(none,in_hierarchy,usr('Gs_start'),1)]],[curve=[3,46]]).
arc(arc00037,node00048,node00045,influence,[complete=true,name=i2,role=[use(none,in_hierarchy,usr(loop_count),int)]],[curve=[10,34]]).
arc(arc00038,node00049,node00048,influence,[name=i27],[]).
arc(arc00039,node00042,node00049,influence,[complete=true,name=i28,role=[use(none,in_hierarchy,al1,boolean)]],[curve=[2,-10]]).
arc(arc00040,node00050,node00041,influence,[complete=true,name=i10,role=[use(none,in_hierarchy,'Q',1)]],[curve=[8,13]]).
arc(arc00041,node00053,node00045,influence,[complete=true,name=i8,role=[use(none,in_hierarchy,usr('Gs_0'),1)],use_sofar=1],[curve=[38,23]]).
arc(arc00042,node00053,node00043,influence,[complete=true,name=i16,role=[use(none,in_hierarchy,usr('Gs_0'),1)]],[curve=[27,-6]]).
arc(arc00043,node00053,node00046,influence,[complete=true,name=i22],[curve=[24,-22]]).
arc(arc00044,node00054,node00053,influence,[name=i2_0_0],[]).
arc(arc00045,node00041,node00054,influence,[complete=true,name=i1_0,role=[use(none,in_hierarchy,usr('A'),1)]],[curve=[-1,-12]]).
arc(arc00046,node00051,node00054,influence,[complete=true,name=i6,role=[use(none,in_hierarchy,usr('H'),1)]],[curve=[26,15]]).
arc(arc00047,node00052,node00054,influence,[complete=true,name=i2_0,role=[use(none,in_hierarchy,usr('C_a'),1)]],[curve=[24,19]]).
arc(arc00048,node00055,node00054,influence,[complete=true,name=i14,role=[use(none,in_hierarchy,usr(g_0),1)]],[curve=[-6,21]]).
arc(arc00049,node00056,node00054,influence,[complete=true,name=i13,role=[use(none,in_hierarchy,usr(g_1),1)]],[curve=[8,21]]).
arc(arc00050,node00037,node00036,influence,[complete=true,name=i14,role=[use(none,in_hierarchy,g_0,1)]],[curve=[-6,18]]).
arc(arc00051,node00037,node00033,influence,[complete=true,name=i24,role=[use(none,in_hierarchy,g_0,1)]],[curve=[20,8]]).
arc(arc00052,node00038,node00037,influence,[name=i11],[]).
arc(arc00053,node00039,node00036,influence,[complete=true,name=i13,role=[use(none,in_hierarchy,g_1,1)]],[curve=[9,23]]).
arc(arc00054,node00040,node00039,influence,[name=i12],[]).

