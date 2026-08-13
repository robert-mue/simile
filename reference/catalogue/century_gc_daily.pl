source(program='AME',version= 9.0,edition=standard,date='Tue Feb 05 17:08:56 GMT 2008').

roots([node00002,node00003,node00004,node00005,node00006,node00007,node00008,node00009,node00010,node00011,node00012,node00013,node00014,node00015,node00016,node00017,node00018,node00019,node00020,node00021,node00022,node00023,node00024,node00025,node00026,node00027,node00028,node00029,node00030,node00031,node00032,node00033,node00034,node00035,node00036,node00037,node00038,node00039,node00040,node00041,node00042,node00043,node00044,node00045,node00046,node00047,node00048,node00049,node00050,node00051,node00052,node00053,node00054,node00055,node00056,node00057,node00058,node00059,node00060,node00061,node00062,node00063,node00064,node00065,node00066,node00067,node00068,node00069,node00070,node00071,node00072,node00073,node00074,node00075,node00076,node00077,node00078,node00079,node00080,node00081,node00082,node00083,node00084,node00085,node00086,node00087,node00088,node00089,node00090,node00091,node00092,node00093,node00094,node00095,node00096,node00097,node00098,node00099,node00100,node00101,node00102,node00104,node00105,node00106,node00107,node00108,node00109,node00110,node00112,node00113,node00114,node00115,node00116,node00117,node00118,node00119,node00120,node00121,node00122,node00123,node00124,node00125,node00126,node00127,node00128,node00129,node00130,node00131,node00132,node00133,node00134,node00135,node00136,node00137,node00138,node00139,node00140,node00141,node00142,node00143,node00144,node00145,node00146,node00147,node00148,node00149,node00150,node00151,node00152,node00153,node00154,node00155,node00156,node00157,node00158,node00159,node00160,node00161,node00162,node00163,node00164,node00165,node00166,node00167,node00168,node00169,node00170,node00171,node00172,node00173,node00174,node00175,node00176,node00177,node00178,node00179,node00180,node00181,node00182,node00183,node00184,node00185,node00186]).

properties([complete-true,file_name-'C:/Dad/Projects/NUANCES/century gc daily nonzero min n.sml',name-'century gc daily nonzero min n v40']).

node(node00002,compartment,[],[complete=true,name='Mineral N'],[caption_offset=[48,-24],centre=[1096,282]]).
node(node00003,function,[],[complete=true,name=fn1,units=1,value=0],[]).
node(node00004,compartment,[],[complete=true,name='CO2 LiSta'],[caption_offset=[0,-51],centre=[-5,-124]]).
node(node00005,function,[],[complete=true,name=fn2,units=1,value=0],[]).
node(node00006,compartment,[],[complete=true,name='CO2 LiSts'],[caption_offset=[-4,-51],centre=[-149,0]]).
node(node00007,function,[],[complete=true,name=fn3,units=1,value=0],[]).
node(node00008,compartment,[],[complete=true,name='LiStructural C'],[caption_offset=[-32,-46],centre=[-9,20]]).
node(node00009,function,[],[complete=true,name=fn4,units=1,value='Initial_C'*(1-'SplitMet')],[]).
node(node00010,compartment,[],[complete=true,name='LiMetabolic C'],[caption_offset=[-58,-14],centre=[368,33]]).
node(node00011,function,[],[complete=true,name=fn5,units=1,value='Initial_C'*'SplitMet'],[]).
node(node00012,compartment,[],[complete=true,name='CO2 LiMet'],[caption_offset=[1,-47],centre=[491,23]]).
node(node00013,function,[],[complete=true,name=fn6,units=1,value=0],[]).
node(node00014,variable,[],[comment='N_released% = Mineral_N/(Initial_C/Carbon*Nitrogen)*100',complete=true,name='N released %'],[caption_offset=[41,-21],centre=[631,-91]]).
node(node00015,function,[],[complete=true,name=fn7,units=1,value='Mineral_N'/('Initial_C'/'Carbon'*'Nitrogen')*100],[]).
node(node00016,variable,[],[complete=true,name='Initial C'],[caption_offset=[3,-37],centre=[244,-236]]).
node(node00017,function,[],[complete=true,name=fn8,units=int,value=100],[]).
node(node00018,variable,[],[complete=true,name='Carbon'],[caption_offset=[1,-35],centre=[461,-242]]).
node(node00019,function,[],[complete=true,name=fn9,units=1,value= 0.42],[]).
node(node00020,variable,[],[complete=true,name='Residue CN'],[caption_offset=[-34,-5],centre=[393,-139]]).
node(node00021,function,[],[complete=true,name=fn10,units=1,value='Carbon'/'Nitrogen'],[]).
node(node00022,variable,[],[complete=true,name='Nitrogen'],[caption_offset=[-3,-35],centre=[326,-233]]).
node(node00023,function,[],[complete=true,name=fn11,units=1,value= 0.0117],[]).
node(node00024,variable,[],[complete=true,name='SplitMet'],[caption_offset=[-29,-25],centre=[241,-94]]).
node(node00025,function,[],[complete=true,name=fn12,units=1,value= 0.85 - 0.018 *'Lignin'/'Nitrogen'],[]).
node(node00026,variable,[],[complete=true,name='Lignin'],[caption_offset=[0,-35],centre=[404,-239]]).
node(node00027,function,[],[complete=true,name=fn13,units=1,value= 0.2],[]).
node(node00028,variable,[],[complete=true,name='Total Litter C'],[caption_offset=[0,-32],centre=[286,-4]]).
node(node00029,function,[],[complete=true,name=fn14,units=1,value='LiMetabolic_C'+'LiStructural_C'],[]).
node(node00030,variable,[],[complete=true,name='Litter CO2'],[caption_offset=[-41,-18],centre=[-120,65]]).
node(node00031,function,[],[complete=true,name=fn15,units=1,value='CO2_LiMet'+'CO2_LiSta'+'CO2_LiSts'],[]).
node(node00032,function,[],[complete=true,name=fn16,units=1,value='LiMetabolic_C'*klim*(1-'UtilEffm')],[]).
node(node00033,function,[],[complete=true,name=fn17,units=1,value='LiStructural_C'*(1-'StructLignin')*klist*(1-'UtilEffSta')],[]).
node(node00034,function,[],[complete=true,name=fn18,units=1,value='LiStructural_C'*'StructLignin'*klist*(1-'UtilEffsts')],[]).
node(node00035,variable,[],[comment='StructLignin = Lignin/(1-SplitMet)',complete=true,name='StructLignin'],[caption_offset=[-2,-33],centre=[142,61]]).
node(node00036,function,[],[complete=true,name=fn19,units=1,value='Lignin'/(1-'SplitMet')],[]).
node(node00037,compartment,[],[complete=true,name='LiMetabolic N'],[caption_offset=[59,-25],centre=[870,23]]).
node(node00038,function,[],[complete=false,name=fn20],[]).
node(node00039,function,[],[complete=true,name=fn1_0,units=1,value='INIT_LiMetabolicN'],[]).
node(node00040,function,[],[complete=false,name=fn21],[]).
node(node00041,variable,[],[complete=true,name='UtilEffsts'],[caption_offset=[0,0],centre=[-67,110]]).
node(node00042,function,[],[complete=true,name=fn22,units=1,value= 0.7],[]).
node(node00043,variable,[],[comment='klist = (0.094*EXNWP(-3.0*StructLignin))*TempMod',complete=true,name=klist],[caption_offset=[0,0],centre=[155,134]]).
node(node00044,function,[],[complete=true,name=fn23,units=1,value=1-(1- 0.094 *exp( -3.0*'StructLignin')*'TempMod')^(1/7)],[]).
node(node00045,compartment,[],[complete=true,name='LiStructuralN'],[caption_offset=[59,-27],centre=[1322,39]]).
node(node00046,function,[],[complete=false,name=fn24],[]).
node(node00047,variable,[],[complete=true,name=klim],[caption_offset=[-4,-31],centre=[319,153]]).
node(node00048,function,[],[complete=true,name=fn25,units=1,value=1-(1- 0.35 *'TempMod')^(1/7)],[]).
node(node00049,variable,[],[complete=true,name='TempMod'],[caption_offset=[-31,-14],centre=[244,177]]).
node(node00050,function,[],[complete=true,name=fn26,units=1,value=yInterpolated],[]).
node(node00051,variable,[],[complete=true,name='UtilEffm'],[caption_offset=[-30,-17],centre=[443,96]]).
node(node00052,function,[],[complete=true,name=fn27,units=1,value= 0.45],[]).
node(node00053,variable,[],[complete=true,name='UtilEffSta'],[caption_offset=[3,-29],centre=[188,-18]]).
node(node00054,function,[],[complete=true,name=fn28,units=1,value= 0.45],[]).
node(node00055,compartment,[],[complete=true,name='Active Soil C'],[caption_offset=[51,-50],centre=[355,487]]).
node(node00056,function,[],[complete=true,name=fn29,units=1,value=0],[]).
node(node00057,compartment,[],[complete=true,name='CO2 a'],[caption_offset=[0,0],centre=[539,490]]).
node(node00058,function,[],[complete=true,name=fn30,units=1,value=0],[]).
node(node00059,compartment,[],[complete=true,name='Slow Soil C'],[caption_offset=[52,-27],centre=[157,612]]).
node(node00060,function,[],[complete=true,name=fn31,units=1,value=0],[]).
node(node00061,compartment,[],[complete=true,name='CO2s'],[caption_offset=[0,0],centre=[161,734]]).
node(node00062,function,[],[complete=true,name=fn32,units=1,value=0],[]).
node(node00063,function,[],[complete=true,name=fn33,units=1,value='LiMetabolic_C'*klim*'UtilEffm'],[]).
node(node00064,function,[],[complete=true,name=fn34,units=1,value='Active_Soil_C'*ka*'Respa'],[]).
node(node00065,function,[],[complete=true,name=fn35,units=1,value='Active_Soil_C'*ka*'UtilEffas'],[]).
node(node00066,function,[],[complete=true,name=fn36,units=1,value='Slow_Soil_C'*ks*(1-'UtilEffsa'-'UtilEffsp')],[]).
node(node00067,function,[],[complete=false,name=fn37],[]).
node(node00068,function,[],[complete=false,name=fn38],[]).
node(node00069,compartment,[],[complete=true,name='Passive Soil C'],[caption_offset=[3,-49],centre=[-27,384]]).
node(node00070,function,[],[complete=true,name=fn39,units=1,value=0],[]).
node(node00071,function,[],[complete=true,name=fn40,units=1,value='Slow_Soil_C'*ks*'UtilEffsp'],[]).
node(node00072,variable,[],[complete=true,name='Clay'],[caption_offset=[-1,-33],centre=[521,-243]]).
node(node00073,function,[],[complete=true,name=fn41,units=1,value= 0.52],[]).
node(node00074,variable,[],[comment='Respa = 0.85 - 0.68*Clay',complete=true,name='Respa'],[caption_offset=[-22,-11],centre=[499,533]]).
node(node00075,function,[],[complete=true,name=fn42,units=1,value= 0.85 - 0.68 *'Clay'],[]).
node(node00076,variable,[],[comment='UtilEffas = (1-Respa-0.004)',complete=true,name='UtilEffas'],[caption_offset=[0,0],centre=[522,573]]).
node(node00077,function,[],[complete=true,name=fn43,units=1,value=1-'Respa'- 0.004],[]).
node(node00078,variable,[],[comment='ka = (0.14*(1-0.75*Clay))*TempMod',complete=true,name=ka],[caption_offset=[-14,-11],centre=[294,287]]).
node(node00079,function,[],[complete=true,name=fn44,units=1,value=1-(1- 0.14 *(1- 0.75 *'Clay')*'TempMod')^(1/7)],[]).
node(node00080,function,[],[complete=true,name=fn2_0,units=1,value='INIT_Listructural_N'],[]).
node(node00081,function,[],[complete=false,name=fn45],[]).
node(node00082,function,[],[complete=true,name=fn46,units=1,value='LiStructural_C'*(1-'StructLignin')*klist*'UtilEffSta'],[]).
node(node00083,function,[],[complete=true,name=fn47,units=1,value='LiStructural_C'*'StructLignin'*klist*'UtilEffsts'],[]).
node(node00084,variable,[],[complete=true,name='UtilEffsa'],[caption_offset=[30,-10],centre=[276,659]]).
node(node00085,function,[],[complete=true,name=fn48,units=1,value= 0.42],[]).
node(node00086,function,[],[complete=true,name=fn49,units=1,value='Slow_Soil_C'*ks*'UtilEffsa'],[]).
node(node00087,function,[],[complete=true,name=fn3_0,units=1,value='DecNa'-'FNma'],[]).
node(node00088,function,[],[complete=false,name=fn50],[]).
node(node00089,function,[],[complete=true,name=fn51,units=1,value='Passive_Soil_C'*kp*'UtilEffp'],[]).
node(node00090,compartment,[],[complete=true,name='CO2p'],[caption_offset=[0,0],centre=[-158,372]]).
node(node00091,function,[],[complete=true,name=fn52,units=1,value=0],[]).
node(node00092,function,[],[complete=true,name=fn53,units=1,value='Passive_Soil_C'*kp*(1-'UtilEffp')],[]).
node(node00093,variable,[],[comment='kp = 0.00013*TempMod',complete=true,name=kp],[caption_offset=[0,0],centre=[182,261]]).
node(node00094,function,[],[complete=true,name=fn54,units=1,value=1-(1- 0.00013 *'TempMod')^(1/7)],[]).
node(node00095,variable,[],[complete=true,name='UtilEffp'],[caption_offset=[-29,-18],centre=[-68,463]]).
node(node00096,function,[],[complete=true,name=fn55,units=1,value= 0.45],[]).
node(node00097,function,[],[complete=true,name=fn4_0,units=1,value=(if'Demandma'>'DecNa' then 'DecNa' else 'Demandma')],[]).
node(node00098,function,[],[complete=false,name=fn56],[]).
node(node00099,function,[],[complete=true,name=fn5_0,units=1,value='DecNsta'-'FNsta'],[]).
node(node00100,function,[],[complete=false,name=fn57],[]).
node(node00101,variable,[],[comment='Ks = 0.0038*TempMod',complete=true,name=ks],[caption_offset=[1,-30],centre=[238,283]]).
node(node00102,function,[],[complete=true,name=fn58,units=1,value=1-(1- 0.0038 *'TempMod')^(1/7)],[]).
node(node00104,function,[],[complete=false,name=fn59],[]).
node(node00105,function,[],[complete=true,name=fn6_0,units=1,value=(if'Demandsts'>'DecNsts' then 'DecNsts' else 'Demandsts')],[]).
node(node00106,function,[],[complete=false,name=fn60],[]).
node(node00107,variable,[],[complete=true,name='Temperature'],[caption_offset=[-10,-34],centre=[593,-244]]).
node(node00108,function,[],[complete=true,name=fn61,units=int,value=20],[]).
node(node00109,variable,[],[comment='DecNa = Fma/UtilEffm/CN_LiMet',complete=true,name='DecNa'],[caption_offset=[1,3],centre=[671,131]]).
node(node00110,function,[],[complete=false,name=fn62],[]).
node(node00112,function,[],[complete=false,name=fn63],[]).
node(node00113,compartment,[],[complete=true,name='Active Soil N'],[caption_offset=[58,-23],centre=[1268,468]]).
node(node00114,function,[],[complete=true,name=fn64,units=1,value=0],[]).
node(node00115,function,[],[complete=true,name=fn7_0,units=1,value='Fma'/'UtilEffm'/'CN_LiMet'],[]).
node(node00116,function,[],[complete=false,name=fn65],[]).
node(node00117,compartment,[],[complete=true,name='Slow Soil N'],[caption_offset=[0,0],centre=[1035,727]]).
node(node00118,function,[],[complete=true,name=fn66,units=1,value=0],[]).
node(node00119,compartment,[],[complete=true,name='Passive Soil N'],[caption_offset=[0,0],centre=[855,436]]).
node(node00120,function,[],[complete=true,name=fn67,units=1,value=0],[]).
node(node00121,function,[],[complete=true,name=fn68,units=1,value='DecompNa'-'FNas'-'FNap'],[]).
node(node00122,function,[],[complete=true,name=fn69,units=1,value='Fsp'/'CN_passive_SOM'],[]).
node(node00123,function,[],[complete=true,name=fn70,units=1,value='Fsa'/'CN_active_SOM'],[]).
node(node00124,function,[],[complete=true,name=fn71,units=1,value='DecompNp'-'FNpa'],[]).
node(node00125,function,[],[complete=true,name=fn72,units=1,value='DecompNs'-'FNsa'-'FNsp'],[]).
node(node00126,function,[],[complete=true,name=fn73,units=1,value='Fap'/'CN_passive_SOM'],[]).
node(node00127,function,[],[complete=true,name=fn74,units=1,value='Fpa'/'CN_active_SOM'],[]).
node(node00128,function,[],[complete=true,name=fn75,units=1,value=(if'Demandma'>'DecNa' then 'Demandma'-'DecNa' else 0)],[]).
node(node00129,variable,[],[complete=true,name='CN active SOM'],[caption_offset=[-4,-40],centre=[705,-236]]).
node(node00130,function,[],[complete=true,name=fn76,units=int,value=8],[]).
node(node00131,variable,[],[complete=true,name='DecompNp'],[caption_offset=[0,0],centre=[661,410]]).
node(node00132,function,[],[complete=true,name=fn77,units=1,value='Fpa'/'UtilEffp'/'CN_passive_SOM'],[]).
node(node00133,variable,[],[complete=true,name='CN passive SOM'],[caption_offset=[4,-35],centre=[788,-241]]).
node(node00134,function,[],[complete=true,name=fn78,units=int,value=11],[]).
node(node00135,variable,[],[complete=true,name='Demandma'],[caption_offset=[0,0],centre=[663,214]]).
node(node00136,function,[],[complete=false,name=fn79],[]).
node(node00137,function,[],[complete=true,name=fn80,units=1,value='Fas'/'CN_slow_SOM'],[]).
node(node00138,variable,[],[complete=true,name='CN slow SOM'],[caption_offset=[9,-36],centre=[861,-237]]).
node(node00139,function,[],[complete=true,name=fn81,units=int,value=11],[]).
node(node00140,function,[],[complete=true,name=fn8_0,units=1,value='Fma'/'CN_active_SOM'],[]).
node(node00141,variable,[],[comment='SplitMet/((1/Residue_CN) - ((1-SplitMet)/CN_LiSt))',complete=true,name='CNLiMet'],[caption_offset=[7,2],centre=[475,-123]]).
node(node00142,function,[],[complete=true,name=fn9_0,units=1,value='SplitMet'/(1/'Residue_CN'-(1-'SplitMet')/'CN_LiSt')],[]).
node(node00143,variable,[],[complete=true,name='CN LiSt'],[caption_offset=[28,-14],centre=[562,-77]]).
node(node00144,function,[],[complete=true,name=fn10_0,units=int,value=150],[]).
node(node00145,variable,[],[complete=true,name='INIT LiMetabolicN'],[caption_offset=[-3,-33],centre=[591,-153]]).
node(node00146,function,[],[complete=true,name=fn11_0,units=1,value='Initial_C'*'SplitMet'/'CNLiMet'],[]).
node(node00147,variable,[],[complete=true,name='DecompNa'],[caption_offset=[0,0],centre=[660,460]]).
node(node00148,function,[],[complete=true,name=fn1_1,units=1,value='Fas'/'UtilEffas'/'CN_active_SOM'],[]).
node(node00149,variable,[],[complete=true,name='Total Soil N'],[caption_offset=[-38,-16],centre=[1457,342]]).
node(node00150,function,[],[complete=false,name=fn2_1],[]).
node(node00151,function,[],[complete=true,name=fn3_1,units=1,value=(if'Demandsta'>'DecNsta' then 'DecNsta' else 'Demandsta')],[]).
node(node00152,function,[],[complete=true,name=fn4_1,units=1,value='DecNsts'-'FNsts'],[]).
node(node00153,variable,[],[complete=true,name='INIT Listructural N'],[caption_offset=[-30,-31],centre=[695,-176]]).
node(node00154,function,[],[complete=true,name=fn5_1,units=1,value='Initial_C'*(1-'SplitMet')/'CN_LiSt'],[]).
node(node00155,variable,[],[comment='DecNsts = Fsts/UtilEffsts/CN_LiSt',complete=true,name='DecNsts'],[caption_offset=[0,0],centre=[674,87]]).
node(node00156,function,[],[complete=true,name=fn6_1,units=1,value='Fsts'/'UtilEffsts'/'CN_LiSt'],[]).
node(node00157,function,[],[complete=true,name=fn1_2,units=1,value='Total_SOM_N'+'Mineral_N'],[]).
node(node00158,function,[],[complete=false,name=fn7_1],[]).
node(node00159,variable,[],[comment='DecNsta = Fsta/UtilEffsta/CN_LiSt',complete=true,name='DecNsta'],[caption_offset=[0,0],centre=[674,42]]).
node(node00160,function,[],[complete=true,name=fn8_1,units=1,value='Fsta'/'UtilEffSta'/'CN_LiSt'],[]).
node(node00161,variable,[],[complete=true,name='Demandsta'],[caption_offset=[0,0],centre=[663,261]]).
node(node00162,function,[],[complete=true,name=fn9_1,units=1,value='Fsta'/'CN_active_SOM'],[]).
node(node00163,variable,[],[complete=true,name='Demandsts'],[caption_offset=[0,0],centre=[663,310]]).
node(node00164,function,[],[complete=true,name=fn10_1,units=1,value='Fsts'/'CN_slow_SOM'],[]).
node(node00165,variable,[],[complete=true,name='Total SOM N'],[caption_offset=[-49,-8],centre=[1429,419]]).
node(node00166,function,[],[complete=true,name=fn2_2,units=1,value='Active_Soil_N'+'Passive_Soil_N'+'Slow_Soil_N'],[]).
node(node00167,function,[],[complete=false,name=fn11_1],[]).
node(node00168,variable,[],[complete=true,name='Total Litter N'],[caption_offset=[1,-37],centre=[1154,-8]]).
node(node00169,function,[],[complete=true,name=fn12_0,units=1,value='LiMetabolic_N'+'LiStructuralN'],[]).
node(node00170,variable,[],[complete=true,name='CN LiMet'],[caption_offset=[-4,-29],centre=[474,-41]]).
node(node00171,function,[],[complete=true,name=fn13_0,units=1,value='SplitMet'/(1/'Residue_CN'-(1-'SplitMet')/'CN_LiSt')],[]).
node(node00172,function,[],[complete=true,name=fn14_0,units=1,value='Active_Soil_C'*ka* 0.004],[]).
node(node00173,variable,[],[complete=true,name='UtilEffsp'],[caption_offset=[0,0],centre=[58,632]]).
node(node00174,function,[],[complete=true,name=fn15_0,units=1,value= 0.03],[]).
node(node00175,variable,[],[comment='Soil_CO2 = CO2_a + CO2s + CO2p',complete=true,name='Soil CO2'],[caption_offset=[-40,-21],centre=[-127,170]]).
node(node00176,function,[],[complete=true,name=fn16_0,units=1,value='CO2_a'+'CO2s'+'CO2p'],[]).
node(node00177,variable,[],[complete=true,name='Total CO2'],[caption_offset=[-38,-17],centre=[-140,121]]).
node(node00178,function,[],[complete=true,name=fn17_0,units=1,value='Soil_CO2'+'Litter_CO2'],[]).
node(node00179,variable,[],[complete=true,name='Total Soil C'],[caption_offset=[-43,-19],centre=[-61,572]]).
node(node00180,function,[],[complete=true,name=fn18_0,units=1,value='Active_Soil_C'+'Passive_Soil_C'+'Slow_Soil_C'],[]).
node(node00181,function,[],[complete=true,name=fn19_0,units=1,value=(if'Demandsta'>'DecNsta' then 'Demandsta'-'DecNsta' else 0)],[]).
node(node00182,function,[],[name=fn20_0,units=1,value=(if'Demandsts'>'DecNsts' then 'Demandsts'-'DecNsts' else 0)],[]).
node(node00183,variable,[],[complete=true,name='DecompNs'],[caption_offset=[0,0],centre=[661,516]]).
node(node00184,function,[],[complete=true,name=fn21_0,units=1,value='Fsp'/'UtilEffsp'/'CN_slow_SOM'],[]).
node(node00185,function,[],[complete=true,name=fn22_0,units=1,value=(if'Demandsts'>'DecNsts' then 'Demandsts'-'DecNsts' else 0)],[]).
node(node00186,submodel,[node00187,node00188,node00189,node00190,node00191,node00192,node00193,node00194,node00195,node00196,node00197,node00198,node00199,node00200,node00201,node00202,node00203,node00204,node00205,node00206,node00207,node00208,node00209,node00210,node00211,node00212,node00213,node00214,node00215,node00216,node00217,node00218,node00219,node00220,node00221,node00222,node00223,node00224,node00225,node00226,node00227,node00228],[complete=true,file_name='C:/Ed/Models and shells/Simile/Simile routines/Interpolate with internal data.sml',name='TEMPMOD'],[bounding_box=[191,62,303,134],caption_offset=[30,-7],internal_extent=[-505,-306,384,266]]).
links(node00186,[arc00327-arc00326,arc00328-arc00329]).
node(node00187,function,[],[complete=false,name=fn9],[]).
node(node00188,function,[],[name=fn10,units=1,value=element([xlist],'LowerArrayPos')],[]).
node(node00189,function,[],[name=fn11,units=1,value=element([xlist],'LowerArrayPos'+1)],[]).
node(node00190,function,[],[name=fn12,units=1,value=element([ylist],'LowerArrayPos')],[]).
node(node00191,function,[],[name=fn13,units=1,value=element([ylist],'LowerArrayPos'+1)],[]).
node(node00192,function,[],[complete=false,name=fn5_0],[]).
node(node00193,variable,[],[complete=true,name=xSupplied],[caption_offset=[3,-32],centre=[-179,-140]]).
node(node00194,function,[],[complete=true,name=fn3,units=1,value='Temperature'],[]).
node(node00195,variable,[],[complete=true,name='TempLowerArrayPos'],[caption_offset=[67,-22],centre=[-186,-90]]).
node(node00196,function,[],[complete=true,name=fn4,units=int,value=sum(if [xList2]<'TSUM' then 1 else 0)],[]).
node(node00197,variable,[],[complete=true,name=xLower],[caption_offset=[-3,-1],centre=[-192,-48]]).
node(node00198,function,[],[complete=false,name=fn5,units=array(1,size('TableFromFile')),value=[xtable]],[]).
node(node00199,function,[],[complete=false,name=fn6,units=array(1,size('TableFromFile')),value=[ytable]],[]).
node(node00200,variable,[],[complete=true,name='LowerArrayPos'],[caption_offset=[54,-19],centre=[-159,-74]]).
node(node00201,function,[],[complete=true,name=fn7,units=1,value=(if'ArrayPosOfLowerXNW'<1 then 1 else (if'ArrayPosOfLowerXNW'=='ArraySize' then 'ArrayPosOfLowerXNW'-1 else 'ArrayPosOfLowerXNW'))],[]).
node(node00202,variable,[],[complete=true,name='ArraySize'],[caption_offset=[36,-21],centre=[-135,-112]]).
node(node00203,function,[],[complete=true,name=fn8,units=int,value=count([xList2])],[]).
node(node00204,function,[],[complete=true,name=fn1,units=1,value=element([xList2],'LowerArrayPos')],[]).
node(node00205,variable,[],[complete=true,name=xHigher],[caption_offset=[-8,-2],centre=[-234,-46]]).
node(node00206,function,[],[complete=true,name=fn2,units=1,value=element([xList2],'LowerArrayPos'+1)],[]).
node(node00207,variable,[],[complete=true,name=yLower],[caption_offset=[3,-1],centre=[-109,-47]]).
node(node00208,function,[],[complete=true,name=fn3_0,units=1,value=element(['Ylist'],'LowerArrayPos')],[]).
node(node00209,variable,[],[complete=true,name=yHigher],[caption_offset=[-5,-2],centre=[-149,-47]]).
node(node00210,function,[],[complete=true,name=fn4_0,units=1,value=element(['Ylist'],'LowerArrayPos'+1)],[]).
node(node00211,variable,[],[complete=true,name=yInterpolated],[caption_offset=[-44,-16],centre=[-180,33]]).
node(node00212,function,[],[complete=true,name=fn6_0,units=1,value=yLower+(xSupplied-xLower)*(yHigher-yLower)/(xHigher-xLower)],[]).
node(node00213,function,[],[complete=false,name=fn1_0],[]).
node(node00214,function,[],[complete=false,name=fn2_0],[]).
node(node00215,variable,[],[comment='(0.00, 0.01), (5.00, 0.05), (10.0, 0.15), (15.0, 0.3), (20.0, 0.5), (25.0, 0.7), (30.0, 0.9), (35.0, 1.00), (40.0, 0.95), (45.0, 0.00), (50.0, 0.00)',complete=true,name=xList],[caption_offset=[-25,-17],centre=[-221,-112]]).
node(node00216,function,[],[complete=true,name=fn1_1,units=array(1,11),value=[0,5,10,15,20,25,30,35,40,45,50]],[]).
node(node00217,variable,[],[comment='(0.00, 0.01), (5.00, 0.05), (10.0, 0.15), (15.0, 0.3), (20.0, 0.5), (25.0, 0.7), (30.0, 0.9), (35.0, 1.00), (40.0, 0.95), (45.0, 0.00), (50.0, 0.00)',complete=true,name='Ylist'],[caption_offset=[-25,-15],centre=[-223,-88]]).
node(node00218,function,[],[complete=true,name=fn2_1,units=array(1,11),value=[ 0.01, 0.05, 0.15, 0.3, 0.5, 0.7, 0.9,1, 0.95,0,0]],[]).
node(node00219,function,[],[complete=true,name=fn1,table_data=[current=[0,110,275,555,780,1055,1160,1305,2500],file='C:/Ed/Models and shells/Lintuls/FRTTB.csv',data='TSUM',indices=[],units=const_int,bounds=[int],dims=[9]],units=1,value=table(index(1))],[]).
node(node00220,function,[],[complete=true,name=fn2,table_data=[current=[ 0.5, 0.5, 0.34, 0.12, 0.07, 0.03, 0.02,0,0],file='C:/Ed/Models and shells/Lintuls/FRTTB.csv',data='FRT',indices=[],units=1,bounds=[int],dims=[9]],units=1,value=table(index(1))],[]).
node(node00221,variable,[],[complete=true,name='NB please add lists of x and y '],[caption_offset=[84,-15],centre=[-120,-11]]).
node(node00222,function,[],[complete=true,name=fn1_2,units=int,value=0],[]).
node(node00223,variable,[],[complete=true,name='and change the array dimension '],[caption_offset=[104,-17],centre=[-134,2]]).
node(node00224,function,[],[complete=true,name=fn2_2,units=int,value=0],[]).
node(node00225,variable,[],[complete=true,name='to the number of points'],[caption_offset=[68,-18],centre=[-120,13]]).
node(node00226,function,[],[complete=true,name=fn3_1,units=int,value=0],[]).
node(node00227,border,[],[name=var3],[centre=[87,259]]).
node(node00228,border,[],[name=var4],[centre=[376,220]]).

arc(arc00001,node00003,node00002,influence,[name=i1],[]).
arc(arc00002,node00005,node00004,influence,[name=i2],[]).
arc(arc00003,node00007,node00006,influence,[name=i3],[]).
arc(arc00018,node00008,node00004,flow,[comment='FCO2sta = LiStructural_C*(1-StructLignin)*klist*(1-UtilEffsta)',complete=true,name='FCO2sta'],[caption_offset=[5,-34],curve=[550,500]]).
arc(arc00020,node00008,node00006,flow,[comment='FCO2sts = LiStructural_C*StructLignin*klist*(1-UtilEffsts)',complete=true,name='FCO2sts'],[caption_offset=[-11,-42],curve=[550,707]]).
arc(arc00004,node00009,node00008,influence,[name=i4],[]).
arc(arc00005,node00011,node00010,influence,[name=i5],[]).
arc(arc00016,node00010,node00012,flow,[comment='LiMetabolic_C*klim*(1-UtilEffm)',complete=true,name='FCO2m'],[caption_offset=[-15,-39],curve=[550,500]]).
arc(arc00006,node00013,node00012,influence,[name=i6],[]).
arc(arc00007,node00015,node00014,influence,[name=i7],[]).
arc(arc00031,node00002,node00015,influence,[complete=true,name=i28,role=[use(none,in_hierarchy,'Mineral_N',1)]],[curve=[-20,13]]).
arc(arc00032,node00016,node00015,influence,[complete=true,name=i29,role=[use(none,in_hierarchy,'Initial_C',int)]],[curve=[10,-6]]).
arc(arc00172,node00016,node00011,influence,[complete=true,name=i147,role=[use(none,in_hierarchy,'Initial_C',int)]],[curve=[32,-41]]).
arc(arc00175,node00016,node00009,influence,[complete=true,name=i150,role=[use(none,in_hierarchy,'Initial_C',int)]],[curve=[27,7]]).
arc(arc00008,node00017,node00016,influence,[name=i8],[]).
arc(arc00034,node00018,node00015,influence,[complete=true,name=i31,role=[use(none,in_hierarchy,'Carbon',1)]],[curve=[-36,17]]).
arc(arc00009,node00019,node00018,influence,[name=i9],[]).
arc(arc00010,node00021,node00020,influence,[name=i10],[]).
arc(arc00035,node00018,node00021,influence,[complete=true,name=i32,role=[use(none,in_hierarchy,'Carbon',1)]],[curve=[12,-9]]).
arc(arc00033,node00022,node00015,influence,[complete=true,name=i30,role=[use(none,in_hierarchy,'Nitrogen',1)]],[curve=[28,13]]).
arc(arc00094,node00022,node00021,influence,[complete=true,name=i12_0,role=[use(none,in_hierarchy,'Nitrogen',1)]],[curve=[8,7]]).
arc(arc00011,node00023,node00022,influence,[name=i11],[]).
arc(arc00173,node00024,node00011,influence,[complete=true,name=i148,role=[use(none,in_hierarchy,'SplitMet',1)]],[curve=[30,0]]).
arc(arc00176,node00024,node00009,influence,[complete=true,name=i151,role=[use(none,in_hierarchy,'SplitMet',1)]],[curve=[-62,13]]).
arc(arc00012,node00025,node00024,influence,[name=i12],[]).
arc(arc00036,node00022,node00025,influence,[complete=true,name=i33,role=[use(none,in_hierarchy,'Nitrogen',1)]],[curve=[9,-8]]).
arc(arc00037,node00026,node00025,influence,[complete=true,name=i34,role=[use(none,in_hierarchy,'Lignin',1)]],[curve=[8,6]]).
arc(arc00013,node00027,node00026,influence,[name=i13],[]).
arc(arc00014,node00029,node00028,influence,[name=i14],[]).
arc(arc00080,node00010,node00029,influence,[complete=true,name=i10_0,role=[use(none,in_hierarchy,'LiMetabolic_C',1)]],[curve=[14,-2]]).
arc(arc00093,node00008,node00029,influence,[complete=true,name=i11_0,role=[use(none,in_hierarchy,'LiStructural_C',1)]],[curve=[70,9]]).
arc(arc00015,node00031,node00030,influence,[name=i15],[]).
arc(arc00054,node00012,node00031,influence,[complete=true,name=i7_0,role=[use(none,in_hierarchy,'CO2_LiMet',1)]],[curve=[56,-17]]).
arc(arc00066,node00004,node00031,influence,[complete=true,name=i8_0,role=[use(none,in_hierarchy,'CO2_LiSta',1)]],[curve=[-54,-64]]).
arc(arc00071,node00006,node00031,influence,[complete=true,name=i9_0,role=[use(none,in_hierarchy,'CO2_LiSts',1)]],[curve=[-2,-10]]).
arc(arc00017,node00032,arc00016,influence,[name=i16],[]).
arc(arc00170,node00010,node00032,influence,[complete=true,name=i145,role=[use(none,in_hierarchy,'LiMetabolic_C',1)]],[curve=[-1,12]]).
arc(arc00019,node00033,arc00018,influence,[name=i17],[]).
arc(arc00119,node00008,node00033,influence,[complete=true,name=i103,role=[use(none,in_hierarchy,'LiStructural_C',1)]],[curve=[44,30]]).
arc(arc00021,node00034,arc00020,influence,[name=i18],[]).
arc(arc00171,node00008,node00034,influence,[complete=true,name=i146,role=[use(none,in_hierarchy,'LiStructural_C',1)]],[curve=[-2,15]]).
arc(arc00084,node00035,node00034,influence,[complete=true,name=i73,role=[use(none,in_hierarchy,'StructLignin',1)]],[curve=[-13,56]]).
arc(arc00120,node00035,node00033,influence,[complete=true,name=i104,role=[use(none,in_hierarchy,'StructLignin',1)]],[curve=[-26,32]]).
arc(arc00022,node00036,node00035,influence,[name=i19],[]).
arc(arc00077,node00026,node00036,influence,[complete=true,name=i66,role=[use(none,in_hierarchy,'Lignin',1)]],[curve=[-58,138]]).
arc(arc00078,node00024,node00036,influence,[complete=true,name=i67,role=[use(none,in_hierarchy,'SplitMet',1)]],[curve=[52,60]]).
arc(arc00122,node00037,node00002,flow,[complete=true,name='FNmMin'],[caption_offset=[-10,-41],curve=[397,393]]).
arc(arc00107,node00039,node00037,influence,[name=i13_0],[]).
arc(arc00079,node00041,node00034,influence,[complete=true,name=i68,role=[use(none,in_hierarchy,'UtilEffsts',1)]],[curve=[-20,6]]).
arc(arc00025,node00042,node00041,influence,[name=i22],[]).
arc(arc00083,node00043,node00034,influence,[complete=true,name=i72,role=[use(none,in_hierarchy,klist,1)]],[curve=[-30,60]]).
arc(arc00118,node00043,node00033,influence,[complete=true,name=i102,role=[use(none,in_hierarchy,klist,1)]],[curve=[-26,-68]]).
arc(arc00026,node00044,node00043,influence,[name=i23],[]).
arc(arc00053,node00035,node00044,influence,[complete=true,name=i6_0,role=[use(none,in_hierarchy,'StructLignin',1)]],[curve=[38,28]]).
arc(arc00166,node00045,node00002,flow,[complete=true,name='FNstaMin'],[caption_offset=[-22,-34],curve=[398,500]]).
arc(arc00206,node00045,node00002,flow,[complete=true,name='FNstsMin'],[caption_offset=[-23,7],curve=[399,446]]).
arc(arc00060,node00047,node00032,influence,[complete=true,name=i50,role=[use(none,in_hierarchy,klim,1)]],[curve=[-6,-12]]).
arc(arc00028,node00048,node00047,influence,[name=i25],[]).
arc(arc00059,node00049,node00048,influence,[complete=true,name=i49,role=[use(none,in_hierarchy,'TempMod',1)]],[curve=[-14,27]]).
arc(arc00082,node00049,node00044,influence,[complete=true,name=i71,role=[use(none,in_hierarchy,'TempMod',1)]],[curve=[0,-25]]).
arc(arc00029,node00050,node00049,influence,[name=i26],[]).
arc(arc00058,node00051,node00032,influence,[complete=true,name=i48,role=[use(none,in_hierarchy,'UtilEffm',1)]],[curve=[-17,-5]]).
arc(arc00030,node00052,node00051,influence,[name=i27],[]).
arc(arc00086,node00053,node00033,influence,[complete=true,name=i75,role=[use(none,in_hierarchy,'UtilEffSta',1)]],[curve=[-8,42]]).
arc(arc00038,node00054,node00053,influence,[name=i35],[]).
arc(arc00043,node00010,node00055,flow,[comment='Fma = LiMetabolic_C*klim*UtilEffm',complete=true,name='Fma'],[caption_offset=[0,0],curve=[550,501]]).
arc(arc00075,node00008,node00055,flow,[comment='Fsta = LiStructural_C*(1-StructLignin)*klist*UtilEffsta',complete=true,name='Fsta'],[caption_offset=[-48,-24],curve=[400,476]]).
arc(arc00039,node00056,node00055,influence,[name=i36],[]).
arc(arc00045,node00055,node00057,flow,[comment='FCO2a = Active_Soil_C*ka*Respa',complete=true,name='FCO2a'],[caption_offset=[-20,1],curve=[550,497]]).
arc(arc00040,node00058,node00057,influence,[name=i37],[]).
arc(arc00047,node00055,node00059,flow,[comment='Fas = Active_Soil_C*ka*(UtilEffas)',complete=true,name='Fas'],[caption_offset=[-30,-32],curve=[403,500]]).
arc(arc00087,node00008,node00059,flow,[comment='Fsts = LiStructural_C*StructLignin*klist*UtilEffsts',complete=true,name='Fsts'],[caption_offset=[3,-39],curve=[399,422]]).
arc(arc00091,node00059,node00055,flow,[complete=true,name='Fsa'],[caption_offset=[-17,-1],curve=[396,499]]).
arc(arc00041,node00060,node00059,influence,[name=i38],[]).
arc(arc00049,node00059,node00061,flow,[comment='FCO2s = Slow_Soil_C*Ks*(1-UtilEFFsa-UtilEffsp)',complete=true,name='FCO2s'],[caption_offset=[0,0],curve=[550,500]]).
arc(arc00042,node00062,node00061,influence,[name=i39],[]).
arc(arc00044,node00063,arc00043,influence,[name=i40],[]).
arc(arc00061,node00047,node00063,influence,[complete=true,name=i51,role=[use(none,in_hierarchy,klim,1)]],[curve=[-8,-18]]).
arc(arc00117,node00051,node00063,influence,[complete=true,name=i101,role=[use(none,in_hierarchy,'UtilEffm',1)]],[curve=[30,8]]).
arc(arc00174,node00010,node00063,influence,[complete=true,name=i149,role=[use(none,in_hierarchy,'LiMetabolic_C',1)]],[curve=[-46,4]]).
arc(arc00046,node00064,arc00045,influence,[name=i41],[]).
arc(arc00073,node00055,node00064,influence,[complete=true,name=i63,role=[use(none,in_hierarchy,'Active_Soil_C',1)]],[curve=[0,-20]]).
arc(arc00048,node00065,arc00047,influence,[name=i42],[]).
arc(arc00074,node00055,node00065,influence,[complete=true,name=i64,role=[use(none,in_hierarchy,'Active_Soil_C',1)]],[curve=[13,28]]).
arc(arc00050,node00066,arc00049,influence,[name=i43],[]).
arc(arc00252,node00059,node00066,influence,[complete=true,name=i52_0,role=[use(none,in_hierarchy,'Slow_Soil_C',1)]],[curve=[36,16]]).
arc(arc00056,node00059,node00069,flow,[comment='Fsp = Slow_Soil_C*Ks*UtilEffsp',complete=true,name='Fsp'],[caption_offset=[0,0],curve=[401,499]]).
arc(arc00095,node00069,node00055,flow,[comment='Fpa = Passive_Soil_C*kp*UtilEffp',complete=true,name='Fpa'],[caption_offset=[-38,-26],curve=[398,498]]).
arc(arc00240,node00055,node00069,flow,[comment='Fap = Active_Soil_C*ka*0.004',complete=true,name='Fap'],[caption_offset=[-31,-17],curve=[401,500]]).
arc(arc00055,node00070,node00069,influence,[name=i46],[]).
arc(arc00057,node00071,arc00056,influence,[name=i47],[]).
arc(arc00111,node00059,node00071,influence,[complete=true,name=i95,role=[use(none,in_hierarchy,'Slow_Soil_C',1)]],[curve=[-16,14]]).
arc(arc00062,node00073,node00072,influence,[name=i52],[]).
arc(arc00248,node00074,node00064,influence,[complete=true,name=i48_0,role=[use(none,in_hierarchy,'Respa',1)]],[curve=[2,-1]]).
arc(arc00063,node00075,node00074,influence,[name=i53],[]).
arc(arc00069,node00072,node00075,influence,[complete=true,name=i59,role=[use(none,in_hierarchy,'Clay',1)]],[curve=[-8,3]]).
arc(arc00067,node00076,node00065,influence,[complete=true,name=i57,role=[use(none,in_hierarchy,'UtilEffas',1)]],[curve=[-80,-9]]).
arc(arc00064,node00077,node00076,influence,[name=i54],[]).
arc(arc00068,node00074,node00077,influence,[complete=true,name=i58,role=[use(none,in_hierarchy,'Respa',1)]],[curve=[6,2]]).
arc(arc00072,node00078,node00064,influence,[complete=true,name=i62,role=[use(none,in_hierarchy,ka,1)]],[curve=[48,-41]]).
arc(arc00245,node00078,node00065,influence,[complete=true,name=i45,role=[use(none,in_hierarchy,ka,1)]],[curve=[62,-2]]).
arc(arc00065,node00079,node00078,influence,[name=i55],[]).
arc(arc00070,node00072,node00079,influence,[complete=true,name=i60,role=[use(none,in_hierarchy,'Clay',1)]],[curve=[0,20]]).
arc(arc00101,node00049,node00079,influence,[complete=true,name=i85,role=[use(none,in_hierarchy,'TempMod',1)]],[curve=[8,26]]).
arc(arc00108,node00080,node00045,influence,[name=i14_0],[]).
arc(arc00023,node00035,node00082,influence,[complete=true,name=i1_0,role=[use(none,in_hierarchy,'StructLignin',1)]],[curve=[-22,-22]]).
arc(arc00024,node00008,node00082,influence,[complete=true,name=i2_0,role=[use(none,in_hierarchy,'LiStructural_C',1)]],[curve=[32,-26]]).
arc(arc00076,node00082,arc00075,influence,[name=i65],[]).
arc(arc00081,node00043,node00082,influence,[complete=true,name=i70,role=[use(none,in_hierarchy,klist,1)]],[curve=[14,-24]]).
arc(arc00085,node00053,node00082,influence,[complete=true,name=i74,role=[use(none,in_hierarchy,'UtilEffSta',1)]],[curve=[51,10]]).
arc(arc00027,node00008,node00083,influence,[complete=true,name=i3_0,role=[use(none,in_hierarchy,'LiStructural_C',1)]],[curve=[70,-56]]).
arc(arc00051,node00043,node00083,influence,[complete=true,name=i4_0,role=[use(none,in_hierarchy,klist,1)]],[curve=[-18,-34]]).
arc(arc00052,node00041,node00083,influence,[complete=true,name=i5_0,role=[use(none,in_hierarchy,'UtilEffsts',1)]],[curve=[74,-5]]).
arc(arc00088,node00083,arc00087,influence,[name=i76],[]).
arc(arc00116,node00035,node00083,influence,[complete=true,name=i100,role=[use(none,in_hierarchy,'StructLignin',1)]],[curve=[-18,-3]]).
arc(arc00253,node00084,node00066,influence,[complete=true,name=i53_0,role=[use(none,in_hierarchy,'UtilEffsa',1)]],[curve=[23,-2]]).
arc(arc00089,node00085,node00084,influence,[name=i77],[]).
arc(arc00092,node00086,arc00091,influence,[name=i79],[]).
arc(arc00243,node00084,node00086,influence,[complete=true,name=i43_0,role=[use(none,in_hierarchy,'UtilEffsa',1)]],[curve=[14,5]]).
arc(arc00244,node00059,node00086,influence,[complete=true,name=i44,role=[use(none,in_hierarchy,'Slow_Soil_C',1)]],[curve=[-8,-14]]).
arc(arc00124,node00087,arc00122,influence,[name=i15_0],[]).
arc(arc00198,arc00127,node00087,influence,[complete=true,name=i1_1,role=[use(none,in_hierarchy,'FNma',1)]],[curve=[-7,-6]]).
arc(arc00096,node00089,arc00095,influence,[name=i81],[]).
arc(arc00106,node00069,node00089,influence,[complete=true,name=i90,role=[use(none,in_hierarchy,'Passive_Soil_C',1)]],[curve=[8,-30]]).
arc(arc00098,node00069,node00090,flow,[comment='FCO2p = Passive_Soil_C*kp*(1-UtilEffp)',complete=true,name='FCO2p'],[caption_offset=[-35,-42],curve=[550,500]]).
arc(arc00097,node00091,node00090,influence,[name=i82],[]).
arc(arc00099,node00092,arc00098,influence,[name=i83],[]).
arc(arc00100,node00069,node00092,influence,[complete=true,name=i84,role=[use(none,in_hierarchy,'Passive_Soil_C',1)]],[curve=[0,12]]).
arc(arc00105,node00093,node00092,influence,[complete=true,name=i89,role=[use(none,in_hierarchy,kp,1)]],[curve=[-83,-29]]).
arc(arc00109,node00093,node00089,influence,[complete=true,name=i93,role=[use(none,in_hierarchy,kp,1)]],[curve=[56,-20]]).
arc(arc00102,node00094,node00093,influence,[name=i86],[]).
arc(arc00110,node00049,node00094,influence,[complete=true,name=i94,role=[use(none,in_hierarchy,'TempMod',1)]],[curve=[30,30]]).
arc(arc00104,node00095,node00092,influence,[complete=true,name=i88,role=[use(none,in_hierarchy,'UtilEffp',1)]],[curve=[47,6]]).
arc(arc00242,node00095,node00089,influence,[complete=true,name=i42_0,role=[use(none,in_hierarchy,'UtilEffp',1)]],[curve=[68,-37]]).
arc(arc00103,node00096,node00095,influence,[name=i87],[]).
arc(arc00159,node00097,arc00127,influence,[name=i16_0],[]).
arc(arc00177,node00099,arc00166,influence,[name=i17_0],[]).
arc(arc00227,arc00204,node00099,influence,[complete=true,name=i28_1,role=[use(none,in_hierarchy,'FNsta',1)]],[curve=[-2,28]]).
arc(arc00113,node00101,node00071,influence,[complete=true,name=i97,role=[use(none,in_hierarchy,ks,1)]],[curve=[44,6]]).
arc(arc00115,node00101,node00086,influence,[complete=true,name=i99,role=[use(none,in_hierarchy,ks,1)]],[curve=[56,-32]]).
arc(arc00251,node00101,node00066,influence,[complete=true,name=i51_0,role=[use(none,in_hierarchy,ks,1)]],[curve=[82,-18]]).
arc(arc00112,node00102,node00101,influence,[name=i96],[]).
arc(arc00114,node00049,node00102,influence,[complete=true,name=i98,role=[use(none,in_hierarchy,'TempMod',1)]],[curve=[72,50]]).
arc(arc00179,node00105,arc00178,influence,[name=i18_0],[]).
arc(arc00123,node00108,node00107,influence,[name=i107],[]).
arc(arc00181,node00109,node00087,influence,[complete=true,name=i20,role=[use(none,in_hierarchy,'DecNa',1)]],[curve=[0,-58]]).
arc(arc00182,node00109,node00097,influence,[complete=true,name=i21,role=[use(none,in_hierarchy,'DecNa',1)]],[curve=[30,12]]).
arc(arc00127,node00037,node00113,flow,[complete=true,name='FNma'],[caption_offset=[-38,-8],curve=[399,265]]).
arc(arc00130,node00113,node00002,flow,[complete=true,name='FNaMin'],[caption_offset=[-26,-33],curve=[400,500]]).
arc(arc00144,node00002,node00113,flow,[complete=true,name='Immob a'],[caption_offset=[-18,-40],curve=[395,560]]).
arc(arc00204,node00045,node00113,flow,[complete=true,name='FNsta'],[caption_offset=[10,-21],curve=[400,162]]).
arc(arc00268,node00002,node00113,flow,[complete=true,name='Immob sta'],[caption_offset=[-19,-35],curve=[395,437]]).
arc(arc00126,node00114,node00113,influence,[name=i110],[]).
arc(arc00180,node00115,node00109,influence,[name=i19_0],[]).
arc(arc00184,node00051,node00115,influence,[complete=true,name=i23_0,role=[use(none,in_hierarchy,'UtilEffm',1)]],[curve=[0,-8]]).
arc(arc00185,arc00043,node00115,influence,[complete=true,name=i24,role=[use(none,in_hierarchy,'Fma',1)]],[curve=[-24,19]]).
arc(arc00134,node00117,node00113,flow,[complete=true,name='FNsa'],[caption_offset=[-20,0],curve=[400,406]]).
arc(arc00138,node00117,node00002,flow,[complete=true,name='FNsMin'],[caption_offset=[-51,-25],curve=[401,277]]).
arc(arc00162,node00113,node00117,flow,[complete=true,name='FNas'],[caption_offset=[12,-24],curve=[397,212]]).
arc(arc00178,node00045,node00117,flow,[complete=true,name='FNsts'],[caption_offset=[8,-20],curve=[399,151]]).
arc(arc00283,node00002,node00117,flow,[complete=true,name='Immob sts'],[caption_offset=[21,-21],curve=[399,231]]).
arc(arc00128,node00118,node00117,influence,[name=i112],[]).
arc(arc00132,node00117,node00119,flow,[complete=true,name='FNsp'],[caption_offset=[-30,6],curve=[401,417]]).
arc(arc00136,node00119,node00002,flow,[complete=true,name='FNpMin'],[caption_offset=[-15,-41],curve=[397,195]]).
arc(arc00140,node00113,node00119,flow,[complete=true,name='FNap'],[caption_offset=[-9,-41],curve=[401,96]]).
arc(arc00142,node00119,node00113,flow,[complete=true,name='FNpa'],[caption_offset=[-22,-1],curve=[400,136]]).
arc(arc00129,node00120,node00119,influence,[name=i113],[]).
arc(arc00131,node00121,arc00130,influence,[name=i114],[]).
arc(arc00158,arc00140,node00121,influence,[complete=true,name=i134,role=[use(none,in_hierarchy,'FNap',1)]],[curve=[-10,4]]).
arc(arc00273,arc00162,node00121,influence,[complete=true,name=i72_0,role=[use(none,in_hierarchy,'FNas',1)]],[curve=[-34,22]]).
arc(arc00133,node00122,arc00132,influence,[name=i115],[]).
arc(arc00169,arc00056,node00122,influence,[complete=true,name=i144,role=[use(none,in_hierarchy,'Fsp',1)]],[curve=[-148,225]]).
arc(arc00135,node00123,arc00134,influence,[name=i116],[]).
arc(arc00161,arc00091,node00123,influence,[complete=true,name=i137,role=[use(none,in_hierarchy,'Fsa',1)]],[curve=[-410,286]]).
arc(arc00137,node00124,arc00136,influence,[name=i117],[]).
arc(arc00149,arc00142,node00124,influence,[complete=true,name=i125,role=[use(none,in_hierarchy,'FNpa',1)]],[curve=[-6,4]]).
arc(arc00139,node00125,arc00138,influence,[name=i118],[]).
arc(arc00168,arc00134,node00125,influence,[complete=true,name=i143,role=[use(none,in_hierarchy,'FNsa',1)]],[curve=[-83,-1]]).
arc(arc00280,arc00132,node00125,influence,[complete=true,name=i78,role=[use(none,in_hierarchy,'FNsp',1)]],[curve=[-9,-8]]).
arc(arc00141,node00126,arc00140,influence,[name=i119],[]).
arc(arc00275,arc00240,node00126,influence,[complete=true,name=i74_0,role=[use(none,in_hierarchy,'Fap',1)]],[curve=[-249,684]]).
arc(arc00143,node00127,arc00142,influence,[name=i120],[]).
arc(arc00152,arc00095,node00127,influence,[complete=true,name=i128,role=[use(none,in_hierarchy,'Fpa',1)]],[curve=[46,432]]).
arc(arc00145,node00128,arc00144,influence,[name=i121],[]).
arc(arc00183,node00109,node00128,influence,[complete=true,name=i22_0,role=[use(none,in_hierarchy,'DecNa',1)]],[curve=[-230,74]]).
arc(arc00150,node00129,node00127,influence,[complete=true,name=i126,role=[use(none,in_hierarchy,'CN_active_SOM',int)]],[curve=[164,-56]]).
arc(arc00160,node00129,node00123,influence,[complete=true,name=i136,role=[use(none,in_hierarchy,'CN_active_SOM',int)]],[curve=[213,-96]]).
arc(arc00146,node00130,node00129,influence,[name=i122],[]).
arc(arc00148,node00131,node00124,influence,[complete=true,name=i124,role=[use(none,in_hierarchy,'DecompNp',1)]],[curve=[2,-58]]).
arc(arc00147,node00132,node00131,influence,[name=i123],[]).
arc(arc00151,arc00095,node00132,influence,[complete=true,name=i127,role=[use(none,in_hierarchy,'Fpa',1)]],[curve=[2,-66]]).
arc(arc00153,node00095,node00132,influence,[complete=true,name=i129,role=[use(none,in_hierarchy,'UtilEffp',1)]],[curve=[140,-174]]).
arc(arc00155,node00133,node00132,influence,[complete=true,name=i131,role=[use(none,in_hierarchy,'CN_passive_SOM',int)]],[curve=[35,54]]).
arc(arc00156,node00133,node00122,influence,[complete=true,name=i132,role=[use(none,in_hierarchy,'CN_passive_SOM',int)]],[curve=[210,-46]]).
arc(arc00157,node00133,node00126,influence,[complete=true,name=i133,role=[use(none,in_hierarchy,'CN_passive_SOM',int)]],[curve=[169,-102]]).
arc(arc00154,node00134,node00133,influence,[name=i130],[]).
arc(arc00187,node00135,node00097,influence,[complete=true,name=i26_0,role=[use(none,in_hierarchy,'Demandma',1)]],[curve=[-8,-40]]).
arc(arc00270,node00135,node00128,influence,[complete=true,name=i69,role=[use(none,in_hierarchy,'Demandma',1)]],[curve=[35,-136]]).
arc(arc00163,node00137,arc00162,influence,[name=i138],[]).
arc(arc00164,arc00047,node00137,influence,[complete=true,name=i139,role=[use(none,in_hierarchy,'Fas',1)]],[curve=[280,552]]).
arc(arc00167,node00138,node00137,influence,[complete=true,name=i142,role=[use(none,in_hierarchy,'CN_slow_SOM',int)]],[curve=[190,-102]]).
arc(arc00165,node00139,node00138,influence,[name=i140],[]).
arc(arc00186,node00140,node00135,influence,[name=i25_0],[]).
arc(arc00199,arc00043,node00140,influence,[complete=true,name=i2_1,role=[use(none,in_hierarchy,'Fma',1)]],[curve=[-8,-30]]).
arc(arc00203,node00129,node00140,influence,[complete=true,name=i6_1,role=[use(none,in_hierarchy,'CN_active_SOM',int)]],[curve=[140,32]]).
arc(arc00188,node00142,node00141,influence,[name=i27_0],[]).
arc(arc00189,node00020,node00142,influence,[complete=true,name=i28_0,role=[use(none,in_hierarchy,'Residue_CN',1)]],[curve=[-6,-11]]).
arc(arc00190,node00024,node00142,influence,[complete=true,name=i29_0,role=[use(none,in_hierarchy,'SplitMet',1)]],[curve=[-28,1]]).
arc(arc00192,node00143,node00142,influence,[complete=true,name=i31_0,role=[use(none,in_hierarchy,'CN_LiSt',int)]],[curve=[-9,-18]]).
arc(arc00191,node00144,node00143,influence,[name=i30_0],[]).
arc(arc00197,node00145,node00039,influence,[complete=true,name=i36_0,role=[use(none,in_hierarchy,'INIT_LiMetabolicN',1)]],[curve=[52,-1]]).
arc(arc00193,node00146,node00145,influence,[name=i32_0],[]).
arc(arc00194,node00016,node00146,influence,[complete=true,name=i33_0,role=[use(none,in_hierarchy,'Initial_C',int)]],[curve=[-6,12]]).
arc(arc00195,node00024,node00146,influence,[complete=true,name=i34_0,role=[use(none,in_hierarchy,'SplitMet',1)]],[curve=[-12,-60]]).
arc(arc00196,node00141,node00146,influence,[complete=true,name=i35_0,role=[use(none,in_hierarchy,'CNLiMet',1)]],[curve=[32,-9]]).
arc(arc00274,node00147,node00121,influence,[complete=true,name=i73_0,role=[use(none,in_hierarchy,'DecompNa',1)]],[curve=[-16,-183]]).
arc(arc00200,node00148,node00147,influence,[name=i3_1],[]).
arc(arc00290,arc00047,node00148,influence,[complete=true,name=i87_0,role=[use(none,in_hierarchy,'Fas',1)]],[curve=[-24,24]]).
arc(arc00291,node00076,node00148,influence,[complete=true,name=i88_0,role=[use(none,in_hierarchy,'UtilEffas',1)]],[curve=[-3,-28]]).
arc(arc00292,node00129,node00148,influence,[complete=true,name=i89_0,role=[use(none,in_hierarchy,'CN_active_SOM',int)]],[curve=[205,2]]).
arc(arc00205,node00151,arc00204,influence,[name=i7_1],[]).
arc(arc00207,node00152,arc00206,influence,[name=i8_1],[]).
arc(arc00213,arc00178,node00152,influence,[complete=true,name=i14_1,role=[use(none,in_hierarchy,'FNsts',1)]],[curve=[0,-5]]).
arc(arc00212,node00153,node00080,influence,[complete=true,name=i13_1,role=[use(none,in_hierarchy,'INIT_Listructural_N',1)]],[curve=[73,-36]]).
arc(arc00208,node00154,node00153,influence,[name=i9_1],[]).
arc(arc00209,node00016,node00154,influence,[complete=true,name=i10_1,role=[use(none,in_hierarchy,'Initial_C',int)]],[curve=[14,14]]).
arc(arc00210,node00024,node00154,influence,[complete=true,name=i11_1,role=[use(none,in_hierarchy,'SplitMet',1)]],[curve=[62,30]]).
arc(arc00211,node00143,node00154,influence,[complete=true,name=i12_1,role=[use(none,in_hierarchy,'CN_LiSt',int)]],[curve=[12,10]]).
arc(arc00221,node00155,node00152,influence,[complete=true,name=i22_1,role=[use(none,in_hierarchy,'DecNsts',1)]],[curve=[12,-138]]).
arc(arc00289,node00155,node00105,influence,[complete=true,name=i86_0,role=[use(none,in_hierarchy,'DecNsts',1)]],[curve=[8,-254]]).
arc(arc00214,node00156,node00155,influence,[name=i15_1],[]).
arc(arc00216,node00143,node00156,influence,[complete=true,name=i17_1,role=[use(none,in_hierarchy,'CN_LiSt',int)]],[curve=[-34,10]]).
arc(arc00238,arc00087,node00156,influence,[complete=true,name=i39_0,role=[use(none,in_hierarchy,'Fsts',1)]],[curve=[-59,86]]).
arc(arc00239,node00041,node00156,influence,[complete=true,name=i40_0,role=[use(none,in_hierarchy,'UtilEffsts',1)]],[curve=[30,-211]]).
arc(arc00202,node00157,node00149,influence,[name=i3_2],[]).
arc(arc00281,node00002,node00157,influence,[complete=true,name=i12_2,role=[use(none,in_hierarchy,'Mineral_N',1)]],[curve=[-14,4]]).
arc(arc00218,node00159,node00151,influence,[complete=true,name=i19_1,role=[use(none,in_hierarchy,'DecNsta',1)]],[curve=[21,-160]]).
arc(arc00225,node00159,node00099,influence,[complete=true,name=i26_1,role=[use(none,in_hierarchy,'DecNsta',1)]],[curve=[19,-129]]).
arc(arc00217,node00160,node00159,influence,[name=i18_1],[]).
arc(arc00220,node00143,node00160,influence,[complete=true,name=i21_0,role=[use(none,in_hierarchy,'CN_LiSt',int)]],[curve=[0,29]]).
arc(arc00236,arc00075,node00160,influence,[complete=true,name=i37_0,role=[use(none,in_hierarchy,'Fsta',1)]],[curve=[-42,-96]]).
arc(arc00237,node00053,node00160,influence,[complete=true,name=i38_0,role=[use(none,in_hierarchy,'UtilEffSta',1)]],[curve=[41,-146]]).
arc(arc00223,node00161,node00151,influence,[complete=true,name=i24_0,role=[use(none,in_hierarchy,'Demandsta',1)]],[curve=[126,-12]]).
arc(arc00222,node00162,node00161,influence,[name=i23_1],[]).
arc(arc00228,arc00075,node00162,influence,[complete=true,name=i29_1,role=[use(none,in_hierarchy,'Fsta',1)]],[curve=[-4,-90]]).
arc(arc00230,node00129,node00162,influence,[complete=true,name=i31_1,role=[use(none,in_hierarchy,'CN_active_SOM',int)]],[curve=[120,-44]]).
arc(arc00287,node00163,node00105,influence,[complete=true,name=i84_0,role=[use(none,in_hierarchy,'Demandsts',1)]],[curve=[-34,-87]]).
arc(arc00090,node00138,node00164,influence,[complete=true,name=i1_2,role=[use(none,in_hierarchy,'CN_slow_SOM',int)]],[curve=[-40,-120]]).
arc(arc00201,arc00087,node00164,influence,[complete=true,name=i2_2,role=[use(none,in_hierarchy,'Fsts',1)]],[curve=[16,-105]]).
arc(arc00224,node00164,node00163,influence,[name=i25_1],[]).
arc(arc00277,node00165,node00157,influence,[complete=true,name=i11_2,role=[use(none,in_hierarchy,'Total_SOM_N',1)]],[curve=[-10,4]]).
arc(arc00215,node00166,node00165,influence,[name=i4_1],[]).
arc(arc00246,node00113,node00166,influence,[complete=true,name=i8_2,role=[use(none,in_hierarchy,'Active_Soil_N',1)]],[curve=[6,85]]).
arc(arc00247,node00119,node00166,influence,[complete=true,name=i9_2,role=[use(none,in_hierarchy,'Passive_Soil_N',1)]],[curve=[-22,-34]]).
arc(arc00276,node00117,node00166,influence,[complete=true,name=i10_2,role=[use(none,in_hierarchy,'Slow_Soil_N',1)]],[curve=[57,146]]).
arc(arc00231,node00169,node00168,influence,[name=i32_1],[]).
arc(arc00232,node00037,node00169,influence,[complete=true,name=i33_1,role=[use(none,in_hierarchy,'LiMetabolic_N',1)]],[curve=[-2,-12]]).
arc(arc00233,node00045,node00169,influence,[complete=true,name=i34_1,role=[use(none,in_hierarchy,'LiStructuralN',1)]],[curve=[-12,29]]).
arc(arc00235,node00170,node00115,influence,[complete=true,name=i36_1,role=[use(none,in_hierarchy,'CN_LiMet',1)]],[curve=[12,2]]).
arc(arc00234,node00171,node00170,influence,[name=i35_1],[]).
arc(arc00330,node00024,node00171,influence,[complete=true,name=i17_2,role=[use(none,in_hierarchy,'SplitMet',1)]],[curve=[14,4]]).
arc(arc00331,node00020,node00171,influence,[complete=true,name=i18_2,role=[use(none,in_hierarchy,'Residue_CN',1)]],[curve=[30,-48]]).
arc(arc00332,node00143,node00171,influence,[complete=true,name=i19_2,role=[use(none,in_hierarchy,'CN_LiSt',int)]],[curve=[-2,8]]).
arc(arc00241,node00172,arc00240,influence,[name=i41_0],[]).
arc(arc00249,node00055,node00172,influence,[complete=true,name=i49_0,role=[use(none,in_hierarchy,'Active_Soil_C',1)]],[curve=[-12,31]]).
arc(arc00250,node00078,node00172,influence,[complete=true,name=i50_0,role=[use(none,in_hierarchy,ka,1)]],[curve=[32,15]]).
arc(arc00255,node00173,node00066,influence,[complete=true,name=i55_0,role=[use(none,in_hierarchy,'UtilEffsp',1)]],[curve=[28,28]]).
arc(arc00256,node00173,node00071,influence,[complete=true,name=i56,role=[use(none,in_hierarchy,'UtilEffsp',1)]],[curve=[8,-20]]).
arc(arc00254,node00174,node00173,influence,[name=i54_0],[]).
arc(arc00257,node00176,node00175,influence,[name=i57_0],[]).
arc(arc00258,node00057,node00176,influence,[complete=true,name=i58_0,role=[use(none,in_hierarchy,'CO2_a',1)]],[curve=[-104,-6]]).
arc(arc00259,node00061,node00176,influence,[complete=true,name=i59_0,role=[use(none,in_hierarchy,'CO2s',1)]],[curve=[79,-62]]).
arc(arc00260,node00090,node00176,influence,[complete=true,name=i60_0,role=[use(none,in_hierarchy,'CO2p',1)]],[curve=[-16,-30]]).
arc(arc00261,node00178,node00177,influence,[name=i61],[]).
arc(arc00262,node00030,node00178,influence,[complete=true,name=i62_0,role=[use(none,in_hierarchy,'Litter_CO2',1)]],[curve=[2,-6]]).
arc(arc00263,node00175,node00178,influence,[complete=true,name=i63_0,role=[use(none,in_hierarchy,'Soil_CO2',1)]],[curve=[-6,-4]]).
arc(arc00264,node00180,node00179,influence,[name=i64_0],[]).
arc(arc00265,node00055,node00180,influence,[complete=true,name=i65_0,role=[use(none,in_hierarchy,'Active_Soil_C',1)]],[curve=[-32,-133]]).
arc(arc00266,node00069,node00180,influence,[complete=true,name=i66_0,role=[use(none,in_hierarchy,'Passive_Soil_C',1)]],[curve=[16,4]]).
arc(arc00267,node00059,node00180,influence,[complete=true,name=i67_0,role=[use(none,in_hierarchy,'Slow_Soil_C',1)]],[curve=[-58,-30]]).
arc(arc00269,node00181,arc00268,influence,[name=i68_0],[]).
arc(arc00271,node00161,node00181,influence,[complete=true,name=i70_0,role=[use(none,in_hierarchy,'Demandsta',1)]],[curve=[23,-118]]).
arc(arc00272,node00159,node00181,influence,[complete=true,name=i71_0,role=[use(none,in_hierarchy,'DecNsta',1)]],[curve=[76,-116]]).
arc(arc00279,node00183,node00125,influence,[complete=true,name=i77_0,role=[use(none,in_hierarchy,'DecompNs',1)]],[curve=[14,-85]]).
arc(arc00278,node00184,node00183,influence,[name=i76_0],[]).
arc(arc00293,arc00056,node00184,influence,[complete=true,name=i90_0,role=[use(none,in_hierarchy,'Fsp',1)]],[curve=[176,174]]).
arc(arc00294,node00173,node00184,influence,[complete=true,name=i91,role=[use(none,in_hierarchy,'UtilEffsp',1)]],[curve=[356,76]]).
arc(arc00295,node00138,node00184,influence,[complete=true,name=i92,role=[use(none,in_hierarchy,'CN_slow_SOM',int)]],[curve=[-20,12]]).
arc(arc00284,node00185,arc00283,influence,[name=i81_0],[]).
arc(arc00285,node00163,node00185,influence,[complete=true,name=i82_0,role=[use(none,in_hierarchy,'Demandsts',1)]],[curve=[24,-101]]).
arc(arc00286,node00155,node00185,influence,[complete=true,name=i83_0,role=[use(none,in_hierarchy,'DecNsts',1)]],[curve=[78,-99]]).
arc(arc00327,node00107,node00186,influence,[complete=true,name=i14_2],[curve=[-249,145]]).
arc(arc00329,node00186,node00050,influence,[complete=true,name=i16_1,role=[use(none,in_hierarchy,yInterpolated,1)]],[curve=[-12,15]]).
arc(arc00296,node00194,node00193,influence,[name=i3],[]).
arc(arc00297,node00196,node00195,influence,[name=i4],[]).
arc(arc00300,node00193,node00196,influence,[complete=true,name=i7,role=[use(none,in_hierarchy,'TSUM',1)]],[curve=[0,-8]]).
arc(arc00302,node00201,node00200,influence,[name=i15],[]).
arc(arc00304,node00195,node00201,influence,[complete=true,name=i17,role=[use(none,in_hierarchy,'ArrayPosOfLowerXNW',int)]],[curve=[2,1]]).
arc(arc00307,node00202,node00201,influence,[complete=true,name=i21,role=[use(none,in_hierarchy,'ArraySize',int)]],[curve=[-34,-26]]).
arc(arc00305,node00203,node00202,influence,[name=i18],[]).
arc(arc00298,node00204,node00197,influence,[name=i1],[]).
arc(arc00309,node00200,node00204,influence,[complete=true,name=i8_0,role=[use(none,in_hierarchy,'LowerArrayPos',1)]],[curve=[12,-13]]).
arc(arc00299,node00206,node00205,influence,[name=i2],[]).
arc(arc00308,node00200,node00206,influence,[complete=true,name=i7_0,role=[use(none,in_hierarchy,'LowerArrayPos',1)]],[curve=[8,-18]]).
arc(arc00303,node00208,node00207,influence,[name=i3_0],[]).
arc(arc00310,node00200,node00208,influence,[complete=true,name=i9_0,role=[use(none,in_hierarchy,'LowerArrayPos',1)]],[curve=[6,-5]]).
arc(arc00306,node00210,node00209,influence,[name=i4_0],[]).
arc(arc00311,node00200,node00210,influence,[complete=true,name=i10,role=[use(none,in_hierarchy,'LowerArrayPos',1)]],[curve=[-2,-2]]).
arc(arc00313,node00212,node00211,influence,[name=i14_0],[]).
arc(arc00314,node00197,node00212,influence,[complete=true,name=i15_0,role=[use(none,in_hierarchy,xLower,1)]],[curve=[-57,-16]]).
arc(arc00315,node00205,node00212,influence,[complete=true,name=i16,role=[use(none,in_hierarchy,xHigher,1)]],[curve=[4,-4]]).
arc(arc00316,node00207,node00212,influence,[complete=true,name=i17_0,role=[use(none,in_hierarchy,yLower,1)]],[curve=[12,-21]]).
arc(arc00317,node00209,node00212,influence,[complete=true,name=i18_0,role=[use(none,in_hierarchy,yHigher,1)]],[curve=[42,-34]]).
arc(arc00318,node00193,node00212,influence,[complete=true,name=i19,role=[use(none,in_hierarchy,xSupplied,1)]],[curve=[8,-2]]).
arc(arc00322,node00215,node00206,influence,[complete=true,name=i5,role=[use(none,in_hierarchy,[xList2],array(1,11))]],[curve=[36,-4]]).
arc(arc00323,node00215,node00204,influence,[complete=true,name=i6,role=[use(none,in_hierarchy,[xList2],array(1,11))]],[curve=[6,-15]]).
arc(arc00324,node00215,node00196,influence,[complete=true,name=i7_1,role=[use(none,in_hierarchy,[xList2],array(1,11))]],[curve=[0,-8]]).
arc(arc00325,node00215,node00203,influence,[complete=true,name=i8,role=[use(none,in_hierarchy,[xList2],array(1,11))]],[curve=[10,-18]]).
arc(arc00312,node00216,node00215,influence,[name=i1_0],[]).
arc(arc00320,node00217,node00210,influence,[complete=true,name=i3_1,role=[use(none,in_hierarchy,['Ylist'],array(1,11))]],[curve=[17,8]]).
arc(arc00321,node00217,node00208,influence,[complete=true,name=i4_1,role=[use(none,in_hierarchy,['Ylist'],array(1,11))]],[curve=[-14,-3]]).
arc(arc00319,node00218,node00217,influence,[name=i2_0],[]).
arc(arc00282,node00222,node00221,influence,[name=i1_1],[]).
arc(arc00288,node00224,node00223,influence,[name=i2_1],[]).
arc(arc00301,node00226,node00225,influence,[name=i3_2],[]).
arc(arc00326,node00227,node00194,influence,[complete=true,name=i13,role=[use(none,in_hierarchy,'Temperature',int)]],[curve=[-84,193]]).
arc(arc00328,node00211,node00228,influence,[complete=true,name=i15_1],[curve=[-52,-20]]).

