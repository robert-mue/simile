source(program='AME',version= 9.0,edition=standard,date='Tue Feb 05 17:07:53 GMT 2008').

roots([node00002,node00003,node00004,node00005,node00006,node00007,node00008,node00009,node00010,node00011,node00012,node00013,node00014,node00015,node00016,node00017,node00018,node00019,node00020,node00021,node00022,node00023,node00024,node00025,node00026,node00027,node00028,node00029,node00030,node00031,node00032,node00033,node00034,node00035,node00036,node00037,node00038,node00039,node00040,node00041,node00042,node00043,node00044,node00045,node00046,node00047,node00048,node00049,node00050,node00051,node00052,node00053,node00054,node00055,node00056,node00057,node00058,node00059,node00060,node00061,node00062,node00063,node00064,node00065,node00066,node00067,node00068,node00069,node00070,node00071,node00073,node00074,node00075,node00076,node00077,node00078,node00079,node00080,node00081,node00082,node00083,node00084,node00085,node00086,node00087,node00088,node00089,node00090,node00091,node00092,node00093,node00094,node00095,node00097,node00099,node00101,node00102,node00103,node00104,node00105,node00106,node00107,node00108,node00109,node00110,node00111,node00112]).

properties([complete-true,file_name-'C:/Inetpub/wwwroot/www/examples/catalogue/models/bob/broomgrass1/broomgrass1.sml',name-broomgrass1]).

node(node00002,compartment,[],[comment=brooms,complete=true,name=broomgrass],[caption_offset=[9,11],centre=[180,98]]).
node(node00003,function,[],[complete=true,min_val=0,name=fn1,units=1,value=75000],[]).
node(node00004,cloud,[],[complete=true,name=cd1],[centre=[-68,102]]).
node(node00005,function,[],[complete=true,name=fn2,units=1,value=(if frequency_of_burning*burning_internsity>0 and element([proportion_of_grass_by__digging_uprooting__or_cutting],3)>0 then grass_growth*'Broom_Grass__in_Machije_Vlei'+germination else 0)],[]).
node(node00006,cloud,[],[complete=true,name=cd2],[centre=[421,98]]).
node(node00007,function,[],[complete=true,name=fn3,units=1,value=(if'Broom_Grass__in_Machije_Vlei'==0 then 0 elseif harvest then (element([proportion_of_grass_by__digging_uprooting__or_cutting],1)+element([proportion_of_grass_by__digging_uprooting__or_cutting],2))* 0.008 *number_of_harvesters*quantity_harvested_per_person+element([proportion_of_grass_by__digging_uprooting__or_cutting],3)* 0.012 *number_of_harvesters*quantity_harvested_per_person else 0)],[]).
node(node00008,cloud,[],[complete=true,name=cd3],[centre=[179,-47]]).
node(node00009,function,[],[complete=true,name=fn4,units=1,value=(if burning_internsity==2 then 'Broom_Grass__in_Machije_Vlei' else agriculture+decomposition+element([proportion_of_grass_by__digging_uprooting__or_cutting],1)*total_harvesting/300)],[]).
node(node00010,variable,[],[complete=true,name=seeds],[caption_offset=[-31,-8],centre=[-56,-12]]).
node(node00011,function,[],[complete=true,name=fn5,units=int,value=(if element([time_of_harvesting],1)==6 and burning_internsity==1 and season==6 then produce else 0)],[]).
node(node00012,variable,[],[complete=true,name='time of harvesting'],[caption_offset=[-71,-5],centre=[-112,-70]]).
node(node00013,function,[],[complete=true,name=fn6,units=array(int,5),value=(if rules_enforcement> 0.5 then [set_harvesting_season] elseif number_of_people_not_farming>0 then [set_harvesting_season]-3 else [set_harvesting_season])],[]).
node(node00014,variable,[],[complete=true,name=rainfall],[caption_offset=[32,-19],centre=[5,-100]]).
node(node00015,function,[],[complete=true,name=fn7,units=int,value=element([rainfall_this_month],season)],[]).
node(node00016,variable,[],[comment='Price in dollars to transport a bundle of brooms',complete=true,name=transport_cost],[caption_offset=[0,0],centre=[532,282]]).
node(node00017,function,[],[complete=false,name=fn8],[]).
node(node00018,variable,[],[comment='1 = low internsity burning\n2 = high internsity burning',complete=true,name='burning internsity'],[caption_offset=[0,0],centre=[-75,277]]).
node(node00019,function,[],[complete=true,name=fn9,units=int,value=(if season>=6 and season<=10 and frequency_of_burning>0 then 2 else 1)],[]).
node(node00020,variable,[],[complete=true,name=season],[caption_offset=[0,0],centre=[38,233]]).
node(node00021,function,[],[complete=true,name=fn10,units=1,value=fmod(time(1),12)+1],[]).
node(node00022,variable,[],[complete=true,name=comfort],[caption_offset=[0,0],centre=[248,259]]).
node(node00023,function,[],[complete=true,name=fn11,units=int,value=length],[]).
node(node00024,variable,[],[comment='1 for tube\n0 for fibre',complete=true,name='bundling with tube or fibre'],[caption_offset=[28,1],centre=[312,316]]).
node(node00025,function,[],[complete=true,name=fn12,units=int,value=1],[]).
node(node00026,variable,[],[complete=true,name=processing],[caption_offset=[0,0],centre=[431,358]]).
node(node00027,function,[],[complete=true,name=fn13,units=int,value=1],[]).
node(node00028,variable,[],[complete=true,name=beauty],[caption_offset=[35,-20],centre=[371,304]]).
node(node00029,function,[],[complete=true,name=fn14,units=int,value=processing+bundling_with_tube_or_fibre],[]).
node(node00030,variable,[],[complete=true,name='quality of broom'],[caption_offset=[-15,-32],centre=[343,235]]).
node(node00031,function,[],[complete=true,name=fn15,units=1,value=beauty*life_of_broom*comfort],[]).
node(node00032,variable,[],[complete=true,name='Number of brooms sold'],[caption_offset=[0,0],centre=[415,165]]).
node(node00033,function,[],[complete=false,name=fn16],[]).
node(node00034,variable,[],[comment='1 = yes there is supply from elsewhere\n0 = there is no availabiility',complete=true,name='supply from other sources'],[caption_offset=[69,1],centre=[517,339]]).
node(node00035,function,[],[complete=true,name=fn17,units=int,value=1],[]).
node(node00036,variable,[],[complete=true,name='market price per broom'],[caption_offset=[0,0],centre=[443,223]]).
node(node00037,function,[],[complete=true,name=fn18,units=1,value=3+last(quality_of_broom)*season/(supply_from_other_sources+1)],[]).
node(node00038,variable,[],[complete=true,name='time of sale'],[caption_offset=[55,-18],centre=[575,187]]).
node(node00039,function,[],[complete=true,name=fn19,units=1,value=market_price_per_broom],[]).
node(node00040,variable,[],[complete=true,name='expected income\nbefore harvesting'],[caption_offset=[71,-18],centre=[570,138]]).
node(node00041,function,[],[complete=true,name=fn20,units=1,value=market_price_per_broom*2000-permit_price-availability_of_transport],[]).
node(node00042,variable,[],[complete=true,name=income],[caption_offset=[38,-15],centre=[477,39]]).
node(node00043,function,[],[complete=true,name=fn21,units=1,value=number_of_brooms_sold*market_price_per_broom-permit_price],[]).
node(node00044,variable,[],[comment='Price of permit in dollars',complete=true,name='permit price'],[caption_offset=[55,-18],centre=[524,-83]]).
node(node00045,function,[],[complete=true,name=fn22,units=int,value=30],[]).
node(node00046,variable,[],[complete=true,name='quantity harvested per person'],[caption_offset=[115,-16],centre=[393,3]]).
node(node00047,function,[],[complete=true,name=fn23,units=int,value=maximum_number_of_broom__harvest_per_day],[]).
node(node00048,variable,[],[complete=true,name='number of harvesters'],[caption_offset=[0,4],centre=[283,-43]]).
node(node00049,function,[],[complete=true,name=fn24,units=int,value=(if alternative_income_sources then 0 elseif permit_price<expected_income_before_harvesting then number_of_permits else number_of_people_not_farming)],[]).
node(node00050,variable,[],[complete=true,name='number of people not farming'],[caption_offset=[115,-20],centre=[381,-130]]).
node(node00051,function,[],[complete=true,name=fn25,units=int,value=10],[]).
node(node00052,variable,[],[comment='Percent of Machije converted to agriculture',complete=true,name=agriculture],[caption_offset=[-2,-32],centre=[89,-121]]).
node(node00053,function,[],[complete=true,name=fn26,units=int,value=2],[]).
node(node00054,variable,[],[comment='Percent of grass decomposing',complete=true,name=decomposition],[caption_offset=[0,0],centre=[103,-15]]).
node(node00055,function,[],[complete=true,name=fn27,units=int,value=5],[]).
node(node00056,variable,[],[complete=true,name='proportion of grass by \ndigging uprooting \nor cutting'],[caption_offset=[11,19],centre=[160,199]]).
node(node00057,function,[],[complete=true,name=fn28,units=array(int,3),value=(if rules_enforcement> 0.5 then [5,10,85] else [80,10,10])],[]).
node(node00058,variable,[],[complete=true,name='whether cut \nor dug or uprooted'],[caption_offset=[-28,-2],centre=[133,282]]).
node(node00059,function,[],[complete=true,name=fn29,units=1,value=element([proportion_of_grass_by__digging_uprooting__or_cutting],3)/100],[]).
node(node00060,variable,[],[complete=true,max_val=100,min_val=50,name=length,param_type=file,units=int,value=1],[caption_offset=[0,0],centre=[307,362]]).
node(node00061,variable,[],[complete=true,name='K'],[caption_offset=[0,0],centre=[-70,155]]).
node(node00062,variable,[],[comment='1 = ripe\n0 = unripe',complete=true,name='ripe or unripe'],[caption_offset=[0,0],centre=[16,304]]).
node(node00063,function,[],[complete=true,name=fn31,units=int,value=(if element([time_of_harvesting],1)==6 then 1 else 0)],[]).
node(node00064,variable,[],[complete=true,name='life of broom'],[caption_offset=[0,0],centre=[199,351]]).
node(node00065,function,[],[complete=true,name=fn32,units=1,value=bundling_with_tube_or_fibre*ripe_or_unripe*length*whether_cut__or_dug_or_uprooted],[]).
node(node00066,function,[],[complete=true,name=fn1_0,units=1,value=availability_of_transport*number_of_brooms_made],[]).
node(node00067,variable,[],[complete=true,name='number of brooms made'],[caption_offset=[0,0],centre=[287,148]]).
node(node00068,function,[],[complete=true,name=fn2_0,units=1,value= 0.99 *total_harvesting],[]).
node(node00069,variable,[],[comment='from the permits book',complete=true,name=no_of_permits],[caption_offset=[62,-19],centre=[445,-111]]).
node(node00070,function,[],[complete=true,name=fn3_0,units=int,value=150],[]).
node(node00071,variable,[],[comment='1 =   there is enforcement\n0 = there is no enforcement',complete=true,max_val=1,min_val=0,name=rules_enforcement,units=1,value= 0.5],[caption_offset=[79,-18],centre=[301,-151]]).
node(node00073,variable,[],[complete=true,name='frequency of burning'],[caption_offset=[-5,-35],centre=[-185,125]]).
node(node00074,function,[],[complete=true,name=fn2_1,units=int,value=(if rules_enforcement> 0.5 then 0 elseif season>=6 and season<10 then burning_events else 0)],[]).
node(node00075,variable,[],[complete=true,name='availability of\ntransport'],[caption_offset=[56,-15],centre=[579,259]]).
node(node00076,function,[],[complete=true,name=fn3_1,units=int,value=(if transport_cost<=10 then 1 else 0)],[]).
node(node00077,function,[],[complete=true,min_val=0,name=fn1_2,units=int,value=2],[]).
node(node00078,function,[],[name=fn4_0],[]).
node(node00079,function,[],[complete=true,name=fn1_8,units=int,value=1000000],[]).
node(node00080,function,[],[complete=false,name=fn5_0],[]).
node(node00081,variable,[],[complete=true,name='expected income \nafter harvesting'],[caption_offset=[71,-15],centre=[523,79]]).
node(node00082,function,[],[complete=true,name=fn6_0,units=1,value=number_of_brooms_made*market_price_per_broom-permit_price-transport_cost],[]).
node(node00083,function,[],[complete=false,name=fn1_3],[]).
node(node00084,variable,[],[complete=true,name='alternative income\nsources'],[caption_offset=[-3,-28],centre=[216,-123]]).
node(node00085,function,[],[complete=true,name=fn2_2,units=boolean,value=(1==0)],[]).
node(node00086,variable,[],[complete=true,name='rainfall this month'],[caption_offset=[-1,-32],centre=[-49,-127]]).
node(node00087,function,[],[complete=true,name=fn1_4,units=array(int,12),value=[193,185,70,32,7,2,0,0,4,28,91,128]],[]).
node(node00088,variable,[],[comment='Months of the year when harvesting is permitted',complete=true,name='set harvesting season'],[caption_offset=[9,-30],centre=[-202,-102]]).
node(node00089,function,[],[complete=true,name=fn1_5,units=array(int,5),value=[6,7,8,9,10]],[]).
node(node00090,variable,[],[complete=true,name=produce],[caption_offset=[0,0],centre=[-189,-9]]).
node(node00091,function,[],[complete=true,name=fn1_6,units=int,value=300],[]).
node(node00092,variable,[],[complete=true,name='burning events'],[caption_offset=[0,0],centre=[-183,222]]).
node(node00093,function,[],[complete=true,name=fn1_7,units=int,value=1],[]).
node(node00094,variable,[],[complete=true,name='grass growth'],[caption_offset=[58,-12],centre=[-21,161]]).
node(node00095,function,[],[complete=false,name=fn2_3],[]).
node(node00097,variable,[],[complete=true,name='soil moisture'],[caption_offset=[0,0],centre=[-18,58]]).
node(node00099,function,[],[complete=true,name=fn3_2,units=int,value=(if rainfall>100 then 1 else 0)],[]).
node(node00101,variable,[],[complete=true,name=germination],[caption_offset=[0,0],centre=[50,14]]).
node(node00102,function,[],[complete=true,name=fn4_1,units=int,value=(if soil_moisture==1 then seeds else 0)],[]).
node(node00103,function,[],[complete=true,name=fn1_9,units=1,value=1-growth_rate*soil_moisture/'K'],[]).
node(node00104,variable,[],[complete=true,name='growth rate'],[caption_offset=[0,0],centre=[33,184]]).
node(node00105,function,[],[complete=true,name=fn2_4,units=int,value=5],[]).
node(node00106,variable,[],[complete=true,name='maximum\nnumber of broom \nharvest per day'],[caption_offset=[70,10],centre=[406,-81]]).
node(node00107,function,[],[complete=false,name=fn1_10],[]).
node(node00108,function,[],[complete=true,name=fn1_11,units=int,value=100],[]).
node(node00109,function,[],[complete=false,name=fn2_5],[]).
node(node00110,function,[],[complete=true,max_val=100,min_val=0,name=fn1_12,units=int,value=1],[]).
node(node00111,variable,[],[complete=true,name=harvest],[caption_offset=[11,-34],centre=[289,41]]).
node(node00112,function,[],[complete=true,name=fn1_13,units=boolean,value=any([time_of_harvesting]==season)],[]).

arc(arc00001,node00003,node00002,influence,[name=i1],[]).
arc(arc00002,node00004,node00002,flow,[complete=true,name=growth],[caption_offset=[0,0],curve=[550,502]]).
arc(arc00003,node00005,arc00002,influence,[name=i2],[]).
arc(arc00068,node00002,node00005,influence,[complete=true,name=i65,role=[use(none,in_hierarchy,'Broom_Grass__in_Machije_Vlei',1)]],[curve=[0,26]]).
arc(arc00004,node00002,node00006,flow,[complete=true,name='total harvesting'],[caption_offset=[34,-1],curve=[550,500]]).
arc(arc00005,node00007,arc00004,influence,[name=i3],[]).
arc(arc00087,node00002,node00007,influence,[complete=true,name=i1_14,role=[use(none,in_hierarchy,'Broom_Grass__in_Machije_Vlei',1)]],[curve=[0,-25]]).
arc(arc00006,node00002,node00008,flow,[complete=true,name=destroyed],[caption_offset=[22,-3],curve=[550,500]]).
arc(arc00007,node00009,arc00006,influence,[name=i4],[]).
arc(arc00077,node00002,node00009,influence,[complete=true,name=i2_10,role=[use(none,in_hierarchy,'Broom_Grass__in_Machije_Vlei',1)]],[curve=[-14,0]]).
arc(arc00101,arc00004,node00009,influence,[complete=true,name=i3_5,role=[use(none,in_hierarchy,total_harvesting,1)]],[curve=[-16,27]]).
arc(arc00008,node00011,node00010,influence,[name=i5],[]).
arc(arc00060,node00012,node00011,influence,[complete=true,name=i57,role=[use(none,in_hierarchy,[time_of_harvesting],array(int,5))]],[curve=[12,-12]]).
arc(arc00009,node00013,node00012,influence,[name=i6],[]).
arc(arc00010,node00015,node00014,influence,[name=i7],[]).
arc(arc00061,node00018,node00011,influence,[complete=true,name=i58,role=[use(none,in_hierarchy,burning_internsity,int)]],[curve=[-189,36]]).
arc(arc00062,node00018,node00005,influence,[complete=true,name=i59,role=[use(none,in_hierarchy,burning_internsity,int)]],[curve=[-30,-10]]).
arc(arc00079,node00018,node00009,influence,[complete=true,name=i76,role=[use(none,in_hierarchy,burning_internsity,int)]],[curve=[-354,-109]]).
arc(arc00012,node00019,node00018,influence,[name=i9],[]).
arc(arc00054,node00020,node00019,influence,[complete=true,name=i51,role=[use(none,in_hierarchy,season,1)]],[curve=[7,10]]).
arc(arc00056,node00020,node00011,influence,[complete=true,name=i53,role=[use(none,in_hierarchy,season,1)]],[curve=[-184,97]]).
arc(arc00057,node00020,node00015,influence,[complete=true,name=i54,role=[use(none,in_hierarchy,season,1)]],[curve=[-167,116]]).
arc(arc00013,node00021,node00020,influence,[name=i10],[]).
arc(arc00014,node00023,node00022,influence,[name=i11],[]).
arc(arc00015,node00025,node00024,influence,[name=i12],[]).
arc(arc00016,node00027,node00026,influence,[name=i13],[]).
arc(arc00017,node00029,node00028,influence,[name=i14],[]).
arc(arc00032,node00026,node00029,influence,[complete=true,name=i29,role=[use(none,in_hierarchy,processing,int)]],[curve=[-13,-8]]).
arc(arc00038,node00024,node00029,influence,[complete=true,name=i35,role=[use(none,in_hierarchy,bundling_with_tube_or_fibre,int)]],[curve=[2,-28]]).
arc(arc00018,node00031,node00030,influence,[name=i15],[]).
arc(arc00031,node00028,node00031,influence,[complete=true,name=i28,role=[use(none,in_hierarchy,beauty,int)]],[curve=[-14,5]]).
arc(arc00046,node00022,node00031,influence,[complete=true,name=i43,role=[use(none,in_hierarchy,comfort,int)]],[curve=[-5,-16]]).
arc(arc00020,node00035,node00034,influence,[name=i17],[]).
arc(arc00021,node00037,node00036,influence,[name=i18],[]).
arc(arc00047,node00030,node00037,influence,[complete=true,name=i44,role=[use(none,in_hierarchy,quality_of_broom,1)]],[curve=[-4,-22]]).
arc(arc00048,node00034,node00037,influence,[complete=true,name=i45,role=[use(none,in_hierarchy,supply_from_other_sources,int)]],[curve=[-19,5]]).
arc(arc00055,node00020,node00037,influence,[complete=true,name=i52,role=[use(none,in_hierarchy,season,1)]],[curve=[5,-97]]).
arc(arc00022,node00039,node00038,influence,[name=i19],[]).
arc(arc00050,node00036,node00039,influence,[complete=true,name=i47,role=[use(none,in_hierarchy,market_price_per_broom,1)]],[curve=[-8,-26]]).
arc(arc00023,node00041,node00040,influence,[name=i20],[]).
arc(arc00051,node00036,node00041,influence,[complete=true,name=i48,role=[use(none,in_hierarchy,market_price_per_broom,1)]],[curve=[-19,-36]]).
arc(arc00024,node00043,node00042,influence,[name=i21],[]).
arc(arc00081,node00032,node00043,influence,[complete=true,name=i2_0,role=[use(none,in_hierarchy,number_of_brooms_sold,1)]],[curve=[-26,-32]]).
arc(arc00082,node00036,node00043,influence,[complete=true,name=i3_0,role=[use(none,in_hierarchy,market_price_per_broom,1)]],[curve=[-43,-24]]).
arc(arc00074,node00044,node00043,influence,[complete=true,name=i71,role=[use(none,in_hierarchy,permit_price,int)]],[curve=[30,-3]]).
arc(arc00075,node00044,node00041,influence,[complete=true,name=i72,role=[use(none,in_hierarchy,permit_price,int)]],[curve=[55,-15]]).
arc(arc00025,node00045,node00044,influence,[name=i22],[]).
arc(arc00073,node00046,node00007,influence,[complete=true,name=i70,role=[use(none,in_hierarchy,quantity_harvested_per_person,int)]],[curve=[26,30]]).
arc(arc00026,node00047,node00046,influence,[name=i23],[]).
arc(arc00070,node00048,node00007,influence,[complete=true,name=i67,role=[use(none,in_hierarchy,number_of_harvesters,int)]],[curve=[32,1]]).
arc(arc00027,node00049,node00048,influence,[name=i24],[]).
arc(arc00078,node00040,node00049,influence,[complete=true,name=i75,role=[use(none,in_hierarchy,expected_income_before_harvesting,1)]],[curve=[-46,67]]).
arc(arc00080,node00044,node00049,influence,[complete=true,name=i77,role=[use(none,in_hierarchy,permit_price,int)]],[curve=[10,49]]).
arc(arc00063,node00050,node00013,influence,[complete=true,name=i60,role=[use(none,in_hierarchy,number_of_people_not_farming,int)]],[curve=[7,112]]).
arc(arc00071,node00050,node00049,influence,[complete=true,name=i68,role=[use(none,in_hierarchy,number_of_people_not_farming,int)]],[curve=[10,10]]).
arc(arc00028,node00051,node00050,influence,[name=i25],[]).
arc(arc00064,node00052,node00009,influence,[complete=true,name=i61,role=[use(none,in_hierarchy,agriculture,int)]],[curve=[22,-16]]).
arc(arc00029,node00053,node00052,influence,[name=i26],[]).
arc(arc00065,node00054,node00009,influence,[complete=true,name=i62,role=[use(none,in_hierarchy,decomposition,int)]],[curve=[8,-18]]).
arc(arc00030,node00055,node00054,influence,[name=i27],[]).
arc(arc00066,node00056,node00009,influence,[complete=true,name=i63,role=[use(none,in_hierarchy,[proportion_of_grass_by__digging_uprooting__or_cutting],array(int,3))]],[curve=[-40,-5]]).
arc(arc00067,node00056,node00005,influence,[complete=true,name=i64,role=[use(none,in_hierarchy,[proportion_of_grass_by__digging_uprooting__or_cutting],array(int,3))]],[curve=[-22,24]]).
arc(arc00076,node00056,node00007,influence,[complete=true,name=i73,role=[use(none,in_hierarchy,[proportion_of_grass_by__digging_uprooting__or_cutting],array(int,3))]],[curve=[-23,-34]]).
arc(arc00033,node00057,node00056,influence,[name=i30],[]).
arc(arc00034,node00059,node00058,influence,[name=i31],[]).
arc(arc00044,node00056,node00059,influence,[complete=true,name=i41,role=[use(none,in_hierarchy,[proportion_of_grass_by__digging_uprooting__or_cutting],array(int,3))]],[curve=[15,-6]]).
arc(arc00045,node00060,node00023,influence,[complete=true,name=i42,role=[use(none,in_hierarchy,length,int)]],[curve=[-14,-30]]).
arc(arc00036,node00063,node00062,influence,[name=i33],[]).
arc(arc00052,node00012,node00063,influence,[complete=true,name=i49,role=[use(none,in_hierarchy,[time_of_harvesting],array(int,5))]],[curve=[-116,71]]).
arc(arc00042,node00064,node00031,influence,[complete=true,name=i39,role=[use(none,in_hierarchy,life_of_broom,1)]],[curve=[-25,-23]]).
arc(arc00037,node00065,node00064,influence,[name=i34],[]).
arc(arc00039,node00024,node00065,influence,[complete=true,name=i36,role=[use(none,in_hierarchy,bundling_with_tube_or_fibre,int)]],[curve=[10,0]]).
arc(arc00040,node00062,node00065,influence,[complete=true,name=i37,role=[use(none,in_hierarchy,ripe_or_unripe,int)]],[curve=[2,-14]]).
arc(arc00041,node00060,node00065,influence,[complete=true,name=i38,role=[use(none,in_hierarchy,length,int)]],[curve=[5,-20]]).
arc(arc00043,node00058,node00065,influence,[complete=true,name=i40,role=[use(none,in_hierarchy,whether_cut__or_dug_or_uprooted,1)]],[curve=[15,-12]]).
arc(arc00019,node00066,node00032,influence,[name=i1_0],[]).
arc(arc00085,node00067,node00066,influence,[complete=true,name=i6_0,role=[use(none,in_hierarchy,number_of_brooms_made,1)]],[curve=[0,-26]]).
arc(arc00083,node00068,node00067,influence,[name=i4_0],[]).
arc(arc00084,arc00004,node00068,influence,[complete=true,name=i5_0,role=[use(none,in_hierarchy,total_harvesting,1)]],[curve=[8,2]]).
arc(arc00109,node00069,node00049,influence,[complete=true,name=i1_4,role=[use(none,in_hierarchy,number_of_permits,int)]],[curve=[14,31]]).
arc(arc00086,node00070,node00069,influence,[name=i7_0],[]).
arc(arc00088,node00071,node00057,influence,[complete=true,name=i1_1,role=[use(none,in_hierarchy,rules_enforcement,1)]],[curve=[76,33]]).
arc(arc00090,node00071,node00013,influence,[complete=true,name=i3_1,role=[use(none,in_hierarchy,rules_enforcement,1)]],[curve=[14,98]]).
arc(arc00093,node00073,node00005,influence,[complete=true,name=i6_1,role=[use(none,in_hierarchy,frequency_of_burning,int)]],[curve=[-29,-38]]).
arc(arc00131,node00073,node00019,influence,[complete=true,name=i5_5,role=[use(none,in_hierarchy,frequency_of_burning,int)]],[curve=[4,-26]]).
arc(arc00091,node00074,node00073,influence,[name=i4_1],[]).
arc(arc00092,node00071,node00074,influence,[complete=true,name=i5_1,role=[use(none,in_hierarchy,rules_enforcement,1)]],[curve=[84,100]]).
arc(arc00095,node00020,node00074,influence,[complete=true,name=i8_1,role=[use(none,in_hierarchy,season,1)]],[curve=[7,34]]).
arc(arc00097,node00075,node00066,influence,[complete=true,name=i10_0,role=[use(none,in_hierarchy,availability_of_transport,int)]],[curve=[-25,38]]).
arc(arc00105,node00075,node00041,influence,[complete=true,name=i7_2,role=[use(none,in_hierarchy,availability_of_transport,int)]],[curve=[-26,-6]]).
arc(arc00096,node00076,node00075,influence,[name=i9_0],[]).
arc(arc00103,node00016,node00076,influence,[complete=true,name=i6_2,role=[use(none,in_hierarchy,transport_cost,int)]],[curve=[-3,-16]]).
arc(arc00099,node00077,node00016,influence,[name=i4_2],[]).
arc(arc00035,node00079,node00061,influence,[name=i1_3],[]).
arc(arc00011,node00067,node00082,influence,[complete=true,name=i1_2,role=[use(none,in_hierarchy,number_of_brooms_made,1)]],[curve=[-16,-64]]).
arc(arc00053,node00036,node00082,influence,[complete=true,name=i2_2,role=[use(none,in_hierarchy,market_price_per_broom,1)]],[curve=[-31,-26]]).
arc(arc00098,node00044,node00082,influence,[complete=true,name=i3_2,role=[use(none,in_hierarchy,permit_price,int)]],[curve=[42,-6]]).
arc(arc00100,node00016,node00082,influence,[complete=true,name=i5_2,role=[use(none,in_hierarchy,transport_cost,int)]],[curve=[-42,-14]]).
arc(arc00102,node00082,node00081,influence,[name=i15_0],[]).
arc(arc00108,node00084,node00049,influence,[complete=true,name=i3_3,role=[use(none,in_hierarchy,alternative_income_sources,boolean)]],[curve=[12,-21]]).
arc(arc00107,node00085,node00084,influence,[name=i2_3],[]).
arc(arc00111,node00086,node00015,influence,[complete=true,name=i2_4,role=[use(none,in_hierarchy,[rainfall_this_month],array(int,12))]],[curve=[15,-6]]).
arc(arc00110,node00087,node00086,influence,[name=i1_5],[]).
arc(arc00113,node00088,node00013,influence,[complete=true,name=i2_5,role=[use(none,in_hierarchy,[set_harvesting_season],array(int,5))]],[curve=[7,-20]]).
arc(arc00112,node00089,node00088,influence,[name=i1_6],[]).
arc(arc00115,node00090,node00011,influence,[complete=true,name=i2_6,role=[use(none,in_hierarchy,produce,int)]],[curve=[0,-24]]).
arc(arc00114,node00091,node00090,influence,[name=i1_7],[]).
arc(arc00117,node00092,node00074,influence,[complete=true,name=i2_7,role=[use(none,in_hierarchy,burning_events,int)]],[curve=[-4,0]]).
arc(arc00116,node00093,node00092,influence,[name=i1_8],[]).
arc(arc00127,node00094,node00005,influence,[complete=true,name=i6_3,role=[use(none,in_hierarchy,grass_growth,1)]],[curve=[-9,-14]]).
arc(arc00106,node00099,node00097,influence,[name=i4_3],[]).
arc(arc00118,node00014,node00099,influence,[complete=true,name=i5_3,role=[use(none,in_hierarchy,rainfall,int)]],[curve=[22,4]]).
arc(arc00072,node00101,node00005,influence,[complete=true,name=i1_12,role=[use(none,in_hierarchy,germination,int)]],[curve=[17,0]]).
arc(arc00120,node00102,node00101,influence,[name=i7_3],[]).
arc(arc00121,node00010,node00102,influence,[complete=true,name=i8_2,role=[use(none,in_hierarchy,seeds,int)]],[curve=[5,-23]]).
arc(arc00126,node00097,node00102,influence,[complete=true,name=i10_2,role=[use(none,in_hierarchy,soil_moisture,int)]],[curve=[-10,-14]]).
arc(arc00058,node00103,node00094,influence,[name=i1_9],[]).
arc(arc00059,node00061,node00103,influence,[complete=true,name=i2_8,role=[use(none,in_hierarchy,'K',int)]],[curve=[4,-9]]).
arc(arc00069,node00097,node00103,influence,[complete=true,name=i3_4,role=[use(none,in_hierarchy,soil_moisture,int)]],[curve=[16,0]]).
arc(arc00119,node00104,node00103,influence,[complete=true,name=i5_4,role=[use(none,in_hierarchy,growth_rate,int)]],[curve=[-4,8]]).
arc(arc00089,node00105,node00104,influence,[name=i4_4],[]).
arc(arc00129,node00106,node00047,influence,[complete=true,name=i2_9,role=[use(none,in_hierarchy,maximum_number_of_broom__harvest_per_day,int)]],[curve=[14,-9]]).
arc(arc00104,node00108,node00106,influence,[name=i1_11],[]).
arc(arc00049,node00110,node00060,influence,[name=i1_10],[]).
arc(arc00130,node00111,node00007,influence,[complete=true,name=i4_5,role=[use(none,in_hierarchy,harvest,boolean)]],[curve=[13,-8]]).
arc(arc00094,node00112,node00111,influence,[name=i1_13],[]).
arc(arc00122,node00012,node00112,influence,[complete=true,name=i2_1,role=[use(none,in_hierarchy,[time_of_harvesting],array(int,5))]],[curve=[48,-80]]).
arc(arc00128,node00020,node00112,influence,[complete=true,name=i3_6,role=[use(none,in_hierarchy,season,1)]],[curve=[-44,-52]]).

