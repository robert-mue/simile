source(program='AME',version= 9.0,edition=standard,date='Tue Feb 05 17:14:11 GMT 2008').

roots([node00002,node00003,node00004,node00005,node00006,node00007,node00008,node00009,node00010,node00011,node00012,node00013,node00014,node00015,node00016,node00017,node00018,node00019,node00020,node00021,node00022,node00023,node00024,node00025,node00026,node00027,node00028,node00029,node00030,node00031,node00032,node00033,node00034,node00035,node00036,node00037,node00038,node00039,node00040,node00041,node00042,node00043,node00044,node00045,node00046,node00047]).

properties([complete-true,file_name-'C:/Inetpub/wwwroot/www/examples/catalogue/models/bob/daisyworld1/daisyworld1.sml',name-daisyworld1]).

node(node00002,compartment,[],[complete=true,name=black_area],[caption_offset=[0,-48],centre=[345,-7]]).
node(node00003,compartment,[],[complete=true,name=white_area],[caption_offset=[0,0],centre=[352,265]]).
node(node00004,cloud,[],[complete=true,name=cd1],[centre=[25,-14]]).
node(node00005,function,[],[complete=true,name=fn1,units=1,value=black_area*bare_area*black_gr],[]).
node(node00006,cloud,[],[complete=true,name=cd2],[centre=[28,268]]).
node(node00007,function,[],[complete=true,name=fn2,units=1,value=white_area*bare_area*white_gr],[]).
node(node00008,cloud,[],[complete=true,name=cd3],[centre=[499,-13]]).
node(node00009,function,[],[complete=true,name=fn3,units=1,value=d*black_area],[]).
node(node00010,cloud,[],[complete=true,name=cd4],[centre=[499,266]]).
node(node00011,function,[],[complete=true,name=fn4,units=1,value=d*white_area],[]).
node(node00012,variable,[],[complete=true,name=death],[caption_offset=[14,-28],centre=[444,127]]).
node(node00013,function,[],[complete=true,name=fn6,units=1,value= 0.3],[]).
node(node00014,variable,[],[complete=true,name=black_growth],[caption_offset=[-6,-32],centre=[-18,21]]).
node(node00015,function,[],[complete=true,name=fn7,units=1,value=pow(1-k1*(best_temp-black_temp),2)],[]).
node(node00016,variable,[],[complete=true,name=white_growth],[caption_offset=[-14,-2],centre=[-6,226]]).
node(node00017,function,[],[complete=true,name=fn8,units=1,value=pow(1-k1*(best_temp-white_temp),2)],[]).
node(node00018,variable,[],[complete=true,name=black_temp],[caption_offset=[-36,-26],centre=[125,45]]).
node(node00019,function,[],[complete=true,name=fn10,units=1,value=q1*(planet_albedo-black_albedo)+effective_temp],[]).
node(node00020,variable,[],[complete=true,name=effective_temp],[caption_offset=[0,0],centre=[68,105]]).
node(node00021,function,[],[complete=true,name=fn11,units=1,value=pow(solar_const*luminosity*(1-planet_albedo)/stefan, 0.25)-273],[]).
node(node00022,variable,[],[complete=true,name=white_temp],[caption_offset=[-41,-14],centre=[126,141]]).
node(node00023,function,[],[complete=true,name=fn12,units=1,value=q1*(planet_albedo-white_albedo)+effective_temp],[]).
node(node00024,variable,[],[complete=true,name=black_albedo],[caption_offset=[-6,-30],centre=[192,41]]).
node(node00025,function,[],[complete=true,name=fn13,units=1,value= 0.25],[]).
node(node00026,variable,[],[complete=true,name=white_albedo],[caption_offset=[-20,-5],centre=[185,195]]).
node(node00027,function,[],[complete=true,name=fn14,units=1,value= 0.75],[]).
node(node00028,variable,[],[complete=true,name=q1],[caption_offset=[15,-8],centre=[135,92]]).
node(node00029,function,[],[complete=true,name=fn15,units=1,value=20],[]).
node(node00030,variable,[],[complete=true,name=planet_albedo],[caption_offset=[44,-24],centre=[245,113]]).
node(node00031,function,[],[complete=true,name=fn16,units=1,value=black_albedo*black_area+white_albedo*white_area+bare_albedo*bare_area],[]).
node(node00032,variable,[],[complete=true,name=bare_area],[caption_offset=[35,-27],centre=[350,113]]).
node(node00033,function,[],[complete=true,name=fn9,units=1,value=1-black_area-white_area],[]).
node(node00034,variable,[],[complete=true,name=solar_const],[caption_offset=[0,0],centre=[4,64]]).
node(node00035,function,[],[complete=true,name=fn17,units=1,value=917],[]).
node(node00036,variable,[],[complete=true,name=luminosity],[caption_offset=[0,0],centre=[1,98]]).
node(node00037,function,[],[complete=true,name=fn18,units=1,value= 0.8],[]).
node(node00038,variable,[],[complete=true,name=stefan],[caption_offset=[0,0],centre=[12,137]]).
node(node00039,function,[],[complete=true,name=fn19,units=1,value= 5.67 *pow(10,-8)],[]).
node(node00040,variable,[],[complete=true,name=bare_albedo],[caption_offset=[13,-4],centre=[219,173]]).
node(node00041,function,[],[complete=true,name=fn20,units=1,value= 0.5],[]).
node(node00042,variable,[],[complete=true,name=best_temp],[caption_offset=[-2,-1],centre=[-92,130]]).
node(node00043,function,[],[complete=true,name=fn1,units=1,value= 22.5],[]).
node(node00044,variable,[],[complete=true,name=k1],[caption_offset=[0,0],centre=[-53,106]]).
node(node00045,function,[],[complete=true,name=fn2,units=1,value= 0.003265],[]).
node(node00046,function,[],[complete=true,units=1,value= 0.01],[]).
node(node00047,function,[],[complete=true,units=1,value= 0.01],[]).

arc(arc00001,node00004,node00002,flow,[complete=true,name=black_increase],[caption_offset=[-3,-45],curve=[550,500]]).
arc(arc00002,node00005,arc00001,influence,[name=i1],[]).
arc(arc00010,node00002,node00005,influence,[complete=true,name=i9,role=[use(none,in_hierarchy,black_area,1)]],[curve=[-2,34]]).
arc(arc00003,node00006,node00003,flow,[complete=true,name=white_increase],[caption_offset=[0,0],curve=[550,500]]).
arc(arc00004,node00007,arc00003,influence,[name=i2],[]).
arc(arc00011,node00003,node00007,influence,[complete=true,name=i10,role=[use(none,in_hierarchy,white_area,1)]],[curve=[0,34]]).
arc(arc00005,node00002,node00008,flow,[complete=true,name=black_decrease],[caption_offset=[-16,-42],curve=[550,496]]).
arc(arc00006,node00009,arc00005,influence,[name=i3],[]).
arc(arc00044,node00002,node00009,influence,[complete=true,name=i45,role=[use(none,in_hierarchy,black_area,1)]],[curve=[0,-14]]).
arc(arc00007,node00003,node00010,flow,[complete=true,name=white_decrease],[caption_offset=[0,0],curve=[550,500]]).
arc(arc00008,node00011,arc00007,influence,[name=i4],[]).
arc(arc00045,node00003,node00011,influence,[complete=true,name=i46,role=[use(none,in_hierarchy,white_area,1)]],[curve=[0,-13]]).
arc(arc00016,node00012,node00009,influence,[complete=true,name=i15,role=[use(none,in_hierarchy,d,1)]],[curve=[-28,4]]).
arc(arc00017,node00012,node00011,influence,[complete=true,name=i16,role=[use(none,in_hierarchy,d,1)]],[curve=[30,3]]).
arc(arc00009,node00013,node00012,influence,[name=i6],[]).
arc(arc00014,node00014,node00005,influence,[complete=true,name=i13,role=[use(none,in_hierarchy,black_gr,1)]],[curve=[18,9]]).
arc(arc00012,node00015,node00014,influence,[name=i11],[]).
arc(arc00015,node00016,node00007,influence,[complete=true,name=i14,role=[use(none,in_hierarchy,white_gr,1)]],[curve=[10,-46]]).
arc(arc00013,node00017,node00016,influence,[name=i12],[]).
arc(arc00054,node00018,node00015,influence,[complete=true,name=i6,role=[use(none,in_hierarchy,black_temp,1)]],[curve=[-6,32]]).
arc(arc00019,node00019,node00018,influence,[name=i18],[]).
arc(arc00026,node00020,node00019,influence,[complete=true,name=i25,role=[use(none,in_hierarchy,effective_temp,1)]],[curve=[-12,-13]]).
arc(arc00020,node00021,node00020,influence,[name=i19],[]).
arc(arc00055,node00022,node00017,influence,[complete=true,name=i7,role=[use(none,in_hierarchy,white_temp,1)]],[curve=[20,29]]).
arc(arc00021,node00023,node00022,influence,[name=i20],[]).
arc(arc00032,node00020,node00023,influence,[complete=true,name=i32,role=[use(none,in_hierarchy,effective_temp,1)]],[curve=[6,-12]]).
arc(arc00025,node00024,node00019,influence,[complete=true,name=i24,role=[use(none,in_hierarchy,black_albedo,1)]],[curve=[1,13]]).
arc(arc00022,node00025,node00024,influence,[name=i21],[]).
arc(arc00033,node00026,node00023,influence,[complete=true,name=i33,role=[use(none,in_hierarchy,white_albedo,1)]],[curve=[-12,12]]).
arc(arc00023,node00027,node00026,influence,[name=i22],[]).
arc(arc00029,node00028,node00019,influence,[complete=true,name=i28,role=[use(none,in_hierarchy,q1,1)]],[curve=[-8,2]]).
arc(arc00031,node00028,node00023,influence,[complete=true,name=i31,role=[use(none,in_hierarchy,q1,1)]],[curve=[9,2]]).
arc(arc00024,node00029,node00028,influence,[name=i23],[]).
arc(arc00028,node00030,node00019,influence,[complete=true,name=i27,role=[use(none,in_hierarchy,planet_albedo,1)]],[curve=[-16,26]]).
arc(arc00030,node00030,node00023,influence,[complete=true,name=i30,role=[use(none,in_hierarchy,planet_albedo,1)]],[curve=[6,26]]).
arc(arc00061,node00030,node00021,influence,[complete=true,name=i1,role=[use(none,in_hierarchy,planet_albedo,1)]],[curve=[0,11]]).
arc(arc00027,node00031,node00030,influence,[name=i26],[]).
arc(arc00034,node00024,node00031,influence,[complete=true,name=i35,role=[use(none,in_hierarchy,black_albedo,1)]],[curve=[15,-12]]).
arc(arc00035,node00026,node00031,influence,[complete=true,name=i36,role=[use(none,in_hierarchy,white_albedo,1)]],[curve=[-18,-13]]).
arc(arc00036,node00002,node00031,influence,[complete=true,name=i37,role=[use(none,in_hierarchy,black_area,1)]],[curve=[0,14]]).
arc(arc00037,node00003,node00031,influence,[complete=true,name=i38,role=[use(none,in_hierarchy,white_area,1)]],[curve=[-33,24]]).
arc(arc00040,node00032,node00031,influence,[complete=true,name=i41,role=[use(none,in_hierarchy,bare_area,1)]],[curve=[0,23]]).
arc(arc00056,node00032,node00005,influence,[complete=true,name=i8,role=[use(none,in_hierarchy,bare_area,1)]],[curve=[-1,2]]).
arc(arc00057,node00032,node00007,influence,[complete=true,name=i9,role=[use(none,in_hierarchy,bare_area,1)]],[curve=[36,38]]).
arc(arc00018,node00033,node00032,influence,[name=i17],[]).
arc(arc00038,node00003,node00033,influence,[complete=true,name=i39,role=[use(none,in_hierarchy,white_area,1)]],[curve=[-33,0]]).
arc(arc00039,node00002,node00033,influence,[complete=true,name=i40,role=[use(none,in_hierarchy,black_area,1)]],[curve=[24,-2]]).
arc(arc00046,node00034,node00021,influence,[complete=true,name=i47,role=[use(none,in_hierarchy,solar_const,1)]],[curve=[8,-13]]).
arc(arc00041,node00035,node00034,influence,[name=i42],[]).
arc(arc00047,node00036,node00021,influence,[complete=true,name=i48,role=[use(none,in_hierarchy,luminosity,1)]],[curve=[1,-14]]).
arc(arc00042,node00037,node00036,influence,[name=i43],[]).
arc(arc00048,node00038,node00021,influence,[complete=true,name=i49,role=[use(none,in_hierarchy,stefan,1)]],[curve=[-7,-12]]).
arc(arc00043,node00039,node00038,influence,[name=i44],[]).
arc(arc00050,node00040,node00031,influence,[complete=true,name=i51,role=[use(none,in_hierarchy,bare_albedo,1)]],[curve=[-12,-6]]).
arc(arc00049,node00041,node00040,influence,[name=i50],[]).
arc(arc00052,node00042,node00015,influence,[complete=true,name=i4,role=[use(none,in_hierarchy,best_temp,1)]],[curve=[-24,-17]]).
arc(arc00053,node00042,node00017,influence,[complete=true,name=i5,role=[use(none,in_hierarchy,best_temp,1)]],[curve=[22,-20]]).
arc(arc00051,node00043,node00042,influence,[name=i1],[]).
arc(arc00059,node00044,node00015,influence,[complete=true,name=i11,role=[use(none,in_hierarchy,k1,1)]],[curve=[-18,-8]]).
arc(arc00060,node00044,node00017,influence,[complete=true,name=i12,role=[use(none,in_hierarchy,k1,1)]],[curve=[27,-12]]).
arc(arc00058,node00045,node00044,influence,[name=i10],[]).
arc(arc00062,node00046,node00002,influence,[],[]).
arc(arc00063,node00047,node00003,influence,[],[]).

