source(program='AME',version= 8.5,edition=standard,date='Tue Jun 19 16:08:20 GMT 2007').

roots([node00077,node00121,node00122,node00173,node00175,node00176,node00186,node00206,node00211,node00234,node00367,node00727,node00757,node00763,node00764,node00765,node00816,node00817,node00829,node00830,node00831,node00832,node00845,node00846,node00957,node00959,node01114,node01117,node01118,node01124,node01179,node01199,node01200,node01201,node01202,node01203,node01204,node01220,node01221,node01235,node01237,node01240,node01275,node01276,node01345,node01347,node01359,node01361,node01362]).

properties([complete-true,name-'Molusc_june06']).

node(node00077,submodel,[node00082,node00128,node00184,node00222,node00438,node00439,node00446,node00447,node00449,node00450,node00502,node00628,node00651,node00658,node00661,node00662,node00663,node00664,node00665,node00666,node00670,node00697,node00975,node01242],[complete=true,enum_types=[],fill_colour='#bbaffe',image_posn=none,multiplication_spec=[count=[31]],name='Country',separate=0],[bounding_box=[ -399.71652, 2671.7957, 303.66648, 3405.7605],caption_offset=[ 65.386877, -3.7472076],hide_contents=0,internal_extent=[ -4.2602547, -8.890977299999999, 699.12275, 725.07391]]).
links(node00077,[arc00148-arc00147,arc00149-arc00143,arc00547-arc00546,arc00627-arc00555,arc00741-arc00740,arc00750-arc00749,arc00787-arc00790,arc00973-arc00972,arc01140-arc01143,arc01381-arc01379]).
node(node00082,variable,[],[comment='Identifier of the country',complete=true,name='CountryID',param_type=file,units=1],[bounding_box=[ 195.82234, 92.13642299999999, 210.82234, 107.13642],caption_offset=[ -48.506168, -19.061718]]).
node(node00128,submodel,[node00130,node00133,node00134,node00203,node00401,node00420,node00440,node00441,node00497,node00498,node00501,node00627,node00646,node00647,node00650,node00657,node00660,node00667,node00692,node00974,node01211,node01212,node01231,node01587],[complete=true,enum_types=[],fill_colour='#91c8ff',image_posn=none,multiplication_spec=[count=[]],name='Cond',separate=0],[bounding_box=[ 344.68476, 41.91913, 637.18616, 372.87143],caption_offset=[ 31.971956, 18.071105],hide_contents=0,internal_extent=[0,0, 296.08811, 335.01049]]).
links(node00128,[arc00141-arc00099,arc00147-arc00146,arc00469-arc00470,arc00469-arc00762,arc00546-arc00545,arc00555-arc00539,arc00740-arc00739,arc00749-arc00748,arc00753-arc00754,arc00972-arc00971,arc00976-arc01209,arc01054-arc01057,arc01379-arc01378]).
references(node00128,[local(arc00143)]).
node(node00130,condition,[],[complete=true,name=cond],[bounding_box=[ 207.4136, 43.38357, 237.4136, 73.38357000000001],caption_offset=[0,0]]).
node(node00133,function,[],[comment='If the cell belongs to the country, cond = true\nIf the cell does not belong to the country, cond = false',complete=true,name=fn2,spec='countryID_link==CountryID',units=cond_spec,value=(countryID_link=='CountryID')],[]).
node(node00134,variable,[],[name=var2],[]).
node(node00203,variable,[],[name=var25],[]).
node(node00401,variable,[],[complete=true,name='forest\nini abs'],[bounding_box=[ 183.25588, 167.1775, 198.25588, 182.1775],caption_offset=[0,0]]).
node(node00420,function,[],[comment='Surface of forests in 2005 (square meters)',complete=true,name=fn3,spec=forest_ini_abs_link,units=1,value=forest_ini_abs_link],[]).
node(node00440,variable,[],[complete=true,name='remaining\nsurplus +'],[bounding_box=[ 36.15302, 119.15729, 51.15302, 134.15729],caption_offset=[ 3.9718606, -46.583163]]).
node(node00441,function,[],[comment='Remaining surplus from agriculture at the time of simulation after that biofuels have been allocated (square meters)',complete=true,name=fn1,spec='if remaining_surplus_4_link>0 then remaining_surplus_4_link\nelse 0',units=1,value=(if remaining_surplus_4_link>0 then remaining_surplus_4_link else 0)],[]).
node(node00497,variable,[],[complete=true,name='space\nremaining'],[bounding_box=[ 228.35858, 277.58128, 243.35858, 292.58128],caption_offset=[ -41.708224, -25.42199]]).
node(node00498,function,[],[comment='Surface available for further forest development (square meters)',complete=true,name=fn11,spec=space_remaining_link,units=1,value=space_remaining_link],[]).
node(node00501,variable,[],[name=var81],[]).
node(node00627,variable,[],[name=var57],[]).
node(node00646,variable,[],[complete=true,name='tot forest'],[bounding_box=[ 132.70923, 218.92974, 147.70923, 233.92974],caption_offset=[0,0]]).
node(node00647,function,[],[comment='Total forest area corrected for the future removing of forest due to area congestion (square meters)',complete=true,name=fn15,spec='tot_forest_abs_link-removed_forest',units=1,value=tot_forest_abs_link-removed_forest],[]).
node(node00650,variable,[],[name=var76],[]).
node(node00657,variable,[],[name=var83],[]).
node(node00660,variable,[],[name=var86],[]).
node(node00667,variable,[],[name=var90],[]).
node(node00692,variable,[],[name=var111],[]).
node(node00974,variable,[],[name=var4],[]).
node(node01211,variable,[],[complete=true,name='removed forest'],[bounding_box=[ 133.77425, 83.76746, 148.77425, 98.767456],caption_offset=[0,0]]).
node(node01212,function,[],[comment='Forest removed at the time step due to area congestion in the cells (square meters)',complete=true,name=fn5,spec='forest_to_remove_link+forest_decline_outside_surplus_link',units=1,value=forest_to_remove_link+forest_decline_outside_surplus_link],[]).
node(node01231,variable,[],[name=var56],[]).
node(node01587,variable,[],[name=var6],[]).
node(node00184,submodel,[],[name=submodel2],[]).
node(node00222,variable,[],[name=var26],[]).
node(node00438,variable,[],[complete=true,name='forest\nexpected\nt+1'],[bounding_box=[ 195.82234, 206.62848, 210.82234, 221.62848],caption_offset=[ -39.015187, -31.248079]]).
node(node00439,function,[],[comment='Forest area at the time of simulation + 1 timestep (square meters)',complete=true,name=fn5,spec='if time() <= 20 then \n(if (CountryID == 2) or (CountryID == 10) or (CountryID == 22) or (CountryID == 26) or (CountryID == 3) or (CountryID == 18) or (CountryID == 23) or (CountryID == 13) or (CountryID == 16) or (CountryID == 25) or (CountryID == 8) then sum({forest_ini_abs})+(sum({forest_ini_abs})*0.0005*(time()+1))\nelseif (CountryID == 12) or (CountryID == 6)  then sum({forest_ini_abs})+(sum({forest_ini_abs})*0.00025*(time()+1))\nelseif (CountryID == 7) or (CountryID == 15) or (CountryID == 4) or (CountryID == 30) then sum({forest_ini_abs})+(sum({forest_ini_abs})*0.001*(time()+1))\nelseif (CountryID == 14) or (CountryID == 5) then sum({forest_ini_abs})+(sum({forest_ini_abs})*0.0005*(time()+1))\nelseif (CountryID == 8) or (CountryID == 17) or (CountryID == 24) or (CountryID == 28) then sum({forest_ini_abs})+(sum({forest_ini_abs})*0.0003*(time()+1))\nelseif (CountryID == 17) or (CountryID == 27) then sum({forest_ini_abs})+(sum({forest_ini_abs})*0.0001*(time()+1))\nelse sum({forest_ini_abs}))\n\nelse \n(if (CountryID == 2) or (CountryID == 10) or (CountryID == 22) or (CountryID == 26) then sum({forest_ini_abs})+(sum({forest_ini_abs})*0.0003*(time()+1))\nelseif (CountryID == 12) or (CountryID == 6)  or (CountryID == 13) or (CountryID == 16) or (CountryID == 25) or (CountryID == 8) then sum({forest_ini_abs})+(sum({forest_ini_abs})*-0.007*(time()+1))\nelseif (CountryID == 7) or (CountryID == 15) or (CountryID == 4) or (CountryID == 30) or (CountryID == 3) or (CountryID == 23) or (CountryID == 18) then sum({forest_ini_abs})+(sum({forest_ini_abs})*-0.0003*(time()+1))\nelseif (CountryID == 14) or (CountryID == 5) then sum({forest_ini_abs})+(sum({forest_ini_abs})*0.0003*(time()+1))\nelseif (CountryID == 8) or (CountryID == 17) or (CountryID == 24) or (CountryID == 28) then sum({forest_ini_abs})+(sum({forest_ini_abs})*0.0003*(time()+1))\nelseif (CountryID == 17) or (CountryID == 27) then sum({forest_ini_abs})+(sum({forest_ini_abs})*0.0003*(time()+1))\nelse sum({forest_ini_abs}))',units=1,value=(if time('')<=20 then(if 'CountryID'==2 or 'CountryID'==10 or 'CountryID'==22 or 'CountryID'==26 or 'CountryID'==3 or 'CountryID'==18 or 'CountryID'==23 or 'CountryID'==13 or 'CountryID'==16 or 'CountryID'==25 or 'CountryID'==8 then sum({forest_ini_abs})+sum({forest_ini_abs})* 0.0005*(time('')+1)elseif 'CountryID'==12 or 'CountryID'==6 then sum({forest_ini_abs})+sum({forest_ini_abs})* 0.00025*(time('')+1)elseif 'CountryID'==7 or 'CountryID'==15 or 'CountryID'==4 or 'CountryID'==30 then sum({forest_ini_abs})+sum({forest_ini_abs})* 0.001*(time('')+1)elseif 'CountryID'==14 or 'CountryID'==5 then sum({forest_ini_abs})+sum({forest_ini_abs})* 0.0005*(time('')+1)elseif 'CountryID'==8 or 'CountryID'==17 or 'CountryID'==24 or 'CountryID'==28 then sum({forest_ini_abs})+sum({forest_ini_abs})* 0.0003*(time('')+1)elseif 'CountryID'==17 or 'CountryID'==27 then sum({forest_ini_abs})+sum({forest_ini_abs})* 0.0001*(time('')+1)else sum({forest_ini_abs}))else(if 'CountryID'==2 or 'CountryID'==10 or 'CountryID'==22 or 'CountryID'==26 then sum({forest_ini_abs})+sum({forest_ini_abs})* 0.0003*(time('')+1)elseif 'CountryID'==12 or 'CountryID'==6 or 'CountryID'==13 or 'CountryID'==16 or 'CountryID'==25 or 'CountryID'==8 then sum({forest_ini_abs})+sum({forest_ini_abs})* -0.007*(time('')+1)elseif 'CountryID'==7 or 'CountryID'==15 or 'CountryID'==4 or 'CountryID'==30 or 'CountryID'==3 or 'CountryID'==23 or 'CountryID'==18 then sum({forest_ini_abs})+sum({forest_ini_abs})* -0.0003*(time('')+1)elseif 'CountryID'==14 or 'CountryID'==5 then sum({forest_ini_abs})+sum({forest_ini_abs})* 0.0003*(time('')+1)elseif 'CountryID'==8 or 'CountryID'==17 or 'CountryID'==24 or 'CountryID'==28 then sum({forest_ini_abs})+sum({forest_ini_abs})* 0.0003*(time('')+1)elseif 'CountryID'==17 or 'CountryID'==27 then sum({forest_ini_abs})+sum({forest_ini_abs})* 0.0003*(time('')+1)else sum({forest_ini_abs})))],[]).
node(node00446,variable,[],[complete=true,name='forest change\nin surplus'],[bounding_box=[ 311.95654, 427.5012, 326.95654, 442.5012],caption_offset=[ -52.412676, -19.832831]]).
node(node00447,function,[],[comment='Forest area change at the current timestep in the surplus from agriculture (square meters)',complete=true,name=fn2,units=1,value=(if forest_change>sum({remaining_surplus__})then sum({remaining_surplus__})else forest_change)],[]).
node(node00449,variable,[],[complete=true,name='forest change'],[bounding_box=[ 196.80917, 259.62761, 211.80917, 274.62761],caption_offset=[ -56.553774, -16.902864]]).
node(node00450,function,[],[comment='Forest area change at the current timestep (square meters)',complete=true,name=fn3,spec='forest_expected_t_1-sum({tot_forest})',units=1,value=forest_expected_t_1-sum({tot_forest})],[]).
node(node00502,variable,[],[name=var82],[]).
node(node00628,variable,[],[name=var58],[]).
node(node00651,variable,[],[name=var77],[]).
node(node00658,variable,[],[name=var84],[]).
node(node00661,variable,[],[complete=true,name='forest change\noutside surplus'],[bounding_box=[ 196.70746, 600.39105, 211.70746, 615.39105],caption_offset=[ -62.116461, -22.085853]]).
node(node00662,function,[],[comment='Forest area change at the current timestep outside the surplus from agriculture (square meters)',complete=true,name=fn17,spec='forest_change-forest_change_in_surplus',units=1,value=forest_change-forest_change_in_surplus],[]).
node(node00663,variable,[],[complete=true,name='forest change rate\nin surplus'],[bounding_box=[ 452.37345, 523.55154, 467.37345, 538.55154],caption_offset=[0,0]]).
node(node00664,function,[],[comment='Increase/decrease of forest density in the surplus from agriculture at the current timestep (no dimention)',complete=true,name=fn18,units=1,value=(if sum({remaining_surplus__})==0 then 0 else forest_change_in_surplus/sum({remaining_surplus__}))],[]).
node(node00665,variable,[],[complete=true,name='forest change rate\noutside surplus'],[bounding_box=[ 568.33125, 600.39105, 583.33125, 615.39105],caption_offset=[0,0]]).
node(node00666,function,[],[comment='Increase/decrease of forest density outside the surplus from agriculture at the current timestep (no dimention)',complete=true,name=fn19,spec='if sum({space_remaining})==0 then 0\nelseif sum({space_remaining})<forest_change_outside_surplus then 1\nelse forest_change_outside_surplus/sum({space_remaining})',units=1,value=(if sum({space_remaining})==0 then 0 elseif sum({space_remaining})<forest_change_outside_surplus then 1 else forest_change_outside_surplus/sum({space_remaining}))],[]).
node(node00670,variable,[],[name=var92],[]).
node(node00697,variable,[],[name=var115],[]).
node(node00975,variable,[],[name=var5],[]).
node(node01242,variable,[],[name=var57],[]).
node(node00121,variable,[],[complete=true,name='rent_min\nfoodcrops'],[bounding_box=[ 482.34195, 293.33139, 497.34195, 308.33139],caption_offset=[ 0.15864296, 0.43822744]]).
node(node00122,function,[],[comment='Smallest rent value for croplands',complete=true,name=fn7,units=1,value=(if time('')<=5 then least([rent_crop_2000_2030])elseif time('')<=25 then least([rent_crop_2031_2060])else least([rent_crop_2060_2080]))],[]).
node(node00173,variable,[],[complete=true,name='rent_min\npcrops'],[bounding_box=[ 500.05227, 1360.0442, 515.05227, 1375.0442],caption_offset=[0,0]]).
node(node00175,variable,[],[complete=true,name='rent_min\ngrasslands'],[bounding_box=[ 485.34431, 824.23843, 500.34431, 839.23843],caption_offset=[0,0]]).
node(node00176,function,[],[comment='Smallest rent value for grasslands',complete=true,name=fn8,units=1,value=(if time('')<=5 then least([rent_grass])elseif time('')<=25 then least([rent_grass_2031_2060])else least([rent_grass_2061_2080]))],[]).
node(node00186,function,[],[comment='Smallest rent value for permanent crops',complete=true,name=fn1,units=1,value=(if time('')<=5 then least([rent_pcrops_2000_2030])elseif time('')<=25 then least([rent_pcrops_2031_2060])else least([rent_pcrops_2061_2080]))],[]).
node(node00206,variable,[],[comment='Smallest croplands rent value to be considered profitable enough to avoid a decrease in croplands\nOnly relevant in the GRAS scenario',complete=true,max_val=2,min_val=0,name='FC_rent_thr',spec='0.5',units=1,value= 0.5],[bounding_box=[ 506.06901, 116.10362, 521.06901, 131.10362],caption_offset=[ 1.4624693, -31.706547]]).
node(node00211,variable,[],[comment='Smallest grasslands rent value to be considered profitable enough to avoid a decrease in grasslands\nOnly relevant in the GRAS scenario',complete=true,max_val=2,min_val=0,name='GFC_rent_thr',spec='0.5',units=1,value= 0.5],[bounding_box=[ 496.57174, 645.14184, 511.57174, 660.14184],caption_offset=[ 2.7801701, -34.583229]]).
node(node00234,variable,[],[comment='Smallest permanent crops rent value to be considered profitable enough to avoid a decrease in permanent crops\nOnly relevant in the GRAS scenario',complete=true,max_val=2,min_val=0,name='PC_rent_thr',spec='0.5',units=1,value= 0.5],[bounding_box=[ 503.407, 1149.4668, 518.407, 1164.4668],caption_offset=[ 1.390085, -37.411655]]).
node(node00367,variable,[],[comment='1 = GRAS\n2 = BAMBU\n3 = SEDG',complete=true,max_val=3,min_val=1,name=scenario,param_type=file,units=int],[bounding_box=[ 204.10982, -1034.8757, 219.10982, -1019.8757],caption_offset=[ 1.390085, 0.0]]).
node(node00727,variable,[],[comment='probability of a suitable cell to have an evolution of urban landuse',complete=true,max_val=1,min_val=0,name=rand_par,param_type=file,units=1],[bounding_box=[ 491.50257, -816.16515, 511.00257, -796.66515],caption_offset=[ -6.9504251, 0.90548781]]).
node(node00757,variable,[],[comment='suitability of cells that are in the neighbourhood of large cities for urban development\n1 = suitable\n0 = not suitable',complete=true,max_val=1,min_val=0,name=pds_large,param_type=file,units=int],[bounding_box=[ 1175.8387, -1039.438, 1195.3387, -1019.938],caption_offset=[0,0]]).
node(node00763,variable,[],[comment='suitability of cells that are in the neighbourhood of medium cities for urban development\n1 = suitable\n0 = not suitable',complete=true,max_val=1,min_val=0,name=pds_med,param_type=file,units=int],[bounding_box=[ 1246.5792, -1042.7086, 1266.0792, -1023.2086],caption_offset=[0,0]]).
node(node00764,variable,[],[comment='suitability of cells that are in the neighbourhood of small cities for urban development\n1 = suitable\n0 = not suitable',complete=true,max_val=1,min_val=0,name=pds_small,param_type=file,units=int],[bounding_box=[ 1323.6492, -1039.3421, 1343.1492, -1019.8421],caption_offset=[0,0]]).
node(node00765,variable,[],[comment='suitability of rural cells for urban development\n1 = suitable\n0 = not suitable',complete=true,max_val=1,min_val=0,name=pds_rural,param_type=file,units=int],[bounding_box=[ 1402.2687, -1038.602, 1421.7687, -1019.102],caption_offset=[0,0]]).
node(node00816,variable,[],[comment='Maximum proportion of the nuts which can evolve to urban land use in 1 year',complete=true,max_val= 0.1,min_val=0,name='K',spec='0.01',units=1,value= 0.01],[bounding_box=[ -423.08371, -442.38418, -403.58371, -422.88418],caption_offset=[0,0]]).
node(node00817,submodel,[node00298,node00315,node00818,node00841,node00847,node00853,node00857,node00862,node00979,node00983,node01020,node01025,node01048,node01049,node01224,node01227,node01230,node01234,node01282,node01287,node01312,node01316,node01318,node01326,node01346,node01350,node01367,node01380,node01385,node01397,node01420,node01422,node01430,node01441,node01445,node01460,node01465,node01473,node01482,node01486,node01499],[complete=true,enum_types=[],fill_colour='#5badff',image_posn=none,multiplication_spec=[count=[304]],name='Nuts',separate=0],[bounding_box=[ -1403.0586, -864.96791, -532.85203, 1502.2277],caption_offset=[ 100.80996, -1.390085],hide_contents=0,internal_extent=[ -111.22016, -13.171567, 758.98642, 2354.0241]]).
links(node00817,[arc00844-arc00843,arc00981-arc00986,arc01023-arc01030,arc01049-arc01043,arc01086-arc01219,arc01096-arc01088,arc01106-arc01104,arc01115-arc01122,arc01130-arc01129,arc01231-arc01234,arc01360-arc01359,arc01364-arc01363,arc01387-arc01386,arc01391-arc01390,arc01402-arc01119,arc01402-arc01401,arc01407-arc01406,arc01407-arc01547,arc01407-arc01551,arc01462-arc01491,arc01470-arc01469,arc01476-arc01474,arc01489-arc01488,arc01489-arc01586,arc01489-arc01641,arc01517-arc01520,arc01535-arc00998,arc01535-arc01534,arc01590-arc01589,arc01599-arc01598,arc01613-arc01616,arc01618-arc01621,arc01637-arc01636,arc01649-arc01648,arc01660-arc01663,arc01665-arc01668,arc01678-arc01681]).
node(node00298,submodel,[node00864,node00871,node00891,node00923,node00937,node00949,node00950,node00960,node00978,node00994,node00997,node01138,node01190,node01223,node01226,node01229,node01233,node01236,node01281,node01286,node01289,node01290,node01291,node01296,node01297,node01298,node01305,node01315,node01317,node01325,node01339,node01340,node01349,node01366,node01387,node01498,node01507,node01508,node01510,node01539,node01549,node01588,node01591,node01592,node01595,node01596,node01599,node01600,node01616,node01638],[complete=true,enum_types=[],fill_colour='#ffff80',image_posn=none,multiplication_spec=[count=[]],name='Food crops',separate=0],[bounding_box=[ -79.948294, 684.91921, 720.49635, 1186.9649],caption_offset=[ 49.49746, -1.4142131],hide_contents=0,internal_extent=[ -48.083254, -28.28428, 752.36141, 473.76142]]).
links(node00298,[arc00978-arc00981,arc01359-arc01347,arc01363-arc01362,arc01386-arc01366,arc01390-arc01389,arc01401-arc01399,arc01406-arc01405,arc01461-arc01462,arc01469-arc01468,arc01474-arc01472,arc01488-arc01487,arc01516-arc01517,arc01534-arc01533,arc01674-arc01678,arc01693-arc01692]).
node(node00864,submodel,[node00514,node00885,node00886,node00888,node00927,node00951,node00952,node00953,node00958,node00993,node01078,node01194,node01195,node01222,node01225,node01228,node01232,node01239,node01278,node01279,node01280,node01283,node01284,node01285,node01292,node01293,node01294,node01306,node01307,node01308,node01309,node01333,node01334,node01353,node01354,node01355,node01356,node01357,node01358,node01363,node01364,node01365,node01412,node01589,node01590,node01593,node01594,node01597,node01598,node01601,node01602,node01603,node01604,node01605,node01606,node01617,node01629,node01639,node01640],[complete=true,enum_types=[],fill_colour='#d8d8d8',image_posn=none,multiplication_spec=[count=[4]],name='LPJ_wheat_maize_sunflower_soya',separate=0],[bounding_box=[ 188.09035, 62.225379, 534.57257, 415.77866],caption_offset=[ 101.82335, -4.2426395],hide_contents=0,internal_extent=[ -2.8421709e-14, -2.3816327e-06, 346.48222, 353.55329]]).
links(node00864,[arc00704-arc00529,arc00897-arc01522,arc00938-arc01523,arc00940-arc01524,arc00991-arc00993,arc01347-arc00941,arc01347-arc01245,arc01362-arc00946,arc01362-arc01361,arc01366-arc00987,arc01366-arc01365,arc01389-arc00989,arc01389-arc01388,arc01399-arc01398,arc01405-arc01404,arc01408-arc01525,arc01410-arc01409,arc01450-arc01411,arc01455-arc01454,arc01458-arc01457,arc01533-arc01532,arc01580-arc01581,arc01712-arc01526,arc01723-arc01722,arc01725-arc01724,arc01727-arc01726,arc01729-arc01728,arc01731-arc01730,arc01733-arc01732,arc01735-arc01734,arc01737-arc01736,arc01738-arc01713,arc01740-arc01739,arc01826-arc01833,arc01827-arc01828,arc01829-arc01830,arc01831-arc01832]).
node(node00514,variable,[],[complete=true,name='Weighted\nyield 2000'],[bounding_box=[ 254.12946, 297.97001, 269.12946, 312.97001],caption_offset=[0,0]]).
node(node00885,variable,[],[complete=true,name='Scaling\nfactor'],[bounding_box=[ 98.914213, 196.84315, 113.91421, 211.84315],caption_offset=[ -2.8284257, -46.669036]]).
node(node00886,function,[],[comment='Part of the potential yield that is actually reached in the nuts',complete=true,name=fn2,spec='if index(1)==1 then scaling_factor_wheat\nelseif index(1)==2 then scaling_factor_maize\nelseif index(1)==3 then scaling_factor_sunflower\nelse scaling_factor_soya',units=1,value=(if index(1)==1 then scaling_factor_wheat elseif index(1)==2 then scaling_factor_maize elseif index(1)==3 then scaling_factor_sunflower else scaling_factor_soya)],[]).
node(node00888,function,[],[comment='Actual yield of the crop in 2000 relativized by the relative importance of the crop',complete=true,name=fn8,spec='if index(1) ==1 then weight_wheat*actual_yield_2000\nelseif index(1) == 2 then weight_maize*actual_yield_2000\nelseif index(1) == 3 then weight_sunflower*actual_yield_2000\nelse weight_soy*actual_yield_2000',units=1,value=(if index(1)==1 then weight_wheat*actual_yield_2000 elseif index(1)==2 then weight_maize*actual_yield_2000 elseif index(1)==3 then weight_sunflower*actual_yield_2000 else weight_soy*actual_yield_2000)],[]).
node(node00927,variable,[],[name=var1],[]).
node(node00951,variable,[],[complete=true,name='Predicted\nactual\nyield '],[bounding_box=[ 167.86243, 197.5609, 182.86243, 212.5609],caption_offset=[ -15.556345, 2.8665227e-08]]).
node(node00952,variable,[],[name=var5],[]).
node(node00953,variable,[],[name=var8],[]).
node(node00958,variable,[],[name=var13],[]).
node(node00993,variable,[],[name=var22],[]).
node(node01078,function,[],[comment='Actual yield predicted for the time of simulation + 1 timestep (t/ha)',complete=true,name=fn5,spec='Potential_with_technology*max(Scaling_factor-Management_factor_plus,0)',units=1,value='Potential_with_technology'*max('Scaling_factor'-'Management_factor_plus',0)],[]).
node(node01194,variable,[],[complete=true,name='Weighted\nyield'],[bounding_box=[ 244.22995, 197.56087, 259.22995, 212.56087],caption_offset=[ -1.4142131, 1.4142132]]).
node(node01195,function,[],[comment='Predicted actual yield of the crop relativized by the relative importance of the crop',complete=true,name=fn3,spec='if index(1)==1 then weight_wheat*Predicted_actual_yield elseif index(1)==2 then weight_maize*Predicted_actual_yield elseif index(1)==3 then weight_sunflower*Predicted_actual_yield else weight_soy*Predicted_actual_yield',units=1,value=(if index(1)==1 then weight_wheat*'Predicted_actual_yield' elseif index(1)==2 then weight_maize*'Predicted_actual_yield' elseif index(1)==3 then weight_sunflower*'Predicted_actual_yield' else weight_soy*'Predicted_actual_yield')],[]).
node(node01222,variable,[],[name=var9],[]).
node(node01225,variable,[],[name=var12],[]).
node(node01228,variable,[],[name=var15],[]).
node(node01232,variable,[],[name=var18],[]).
node(node01239,variable,[],[name=var24],[]).
node(node01278,variable,[],[name=var6],[bounding_box=[ 242.81574, 49.068508, 257.81574, 64.06850799999999],caption_offset=[0,0]]).
node(node01279,function,[],[name=fn13],[]).
node(node01280,variable,[],[name=var7],[]).
node(node01283,variable,[],[name=var10],[bounding_box=[ 214.00931, 86.59531, 229.00931, 101.59531],caption_offset=[0,0]]).
node(node01284,function,[],[name=fn14],[]).
node(node01285,variable,[],[name=var11],[]).
node(node01292,variable,[],[name=var14],[]).
node(node01293,variable,[],[name=var16],[]).
node(node01294,variable,[],[name=var17],[]).
node(node01306,variable,[],[complete=true,name='Potential\nwith technology'],[bounding_box=[ 167.86243, 50.482726, 182.86243, 65.482726],caption_offset=[ 7.0710657, -46.669035]]).
node(node01307,function,[],[comment='Potential yield at the time of simulation + 1 timestep, corrected for the evolution of the technology (t/ha)',complete=true,name=fn4,spec='if scenario==1 then (if time() <=10 then POT_LPJ*(1+time()*(element([T],1)))\nelse POT_LPJ*(1+(element([T],1))*10+((element([T],4))*(time()-10))))\nelseif scenario==2 then (if time() <=10 then POT_LPJ*(1+time()*(element([T],2)))\nelse POT_LPJ*(1+(element([T],2))*10+((element([T],5))*(time()-10))))\nelse (if time() <=10 then POT_LPJ*(1+time()*(element([T],3)))\nelse POT_LPJ*(1+(element([T],3))*10+((element([T],6))*(time()-10))))',units=1,value=(if scenario==1 then(if time('')<=10 then 'POT_LPJ'*(1+time('')*element(['T'],1))else 'POT_LPJ'*(1+element(['T'],1)*10+element(['T'],4)*(time('')-10)))elseif scenario==2 then(if time('')<=10 then 'POT_LPJ'*(1+time('')*element(['T'],2))else 'POT_LPJ'*(1+element(['T'],2)*10+element(['T'],5)*(time('')-10)))else(if time('')<=10 then 'POT_LPJ'*(1+time('')*element(['T'],3))else 'POT_LPJ'*(1+element(['T'],3)*10+element(['T'],6)*(time('')-10))))],[]).
node(node01308,variable,[],[complete=true,name='POT_LPJ'],[bounding_box=[ 69.57461499999999, 49.068512, 84.57461499999999, 64.068512],caption_offset=[ 8.485279200000001, -32.526902]]).
node(node01309,function,[],[comment='Potential yield at the time of simulation + 1 timestep (t/ha)',complete=true,name=fn6,spec='if index(1)==1 then(if time()<5 then LPJ_data_wheat elseif time()<30 then LPJ_data_wheat_2011_2030 elseif time()<50 then LPJ_data_wheat_2031_2050 else LPJ_data_wheat_2051_2070)elseif index(1)==2 then(if time()<5 then LPJ_data_maize_2000_2010 elseif time()<30 then LPJ_data_maize_2011_2030 elseif time()<50 then LPJ_data_maize_2031_2050 else LPJ_data_maize_2051_2070)elseif index(1)==3 then(if time()<5 then LPJ_data_sunflower elseif time()<30 then LPJ_data_sunflower_2011_2030 elseif time()<50 then LPJ_data_sunflower_2031_2050 else LPJ_data_sunflower_2051_2070)else(if time()<5 then LPJ_data_soya elseif time()<35 then LPJ_data_soya_2011_2030 elseif time()<50 then LPJ_data_soya_2031_2050 else LPJ_data_soya_2051_2070)',units=1,value=(if index(1)==1 then(if time('')<5 then 'LPJ_data_wheat' elseif time('')<30 then 'LPJ_data_wheat_2011_2030' elseif time('')<50 then 'LPJ_data_wheat_2031_2050' else 'LPJ_data_wheat_2051_2070')elseif index(1)==2 then(if time('')<5 then 'LPJ_data_maize_2000_2010' elseif time('')<30 then 'LPJ_data_maize_2011_2030' elseif time('')<50 then 'LPJ_data_maize_2031_2050' else 'LPJ_data_maize_2051_2070')elseif index(1)==3 then(if time('')<5 then 'LPJ_data_sunflower' elseif time('')<30 then 'LPJ_data_sunflower_2011_2030' elseif time('')<50 then 'LPJ_data_sunflower_2031_2050' else 'LPJ_data_sunflower_2051_2070')else(if time('')<5 then 'LPJ_data_soya' elseif time('')<35 then 'LPJ_data_soya_2011_2030' elseif time('')<50 then 'LPJ_data_soya_2031_2050' else 'LPJ_data_soya_2051_2070'))],[]).
node(node01333,variable,[],[complete=true,name='Management\nfactor'],[bounding_box=[ 269.68575, 118.36507, 284.68575, 133.36507],caption_offset=[0,0]]).
node(node01334,function,[],[comment='Impact of the management on the scale factor',complete=true,name=fn9,spec='if scenario==1 then (if time()<=10 then element([M],1)*time() else element([M],1)*10)\nelseif scenario==2  then (if time()<=10 then element([M],2)*time() else element([M],2)*10)\nelse  (if time()<=10 then element([M],3)*time() else element([M],3)*10)',units=1,value=(if scenario==1 then(if time('')<=10 then element(['M'],1)*time('')else element(['M'],1)*10)elseif scenario==2 then(if time('')<=10 then element(['M'],2)*time('')else element(['M'],2)*10)else(if time('')<=10 then element(['M'],3)*time('')else element(['M'],3)*10))],[]).
node(node01353,variable,[],[complete=true,name='actual yield\n2000'],[bounding_box=[ 95.737534, 299.38423, 110.73753, 314.38423],caption_offset=[ -1.4142143, -43.84061]]).
node(node01354,function,[],[comment='Actual yield in 2000 (t/ha)',complete=true,name=fn12,spec='if index(1)==1 then Actual_yield_wheat_2000\nelseif index(1)==2 then Actual_yield_maize_2000\nelseif index(1)==3 then Actual_yield_sunflower_2000\nelse Actual_yield_soya_2000',units=1,value=(if index(1)==1 then 'Actual_yield_wheat_2000' elseif index(1)==2 then 'Actual_yield_maize_2000' elseif index(1)==3 then 'Actual_yield_sunflower_2000' else 'Actual_yield_soya_2000')],[]).
node(node01355,variable,[],[name=var106],[]).
node(node01356,variable,[],[name=var107],[]).
node(node01357,variable,[],[name=var108],[]).
node(node01358,variable,[],[name=var109],[]).
node(node01363,variable,[],[name=var33],[bounding_box=[ 300.79836, 49.068675, 315.79836, 64.068675],caption_offset=[ 2.8284264, 5.6568528]]).
node(node01364,function,[],[name=fn17],[]).
node(node01365,variable,[],[name=var34],[]).
node(node01412,variable,[],[name=var27],[]).
node(node01589,variable,[],[name=var23],[]).
node(node01590,variable,[],[name=var25],[]).
node(node01593,variable,[],[name=var26],[]).
node(node01594,variable,[],[name=var28],[]).
node(node01597,variable,[],[name=var29],[]).
node(node01598,variable,[],[name=var30],[]).
node(node01601,variable,[],[name=var31],[]).
node(node01602,variable,[],[name=var32],[]).
node(node01603,variable,[],[name=var2],[]).
node(node01604,variable,[],[name=var3],[]).
node(node01605,variable,[],[name=var4],[]).
node(node01606,variable,[],[name=var19],[]).
node(node01617,variable,[],[name=var20],[]).
node(node01629,variable,[],[name=var21],[]).
node(node01639,variable,[],[name=var35],[]).
node(node01640,variable,[],[name=var36],[]).
node(node00871,variable,[],[complete=true,name='scaling factor\nwheat',param_type=file,units=1],[bounding_box=[ -4.6715812, 350.29592, 10.328419, 365.29592],caption_offset=[0,0]]).
node(node00891,variable,[],[comment='Potential wheat yields in the nuts, according to LPJ (t/ha)',complete=true,name='LPJ data\nwheat\n2000 2010',param_type=file,units=1],[bounding_box=[ 329.97004, -4.1360531, 344.97004, 10.863947],caption_offset=[ 35.355329, -31.112689]]).
node(node00923,variable,[],[comment='Actual wheat yield in the nuts in 2000 (t/ha)',complete=true,name='Actual yield\nwheat 2000',param_type=file,units=1],[bounding_box=[ 136.74973, 439.39135, 151.74973, 454.39135],caption_offset=[ -48.083248, -19.798984]]).
node(node00937,variable,[],[complete=true,name='scaling factor\nmaize',param_type=file,units=1],[bounding_box=[ 94.323342, 348.88171, 109.32334, 363.88171],caption_offset=[0,0]]).
node(node00949,variable,[],[complete=true,name='Weighted\nactual\nyield'],[bounding_box=[ 689.70755, 126.85021, 704.70755, 141.85021],caption_offset=[ -2.8284263, -62.225379]]).
node(node00950,function,[],[comment='Predicted cropland actual yield weighted by the area occupied by croplands in the nuts',complete=true,name=fn9,spec='sum([Weighted_yield])*FC_surf_ini',units=1,value=sum(['Weighted_yield'])*'FC_surf_ini'],[]).
node(node00960,variable,[],[comment='Actual sunflower yield in the nuts in 2000 (t/ha)',complete=true,name='Actual yield\nsunflower 2000',param_type=file,units=1],[bounding_box=[ 351.71015, 439.39135, 366.71015, 454.39135],caption_offset=[ -46.669034, -12.727918]]).
node(node00978,variable,[],[name=var34],[]).
node(node00994,variable,[],[complete=true,name='yield 2000\nweighted'],[bounding_box=[ 623.23907, 235.74465, 638.23907, 250.74465],caption_offset=[ -7.0710658, -50.911674]]).
node(node00997,function,[],[comment='Actual yield of croplands in 2000 weighted by the area occupied by croplands in the nuts',complete=true,name=fn10,spec='sum([Weighted_yield_2000])*FC_surf_ini',units=1,value=sum(['Weighted_yield_2000'])*'FC_surf_ini'],[]).
node(node01138,variable,[],[comment='Employment in agriculture (% of the total employment of the nuts)',complete=true,name='employment\nin agriculture',param_type=file,units=1],[bounding_box=[ 577.98425, 25.026891, 592.98425, 40.026891],caption_offset=[0,0]]).
node(node01190,variable,[],[comment='Actual maize yield in the nuts in 2000 (t/ha)',complete=true,name='Actual yield\nmaize 2000',param_type=file,units=1],[bounding_box=[ 237.15888, 445.04821, 252.15888, 460.04821],caption_offset=[ -46.669034, -22.627411]]).
node(node01223,variable,[],[name=var10],[]).
node(node01226,variable,[],[name=var13],[]).
node(node01229,variable,[],[name=var16],[]).
node(node01233,variable,[],[name=var19],[]).
node(node01236,variable,[],[comment='Actual soya yield in the nuts in 2000 (t/ha)',complete=true,name='Actual yield\nsoya 2000',param_type=file,units=1],[bounding_box=[ 401.20761, 446.46241, 416.20761, 461.46241],caption_offset=[ 49.497461, -24.041624]]).
node(node01281,variable,[],[name=var8],[]).
node(node01286,variable,[],[name=var12],[]).
node(node01289,variable,[],[comment='Potential maize yields in the nuts, according to LPJ (t/ha)',complete=true,name='LPJ data maize\n2000 2010',param_type=file,units=1],[bounding_box=[ 56.75837, 23.926382, 71.75836, 38.926382],caption_offset=[ -59.396953, -31.11269]]).
node(node01290,variable,[],[comment='Potential sunflower yields in the nuts, according to LPJ (t/ha)',complete=true,name='LPJ data sunflower\n2000 2010',param_type=file,units=1],[bounding_box=[ 78.767, 122.6076, 93.767, 137.6076],caption_offset=[ -70.710658, -24.041624]]).
node(node01291,variable,[],[comment='Potential soya yields in the nuts, according to LPJ (t/ha)',complete=true,name='LPJ data soya\n2000 2010',param_type=file,units=1],[bounding_box=[ 83.71675, 230.79491, 98.71675, 245.79491],caption_offset=[ -55.154314, -28.284263]]).
node(node01296,variable,[],[complete=true,name='scaling factor\nsoya',param_type=file,units=1],[bounding_box=[ 37.754814, 384.23704, 52.754814, 399.23704],caption_offset=[0,0]]).
node(node01297,variable,[],[comment='Potential wheat yields in the nuts, according to LPJ (t/ha)',complete=true,name='LPJ data wheat\n2051 2070 ',param_type=file,units=1],[bounding_box=[ 82.993835, -24.492918, 97.993835, -9.492917800000001],caption_offset=[ 1.4142132, -0.7071066]]).
node(node01298,submodel,[node01299,node01300,node01304,node01313,node01314,node01320,node01321,node01324,node01329,node01330,node01341,node01519],[complete=true,enum_types=[],fill_colour='#ffff00',image_posn=none,multiplication_spec=[count=[]],name=cond,separate=0],[bounding_box=[ 572.75633, 274.35734, 729.734, 432.74921],caption_offset=[ 11.313705, 0.0],hide_contents=0,internal_extent=[ -1.1368684e-13, -32.526903, 156.97766, 125.86497]]).
links(node01298,[arc01468-arc01467,arc01487-arc01486,arc01503-arc01504,arc01705-arc01704]).
references(node01298,[local(arc01472)]).
node(node01299,variable,[],[name=var50],[bounding_box=[ 43.411673, -0.42893369, 58.411673, 14.571066],caption_offset=[0,0]]).
node(node01300,function,[],[name=fn3],[]).
node(node01304,variable,[],[name=var64],[]).
node(node01313,condition,[],[complete=true,name=cond],[bounding_box=[ 28.840608, 69.85279, 58.840608, 99.85279],caption_offset=[0,0]]).
node(node01314,function,[],[comment='If the cell belongs to the nuts, cond = true\nIf the cell does not belong to the nuts, cond = false',complete=true,name=fn4,spec='index==IDNUTS_link2',units=cond_spec,value=(index=='IDNUTS_link2')],[]).
node(node01320,variable,[],[name=var69],[bounding_box=[ 76.709191, 49.480677, 141.70919, 114.48068],caption_offset=[ 4.2426395, 2.8284263]]).
node(node01321,function,[],[name=fn6],[]).
node(node01324,variable,[],[name=var79],[]).
node(node01329,variable,[],[complete=true,name='FC surf'],[bounding_box=[ 111.29391, -0.42893419, 126.29391, 14.571066],caption_offset=[0,0]]).
node(node01330,function,[],[comment='Area of foodcrops in 2005 (square meters)',complete=true,name=fn8,spec=food_crops_ini_abs_link2,units=1,value=food_crops_ini_abs_link2],[]).
node(node01341,variable,[],[name=var92],[]).
node(node01519,variable,[],[name=var12],[]).
node(node01305,variable,[],[name=var65],[]).
node(node01315,submodel,[],[name=submodel2],[]).
node(node01317,variable,[],[name=var26],[]).
node(node01325,variable,[],[name=var80],[]).
node(node01339,variable,[],[complete=true,name='FC surf\nini'],[bounding_box=[ 686.8786700000001, 187.66141, 701.8786700000001, 202.66141],caption_offset=[ -26.87005, -31.11269]]).
node(node01340,function,[],[comment='Area of foodcrops in 2005 (square meters)',complete=true,name=fn11,spec='sum({FC_surf})',units=1,value=sum({'FC_surf'})],[]).
node(node01349,variable,[],[name=var101],[]).
node(node01366,variable,[],[name=var35],[]).
node(node01387,variable,[],[complete=true,name='LPJ data maize 2051 2070',param_type=file,units=1],[bounding_box=[ 73.496375, 77.00962800000001, 88.496375, 92.00962800000001],caption_offset=[ -29.698477, 1.4142132]]).
node(node01498,variable,[],[name=var66],[]).
node(node01507,variable,[],[name=var3],[bounding_box=[ 491.01292, 398.41333, 556.01292, 463.41333],caption_offset=[0,0]]).
node(node01508,function,[],[name=fn1],[]).
node(node01510,variable,[],[name=var5],[]).
node(node01539,variable,[],[complete=true,name='scaling factor\nsunflower',param_type=file,units=1],[bounding_box=[ 146.64923, 375.75176, 161.64923, 390.75176],caption_offset=[0,0]]).
node(node01549,variable,[],[comment='Potential wheat yields in the nuts, according to LPJ (t/ha)',complete=true,name='LPJ data\nwheat\n2011 2030',param_type=file,units=1],[bounding_box=[ 292.2005, -10.792906, 307.2005, 4.207095],caption_offset=[ -38.890863, -31.112689]]).
node(node01588,variable,[],[comment='Potential wheat yields in the nuts, according to LPJ (t/ha)',complete=true,name='LPJ data\nwheat\n2031 2050',param_type=file,units=1],[bounding_box=[ 204.39796, -10.792906, 219.39796, 4.2070948],caption_offset=[ -38.183756, -31.112689]]).
node(node01591,variable,[],[comment='Potential maize yields in the nuts, according to LPJ (t/ha)',complete=true,name='LPJ data maize\n2011 2030',param_type=file,units=1],[bounding_box=[ 51.139593, 48.189831, 66.139584, 63.189835],caption_offset=[ -56.568526, -28.284263]]).
node(node01592,variable,[],[comment='Potential maize yields in the nuts, according to LPJ (t/ha)',complete=true,name='LPJ data maize\n2031 2050',param_type=file,units=1],[bounding_box=[ 48.574617, 73.252269, 63.574608, 88.252269],caption_offset=[ -56.568526, -26.87005]]).
node(node01595,variable,[],[comment='Potential sunflower yields in the nuts, according to LPJ (t/ha)',complete=true,name='LPJ data sunflower\n2011 2030',param_type=file,units=1],[bounding_box=[ 77.352783, 150.89186, 92.352783, 165.89186],caption_offset=[ -70.710658, -24.041624]]).
node(node01596,variable,[],[comment='Potential sunflower yields in the nuts, according to LPJ (t/ha)',complete=true,name='LPJ data sunflower\n2031 2050',param_type=file,units=1],[bounding_box=[ 78.767003, 176.34769, 93.767003, 191.34769],caption_offset=[ -70.710658, -24.041624]]).
node(node01599,variable,[],[comment='Potential soya yields in the nuts, according to LPJ (t/ha)',complete=true,name='LPJ data soya\n2011 2030',param_type=file,units=1],[bounding_box=[ 81.59542999999999, 262.61471, 96.59542999999999, 277.61471],caption_offset=[ -55.154314, -28.284263]]).
node(node01600,variable,[],[comment='Potential soya yields in the nuts, according to LPJ (t/ha)',complete=true,name='LPJ data soya\n2031 2050',param_type=file,units=1],[bounding_box=[ 70.28171500000001, 289.48475, 85.28171500000001, 304.48475],caption_offset=[ -57.98274, -28.284263]]).
node(node01616,variable,[],[complete=true,name='LPJ data soya 2051 2070',param_type=file,units=1],[bounding_box=[ 92.90913, 293.02029, 107.90913, 308.02029],caption_offset=[0,0]]).
node(node01638,variable,[],[complete=true,name='LPJ data sunflower 2051 2070',param_type=file,units=1],[bounding_box=[ 103.51573, 180.59034, 118.51573, 195.59034],caption_offset=[ -57.982741, 2.8284264]]).
node(node00315,submodel,[node00345,node00792,node00793,node00794,node00795,node00796,node00797,node00798,node00799,node00800,node00801,node00802,node00803,node00804,node00805,node00813,node00814,node00815,node00834,node00837,node00838,node00840,node00851,node00852,node01509],[complete=true,enum_types=[],fill_colour='#3535ff',image_posn=none,multiplication_spec=[count=[]],name=urban,separate=0],[bounding_box=[ -26.205737, 30.140046, 699.28425, 656.6353],caption_offset=[ 56.56842, -1.4142105],hide_contents=0,internal_extent=[0,0, 725.48999, 626.4952500000001]]).
links(node00315,[arc00843-arc01222,arc01043-arc01224,arc01088-arc01225,arc01104-arc01103,arc01129-arc01227,arc01223-arc01023,arc01228-arc01115,arc01691-arc01693,arc01691-arc01696,arc01691-arc01699]).
node(node00345,variable,[],[],[]).
node(node00792,variable,[],[complete=true,name='Urb_reg'],[bounding_box=[ 524.18278, 416.25123, 589.18278, 481.25123],caption_offset=[ -39.112931, -12.822786]]).
node(node00793,function,[],[comment='Total surface of urban landuse predicted by the regression (square meters)',complete=true,name=fn6,spec='Dens_reg*surface',units=1,value='Dens_reg'*surface],[]).
node(node00794,variable,[],[complete=true,name='Urb_Model'],[bounding_box=[ 507.94144, 255.13696, 572.9414399999999, 320.13696],caption_offset=[ 47.974375, -18.937253]]).
node(node00795,function,[],[comment='Total surface of urban landuse in the nuts at the time of simulation (square meters)',complete=true,name=fn3,spec='sum({Urb_surf})',units=1,value=sum({'Urb_surf'})],[]).
node(node00796,variable,[],[complete=true,name=diff],[bounding_box=[ 570.19911, 332.43309, 635.19911, 397.43309],caption_offset=[ -23.987188, -21.462221]]).
node(node00797,function,[],[comment='Difference between the urban landuse predicted by the regression and the modelled urban landuse (square meters)',complete=true,name=fn4,spec='(Urb_reg-Urb_Model)',units=1,value='Urb_reg'-'Urb_Model'],[]).
node(node00798,variable,[],[complete=true,name=index],[bounding_box=[ 458.48356, 256.99049, 523.48356, 321.99049],caption_offset=[0,0]]).
node(node00799,function,[],[comment='number of the instance of the submodel',complete=true,name=fn12,spec='index(1)',units=int,value=index(1)],[]).
node(node00800,variable,[],[comment='Surface of the nuts (square meters)',complete=true,name=surface,param_type=file,units=1],[bounding_box=[ 524.7685300000001, 515.32846, 589.7685300000001, 580.32846],caption_offset=[0,0]]).
node(node00801,variable,[],[complete=true,name=var_max],[bounding_box=[ 641.67834, 387.93879, 661.17834, 407.43879],caption_offset=[ 34.087056, -3.7874507]]).
node(node00802,function,[],[comment='Maximum surface which can evolve to urban land use in 1 year (square meters)',complete=true,name=fn2,spec='K*surface',units=1*1*1,value='K'*surface],[]).
node(node00803,variable,[],[complete=true,name=diff_pond],[bounding_box=[ 664.40305, 331.12703, 683.90305, 350.62703],caption_offset=[ -3.7874507, -39.136991]]).
node(node00804,function,[],[comment='Quantity of urban landuse that will be added (distributed in the cells of the nuts) during the timestep',complete=true,name=fn8,spec='if diff<var_max then diff\nelse var_max',units=1,value=(if diff<var_max then diff else var_max)],[]).
node(node00805,submodel,[node00768,node00769,node00770,node00771,node00772,node00773,node00776,node00777,node00778,node00806],[complete=true,enum_types=[],fill_colour='#97ddff',image_posn=none,multiplication_spec=[count=[]],name='Urban demand ',separate=0],[bounding_box=[ 45.925613, 32.873546, 412.90806, 583.34721],caption_offset=[ 1.1368684e-13, -6.8212103e-13],hide_contents=0,internal_extent=[ -5.5603401, 13.90085, 361.42211, 564.37452]]).
links(node00805,[arc00838-arc00837]).
node(node00768,function,[],[comment='GDP (standardised data)',complete=true,max_val=1,min_val=0,name='GDP_0_0',spec='if time() <71 then element([GDP_Matrice],(time())+7)\n+((element([GDP_Matrice],(time())+8))-element([GDP_Matrice],(time())+7))*(time()-int(time()))\n\n else (element([GDP_Matrice],81))',units=1,value=(if time('')<71 then element(['GDP_Matrice'],time('')+7)+(element(['GDP_Matrice'],time('')+8)-element(['GDP_Matrice'],time('')+7))*(time('')-int(time('')))else element(['GDP_Matrice'],81))],[]).
node(node00769,variable,[],[comment='Annual GDP data (GINFORS)',complete=true,name='GDP\nMatrice',param_type=file,spec='makearray(1.0,81)',units=array(1,81),value=makearray( 1.0,81)],[bounding_box=[ 104.85974, 99.646856, 124.35974, 119.14686],caption_offset=[ -4.1306106, -73.935757]]).
node(node00770,variable,[],[complete=true,name='Dens_reg'],[bounding_box=[ 243.38516, 275.82868, 308.38516, 340.82868],caption_offset=[ -42.507572, -16.484991]]).
node(node00771,function,[],[comment='Predicted part of urban landuse density in the nuts',complete=true,max_val=1,min_val=0,name=fn1,spec='const+coef_pop*POP_t_1+coef_gdp*GDP_t_1',units=1,value=const+coef_pop*'POP_t_1'+coef_gdp*'GDP_t_1'],[]).
node(node00772,variable,[],[complete=true,name='GDP\nt+1'],[bounding_box=[ 103.78943, 203.21183, 123.28943, 222.71183],caption_offset=[ -26.512156, -18.937254]]).
node(node00773,submodel,[node00781,node00782,node00783,node00786,node00787,node00788,node00789,node00790,node00791],[complete=true,enum_types=[],fill_colour='#00ffff',image_posn=none,multiplication_spec=[count=[]],name='Coefficients',separate=0],[bounding_box=[ 48.52632, 383.26407, 307.33545, 534.7620899999999],caption_offset=[ -21.462221, 0.0],hide_contents=0,internal_extent=[0,0, 258.80913, 151.49803]]).
links(node00773,[arc00812-arc00807,arc00814-arc00808,arc00816-arc00809]).
references(node00773,[obsolete]).
node(node00781,variable,[],[],[]).
node(node00782,variable,[],[],[]).
node(node00783,variable,[],[],[]).
node(node00786,variable,[],[complete=true,name=const],[bounding_box=[ 67.917062, 79.88633400000001, 87.417062, 99.38633400000001],caption_offset=[0,0]]).
node(node00787,function,[],[complete=true,name=fn8,spec='0',units=int,value=0],[]).
node(node00788,variable,[],[complete=true,name=coef_pop],[bounding_box=[ 127.55725, 78.62384900000001, 147.05725, 98.12384900000001],caption_offset=[0,0]]).
node(node00789,function,[],[complete=true,name=fn9,spec='0.92712',units=1,value= 0.9271200000000001],[]).
node(node00790,variable,[],[complete=true,name=coef_gdp],[bounding_box=[ 197.449034797328, 76.90617720367197, 216.949034797328, 96.40618220367197],caption_offset=[0,0]]).
node(node00791,function,[],[complete=true,name=fn10,spec='0.09580',units=1,value= 0.0958],[]).
node(node00776,variable,[],[complete=true,name='POP\nt+1'],[bounding_box=[ 266.58812, 207.14526, 286.08812, 226.64526],caption_offset=[ 23.076811, -16.108828]]).
node(node00777,function,[],[comment='Population density (standardised data)',complete=true,max_val=1,min_val=0,name='POP_0_0',spec='if time() <71 then element([POP_Matrice],(time())+7)\n+((element([POP_Matrice],(time())+8))-element([POP_Matrice],(time())+7))*(time()-int(time()))\n\n else (element([POP_Matrice],51))',units=1,value=(if time('')<71 then element(['POP_Matrice'],time('')+7)+(element(['POP_Matrice'],time('')+8)-element(['POP_Matrice'],time('')+7))*(time('')-int(time('')))else element(['POP_Matrice'],51))],[]).
node(node00778,variable,[],[comment='Annual population density data (GINFORS)',complete=true,name='POP\nMatrice',param_type=file,spec='makearray(1.0,81)',units=array(1,81),value=makearray( 1.0,81)],[bounding_box=[ 266.78715, 102.90714, 286.28715, 122.40714],caption_offset=[ -1.609875, -76.6895]]).
node(node00806,variable,[],[],[]).
node(node00813,submodel,[node00807,node00808,node00809,node00810,node00811,node00812,node00819,node00820,node00821,node00833,node00844,node01036],[complete=true,enum_types=[],fill_colour='#97ddff',image_posn=none,multiplication_spec=[count=[]],name='Cond',separate=0],[bounding_box=[ 433.90159, 35.483456, 628.5135, 239.82595],caption_offset=[ 0.0, 4.5474735e-13],hide_contents=0,internal_extent=[ 0.0, 12.510765, 194.6119, 216.85326]]).
links(node00813,[arc00845-arc00846,arc00847-arc00848,arc00850-arc00849,arc01103-arc00887,arc01224-arc01039,arc01227-arc01127]).
references(node00813,[local(arc01225)]).
node(node00807,condition,[],[complete=true,name=cond],[bounding_box=[ 21.997923, 29.833072, 86.997923, 94.833072],caption_offset=[ 1.5016628e-07, -48.47125]]).
node(node00808,function,[],[comment='If the cell belongs to the nuts, cond = true\nIf the cell does not belong to the nuts, cond = false',complete=true,name=fn1,spec='index==IDNUTS_Link',units=cond_spec,value=(index=='IDNUTS_Link')],[]).
node(node00809,variable,[],[complete=true,name='Urb_surf'],[bounding_box=[ 73.411429, 148.98138, 138.41143, 213.98138],caption_offset=[ 7.9226885, -39.118686]]).
node(node00810,function,[],[comment='Area of urban landuse at the time of simulation (square meters)',complete=true,name=fn2,spec=urb_surface_Link,units=1,value=urb_surface_Link],[]).
node(node00811,variable,[],[complete=true,name=suit],[bounding_box=[ 73.33821500000001, 73.87303199999999, 138.33821, 138.87303],caption_offset=[0,0]]).
node(node00812,function,[],[comment='1 : cells that are suitable for urban landuse and where some growth will be recorded\n0 : other cells',complete=true,name=fn4,spec='Suitability_index_Link',units=1,value='Suitability_index_Link'],[]).
node(node00819,variable,[],[name=var2],[]).
node(node00820,variable,[],[name=var3],[]).
node(node00821,variable,[],[name=var4],[]).
node(node00833,variable,[],[name=var18],[]).
node(node00844,variable,[],[name=var70],[]).
node(node01036,variable,[],[name=var85],[]).
node(node00814,variable,[],[complete=true,name=suittot],[bounding_box=[ 641.74153, 140.38472, 706.74153, 205.38472],caption_offset=[0,0]]).
node(node00815,function,[],[comment='Number of cells of the nuts that are suitable for urban landuse and selected to undergo a growth of their urban landuse',complete=true,name=fn5,spec='sum({suit})',units=1,value=sum({suit})],[]).
node(node00834,variable,[],[name=var19],[]).
node(node00837,variable,[],[],[]).
node(node00838,variable,[],[],[]).
node(node00840,submodel,[],[],[]).
node(node00851,variable,[],[],[]).
node(node00852,variable,[],[],[]).
node(node01509,variable,[],[name=var4],[]).
node(node00818,variable,[],[name=var1],[]).
node(node00841,variable,[],[name=var67],[]).
node(node00847,variable,[],[name=var21],[]).
node(node00853,variable,[],[name=var71],[]).
node(node00857,submodel,[node00866,node00998,node00999,node01012,node01336,node01379,node01410,node01411,node01413,node01419,node01421,node01429,node01433,node01434,node01440,node01444,node01511,node01512,node01513,node01541,node01542],[complete=true,enum_types=[],fill_colour='#80ff80',image_posn=none,multiplication_spec=[count=[]],name='Grasslands and fooder crops',separate=0],[bounding_box=[ -41.764538, 1225.1486, 717.66792, 1720.1232],caption_offset=[ 53.7401, -2.8284263],hide_contents=0,internal_extent=[0,0, 759.43246, 494.9746]]).
links(node00857,[arc01056-arc01086,arc01547-arc01546,arc01586-arc01585,arc01589-arc01588,arc01598-arc01597,arc01612-arc01613,arc01617-arc01618,arc01696-arc01695]).
node(node00866,submodel,[node00892,node00896,node00901,node00902,node01348,node01360,node01368,node01369,node01370,node01371,node01374,node01375,node01376,node01377,node01378,node01386,node01388,node01392,node01393,node01394,node01395,node01436,node01437,node01543,node01544],[complete=true,enum_types=[],fill_colour='#d8d8d8',image_posn=none,multiplication_spec=[count=[]],name='LPJ',separate=0],[bounding_box=[ 83.438576, 59.396959, 452.5482, 458.20507],caption_offset=[ 36.769542, -2.8284263],hide_contents=0,internal_extent=[ -1.4210855e-13, -11.313706, 369.10963, 387.49441]]).
links(node00866,[arc01515-arc01514,arc01515-arc01538,arc01546-arc01545,arc01606-arc01607,arc01609-arc01610,arc01715-arc01714,arc01717-arc01716]).
node(node00892,variable,[],[complete=true,name='Potential\nyield LPJ\n2000'],[bounding_box=[ 48.083205, 123.31439, 63.083201, 138.31438],caption_offset=[ 41.012182, -35.355329]]).
node(node00896,function,[],[comment='Potential yield in 2000 (t/ha)',complete=true,name=fn1,spec='LPJ_data',units=1,value='LPJ_data'],[]).
node(node00901,variable,[],[complete=true,name='Predicted\nactual\nyield'],[bounding_box=[ 178.19073, 209.58134, 193.19073, 224.58134],caption_offset=[ -1.4142308, 1.4142097]]).
node(node00902,function,[],[comment='Actual yield predicted for the time of simulation + 1 timestep (t/ha)',complete=true,name=fn3,spec='Potential_with_technology*max(Scaling_factor-Management_factor_plus,0)',units=1,value='Potential_with_technology'*max('Scaling_factor'-'Management_factor_plus',0)],[]).
node(node01348,variable,[],[complete=true,name='POT LPJ'],[bounding_box=[ 81.595428, 23.612719, 96.595428, 38.612719],caption_offset=[ 2.8284263, -31.11269]]).
node(node01360,function,[],[comment='Potential yield at the time of simulation + 1 timestep (t/ha)',complete=true,name=fn4,spec='if time()<5 then LPJ_data\nelseif time()<25 then LPJ_data_2011_2030\nelse LPJ_data_2031_2050',units=1,value=(if time('')<5 then 'LPJ_data' elseif time('')<25 then 'LPJ_data_2011_2030' else 'LPJ_data_2031_2050')],[]).
node(node01368,variable,[],[name=var3],[]).
node(node01369,variable,[],[name=var4],[]).
node(node01370,variable,[],[complete=true,name='Potential\nwith technology'],[bounding_box=[ 177.76192, 25.026933, 192.76192, 40.026933],caption_offset=[ -1.4142132, -46.669035]]).
node(node01371,function,[],[comment='Potential yield at the time of simulation + 1 timestep, corrected for the evolution of the technology (t/ha)',complete=true,name=fn5,spec='if scenario==1 then(if time()<=10 then POT_LPJ*(1+time()*T_temp_0)else POT_LPJ*(1+T_temp_0*10+T_temp_0*(time()-10)))elseif scenario==2 then(if time()<=10 then POT_LPJ*(1+time()*T_temp_0)else POT_LPJ*(1+T_temp_0*10+T_temp_0*(time()-10)))else(if time()<=10 then POT_LPJ*(1+time()*T_temp_0)else POT_LPJ*(1+T_temp_0*10+T_temp_0*(time()-10)))',units=1,value=(if scenario==1 then(if time('')<=10 then 'POT_LPJ'*(1+time('')*'T_temp_0')else 'POT_LPJ'*(1+'T_temp_0'*10+'T_temp_0'*(time('')-10)))elseif scenario==2 then(if time('')<=10 then 'POT_LPJ'*(1+time('')*'T_temp_0')else 'POT_LPJ'*(1+'T_temp_0'*10+'T_temp_0'*(time('')-10)))else(if time('')<=10 then 'POT_LPJ'*(1+time('')*'T_temp_0')else 'POT_LPJ'*(1+'T_temp_0'*10+'T_temp_0'*(time('')-10))))],[]).
node(node01374,variable,[],[complete=true,name='T_temp'],[bounding_box=[ 280.99948, 25.026933, 295.99948, 40.026933],caption_offset=[0,0]]).
node(node01375,function,[],[complete=true,name=fn7,spec='0.005',units=1,value= 0.005],[]).
node(node01376,variable,[],[name=var8],[bounding_box=[ 215.42356, 80.938491, 230.42356, 95.93849299999999],caption_offset=[ 41.012158, -16.970547]]).
node(node01377,function,[],[name=fn8],[]).
node(node01378,variable,[],[name=var9],[]).
node(node01386,variable,[],[comment='Part of the potential yield that is actually reached in the nuts',complete=true,name='Scaling\nfactor',param_type=file,units=1],[bounding_box=[ 88.666495, 213.11725, 103.6665, 228.11725],caption_offset=[ -36.769542, -21.213198]]).
node(node01388,variable,[],[comment='Actual grassland yield in the nuts in 2000 (t/ha)',complete=true,name='actual yield\n2000',param_type=file,units=1],[bounding_box=[ 88.66646299999999, 320.59746, 103.66646, 335.59746],caption_offset=[0,0]]).
node(node01392,variable,[],[complete=true,name='Management\nfactor'],[bounding_box=[ 261.2005, 148.06357, 276.2005, 163.06357],caption_offset=[ 9.8994923, 2.8284264]]).
node(node01393,function,[],[comment='Impact of the management on the scale factor',complete=true,name=fn9,spec='if scenario==1 then(if time()<=10 then M_temp*time()else M_temp*10)elseif scenario==2 then(if time()<=10 then M_temp*time()else M_temp*10)else(if time()<=10 then M_temp*time()else M_temp*10)',units=1,value=(if scenario==1 then(if time('')<=10 then 'M_temp'*time('')else 'M_temp'*10)elseif scenario==2 then(if time('')<=10 then 'M_temp'*time('')else 'M_temp'*10)else(if time('')<=10 then 'M_temp'*time('')else 'M_temp'*10))],[]).
node(node01394,variable,[],[complete=true,name='M_temp'],[bounding_box=[ 323.42579, 101.39456, 338.42579, 116.39456],caption_offset=[0,0]]).
node(node01395,function,[],[complete=true,name=fn12,spec='0.0005',units=1,value= 0.0005],[]).
node(node01436,variable,[],[name=var54],[]).
node(node01437,variable,[],[name=var55],[]).
node(node01543,variable,[],[name=var5],[]).
node(node01544,variable,[],[name=var6],[]).
node(node00998,variable,[],[complete=true,name='Weighted\nactual\nyield'],[bounding_box=[ 631.72481, 140.99201, 646.72481, 155.99201],caption_offset=[ -1.4142132, -66.468019]]).
node(node00999,function,[],[comment='Predicted grassland actual yield weighted by the area occupied grasslands in the nuts',complete=true,name=fn9,spec='Predicted_actual_yield*GFC_surf_ini',units=1,value='Predicted_actual_yield'*'GFC_surf_ini'],[]).
node(node01012,variable,[],[name=var46],[]).
node(node01336,variable,[],[comment='Potential grassland yields in the nuts, according to LPJ (t/ha)',complete=true,name='LPJ data\n2000 2010',param_type=file,units=1],[bounding_box=[ 33.512179, 41.997498, 48.512179, 56.997496],caption_offset=[ 9.999897800000001e-09, 7.0710658]]).
node(node01379,variable,[],[name=var10],[]).
node(node01410,variable,[],[complete=true,name='Yield 2000\nweighted'],[bounding_box=[ 532.72943, 265.44318, 547.72943, 280.44318],caption_offset=[ -2.8284263, -50.911674]]).
node(node01411,function,[],[comment='Actual yield of grasslands in 2000 weighted by the area occupied by grasslands in the nuts',complete=true,name=fn9,spec='actual_yield_2000*GFC_surf_ini',units=1,value=actual_yield_2000*'GFC_surf_ini'],[]).
node(node01413,submodel,[node01414,node01415,node01416,node01417,node01418,node01423,node01424,node01428,node01431,node01432,node01435,node01518],[complete=true,enum_types=[],fill_colour='#80ff00',image_posn=none,multiplication_spec=[count=[]],name=cond,separate=0],[bounding_box=[ 497.80303, 318.198, 681.65074, 479.4183],caption_offset=[ 7.0710658, 0.0],hide_contents=0,internal_extent=[0,0, 183.84771, 161.2203]]).
links(node01413,[arc01585-arc01584,arc01597-arc01596,arc01603-arc01604,arc01703-arc01702]).
references(node01413,[local(arc01588)]).
node(node01414,condition,[],[complete=true,name=cond],[bounding_box=[ 30.254821, 96.72284000000001, 60.254821, 126.72284],caption_offset=[0,0]]).
node(node01415,function,[],[comment='If the cell belongs to the nuts, cond = true\nIf the cell does not belong to the nuts, cond = false',complete=true,name=fn16,spec='index==IDNUTS_link_3',units=cond_spec,value=(index=='IDNUTS_link_3')],[]).
node(node01416,variable,[],[name=var28],[bounding_box=[ 102.17914, 80.59054399999999, 167.17914, 145.59054],caption_offset=[0,0]]).
node(node01417,function,[],[name=fn17],[]).
node(node01418,variable,[],[name=var29],[]).
node(node01423,variable,[],[name=var32],[bounding_box=[ 46.240096, 39.113644, 61.240096, 54.113644],caption_offset=[0,0]]).
node(node01424,function,[],[name=fn18],[]).
node(node01428,variable,[],[name=var48],[]).
node(node01431,variable,[],[complete=true,name='GFC surf'],[bounding_box=[ 131.09289, 37.754821, 146.09289, 52.754821],caption_offset=[0,0]]).
node(node01432,function,[],[comment='Area of grasslands in 2005 (square meters)',complete=true,name=fn19,spec='GFC_ini_abs_link_3',units=1,value='GFC_ini_abs_link_3'],[]).
node(node01435,variable,[],[name=var53],[]).
node(node01518,variable,[],[name=var11],[]).
node(node01419,variable,[],[name=var30],[]).
node(node01421,submodel,[],[name=submodel2],[]).
node(node01429,variable,[],[name=var49],[]).
node(node01433,variable,[],[complete=true,name='GFC surf\nini'],[bounding_box=[ 630.31013, 220.18835, 645.31013, 235.18835],caption_offset=[ -33.941116, -29.698476]]).
node(node01434,function,[],[comment='Area of grasslands in 2005 (square meters)',complete=true,name=fn20,spec='sum({GFC_surf})',units=1,value=sum({'GFC_surf'})],[]).
node(node01440,variable,[],[name=var57],[]).
node(node01444,variable,[],[name=var64],[]).
node(node01511,variable,[],[name=var6],[bounding_box=[ 423.13069, 433.7687, 488.13069, 498.7687],caption_offset=[0,0]]).
node(node01512,function,[],[name=fn2],[]).
node(node01513,variable,[],[name=var7],[]).
node(node01541,variable,[],[comment='Potential grassland yields in the nuts, according to LPJ (t/ha)',complete=true,name='LPJ data\n2011 2030',param_type=file,units=1],[bounding_box=[ 30.683753, 119.77922, 45.683753, 134.77922],caption_offset=[ 9.999897800000001e-09, 7.0710658]]).
node(node01542,variable,[],[comment='Potential grassland yields in the nuts, according to LPJ (t/ha)',complete=true,name='LPJ data\n2031 2050',param_type=file,units=1],[bounding_box=[ 26.441113, 196.14673, 41.441113, 211.14673],caption_offset=[ 9.999897800000001e-09, 7.0710658]]).
node(node00862,submodel,[node00868,node00898,node01000,node01001,node01047,node01198,node01384,node01396,node01409,node01452,node01456,node01459,node01464,node01472,node01476,node01477,node01481,node01485,node01514,node01515,node01516,node01545,node01546],[complete=true,enum_types=[],fill_colour='#ff8000',image_posn=none,multiplication_spec=[count=[]],name='Permanent crops',separate=0],[bounding_box=[ -37.521898, 1790.8339, 702.11158, 2301.3648],caption_offset=[ -2.8421709e-14, -4.5474735e-13],hide_contents=0,internal_extent=[ 39.597934, -43.840612, 779.23148, 466.69034]]).
links(node00862,[arc00998-arc00997,arc01119-arc01033,arc01230-arc01231,arc01551-arc01550,arc01636-arc01635,arc01641-arc01640,arc01648-arc01647,arc01659-arc01660,arc01664-arc01665,arc01699-arc01698]).
node(node00868,submodel,[node00903,node00904,node00905,node00906,node00907,node00908,node00928,node00941,node00943,node00946,node01002,node01003,node01191,node01192,node01372,node01373,node01381,node01382,node01383,node01389,node01405,node01406,node01407,node01408,node01455,node01547,node01548],[complete=true,enum_types=[],fill_colour='#d8d8d8',image_posn=none,multiplication_spec=[count=[]],name='LPJ',separate=0],[bounding_box=[ 130.81473, 9.899483699999999, 481.5396, 427.09238],caption_offset=[ 36.769542, -2.8284263],hide_contents=0,internal_extent=[ -2.8421709e-14, -29.698483, 350.72486, 387.4944]]).
links(node00868,[arc00882-arc00875,arc00882-arc00884,arc00997-arc00992,arc01000-arc01008,arc01033-arc01013,arc01550-arc01549,arc01632-arc01633,arc01719-arc01718,arc01721-arc01720]).
node(node00903,variable,[],[complete=true,name='POT LPJ'],[bounding_box=[ 62.503517, 16.541632, 77.503517, 31.541632],caption_offset=[0,0]]).
node(node00904,function,[],[comment='Potential yield at the time of simulation + 1 timestep (t/ha)',complete=true,name=fn2,spec='if time()<5 then LPJ_data\nelseif time()<25 then LPJ_data_2011_2030\nelse LPJ_data_2031_2050',units=1,value=(if time('')<5 then 'LPJ_data' elseif time('')<25 then 'LPJ_data_2011_2030' else 'LPJ_data_2031_2050')],[]).
node(node00905,variable,[],[name=var3],[]).
node(node00906,variable,[],[complete=true,name='Potential\nyield LPJ\n2000'],[bounding_box=[ 42.704541, 105.63706, 57.704541, 120.63706],caption_offset=[ 41.012185, -24.041625]]).
node(node00907,variable,[],[complete=true,name='Predicted\nactual\nyield'],[bounding_box=[ 177.05549, 203.92418, 192.05549, 218.92418],caption_offset=[ -22.627412, -2.8284265]]).
node(node00908,function,[],[comment='Actual yield predicted for the time of simulation + 1 timestep (t/ha)',complete=true,name=fn3,spec='Potential_with_technology*max(Scaling_factor-Management_factor_plus,0)',units=1,value='Potential_with_technology'*max('Scaling_factor'-'Management_factor_plus',0)],[]).
node(node00928,function,[],[comment='Potential yield in 2000 (t/ha)',complete=true,name=fn4,spec='LPJ_data',units=1,value='LPJ_data'],[]).
node(node00941,variable,[],[name=var5],[]).
node(node00943,variable,[],[comment='Part of the potential yield that is actually reached in the nuts',complete=true,name='Scaling\nfactor',param_type=file,units=1],[bounding_box=[ 93.616208, 204.63198, 108.61621, 219.63198],caption_offset=[ -35.355332, -19.798986]]).
node(node00946,variable,[],[comment='Actual permanent crop yield in the nuts in 2000 (t/ha)',complete=true,name='actual yield\n2000',param_type=file,units=1],[bounding_box=[ 92.20196799999999, 334.73957, 107.20197, 349.73957],caption_offset=[0,0]]).
node(node01002,variable,[],[name=var16],[bounding_box=[ 301.50547, 87.252419, 316.50547, 102.25242],caption_offset=[ 1.4142133, 5.656853]]).
node(node01003,variable,[],[name=var45],[]).
node(node01191,function,[],[name=fn8],[]).
node(node01192,variable,[],[name=var17],[]).
node(node01372,variable,[],[name=var20],[bounding_box=[ 271.80708, 16.541633, 286.80708, 31.541633],caption_offset=[ 0.0, 7.0710663]]).
node(node01373,function,[],[name=fn10],[]).
node(node01381,variable,[],[name=var13],[bounding_box=[ 211.888, 73.86740899999999, 226.888, 88.86740899999999],caption_offset=[ 39.597947, -16.970549]]).
node(node01382,function,[],[name=fn9],[]).
node(node01383,variable,[],[name=var14],[]).
node(node01389,variable,[],[name=var21],[]).
node(node01405,variable,[],[complete=true,name='Management\nfactor'],[bounding_box=[ 244.93703, 138.16407, 259.93703, 153.16407],caption_offset=[0,0]]).
node(node01406,function,[],[comment='Impact of the management on the scale factor',complete=true,name=fn9,spec='if scenario==1 then (if time()<=10 then element([M],1)*time() else element([M],1)*10)\nelseif scenario==2  then (if time()<=10 then element([M],2)*time() else element([M],2)*10)\nelse  (if time()<=10 then element([M],3)*time() else element([M],3)*10)',units=1,value=(if scenario==1 then(if time('')<=10 then element(['M'],1)*time('')else element(['M'],1)*10)elseif scenario==2 then(if time('')<=10 then element(['M'],2)*time('')else element(['M'],2)*10)else(if time('')<=10 then element(['M'],3)*time('')else element(['M'],3)*10))],[]).
node(node01407,variable,[],[complete=true,name='Potential\nwith technology'],[bounding_box=[ 177.05479, 16.541632, 192.05479, 31.541632],caption_offset=[ 7.0710657, -46.669035]]).
node(node01408,function,[],[comment='Potential yield at the time of simulation + 1 timestep, corrected for the evolution of the technology (t/ha)',complete=true,name=fn4,spec='if scenario==1 then (if time() <=10 then POT_LPJ*(1+time()*(element([T],1)))\nelse POT_LPJ*(1+(element([T],1))*10+((element([T],4))*(time()-10))))\nelseif scenario==2 then (if time() <=10 then POT_LPJ*(1+time()*(element([T],2)))\nelse POT_LPJ*(1+(element([T],2))*10+((element([T],5))*(time()-10))))\nelse (if time() <=10 then POT_LPJ*(1+time()*(element([T],3)))\nelse POT_LPJ*(1+(element([T],3))*10+((element([T],6))*(time()-10))))',units=1,value=(if scenario==1 then(if time('')<=10 then 'POT_LPJ'*(1+time('')*element(['T'],1))else 'POT_LPJ'*(1+element(['T'],1)*10+element(['T'],4)*(time('')-10)))elseif scenario==2 then(if time('')<=10 then 'POT_LPJ'*(1+time('')*element(['T'],2))else 'POT_LPJ'*(1+element(['T'],2)*10+element(['T'],5)*(time('')-10)))else(if time('')<=10 then 'POT_LPJ'*(1+time('')*element(['T'],3))else 'POT_LPJ'*(1+element(['T'],3)*10+element(['T'],6)*(time('')-10))))],[]).
node(node01455,variable,[],[name=var24],[]).
node(node01547,variable,[],[name=var7],[]).
node(node01548,variable,[],[name=var8],[]).
node(node00898,variable,[],[comment='Potential permanent crop yields in the nuts, according to LPJ (t/ha)',complete=true,name='LPJ data\n2000 2010',param_type=file,units=1],[bounding_box=[ 83.00960600000001, -13.156851, 98.00960600000001, 1.8431489],caption_offset=[ 2.8284266, 7.0710665]]).
node(node01000,variable,[],[complete=true,name='Weighted\nactual\nyield'],[bounding_box=[ 664.25172, 81.594746, 679.25172, 96.594746],caption_offset=[ 0.0, -63.639599]]).
node(node01001,function,[],[comment='Predicted permanent crop actual yield weighted by the area occupied by permanent crops in the nuts',complete=true,name=fn9,spec='Predicted_actual_yield*PC_surf_ini',units=1,value='Predicted_actual_yield'*'PC_surf_ini'],[]).
node(node01047,variable,[],[name=var52],[]).
node(node01198,variable,[],[name=var18],[]).
node(node01384,variable,[],[name=var15],[]).
node(node01396,variable,[],[name=var22],[]).
node(node01409,variable,[],[complete=true,name='Yield 2000\nweighted'],[bounding_box=[ 577.9842599999999, 210.28885, 592.9842599999999, 225.28885],caption_offset=[ -15.556346, -48.083247]]).
node(node01452,function,[],[comment='Actual yield of permanent crops in 2000 weighted by the area occupied by permanent crops in the nuts',complete=true,name=fn9,spec='actual_yield_2000*PC_surf_ini',units=1,value=actual_yield_2000*'PC_surf_ini'],[]).
node(node01456,submodel,[node01457,node01458,node01461,node01462,node01463,node01466,node01467,node01471,node01474,node01475,node01478,node01517],[complete=true,enum_types=[],fill_colour='#f5ac49',image_posn=none,multiplication_spec=[count=[]],name=cond,separate=0],[bounding_box=[ 526.0873, 294.15637, 733.97666, 448.30562],caption_offset=[ 5.6568532, 0.0],hide_contents=0,internal_extent=[0,0, 207.88936, 154.14925]]).
links(node01456,[arc01640-arc01639,arc01647-arc01646,arc01654-arc01655,arc01701-arc01700]).
references(node01456,[local(arc01635)]).
node(node01457,condition,[],[complete=true,name=cond],[bounding_box=[ 24.597972, 89.65178400000001, 54.597972, 119.65178],caption_offset=[0,0]]).
node(node01458,function,[],[comment='If the cell belongs to the nuts, cond = true\nIf the cell does not belong to the nuts, cond = false',complete=true,name=fn11,spec='index==IDNUTS_link_4',units=cond_spec,value=(index=='IDNUTS_link_4')],[]).
node(node01461,variable,[],[name=var25],[bounding_box=[ 116.32129, 72.105276, 181.32129, 137.10528],caption_offset=[0,0]]).
node(node01462,function,[],[name=fn12],[]).
node(node01463,variable,[],[name=var26],[]).
node(node01466,variable,[],[name=var30],[bounding_box=[ 42.052859, 30.739151, 57.052859, 45.739151],caption_offset=[0,0]]).
node(node01467,function,[],[name=fn13],[]).
node(node01471,variable,[],[name=var87],[]).
node(node01474,variable,[],[complete=true,name='PC surf'],[bounding_box=[ 139.57818, 29.269546, 154.57818, 44.269546],caption_offset=[0,0]]).
node(node01475,function,[],[comment='Area of permanent crops in 2005 (square meters)',complete=true,name=fn14,spec='PC_ini_abs_link_4',units=1,value='PC_ini_abs_link_4'],[]).
node(node01478,variable,[],[name=var92],[]).
node(node01517,variable,[],[name=var10],[]).
node(node01459,submodel,[],[name=submodel2],[]).
node(node01464,variable,[],[name=var27],[]).
node(node01472,variable,[],[name=var88],[]).
node(node01476,variable,[],[complete=true,name='PC surf\nini'],[bounding_box=[ 664.25127, 162.2056, 679.25127, 177.2056],caption_offset=[ -33.941119, -25.455839]]).
node(node01477,function,[],[comment='Area of permanent crops in 2005 (square meters)',complete=true,name=fn15,spec='sum({PC_surf})',units=1,value=sum({'PC_surf'})],[]).
node(node01481,variable,[],[name=var94],[]).
node(node01485,variable,[],[name=var98],[]).
node(node01514,variable,[],[name=var8],[bounding_box=[ 461.31445, 401.24181, 526.31445, 466.24181],caption_offset=[0,0]]).
node(node01515,function,[],[name=fn3],[]).
node(node01516,variable,[],[name=var9],[]).
node(node01545,variable,[],[comment='Potential grassland yields in the nuts, according to LPJ (t/ha)',complete=true,name='LPJ data\n2011 2030',param_type=file,units=1],[bounding_box=[ 74.524326, 66.03909299999999, 89.524326, 81.03909299999999],caption_offset=[ 9.999897800000001e-09, 7.0710658]]).
node(node01546,variable,[],[comment='Potential grassland yields in the nuts, according to LPJ (t/ha)',complete=true,name='LPJ data\n2031 2050',param_type=file,units=1],[bounding_box=[ 78.766966, 136.74976, 93.766966, 151.74976],caption_offset=[ 9.999897800000001e-09, 7.0710658]]).
node(node00979,variable,[],[name=var35],[]).
node(node00983,submodel,[],[name=submodel4],[]).
node(node01020,variable,[],[name=var47],[]).
node(node01025,variable,[],[name=var77],[]).
node(node01048,variable,[],[name=var86],[]).
node(node01049,variable,[],[name=var53],[]).
node(node01224,variable,[],[name=var11],[]).
node(node01227,variable,[],[name=var14],[]).
node(node01230,variable,[],[name=var17],[]).
node(node01234,variable,[],[name=var20],[]).
node(node01282,variable,[],[name=var9],[]).
node(node01287,variable,[],[name=var13],[]).
node(node01312,variable,[],[name=var66],[]).
node(node01316,submodel,[],[name=submodel3],[]).
node(node01318,variable,[],[name=var27],[]).
node(node01326,variable,[],[name=var81],[]).
node(node01346,variable,[],[name=var19],[]).
node(node01350,variable,[],[name=var102],[]).
node(node01367,variable,[],[name=var36],[]).
node(node01380,variable,[],[name=var12],[]).
node(node01385,variable,[],[name=var16],[]).
node(node01397,variable,[],[name=var23],[]).
node(node01420,variable,[],[name=var31],[]).
node(node01422,submodel,[],[name=submodel5],[]).
node(node01430,variable,[],[name=var50],[]).
node(node01441,variable,[],[name=var58],[]).
node(node01445,variable,[],[name=var65],[]).
node(node01460,submodel,[],[name=submodel6],[]).
node(node01465,variable,[],[name=var29],[]).
node(node01473,variable,[],[name=var89],[]).
node(node01482,variable,[],[name=var95],[]).
node(node01486,variable,[],[name=var99],[]).
node(node01499,variable,[],[name=var68],[]).
node(node00829,variable,[],[comment='Maximum distance for a cell to be considered as "close to roads" (meters)',complete=true,name='dist_to_roads\nthreshold',param_type=file,units=1],[bounding_box=[ 798.38033, -1049.0397, 817.88033, -1029.5397],caption_offset=[0,0]]).
node(node00830,variable,[],[comment='Maximum distance for a cell to be considered as "close to small cities" (meters)',complete=true,name='dist_to_sm\nthreshold',param_type=file,units=1],[bounding_box=[ 886.9619300000001, -1046.8003, 906.4619300000001, -1027.3003],caption_offset=[0,0]]).
node(node00831,variable,[],[comment='Maximum distance for a cell to be considered as "close to medium cities" (meters)',complete=true,name='dist_to_med\nthreshold',param_type=file,units=1],[bounding_box=[ 975.4378, -1047.6751, 994.9378, -1028.1751],caption_offset=[ -1.2362746, -1.2362746]]).
node(node00832,variable,[],[comment='Maximum distance for a cell to be considered as "close to large cities" (meters)',complete=true,name='dist_to_large\nthreshold',param_type=file,units=1],[bounding_box=[ 1057.3443, -1049.9674, 1076.8443, -1030.4674],caption_offset=[0,0]]).
node(node00845,submodel,[node00043,node00045,node00055,node00059,node00097,node00105,node00136,node00158,node00168,node00240,node00242,node00248,node00252,node00254,node00262,node00264,node00320,node00326,node00330,node00333,node00364,node00369,node00375,node00505,node00767,node00848,node00849,node00855,node00856,node00859,node00860,node00863,node00865,node00867,node00911,node00913,node00989,node01022,node01042,node01061,node01072,node01176,node01188,node01255,node01265,node01274,node01327,node01352,node01443,node01447,node01484,node01488],[complete=true,enum_types=[],fill_colour='#80ffff',image_posn=none,multiplication_spec=[count=[]],name='Europe',separate=0],[bounding_box=[ -407.92309, -163.25872, 389.47405, 2520.3371],caption_offset=[ 93.77989599999999, -2.9339805],hide_contents=0,internal_extent=[ -82.190344, -18.00005, 739.11697, 2746.0641]]).
links(node00845,[arc00055-arc00054,arc00058-arc00061,arc00070-arc00069,arc00075-arc00078,arc00097-arc00096,arc00105-arc00114,arc00120-arc00119,arc00126-arc00125,arc00128-arc00151,arc00166-arc00156,arc00176-arc00193,arc00199-arc00197,arc00274-arc00272,arc00279-arc00273,arc00281-arc00284,arc00290-arc00289,arc00295-arc00298,arc00304-arc00302,arc00309-arc00308,arc00377-arc00380,arc00395-arc00394,arc00416-arc00436,arc00489-arc00461,arc00891-arc00851,arc00907-arc00945,arc00955-arc01018,arc00986-arc00985,arc01007-arc01029,arc01017-arc00954,arc01024-arc00958,arc01026-arc01009,arc01028-arc01011,arc01148-arc01112,arc01184-arc01183,arc01219-arc01218,arc01234-arc01233,arc01240-arc01239,arc01343-arc01342,arc01356-arc01355,arc01427-arc01426,arc01439-arc01438,arc01448-arc01447,arc01491-arc01482,arc01520-arc01519,arc01616-arc01615,arc01621-arc01620,arc01663-arc01662,arc01668-arc01667]).
references(node00845,[obsolete]).
node(node00043,variable,[],[name=var22],[]).
node(node00045,variable,[],[name=var24],[]).
node(node00055,variable,[],[name=var26],[]).
node(node00059,variable,[],[name=var29],[]).
node(node00097,variable,[],[name=var4],[]).
node(node00105,variable,[],[name=var6],[]).
node(node00136,variable,[],[name=var32],[]).
node(node00158,variable,[],[name=var37],[]).
node(node00168,variable,[],[name=var39],[]).
node(node00240,variable,[],[name=var47],[]).
node(node00242,variable,[],[name=var49],[]).
node(node00248,variable,[],[name=var56],[]).
node(node00252,variable,[],[name=var60],[]).
node(node00254,variable,[],[name=var62],[]).
node(node00262,variable,[],[name=var73],[]).
node(node00264,variable,[],[name=var75],[]).
node(node00320,submodel,[node00073,node00075,node00076,node00078,node00079,node00080,node00081,node00086,node00089,node00090,node00091,node00092,node00093,node00094,node00096,node00104,node00115,node00139,node00140,node00141,node00142,node00143,node00144,node00145,node00150,node00151,node00152,node00153,node00154,node00155,node00157,node00159,node00160,node00167,node00172,node00235,node00241,node00247,node00251,node00253,node00261,node00263,node00325,node00329,node00332,node00357,node00360,node00362,node00395,node00567,node00568,node00572,node00573,node00574,node00575,node00585,node00586,node00596,node00597,node00601,node00602,node00603,node00604,node00608,node00609,node00613,node00614,node00711,node00712,node00713,node00714,node00766,node00779,node00780,node00784,node00785,node00822,node00823,node01175,node01180,node01181,node01187],[complete=true,enum_types=[],fill_colour='#00a8f9',image_posn=none,multiplication_spec=[count=[]],name='Biofuels',separate=0],[bounding_box=[ -20.232016, 1663.3715, 662.3731, 2667.6156],caption_offset=[ 46.34973, 0.0],hide_contents=0,internal_extent=[ -5.5067062e-14, -2.2737368e-13, 682.6051200000001, 1004.2442]]).
links(node00320,[arc00096-arc00095,arc00098-arc00105,arc00119-arc00118,arc00125-arc00124,arc00127-arc00128,arc00156-arc00154,arc00173-arc00176,arc00197-arc00196,arc00273-arc00258,arc00280-arc00281,arc00289-arc00287,arc00291-arc00295,arc00302-arc00301,arc00308-arc00307,arc00310-arc00377,arc01183-arc01182,arc01342-arc01341,arc01355-arc01354]).
references(node00320,[obsolete]).
node(node00073,variable,[],[comment='European surface (square meters)',complete=true,name=surface,param_type=file,units=1],[bounding_box=[ 50.085987, 464.42451, 65.085987, 479.4245],caption_offset=[ 37.294932, -15.503887]]).
node(node00075,variable,[],[complete=true,name='liquid\nbiofuels_abs\nt+1'],[bounding_box=[ 144.19011, 213.01236, 159.19011, 228.01236],caption_offset=[ 39.735012, -1.9040733]]).
node(node00076,function,[],[comment='Liquid biofuels at the time of simulation + 1 year (square meters)',complete=true,name=fn3,spec='if time() <71 then (element([liquid_data],time()+2)+(element([liquid_data],time()+3)-element([liquid_data],time()+2))*(time()-int(time())))*surface\n\nelse (element([liquid_data],76))*surface',units=1,value=(if time('')<71 then(element([liquid_data],time('')+2)+(element([liquid_data],time('')+3)-element([liquid_data],time('')+2))*(time('')-int(time(''))))*surface else element([liquid_data],76)*surface)],[]).
node(node00078,variable,[],[complete=true,name='non woody\nbiofuels_abs\nt+1'],[bounding_box=[ 126.64239, 510.69412, 141.64239, 525.69412],caption_offset=[ 2.4229734, -0.071703853]]).
node(node00079,function,[],[comment='Non woody biofuels at the time of simulation + 1 year (square meters)',complete=true,name=fn4,spec='if time() < 75then (element([NW_data],time()+2)+(element([NW_data],time()+3)-element([NW_data],time()+2))*(time()-int(time())))*surface\n\nelse (element([NW_data],76))*surface',units=1,value=(if time('')<75 then(element(['NW_data'],time('')+2)+(element(['NW_data'],time('')+3)-element(['NW_data'],time('')+2))*(time('')-int(time(''))))*surface else element(['NW_data'],76)*surface)],[]).
node(node00080,variable,[],[complete=true,name='woody\nbiofuels_abs\nt+1'],[bounding_box=[ 49.603115, 854.97513, 64.603115, 869.97513],caption_offset=[ 4.0309358, 1.5873901]]).
node(node00081,function,[],[comment='Woody biofuels at the time of simulation + 1 year (square meters)',complete=true,name=fn5,spec='if time()< 75 then (element([Woody_data],time()+2)+(element([Woody_data],time()+3)-element([Woody_data],time()+2))*(time()-int(time())))*surface\n\nelse (element([Woody_data],76))*surface',units=1,value=(if time('')<75 then(element(['Woody_data'],time('')+2)+(element(['Woody_data'],time('')+3)-element(['Woody_data'],time('')+2))*(time('')-int(time(''))))*surface else element(['Woody_data'],76)*surface)],[]).
node(node00086,variable,[],[complete=true,name='liquid\narea'],[bounding_box=[ 551.6026000000001, 213.06148, 566.6026000000001, 228.06148],caption_offset=[ -0.2032002, -47.918763]]).
node(node00089,variable,[],[complete=true,name='tot rent_area\nliquid 2005'],[bounding_box=[ 252.33939, 48.681495, 267.33939, 63.681495],caption_offset=[ -1.4624753, -47.190508]]).
node(node00090,function,[],[comment='area available for liquid biofuels in 2005 (square meters)',complete=true,name=fn13,spec='sum([rent_liquid_area_2005])',units=1,value=sum([rent_liquid_area_2005])],[]).
node(node00091,variable,[],[complete=true,name='remaining\nrent_area\nnon woody'],[bounding_box=[ 364.71198, 442.53389, 379.71198, 457.53389],caption_offset=[ -51.953432, -34.670563]]).
node(node00092,function,[],[comment='Remaining area available for non woody biofuels at the time of simulation (square meters)',complete=true,name=fn14,spec='sum([remaining_NW_rent_area])',units=1,value=sum([remaining_NW_rent_area])],[]).
node(node00093,variable,[],[complete=true,name='remaining\nrent_area\nwoody'],[bounding_box=[ 412.11703, 799.1606399999999, 427.11703, 814.1606399999999],caption_offset=[ -2.7222385, -62.814472]]).
node(node00094,function,[],[comment='Remaining area available for woody biofuels at the time of simulation (square meters)',complete=true,name=fn15,spec='sum([remaining_woody_rent_area])',units=1,value=sum([remaining_woody_rent_area])],[]).
node(node00096,variable,[],[name=var3],[]).
node(node00104,variable,[],[name=var5],[]).
node(node00115,variable,[],[name=var31],[]).
node(node00139,variable,[],[name=var36],[]).
node(node00140,variable,[],[complete=true,name='dens\nliquid\n2005'],[bounding_box=[ 252.33939, 96.43575800000001, 267.33939, 111.43576],caption_offset=[ 8.1237289, 7.2394685]]).
node(node00141,function,[],[comment='Liquid biofuels density the available areas in 2005 (no dimension)',complete=true,name=fn20,spec='if tot_rent_area_liquid_2005<=0 then 0 elseif tot_rent_area_liquid_2005<liquid_biofuels_2005 then 1 else liquid_biofuels_2005/tot_rent_area_liquid_2005',units=1,value=(if tot_rent_area_liquid_2005<=0 then 0 elseif tot_rent_area_liquid_2005<liquid_biofuels_2005 then 1 else liquid_biofuels_2005/tot_rent_area_liquid_2005)],[]).
node(node00142,variable,[],[complete=true,name='dens\nnon woody\n2005'],[bounding_box=[ 403.2097, 398.32428, 418.2097, 413.32428],caption_offset=[ -41.585741, -56.221207]]).
node(node00143,function,[],[comment='Non woody biofuels density the available areas in 2005 (no dimension)',complete=true,name=fn21,spec='if tot_rent_area_NW_2005_0<=0 then 0 elseif tot_rent_area_NW_2005_0<NW_biofuels_2005 then 1 else NW_biofuels_2005/tot_rent_area_NW_2005_0',units=1,value=(if tot_rent_area_NW_2005_0<=0 then 0 elseif tot_rent_area_NW_2005_0<'NW_biofuels_2005' then 1 else 'NW_biofuels_2005'/tot_rent_area_NW_2005_0)],[]).
node(node00144,variable,[],[complete=true,name='dens add\nwoody'],[bounding_box=[ 411.39171, 934.0204, 426.39171, 949.0204],caption_offset=[ -46.988717, -19.110855]]).
node(node00145,function,[],[comment='Increase/decrease of woody biofuels density in the available areas at the current timestep (no dimension)',complete=true,name=fn22,spec='if remaining_rent_area_woody<=0 then 0 elseif remaining_rent_area_woody<woody_change then 1 else woody_change/remaining_rent_area_woody',units=1,value=(if remaining_rent_area_woody<=0 then 0 elseif remaining_rent_area_woody<woody_change then 1 else woody_change/remaining_rent_area_woody)],[]).
node(node00150,variable,[],[complete=true,name='liquid biofuels\n2005'],[bounding_box=[ 50.086004, 97.944461, 65.086004, 112.94445],caption_offset=[ 17.891289, -47.928438]]).
node(node00151,function,[],[comment='Liquid biofuels in 2005 (square meters)',complete=true,name=fn8,spec='element([liquid_data],1)*surface',units=1,value=element([liquid_data],1)*surface],[]).
node(node00152,variable,[],[complete=true,name='Liquid change'],[bounding_box=[ 322.66301, 212.96323, 337.66301, 227.96323],caption_offset=[ -8.020824299999999, -31.006258]]).
node(node00153,function,[],[comment='Liquid biofuels increase/decrease at the current timestep (square meters)',complete=true,name=fn9,spec='liquid_biofuels_abs_t_1-liquid_area_bis',units=1,value=liquid_biofuels_abs_t_1-liquid_area_bis],[]).
node(node00154,variable,[],[complete=true,name='remaining\nrent area\nliquid'],[bounding_box=[ 402.18945, 155.97862, 417.18945, 170.97862],caption_offset=[ -44.954869, -35.558536]]).
node(node00155,function,[],[comment='Remaining area available for liquid biofuels at the time of simulation (square meters)',complete=true,name=fn10,spec='sum([remaining_liquid_rent_area])',units=1,value=sum([remaining_liquid_rent_area])],[]).
node(node00157,function,[],[comment='surface of liquid biofuels (square meters)',complete=true,name=fn1,spec='sum([liquid_area_0])',units=1,value=sum([liquid_area_0])],[]).
node(node00159,variable,[],[complete=true,name='dens add\nliquid'],[bounding_box=[ 401.65577, 262.72344, 416.65577, 277.72344],caption_offset=[ -49.924535, -18.683821]]).
node(node00160,function,[],[comment='Increase/decrease of liquid biofuels density in the available areas at the current timestep (no dimension)',complete=true,name=fn11,spec='if remaining_rent_area_liquid<=0 then 0 elseif remaining_rent_area_liquid<Liquid_change then 1 else Liquid_change/remaining_rent_area_liquid',units=1,value=(if remaining_rent_area_liquid<=0 then 0 elseif remaining_rent_area_liquid<'Liquid_change' then 1 else 'Liquid_change'/remaining_rent_area_liquid)],[]).
node(node00167,variable,[],[name=var38],[]).
node(node00172,variable,[],[complete=true,name='NW biofuels\n2005'],[bounding_box=[ 173.21046, 397.09374, 188.21046, 412.09374],caption_offset=[ -0.31942863, -47.938063]]).
node(node00235,variable,[],[name=var46],[]).
node(node00241,variable,[],[name=var48],[]).
node(node00247,variable,[],[name=var55],[]).
node(node00251,variable,[],[name=var59],[]).
node(node00253,variable,[],[name=var61],[]).
node(node00261,variable,[],[name=var72],[]).
node(node00263,variable,[],[name=var74],[]).
node(node00325,variable,[],[name=var80],[]).
node(node00329,variable,[],[name=var84],[]).
node(node00332,variable,[],[name=var86],[]).
node(node00357,variable,[],[comment='Annual liquid biofuels density data',complete=true,name='liquid\ndata',param_type=file,spec='makearray(1.0,76)',units=array(1,76),value=makearray( 1.0,76)],[bounding_box=[ 96.159335, 150.98098, 111.15934, 165.98098],caption_offset=[ 30.588996, -24.76252]]).
node(node00360,variable,[],[comment='Annual non-woody biofuels density data',complete=true,name='NW data',param_type=file,spec='makearray(1.0,76)',units=array(1,76),value=makearray( 1.0,76)],[bounding_box=[ 154.42409, 451.04446, 169.42409, 466.04446],caption_offset=[ 45.155184, -11.652951]]).
node(node00362,variable,[],[comment='Annual woody biofuels density data',complete=true,name='Woody\ndata\n',param_type=file,spec='makearray(1.0,76)',units=array(1,76),value=makearray( 1.0,76)],[bounding_box=[ 84.50638499999999, 777.32708, 99.50638499999999, 792.32708],caption_offset=[ 36.415471, -17.479426]]).
node(node00395,function,[],[comment='Non woody biofuels in 2005 (square meters)',complete=true,name=fn2,spec='element([NW_data],1)*surface',units=1,value=element(['NW_data'],1)*surface],[]).
node(node00567,variable,[],[complete=true,name='NW\narea'],[bounding_box=[ 584.86645, 510.85439, 599.86645, 525.85439],caption_offset=[ -1.5690326, -46.485196]]).
node(node00568,function,[],[comment='surface of non woody biofuels (square meters)',complete=true,name=fn6,spec='sum([NW_area])',units=1,value=sum(['NW_area'])],[]).
node(node00572,variable,[],[complete=true,name='NW change'],[bounding_box=[ 239.35027, 511.00772, 254.35027, 526.0077199999999],caption_offset=[ 8.765890000000001, -29.582368]]).
node(node00573,function,[],[comment='Non woody biofuels increase/decrease at the current timestep (square meters)',complete=true,name=fn7,spec='non_woody_biofuels_abs_t_1-NW_area_bis',units=1,value=non_woody_biofuels_abs_t_1-'NW_area_bis'],[]).
node(node00574,variable,[],[complete=true,name='dens add\nNW'],[bounding_box=[ 364.69277, 559.49886, 379.69277, 574.49886],caption_offset=[ -11.204003, 0.63622299]]).
node(node00575,function,[],[comment='Increase/decrease of non woody biofuels density in the available areas at the current timestep (no dimension)',complete=true,name=fn12,spec='if remaining_rent_area_non_woody<=0 then 0 elseif remaining_rent_area_non_woody<NW_change then 1 else NW_change/remaining_rent_area_non_woody',units=1,value=(if remaining_rent_area_non_woody<=0 then 0 elseif remaining_rent_area_non_woody<'NW_change' then 1 else 'NW_change'/remaining_rent_area_non_woody)],[]).
node(node00585,variable,[],[complete=true,name='tot rent_area\nNW 2005'],[bounding_box=[ 403.09976, 307.42739, 418.09976, 322.42739],caption_offset=[ -49.168505, -23.838425]]).
node(node00586,function,[],[comment='area available for non woody biofuels in 2005 (square meters)',complete=true,name=fn17,spec='sum([rent_NW_area_2005])',units=1,value=sum([rent_NW_area_2005])],[]).
node(node00596,variable,[],[complete=true,name='tot rent_area\nwoody 2005'],[bounding_box=[ 455.70702, 622.26638, 470.70702, 637.26638],caption_offset=[ 1.4142135, -49.497471]]).
node(node00597,function,[],[comment='area available for woody biofuels in 2005 (square meters)',complete=true,name=fn23,spec='sum([rent_woody_area_2005])',units=1,value=sum([rent_woody_area_2005])],[]).
node(node00601,variable,[],[complete=true,name='woody biofuels\n2005'],[bounding_box=[ 110.77141, 706.8854700000001, 125.77141, 721.8854700000001],caption_offset=[ 53.604645, -43.763208]]).
node(node00602,function,[],[comment='Woody biofuels in 2005 (square meters)',complete=true,name=fn24,spec='element([Woody_data],1)*surface',units=1,value=element(['Woody_data'],1)*surface],[]).
node(node00603,variable,[],[complete=true,name='dens\nwoody\n2005'],[bounding_box=[ 456.28758, 706.52896, 471.28758, 721.52896],caption_offset=[ -25.271995, -58.069838]]).
node(node00604,function,[],[comment='Woody biofuels density the available areas in 2005 (no dimension)',complete=true,name=fn25,spec='if tot_rent_area_woody_2005<=0 then 0 elseif tot_rent_area_woody_2005<woody_biofuels_2005 then 1 else woody_biofuels_2005/tot_rent_area_woody_2005',units=1,value=(if tot_rent_area_woody_2005<=0 then 0 elseif tot_rent_area_woody_2005<woody_biofuels_2005 then 1 else woody_biofuels_2005/tot_rent_area_woody_2005)],[]).
node(node00608,variable,[],[complete=true,name='woody\narea'],[bounding_box=[ 573.07258, 854.79662, 588.07258, 869.79662],caption_offset=[ -2.9735699, 1.2110138]]).
node(node00609,function,[],[comment='surface of woody biofuels (square meters)',complete=true,name=fn16,spec='sum([woody_area_0])',units=1,value=sum([woody_area_0])],[]).
node(node00613,variable,[],[complete=true,name='woody change'],[bounding_box=[ 268.28799, 854.92092, 283.28799, 869.92092],caption_offset=[ 11.642698, -32.420472]]).
node(node00614,function,[],[comment='Woody biofuels increase/decrease at the current timestep (square meters)',complete=true,name=fn18,spec='woody_biofuels_abs_t_1-woody_area_bis',units=1,value=woody_biofuels_abs_t_1-woody_area_bis],[]).
node(node00711,variable,[],[complete=true,name='removed\nwoody'],[bounding_box=[ 572.10252, 949.7079199999999, 587.10252, 964.7079199999999],caption_offset=[0,0]]).
node(node00712,function,[],[comment='Woody biofuels removed due to congestion in the surplus \'from agriculture\' areas (square meters)',complete=true,name=fn19,spec='sum([woody_to_remove])',units=1,value=sum([woody_to_remove])],[]).
node(node00713,variable,[],[complete=true,name='NW area\nbis'],[bounding_box=[ 425.35519, 510.76584, 440.35519, 525.76584],caption_offset=[0,0]]).
node(node00714,function,[],[comment='Surface of non-woody biofuels corrected for the non-woody biofuels that are removed due to congestion in the surplus \'from agriculture\' areas (square meters)',complete=true,name=fn26,spec='NW_area-removed_NW',units=1,value='NW_area'-removed_NW],[]).
node(node00766,variable,[],[name=var19],[]).
node(node00779,variable,[],[complete=true,name='removed\nNW'],[bounding_box=[ 583.7554699999999, 579.72673, 598.7554699999999, 594.72673],caption_offset=[0,0]]).
node(node00780,function,[],[comment='Non woody biofuels removed due to congestion in the surplus \'from agriculture\' areas (square meters)',complete=true,name=fn32,spec='sum([NW_to_remove])',units=1,value=sum(['NW_to_remove'])],[]).
node(node00784,variable,[],[complete=true,name='woody\narea bis'],[bounding_box=[ 458.85743, 854.52788, 473.85743, 869.52788],caption_offset=[0,0]]).
node(node00785,function,[],[comment='Surface of woody biofuels corrected for the woody biofuels that are removed due to congestion in the surplus \'from agriculture\' areas (square meters)',complete=true,name=fn30,spec='woody_area-removed_woody',units=1,value=woody_area-removed_woody],[]).
node(node00822,variable,[],[complete=true,name='liquid area\nbis'],[bounding_box=[ 445.74786, 213.61559, 460.74786, 228.61559],caption_offset=[0,0]]).
node(node00823,function,[],[comment='Surface of liquid biofuels corrected for the liquid biofuels that are removed due to congestion in the surplus \'from agriculture\' areas (square meters)',complete=true,name=fn31,spec='liquid_area-removed_liquid',units=1,value=liquid_area-removed_liquid],[]).
node(node01175,variable,[],[name=var40],[]).
node(node01180,variable,[],[complete=true,name='removed\nliquid'],[bounding_box=[ 557.53633, 273.83677, 572.53633, 288.83677],caption_offset=[0,0]]).
node(node01181,function,[],[comment='Liquid biofuels removed due to congestion in the surplus \'from agriculture\' areas (square meters)',complete=true,name=fn34,spec='sum([liquid_to_remove])',units=1,value=sum([liquid_to_remove])],[]).
node(node01187,variable,[],[name=var63],[]).
node(node00326,variable,[],[name=var81],[]).
node(node00330,variable,[],[name=var85],[]).
node(node00333,variable,[],[name=var87],[]).
node(node00364,variable,[],[name=var54],[]).
node(node00369,variable,[],[name=var15],[]).
node(node00375,variable,[],[name=var13],[]).
node(node00505,variable,[],[name=var52],[]).
node(node00767,variable,[],[name=var23],[]).
node(node00848,submodel,[node00036,node00037,node00038,node00039,node00042,node00044,node00204,node00221,node00311,node00869,node00870,node00873,node00874,node00875,node00876,node00877,node00878,node00879,node00880,node00883,node00884,node00887,node00889,node00890,node00893,node00894,node00895,node00897,node00899,node01004,node01005,node01028,node01256,node01257,node01264,node01438,node01439,node01442,node01446,node01448,node01449,node01450,node01451,node01453,node01454,node01570,node01571,node01572,node01573],[complete=true,enum_types=[],fill_colour='#80ff80',image_posn=none,multiplication_spec=[count=[]],name='Grassland and fooder crops',separate=0],[bounding_box=[ -28.393018, 534.89472, 665.09858, 1041.9431],caption_offset=[ 45.406892, -2.8635342],hide_contents=0,internal_extent=[ -44.927733, 100.4204, 648.56386, 607.46876]]).
links(node00848,[arc00054-arc00053,arc00057-arc00058,arc00272-arc00270,arc00901-arc00955,arc00954-arc00900,arc00958-arc00898,arc01218-arc01212,arc01438-arc01437,arc01615-arc01614,arc01620-arc01619,arc01620-arc01622]).
references(node00848,[obsolete]).
node(node00036,variable,[],[complete=true,name='surf where\nch apply bis'],[bounding_box=[ 570.77563, 467.83987, 585.77563, 482.83987],caption_offset=[0,0]]).
node(node00037,function,[],[comment='European surface of grasslands that may potentially disapear in a second time (square meters)',complete=true,name=fn8,spec='sum([modifiable_surface_bis])',units=1,value=sum([modifiable_surface_bis])],[]).
node(node00038,variable,[],[complete=true,name='change\ncoef bis'],[bounding_box=[ 432.14455, 466.74225, 447.14455, 481.74225],caption_offset=[0,0]]).
node(node00039,function,[],[comment='Part of the "modifiable" surface of grasslands that will remain unchanged at the time of simulation',complete=true,name=fn9,spec='if surf_where_ch_apply_bis>exp_change_bis then(surf_where_ch_apply_bis-exp_change_bis)/surf_where_ch_apply_bis else 0',units=1,value=(if surf_where_ch_apply_bis>exp_change_bis then(surf_where_ch_apply_bis-exp_change_bis)/surf_where_ch_apply_bis else 0)],[]).
node(node00042,variable,[],[name=var21],[]).
node(node00044,variable,[],[name=var23],[]).
node(node00204,variable,[],[complete=true,name='GFC abs\nadjusted'],[bounding_box=[ 477.12471, 190.92895, 492.12471, 205.92895],caption_offset=[ -38.567162, -27.768357]]).
node(node00221,function,[],[comment='European surface of grasslands in 2005 (square meters)',complete=true,name=fn3,spec='sum([GFC_adjusted])',units=1,value=sum(['GFC_adjusted'])],[]).
node(node00311,variable,[],[name=var53],[]).
node(node00869,variable,[],[complete=true,name='GFC surf\nexpected'],[bounding_box=[ 351.98292, 268.84318, 366.98292, 283.84318],caption_offset=[ -36.860289, -43.985461]]).
node(node00870,function,[],[comment='Expected european surface of grasslands at the time of simulation (square meters)',complete=true,name=fn6,spec='Surface_change*GFC_ini_abs',units=1,value='Surface_change'*'GFC_ini_abs'],[]).
node(node00873,variable,[],[complete=true,name='Temp\nGFC surface'],[bounding_box=[ 552.32434, 398.2128, 567.32434, 413.2128],caption_offset=[0,0]]).
node(node00874,variable,[],[complete=true,name='Surface where\nchanges apply'],[bounding_box=[ 541.64118, 270.07498, 556.64118, 285.07498],caption_offset=[ -12.700064, -48.884977]]).
node(node00875,function,[],[comment='European surface of grasslands that may potentially disapear in a first time (square meters)',complete=true,name=fn14,spec='sum([modifiable_surface])',units=1,value=sum([modifiable_surface])],[]).
node(node00876,function,[],[comment='Surface of grassland after that grassland have been decreased in less profitable areas',complete=true,name=fn1,spec='sum([GFC_surface_abs_ite1])',units=1,value=sum(['GFC_surface_abs_ite1'])],[]).
node(node00877,variable,[],[complete=true,name='Expected\nchange_abs'],[bounding_box=[ 445.51677, 268.09029, 460.51677, 283.09029],caption_offset=[ -4.6409654, 1.5774192]]).
node(node00878,function,[],[comment='Difference between the current grassland surface (at the time of simulation) and the 2005 situation (square meters)',complete=true,name=fn16,spec='if GFC_abs_adjusted-GFC_surf_expected <0 then 0\nelse (GFC_abs_adjusted-GFC_surf_expected)*dt()',units=1,value=(if 'GFC_abs_adjusted'-'GFC_surf_expected'<0 then 0 else('GFC_abs_adjusted'-'GFC_surf_expected')*dt(''))],[]).
node(node00879,variable,[],[complete=true,name='Change\ncoefficient'],[bounding_box=[ 540.85885, 325.59199, 555.85885, 340.59199],caption_offset=[0,0]]).
node(node00880,function,[],[comment='Part of the "modifiable" surface of grasslands that will remain unchanged at the time of simulation',complete=true,name=fn17,spec='if Surface_where_changes_apply>Expected_change_abs then(Surface_where_changes_apply-Expected_change_abs)/Surface_where_changes_apply else 0',units=1,value=(if 'Surface_where_changes_apply'>'Expected_change_abs' then('Surface_where_changes_apply'-'Expected_change_abs')/'Surface_where_changes_apply' else 0)],[]).
node(node00883,variable,[],[complete=true,name='exp change\nbis'],[bounding_box=[ 356.42222, 423.9846, 371.42222, 438.9846],caption_offset=[ -12.341492, -1.5426865]]).
node(node00884,function,[],[comment='Remaining difference between the current grassland surface (at the time of simulation) and the 2005 situation after that grassland have been decreased in less profitable areas (square meters)',complete=true,name=fn7,spec='if Change_coefficient!=0 then 0 else Expected_change_abs-(Surface_where_changes_apply-Temp_GFC_surface)',units=1,value=(if 'Change_coefficient' '!=' 0 then 0 else 'Expected_change_abs'-('Surface_where_changes_apply'-'Temp_GFC_surface'))],[]).
node(node00887,variable,[],[name=var10],[]).
node(node00889,variable,[],[name=var8],[]).
node(node00890,variable,[],[name=var11],[]).
node(node00893,variable,[],[complete=true,name='Surface\nchange'],[bounding_box=[ 241.25908, 364.04345, 256.25908, 379.04345],caption_offset=[ -0.15833006, 1.1622238]]).
node(node00894,function,[],[comment='Expected surface change of grasslands (surface at time(t+1) / surface at time (t0))',complete=true,name='Surface\nchange_0',spec='Demand_ratio*Productivity_ratio_2005*Oversupply_ratio',units=1,value='Demand_ratio'*'Productivity_ratio_2005'*'Oversupply_ratio'],[]).
node(node00895,variable,[],[complete=true,name='Demand\nratio',param_type=file,units=1],[bounding_box=[ 172.29217, 441.10728, 187.29217, 456.10728],caption_offset=[ 23.541951, 1.5694634]]).
node(node00897,variable,[],[comment='\'Demand of grasslands\' data (GINFORS)',complete=true,name='Demand_data',param_type=file,spec='makearray(1.0,76)',units=array(1,76),value=makearray( 1.0,76)],[bounding_box=[ 99.838356, 517.77568, 114.83836, 532.77568],caption_offset=[ 0.0, 4.7083901]]).
node(node00899,function,[],[comment='Relative importance of the demand for grassland at the time of simulation + 1 compared to the 2005 demand',complete=true,name='Demand\nratio_0',spec='if time()<75 then element([Demand_data],time()+2)+(element([Demand_data],time()+3)-element([Demand_data],time()+2))*(time()-int(time()))\nelse\nelement([Demand_data],76)',units=1,value=(if time('')<75 then element(['Demand_data'],time('')+2)+(element(['Demand_data'],time('')+3)-element(['Demand_data'],time('')+2))*(time('')-int(time('')))else element(['Demand_data'],76))],[]).
node(node01004,variable,[],[complete=true,name='Actual\nYield'],[bounding_box=[ 67.76132, 248.58486, 82.76132, 263.58486],caption_offset=[ 0.0, -47.083901]]).
node(node01005,function,[],[comment='Predicted actual yield at time t+1timestep',complete=true,name=fn5,spec='sum([Weighted_actual_yield])/sum([GFC_surf_ini])',units=1,value=sum(['Weighted_actual_yield'])/sum(['GFC_surf_ini'])],[]).
node(node01028,variable,[],[name=var48],[]).
node(node01256,variable,[],[complete=true,name='GFC\nini_abs'],[bounding_box=[ 351.8018, 136.42558, 366.8018, 151.42558],caption_offset=[ 1.5694634, -48.653365]]).
node(node01257,function,[],[comment='Area of grasslands in 2005 (square meters)',complete=true,name=fn10,spec='sum([GFC_ini_abs])',units=1,value=sum(['GFC_ini_abs'])],[]).
node(node01264,variable,[],[name=var86],[]).
node(node01438,variable,[],[complete=true,name='Actual yield\n2000'],[bounding_box=[ 72.13101399999999, 341.80882, 87.13101399999999, 356.80882],caption_offset=[0,0]]).
node(node01439,function,[],[comment='Actual yield in 2000',complete=true,name=fn21,spec='sum([Yield_2000_weighted])/sum([GFC_surf_ini])',units=1,value=sum(['Yield_2000_weighted'])/sum(['GFC_surf_ini'])],[]).
node(node01442,variable,[],[name=var59],[]).
node(node01446,variable,[],[name=var66],[]).
node(node01448,variable,[],[name=var68],[]).
node(node01449,variable,[],[complete=true,name='Productivity\nratio 2000'],[bounding_box=[ 156.6149, 251.49846, 171.6149, 266.49846],caption_offset=[ 0.0, -50.222828]]).
node(node01450,function,[],[comment='Relative importance of the 2000 yield compared to the yield at time t+1timestep',complete=true,name=fn22,spec='Actual_yield_2000/Actual_Yield',units=1,value='Actual_yield_2000'/'Actual_Yield'],[]).
node(node01451,variable,[],[comment='Oversupply data (GINFORS)',complete=true,name='Oversupply\ndata',param_type=file,spec='makearray(1.0,76)',units=array(1,76),value=makearray( 1.0,76)],[bounding_box=[ 19.692741, 429.20594, 34.692741, 444.20594],caption_offset=[0,0]]).
node(node01453,variable,[],[complete=true,name='Oversupply\nratio'],[bounding_box=[ 108.54648, 404.44342, 123.54648, 419.44342],caption_offset=[0,0]]).
node(node01454,function,[],[comment='Relative importance of the oversupply at the time of simulation + 1 compared to the 2005 oversupply',complete=true,name=fn24,spec='if time()<75 then element([Oversupply_data],time()+2)+(element([Oversupply_data],time()+3)-element([Oversupply_data],time()+2))*(time()-int(time()))\nelse\nelement([Oversupply_data],76)',units=1,value=(if time('')<75 then element(['Oversupply_data'],time('')+2)+(element(['Oversupply_data'],time('')+3)-element(['Oversupply_data'],time('')+2))*(time('')-int(time('')))else element(['Oversupply_data'],76))],[]).
node(node01570,variable,[],[complete=true,name='Productivity\nratio 2005'],[bounding_box=[ 194.48699, 299.56688, 209.48699, 314.56688],caption_offset=[ -28.701834, 3.0212457]]).
node(node01571,function,[],[comment='Relative importance of the 2005 yield compared to the yield at time t+1timestep',complete=true,name=fn10,spec='Productivity_ratio_2000/ratio_2005_2000',units=1,value='Productivity_ratio_2000'/ratio_2005_2000],[]).
node(node01572,compartment,[],[complete=true,name='ratio\n2005-2000'],[bounding_box=[ 230.0554, 193.01681, 270.0554, 223.01681],caption_offset=[ 0.27002077, -64.091222]]).
node(node01573,function,[],[comment='Relative importance of the 2000 yield compared to the 2005 yield',complete=true,name=fn2,spec='Productivity_ratio_2000+((1-Productivity_ratio_2000)/6)',units=1,value='Productivity_ratio_2000'+(1-'Productivity_ratio_2000')/6],[]).
node(node00849,submodel,[node00007,node00014,node00026,node00027,node00340,node00392,node00459,node00474,node00566,node00861,node00909,node00910,node00912,node00915,node00916,node00918,node00919,node00921,node00922,node00924,node00926,node00929,node00930,node00935,node00936,node00938,node00939,node00940,node00942,node00944,node00987,node01009,node01068,node01189,node01193,node01241,node01249,node01250,node01254,node01288,node01319,node01328,node01331,node01332,node01351,node01401,node01402,node01403,node01565],[complete=true,enum_types=[],fill_colour='#ffff80',image_posn=none,multiplication_spec=[count=[]],name='Food crops',separate=0],[bounding_box=[ -24.430994, 9.3461389, 662.72195, 501.75937],caption_offset=[ 35.800142, -1.4317671],hide_contents=0,internal_extent=[ -9.0000012, 118.44444, 703.62913, 629.11389]]).
links(node00849,[arc00410-arc00416,arc00461-arc00457,arc00851-arc00686,arc00892-arc00907,arc00985-arc00984,arc01112-arc01076,arc01239-arc01238,arc01426-arc01425,arc01482-arc01481,arc01519-arc01494,arc01519-arc01518]).
node(node00007,variable,[],[complete=true,name='surf where\nch apply bis'],[bounding_box=[ 612.68188, 482.84541, 627.68188, 497.84541],caption_offset=[ 4.6865065, 0.0]]).
node(node00014,function,[],[comment='European surface of croplands that may potentially disapear in a second time (square meters)',complete=true,name=fn3,spec='sum([modifiable_surface_bis])',units=1,value=sum([modifiable_surface_bis])],[]).
node(node00026,variable,[],[complete=true,name='Change\ncoef bis'],[bounding_box=[ 487.98026, 534.61896, 502.98026, 549.61896],caption_offset=[ 2.9696997, 0.0]]).
node(node00027,function,[],[comment='Part of the "modifiable" surface of croplands that will remain unchanged at the time of simulation',complete=true,name=fn8,spec='if surf_where_ch_apply_bis>exp_change_bis then(surf_where_ch_apply_bis-exp_change_bis)/surf_where_ch_apply_bis else 0',units=1,value=(if surf_where_ch_apply_bis>exp_change_bis then(surf_where_ch_apply_bis-exp_change_bis)/surf_where_ch_apply_bis else 0)],[]).
node(node00340,variable,[],[name=var14],[]).
node(node00392,variable,[],[complete=true,name='Expected\nchange'],[bounding_box=[ 479.05537, 301.77311, 494.05537, 316.77311],caption_offset=[0,0]]).
node(node00459,function,[],[complete=true,name=fn11,spec='if Food_crops_abs_adjusted-FC_surf_expected <0 then 0\nelse (Food_crops_abs_adjusted-FC_surf_expected)*dt()',units=1,value=(if 'Food_crops_abs_adjusted'-'FC_surf_expected'<0 then 0 else('Food_crops_abs_adjusted'-'FC_surf_expected')*dt(''))],[]).
node(node00474,variable,[],[name=var49],[]).
node(node00566,variable,[],[comment='Oversupply data (GINFORS)',complete=true,name='Oversupply\ndata',param_type=file,spec='makearray(1.0,76)',units=array(1,76),value=makearray( 1.0,76)],[bounding_box=[ 58.717289, 424.6519, 73.71728899999999, 439.6519],caption_offset=[ 0.0, 4.5318685]]).
node(node00861,variable,[],[name=var17],[]).
node(node00909,variable,[],[complete=true,name='Actual\nYield'],[bounding_box=[ 117.63174, 252.44085, 132.63174, 267.44085],caption_offset=[ 1.5106228, -48.339931]]).
node(node00910,function,[],[comment='Predicted actual yield at time t+1timestep',complete=true,name=fn5,spec='sum([Weighted_actual_yield])/sum([FC_surf_ini])',units=1,value=sum(['Weighted_actual_yield'])/sum(['FC_surf_ini'])],[]).
node(node00912,variable,[],[name=var19],[]).
node(node00915,variable,[],[complete=true,name='FC surf\nexpected'],[bounding_box=[ 412.21531, 293.99881, 431.71531, 313.49881],caption_offset=[ -41.418308, -41.435207]]).
node(node00916,function,[],[comment='Expected european surface of croplands at the time of simulation (square meters)',complete=true,name=fn6,spec='Surface_change*food_crops_ini_abs',units=1,value='Surface_change'*food_crops_ini_abs],[]).
node(node00918,variable,[],[complete=true,name='Food crops\nabs adjusted'],[bounding_box=[ 577.65832, 202.89778, 597.15832, 222.39778],caption_offset=[ -57.728732, -29.671223]]).
node(node00919,function,[],[comment='European surface of croplands in 2005 (square meters)',complete=true,name=fn4,spec='sum([FC_adjusted])',units=1,value=sum(['FC_adjusted'])],[]).
node(node00921,variable,[],[complete=true,name='Temp\nFC surface'],[bounding_box=[ 601.0997, 416.26656, 620.5997, 435.76656],caption_offset=[0,0]]).
node(node00922,variable,[],[complete=true,name='Surface where\nchanges apply'],[bounding_box=[ 600.08669, 284.90586, 619.58669, 304.40586],caption_offset=[ -3.6929919, -48.165165]]).
node(node00924,function,[],[comment='European surface of croplands that may potentially disapear in a first time (square meters)',complete=true,name=fn14,spec='sum([modifiable_surface])',units=1,value=sum([modifiable_surface])],[]).
node(node00926,function,[],[comment='Surface of cropland after that cropland have been decreased in less profitable areas',complete=true,name=fn1,spec='sum([FC_surface_abs_ite1])',units=1,value=sum(['FC_surface_abs_ite1'])],[]).
node(node00929,variable,[],[complete=true,name='Change\ncoefficient'],[bounding_box=[ 601.43448, 340.95169, 620.93448, 360.45169],caption_offset=[ 3.0212457, 1.5106228]]).
node(node00930,function,[],[comment='Part of the "modifiable" surface of croplands that will remain unchanged at the time of simulation',complete=true,name=fn17,units=1,value=(if 'Surface_where_changes_apply'>'Expected_change_0' then('Surface_where_changes_apply'-'Expected_change_0')/'Surface_where_changes_apply' else 0)],[]).
node(node00935,variable,[],[complete=true,name='exp change\nbis'],[bounding_box=[ 412.5829, 431.11506, 432.0829, 450.61506],caption_offset=[0,0]]).
node(node00936,function,[],[comment='Remaining difference between the current cropland surface (at the time of simulation) and the 2005 situation after that cropland have been decreased in less profitable areas (square meters)',complete=true,name=fn7,spec='if Change_coefficient!=0 then 0 else Expected_change-(Surface_where_changes_apply-Temp_FC_surface)',units=1,value=(if 'Change_coefficient' '!=' 0 then 0 else 'Expected_change'-('Surface_where_changes_apply'-'Temp_FC_surface'))],[]).
node(node00938,variable,[],[complete=true,name='Surface\nchange'],[bounding_box=[ 276.09132, 358.09531, 291.09132, 373.09531],caption_offset=[ 33.075372, -6.3908904]]).
node(node00939,function,[],[comment='Expected surface change of croplands (surface at time(t+1) / surface at time (t0))',complete=true,name='Surface\nchange_0',spec='Demand_ratio*Productivity_ratio_2005*oversupply_ratio',units=1,value='Demand_ratio'*'Productivity_ratio_2005'*oversupply_ratio],[]).
node(node00940,variable,[],[complete=true,name='Demand\nratio',param_type=file,units=1],[bounding_box=[ 230.58179, 448.05554, 245.58179, 463.05554],caption_offset=[ 39.276194, -16.616851]]).
node(node00942,variable,[],[comment='\'Demand of foodcrops\' data (GINFORS)',complete=true,name='Demand_data',param_type=file,spec='makearray(1.0,76)',units=array(1,76),value=makearray( 1.0,76)],[bounding_box=[ 178.294, 541.1405, 193.294, 556.1405],caption_offset=[ 3.0212457, 6.0424913]]).
node(node00944,function,[],[comment='Relative importance of the demand for foodcrops at the time of simulation + 1 compared to the 2005 demand',complete=true,name='Demand\nratio_0',spec='if time()<75 then element([Demand_data],time()+2)+(element([Demand_data],time()+3)-element([Demand_data],time()+2))*(time()-int(time()))\nelse\nelement([Demand_data],76)',units=1,value=(if time('')<75 then element(['Demand_data'],time('')+2)+(element(['Demand_data'],time('')+3)-element(['Demand_data'],time('')+2))*(time('')-int(time('')))else element(['Demand_data'],76))],[]).
node(node00987,variable,[],[name=var36],[]).
node(node01009,variable,[],[name=var60],[]).
node(node01068,variable,[],[name=var67],[]).
node(node01189,variable,[],[complete=true,name='oversupply\nratio'],[bounding_box=[ 146.33342, 400.48193, 161.33342, 415.48193],caption_offset=[0,0]]).
node(node01193,function,[],[comment='Relative importance of the oversupply at the time of simulation + 1 compared to the 2005 oversupply',complete=true,name=fn13,spec='if time()<75 then element([Oversupply_data],time()+2)+(element([Oversupply_data],time()+3)-element([Oversupply_data],time()+2))*(time()-int(time()))\nelse\nelement([Oversupply_data],76)',units=1,value=(if time('')<75 then element(['Oversupply_data'],time('')+2)+(element(['Oversupply_data'],time('')+3)-element(['Oversupply_data'],time('')+2))*(time('')-int(time('')))else element(['Oversupply_data'],76))],[]).
node(node01241,variable,[],[complete=true,name='Actual yield\n2000'],[bounding_box=[ 117.63158, 334.01453, 132.63158, 349.01453],caption_offset=[0,0]]).
node(node01249,variable,[],[complete=true,name='food crops\nini abs'],[bounding_box=[ 418.24552, 173.88851, 433.24552, 188.88851],caption_offset=[ 7.5531142, -49.850553]]).
node(node01250,function,[],[comment='Area of foodcrops in 2005 (square meters)',complete=true,name=fn9,spec='sum([food_crops_ini_abs])',units=1,value=sum([food_crops_ini_abs])],[]).
node(node01254,variable,[],[name=var77],[]).
node(node01288,function,[],[comment='Actual yield in 2000',complete=true,name=fn12,spec='sum([yield_2000_weighted])/sum([FC_surf_ini])',units=1,value=sum([yield_2000_weighted])/sum(['FC_surf_ini'])],[]).
node(node01319,variable,[],[name=var28],[]).
node(node01328,variable,[],[name=var31],[]).
node(node01331,variable,[],[complete=true,name='Productivity\nratio 2000'],[bounding_box=[ 200.71584, 253.95152, 215.71584, 268.95152],caption_offset=[ 10.57436, -52.871799]]).
node(node01332,function,[],[comment='Relative importance of the 2000 yield compared to the yield at time t+1timestep',complete=true,name=fn15,spec='Actual_yield_2000/Actual_Yield',units=1,value='Actual_yield_2000'/'Actual_Yield'],[]).
node(node01351,variable,[],[name=var103],[]).
node(node01401,compartment,[],[complete=true,name='ratio\n2005-2000'],[bounding_box=[ 307.55504, 192.0691, 347.55504, 222.0691],caption_offset=[ 3.0212457, -66.467405]]).
node(node01402,function,[],[comment='Relative importance of the 2000 yield compared to the 2005 yield',complete=true,name=fn2,spec='Productivity_ratio_2000+((1-Productivity_ratio_2000)/6)',units=1,value='Productivity_ratio_2000'+(1-'Productivity_ratio_2000')/6],[]).
node(node01403,variable,[],[complete=true,name='Productivity\nratio 2005'],[bounding_box=[ 239.99203, 297.75958, 254.99203, 312.75958],caption_offset=[ -28.701834, 3.0212457]]).
node(node01565,function,[],[comment='Relative importance of the 2005 yield compared to the yield at time t+1timestep',complete=true,name=fn10,spec='Productivity_ratio_2000/ratio_2005_2000',units=1,value='Productivity_ratio_2000'/ratio_2005_2000],[]).
node(node00855,variable,[],[name=var10],[]).
node(node00856,variable,[],[name=var12],[]).
node(node00859,variable,[],[name=var11],[]).
node(node00860,submodel,[node00050,node00051,node00054,node00056,node00057,node00058,node00370,node00371,node00374,node00961,node00962,node00965,node00966,node00967,node00968,node00969,node00970,node00971,node00972,node00973,node00976,node00977,node00980,node00982,node00984,node00985,node00986,node00988,node00990,node01006,node01011,node01058,node01266,node01267,node01273,node01479,node01480,node01483,node01487,node01489,node01490,node01491,node01492,node01494,node01495,node01574,node01575,node01576,node01586],[complete=true,enum_types=[],fill_colour='#ff8000',image_posn=none,multiplication_spec=[count=[]],name='Permanent crops',separate=0],[bounding_box=[ -20.411253, 1088.5758, 667.19485, 1552.0255],caption_offset=[ 35.482306, 1.6647444],hide_contents=0,internal_extent=[ -53.517313, 5.1288199, 634.08879, 468.57852]]).
links(node00860,[arc00069-arc00068,arc00074-arc00075,arc00394-arc00392,arc00967-arc01007,arc01009-arc01001,arc01011-arc01003,arc01233-arc01232,arc01447-arc01446,arc01662-arc01661,arc01667-arc01666,arc01667-arc01669]).
references(node00860,[obsolete]).
node(node00050,variable,[],[complete=true,name='surf where\nch apply bis'],[bounding_box=[ 543.58064, 372.18232, 558.58064, 387.18232],caption_offset=[0,0]]).
node(node00051,function,[],[comment='European surface of permanent crops that may potentially disapear in a second time (square meters)',complete=true,name=fn5,spec='sum([modifiable_surface_bis])',units=1,value=sum([modifiable_surface_bis])],[]).
node(node00054,variable,[],[name=var24],[]).
node(node00056,variable,[],[complete=true,name='change\ncoef bis'],[bounding_box=[ 418.54472, 389.81086, 433.54472, 404.81086],caption_offset=[ -14.382494, -1.5980548]]).
node(node00057,function,[],[comment='Part of the "modifiable" surface of permanent crops that will remain unchanged at the time of simulation',complete=true,name=fn8,spec='if surf_where_ch_apply_bis>exp_change_bis then(surf_where_ch_apply_bis-exp_change_bis)/surf_where_ch_apply_bis else 0',units=1,value=(if surf_where_ch_apply_bis>exp_change_bis then(surf_where_ch_apply_bis-exp_change_bis)/surf_where_ch_apply_bis else 0)],[]).
node(node00058,variable,[],[name=var28],[]).
node(node00370,variable,[],[complete=true,name='PC abs\nadjusted'],[bounding_box=[ 477.24717, 103.45744, 492.24717, 118.45744],caption_offset=[ -44.745536, -28.764987]]).
node(node00371,function,[],[comment='European surface of permanent crops in 2005 (square meters)',complete=true,name=fn9,spec='sum([PC_adjusted])',units=1,value=sum(['PC_adjusted'])],[]).
node(node00374,variable,[],[name=var12],[]).
node(node00961,variable,[],[complete=true,name='PC surf\nexpected'],[bounding_box=[ 342.13646, 190.4942, 357.13646, 205.4942],caption_offset=[ -35.094493, -44.916851]]).
node(node00962,function,[],[comment='Expected european surface of permanent crops at the time of simulation (square meters)',complete=true,name=fn6,spec='Surface_change*PC_ini_abs',units=1,value='Surface_change'*'PC_ini_abs'],[]).
node(node00965,variable,[],[complete=true,name='Temp\nPC surface'],[bounding_box=[ 545.4414399999999, 303.48119, 560.4414399999999, 318.48119],caption_offset=[0,0]]).
node(node00966,variable,[],[complete=true,name='Surface where\nchanges apply'],[bounding_box=[ 532.2707799999999, 164.07256, 547.2707799999999, 179.07256],caption_offset=[ -4.5360573, -49.549397]]).
node(node00967,variable,[],[name=var7],[]).
node(node00968,function,[],[comment='European surface of permanent crops that may potentially disapear in a first time (square meters)',complete=true,name=fn14,spec='sum([modifiable_surface])',units=1,value=sum([modifiable_surface])],[]).
node(node00969,function,[],[comment='Surface of permanent crops after that permanent crops have been decreased in less profitable areas',complete=true,name=fn1,spec='sum([PC_surface_abs_ite1])',units=1,value=sum(['PC_surface_abs_ite1'])],[]).
node(node00970,variable,[],[complete=true,name='Expected\nchange_abs'],[bounding_box=[ 424.56485, 185.34707, 439.56485, 200.34707],caption_offset=[ -4.8496405, 8.458931099999999]]).
node(node00971,function,[],[comment='Difference between the current permanent crop surface (at the time of simulation) and the 2005 situation (square meters)',complete=true,name=fn16,spec='if PC_abs_adjusted-PC_surf_expected <0 then 0\nelse (PC_abs_adjusted-PC_surf_expected)*dt()',units=1,value=(if 'PC_abs_adjusted'-'PC_surf_expected'<0 then 0 else('PC_abs_adjusted'-'PC_surf_expected')*dt(''))],[]).
node(node00972,variable,[],[complete=true,name='Change\ncoefficient'],[bounding_box=[ 532.42088, 224.35281, 547.42088, 239.35281],caption_offset=[0,0]]).
node(node00973,function,[],[comment='Part of the "modifiable" surface of permanent crops that will remain unchanged at the time of simulation',complete=true,name=fn17,spec='if Surface_where_changes_apply>Expected_change_abs then(Surface_where_changes_apply-Expected_change_abs)/Surface_where_changes_apply else 0',units=1,value=(if 'Surface_where_changes_apply'>'Expected_change_abs' then('Surface_where_changes_apply'-'Expected_change_abs')/'Surface_where_changes_apply' else 0)],[]).
node(node00976,variable,[],[complete=true,name='exp change\nbis'],[bounding_box=[ 373.43392, 347.71686, 388.43392, 362.71686],caption_offset=[ -22.372768, 0.0]]).
node(node00977,function,[],[comment='Remaining difference between the current permanent crop surface (at the time of simulation) and the 2005 situation after that permanent crop have been decreased in less profitable areas (square meters)',complete=true,name=fn7,spec='if Change_coefficient!=0 then 0 else Expected_change_abs-(Surface_where_changes_apply-Temp_PC_surface)',units=1,value=(if 'Change_coefficient' '!=' 0 then 0 else 'Expected_change_abs'-('Surface_where_changes_apply'-'Temp_PC_surface'))],[]).
node(node00980,variable,[],[name=var20],[]).
node(node00982,variable,[],[name=var30],[]).
node(node00984,variable,[],[complete=true,name='Surface\nchange'],[bounding_box=[ 234.71035, 271.01654, 249.71035, 286.01654],caption_offset=[ 12.848012, 2.7880166]]).
node(node00985,function,[],[comment='Expected surface change of permanent crops (surface at time(t+1) / surface at time (t0))',complete=true,name='Surface\nchange_0',spec='Demand_ratio*Productivity_ratio_2005*Oversupply_ratio',units=1,value='Demand_ratio'*'Productivity_ratio_2005'*'Oversupply_ratio'],[]).
node(node00986,variable,[],[complete=true,name='Demand\nratio',param_type=file,units=1],[bounding_box=[ 150.40815, 341.25626, 165.40815, 356.25626],caption_offset=[ 19.509513, 1.6257928]]).
node(node00988,variable,[],[comment='\'Demand of permanent crops\' data (GINFORS)',complete=true,name='Demand_data',param_type=file,spec='makearray(1.0,76)',units=array(1,76),value=makearray( 1.0,76)],[bounding_box=[ 65.65309000000001, 407.74675, 80.65309000000001, 422.74675],caption_offset=[0,0]]).
node(node00990,function,[],[comment='Relative importance of the demand for permanent crops at the time of simulation + 1 compared to the 2005 demand',complete=true,name='Demand\nratio_0',spec='if time()<75 then element([Demand_data],time()+2)+(element([Demand_data],time()+3)-element([Demand_data],time()+2))*(time()-int(time()))\nelse\nelement([Demand_data],76)',units=1,value=(if time('')<75 then element(['Demand_data'],time('')+2)+(element(['Demand_data'],time('')+3)-element(['Demand_data'],time('')+2))*(time('')-int(time('')))else element(['Demand_data'],76))],[]).
node(node01006,variable,[],[complete=true,name='Actual\nYield'],[bounding_box=[ 55.559813, 140.01737, 70.55981300000001, 155.01737],caption_offset=[ -3.2515856, -52.025369]]).
node(node01011,function,[],[comment='Predicted actual yield at time t+1timestep',complete=true,name=fn5,spec='sum([Weighted_actual_yield])/sum([PC_surf_ini])',units=1,value=sum(['Weighted_actual_yield'])/sum(['PC_surf_ini'])],[]).
node(node01058,variable,[],[name=var54],[]).
node(node01266,variable,[],[complete=true,name='PC ini_abs'],[bounding_box=[ 343.97017, 42.424608, 358.97017, 57.424608],caption_offset=[ 1.6257928, -35.767441]]).
node(node01267,function,[],[comment='Area of permanent crops in 2005 (square meters)',complete=true,name=fn18,spec='sum([PC_ini_abs])',units=1,value=sum(['PC_ini_abs'])],[]).
node(node01273,variable,[],[name=var94],[]).
node(node01479,variable,[],[complete=true,name='Actual yield\n2000'],[bounding_box=[ 51.189812, 230.32842, 66.189812, 245.32842],caption_offset=[ 0.0, 3.2515856]]).
node(node01480,function,[],[comment='Actual yield in 2000',complete=true,name=fn19,spec='sum([Yield_2000_weighted])/sum([PC_surf_ini])',units=1,value=sum(['Yield_2000_weighted'])/sum(['PC_surf_ini'])],[]).
node(node01483,variable,[],[name=var96],[]).
node(node01487,variable,[],[name=var100],[]).
node(node01489,variable,[],[name=var102],[]).
node(node01490,variable,[],[complete=true,name='Productivity\nratio 2000'],[bounding_box=[ 135.67369, 182.26, 150.67369, 197.26],caption_offset=[ 0.0, -50.222828]]).
node(node01491,function,[],[comment='Relative importance of the 2000 yield compared to the yield at time t+1timestep',complete=true,name=fn22,spec='Actual_yield_2000/Actual_Yield',units=1,value='Actual_yield_2000'/'Actual_Yield'],[]).
node(node01492,variable,[],[comment='Oversupply data (GINFORS)',complete=true,name='Oversupply\ndata',param_type=file,spec='makearray(1.0,76)',units=array(1,76),value=makearray( 1.0,76)],[bounding_box=[ 3.1213949, 325.00864, 18.121395, 340.00864],caption_offset=[0,0]]).
node(node01494,variable,[],[complete=true,name='Oversupply\nratio'],[bounding_box=[ 97.801614, 297.33289, 112.80161, 312.33289],caption_offset=[0,0]]).
node(node01495,function,[],[comment='Relative importance of the oversupply at the time of simulation + 1 compared to the 2005 oversupply',complete=true,name=fn24,spec='if time()<75 then element([Oversupply_data],time()+2)+(element([Oversupply_data],time()+3)-element([Oversupply_data],time()+2))*(time()-int(time()))\nelse\nelement([Oversupply_data],76)',units=1,value=(if time('')<75 then element(['Oversupply_data'],time('')+2)+(element(['Oversupply_data'],time('')+3)-element(['Oversupply_data'],time('')+2))*(time('')-int(time('')))else element(['Oversupply_data'],76))],[]).
node(node01574,compartment,[],[complete=true,name='ratio\n2005-2000'],[bounding_box=[ 223.68039, 113.58201, 263.68039, 143.58201],caption_offset=[ -1.186598, -65.54784100000001]]).
node(node01575,function,[],[comment='Relative importance of the 2000 yield compared to the 2005 yield',complete=true,name=fn2,spec='Productivity_ratio_2000+((1-Productivity_ratio_2000)/6)',units=1,value='Productivity_ratio_2000'+(1-'Productivity_ratio_2000')/6],[]).
node(node01576,variable,[],[complete=true,name='Productivity\nratio 2005'],[bounding_box=[ 185.19873, 217.21885, 200.19873, 232.21885],caption_offset=[ -28.701834, 3.0212457]]).
node(node01586,function,[],[comment='Relative importance of the 2005 yield compared to the yield at time t+1timestep',complete=true,name=fn10,spec='Productivity_ratio_2000/ratio_2005_2000',units=1,value='Productivity_ratio_2000'/ratio_2005_2000],[]).
node(node00863,variable,[],[name=var8],[]).
node(node00865,variable,[],[name=var21],[]).
node(node00867,variable,[],[name=var31],[]).
node(node00911,variable,[],[name=var18],[]).
node(node00913,variable,[],[name=var20],[]).
node(node00989,variable,[],[name=var38],[]).
node(node01022,variable,[],[name=var61],[]).
node(node01042,variable,[],[name=var51],[]).
node(node01061,variable,[],[name=var55],[]).
node(node01072,variable,[],[name=var68],[]).
node(node01176,variable,[],[name=var41],[]).
node(node01188,variable,[],[name=var64],[]).
node(node01255,variable,[],[name=var78],[]).
node(node01265,variable,[],[name=var88],[]).
node(node01274,variable,[],[name=var95],[]).
node(node01327,variable,[],[name=var30],[]).
node(node01352,variable,[],[name=var104],[]).
node(node01443,variable,[],[name=var63],[]).
node(node01447,variable,[],[name=var67],[]).
node(node01484,variable,[],[name=var97],[]).
node(node01488,variable,[],[name=var101],[]).
node(node00846,submodel,[node00041,node00047,node00053,node00061,node00064,node00068,node00072,node00095,node00107,node00108,node00114,node00118,node00126,node00138,node00170,node00182,node00188,node00198,node00210,node00214,node00218,node00225,node00236,node00244,node00246,node00250,node00256,node00260,node00301,node00314,node00319,node00322,node00324,node00328,node00335,node00337,node00373,node00453,node00457,node00460,node00473,node00500,node00518,node00522,node00526,node00530,node00534,node00538,node00626,node00649,node00656,node00673,node00699,node00737,node00750,node00826,node00839,node00842,node00843,node00854,node00882,node00955,node00981,node01013,node01014,node01018,node01019,node01027,node01030,node01032,node01034,node01035,node01063,node01066,node01084,node01089,node01113,node01174,node01183,node01186,node01216,node01253,node01263,node01272,node01303,node01323,node01427,node01470,node01501,node01609,node01613,node01621,node01625,node01633,node01637],[complete=true,enum_types=[],fill_colour='#fff4d5',image_posn=none,multiplication_spec=[count=[58960]],name='Cells',separate=0],[bounding_box=[ 571.31463, -961.36654, 2320.1252, 3489.8786],caption_offset=[ 138.63442, 0.37016644],hide_contents=0,internal_extent=[ -25.613405, -97.668862, 1723.1974, 4353.5769]]).
links(node00846,[arc00017-arc00097,arc00061-arc00382,arc00078-arc00383,arc00089-arc00149,arc00114-arc00107,arc00117-arc00120,arc00123-arc00126,arc00129-arc00384,arc00138-arc00385,arc00145-arc00148,arc00151-arc00150,arc00153-arc00166,arc00193-arc00186,arc00195-arc00199,arc00211-arc00412,arc00228-arc00418,arc00256-arc00279,arc00260-arc00395,arc00267-arc00274,arc00284-arc00283,arc00286-arc00290,arc00298-arc00297,arc00300-arc00304,arc00306-arc00309,arc00347-arc00346,arc00356-arc00355,arc00364-arc00484,arc00380-arc00379,arc00381-arc00393,arc00436-arc00432,arc00438-arc00055,arc00439-arc00163,arc00443-arc01024,arc00444-arc01017,arc00454-arc00489,arc00464-arc00070,arc00478-arc00476,arc00482-arc01026,arc00483-arc01028,arc00538-arc00627,arc00544-arc00547,arc00562-arc00481,arc00569-arc00568,arc00573-arc00572,arc00577-arc00576,arc00581-arc00580,arc00585-arc00584,arc00589-arc00588,arc00609-arc00423,arc00609-arc00424,arc00609-arc00437,arc00616-arc00891,arc00738-arc00741,arc00747-arc00750,arc00776-arc00772,arc00790-arc00811,arc00799-arc01106,arc00873-arc00973,arc00890-arc00889,arc00944-arc00943,arc00945-arc00942,arc01018-arc00488,arc01029-arc00490,arc01030-arc01027,arc01034-arc01049,arc01071-arc01148,arc01087-arc01096,arc01122-arc01121,arc01125-arc01130,arc01143-arc01142,arc01181-arc01184,arc01201-arc01343,arc01217-arc01240,arc01265-arc01266,arc01268-arc00473,arc01353-arc01356,arc01377-arc01381,arc01424-arc01427,arc01436-arc01439,arc01445-arc01448,arc01466-arc01470,arc01485-arc01489,arc01554-arc01557,arc01595-arc01599,arc01645-arc01649,arc01681-arc01680,arc01799-arc01800,arc01807-arc01808,arc01811-arc01812,arc01819-arc01820,arc01823-arc01824]).
references(node00846,[obsolete,obsolete,local(arc01476),local(arc01590),local(arc01637)]).
node(node00041,variable,[],[name=var20],[]).
node(node00047,variable,[],[name=var26],[]).
node(node00053,variable,[],[name=var23],[]).
node(node00061,variable,[],[name=var31],[]).
node(node00064,variable,[],[name=var15],[]).
node(node00068,submodel,[node00011,node00012,node00117,node00132,node00183,node00209,node00233,node00272,node00273,node00274,node00275,node00276,node00277,node00278,node00279,node00280,node00281,node00283,node00284,node00285,node00286,node00287,node00288,node00289,node00290,node00291,node00292,node00293,node00294,node00295,node00296,node00299,node00300,node00302,node00303,node00304,node00305,node00306,node00307,node00308,node00310,node00313,node00318,node00336,node00338,node00339,node00341,node00343,node00347,node00348,node00349,node00352,node00353,node00354,node00355,node00363,node00368,node00372,node00385,node00386,node00389,node00398,node00403,node00419,node00424,node00433,node00437,node00451,node00472,node00478,node00479,node00484,node00485,node00486,node00487,node00488,node00489,node00491,node00494,node00496,node00511,node00578,node00605,node00606,node00607,node00610,node00611,node00612,node00617,node00618,node00619,node00623,node00624,node00643,node00709,node00718,node00947,node00954,node01007,node01008,node01016,node01062,node01065,node01088,node01112,node01137,node01146,node01153,node01158,node01163,node01185,node01205,node01244,node01247,node01252,node01262,node01271,node01302,node01426,node01469,node01500,node01506,node01568,node01608,node01612,node01620,node01624,node01632,node01636],[complete=true,enum_types=[],fill_colour='#f7be09',image_posn=none,multiplication_spec=[count=[]],name='Agriculture and biofuels',separate=0],[bounding_box=[ 178.98576, 693.24222, 1660.5376, 3485.7843],caption_offset=[ 113.18251, -1.3636447],hide_contents=0,internal_extent=[ -1.8421432, -9.0000441, 1484.475, 2792.524]]).
links(node00068,[arc00052-arc00041,arc00052-arc00696,arc00107-arc00507,arc00150-arc00516,arc00186-arc00518,arc00241-arc00260,arc00245-arc00236,arc00245-arc01111,arc00255-arc00252,arc00255-arc01097,arc00257-arc00381,arc00262-arc00267,arc00283-arc00522,arc00297-arc00523,arc00319-arc00318,arc00319-arc01149,arc00323-arc00322,arc00328-arc00327,arc00332-arc00331,arc00336-arc00334,arc00336-arc01151,arc00346-arc00271,arc00355-arc00352,arc00379-arc00524,arc00382-arc00548,arc00383-arc00648,arc00384-arc00565,arc00385-arc00549,arc00412-arc00550,arc00418-arc00551,arc00423-arc00275,arc00423-arc00660,arc00424-arc00552,arc00432-arc00428,arc00437-arc00608,arc00453-arc00454,arc00484-arc00661,arc00485-arc00676,arc00485-arc00729,arc00485-arc01279,arc00486-arc00553,arc00487-arc00613,arc00488-arc00554,arc00490-arc00677,arc00491-arc00448,arc00492-arc00451,arc00493-arc00859,arc00494-arc00953,arc00495-arc01004,arc00496-arc00017,arc00497-arc00117,arc00498-arc00123,arc00499-arc00153,arc00500-arc00195,arc00501-arc00256,arc00502-arc00286,arc00503-arc00300,arc00504-arc00306,arc00521-arc00505,arc00525-arc00438,arc00526-arc00439,arc00527-arc00440,arc00536-arc00443,arc00540-arc00444,arc00559-arc00456,arc00607-arc00616,arc00619-arc00464,arc00622-arc00506,arc00628-arc00472,arc00642-arc00482,arc00647-arc00483,arc00889-arc00659,arc00942-arc00917,arc00943-arc00894,arc01070-arc01071,arc01168-arc01170,arc01180-arc01181,arc01199-arc01201,arc01207-arc01367,arc01216-arc01217,arc01258-arc01265,arc01300-arc01299,arc01300-arc01308,arc01300-arc01314,arc01352-arc01353,arc01416-arc01415,arc01419-arc01418,arc01423-arc01424,arc01435-arc01436,arc01444-arc01445,arc01465-arc01466,arc01553-arc01554,arc01594-arc01595,arc01644-arc01645,arc01680-arc01679,arc01685-arc01684,arc01762-arc01764,arc01798-arc01799,arc01806-arc01807,arc01810-arc01811,arc01818-arc01819,arc01822-arc01823]).
references(node00068,[obsolete,obsolete,ancestor(2),ancestor(3),ancestor(4)]).
node(node00011,variable,[],[name=var4],[bounding_box=[ 1144.5317, 1918.3155, 1159.5317, 1933.3155],caption_offset=[ 46.819146, -21.28143]]).
node(node00012,function,[],[name=fn2],[]).
node(node00117,variable,[],[],[]).
node(node00132,submodel,[node00019,node00032,node00033,node00069,node00070,node00071,node00074,node00083,node00084,node00085,node00087,node00088,node00098,node00099,node00100,node00101,node00102,node00103,node00106,node00109,node00119,node00123,node00137,node00146,node00147,node00148,node00149,node00156,node00169,node00171,node00243,node00245,node00249,node00255,node00257,node00321,node00323,node00327,node00334,node00396,node00397,node00425,node00427,node00553,node00554,node00555,node00562,node00563,node00576,node00577,node00579,node00580,node00581,node00582,node00583,node00584,node00587,node00588,node00589,node00590,node00591,node00592,node00593,node00594,node00595,node00598,node00599,node00600,node00615,node00616,node00622,node00671,node00676,node00681,node00686,node00695,node00696,node00702,node00703,node00704,node00705,node00706,node00707,node00708,node00715,node00716,node00717,node00719,node00720,node00721,node00749,node00774,node00775,node00824,node00825,node01161,node01177,node01178,node01184,node01196,node01243,node01246,node01523,node01527,node01531],[complete=true,enum_types=[],fill_colour='#00a8f9',image_posn=none,multiplication_spec=[count=[]],name='Biofuels',separate=0],[bounding_box=[ 74.523695, 1575.1252, 1072.1214, 2770.5395],caption_offset=[ 97.209447, -2.8042984],hide_contents=0,internal_extent=[ 17.723042, -132.24743, 1015.3208, 1063.1669]]).
links(node00132,[arc00013-arc00496,arc00115-arc00497,arc00122-arc00498,arc00152-arc00499,arc00194-arc00500,arc00200-arc00501,arc00285-arc00502,arc00299-arc00503,arc00305-arc00504,arc00446-arc00491,arc00449-arc00492,arc00505-arc00520,arc00506-arc00621,arc00507-arc00106,arc00516-arc00135,arc00518-arc00180,arc00522-arc00282,arc00523-arc00296,arc00524-arc00378,arc00855-arc00493,arc00864-arc00494,arc00961-arc00495,arc01019-arc00956,arc01038-arc01040,arc01044-arc01041,arc01062-arc01052,arc01065-arc01064,arc01074-arc01069,arc01093-arc01092,arc01153-arc01152,arc01155-arc01154,arc01157-arc01156,arc01159-arc01158,arc01167-arc01168,arc01175-arc01180,arc01198-arc01199,arc01206-arc01207,arc01351-arc01352,arc01415-arc01414,arc01418-arc01417]).
references(node00132,[obsolete,obsolete,ancestor(2),ancestor(3),ancestor(4)]).
node(node00019,compartment,[],[complete=true,name='liquid\narea'],[bounding_box=[ 225.66578, 160.04751, 265.66578, 190.04751],caption_offset=[ 9.9998942e-09, -30.000184]]).
node(node00032,function,[],[comment='surface of liquid biofuels (square meters)',complete=true,name=fn1,spec='dens_liquid_2005*rent_liquid_area_2005',units=1,value=dens_liquid_2005*rent_liquid_area_2005],[]).
node(node00033,compartment,[],[complete=true,name='NW\narea'],[bounding_box=[ 227.39655, 481.96472, 267.39655, 511.96472],caption_offset=[ 9.9998942e-09, -28.636539]]).
node(node00069,function,[],[comment='Surface of non woody biofuels (square meters)',complete=true,name=fn2,spec='rent_NW_area_2005*dens_non_woody_2005',units=1,value=rent_NW_area_2005*dens_non_woody_2005],[]).
node(node00070,compartment,[],[complete=true,name='woody\narea'],[bounding_box=[ 230.64407, 813.27575, 270.64407, 843.27575],caption_offset=[ 1.3636447, -30.000184]]).
node(node00071,variable,[],[name=var1],[]).
node(node00074,function,[],[comment='Surface of woody biofuels (square meters)',complete=true,name=fn3,spec='dens_woody_2005*rent_woody_area_2005',units=1,value=dens_woody_2005*rent_woody_area_2005],[]).
node(node00083,variable,[],[comment='Suitability of the cell for liquid biofuels\n1 : suitable\n0 or -1 : not suitable',complete=true,name='rentability\nliquid',param_type=file,units=1],[bounding_box=[ 285.51375, 30.763433, 300.51375, 45.763433],caption_offset=[ 36.924171, -28.636538]]).
node(node00084,variable,[],[comment='Surplus land in 2005 (areas abandoned by agriculture between 2000 and 2005) (part of the cell)',complete=true,name='surplus_ini\n2005_rel',param_type=file,units=1],[bounding_box=[ 702.35103, -14.642921, 717.35103, 0.35707887],caption_offset=[0,0]]).
node(node00085,variable,[],[comment='Suitability of the cell for wody biofuels\n1 : suitable\n0 or -1 : not suitable',complete=true,name='rentability\nwoody',param_type=file,units=1],[bounding_box=[ 282.85008, 668.82954, 297.85008, 683.82954],caption_offset=[ -43.588375, -23.508096]]).
node(node00087,variable,[],[comment='Suitability of the cell for non woody biofuels\n1 : suitable\n0 or -1 : not suitable',complete=true,name='rentability\nnon woody',param_type=file,units=1],[bounding_box=[ 277.52617, 345.47483, 292.52617, 360.47483],caption_offset=[ -45.099101, -27.700167]]).
node(node00088,variable,[],[complete=true,name='surplus ini\n2005 abs'],[bounding_box=[ 534.62229, -15.093202, 549.62229, -0.093202479],caption_offset=[ 1.2102313, -48.536663]]).
node(node00098,variable,[],[complete=true,name='rent liquid\narea 2005'],[bounding_box=[ 239.74491, -15.040504, 254.74491, -0.040503906],caption_offset=[ 0.74033165, -47.130691]]).
node(node00099,function,[],[comment='area available for liquid biofuels in 2005 (square meters)',complete=true,name=fn17,spec='if rentability_liquid== -1 then 0 elseif rentability_liquid==0 then 0 else surplus_ini_2005_abs',units=1,value=(if rentability_liquid== -1 then 0 elseif rentability_liquid==0 then 0 else surplus_ini_2005_abs)],[]).
node(node00100,variable,[],[complete=true,name='remaining\nNW rent area'],[bounding_box=[ 214.43695, 413.40371, 229.43695, 428.40371],caption_offset=[ -26.264235, -47.385845]]).
node(node00101,function,[],[comment='Remaining area available for non woody biofuels at the time of simulation (square meters)',complete=true,name=fn18,spec='if remaining_surplus_2<0 then 0 elseif rentability_non_woody== -1 then 0 elseif rentability_non_woody==0 then 0 else remaining_surplus_2',units=1,value=(if remaining_surplus_2<0 then 0 elseif rentability_non_woody== -1 then 0 elseif rentability_non_woody==0 then 0 else remaining_surplus_2)],[]).
node(node00102,variable,[],[complete=true,name='remaining\nwoody rent area'],[bounding_box=[ 205.68788, 742.24176, 220.68788, 757.24176],caption_offset=[ -7.2455977, -48.210831]]).
node(node00103,function,[],[comment='Remaining area available for woody biofuels at the time of simulation (square meters)',complete=true,name=fn19,spec='if remaining_surplus_3<0 then 0 elseif rentability_woody== -1 then 0 elseif rentability_woody==0 then 0 else remaining_surplus_3',units=1,value=(if remaining_surplus_3<0 then 0 elseif rentability_woody== -1 then 0 elseif rentability_woody==0 then 0 else remaining_surplus_3)],[]).
node(node00106,variable,[],[name=var7],[]).
node(node00109,variable,[],[name=var27],[]).
node(node00119,variable,[],[complete=true,name=surplus],[bounding_box=[ 733.0425, 79.078971, 748.0425, 94.078971],caption_offset=[ -3.1780862, -34.175043]]).
node(node00123,function,[],[comment='Area abandoned by agriculture from 2005 (square meters)',complete=true,name=fn4,spec='if pro_land+sea_dens+inland_waters+pro_forest+GFC_surface_rel+PC_surface_rel+FC_surface_rel+Urb_dens >=1 then 0\nelse (min(surplus_ini_2005_abs+surface*(surplus_foodcrops+surplus_grassland+surplus_PC),(surface*(1-pro_land+sea_dens+inland_waters+pro_forest+GFC_surface_rel+PC_surface_rel+FC_surface_rel+Urb_dens))))',units=1,value=(if pro_land+sea_dens+inland_waters+pro_forest+'GFC_surface_rel'+'PC_surface_rel'+'FC_surface_rel'+'Urb_dens'>=1 then 0 else min(surplus_ini_2005_abs+surface*(surplus_foodcrops+surplus_grassland+surplus_PC),surface*(1-pro_land+sea_dens+inland_waters+pro_forest+'GFC_surface_rel'+'PC_surface_rel'+'FC_surface_rel'+'Urb_dens')))],[]).
node(node00137,variable,[],[name=var33],[]).
node(node00146,cloud,[],[complete=true,name=cd1],[bounding_box=[ 411.65964, 157.0427, 436.65964, 182.0427]]).
node(node00147,function,[],[comment='Liquid biofuels growth rate (square meters/year)',complete=true,name=fn5,spec='if remaining_liquid_rent_area<0 then 0\nelse dens_add_liquid*remaining_liquid_rent_area',units=1,value=(if remaining_liquid_rent_area<0 then 0 else dens_add_liquid*remaining_liquid_rent_area)],[]).
node(node00148,variable,[],[complete=true,name='remaining\nsurplus'],[bounding_box=[ 534.27477, 77.57989600000001, 549.27477, 92.57989600000001],caption_offset=[ -1.5170582, -49.34576]]).
node(node00149,function,[],[comment='Remaining surplus from agriculture at the time of simulation (square meters)',complete=true,name=fn7,spec='surplus-liquid_area_0-NW_area-woody_area_0-forest_area_in_surplus',units=1,value=surplus-liquid_area_0-'NW_area'-woody_area_0-forest_area_in_surplus],[]).
node(node00156,function,[],[comment='Surplus land in 2005 (areas abandoned by agriculture between 2000 and 2005) (square meters)',complete=true,name=fn13,spec='surface*surplus_ini_2005_rel',units=1,value=surface*surplus_ini_2005_rel],[]).
node(node00169,variable,[],[name=var40],[]).
node(node00171,variable,[],[name=var42],[]).
node(node00243,variable,[],[name=var50],[]).
node(node00245,variable,[],[name=var52],[]).
node(node00249,variable,[],[name=var57],[]).
node(node00255,variable,[],[name=var63],[]).
node(node00257,variable,[],[name=var66],[]).
node(node00321,variable,[],[name=var76],[]).
node(node00323,variable,[],[name=var78],[]).
node(node00327,variable,[],[name=var82],[]).
node(node00334,variable,[],[name=var88],[]).
node(node00396,variable,[],[complete=true,name='remaining\nsurplus_2'],[bounding_box=[ 534.03808, 414.5067, 549.03808, 429.5067],caption_offset=[ -1.1368684e-13, 4.0909342]]).
node(node00397,function,[],[comment='Remaining surplus from agriculture at the time of simulation after that liquid biofuels have been allocated (square meters)',complete=true,name=fn10,spec='remaining_surplus-(liquid_growth*dt())+(liquid_decline*dt())',units=1,value=remaining_surplus-liquid_growth*dt('')+liquid_decline*dt('')],[]).
node(node00425,variable,[],[name=var10],[]).
node(node00427,variable,[],[name=var13],[]).
node(node00553,variable,[],[name=var24],[bounding_box=[ 706.63726, 258.97393, 771.63726, 323.97393],caption_offset=[ 34.091118, -16.363737]]).
node(node00554,function,[],[name=fn12],[]).
node(node00555,variable,[],[name=var25],[]).
node(node00562,variable,[],[complete=true,name='remaining\nliquid\nrent area'],[bounding_box=[ 332.45495, 77.84533999999999, 347.45495, 92.84533999999999],caption_offset=[ 43.751415, -31.092791]]).
node(node00563,function,[],[comment='Remaining area available for liquid biofuels at the time of simulation (square meters)',complete=true,name=fn8,spec='if remaining_surplus<0 then 0 elseif rentability_liquid== -1 then 0 elseif rentability_liquid==0 then 0 else remaining_surplus',units=1,value=(if remaining_surplus<0 then 0 elseif rentability_liquid== -1 then 0 elseif rentability_liquid==0 then 0 else remaining_surplus)],[]).
node(node00576,cloud,[],[complete=true,name=cd2],[bounding_box=[ 414.70349, 496.73782, 439.70349, 521.7378200000001]]).
node(node00577,function,[],[comment='Non woody biofuels growth rate (square meters/year)',complete=true,name=fn14,spec='if remaining_NW_rent_area<0 then 0\nelse dens_add_NW*remaining_NW_rent_area',units=1,value=(if remaining_NW_rent_area<0 then 0 else dens_add_NW*remaining_NW_rent_area)],[]).
node(node00579,variable,[],[name=var37],[]).
node(node00580,variable,[],[name=var38],[]).
node(node00581,variable,[],[complete=true,name='remaining\nsurplus_3'],[bounding_box=[ 534.70833, 741.78218, 549.70833, 756.78218],caption_offset=[ 2.7272895, 2.7272895]]).
node(node00582,function,[],[comment='Remaining surplus from agriculture at the time of simulation after that liquid and non woody biofuels have been allocated (square meters)',complete=true,name=fn15,spec='remaining_surplus_2-(NW_growth*dt())+(NW_decline*dt())',units=1,value=remaining_surplus_2-'NW_growth'*dt('')+'NW_decline'*dt('')],[]).
node(node00583,variable,[],[complete=true,name='surplus ini\n2005 abs_2'],[bounding_box=[ 389.98914, 228.75522, 404.98914, 243.75522],caption_offset=[ -43.636631, -30.000184]]).
node(node00584,function,[],[comment='Surplus land remaining in 2005 after that liquid biofuels have been allocated (square meters)',complete=true,name=fn16,spec='surplus_ini_2005_abs-liquid_area_0',units=1,value=surplus_ini_2005_abs-liquid_area_0],[]).
node(node00587,variable,[],[complete=true,name='rent NW\narea 2005'],[bounding_box=[ 334.94084, 288.65622, 349.94084, 303.65622],caption_offset=[ -38.182049, -39.54569]]).
node(node00588,function,[],[comment='area available for non woody biofuels in 2005 (square meters)',complete=true,name=fn20,spec='if rentability_non_woody== -1 then 0 elseif rentability_non_woody==0 then 0 else surplus_ini_2005_abs_2',units=1,value=(if rentability_non_woody== -1 then 0 elseif rentability_non_woody==0 then 0 else surplus_ini_2005_abs_2)],[]).
node(node00589,variable,[],[complete=true,name='surplus ini\n2005 abs_3'],[bounding_box=[ 389.75088, 547.33993, 404.75088, 562.33993],caption_offset=[ -42.272987, -27.272895]]).
node(node00590,function,[],[comment='Surplus land remaining in 2005 after that liquid and non woody biofuels have been allocated (square meters)',complete=true,name=fn21,spec='surplus_ini_2005_abs_2-NW_area',units=1,value=surplus_ini_2005_abs_2-'NW_area'],[]).
node(node00591,variable,[],[name=var39],[]).
node(node00592,cloud,[],[complete=true,name=cd4],[bounding_box=[ 82.574341, 191.46474, 107.57434, 216.46474]]).
node(node00593,variable,[],[name=var41],[]).
node(node00594,variable,[],[complete=true,name='rent woody\narea 2005'],[bounding_box=[ 337.27819, 609.8671000000001, 352.27819, 624.8671000000001],caption_offset=[ -40.909342, -36.818408]]).
node(node00595,function,[],[comment='area available for woody biofuels in 2005 (square meters)',complete=true,name=fn22,spec='if rentability_woody== -1 then 0 elseif rentability_woody==0 then 0 else surplus_ini_2005_abs_3',units=1,value=(if rentability_woody== -1 then 0 elseif rentability_woody==0 then 0 else surplus_ini_2005_abs_3)],[]).
node(node00598,variable,[],[name=var43],[]).
node(node00599,variable,[],[name=var44],[]).
node(node00600,variable,[],[name=var45],[]).
node(node00615,cloud,[],[complete=true,name=cd3],[bounding_box=[ 422.95046, 821.43294, 447.95046, 846.43294]]).
node(node00616,function,[],[comment='Woody biofuels growth rate (square meters/year)',complete=true,name=fn23,spec='if dens_add_woody<=0 then 0\nelseif remaining_woody_rent_area<0 then 0\nelse dens_add_woody*remaining_woody_rent_area',units=1,value=(if dens_add_woody<=0 then 0 elseif remaining_woody_rent_area<0 then 0 else dens_add_woody*remaining_woody_rent_area)],[]).
node(node00622,variable,[],[name=var29],[]).
node(node00671,variable,[],[name=var55],[]).
node(node00676,variable,[],[name=var97],[]).
node(node00681,variable,[],[name=var101],[]).
node(node00686,variable,[],[name=var105],[]).
node(node00695,variable,[],[name=var56],[]).
node(node00696,variable,[],[name=var58],[]).
node(node00702,variable,[],[name=var59],[]).
node(node00703,function,[],[comment='Loss of liquid biofuels due to congestion in the surplus land (square meters)',complete=true,name=fn6,spec='liquid_to_remove/dt()',units=1,value=liquid_to_remove/dt('')],[]).
node(node00704,cloud,[],[complete=true,name=cd5],[bounding_box=[ 81.155579, 517.78002, 106.15558, 542.78002]]).
node(node00705,function,[],[comment='Loss of non-woody biofuels due to congestion in the surplus land (square meters)',complete=true,name=fn9,spec='NW_to_remove/dt()',units=1,value='NW_to_remove'/dt('')],[]).
node(node00706,cloud,[],[complete=true,name=cd6],[bounding_box=[ 85.41186500000001, 849.77035, 110.41187, 874.77035]]).
node(node00707,function,[],[comment='Loss of woody biofuels due to congestion in the surplus land (square meters)',complete=true,name=fn11,spec='woody_to_remove/dt()',units=1,value=woody_to_remove/dt('')],[]).
node(node00708,variable,[],[name=var2],[]).
node(node00715,variable,[],[complete=true,name='woody\nto remove'],[bounding_box=[ 447.93991, 924.28971, 462.93991, 939.28971],caption_offset=[0,0]]).
node(node00716,function,[],[comment='Area of woody biofuels that will be removed at the next timestep due to congestion in the \'surplus from agriculture\' (square meters)',complete=true,name=fn30,spec='if woody_max_to_remove>woody_area then woody_area else woody_max_to_remove',units=1,value=(if woody_max_to_remove>woody_area then woody_area else woody_max_to_remove)],[]).
node(node00717,variable,[],[name=var4],[]).
node(node00719,variable,[],[complete=true,name='woody max\nto remove'],[bounding_box=[ 683.45442, 860.4453999999999, 698.45442, 875.4453999999999],caption_offset=[ -8.5125727, 7.0938106]]).
node(node00720,function,[],[comment='Landuse still in excess after the removing of the surplus forests (square meters)',complete=true,name=fn24,spec='forest_max_to_remove-forest_to_remove',units=1,value=forest_max_to_remove-forest_to_remove],[]).
node(node00721,variable,[],[complete=true,name='NW max\nto remove'],[bounding_box=[ 682.03566, 622.09336, 697.03566, 637.09336],caption_offset=[ -8.5125727, 8.5125727]]).
node(node00749,function,[],[comment='Landuse still in excess after the removing of the surplus forests and woody biofuels (square meters)',complete=true,name=fn25,spec='woody_max_to_remove-woody_to_remove',units=1,value=woody_max_to_remove-woody_to_remove],[]).
node(node00774,variable,[],[complete=true,name='NW to\nremove'],[bounding_box=[ 496.17782, 622.09338, 511.17782, 637.09338],caption_offset=[0,0]]).
node(node00775,function,[],[comment='Area of non-woody biofuels that will be removed at the next timestep due to congestion in the \'surplus from agriculture\' (square meters)',complete=true,name=fn31,spec='if NW_area-NW_max_to_remove<0 then NW_area else NW_max_to_remove',units=1,value=(if 'NW_area'-'NW_max_to_remove'<0 then 'NW_area' else 'NW_max_to_remove')],[]).
node(node00824,variable,[],[complete=true,name='liquid max\nto remove'],[bounding_box=[ 682.03566, 305.70942, 697.03566, 320.70942],caption_offset=[ -7.0938106, 9.9313348]]).
node(node00825,function,[],[comment='Landuse still in excess after the removing of the surplus forests, woody and non-woody biofuels (square meters)',complete=true,name=fn29,spec='NW_max_to_remove-NW_to_remove',units=1,value='NW_max_to_remove'-'NW_to_remove'],[]).
node(node01161,variable,[],[name=var28],[]).
node(node01177,variable,[],[complete=true,name='liquid to\nremove'],[bounding_box=[ 520.29677, 305.70943, 535.29677, 320.70943],caption_offset=[0,0]]).
node(node01178,function,[],[comment='Area of liquid biofuels that will be removed at the next timestep due to congestion in the \'surplus from agriculture\' (square meters)',complete=true,name=fn33,spec='if liquid_area-liquid_max_to_remove<0 then liquid_area else liquid_max_to_remove',units=1,value=(if liquid_area-liquid_max_to_remove<0 then liquid_area else liquid_max_to_remove)],[]).
node(node01184,variable,[],[name=var51],[]).
node(node01196,variable,[],[name=var5],[]).
node(node01243,variable,[],[name=var8],[]).
node(node01246,variable,[],[name=var17],[]).
node(node01523,submodel,[node00161,node00162,node01524,node01525,node01526],[complete=true,enum_types=[],fill_colour='#ff0000',image_posn=none,multiplication_spec=[count=[]],name='RESULT',separate=0],[bounding_box=[ 595.89735, 228.0837, 663.99793, 307.53438],caption_offset=[ 7.0938106, 1.4187621],hide_contents=0,internal_extent=[0,0, 68.10058100000001, 79.450678]]).
links(node01523,[arc00177-arc01536,arc00644-arc01558,arc01511-arc00855]).
references(node01523,[obsolete,obsolete,ancestor(2),ancestor(3),ancestor(4)]).
node(node00161,variable,[],[complete=true,name='liquid\nrel'],[bounding_box=[ 27.869707, 27.871948, 42.869707, 42.871948],caption_offset=[ 0.32814427, 0.45572208]]).
node(node00162,function,[],[comment='Surface of liquid biofuels (part of the cell)',complete=true,max_val=1,min_val=0,name=fn26,spec='liquid_area_0/surface',units=1,value=liquid_area_0/surface],[]).
node(node01524,variable,[],[],[]).
node(node01525,variable,[],[],[]).
node(node01526,variable,[],[],[]).
node(node01527,submodel,[node00163,node00164,node01528,node01529,node01530],[complete=true,enum_types=[],fill_colour='#ff0000',image_posn=none,multiplication_spec=[count=[]],name='RESULT2',separate=0],[bounding_box=[ 605.82868, 521.76746, 686.69812, 615.40576],caption_offset=[ 5.6750484, 2.8421709e-13],hide_contents=0,internal_extent=[ -5.6750484, 0.0, 75.19439199999999, 93.638299]]).
links(node01527,[arc00178-arc01565,arc00645-arc01689,arc01562-arc00864]).
references(node01527,[obsolete,obsolete,ancestor(2),ancestor(3),ancestor(4)]).
node(node00163,variable,[],[complete=true,name='non woody\nrel'],[bounding_box=[ 27.459817, 35.742297, 42.459817, 50.742297],caption_offset=[ -4.2000276e-07, 6.2800352e-07]]).
node(node00164,function,[],[comment='Surface of non woody biofuels (part of the cell)',complete=true,max_val=1,min_val=0,name=fn27,spec='NW_area/surface',units=1,value='NW_area'/surface],[]).
node(node01528,variable,[],[],[]).
node(node01529,variable,[],[],[]).
node(node01530,variable,[],[],[]).
node(node01531,submodel,[node00165,node00166,node01532,node01533,node01534],[complete=true,enum_types=[],fill_colour='#ff0000',image_posn=none,multiplication_spec=[count=[]],name='RESULT3',separate=0],[bounding_box=[ 705.14203, 916.18333, 778.91766, 992.79648],caption_offset=[ 4.2562863, 93.638299],hide_contents=0,internal_extent=[0,0, 73.77563000000001, 76.61315399999999]]).
links(node01531,[arc00179-arc01707,arc00646-arc01708,arc01706-arc00961]).
references(node01531,[obsolete,obsolete,ancestor(2),ancestor(3),ancestor(4)]).
node(node00165,variable,[],[complete=true,name='woody\nrel'],[bounding_box=[ 26.618122, 17.514784, 41.618122, 32.514784],caption_offset=[0,0]]).
node(node00166,function,[],[comment='Surface of woody biofuels (part of the cell)',complete=true,max_val=1,min_val=0,name=fn28,spec='woody_area_0/surface',units=1,value=woody_area_0/surface],[]).
node(node01532,variable,[],[],[]).
node(node01533,variable,[],[],[]).
node(node01534,variable,[],[],[]).
node(node00183,variable,[],[name=var9],[]).
node(node00209,variable,[],[name=var7],[]).
node(node00233,variable,[],[],[]).
node(node00272,variable,[],[],[]).
node(node00273,variable,[],[],[]).
node(node00274,variable,[],[],[]).
node(node00275,variable,[],[],[]).
node(node00276,variable,[],[],[]).
node(node00277,variable,[],[name=var50],[]).
node(node00278,variable,[],[],[]).
node(node00279,variable,[],[],[]).
node(node00280,variable,[],[],[]).
node(node00281,variable,[],[],[]).
node(node00283,variable,[],[],[]).
node(node00284,variable,[],[],[]).
node(node00285,variable,[],[],[]).
node(node00286,variable,[],[],[]).
node(node00287,variable,[],[],[]).
node(node00288,variable,[],[],[]).
node(node00289,variable,[],[],[]).
node(node00290,variable,[],[],[]).
node(node00291,variable,[],[],[]).
node(node00292,variable,[],[],[]).
node(node00293,variable,[],[],[]).
node(node00294,variable,[],[],[]).
node(node00295,variable,[],[],[]).
node(node00296,variable,[],[],[]).
node(node00299,variable,[],[],[]).
node(node00300,variable,[],[],[]).
node(node00302,variable,[],[],[]).
node(node00303,variable,[],[],[]).
node(node00304,variable,[],[],[]).
node(node00305,variable,[],[],[]).
node(node00306,variable,[],[],[]).
node(node00307,variable,[],[],[]).
node(node00308,variable,[],[],[]).
node(node00310,variable,[],[name=var22],[]).
node(node00313,variable,[],[],[]).
node(node00318,variable,[],[],[]).
node(node00336,variable,[],[name=var8],[]).
node(node00338,variable,[],[],[]).
node(node00339,variable,[],[],[]).
node(node00341,variable,[],[],[]).
node(node00343,variable,[],[],[]).
node(node00347,variable,[],[],[]).
node(node00348,variable,[],[],[]).
node(node00349,variable,[],[],[]).
node(node00352,variable,[],[],[]).
node(node00353,variable,[],[],[]).
node(node00354,variable,[],[],[]).
node(node00355,variable,[],[],[]).
node(node00363,variable,[],[name=var2],[]).
node(node00368,variable,[],[name=var40],[]).
node(node00372,variable,[],[name=var3],[]).
node(node00385,variable,[],[name=var6],[bounding_box=[ 1143.0946, 1856.8525, 1158.0946, 1871.8525],caption_offset=[ 39.725336, -24.118954]]).
node(node00386,function,[],[name=fn3],[]).
node(node00389,variable,[],[name=var38],[]).
node(node00398,variable,[],[name=var15],[]).
node(node00403,variable,[],[name=var17],[]).
node(node00419,variable,[],[name=var20],[]).
node(node00424,variable,[],[name=var23],[]).
node(node00433,variable,[],[name=var26],[]).
node(node00437,variable,[],[name=var29],[]).
node(node00451,variable,[],[name=var31],[]).
node(node00472,variable,[],[name=var42],[]).
node(node00478,variable,[],[name=var19],[bounding_box=[ 1138.4418, 1790.1244, 1153.4418, 1805.1244],caption_offset=[ 17.025144, 0.0]]).
node(node00479,function,[],[name=fn13],[]).
node(node00484,variable,[],[name=var32],[bounding_box=[ 1192.5217, 1746.8075, 1257.5217, 1811.8075],caption_offset=[0,0]]).
node(node00485,function,[],[name=fn14],[]).
node(node00486,variable,[],[name=var33],[]).
node(node00487,variable,[],[name=var34],[bounding_box=[ 1126.6516, 1720.0559, 1146.1516, 1739.5559],caption_offset=[ 46.819146, -25.537716]]).
node(node00488,function,[],[name=fn15],[]).
node(node00489,variable,[],[name=var35],[bounding_box=[ 1126.675, 1616.0354, 1146.175, 1635.5354],caption_offset=[ 52.494194, -19.862668]]).
node(node00491,submodel,[node00022,node00023,node00028,node00029,node00030,node00031,node00181,node00194,node00227,node00359,node00361,node00393,node00394,node00399,node00402,node00416,node00417,node00421,node00422,node00426,node00431,node00434,node00435,node00443,node00448,node00452,node00458,node00461,node00467,node00482,node00483,node00492,node00493,node00506,node00507,node00509,node00510,node00559,node00560,node00569,node00570,node00641,node00642,node00689,node00690,node00691,node00900,node00932,node00933,node00948,node00991,node00992,node00995,node00996,node01100,node01107,node01115,node01116,node01120,node01121,node01135,node01136,node01140,node01141,node01142,node01143,node01144,node01145,node01150,node01151,node01214,node01215,node01217,node01218,node01219,node01335,node01337,node01338,node01342,node01343,node01344,node01399,node01400,node01496,node01497,node01502,node01503,node01504,node01505,node01554,node01555,node01556,node01557,node01560,node01561],[complete=true,enum_types=[],fill_colour='#ff952b',image_posn=none,multiplication_spec=[count=[]],name='All agriculture',separate=0],[bounding_box=[ 1041.4388, 102.41578, 1454.2985, 1156.556],caption_offset=[ 0.0, 0.0],hide_contents=0,internal_extent=[ -4.0, -11.565956, 414.84987, 1057.8688]]).
links(node00491,[arc00041-arc01383,arc00236-arc01384,arc00252-arc01385,arc00275-arc01382,arc00318-arc01479,arc00322-arc01501,arc00327-arc01506,arc00331-arc01507,arc00334-arc01508,arc00711-arc01510,arc00729-arc01566,arc00930-arc01380,arc00934-arc00218,arc00935-arc01269,arc00936-arc00223,arc01083-arc01567,arc01128-arc01568,arc01255-arc01569,arc01261-arc01570,arc01264-arc01571,arc01279-arc01572,arc01509-arc00632,arc01509-arc00633,arc01509-arc01022,arc01679-arc01688,arc01684-arc01747,arc01752-arc01760,arc01756-arc01766,arc01759-arc01762]).
references(node00491,[obsolete,obsolete,ancestor(2),ancestor(3),ancestor(4)]).
node(node00022,variable,[],[complete=true,name='FC to keep\noutside pro areas'],[bounding_box=[ 105.98731, 653.82092, 120.98731, 668.82092],caption_offset=[ -47.270515, -15.756838]]).
node(node00023,function,[],[comment='area of food crops that should be kept in addition to the protected areas (square meters)',complete=true,name=fn17,spec='Agriculture_to_keep_outside_protected_areas*proportion_FC',units=1,value='Agriculture_to_keep_outside_protected_areas'*proportion_FC],[]).
node(node00028,variable,[],[complete=true,name='GFC to keep\noutside pro areas'],[bounding_box=[ 175.34253, 618.66646, 190.34253, 633.66646],caption_offset=[ -22.919038, -50.135395]]).
node(node00029,function,[],[comment='area of grasslands that should be kept in addition to the protected areas (square meters)',complete=true,name=fn27,spec='Agriculture_to_keep_outside_protected_areas*proportion_GFC',units=1,value='Agriculture_to_keep_outside_protected_areas'*proportion_GFC],[]).
node(node00030,variable,[],[complete=true,name='PC to keep\noutside pro areas'],[bounding_box=[ 229.20077, 587.42634, 244.20077, 602.42634],caption_offset=[ 61.594913, -42.973195]]).
node(node00031,function,[],[comment='area of permanent crops that should be kept in addition to the protected areas (square meters)',complete=true,name=fn28,spec='Agriculture_to_keep_outside_protected_areas*proportion_PC',units=1,value='Agriculture_to_keep_outside_protected_areas'*proportion_PC],[]).
node(node00181,variable,[],[name=var66],[bounding_box=[ 44.005563, 837.49018, 63.505563, 856.99018],caption_offset=[0,0]]).
node(node00194,function,[],[name=fn29],[]).
node(node00227,variable,[],[name=var10],[bounding_box=[ 348.50199, 838.1638, 363.50199, 853.1638],caption_offset=[0,0]]).
node(node00359,variable,[],[name=var1],[bounding_box=[ 18.690178, 39.848731, 83.690178, 104.84873],caption_offset=[ 1.418762, -34.050288]]).
node(node00361,function,[],[name=fn1],[]).
node(node00393,variable,[],[name=var14],[bounding_box=[ 91.46123799999999, 39.971438, 156.46124, 104.97143],caption_offset=[ -4.2973195, -46.819146]]).
node(node00394,function,[],[name=fn4],[]).
node(node00399,variable,[],[name=var16],[bounding_box=[ 173.13396, 64.44748, 192.63396, 83.94748],caption_offset=[ -1.7607082, -61.417101]]).
node(node00402,function,[],[name=fn5],[]).
node(node00416,variable,[],[name=var18],[bounding_box=[ 232.47376, 63.184412, 251.97376, 82.68441199999999],caption_offset=[ 6.6971524, -49.984938]]).
node(node00417,function,[],[name=fn6],[]).
node(node00421,variable,[],[name=var21],[bounding_box=[ 367.99342, 214.16057, 387.49342, 233.66057],caption_offset=[ 2.8648797, -48.702955]]).
node(node00422,function,[],[name=fn7],[]).
node(node00426,variable,[],[name=var24],[bounding_box=[ 282.33477, 136.84824, 301.83477, 156.34824],caption_offset=[ -1.4324399, -48.702955]]).
node(node00431,function,[],[name=fn8],[]).
node(node00434,variable,[],[name=var27],[bounding_box=[ 355.39656, 146.17802, 374.89656, 165.67802],caption_offset=[ 2.8648797, -50.135395]]).
node(node00435,function,[],[name=fn9],[]).
node(node00443,variable,[],[name=var30],[bounding_box=[ 304.47914, 64.618888, 323.97914, 84.118888],caption_offset=[ 8.5946391, -45.838075]]).
node(node00448,function,[],[name=fn10],[]).
node(node00452,variable,[],[complete=true,name='tot occupied\narea'],[bounding_box=[ 88.77064799999999, 159.92762, 103.77065, 174.92762],caption_offset=[ -48.292619, -22.618125]]).
node(node00458,function,[],[comment='Total area occupied by all landuses excluding surplus land (square meters)',complete=true,name=fn11,spec='(Urb_dens+inland_waters+sea_dens+pro_forest+pro_land)*surface+FC_abs+GFC_abs+PC_abs',units=1,value=('Urb_dens'+inland_waters+sea_dens+pro_forest+pro_land)*surface+'FC_abs'+'GFC_abs'+'PC_abs'],[]).
node(node00461,variable,[],[complete=true,name='Agriculture\nto remove'],[bounding_box=[ 212.43553, 219.20103, 227.43553, 234.20103],caption_offset=[0,0]]).
node(node00467,function,[],[comment='Agriculture to remove to avoid that the sum of all landuses surfaces exceeds the cell surface (square meters)',complete=true,name=fn12,spec='if tot_occupied_area<=surface then 0 else tot_occupied_area-surface',units=1,value=(if tot_occupied_area<=surface then 0 else tot_occupied_area-surface)],[]).
node(node00482,variable,[],[complete=true,name='coef\nremove'],[bounding_box=[ 309.15744, 216.42814, 324.15744, 231.42814],caption_offset=[ 11.432161, 0.027357398]]).
node(node00483,function,[],[comment='Part of the non-protected areas of agricultural landuse that may be kept',complete=true,name=coef_remove1_0_0,spec='if to_remove==0 then 1 elseif max(FC_abs-pro_crop*surface,0)+max(PC_abs-pro_pcrop*surface,0)+max(GFC_abs-pro_grass*surface,0)==0 then 1 elseif(max(FC_abs-pro_crop*surface,0)+max(PC_abs-pro_pcrop*surface,0)+max(GFC_abs-pro_grass*surface,0)-to_remove)/(max(FC_abs-pro_crop*surface,0)+max(PC_abs-pro_pcrop*surface,0)+max(GFC_abs-pro_grass*surface,0))<0 then 0 else(max(FC_abs-pro_crop*surface,0)+max(PC_abs-pro_pcrop*surface,0)+max(GFC_abs-pro_grass*surface,0)-to_remove)/(max(FC_abs-pro_crop*surface,0)+max(PC_abs-pro_pcrop*surface,0)+max(GFC_abs-pro_grass*surface,0))',units=1,value=(if to_remove==0 then 1 elseif max('FC_abs'-pro_crop*surface,0)+max('PC_abs'-pro_pcrop*surface,0)+max('GFC_abs'-pro_grass*surface,0)==0 then 1 elseif(max('FC_abs'-pro_crop*surface,0)+max('PC_abs'-pro_pcrop*surface,0)+max('GFC_abs'-pro_grass*surface,0)-to_remove)/(max('FC_abs'-pro_crop*surface,0)+max('PC_abs'-pro_pcrop*surface,0)+max('GFC_abs'-pro_grass*surface,0))<0 then 0 else(max('FC_abs'-pro_crop*surface,0)+max('PC_abs'-pro_pcrop*surface,0)+max('GFC_abs'-pro_grass*surface,0)-to_remove)/(max('FC_abs'-pro_crop*surface,0)+max('PC_abs'-pro_pcrop*surface,0)+max('GFC_abs'-pro_grass*surface,0)))],[]).
node(node00492,variable,[],[],[]).
node(node00493,variable,[],[],[]).
node(node00506,compartment,[],[name=comp2],[bounding_box=[ 31.002139, 357.66945, 71.002139, 387.66945],caption_offset=[ 4.2973195, -22.919038]]).
node(node00507,function,[],[name=fn18],[]).
node(node00509,variable,[],[name=var25],[bounding_box=[ 187.21903, 134.27411, 252.21903, 199.27411],caption_offset=[ -2.8648797, -45.838075]]).
node(node00510,function,[],[name=fn19],[]).
node(node00559,compartment,[],[name=comp4],[bounding_box=[ 102.02926, 357.55181, 142.02926, 387.55181],caption_offset=[ -1.0129014e-08, -22.919038]]).
node(node00560,function,[],[name=fn21],[]).
node(node00569,compartment,[],[name=comp6],[bounding_box=[ 170.03202, 357.70254, 210.03202, 387.70254],caption_offset=[ -1.4324399, -21.486598]]).
node(node00570,function,[],[name=fn23],[]).
node(node00641,variable,[],[],[]).
node(node00642,variable,[],[],[]).
node(node00689,variable,[],[],[]).
node(node00690,variable,[],[],[]).
node(node00691,variable,[],[],[]).
node(node00900,function,[],[name=fn30],[]).
node(node00932,variable,[],[],[]).
node(node00933,variable,[],[],[]).
node(node00948,variable,[],[],[]).
node(node00991,variable,[],[],[]).
node(node00992,variable,[],[],[]).
node(node00995,variable,[],[],[]).
node(node00996,variable,[],[],[]).
node(node01100,variable,[],[name=var76],[bounding_box=[ 348.64616, 711.80286, 363.64616, 726.80285],caption_offset=[0,0]]).
node(node01107,function,[],[name=fn33],[]).
node(node01115,variable,[],[name=var80],[bounding_box=[ 350.95294, 662.68762, 365.95294, 677.68762],caption_offset=[0,0]]).
node(node01116,function,[],[name=fn35],[]).
node(node01120,variable,[],[name=var82],[bounding_box=[ 349.39481, 609.67764, 364.39481, 624.67764],caption_offset=[0,0]]).
node(node01121,function,[],[name=fn36],[]).
node(node01135,variable,[],[name=var90],[bounding_box=[ 323.85366, 748.58923, 388.85366, 813.58923],caption_offset=[0,0]]).
node(node01136,function,[],[name=fn43],[]).
node(node01140,variable,[],[complete=true,name='proportion\nFC'],[bounding_box=[ 43.533226, 545.95372, 58.533226, 560.95372],caption_offset=[0,0]]).
node(node01141,function,[],[comment='Part of the Foodcrops in the total agricultural surface',complete=true,name=fn45,spec='if FC_abs+GFC_abs+PC_abs<=0 then 0\nelse FC_abs/(FC_abs+GFC_abs+PC_abs)',units=1,value=(if 'FC_abs'+'GFC_abs'+'PC_abs'<=0 then 0 else 'FC_abs'/('FC_abs'+'GFC_abs'+'PC_abs'))],[]).
node(node01142,variable,[],[complete=true,name='proportion\nGFC'],[bounding_box=[ 115.97217, 511.84874, 130.97217, 526.84874],caption_offset=[ -1.4324399, 2.8648797]]).
node(node01143,function,[],[comment='Part of the grasslands in the total agricultural surface',complete=true,name=fn46,spec='if FC_abs+GFC_abs+PC_abs<=0 then 0\nelse GFC_abs/(FC_abs+GFC_abs+PC_abs)',units=1,value=(if 'FC_abs'+'GFC_abs'+'PC_abs'<=0 then 0 else 'GFC_abs'/('FC_abs'+'GFC_abs'+'PC_abs'))],[]).
node(node01144,variable,[],[complete=true,name='proportion\nPC'],[bounding_box=[ 182.61285, 483.39144, 197.61285, 498.39144],caption_offset=[ 47.270515, -24.351477]]).
node(node01145,function,[],[comment='Part of the permanent crops in the total agricultural surface',complete=true,name=fn47,spec='if FC_abs+GFC_abs+PC_abs<=0 then 0\nelse PC_abs/(FC_abs+GFC_abs+PC_abs)',units=1,value=(if 'FC_abs'+'GFC_abs'+'PC_abs'<=0 then 0 else 'PC_abs'/('FC_abs'+'GFC_abs'+'PC_abs'))],[]).
node(node01150,variable,[],[complete=true,name='Agriculture\nto keep outside\nprotected areas'],[bounding_box=[ 228.98063, 752.15284, 243.98063, 767.15284],caption_offset=[ -55.061935, -22.795929]]).
node(node01151,function,[],[comment='area of agricultural landuse that should be kept in addition to the protected areas',complete=true,name=fn49,spec='if protected_abs_FC+protected_abs_GFC+protected_abs_PC>=Agro_threshold*surface then 0 else Agro_threshold*surface-(protected_abs_FC+protected_abs_GFC+protected_abs_PC)',units=1,value=(if protected_abs_FC+protected_abs_GFC+protected_abs_PC>='Agro_threshold'*surface then 0 else 'Agro_threshold'*surface-(protected_abs_FC+protected_abs_GFC+protected_abs_PC))],[]).
node(node01214,variable,[],[],[]).
node(node01215,variable,[],[],[]).
node(node01217,variable,[],[],[]).
node(node01218,variable,[],[],[]).
node(node01219,variable,[],[],[]).
node(node01335,variable,[],[],[]).
node(node01337,variable,[],[],[]).
node(node01338,variable,[],[],[]).
node(node01342,variable,[],[],[]).
node(node01343,variable,[],[],[]).
node(node01344,variable,[],[],[]).
node(node01399,variable,[],[],[]).
node(node01400,variable,[],[],[]).
node(node01496,variable,[],[name=var65],[bounding_box=[ 228.76213, 991.17539, 243.76213, 1006.1754],caption_offset=[0,0]]).
node(node01497,function,[],[name=fn32],[]).
node(node01502,variable,[],[complete=true,name='Employment\nin agriculture'],[bounding_box=[ 228.08284, 898.21729, 243.08284, 913.21729],caption_offset=[ -49.23639, -21.322464]]).
node(node01503,function,[],[comment='Employment in agriculture (% of the total employment of the nuts where the cell is)',complete=true,name=fn34,spec='if IDNUTS==999 then 0\nelseif IDNUTS==998 then 0\nelse element([employment_in_agriculture],IDNUTS)',units=1,value=(if 'IDNUTS'==999 then 0 elseif 'IDNUTS'==998 then 0 else element([employment_in_agriculture],'IDNUTS'))],[]).
node(node01504,variable,[],[name=var89],[bounding_box=[ 323.11385, 872.7769500000001, 388.11385, 937.77699],caption_offset=[0,0]]).
node(node01505,function,[],[name=fn37],[]).
node(node01554,variable,[],[complete=true,name='Agro\nthreshold'],[bounding_box=[ 227.78197, 838.9302, 242.78197, 853.9302],caption_offset=[ 41.048354, -39.821082]]).
node(node01555,function,[],[comment='Minimum threshold of agricultural landuse that should be kept in the cell (part of the cell)\nProtected areas are not taken into account',complete=true,name=fn56,spec='if scenario==1 then 0\nelse (if Employment_in_agriculture>20 then min(0.12,(Food_crops_ini_rel+PC_ini_rel+GFC_ini_rel))\nelse min(0.10,(Food_crops_ini_rel+PC_ini_rel+GFC_ini_rel)))',units=1,value=(if scenario==1 then 0 else(if 'Employment_in_agriculture'>20 then min( 0.12,'Food_crops_ini_rel'+'PC_ini_rel'+'GFC_ini_rel')else min( 0.1,'Food_crops_ini_rel'+'PC_ini_rel'+'GFC_ini_rel')))],[]).
node(node01556,variable,[],[name=var99],[bounding_box=[ 44.765188, 766.34637, 64.26518799999999, 785.84637],caption_offset=[0,0]]).
node(node01557,function,[],[name=fn57],[]).
node(node01560,variable,[],[name=var102],[bounding_box=[ 43.187784, 905.16795, 62.687784, 924.66795],caption_offset=[0,0]]).
node(node01561,function,[],[name=fn58],[]).
node(node00494,function,[],[name=fn16],[]).
node(node00496,variable,[],[name=var36],[bounding_box=[ 1126.6307, 1668.4806, 1146.1307, 1687.9806],caption_offset=[ 48.237908, -22.700192]]).
node(node00511,variable,[],[name=var28],[]).
node(node00578,function,[],[name=fn20],[]).
node(node00605,variable,[],[name=var46],[bounding_box=[ 1264.7902, 1801.2463, 1284.2902, 1820.7463],caption_offset=[0,0]]).
node(node00606,function,[],[name=fn22],[]).
node(node00607,variable,[],[name=var47],[]).
node(node00610,variable,[],[name=var48],[bounding_box=[ 1244.0267, 1717.1583, 1309.0267, 1782.1583],caption_offset=[0,0]]).
node(node00611,function,[],[name=fn24],[]).
node(node00612,variable,[],[name=var49],[]).
node(node00617,variable,[],[name=var51],[bounding_box=[ 1274.1331, 1875.9333, 1293.6331, 1895.4333],caption_offset=[0,0]]).
node(node00618,function,[],[name=fn25],[]).
node(node00619,variable,[],[name=var52],[]).
node(node00623,variable,[],[name=var53],[bounding_box=[ 1260.1048, 1673.2371, 1279.6048, 1692.7371],caption_offset=[0,0]]).
node(node00624,function,[],[name=fn26],[]).
node(node00643,variable,[],[name=var54],[]).
node(node00709,variable,[],[name=var5],[]).
node(node00718,variable,[],[name=var12],[]).
node(node00947,variable,[],[name=var11],[]).
node(node00954,variable,[],[name=var55],[]).
node(node01007,submodel,[node00003,node00004,node00005,node00008,node00009,node00024,node00034,node00035,node00040,node00046,node00063,node00110,node00112,node00113,node00127,node00180,node00185,node00192,node00197,node00200,node00202,node00215,node00216,node00217,node00231,node00232,node00237,node00331,node00365,node00366,node00471,node00477,node00512,node00513,node00547,node00548,node00549,node00561,node00858,node00956,node01043,node01044,node01045,node01046,node01050,node01051,node01052,node01053,node01054,node01056,node01057,node01092,node01093,node01099,node01119,node01157,node01159,node01169,node01258,node01259,node01261,node01390,node01425,node01619,node01623],[complete=true,enum_types=[],fill_colour='#80ff80',image_posn=none,multiplication_spec=[count=[]],name='Grassland and fooder crops',separate=0],[bounding_box=[ 132.52091, 546.59168, 1022.5897, 1027.7194],caption_offset=[ 42.107846, 0.22121685],hide_contents=0,internal_extent=[ -1.1776089e-13, 0.0, 921.96506, 498.36928]]).
links(node01007,[arc00051-arc00525,arc00155-arc00526,arc00261-arc00262,arc00335-arc00527,arc00335-arc00910,arc00548-arc00059,arc00549-arc00132,arc00550-arc00081,arc00550-arc00205,arc00551-arc00226,arc00551-arc00229,arc00552-arc00251,arc00553-arc00615,arc00554-arc01051,arc00632-arc00137,arc00639-arc00687,arc00924-arc00930,arc01048-arc00536,arc01050-arc00540,arc01082-arc01083,arc01260-arc01261,arc01269-arc01271,arc01314-arc01313,arc01327-arc01326,arc01434-arc01435,arc01593-arc01594,arc01805-arc01806,arc01809-arc01810]).
references(node01007,[obsolete,obsolete,ancestor(2),ancestor(3),ancestor(4)]).
node(node00003,cloud,[],[complete=true,name=cd1],[bounding_box=[ 342.61744, 69.69075599999999, 367.61744, 94.69075599999999]]).
node(node00004,function,[],[comment='Decline rate of the grassland area (square meters/year)',complete=true,name=fn3,spec='if diff_GFC<0 then 0 else diff_GFC/dt()',units=1,value=(if diff_GFC<0 then 0 else diff_GFC/dt(''))],[]).
node(node00005,variable,[],[complete=true,name='protected abs\nGFC'],[bounding_box=[ 548.24104, 208.04228, 563.24104, 223.04228],caption_offset=[0,0]]).
node(node00008,variable,[],[complete=true,name='GFC_adjusted'],[bounding_box=[ 372.60072, 155.51901, 387.60072, 170.51901],caption_offset=[ 4.4088132, -1.4696044]]).
node(node00009,function,[],[complete=true,name=fn4,units=1,value=(if 'GFC_abs'-protected_abs_GFC<0 then 'GFC_abs' else('GFC_abs'-protected_abs_GFC)*coef_remove_0+protected_abs_GFC)],[]).
node(node00024,function,[],[comment='Protected areas of grasslands (square meters)',complete=true,name=fn2,spec='protected_rel*surface',units=1,value=protected_rel*surface],[]).
node(node00034,variable,[],[complete=true,name='modifiable\nsurface bis'],[bounding_box=[ 58.826777, 375.98458, 73.82677700000001, 390.98458],caption_offset=[ 0.80028077, 1.4696044]]).
node(node00035,function,[],[comment='surface of grasslands that may potentially disapear in a second time (square meters)',complete=true,name=fn5,units=1,value=(if scenario==2 or scenario==3 then 'GFC_surface_abs_ite1'-protected_abs-area_to_keep_GFC elseif rent_grass_bis>='GFC_rent_thr' then 0 else 'GFC_surface_abs_ite1'-protected_abs-area_to_keep_GFC)],[]).
node(node00040,variable,[],[name=var14],[]).
node(node00046,variable,[],[name=var25],[]).
node(node00063,variable,[],[name=var12],[]).
node(node00110,variable,[],[name=var7],[bounding_box=[ 413.30951, 236.85393, 428.30951, 251.85393],caption_offset=[0,0]]).
node(node00112,function,[],[name=fn6],[]).
node(node00113,variable,[],[name=var9],[]).
node(node00127,variable,[],[name=var5],[bounding_box=[ 278.54609, 89.437648, 293.54609, 104.43765],caption_offset=[0,0]]).
node(node00180,variable,[],[name=var4],[]).
node(node00185,variable,[],[name=var2],[]).
node(node00192,variable,[],[name=var35],[]).
node(node00197,submodel,[node00006,node00120,node00199,node00271,node01037,node01038,node01039,node01073,node01154,node01155,node01156,node01164,node01165,node01168,node01564,node01614,node01615,node01618,node01622],[complete=true,enum_types=[],fill_colour='#00df38',image_posn=none,multiplication_spec=[count=[]],name=data,separate=0],[bounding_box=[ 756.28142, 26.432407, 889.41053, 482.00283],caption_offset=[ 0.0, 2.1316282e-14],hide_contents=0,internal_extent=[ -1.882745e-06, -47.027342, 133.12911, 408.54309]]).
links(node00197,[arc00027-arc00026,arc00045-arc00155,arc00045-arc01055,arc00238-arc00265,arc00238-arc01431,arc00363-arc00924,arc01313-arc01312,arc01315-arc01256,arc01315-arc01316,arc01326-arc01325,arc01336-arc01257,arc01336-arc01337,arc01801-arc01802,arc01801-arc01805,arc01803-arc01804,arc01803-arc01809]).
references(node00197,[obsolete,obsolete]).
node(node00006,variable,[],[comment='Protected areas of grasslands (part of the cell)',complete=true,name='protected rel',param_type=file,units=1],[bounding_box=[ 64.22721900000001, 47.663849, 79.22721900000001, 62.663849],caption_offset=[ 8.5889711, 1.4314974]]).
node(node00120,variable,[],[comment='Rentability of the grasslands (Euro/ha). 99999 or 999999 means that the cell is not suitable for grasslands',complete=true,name='rent_grass\n2000 2030',param_type=file,units=1],[bounding_box=[ 67.090214, 101.45095, 82.090214, 116.45095],caption_offset=[ 0.0, 1.4314958]]).
node(node00199,variable,[],[],[]).
node(node00271,variable,[],[name=var67],[]).
node(node01037,variable,[],[name=var17],[]).
node(node01038,variable,[],[name=var18],[]).
node(node01039,variable,[],[comment='Surface of grasslands in 2005 (part of the cell)',complete=true,max_val=1,min_val=0,name='GFC\nini_rel',param_type=file,units=1],[bounding_box=[ 62.473386, -22.851168, 81.973386, -3.3511678],caption_offset=[0,0]]).
node(node01073,variable,[],[name=var19],[]).
node(node01154,variable,[],[name=var46],[bounding_box=[ 83.758651, 291.0585, 98.758651, 306.0585],caption_offset=[0,0]]).
node(node01155,function,[],[name=fn20],[]).
node(node01156,variable,[],[name=var47],[]).
node(node01164,variable,[],[name=var62],[bounding_box=[ 45.374412, 343.68353, 60.374412, 358.68353],caption_offset=[0,0]]).
node(node01165,function,[],[name=fn22],[]).
node(node01168,variable,[],[name=var65],[]).
node(node01564,variable,[],[name=var105],[]).
node(node01614,variable,[],[comment='Rentability of the grasslands (Euro/ha). 99999 or 999999 means that the cell is not suitable for grasslands',complete=true,name='rent_grass\n2031 2060',param_type=file,units=1],[bounding_box=[ 67.48784000000001, 165.82671, 82.48784000000001, 180.82671],caption_offset=[ 1.0391676, 8.705668899999999]]).
node(node01615,variable,[],[comment='Rentability of the grasslands (Euro/ha). 99999 or 999999 means that the cell is not suitable for grasslands',complete=true,name='rent_grass\n2061 2080',param_type=file,units=1],[bounding_box=[ 64.548631, 230.4893, 79.548631, 245.4893],caption_offset=[ 0.0, 1.4314958]]).
node(node01618,variable,[],[name=var35],[]).
node(node01622,variable,[],[name=var75],[]).
node(node00200,function,[],[name=fn9],[]).
node(node00202,variable,[],[name=var11],[]).
node(node00215,variable,[],[name=var39],[bounding_box=[ 224.91692, 311.64185, 239.91692, 326.64185],caption_offset=[ -2.5614931, -1.0337947]]).
node(node00216,function,[],[name=fn7],[]).
node(node00217,variable,[],[name=var40],[]).
node(node00231,variable,[],[complete=true,name='surplus\ngrassland'],[bounding_box=[ 687.05804, 445.0179, 702.05804, 460.0179],caption_offset=[ 1.8340587, -0.8979751500000001]]).
node(node00232,function,[],[comment='Area formerly allocated to grasslands and now abandoned by this landuse type',complete=true,name=fn8,spec='if High_risks_floodable_areas==1 then 0 elseif Medium_risks_floodable_areas==1 then 0 elseif GFC_ini_rel-GFC_surface_rel<0 then 0 else GFC_ini_rel-GFC_surface_rel',units=1,value=(if 'High_risks_floodable_areas'==1 then 0 elseif 'Medium_risks_floodable_areas'==1 then 0 elseif 'GFC_ini_rel'-'GFC_surface_rel'<0 then 0 else 'GFC_ini_rel'-'GFC_surface_rel')],[]).
node(node00237,variable,[],[name=var49],[]).
node(node00331,variable,[],[name=var10],[]).
node(node00365,variable,[],[complete=true,name='diff\nGFC'],[bounding_box=[ 441.67213, 437.68306, 456.67213, 452.68306],caption_offset=[0,0]]).
node(node00366,function,[],[comment='Quantity of graslands that should be removed in the next timestep (square meters)',complete=true,name=fn11,spec='GFC_abs-GFC_surface_abs_ite2',units=1,value='GFC_abs'-'GFC_surface_abs_ite2'],[]).
node(node00471,variable,[],[name=var68],[]).
node(node00477,variable,[],[name=var15],[]).
node(node00512,compartment,[],[complete=true,name='GFC_abs'],[bounding_box=[ 530.57487, 68.660363, 570.57487, 98.660366],caption_offset=[ -1.4696044, -47.027342]]).
node(node00513,function,[],[comment='Area of grasslands (square meters)',complete=true,name=fn20,spec='GFC_ini_abs',units=1,value='GFC_ini_abs'],[]).
node(node00547,variable,[],[name=var19],[bounding_box=[ 619.07376, 120.62632, 684.07376, 185.62632],caption_offset=[ 34.355901, -14.314959]]).
node(node00548,function,[],[name=fn10],[]).
node(node00549,variable,[],[name=var20],[]).
node(node00561,variable,[],[name=var30],[]).
node(node00858,variable,[],[complete=true,name='rent_grass\nbis'],[bounding_box=[ 565.5493300000001, 271.61775, 580.5493300000001, 286.61775],caption_offset=[0,0]]).
node(node00956,function,[],[comment='Rentability of the grasslands when the risks of flooding are taken into account (Euro/ha). 99999 or 999999 means that the cell is not suitable for grasslands',complete=true,name=fn14,spec='if time()<=25 then(if High_risks_floodable_areas==1 then rent_min_grasslands elseif Medium_risks_floodable_areas==1 then rent_min_grasslands else rent_grass_2000_2030)elseif time()<=55 then(if High_risks_floodable_areas==1 then rent_min_grasslands elseif Medium_risks_floodable_areas==1 then rent_min_grasslands else rent_grass_2031_2060)else(if High_risks_floodable_areas==1 then rent_min_grasslands elseif Medium_risks_floodable_areas==1 then rent_min_grasslands else rent_grass_2061_2080)',units=1,value=(if time('')<=25 then(if 'High_risks_floodable_areas'==1 then rent_min_grasslands elseif 'Medium_risks_floodable_areas'==1 then rent_min_grasslands else rent_grass_2000_2030)elseif time('')<=55 then(if 'High_risks_floodable_areas'==1 then rent_min_grasslands elseif 'Medium_risks_floodable_areas'==1 then rent_min_grasslands else rent_grass_2031_2060)else(if 'High_risks_floodable_areas'==1 then rent_min_grasslands elseif 'Medium_risks_floodable_areas'==1 then rent_min_grasslands else rent_grass_2061_2080))],[]).
node(node01043,variable,[],[complete=true,name=weight],[bounding_box=[ 311.51663, 268.08775, 331.01663, 287.58775],caption_offset=[ 3.0656004, 0.084229517]]).
node(node01044,function,[],[comment='weight that takes a value between 0 and 1 indicating the part of the grassland areas of the cell that may potentially disapear when protected areas are not taken into account',complete=true,name=fn12,spec='if rent_grass_bis==99999 or rent_grass_bis==999999 then 1 elseif scenario ==3 then 1 elseif rent_grass_bis>=GFC_rent_thr then 0 else 1-(rent_grass_bis-rent_min_grasslands)/(GFC_rent_thr-rent_min_grasslands)*k_GFC',units=1,value=(if rent_grass_bis==99999 or rent_grass_bis==999999 then 1 elseif scenario==3 then 1 elseif rent_grass_bis>='GFC_rent_thr' then 0 else 1-(rent_grass_bis-rent_min_grasslands)/('GFC_rent_thr'-rent_min_grasslands)*k_GFC)],[]).
node(node01045,variable,[],[complete=true,name='modifiable\nsurface'],[bounding_box=[ 146.9007, 189.14345, 166.4007, 208.64345],caption_offset=[ -0.65061138, -47.629047]]).
node(node01046,function,[],[comment='surface of grasslands that may potentially disapear in a first time (square meters)',complete=true,name=fn13,units=1,value=min(weight*'GFC_adjusted',max('GFC_adjusted'-protected_abs_GFC-'GFC_to_keep_outside_pro_areas',0))],[]).
node(node01050,variable,[],[complete=true,name='GFC surface\nabs_ite1'],[bounding_box=[ 120.71442, 300.06672, 140.21443, 319.56672],caption_offset=[ 38.171606, 7.3480221]]).
node(node01051,function,[],[comment='Surface of grasslands after the first iteration of the model (square meters)',complete=true,name=fn18,spec='GFC_adjusted-modifiable_surface+modifiable_surface*Change_coefficient',units=1,value='GFC_adjusted'-modifiable_surface+modifiable_surface*'Change_coefficient'],[]).
node(node01052,variable,[],[complete=true,name='GFC surface\nabs_ite2'],[bounding_box=[ 124.39449, 436.1811, 143.89449, 455.6811],caption_offset=[0,0]]).
node(node01053,function,[],[comment='Surface of grasslands after the second iteration of the model (square meters)',complete=true,name=fn15,spec='(GFC_surface_abs_ite1-modifiable_surface_bis)+(modifiable_surface_bis*change_coef_bis)',units=1,value='GFC_surface_abs_ite1'-modifiable_surface_bis+modifiable_surface_bis*change_coef_bis],[]).
node(node01054,variable,[],[name=var8],[]).
node(node01056,variable,[],[name=var6],[]).
node(node01057,variable,[],[name=var13],[]).
node(node01092,variable,[],[name=var22],[bounding_box=[ 56.635765, 114.42092, 71.63576500000001, 129.42092],caption_offset=[ 55.844968, -13.22644]]).
node(node01093,function,[],[name=fn16],[]).
node(node01099,variable,[],[name=var23],[]).
node(node01119,variable,[],[name=var81],[]).
node(node01157,variable,[],[name=var48],[]).
node(node01159,variable,[],[name=var16],[]).
node(node01169,variable,[],[name=var66],[]).
node(node01258,variable,[],[complete=true,name='GFC ini_abs'],[bounding_box=[ 645.94713, 27.663415, 660.94713, 42.663415],caption_offset=[ 0.0, -32.331297]]).
node(node01259,function,[],[comment='Area of grasslands in 2005 (square meters)',complete=true,name=fn17,spec='GFC_ini_rel*surface',units=1,value='GFC_ini_rel'*surface],[]).
node(node01261,variable,[],[name=var82],[]).
node(node01390,submodel,[node01040,node01041,node01391,node01398,node01404],[complete=true,enum_types=[],fill_colour='#ff0000',image_posn=none,multiplication_spec=[count=[]],name='RESULT',separate=0],[bounding_box=[ 560.86205, 346.71955, 691.65684, 417.26056],caption_offset=[ 35.270506, -1.4696044],hide_contents=0,internal_extent=[0,0, 130.79479, 70.54101199999999]]).
links(node01390,[arc00400-arc01236,arc00637-arc01370,arc01229-arc00266,arc01229-arc00335]).
references(node01390,[obsolete,obsolete,ancestor(2),ancestor(3),ancestor(4)]).
node(node01040,variable,[],[complete=true,name='GFC surface\nrel'],[bounding_box=[ 100.39949, 29.650247, 119.89949, 49.150247],caption_offset=[ -51.398046, -24.983275]]).
node(node01041,function,[],[comment='Part of the cell covered by grasslands at the time of simulation',complete=true,max_val=1,min_val=0,name=fn1,spec='GFC_abs/surface',units=1,value='GFC_abs'/surface],[]).
node(node01391,variable,[],[],[]).
node(node01398,variable,[],[],[]).
node(node01404,variable,[],[],[]).
node(node01425,variable,[],[name=var33],[]).
node(node01619,variable,[],[name=var36],[]).
node(node01623,variable,[],[name=var76],[]).
node(node01008,submodel,[node00015,node00016,node00017,node00018,node00020,node00062,node00065,node00067,node00129,node00174,node00177,node00178,node00179,node00189,node00201,node00205,node00208,node00219,node00220,node00223,node00224,node00226,node00228,node00270,node00309,node00317,node00382,node00384,node00390,node00391,node00468,node00475,node00476,node00503,node00504,node00508,node00550,node00551,node00552,node00659,node00850,node00914,node00917,node00920,node00925,node00931,node01021,node01024,node01067,node01069,node01070,node01071,node01076,node01077,node01082,node01083,node01122,node01139,node01167,node01213,node01251,node01301,node01559,node01607,node01611],[complete=true,enum_types=[],fill_colour='#ffff80',image_posn=none,multiplication_spec=[count=[]],name='Food crops',separate=0],[bounding_box=[ 140.16548, 33.064072, 995.19012, 508.95818],caption_offset=[ 54.121144, -1.1504336],hide_contents=0,internal_extent=[0,0, 864.76079, 481.31311]]).
links(node01008,[arc00016-arc00268,arc00218-arc00217,arc00247-arc00257,arc00271-arc00259,arc00271-arc00563,arc00288-arc00559,arc00288-arc00699,arc00352-arc00080,arc00352-arc00349,arc00428-arc00422,arc00447-arc00453,arc00558-arc00607,arc00565-arc00085,arc00608-arc00254,arc00613-arc00618,arc00710-arc00711,arc00917-arc00913,arc01022-arc01021,arc01063-arc01070,arc01215-arc01216,arc01263-arc01264,arc01299-arc01298,arc01324-arc01327,arc01324-arc01331,arc01422-arc01423,arc01456-arc01553,arc01464-arc01465,arc01751-arc01752,arc01797-arc01798]).
references(node01008,[obsolete,obsolete,ancestor(2),ancestor(3),ancestor(4)]).
node(node00015,variable,[],[complete=true,name='modifiable\nsurface bis'],[bounding_box=[ 50.570408, 360.58917, 65.570398, 375.58917],caption_offset=[ -4.8838591, 2.9070441]]).
node(node00016,function,[],[comment='surface of croplands that may potentially disapear in a second time (square meters)',complete=true,name=fn1,units=1,value=(if scenario==2 or scenario==3 then 'FC_surface_abs_ite1'-protected_abs-area_to_keep_FC elseif rent_crop_bis>='FC_rent_thr' then 0 else 'FC_surface_abs_ite1'-protected_abs-area_to_keep_FC)],[]).
node(node00017,variable,[],[complete=true,name='protected abs\nFC'],[bounding_box=[ 535.51226, 207.9413, 550.51226, 222.9413],caption_offset=[ 0.016238737, 0.52092817]]).
node(node00018,function,[],[comment='Protected areas of croplands (square meters)',complete=true,name=fn3,spec='surface*protected_crop_rel',units=1,value=surface*protected_crop_rel],[]).
node(node00020,variable,[],[complete=true,name='rent_crop\nbis'],[bounding_box=[ 532.98682, 269.44361, 547.98682, 284.44361],caption_offset=[ 0.0, 1.4349175]]).
node(node00062,variable,[],[name=var1],[bounding_box=[ 385.83806, 250.77387, 400.83806, 265.77387],caption_offset=[ -1.4349175, -31.568184]]).
node(node00065,function,[],[name=fn4],[]).
node(node00067,variable,[],[name=var2],[]).
node(node00129,variable,[],[name=var10],[bounding_box=[ 51.711261, 137.25712, 66.71126099999999, 152.25713],caption_offset=[ 54.526864, -15.784092]]).
node(node00174,submodel,[node00001,node00013,node00021,node00316,node00342,node00350,node00945,node01064,node01131,node01132,node01134,node01162,node01166,node01248,node01295,node01540,node01558,node01610],[complete=true,enum_types=[],fill_colour='#fede01',image_posn=none,multiplication_spec=[count=[]],name=data,separate=0],[bounding_box=[ 684.79713, 25.894855, 820.52367, 466.59381],caption_offset=[ 15.374791, -1.3977083],hide_contents=0,internal_extent=[ -3.4337045e-06, -31.568186, 135.72654, 409.13079]]).
links(node00174,[arc00032-arc00033,arc00244-arc00029,arc00244-arc00247,arc00442-arc00561,arc00442-arc01456,arc00881-arc00886,arc00881-arc01797,arc01243-arc00752,arc01243-arc01251,arc01298-arc01297,arc01319-arc00606,arc01319-arc01320,arc01323-arc01324,arc01334-arc00949,arc01334-arc01335,arc01750-arc01751]).
references(node00174,[obsolete,obsolete]).
node(node00001,variable,[],[comment='Protected areas of croplands (part of the cell)',complete=true,name='protected\ncrop rel',param_type=file,units=1],[bounding_box=[ 65.34261100000001, 62.058589, 80.34261100000001, 77.058592],caption_offset=[ 5.5908304, 5.5908337]]).
node(node00013,variable,[],[comment='Rentability of the croplands (Euro/ha). 99999 or 999999 means that the cell is not suitable for croplands',complete=true,name='rent_crop\n2000 2030',param_type=file,units=1],[bounding_box=[ 62.484093, 133.20581, 77.484093, 148.20581],caption_offset=[ 0.0, -2.869835]]).
node(node00021,variable,[],[name=var3],[]).
node(node00316,variable,[],[name=var8],[]).
node(node00342,variable,[],[name=var9],[]).
node(node00350,variable,[],[name=var10],[]).
node(node00945,variable,[],[comment='Rentability of the croplands (Euro/ha). 99999 or 999999 means that the cell is not suitable for croplands',complete=true,name='rent_crop\n2031 2060',param_type=file,units=1],[bounding_box=[ 61.398015, 188.84782, 76.398015, 203.84782],caption_offset=[ 0.0, 0.0]]).
node(node01064,variable,[],[comment='Surface of croplands in 2005 (part of the cell)',complete=true,max_val=1,min_val=0,name='Food crops\nini_rel',param_type=file,units=1],[bounding_box=[ 60.614412, -4.7510635, 80.114412, 14.748936],caption_offset=[0,0]]).
node(node01131,variable,[],[name=var12],[bounding_box=[ 82.92180399999999, 293.57892, 97.92180399999999, 308.57892],caption_offset=[0,0]]).
node(node01132,function,[],[name=fn18],[]).
node(node01134,variable,[],[name=var14],[]).
node(node01162,variable,[],[complete=true,name='Medium risks\nfloodable\nareas',param_type=file,units=1],[bounding_box=[ 41.309183, 342.38399, 56.309183, 357.38399],caption_offset=[0,0]]).
node(node01166,variable,[],[name=var63],[]).
node(node01248,variable,[],[name=var11],[]).
node(node01295,variable,[],[comment='Rentability of the croplands (Euro/ha). 99999 or 999999 means that the cell is not suitable for croplands',complete=true,name='rent_crop\n2060 2080',param_type=file,units=1],[bounding_box=[ 41.30917, 244.8096, 56.30917, 259.8096],caption_offset=[ 1.0146402, 0.0]]).
node(node01540,variable,[],[name=var4],[]).
node(node01558,variable,[],[name=var100],[]).
node(node01610,variable,[],[name=var22],[]).
node(node00177,function,[],[name=fn30],[]).
node(node00178,variable,[],[name=var12],[]).
node(node00179,variable,[],[name=var3],[]).
node(node00189,variable,[],[complete=true,name='surplus\nfoodcrops'],[bounding_box=[ 628.46141, 421.64511, 643.46141, 436.64511],caption_offset=[ 0.281433, -0.98840786]]).
node(node00201,variable,[],[name=var7],[]).
node(node00205,cloud,[],[complete=true,name=cd3],[bounding_box=[ 317.89455, 89.209615, 342.89455, 114.20961]]).
node(node00208,variable,[],[name=var4],[]).
node(node00219,variable,[],[name=var43],[bounding_box=[ 226.92493, 307.2017, 241.92493, 322.2017],caption_offset=[ -5.3190746, 0.50157834]]).
node(node00220,function,[],[comment='Area formerly allocated to croplands and now abandoned by this landuse type',complete=true,name=fn5,spec='if High_risks_floodable_areas==1 then 0 elseif Medium_risks_floodable_areas==1 then 0 elseif Food_crops_ini_rel-FC_surface_rel<0 then 0 else Food_crops_ini_rel-FC_surface_rel',units=1,value=(if 'High_risks_floodable_areas'==1 then 0 elseif 'Medium_risks_floodable_areas'==1 then 0 elseif 'Food_crops_ini_rel'-'FC_surface_rel'<0 then 0 else 'Food_crops_ini_rel'-'FC_surface_rel')],[]).
node(node00223,function,[],[name=fn8],[]).
node(node00224,variable,[],[name=var44],[]).
node(node00226,function,[],[comment='Decline rate of the foodcrop area (square meters/year)',complete=true,name=fn7,spec='if diff_FC<0 then 0 else diff_FC/dt()',units=1,value=(if diff_FC<0 then 0 else diff_FC/dt(''))],[]).
node(node00228,function,[],[comment='Rentability of the foodcrops when the risks of flooding are taken into account (Euro/ha). 99999 or 999999 means that the cell is not suitable for foodcrops',complete=true,name=fn2,spec='if time()<=25 then(if High_risks_floodable_areas==1 then rent_min_foodcrops elseif Medium_risks_floodable_areas==1 then rent_min_foodcrops else rent_crop_2000_2030)elseif time()<=55 then(if High_risks_floodable_areas==1 then rent_min_foodcrops elseif Medium_risks_floodable_areas==1 then rent_min_foodcrops else rent_crop_2031_2060)else(if High_risks_floodable_areas==1 then rent_min_foodcrops elseif Medium_risks_floodable_areas==1 then rent_min_foodcrops else rent_crop_2060_2080)',units=1,value=(if time('')<=25 then(if 'High_risks_floodable_areas'==1 then rent_min_foodcrops elseif 'Medium_risks_floodable_areas'==1 then rent_min_foodcrops else rent_crop_2000_2030)elseif time('')<=55 then(if 'High_risks_floodable_areas'==1 then rent_min_foodcrops elseif 'Medium_risks_floodable_areas'==1 then rent_min_foodcrops else rent_crop_2031_2060)else(if 'High_risks_floodable_areas'==1 then rent_min_foodcrops elseif 'Medium_risks_floodable_areas'==1 then rent_min_foodcrops else rent_crop_2060_2080))],[]).
node(node00270,variable,[],[name=var11],[]).
node(node00309,variable,[],[name=var13],[]).
node(node00317,variable,[],[name=var6],[]).
node(node00382,variable,[],[name=var16],[]).
node(node00384,variable,[],[name=var5],[]).
node(node00390,variable,[],[complete=true,name='FC_adjusted'],[bounding_box=[ 335.80881, 177.43483, 350.80881, 192.43483],caption_offset=[0,0]]).
node(node00391,function,[],[complete=true,name=fn10,units=1,value=(if 'FC_abs'-protected_abs_FC<0 then 'FC_abs' else('FC_abs'-protected_abs_FC)*coef_remove_0+protected_abs_FC)],[]).
node(node00468,variable,[],[name=var41],[]).
node(node00475,variable,[],[complete=true,name='diff FC'],[bounding_box=[ 417.59911, 419.93587, 432.59911, 434.93587],caption_offset=[ 34.438019, -14.349174]]).
node(node00476,function,[],[comment='Quantity of foodcrops that should be removed in the next timestep (square meters)',complete=true,name=fn14,spec='FC_abs-FC_surface_abs_ite2',units=1,value='FC_abs'-'FC_surface_abs_ite2'],[]).
node(node00503,compartment,[],[complete=true,name='FC_abs'],[bounding_box=[ 506.97824, 89.579452, 546.97824, 119.57946],caption_offset=[ 6.5676693e-08, -47.352276]]).
node(node00504,function,[],[comment='Area of foodcrops (square meters)',complete=true,name=fn16,spec=food_crops_ini_abs,units=1,value=food_crops_ini_abs],[]).
node(node00508,variable,[],[name=var23],[]).
node(node00550,variable,[],[name=var21],[bounding_box=[ 583.29198, 135.72685, 648.29198, 200.72685],caption_offset=[ 34.942709, -15.374792]]).
node(node00551,function,[],[name=fn11],[]).
node(node00552,variable,[],[name=var22],[]).
node(node00659,variable,[],[complete=true,name='food crops\nini_abs'],[bounding_box=[ 608.44308, 48.29224, 623.44308, 63.29224],caption_offset=[ 1.4349175, -47.352276]]).
node(node00850,variable,[],[name=var54],[]).
node(node00914,variable,[],[name=var24],[]).
node(node00917,variable,[],[name=var45],[bounding_box=[ 271.22178, 110.02617, 286.22178, 125.02617],caption_offset=[0,0]]).
node(node00920,function,[],[name=fn28],[]).
node(node00925,variable,[],[name=var46],[]).
node(node00931,variable,[],[name=var47],[]).
node(node01021,submodel,[node01023,node01080,node01081,node01310,node01311],[complete=true,enum_types=[],fill_colour='#ff0000',image_posn=none,multiplication_spec=[count=[]],name='RESULT',separate=0],[bounding_box=[ 522.67344, 324.12181, 634.597, 392.99784],caption_offset=[ 27.263432, 0.0],hide_contents=0,internal_extent=[ 0.0, 0.0, 111.92356, 68.87603799999999]]).
links(node01021,[arc01178-arc00288,arc01178-arc01250,arc01248-arc01210,arc01249-arc01226]).
references(node01021,[obsolete,obsolete,ancestor(2),ancestor(3),ancestor(4)]).
node(node01023,variable,[],[],[]).
node(node01080,variable,[],[complete=true,name='FC surface\nrel'],[bounding_box=[ 86.279078, 24.806537, 105.77908, 44.306537],caption_offset=[ -45.917359, -22.958679]]).
node(node01081,function,[],[comment='Part of the cell covered by croplands at the time of simulation',complete=true,max_val=1,min_val=0,name=fn19,spec='FC_abs/surface',units=1,value='FC_abs'/surface],[]).
node(node01310,variable,[],[],[]).
node(node01311,variable,[],[],[]).
node(node01024,variable,[],[name=var62],[]).
node(node01067,variable,[],[complete=true,name=weight],[bounding_box=[ 280.88689, 264.38111, 300.38689, 283.88111],caption_offset=[ 6.5398871, -1.4347485]]).
node(node01069,function,[],[comment='weight that takes a value between 0 and 1 indicating the part of the cropland areas of the cell that may potentially disapear when protected areas are not taken into account',complete=true,name=fn12,spec='if rent_crop_bis==99999 or rent_crop_bis==999999 then 1 elseif scenario ==3 then 1 elseif rent_crop_bis>=FC_rent_thr then 0 else 1-(rent_crop_bis-rent_min_foodcrops)/(FC_rent_thr-rent_min_foodcrops)*k_foodcrops',units=1,value=(if rent_crop_bis==99999 or rent_crop_bis==999999 then 1 elseif scenario==3 then 1 elseif rent_crop_bis>='FC_rent_thr' then 0 else 1-(rent_crop_bis-rent_min_foodcrops)/('FC_rent_thr'-rent_min_foodcrops)*k_foodcrops)],[]).
node(node01070,variable,[],[complete=true,name='modifiable\nsurface'],[bounding_box=[ 138.99415, 218.39753, 158.49415, 237.89752],caption_offset=[ -45.680926, -16.236644]]).
node(node01071,function,[],[comment='surface of croplands that may potentially disapear in a first time (square meters)',complete=true,name=fn13,units=1,value=min(weight*'FC_adjusted',max('FC_adjusted'-protected_abs_FC-'FC_to_keep_outside_pro_areas',0))],[]).
node(node01076,variable,[],[complete=true,name='FC surface\nabs_ite1'],[bounding_box=[ 119.17364, 299.61723, 138.67364, 319.11723],caption_offset=[ -5.5324914, -0.025897333]]).
node(node01077,function,[],[comment='Surface of croplands after the first iteration of the model (square meters)',complete=true,name=fn18,spec='FC_adjusted-modifiable_surface+modifiable_surface*Change_coefficient',units=1,value='FC_adjusted'-modifiable_surface+modifiable_surface*'Change_coefficient'],[]).
node(node01082,variable,[],[complete=true,name='FC surface\nabs_ite2'],[bounding_box=[ 117.43167, 416.95081, 136.93167, 436.45081],caption_offset=[ 1.9396063, 0.074418333]]).
node(node01083,function,[],[comment='Surface of croplands after the second iteration of the model (square meters)',complete=true,name=fn15,spec='(FC_surface_abs_ite1-modifiable_surface_bis)+(modifiable_surface_bis*Change_coef_bis)',units=1,value='FC_surface_abs_ite1'-modifiable_surface_bis+modifiable_surface_bis*'Change_coef_bis'],[]).
node(node01122,variable,[],[name=var83],[]).
node(node01139,variable,[],[name=var15],[]).
node(node01167,variable,[],[name=var64],[]).
node(node01213,function,[],[comment='Area of foodcrops in 2005 (square meters)',complete=true,name=fn6,spec='Food_crops_ini_rel*surface',units=1,value='Food_crops_ini_rel'*surface],[]).
node(node01251,variable,[],[name=var14],[]).
node(node01301,variable,[],[name=var51],[]).
node(node01559,variable,[],[name=var101],[]).
node(node01607,variable,[],[name=var8],[]).
node(node01611,variable,[],[name=var25],[]).
node(node01016,submodel,[node00010,node00025,node00048,node00049,node00052,node00060,node00066,node00111,node00124,node00125,node00131,node00190,node00191,node00193,node00207,node00212,node00213,node00229,node00230,node00238,node00282,node00297,node00312,node00344,node00346,node00351,node00376,node00377,node00378,node00379,node00380,node00381,node00383,node00481,node00564,node00565,node00571,node01074,node01075,node01085,node01094,node01095,node01096,node01097,node01098,node01101,node01102,node01105,node01106,node01108,node01109,node01110,node01111,node01123,node01152,node01160,node01173,node01268,node01269,node01270,node01468,node01493,node01563,node01631,node01635],[complete=true,enum_types=[],fill_colour='#ff8000',image_posn=none,multiplication_spec=[count=[]],name='Permanent crops',separate=0],[bounding_box=[ 131.72762, 1069.6952, 1018.6963, 1534.1908],caption_offset=[ 41.412304, -0.55528651],hide_contents=0,internal_extent=[ -9.518579599999999e-06, 1.4187621, 886.96869, 465.91441]]).
links(node01016,[arc00066-arc00619,arc00223-arc00212,arc00235-arc00241,arc00344-arc00628,arc00344-arc00915,arc00633-arc00407,arc00648-arc00076,arc00659-arc00216,arc00659-arc00658,arc00660-arc00243,arc00661-arc00326,arc00676-arc00612,arc00677-arc01098,arc00693-arc00694,arc00894-arc00893,arc00894-arc01267,arc01085-arc01258,arc01105-arc00642,arc01107-arc00647,arc01126-arc01128,arc01254-arc01255,arc01308-arc01304,arc01331-arc01330,arc01443-arc01444,arc01643-arc01644,arc01755-arc01756,arc01817-arc01818,arc01821-arc01822]).
references(node01016,[obsolete,obsolete,ancestor(2),ancestor(3),ancestor(4)]).
node(node00010,variable,[],[complete=true,name='protected abs\nPC'],[bounding_box=[ 540.59123, 183.26439, 555.59123, 198.26439],caption_offset=[ 1.4314959, 4.2944877]]).
node(node00025,function,[],[comment='Protected areas of permanent crops (square meters)',complete=true,name=fn1,spec='surface*protected_rel',units=1,value=surface*protected_rel],[]).
node(node00048,variable,[],[complete=true,name='modifiable\nsurface bis'],[bounding_box=[ 57.515195, 329.23833, 72.51519500000001, 344.23833],caption_offset=[ -0.82175621, 1.3552785]]).
node(node00049,function,[],[comment='surface of permanent crops that may potentially disapear in a second time (square meters)',complete=true,name=fn3,units=1,value=(if scenario==2 or scenario==3 then 'PC_surface_abs_ite1'-protected_abs-area_to_keep_PC elseif rent_pcrops_bis>='PC_rent_thr' then 0 else 'PC_surface_abs_ite1'-protected_abs-area_to_keep_PC)],[]).
node(node00052,variable,[],[name=var6],[]).
node(node00060,variable,[],[name=var30],[]).
node(node00066,variable,[],[name=var8],[bounding_box=[ 632.81104, 138.39666, 647.81104, 153.39666],caption_offset=[ 37.2189, -14.314962]]).
node(node00111,function,[],[name=fn5],[]).
node(node00124,cloud,[],[complete=true,name=cd1],[bounding_box=[ 356.66282, 67.26700200000001, 381.66282, 92.26700200000001]]).
node(node00125,function,[],[comment='Decline rate of the permanent crop area (square meters/year)',complete=true,name=fn2,spec='if diff_PC<0 then 0 else diff_PC/dt()',units=1,value=(if diff_PC<0 then 0 else diff_PC/dt(''))],[]).
node(node00131,variable,[],[name=var7],[bounding_box=[ 222.10787, 282.57349, 237.10787, 297.57349],caption_offset=[ -1.8144089, -1.2308945]]).
node(node00190,variable,[],[name=var1],[bounding_box=[ 58.047732, 95.01628100000001, 73.047732, 110.01628],caption_offset=[ 54.375375, -16.165652]]).
node(node00191,function,[],[name=fn6],[]).
node(node00193,variable,[],[name=var3],[]).
node(node00207,function,[],[name=fn4],[]).
node(node00212,variable,[],[name=var10],[]).
node(node00213,variable,[],[name=var11],[]).
node(node00229,variable,[],[complete=true,name='PC_adjusted'],[bounding_box=[ 381.5255, 141.78634, 396.5255, 156.78634],caption_offset=[0,0]]).
node(node00230,function,[],[complete=true,name=fn8,units=1,value=(if 'PC_abs'-protected_abs_PC<0 then 'PC_abs' else('PC_abs'-protected_abs_PC)*coef_remove_0+protected_abs_PC)],[]).
node(node00238,submodel,[node00002,node00187,node00239,node01079,node01090,node01091,node01125,node01147,node01148,node01149,node01170,node01171,node01172,node01277,node01562,node01626,node01627,node01630,node01634],[complete=true,enum_types=[],fill_colour='#fede01',image_posn=none,multiplication_spec=[count=[]],name=data,separate=0],[bounding_box=[ 726.12414, 23.325089, 849.11963, 454.14376],caption_offset=[ 0.0, 0.0],hide_contents=0,internal_extent=[ -4.4480128e-06, -2.9392097, 127.40314, 443.31825]]).
links(node00238,[arc00388-arc00010,arc00389-arc01085,arc00389-arc01310,arc00390-arc00405,arc00390-arc01452,arc01304-arc01303,arc01317-arc01318,arc01317-arc01339,arc01330-arc01329,arc01332-arc01333,arc01332-arc01340,arc01754-arc01755,arc01813-arc01814,arc01813-arc01817,arc01815-arc01816,arc01815-arc01821]).
references(node00238,[obsolete,obsolete]).
node(node00002,variable,[],[comment='Protected areas of permanent crops (part of the cell)',complete=true,name='protected rel',param_type=file,units=1],[bounding_box=[ 56.955419, 85.822177, 71.95541900000001, 100.82218],caption_offset=[ 2.8629883, 4.2944889]]).
node(node00187,variable,[],[comment='Rentability of the permanent crops (Euro/ha). 99999 or 999999 means that the cell is not suitable for permanent crops',complete=true,name='rent_pcrops\n2000 2030',param_type=file,units=1],[bounding_box=[ 58.577467, 137.84809, 73.577467, 152.84809],caption_offset=[ 10.921823, 4.9413278]]).
node(node00239,variable,[],[],[]).
node(node01079,variable,[],[name=var22],[]).
node(node01090,variable,[],[name=var23],[]).
node(node01091,variable,[],[comment='Surface of permanent crops in 2005 (part of the cell)',complete=true,max_val=1,min_val=0,name='PC\nini_rel',param_type=file,units=1],[bounding_box=[ 54.911313, 16.291699, 74.41131300000001, 35.791699],caption_offset=[ 1.2731035, 0.0]]).
node(node01125,variable,[],[name=var24],[]).
node(node01147,variable,[],[name=var42],[bounding_box=[ 81.105619, 318.4852, 96.105619, 333.4852],caption_offset=[0,0]]).
node(node01148,function,[],[name=fn19],[]).
node(node01149,variable,[],[name=var43],[]).
node(node01170,variable,[],[name=var67],[bounding_box=[ 41.549296, 375.7819, 56.549296, 390.7819],caption_offset=[0,0]]).
node(node01171,function,[],[name=fn23],[]).
node(node01172,variable,[],[name=var68],[]).
node(node01277,variable,[],[name=var98],[]).
node(node01562,variable,[],[name=var103],[]).
node(node01626,variable,[],[comment='Rentability of the permanent crops (Euro/ha). 99999 or 999999 means that the cell is not suitable for permanent crops',complete=true,name='rent_pcrops\n2031 2060',param_type=file,units=1],[bounding_box=[ 65.09767100000001, 199.39462, 80.09767100000001, 214.39462],caption_offset=[ 6.7651519, 2.862992]]).
node(node01627,variable,[],[comment='Rentability of the permanent crops (Euro/ha). 99999 or 999999 means that the cell is not suitable for permanent crops',complete=true,name='rent_pcrops\n2061 2080',param_type=file,units=1],[bounding_box=[ 38.644784, 258.17881, 53.644784, 273.17881],caption_offset=[ 8.8434876, 2.862992]]).
node(node01630,variable,[],[name=var91],[]).
node(node01634,variable,[],[name=var97],[]).
node(node00282,variable,[],[name=var23],[bounding_box=[ 399.43185, 213.22551, 414.43185, 228.22551],caption_offset=[0,0]]).
node(node00297,function,[],[name=fn7],[]).
node(node00312,variable,[],[name=var24],[]).
node(node00344,variable,[],[name=var2],[]).
node(node00346,variable,[],[name=var42],[]).
node(node00351,variable,[],[name=var16],[]).
node(node00376,variable,[],[name=var14],[bounding_box=[ 292.09445, 79.40989399999999, 307.09445, 94.40989399999999],caption_offset=[0,0]]).
node(node00377,function,[],[name=fn9],[]).
node(node00378,variable,[],[name=var15],[]).
node(node00379,variable,[],[complete=true,name='diff\nPC'],[bounding_box=[ 442.53225, 401.4198, 457.53225, 416.4198],caption_offset=[0,0]]).
node(node00380,variable,[],[complete=true,name='surplus\nPC'],[bounding_box=[ 664.71119, 389.76685, 679.71119, 404.76685],caption_offset=[0,0]]).
node(node00381,function,[],[comment='Area formerly allocated to permanent crops and now abandoned by this landuse type',complete=true,name=fn10,spec='if High_risks_floodable_areas==1 then 0 elseif Medium_risks_floodable_areas==1 then 0 elseif PC_ini_rel-PC_surface_rel<0 then 0 else PC_ini_rel-PC_surface_rel',units=1,value=(if 'High_risks_floodable_areas'==1 then 0 elseif 'Medium_risks_floodable_areas'==1 then 0 elseif 'PC_ini_rel'-'PC_surface_rel'<0 then 0 else 'PC_ini_rel'-'PC_surface_rel')],[]).
node(node00383,function,[],[comment='Quantity of permanent crops that should be removed in the next timestep (square meters)',complete=true,name=fn11,spec='PC_abs-PC_surface_abs_ite2',units=1,value='PC_abs'-'PC_surface_abs_ite2'],[]).
node(node00481,variable,[],[name=var20],[]).
node(node00564,compartment,[],[complete=true,name='PC_abs'],[bounding_box=[ 525.08935, 59.091939, 565.08935, 89.091939],caption_offset=[ 2.8375241, -49.656672]]).
node(node00565,function,[],[comment='Area of permanent crops (square meters)',complete=true,name=fn22,spec='PC_ini_abs',units=1,value='PC_ini_abs'],[]).
node(node00571,variable,[],[name=var32],[]).
node(node01074,variable,[],[complete=true,name='rent_pcrops\nbis'],[bounding_box=[ 540.42684, 247.19028, 555.42684, 262.19028],caption_offset=[0,0]]).
node(node01075,function,[],[comment='Rentability of the permanent crops when the risks of flooding are taken into account (Euro/ha). 99999 or 999999 means that the cell is not suitable for permanent crops',complete=true,name=fn16,spec='if time()<=25 then(if High_risks_floodable_areas==1 then rent_min_pcrops elseif Medium_risks_floodable_areas==1 then rent_min_pcrops else rent_pcrops_2000_2030)elseif time()<=55 then(if High_risks_floodable_areas==1 then rent_min_pcrops elseif Medium_risks_floodable_areas==1 then rent_min_pcrops else rent_pcrops_2031_2060)else(if High_risks_floodable_areas==1 then rent_min_pcrops elseif Medium_risks_floodable_areas==1 then rent_min_pcrops else rent_pcrops_2061_2080)',units=1,value=(if time('')<=25 then(if 'High_risks_floodable_areas'==1 then rent_min_pcrops elseif 'Medium_risks_floodable_areas'==1 then rent_min_pcrops else rent_pcrops_2000_2030)elseif time('')<=55 then(if 'High_risks_floodable_areas'==1 then rent_min_pcrops elseif 'Medium_risks_floodable_areas'==1 then rent_min_pcrops else rent_pcrops_2031_2060)else(if 'High_risks_floodable_areas'==1 then rent_min_pcrops elseif 'Medium_risks_floodable_areas'==1 then rent_min_pcrops else rent_pcrops_2061_2080))],[]).
node(node01085,variable,[],[name=var51],[]).
node(node01094,variable,[],[name=var9],[]).
node(node01095,variable,[],[complete=true,name=weight],[bounding_box=[ 326.4342, 248.30272, 341.4342, 263.30272],caption_offset=[ 0.065710614, 1.7755225]]).
node(node01096,function,[],[comment='weight that takes a value between 0 and 1 indicating the part of the permanent crops areas of the cell that may potentially disapear when protected areas are not taken into account',complete=true,name=fn12,spec='if rent_pcrops_bis==99999 or rent_pcrops_bis==999999 then 1 elseif scenario ==3 then 1 elseif rent_pcrops_bis>=PC_rent_thr then 0 else 1-(rent_pcrops_bis-rent_min_pcrops)/(PC_rent_thr-rent_min_pcrops)*k_PC',units=1,value=(if rent_pcrops_bis==99999 or rent_pcrops_bis==999999 then 1 elseif scenario==3 then 1 elseif rent_pcrops_bis>='PC_rent_thr' then 0 else 1-(rent_pcrops_bis-rent_min_pcrops)/('PC_rent_thr'-rent_min_pcrops)*k_PC)],[]).
node(node01097,variable,[],[complete=true,name='modifiable\nsurface'],[bounding_box=[ 134.47713, 168.84736, 149.47713, 183.84736],caption_offset=[ -0.65061081, -49.060542]]).
node(node01098,function,[],[comment='surface of permanent crops that may potentially disapear in a first time (square meters)',complete=true,name=fn13,units=1,value=min(weight*'PC_adjusted',max('PC_adjusted'-protected_abs_PC-'PC_to_keep_outside_pro_areas',0))],[]).
node(node01101,variable,[],[complete=true,name='PC surface\nabs_ite1'],[bounding_box=[ 119.67998, 264.32549, 134.67998, 279.32549],caption_offset=[0,0]]).
node(node01102,function,[],[comment='Surface of permanent crops after the first iteration of the model (square meters)',complete=true,name=fn18,spec='PC_adjusted-modifiable_surface+modifiable_surface*Change_coefficient',units=1,value='PC_adjusted'-modifiable_surface+modifiable_surface*'Change_coefficient'],[]).
node(node01105,variable,[],[complete=true,name='PC surface\nabs_ite2'],[bounding_box=[ 121.56216, 401.49099, 136.56216, 416.49099],caption_offset=[ -6.3035727, 2.7045995]]).
node(node01106,function,[],[comment='Surface of permanent crops after the second iteration of the model (square meters)',complete=true,name=fn15,spec='(PC_surface_abs_ite1-modifiable_surface_bis)+(modifiable_surface_bis*change_coef_bis)',units=1,value='PC_surface_abs_ite1'-modifiable_surface_bis+modifiable_surface_bis*change_coef_bis],[]).
node(node01108,variable,[],[name=var77],[]).
node(node01109,variable,[],[name=var18],[]).
node(node01110,variable,[],[name=var62],[]).
node(node01111,variable,[],[name=var28],[]).
node(node01123,variable,[],[name=var73],[]).
node(node01152,variable,[],[name=var44],[]).
node(node01160,variable,[],[name=var4],[]).
node(node01173,variable,[],[name=var69],[]).
node(node01268,variable,[],[complete=true,name='PC ini_abs'],[bounding_box=[ 632.64637, 24.029091, 647.64637, 39.029091],caption_offset=[ 0.0, -32.331304]]).
node(node01269,function,[],[comment='Area of permanent crops in 2005 (square meters)',complete=true,name=fn20,spec='surface*PC_ini_rel',units=1,value=surface*'PC_ini_rel'],[]).
node(node01270,variable,[],[name=var91],[]).
node(node01468,variable,[],[name=var31],[]).
node(node01493,submodel,[node01103,node01104,node01520,node01521,node01522],[complete=true,enum_types=[],fill_colour='#ff0000',image_posn=none,multiplication_spec=[count=[]],name='RESULT',separate=0],[bounding_box=[ 537.99549, 308.18769, 661.42779, 370.61322],caption_offset=[ 22.700193, 1.0032295e-08],hide_contents=0,internal_extent=[ 1.1368684e-13, -4.2562862, 123.4323, 58.169245]]).
links(node01493,[arc00626-arc01412,arc00640-arc01478,arc01400-arc00344,arc01400-arc00406]).
references(node01493,[obsolete,obsolete,ancestor(2),ancestor(3),ancestor(4)]).
node(node01103,variable,[],[complete=true,name='PC surface\nrel'],[bounding_box=[ 95.909386, 27.70133, 110.90939, 42.70133],caption_offset=[ -47.027352, -24.983281]]).
node(node01104,function,[],[comment='Part of the cell covered by permanent crops at the time of simulation',complete=true,max_val=1,min_val=0,name=fn19,spec='PC_abs/surface',units=1,value='PC_abs'/surface],[]).
node(node01520,variable,[],[],[]).
node(node01521,variable,[],[],[]).
node(node01522,variable,[],[],[]).
node(node01563,variable,[],[name=var104],[]).
node(node01631,variable,[],[name=var92],[]).
node(node01635,variable,[],[name=var98],[]).
node(node01062,variable,[],[name=var39],[]).
node(node01065,variable,[],[name=var63],[]).
node(node01088,variable,[],[name=var56],[]).
node(node01112,variable,[],[name=var64],[]).
node(node01137,variable,[],[name=var91],[]).
node(node01146,variable,[],[name=var41],[]).
node(node01153,variable,[],[name=var45],[]).
node(node01158,variable,[],[name=var57],[]).
node(node01163,variable,[],[name=var37],[]).
node(node01185,variable,[],[name=var58],[]).
node(node01205,variable,[],[name=var44],[]).
node(node01244,variable,[],[name=var13],[]).
node(node01247,variable,[],[name=var60],[]).
node(node01252,variable,[],[name=var61],[]).
node(node01262,variable,[],[name=var83],[]).
node(node01271,variable,[],[name=var92],[]).
node(node01302,variable,[],[name=var59],[]).
node(node01426,variable,[],[name=var43],[]).
node(node01469,variable,[],[name=var62],[]).
node(node01500,variable,[],[name=var69],[]).
node(node01506,variable,[],[name=var93],[]).
node(node01568,variable,[],[name=var108],[]).
node(node01608,variable,[],[name=var10],[]).
node(node01612,variable,[],[name=var27],[]).
node(node01620,variable,[],[name=var65],[]).
node(node01624,variable,[],[name=var77],[]).
node(node01632,variable,[],[name=var94],[]).
node(node01636,variable,[],[name=var99],[]).
node(node00072,submodel,[node00135,node00196,node00269,node00387,node00407,node00411,node00415,node00428,node00429,node00430,node00442,node00462,node00463,node00470,node00480,node00490,node00495,node00499,node00556,node00557,node00558,node00620,node00621,node00625,node00629,node00630,node00635,node00640,node00644,node00645,node00648,node00652,node00653,node00655,node00668,node00669,node00672,node00678,node00683,node00688,node00693,node00694,node00698,node00700,node00701,node00710,node00836,node00872,node00881,node01197,node01206,node01207,node01208,node01209,node01210,node01238,node01245,node01260,node01535,node01550,node01584,node01585],[complete=true,enum_types=[],fill_colour='#00bf78',image_posn=none,multiplication_spec=[count=[]],name='Forest',separate=0],[bounding_box=[ 242.28881, 3532.9823, 1296.4116, 4259.9969],caption_offset=[ 83.40511100000001, 4.4811077e-07],hide_contents=0,internal_extent=[ -273.25673, -8.889946800000001, 780.8660599999999, 718.12456]]).
links(node00072,[arc00144-arc00145,arc00314-arc00313,arc00440-arc00431,arc00448-arc00452,arc00451-arc00450,arc00456-arc00427,arc00472-arc00435,arc00514-arc00513,arc00519-arc00521,arc00537-arc00538,arc00543-arc00544,arc00625-arc00624,arc00718-arc00717,arc00723-arc00722,arc00737-arc00738,arc00746-arc00747,arc00811-arc00810,arc00859-arc00858,arc00868-arc00873,arc00953-arc00952,arc01004-arc01002,arc01142-arc01141,arc01170-arc01169,arc01367-arc01214,arc01376-arc01377,arc01376-arc01419,arc01413-arc01416]).
references(node00072,[obsolete,obsolete,local(arc00089),ancestor(2),ancestor(3),ancestor(4)]).
node(node00135,variable,[],[comment='Identifier of the country that the cell belongs to',complete=true,name=countryID,param_type=file,units=1],[bounding_box=[ -155.48249, 127.07847, -140.48249, 142.07847],caption_offset=[ -4.2426404, -46.669044]]).
node(node00196,variable,[],[name=var4],[]).
node(node00269,variable,[],[name=var5],[]).
node(node00387,submodel,[node00265,node00266,node00268,node00388,node00404,node00405,node00406,node00408,node00409,node00410,node00412,node00413,node00414,node00464,node00465,node00469,node00631,node00632,node00634,node00636,node00637,node00639,node00654,node00674,node00675,node00677,node00679,node00680,node00682,node00684,node00685,node00687,node01551,node01552,node01553,node01577,node01578,node01579,node01580,node01581,node01582,node01583],[complete=true,enum_types=[],fill_colour='#008080',image_posn=none,multiplication_spec=[count=[]],name=data,separate=0],[bounding_box=[ 561.54494, 37.771221, 719.44994, 681.2431800000001],caption_offset=[ 13.900852, 16.681022],hide_contents=0,internal_extent=[ 0.0, 0.0, 157.905, 643.47195]]).
links(node00387,[arc00313-arc00312,arc00315-arc00316,arc00315-arc01774,arc00427-arc00426,arc00431-arc00430,arc00435-arc00434,arc00513-arc00512,arc00515-arc00517,arc00515-arc01743,arc00530-arc00531,arc00530-arc01744,arc00532-arc00533,arc00532-arc01745,arc00534-arc00535,arc00534-arc01773,arc00717-arc00716,arc00722-arc00721,arc00724-arc00725,arc00724-arc01742,arc00726-arc00727,arc00726-arc01741,arc00730-arc00743,arc00858-arc00856,arc00952-arc00899,arc01002-arc00966,arc01006-arc01010,arc01006-arc01775,arc01012-arc01016,arc01012-arc01776,arc01020-arc01053,arc01020-arc01777]).
references(node00387,[obsolete,obsolete,ancestor(2)]).
node(node00265,variable,[],[name=var1],[bounding_box=[ 48.498915, 464.59025, 63.498915, 479.59025],caption_offset=[ 40.438843, -16.936875]]).
node(node00266,function,[],[name=fn1],[]).
node(node00268,variable,[],[name=var4],[]).
node(node00388,variable,[],[comment='Surface of forests in 2005 (part of the cell)',complete=true,name='forest\nini rel',param_type=file,units=1],[bounding_box=[ 63.709859, 57.583262, 78.70985899999999, 72.583262],caption_offset=[ 37.812541, -25.455843]]).
node(node00404,variable,[],[name=var21],[bounding_box=[ 57.484314, 290.22666, 72.484314, 305.22666],caption_offset=[ 39.193067, -25.388468]]).
node(node00405,function,[],[name=fn4],[]).
node(node00406,variable,[],[name=var22],[]).
node(node00408,variable,[],[name=var24],[bounding_box=[ 58.221373, 352.01422, 73.221373, 367.01422],caption_offset=[ 47.408848, -19.933739]]).
node(node00409,function,[],[name=fn5],[]).
node(node00410,variable,[],[name=var25],[]).
node(node00412,variable,[],[name=var27],[bounding_box=[ 52.988365, 408.47605, 67.988365, 423.47605],caption_offset=[ 44.580421, -19.900052]]).
node(node00413,function,[],[name=fn6],[]).
node(node00414,variable,[],[name=var28],[]).
node(node00464,variable,[],[name=var16],[bounding_box=[ 54.556013, 235.20917, 69.55601299999999, 250.20917],caption_offset=[ 44.580421, -16.970562]]).
node(node00465,function,[],[name=fn7],[]).
node(node00469,variable,[],[name=var18],[]).
node(node00631,variable,[],[name=var59],[bounding_box=[ 64.490262, 189.32218, 79.490262, 204.32218],caption_offset=[ 43.233582, -19.664239]]).
node(node00632,function,[],[name=fn12],[]).
node(node00634,variable,[],[name=var61],[]).
node(node00636,variable,[],[name=var63],[bounding_box=[ 63.679755, 137.92041, 78.679755, 152.92041],caption_offset=[ 37.778854, -24.075317]]).
node(node00637,function,[],[name=fn13],[]).
node(node00639,variable,[],[name=var65],[]).
node(node00654,variable,[],[name=var79],[]).
node(node00674,variable,[],[name=var96],[bounding_box=[ 48.706567, 516.29347, 63.706567, 531.29347],caption_offset=[ 33.502525, -22.627416]]).
node(node00675,function,[],[name=fn21],[]).
node(node00677,variable,[],[name=var98],[]).
node(node00679,variable,[],[name=var100],[bounding_box=[ 51.20456, 558.83081, 66.20456, 573.83081],caption_offset=[ 43.166207, -26.903744]]).
node(node00680,function,[],[name=fn22],[]).
node(node00682,variable,[],[name=var102],[]).
node(node00684,variable,[],[name=var104],[bounding_box=[ 51.809657, 605.87392, 66.809657, 620.87392],caption_offset=[ 32.155687, -22.694791]]).
node(node00685,function,[],[name=fn23],[]).
node(node00687,variable,[],[name=var106],[]).
node(node01551,variable,[],[name=var2],[]).
node(node01552,variable,[],[name=var3],[]).
node(node01553,variable,[],[name=var5],[]).
node(node01577,variable,[],[name=var7],[]).
node(node01578,variable,[],[name=var8],[]).
node(node01579,variable,[],[name=var9],[]).
node(node01580,variable,[],[name=var10],[]).
node(node01581,variable,[],[name=var11],[]).
node(node01582,variable,[],[name=var12],[]).
node(node01583,variable,[],[name=var13],[]).
node(node00407,variable,[],[name=var23],[]).
node(node00411,variable,[],[name=var26],[]).
node(node00415,variable,[],[name=var29],[]).
node(node00428,variable,[],[name=var14],[]).
node(node00429,variable,[],[name=var15],[]).
node(node00430,compartment,[],[complete=true,name='forest area\nin surplus'],[bounding_box=[ 344.98826, 166.15349, 384.98826, 196.15349],caption_offset=[ 3.5585422, 1.5035656]]).
node(node00442,function,[],[comment='Forest areas in former surplus from agriculture (square meters)',complete=true,name=fn3,spec='0',units=1,value=0],[]).
node(node00462,cloud,[],[complete=true,name=cd1],[bounding_box=[ 136.30447, 169.28387, 161.30447, 194.28387]]).
node(node00463,function,[],[comment='Forest areas growth rate in surplus from agriculture (square meters/year)',complete=true,name=fn5,spec='if remaining_surplus_4>0 then forest_change_rate_in_surplus*remaining_surplus_4\nelse 0',units=1,value=(if remaining_surplus_4>0 then forest_change_rate_in_surplus*remaining_surplus_4 else 0)],[]).
node(node00470,variable,[],[name=var19],[]).
node(node00480,variable,[],[complete=true,name='space\nremaining'],[bounding_box=[ 131.52888, 574.01369, 146.52888, 589.01369],caption_offset=[ 1.4142129, 1.4142135]]).
node(node00490,function,[],[comment='Surface available for further forest development (square meters)',complete=true,name=fn10,spec='if Altitude_mask==1 then 0\nelseif surface-(FC_surface_rel+GFC_surface_rel+PC_surface_rel+Urb_dens+pro_land+liquid_rel+non_woody_rel+woody_rel+sea_dens+inland_waters+Forest_rel)*surface<0 then 0 else surface-(FC_surface_rel+GFC_surface_rel+PC_surface_rel+Urb_dens+pro_land+liquid_rel+non_woody_rel+woody_rel+sea_dens+inland_waters+Forest_rel)*surface',units=1,value=(if 'Altitude_mask'==1 then 0 elseif surface-('FC_surface_rel'+'GFC_surface_rel'+'PC_surface_rel'+'Urb_dens'+pro_land+liquid_rel+non_woody_rel+woody_rel+sea_dens+inland_waters+'Forest_rel')*surface<0 then 0 else surface-('FC_surface_rel'+'GFC_surface_rel'+'PC_surface_rel'+'Urb_dens'+pro_land+liquid_rel+non_woody_rel+woody_rel+sea_dens+inland_waters+'Forest_rel')*surface)],[]).
node(node00495,variable,[],[complete=true,name='forest max\nto remove'],[bounding_box=[ 484.12685, 42.265607, 499.12685, 57.265607],caption_offset=[ 18.612368, 0.0]]).
node(node00499,variable,[],[name=var79],[]).
node(node00556,variable,[],[name=var27],[bounding_box=[ 466.11366, 505.4192, 481.11366, 520.4192],caption_offset=[0,0]]).
node(node00557,function,[],[name=fn13],[]).
node(node00558,variable,[],[name=var28],[]).
node(node00620,variable,[],[complete=true,name='remaining\nsurplus_4'],[bounding_box=[ 194.38744, 80.690219, 209.38744, 95.690219],caption_offset=[ 45.859885, -26.802679]]).
node(node00621,function,[],[comment='Remaining surplus from agriculture at the time of simulation after that biofuels have been allocated (square meters)',complete=true,name=fn24,spec='if Altitude_mask==1 then 0\nelse remaining_surplus_3-(woody_growth*dt())+(Woody_decline*dt())',units=1,value=(if 'Altitude_mask'==1 then 0 else remaining_surplus_3-woody_growth*dt('')+'Woody_decline'*dt(''))],[]).
node(node00625,variable,[],[name=var31],[]).
node(node00629,compartment,[],[complete=true,name='forest area\noutside surplus'],[bounding_box=[ 345.39366, 363.74962, 385.39366, 393.74962],caption_offset=[ -18.400026, -0.13607427]]).
node(node00630,function,[],[comment='Forest areas outside former surplus from agriculture (square meters)',complete=true,name=fn11,spec=forest_ini_abs,units=1,value=forest_ini_abs],[]).
node(node00635,variable,[],[name=var62],[]).
node(node00640,variable,[],[name=var66],[]).
node(node00644,variable,[],[complete=true,name='tot forest\nabs'],[bounding_box=[ 357.86038, 273.43193, 372.86038, 288.43193],caption_offset=[ 41.853057, -22.661101]]).
node(node00645,function,[],[comment='Total forest area (square meters)',complete=true,name=fn14,spec='forest_area_in_surplus+forest_area_outside_surplus',units=1,value=forest_area_in_surplus+forest_area_outside_surplus],[]).
node(node00648,variable,[],[name=var72],[]).
node(node00652,variable,[],[complete=true,name='forest\nini abs'],[bounding_box=[ 466.78688, 304.19744, 481.78688, 319.19744],caption_offset=[ 33.132623, -19.327363]]).
node(node00653,function,[],[comment='Surface of forests in 2005 (square meters)',complete=true,name=fn16,spec='forest_ini_rel*surface',units=1,value=forest_ini_rel*surface],[]).
node(node00655,variable,[],[name=var80],[]).
node(node00668,variable,[],[complete=true,name='forest change rate\nin surplus'],[bounding_box=[ 42.256248, 221.84571, 57.256248, 236.84571],caption_offset=[0,0]]).
node(node00669,function,[],[comment='Increase/decrease of forest density in the surplus from agriculture at the current timestep (no dimention)',complete=true,name=fn20,spec='element([forest_change_rate_in_surplus],countryID)',units=1,value=element([forest_change_rate_in_surplus],countryID)],[]).
node(node00672,variable,[],[name=var94],[]).
node(node00678,variable,[],[name=var99],[]).
node(node00683,variable,[],[name=var103],[]).
node(node00688,variable,[],[name=var107],[]).
node(node00693,variable,[],[complete=true,name='forest change rate\noutside surplus'],[bounding_box=[ -157.60318, 470.4975, -142.60318, 485.4975],caption_offset=[ -25.455842, 0.0]]).
node(node00694,function,[],[comment='Increase/decrease of forest density outside the surplus from agriculture at the current timestep (no dimention)',complete=true,name=fn25,spec='element([forest_change_rate_outside_surplus],countryID)',units=1,value=element([forest_change_rate_outside_surplus],countryID)],[]).
node(node00698,variable,[],[name=var116],[]).
node(node00700,cloud,[],[complete=true,name=cd2],[bounding_box=[ 139.09832, 371.83729, 164.09832, 396.83729]]).
node(node00701,function,[],[comment='Forest areas growth rate outside surplus from agriculture (square meters/year)',complete=true,name=fn26,spec='space_remaining*forest_change_rate_outside_surplus',units=1,value=space_remaining*forest_change_rate_outside_surplus],[]).
node(node00710,variable,[],[name=var6],[]).
node(node00836,function,[],[comment='Landuse in excess in the surplus \'from agriculture\' (square meters)',complete=true,name=fn1,spec='if remaining_surplus>=0 then 0 else abs(remaining_surplus)',units=1,value=(if remaining_surplus>=0 then 0 else abs(remaining_surplus))],[]).
node(node00872,variable,[],[comment='0 = forest landuse is possible\n1 = not suitable for forest landuse',complete=true,name='Altitude\nmask',param_type=file,units=1],[bounding_box=[ 69.379745, 385.99686, 84.379745, 400.99686],caption_offset=[ -35.355333, -25.45584]]).
node(node00881,variable,[],[name=var1],[]).
node(node01197,variable,[],[name=var7],[]).
node(node01206,variable,[],[name=var45],[]).
node(node01207,cloud,[],[complete=true,name=cd3],[bounding_box=[ 492.8864, 170.27908, 517.8864, 195.27908]]).
node(node01208,function,[],[comment='Decline rate of forest areas inside "surplus from agriculture" due area congestion (square meters/year)',complete=true,name=fn2,spec='forest_to_remove/dt()',units=1,value=forest_to_remove/dt('')],[]).
node(node01209,variable,[],[complete=true,name='forest\nto remove'],[bounding_box=[ 400.37124, 80.882301, 415.37124, 95.882301],caption_offset=[ 6.810469, -51.078518]]).
node(node01210,function,[],[comment='Area of forest that will be removed in the next timestep due to the congestion in the \'surplus from agriculture\' (square meters)',complete=true,name=fn4,spec='if forest_max_to_remove>forest_area_in_surplus then forest_area_in_surplus else forest_max_to_remove',units=1,value=(if forest_max_to_remove>forest_area_in_surplus then forest_area_in_surplus else forest_max_to_remove)],[]).
node(node01238,variable,[],[name=var108],[]).
node(node01245,variable,[],[name=var16],[]).
node(node01260,variable,[],[complete=true,name='Max\nto remove'],[bounding_box=[ 510.61432, 466.60702, 525.61432, 481.60702],caption_offset=[ 1.4317206, -48.6785]]).
node(node01535,submodel,[node00258,node00259,node01536,node01537,node01538],[complete=true,enum_types=[],fill_colour='#ff0000',image_posn=none,multiplication_spec=[count=[]],name='RESULT',separate=0],[bounding_box=[ -106.96798, 349.65624, -29.18625, 430.2664],caption_offset=[ 4.24264, 0.0],hide_contents=0,internal_extent=[0,0, 77.781733, 80.610159]]).
links(node01535,[arc00293-arc01711,arc00294-arc01710,arc01709-arc01783,arc01709-arc01784]).
references(node01535,[obsolete,obsolete,ancestor(2),ancestor(3),ancestor(4),ancestor(5)]).
node(node00258,variable,[],[complete=true,name='Forest\nrel'],[bounding_box=[ 33.146757, 18.799508, 48.146757, 33.799508],caption_offset=[0,0]]).
node(node00259,function,[],[comment='Total forest area (part of the cell)',complete=true,max_val=1,min_val=0,name=fn12,spec='tot_forest_abs/surface',units=1,value=tot_forest_abs/surface],[]).
node(node01536,variable,[],[],[]).
node(node01537,variable,[],[],[]).
node(node01538,variable,[],[],[]).
node(node01550,function,[],[comment='Landuse in excess and that should be removed (square meters)',complete=true,name=fn6,spec='if inland_waters+sea_dens+Urb_dens+FC_surface_rel+GFC_surface_rel+PC_surface_rel+pro_land+liquid_rel+non_woody_rel+woody_rel+Forest_rel <=1 then 0\nelse abs(surface-(inland_waters+sea_dens+Urb_dens+FC_surface_rel+GFC_surface_rel+PC_surface_rel+pro_land+liquid_rel+non_woody_rel+woody_rel+Forest_rel)*surface)',units=1,value=(if inland_waters+sea_dens+'Urb_dens'+'FC_surface_rel'+'GFC_surface_rel'+'PC_surface_rel'+pro_land+liquid_rel+non_woody_rel+woody_rel+'Forest_rel'<=1 then 0 else abs(surface-(inland_waters+sea_dens+'Urb_dens'+'FC_surface_rel'+'GFC_surface_rel'+'PC_surface_rel'+pro_land+liquid_rel+non_woody_rel+woody_rel+'Forest_rel')*surface))],[]).
node(node01584,cloud,[],[complete=true,name=cd4],[bounding_box=[ 497.12903, 371.09736, 522.1290299999999, 396.09736]]).
node(node01585,function,[],[comment='Decline rate of forest areas outside "surplus from agriculture" due area congestion (square meters/year)',complete=true,name=fn7,spec='(min(Max_to_remove,forest_area_outside_surplus))/dt()',units=1,value=min('Max_to_remove',forest_area_outside_surplus)/dt('')],[]).
node(node00095,variable,[],[name=var2],[]).
node(node00107,variable,[],[name=var25],[]).
node(node00108,variable,[],[name=var5],[]).
node(node00114,variable,[],[name=var30],[]).
node(node00118,variable,[],[name=var22],[]).
node(node00126,submodel,[],[name=submodel1],[]).
node(node00138,variable,[],[name=var35],[]).
node(node00170,variable,[],[name=var41],[]).
node(node00182,variable,[],[name=var6],[]).
node(node00188,variable,[],[name=var34],[]).
node(node00198,variable,[],[name=var24],[]).
node(node00210,variable,[],[name=var12],[]).
node(node00214,variable,[],[name=var38],[]).
node(node00218,variable,[],[name=var42],[]).
node(node00225,variable,[],[name=var45],[]).
node(node00236,variable,[],[name=var46],[]).
node(node00244,variable,[],[name=var51],[]).
node(node00246,variable,[],[name=var54],[]).
node(node00250,variable,[],[name=var58],[]).
node(node00256,variable,[],[name=var65],[]).
node(node00260,variable,[],[name=var71],[]).
node(node00301,variable,[],[name=var52],[]).
node(node00314,variable,[],[name=var27],[]).
node(node00319,variable,[],[name=var28],[]).
node(node00322,variable,[],[name=var77],[]).
node(node00324,variable,[],[name=var79],[]).
node(node00328,variable,[],[name=var83],[]).
node(node00335,variable,[],[name=var89],[]).
node(node00337,variable,[],[name=var13],[]).
node(node00373,variable,[],[name=var11],[]).
node(node00453,variable,[],[name=var44],[]).
node(node00457,variable,[],[name=var53],[]).
node(node00460,variable,[],[name=var40],[]).
node(node00473,variable,[],[name=var48],[]).
node(node00500,variable,[],[name=var80],[]).
node(node00518,variable,[],[name=var57],[]).
node(node00522,variable,[],[name=var61],[]).
node(node00526,variable,[],[name=var64],[]).
node(node00530,variable,[],[name=var67],[]).
node(node00534,variable,[],[name=var70],[]).
node(node00538,variable,[],[name=var73],[]).
node(node00626,variable,[],[name=var56],[]).
node(node00649,variable,[],[name=var75],[]).
node(node00656,variable,[],[name=var82],[]).
node(node00673,variable,[],[name=var95],[]).
node(node00699,variable,[],[name=var117],[]).
node(node00737,variable,[],[name=var43],[]).
node(node00750,variable,[],[name=var18],[]).
node(node00826,variable,[],[name=var17],[]).
node(node00839,variable,[],[name=var16],[]).
node(node00842,variable,[],[name=var68],[]).
node(node00843,variable,[],[name=var69],[]).
node(node00854,submodel,[node00116,node00267,node00400,node00418,node00423,node00432,node00436,node00444,node00445,node00454,node00455,node00456,node00466,node00515,node00516,node00517,node00519,node00520,node00521,node00523,node00524,node00525,node00527,node00528,node00529,node00531,node00532,node00533,node00535,node00536,node00537,node00633,node00638,node00723,node00736,node00738,node00739,node00740,node00741,node00742,node00743,node00744,node00745,node00746,node00747,node00748,node00751,node00752,node00755,node00758,node00759,node00760,node00761,node00762,node00835,node00934,node00963,node00964,node01029,node01033,node01055,node01059,node01126,node01127,node01128,node01129,node01133,node01182,node01322,node01566,node01567,node01569],[complete=true,enum_types=[],fill_colour='#c0c0c0',image_posn=none,multiplication_spec=[count=[]],name='Urban',separate=0],[bounding_box=[ 237.19995, -35.914449, 1250.3605, 660.51825],caption_offset=[ 74.615112, 1.3900852],hide_contents=0,internal_extent=[ -2.0, -17.375892, 1013.1823, 680.44652]]).
links(node00854,[arc00311-arc00314,arc00311-arc00336,arc00317-arc00319,arc00321-arc00323,arc00325-arc00328,arc00330-arc00332,arc00473-arc00466,arc00476-arc00467,arc00481-arc00480,arc00511-arc00052,arc00511-arc00514,arc00568-arc00567,arc00572-arc00571,arc00576-arc00575,arc00580-arc00579,arc00584-arc00583,arc00588-arc00587,arc00611-arc00485,arc00611-arc00486,arc00611-arc00487,arc00611-arc00622,arc00611-arc00625,arc00715-arc00245,arc00715-arc00718,arc00720-arc00255,arc00720-arc00723,arc00772-arc01084,arc00773-arc00799,arc01027-arc01080,arc01078-arc01034,arc01121-arc01118,arc01124-arc01125,arc01296-arc01300,arc01484-arc01485,arc01484-arc01685,arc01764-arc01763]).
references(node00854,[obsolete,obsolete,local(arc01087),ancestor(2),ancestor(3),ancestor(4)]).
node(node00116,variable,[],[name=var9],[]).
node(node00267,variable,[],[name=var3],[]).
node(node00400,variable,[],[name=var1],[bounding_box=[ 822.75719, 62.909365, 842.25719, 82.40936499999999],caption_offset=[0,0]]).
node(node00418,variable,[],[name=var19],[]).
node(node00423,variable,[],[name=var22],[]).
node(node00432,variable,[],[name=var25],[]).
node(node00436,variable,[],[name=var28],[]).
node(node00444,function,[],[name=fn6],[]).
node(node00445,variable,[],[name=var2],[]).
node(node00454,variable,[],[name=var45],[bounding_box=[ 823.99349, 139.85443, 843.49349, 159.35444],caption_offset=[0,0]]).
node(node00455,function,[],[name=fn7],[]).
node(node00456,variable,[],[name=var46],[]).
node(node00466,variable,[],[name=var17],[]).
node(node00515,variable,[],[name=var54],[bounding_box=[ 830.16907, 203.21207, 849.66907, 222.71207],caption_offset=[ 1.3900852, 0.0]]).
node(node00516,function,[],[name=fn8],[]).
node(node00517,variable,[],[name=var55],[]).
node(node00519,variable,[],[name=var58],[bounding_box=[ 828.16364, 278.92666, 847.66364, 298.42666],caption_offset=[0,0]]).
node(node00520,function,[],[name=fn10],[]).
node(node00521,variable,[],[name=var59],[]).
node(node00523,variable,[],[name=var62],[bounding_box=[ 922.30952, 54.968763, 941.80952, 74.468763],caption_offset=[0,0]]).
node(node00524,function,[],[name=fn11],[]).
node(node00525,variable,[],[name=var63],[]).
node(node00527,variable,[],[name=var65],[bounding_box=[ 925.91086, 131.88487, 945.41086, 151.38487],caption_offset=[0,0]]).
node(node00528,function,[],[name=fn12],[]).
node(node00529,variable,[],[name=var66],[]).
node(node00531,variable,[],[name=var68],[bounding_box=[ 928.12213, 209.10861, 947.62213, 228.60861],caption_offset=[0,0]]).
node(node00532,function,[],[name=fn13],[]).
node(node00533,variable,[],[name=var69],[]).
node(node00535,variable,[],[name=var71],[bounding_box=[ 927.85505, 276.76135, 947.35505, 296.26135],caption_offset=[0,0]]).
node(node00536,function,[],[name=fn14],[]).
node(node00537,variable,[],[name=var72],[]).
node(node00633,variable,[],[name=var60],[]).
node(node00638,variable,[],[name=var64],[]).
node(node00723,submodel,[node00753,node00754,node01010,node01015,node01017],[complete=true,enum_types=[],fill_colour='#ff0000',image_posn=none,multiplication_spec=[count=[]],name='RESULT',separate=0],[bounding_box=[ 370.93861, 515.6023300000001, 447.45852, 606.2926],caption_offset=[ 12.753318, -1.4170354],hide_contents=0,internal_extent=[ 11.177065, 7.0430806, 87.69697499999999, 97.733344]]).
links(node00723,[arc00763-arc00511,arc00763-arc00792,arc00794-arc01109,arc00795-arc01113]).
references(node00723,[obsolete,obsolete,ancestor(2),ancestor(3),ancestor(4),ancestor(5)]).
node(node00753,variable,[],[complete=true,name='Urb_dens'],[bounding_box=[ 45.373483, 49.685452, 60.373483, 64.685452],caption_offset=[ 1.873536, -34.182413]]).
node(node00754,function,[],[comment='Urban landuse at the time of simulation (part of the ALARM cell)',complete=true,max_val=1,min_val=0,name=fn2,spec='urb_surface/surface',units=1,value=urb_surface/surface],[]).
node(node01010,variable,[],[],[]).
node(node01015,variable,[],[],[]).
node(node01017,variable,[],[],[]).
node(node00736,submodel,[node00195,node00539,node00540,node00541,node00542,node00543,node00544,node00545,node00546,node00722,node00724,node00725,node00726,node00728,node00729,node00730,node00731,node00732,node00733,node00734,node00735,node00756,node00827,node00828,node01026,node01031,node01060,node01130],[complete=true,enum_types=[],fill_colour='#a6a6a6',image_posn=none,multiplication_spec=[count=[]],name='Potential for change',separate=0],[bounding_box=[ 425.36607, 52.823237, 765.93694, 307.20883],caption_offset=[ 0.0, 0.0],hide_contents=0,internal_extent=[ 0.0, -1.3900852, 340.57087, 252.9955]]).
links(node00736,[arc00591-arc00590,arc00593-arc00592,arc00595-arc00594,arc00597-arc00596,arc00599-arc00598,arc00601-arc00600,arc00603-arc00602,arc00605-arc00604,arc00764-arc00773,arc00800-arc00237,arc00802-arc00801,arc00802-arc01123,arc00906-arc00902,arc00921-arc00912,arc01118-arc01117,arc01137-arc01138,arc01294-arc01293]).
references(node00736,[obsolete,obsolete,ancestor(2),ancestor(3),ancestor(4),ancestor(5)]).
node(node00195,variable,[],[name=var1],[]).
node(node00539,variable,[],[name=var74],[]).
node(node00540,variable,[],[name=var75],[]).
node(node00541,variable,[],[name=var76],[]).
node(node00542,variable,[],[name=var77],[]).
node(node00543,variable,[],[name=var79],[]).
node(node00544,variable,[],[name=var80],[]).
node(node00545,variable,[],[name=var81],[]).
node(node00546,variable,[],[name=var83],[]).
node(node00722,variable,[],[comment='1 : the cell is in a rural area\n0 : the cell is not in a rural area',complete=true,max_val=1,min_val=0,name=rural,param_type=file,units=int],[bounding_box=[ 284.64963, 112.32337, 304.14963, 131.82337],caption_offset=[0,0]]).
node(node00724,variable,[],[name=var3],[]).
node(node00725,variable,[],[complete=true,name='Suitability\nindex'],[bounding_box=[ 159.69555, 119.38308, 224.69555, 184.38308],caption_offset=[ 41.784108, -2.5520044]]).
node(node00726,function,[],[comment='Suitability of the cell for urban landuse (on a 0 -> 1 scale)\n1 = maximum suitability\n0 = no suitability',complete=true,name=fn1,spec='if (IDNUTS==999) or (IDNUTS==998) then 0 elseif espace>=1 then 0\nelseif random>=1 then 0\nelseif Dist_to_roads>dist_to_roads_threshold then 0\nelseif Dist_to_large_cities<dist_to_large_threshold then pds_large*surface*flood_coefficient\nelseif Dist_to_medium_cities<dist_to_med_threshold then pds_med*surface*flood_coefficient\nelseif Dist_to_small_cities<dist_to_sm_threshold then pds_small*surface*flood_coefficient\nelseif rural==1 then pds_rural*surface*flood_coefficient\nelse 0',units=1,value=(if 'IDNUTS'==999 or 'IDNUTS'==998 then 0 elseif espace>=1 then 0 elseif random>=1 then 0 elseif 'Dist_to_roads'>dist_to_roads_threshold then 0 elseif 'Dist_to_large_cities'<dist_to_large_threshold then pds_large*surface*flood_coefficient elseif 'Dist_to_medium_cities'<dist_to_med_threshold then pds_med*surface*flood_coefficient elseif 'Dist_to_small_cities'<dist_to_sm_threshold then pds_small*surface*flood_coefficient elseif rural==1 then pds_rural*surface*flood_coefficient else 0)],[]).
node(node00728,variable,[],[comment='Distance to the closest "small city" (meters)',complete=true,name='Dist to\nsmall cities',param_type=file,units=1],[bounding_box=[ 84.13338899999999, 40.921926, 149.13339, 105.92192],caption_offset=[ -4.8031424, -64.879518]]).
node(node00729,variable,[],[comment='Distance to the closest "medium city" (meters)',complete=true,name='Dist to\nmedium cities',param_type=file,units=1],[bounding_box=[ 168.8119, 40.921926, 233.8119, 105.92192],caption_offset=[ 2.5853002, -65.026132]]).
node(node00730,variable,[],[comment='Distance to the closest "large city" (meters)',complete=true,name='Dist to\nlarge cities',param_type=file,units=1],[bounding_box=[ 260.60974, 45.335308, 325.60974, 110.33531],caption_offset=[ 0.34148429, -67.707944]]).
node(node00731,variable,[],[comment='Distance to the closest "major road" (meters)',complete=true,name='Dist to\nroads',param_type=file,units=1],[bounding_box=[ 15.181972, 43.921095, 80.181972, 108.92109],caption_offset=[ -6.3880977, -63.465304]]).
node(node00732,variable,[],[complete=true,name=suittot],[bounding_box=[ 24.281832, 170.51201, 89.28183199999999, 235.51201],caption_offset=[0,0]]).
node(node00733,function,[],[comment='Number of cells of the nuts that are suitable for urban landuse and selected to undergo a growth of their urban landuse',complete=true,name=fn7,spec='if\t(IDNUTS==999)  or  (IDNUTS==998)\tthen\t0\nelse\t\t\t\telement([suittot],IDNUTS)',units=1,value=(if 'IDNUTS'==999 or 'IDNUTS'==998 then 0 else element([suittot],'IDNUTS'))],[]).
node(node00734,variable,[],[complete=true,name=suitrel],[bounding_box=[ 78.326536, 168.9753, 143.32654, 233.9753],caption_offset=[ -4.6014449, -29.191789]]).
node(node00735,function,[],[comment='relative suitability of the cell :\n1/Number of cells of the same nuts that are suitable for urban landuse and selected to undergo a growth of their urban landuse',complete=true,max_val=1,min_val=0,name=fn8,spec='if suittot==0 then 0 else Suitability_index/suittot',units=1,value=(if suittot==0 then 0 else 'Suitability_index'/suittot)],[]).
node(node00756,variable,[],[name=var45],[]).
node(node00827,variable,[],[name=var55],[]).
node(node00828,variable,[],[name=var56],[]).
node(node01026,variable,[],[name=var78],[]).
node(node01031,variable,[],[name=var82],[]).
node(node01060,variable,[],[name=var87],[]).
node(node01130,variable,[],[name=var11],[]).
node(node00738,variable,[],[comment='Part of the ALARM cell covered by an inland water',complete=true,name='inland\nwaters',param_type=file,units=1],[bounding_box=[ 622.34932, 390.04646, 641.84932, 409.54646],caption_offset=[ 36.84292, -26.923672]]).
node(node00739,variable,[],[comment='Protected areas of landuses other than croplands, grasslands, permanent crops and forests (part of the ALARM cell)',complete=true,max_val=1,min_val=0,name=pro_land,param_type=file,units=1],[bounding_box=[ 586.49433, 619.27525, 605.99433, 638.77525],caption_offset=[ 39.67699, -15.587389]]).
node(node00740,variable,[],[comment='Protected areas of forest (part of the ALARM cell)',complete=true,name=pro_forest,param_type=file,units=1],[bounding_box=[ 665.68549, 471.72718, 685.18549, 491.22718],caption_offset=[ 53.847344, -17.004424]]).
node(node00741,variable,[],[comment='Protected areas of croplands (part of the ALARM cell)',complete=true,name=pro_crop,param_type=file,units=1],[bounding_box=[ 669.2813, 561.97761, 688.7813, 581.47761],caption_offset=[ 43.928096, -14.170354]]).
node(node00742,variable,[],[comment='Protected areas of grasslands (part of the ALARM cell)',complete=true,name=pro_grass,param_type=file,units=1],[bounding_box=[ 639.20266, 596.4532400000001, 658.70266, 615.9532400000001],caption_offset=[ 49.596238, -14.170354]]).
node(node00743,variable,[],[comment='Protected areas of permanent crops (part of the ALARM cell)',complete=true,name=pro_pcrop,param_type=file,units=1],[bounding_box=[ 678.58628, 520.0799500000001, 698.08628, 539.5799500000001],caption_offset=[ 46.762167, -17.004424]]).
node(node00744,variable,[],[comment='Part of urban landsuse in the ALARM cell in 2005 (baseline)',complete=true,name=urbbase,param_type=file,units=1],[bounding_box=[ 194.99734, 509.92566, 259.99735, 574.92566],caption_offset=[0,0]]).
node(node00745,variable,[],[complete=true,name=espace],[bounding_box=[ 509.81645, 542.55287, 529.31645, 562.05287],caption_offset=[ -29.995418, -25.890226]]).
node(node00746,function,[],[comment='Space where further development of urban landuse is impossible/disallowed (part of the ALARM cell)',complete=true,name=fn5,units=1,value='Urb_dens'+inland_waters_0+sea_dens+pro_forest+pro_land+max(pro_pcrop+pro_crop+pro_grass,'Agro_threshold')],[]).
node(node00747,compartment,[],[complete=true,name=urb_surface],[bounding_box=[ 196.68816, 329.39756, 339.35483, 436.39756],caption_offset=[ -1.2434711, -44.764962]]).
node(node00748,function,[],[comment='Area of urban landuse at the time of simulation (square meters)',complete=true,name=fn3,spec='urbbase*surface',units=1,value=urbbase*surface],[]).
node(node00751,variable,[],[comment='Part of the Alarm cell covered by the sea',complete=true,name=sea_dens,param_type=file,units=1],[bounding_box=[ 620.00212, 413.72572, 685.00212, 478.72572],caption_offset=[ 45.345132, -15.587389]]).
node(node00752,variable,[],[comment='Surface of the ALARM cell (square meters)',complete=true,name=surface,param_type=file,units=1],[bounding_box=[ 276.97261, 553.38775, 341.97261, 618.38775],caption_offset=[ -1.907626, 2.2039168]]).
node(node00755,variable,[],[name=var6],[]).
node(node00758,variable,[],[comment='membership NUTS of the ALARM cell',complete=true,name='IDNUTS',param_type=file,units=1],[bounding_box=[ 110.61917, 127.38277, 175.61917, 192.38277],caption_offset=[ -4.163059, -48.446276]]).
node(node00759,variable,[],[complete=true,name=urbdiff],[bounding_box=[ 109.9078, 193.33079, 174.90778, 258.33079],caption_offset=[0,0]]).
node(node00760,function,[],[comment='Quantity of urban landuse that will be added (distributed in the cells of the nuts) during the timestep',complete=true,name=fn9,spec='if IDNUTS==999 then 0 else element([diff_pond],IDNUTS)',units=1,value=(if 'IDNUTS'==999 then 0 else element([diff_pond],'IDNUTS'))],[]).
node(node00761,variable,[],[complete=true,name=random],[bounding_box=[ 130.78906, 63.395323, 150.28906, 82.895323],caption_offset=[ 39.791077, -18.652067]]).
node(node00762,function,[],[comment='A random number. If it is picked between 0 and 1, the cell, if it is suitable, will have an increase of urban land use',complete=true,name=fn1,spec='rand_const(0,(1/rand_par))',units=1,value=rand_const(0,1/rand_par)],[]).
node(node00835,variable,[],[comment='1 = area with high risk of flooding\n0 = area without high risk of flooding',complete=true,name='High risks\nfloodable\nareas',param_type=file,units=1],[bounding_box=[ 928.83574, 376.31805, 943.83574, 391.31805],caption_offset=[ 2.8340707, 4.2511061]]).
node(node00934,variable,[],[],[]).
node(node00963,variable,[],[],[]).
node(node00964,variable,[],[],[]).
node(node01029,variable,[],[name=var79],[]).
node(node01033,variable,[],[name=var83],[]).
node(node01055,cloud,[],[complete=true,name=cd1],[bounding_box=[ 504.61169, 366.99325, 529.61169, 391.99325]]).
node(node01059,function,[],[comment='Growth rate of urban landuse at the timestep of simulation (square meters/year)',complete=true,name=fn4,spec='if urbdiff<0 then 0\nelseif espace>=1 then 0 \nelseif surface-(espace*surface) <suitrel*urbdiff then (surface-(espace*surface))\nelse (suitrel*urbdiff)',units=1,value=(if urbdiff<0 then 0 elseif espace>=1 then 0 elseif surface-espace*surface<suitrel*urbdiff then surface-espace*surface else suitrel*urbdiff)],[]).
node(node01126,variable,[],[name=var4],[bounding_box=[ 835.42449, 436.561, 850.42449, 451.561],caption_offset=[0,0]]).
node(node01127,function,[],[name=fn15],[]).
node(node01128,variable,[],[complete=true,name='flood\ncoefficient'],[bounding_box=[ 781.46405, 347.97734, 796.46405, 362.97734],caption_offset=[ -34.008849, -9.9192476]]).
node(node01129,function,[],[comment='\'Suitability for urban landuse\' reduction factor due to flood risks\n0 = 0 % of the original sensibility is kept (100% reduction)\n1 = no influence of flood risks',complete=true,name=fn17,spec='if time()<10 then 1 elseif High_risks_floodable_areas==0 then 1 else flood_sensitivity',units=1,value=(if time('')<10 then 1 elseif 'High_risks_floodable_areas'==0 then 1 else flood_sensitivity)],[]).
node(node01133,variable,[],[name=var13],[]).
node(node01182,variable,[],[name=var5],[]).
node(node01322,variable,[],[name=var70],[]).
node(node01566,variable,[],[name=var107],[bounding_box=[ 537.73052, 621.46516, 552.73052, 636.46516],caption_offset=[0,0]]).
node(node01567,function,[],[name=fn59],[]).
node(node01569,variable,[],[name=var109],[]).
node(node00882,variable,[],[name=var3],[]).
node(node00955,variable,[],[name=var59],[]).
node(node00981,submodel,[],[name=submodel3],[]).
node(node01013,variable,[],[name=var9],[]).
node(node01014,submodel,[node00356,node00358,node01086,node01087],[complete=true,enum_types=[],fill_colour='#ffffb9',image_posn=none,multiplication_spec=[count=[]],name='Coordinates',separate=0],[bounding_box=[ 1290.2231, -21.854668, 1416.4093, 127.83166],caption_offset=[ 6.2226716, -1.5438955],hide_contents=0,internal_extent=[ 4.9999918, -2.7526159, 133.83954, 150.08122]]).
references(node01014,[obsolete,ancestor(1)]).
node(node00356,variable,[],[comment='Y coordinate of the cell on the 268*220 ALARM grid',complete=true,name='IDline',param_type=file,units=1],[bounding_box=[ 31.551765, 101.19188, 46.551765, 116.19188],caption_offset=[0,0]]).
node(node00358,variable,[],[comment='XNW coordinate of the cell on the 268*220 ALARM grid',complete=true,name='IDcol',param_type=file,units=1],[bounding_box=[ 86.421885, 99.747929, 101.42189, 114.74793],caption_offset=[0,0]]).
node(node01086,variable,[],[comment='Latitude of the center of the cell (decimal degrees)',complete=true,name='LAT',param_type=file,units=1],[bounding_box=[ 31.047063, 27.390231, 50.547063, 46.890231],caption_offset=[ -8.4334978e-07, 4.2167489e-07]]).
node(node01087,variable,[],[comment='Longitude of the center of the cell (decimal degrees)',complete=true,name='LONG',param_type=file,units=1],[bounding_box=[ 79.26177300000001, 28.626506, 98.76177300000001, 48.126506],caption_offset=[0,0]]).
node(node01018,variable,[],[name=var7],[]).
node(node01019,variable,[],[name=var14],[]).
node(node01027,variable,[],[name=var10],[]).
node(node01030,variable,[],[name=var81],[]).
node(node01032,variable,[],[name=var19],[]).
node(node01034,variable,[],[name=var29],[]).
node(node01035,variable,[],[name=var84],[]).
node(node01063,variable,[],[name=var49],[]).
node(node01066,variable,[],[name=var66],[]).
node(node01084,variable,[],[name=var50],[]).
node(node01089,variable,[],[name=var60],[]).
node(node01113,variable,[],[name=var72],[]).
node(node01174,variable,[],[name=var39],[]).
node(node01183,variable,[],[name=var8],[]).
node(node01186,variable,[],[name=var62],[]).
node(node01216,variable,[],[name=var55],[]).
node(node01253,variable,[],[name=var76],[]).
node(node01263,variable,[],[name=var85],[]).
node(node01272,variable,[],[name=var93],[]).
node(node01303,variable,[],[name=var63],[]).
node(node01323,variable,[],[name=var78],[]).
node(node01427,variable,[],[name=var47],[]).
node(node01470,variable,[],[name=var86],[]).
node(node01501,variable,[],[name=var87],[]).
node(node01609,variable,[],[name=var21],[]).
node(node01613,variable,[],[name=var32],[]).
node(node01621,variable,[],[name=var74],[]).
node(node01625,variable,[],[name=var88],[]).
node(node01633,variable,[],[name=var96],[]).
node(node01637,variable,[],[name=var100],[]).
node(node00957,variable,[],[comment='Annual increase of the technology factor for the foodcrops for the GRAS scenario before 2015',complete=true,max_val= 0.1,min_val=0,name='T GRAS <= 2015',spec='0.015',units=1,value= 0.015],[bounding_box=[ -344.08272, -400.65125, -329.08272, -385.65125],caption_offset=[0,0]]).
node(node00959,variable,[],[comment='Annual increase of the technology factor for the foodcrops for the GRAS scenario from 2015',complete=true,max_val= 0.1,min_val=0,name='T GRAS > 2015',spec='0.017',units=1,value= 0.017],[bounding_box=[ -187.10507, -404.89389, -172.10507, -389.89389],caption_offset=[0,0]]).
node(node01114,variable,[],[comment='1 = Food crops decline faster in less rentable areas of the cells with rentability <FC_rent_thr (decline =0 in cells with rentability > FC_rent_thr)\n0 = Food crops decline at the same rate in all cells with rentability < FC_rent_thr (decline =0 in cells with rentability > FC_rent_thr)\n\nOnly relevant in the GRAS scenario',complete=true,max_val=1,min_val=0,name=k_foodcrops,spec='0.614',units=1,value= 0.614],[bounding_box=[ 365.32215, -1035.9592, 380.32215, -1020.9592],caption_offset=[ 3.0048918, 4.5073378]]).
node(node01117,variable,[],[comment='1 = Grasslands decline faster in less rentable areas of the cells with rentability <GFC_rent_thr (decline =0 in cells with rentability > GFC_rent_thr)\n0 = Grasslands decline at the same rate in all cells with rentability < GFC_rent_thr (decline =0 in cells with rentability > GFC_rent_thr)\n\nOnly relevant in the GRAS scenario',complete=true,max_val=1,min_val=0,name=k_GFC,spec='2.5',units=1,value= 2.5],[bounding_box=[ 458.43059, -1035.9978, 473.43059, -1020.9978],caption_offset=[0,0]]).
node(node01118,variable,[],[comment='1 = Permanent crops decline faster in less rentable areas of the cells with rentability <PC_rent_thr (decline =0 in cells with rentability > PC_rent_thr)\n0 = Permanent crops at the same rate in all cells with rentability < PC_rent_thr (decline =0 in cells with rentability > PC_rent_thr)\n\nOnly relevant in the GRAS scenario',complete=true,max_val=1,min_val=0,name=k_PC,spec='0.756',units=1,value= 0.756],[bounding_box=[ 540.01864, -1026.3226, 555.01864, -1011.3226],caption_offset=[0,0]]).
node(node01124,variable,[],[comment='0 : No more urban developpement in areas that present a high flood risk\n1 : Flood risk does not influence localisation of new urban developpements',complete=true,max_val=1,min_val=0,name='flood\nsensitivity',units=1],[bounding_box=[ 1486.0138, -1037.742, 1501.0138, -1022.742],caption_offset=[0,0]]).
node(node01179,variable,[],[comment='Annual increase of the technology factor for the foodcrops for the BAMBU scenario before 2015',complete=true,max_val= 0.1,min_val=0,name='T BAMBU <= 2015',spec='0.015',units=1,value= 0.015],[bounding_box=[ -363.88171, -351.15379, -348.88171, -336.15379],caption_offset=[0,0]]).
node(node01199,variable,[],[complete=true,name='weight\nwheat'],[bounding_box=[ -496.81774, -318.62689, -481.81774, -303.62689],caption_offset=[0,0]]).
node(node01200,function,[],[comment='Proportion of the foodcrops (only including wheat, maize, sunflower and soya) that are constituted by wheat in the nuts (%)',complete=true,name=fn4,spec='73.54',units=1,value= 73.54000000000001],[]).
node(node01201,variable,[],[complete=true,name='weight\nmaize'],[bounding_box=[ -495.40353, -240.84517, -480.40353, -225.84517],caption_offset=[ 5.6568525, 1.4142131]]).
node(node01202,function,[],[comment='Proportion of the foodcrops (only including wheat, maize, sunflower and soya) that are constituted by maize in the nuts (%)',complete=true,name=fn5,spec='18.10',units=1,value= 18.1],[]).
node(node01203,variable,[],[complete=true,name='weight\nsunflower'],[bounding_box=[ -491.1609, -158.8208, -476.1609, -143.8208],caption_offset=[0,0]]).
node(node01204,function,[],[comment='Proportion of the foodcrops (only including wheat, maize, sunflower and soya) that are constituted by sunflowers in the nuts (%)',complete=true,name=fn6,spec='7.17',units=1,value= 7.17],[]).
node(node01220,variable,[],[complete=true,name='weight\nsoy'],[bounding_box=[ -491.16088, -92.35278700000001, -476.16088, -77.35278700000001],caption_offset=[0,0]]).
node(node01221,function,[],[comment='Proportion of the foodcrops (only including wheat, maize, sunflower and soya) that are constituted by soya in the nuts (%)',complete=true,name=fn9,spec='1.19',units=1,value= 1.19],[]).
node(node01235,variable,[],[comment='Annual increase of the technology factor for the foodcrops for the SEDG scenario before 2015',complete=true,max_val= 0.1,min_val=0,name='T SEDG <= 2015',spec='0.015',units=1,value= 0.015],[bounding_box=[ -348.32536, -304.48476, -333.32536, -289.48476],caption_offset=[0,0]]).
node(node01237,variable,[],[comment='Annual increase of the technology factor for the foodcrops for the SEDG scenario from 2015',complete=true,max_val= 0.1,min_val=0,name='T SEDG > 2015',spec='0.007',units=1,value= 0.007],[bounding_box=[ -168.7203, -298.8279, -153.7203, -283.8279],caption_offset=[0,0]]).
node(node01240,variable,[],[comment='Annual increase of the technology factor for the foodcrops for the BAMBU scenario from 2015',complete=true,max_val= 0.1,min_val=0,name='T BAMBU > 2015',spec='0.013',units=1,value= 0.013],[bounding_box=[ -153.16395, -351.15379, -138.16395, -336.15379],caption_offset=[0,0]]).
node(node01275,variable,[],[complete=true,name='T'],[bounding_box=[ -260.64415, -342.66851, -245.64415, -327.66851],caption_offset=[ 1.4142131, 9.899491899999999]]).
node(node01276,function,[],[comment='Gathering of all the technology parameters',complete=true,name=fn12,spec='[T_GRAS____2015,T_BAMBU____2015,T_SEDG____2015,T_GRAS___2015,T_BAMBU___2015,T_SEDG___2015]',units=array(1,6),value=['T_GRAS____2015','T_BAMBU____2015','T_SEDG____2015','T_GRAS___2015','T_BAMBU___2015','T_SEDG___2015']],[]).
node(node01345,variable,[],[comment='Annual increase of the management factor for the foodcrops for the GRAS scenario',complete=true,max_val= 0.1,min_val=0,name='M GRAS',spec='0.00',units=1,value= 0.0],[bounding_box=[ -17.399492, -387.92333, -2.3994919, -372.92333],caption_offset=[0,0]]).
node(node01347,variable,[],[comment='Annual increase of the management factor for the foodcrops for the BAMBU scenario',complete=true,max_val= 0.1,min_val=0,name='M BAMBU',spec='0.005',units=1,value= 0.005],[bounding_box=[ -14.571066, -325.69795, 0.42893438, -310.69795],caption_offset=[0,0]]).
node(node01359,variable,[],[comment='Annual increase of the management factor for the foodcrops for the SEDG scenario',complete=true,max_val= 0.1,min_val=0,name='M SEDG',spec='0.01',units=1,value= 0.01],[bounding_box=[ -14.571066, -262.05836, 0.42893438, -247.05836],caption_offset=[0,0]]).
node(node01361,variable,[],[complete=true,name='M'],[bounding_box=[ 68.867509, -322.86953, 83.867509, -307.86953],caption_offset=[ 2.8284262, 5.6568525]]).
node(node01362,function,[],[comment='Gathering of all the management parameters',complete=true,name=fn16,spec='[M_GRAS,M_BAMBU,M_SEDG]',units=array(1,3),value=['M_GRAS','M_BAMBU','M_SEDG']],[]).

arc(arc00141,node00082,node00128,influence,[complete=true,name=i4],[course=[[ 344.68476, 99.837476],[ 274.97277, 99.510586],[ 210.82233, 99.62350600000001]]]).
arc(arc00094,node00133,node00130,influence,[name=i2],[]).
arc(arc00099,node00134,node00133,influence,[complete=true,name=i3,role=[use(none,in_hierarchy,'CountryID',1)]],[course=[[ 207.4136, 58.30545],[ 24.84369, 57.35464],[ 5.7540443e-14, 58.62855]]]).
arc(arc00146,node00203,node00133,influence,[complete=true,name=i11,role=[use(0,in_base,countryID_link,1)]],[course=[[ 237.4136, 57.77558],[ 258.18467, 56.93368],[ 296.08811, 57.25012]]]).
arc(arc00420,node00420,node00401,influence,[name=i34],[]).
arc(arc00462,node00441,node00440,influence,[name=i1],[]).
arc(arc00542,node00498,node00497,influence,[name=i144],[]).
arc(arc00545,node00501,node00498,influence,[complete=true,name=i147,role=[use(0,in_base,space_remaining_link,1)]],[course=[[ 243.35705, 284.92943],[ 273.7523, 283.58359],[ 296.08811, 284.3249]]]).
arc(arc00539,node00627,node00441,influence,[complete=true,name=i159,role=[use(0,in_base,remaining_surplus_4_link,1)]],[course=[[ 51.14478, 126.30576],[ 161.65448, 125.17857],[ 296.08811, 126.21699]]]).
arc(arc00736,node00647,node00646,influence,[name=i188],[]).
arc(arc00739,node00650,node00647,influence,[complete=true,name=i191,role=[use(0,in_base,tot_forest_abs_link,1)]],[course=[[ 147.70909, 226.38322],[ 219.13916, 226.05113],[ 296.08811, 225.93499]]]).
arc(arc00748,node00657,node00420,influence,[complete=true,name=i200,role=[use(0,in_base,forest_ini_abs_link,1)]],[course=[[ 198.25569, 174.62389],[ 240.89721, 174.03261],[ 296.08811, 173.91505]]]).
arc(arc00753,node00401,node00660,influence,[complete=true,name=i205],[course=[[ 5.7540443e-14, 174.26196],[ 66.73675900000001, 173.30765],[ 183.25688, 174.55511]]]).
arc(arc00469,node00440,node00667,influence,[complete=true,name=i35],[course=[[ 44.54357, 335.01049],[ 44.50393, 208.84608],[ 43.73066, 134.15689]]]).
arc(arc01054,node00497,node00692,influence,[complete=true,name=i249],[course=[[ 234.5032, 335.0105],[ 233.82437, 301.07736],[ 235.2425, 292.55594]]]).
arc(arc00975,node01211,node00647,influence,[complete=true,name=i37,role=[use(none,in_hierarchy,removed_forest,1)]],[course=[[ 141.7995, 219.10028],[ 145.08997, 141.25402],[ 141.8451, 98.74570199999999]]]).
arc(arc00971,node00974,node01212,influence,[complete=true,name=i33,role=[use(0,in_base,forest_decline_outside_surplus_link,1)]],[course=[[ 148.77384, 91.34575100000001],[ 245.1469, 92.351855],[ 296.08811, 90.784385]]]).
arc(arc01375,node01212,node01211,influence,[name=i14],[]).
arc(arc01378,node01231,node01212,influence,[complete=true,name=i19,role=[use(0,in_base,forest_to_remove_link,1)]],[course=[[ 148.77409, 91.316247],[ 243.71169, 91.933848],[ 296.08811, 91.499923]]]).
arc(arc00976,node00646,node01587,influence,[complete=true,name=i38],[course=[[ -5.7540443e-14, 227.28196],[ 78.011072, 228.91503],[ 132.71901, 226.81278]]]).
arc(arc00143,node00184,node00128,relation,[complete=true,name=role2],[caption_offset=[ 168.02558, -29.114031],course=[[ 634.62265, 65.032392],[ 676.7128, 44.770353],[ 691.0571, 42.24528]]]).
arc(arc00147,node00222,node00128,influence,[complete=true,name=i12],[course=[[ 637.18616, 98.47573300000001],[ 673.84433, 99.751757],[ 699.12279, 98.343735]]]).
arc(arc00459,node00439,node00438,influence,[name=i49],[]).
arc(arc00460,node00082,node00439,influence,[complete=true,name=i50,role=[use(none,in_hierarchy,'CountryID',1)]],[course=[[ 203.23762, 206.62896],[ 202.73952, 162.5393],[ 203.25286, 107.1361]]]).
arc(arc00754,node00128,node00439,influence,[complete=true,name=i206,role=[use(none,in_hierarchy,{forest_ini_abs},list(1))]],[course=[[ 210.82232, 214.14634],[ 286.25265, 214.32939],[ 344.68476, 214.07014]]]).
arc(arc00468,node00447,node00446,influence,[name=i34],[]).
arc(arc00470,node00128,node00447,influence,[complete=true,name=i36,role=[use(none,in_hierarchy,{remaining_surplus__},list(1))]],[course=[[ 325.21492, 430.19589],[ 354.17315, 406.03056],[ 388.68874, 372.87143]]]).
arc(arc00758,node00449,node00447,influence,[complete=true,name=i210,role=[use(none,in_hierarchy,forest_change,1)]],[course=[[ 315.15112, 428.86008],[ 249.84713, 335.71243],[ 208.45773, 273.37577]]]).
arc(arc00471,node00450,node00449,influence,[name=i37],[]).
arc(arc00474,node00438,node00450,influence,[complete=true,name=i40,role=[use(none,in_hierarchy,usr(forest_expected_t_1),1)]],[course=[[ 204.52197, 259.63063],[ 204.83994, 248.42877],[ 203.96108, 221.60123]]]).
arc(arc01209,node00128,node00450,influence,[complete=true,name=i39,role=[use(none,in_hierarchy,{tot_forest},list(1))]],[course=[[ 211.80837, 267.01829],[ 278.40777, 266.04739],[ 344.68476, 266.44788]]]).
arc(arc00546,node00502,node00128,influence,[complete=true,name=i148],[course=[[ 637.18616, 322.79982],[ 673.35482, 321.97454],[ 699.12279, 324.12206]]]).
arc(arc00555,node00628,node00128,influence,[complete=true,name=i160],[course=[[ 637.18616, 166.60717],[ 671.1453299999999, 164.7959],[ 699.12279, 165.95744]]]).
arc(arc00740,node00651,node00128,influence,[complete=true,name=i192],[course=[[ 637.18616, 265.11723],[ 673.75747, 263.73854],[ 699.12279, 265.33265]]]).
arc(arc00749,node00658,node00128,influence,[complete=true,name=i201],[course=[[ 637.18616, 213.72744],[ 670.9116, 215.21207],[ 699.12279, 214.01265]]]).
arc(arc00755,node00662,node00661,influence,[name=i207],[]).
arc(arc00759,node00449,node00662,influence,[complete=true,name=i211,role=[use(none,in_hierarchy,forest_change,1)]],[course=[[ 204.18401, 600.39109],[ 203.6748, 437.53364],[ 204.28125, 274.62756]]]).
arc(arc00760,node00446,node00662,influence,[complete=true,name=i212,role=[use(none,in_hierarchy,forest_change_in_surplus,1)]],[course=[[ 208.62055, 601.8268399999999],[ 276.47835, 508.58043],[ 315.67376, 441.47736]]]).
arc(arc00756,node00664,node00663,influence,[name=i208],[]).
arc(arc00757,node00446,node00664,influence,[complete=true,name=i209,role=[use(none,in_hierarchy,forest_change_in_surplus,1)]],[course=[[ 453.52532, 527.05764],[ 377.61926, 479.30156],[ 325.42297, 439.54561]]]).
arc(arc00762,node00128,node00664,influence,[complete=true,name=i214,role=[use(none,in_hierarchy,{remaining_surplus__},list(1))]],[course=[[ 457.00283, 524.12265],[ 420.97938, 437.17195],[ 388.68874, 372.87143]]]).
arc(arc00761,node00666,node00665,influence,[name=i213],[]).
arc(arc01057,node00128,node00666,influence,[complete=true,name=i250,role=[use(none,in_hierarchy,{space_remaining},list(1))]],[course=[[ 575.8670100000001, 600.39114],[ 576.40887, 486.75614],[ 576.34727, 372.87143]]]).
arc(arc01058,node00661,node00666,influence,[complete=true,name=i251,role=[use(none,in_hierarchy,forest_change_outside_surplus,1)]],[course=[[ 568.3314800000001, 607.83242],[ 387.19093, 606.41633],[ 211.70722, 607.83061]]]).
arc(arc00787,node00663,node00670,influence,[complete=true,name=i216],[course=[[ 699.12279, 531.11369],[ 603.06215, 529.71478],[ 467.37312, 530.98153]]]).
arc(arc01140,node00665,node00697,influence,[complete=true,name=i257],[course=[[ 699.12275, 608.27769],[ 649.80304, 607.43252],[ 583.3311, 607.84456]]]).
arc(arc00972,node00975,node00128,influence,[complete=true,name=i35],[course=[[ 637.18616, 131.60379],[ 668.3934400000001, 150.05799],[ 699.12279, 165.82814]]]).
arc(arc01379,node01242,node00128,influence,[complete=true,name=i20],[course=[[ 637.18616, 132.31066],[ 676.53709, 133.85802],[ 699.12279, 132.72134]]]).
arc(arc00083,node00122,node00121,influence,[name=i22],[]).
arc(arc00204,node00176,node00175,influence,[name=i8],[]).
arc(arc00082,node00186,node00173,influence,[name=i1],[]).
arc(arc00844,node00816,node00817,influence,[complete=true,name=i28],[course=[[ -532.85203, -430.76142],[ -433.53597, -431.84486],[ -420.73083, -431.39619]]]).
arc(arc01407,node00367,node00817,influence,[complete=true,name=i68],[course=[[ -532.85203, -314.84161],[ 13.506851, -483.75482],[ 206.19161, -1022.1899]]]).
arc(arc00458,node00886,node00885,influence,[name=i2],[]).
arc(arc00926,node00888,node00514,influence,[name=i12],[]).
arc(arc00941,node00952,node00888,influence,[complete=true,name=i19,role=[use(none,in_hierarchy,weight_wheat,1)]],[course=[[ 265.30745, 298.93378],[ 305.10398, 228.21051],[ 346.48222, 160.03215]]]).
arc(arc00946,node00953,node00888,influence,[complete=true,name=i20,role=[use(none,in_hierarchy,weight_maize,1)]],[course=[[ 265.30954, 298.93496],[ 308.198, 222.77397],[ 346.48222, 160.47159]]]).
arc(arc00987,node00958,node00888,influence,[complete=true,name=i21,role=[use(none,in_hierarchy,weight_sunflower,1)]],[course=[[ 265.298, 298.92847],[ 304.94423, 228.23344],[ 346.48222, 160.0787]]]).
arc(arc00989,node00993,node00888,influence,[complete=true,name=i22,role=[use(none,in_hierarchy,weight_soy,1)]],[course=[[ 265.30464, 298.9322],[ 301.79364, 234.02163],[ 346.48222, 160.3427]]]).
arc(arc00397,node01078,node00951,influence,[name=i5],[]).
arc(arc00904,node00885,node01078,influence,[complete=true,name=i10,role=[use(none,in_hierarchy,usr('Scaling_factor'),1)]],[course=[[ 167.88096, 204.53396],[ 134.25928, 202.16592],[ 113.89139, 203.7585]]]).
arc(arc00895,node00951,node01195,influence,[complete=true,name=i8,role=[use(none,in_hierarchy,'Predicted_actual_yield',1)]],[course=[[ 244.23194, 205.23351],[ 202.64919, 205.54895],[ 182.86123, 205.19502]]]).
arc(arc01079,node01195,node01194,influence,[name=i11],[]).
arc(arc01245,node01222,node01195,influence,[complete=true,name=i30,role=[use(none,in_hierarchy,weight_wheat,1)]],[course=[[ 258.44609, 201.72268],[ 314.42324, 173.89977],[ 346.48222, 160.03215]]]).
arc(arc01361,node01225,node01195,influence,[complete=true,name=i34,role=[use(none,in_hierarchy,weight_maize,1)]],[course=[[ 259.21099, 204.52793],[ 304.02074, 180.01992],[ 346.48222, 160.47159]]]).
arc(arc01365,node01228,node01195,influence,[complete=true,name=i39,role=[use(none,in_hierarchy,weight_sunflower,1)]],[course=[[ 258.44685, 201.72422],[ 313.13419, 174.55804],[ 346.48222, 160.0787]]]).
arc(arc01388,node01232,node01195,influence,[complete=true,name=i44,role=[use(none,in_hierarchy,weight_soy,1)]],[course=[[ 259.22949, 205.14384],[ 294.6365, 183.52137],[ 346.48222, 160.3427]]]).
arc(arc00991,node00514,node01239,influence,[complete=true,name=i24],[course=[[ 346.48222, 197.24381],[ 300.47904, 254.42082],[ 266.17145, 299.50174]]]).
arc(arc01397,node01279,node01278,influence,[name=i59],[]).
arc(arc01398,node01280,node01278,influence,[complete=true,name=i60],[course=[[ 257.66486, 55.071688],[ 358.89098, 146.71681],[ 346.48222, 105.2697]]]).
arc(arc01403,node01284,node01283,influence,[name=i64],[]).
arc(arc01404,node01285,node01283,influence,[complete=true,name=i65],[course=[[ 228.52839, 91.45287],[ 351.55953, 132.58427],[ 346.48222, 75.79957]]]).
arc(arc01480,node01306,node01078,influence,[complete=true,name=i18,role=[use(none,in_hierarchy,usr('Potential_with_technology'),1)]],[course=[[ 175.27685, 197.56139],[ 174.76405, 129.9988],[ 175.30011, 65.482467]]]).
arc(arc01459,node01278,node01307,influence,[complete=true,name=i33,role=[use(none,in_hierarchy,['T'],array(1,6))]],[course=[[ 182.82063, 57.191998],[ 220.72285, 53.173556],[ 242.86052, 55.75018]]]).
arc(arc01460,node01283,node01307,influence,[complete=true,name=i35,role=[use(none,in_hierarchy,scenario,int)]],[course=[[ 181.68352, 62.019284],[ 191.94853, 68.57437299999999],[ 216.58034, 88.44241]]]).
arc(arc01473,node01307,node01306,influence,[name=i3],[]).
arc(arc01477,node01308,node01307,influence,[complete=true,name=i13,role=[use(none,in_hierarchy,'POT_LPJ',1)]],[course=[[ 167.86651, 57.735335],[ 133.76149, 56.609755],[ 84.574613, 56.574218]]]).
arc(arc00529,node00927,node01309,influence,[complete=true,name=i4,role=[use(none,in_hierarchy,'LPJ_data_wheat',1)]],[course=[[ 69.950874, 54.222809],[ 35.253081, 41.982607],[ 2.6379278, 28.426044]]]).
arc(arc01409,node01292,node01309,influence,[complete=true,name=i23,role=[use(none,in_hierarchy,'LPJ_data_maize_2000_2010',1)]],[course=[[ 70.082545, 53.855405],[ 45.927781, 43.522404],[ 3.5628207, 26.107948]]]).
arc(arc01411,node01293,node01309,influence,[complete=true,name=i25,role=[use(none,in_hierarchy,'LPJ_data_sunflower',1)]],[course=[[ 69.81775399999999, 54.67432],[ 49.593821, 48.749459],[ 4.3895123, 24.311481]]]).
arc(arc01454,node01294,node01309,influence,[complete=true,name=i27,role=[use(none,in_hierarchy,'LPJ_data_soya',1)]],[course=[[ 70.01781, 54.028531],[ 38.439263, 41.77156],[ 3.6118613, 25.995083]]]).
arc(arc01475,node01309,node01308,influence,[name=i9],[]).
arc(arc01499,node01333,node01078,influence,[complete=true,name=i28,role=[use(none,in_hierarchy,usr('Management_factor_plus'),1)]],[course=[[ 181.34513, 200.53793],[ 225.66948, 167.02835],[ 271.32647, 130.54683]]]).
arc(arc01235,node01334,node01333,influence,[name=i26],[]).
arc(arc01512,node01283,node01334,influence,[complete=true,name=i67,role=[use(none,in_hierarchy,scenario,int)]],[course=[[ 270.35099, 122.77702],[ 243.35022, 110.57765],[ 227.49591, 98.613122]]]).
arc(arc00939,node01353,node00888,influence,[complete=true,name=i14,role=[use(none,in_hierarchy,actual_yield_2000,1)]],[course=[[ 254.28324, 306.981],[ 180.59362, 305.68378],[ 110.73663, 306.76785]]]).
arc(arc01521,node01354,node01353,influence,[name=i217],[]).
arc(arc01522,node01355,node01354,influence,[complete=true,name=i218,role=[use(none,in_hierarchy,'Actual_yield_wheat_2000',1)]],[course=[[ 104.45554, 314.28467],[ 106.88839, 329.06626],[ 119.11183, 353.55329]]]).
arc(arc01523,node01356,node01354,influence,[complete=true,name=i219,role=[use(none,in_hierarchy,'Actual_yield_maize_2000',1)]],[course=[[ 102.96149, 314.37915],[ 102.62521, 323.5097],[ 117.37969, 353.55329]]]).
arc(arc01524,node01357,node01354,influence,[complete=true,name=i220,role=[use(none,in_hierarchy,'Actual_yield_sunflower_2000',1)]],[course=[[ 103.79608, 314.3634],[ 105.10472, 331.88645],[ 115.44874, 353.55329]]]).
arc(arc01525,node01358,node01354,influence,[complete=true,name=i221,role=[use(none,in_hierarchy,'Actual_yield_soya_2000',1)]],[course=[[ 103.91211, 314.35383],[ 105.24508, 329.11384],[ 116.3711, 353.55329]]]).
arc(arc01537,node01363,node01334,influence,[complete=true,name=i84,role=[use(none,in_hierarchy,['M'],array(1,3))]],[course=[[ 280.50403, 119.13908],[ 295.89219, 87.948033],[ 305.54085, 63.543352]]]).
arc(arc01531,node01364,node01363,influence,[name=i78],[]).
arc(arc01532,node01365,node01363,influence,[complete=true,name=i79],[course=[[ 313.56526, 51.229225],[ 374.20858, 145.744],[ 346.48222, 153.0897]]]).
arc(arc01580,node01194,node01412,influence,[complete=true,name=i47],[course=[[ 346.48222, 160.0787],[ 316.86996, 175.0898],[ 258.54337, 201.926]]]).
arc(arc01722,node01589,node01309,influence,[complete=true,name=i43,role=[use(none,in_hierarchy,'LPJ_data_wheat_2011_2030',1)]],[course=[[ 70.224006, 53.515782],[ 37.075705, 37.641579],[ 3.6603372, 25.884358]]]).
arc(arc01724,node01590,node01309,influence,[complete=true,name=i45,role=[use(none,in_hierarchy,'LPJ_data_wheat_2031_2050',1)]],[course=[[ 69.97850200000001, 54.140513],[ 37.791181, 42.280529],[ 3.6603372, 25.884358]]]).
arc(arc01726,node01593,node01309,influence,[complete=true,name=i48,role=[use(none,in_hierarchy,'LPJ_data_maize_2011_2030',1)]],[course=[[ 69.99023, 54.106503],[ 22.822913, 36.854548],[ 2.9788863, 27.525496]]]).
arc(arc01728,node01594,node01309,influence,[complete=true,name=i50,role=[use(none,in_hierarchy,'LPJ_data_maize_2031_2050',1)]],[course=[[ 70.18193100000001, 53.612008],[ 19.055798, 30.620735],[ 4.2442007, 24.612089]]]).
arc(arc01730,node01597,node01309,influence,[complete=true,name=i52,role=[use(none,in_hierarchy,'LPJ_data_sunflower_2011_2030',1)]],[course=[[ 70.13556699999999, 53.722531],[ 9.935644099999999, 28.017089],[ 2.7748505, 28.057102]]]).
arc(arc01732,node01598,node01309,influence,[complete=true,name=i55,role=[use(none,in_hierarchy,'LPJ_data_sunflower_2031_2050',1)]],[course=[[ 70.054373, 53.929155],[ 23.350587, 35.43976],[ 3.9649177, 25.207159]]]).
arc(arc01734,node01601,node01309,influence,[complete=true,name=i57,role=[use(none,in_hierarchy,'LPJ_data_soya_2011_2030',1)]],[course=[[ 69.875231, 54.466402],[ 11.259655, 36.628921],[ 3.2327241, 26.891693]]]).
arc(arc01736,node01602,node01309,influence,[complete=true,name=i61,role=[use(none,in_hierarchy,'LPJ_data_soya_2031_2050',1)]],[course=[[ 70.142146, 53.706542],[ 5.924814, 26.17363],[ 2.620575, 28.473556]]]).
arc(arc01457,node01603,node00886,influence,[complete=true,name=i6,role=[use(none,in_hierarchy,scaling_factor_maize,1)]],[course=[[ 100.27986, 208.6582],[ 72.140945, 228.45182],[ -5.5770001e-06, 253.94528]]]).
arc(arc01526,node01604,node00886,influence,[complete=true,name=i15,role=[use(none,in_hierarchy,scaling_factor_sunflower,1)]],[course=[[ 99.914327, 208.085],[ 56.953426, 232.81673],[ -2.842171e-14, 255.84934]]]).
arc(arc01713,node01605,node00886,influence,[complete=true,name=i17,role=[use(none,in_hierarchy,scaling_factor_soya,1)]],[course=[[ 99.646117, 207.57469],[ 45.822855, 233.27352],[ -5.5770001e-06, 257.78236]]]).
arc(arc01739,node01606,node00886,influence,[complete=true,name=i29,role=[use(none,in_hierarchy,scaling_factor_wheat,1)]],[course=[[ 99.84405099999999, 207.96019],[ 56.009136, 232.09241],[ -5.5770001e-06, 256.31925]]]).
arc(arc01828,node01617,node01309,influence,[complete=true,name=i7,role=[use(none,in_hierarchy,'LPJ_data_wheat_2051_2070',1)]],[course=[[ 70.018154, 54.027574],[ 42.804638, 23.23974],[ 2.5533673, 28.659172]]]).
arc(arc01830,node01629,node01309,influence,[complete=true,name=i16,role=[use(none,in_hierarchy,'LPJ_data_maize_2051_2070',1)]],[course=[[ 70.14248499999999, 53.705721],[ 43.955344, 22.709381],[ 3.5874097, 26.051239]]]).
arc(arc01832,node01639,node01309,influence,[complete=true,name=i31,role=[use(none,in_hierarchy,'LPJ_data_sunflower_2051_2070',1)]],[course=[[ 70.20311700000001, 53.563098],[ 11.369713, 27.875178],[ 2.0504156, 30.141982]]]).
arc(arc01833,node01640,node01309,influence,[complete=true,name=i32,role=[use(none,in_hierarchy,'LPJ_data_soya_2051_2070',1)]],[course=[[ 70.014256, 54.038427],[ -5.5813609, 27.048838],[ 2.6465883, 28.402407]]]).
arc(arc01740,node00871,node00864,influence,[complete=true,name=i30],[course=[[ 188.09035, 318.54463],[ 87.940471, 357.5787],[ 10.328394, 357.77678]]]).
arc(arc00704,node00891,node00864,influence,[complete=true,name=i5],[course=[[ 190.72828, 90.651425],[ 264.54541, 43.13965],[ 332.5566, 9.0303463]]]).
arc(arc00897,node00923,node00864,influence,[complete=true,name=i9],[course=[[ 307.20218, 415.77866],[ 181.78872, 435.35311],[ 151.41873, 444.68784]]]).
arc(arc01458,node00937,node00864,influence,[complete=true,name=i7],[course=[[ 188.09035, 316.17066],[ 173.03625, 328.96671],[ 108.8226, 353.68719]]]).
arc(arc00937,node00950,node00949,influence,[name=i32],[]).
arc(arc01581,node00864,node00950,influence,[complete=true,name=i48,role=[use(none,in_hierarchy,['Weighted_yield'],array(1,4))]],[course=[[ 690.50179, 137.7092],[ 645.22339, 160.38967],[ 534.57257, 222.30407]]]).
arc(arc00940,node00960,node00864,influence,[complete=true,name=i20],[course=[[ 303.5391, 415.77866],[ 327.46939, 430.98027],[ 352.80736, 442.98568]]]).
arc(arc00978,node00949,node00978,influence,[complete=true,name=i53],[course=[[ 752.36141, 135.2042],[ 740.5870200000001, 133.88362],[ 704.70712, 134.26954]]]).
arc(arc00990,node00997,node00994,influence,[name=i23],[]).
arc(arc00993,node00864,node00997,influence,[complete=true,name=i25,role=[use(none,in_hierarchy,['Weighted_yield_2000'],array(1,4))]],[course=[[ 623.36257, 244.60011],[ 586.1550099999999, 251.43717],[ 534.57257, 259.46919]]]).
arc(arc00938,node01190,node00864,influence,[complete=true,name=i13],[course=[[ 305.47004, 415.77866],[ 256.58307, 443.83839],[ 251.50698, 449.48985]]]).
arc(arc01347,node01223,node00864,influence,[complete=true,name=i31],[course=[[ 534.57257, 222.25752],[ 659.4199, 70.438498],[ 724.67961, -17.49402]]]).
arc(arc01362,node01226,node00864,influence,[complete=true,name=i36],[course=[[ 534.57257, 222.69697],[ 661.9005100000001, 69.331282],[ 725.00652, -17.27206]]]).
arc(arc01366,node01229,node00864,influence,[complete=true,name=i40],[course=[[ 534.57257, 222.30407],[ 662.72961, 66.741963],[ 725.14519, -17.177]]]).
arc(arc01389,node01233,node00864,influence,[complete=true,name=i45],[course=[[ 534.57257, 222.56807],[ 662.82167, 68.352597],[ 723.94701, -17.98065]]]).
arc(arc01408,node01236,node00864,influence,[complete=true,name=i22],[course=[[ 304.46146, 415.77866],[ 331.49482, 429.58062],[ 401.55571, 451.70403]]]).
arc(arc01399,node01281,node00864,influence,[complete=true,name=i61],[course=[[ 534.57257, 167.49508],[ 669.49293, 158.64121],[ 724.03806, -17.92097]]]).
arc(arc01405,node01286,node00864,influence,[complete=true,name=i66],[course=[[ 534.57257, 138.02495],[ 571.9689100000001, 95.537531],[ 540.2499299999999, -28.28428]]]).
arc(arc01410,node01289,node00864,influence,[complete=true,name=i24],[course=[[ 191.65318, 88.33332900000001],[ 108.5406, 56.831082],[ 70.59912, 35.43198]]]).
arc(arc01450,node01290,node00864,influence,[complete=true,name=i26],[course=[[ 192.47987, 86.536862],[ 155.34367, 100.20171],[ 91.94593999999999, 125.20866]]]).
arc(arc01455,node01291,node00864,influence,[complete=true,name=i28],[course=[[ 191.70222, 88.220463],[ 143.32599, 158.55321],[ 93.9791, 231.32215]]]).
arc(arc01738,node01296,node00864,influence,[complete=true,name=i18],[course=[[ 188.09035, 320.00773],[ 136.87399, 356.92573],[ 52.265792, 389.07317]]]).
arc(arc01827,node01297,node00864,influence,[complete=true,name=i3],[course=[[ 190.64372, 90.884552],[ 171.13649, 5.7204115],[ 97.801948, -15.307249]]]).
arc(arc01463,node01300,node01299,influence,[name=i168],[]).
arc(arc01467,node01304,node01299,influence,[complete=true,name=i172],[course=[[ 58.390722, 7.631271],[ 109.58131, 34.095759],[ 156.97766, 47.542762]]]).
arc(arc01471,node01314,node01313,influence,[name=i176],[]).
arc(arc01490,node01320,node01314,influence,[complete=true,name=i186,role=[use(0,in_base,'IDNUTS_link2',1)]],[course=[[ 58.840608, 83.63529200000001],[ 84.74502200000001, 81.53272200000001],[ 101.77559, 82.97642]]]).
arc(arc01483,node01321,node01320,influence,[name=i179],[]).
arc(arc01486,node01324,node01320,influence,[complete=true,name=i182],[course=[[ 115.02933, 77.250347],[ 145.1016, 66.712794],[ 156.97766, 33.78686]]]).
arc(arc01492,node01330,node01329,influence,[name=i188],[]).
arc(arc01493,node01299,node01330,influence,[complete=true,name=i189,role=[use(0,in_base,food_crops_ini_abs_link2,1)]],[course=[[ 111.30031, 6.7613321],[ 96.138166, 6.9294213],[ 58.411636, 7.047577]]]).
arc(arc01503,node01329,node01341,influence,[complete=true,name=i199],[course=[[ 121.19252, -32.526903],[ 122.85781, -2.1770371],[ 121.53729, 0.090819595]]]).
arc(arc01704,node01519,node01314,influence,[complete=true,name=i18,role=[use(none,in_hierarchy,index,int)]],[course=[[ 28.840608, 90.529213],[ 22.699467, 92.853194],[ -6.4866073e-06, 103.304]]]).
arc(arc01468,node01305,node01298,influence,[complete=true,name=i173],[course=[[ 729.734, 354.427],[ 742.12243, 364.97172],[ 752.36141, 362.78852]]]).
arc(arc01472,node01315,node01298,relation,[complete=true,name=role1],[caption_offset=[ 130.10761, 49.497461],course=[[ 716.88626, 431.54269],[ 733.60959, 440.87121],[ 739.42733, 449.09752]]]).
arc(arc01461,node00994,node01317,influence,[complete=true,name=i29],[course=[[ 752.36141, 245.0788],[ 718.7030099999999, 245.42032],[ 638.23678, 243.4301]]]).
arc(arc01487,node01325,node01298,influence,[complete=true,name=i183],[course=[[ 729.734, 340.6711],[ 745.12244, 335.92482],[ 752.36141, 318.45062]]]).
arc(arc00994,node01339,node00997,influence,[complete=true,name=i27,role=[use(none,in_hierarchy,'FC_surf_ini',1)]],[course=[[ 636.77604, 238.79437],[ 659.20928, 222.25725],[ 688.27221, 199.51586]]]).
arc(arc01505,node01339,node00950,influence,[complete=true,name=i201,role=[use(none,in_hierarchy,'FC_surf_ini',1)]],[course=[[ 695.87814, 141.73145],[ 694.19889, 162.83326],[ 694.33696, 187.66153]]]).
arc(arc01502,node01340,node01339,influence,[name=i198],[]).
arc(arc01504,node01298,node01340,influence,[complete=true,name=i200,role=[use(none,in_hierarchy,{'FC_surf'},list(1))]],[course=[[ 694.18931, 202.65902],[ 693.2807299999999, 238.63344],[ 693.94885, 274.35734]]]).
arc(arc01516,node01339,node01349,influence,[complete=true,name=i212],[course=[[ 752.36141, 194.95248],[ 730.84565, 197.47391],[ 701.86364, 195.63606]]]).
arc(arc01533,node01366,node00864,influence,[complete=true,name=i80],[course=[[ 534.57257, 215.31507],[ 654.30983, 230.11748],[ 752.36141, 137.43968]]]).
arc(arc01829,node01387,node00864,influence,[complete=true,name=i8],[course=[[ 191.67777, 88.27661999999999],[ 147.72444, 67.700873],[ 84.184065, 91.298489]]]).
arc(arc01674,node01138,node01498,influence,[complete=true,name=i172],[course=[[ 752.36141, 87.12128199999999],[ 690.64658, 21.370337],[ 592.9424, 31.735664]]]).
arc(arc01705,node01507,node01298,influence,[complete=true,name=i19],[course=[[ 572.75633, 410.18824],[ 558.45075, 416.99871],[ 530.48065, 428.1383]]]).
arc(arc01690,node01508,node01507,influence,[name=i4],[]).
arc(arc01692,node01510,node01507,influence,[complete=true,name=i6],[course=[[ 522.94344, 423.43498],[ 509.3456, 244.86841],[ 287.7738, -28.28428]]]).
arc(arc01712,node01539,node00864,influence,[complete=true,name=i16],[course=[[ 188.09036, 318.07472],[ 165.04555, 349.63602],[ 156.46185, 376.11721]]]).
arc(arc01723,node01549,node00864,influence,[complete=true,name=i44],[course=[[ 191.75069, 88.10973799999999],[ 246.68403, 39.456315],[ 297.1768, 3.7697378]]]).
arc(arc01725,node01588,node00864,influence,[complete=true,name=i46],[course=[[ 191.75069, 88.10973799999999],[ 202.3096, 46.672883],[ 215.83359, 3.0915168]]]).
arc(arc01727,node01591,node00864,influence,[complete=true,name=i49],[course=[[ 191.06924, 89.750877],[ 148.44648, 63.215347],[ 66.08243400000001, 54.765665]]]).
arc(arc01729,node01592,node00864,influence,[complete=true,name=i51],[course=[[ 192.33456, 86.837469],[ 138.56194, 74.529225],[ 62.828718, 77.491589]]]).
arc(arc01731,node01595,node00864,influence,[complete=true,name=i54],[course=[[ 190.86521, 90.282483],[ 141.63172, 118.28001],[ 89.037693, 152.16799]]]).
arc(arc01733,node01596,node00864,influence,[complete=true,name=i56],[course=[[ 192.05527, 87.43254],[ 150.4395, 123.5889],[ 89.954683, 177.31692]]]).
arc(arc01735,node01599,node00864,influence,[complete=true,name=i58],[course=[[ 191.32308, 89.117073],[ 148.67506, 155.26704],[ 91.48273, 263.0048]]]).
arc(arc01737,node01600,node00864,influence,[complete=true,name=i62],[course=[[ 190.71093, 90.698936],[ 141.93818, 183.99437],[ 80.00956499999999, 289.82328]]]).
arc(arc01826,node01616,node00864,influence,[complete=true,name=i2],[course=[[ 190.73694, 90.627788],[ 144.51178, 181.73058],[ 102.03546, 293.19874]]]).
arc(arc01831,node01638,node00864,influence,[complete=true,name=i10],[course=[[ 190.14077, 92.367363],[ 155.24966, 123.21081],[ 114.5008, 181.44923]]]).
arc(arc01693,node00315,node00298,influence,[complete=true,name=i7],[course=[[ 255.90875, 684.91921],[ 297.00958, 677.27963],[ 309.82633, 656.6353]]]).
arc(arc00825,node00793,node00792,influence,[name=i16],[]).
arc(arc00826,node00795,node00794,influence,[name=i14],[]).
arc(arc00827,node00797,node00796,influence,[name=i2],[]).
arc(arc00828,node00794,node00797,influence,[complete=true,name=i19_0,role=[use(none,in_hierarchy,usr('Urb_Model'),1)]],[course=[[ 598.0718900000001, 359.03065],[ 575.40216, 330.11334],[ 545.20763, 293.42777]]]).
arc(arc00829,node00792,node00797,influence,[complete=true,name=i25_0,role=[use(none,in_hierarchy,usr('Urb_reg'),1)]],[course=[[ 599.69647, 371.8058],[ 584.16972, 407.34477],[ 560.8307600000001, 442.50269]]]).
arc(arc00830,node00799,node00798,influence,[name=i46],[]).
arc(arc00831,node00800,node00793,influence,[complete=true,name=i23_0,role=[use(none,in_hierarchy,surface,1)]],[course=[[ 556.72948, 456.25108],[ 556.99657, 499.15009],[ 557.22663, 540.32858]]]).
arc(arc00832,node00800,node00802,influence,[complete=true,name=i5_0,role=[use(none,in_hierarchy,surface,1)]],[course=[[ 647.5898, 404.13205],[ 586.0933199999999, 507.35808],[ 561.61955, 541.71957]]]).
arc(arc00833,node00802,node00801,influence,[name=i3],[]).
arc(arc01222,node00345,node00802,influence,[complete=true,name=i27,role=[use(none,in_hierarchy,'K',1)]],[course=[[ 658.92258, 397.39491],[ 692.38973, 396.08252],[ 725.48999, 391.80768]]]).
arc(arc00834,node00804,node00803,influence,[name=i10],[]).
arc(arc00835,node00796,node00804,influence,[complete=true,name=i12_0,role=[use(none,in_hierarchy,usr(diff),1)]],[course=[[ 664.70317, 343.27752],[ 649.1173199999999, 347.23667],[ 611.8095, 361.45986]]]).
arc(arc00836,node00801,node00804,influence,[complete=true,name=i24_0,role=[use(none,in_hierarchy,usr(var_max),1*1*1)]],[course=[[ 671.79904, 347.99803],[ 666.04238, 365.41227],[ 654.52184, 390.85649]]]).
arc(arc00837,node00805,node00793,influence,[complete=true,name=i26,role=[use(none,in_hierarchy,'Dens_reg',1)]],[course=[[ 551.54695, 443.28559],[ 515.22534, 404.63146],[ 412.90806, 331.60057]]]).
arc(arc00803,node00769,node00768,influence,[complete=true,name=i3_0,role=[use(none,in_hierarchy,['GDP_Matrice'],array(1,81))]],[course=[[ 113.73887, 203.21387],[ 114.6411, 158.61547],[ 114.61452, 116.89686]]]).
arc(arc00804,node00771,node00770,influence,[name=i1],[]).
arc(arc00805,node00772,node00771,influence,[complete=true,name=i6,role=[use(none,in_hierarchy,'GDP_t_1',1)]],[course=[[ 269.40878, 304.54628],[ 174.51123, 249.1233],[ 121.89524, 217.98606]]]).
arc(arc00806,node00768,node00772,influence,[name=i2],[]).
arc(arc00807,node00773,node00771,influence,[complete=true,name=i31,role=[use(none,in_hierarchy,const,int)]],[course=[[ 271.00578, 316.76989],[ 249.44854, 354.06335],[ 231.86376, 383.26407]]]).
arc(arc00808,node00773,node00771,influence,[complete=true,name=i32_0,role=[use(none,in_hierarchy,coef_pop,1)]],[course=[[ 271.05904, 316.80046],[ 257.02344, 341.43851],[ 231.86376, 383.26407]]]).
arc(arc00809,node00773,node00771,influence,[complete=true,name=i33,role=[use(none,in_hierarchy,coef_gdp,1)]],[course=[[ 271.64514, 314.51513],[ 251.67004, 343.66002],[ 231.86376, 383.26407]]]).
arc(arc00812,node00786,node00781,influence,[complete=true,name=i31,role=[use(none,in_hierarchy,const,int)]],[course=[[ 183.33744, -5.6843419e-14],[ 139.9966, 32.585749],[ 84.704752, 82.88848900000001]]]).
arc(arc00813,node00787,node00786,influence,[name=i24],[]).
arc(arc00814,node00788,node00782,influence,[complete=true,name=i32,role=[use(none,in_hierarchy,coef_pop,1)]],[course=[[ 183.33744, -5.6843419e-14],[ 164.61733, 34.898397],[ 141.55671, 79.598625]]]).
arc(arc00815,node00789,node00788,influence,[name=i27],[]).
arc(arc00816,node00790,node00783,influence,[complete=true,name=i33,role=[use(none,in_hierarchy,coef_gdp,1)]],[course=[[ 183.33744, -5.6843419e-14],[ 191.425472398664, 42.75970460183599],[ 204.165294797328, 77.39016820367198]]]).
arc(arc00817,node00791,node00790,influence,[name=i28],[]).
arc(arc00821,node00776,node00771,influence,[complete=true,name=i5,role=[use(none,in_hierarchy,'POP_t_1',1)]],[course=[[ 276.37549, 298.59102],[ 276.15997, 262.82662],[ 276.3003, 226.64518]]]).
arc(arc00822,node00777,node00776,influence,[name=i5_0],[]).
arc(arc00823,node00778,node00777,influence,[complete=true,name=i1,role=[use(none,in_hierarchy,['POP_Matrice'],array(1,81))]],[course=[[ 276.23061, 207.14585],[ 275.8446, 172.13818],[ 276.42364, 122.40648]]]).
arc(arc00838,node00770,node00806,influence,[complete=true,name=i26,role=[use(none,in_hierarchy,'Dens_reg',1)]],[course=[[ 361.42211, 312.62788],[ 321.93314, 307.55932],[ 283.38411, 308.20339]]]).
arc(arc00846,node00813,node00795,influence,[complete=true,name=i30,role=[use(none,in_hierarchy,{'Urb_surf'},list(1))]],[course=[[ 540.77067, 280.14419],[ 541.97695, 252.69083],[ 540.01974, 239.82595]]]).
arc(arc00850,node00798,node00813,influence,[complete=true,name=i34],[course=[[ 488.09979, 239.82595],[ 489.75638, 284.12776],[ 489.31054, 282.17947]]]).
arc(arc00839,node00808,node00807,influence,[name=i1],[]).
arc(arc00840,node00810,node00809,influence,[name=i15],[]).
arc(arc00841,node00812,node00811,influence,[name=i4],[]).
arc(arc00845,node00809,node00819,influence,[complete=true,name=i29],[course=[[ 106.11814, 216.85326],[ 107.92354, 201.78744],[ 106.65098, 188.94483]]]).
arc(arc00847,node00811,node00820,influence,[complete=true,name=i31],[course=[[ 194.6119, 141.30643],[ 164.54153, 129.78578],[ 112.80459, 109.15145]]]).
arc(arc00849,node00821,node00808,influence,[complete=true,name=i33,role=[use(none,in_hierarchy,index,int)]],[course=[[ 54.383076, 77.333072],[ 53.812924, 151.79952],[ 54.198196, 216.85326]]]).
arc(arc00887,node00833,node00812,influence,[complete=true,name=i16,role=[use(0,in_base,'Suitability_index_Link',1)]],[course=[[ 113.33811, 106.33454],[ 151.00331, 106.14122],[ 194.61191, 104.81754]]]).
arc(arc01039,node00844,node00810,influence,[complete=true,name=i140,role=[use(0,in_base,urb_surface_Link,1)]],[course=[[ 113.40897, 181.28938],[ 168.68507, 179.87382],[ 194.61191, 181.54304]]]).
arc(arc01127,node01036,node00808,influence,[complete=true,name=i157,role=[use(0,in_base,'IDNUTS_Link',1)]],[course=[[ 69.497923, 62.633652],[ 135.28105, 63.951859],[ 194.61191, 63.058001]]]).
arc(arc00842,node00815,node00814,influence,[name=i17],[]).
arc(arc00848,node00813,node00815,influence,[complete=true,name=i32,role=[use(none,in_hierarchy,{suit},list(1))]],[course=[[ 666.75201, 172.48844],[ 658.14337, 172.03295],[ 628.5135, 164.27912]]]).
arc(arc01103,node00834,node00813,influence,[complete=true,name=i18],[course=[[ 628.5135, 127.79023],[ 679.65926, 126.37481],[ 725.48999, 127.38279]]]).
arc(arc01223,node00803,node00837,influence,[complete=true,name=i136],[course=[[ 725.48999, 339.5121],[ 711.59354, 341.46463],[ 681.6521300000001, 340.99472]]]).
arc(arc01224,node00838,node00813,influence,[complete=true,name=i141],[course=[[ 628.5135, 204.14689],[ 671.42885, 204.22188],[ 725.48999, 206.7203]]]).
arc(arc01225,node00840,node00813,relation,[complete=true,name=role3],[caption_offset=[ 7.0710658, 4.2426395],course=[[ 625.69408, 48.442265],[ 673.46528, 41.446241],[ 709.39993, 30.75986]]]).
arc(arc01227,node00851,node00813,influence,[complete=true,name=i158],[course=[[ 628.5135, 86.030692],[ 676.96134, 87.482496],[ 725.48999, 85.700861]]]).
arc(arc01228,node00814,node00852,influence,[complete=true,name=i149],[course=[[ 725.48999, 174.61274],[ 716.2377, 173.96349],[ 681.73906, 173.07731]]]).
arc(arc01691,node00798,node01509,influence,[complete=true,name=i5],[course=[[ 336.03207, 626.4952500000001],[ 494.48889, 499.35458],[ 487.85045, 296.30471]]]).
arc(arc00843,node00818,node00315,influence,[complete=true,name=i27,role=[use(none,in_hierarchy,'K',1)]],[course=[[ 699.28425, 421.94773],[ 726.76347, 422.27474],[ 758.98643, 421.03493]]]).
arc(arc01023,node00315,node00841,influence,[complete=true,name=i136],[course=[[ 758.98642, 369.89192],[ 729.19208, 371.81706],[ 699.28425, 369.65215]]]).
arc(arc01104,node00847,node00315,influence,[complete=true,name=i19],[course=[[ 699.28425, 157.52284],[ 725.03012, 164.59512],[ 758.98643, 173.8163]]]).
arc(arc01043,node00853,node00315,influence,[complete=true,name=i141],[course=[[ 699.28425, 236.86035],[ 740.50073, 240.62495],[ 758.98642, 237.16588]]]).
arc(arc01696,node00315,node00857,influence,[complete=true,name=i10],[course=[[ 493.52169, 1225.1486],[ 543.80234, 894.96811],[ 309.82633, 656.6353]]]).
arc(arc00641,node00896,node00892,influence,[name=i1],[]).
arc(arc00878,node00902,node00901,influence,[name=i3],[]).
arc(arc01513,node01360,node01348,influence,[name=i4],[]).
arc(arc01514,node01368,node00896,influence,[complete=true,name=i6,role=[use(none,in_hierarchy,'LPJ_data',1)]],[course=[[ 50.761378, 125.06982],[ 22.641827, 75.305679],[ 0.019407626, 30.740501]]]).
arc(arc01538,node01369,node01360,influence,[complete=true,name=i8,role=[use(none,in_hierarchy,'LPJ_data',1)]],[course=[[ 81.596041, 31.016809],[ 45.066595, 30.549629],[ 0.019407626, 30.740501]]]).
arc(arc01574,node01370,node00902,influence,[complete=true,name=i42,role=[use(none,in_hierarchy,usr('Potential_with_technology'),1)]],[course=[[ 185.79048, 209.582],[ 185.79627, 131.94474],[ 185.30223, 40.026825]]]).
arc(arc01539,node01371,node01370,influence,[name=i9],[]).
arc(arc01541,node01348,node01371,influence,[complete=true,name=i11,role=[use(none,in_hierarchy,'POT_LPJ',1)]],[course=[[ 177.77418, 32.098368],[ 151.91767, 31.325566],[ 96.595384, 31.13813]]]).
arc(arc01543,node01374,node01371,influence,[complete=true,name=i13,role=[use(none,in_hierarchy,'T_temp_0',1)]],[course=[[ 192.76188, 32.500078],[ 245.0631, 32.312808],[ 281.00458, 32.250465]]]).
arc(arc01542,node01375,node01374,influence,[name=i12],[]).
arc(arc01552,node01376,node01371,influence,[complete=true,name=i22,role=[use(none,in_hierarchy,scenario,int)]],[course=[[ 189.6007, 38.644531],[ 218.47946, 79.363055],[ 219.60734, 81.711479]]]).
arc(arc01544,node01377,node01376,influence,[name=i14],[]).
arc(arc01545,node01378,node01376,influence,[complete=true,name=i15],[course=[[ 228.96458, 83.99369799999999],[ 309.93289, 45.27061],[ 347.66508, -4.5882925]]]).
arc(arc01555,node01386,node00902,influence,[complete=true,name=i25,role=[use(none,in_hierarchy,usr('Scaling_factor'),1)]],[course=[[ 179.36605, 221.11227],[ 145.59365, 220.71628],[ 103.66648, 220.63228]]]).
arc(arc01573,node01392,node00902,influence,[complete=true,name=i41,role=[use(none,in_hierarchy,usr('Management_factor_plus'),1)]],[course=[[ 191.68586, 212.57485],[ 231.74829, 182.46021],[ 263.08507, 160.53518]]]).
arc(arc01559,node01393,node01392,influence,[name=i26],[]).
arc(arc01564,node01376,node01393,influence,[complete=true,name=i32,role=[use(none,in_hierarchy,scenario,int)]],[course=[[ 264.92018, 149.08597],[ 254.63029, 133.06712],[ 227.26733, 94.552544]]]).
arc(arc01563,node01394,node01393,influence,[complete=true,name=i31,role=[use(none,in_hierarchy,'M_temp',1)]],[course=[[ 275.50965, 152.41944],[ 316.90295, 125.69018],[ 326.11905, 114.65175]]]).
arc(arc01560,node01395,node01394,influence,[name=i28],[]).
arc(arc01606,node01388,node01436,influence,[complete=true,name=i174],[course=[[ 369.10963, 247.90594],[ 228.77186, 287.67723],[ 103.61121, 327.18873]]]).
arc(arc01609,node00901,node01437,influence,[complete=true,name=i177],[course=[[ 369.10963, 182.68183],[ 284.17485, 198.46016],[ 193.0545, 215.65836]]]).
arc(arc01714,node01543,node01360,influence,[complete=true,name=i33,role=[use(none,in_hierarchy,'LPJ_data_2011_2030',1)]],[course=[[ 81.596698, 31.250749],[ 40.811269, 32.001492],[ 0.12494268, 31.431801]]]).
arc(arc01716,node01544,node01360,influence,[complete=true,name=i35,role=[use(none,in_hierarchy,'LPJ_data_2031_2050',1)]],[course=[[ 81.596661, 30.976743],[ 26.563927, 29.97883],[ 0.14012048, 31.231904]]]).
arc(arc00995,node00999,node00998,influence,[name=i32],[]).
arc(arc01610,node00866,node00999,influence,[complete=true,name=i178,role=[use(none,in_hierarchy,'Predicted_actual_yield',1)]],[course=[[ 632.84516, 152.43536],[ 555.72173, 200.10641],[ 452.5482, 253.39249]]]).
arc(arc01056,node00998,node01012,influence,[complete=true,name=i77],[course=[[ 759.43246, 147.98559],[ 730.72588, 148.60747],[ 646.7248, 148.50262]]]).
arc(arc01515,node01336,node00866,influence,[complete=true,name=i7],[course=[[ 83.457984, 101.45117],[ 58.846724, 75.46146299999999],[ 45.258609, 55.679554]]]).
arc(arc01546,node01379,node00866,influence,[complete=true,name=i16],[course=[[ 431.10365, 66.122373],[ 463.24976, 46.197144],[ 462.33468, -6.5176914e-07]]]).
arc(arc01579,node01411,node01410,influence,[name=i32],[]).
arc(arc01607,node00866,node01411,influence,[complete=true,name=i175,role=[use(none,in_hierarchy,actual_yield_2000,1)]],[course=[[ 533.6312799999999, 276.5089],[ 497.11353, 296.24355],[ 452.5482, 318.61661]]]).
arc(arc01582,node01415,node01414,influence,[name=i49],[]).
arc(arc01591,node01416,node01415,influence,[complete=true,name=i55,role=[use(0,in_base,'IDNUTS_link_3',1)]],[course=[[ 60.254821, 112.36719],[ 92.954296, 113.77186],[ 127.18047, 112.94925]]]).
arc(arc01583,node01417,node01416,influence,[name=i50],[]).
arc(arc01584,node01418,node01416,influence,[complete=true,name=i51],[course=[[ 134.36219, 105.59724],[ 156.34715, 51.652101],[ 124.11926, 0.0]]]).
arc(arc01592,node01424,node01423,influence,[name=i56],[]).
arc(arc01596,node01428,node01423,influence,[complete=true,name=i164],[course=[[ 61.240082, 46.627997],[ 122.48659, 75.980311],[ 183.84771, 45.443023]]]).
arc(arc01600,node01432,node01431,influence,[name=i168],[]).
arc(arc01601,node01423,node01432,influence,[complete=true,name=i169,role=[use(0,in_base,'GFC_ini_abs_link_3',1)]],[course=[[ 131.09398, 45.12671],[ 84.57858299999999, 44.38036],[ 61.220506, 46.071922]]]).
arc(arc01603,node01431,node01435,influence,[complete=true,name=i171],[course=[[ 138.20005, 0.0],[ 138.22298, 22.484641],[ 138.47107, 37.75581]]]).
arc(arc01702,node01518,node01415,influence,[complete=true,name=i16,role=[use(none,in_hierarchy,index,int)]],[course=[[ 30.254821, 118.14883],[ 20.468077, 122.34146],[ -5.6843419e-14, 130.53754]]]).
arc(arc01585,node01419,node01413,influence,[complete=true,name=i52],[course=[[ 621.92229, 318.198],[ 756.71705, 198.25478],[ 741.6393399999999, 18.453044]]]).
arc(arc01588,node01421,node01413,relation,[complete=true,name=role1],[caption_offset=[ 158.39187, 38.183755],course=[[ 679.89001, 467.50386],[ 708.7277, 476.45172],[ 729.3687, 486.17226]]]).
arc(arc01597,node01429,node01413,influence,[complete=true,name=i165],[course=[[ 681.65074, 363.64102],[ 725.99836, 372.17292],[ 759.43246, 341.81397]]]).
arc(arc01605,node01433,node00999,influence,[complete=true,name=i173,role=[use(none,in_hierarchy,'GFC_surf_ini',1)]],[course=[[ 637.2, 155.71352],[ 638.7314, 185.55841],[ 637.9741, 220.19015]]]).
arc(arc01608,node01433,node01411,influence,[complete=true,name=i176,role=[use(none,in_hierarchy,'GFC_surf_ini',1)]],[course=[[ 547.15759, 270.07078],[ 613.45798, 242.58282],[ 630.96123, 230.74491]]]).
arc(arc01602,node01434,node01433,influence,[name=i170],[]).
arc(arc01604,node01413,node01434,influence,[complete=true,name=i172,role=[use(none,in_hierarchy,{'GFC_surf'},list(1))]],[course=[[ 636.04923, 234.97871],[ 636.1418200000001, 277.80101],[ 636.00308, 318.198]]]).
arc(arc01612,node01410,node01440,influence,[complete=true,name=i180],[course=[[ 759.43246, 273.23081],[ 690.22518, 273.6899],[ 547.72933, 272.98051]]]).
arc(arc01617,node01433,node01444,influence,[complete=true,name=i185],[course=[[ 759.43246, 225.95334],[ 708.84739, 226.35236],[ 645.3097299999999, 227.61031]]]).
arc(arc01703,node01511,node01413,influence,[complete=true,name=i17],[course=[[ 497.80303, 448.73554],[ 479.34446, 458.56447],[ 462.76369, 463.9513]]]).
arc(arc01694,node01512,node01511,influence,[name=i8],[]).
arc(arc01695,node01513,node01511,influence,[complete=true,name=i9],[course=[[ 453.32471, 459.132],[ 511.86132, 223.89344],[ 535.28623, -6.5176914e-07]]]).
arc(arc01715,node01541,node00866,influence,[complete=true,name=i34],[course=[[ 83.563519, 102.14247],[ 68.98264500000001, 110.00187],[ 44.724832, 123.60985]]]).
arc(arc01717,node01542,node00866,influence,[complete=true,name=i36],[course=[[ 83.57869599999999, 101.94257],[ 64.567145, 144.98169],[ 37.411978, 196.99819]]]).
arc(arc01699,node00315,node00862,influence,[complete=true,name=i13],[course=[[ 470.39601, 1790.8339],[ 673.6608199999999, 1183.5922],[ 309.82633, 656.6353]]]).
arc(arc00477,node00904,node00903,influence,[name=i2],[]).
arc(arc00875,node00905,node00904,influence,[complete=true,name=i4,role=[use(none,in_hierarchy,'LPJ_data',1)]],[course=[[ 62.510255, 24.359482],[ 30.721405, 24.173717],[ 0.0, 24.166449]]]).
arc(arc00885,node00908,node00907,influence,[name=i3],[]).
arc(arc00883,node00928,node00906,influence,[name=i6],[]).
arc(arc00884,node00941,node00928,influence,[complete=true,name=i7,role=[use(none,in_hierarchy,'LPJ_data',1)]],[course=[[ 45.09938, 107.64276],[ 17.065498, 61.322771],[ 0.0, 24.166449]]]).
arc(arc01561,node00943,node00908,influence,[complete=true,name=i31,role=[use(none,in_hierarchy,usr('Scaling_factor'),1)]],[course=[[ 177.07131, 211.91117],[ 149.87504, 212.31262],[ 108.61616, 212.15976]]]).
arc(arc01000,node00907,node01003,influence,[complete=true,name=i73],[course=[[ 350.72486, 167.11405],[ 284.23876, 189.37878],[ 191.87854, 209.80466]]]).
arc(arc00988,node01191,node01002,influence,[name=i17],[]).
arc(arc00992,node01192,node01002,influence,[complete=true,name=i20],[course=[[ 311.36681, 87.633849],[ 405.2712, 59.756164],[ 317.40658, -28.417005]]]).
arc(arc00999,node01373,node01372,influence,[name=i23],[]).
arc(arc01548,node01382,node01381,influence,[name=i18],[]).
arc(arc01549,node01383,node01381,influence,[complete=true,name=i19],[course=[[ 220.59563, 73.965273],[ 249.61152, 21.662928],[ 237.39244, -29.698483]]]).
arc(arc01013,node01389,node01372,influence,[complete=true,name=i24],[course=[[ 283.40327, 17.759019],[ 264.57871, -1.6919884],[ 232.63201, -29.698483]]]).
arc(arc01575,node01405,node00908,influence,[complete=true,name=i33,role=[use(none,in_hierarchy,usr('Management_factor_plus'),1)]],[course=[[ 190.14864, 206.42752],[ 220.37064, 179.42864],[ 247.62101, 151.4135]]]).
arc(arc01500,node01406,node01405,influence,[name=i26],[]).
arc(arc01540,node01381,node01406,influence,[complete=true,name=i29,role=[use(none,in_hierarchy,scenario,int)]],[course=[[ 248.097, 139.54736],[ 237.64743, 123.9848],[ 222.34169, 88.26129899999999]]]).
arc(arc01556,node01002,node01406,influence,[complete=true,name=i30,role=[use(none,in_hierarchy,['M'],array(1,3))]],[course=[[ 258.77359, 141.65184],[ 267.99533, 132.08886],[ 303.45959, 99.801498]]]).
arc(arc01626,node01407,node00908,influence,[complete=true,name=i37,role=[use(none,in_hierarchy,usr('Potential_with_technology'),1)]],[course=[[ 184.5795, 203.92422],[ 184.87158, 112.70764],[ 184.76094, 31.538798]]]).
arc(arc01576,node01408,node01407,influence,[name=i3],[]).
arc(arc01577,node00903,node01408,influence,[complete=true,name=i34,role=[use(none,in_hierarchy,'POT_LPJ',1)]],[course=[[ 177.05483, 24.017186],[ 139.49954, 24.60649],[ 77.503269, 24.102589]]]).
arc(arc01578,node01372,node01408,influence,[complete=true,name=i35,role=[use(none,in_hierarchy,['T'],array(1,6))]],[course=[[ 192.05384, 24.160832],[ 236.55582, 24.901923],[ 271.8086, 24.192526]]]).
arc(arc01587,node01381,node01408,influence,[complete=true,name=i36,role=[use(none,in_hierarchy,scenario,int)]],[course=[[ 188.06848, 30.667639],[ 201.26161, 55.54681],[ 213.50212, 76.71914099999999]]]).
arc(arc01632,node00946,node01455,influence,[complete=true,name=i38],[course=[[ 350.72486, 259.66551],[ 227.05624, 307.60155],[ 106.93906, 340.27121]]]).
arc(arc01718,node01547,node00904,influence,[complete=true,name=i39,role=[use(none,in_hierarchy,'LPJ_data_2011_2030',1)]],[course=[[ 62.503614, 24.00345],[ 32.875397, 23.85261],[ 0.0, 24.834661]]]).
arc(arc01720,node01548,node00904,influence,[complete=true,name=i41,role=[use(none,in_hierarchy,'LPJ_data_2031_2050',1)]],[course=[[ 62.511661, 23.692212],[ 18.321987, 21.631205],[ 0.0, 23.414722]]]).
arc(arc00882,node00898,node00868,influence,[complete=true,name=i5],[course=[[ 130.81473, 63.764418],[ 119.67924, 35.5599],[ 95.100617, 0.27379949]]]).
arc(arc00996,node01001,node01000,influence,[name=i32],[]).
arc(arc01008,node00868,node01001,influence,[complete=true,name=i74,role=[use(none,in_hierarchy,'Predicted_actual_yield',1)]],[course=[[ 665.55288, 93.31664000000001],[ 590.44837, 144.46868],[ 481.5396, 206.71202]]]).
arc(arc01230,node01000,node01047,influence,[complete=true,name=i83],[course=[[ 779.23148, 89.10638299999999],[ 727.8326, 89.79534700000001],[ 679.25113, 89.188434]]]).
arc(arc00997,node01198,node00868,influence,[complete=true,name=i21],[course=[[ 448.22131, 11.180961],[ 480.82603, -6.9051651],[ 485.91995, -43.840612]]]).
arc(arc01550,node01384,node00868,influence,[complete=true,name=i20],[course=[[ 368.20717, 9.899483699999999],[ 445.91435, 10.226584],[ 411.89869, -43.840612]]]).
arc(arc01033,node01396,node00868,influence,[complete=true,name=i25],[course=[[ 363.44674, 9.899483699999999],[ 384.25886, -13.282016],[ 378.20093, -43.840612]]]).
arc(arc01631,node01452,node01409,influence,[name=i32],[]).
arc(arc01633,node00868,node01452,influence,[complete=true,name=i39,role=[use(none,in_hierarchy,actual_yield_2000,1)]],[course=[[ 580.2604700000001, 223.17049],[ 547.90086, 248.49476],[ 481.5396, 299.26349]]]).
arc(arc01634,node01458,node01457,influence,[name=i40],[]).
arc(arc01650,node01461,node01458,influence,[complete=true,name=i169,role=[use(0,in_base,'IDNUTS_link_4',1)]],[course=[[ 54.597972, 104.54083],[ 102.78343, 104.17917],[ 141.32161, 104.53586]]]).
arc(arc01638,node01462,node01461,influence,[name=i41],[]).
arc(arc01639,node01463,node01461,influence,[complete=true,name=i42],[course=[[ 147.11631, 97.301642],[ 160.65003, 42.724648],[ 123.41162, 5.6843419e-14]]]).
arc(arc01642,node01467,node01466,influence,[name=i45],[]).
arc(arc01646,node01471,node01466,influence,[complete=true,name=i165],[course=[[ 57.015152, 37.488025],[ 136.24886, 72.563114],[ 207.88936, 32.201101]]]).
arc(arc01651,node01475,node01474,influence,[name=i170],[]).
arc(arc01652,node01466,node01475,influence,[complete=true,name=i171,role=[use(0,in_base,'PC_ini_abs_link_4',1)]],[course=[[ 139.59332, 37.24583],[ 115.2743, 38.793323],[ 57.051479, 38.383059]]]).
arc(arc01654,node01474,node01478,influence,[complete=true,name=i173],[course=[[ 145.78519, 0.0],[ 145.01875, 14.150437],[ 146.39813, 29.300441]]]).
arc(arc01700,node01517,node01458,influence,[complete=true,name=i14,role=[use(none,in_hierarchy,index,int)]],[course=[[ 24.597972, 111.08884],[ 15.082108, 114.869],[ 1.1368684e-13, 123.58398]]]).
arc(arc01635,node01459,node01456,relation,[complete=true,name=role1],[caption_offset=[ 145.66397, 4.2426399],course=[[ 733.88971, 430.86543],[ 759.40608, 430.95931],[ 772.67295, 431.0532]]]).
arc(arc01640,node01464,node01456,influence,[complete=true,name=i43],[course=[[ 649.49892, 294.15637],[ 775.62364, 147.72944],[ 734.15693, -41.026484]]]).
arc(arc01647,node01472,node01456,influence,[complete=true,name=i166],[course=[[ 733.97666, 326.35747],[ 758.83782, 333.20368],[ 779.23148, 317.42247]]]).
arc(arc01656,node01476,node01001,influence,[complete=true,name=i175,role=[use(none,in_hierarchy,'PC_surf_ini',1)]],[course=[[ 671.51301, 96.590947],[ 668.78381, 137.88536],[ 671.0548700000001, 162.238]]]).
arc(arc01657,node01476,node01452,influence,[complete=true,name=i176,role=[use(none,in_hierarchy,'PC_surf_ini',1)]],[course=[[ 591.5251, 213.34383],[ 636.59663, 188.99775],[ 665.17627, 173.31383]]]).
arc(arc01653,node01477,node01476,influence,[name=i172],[]).
arc(arc01655,node01456,node01477,influence,[complete=true,name=i174,role=[use(none,in_hierarchy,{'PC_surf'},list(1))]],[course=[[ 671.77761, 177.20555],[ 671.3095, 245.25599],[ 671.87249, 294.15637]]]).
arc(arc01659,node01409,node01481,influence,[complete=true,name=i178],[course=[[ 779.23148, 217.81328],[ 699.89131, 217.80681],[ 592.9842599999999, 217.78995]]]).
arc(arc01664,node01476,node01485,influence,[complete=true,name=i183],[course=[[ 779.23148, 169.38406],[ 722.57856, 169.85377],[ 679.2512400000001, 169.72746]]]).
arc(arc01701,node01514,node01456,influence,[complete=true,name=i15],[course=[[ 526.0873, 417.74035],[ 515.79997, 423.34377],[ 500.59441, 430.53523]]]).
arc(arc01697,node01515,node01514,influence,[name=i11],[]).
arc(arc01698,node01516,node01514,influence,[complete=true,name=i12],[course=[[ 492.76315, 426.31586],[ 538.33015, 188.66235],[ 547.51589, -43.840612]]]).
arc(arc01719,node01545,node00868,influence,[complete=true,name=i40],[course=[[ 130.81473, 64.43263],[ 118.69907, 69.307136],[ 89.47488800000001, 72.679361]]]).
arc(arc01721,node01546,node00868,influence,[complete=true,name=i42],[course=[[ 130.81473, 63.012691],[ 112.21445, 95.373217],[ 89.783709, 137.62537]]]).
arc(arc00981,node00298,node00979,influence,[complete=true,name=i54],[course=[[ 758.98642, 847.00078],[ 734.2385, 846.56699],[ 720.49635, 848.40769]]]).
arc(arc01088,node00983,node00315,relation,[complete=true,name=role3],[course=[[ 683.19419, 60.899909],[ 724.3331899999999, 47.443685],[ 755.27633, 43.500462]]]).
arc(arc01086,node00857,node01020,influence,[complete=true,name=i78],[course=[[ 758.98642, 1373.7842],[ 751.55879, 1374.4433],[ 717.66792, 1373.1342]]]).
arc(arc01115,node00315,node01025,influence,[complete=true,name=i149],[course=[[ 758.98642, 208.46995],[ 724.1527, 205.82795],[ 699.28425, 204.75279]]]).
arc(arc01129,node01048,node00315,influence,[complete=true,name=i158],[course=[[ 699.28425, 115.84091],[ 731.93889, 116.75281],[ 758.98642, 116.09789]]]).
arc(arc01231,node00862,node01049,influence,[complete=true,name=i84],[course=[[ 758.98643, 1923.539],[ 721.7142700000001, 1923.9368],[ 702.11158, 1923.7809]]]).
arc(arc01359,node01224,node00298,influence,[complete=true,name=i32],[course=[[ 692.8145500000001, 695.70947],[ 764.1583000000001, 588.19024],[ 758.98642, 601.18615]]]).
arc(arc01363,node01227,node00298,influence,[complete=true,name=i37],[course=[[ 693.14147, 695.93143],[ 712.43844, 679.35139],[ 758.98643, 650.30307]]]).
arc(arc01386,node01230,node00298,influence,[complete=true,name=i41],[course=[[ 693.28014, 696.02649],[ 736.05634, 696.46738],[ 758.98643, 696.52973]]]).
arc(arc01390,node01234,node00298,influence,[complete=true,name=i46],[course=[[ 692.08195, 695.22284],[ 739.2132, 719.33658],[ 758.98643, 735.51897]]]).
arc(arc01401,node01282,node00298,influence,[complete=true,name=i62],[course=[[ 692.17301, 695.28252],[ 733.23207, 710.10601],[ 758.98643, 692.37351]]]).
arc(arc01406,node01287,node00298,influence,[complete=true,name=i67],[course=[[ 508.38488, 684.91921],[ 677.74783, 670.4019500000001],[ 758.98643, 536.95475]]]).
arc(arc01469,node01312,node00298,influence,[complete=true,name=i174],[course=[[ 720.49635, 1075.992],[ 740.07508, 1088.0731],[ 758.98643, 1080.9092]]]).
arc(arc01474,node01316,node00298,relation,[complete=true,name=role2],[course=[[ 707.56228, 1162.301],[ 734.15457, 1178.8556],[ 758.98642, 1198.4807]]]).
arc(arc01462,node00298,node01318,influence,[complete=true,name=i30],[course=[[ 758.98642, 956.3198],[ 739.07677, 956.1638],[ 720.49635, 958.28228]]]).
arc(arc01488,node01326,node00298,influence,[complete=true,name=i184],[course=[[ 720.49635, 1031.6541],[ 742.4427899999999, 1040.2488],[ 758.98643, 1029.5984]]]).
arc(arc00998,node01346,node00862,influence,[complete=true,name=i22],[course=[[ 408.80008, 1790.8339],[ 815.86621, 1414.4346],[ 758.98643, 862.94206]]]).
arc(arc01517,node00298,node01350,influence,[complete=true,name=i213],[course=[[ 758.98642, 907.88762],[ 738.44199, 909.71299],[ 720.49635, 908.15597]]]).
arc(arc01534,node01367,node00298,influence,[complete=true,name=i81],[course=[[ 720.49635, 850.6431700000001],[ 741.40359, 866.41513],[ 758.98643, 862.94206]]]).
arc(arc01547,node01380,node00857,influence,[complete=true,name=i17],[course=[[ 420.57014, 1225.1486],[ 761.8267499999999, 965.65574],[ 758.98643, 536.95475]]]).
arc(arc01551,node01385,node00862,influence,[complete=true,name=i21],[course=[[ 334.77883, 1790.8339],[ 860.35241, 1269.9462],[ 758.98643, 536.95475]]]).
arc(arc01119,node01397,node00862,influence,[complete=true,name=i26],[course=[[ 301.08107, 1790.8339],[ 804.64884, 1356.08],[ 758.98643, 692.37351]]]).
arc(arc01586,node01420,node00857,influence,[complete=true,name=i53],[course=[[ 699.8748000000001, 1243.6016],[ 782.93142, 1151.3779],[ 758.98643, 1029.5984]]]).
arc(arc01589,node01422,node00857,relation,[complete=true,name=role4],[course=[[ 687.60416, 1711.3209],[ 729.43884, 1721.1114],[ 758.98643, 1732.8046]]]).
arc(arc01598,node01430,node00857,influence,[complete=true,name=i166],[course=[[ 717.66792, 1566.9626],[ 741.79629, 1570.354],[ 758.98643, 1553.0861]]]).
arc(arc01613,node00857,node01441,influence,[complete=true,name=i181],[course=[[ 758.98642, 1496.553],[ 743.4087, 1498.4503],[ 717.66792, 1498.3794]]]).
arc(arc01618,node00857,node01445,influence,[complete=true,name=i186],[course=[[ 758.98642, 1451.5333],[ 738.69253, 1452.3017],[ 717.66792, 1451.1019]]]).
arc(arc01636,node01460,node00862,relation,[complete=true,name=role5],[course=[[ 695.55305, 2265.7277],[ 732.54356, 2265.7962],[ 757.04428, 2265.7116]]]).
arc(arc01641,node01465,node00862,influence,[complete=true,name=i44],[course=[[ 657.03703, 1793.648],[ 899.02413, 1437.1106],[ 758.98643, 1029.5984]]]).
arc(arc01648,node01473,node00862,influence,[complete=true,name=i167],[course=[[ 702.11158, 2152.097],[ 735.67695, 2156.0598],[ 758.98643, 2131.5851]]]).
arc(arc01660,node00862,node01482,influence,[complete=true,name=i179],[course=[[ 758.98642, 2051.7055],[ 731.68985, 2052.0201],[ 702.11158, 2052.4878]]]).
arc(arc01665,node00862,node01486,influence,[complete=true,name=i185],[course=[[ 758.98642, 2004.6162],[ 738.46377, 2004.2608],[ 702.11158, 2004.0586]]]).
arc(arc01678,node00298,node01499,influence,[complete=true,name=i173],[course=[[ 758.98643, 809.01297],[ 736.4678, 795.04635],[ 720.49635, 800.3247699999999]]]).
arc(arc00986,node00817,node00845,influence,[complete=true,name=i59],[course=[[ -407.92309, -4.7879716],[ -452.9173, -4.9113419],[ -532.85204, -4.7955872]]]).
arc(arc01219,node00817,node00845,influence,[complete=true,name=i81],[course=[[ -407.92309, 521.22691],[ -464.65528, 521.4878],[ -532.85204, 521.98781]]]).
arc(arc01234,node00817,node00845,influence,[complete=true,name=i87],[course=[[ -407.92309, 1047.6607],[ -485.51857, 1065.2389],[ -532.85203, 1071.7426]]]).
arc(arc01491,node00817,node00845,influence,[complete=true,name=i61],[course=[[ -407.92309, 104.48515],[ -466.88789, 104.38475],[ -532.85204, 104.52344]]]).
arc(arc01520,node00817,node00845,influence,[complete=true,name=i216],[course=[[ -407.92309, 57.269469],[ -449.14922, 56.560816],[ -532.85204, 56.091256]]]).
arc(arc01616,node00817,node00845,influence,[complete=true,name=i184],[course=[[ -407.92309, 644.99511],[ -472.12708, 644.7563],[ -532.85204, 644.75657]]]).
arc(arc01621,node00817,node00845,influence,[complete=true,name=i190],[course=[[ -407.92309, 599.2192],[ -463.62603, 599.35849],[ -532.85204, 599.73688]]]).
arc(arc01663,node00817,node00845,influence,[complete=true,name=i182],[course=[[ -407.92309, 1199.0667],[ -457.12386, 1199.3684],[ -532.85204, 1199.9091]]]).
arc(arc01668,node00817,node00845,influence,[complete=true,name=i188],[course=[[ -407.92309, 1152.726],[ -454.67015, 1152.6534],[ -532.85204, 1152.8198]]]).
arc(arc00096,node00097,node00320,influence,[complete=true,name=i7],[course=[[ 657.15477, 1719.3154],[ 705.19858, 1719.9071],[ 739.11697, 1719.7546]]]).
arc(arc00105,node00320,node00105,influence,[complete=true,name=i13],[course=[[ 739.11697, 1767.649],[ 676.01024, 1766.4742],[ 662.3731, 1766.9246]]]).
arc(arc00119,node00136,node00320,influence,[complete=true,name=i39],[course=[[ 662.3731, 1826.5099],[ 700.65407, 1826.1412],[ 739.11697, 1826.4744]]]).
arc(arc00125,node00158,node00320,influence,[complete=true,name=i46],[course=[[ 662.3731, 1884.0536],[ 715.23806, 1882.6199],[ 739.11697, 1884.2153]]]).
arc(arc00128,node00320,node00168,influence,[complete=true,name=i52],[course=[[ 739.11697, 1934.551],[ 726.68787, 1932.4599],[ 662.3731, 1933.6686]]]).
arc(arc00156,node00240,node00320,influence,[complete=true,name=i68],[course=[[ 662.3731, 1977.8507],[ 705.2960399999999, 1977.2392],[ 739.11697, 1977.982]]]).
arc(arc00176,node00320,node00242,influence,[complete=true,name=i71],[course=[[ 739.11697, 2069.6309],[ 687.07973, 2069.6569],[ 662.3731, 2069.2925]]]).
arc(arc00197,node00248,node00320,influence,[complete=true,name=i78],[course=[[ 662.3731, 2112.8936],[ 713.23261, 2112.289],[ 739.11697, 2113.0387]]]).
arc(arc00273,node00252,node00320,influence,[complete=true,name=i96],[course=[[ 662.3731, 2181.5375],[ 704.33581, 2179.869],[ 739.11697, 2180.5186]]]).
arc(arc00281,node00320,node00254,influence,[complete=true,name=i99],[course=[[ 739.11697, 2230.2964],[ 707.04593, 2229.8329],[ 662.3731, 2230.3422]]]).
arc(arc00289,node00262,node00320,influence,[complete=true,name=i113],[course=[[ 662.3731, 2293.4304],[ 754.79785, 2292.1061],[ 739.11697, 2293.1001]]]).
arc(arc00295,node00320,node00264,influence,[complete=true,name=i118],[course=[[ 739.11697, 2377.2054],[ 711.00735, 2377.8377],[ 662.3731, 2377.1158]]]).
arc(arc00091,node00076,node00075,influence,[name=i3],[]).
arc(arc00371,node00073,node00076,influence,[complete=true,name=i61,role=[use(none,in_hierarchy,surface,1)]],[course=[[ 149.10371, 227.55229],[ 106.28686, 344.09586],[ 60.256155, 464.91592]]]).
arc(arc00092,node00079,node00078,influence,[name=i4],[]).
arc(arc00374,node00073,node00079,influence,[complete=true,name=i64,role=[use(none,in_hierarchy,surface,1)]],[course=[[ 128.28319, 513.5122699999999],[ 87.746878, 486.73291],[ 64.318304, 475.22994]]]).
arc(arc00093,node00081,node00080,influence,[name=i5],[]).
arc(arc00376,node00073,node00081,influence,[complete=true,name=i66,role=[use(none,in_hierarchy,surface,1)]],[course=[[ 57.118706, 854.97515],[ 57.482913, 679.77314],[ 57.582267, 479.4245]]]).
arc(arc00102,node00090,node00089,influence,[name=i12],[]).
arc(arc00103,node00092,node00091,influence,[name=i13],[]).
arc(arc00104,node00094,node00093,influence,[name=i14],[]).
arc(arc00095,node00096,node00090,influence,[complete=true,name=i6,role=[use(none,in_hierarchy,[rent_liquid_area_2005],array(1,58960))]],[course=[[ 267.33937, 56.197252],[ 540.0039, 56.770125],[ 677.38678, 55.943935]]]).
arc(arc00098,node00140,node00104,influence,[complete=true,name=i11],[course=[[ 682.6051200000001, 103.55313],[ 453.12387, 105.41992],[ 267.33916, 103.99335]]]).
arc(arc00160,node00141,node00140,influence,[name=i58],[]).
arc(arc00369,node00089,node00141,influence,[complete=true,name=i59,role=[use(none,in_hierarchy,tot_rent_area_liquid_2005,1)]],[course=[[ 259.87172, 96.435828],[ 259.95339, 77.493622],[ 260.3905, 63.661219]]]).
arc(arc00161,node00143,node00142,influence,[name=i59],[]).
arc(arc00165,node00145,node00144,influence,[name=i60],[]).
arc(arc00170,node00093,node00145,influence,[complete=true,name=i65_0,role=[use(none,in_hierarchy,remaining_rent_area_woody,1)]],[course=[[ 419.0987, 934.0232600000001],[ 420.76845, 873.5448699999999],[ 419.90343, 814.15517]]]).
arc(arc00368,node00150,node00141,influence,[complete=true,name=i57,role=[use(none,in_hierarchy,liquid_biofuels_2005,1)]],[course=[[ 252.36709, 104.57976],[ 230.97542, 106.42339],[ 65.085264, 105.54979]]]).
arc(arc00172,node00151,node00150,influence,[name=i84],[]).
arc(arc00370,node00073,node00151,influence,[complete=true,name=i60,role=[use(none,in_hierarchy,surface,1)]],[course=[[ 57.529285, 112.94424],[ 56.184814, 290.72096],[ 57.527994, 464.42473]]]).
arc(arc00174,node00153,node00152,influence,[name=i86],[]).
arc(arc00372,node00075,node00153,influence,[complete=true,name=i62,role=[use(none,in_hierarchy,liquid_biofuels_abs_t_1,1)]],[course=[[ 322.66368, 220.56314],[ 259.63371, 221.40293],[ 159.18985, 220.57424]]]).
arc(arc00118,node00115,node00155,influence,[complete=true,name=i36,role=[use(none,in_hierarchy,[remaining_liquid_rent_area],array(1,58960))]],[course=[[ 417.1894, 163.4508],[ 561.22239, 162.91661],[ 682.6051200000001, 163.13843]]]).
arc(arc00182,node00155,node00154,influence,[name=i94],[]).
arc(arc00090,node00157,node00086,influence,[name=i1],[]).
arc(arc00124,node00139,node00157,influence,[complete=true,name=i45,role=[use(none,in_hierarchy,[liquid_area_0],array(1,58960))]],[course=[[ 566.60254, 220.53052],[ 634.9187899999999, 220.24847],[ 682.60515, 220.6821]]]).
arc(arc00187,node00160,node00159,influence,[name=i114],[]).
arc(arc00188,node00154,node00160,influence,[complete=true,name=i115,role=[use(none,in_hierarchy,remaining_rent_area_liquid,1)]],[course=[[ 409.442, 262.72891],[ 411.08022, 219.83325],[ 410.06101, 170.96941]]]).
arc(arc00189,node00152,node00160,influence,[complete=true,name=i116,role=[use(none,in_hierarchy,'Liquid_change',1)]],[course=[[ 402.98793, 265.9564],[ 377.07861, 248.03182],[ 336.62925, 224.26293]]]).
arc(arc00127,node00159,node00167,influence,[complete=true,name=i50],[course=[[ 682.60515, 270.29713],[ 604.99197, 269.59046],[ 416.65573, 270.1992]]]).
arc(arc00249,node00172,node00143,influence,[complete=true,name=i17,role=[use(none,in_hierarchy,'NW_biofuels_2005',1)]],[course=[[ 403.22347, 405.37003],[ 370.63445, 403.26477],[ 188.21028, 404.54126]]]).
arc(arc00173,node00142,node00241,influence,[complete=true,name=i70],[course=[[ 682.6051200000001, 405.921],[ 575.9458100000001, 407.1358],[ 418.20947, 405.88381]]]).
arc(arc00196,node00247,node00092,influence,[complete=true,name=i77,role=[use(none,in_hierarchy,[remaining_NW_rent_area],array(1,58960))]],[course=[[ 379.71198, 450.03392],[ 562.66011, 450.03471],[ 682.6051200000001, 449.52214]]]).
arc(arc00307,node00329,node00094,influence,[complete=true,name=i131,role=[use(none,in_hierarchy,[remaining_woody_rent_area],array(1,58960))]],[course=[[ 427.11695, 806.62582],[ 566.36676, 805.97924],[ 682.6051200000001, 807.02469]]]).
arc(arc00310,node00144,node00332,influence,[complete=true,name=i135],[course=[[ 679.65622, 941.1567],[ 568.28766, 941.5905299999999],[ 426.39171, 941.52392]]]).
arc(arc00060,node00357,node00151,influence,[complete=true,name=i9,role=[use(none,in_hierarchy,[liquid_data],array(1,76))]],[course=[[ 62.585033, 111.03549],[ 85.41887699999999, 135.11681],[ 99.044017, 152.56923]]]).
arc(arc00067,node00357,node00076,influence,[complete=true,name=i15,role=[use(none,in_hierarchy,[liquid_data],array(1,76))]],[course=[[ 147.27926, 214.44652],[ 124.09892, 182.56872],[ 108.51187, 164.19963]]]).
arc(arc00086,node00360,node00079,influence,[complete=true,name=i20,role=[use(none,in_hierarchy,['NW_data'],array(1,76))]],[course=[[ 137.24276, 511.36494],[ 147.89332, 487.90499],[ 158.69028, 465.31148]]]).
arc(arc00134,node00362,node00081,influence,[complete=true,name=i22,role=[use(none,in_hierarchy,['Woody_data'],array(1,76))]],[course=[[ 60.531849, 855.80476],[ 75.72929600000001, 826.23918],[ 88.755487, 791.58591]]]).
arc(arc00077,node00360,node00395,influence,[complete=true,name=i19,role=[use(none,in_hierarchy,['NW_data'],array(1,76))]],[course=[[ 177.9183, 411.55462],[ 170.11074, 431.01892],[ 164.06218, 451.35568]]]).
arc(arc00175,node00395,node00172,influence,[name=i10],[]).
arc(arc00373,node00073,node00395,influence,[complete=true,name=i63,role=[use(none,in_hierarchy,surface,1)]],[course=[[ 173.80497, 407.52019],[ 134.49861, 428.55835],[ 64.119069, 468.24091]]]).
arc(arc00258,node00251,node00568,influence,[complete=true,name=i95,role=[use(none,in_hierarchy,['NW_area'],array(1,58960))]],[course=[[ 599.86631, 518.30772],[ 650.41412, 517.9932],[ 682.6051200000001, 518.16604]]]).
arc(arc00419,node00568,node00567,influence,[name=i31],[]).
arc(arc00649,node00573,node00572,influence,[name=i87],[]).
arc(arc00651,node00078,node00573,influence,[complete=true,name=i90,role=[use(none,in_hierarchy,non_woody_biofuels_abs_t_1,1)]],[course=[[ 239.35189, 518.35167],[ 195.29408, 518.1808600000001],[ 141.64239, 518.1925]]]).
arc(arc00280,node00574,node00253,influence,[complete=true,name=i98],[course=[[ 682.6051200000001, 566.97072],[ 550.21396, 567.83263],[ 379.69269, 567.03399]]]).
arc(arc00652,node00575,node00574,influence,[name=i91],[]).
arc(arc00653,node00572,node00575,influence,[complete=true,name=i92,role=[use(none,in_hierarchy,'NW_change',1)]],[course=[[ 365.46743, 563.67925],[ 332.23608, 547.27634],[ 253.9577, 520.90239]]]).
arc(arc00654,node00091,node00575,influence,[complete=true,name=i93,role=[use(none,in_hierarchy,remaining_rent_area_non_woody,1)]],[course=[[ 372.18235, 559.49887],[ 372.08041, 486.12012],[ 372.18463, 457.53384]]]).
arc(arc00680,node00585,node00143,influence,[complete=true,name=i120,role=[use(none,in_hierarchy,tot_rent_area_NW_2005_0,1)]],[course=[[ 410.63599, 398.32464],[ 410.27398, 361.49328],[ 410.6604, 322.42714]]]).
arc(arc00154,node00235,node00586,influence,[complete=true,name=i67,role=[use(none,in_hierarchy,[rent_NW_area_2005],array(1,58960))]],[course=[[ 418.09974, 314.90827],[ 563.02144, 314.53894],[ 682.6051200000001, 314.47922]]]).
arc(arc00669,node00586,node00585,influence,[name=i25],[]).
arc(arc00287,node00261,node00597,influence,[complete=true,name=i112,role=[use(none,in_hierarchy,[rent_woody_area_2005],array(1,58960))]],[course=[[ 470.70625, 629.65919],[ 576.79587, 628.1428100000001],[ 682.6051200000001, 630.05895]]]).
arc(arc00683,node00597,node00596,influence,[name=i53],[]).
arc(arc00121,node00362,node00602,influence,[complete=true,name=i21,role=[use(none,in_hierarchy,['Woody_data'],array(1,76))]],[course=[[ 115.39433, 721.31168],[ 105.33761, 745.52203],[ 93.89522100000001, 777.56883]]]).
arc(arc00375,node00073,node00602,influence,[complete=true,name=i65,role=[use(none,in_hierarchy,surface,1)]],[course=[[ 116.4391, 707.11274],[ 88.077386, 594.54085],[ 59.786156, 479.09453]]]).
arc(arc00688,node00602,node00601,influence,[name=i119],[]).
arc(arc00291,node00603,node00263,influence,[complete=true,name=i117],[course=[[ 682.6051200000001, 713.74433],[ 590.12518, 713.46791],[ 471.28751, 713.99566]]]).
arc(arc00690,node00604,node00603,influence,[name=i122],[]).
arc(arc00691,node00596,node00604,influence,[complete=true,name=i123,role=[use(none,in_hierarchy,tot_rent_area_woody_2005,1)]],[course=[[ 463.4596, 706.53614],[ 461.24761, 676.26005],[ 462.89122, 637.25973]]]).
arc(arc00692,node00601,node00604,influence,[complete=true,name=i124,role=[use(none,in_hierarchy,woody_biofuels_2005,1)]],[course=[[ 456.28817, 713.9351],[ 326.29451, 712.3082000000001],[ 125.77104, 714.31058]]]).
arc(arc00301,node00325,node00609,influence,[complete=true,name=i125,role=[use(none,in_hierarchy,[woody_area_0],array(1,58960))]],[course=[[ 588.07165, 862.41488],[ 632.67599, 863.11826],[ 682.6051200000001, 861.66506]]]).
arc(arc00643,node00609,node00608,influence,[name=i16],[]).
arc(arc00171,node00613,node00145,influence,[complete=true,name=i18,role=[use(none,in_hierarchy,woody_change,1)]],[course=[[ 412.41652, 937.73596],[ 346.00247, 898.92007],[ 282.4426, 865.88014]]]).
arc(arc00702,node00614,node00613,influence,[name=i128],[]).
arc(arc00703,node00080,node00614,influence,[complete=true,name=i129,role=[use(none,in_hierarchy,woody_biofuels_abs_t_1,1)]],[course=[[ 268.28994, 862.24981],[ 190.10012, 860.4654399999999],[ 64.602259, 862.36181]]]).
arc(arc00232,node00712,node00711,influence,[name=i2],[]).
arc(arc01196,node00713,node00573,influence,[complete=true,name=i130,role=[use(none,in_hierarchy,'NW_area_bis',1)]],[course=[[ 254.35019, 518.54266],[ 350.72471, 518.9916899999999],[ 425.35549, 518.33212]]]).
arc(arc01172,node00714,node00713,influence,[name=i7],[]).
arc(arc01195,node00567,node00714,influence,[complete=true,name=i127,role=[use(none,in_hierarchy,'NW_area',1)]],[course=[[ 440.35492, 518.32991],[ 510.84676, 518.2100799999999],[ 584.86646, 518.34111]]]).
arc(arc01182,node00766,node00712,influence,[complete=true,name=i102,role=[use(none,in_hierarchy,[woody_to_remove],array(1,58960))]],[course=[[ 587.00328, 958.42393],[ 639.3616, 967.0269],[ 664.83251, 971.04395]]]).
arc(arc01357,node00779,node00714,influence,[complete=true,name=i180,role=[use(none,in_hierarchy,removed_NW,1)]],[course=[[ 439.87141, 520.91586],[ 519.6179, 551.03598],[ 584.56122, 583.84485]]]).
arc(arc01197,node00780,node00779,influence,[name=i118],[]).
arc(arc01191,node00784,node00614,influence,[complete=true,name=i113,role=[use(none,in_hierarchy,woody_area_bis,1)]],[course=[[ 283.28799, 862.42069],[ 365.33676, 862.4182],[ 458.85748, 862.05686]]]).
arc(arc01185,node00711,node00785,influence,[complete=true,name=i105,role=[use(none,in_hierarchy,removed_woody,1)]],[course=[[ 472.05376, 866.9065900000001],[ 527.81688, 914.66579],[ 573.80729, 952.44711]]]).
arc(arc01189,node00785,node00784,influence,[name=i110],[]).
arc(arc01190,node00608,node00785,influence,[complete=true,name=i111,role=[use(none,in_hierarchy,woody_area,1)]],[course=[[ 473.85587, 861.87512],[ 529.23312, 860.74691],[ 573.07599, 862.07033]]]).
arc(arc01203,node00822,node00153,influence,[complete=true,name=i139,role=[use(none,in_hierarchy,liquid_area_bis,1)]],[course=[[ 337.66218, 220.57461],[ 406.12841, 221.59154],[ 445.74824, 221.19135]]]).
arc(arc01200,node00823,node00822,influence,[name=i136],[]).
arc(arc01202,node00086,node00823,influence,[complete=true,name=i138,role=[use(none,in_hierarchy,liquid_area,1)]],[course=[[ 460.74552, 221.30267],[ 505.98248, 222.43139],[ 551.60724, 220.82533]]]).
arc(arc01341,node01175,node00780,influence,[complete=true,name=i160,role=[use(none,in_hierarchy,['NW_to_remove'],array(1,58960))]],[course=[[ 598.75419, 587.08816],[ 658.6793, 585.98078],[ 682.60515, 587.12825]]]).
arc(arc01358,node01180,node00823,influence,[complete=true,name=i181,role=[use(none,in_hierarchy,removed_liquid,1)]],[course=[[ 459.70285, 224.93437],[ 516.25796, 258.39244],[ 558.24964, 278.14446]]]).
arc(arc01350,node01181,node01180,influence,[name=i170],[]).
arc(arc01354,node01187,node01181,influence,[complete=true,name=i177,role=[use(none,in_hierarchy,[liquid_to_remove],array(1,58960))]],[course=[[ 572.53633, 281.34393],[ 628.00135, 281.39687],[ 682.60515, 281.84387]]]).
arc(arc00302,node00326,node00320,influence,[complete=true,name=i126],[course=[[ 662.3731, 2525.0365],[ 698.05472, 2524.3215],[ 739.11697, 2524.5615]]]).
arc(arc00308,node00330,node00320,influence,[complete=true,name=i132],[course=[[ 662.3731, 2470.3962],[ 708.9066800000001, 2469.4926],[ 739.11697, 2469.9433]]]).
arc(arc00377,node00320,node00333,influence,[complete=true,name=i136],[course=[[ 739.11697, 2604.2059],[ 699.0659000000001, 2603.5613],[ 659.42421, 2604.5282]]]).
arc(arc01183,node00767,node00320,influence,[complete=true,name=i103],[course=[[ 644.60046, 2634.4154],[ 710.88517, 2637.471],[ 739.11697, 2639.8802]]]).
arc(arc00054,node00043,node00848,influence,[complete=true,name=i33],[course=[[ 665.09858, 918.2963],[ 725.89973, 928.82814],[ 739.11697, 929.35555]]]).
arc(arc00058,node00848,node00045,influence,[complete=true,name=i37],[course=[[ 739.11697, 989.01373],[ 693.80395, 991.70245],[ 664.1560899999999, 989.45167]]]).
arc(arc00272,node00364,node00848,influence,[complete=true,name=i45],[course=[[ 665.09858, 633.75229],[ 707.0566700000001, 633.6194],[ 739.11697, 637.2626299999999]]]).
arc(arc00048,node00037,node00036,influence,[name=i23],[]).
arc(arc00049,node00039,node00038,influence,[name=i24],[]).
arc(arc00056,node00036,node00039,influence,[complete=true,name=i35,role=[use(none,in_hierarchy,surf_where_ch_apply_bis,1)]],[course=[[ 447.14415, 474.16533],[ 497.06242, 473.65334],[ 570.77724, 475.18415]]]).
arc(arc00053,node00042,node00037,influence,[complete=true,name=i31,role=[use(none,in_hierarchy,[modifiable_surface_bis],array(1,58960))]],[course=[[ 585.68394, 476.50903],[ 615.24685, 481.17457],[ 648.56386, 483.82197]]]).
arc(arc00057,node00038,node00044,influence,[complete=true,name=i36],[course=[[ 647.62137, 554.97734],[ 514.19577, 500.67942],[ 446.71325, 476.74894]]]).
arc(arc00239,node00221,node00204,influence,[name=i2],[]).
arc(arc00270,node00311,node00221,influence,[complete=true,name=i44,role=[use(none,in_hierarchy,['GFC_adjusted'],array(1,58960))]],[course=[[ 492.12359, 198.55873],[ 581.79465, 200.1106],[ 648.56386, 199.27796]]]).
arc(arc00857,node00870,node00869,influence,[name=i10],[]).
arc(arc00860,node00875,node00874,influence,[name=i29],[]).
arc(arc00861,node00876,node00873,influence,[name=i30],[]).
arc(arc00276,node00869,node00878,influence,[complete=true,name=i47,role=[use(none,in_hierarchy,'GFC_surf_expected',1)]],[course=[[ 445.5304, 275.13832],[ 423.57123, 273.81258],[ 366.97708, 276.04727]]]).
arc(arc00277,node00204,node00878,influence,[complete=true,name=i50,role=[use(none,in_hierarchy,'GFC_abs_adjusted',1)]],[course=[[ 456.31152, 268.85274],[ 472.98799, 234.75041],[ 482.33642, 205.57134]]]).
arc(arc00862,node00878,node00877,influence,[name=i46],[]).
arc(arc00865,node00880,node00879,influence,[name=i53],[]).
arc(arc00866,node00877,node00880,influence,[complete=true,name=i48,role=[use(none,in_hierarchy,'Expected_change_abs',1)]],[course=[[ 542.14708, 328.88914],[ 483.99416, 289.54328],[ 459.8551, 278.67045]]]).
arc(arc00867,node00874,node00880,influence,[complete=true,name=i49,role=[use(none,in_hierarchy,'Surface_where_changes_apply',1)]],[course=[[ 548.7577199999999, 325.6026],[ 550.13992, 299.64975],[ 549.48016, 285.06731]]]).
arc(arc00050,node00883,node00039,influence,[complete=true,name=i25,role=[use(none,in_hierarchy,exp_change_bis,1)]],[course=[[ 433.30409, 470.23617],[ 390.23629, 443.0247],[ 370.79074, 434.49681]]]).
arc(arc00871,node00884,node00883,influence,[name=i12],[]).
arc(arc00874,node00873,node00884,influence,[complete=true,name=i71,role=[use(none,in_hierarchy,usr('Temp_GFC_surface'),1)]],[course=[[ 371.37518, 430.64597],[ 438.69474, 423.07094],[ 552.40018, 406.7767]]]).
arc(arc01673,node00874,node00884,influence,[complete=true,name=i8,role=[use(none,in_hierarchy,usr('Surface_where_changes_apply'),1)]],[course=[[ 369.51689, 426.48964],[ 463.48008, 342.59883],[ 543.16732, 282.10963]]]).
arc(arc01795,node00877,node00884,influence,[complete=true,name=i17,role=[use(none,in_hierarchy,usr('Expected_change_abs'),1)]],[course=[[ 367.79967, 425.06468],[ 409.22842, 356.47095],[ 449.44604, 282.18574]]]).
arc(arc01796,node00879,node00884,influence,[complete=true,name=i18,role=[use(none,in_hierarchy,usr('Change_coefficient'),1)]],[course=[[ 370.50489, 427.89037],[ 455.66771, 381.39026],[ 541.70763, 336.55771]]]).
arc(arc00898,node00887,node00875,influence,[complete=true,name=i11,role=[use(none,in_hierarchy,[modifiable_surface],array(1,58960))]],[course=[[ 556.62392, 277.06653],[ 620.78103, 272.70711],[ 648.56386, 274.54304]]]).
arc(arc00900,node00889,node00876,influence,[complete=true,name=i9,role=[use(none,in_hierarchy,['GFC_surface_abs_ite1'],array(1,58960))]],[course=[[ 567.30064, 405.11696],[ 611.3244, 401.60837],[ 648.56386, 403.66777]]]).
arc(arc00901,node00879,node00890,influence,[complete=true,name=i13],[course=[[ 648.56386, 337.18783],[ 614.8085600000001, 335.42114],[ 555.85424, 333.35471]]]).
arc(arc01220,node00893,node00870,influence,[complete=true,name=i16,role=[use(none,in_hierarchy,usr('Surface_change'),1)]],[course=[[ 353.80363, 281.24171],[ 306.07165, 322.41173],[ 254.45318, 366.66213]]]).
arc(arc00876,node00894,node00893,influence,[name=i2],[]).
arc(arc00877,node00895,node00894,influence,[complete=true,name=i14,role=[use(none,in_hierarchy,'Demand_ratio',1)]],[course=[[ 243.14197, 376.51317],[ 215.28347, 401.1609],[ 184.28459, 442.60161]]]).
arc(arc00879,node00899,node00895,influence,[name=i33],[]).
arc(arc00880,node00897,node00899,influence,[complete=true,name=i34,role=[use(none,in_hierarchy,['Demand_data'],array(1,76))]],[course=[[ 174.65005, 454.06701],[ 144.60309, 485.96989],[ 112.49846, 519.83295]]]).
arc(arc01015,node01005,node01004,influence,[name=i6],[]).
arc(arc01212,node01028,node01005,influence,[complete=true,name=i79,role=[use(none,in_hierarchy,['Weighted_actual_yield'],array(1,304))]],[course=[[ 67.82728400000001, 255.09234],[ 23.946959, 249.23385],[ -44.927733, 252.3503]]]).
arc(arc01440,node01256,node00870,influence,[complete=true,name=i181,role=[use(none,in_hierarchy,usr('GFC_ini_abs'),1)]],[course=[[ 359.50007, 268.8432],[ 359.61439, 218.83394],[ 359.3331, 151.42552]]]).
arc(arc01429,node01257,node01256,influence,[name=i167],[]).
arc(arc01437,node01264,node01257,influence,[complete=true,name=i178,role=[use(none,in_hierarchy,['GFC_ini_abs'],array(1,58960))]],[course=[[ 366.8001, 143.76561],[ 514.84067, 140.60732],[ 645.29511, 143.70992]]]).
arc(arc01611,node01439,node01438,influence,[name=i179],[]).
arc(arc01614,node01442,node01439,influence,[complete=true,name=i182,role=[use(none,in_hierarchy,['Yield_2000_weighted'],array(1,304))]],[course=[[ 72.385727, 351.24682],[ 17.944931, 365.80882],[ -44.927733, 380.84725]]]).
arc(arc01619,node01446,node01439,influence,[complete=true,name=i187,role=[use(none,in_hierarchy,['GFC_surf_ini'],array(1,304))]],[course=[[ 72.237577, 348.04902],[ 17.003388, 338.63742],[ -44.927733, 334.94122]]]).
arc(arc01622,node01448,node01005,influence,[complete=true,name=i191,role=[use(none,in_hierarchy,['GFC_surf_ini'],array(1,304))]],[course=[[ 69.082279, 260.33568],[ 22.478255, 292.39651],[ -44.927733, 334.94122]]]).
arc(arc01623,node01450,node01449,influence,[name=i192],[]).
arc(arc01624,node01004,node01450,influence,[complete=true,name=i193,role=[use(none,in_hierarchy,'Actual_Yield',1)]],[course=[[ 156.64091, 258.37439],[ 134.8598, 256.55568],[ 82.76108600000001, 256.14411]]]).
arc(arc01625,node01438,node01450,influence,[complete=true,name=i194,role=[use(none,in_hierarchy,'Actual_yield_2000',1)]],[course=[[ 158.9431, 264.43009],[ 116.60007, 308.90041],[ 84.693589, 343.77526]]]).
arc(arc01629,node01453,node00894,influence,[complete=true,name=i198,role=[use(none,in_hierarchy,'Oversupply_ratio',1)]],[course=[[ 241.50777, 373.45878],[ 185.04782, 388.37188],[ 123.14379, 409.51891]]]).
arc(arc01627,node01454,node01453,influence,[name=i196],[]).
arc(arc01628,node01451,node01454,influence,[complete=true,name=i197,role=[use(none,in_hierarchy,['Oversupply_data'],array(1,76))]],[course=[[ 108.69814, 413.44404],[ 75.17541300000001, 420.28977],[ 34.288924, 434.27815]]]).
arc(arc01788,node01570,node00894,influence,[complete=true,name=i7,role=[use(none,in_hierarchy,'Productivity_ratio_2005',1)]],[course=[[ 245.45587, 364.81004],[ 229.71702, 332.72733],[ 207.49173, 312.16078]]]).
arc(arc01497,node01571,node01570,influence,[name=i15],[]).
arc(arc01787,node01449,node01571,influence,[complete=true,name=i5,role=[use(none,in_hierarchy,'Productivity_ratio_2000',1)]],[course=[[ 198.14417, 300.62617],[ 183.38274, 275.88542],[ 169.75522, 263.94182]]]).
arc(arc01786,node01572,node01571,influence,[complete=true,name=i4,role=[use(none,in_hierarchy,ratio_2005_2000,1)]],[course=[[ 206.0309, 300.75049],[ 228.77821, 265.22028],[ 244.47606, 223.01681]]]).
arc(arc01630,node01573,node01572,influence,[name=i1],[]).
arc(arc01785,node01449,node01573,influence,[complete=true,name=i3,role=[use(none,in_hierarchy,'Productivity_ratio_2000',1)]],[course=[[ 230.0554, 219.96648],[ 206.05386, 234.30701],[ 170.57796, 255.19335]]]).
arc(arc00416,node00849,node00369,influence,[complete=true,name=i62],[course=[[ 739.11697, 288.38894],[ 679.85294, 247.41944],[ 662.72195, 232.9945]]]).
arc(arc00461,node00505,node00849,influence,[complete=true,name=i97],[course=[[ 662.72195, 307.02216],[ 697.4178000000001, 307.26708],[ 739.11697, 310.09981]]]).
arc(arc00018,node00014,node00007,influence,[name=i2],[]).
arc(arc00035,node00027,node00026,influence,[name=i31],[]).
arc(arc00037,node00007,node00027,influence,[complete=true,name=i33,role=[use(none,in_hierarchy,surf_where_ch_apply_bis,1)]],[course=[[ 502.81443, 543.68738],[ 553.59673, 516.9432],[ 613.217, 493.12757]]]).
arc(arc00358,node00459,node00392,influence,[name=i51],[]).
arc(arc00686,node00861,node00014,influence,[complete=true,name=i58,role=[use(none,in_hierarchy,[modifiable_surface_bis],array(1,58960))]],[course=[[ 627.67234, 490.7235],[ 665.06686, 492.61105],[ 703.62913, 492.92453]]]).
arc(arc00888,node00910,node00909,influence,[name=i6],[]).
arc(arc00892,node00026,node00912,influence,[complete=true,name=i63],[course=[[ 703.62913, 541.50597],[ 605.87577, 544.10989],[ 502.97633, 542.3617]]]).
arc(arc00359,node00915,node00459,influence,[complete=true,name=i52,role=[use(none,in_hierarchy,'FC_surf_expected',1)]],[course=[[ 479.06425, 308.90826],[ 461.49567, 306.94901],[ 429.44085, 304.354]]]).
arc(arc00903,node00916,node00915,influence,[name=i10],[]).
arc(arc00362,node00918,node00459,influence,[complete=true,name=i54,role=[use(none,in_hierarchy,'Food_crops_abs_adjusted',1)]],[course=[[ 490.62297, 302.97195],[ 530.69571, 275.99663],[ 582.40579, 218.23568]]]).
arc(arc00905,node00919,node00918,influence,[name=i3],[]).
arc(arc00908,node00924,node00922,influence,[name=i29],[]).
arc(arc00457,node00474,node00926,influence,[complete=true,name=i96,role=[use(none,in_hierarchy,['FC_surface_abs_ite1'],array(1,58960))]],[course=[[ 618.32676, 426.60269],[ 660.3307600000001, 429.89543],[ 703.62913, 427.1568]]]).
arc(arc00909,node00926,node00921,influence,[name=i30],[]).
arc(arc00410,node00929,node00340,influence,[complete=true,name=i61],[course=[[ 703.62913, 350.38456],[ 678.72901, 347.85838],[ 618.6778399999999, 350.38625]]]).
arc(arc00386,node00392,node00930,influence,[complete=true,name=i55,role=[use(none,in_hierarchy,'Expected_change_0',1)]],[course=[[ 604.20182, 347.96445],[ 539.3633599999999, 322.54738],[ 493.41949, 312.29534]]]).
arc(arc00914,node00930,node00929,influence,[name=i53],[]).
arc(arc00916,node00922,node00930,influence,[complete=true,name=i49,role=[use(none,in_hierarchy,'Surface_where_changes_apply',1)]],[course=[[ 609.83044, 343.32493],[ 606.9047, 327.38559],[ 609.16751, 302.12594]]]).
arc(arc00036,node00935,node00027,influence,[complete=true,name=i32,role=[use(none,in_hierarchy,exp_change_bis,1)]],[course=[[ 488.56713, 539.21058],[ 448.97714, 485.10711],[ 426.20218, 447.28991]]]).
arc(arc00919,node00392,node00936,influence,[complete=true,name=i9,role=[use(none,in_hierarchy,usr('Expected_change'),1)]],[course=[[ 425.05825, 433.87775],[ 443.22438, 387.30308],[ 481.85938, 315.12098]]]).
arc(arc00920,node00922,node00936,influence,[complete=true,name=i11,role=[use(none,in_hierarchy,usr('Surface_where_changes_apply'),1)]],[course=[[ 428.20211, 436.19576],[ 584.54543, 311.81548],[ 602.94668, 297.61859]]]).
arc(arc00922,node00936,node00935,influence,[name=i12],[]).
arc(arc00923,node00929,node00936,influence,[complete=true,name=i13,role=[use(none,in_hierarchy,usr('Change_coefficient'),1)]],[course=[[ 429.10058, 437.63265],[ 513.5139, 397.31473],[ 604.41581, 353.93202]]]).
arc(arc00925,node00921,node00936,influence,[complete=true,name=i71,role=[use(none,in_hierarchy,usr('Temp_FC_surface'),1)]],[course=[[ 429.79796, 440.14194],[ 564.61208, 427.08274],[ 603.35169, 426.18945]]]).
arc(arc01221,node00938,node00916,influence,[complete=true,name=i16,role=[use(none,in_hierarchy,usr('Surface_change'),1)]],[course=[[ 415.21861, 307.02479],[ 380.96948, 323.6551],[ 290.4796, 362.62856]]]).
arc(arc00928,node00939,node00938,influence,[name=i2],[]).
arc(arc00929,node00940,node00939,influence,[complete=true,name=i14,role=[use(none,in_hierarchy,'Demand_ratio',1)]],[course=[[ 280.23142, 372.30061],[ 260.36298, 411.95169],[ 242.02946, 449.17855]]]).
arc(arc00931,node00944,node00940,influence,[name=i33_0],[]).
arc(arc00932,node00942,node00944,influence,[complete=true,name=i34_0,role=[use(none,in_hierarchy,['Demand_data'],array(1,76))]],[course=[[ 235.57703, 462.62492],[ 220.60477, 492.71281],[ 189.75719, 542.27315]]]).
arc(arc00984,node00987,node00910,influence,[complete=true,name=i57,role=[use(none,in_hierarchy,['Weighted_actual_yield'],array(1,304))]],[course=[[ 117.63504, 259.7185],[ 72.92013300000001, 260.61338],[ -9.000004199999999, 260.52082]]]).
arc(arc01076,node01009,node00919,influence,[complete=true,name=i168,role=[use(none,in_hierarchy,['FC_adjusted'],array(1,58960))]],[course=[[ 594.90799, 212.71856],[ 648.79806, 213.22716],[ 703.62913, 212.8514]]]).
arc(arc01238,node01068,node00924,influence,[complete=true,name=i174,role=[use(none,in_hierarchy,[modifiable_surface],array(1,58960))]],[course=[[ 617.28252, 295.55569],[ 668.26981, 298.01615],[ 703.62913, 293.71645]]]).
arc(arc01394,node01189,node00939,influence,[complete=true,name=i8,role=[use(none,in_hierarchy,oversupply_ratio,1)]],[course=[[ 276.11271, 366.16138],[ 258.77748, 377.16613],[ 161.02959, 405.86884]]]).
arc(arc01392,node01193,node01189,influence,[name=i5],[]).
arc(arc01393,node00566,node01193,influence,[complete=true,name=i7,role=[use(none,in_hierarchy,['Oversupply_data'],array(1,76))]],[course=[[ 146.73838, 410.41307],[ 121.46087, 419.07451],[ 72.89650399999999, 428.74043]]]).
arc(arc01428,node01249,node00916,influence,[complete=true,name=i166,role=[use(none,in_hierarchy,usr(food_crops_ini_abs),1)]],[course=[[ 422.178, 296.25183],[ 423.50607, 249.44041],[ 425.49885, 188.88445]]]).
arc(arc01421,node01250,node01249,influence,[name=i34],[]).
arc(arc01425,node01254,node01250,influence,[complete=true,name=i163,role=[use(none,in_hierarchy,[food_crops_ini_abs],array(1,58960))]],[course=[[ 433.24529, 181.32976],[ 574.13383, 180.22604],[ 703.62913, 182.81063]]]).
arc(arc01116,node01288,node01241,influence,[name=i28],[]).
arc(arc01481,node01319,node01288,influence,[complete=true,name=i35,role=[use(none,in_hierarchy,[yield_2000_weighted],array(1,304))]],[course=[[ 117.83823, 343.26296],[ 70.26528500000001, 354.66763],[ -9.000004199999999, 376.24622]]]).
arc(arc01494,node01328,node01288,influence,[complete=true,name=i62,role=[use(none,in_hierarchy,['FC_surf_ini'],array(1,304))]],[course=[[ 117.72184, 340.35445],[ 58.369127, 331.06211],[ -9.000004199999999, 324.47561]]]).
arc(arc01495,node01332,node01331,influence,[name=i64],[]).
arc(arc01496,node00909,node01332,influence,[complete=true,name=i65,role=[use(none,in_hierarchy,'Actual_Yield',1)]],[course=[[ 201.45508, 258.20466],[ 168.87119, 261.07626],[ 132.62921, 260.13547]]]).
arc(arc01498,node01241,node01332,influence,[complete=true,name=i67,role=[use(none,in_hierarchy,'Actual_yield_2000',1)]],[course=[[ 202.84216, 266.6835],[ 169.86138, 298.79463],[ 130.55534, 336.33449]]]).
arc(arc01518,node01351,node00910,influence,[complete=true,name=i214,role=[use(none,in_hierarchy,['FC_surf_ini'],array(1,304))]],[course=[[ 118.498, 263.43991],[ 78.028514, 287.84882],[ -9.000004199999999, 324.47561]]]).
arc(arc01767,node01402,node01401,influence,[name=i1],[]).
arc(arc01768,node01331,node01402,influence,[complete=true,name=i4,role=[use(none,in_hierarchy,'Productivity_ratio_2000',1)]],[course=[[ 307.55504, 218.42932],[ 274.41486, 237.25331],[ 215.25998, 258.87662]]]).
arc(arc01771,node01403,node00939,influence,[complete=true,name=i18,role=[use(none,in_hierarchy,'Productivity_ratio_2005',1)]],[course=[[ 279.94866, 359.03932],[ 270.33387, 341.7348],[ 251.47264, 311.61605]]]).
arc(arc01769,node01565,node01403,influence,[name=i15],[]).
arc(arc01770,node01331,node01565,influence,[complete=true,name=i17,role=[use(none,in_hierarchy,'Productivity_ratio_2000',1)]],[course=[[ 243.09954, 299.18043],[ 227.27699, 277.28226],[ 213.98546, 266.24333]]]).
arc(arc01772,node01401,node01565,influence,[complete=true,name=i19,role=[use(none,in_hierarchy,ratio_2005_2000,1)]],[course=[[ 252.47685, 299.65587],[ 289.96817, 257.50988],[ 316.37752, 222.0691]]]).
arc(arc00954,node00855,node00848,influence,[complete=true,name=i10],[course=[[ 665.09858, 838.1421],[ 716.78901, 835.95895],[ 739.11697, 838.12056]]]).
arc(arc00955,node00848,node00856,influence,[complete=true,name=i14],[course=[[ 739.11697, 772.0700000000001],[ 695.29328, 771.22944],[ 665.09858, 771.66216]]]).
arc(arc00958,node00859,node00848,influence,[complete=true,name=i12],[course=[[ 665.09858, 709.01737],[ 698.98586, 709.22705],[ 739.11697, 708.16341]]]).
arc(arc00069,node00055,node00860,influence,[complete=true,name=i22],[course=[[ 667.19485, 1463.0754],[ 717.66911, 1456.1857],[ 739.11697, 1450.2121]]]).
arc(arc00075,node00860,node00059,influence,[complete=true,name=i29],[course=[[ 739.11697, 1515.9195],[ 684.1286, 1526.0455],[ 649.2095399999999, 1536.0508]]]).
arc(arc00394,node00375,node00860,influence,[complete=true,name=i16],[course=[[ 667.19485, 1194.6763],[ 717.5850799999999, 1183.5658],[ 739.11697, 1176.5511]]]).
arc(arc00065,node00051,node00050,influence,[name=i17],[]).
arc(arc00068,node00054,node00051,influence,[complete=true,name=i21,role=[use(none,in_hierarchy,[modifiable_surface_bis],array(1,58960))]],[course=[[ 558.57736, 379.90417],[ 606.6240299999999, 381.32602],[ 634.08879, 379.62841]]]).
arc(arc00071,node00057,node00056,influence,[name=i24],[]).
arc(arc00072,node00050,node00057,influence,[complete=true,name=i25,role=[use(none,in_hierarchy,surf_where_ch_apply_bis,1)]],[course=[[ 433.52342, 396.74609],[ 486.61981, 392.73639],[ 543.72986, 381.17094]]]).
arc(arc00074,node00056,node00058,influence,[complete=true,name=i27],[course=[[ 616.10348, 452.60382],[ 500.1022, 409.42292],[ 433.44638, 398.52139]]]).
arc(arc00391,node00371,node00370,influence,[name=i106],[]).
arc(arc00392,node00374,node00371,influence,[complete=true,name=i14,role=[use(none,in_hierarchy,['PC_adjusted'],array(1,58960))]],[course=[[ 492.24698, 111.01113],[ 574.7563699999999, 111.60177],[ 634.08879, 111.22932]]]).
arc(arc00959,node00962,node00961,influence,[name=i10],[]).
arc(arc00962,node00968,node00966,influence,[name=i29],[]).
arc(arc00963,node00969,node00965,influence,[name=i30],[]).
arc(arc00398,node00370,node00971,influence,[complete=true,name=i113,role=[use(none,in_hierarchy,'PC_abs_adjusted',1)]],[course=[[ 436.45264, 186.76453],[ 464.07173, 148.47774],[ 481.1275, 117.52615]]]).
arc(arc00964,node00971,node00970,influence,[name=i46],[]).
arc(arc00965,node00961,node00971,influence,[complete=true,name=i41,role=[use(none,in_hierarchy,usr('PC_surf_expected'),1)]],[course=[[ 424.56522, 192.92162],[ 404.36377, 193.12243],[ 357.10692, 197.32919]]]).
arc(arc00967,node00972,node00967,influence,[complete=true,name=i13],[course=[[ 634.08879, 232.58102],[ 596.74875, 230.97154],[ 547.41998, 231.73652]]]).
arc(arc00968,node00973,node00972,influence,[name=i53],[]).
arc(arc00969,node00970,node00973,influence,[complete=true,name=i48,role=[use(none,in_hierarchy,'Expected_change_abs',1)]],[course=[[ 532.99635, 228.97169],[ 485.72925, 209.30507],[ 439.23522, 195.0461]]]).
arc(arc00970,node00966,node00973,influence,[complete=true,name=i49,role=[use(none,in_hierarchy,'Surface_where_changes_apply',1)]],[course=[[ 540.54158, 224.37854],[ 542.42619, 201.6845],[ 540.42961, 179.04357]]]).
arc(arc00073,node00976,node00057,influence,[complete=true,name=i26,role=[use(none,in_hierarchy,exp_change_bis,1)]],[course=[[ 420.01814, 392.84651],[ 393.97501, 373.55438],[ 385.28059, 361.32886]]]).
arc(arc00869,node00970,node00977,influence,[complete=true,name=i4,role=[use(none,in_hierarchy,usr('Expected_change_abs'),1)]],[course=[[ 383.51518, 348.17505],[ 408.55614, 279.86186],[ 430.10871, 200.08748]]]).
arc(arc00870,node00972,node00977,influence,[complete=true,name=i5,role=[use(none,in_hierarchy,usr('Change_coefficient'),1)]],[course=[[ 386.67727, 350.39359],[ 445.27097, 301.18649],[ 533.8705200000001, 236.28487]]]).
arc(arc00872,node00966,node00977,influence,[complete=true,name=i7,role=[use(none,in_hierarchy,usr('Surface_where_changes_apply'),1)]],[course=[[ 385.78331, 349.49555],[ 456.81534, 265.69192],[ 534.81168, 177.19905]]]).
arc(arc00974,node00977,node00976,influence,[name=i12],[]).
arc(arc00977,node00965,node00977,influence,[complete=true,name=i71,role=[use(none,in_hierarchy,usr('Temp_PC_surface'),1)]],[course=[[ 388.17593, 353.26665],[ 468.32288, 331.68376],[ 545.6563, 312.76356]]]).
arc(arc01001,node00980,node00968,influence,[complete=true,name=i22,role=[use(none,in_hierarchy,[modifiable_surface],array(1,58960))]],[course=[[ 547.2686, 171.75324],[ 590.71566, 172.80024],[ 634.08879, 171.41662]]]).
arc(arc01003,node00982,node00969,influence,[complete=true,name=i35,role=[use(none,in_hierarchy,['PC_surface_abs_ite1'],array(1,58960))]],[course=[[ 560.44041, 311.10537],[ 582.88016, 311.47697],[ 634.08879, 310.18162]]]).
arc(arc01211,node00984,node00962,influence,[complete=true,name=i16,role=[use(none,in_hierarchy,usr('Surface_change'),1)]],[course=[[ 344.34591, 203.31022],[ 315.91406, 231.8789],[ 248.5481, 274.50619]]]).
arc(arc00979,node00985,node00984,influence,[name=i2],[]).
arc(arc00980,node00986,node00985,influence,[complete=true,name=i14_0,role=[use(none,in_hierarchy,'Demand_ratio',1)]],[course=[[ 236.27967, 283.10751],[ 205.29243, 307.09483],[ 163.54067, 343.80401]]]).
arc(arc00982,node00990,node00986,influence,[name=i33],[]).
arc(arc00983,node00988,node00990,influence,[complete=true,name=i34,role=[use(none,in_hierarchy,['Demand_data'],array(1,76))]],[course=[[ 152.31989, 353.7584],[ 121.61528, 381.2426],[ 79.29252700000001, 410.93893]]]).
arc(arc01025,node01011,node01006,influence,[name=i6],[]).
arc(arc01232,node01058,node01011,influence,[complete=true,name=i85,role=[use(none,in_hierarchy,['Weighted_actual_yield'],array(1,304))]],[course=[[ 55.559864, 147.54494],[ 23.280958, 147.6636],[ -53.517313, 147.56234]]]).
arc(arc01449,node01266,node00962,influence,[complete=true,name=i190,role=[use(none,in_hierarchy,usr('PC_ini_abs'),1)]],[course=[[ 349.56059, 190.49458],[ 348.86215, 121.45816],[ 351.19691, 57.419629]]]).
arc(arc01441,node01267,node01266,influence,[name=i182],[]).
arc(arc01446,node01273,node01267,influence,[complete=true,name=i187,role=[use(none,in_hierarchy,['PC_ini_abs'],array(1,58960))]],[course=[[ 358.96998, 49.978366],[ 510.39766, 51.06379],[ 632.47283, 49.47262]]]).
arc(arc01658,node01480,node01479,influence,[name=i177],[]).
arc(arc01661,node01483,node01480,influence,[complete=true,name=i180,role=[use(none,in_hierarchy,['Yield_2000_weighted'],array(1,304))]],[course=[[ 52.068965, 241.35183],[ 5.8898314, 265.9269],[ -53.517313, 302.55031]]]).
arc(arc01666,node01487,node01480,influence,[complete=true,name=i186,role=[use(none,in_hierarchy,['PC_surf_ini'],array(1,304))]],[course=[[ 51.200834, 237.42196],[ 11.283919, 235.2555],[ -53.517313, 236.37778]]]).
arc(arc01669,node01489,node01011,influence,[complete=true,name=i189,role=[use(none,in_hierarchy,['PC_surf_ini'],array(1,304))]],[course=[[ 57.250263, 152.26069],[ 7.3000262, 193.04357],[ -53.517313, 236.37778]]]).
arc(arc01670,node01491,node01490,influence,[name=i192],[]).
arc(arc01671,node01006,node01491,influence,[complete=true,name=i191,role=[use(none,in_hierarchy,'Actual_Yield',1)]],[course=[[ 136.58093, 186.18433],[ 100.2754, 166.49352],[ 69.741355, 150.92428]]]).
arc(arc01672,node01479,node01491,influence,[complete=true,name=i193,role=[use(none,in_hierarchy,'Actual_yield_2000',1)]],[course=[[ 137.14157, 194.21684],[ 111.16178, 213.41203],[ 65.489684, 234.66428]]]).
arc(arc01677,node01494,node00985,influence,[complete=true,name=i198,role=[use(none,in_hierarchy,'Oversupply_ratio',1)]],[course=[[ 234.93413, 280.33495],[ 190.88773, 291.34265],[ 112.71015, 303.66514]]]).
arc(arc01675,node01495,node01494,influence,[name=i196],[]).
arc(arc01676,node01492,node01495,influence,[complete=true,name=i197,role=[use(none,in_hierarchy,['Oversupply_data'],array(1,76))]],[course=[[ 97.935784, 306.24521],[ 58.19279, 315.01281],[ 17.66043, 329.91982]]]).
arc(arc01789,node01575,node01574,influence,[name=i1],[]).
arc(arc01793,node01490,node01575,influence,[complete=true,name=i11,role=[use(none,in_hierarchy,'Productivity_ratio_2000',1)]],[course=[[ 223.68039, 142.97575],[ 192.83359, 165.17577],[ 149.89515, 186.43253]]]).
arc(arc01792,node01576,node00985,influence,[complete=true,name=i9,role=[use(none,in_hierarchy,'Productivity_ratio_2005',1)]],[course=[[ 237.47374, 272.70152],[ 219.40497, 250.51896],[ 198.09275, 229.92986]]]).
arc(arc01790,node01586,node01576,influence,[name=i15],[]).
arc(arc01791,node01490,node01586,influence,[complete=true,name=i8,role=[use(none,in_hierarchy,'Productivity_ratio_2000',1)]],[course=[[ 186.46984, 220.54143],[ 165.77365, 206.66151],[ 149.17987, 194.25176]]]).
arc(arc01794,node01574,node01586,influence,[complete=true,name=i18,role=[use(none,in_hierarchy,ratio_2005_2000,1)]],[course=[[ 196.55106, 218.28383],[ 220.03071, 179.06284],[ 236.65306, 143.58201]]]).
arc(arc01007,node00860,node00863,influence,[complete=true,name=i15],[course=[[ 739.11697, 1303.0607],[ 713.5122, 1307.5861],[ 667.19485, 1316.028]]]).
arc(arc01009,node00865,node00860,influence,[complete=true,name=i23],[course=[[ 667.19485, 1254.8636],[ 741.48043, 1233.4612],[ 739.11697, 1232.1811]]]).
arc(arc01011,node00867,node00860,influence,[complete=true,name=i36],[course=[[ 667.19485, 1393.6286],[ 703.63778, 1386.8836],[ 739.11697, 1382.0946]]]).
arc(arc00851,node00911,node00849,influence,[complete=true,name=i59],[course=[[ 662.72195, 370.43872],[ 700.32917, 370.32539],[ 739.11697, 372.79987]]]).
arc(arc00907,node00849,node00913,influence,[complete=true,name=i65],[course=[[ 739.11697, 417.0678],[ 694.91769, 415.55628],[ 662.72195, 417.2834]]]).
arc(arc00985,node00989,node00849,influence,[complete=true,name=i58],[course=[[ -24.430994, 146.34335],[ -47.25316, 145.90925],[ -82.190344, 145.22247]]]).
arc(arc01112,node01022,node00849,influence,[complete=true,name=i169],[course=[[ 662.72195, 100.37809],[ 733.44706, 99.264054],[ 739.11697, 100.7378]]]).
arc(arc01218,node01042,node00848,influence,[complete=true,name=i80],[course=[[ -28.393018, 686.82463],[ -56.477184, 685.12096],[ -82.190344, 687.01005]]]).
arc(arc01233,node01061,node00860,influence,[complete=true,name=i86],[course=[[ -20.411253, 1231.0094],[ -40.125343, 1229.6048],[ -82.190344, 1229.2291]]]).
arc(arc01239,node01072,node00849,influence,[complete=true,name=i175],[course=[[ 662.72195, 178.35225],[ 713.5663500000001, 180.7163],[ 739.11697, 179.84167]]]).
arc(arc01342,node01176,node00320,influence,[complete=true,name=i161],[course=[[ 662.3731, 2250.4997],[ 698.64847, 2249.6211],[ 739.11697, 2251.1559]]]).
arc(arc01355,node01188,node00320,influence,[complete=true,name=i178],[course=[[ 662.3731, 1945.2153],[ 702.00311, 1943.6898],[ 739.11697, 1944.5777]]]).
arc(arc01426,node01255,node00849,influence,[complete=true,name=i164],[course=[[ 662.72195, 71.411269],[ 694.59163, 70.108452],[ 738.30768, 71.798095]]]).
arc(arc01438,node01265,node00848,influence,[complete=true,name=i179],[course=[[ 661.82983, 578.18425],[ 700.41563, 579.69443],[ 739.11697, 578.11428]]]).
arc(arc01447,node01274,node00860,influence,[complete=true,name=i188],[course=[[ 665.57889, 1132.9196],[ 702.6616, 1124.1683],[ 739.11697, 1113.5841]]]).
arc(arc01482,node01327,node00849,influence,[complete=true,name=i38],[course=[[ -24.430994, 257.93161],[ -42.655066, 257.97824],[ -82.190344, 257.77218]]]).
arc(arc01519,node01352,node00849,influence,[complete=true,name=i215],[course=[[ -24.430994, 208.01178],[ -46.520863, 208.7026],[ -82.190344, 209.14072]]]).
arc(arc01615,node01443,node00848,influence,[complete=true,name=i183],[course=[[ -28.393018, 815.32158],[ -53.12752, 813.10915],[ -82.190344, 814.48948]]]).
arc(arc01620,node01447,node00848,influence,[complete=true,name=i189],[course=[[ -28.393018, 769.4155500000001],[ -48.989506, 766.58188],[ -82.190344, 767.34096]]]).
arc(arc01662,node01484,node00860,influence,[complete=true,name=i181],[course=[[ -20.411253, 1385.9973],[ -56.003908, 1385.0717],[ -82.190344, 1385.1751]]]).
arc(arc01667,node01488,node00860,influence,[complete=true,name=i187],[course=[[ -20.411253, 1319.8248],[ -46.079411, 1328.1204],[ -82.190344, 1337.4449]]]).
arc(arc00055,node00846,node00845,influence,[complete=true,name=i34],[course=[[ 389.47405, 756.51716],[ 524.50345, 755.14908],[ 571.31463, 756.95507]]]).
arc(arc00061,node00845,node00846,influence,[complete=true,name=i41],[course=[[ 571.31463, 812.52176],[ 494.44553, 812.73572],[ 389.47405, 814.43855]]]).
arc(arc00070,node00846,node00845,influence,[complete=true,name=i23],[course=[[ 389.47405, 1262.2103],[ 475.03503, 1256.0177],[ 571.3146400000001, 1255.7652]]]).
arc(arc00078,node00845,node00846,influence,[complete=true,name=i32],[course=[[ 571.31463, 1324.7223],[ 437.4203, 1324.2587],[ 389.47405, 1326.0049]]]).
arc(arc00097,node00846,node00845,influence,[complete=true,name=i10],[course=[[ 389.47405, 1523.9059],[ 496.86846, 1526.7735],[ 571.31463, 1531.9155]]]).
arc(arc00114,node00845,node00846,influence,[complete=true,name=i26],[course=[[ 571.31463, 1569.2853],[ 504.50558, 1570.7085],[ 389.47405, 1570.406]]]).
arc(arc00120,node00846,node00845,influence,[complete=true,name=i42],[course=[[ 389.47405, 1627.5188],[ 476.38898, 1626.4832],[ 571.31463, 1626.7861]]]).
arc(arc00126,node00846,node00845,influence,[complete=true,name=i49],[course=[[ 389.47405, 1683.5787],[ 484.83507, 1701.3026],[ 571.31463, 1714.9104]]]).
arc(arc00148,node00846,node00077,influence,[complete=true,name=i15],[course=[[ 303.66648, 2779.0304],[ 425.82821, 2794.788],[ 571.31463, 2814.3455]]]).
arc(arc00149,node00846,node00077,relation,[complete=true,name=link],[course=[[ 295.60083, 2722.9319],[ 513.3477, 2723.016],[ 571.31463, 2724.2272]]]).
arc(arc00151,node00845,node00846,influence,[complete=true,name=i57,use_sofar=0],[course=[[ 571.31463, 1807.0143],[ 467.92561, 1765.9832],[ 389.47405, 1732.449]]]).
arc(arc00163,node00846,node00176,influence,[complete=true,name=i103,role=[use(none,in_hierarchy,usr([rent_grass]),array(1,58960))]],[course=[[ 499.77754, 834.59857],[ 565.04813, 861.52441],[ 571.31463, 866.28005]]]).
arc(arc00166,node00846,node00845,influence,[complete=true,name=i69],[course=[[ 389.47405, 1774.6157],[ 489.46702, 1809.4501],[ 571.31463, 1836.5853]]]).
arc(arc00193,node00845,node00846,influence,[complete=true,name=i74],[course=[[ 571.31463, 1864.6817],[ 489.01168, 1862.6415],[ 389.47405, 1863.5964]]]).
arc(arc00199,node00846,node00845,influence,[complete=true,name=i79],[course=[[ 389.47405, 1905.7405],[ 485.11801, 1930.4303],[ 571.31463, 1956.4586]]]).
arc(arc00211,node00175,node00846,influence,[complete=true,name=i12],[course=[[ 571.31463, 866.89996],[ 531.6011999999999, 844.92852],[ 499.94439, 834.15479]]]).
arc(arc00228,node00211,node00846,influence,[complete=true,name=i9],[course=[[ 571.31463, 652.52814],[ 544.12676, 656.70573],[ 511.53343, 653.3988900000001]]]).
arc(arc00274,node00846,node00845,influence,[complete=true,name=i46],[course=[[ 389.47405, 472.92774],[ 514.63476, 481.99238],[ 571.31463, 491.88038]]]).
arc(arc00279,node00846,node00845,influence,[complete=true,name=i97],[course=[[ 389.47405, 1971.2559],[ 482.8316, 2003.5707],[ 571.31463, 2035.9004]]]).
arc(arc00284,node00845,node00846,influence,[complete=true,name=i106],[course=[[ 571.31463, 2131.2075],[ 480.68605, 2077.7639],[ 389.47405, 2019.5846]]]).
arc(arc00290,node00846,node00845,influence,[complete=true,name=i114,use_sofar=0],[course=[[ 389.47405, 2080.5599],[ 472.25754, 2108.6023],[ 571.31463, 2149.8283]]]).
arc(arc00298,node00845,node00846,influence,[complete=true,name=i121],[course=[[ 571.31463, 2161.7015],[ 487.8633, 2162.6282],[ 389.47405, 2162.2167]]]).
arc(arc00304,node00846,node00845,influence,[complete=true,name=i127],[course=[[ 389.47405, 2305.283],[ 485.04933, 2338.5317],[ 571.3146400000001, 2365.9532]]]).
arc(arc00309,node00846,node00845,influence,[complete=true,name=i134],[course=[[ 389.47405, 2252.2548],[ 492.82473, 2272.0624],[ 571.31463, 2286.4305]]]).
arc(arc00347,node00206,node00846,influence,[complete=true,name=i45],[course=[[ 571.31463, 138.3397],[ 530.78181, 127.0586],[ 520.92234, 125.07959]]]).
arc(arc00356,node00121,node00846,influence,[complete=true,name=i53],[course=[[ 571.31463, 345.2294],[ 528.45065, 324.47644],[ 496.17127, 304.85503]]]).
arc(arc00380,node00845,node00846,influence,[complete=true,name=i141],[course=[[ 571.31463, 2449.455],[ 495.29409, 2420.5579],[ 389.47405, 2382.6087]]]).
arc(arc00393,node00846,node00122,influence,[complete=true,name=i54,role=[use(none,in_hierarchy,[rent_crop_2000_2030],array(1,58960))]],[course=[[ 496.4413, 304.3949],[ 542.63848, 328.57674],[ 571.3146400000001, 344.65344]]]).
arc(arc00395,node00846,node00845,influence,[complete=true,name=i21],[course=[[ 389.47405, 996.51627],[ 488.48132, 996.49761],[ 571.31463, 997.30234]]]).
arc(arc00436,node00845,node00846,influence,[complete=true,name=i67],[course=[[ 571.31463, 137.47496],[ 485.76612, 135.2839],[ 389.47405, 134.21059]]]).
arc(arc00478,node00757,node00846,influence,[complete=true,name=i48],[course=[[ 1138.6161, -961.36654],[ 1150.2266, -990.08722],[ 1180.5933, -1024.0938]]]).
arc(arc00489,node00846,node00845,influence,[complete=true,name=i98],[course=[[ 389.47405, 155.28941],[ 484.63969, 152.31986],[ 571.3146400000001, 153.88941]]]).
arc(arc00547,node00846,node00077,influence,[complete=true,name=i149],[course=[[ 303.66648, 3004.8087],[ 493.49352, 3183.1342],[ 571.31463, 3262.2575]]]).
arc(arc00562,node00763,node00846,influence,[complete=true,name=i109],[course=[[ 1183.2121, -961.36654],[ 1208.2081, -992.65002],[ 1250.5798, -1028.1426]]]).
arc(arc00569,node00764,node00846,influence,[complete=true,name=i117],[course=[[ 1227.6228, -961.36654],[ 1268.9698, -992.42842],[ 1326.9025, -1025.8447]]]).
arc(arc00573,node00765,node00846,influence,[complete=true,name=i123],[course=[[ 1271.1777, -961.36654],[ 1329.3003, -993.9072200000001],[ 1405.1099, -1025.9333]]]).
arc(arc00577,node00829,node00846,influence,[complete=true,name=i128],[course=[[ 891.19227, -961.36654],[ 842.33233, -988.7872599999999],[ 812.3359, -1033.0798]]]).
arc(arc00581,node00830,node00846,influence,[complete=true,name=i133],[course=[[ 952.5314, -961.36654],[ 918.19201, -988.7436],[ 899.7592, -1030.1973]]]).
arc(arc00585,node00831,node00846,influence,[complete=true,name=i139],[course=[[ 1012.6367, -961.36654],[ 993.99842, -990.70611],[ 986.56349, -1030.5523]]]).
arc(arc00589,node00832,node00846,influence,[complete=true,name=i143],[course=[[ 1068.8464, -961.36654],[ 1062.0882, -991.37443],[ 1066.3296, -1032.7565]]]).
arc(arc00609,node00367,node00846,influence,[complete=true,name=i47],[course=[[ 683.09729, -902.9629200000001],[ 1065.4652, -914.81867],[ 219.04549, -1026.3955]]]).
arc(arc00627,node00846,node00077,influence,[complete=true,name=i162],[course=[[ 303.66648, 2846.6441],[ 476.19373, 2799.5072],[ 571.31463, 2767.0681]]]).
arc(arc00741,node00846,node00077,influence,[complete=true,name=i193],[course=[[ 303.66648, 2946.0193],[ 531.80282, 2959.3457],[ 571.31463, 2959.2421]]]).
arc(arc00750,node00846,node00077,influence,[complete=true,name=i202],[course=[[ 303.66648, 2894.6993],[ 434.22292, 2893.7196],[ 571.31463, 2894.755]]]).
arc(arc00776,node00727,node00846,influence,[complete=true,name=i31],[course=[[ 580.31519, -807.25117],[ 538.27976, -807.4298199999999],[ 508.74976, -806.6206]]]).
arc(arc00790,node00077,node00846,influence,[complete=true,name=i218],[course=[[ 571.31463, 3058.6177],[ 522.17105, 3082.6868],[ 303.66648, 3211.8003]]]).
arc(arc00890,node00173,node00846,influence,[complete=true,name=i119],[course=[[ 571.31463, 1365.4681],[ 539.15592, 1367.6879],[ 515.05219, 1367.5783]]]).
arc(arc00891,node00846,node00845,influence,[complete=true,name=i60],[course=[[ 389.47405, 216.16412],[ 493.12051, 216.65774],[ 571.3146400000001, 216.0336]]]).
arc(arc00944,node00234,node00846,influence,[complete=true,name=i145],[course=[[ 571.31463, 1160.3337],[ 544.88649, 1156.3906],[ 518.40592, 1156.8396]]]).
arc(arc00945,node00845,node00846,influence,[complete=true,name=i110],[course=[[ 571.31463, 258.30724],[ 482.80226, 258.1664],[ 389.47405, 259.14331]]]).
arc(arc00973,node00846,node00077,influence,[complete=true,name=i36],[course=[[ 303.66648, 2846.5148],[ 440.38361, 2863.2418],[ 571.31463, 2892.5158]]]).
arc(arc01017,node00846,node00845,influence,[complete=true,name=i11],[course=[[ 389.47405, 667.93822],[ 494.48932, 672.14642],[ 571.31463, 676.45228]]]).
arc(arc01018,node00845,node00846,influence,[complete=true,name=i17],[course=[[ 571.31463, 612.84297],[ 455.59736, 610.90907],[ 389.47405, 603.81055]]]).
arc(arc01024,node00846,node00845,influence,[complete=true,name=i13],[course=[[ 389.47405, 541.7644299999999],[ 499.91902, 543.18226],[ 571.31463, 544.69775]]]).
arc(arc01026,node00846,node00845,influence,[complete=true,name=i24],[course=[[ 389.47405, 1050.5268],[ 486.02805, 1049.6897],[ 571.31463, 1050.6951]]]).
arc(arc01028,node00846,node00845,influence,[complete=true,name=i37],[course=[[ 389.47405, 1196.0759],[ 576.46502, 1195.8745],[ 571.31463, 1195.7707]]]).
arc(arc01029,node00845,node00846,influence,[complete=true,name=i18],[course=[[ 571.31463, 1119.3749],[ 508.45895, 1119.003],[ 389.47405, 1119.3429]]]).
arc(arc01030,node00817,node00846,influence,[complete=true,name=i138],[course=[[ 571.31463, -597.49808],[ -3.0911811, -536.82381],[ -532.85204, -481.90443]]]).
arc(arc01049,node00846,node00817,influence,[complete=true,name=i142],[course=[[ -532.85203, -614.6304699999999],[ -426.42185, -599.02377],[ 571.31463, -526.14367]]]).
arc(arc01096,node00846,node00817,relation,[complete=true,name='Link'],[course=[[ -536.56212, -808.29588],[ 90.91081, -860.29722],[ 621.02378, -882.77904]]]).
arc(arc01106,node00846,node00817,influence,[complete=true,name=i30],[course=[[ -532.85203, -677.98005],[ 57.285332, -677.47848],[ 571.3146400000001, -677.06058]]]).
arc(arc01122,node00817,node00846,influence,[complete=true,name=i153],[course=[[ 571.31463, -645.6813],[ 15.150086, -647.08097],[ -532.85204, -643.3264]]]).
arc(arc01130,node00846,node00817,influence,[complete=true,name=i159],[course=[[ -532.85203, -735.69846],[ -338.14156, -734.24767],[ 571.31463, -732.09199]]]).
arc(arc01143,node00077,node00846,influence,[complete=true,name=i260],[course=[[ 571.31463, 3156.7006],[ 413.6686, 3232.0217],[ 303.66644, 3288.9643]]]).
arc(arc01148,node00846,node00845,influence,[complete=true,name=i170],[course=[[ 389.47405, -47.977588],[ 474.56236, -44.021136],[ 571.31463, -46.839345]]]).
arc(arc01184,node00846,node00845,influence,[complete=true,name=i104],[course=[[ 389.47405, 2417.2444],[ 491.88759, 2446.2065],[ 571.3146400000001, 2468.394]]]).
arc(arc01240,node00846,node00845,influence,[complete=true,name=i176],[course=[[ 389.47405, 28.823379],[ 495.58935, 30.603544],[ 571.31463, 31.265897]]]).
arc(arc01266,node00846,node00186,influence,[complete=true,name=i151,role=[use(none,in_hierarchy,[rent_pcrops_2000_2030],array(1,58960))]],[course=[[ 515.04209, 1367.1535],[ 551.41386, 1365.2562],[ 571.31463, 1368.6188]]]).
arc(arc01343,node00846,node00845,influence,[complete=true,name=i163],[course=[[ 389.47405, 2039.8369],[ 475.38803, 2039.9246],[ 571.3146400000001, 2038.8946]]]).
arc(arc01356,node00846,node00845,influence,[complete=true,name=i179],[course=[[ 389.47405, 1742.1838],[ 470.78515, 1742.9697],[ 571.31463, 1742.6379]]]).
arc(arc01381,node00846,node00077,influence,[complete=true,name=i25],[course=[[ 303.66648, 2813.408],[ 459.67204, 2743.5476],[ 571.3146400000001, 2669.2635]]]).
arc(arc01427,node00846,node00845,influence,[complete=true,name=i165],[course=[[ 388.68832, -76.074792],[ 468.4523, -74.84854900000001],[ 571.31463, -75.132927]]]).
arc(arc01439,node00846,node00845,influence,[complete=true,name=i180],[course=[[ 389.47405, 415.50134],[ 488.74051, 416.92685],[ 571.3146400000001, 417.23459]]]).
arc(arc01448,node00846,node00845,influence,[complete=true,name=i189],[course=[[ 389.47405, 935.3823599999999],[ 484.00394, 933.14786],[ 571.3146400000001, 935.4524699999999]]]).
arc(arc01470,node00846,node00817,influence,[complete=true,name=i175],[course=[[ -532.85203, 229.11285],[ 61.303744, 421.36318],[ 571.31463, 60.82307]]]).
arc(arc01476,node00846,node00817,relation,[complete=true,name=link2],[course=[[ -532.85204, 346.68434],[ -16.78815, 350.24073],[ 571.31463, 349.72138]]]).
arc(arc01489,node00846,node00817,influence,[complete=true,name=i185],[course=[[ -532.85203, 177.80206],[ 183.8659, 124.92807],[ 571.31463, -480.73636]]]).
arc(arc01557,node00846,node00122,influence,[complete=true,name=i62,role=[use(none,in_hierarchy,[rent_crop_2031_2060],array(1,58960))]],[course=[[ 496.02134, 305.0817],[ 539.93934, 334.31669],[ 571.31463, 344.67378]]]).
arc(arc01590,node00846,node00817,relation,[complete=true,name='link 3'],[course=[[ -532.85203, 881.00817],[ 33.1381, 880.54853],[ 571.31463, 881.67]]]).
arc(arc01599,node00846,node00817,influence,[complete=true,name=i167],[course=[[ -532.85203, 701.28971],[ 59.01123, 898.1250700000001],[ 571.31463, 542.16999]]]).
arc(arc01637,node00846,node00817,relation,[complete=true,name='link 4'],[course=[[ -534.79418, 1413.9152],[ -32.534307, 1413.276],[ 571.31463, 1414.2179]]]).
arc(arc01649,node00846,node00817,influence,[complete=true,name=i168],[course=[[ -532.85203, 1279.7887],[ 67.391164, 1459.8642],[ 571.31463, 1087.1493]]]).
arc(arc01681,node00817,node00846,influence,[complete=true,name=i181],[course=[[ 571.31463, 297.89425],[ 104.40071, -148.83979],[ -532.85203, -42.783395]]]).
arc(arc01800,node00846,node00122,influence,[complete=true,name=i71,role=[use(none,in_hierarchy,[rent_crop_2060_2080],array(1,58960))]],[course=[[ 496.43868, 304.39974],[ 542.81935, 328.72335],[ 571.31463, 344.82063]]]).
arc(arc01808,node00846,node00176,influence,[complete=true,name=i80,role=[use(none,in_hierarchy,[rent_grass_2031_2060],array(1,58960))]],[course=[[ 499.78394, 834.58298],[ 541.73402, 851.77831],[ 571.31463, 865.86252]]]).
arc(arc01812,node00846,node00176,influence,[complete=true,name=i84,role=[use(none,in_hierarchy,[rent_grass_2061_2080],array(1,58960))]],[course=[[ 499.74229, 834.68256],[ 538.89314, 851.39259],[ 571.31463, 865.08635]]]).
arc(arc01820,node00846,node00186,influence,[complete=true,name=i92,role=[use(none,in_hierarchy,[rent_pcrops_2031_2060],array(1,58960))]],[course=[[ 515.04754, 1367.2779],[ 540.76563, 1366.3644],[ 571.31463, 1366.9637]]]).
arc(arc01824,node00846,node00186,influence,[complete=true,name=i99,role=[use(none,in_hierarchy,[rent_pcrops_2061_2080],array(1,58960))]],[course=[[ 515.04718, 1367.2679],[ 552.06697, 1365.9032],[ 571.31463, 1366.0358]]]).
arc(arc00382,node00047,node00068,influence,[complete=true,name=i39],[course=[[ 178.98576, 1675.5159],[ 76.300678, 1677.0923],[ -25.61341, 1676.2197]]]).
arc(arc00383,node00061,node00068,influence,[complete=true,name=i31],[course=[[ 178.98576, 2188.1278],[ 82.477307, 2189.2964],[ -25.613405, 2188.4203]]]).
arc(arc00438,node00068,node00041,influence,[complete=true,name=i28],[course=[[ -25.613405, 1620.653],[ 78.595457, 1619.5597],[ 178.98576, 1620.511]]]).
arc(arc00439,node00068,node00064,influence,[complete=true,name=i102],[course=[[ -25.613405, 1729.978],[ 83.286106, 1731.6584],[ 178.98576, 1729.7266]]]).
arc(arc00464,node00068,node00053,influence,[complete=true,name=i20],[course=[[ -25.613395, 2119.4632],[ 86.66161200000001, 2113.3674],[ 178.98576, 2109.5184]]]).
arc(arc00007,node00012,node00011,influence,[name=i6],[]).
arc(arc00491,node00132,node00117,influence,[complete=true,name=i126],[course=[[ 450.32144, 2792.524],[ 421.21888, 2778.0109],[ 406.22091, 2770.5395]]]).
arc(arc01093,node00011,node00132,influence,[complete=true,name=i119],[course=[[ 1072.1214, 1783.5785],[ 1110.326, 1846.0763],[ 1148.5557, 1919.1696]]]).
arc(arc00084,node00032,node00019,influence,[name=i1],[]).
arc(arc00087,node00069,node00033,influence,[name=i3],[]).
arc(arc00088,node00074,node00070,influence,[name=i4],[]).
arc(arc00013,node00098,node00071,influence,[complete=true,name=i2],[course=[[ 17.737866, -9.4704529],[ 143.2379, -6.7600742],[ 239.74512, -7.4842283]]]).
arc(arc00116,node00098,node00032,influence,[complete=true,name=i77,role=[use(none,in_hierarchy,rent_liquid_area_2005,1)]],[course=[[ 245.70194, 160.04751],[ 245.8727, 89.205303],[ 247.13854, -0.041258255]]]).
arc(arc00108,node00099,node00098,influence,[name=i25],[]).
arc(arc00111,node00083,node00099,influence,[complete=true,name=i28,role=[use(none,in_hierarchy,usr(rentability_liquid),1)]],[course=[[ 252.21049, -1.9197395],[ 264.55729, 12.056159],[ 287.49691, 33.182639]]]).
arc(arc00185,node00088,node00099,influence,[complete=true,name=i12,role=[use(none,in_hierarchy,usr(surplus_ini_2005_abs),1)]],[course=[[ 254.74479, -7.4977996],[ 407.07503, -6.6304312],[ 534.62366, -7.4497315]]]).
arc(arc00109,node00101,node00100,influence,[name=i26],[]).
arc(arc00112,node00087,node00101,influence,[complete=true,name=i29,role=[use(none,in_hierarchy,usr(rentability_non_woody),1)]],[course=[[ 226.90927, 415.2889],[ 255.45166, 383.05849],[ 279.44522, 357.98512]]]).
arc(arc00110,node00103,node00102,influence,[name=i27],[]).
arc(arc00113,node00085,node00103,influence,[complete=true,name=i30,role=[use(none,in_hierarchy,usr(rentability_woody),1)]],[course=[[ 218.79714, 744.76319],[ 260.77197, 707.508],[ 285.18826, 681.77065]]]).
arc(arc00106,node00106,node00032,influence,[complete=true,name=i17,role=[use(none,in_hierarchy,dens_liquid_2005,1)]],[course=[[ 225.66578, 162.41799],[ 110.21935, 89.516352],[ 17.723042, 36.246482]]]).
arc(arc00142,node00123,node00119,influence,[name=i49],[]).
arc(arc01160,node00088,node00123,influence,[complete=true,name=i155,role=[use(none,in_hierarchy,surplus_ini_2005_abs,1)]],[course=[[ 733.76307, 83.37128199999999],[ 609.34516, 24.838598],[ 548.87724, -4.3342649]]]).
arc(arc00122,node00019,node00137,influence,[complete=true,name=i43],[course=[[ 17.723042, 174.97735],[ 123.06423, 173.21781],[ 225.66578, 174.74903]]]).
arc(arc00130,node00146,node00019,flow,[complete=true,name='liquid\ngrowth'],[bowtie=[ 333.34956, 155.9446, 345.84956, 180.9446],caption_offset=[ 53.182144, -45.000276],course=[[ 265.66578, 168.4446],[ 413.53335, 168.4446]]]).
arc(arc00133,node00147,arc00130,influence,[name=i78],[]).
arc(arc00136,node00149,node00148,influence,[name=i79],[]).
arc(arc00139,node00019,node00149,influence,[complete=true,name=i80,role=[use(none,in_hierarchy,usr(liquid_area_0),1)]],[course=[[ 534.70579, 87.585801],[ 433.22001, 124.27121],[ 265.66578, 169.63294]]]).
arc(arc00157,node00033,node00149,influence,[complete=true,name=i81,role=[use(none,in_hierarchy,usr('NW_area'),1)]],[course=[[ 539.37683, 92.186224],[ 459.06639, 330.89713],[ 266.51556, 481.96472]]]).
arc(arc00158,node00070,node00149,influence,[complete=true,name=i82,role=[use(none,in_hierarchy,usr(woody_area_0),1)]],[course=[[ 540.46671, 92.46494800000001],[ 455.1865, 598.68268],[ 264.00744, 813.27575]]]).
arc(arc00159,node00119,node00149,influence,[complete=true,name=i83,role=[use(none,in_hierarchy,usr(surplus),1)]],[course=[[ 549.27393, 84.96765499999999],[ 649.23866, 84.18084500000001],[ 733.04509, 86.38204899999999]]]).
arc(arc00100,node00156,node00088,influence,[name=i8],[]).
arc(arc00183,node00084,node00156,influence,[complete=true,name=i10,role=[use(none,in_hierarchy,surplus_ini_2005_rel,1)]],[course=[[ 549.622, -7.659665],[ 648.7329099999999, -8.537991],[ 702.35298, -7.31407]]]).
arc(arc00135,node00169,node00147,influence,[complete=true,name=i55,role=[use(none,in_hierarchy,dens_add_liquid,1)]],[course=[[ 333.34956, 170.17058],[ 170.29851, 215.19836],[ 17.723042, 267.22463]]]).
arc(arc00180,node00243,node00069,influence,[complete=true,name=i72,role=[use(none,in_hierarchy,dens_non_woody_2005,1)]],[course=[[ 227.39655, 482.0565],[ 109.55142, 394.21345],[ 17.723042, 325.94043]]]).
arc(arc00194,node00100,node00245,influence,[complete=true,name=i75],[course=[[ 17.723042, 421.28256],[ 94.27678400000001, 419.92537],[ 214.43717, 420.84623]]]).
arc(arc00200,node00033,node00249,influence,[complete=true,name=i88],[course=[[ 17.723042, 497.25812],[ 143.77273, 497.2706],[ 227.39655, 497.02375]]]).
arc(arc00296,node00321,node00074,influence,[complete=true,name=i119,role=[use(none,in_hierarchy,dens_woody_2005,1)]],[course=[[ 232.96124, 813.27575],[ 141.30833, 735.52834],[ 17.723042, 631.25301]]]).
arc(arc00299,node00070,node00323,influence,[complete=true,name=i122],[course=[[ 17.723042, 828.85856],[ 109.16256, 830.97773],[ 230.64407, 828.6577]]]).
arc(arc00305,node00102,node00327,influence,[complete=true,name=i128],[course=[[ 17.723042, 749.20464],[ 80.09584700000001, 751.04372],[ 205.68823, 749.81512]]]).
arc(arc00240,node00396,node00101,influence,[complete=true,name=i16,role=[use(none,in_hierarchy,usr(remaining_surplus_2),1)]],[course=[[ 229.43602, 421.02208],[ 393.66721, 423.61447],[ 534.0385199999999, 422.08824]]]).
arc(arc00168,arc00130,node00397,influence,[complete=true,name=i7,role=[use(none,in_hierarchy,usr(liquid_growth),1)]],[course=[[ 537.18868, 415.89665],[ 435.51464, 277.83746],[ 345.84956, 175.57284]]]).
arc(arc00181,node00397,node00396,influence,[name=i13],[]).
arc(arc00201,node00148,node00397,influence,[complete=true,name=i14,role=[use(none,in_hierarchy,usr(remaining_surplus),1)]],[course=[[ 541.60759, 414.50702],[ 543.09385, 254.15375],[ 541.83353, 92.579666]]]).
arc(arc01165,arc00184,node00397,influence,[complete=true,name=i33,role=[use(none,in_hierarchy,liquid_decline,1)]],[course=[[ 536.08441, 416.85815],[ 359.75768, 250.39645],[ 165.58534, 192.18782]]]).
arc(arc00446,arc00705,node00425,influence,[complete=true,name=i123],[course=[[ 349.42028, 1063.1669],[ 348.3606, 962.4238800000001],[ 349.62451, 837.16984]]]).
arc(arc00101,node00553,node00156,influence,[complete=true,name=i9,role=[use(none,in_hierarchy,surface,1)]],[course=[[ 546.28643, -1.3554203],[ 640.73233, 140.12222],[ 735.04908, 285.1861]]]).
arc(arc00167,node00553,node00123,influence,[complete=true,name=i6,role=[use(none,in_hierarchy,surface,1)]],[course=[[ 740.35038, 94.07651],[ 737.03732, 195.6853],[ 738.97288, 283.97573]]]).
arc(arc00620,node00554,node00553,influence,[name=i111],[]).
arc(arc00621,node00555,node00553,influence,[complete=true,name=i112],[course=[[ 735.37242, 284.98733],[ 639.56499, 119.917],[ 688.44071, -132.24743]]]).
arc(arc00115,node00562,node00109,influence,[complete=true,name=i32],[course=[[ 17.723042, 85.729438],[ 174.04511, 86.403143],[ 332.4551, 85.393157]]]).
arc(arc00629,node00562,node00147,influence,[complete=true,name=i84,role=[use(none,in_hierarchy,remaining_liquid_rent_area,1)]],[course=[[ 339.08035, 155.9446],[ 337.83018, 125.8468],[ 339.56203, 92.835041]]]).
arc(arc00413,node00563,node00562,influence,[name=i38],[]).
arc(arc00414,node00148,node00563,influence,[complete=true,name=i40,role=[use(none,in_hierarchy,usr(remaining_surplus),1)]],[course=[[ 347.45493, 85.33030100000001],[ 456.74418, 85.11115100000001],[ 534.27477, 85.08033]]]).
arc(arc00415,node00083,node00563,influence,[complete=true,name=i41,role=[use(none,in_hierarchy,usr(rentability_liquid),1)]],[course=[[ 334.88201, 79.821276],[ 313.69407, 56.749138],[ 298.60544, 43.26173]]]).
arc(arc00655,node00576,node00033,flow,[complete=true,name='NW\ngrowth'],[bowtie=[ 338.06869, 486.74954, 350.56869, 511.74954],caption_offset=[ 31.363829, -47.727565],course=[[ 267.39655, 499.24954],[ 421.24084, 499.24954]]]).
arc(arc00282,node00255,node00577,influence,[complete=true,name=i100,role=[use(none,in_hierarchy,dens_add_NW,1)]],[course=[[ 338.06869, 501.24504],[ 172.87053, 553.9896],[ 17.723042, 593.24231]]]).
arc(arc00656,node00577,arc00655,influence,[name=i94],[]).
arc(arc00657,node00100,node00577,influence,[complete=true,name=i95,role=[use(none,in_hierarchy,remaining_NW_rent_area,1)]],[course=[[ 338.06869, 495.39519],[ 257.1284, 445.47966],[ 228.08595, 425.19786]]]).
arc(arc00956,node00579,node00123,influence,[complete=true,name=i93,role=[use(none,in_hierarchy,'Urb_dens',1)]],[course=[[ 748.04183, 86.679743],[ 903.83469, 88.782741],[ 1015.3208, 76.067623]]]).
arc(arc01040,node00580,node00123,influence,[complete=true,name=i99,role=[use(none,in_hierarchy,'FC_surface_rel',1)]],[course=[[ 748.0408, 86.73897599999999],[ 899.16538, 89.978945],[ 1015.3208, 78.56994400000001]]]).
arc(arc00449,node00581,node00427,influence,[complete=true,name=i127],[course=[[ 538.49997, 1063.1669],[ 539.67097, 925.14575],[ 542.10013, 756.7814]]]).
arc(arc00665,node00581,node00103,influence,[complete=true,name=i21,role=[use(none,in_hierarchy,usr(remaining_surplus_3),1)]],[course=[[ 220.68786, 749.76022],[ 394.07106, 750.1868899999999],[ 534.70847, 749.32798]]]).
arc(arc00169,arc00655,node00582,influence,[complete=true,name=i15,role=[use(none,in_hierarchy,'NW_growth',1)]],[course=[[ 539.6573, 742.22937],[ 448.63909, 613.47965],[ 350.56869, 506.09325]]]).
arc(arc00662,node00582,node00581,influence,[name=i18],[]).
arc(arc00663,node00396,node00582,influence,[complete=true,name=i19,role=[use(none,in_hierarchy,remaining_surplus_2,1)]],[course=[[ 542.11532, 741.7827600000001],[ 540.90003, 587.45071],[ 541.50916, 429.50664]]]).
arc(arc01166,arc01161,node00582,influence,[complete=true,name=i34,role=[use(none,in_hierarchy,'NW_decline',1)]],[course=[[ 536.85672, 744.02764],[ 349.65324, 560.21971],[ 190.29956, 518.08992]]]).
arc(arc00666,node00584,node00583,influence,[name=i22],[]).
arc(arc00667,node00088,node00584,influence,[complete=true,name=i23,role=[use(none,in_hierarchy,surplus_ini_2005_abs,1)]],[course=[[ 402.27489, 230.48056],[ 440.80436, 183.98949],[ 538.6160599999999, -0.96324511]]]).
arc(arc00668,node00019,node00584,influence,[complete=true,name=i24,role=[use(none,in_hierarchy,liquid_area_0,1)]],[course=[[ 390.61056, 233.26605],[ 315.41763, 200.59007],[ 265.66578, 182.37135]]]).
arc(arc00152,node00587,node00171,influence,[complete=true,name=i59],[course=[[ 17.723042, 296.0857],[ 187.84146, 295.86691],[ 334.94085, 296.14218]]]).
arc(arc00681,node00587,node00069,influence,[complete=true,name=i121,role=[use(none,in_hierarchy,rent_NW_area_2005,1)]],[course=[[ 254.55276, 481.96472],[ 299.76532, 387.19554],[ 339.0726, 302.85733]]]).
arc(arc00670,node00588,node00587,influence,[name=i36],[]).
arc(arc00671,node00583,node00588,influence,[complete=true,name=i37,role=[use(none,in_hierarchy,surplus_ini_2005_abs_2,1)]],[course=[[ 346.61054, 289.92215],[ 363.45823, 264.73336],[ 391.73739, 241.06847]]]).
arc(arc00672,node00087,node00588,influence,[complete=true,name=i42,role=[use(none,in_hierarchy,rentability_non_woody,1)]],[course=[[ 337.23628, 301.55646],[ 312.90088, 326.80687],[ 290.05532, 347.41088]]]).
arc(arc00202,node00590,node00589,influence,[name=i20],[]).
arc(arc00664,node00583,node00590,influence,[complete=true,name=i46,role=[use(none,in_hierarchy,surplus_ini_2005_abs_2,1)]],[course=[[ 397.26904, 547.33995],[ 397.54013, 435.41426],[ 397.49106, 243.75522]]]).
arc(arc00673,node00033,node00590,influence,[complete=true,name=i47,role=[use(none,in_hierarchy,'NW_area',1)]],[course=[[ 390.19713, 552.29146],[ 327.18827, 521.15581],[ 267.39655, 503.02828]]]).
arc(arc01041,node00591,node00123,influence,[complete=true,name=i101,role=[use(none,in_hierarchy,'PC_surface_rel',1)]],[course=[[ 748.04233, 86.527536],[ 915.69868, 85.372849],[ 1015.3208, 82.558448]]]).
arc(arc00184,node00019,node00592,flow,[complete=true,name='liquid\ndecline'],[bowtie=[ 140.58534, 182.19059, 165.58534, 194.69059],caption_offset=[ -129.10735, 19.862669],course=[[ 104.69838, 201.83366],[ 153.08534, 201.83366],[ 153.08534, 175.04751],[ 225.66578, 175.04751]]]).
arc(arc01052,node00593,node00123,influence,[complete=true,name=i109,role=[use(none,in_hierarchy,'GFC_surface_rel',1)]],[course=[[ 748.0421700000001, 86.650035],[ 910.94904, 88.200391],[ 1015.3208, 80.73771600000001]]]).
arc(arc00285,node00594,node00257,influence,[complete=true,name=i107],[course=[[ 17.723042, 617.44152],[ 205.50669, 618.81683],[ 337.27859, 617.44517]]]).
arc(arc00697,node00594,node00074,influence,[complete=true,name=i130,role=[use(none,in_hierarchy,rent_woody_area_2005,1)]],[course=[[ 257.56985, 813.27575],[ 299.40243, 722.67398],[ 341.92847, 624.30461]]]).
arc(arc00674,node00595,node00594,influence,[name=i48],[]).
arc(arc00675,node00085,node00595,influence,[complete=true,name=i51,role=[use(none,in_hierarchy,rentability_woody,1)]],[course=[[ 339.4932, 622.6886500000001],[ 317.71856, 644.61393],[ 295.24995, 670.6514]]]).
arc(arc00682,node00589,node00595,influence,[complete=true,name=i52,role=[use(none,in_hierarchy,surplus_ini_2005_abs_3,1)]],[course=[[ 350.21436, 612.20009],[ 373.79157, 589.79027],[ 393.07102, 561.06719]]]).
arc(arc01064,node00598,node00123,influence,[complete=true,name=i113,role=[use(none,in_hierarchy,surplus_PC,1)]],[course=[[ 748.04122, 86.717431],[ 889.48915, 89.34230100000001],[ 1015.3208, 76.85421599999999]]]).
arc(arc01069,node00599,node00123,influence,[complete=true,name=i115,role=[use(none,in_hierarchy,surplus_grassland,1)]],[course=[[ 748.0425, 86.58103800000001],[ 885.29403, 86.619051],[ 1015.3208, 75.629665]]]).
arc(arc01092,node00600,node00123,influence,[complete=true,name=i117,role=[use(none,in_hierarchy,surplus_foodcrops,1)]],[course=[[ 748.03885, 86.81289],[ 862.20602, 90.39753399999999],[ 1015.3208, 76.205853]]]).
arc(arc00705,node00615,node00070,flow,[complete=true,name='woody\ngrowth'],[bowtie=[ 343.50065, 812.16984, 356.00065, 837.16984],caption_offset=[ 40.909342, -49.09121],course=[[ 270.64407, 824.66984],[ 428.85723, 824.66984]]]).
arc(arc00378,node00334,node00616,influence,[complete=true,name=i137,role=[use(none,in_hierarchy,dens_add_woody,1)]],[course=[[ 343.50065, 826.54227],[ 193.70074, 871.42064],[ 17.723042, 911.76596]]]).
arc(arc00706,node00616,arc00705,influence,[name=i57],[]).
arc(arc00707,node00102,node00616,influence,[complete=true,name=i58,role=[use(none,in_hierarchy,remaining_woody_rent_area,1)]],[course=[[ 343.50065, 820.77104],[ 273.03777, 776.81577],[ 220.02123, 752.83293]]]).
arc(arc00520,node00622,node00149,influence,[complete=true,name=i154,role=[use(none,in_hierarchy,usr(forest_area_in_surplus),1)]],[course=[[ 542.60391, 92.533923],[ 610.81417, 706.45753],[ 646.43004, 1063.1669]]]).
arc(arc01152,node00671,node00123,influence,[complete=true,name=i143,role=[use(none,in_hierarchy,pro_forest,1)]],[course=[[ 748.0379799999999, 86.83944099999999],[ 877.49546, 91.36278],[ 1015.3208, 79.523858]]]).
arc(arc01154,node00695,node00123,influence,[complete=true,name=i145,role=[use(none,in_hierarchy,inland_waters,1)]],[course=[[ 748.04194, 86.670761],[ 882.12452, 88.32055200000001],[ 1015.3208, 80.295366]]]).
arc(arc01156,node00696,node00123,influence,[complete=true,name=i150,role=[use(none,in_hierarchy,sea_dens,1)]],[course=[[ 748.03736, 86.856718],[ 885.01994, 91.95936399999999],[ 1015.3208, 77.16466699999999]]]).
arc(arc01158,node00702,node00123,influence,[complete=true,name=i152,role=[use(none,in_hierarchy,pro_land,1)]],[course=[[ 748.04242, 86.61457],[ 908.67252, 87.380382],[ 1015.3208, 80.295366]]]).
arc(arc01045,node00703,arc00184,influence,[name=i5],[]).
arc(arc01161,node00033,node00704,flow,[complete=true,name='NW\ndecline'],[bowtie=[ 165.29956, 508.53518, 190.29956, 521.03518],caption_offset=[ -160.32012, 15.606383],course=[[ 103.40408, 528.25899],[ 177.79956, 528.25899],[ 177.79956, 501.31137],[ 227.39655, 501.31137]]]).
arc(arc01162,node00705,arc01161,influence,[name=i11],[]).
arc(arc01163,node00070,node00706,flow,[complete=true,name='Woody\ndecline'],[bowtie=[ 169.0409, 840.37275, 194.0409, 852.87275],caption_offset=[ -157.48259, 17.025145],course=[[ 107.88615, 860.46072],[ 181.5409, 860.46072],[ 181.5409, 832.78478],[ 230.64407, 832.78478]]]).
arc(arc01164,node00707,arc01163,influence,[name=i31],[]).
arc(arc01167,arc01163,node00708,influence,[complete=true,name=i35],[course=[[ 352.27542, 1063.1669],[ 259.50218, 939.56946],[ 186.78324, 852.87275]]]).
arc(arc01174,node00715,node00707,influence,[complete=true,name=i70,role=[use(none,in_hierarchy,usr(woody_to_remove),1)]],[course=[[ 194.0409, 849.97586],[ 316.31987, 882.77701],[ 448.36607, 929.29756]]]).
arc(arc00246,node00716,node00715,influence,[name=i67],[]).
arc(arc01171,node00070,node00716,influence,[complete=true,name=i68,role=[use(none,in_hierarchy,woody_area,1)]],[course=[[ 448.33176, 929.39717],[ 252.89564, 863.61519],[ 251.59976, 843.27575]]]).
arc(arc01175,node00715,node00717,influence,[complete=true,name=i71],[course=[[ 17.723042, 930.5803100000001],[ 283.36939, 927.86243],[ 447.94186, 931.61858]]]).
arc(arc01173,node00719,node00716,influence,[complete=true,name=i69,role=[use(none,in_hierarchy,woody_max_to_remove,1)]],[course=[[ 462.59555, 929.54319],[ 552.10534, 901.44155],[ 683.66357, 869.70425]]]).
arc(arc00198,node00720,node00719,influence,[name=i39],[]).
arc(arc01176,node00749,node00721,influence,[name=i53],[]).
arc(arc01177,node00719,node00749,influence,[complete=true,name=i54,role=[use(none,in_hierarchy,usr(woody_max_to_remove),1)]],[course=[[ 689.71564, 637.0912],[ 692.48979, 747.69656],[ 691.05017, 860.44601]]]).
arc(arc01186,node00715,node00749,influence,[complete=true,name=i106,role=[use(none,in_hierarchy,usr(woody_to_remove),1)]],[course=[[ 685.46664, 635.8936],[ 593.93169, 772.65551],[ 460.36356, 926.1321799999999]]]).
arc(arc01194,node00774,node00705,influence,[complete=true,name=i116,role=[use(none,in_hierarchy,usr('NW_to_remove'),1)]],[course=[[ 190.29956, 518.64347],[ 339.17389, 564.59549],[ 496.70256, 626.83735]]]).
arc(arc01188,node00775,node00774,influence,[name=i108],[]).
arc(arc01192,node00721,node00775,influence,[complete=true,name=i110,role=[use(none,in_hierarchy,'NW_max_to_remove',1)]],[course=[[ 511.17781, 629.60652],[ 593.21443, 629.75031],[ 682.04624, 629.99167]]]).
arc(arc01193,node00033,node00775,influence,[complete=true,name=i114,role=[use(none,in_hierarchy,'NW_area',1)]],[course=[[ 496.59538, 627.12577],[ 264.36331, 546.21334],[ 252.56423, 511.96472]]]).
arc(arc01204,node00825,node00824,influence,[name=i62],[]).
arc(arc01205,node00721,node00825,influence,[complete=true,name=i63,role=[use(none,in_hierarchy,usr('NW_max_to_remove'),1)]],[course=[[ 689.51306, 320.70939],[ 689.02833, 481.599],[ 689.50995, 622.0934099999999]]]).
arc(arc01344,node00774,node00825,influence,[complete=true,name=i164,role=[use(none,in_hierarchy,usr('NW_to_remove'),1)]],[course=[[ 685.66367, 319.63263],[ 604.4681399999999, 451.28069],[ 507.36838, 623.06424]]]).
arc(arc01198,node00774,node01161,influence,[complete=true,name=i120],[course=[[ 17.723042, 630.30621],[ 201.33767, 635.66625],[ 496.17933, 629.744]]]).
arc(arc01349,node01177,node00703,influence,[complete=true,name=i169,role=[use(none,in_hierarchy,usr(liquid_to_remove),1)]],[course=[[ 165.58534, 192.95638],[ 320.65508, 248.97739],[ 520.63327, 310.98812]]]).
arc(arc01345,node01178,node01177,influence,[name=i165],[]).
arc(arc01346,node00824,node01178,influence,[complete=true,name=i166,role=[use(none,in_hierarchy,liquid_max_to_remove,1)]],[course=[[ 535.29619, 313.11646],[ 628.10901, 311.96584],[ 682.03727, 313.05403]]]).
arc(arc01348,node00019,node01178,influence,[complete=true,name=i168,role=[use(none,in_hierarchy,liquid_area,1)]],[course=[[ 520.61666, 311.04241],[ 202.02646, 215.26596],[ 229.38992, 190.04751]]]).
arc(arc01351,node01177,node01184,influence,[complete=true,name=i171],[course=[[ 17.723042, 312.66365],[ 170.22071, 313.41353],[ 520.29677, 313.21371]]]).
arc(arc01206,node00148,node01196,influence,[complete=true,name=i45],[course=[[ 646.54068, 1063.1669],[ 614.10239, 748.60839],[ 542.54099, 92.540654]]]).
arc(arc01414,node01243,node00720,influence,[complete=true,name=i50,role=[use(none,in_hierarchy,usr(forest_max_to_remove),1)]],[course=[[ 690.79148, 875.44363],[ 687.4496, 1029.2363],[ 690.96529, 1063.1669]]]).
arc(arc01417,node01246,node00720,influence,[complete=true,name=i163,role=[use(none,in_hierarchy,usr(forest_to_remove),1)]],[course=[[ 690.85995, 875.44481],[ 689.88171, 953.1052],[ 689.1514, 1063.1669]]]).
arc(arc00177,node00019,node01523,influence,[complete=true,name=i89,role=[use(none,in_hierarchy,liquid_area_0,1)]],[course=[[ 595.89735, 259.58967],[ 413.82234, 213.78774],[ 265.66578, 179.65515]]]).
arc(arc00644,node00553,node01523,influence,[complete=true,name=i147,role=[use(none,in_hierarchy,surface,1)]],[course=[[ 663.99793, 275.18883],[ 699.90361, 279.62678],[ 731.95746, 289.30589]]]).
arc(arc00855,node01523,node00676,influence,[complete=true,name=i229],[course=[[ 930.07386, 1056.7701],[ 974.87558, 610.89864],[ 645.05943, 307.53438]]]).
arc(arc00190,node00162,node00161,influence,[name=i85],[]).
arc(arc01511,node00161,node01524,influence,[complete=true,name=i229],[course=[[ 49.162083, 79.450678],[ 52.736444, 57.765039],[ 37.816301, 42.461671]]]).
arc(arc01536,node01525,node00162,influence,[complete=true,name=i89,role=[use(none,in_hierarchy,liquid_area_0,1)]],[course=[[ 27.970701, 34.145278],[ 14.713293, 32.064959],[ 0.0, 31.505963]]]).
arc(arc01558,node01526,node00162,influence,[complete=true,name=i147,role=[use(none,in_hierarchy,surface,1)]],[course=[[ 42.332807, 38.158565],[ 55.795139, 43.546159],[ 68.10058100000001, 47.105128]]]).
arc(arc00178,node00033,node01527,influence,[complete=true,name=i90,role=[use(none,in_hierarchy,'NW_area',1)]],[course=[[ 605.82868, 568.58661],[ 417.90047, 527.9825],[ 267.39655, 500.60309]]]).
arc(arc00645,node00553,node01527,influence,[complete=true,name=i148,role=[use(none,in_hierarchy,surface,1)]],[course=[[ 680.95989, 522.76106],[ 710.76698, 423.13563],[ 737.55743, 298.80565]]]).
arc(arc00864,node01527,node00681,influence,[complete=true,name=i234],[course=[[ 797.07082, 1063.1669],[ 841.13972, 805.79573],[ 661.32805, 615.40576]]]).
arc(arc00191,node00164,node00163,influence,[name=i86],[]).
arc(arc01562,node00163,node01528,influence,[complete=true,name=i234],[course=[[ 49.824322, 93.638299],[ 54.386734, 68.427926],[ 39.540548, 49.180891]]]).
arc(arc01565,node01529,node00164,influence,[complete=true,name=i90,role=[use(none,in_hierarchy,'NW_area',1)]],[course=[[ 27.460602, 43.35081],[ 17.196956, 43.499326],[ -5.6750484, 46.81915]]]).
arc(arc01689,node01530,node00164,influence,[complete=true,name=i148,role=[use(none,in_hierarchy,surface,1)]],[course=[[ 39.364731, 37.172145],[ 54.203639, 16.723523],[ 69.456157, 0.99360335]]]).
arc(arc00179,node00070,node01531,influence,[complete=true,name=i91,role=[use(none,in_hierarchy,woody_area_0,1)]],[course=[[ 705.14203, 945.01514],[ 481.74334, 896.92798],[ 270.64407, 834.21711]]]).
arc(arc00646,node00553,node01531,influence,[complete=true,name=i149,role=[use(none,in_hierarchy,surface,1)]],[course=[[ 739.29366, 916.18333],[ 740.30788, 595.55531],[ 739.16613, 298.97387]]]).
arc(arc00961,node01531,node00686,influence,[complete=true,name=i239],[course=[[ 812.14125, 1063.1669],[ 807.03462, 1016.6321],[ 766.74278, 992.79648]]]).
arc(arc00192,node00166,node00165,influence,[name=i87],[]).
arc(arc01706,node00165,node01532,influence,[complete=true,name=i239],[course=[[ 61.60075, 76.61315399999999],[ 60.867014, 48.134549],[ 37.643887, 31.634374]]]).
arc(arc01707,node01533,node00166,influence,[complete=true,name=i91,role=[use(none,in_hierarchy,woody_area_0,1)]],[course=[[ 26.755058, 26.441419],[ 12.586523, 29.186653],[ 0.0, 28.831813]]]).
arc(arc01708,node01534,node00166,influence,[complete=true,name=i149,role=[use(none,in_hierarchy,surface,1)]],[course=[[ 33.608526, 17.532116],[ 33.23665, 12.071661],[ 34.151631, 0.0]]]).
arc(arc00492,node00132,node00233,influence,[complete=true,name=i130],[course=[[ 578.24592, 2792.524],[ 602.53139, 2764.7132],[ 595.3006, 2770.5395]]]).
arc(arc00493,node00132,node00272,influence,[complete=true,name=i232],[course=[[ 1295.579, 2792.524],[ 1149.7408, 2775.11],[ 986.87446, 2764.1427]]]).
arc(arc00494,node00132,node00273,influence,[complete=true,name=i237],[course=[[ 1117.2334, 2792.524],[ 992.4673, 2779.4647],[ 853.87143, 2770.5395]]]).
arc(arc00495,node00132,node00274,influence,[complete=true,name=i242],[course=[[ 1147.5604, 2792.524],[ 1015.166, 2777.3841],[ 868.94186, 2770.5395]]]).
arc(arc00496,node00132,node00275,influence,[complete=true,name=i3],[course=[[ -1.8420874, 1697.2053],[ 41.849502, 1700.1103],[ 74.53851899999999, 1697.9022]]]).
arc(arc00497,node00132,node00276,influence,[complete=true,name=i35],[course=[[ -1.8420874, 1793.0225],[ 39.105952, 1792.8827],[ 74.523695, 1793.1021]]]).
arc(arc00498,node00132,node00278,influence,[complete=true,name=i44],[course=[[ -1.8420874, 1883.236],[ 58.22342, 1882.6135],[ 74.523695, 1882.35]]]).
arc(arc00499,node00132,node00279,influence,[complete=true,name=i60],[course=[[ -1.8421432, 2004.3834],[ 55.590531, 2003.6399],[ 74.523695, 2003.4583]]]).
arc(arc00500,node00132,node00280,influence,[complete=true,name=i76],[course=[[ -1.8421432, 2124.4543],[ 55.731566, 2126.4766],[ 74.523695, 2128.6552]]]).
arc(arc00501,node00132,node00281,influence,[complete=true,name=i89],[course=[[ -1.8421432, 2205.2132],[ 39.10122, 2204.7424],[ 74.523695, 2204.6308]]]).
arc(arc00502,node00132,node00283,influence,[complete=true,name=i111],[course=[[ -1.8421432, 2318.594],[ 41.817234, 2321.5246],[ 74.523695, 2324.8142]]]).
arc(arc00503,node00132,node00284,influence,[complete=true,name=i124],[course=[[ -1.8421432, 2535.6945],[ 43.628701, 2535.7834],[ 74.523695, 2536.2312]]]).
arc(arc00504,node00132,node00285,influence,[complete=true,name=i129],[course=[[ -1.8421432, 2454.6331],[ 39.024334, 2455.4257],[ 74.523695, 2456.5773]]]).
arc(arc00505,node00286,node00132,influence,[complete=true,name=i155],[course=[[ 703.2306599999999, 2770.5395],[ 701.42867, 2784.9448],[ 702.54724, 2792.524]]]).
arc(arc00506,node00287,node00132,influence,[complete=true,name=i115],[course=[[ 745.24136, 1575.1252],[ 1128.086, 736.36483],[ 723.3681800000001, -9.0000441]]]).
arc(arc00507,node00288,node00132,influence,[complete=true,name=i19],[course=[[ 74.523695, 1743.6191],[ 35.967162, 1742.9321],[ -1.8421432, 1741.8862]]]).
arc(arc00516,node00289,node00132,influence,[complete=true,name=i56],[course=[[ 74.523695, 1974.5973],[ 24.074718, 1974.776],[ -1.8421432, 1974.5956]]]).
arc(arc00518,node00290,node00132,influence,[complete=true,name=i73],[course=[[ 74.523695, 2033.3131],[ 56.381808, 2033.8481],[ -1.8421432, 2033.8212]]]).
arc(arc00522,node00291,node00132,influence,[complete=true,name=i105],[course=[[ 74.523695, 2300.615],[ 38.806619, 2300.5888],[ -1.8421432, 2300.2037]]]).
arc(arc00523,node00292,node00132,influence,[complete=true,name=i120],[course=[[ 74.523695, 2338.6257],[ 19.052693, 2336.4859],[ -1.8421432, 2333.9872]]]).
arc(arc00524,node00293,node00132,influence,[complete=true,name=i140],[course=[[ 74.523695, 2619.1386],[ 33.357675, 2619.4734],[ -1.4065473, 2619.4493]]]).
arc(arc01074,node00385,node00132,influence,[complete=true,name=i116],[course=[[ 1072.1214, 1783.0023],[ 1112.6632, 1818.0263],[ 1145.8432, 1858.5496]]]).
arc(arc00635,node00386,node00385,influence,[name=i15],[]).
arc(arc01065,node00478,node00132,influence,[complete=true,name=i114],[course=[[ 1072.1214, 1784.2269],[ 1105.1078, 1790.4413],[ 1138.5552, 1796.325]]]).
arc(arc00689,node00479,node00478,influence,[name=i37],[]).
arc(arc01019,node00484,node00132,influence,[complete=true,name=i97],[course=[[ 1072.1214, 1783.4403],[ 1151.7394, 1772.4526],[ 1217.5543, 1778.609]]]).
arc(arc00695,node00485,node00484,influence,[name=i62],[]).
arc(arc00696,node00486,node00484,influence,[complete=true,name=i64],[course=[[ 1227.4497, 1772.2114],[ 1541.9735, 852.96781],[ 1188.3405, -9.0000441]]]).
arc(arc01038,node00487,node00132,influence,[complete=true,name=i98],[course=[[ 1072.1214, 1785.9426],[ 1101.4486, 1769.1144],[ 1131.4179, 1735.4106]]]).
arc(arc00698,node00488,node00487,influence,[name=i67],[]).
arc(arc01062,node00489,node00132,influence,[complete=true,name=i112],[course=[[ 1072.1214, 1788.1104],[ 1108.7992, 1724.5807],[ 1134.4052, 1633.0084]]]).
arc(arc00041,node00363,node00491,influence,[complete=true,name=i5],[course=[[ 1208.0401, 102.41578],[ 1214.3395, 45.329886],[ 1188.3406, -9.0000658]]]).
arc(arc00236,node00398,node00491,influence,[complete=true,name=i45],[course=[[ 1290.7543, 102.41578],[ 1302.7772, 48.191594],[ 1282.5017, -9.0000658]]]).
arc(arc00252,node00403,node00491,influence,[complete=true,name=i55],[course=[[ 1288.5463, 102.41578],[ 1300.4164, 48.115203],[ 1279.9881, -9.0000658]]]).
arc(arc00318,node00419,node00491,influence,[complete=true,name=i61],[course=[[ 1116.0209, 102.41578],[ 1115.953, 42.146251],[ 1083.5868, -9.0000658]]]).
arc(arc00322,node00424,node00491,influence,[complete=true,name=i66],[course=[[ 1105.3981, 102.41578],[ 1104.5952, 41.778729],[ 1071.4939, -9.0000658]]]).
arc(arc00327,node00433,node00491,influence,[complete=true,name=i71],[course=[[ 1041.4388, 168.95024],[ 1033.9656, 64.345484],[ 964.73275, -9.0000658]]]).
arc(arc00331,node00437,node00491,influence,[complete=true,name=i77],[course=[[ 1041.4388, 298.02567],[ 1010.1767, 102.70011],[ 860.00036, -9.0000658]]]).
arc(arc00334,node00451,node00491,influence,[complete=true,name=i80],[course=[[ 1214.0872, 102.41578],[ 1220.805, 45.539101],[ 1195.2245, -9.0000658]]]).
arc(arc00019,node00023,node00022,influence,[name=i1],[]).
arc(arc00038,node00029,node00028,influence,[name=i14],[]).
arc(arc00039,node00031,node00030,influence,[name=i18],[]).
arc(arc00022,node00194,node00181,influence,[name=i49],[]).
arc(arc00030,node00361,node00359,influence,[name=i2],[]).
arc(arc00233,node00394,node00393,influence,[name=i43],[]).
arc(arc00248,node00402,node00399,influence,[name=i54],[]).
arc(arc00263,node00417,node00416,influence,[name=i58],[]).
arc(arc00320,node00422,node00421,influence,[name=i63],[]).
arc(arc00324,node00431,node00426,influence,[name=i69],[]).
arc(arc00329,node00435,node00434,influence,[name=i74],[]).
arc(arc00333,node00448,node00443,influence,[name=i79],[]).
arc(arc00337,node00458,node00452,influence,[name=i82],[]).
arc(arc00338,node00359,node00458,influence,[complete=true,name=i83,role=[use(none,in_hierarchy,usr('Urb_dens'),1)]],[course=[[ 95.98656099999999, 159.933],[ 72.155822, 112.68883],[ 54.648868, 79.003613]]]).
arc(arc00340,node00399,node00458,influence,[complete=true,name=i85,role=[use(none,in_hierarchy,usr(inland_waters),1)]],[course=[[ 102.46061, 163.19271],[ 144.61552, 114.8646],[ 177.74419, 79.65941599999999]]]).
arc(arc00341,node00393,node00458,influence,[complete=true,name=i86,role=[use(none,in_hierarchy,usr(sea_dens),1)]],[course=[[ 99.275257, 160.55577],[ 110.28222, 123.91523],[ 122.03394, 79.71957500000001]]]).
arc(arc00342,node00416,node00458,influence,[complete=true,name=i87,role=[use(none,in_hierarchy,usr(pro_forest),1)]],[course=[[ 102.6952, 163.55785],[ 167.48218, 124.53406],[ 236.06247, 77.21092299999999]]]).
arc(arc00345,node00443,node00458,influence,[complete=true,name=i90,role=[use(none,in_hierarchy,usr(pro_land),1)]],[course=[[ 103.3351, 164.909],[ 217.83602, 122.2997],[ 307.51354, 77.70817099999999]]]).
arc(arc00350,node00467,node00461,influence,[name=i95],[]).
arc(arc00351,node00452,node00467,influence,[complete=true,name=i96,role=[use(none,in_hierarchy,tot_occupied_area,1)]],[course=[[ 213.37791, 223.06129],[ 165.37777, 196.41922],[ 103.25536, 170.15962]]]).
arc(arc00360,node00483,node00482,influence,[name=i117_0],[]).
arc(arc00634,node00461,node00483,influence,[complete=true,name=i118,role=[use(none,in_hierarchy,usr(to_remove),1)]],[course=[[ 309.95326, 227.29028],[ 276.28968, 224.47543],[ 227.42968, 226.40506]]]).
arc(arc00679,node00421,node00483,influence,[complete=true,name=i121,role=[use(none,in_hierarchy,usr(pro_pcrop),1)]],[course=[[ 324.14267, 223.45769],[ 350.67206, 221.79034],[ 370.2525, 223.54159]]]).
arc(arc00684,node00434,node00483,influence,[complete=true,name=i125,role=[use(none,in_hierarchy,usr(pro_grass),1)]],[course=[[ 321.02211, 217.82899],[ 339.09076, 192.58002],[ 360.56804, 161.86832]]]).
arc(arc00685,node00426,node00483,influence,[complete=true,name=i127,role=[use(none,in_hierarchy,usr(pro_crop),1)]],[course=[[ 314.58155, 216.72115],[ 310.36491, 202.08204],[ 294.74475, 153.61069]]]).
arc(arc00934,node00022,node00492,influence,[complete=true,name=i50],[course=[[ -4.0, 632.99286],[ 32.727575, 672.20499],[ 106.05451, 662.32265]]]).
arc(arc00935,node00028,node00493,influence,[complete=true,name=i108],[course=[[ -4.0, 639.51773],[ 84.169708, 681.21785],[ 176.29293, 629.8206]]]).
arc(arc00031,node00506,node00458,influence,[complete=true,name=i12,role=[use(none,in_hierarchy,usr('FC_abs'),1)]],[course=[[ 95.033793, 174.82493],[ 84.011195, 240.74823],[ 54.755408, 357.66945]]]).
arc(arc00701,node00506,node00483,influence,[complete=true,name=i107,role=[use(none,in_hierarchy,usr('FC_abs'),1)]],[course=[[ 310.12345, 227.61011],[ 213.61343, 281.99461],[ 71.002139, 361.51711]]]).
arc(arc00709,node00507,node00506,influence,[name=i78],[]).
arc(arc00708,node00509,node00483,influence,[complete=true,name=i128,role=[use(none,in_hierarchy,usr(surface),1)]],[course=[[ 309.20527, 223.08245],[ 265.95099, 198.91719],[ 225.87696, 171.05545]]]).
arc(arc00731,node00509,node00458,influence,[complete=true,name=i93,role=[use(none,in_hierarchy,usr(surface),1)]],[course=[[ 103.7706, 167.40095],[ 163.12497, 167.17206],[ 212.21922, 166.82684]]]).
arc(arc00852,node00509,node00467,influence,[complete=true,name=i131,role=[use(none,in_hierarchy,surface,1)]],[course=[[ 219.25332, 219.23212],[ 217.54839, 200.56631],[ 219.23826, 174.25868]]]).
arc(arc00728,node00510,node00509,influence,[name=i84],[]).
arc(arc00732,node00559,node00483,influence,[complete=true,name=i141,role=[use(none,in_hierarchy,usr('GFC_abs'),1)]],[course=[[ 310.96066, 228.80632],[ 222.81141, 304.28898],[ 142.02926, 359.0052]]]).
arc(arc01110,node00559,node00458,influence,[complete=true,name=i138,role=[use(none,in_hierarchy,usr('GFC_abs'),1)]],[course=[[ 97.159053, 174.87481],[ 107.88519, 264.78843],[ 120.06049, 357.55181]]]).
arc(arc01081,node00560,node00559,influence,[name=i135],[]).
arc(arc00824,node00569,node00483,influence,[complete=true,name=i152,role=[use(none,in_hierarchy,usr('PC_abs'),1)]],[course=[[ 311.79631, 229.63947],[ 253.88077, 297.68429],[ 202.79866, 357.70254]]]).
arc(arc01136,node00569,node00458,influence,[complete=true,name=i150,role=[use(none,in_hierarchy,usr('PC_abs'),1)]],[course=[[ 98.90449, 174.44993],[ 145.31183, 268.82067],[ 183.57466, 357.70254]]]).
arc(arc01120,node00570,node00569,influence,[name=i147],[]).
arc(arc00936,node00030,node00641,influence,[complete=true,name=i24],[course=[[ -4.0, 777.14359],[ 147.72728, 751.44613],[ 232.99438, 601.44652]]]).
arc(arc01380,node00642,node00181,influence,[complete=true,name=i168],[course=[[ 53.325482, 839.75252],[ 51.427608, 806.7107999999999],[ -4.0, 816.75023]]]).
arc(arc01382,node00689,node00227,influence,[complete=true,name=i167],[course=[[ 353.90219, 838.46374],[ 270.39426, 552.12147],[ -4.0, 418.62165]]]).
arc(arc01383,node00690,node00359,influence,[complete=true,name=i5],[course=[[ 58.18164, 69.634056],[ 125.50017, 43.495327],[ 165.01851, -11.565956]]]).
arc(arc01384,node00691,node00393,influence,[complete=true,name=i45],[course=[[ 131.08138, 70.114825],[ 204.72934, 45.738974],[ 248.93281, -11.565956]]]).
arc(arc00234,node00900,node00227,influence,[name=i59],[]).
arc(arc01385,node00932,node00399,influence,[complete=true,name=i55],[course=[[ 188.34162, 69.053166],[ 231.04, 28.80625],[ 246.69278, -11.565956]]]).
arc(arc01479,node00933,node00416,influence,[complete=true,name=i61],[course=[[ 238.48463, 66.43295999999999],[ 190.04793, -17.786779],[ 71.66421, -11.565956]]]).
arc(arc01501,node00948,node00421,influence,[complete=true,name=i66],[course=[[ 374.26577, 217.26557],[ 279.50892, 36.206585],[ 60.887284, -11.565956]]]).
arc(arc01506,node00991,node00426,influence,[complete=true,name=i71],[course=[[ 288.26278, 140.14515],[ 209.46217, 7.0975376],[ -4.0, 55.933851]]]).
arc(arc01507,node00992,node00434,influence,[complete=true,name=i77],[course=[[ 358.29685, 152.87327],[ 210.38673, 86.91018699999999],[ -4.0, 186.88203]]]).
arc(arc01508,node00995,node00443,influence,[complete=true,name=i80],[course=[[ 310.77042, 67.714023],[ 281.38508, 11.174243],[ 171.15335, -11.565956]]]).
arc(arc01509,node00482,node00996,influence,[complete=true,name=i22],[course=[[ -4.0, 511.68545],[ 167.15447, 438.73156],[ 312.37302, 230.08393]]]).
arc(arc01253,node01107,node01100,influence,[name=i186],[]).
arc(arc01259,node01116,node01115,influence,[name=i192],[]).
arc(arc01262,node01121,node01120,influence,[name=i195],[]).
arc(arc01278,node01136,node01135,influence,[name=i211],[]).
arc(arc00207,node01140,node00023,influence,[complete=true,name=i29,role=[use(none,in_hierarchy,proportion_FC,1)]],[course=[[ 109.72996, 654.82997],[ 64.438186, 576.58688],[ 54.793536, 559.94294]]]).
arc(arc01281,node01141,node01140,influence,[name=i214],[]).
arc(arc01284,node00506,node01141,influence,[complete=true,name=i217,role=[use(none,in_hierarchy,'FC_abs',1)]],[course=[[ 51.057496, 545.95376],[ 51.401012, 439.80072],[ 50.948854, 387.66945]]]).
arc(arc01285,node00559,node01141,influence,[complete=true,name=i218,role=[use(none,in_hierarchy,'GFC_abs',1)]],[course=[[ 53.741137, 546.4596299999999],[ 88.581632, 456.47243],[ 116.05082, 387.55181]]]).
arc(arc01286,node00569,node01141,influence,[complete=true,name=i219,role=[use(none,in_hierarchy,'PC_abs',1)]],[course=[[ 55.598753, 547.50343],[ 142.20507, 434.62865],[ 182.62909, 387.70254]]]).
arc(arc00213,node01142,node00029,influence,[complete=true,name=i30,role=[use(none,in_hierarchy,proportion_GFC,1)]],[course=[[ 179.11644, 619.65753],[ 147.27133, 564.02877],[ 126.65252, 526.14104]]]).
arc(arc01282,node01143,node01142,influence,[name=i215],[]).
arc(arc01287,node00506,node01143,influence,[complete=true,name=i220,role=[use(none,in_hierarchy,'FC_abs',1)]],[course=[[ 120.1486, 512.62535],[ 77.506833, 426.36337],[ 58.309058, 387.66945]]]).
arc(arc01288,node00559,node01143,influence,[complete=true,name=i221,role=[use(none,in_hierarchy,'GFC_abs',1)]],[course=[[ 122.47599, 511.91519],[ 120.44453, 496.75639],[ 121.66488, 387.55181]]]).
arc(arc01290,node00569,node01143,influence,[complete=true,name=i223,role=[use(none,in_hierarchy,'PC_abs',1)]],[course=[[ 126.64563, 512.55322],[ 160.03369, 441.05758],[ 185.44068, 387.70254]]]).
arc(arc00214,node01144,node00031,influence,[complete=true,name=i36,role=[use(none,in_hierarchy,proportion_PC,1)]],[course=[[ 233.31816, 588.23247],[ 210.21265, 542.50882],[ 192.83429, 497.88027]]]).
arc(arc01283,node01145,node01144,influence,[name=i216],[]).
arc(arc01289,node00559,node01145,influence,[complete=true,name=i222,role=[use(none,in_hierarchy,'GFC_abs',1)]],[course=[[ 185.9466, 484.65506],[ 170.79099, 461.96887],[ 130.2092, 387.55181]]]).
arc(arc01291,node00569,node01145,influence,[complete=true,name=i224,role=[use(none,in_hierarchy,'PC_abs',1)]],[course=[[ 190.19466, 483.39188],[ 190.63249, 443.25533],[ 190.15714, 387.70254]]]).
arc(arc01292,node00506,node01145,influence,[complete=true,name=i225,role=[use(none,in_hierarchy,'FC_abs',1)]],[course=[[ 184.27986, 486.17696],[ 85.223314, 406.11501],[ 66.028223, 387.66945]]]).
arc(arc00040,node01150,node00023,influence,[complete=true,name=i23,role=[use(none,in_hierarchy,'Agriculture_to_keep_outside_protected_areas',1)]],[course=[[ 119.30455, 666.05481],[ 153.62521, 693.9838999999999],[ 230.60288, 754.9943]]]).
arc(arc00042,node01150,node00029,influence,[complete=true,name=i26,role=[use(none,in_hierarchy,'Agriculture_to_keep_outside_protected_areas',1)]],[course=[[ 185.5275, 633.16939],[ 207.77187, 691.187],[ 233.58041, 752.7362900000001]]]).
arc(arc00043,node01150,node00031,influence,[complete=true,name=i27,role=[use(none,in_hierarchy,'Agriculture_to_keep_outside_protected_areas',1)]],[course=[[ 236.03276, 602.39653],[ 238.84375, 682.76828],[ 236.71104, 752.15638]]]).
arc(arc01301,node01151,node01150,influence,[name=i235],[]).
arc(arc01305,node01120,node01151,influence,[complete=true,name=i240,role=[use(none,in_hierarchy,protected_abs_FC,1)]],[course=[[ 241.48946, 754.0705799999999],[ 315.18049, 671.94313],[ 352.3503, 623.14399]]]).
arc(arc01306,node01115,node01151,influence,[complete=true,name=i241,role=[use(none,in_hierarchy,protected_abs_GFC,1)]],[course=[[ 242.67916, 755.43049],[ 307.40433, 711.34058],[ 355.61933, 677.1317299999999]]]).
arc(arc01307,node01100,node01151,influence,[complete=true,name=i243,role=[use(none,in_hierarchy,protected_abs_PC,1)]],[course=[[ 243.67836, 757.54507],[ 305.361, 739.4820099999999],[ 351.63579, 725.29507]]]).
arc(arc01309,node01135,node01151,influence,[complete=true,name=i245,role=[use(none,in_hierarchy,surface,1)]],[course=[[ 243.84852, 761.05433],[ 296.9529, 771.15562],[ 349.14817, 783.17031]]]).
arc(arc01510,node01214,node00506,influence,[complete=true,name=i81],[course=[[ 46.678107, 357.66945],[ 25.011759, 282.50923],[ -4.0, 227.11219]]]).
arc(arc01566,node01215,node00509,influence,[complete=true,name=i88],[course=[[ 212.27381, 165.86929],[ 105.22484, 152.85964],[ -4.0, 275.97478]]]).
arc(arc01567,node01217,node00559,influence,[complete=true,name=i137],[course=[[ 102.02926, 382.14185],[ 4.9833549, 428.67554],[ -4.0, 533.14801]]]).
arc(arc01568,node01218,node00569,influence,[complete=true,name=i149],[course=[[ 170.40299, 387.70254],[ -0.97651703, 518.66634],[ -4.0, 744.97183]]]).
arc(arc01569,node01219,node01100,influence,[complete=true,name=i188],[course=[[ 348.79204, 717.83083],[ 146.57045, 677.35352],[ -4.0, 812.08536]]]).
arc(arc01570,node01335,node01115,influence,[complete=true,name=i194],[course=[[ 351.09129, 668.75373],[ 147.63574, 629.12497],[ -4.0, 749.98879]]]).
arc(arc01571,node01337,node01120,influence,[complete=true,name=i197],[course=[[ 351.07284, 612.44956],[ 188.11642, 480.111],[ -4.0, 492.13071]]]).
arc(arc01572,node01338,node01135,influence,[complete=true,name=i212],[course=[[ 354.95097, 773.72157],[ 290.22035, 433.72284],[ -4.0, 275.97478]]]).
arc(arc01688,node01342,node01496,influence,[complete=true,name=i176],[course=[[ 235.43969, 991.22063],[ 206.81401, 731.75213],[ -4.0, 549.72942]]]).
arc(arc01237,node01497,node01496,influence,[name=i171],[]).
arc(arc01682,node01503,node01502,influence,[name=i182],[]).
arc(arc01686,node01496,node01503,influence,[complete=true,name=i187,role=[use(none,in_hierarchy,[employment_in_agriculture],array(1,304))]],[course=[[ 235.71578, 913.21611],[ 236.32745, 947.71923],[ 236.27175, 991.1754]]]).
arc(arc01687,node01504,node01503,influence,[complete=true,name=i189,role=[use(none,in_hierarchy,'IDNUTS',1)]],[course=[[ 243.08106, 905.55371],[ 307.51244, 904.1480299999999],[ 348.11905, 904.99778]]]).
arc(arc01747,node01343,node01504,influence,[complete=true,name=i184],[course=[[ 354.60598, 897.845],[ 309.64549, 566.30905],[ -4.0, 378.48953]]]).
arc(arc01683,node01505,node01504,influence,[name=i183],[]).
arc(arc01748,node01554,node01151,influence,[complete=true,name=i256,role=[use(none,in_hierarchy,'Agro_threshold',1)]],[course=[[ 234.13353, 766.77612],[ 237.10415, 797.26179],[ 235.55973, 838.93534]]]).
arc(arc01759,node01554,node01344,influence,[complete=true,name=i270],[course=[[ 22.427451, -3.8069403],[ -58.180326, 475.56992],[ 230.62802, 840.54881]]]).
arc(arc00853,node00227,node01555,influence,[complete=true,name=i156,role=[use(none,in_hierarchy,usr(scenario),int)]],[course=[[ 242.78197, 846.43584],[ 282.70553, 846.46587],[ 348.502, 845.67259]]]).
arc(arc00918,node01502,node01555,influence,[complete=true,name=i205,role=[use(none,in_hierarchy,usr('Employment_in_agriculture'),1)]],[course=[[ 234.17921, 853.8486799999999],[ 236.84791, 873.39881],[ 235.8762, 898.22303]]]).
arc(arc00933,node00181,node01555,influence,[complete=true,name=i190,role=[use(none,in_hierarchy,'GFC_ini_rel',1)]],[course=[[ 227.78519, 846.64996],[ 170.47777, 848.32988],[ 61.254665, 847.35621]]]).
arc(arc01746,node01555,node01554,influence,[name=i254],[]).
arc(arc01757,node01556,node01555,influence,[complete=true,name=i265,role=[use(none,in_hierarchy,usr('Food_crops_ini_rel'),1)]],[course=[[ 228.33188, 843.61128],[ 157.05658, 814.70245],[ 61.534207, 778.73898]]]).
arc(arc01760,node01399,node01556,influence,[complete=true,name=i260],[course=[[ 56.357296, 768.82611],[ 110.38744, 555.58511],[ -4.0, 412.27607]]]).
arc(arc01749,node01557,node01556,influence,[name=i257],[]).
arc(arc01758,node01560,node01555,influence,[complete=true,name=i266,role=[use(none,in_hierarchy,usr('PC_ini_rel'),1)]],[course=[[ 228.28104, 849.12036],[ 166.73192, 872.7711],[ 59.98914, 912.36288]]]).
arc(arc01766,node01400,node01560,influence,[complete=true,name=i264],[course=[[ 45.763464, 917.10407],[ -1.335868, 931.45593],[ -4.0, 989.43962]]]).
arc(arc01753,node01561,node01560,influence,[name=i261],[]).
arc(arc00788,node00494,node00489,influence,[name=i72],[]).
arc(arc01044,node00496,node00132,influence,[complete=true,name=i103],[course=[[ 1072.1214, 1789.9311],[ 1105.5575, 1749.5772],[ 1133.4062, 1685.1155]]]).
arc(arc00729,node00511,node00491,influence,[complete=true,name=i88],[course=[[ 1041.4388, 385.84426],[ 962.2747000000001, 112.93688],[ 725.31029, -9.0000658]]]).
arc(arc00911,node00578,node00496,influence,[name=i91],[]).
arc(arc01155,node00605,node00132,influence,[complete=true,name=i146],[course=[[ 1072.1214, 1787.668],[ 1176.3603, 1799.6917],[ 1267.0894, 1810.1384]]]).
arc(arc01094,node00606,node00605,influence,[name=i122],[]).
arc(arc01097,node00607,node00605,influence,[complete=true,name=i123],[course=[[ 1278.1701, 1804.4332],[ 1788.7955, 881.2008499999999],[ 1279.988, -9.0000441]]]).
arc(arc01157,node00610,node00132,influence,[complete=true,name=i151],[course=[[ 1072.1214, 1784.5373],[ 1172.2899, 1768.4383],[ 1269.1456, 1750.9882]]]).
arc(arc01100,node00611,node00610,influence,[name=i132],[]).
arc(arc01111,node00612,node00610,influence,[complete=true,name=i133],[course=[[ 1280.1622, 1743.0984],[ 1783.4005, 835.05822],[ 1282.5017, -9.0000441]]]).
arc(arc01153,node00617,node00132,influence,[complete=true,name=i144],[course=[[ 1072.1214, 1786.8965],[ 1176.061, 1841.2944],[ 1276.9478, 1882.8282]]]).
arc(arc01139,node00618,node00617,influence,[name=i134],[]).
arc(arc01149,node00619,node00617,influence,[complete=true,name=i136],[course=[[ 1286.6463, 1878.7109],[ 1680.3526, 885.2797],[ 1083.5868, -9.0000441]]]).
arc(arc01159,node00623,node00132,influence,[complete=true,name=i153],[course=[[ 1072.1214, 1787.668],[ 1164.2959, 1744.0648],[ 1263.3632, 1686.7433]]]).
arc(arc01150,node00624,node00623,influence,[name=i139],[]).
arc(arc01151,node00643,node00623,influence,[complete=true,name=i142],[course=[[ 1273.1972, 1676.2731],[ 1719.5895, 779.59803],[ 1195.2245, -9.0000441]]]).
arc(arc01168,node00132,node00709,influence,[complete=true,name=i48],[course=[[ 451.74466, 2792.524],[ 438.744, 2785.7423],[ 409.07606, 2770.5395]]]).
arc(arc01180,node00132,node00718,influence,[complete=true,name=i100],[course=[[ 0.92610211, 2638.6868],[ 42.29639, 2637.5437],[ 74.523695, 2637.9529]]]).
arc(arc00275,node00947,node00491,influence,[complete=true,name=i167],[course=[[ 1041.4388, 526.45107],[ 666.67681, 34.166228],[ 83.285937, 13.863999]]]).
arc(arc00262,node01007,node00277,influence,[complete=true,name=i41],[course=[[ -1.8421432, 628.07617],[ 94.959098, 625.12371],[ 132.52091, 628.76536]]]).
arc(arc00525,node01007,node00294,influence,[complete=true,name=i28],[course=[[ -1.8421432, 921.2512400000001],[ 78.85148599999999, 921.0829],[ 132.52091, 920.31957]]]).
arc(arc00526,node01007,node00295,influence,[complete=true,name=i102],[course=[[ -1.8421432, 1030.8181],[ 431.31177, 1026.7286],[ 863.73009, 1027.7194]]]).
arc(arc00527,node01007,node00296,influence,[complete=true,name=i109],[course=[[ 1356.7434, 2785.3449],[ 1508.404, 1839.379],[ 778.4100100000001, 1027.7194]]]).
arc(arc00536,node01007,node00299,influence,[complete=true,name=i9],[course=[[ -1.8421432, 705.0500500000001],[ 65.21265, 720.68963],[ 132.52091, 735.7342]]]).
arc(arc00540,node01007,node00300,influence,[complete=true,name=i8],[course=[[ -1.8421432, 836.18398],[ 70.730823, 837.0723400000001],[ 132.52091, 831.89359]]]).
arc(arc00548,node00302,node01007,influence,[complete=true,name=i39],[course=[[ 133.24269, 976.86802],[ 22.447163, 975.95298],[ -1.8421432, 976.43299]]]).
arc(arc00549,node00303,node01007,influence,[name=i25],[course=[[ 384.49112, 546.59168],[ 368.32468, 200.24469],[ 88.932699, 11.164475]]]).
arc(arc00550,node00304,node01007,influence,[complete=true,name=i11],[course=[[ 443.66831, 1027.7194],[ 269.51642, 1025.831],[ -1.8421432, 1030.0097]]]).
arc(arc00551,node00305,node01007,influence,[complete=true,name=i7],[course=[[ 132.52091, 816.96266],[ 52.447397, 816.95571],[ -1.8421432, 817.5437899999999]]]).
arc(arc00552,node00306,node01007,influence,[complete=true,name=i68],[course=[[ 256.27586, 546.59168],[ 330.19541, 233.49648],[ 133.50794, -3.6159923]]]).
arc(arc00553,node00307,node01007,influence,[complete=true,name=i106],[course=[[ 702.52138, 546.59168],[ 852.4807, 234.00297],[ 729.1442, -9.0000441]]]).
arc(arc00554,node00308,node01007,influence,[complete=true,name=i16],[course=[[ 132.52091, 817.34112],[ 51.216831, 792.33897],[ -1.8421432, 773.4039]]]).
arc(arc00632,node00491,node01007,influence,[complete=true,name=i22],[course=[[ 861.5838, 546.59168],[ 960.06912, 623.8046399999999],[ 1041.4388, 618.1839199999999]]]).
arc(arc00687,node01007,node00385,influence,[complete=true,name=i32],[course=[[ 1145.6766, 1858.69],[ 1122.1786, 1365.3589],[ 919.41916, 1027.7194]]]).
arc(arc00910,node01007,node00489,influence,[complete=true,name=i75],[course=[[ 1131.7762, 1619.8999],[ 1146.318, 1257.4799],[ 1022.5897, 1004.2754]]]).
arc(arc00930,node01007,node00491,influence,[complete=true,name=i168],[course=[[ 1041.4388, 918.88582],[ 1030.5674, 850.50206],[ 1022.5897, 784.44903]]]).
arc(arc01083,node01007,node00491,influence,[complete=true,name=i137],[course=[[ 1041.4388, 639.33953],[ 847.18623, 501.32323],[ 660.68165, 546.59168]]]).
arc(arc01261,node01007,node00491,influence,[complete=true,name=i194],[course=[[ 1041.4388, 853.07917],[ 1030.8964, 787.80159],[ 1022.5897, 724.85474]]]).
arc(arc01269,node00491,node01007,influence,[complete=true,name=i108],[course=[[ 1022.5897, 623.8049099999999],[ 1031.9781, 685.16183],[ 1041.4388, 744.18801]]]).
arc(arc00004,node00004,arc00002,influence,[name=i4],[]).
arc(arc00006,node00009,node00008,influence,[name=i7],[]).
arc(arc00011,node00005,node00009,influence,[complete=true,name=i11,role=[use(none,in_hierarchy,protected_abs_GFC,1)]],[course=[[ 387.4421, 164.55332],[ 447.5811, 177.12207],[ 548.6097, 213.21979]]]).
arc(arc00003,node00024,node00005,influence,[name=i6],[]).
arc(arc00044,node00035,node00034,influence,[name=i14],[]).
arc(arc00269,node00005,node00035,influence,[complete=true,name=i57,role=[use(none,in_hierarchy,usr(protected_abs),1)]],[course=[[ 73.807143, 382.94224],[ 363.55503, 361.20028],[ 549.76379, 220.07245]]]).
arc(arc00051,node00034,node00040,influence,[complete=true,name=i27],[course=[[ -1.1776089e-13, 387.1207],[ 46.977734, 383.72686],[ 58.827365, 383.57849]]]).
arc(arc00131,node00112,node00110,influence,[name=i16],[]).
arc(arc00132,node00113,node00110,influence,[name=i24],[course=[[ 421.70627, 236.90774],[ 430.74123, 100.13835],[ 325.05124, 0.0]]]).
arc(arc00209,node00127,node00009,influence,[complete=true,name=i28,role=[use(none,in_hierarchy,coef_remove_0,1)]],[course=[[ 373.91122, 158.78344],[ 333.01176, 130.79533],[ 292.23348, 101.17631]]]).
arc(arc00229,node00192,node00035,influence,[complete=true,name=i13,role=[use(none,in_hierarchy,usr('GFC_rent_thr'),1)]],[course=[[ 61.893023, 377.43546],[ 32.465254, 337.28618],[ -1.1776089e-13, 280.05992]]]).
arc(arc00026,node00197,node00024,influence,[complete=true,name=i9,role=[use(none,in_hierarchy,protected_rel,1)]],[course=[[ 562.95494, 213.49055],[ 663.51951, 184.88871],[ 756.28142, 153.38727]]]).
arc(arc00155,node00197,node00063,influence,[complete=true,name=i50],[course=[[ 757.4126, 498.36928],[ 755.0839, 382.67942],[ 756.28142, 257.3523]]]).
arc(arc00027,node00006,node00199,influence,[complete=true,name=i9,role=[use(none,in_hierarchy,protected_rel,1)]],[course=[[ -1.882745e-06, 79.927526],[ 34.603152, 71.239026],[ 64.844746, 58.144045]]]).
arc(arc00045,node00120,node01037,influence,[complete=true,name=i49,role=[use(none,in_hierarchy,usr(rent_grass),1)]],[course=[[ -1.882745e-06, 183.89256],[ 30.820236, 152.22696],[ 69.25690400000001, 114.22407]]]).
arc(arc00363,node01039,node00271,influence,[complete=true,name=i50],[course=[[ 133.12911, 178.90767],[ 146.31197, 71.46977099999999],[ 77.36610899999999, -7.6420101]]]).
arc(arc01315,node01154,node01038,influence,[complete=true,name=i155],[course=[[ -1.8827449e-06, 291.63262],[ 42.850199, 296.81813],[ 85.43295000000001, 303.28197]]]).
arc(arc01311,node01155,node01154,influence,[name=i146],[]).
arc(arc01312,node01156,node01154,influence,[complete=true,name=i147],[course=[[ 95.03105600000001, 292.07629],[ 162.53517, 123.75625],[ 85.16648000000001, -47.027342]]]).
arc(arc01336,node01164,node01073,influence,[complete=true,name=i178],[course=[[ -1.8827449e-06, 293.70551],[ 25.846371, 321.30337],[ 46.815007, 346.76384]]]).
arc(arc01322,node01165,node01164,influence,[name=i162],[]).
arc(arc01325,node01168,node01164,influence,[complete=true,name=i167],[course=[[ 55.609622, 344.20007],[ 138.45529, 141.81131],[ 36.539129, -47.027342]]]).
arc(arc00238,node01039,node01564,influence,[complete=true,name=i42],[course=[[ -1.8827449e-06, -0.03607374],[ 40.656884, -6.5940353],[ 64.73071, -12.769808]]]).
arc(arc01801,node01614,node01618,influence,[complete=true,name=i72],[course=[[ -1.8827449e-06, 182.75375],[ 35.896092, 174.82012],[ 67.493307, 173.61302]]]).
arc(arc01803,node01615,node01622,influence,[complete=true,name=i74],[course=[[ -1.8827448e-06, 183.61557],[ 36.128662, 214.72467],[ 65.753638, 233.91216]]]).
arc(arc00012,node00200,node00127,influence,[name=i17],[]).
arc(arc00137,node00202,node00127,influence,[complete=true,name=i18],[course=[[ 293.26983, 94.920804],[ 461.9745, 99.556873],[ 601.5888200000001, -2.9293758e-06]]]).
arc(arc00278,node00215,node00035,influence,[complete=true,name=i103,role=[use(none,in_hierarchy,usr(scenario),int)]],[course=[[ 73.48724300000001, 381.2535],[ 148.84271, 357.03918],[ 225.58637, 322.23921]]]).
arc(arc00250,node00216,node00215,influence,[name=i51],[]).
arc(arc00251,node00217,node00215,influence,[complete=true,name=i52],[course=[[ 227.43482, 313.53572],[ 83.596045, 150.85647],[ 43.141354, 2.8084386]]]).
arc(arc00264,node00232,node00231,influence,[name=i40],[]).
arc(arc00265,node00197,node00232,influence,[complete=true,name=i41,role=[use(none,in_hierarchy,'GFC_ini_rel',1)]],[course=[[ 695.84866, 445.12978],[ 726.62789, 268.93544],[ 756.28142, 73.42367400000001]]]).
arc(arc01316,node00197,node00232,influence,[complete=true,name=i156,role=[use(none,in_hierarchy,'High_risks_floodable_areas',1)]],[course=[[ 699.29589, 446.70388],[ 731.16197, 407.59964],[ 756.28142, 365.09237]]]).
arc(arc01337,node00197,node00232,influence,[complete=true,name=i179,role=[use(none,in_hierarchy,'Medium_risks_floodable_areas',1)]],[course=[[ 699.5131699999999, 446.88792],[ 734.20037, 407.47656],[ 756.28142, 367.16525]]]).
arc(arc00261,node00008,node00237,influence,[complete=true,name=i37],[course=[[ -1.1368684e-13, 85.118432],[ 119.97176, 106.45564],[ 372.77198, 161.42542]]]).
arc(arc01274,node00365,node00004,influence,[complete=true,name=i113,role=[use(none,in_hierarchy,diff_GFC,1)]],[course=[[ 448.54661, 94.69076],[ 448.66465, 264.60195],[ 449.15105, 437.68309]]]).
arc(arc00343,node00366,node00365,influence,[name=i56],[]).
arc(arc00924,node00197,node00471,influence,[complete=true,name=i63],[course=[[ 921.96506, 246.38114],[ 905.46669, 241.23565],[ 889.41053, 252.36742]]]).
arc(arc00639,node00231,node00477,influence,[complete=true,name=i31],[course=[[ 815.0973300000001, 498.36928],[ 778.7233199999999, 459.65673],[ 699.476, 458.18038]]]).
arc(arc00002,node00512,node00003,flow,[complete=true,name='GFC decline'],[bowtie=[ 442.28793, 69.69076, 454.78793, 94.69076],caption_offset=[0,0],course=[[ 366.50099, 82.19076],[ 530.57487, 82.19076]]]).
arc(arc00008,node00512,node00009,influence,[complete=true,name=i8,role=[use(none,in_hierarchy,'GFC_abs',1)]],[course=[[ 387.04801, 160.19321],[ 446.81444, 130.35331],[ 530.57487, 92.66051]]]).
arc(arc00354,node00512,node00366,influence,[complete=true,name=i60,role=[use(none,in_hierarchy,'GFC_abs',1)]],[course=[[ 452.11349, 438.2839],[ 504.94469, 279.25614],[ 547.07555, 98.660364]]]).
arc(arc01072,node00513,node00512,influence,[name=i132],[]).
arc(arc00636,node00547,node00024,influence,[complete=true,name=i139,role=[use(none,in_hierarchy,surface,1)]],[course=[[ 563.0646400000001, 213.92519],[ 611.85239, 182.49083],[ 645.54282, 157.58476]]]).
arc(arc00614,node00548,node00547,influence,[name=i53],[]).
arc(arc00615,node00549,node00547,influence,[complete=true,name=i54],[course=[[ 646.79149, 147.34879],[ 547.3381000000001, 76.705623],[ 507.69901, 0.0]]]).
arc(arc01082,node00512,node00561,influence,[complete=true,name=i136],[course=[[ 547.08777, -2.9293758e-06],[ 549.36152, 16.361159],[ 570.57487, 74.619331]]]).
arc(arc01252,node00858,node00035,influence,[complete=true,name=i34,role=[use(none,in_hierarchy,usr(rent_grass_bis),1)]],[course=[[ 73.79487399999999, 382.79354],[ 323.34521, 359.70218],[ 565.91041, 281.41683]]]).
arc(arc01031,node00956,node00858,influence,[name=i26],[]).
arc(arc01055,node00197,node00956,influence,[complete=true,name=i32,role=[use(none,in_hierarchy,rent_grass_2000_2030,1)]],[course=[[ 580.51158, 278.36623],[ 693.05566, 267.08423],[ 756.28142, 257.3523]]]).
arc(arc01256,node00197,node00956,influence,[complete=true,name=i35,role=[use(none,in_hierarchy,'High_risks_floodable_areas',1)]],[course=[[ 579.8375, 282.30692],[ 655.95381, 317.82319],[ 756.28142, 365.09237]]]).
arc(arc01257,node00197,node00956,influence,[complete=true,name=i36,role=[use(none,in_hierarchy,'Medium_risks_floodable_areas',1)]],[course=[[ 579.97118, 282.00531],[ 663.69242, 316.71419],[ 756.28142, 367.16525]]]).
arc(arc01802,node00197,node00956,influence,[complete=true,name=i73,role=[use(none,in_hierarchy,rent_grass_2031_2060,1)]],[course=[[ 580.51259, 278.37634],[ 667.99987, 269.73682],[ 756.28142, 256.21349]]]).
arc(arc01804,node00197,node00956,influence,[complete=true,name=i75,role=[use(none,in_hierarchy,rent_grass_2061_2080,1)]],[course=[[ 580.5096, 278.34684],[ 651.07286, 271.10889],[ 756.28142, 257.07531]]]).
arc(arc00025,node00215,node01044,influence,[complete=true,name=i5,role=[use(none,in_hierarchy,usr(scenario),int)]],[course=[[ 314.53615, 281.14691],[ 277.33799, 299.43604],[ 239.28513, 316.12893]]]).
arc(arc00205,node00180,node01044,influence,[complete=true,name=i10,role=[use(none,in_hierarchy,usr(rent_min_grasslands),1)]],[course=[[ 321.30049, 285.33767],[ 321.78358, 392.33753],[ 322.29759, 498.36928]]]).
arc(arc00226,node00185,node01044,influence,[complete=true,name=i1,role=[use(none,in_hierarchy,usr('GFC_rent_thr'),1)]],[course=[[ 313.76978, 278.05494],[ 170.74283, 282.19854],[ -8.8320667e-14, 280.05992]]]).
arc(arc00366,node00110,node01044,influence,[complete=true,name=i55,role=[use(none,in_hierarchy,usr(k_GFC),1)]],[course=[[ 328.41012, 275.55289],[ 373.82213, 261.02776],[ 413.74135, 246.86212]]]).
arc(arc01035,node01044,node01043,influence,[name=i21],[]).
arc(arc01246,node00858,node01044,influence,[complete=true,name=i33,role=[use(none,in_hierarchy,usr(rent_grass_bis),1)]],[course=[[ 328.76641, 277.89573],[ 438.08141, 278.74085],[ 565.54936, 279.09688]]]).
arc(arc00224,node00008,node01046,influence,[complete=true,name=i30,role=[use(none,in_hierarchy,'GFC_adjusted',1)]],[course=[[ 163.99398, 197.36826],[ 273.25413, 174.67513],[ 372.64496, 163.83238]]]).
arc(arc00339,node00005,node01046,influence,[complete=true,name=i48,role=[use(none,in_hierarchy,protected_abs_GFC,1)]],[course=[[ 164.15069, 198.88112],[ 355.12486, 198.56728],[ 548.26775, 214.90994]]]).
arc(arc01036,node01046,node01045,influence,[name=i23],[]).
arc(arc01037,node01043,node01046,influence,[complete=true,name=i25,role=[use(none,in_hierarchy,usr(weight),1)]],[course=[[ 163.47121, 202.01284],[ 249.95119, 241.56481],[ 314.26243, 275.15611]]]).
arc(arc00046,node01050,node00035,influence,[complete=true,name=i20,role=[use(none,in_hierarchy,usr('GFC_surface_abs_ite1'),1)]],[course=[[ 72.10656899999999, 378.70504],[ 102.7682, 353.34971],[ 126.38546, 316.11053]]]).
arc(arc00020,node01045,node01051,influence,[complete=true,name=i19,role=[use(none,in_hierarchy,usr(modifiable_surface),1)]],[course=[[ 135.86215, 304.60955],[ 141.02791, 263.53456],[ 154.88879, 206.18356]]]).
arc(arc00220,node00008,node01051,influence,[complete=true,name=i29,role=[use(none,in_hierarchy,'GFC_adjusted',1)]],[course=[[ 137.46568, 307.12739],[ 235.78106, 243.93591],[ 373.55882, 166.68691]]]).
arc(arc01042,node01051,node01050,influence,[name=i58],[]).
arc(arc00353,node01052,node00366,influence,[complete=true,name=i59,role=[use(none,in_hierarchy,'GFC_surface_abs_ite2',1)]],[course=[[ 441.67223, 445.2225],[ 306.53895, 445.93304],[ 141.64449, 445.93119]]]).
arc(arc00047,node00034,node01053,influence,[complete=true,name=i22,role=[use(none,in_hierarchy,modifiable_surface_bis,1)]],[course=[[ 129.03652, 440.43941],[ 110.33893, 415.65241],[ 72.38187600000001, 387.91016]]]).
arc(arc00059,node00046,node01053,influence,[complete=true,name=i38,role=[use(none,in_hierarchy,change_coef_bis,1)]],[course=[[ 126.64656, 445.755],[ 101.78396, 445.17107],[ 0.7476471099999999, 445.6956]]]).
arc(arc01046,node01053,node01052,influence,[name=i46],[]).
arc(arc01047,node01050,node01053,influence,[complete=true,name=i47,role=[use(none,in_hierarchy,'GFC_surface_abs_ite1',1)]],[course=[[ 133.85729, 438.4366],[ 131.49011, 376.66378],[ 130.41569, 317.31656]]]).
arc(arc01048,node01045,node01054,influence,[complete=true,name=i12],[course=[[ -1.1368684e-13, 195.92058],[ 80.783095, 195.09031],[ 149.16011, 198.51796]]]).
arc(arc01050,node01050,node01056,influence,[complete=true,name=i65],[course=[[ -1.7664133e-13, 295.52591],[ 89.920371, 301.37201],[ 123.0657, 308.58839]]]).
arc(arc01051,node01057,node01051,influence,[complete=true,name=i15,role=[use(none,in_hierarchy,usr('Change_coefficient'),1)]],[course=[[ 123.06255, 308.60751],[ 45.020834, 294.14851],[ -1.1776089e-13, 280.45194]]]).
arc(arc01272,node01092,node01046,influence,[complete=true,name=i111,role=[use(none,in_hierarchy,'GFC_to_keep_outside_pro_areas',1)]],[course=[[ 150.31347, 194.88228],[ 106.1438, 166.92492],[ 62.172685, 129.15945]]]).
arc(arc01273,node01092,node00035,influence,[complete=true,name=i112,role=[use(none,in_hierarchy,usr(area_to_keep_GFC),1)]],[course=[[ 66.184603, 375.98593],[ 62.828964, 199.00004],[ 64.67756900000001, 129.40132]]]).
arc(arc01270,node01093,node01092,influence,[name=i109],[]).
arc(arc01271,node01099,node01092,influence,[complete=true,name=i110],[course=[[ 71.63549500000001, 121.98551],[ 495.02941, 310.55455],[ 921.96506, 87.92003800000001]]]).
arc(arc01260,node00005,node01119,influence,[complete=true,name=i193],[course=[[ 921.96506, 184.65124],[ 739.34011, 83.489805],[ 563.2381, 215.3324]]]).
arc(arc01313,node01157,node00197,influence,[complete=true,name=i148],[course=[[ 841.4479, 26.432407],[ 844.37369, 14.314251],[ 825.26564, -2.9293758e-06]]]).
arc(arc00081,node01159,node00956,influence,[complete=true,name=i39,role=[use(none,in_hierarchy,rent_min_grasslands,1)]],[course=[[ 567.24776, 283.87084],[ 519.34495, 323.54219],[ 322.29759, 498.36928]]]).
arc(arc01326,node01169,node00197,influence,[complete=true,name=i168],[course=[[ 792.82055, 26.432407],[ 797.6463199999999, 12.325034],[ 789.25588, -2.9293758e-06]]]).
arc(arc01433,node01258,node00513,influence,[complete=true,name=i172,role=[use(none,in_hierarchy,usr('GFC_ini_abs'),1)]],[course=[[ 570.57487, 75.012024],[ 615.72999, 55.486184],[ 646.84459, 38.721]]]).
arc(arc01430,node01259,node01258,influence,[name=i169],[]).
arc(arc01431,node00197,node01259,influence,[complete=true,name=i170,role=[use(none,in_hierarchy,'GFC_ini_rel',1)]],[course=[[ 660.56579, 37.524491],[ 721.5967000000001, 57.766871],[ 756.28142, 73.42367400000001]]]).
arc(arc01432,node00547,node01259,influence,[complete=true,name=i171,role=[use(none,in_hierarchy,surface,1)]],[course=[[ 652.76169, 42.632027],[ 650.77071, 64.325975],[ 651.50594, 145.62663]]]).
arc(arc01434,node01258,node01261,influence,[complete=true,name=i173],[course=[[ 5.9896021, 35.643147],[ 354.95265, 34.498348],[ 645.9471600000001, 35.143285]]]).
arc(arc00266,node01390,node00232,influence,[complete=true,name=i43,role=[use(none,in_hierarchy,'GFC_surface_rel',1)]],[course=[[ 691.31994, 445.75294],[ 681.36916, 424.96399],[ 676.09821, 417.26056]]]).
arc(arc00335,node01390,node00331,influence,[complete=true,name=i44],[course=[[ 669.0350100000001, 498.36928],[ 692.84379, 457.64327],[ 676.09821, 417.26056]]]).
arc(arc00400,node00512,node01390,influence,[complete=true,name=i62,role=[use(none,in_hierarchy,usr('GFC_abs'),1)]],[course=[[ 670.70029, 346.71955],[ 618.71011, 227.53161],[ 557.67864, 98.660365]]]).
arc(arc00637,node00547,node01390,influence,[complete=true,name=i140,role=[use(none,in_hierarchy,usr(surface),1)]],[course=[[ 673.55399, 346.71955],[ 661.65894, 261.73655],[ 652.2672, 160.59419]]]).
arc(arc01032,node01041,node01040,influence,[name=i2],[]).
arc(arc01229,node01040,node01391,influence,[complete=true,name=i43,role=[use(none,in_hierarchy,'GFC_surface_rel',1)]],[course=[[ 115.23616, 70.54101199999999],[ 113.1238, 61.606561],[ 111.5758, 46.763373]]]).
arc(arc01236,node01398,node01041,influence,[complete=true,name=i62,role=[use(none,in_hierarchy,usr('GFC_abs'),1)]],[course=[[ 109.99612, 31.901816],[ 109.47179, 6.267211],[ 109.83824, 0.0]]]).
arc(arc01370,node01404,node01041,influence,[complete=true,name=i140,role=[use(none,in_hierarchy,usr(surface),1)]],[course=[[ 110.64658, 31.916738],[ 111.04781, 3.0169707],[ 112.69194, -5.6843419e-14]]]).
arc(arc01593,node01258,node01425,influence,[complete=true,name=i61],[course=[[ -8.8320667e-14, 161.20842],[ 354.16153, 235.2038],[ 646.1353, 36.832882]]]).
arc(arc01805,node00197,node01619,influence,[complete=true,name=i76],[course=[[ 756.4827299999999, 498.36928],[ 754.4451299999999, 469.36785],[ 756.28142, 256.21349]]]).
arc(arc01809,node00197,node01623,influence,[complete=true,name=i81],[course=[[ 756.37938, 498.36928],[ 757.1957, 463.92034],[ 756.28142, 257.07531]]]).
arc(arc00218,node00491,node01008,influence,[complete=true,name=i50],[course=[[ 870.33127, 508.95818],[ 928.56115, 662.5872900000001],[ 1041.4388, 737.7564599999999]]]).
arc(arc00257,node01008,node00336,influence,[complete=true,name=i52],[course=[[ -1.8421432, 510.70063],[ 402.95564, 508.44349],[ 817.59932, 508.95818]]]).
arc(arc00268,node01008,node00011,influence,[complete=true,name=i13],[course=[[ 1149.6292, 1918.7107],[ 1219.0132, 1139.8759],[ 850.95758, 508.95818]]]).
arc(arc00271,node00209,node01008,influence,[complete=true,name=i38],[course=[[ 140.16548, 301.1679],[ 86.448307, 299.48966],[ -1.8421432, 300.71467]]]).
arc(arc00352,node00310,node01008,influence,[complete=true,name=i51],[course=[[ 430.92485, 508.95818],[ 202.78422, 508.24606],[ -1.8421432, 510.43719]]]).
arc(arc00428,node00389,node01008,influence,[complete=true,name=i65],[course=[[ 140.16548, 301.67296],[ 5.2237862, 297.27795],[ -1.8421432, 301.46122]]]).
arc(arc00453,node01008,node00472,influence,[complete=true,name=i94],[course=[[ -1.8421432, 320.52986],[ 68.06787199999999, 324.5618],[ 140.16548, 320.01545]]]).
arc(arc00559,node01008,node00313,influence,[complete=true,name=i104],[course=[[ 1355.6914, 2785.6092],[ 1594.5361, 1558.7842],[ 692.21387, 508.95818]]]).
arc(arc00565,node00318,node01008,influence,[complete=true,name=i4],[course=[[ 278.46807, 33.064072],[ 305.84857, 3.7872232],[ 316.69703, -9.0000441]]]).
arc(arc00607,node01008,node00183,influence,[complete=true,name=i53],[course=[[ -1.8421432, 381.5329],[ 68.06440600000001, 389.83528],[ 140.16548, 395.23442]]]).
arc(arc00608,node00338,node01008,influence,[complete=true,name=i99],[course=[[ 218.33894, 33.064072],[ 249.18422, 8.5696642],[ 263.49745, -9.0000441]]]).
arc(arc00613,node00339,node01008,influence,[complete=true,name=i110],[course=[[ 581.8592599999999, 33.064072],[ 667.02414, 8.659501300000001],[ 735.65699, -9.0000441]]]).
arc(arc00699,node01008,node00487,influence,[complete=true,name=i70],[course=[[ 1135.3163, 1722.3848],[ 1270.0865, 1085.4686],[ 991.80448, 508.95818]]]).
arc(arc00711,node01008,node00491,influence,[complete=true,name=i81],[course=[[ 1041.4388, 337.68048],[ 1028.3485, 272.73032],[ 995.19012, 223.81068]]]).
arc(arc01022,node00491,node01008,influence,[complete=true,name=i163],[course=[[ 982.71773, 485.9176],[ 1005.4676, 563.18411],[ 1041.4388, 618.1839199999999]]]).
arc(arc01070,node01008,node00954,influence,[complete=true,name=i166],[course=[[ 6.7323648, 120.99903],[ 74.604657, 119.83648],[ 140.16548, 121.44569]]]).
arc(arc01264,node01008,node00491,influence,[complete=true,name=i197],[course=[[ 1041.4388, 598.9088400000001],[ 1012.3005, 532.20897],[ 980.06751, 489.10091]]]).
arc(arc01327,node01008,node01007,influence,[complete=true,name=i169],[course=[[ 894.47172, 546.59168],[ 902.49449, 527.08213],[ 891.70051, 508.95818]]]).
arc(arc01752,node01008,node00491,influence,[complete=true,name=i260],[course=[[ 1041.4388, 520.19624],[ 1022.0725, 457.35807],[ 995.19012, 410.55041]]]).
arc(arc00001,node00016,node00015,influence,[name=i2],[]).
arc(arc00557,node00017,node00016,influence,[complete=true,name=i100,role=[use(none,in_hierarchy,usr(protected_abs),1)]],[course=[[ 65.544746, 367.46933],[ 390.35902, 340.53279],[ 537.21118, 220.19498]]]).
arc(arc00023,node00018,node00017,influence,[name=i14],[]).
arc(arc00417,node00020,node00016,influence,[complete=true,name=i17,role=[use(none,in_hierarchy,usr(rent_crop_bis),1)]],[course=[[ 65.540226, 367.41705],[ 367.83049, 340.21769],[ 533.45692, 279.55714]]]).
arc(arc00079,node00065,node00062,influence,[name=i1],[]).
arc(arc00085,node00067,node00062,influence,[complete=true,name=i3],[course=[[ 388.81075, 252.29444],[ 336.14002, 89.798807],[ 187.45533, 4.3076653e-14]]]).
arc(arc00556,node00129,node00016,influence,[complete=true,name=i99,role=[use(none,in_hierarchy,usr(area_to_keep_FC),1)]],[course=[[ 58.041023, 360.58923],[ 57.324528, 177.68896],[ 57.733068, 152.11001]]]).
arc(arc00033,node00174,node00018,influence,[complete=true,name=i15,role=[use(none,in_hierarchy,protected_crop_rel,1)]],[course=[[ 550.2195400000001, 213.36643],[ 636.05259, 188.65635],[ 684.79713, 179.14126]]]).
arc(arc00032,node00001,node00021,influence,[complete=true,name=i13],[course=[[ -3.4337044e-06, 121.67823],[ 35.066298, 98.559189],[ 66.893511, 74.125671]]]).
arc(arc00244,node00013,node00316,influence,[complete=true,name=i1],[course=[[ -3.4337044e-06, 198.39572],[ 39.800302, 167.94048],[ 64.415745, 145.7301]]]).
arc(arc01319,node01131,node00342,influence,[complete=true,name=i159],[course=[[ -3.4337045e-06, 292.03194],[ 33.938122, 297.92463],[ 82.933471, 300.66074]]]).
arc(arc01295,node01132,node01131,influence,[name=i22],[]).
arc(arc01297,node01134,node01131,influence,[complete=true,name=i24],[course=[[ 94.58098200000001, 294.83782],[ 173.61968, 139.64036],[ 114.83174, -31.568186]]]).
arc(arc01334,node01162,node00350,influence,[complete=true,name=i176],[course=[[ -3.4337045e-06, 292.03194],[ 25.355853, 320.22551],[ 42.601757, 345.67473]]]).
arc(arc01323,node01162,node01166,influence,[complete=true,name=i163],[course=[[ 74.379328, 409.13079],[ 74.53455700000001, 382.0473],[ 51.518788, 356.87742]]]).
arc(arc01243,node01064,node01248,influence,[complete=true,name=i72],[course=[[ -3.4337044e-06, -2.916351],[ 46.192374, 0.72559522],[ 62.978938, 3.6932687]]]).
arc(arc00442,node00945,node01540,influence,[complete=true,name=i2],[course=[[ -3.4337045e-06, 200.93048],[ 35.255271, 194.66411],[ 61.40739, 195.97294]]]).
arc(arc01750,node01064,node01558,influence,[complete=true,name=i258],[course=[[ 135.72654, 276.70856],[ 163.25675, 127.91214],[ 75.191957, 10.738694]]]).
arc(arc00881,node01295,node01610,influence,[complete=true,name=i31],[course=[[ -3.4337044e-06, 197.59914],[ 20.21357, 228.78711],[ 43.017027, 247.54503]]]).
arc(arc00215,node00177,node00129,influence,[name=i37],[]).
arc(arc00217,node00178,node00129,influence,[complete=true,name=i39],[course=[[ 65.160251, 149.32435],[ 366.37309, 378.1018],[ 763.98681, 481.31311]]]).
arc(arc00558,node00015,node00179,influence,[complete=true,name=i9],[course=[[ -4.0078297e-06, 366.29438],[ 27.76605, 368.24008],[ 50.570496, 368.12652]]]).
arc(arc00560,node00219,node00016,influence,[complete=true,name=i102,role=[use(none,in_hierarchy,usr(scenario),int)]],[course=[[ 65.51693, 367.19517],[ 157.04647, 356.20648],[ 227.81568, 318.24682]]]).
arc(arc00221,node00220,node00189,influence,[name=i8],[]).
arc(arc01251,node00174,node00220,influence,[complete=true,name=i122,role=[use(none,in_hierarchy,'Food_crops_ini_rel',1)]],[course=[[ 637.09475, 421.73123],[ 652.22556, 322.75106],[ 684.79713, 54.546689]]]).
arc(arc01320,node00174,node00220,influence,[complete=true,name=i160,role=[use(none,in_hierarchy,'High_risks_floodable_areas',1)]],[course=[[ 639.95374, 422.79599],[ 664.26812, 384.12809],[ 684.79713, 349.49497]]]).
arc(arc01335,node00174,node00220,influence,[complete=true,name=i177,role=[use(none,in_hierarchy,'Medium_risks_floodable_areas',1)]],[course=[[ 639.61592, 422.59572],[ 664.17575, 378.58115],[ 684.79713, 349.49497]]]).
arc(arc00253,node00223,node00219,influence,[name=i69],[]).
arc(arc00254,node00224,node00219,influence,[complete=true,name=i70],[course=[[ 233.24398, 322.10814],[ 136.31398, 392.68345],[ 152.61397, 481.3131]]]).
arc(arc00206,node00226,arc00162,influence,[name=i6],[]).
arc(arc00024,node00228,node00020,influence,[name=i11],[]).
arc(arc00029,node00174,node00228,influence,[complete=true,name=i12,role=[use(none,in_hierarchy,rent_crop_2000_2030,1)]],[course=[[ 547.8914, 275.75105],[ 647.86315, 257.96457],[ 684.79713, 255.85875]]]).
arc(arc00080,node00201,node00228,influence,[complete=true,name=i4,role=[use(none,in_hierarchy,rent_min_foodcrops,1)]],[course=[[ 534.82097, 281.85769],[ 391.39903, 403.84777],[ 294.07024, 481.31311]]]).
arc(arc00561,node00174,node00228,influence,[complete=true,name=i30,role=[use(none,in_hierarchy,rent_crop_2031_2060,1)]],[course=[[ 547.9010500000001, 275.81257],[ 628.65958, 261.81607],[ 684.79713, 258.39351]]]).
arc(arc00606,node00174,node00228,influence,[complete=true,name=i19,role=[use(none,in_hierarchy,'High_risks_floodable_areas',1)]],[course=[[ 547.04522, 280.58194],[ 611.88614, 315.59389],[ 684.79713, 349.49497]]]).
arc(arc00886,node00174,node00228,influence,[complete=true,name=i32,role=[use(none,in_hierarchy,rent_crop_2060_2080,1)]],[course=[[ 547.90696, 275.85207],[ 618.31642, 263.82327],[ 684.79713, 255.06218]]]).
arc(arc00949,node00174,node00228,influence,[complete=true,name=i20,role=[use(none,in_hierarchy,'Medium_risks_floodable_areas',1)]],[course=[[ 546.82464, 280.95385],[ 590.40085, 307.64668],[ 684.79713, 349.49497]]]).
arc(arc00247,node00174,node00317,influence,[complete=true,name=i5],[course=[[ 685.14777, 481.31311],[ 684.39761, 430.73149],[ 684.79713, 255.85875]]]).
arc(arc00016,node00189,node00384,influence,[complete=true,name=i7],[course=[[ 718.88588, 481.31311],[ 702.08745, 450.84781],[ 638.36385, 436.24992]]]).
arc(arc00208,node00017,node00391,influence,[complete=true,name=i25,role=[use(none,in_hierarchy,protected_abs_FC,1)]],[course=[[ 350.80861, 184.99009],[ 445.94365, 200.80531],[ 535.59609, 214.32309]]]).
arc(arc00348,node00391,node00390,influence,[name=i38],[]).
arc(arc01247,node00475,node00226,influence,[complete=true,name=i118,role=[use(none,in_hierarchy,diff_FC,1)]],[course=[[ 424.88091, 119.11277],[ 424.4432, 258.75985],[ 425.00615, 419.93645]]]).
arc(arc00678,node00476,node00475,influence,[name=i68],[]).
arc(arc00162,node00503,node00205,flow,[complete=true,name='FC_decline'],[bowtie=[ 418.67009, 94.11277200000001, 431.17009, 119.11277],caption_offset=[0,0],course=[[ 342.86194, 106.61277],[ 506.97824, 106.61277]]]).
arc(arc00210,node00503,node00391,influence,[complete=true,name=i26,role=[use(none,in_hierarchy,'FC_abs',1)]],[course=[[ 350.11225, 181.77837],[ 472.39468, 125.04544],[ 506.97824, 112.07841]]]).
arc(arc01242,node00503,node00476,influence,[complete=true,name=i116,role=[use(none,in_hierarchy,'FC_abs',1)]],[course=[[ 427.2743, 420.25823],[ 476.27403, 263.30514],[ 522.18656, 119.57946]]]).
arc(arc00700,node00504,node00503,influence,[name=i74],[]).
arc(arc00710,node00503,node00508,influence,[complete=true,name=i79],[course=[[ 864.76079, 192.91863],[ 742.1012500000001, 41.368246],[ 546.97824, 111.12804]]]).
arc(arc00034,node00550,node00018,influence,[complete=true,name=i16,role=[use(none,in_hierarchy,surface,1)]],[course=[[ 549.24557, 211.27046],[ 581.10511, 189.95252],[ 609.4358099999999, 172.20795]]]).
arc(arc00617,node00551,node00550,influence,[name=i107],[]).
arc(arc00618,node00552,node00550,influence,[complete=true,name=i108],[course=[[ 615.4587299999999, 175.71944],[ 536.50184, 326.92584],[ 529.06192, 481.3131]]]).
arc(arc01420,node00659,node00504,influence,[complete=true,name=i29,role=[use(none,in_hierarchy,usr(food_crops_ini_abs),1)]],[course=[[ 546.97824, 92.973934],[ 580.81352, 73.340131],[ 608.79105, 58.05021]]]).
arc(arc00563,node00850,node00016,influence,[complete=true,name=i103,role=[use(none,in_hierarchy,usr('FC_rent_thr'),1)]],[course=[[ 54.15676, 361.69125],[ 18.164491, 302.85203],[ -4.0078296e-06, 271.15672]]]).
arc(arc01061,node00917,node00391,influence,[complete=true,name=i164,role=[use(none,in_hierarchy,coef_remove_0,1)]],[course=[[ 338.89774, 178.86915],[ 301.10403, 136.49493],[ 284.44341, 122.37519]]]).
arc(arc01014,node00920,node00917,influence,[name=i161],[]).
arc(arc01021,node00925,node00917,influence,[complete=true,name=i162],[course=[[ 285.73389, 120.18708],[ 520.9965999999999, 388.15319],[ 864.76079, 370.19315]]]).
arc(arc01063,node00390,node00931,influence,[complete=true,name=i165],[course=[[ 0.0, 89.38802099999999],[ 114.60908, 119.85221],[ 336.25359, 182.39045]]]).
arc(arc00288,node01021,node00270,influence,[complete=true,name=i18],[course=[[ 558.33456, 481.31311],[ 587.71606, 440.80682],[ 572.93994, 392.99784]]]).
arc(arc01248,node00503,node01021,influence,[complete=true,name=i119,role=[use(none,in_hierarchy,'FC_abs',1)]],[course=[[ 618.3714, 324.12181],[ 588.02797, 231.53903],[ 534.19113, 119.57946]]]).
arc(arc01249,node00550,node01021,influence,[complete=true,name=i120,role=[use(none,in_hierarchy,surface,1)]],[course=[[ 621.33836, 324.12181],[ 606.19295, 248.49453],[ 614.90142, 175.67379]]]).
arc(arc01250,node01021,node00220,influence,[complete=true,name=i121,role=[use(none,in_hierarchy,'FC_surface_rel',1)]],[course=[[ 632.80731, 422.34058],[ 626.38804, 408.49186],[ 627.09075, 392.92686]]]).
arc(arc01178,node01080,node01023,influence,[complete=true,name=i18],[course=[[ 104.41731, 68.805059],[ 102.11657, 53.67213],[ 98.304892, 41.702912]]]).
arc(arc01073,node01081,node01080,influence,[name=i64],[]).
arc(arc01210,node01310,node01081,influence,[complete=true,name=i119,role=[use(none,in_hierarchy,'FC_abs',1)]],[course=[[ 97.111869, 27.135111],[ 100.37019, 4.8026247],[ 95.697957, 0.0]]]).
arc(arc01226,node01311,node01081,influence,[complete=true,name=i120,role=[use(none,in_hierarchy,surface,1)]],[course=[[ 96.08958199999999, 27.056781],[ 96.29329, 1.8059081],[ 98.664925, 0.0]]]).
arc(arc00259,node00208,node01069,influence,[complete=true,name=i10,role=[use(none,in_hierarchy,usr('FC_rent_thr'),1)]],[course=[[ 283.13691, 274.14617],[ 153.90171, 274.40581],[ -4.0078296e-06, 271.15672]]]).
arc(arc00349,node00309,node01069,influence,[complete=true,name=i47,role=[use(none,in_hierarchy,usr(rent_min_foodcrops),1)]],[course=[[ 291.07999, 281.61801],[ 296.88885, 379.76761],[ 294.07024, 481.31311]]]).
arc(arc00357,node00062,node01069,influence,[complete=true,name=i55,role=[use(none,in_hierarchy,usr(k_foodcrops),1)]],[course=[[ 298.00577, 272.73482],[ 342.44606, 264.31404],[ 385.97995, 259.72586]]]).
arc(arc00361,node00219,node01069,influence,[complete=true,name=i56,role=[use(none,in_hierarchy,usr(scenario),int)]],[course=[[ 284.5823, 278.55738],[ 279.33056, 282.39671],[ 241.37763, 311.88923]]]).
arc(arc00399,node00020,node01069,influence,[complete=true,name=i13,role=[use(none,in_hierarchy,usr(rent_crop_bis),1)]],[course=[[ 298.13661, 274.19614],[ 447.74662, 275.49347],[ 532.9870100000001, 276.89123]]]).
arc(arc01059,node01069,node01067,influence,[name=i21],[]).
arc(arc01215,node01070,node01024,influence,[complete=true,name=i171],[course=[[ -2.8745347e-14, 168.61206],[ 52.706199, 193.50634],[ 141.8046, 225.30276]]]).
arc(arc00219,node00390,node01071,influence,[complete=true,name=i51,role=[use(none,in_hierarchy,'FC_adjusted',1)]],[course=[[ 156.04744, 226.44105],[ 236.98101, 207.69785],[ 335.97499, 186.50488]]]).
arc(arc00222,node00017,node01071,influence,[complete=true,name=i52,role=[use(none,in_hierarchy,protected_abs_FC,1)]],[course=[[ 156.22946, 227.67827],[ 299.69202, 218.68459],[ 535.51293, 215.54126]]]).
arc(arc00231,node00129,node01071,influence,[complete=true,name=i53,role=[use(none,in_hierarchy,'FC_to_keep_outside_pro_areas',1)]],[course=[[ 142.89076, 223.45841],[ 110.23572, 197.29869],[ 64.436314, 150.13753]]]).
arc(arc00242,node01067,node01071,influence,[complete=true,name=i54,role=[use(none,in_hierarchy,weight,1)]],[course=[[ 155.97465, 230.13999],[ 208.71022, 249.49654],[ 283.45456, 271.97145]]]).
arc(arc01060,node01071,node01070,influence,[name=i23],[]).
arc(arc00447,node01076,node00468,influence,[complete=true,name=i71],[course=[[ 0.0, 290.21889],[ 59.77832, 298.4662],[ 121.51515, 308.19925]]]).
arc(arc00564,node01076,node00016,influence,[complete=true,name=i104,role=[use(none,in_hierarchy,usr('FC_surface_abs_ite1'),1)]],[course=[[ 63.64489, 363.07169],[ 102.91474, 327.72571],[ 122.7963, 313.69224]]]).
arc(arc00401,node00390,node01077,influence,[complete=true,name=i57,role=[use(none,in_hierarchy,'FC_adjusted',1)]],[course=[[ 134.99613, 304.96553],[ 216.55468, 245.84701],[ 336.54885, 188.18336]]]).
arc(arc00408,node01070,node01077,influence,[complete=true,name=i60,role=[use(none,in_hierarchy,modifiable_surface,1)]],[course=[[ 131.02246, 302.16689],[ 141.16182, 267.38215],[ 147.19194, 235.48514]]]).
arc(arc00422,node00382,node01077,influence,[complete=true,name=i63,role=[use(none,in_hierarchy,'Change_coefficient',1)]],[course=[[ 121.67924, 307.42591],[ 61.428309, 291.28019],[ -4.0078296e-06, 271.66753]]]).
arc(arc01067,node01077,node01076,influence,[name=i58],[]).
arc(arc01241,node01082,node00476,influence,[complete=true,name=i115,role=[use(none,in_hierarchy,'FC_surface_abs_ite2',1)]],[course=[[ 417.62143, 426.85768],[ 362.29817, 425.21307],[ 134.68152, 426.65335]]]).
arc(arc00913,node00914,node01083,influence,[complete=true,name=i66,role=[use(none,in_hierarchy,'Change_coef_bis',1)]],[course=[[ 119.68239, 426.80465],[ 62.106315, 427.57205],[ 0.30825041, 427.23146]]]).
arc(arc00957,node01076,node01083,influence,[complete=true,name=i112,role=[use(none,in_hierarchy,'FC_surface_abs_ite1',1)]],[course=[[ 127.91741, 419.23698],[ 130.68234, 369.3527],[ 129.14344, 316.86401]]]).
arc(arc01005,node00015,node01083,influence,[complete=true,name=i113,role=[use(none,in_hierarchy,modifiable_surface_bis,1)]],[course=[[ 121.5084, 421.7953],[ 78.935047, 386.84444],[ 63.648153, 373.10302]]]).
arc(arc01075,node01083,node01082,influence,[name=i46],[]).
arc(arc01263,node00017,node01122,influence,[complete=true,name=i196],[course=[[ 849.4659799999999, 461.22973],[ 759.43845, 265.53101],[ 548.86295, 220.13379]]]).
arc(arc01298,node01139,node00174,influence,[complete=true,name=i27],[course=[[ 799.62887, 25.894855],[ 817.13117, 15.738662],[ 805.9091100000001, 0.014317043]]]).
arc(arc01324,node00174,node01167,influence,[complete=true,name=i166],[course=[[ 760.09275, 481.31311],[ 766.90172, 473.72439],[ 759.17646, 466.59381]]]).
arc(arc00650,node01213,node00659,influence,[name=i22],[]).
arc(arc00751,node00550,node01213,influence,[complete=true,name=i24,role=[use(none,in_hierarchy,surface,1)]],[course=[[ 616.08227, 63.290948],[ 616.61864, 92.18631600000001],[ 615.87351, 160.72729]]]).
arc(arc00752,node00174,node01213,influence,[complete=true,name=i28,role=[use(none,in_hierarchy,'Food_crops_ini_rel',1)]],[course=[[ 623.43089, 55.364847],[ 644.85471, 54.14201],[ 684.79713, 54.546689]]]).
arc(arc01422,node00659,node01251,influence,[complete=true,name=i35],[course=[[ 0.14664711, 55.965905],[ 266.32262, 56.550222],[ 608.4431, 55.8085]]]).
arc(arc01464,node00659,node01301,influence,[complete=true,name=i169],[course=[[ -4.0078296e-06, 180.66703],[ 334.3965, 248.99332],[ 608.63635, 57.483881]]]).
arc(arc01751,node00174,node01559,influence,[complete=true,name=i259],[course=[[ 864.76079, 381.78477],[ 856.08478, 346.91891],[ 820.52367, 334.1716]]]).
arc(arc01456,node00174,node01607,influence,[complete=true,name=i33],[course=[[ 685.3509, 481.31311],[ 683.57118, 429.12903],[ 684.79713, 258.39351]]]).
arc(arc01797,node00174,node01611,influence,[complete=true,name=i64],[course=[[ 685.20868, 481.31311],[ 684.0112, 464.77122],[ 684.79713, 255.06218]]]).
arc(arc00223,node00491,node01016,influence,[complete=true,name=i24],[course=[[ 432.38504, 1069.6952],[ 817.9590899999999, 1123.4869],[ 1041.4388, 879.8456200000001]]]).
arc(arc00241,node01016,node00372,influence,[complete=true,name=i10],[course=[[ -1.8421432, 1129.68],[ 64.693342, 1129.8663],[ 131.72762, 1131.3682]]]).
arc(arc00619,node01016,node00341,influence,[complete=true,name=i20],[course=[[ -1.8421432, 1411.8314],[ 90.257707, 1408.9976],[ 131.72763, 1405.9656]]]).
arc(arc00628,node01016,node00343,influence,[complete=true,name=i113],[course=[[ 1353.4776, 2786.1482],[ 1355.8109, 2081.3742],[ 729.32438, 1534.1908]]]).
arc(arc00633,node00491,node01016,influence,[complete=true,name=i33],[course=[[ 517.41603, 1069.6952],[ 918.40642, 971.39832],[ 1041.4388, 618.1839199999999]]]).
arc(arc00642,node01016,node00347,influence,[complete=true,name=i21],[course=[[ -1.8421432, 1215.7665],[ 57.412432, 1227.0243],[ 131.72763, 1238.0838]]]).
arc(arc00647,node01016,node00348,influence,[complete=true,name=i34],[course=[[ -1.8421432, 1338.9363],[ 64.209703, 1339.7872],[ 131.72763, 1340.4399]]]).
arc(arc00648,node00349,node01016,influence,[complete=true,name=i31],[course=[[ 132.04445, 1482.177],[ 7.1010428, 1489.0871],[ -1.8421432, 1490.6937]]]).
arc(arc00659,node00368,node01016,influence,[complete=true,name=i117],[course=[[ 464.56056, 1534.1908],[ 225.40871, 1536.0367],[ -1.8421432, 1536.5669]]]).
arc(arc00660,node00352,node01016,influence,[complete=true,name=i46],[course=[[ 299.11009, 1069.6952],[ 452.55789, 483.40351],[ 83.285939, 13.86402]]]).
arc(arc00661,node00353,node01016,influence,[complete=true,name=i40],[course=[[ 439.77758, 1069.6952],[ 493.41331, 454.97121],[ 39.484914, 44.211267]]]).
arc(arc00676,node00354,node01016,influence,[complete=true,name=i47],[course=[[ 735.9408, 1069.6952],[ 997.69464, 486.46119],[ 725.31028, -9.0000441]]]).
arc(arc00677,node00355,node01016,influence,[complete=true,name=i17],[course=[[ 131.72762, 1327.2126],[ 61.436306, 1305.9003],[ -1.8421432, 1284.7866]]]).
arc(arc00694,node01016,node00478,influence,[complete=true,name=i57],[course=[[ 1143.7818, 1790.4422],[ 1070.1852, 1545.7222],[ 1018.6963, 1439.406]]]).
arc(arc00915,node01016,node00496,influence,[complete=true,name=i92],[course=[[ 1132.4873, 1671.8203],[ 1039.0568, 1517.9901],[ 1018.6963, 1424.2459]]]).
arc(arc01128,node01016,node00491,influence,[complete=true,name=i149],[course=[[ 1041.4388, 848.13396],[ 758.50147, 865.02688],[ 651.70044, 1069.6952]]]).
arc(arc01255,node01016,node00491,influence,[complete=true,name=i188],[course=[[ 1041.4388, 914.28767],[ 840.73906, 931.89932],[ 786.88279, 1069.6952]]]).
arc(arc01331,node01008,node01016,influence,[complete=true,name=i173],[course=[[ 903.6863499999999, 1069.6952],[ 1037.523, 786.33021],[ 891.70051, 508.95818]]]).
arc(arc01756,node01016,node00491,influence,[complete=true,name=i264],[course=[[ 1041.4388, 1089.1055],[ 964.41427, 1061.7936],[ 956.8239600000001, 1069.6952]]]).
arc(arc00005,node00025,node00010,influence,[name=i2],[]).
arc(arc00015,node00049,node00048,influence,[name=i11],[]).
arc(arc00064,node00010,node00049,influence,[complete=true,name=i15,role=[use(none,in_hierarchy,usr(protected_abs),1)]],[course=[[ 72.502993, 337.16597],[ 341.96198, 352.55544],[ 542.19151, 195.39509]]]).
arc(arc00066,node00048,node00052,influence,[complete=true,name=i18],[course=[[ 4.814206e-07, 337.68916],[ 31.71893, 340.27477],[ 57.557143, 337.53046]]]).
arc(arc00638,node00066,node00025,influence,[complete=true,name=i141,role=[use(none,in_hierarchy,surface,1)]],[course=[[ 555.08573, 188.05755],[ 594.3924500000001, 172.84604],[ 634.07975, 150.07053]]]).
arc(arc00610,node00111,node00066,influence,[name=i19],[]).
arc(arc00164,node00125,arc00014,influence,[name=i3],[]).
arc(arc00387,node00131,node00049,influence,[complete=true,name=i105,role=[use(none,in_hierarchy,usr(scenario),int)]],[course=[[ 72.184275, 334.53508],[ 129.57963, 316.89598],[ 222.36379, 292.01598]]]).
arc(arc00227,node00190,node00049,influence,[complete=true,name=i33,role=[use(none,in_hierarchy,usr(area_to_keep_PC),1)]],[course=[[ 65.24862899999999, 329.24196],[ 69.01155, 208.40182],[ 65.792947, 110.01227]]]).
arc(arc00203,node00191,node00190,influence,[name=i5],[]).
arc(arc00212,node00193,node00190,influence,[complete=true,name=i7],[course=[[ 73.04331000000001, 102.77377],[ 211.41966, 107.52738],[ 300.65742, 1.4187621]]]).
arc(arc00028,node00207,node00131,influence,[name=i1],[]).
arc(arc00612,node00212,node00066,influence,[complete=true,name=i27],[course=[[ 641.8344, 138.553],[ 657.0763899999999, 65.075839],[ 604.21318, 1.4187621]]]).
arc(arc00243,node00213,node00131,influence,[complete=true,name=i38],[course=[[ 231.34244, 282.77683],[ 268.3937, 126.91646],[ 167.38246, 1.4187621]]]).
arc(arc00230,node00230,node00229,influence,[name=i6],[]).
arc(arc00411,node00010,node00230,influence,[complete=true,name=i40,role=[use(none,in_hierarchy,protected_abs_PC,1)]],[course=[[ 396.26478, 151.24664],[ 473.32268, 172.11285],[ 540.81423, 188.9491]]]).
arc(arc00010,node00238,node00025,influence,[complete=true,name=i8,role=[use(none,in_hierarchy,protected_rel,1)]],[course=[[ 555.49663, 189.57695],[ 639.14366, 176.16429],[ 726.12414, 162.56452]]]).
arc(arc00388,node00002,node00239,influence,[complete=true,name=i8,role=[use(none,in_hierarchy,protected_rel,1)]],[course=[[ -4.4480128e-06, 141.28999],[ 47.021995, 111.80278],[ 57.433315, 95.956577]]]).
arc(arc00389,node00187,node01079,influence,[complete=true,name=i17],[course=[[ -4.4480128e-06, 177.10548],[ 30.77098, 160.92761],[ 59.215808, 148.3759]]]).
arc(arc01317,node01147,node01090,influence,[complete=true,name=i157],[course=[[ -4.4480128e-06, 308.93779],[ 41.40218, 314.47394],[ 81.319153, 324.20829]]]).
arc(arc01302,node01148,node01147,influence,[name=i50],[]).
arc(arc01303,node01149,node01147,influence,[complete=true,name=i51],[course=[[ 92.40537999999999, 319.519],[ 156.02577, 159.13441],[ 78.023447, -2.9392097]]]).
arc(arc01332,node01170,node01125,influence,[complete=true,name=i174],[course=[[ -4.4480128e-06, 309.88578],[ 18.020679, 346.43512],[ 42.752417, 379.20768]]]).
arc(arc01328,node01171,node01170,influence,[name=i170],[]).
arc(arc01329,node01172,node01170,influence,[complete=true,name=i171],[course=[[ 52.280259, 376.51353],[ 144.50695, 184.67476],[ 49.271127, -2.9392097]]]).
arc(arc00390,node01091,node01277,influence,[complete=true,name=i33,role=[use(none,in_hierarchy,usr('PC_ini_rel'),1)]],[course=[[ -4.4480128e-06, 19.198054],[ 27.05247, 21.820651],[ 57.59035, 23.541403]]]).
arc(arc01754,node01091,node01562,influence,[complete=true,name=i262],[course=[[ 98.226764, -2.9392097],[ 74.333822, 1.040492],[ 66.86725, 18.873446]]]).
arc(arc01813,node01626,node01630,influence,[complete=true,name=i85],[course=[[ -4.4480128e-06, 178.58876],[ 37.469289, 197.71942],[ 65.341111, 204.99927]]]).
arc(arc01815,node01627,node01634,influence,[complete=true,name=i87],[course=[[ -4.4480128e-06, 179.66825],[ 21.11793, 226.01936],[ 42.142263, 259.33612]]]).
arc(arc00140,node00297,node00282,influence,[name=i36],[]).
arc(arc00326,node00312,node00282,influence,[complete=true,name=i39],[course=[[ 407.06845, 213.22675],[ 409.42801, 83.695947],[ 308.04996, 1.4187621]]]).
arc(arc00235,node00229,node00344,influence,[complete=true,name=i9],[course=[[ -9.518579599999999e-06, 63.091788],[ 203.45916, 107.15555],[ 381.71163, 147.62581]]]).
arc(arc00409,node00376,node00230,influence,[complete=true,name=i34,role=[use(none,in_hierarchy,coef_remove_0,1)]],[course=[[ 383.22519, 144.53173],[ 344.51338, 112.79896],[ 306.37137, 90.122891]]]).
arc(arc00403,node00377,node00376,influence,[name=i31],[]).
arc(arc00407,node00378,node00376,influence,[complete=true,name=i32],[course=[[ 306.63787, 84.333022],[ 367.64982, 62.011473],[ 385.68841, 1.4187621]]]).
arc(arc00475,node00379,node00125,influence,[complete=true,name=i53,role=[use(none,in_hierarchy,diff_PC,1)]],[course=[[ 451.0709, 86.591939],[ 448.92242, 262.08496],[ 449.82973, 401.42254]]]).
arc(arc00404,node00381,node00380,influence,[name=i55],[]).
arc(arc00405,node00238,node00381,influence,[complete=true,name=i57,role=[use(none,in_hierarchy,'PC_ini_rel',1)]],[course=[[ 673.56263, 389.88961],[ 701.2110699999999, 238.9628],[ 726.12414, 44.696488]]]).
arc(arc01318,node00238,node00381,influence,[complete=true,name=i158,role=[use(none,in_hierarchy,'High_risks_floodable_areas',1)]],[course=[[ 677.27768, 391.73687],[ 704.8354399999999, 361.65814],[ 726.12414, 324.41234]]]).
arc(arc01333,node00238,node00381,influence,[complete=true,name=i175,role=[use(none,in_hierarchy,'Medium_risks_floodable_areas',1)]],[course=[[ 676.8757900000001, 391.3939],[ 704.63472, 356.44413],[ 726.12414, 325.32754]]]).
arc(arc00445,node00383,node00379,influence,[name=i42],[]).
arc(arc00693,node00380,node00481,influence,[complete=true,name=i52],[course=[[ 886.96869, 371.12962],[ 776.93418, 331.91182],[ 678.57382, 393.29609]]]).
arc(arc00014,node00564,node00124,flow,[complete=true,name='PC_decline'],[bowtie=[ 444.97393, 61.591939, 457.47393, 86.591939],caption_offset=[0,0],course=[[ 377.3585, 74.091939],[ 525.08935, 74.091939]]]).
arc(arc00402,node00564,node00230,influence,[complete=true,name=i29,role=[use(none,in_hierarchy,'PC_abs',1)]],[course=[[ 395.87933, 146.24086],[ 470.33633, 113.15611],[ 525.08935, 84.543469]]]).
arc(arc00541,node00564,node00383,influence,[complete=true,name=i54,role=[use(none,in_hierarchy,'PC_abs',1)]],[course=[[ 452.10071, 401.71067],[ 503.37432, 232.18816],[ 541.13147, 89.091939]]]).
arc(arc01114,node00565,node00564,influence,[name=i144],[]).
arc(arc01126,node00564,node00571,influence,[complete=true,name=i148],[course=[[ 519.97282, 1.4187621],[ 515.21567, 35.263266],[ 533.54878, 59.091939]]]).
arc(arc01338,node01074,node00049,influence,[complete=true,name=i51,role=[use(none,in_hierarchy,usr(rent_pcrops_bis),1)]],[course=[[ 72.509372, 337.03383],[ 337.46166, 347.48088],[ 541.05819, 257.70218]]]).
arc(arc01280,node01075,node01074,influence,[name=i44],[]).
arc(arc01310,node00238,node01075,influence,[complete=true,name=i48,role=[use(none,in_hierarchy,rent_pcrops_2000_2030,1)]],[course=[[ 555.1371, 252.62579],[ 650.00458, 225.96433],[ 726.12414, 197.14093]]]).
arc(arc01339,node00238,node01075,influence,[complete=true,name=i62,role=[use(none,in_hierarchy,'High_risks_floodable_areas',1)]],[course=[[ 554.79808, 257.69629],[ 636.38623, 293.89094],[ 726.12414, 324.41234]]]).
arc(arc01340,node00238,node01075,influence,[complete=true,name=i63,role=[use(none,in_hierarchy,'Medium_risks_floodable_areas',1)]],[course=[[ 554.84875, 257.5777],[ 641.83986, 294.36697],[ 726.12414, 325.32754]]]).
arc(arc01814,node00238,node01075,influence,[complete=true,name=i86,role=[use(none,in_hierarchy,rent_pcrops_2031_2060,1)]],[course=[[ 555.18828, 252.81373],[ 648.70883, 229.14713],[ 726.12414, 198.57289]]]).
arc(arc01816,node00238,node01075,influence,[complete=true,name=i88,role=[use(none,in_hierarchy,rent_pcrops_2061_2080,1)]],[course=[[ 555.10361, 252.51221],[ 638.4198, 227.72823],[ 726.12414, 199.61504]]]).
arc(arc00009,node00131,node01096,influence,[complete=true,name=i4,role=[use(none,in_hierarchy,usr(scenario),int)]],[course=[[ 326.73728, 257.91326],[ 294.23634, 267.44437],[ 236.68649, 287.59496]]]).
arc(arc00365,node00282,node01096,influence,[complete=true,name=i45,role=[use(none,in_hierarchy,usr(k_PC),1)]],[course=[[ 340.86604, 252.93923],[ 374.74062, 238.94589],[ 400.40483, 224.41983]]]).
arc(arc00658,node00351,node01096,influence,[complete=true,name=i60,role=[use(none,in_hierarchy,usr(rent_min_pcrops),1)]],[course=[[ 333.92449, 263.30271],[ 333.7864, 370.01808],[ 332.83294, 465.91441]]]).
arc(arc00893,node01085,node01096,influence,[complete=true,name=i120,role=[use(none,in_hierarchy,usr('PC_rent_thr'),1)]],[course=[[ 326.43824, 256.04876],[ 153.70815, 261.71834],[ -9.518579599999999e-06, 260.5083]]]).
arc(arc01089,node01096,node01095,influence,[name=i21],[]).
arc(arc01321,node01074,node01096,influence,[complete=true,name=i49,role=[use(none,in_hierarchy,usr(rent_pcrops_bis),1)]],[course=[[ 341.43325, 255.6834],[ 452.30601, 253.91922],[ 540.4275, 254.59046]]]).
arc(arc00225,node00190,node01098,influence,[complete=true,name=i26,role=[use(none,in_hierarchy,'PC_to_keep_outside_pro_areas',1)]],[course=[[ 136.31468, 171.42936],[ 96.914597, 137.20919],[ 70.577645, 108.07955]]]).
arc(arc00396,node00229,node01098,influence,[complete=true,name=i28,role=[use(none,in_hierarchy,'PC_adjusted',1)]],[course=[[ 149.43471, 175.55085],[ 283.20834, 161.26323],[ 381.57308, 150.12984]]]).
arc(arc00631,node00010,node01098,influence,[complete=true,name=i50,role=[use(none,in_hierarchy,protected_abs_PC,1)]],[course=[[ 149.4577, 176.88682],[ 338.72544, 190.53599],[ 540.59123, 190.75621]]]).
arc(arc01090,node01098,node01097,influence,[name=i23],[]).
arc(arc01091,node01095,node01098,influence,[complete=true,name=i25,role=[use(none,in_hierarchy,usr(weight),1)]],[course=[[ 148.83144, 179.39177],[ 242.22622, 220.87406],[ 326.92534, 253.13327]]]).
arc(arc00063,node01101,node00049,influence,[complete=true,name=i14,role=[use(none,in_hierarchy,usr('PC_surface_abs_ite1'),1)]],[course=[[ 70.20259900000001, 331.32161],[ 109.61744, 317.2294],[ 121.99258, 277.24221]]]).
arc(arc00021,node01097,node01102,influence,[complete=true,name=i22,role=[use(none,in_hierarchy,usr(modifiable_surface),1)]],[course=[[ 128.63912, 264.4688],[ 137.71718, 218.69882],[ 141.22652, 183.8097]]]).
arc(arc00441,node00229,node01102,influence,[complete=true,name=i41,role=[use(none,in_hierarchy,'PC_adjusted',1)]],[course=[[ 133.78989, 268.28161],[ 247.4227, 207.35777],[ 382.08635, 152.13209]]]).
arc(arc01095,node01102,node01101,influence,[name=i58],[]).
arc(arc01098,node01094,node01102,influence,[complete=true,name=i16,role=[use(none,in_hierarchy,usr('Change_coefficient'),1)]],[course=[[ 119.74196, 270.86325],[ 40.342951, 260.5916],[ -9.518579599999999e-06, 258.9362]]]).
arc(arc00455,node01105,node00383,influence,[complete=true,name=i43,role=[use(none,in_hierarchy,'PC_surface_abs_ite2',1)]],[course=[[ 442.53231, 408.89151],[ 306.21697, 407.65722],[ 136.56195, 408.93453]]]).
arc(arc00062,node00048,node01106,influence,[complete=true,name=i13,role=[use(none,in_hierarchy,modifiable_surface_bis,1)]],[course=[[ 123.50229, 403.95732],[ 86.75791599999999, 370.69052],[ 69.059855, 343.05424]]]).
arc(arc00076,node00060,node01106,influence,[complete=true,name=i30,role=[use(none,in_hierarchy,change_coef_bis,1)]],[course=[[ 121.59908, 409.73429],[ 65.498547, 415.32175],[ 0.31682049, 413.90058]]]).
arc(arc01101,node01106,node01105,influence,[name=i46],[]).
arc(arc01102,node01101,node01106,influence,[complete=true,name=i47,role=[use(none,in_hierarchy,'PC_surface_abs_ite1',1)]],[course=[[ 128.87947, 401.49321],[ 127.45003, 342.82667],[ 127.20851, 279.32544]]]).
arc(arc01254,node00010,node01108,influence,[complete=true,name=i187],[course=[[ 655.15517, 1.4187621],[ 557.40253, 66.97309],[ 548.65377, 183.28552]]]).
arc(arc01105,node01097,node01109,influence,[complete=true,name=i12],[course=[[ 4.814206e-07, 169.80744],[ 76.830894, 175.29013],[ 134.47812, 176.22566]]]).
arc(arc01085,node00238,node01110,influence,[complete=true,name=i147],[course=[[ 726.48296, 465.91441],[ 725.69436, 331.43796],[ 726.12414, 197.14093]]]).
arc(arc01107,node01101,node01111,influence,[complete=true,name=i65],[course=[[ 4.814206e-07, 272.1635],[ 60.484983, 270.78287],[ 119.6809, 271.70826]]]).
arc(arc01267,node01123,node00049,influence,[complete=true,name=i152,role=[use(none,in_hierarchy,usr('PC_rent_thr'),1)]],[course=[[ 60.40611, 330.82172],[ 28.005871, 289.23001],[ -9.518579599999999e-06, 260.5083]]]).
arc(arc01304,node01152,node00238,influence,[complete=true,name=i61],[course=[[ 801.44828, 23.325089],[ 800.08688, 8.420899500000001],[ 785.64418, 1.4187621]]]).
arc(arc00216,node01160,node01075,influence,[complete=true,name=i10,role=[use(none,in_hierarchy,rent_min_pcrops,1)]],[course=[[ 542.66886, 260.03852],[ 451.71641, 353.05376],[ 332.83294, 465.91441]]]).
arc(arc01330,node01173,node00238,influence,[complete=true,name=i172],[course=[[ 773.69068, 23.325089],[ 779.36536, 11.93894],[ 771.95874, 1.4187621]]]).
arc(arc01453,node01268,node00565,influence,[complete=true,name=i194,role=[use(none,in_hierarchy,usr('PC_ini_abs'),1)]],[course=[[ 565.08935, 67.923237],[ 606.74716, 55.074507],[ 634.01648, 35.850478]]]).
arc(arc01442,node01269,node01268,influence,[name=i183],[]).
arc(arc01451,node00066,node01269,influence,[complete=true,name=i192,role=[use(none,in_hierarchy,surface,1)]],[course=[[ 639.98116, 39.027271],[ 639.2586, 71.81945],[ 640.2045000000001, 138.39741]]]).
arc(arc01452,node00238,node01269,influence,[complete=true,name=i193,role=[use(none,in_hierarchy,'PC_ini_rel',1)]],[course=[[ 647.60986, 32.268183],[ 689.52225, 36.418667],[ 726.12414, 44.696488]]]).
arc(arc01443,node01268,node01270,influence,[complete=true,name=i184],[course=[[ 6.5667006, 32.696926],[ 365.17074, 32.140062],[ 632.64639, 31.545755]]]).
arc(arc01643,node01268,node01468,influence,[complete=true,name=i66],[course=[[ -9.518579599999999e-06, 169.2291],[ 350.53163, 236.45995],[ 634.02406, 35.861223]]]).
arc(arc00344,node01493,node00346,influence,[complete=true,name=i78],[course=[[ 886.96869, 355.96952],[ 796.15784, 362.30791],[ 657.6964, 369.46663]]]).
arc(arc00406,node01493,node00381,influence,[complete=true,name=i59,role=[use(none,in_hierarchy,'PC_surface_rel',1)]],[course=[[ 669.57813, 390.24425],[ 666.46099, 381.93058],[ 657.6964, 369.46663]]]).
arc(arc00626,node00564,node01493,influence,[complete=true,name=i56,role=[use(none,in_hierarchy,'PC_abs',1)]],[course=[[ 645.10984, 308.18769],[ 606.94969, 207.98658],[ 552.01946, 89.091939]]]).
arc(arc00640,node00066,node01493,influence,[complete=true,name=i143,role=[use(none,in_hierarchy,usr(surface),1)]],[course=[[ 644.66538, 308.18769],[ 647.4091, 234.14999],[ 640.91231, 153.37252]]]).
arc(arc01099,node01104,node01103,influence,[name=i64],[]).
arc(arc01400,node01103,node01520,influence,[complete=true,name=i78],[course=[[ 119.70091, 57.022649],[ 116.42986, 47.499547],[ 108.86175, 40.351251]]]).
arc(arc01412,node01521,node01104,influence,[complete=true,name=i56,role=[use(none,in_hierarchy,'PC_abs',1)]],[course=[[ 103.61319, 27.704099],[ 104.23357, 4.88239],[ 107.11435, -4.2562862]]]).
arc(arc01478,node01522,node01104,influence,[complete=true,name=i143,role=[use(none,in_hierarchy,usr(surface),1)]],[course=[[ 103.60115, 27.703782],[ 104.12089, 7.3835251],[ 106.66989, -4.2562862]]]).
arc(arc01755,node00238,node01563,influence,[complete=true,name=i263],[course=[[ 825.09635, 1.4187621],[ 816.48384, 11.335997],[ 820.95264, 23.325089]]]).
arc(arc01817,node00238,node01631,influence,[complete=true,name=i89],[course=[[ 727.94679, 465.91441],[ 724.58457, 317.98551],[ 726.12414, 198.57289]]]).
arc(arc01821,node00238,node01635,influence,[complete=true,name=i93],[course=[[ 728.40913, 465.91441],[ 724.64816, 406.46984],[ 726.12414, 199.61504]]]).
arc(arc00917,node01062,node01008,influence,[complete=true,name=i101],[course=[[ 140.47026, 455.48543],[ 71.825729, 445.42096],[ -1.8421432, 432.58468]]]).
arc(arc01216,node01008,node01065,influence,[complete=true,name=i172],[course=[[ -1.8421432, 194.63503],[ 62.756456, 198.65804],[ 140.16548, 199.77777]]]).
arc(arc00894,node01088,node01016,influence,[complete=true,name=i143],[course=[[ 131.72762, 1328.7847],[ 70.680944, 1325.0743],[ -1.8421432, 1325.7233]]]).
arc(arc01258,node01016,node01112,influence,[complete=true,name=i148],[course=[[ -1.8421432, 1534.8608],[ 405.74553, 1533.8679],[ 858.21057, 1534.1908]]]).
arc(arc01279,node01137,node00491,influence,[complete=true,name=i212],[course=[[ 1041.4388, 385.84426],[ 962.2747000000001, 112.93688],[ 725.31029, -9.0000658]]]).
arc(arc01299,node01146,node01008,influence,[complete=true,name=i42],[course=[[ 937.00104, 33.078228],[ 952.82578, 14.691666],[ 947.6113800000001, -9.0000658]]]).
arc(arc01308,node01153,node01016,influence,[complete=true,name=i145],[course=[[ 917.37179, 1069.6952],[ 1201.8107, 537.90744],[ 947.6113800000001, -9.0000658]]]).
arc(arc01314,node01158,node01007,influence,[complete=true,name=i154],[course=[[ 929.23569, 546.59168],[ 1077.3215, 273.38973],[ 947.6113800000001, -9.0000658]]]).
arc(arc01199,node00132,node01163,influence,[complete=true,name=i157],[course=[[ -1.8421432, 2332.9532],[ 37.092067, 2337.3823],[ 74.523695, 2337.6788]]]).
arc(arc01352,node00132,node01185,influence,[complete=true,name=i174],[course=[[ -1.8421432, 2018.9131],[ 46.043857, 2018.7035],[ 74.523695, 2020.0363]]]).
arc(arc01207,node00132,node01205,influence,[complete=true,name=i158],[course=[[ 702.54724, 2792.524],[ 702.67174, 2800.6232],[ 703.3413, 2770.5395]]]).
arc(arc01415,node01244,node00132,influence,[complete=true,name=i159],[course=[[ 747.7659, 2770.5395],[ 745.0924199999999, 2782.9126],[ 747.73615, 2792.524]]]).
arc(arc01418,node01247,node00132,influence,[complete=true,name=i165],[course=[[ 745.95201, 2770.5395],[ 744.16935, 2785.3057],[ 747.70389, 2792.524]]]).
arc(arc01423,node01008,node01252,influence,[complete=true,name=i160],[course=[[ 20.862822, 87.78857000000001],[ 83.27135199999999, 92.418418],[ 140.31048, 88.399869]]]).
arc(arc01435,node01007,node01262,influence,[complete=true,name=i175],[course=[[ -1.8421432, 580.77427],[ 79.475478, 581.48197],[ 138.3033, 581.00172]]]).
arc(arc01444,node01016,node01271,influence,[complete=true,name=i185],[course=[[ -1.8421432, 1099.6619],[ 65.987289, 1101.3804],[ 138.29433, 1100.9733]]]).
arc(arc01465,node01008,node01302,influence,[complete=true,name=i170],[course=[[ -1.8421432, 235.67113],[ 75.155199, 259.18598],[ 140.16548, 211.69701]]]).
arc(arc01594,node01007,node01426,influence,[complete=true,name=i161],[course=[[ -1.8421432, 727.05998],[ 71.548643, 748.23223],[ 132.52091, 702.22295]]]).
arc(arc01644,node01016,node01469,influence,[complete=true,name=i162],[course=[[ -1.8421432, 1265.3319],[ 72.12588100000001, 1284.8111],[ 131.72762, 1237.5055]]]).
arc(arc01679,node01500,node00491,influence,[complete=true,name=i176],[course=[[ 1041.4388, 655.68381],[ 490.8831, 401.18411],[ -1.8421432, 661.23105]]]).
arc(arc01684,node01506,node00491,influence,[complete=true,name=i184],[course=[[ 1041.4388, 486.8929],[ 804.51815, 73.396856],[ 365.05291, -9.0000658]]]).
arc(arc01762,node00491,node01568,influence,[complete=true,name=i270],[course=[[ 1025.3143, -9.0000658],[ 1028.5588, 57.528472],[ 1067.4883, 110.06383]]]).
arc(arc01553,node01008,node01608,influence,[complete=true,name=i36],[course=[[ -1.8421432, 511.59515],[ 413.6186, 508.89076],[ 817.80017, 508.95818]]]).
arc(arc01798,node01008,node01612,influence,[complete=true,name=i69],[course=[[ -1.8421432, 511.70746],[ 430.67942, 506.10939],[ 817.65955, 508.95818]]]).
arc(arc01806,node01007,node01620,influence,[complete=true,name=i78],[course=[[ -1.8421432, 1029.4615],[ 447.76735, 1022.4559],[ 862.83239, 1027.7194]]]).
arc(arc01810,node01007,node01624,influence,[complete=true,name=i82],[course=[[ -1.8421432, 1030.1616],[ 424.99294, 1025.6435],[ 862.73262, 1027.7194]]]).
arc(arc01818,node01016,node01632,influence,[complete=true,name=i90],[course=[[ -1.8421432, 1535.7354],[ 436.81663, 1534.3052],[ 859.67438, 1534.1908]]]).
arc(arc01822,node01016,node01636,influence,[complete=true,name=i95],[course=[[ -1.8421432, 1535.1863],[ 442.69202, 1534.0307],[ 860.13672, 1534.1908]]]).
arc(arc00440,node00068,node00072,influence,[complete=true,name=i109],[course=[[ 1226.901, 3535.5298],[ 1392.873, 3506.8558],[ 1533.2156, 3478.6282]]]).
arc(arc00448,node00068,node00072,influence,[complete=true,name=i126],[course=[[ 716.55162, 3532.9823],[ 675.32906, 3506.6091],[ 629.69965, 3485.7843]]]).
arc(arc00451,node00068,node00072,influence,[complete=true,name=i130],[course=[[ 717.17436, 3532.9823],[ 739.3975799999999, 3504.9741],[ 757.2140000000001, 3485.7843]]]).
arc(arc00456,node00068,node00072,influence,[complete=true,name=i104],[course=[[ 1226.4103, 3535.4125],[ 1392.0081, 3506.849],[ 1532.1669, 3478.8917]]]).
arc(arc00472,node00068,node00072,influence,[complete=true,name=i113],[course=[[ 1224.4328, 3534.969],[ 1389.6705, 3506.9636],[ 1529.9602, 3479.4289]]]).
arc(arc00521,node00072,node00068,influence,[complete=true,name=i155],[course=[[ 881.11679, 3485.7843],[ 881.72235, 3515.8679],[ 881.28018, 3532.9823]]]).
arc(arc00859,node00068,node00072,influence,[complete=true,name=i232],[course=[[ 1199.2589, 3532.9823],[ 1346.1383, 3504.2863],[ 1472.2472, 3485.7843]]]).
arc(arc00953,node00068,node00072,influence,[complete=true,name=i237],[course=[[ 1051.4183, 3532.9823],[ 1183.3312, 3506.885],[ 1294.4735, 3485.7843]]]).
arc(arc01004,node00068,node00072,influence,[complete=true,name=i242],[course=[[ 1066.302, 3532.9823],[ 1205.8879, 3509.0071],[ 1324.7032, 3485.7843]]]).
arc(arc01170,node00068,node00072,influence,[complete=true,name=i51],[course=[[ 716.98362, 3532.9823],[ 680.19362, 3511.4612],[ 631.11831, 3485.7843]]]).
arc(arc01367,node00068,node00072,influence,[complete=true,name=i5],[course=[[ 925.48634, 3532.9823],[ 920.02653, 3522.7222],[ 881.11679, 3485.7843]]]).
arc(arc01416,node00072,node00068,influence,[complete=true,name=i161],[course=[[ 926.1608199999999, 3485.7843],[ 922.51415, 3512.3479],[ 925.49591, 3532.9823]]]).
arc(arc01419,node00072,node00068,influence,[complete=true,name=i166],[course=[[ 926.1286700000001, 3485.7843],[ 923.43931, 3525.8199],[ 925.08538, 3532.9823]]]).
arc(arc00144,node00135,node00196,influence,[complete=true,name=i6],[course=[[ -273.25673, 134.34911],[ -217.25194, 135.61622],[ -155.48165, 134.69082]]]).
arc(arc00313,node00269,node00387,influence,[complete=true,name=i7],[course=[[ 719.44994, 500.20147],[ 322.25725, 53.703522],[ -273.25673, 103.55891]]]).
arc(arc00303,node00266,node00265,influence,[name=i1],[]).
arc(arc00312,node00268,node00265,influence,[complete=true,name=i6],[course=[[ 63.465443, 471.38248],[ 112.92328, 490.51625],[ 157.905, 462.43025]]]).
arc(arc00425,node00405,node00404,influence,[name=i47],[]).
arc(arc00426,node00406,node00404,influence,[complete=true,name=i48],[course=[[ 72.344741, 299.16684],[ 110.93957, 328.9275],[ 157.905, 315.90803]]]).
arc(arc00429,node00409,node00408,influence,[name=i105],[]).
arc(arc00430,node00410,node00408,influence,[complete=true,name=i106],[course=[[ 71.97064899999999, 363.6611],[ 100.68183, 413.65668],[ 157.905, 420.68509]]]).
arc(arc00433,node00413,node00412,influence,[name=i110],[]).
arc(arc00434,node00414,node00412,influence,[complete=true,name=i111],[course=[[ 65.743819, 421.32677],[ 88.366467, 491.28296],[ 157.905, 515.15855]]]).
arc(arc00510,node00465,node00464,influence,[name=i143],[]).
arc(arc00512,node00469,node00464,influence,[complete=true,name=i147],[course=[[ 66.264064, 248.91742],[ 78.284477, 339.42776],[ 157.905, 384.11764]]]).
arc(arc00714,node00632,node00631,influence,[name=i165],[]).
arc(arc00716,node00634,node00631,influence,[complete=true,name=i168],[course=[[ 76.042447, 203.13327],[ 85.09947699999999, 287.3474],[ 157.905, 330.63026]]]).
arc(arc00719,node00637,node00636,influence,[name=i171],[]).
arc(arc00721,node00639,node00636,influence,[complete=true,name=i173],[course=[[ 74.46687900000001, 152.16169],[ 58.180433, 295.74976],[ 157.905, 382.76951]]]).
arc(arc00730,node00388,node00654,influence,[complete=true,name=i182],[course=[[ 0.0, 151.16841],[ 33.492247, 110.65215],[ 66.42769199999999, 70.860882]]]).
arc(arc00854,node00675,node00674,influence,[name=i228],[]).
arc(arc00856,node00677,node00674,influence,[complete=true,name=i230],[course=[[ 57.475105, 516.40153],[ 230.36569, 281.06342],[ 145.82955, 1.5480953]]]).
arc(arc00863,node00680,node00679,influence,[name=i233],[]).
arc(arc00899,node00682,node00679,influence,[complete=true,name=i235],[course=[[ 57.840696, 558.88073],[ 153.62697, 295.00731],[ 0.0, 60.054238]]]).
arc(arc00960,node00685,node00684,influence,[name=i238],[]).
arc(arc00966,node00687,node00684,influence,[complete=true,name=i240],[course=[[ 58.097843, 605.97247],[ 117.76068, 414.02449],[ 0.0, 251.12544]]]).
arc(arc00726,node00636,node01551,influence,[complete=true,name=i178],[course=[[ 0.0, 545.65309],[ 37.584774, 311.36137],[ 69.69156099999999, 152.77128]]]).
arc(arc00724,node00631,node01552,influence,[complete=true,name=i176],[course=[[ 0.0, 543.63418],[ 35.247298, 360.4037],[ 70.346597, 204.13986]]]).
arc(arc00515,node00464,node01553,influence,[complete=true,name=i150],[course=[[ 0.0, 542.83255],[ 27.095853, 394.60696],[ 60.373824, 250.01809]]]).
arc(arc00530,node00404,node01577,influence,[complete=true,name=i132],[course=[[ 0.0, 543.9818299999999],[ 37.546074, 400.64981],[ 63.052366, 304.97356]]]).
arc(arc00532,node00408,node01578,influence,[complete=true,name=i134],[course=[[ 0.0, 544.49466],[ 42.142428, 440.22797],[ 63.618296, 366.71333]]]).
arc(arc00534,node00412,node01579,influence,[complete=true,name=i136],[course=[[ 0.0, 546.41054],[ 31.28989, 470.64428],[ 56.954989, 422.59158]]]).
arc(arc00315,node00265,node01580,influence,[complete=true,name=i62],[course=[[ 0.0, 543.37618],[ 22.230953, 512.20989],[ 51.169319, 477.82828]]]).
arc(arc01006,node00674,node01581,influence,[complete=true,name=i243],[course=[[ 0.0, 546.63621],[ 18.320263, 534.7992],[ 49.0043, 525.88568]]]).
arc(arc01012,node00679,node01582,influence,[complete=true,name=i245],[course=[[ 0.0, 547.06339],[ 27.213982, 557.10862],[ 51.506865, 564.22293]]]).
arc(arc01020,node00684,node01583,influence,[complete=true,name=i247],[course=[[ 0.0, 543.13858],[ 25.251261, 577.6951299999999],[ 54.13098, 607.94886]]]).
arc(arc00427,node00407,node00387,influence,[complete=true,name=i49],[course=[[ 719.44994, 353.67926],[ 805.19212, 171.46344],[ 710.86476, -6.4597923]]]).
arc(arc00431,node00411,node00387,influence,[complete=true,name=i107],[course=[[ 719.44994, 458.45631],[ 831.6024, 224.03329],[ 711.35546, -6.3424923]]]).
arc(arc00435,node00415,node00387,influence,[complete=true,name=i112],[course=[[ 719.44994, 552.92977],[ 854.1268700000001, 270.37257],[ 708.88726, -6.9032923]]]).
arc(arc00463,node00442,node00430,influence,[name=i3],[]).
arc(arc00508,node00462,node00430,flow,[complete=true,name='forest growth\nin surplus'],[bowtie=[ 246.33814, 169.28387, 258.83814, 194.28387],caption_offset=[0,0],course=[[ 344.98826, 181.78387],[ 160.18802, 181.78387]]]).
arc(arc00509,node00463,arc00508,influence,[name=i142],[]).
arc(arc00513,node00470,node00387,influence,[complete=true,name=i148],[course=[[ 719.44994, 421.88886],[ 246.97627, 125.95287],[ -273.25673, 326.37021]]]).
arc(arc00316,node00387,node00490,influence,[complete=true,name=i64,role=[use(none,in_hierarchy,pro_land,1)]],[course=[[ 146.52883, 581.48689],[ 342.81316, 580.78309],[ 561.54494, 581.1473999999999]]]).
arc(arc00517,node00387,node00490,influence,[complete=true,name=i151,role=[use(none,in_hierarchy,usr('Urb_dens'),1)]],[course=[[ 146.52863, 581.57455],[ 362.74564, 583.33489],[ 561.54494, 580.6037700000001]]]).
arc(arc00528,node00490,node00480,influence,[name=i130],[]).
arc(arc00531,node00387,node00490,influence,[complete=true,name=i133,role=[use(none,in_hierarchy,usr('FC_surface_rel'),1)]],[course=[[ 146.52796, 581.39602],[ 345.49285, 578.26284],[ 561.54494, 581.75305]]]).
arc(arc00533,node00387,node00490,influence,[complete=true,name=i135,role=[use(none,in_hierarchy,usr('GFC_surface_rel'),1)]],[course=[[ 146.526, 581.30585],[ 348.19533, 575.69537],[ 561.54494, 582.26589]]]).
arc(arc00535,node00387,node00490,influence,[complete=true,name=i137,role=[use(none,in_hierarchy,usr('PC_surface_rel'),1)]],[course=[[ 146.52423, 581.24978],[ 356.21005, 573.84186],[ 561.54494, 584.1817600000001]]]).
arc(arc00725,node00387,node00490,influence,[complete=true,name=i177,role=[use(none,in_hierarchy,usr(sea_dens),1)]],[course=[[ 146.52148, 581.18072],[ 342.7498, 572.42909],[ 561.54494, 581.4054]]]).
arc(arc00727,node00387,node00490,influence,[complete=true,name=i179,role=[use(none,in_hierarchy,usr(inland_waters),1)]],[course=[[ 146.52233, 581.20024],[ 330.94025, 573.45643],[ 561.54494, 583.42432]]]).
arc(arc01010,node00387,node00490,influence,[complete=true,name=i244,role=[use(none,in_hierarchy,usr(liquid_rel),1)]],[course=[[ 146.5272, 581.35504],[ 361.81147, 576.78513],[ 561.54494, 584.40743]]]).
arc(arc01016,node00387,node00490,influence,[complete=true,name=i246,role=[use(none,in_hierarchy,usr(non_woody_rel),1)]],[course=[[ 146.52874, 581.5597299999999],[ 324.93699, 582.65936],[ 561.54494, 584.83461]]]).
arc(arc01053,node00387,node00490,influence,[complete=true,name=i248,role=[use(none,in_hierarchy,usr(woody_rel),1)]],[course=[[ 146.52881, 581.48247],[ 342.8715, 580.66219],[ 561.54494, 580.9098]]]).
arc(arc00543,node00480,node00499,influence,[complete=true,name=i145],[course=[[ -273.25673, 582.45611],[ -70.632608, 581.0129899999999],[ 131.5289, 581.49572]]]).
arc(arc00630,node00556,node00490,influence,[complete=true,name=i131,role=[use(none,in_hierarchy,usr(surface),1)]],[course=[[ 146.36948, 579.97565],[ 283.12183, 551.17446],[ 466.26047, 514.39589]]]).
arc(arc00623,node00557,node00556,influence,[name=i119],[]).
arc(arc00624,node00558,node00556,influence,[complete=true,name=i120],[course=[[ 467.13055, 509.14835],[ 204.62792, 108.77826],[ -273.16973, 78.558308]]]).
arc(arc00820,node00620,node00463,influence,[complete=true,name=i223,role=[use(none,in_hierarchy,remaining_surplus_4,1)]],[course=[[ 246.4941, 169.28387],[ 224.96537, 125.12441],[ 205.8617, 94.55066600000001]]]).
arc(arc00450,node00428,node00621,influence,[complete=true,name=i129,role=[use(none,in_hierarchy,remaining_surplus_3,1)]],[course=[[ 201.82775, 80.690456],[ 201.51579, 41.49732],[ 201.62882, -8.889992299999999]]]).
arc(arc00452,node00429,node00621,influence,[complete=true,name=i136,role=[use(none,in_hierarchy,woody_growth,1)]],[course=[[ 201.78069, 80.690978],[ 201.18044, 38.525376],[ 201.00608, -8.889992299999999]]]).
arc(arc00712,node00621,node00620,influence,[name=i128],[]).
arc(arc00537,node00620,node00625,influence,[complete=true,name=i157],[course=[[ -273.25673, 88.352407],[ 31.315932, 89.218143],[ 194.38758, 88.235416]]]).
arc(arc00713,node00630,node00629,influence,[name=i164],[]).
arc(arc00717,node00635,node00387,influence,[complete=true,name=i169],[course=[[ 719.44994, 368.40148],[ 215.32745, 135.76313],[ -273.25673, 399.47811]]]).
arc(arc00722,node00640,node00387,influence,[complete=true,name=i174],[course=[[ 719.44994, 420.54073],[ 246.17857, 126.20015],[ -273.25673, 328.21291]]]).
arc(arc00733,node00645,node00644,influence,[name=i185],[]).
arc(arc00734,node00430,node00645,influence,[complete=true,name=i186,role=[use(none,in_hierarchy,forest_area_in_surplus,1)]],[course=[[ 365.73626, 273.44136],[ 367.53737, 237.54911],[ 365.66626, 196.15349]]]).
arc(arc00735,node00629,node00645,influence,[complete=true,name=i187,role=[use(none,in_hierarchy,forest_area_outside_surplus,1)]],[course=[[ 365.5785, 288.42876],[ 366.34531, 314.78347],[ 365.61682, 363.74962]]]).
arc(arc00737,node00644,node00648,influence,[complete=true,name=i189],[course=[[ -273.25673, 281.01901],[ 39.494913, 280.36337],[ 357.86039, 280.91885]]]).
arc(arc00745,node00652,node00630,influence,[complete=true,name=i197,role=[use(none,in_hierarchy,usr(forest_ini_abs),1)]],[course=[[ 385.39366, 364.80951],[ 422.37765, 339.03146],[ 467.6507, 315.19188]]]).
arc(arc00742,node00653,node00652,influence,[name=i194],[]).
arc(arc00743,node00387,node00653,influence,[complete=true,name=i195,role=[use(none,in_hierarchy,forest_ini_rel,1)]],[course=[[ 478.93235, 305.80935],[ 526.62231, 245.36282],[ 561.54494, 188.93963]]]).
arc(arc00744,node00556,node00653,influence,[complete=true,name=i196,role=[use(none,in_hierarchy,surface,1)]],[course=[[ 474.37581, 319.19691],[ 475.47806, 412.15256],[ 473.7524, 505.42049]]]).
arc(arc00746,node00652,node00655,influence,[complete=true,name=i198],[course=[[ -273.25673, 311.79111],[ 31.734447, 310.07949],[ 466.78693, 311.67002]]]).
arc(arc00819,node00668,node00463,influence,[complete=true,name=i222,role=[use(none,in_hierarchy,forest_change_rate_in_surplus,1)]],[course=[[ 246.33814, 183.23397],[ 171.71484, 200.54787],[ 57.055518, 227.62215]]]).
arc(arc00786,node00669,node00668,influence,[name=i215],[]).
arc(arc00818,node00135,node00669,influence,[complete=true,name=i221,role=[use(none,in_hierarchy,countryID,1)]],[course=[[ 43.045416, 225.99687],[ -69.46840400000001, 169.85022],[ -141.14114, 137.65189]]]).
arc(arc00810,node00672,node00669,influence,[complete=true,name=i219,role=[use(none,in_hierarchy,[forest_change_rate_in_surplus],array(1,31))]],[course=[[ 42.257311, 229.21947],[ -123.78934, 226.424],[ -273.25673, 228.54241]]]).
arc(arc00858,node00678,node00387,influence,[complete=true,name=i231],[course=[[ 707.37449, 39.319316],[ 707.59626, 9.2993796],[ 683.71336, -8.889992299999999]]]).
arc(arc00952,node00683,node00387,influence,[complete=true,name=i236],[course=[[ 561.54494, 97.825459],[ 575.38771, 38.049689],[ 535.87276, -8.889992299999999]]]).
arc(arc01002,node00688,node00387,influence,[complete=true,name=i241],[course=[[ 561.54494, 288.89666],[ 630.59737, 137.30622],[ 550.7564599999999, -8.889992299999999]]]).
arc(arc01066,node00694,node00693,influence,[name=i252],[]).
arc(arc01068,node00135,node00694,influence,[complete=true,name=i253,role=[use(none,in_hierarchy,countryID,1)]],[course=[[ -150.18233, 470.49791],[ -151.79081, 318.10871],[ -148.13808, 142.07686]]]).
arc(arc01141,node00698,node00694,influence,[complete=true,name=i258,role=[use(none,in_hierarchy,[forest_change_rate_outside_surplus],array(1,31))]],[course=[[ -157.59186, 477.58568],[ -207.08798, 474.86382],[ -273.25673, 478.60811]]]).
arc(arc01144,node00700,node00629,flow,[complete=true,name='forest growth\noutside surplus'],[bowtie=[ 247.93776, 371.83729, 260.43776, 396.83729],caption_offset=[ -5.6905406, -52.426299],course=[[ 345.39366, 384.33729],[ 162.98186, 384.33729]]]).
arc(arc01145,node00701,arc01144,influence,[name=i261],[]).
arc(arc01146,node00693,node00701,influence,[complete=true,name=i262,role=[use(none,in_hierarchy,forest_change_rate_outside_surplus,1)]],[course=[[ 247.93776, 385.40238],[ 55.396472, 418.21421],[ -142.90173, 475.90247]]]).
arc(arc01147,node00480,node00701,influence,[complete=true,name=i263,role=[use(none,in_hierarchy,space_remaining,1)]],[course=[[ 247.93776, 396.73729],[ 209.75154, 472.49879],[ 143.13933, 575.24039]]]).
arc(arc01169,node00710,node00621,influence,[complete=true,name=i50,role=[use(none,in_hierarchy,'Woody_decline',1)]],[course=[[ 201.32488, 80.711347],[ 198.58464, 44.281772],[ 201.43808, -8.889992299999999]]]).
arc(arc01213,node00836,node00495,influence,[name=i1],[]).
arc(arc00896,node00872,node00621,influence,[complete=true,name=i33,role=[use(none,in_hierarchy,'Altitude_mask',1)]],[course=[[ 199.34586, 95.246449],[ 141.44463, 255.9987],[ 80.265578, 386.80461]]]).
arc(arc00927,node00872,node00490,influence,[complete=true,name=i34,role=[use(none,in_hierarchy,'Altitude_mask',1)]],[course=[[ 136.79387, 574.35445],[ 110.36458, 489.69564],[ 79.208336, 400.62621]]]).
arc(arc00868,arc01779,node00881,influence,[complete=true,name=i30],[course=[[ -273.25673, 281.26541],[ 83.33939700000001, 275.14528],[ 437.10862, 376.95103]]]).
arc(arc01413,node00495,node01197,influence,[complete=true,name=i9],[course=[[ 409.95037, -8.889946800000001],[ 457.11846, 25.259267],[ 485.51193, 45.423059]]]).
arc(arc01214,node01206,node00836,influence,[complete=true,name=i2,role=[use(none,in_hierarchy,remaining_surplus,1)]],[course=[[ 485.36077, 45.644172],[ 450.07779, 22.437244],[ 409.9408, -8.8899934]]]).
arc(arc01368,node00430,node01207,flow,[complete=true,name='forest\ndecline\nin surplus'],[bowtie=[ 433.8584, 168.65349, 446.3584, 193.65349],caption_offset=[0,0],course=[[ 495.22855, 181.15349],[ 384.98826, 181.15349]]]).
arc(arc01369,node01208,arc01368,influence,[name=i8],[]).
arc(arc01374,node01209,node01208,influence,[complete=true,name=i13,role=[use(none,in_hierarchy,forest_to_remove,1)]],[course=[[ 435.69924, 168.65349],[ 421.54659, 128.53062],[ 410.28946, 95.481752]]]).
arc(arc01371,node01210,node01209,influence,[name=i10],[]).
arc(arc01372,node00495,node01210,influence,[complete=true,name=i11,role=[use(none,in_hierarchy,forest_max_to_remove,1)]],[course=[[ 414.72502, 85.336715],[ 443.69095, 72.46526299999999],[ 484.84845, 52.975467]]]).
arc(arc01373,node00430,node01210,influence,[complete=true,name=i12,role=[use(none,in_hierarchy,forest_area_in_surplus,1)]],[course=[[ 404.64091, 95.15097799999999],[ 387.55286, 130.9565],[ 371.73107, 166.15349]]]).
arc(arc00519,node00430,node01238,influence,[complete=true,name=i153],[course=[[ 365.73464, -8.889992299999999],[ 366.88486, 92.602013],[ 365.30953, 166.15349]]]).
arc(arc01376,node01209,node01245,influence,[complete=true,name=i15],[course=[[ 409.53984, -8.889946800000001],[ 408.92284, 52.769168],[ 408.0926, 80.88556800000001]]]).
arc(arc00293,node00644,node01535,influence,[complete=true,name=i62,role=[use(none,in_hierarchy,tot_forest_abs,1)]],[course=[[ -29.18625, 375.11208],[ 188.8046, 321.10332],[ 358.04729, 282.59586]]]).
arc(arc00294,node00556,node01535,influence,[complete=true,name=i63,role=[use(none,in_hierarchy,surface,1)]],[course=[[ -29.83381, 424.03263],[ 209.91447, 481.20868],[ 466.16731, 512.02376]]]).
arc(arc01784,node01535,node00490,influence,[complete=true,name=i29,role=[use(none,in_hierarchy,'Forest_rel',1)]],[course=[[ 133.54914, 576.3929000000001],[ 38.579981, 488.30553],[ -30.200467, 424.86725]]]).
arc(arc00292,node00259,node00258,influence,[name=i61],[]).
arc(arc01709,node00258,node01536,influence,[complete=true,name=i29,role=[use(none,in_hierarchy,'Forest_rel',1)]],[course=[[ 76.767516, 75.211012],[ 57.997081, 46.770132],[ 45.49605, 32.020903]]]).
arc(arc01710,node01537,node00259,influence,[complete=true,name=i63,role=[use(none,in_hierarchy,surface,1)]],[course=[[ 45.58008, 31.948608],[ 60.187086, 48.674948],[ 77.134173, 74.376389]]]).
arc(arc01711,node01538,node00259,influence,[complete=true,name=i62,role=[use(none,in_hierarchy,tot_forest_abs,1)]],[course=[[ 48.139583, 25.971541],[ 64.92482200000001, 25.236838],[ 77.781733, 25.45584]]]).
arc(arc00367,node01550,node01260,influence,[name=i4],[]).
arc(arc01741,node00387,node01550,influence,[complete=true,name=i5,role=[use(none,in_hierarchy,inland_waters,1)]],[course=[[ 521.45901, 480.81992],[ 541.87712, 526.0522999999999],[ 561.54494, 583.42432]]]).
arc(arc01742,node00387,node01550,influence,[complete=true,name=i14,role=[use(none,in_hierarchy,sea_dens,1)]],[course=[[ 521.07241, 480.99902],[ 545.22916, 541.9906999999999],[ 561.54494, 581.40539]]]).
arc(arc01743,node00387,node01550,influence,[complete=true,name=i16,role=[use(none,in_hierarchy,'Urb_dens',1)]],[course=[[ 521.33644, 480.8796],[ 545.43718, 535.92378],[ 561.54494, 580.60376]]]).
arc(arc01744,node00387,node01550,influence,[complete=true,name=i17,role=[use(none,in_hierarchy,'FC_surface_rel',1)]],[course=[[ 521.53016, 480.784],[ 550.79581, 542.1685],[ 561.54494, 581.7530400000001]]]).
arc(arc01745,node00387,node01550,influence,[complete=true,name=i18,role=[use(none,in_hierarchy,'GFC_surface_rel',1)]],[course=[[ 520.99465, 481.03188],[ 542.17751, 536.77387],[ 561.54494, 582.26589]]]).
arc(arc01773,node00387,node01550,influence,[complete=true,name=i19,role=[use(none,in_hierarchy,'PC_surface_rel',1)]],[course=[[ 520.90823, 481.0672],[ 541.68079, 537.75302],[ 561.54494, 584.1817600000001]]]).
arc(arc01774,node00387,node01550,influence,[complete=true,name=i20,role=[use(none,in_hierarchy,pro_land,1)]],[course=[[ 521.00028, 481.02953],[ 539.63924, 530.54504],[ 561.54494, 581.1473999999999]]]).
arc(arc01775,node00387,node01550,influence,[complete=true,name=i21,role=[use(none,in_hierarchy,liquid_rel,1)]],[course=[[ 520.89815, 481.07123],[ 541.62231, 537.86831],[ 561.54494, 584.40743]]]).
arc(arc01776,node00387,node01550,influence,[complete=true,name=i22,role=[use(none,in_hierarchy,non_woody_rel,1)]],[course=[[ 520.87913, 481.07881],[ 541.51163, 538.0865],[ 561.54494, 584.83461]]]).
arc(arc01777,node00387,node01550,influence,[complete=true,name=i23,role=[use(none,in_hierarchy,woody_rel,1)]],[course=[[ 520.4843100000001, 481.22272],[ 534.04405, 527.59507],[ 561.54494, 580.9098]]]).
arc(arc01778,node00556,node01550,influence,[complete=true,name=i24,role=[use(none,in_hierarchy,surface,1)]],[course=[[ 512.81131, 479.41061],[ 503.46103, 488.76176],[ 479.44344, 508.20077]]]).
arc(arc01783,node01535,node01550,influence,[complete=true,name=i28,role=[use(none,in_hierarchy,'Forest_rel',1)]],[course=[[ 510.63534, 473.54586],[ 192.2162, 449.65449],[ -30.200467, 424.86725]]]).
arc(arc01779,node00629,node01584,flow,[complete=true,name='forest decline\noutside surplus'],[bowtie=[ 437.10862, 366.24962, 449.60862, 391.24962],caption_offset=[ 21.475809, 2.8634412],course=[[ 501.32358, 378.74962],[ 385.39366, 378.74962]]]).
arc(arc01780,node01585,arc01779,influence,[name=i25],[]).
arc(arc01781,node01260,node01585,influence,[complete=true,name=i26,role=[use(none,in_hierarchy,'Max_to_remove',1)]],[course=[[ 449.60862, 386.19807],[ 466.40126, 406.21076],[ 513.56997, 468.14054]]]).
arc(arc01782,node00629,node01585,influence,[complete=true,name=i27,role=[use(none,in_hierarchy,forest_area_outside_surplus,1)]],[course=[[ 437.10862, 371.58716],[ 419.73642, 351.67875],[ 385.39366, 368.78661]]]).
arc(arc00017,node00068,node00095,influence,[complete=true,name=i3],[course=[[ -25.613405, 2395.6135],[ 95.85531, 2393.7732],[ 178.98582, 2393.9773]]]).
arc(arc00107,node00107,node00068,influence,[complete=true,name=i19],[course=[[ 178.98576, 2438.5149],[ 95.99327, 2436.7713],[ -25.613405, 2432.9833]]]).
arc(arc00384,node00108,node00068,influence,[complete=true,name=i4],[course=[[ 496.50367, 693.24222],[ 348.62148, 359.73056],[ -23.022715, 249.4063]]]).
arc(arc00117,node00068,node00114,influence,[complete=true,name=i35],[course=[[ -25.613405, 2490.4841],[ 79.49136799999999, 2488.9634],[ 178.98582, 2489.4873]]]).
arc(arc00385,node00118,node00068,influence,[name=i25],[course=[[ 269.46957, 713.34209],[ 236.43142, 419.90429],[ -23.979918, 262.31294]]]).
arc(arc00089,node00072,node00126,relation,[complete=true,name=role1],[course=[[ -25.613405, 3587.9254],[ 39.024325, 3589.9749],[ 249.46983, 3588.4528]]]).
arc(arc00123,node00068,node00138,influence,[complete=true,name=i44],[course=[[ -25.61341, 2578.6085],[ 115.8639, 2583.6447],[ 178.98582, 2579.4116]]]).
arc(arc00150,node00170,node00068,influence,[complete=true,name=i56],[course=[[ 178.98576, 2670.4783],[ 86.814582, 2671.6176],[ -25.613405, 2670.7124]]]).
arc(arc00412,node00182,node00068,influence,[complete=true,name=i11],[course=[[ 178.98576, 1728.9208],[ 70.58493300000001, 1728.0542],[ -25.613405, 1730.5979]]]).
arc(arc00418,node00188,node00068,influence,[complete=true,name=i7],[course=[[ 178.98576, 1517.1361],[ 80.512263, 1514.976],[ -25.613405, 1516.226]]]).
arc(arc00145,node00072,node00198,influence,[complete=true,name=i10],[course=[[ -25.613405, 3678.0437],[ 38.769426, 3676.4612],[ 242.28881, 3676.2214]]]).
arc(arc00346,node00210,node00068,influence,[complete=true,name=i41],[course=[[ 178.98576, 1001.964],[ 95.993202, 1002.1162],[ -25.613405, 1002.0375]]]).
arc(arc00423,node00214,node00068,influence,[complete=true,name=i46],[course=[[ 263.84091, 716.03298],[ 364.82807, 295.98594],[ 86.169268, -39.265234]]]).
arc(arc00424,node00218,node00068,influence,[complete=true,name=i68],[course=[[ 313.9019, 698.60901],[ 385.49374, 277.59778],[ 86.169268, -39.265234]]]).
arc(arc00153,node00068,node00225,influence,[complete=true,name=i60],[course=[[ -25.613405, 2700.2834],[ 101.92867, 2702.0332],[ 178.98576, 2700.1706]]]).
arc(arc00437,node00236,node00068,influence,[complete=true,name=i99],[course=[[ 443.47465, 693.24222],[ 448.9357, 249.8696],[ 86.169268, -39.265234]]]).
arc(arc00186,node00244,node00068,influence,[complete=true,name=i73],[course=[[ 178.98576, 2729.514],[ 71.35414, 2729.9691],[ -25.613405, 2728.3798]]]).
arc(arc00195,node00068,node00246,influence,[complete=true,name=i76],[course=[[ -25.613405, 2820.1567],[ 95.872074, 2818.9843],[ 178.98576, 2819.8565]]]).
arc(arc00256,node00068,node00250,influence,[complete=true,name=i89],[course=[[ -25.613405, 2899.5985],[ 141.19845, 2901.7836],[ 178.98576, 2900.3564]]]).
arc(arc00283,node00256,node00068,influence,[complete=true,name=i105],[course=[[ 178.98576, 2995.0424],[ 120.45597, 2995.9963],[ -25.613405, 2994.9056]]]).
arc(arc00286,node00068,node00260,influence,[complete=true,name=i111],[course=[[ -25.613405, 3013.5264],[ 106.69798, 3012.4279],[ 178.98576, 3013.3738]]]).
arc(arc00267,node00068,node00301,influence,[complete=true,name=i43],[course=[[ -25.613405, 1355.5783],[ 94.076138, 1341.8117],[ 178.98576, 1328.2759]]]).
arc(arc00355,node00314,node00068,influence,[complete=true,name=i52],[course=[[ 178.98576, 1211.0141],[ 65.52088999999999, 1210.0862],[ -25.613405, 1208.9273]]]).
arc(arc00484,node00319,node00068,influence,[complete=true,name=i40],[course=[[ 220.18032, 746.28293],[ 242.96785, 410.66192],[ -15.316755, 187.9894]]]).
arc(arc00297,node00322,node00068,influence,[complete=true,name=i120],[course=[[ 178.98576, 3028.7176],[ 69.05521400000001, 3028.0808],[ -25.613405, 3025.3996]]]).
arc(arc00300,node00068,node00324,influence,[complete=true,name=i124],[course=[[ -25.613395, 3229.6513],[ 95.598533, 3228.5913],[ 178.98576, 3229.7782]]]).
arc(arc00306,node00068,node00328,influence,[complete=true,name=i129],[course=[[ -25.613405, 3150.1286],[ 73.81832, 3148.5304],[ 178.98576, 3148.9767]]]).
arc(arc00379,node00335,node00068,influence,[complete=true,name=i140],[course=[[ 179.41996, 3313.2645],[ 79.24266799999999, 3311.5039],[ -25.613405, 3313.1532]]]).
arc(arc00381,node00068,node00337,influence,[complete=true,name=i53],[course=[[ -25.613395, 1208.3513],[ 80.225309, 1209.6986],[ 178.98576, 1211.2767]]]).
arc(arc00260,node00068,node00373,influence,[complete=true,name=i13],[course=[[ -25.613405, 1861.0003],[ 59.336238, 1847.349],[ 178.98576, 1828.2715]]]).
arc(arc00432,node00460,node00068,influence,[complete=true,name=i66],[course=[[ 178.98576, 1002.7081],[ 96.784308, 1002.0559],[ -25.613405, 1001.1728]]]).
arc(arc00454,node00068,node00473,influence,[complete=true,name=i95],[course=[[ -25.613395, 1017.5872],[ 66.635892, 1019.536],[ 178.98576, 1021.7156]]]).
arc(arc00544,node00072,node00500,influence,[complete=true,name=i146],[course=[[ -25.613405, 4125.9558],[ 223.03462, 4126.1287],[ 242.28881, 4124.3284]]]).
arc(arc00538,node00072,node00626,influence,[complete=true,name=i158],[course=[[ -25.613405, 3630.7663],[ 179.52216, 3633.233],[ 242.28881, 3630.2247]]]).
arc(arc00738,node00072,node00649,influence,[complete=true,name=i190],[course=[[ -25.613405, 3822.9403],[ 94.36858700000001, 3822.7728],[ 242.28881, 3822.8913]]]).
arc(arc00747,node00072,node00656,influence,[complete=true,name=i199],[course=[[ -25.613405, 3758.4532],[ 110.05402, 3806.1091],[ 242.28881, 3853.6634]]]).
arc(arc00811,node00673,node00072,influence,[complete=true,name=i220],[course=[[ 242.28881, 3770.4147],[ 210.11798, 3797.4974],[ -25.613405, 3922.3159]]]).
arc(arc01142,node00699,node00072,influence,[complete=true,name=i259],[course=[[ 242.28881, 4020.4804],[ 86.478014, 4020.3888],[ -25.613405, 4020.3989]]]).
arc(arc01181,node00068,node00750,influence,[complete=true,name=i101],[course=[[ -25.613395, 3332.0922],[ 83.613894, 3334.9841],[ 181.74513, 3332.4403]]]).
arc(arc00616,node00068,node00839,influence,[complete=true,name=i54],[course=[[ -25.613395, 1079.7314],[ 75.11621599999999, 1081.0118],[ 178.98576, 1082.5231]]]).
arc(arc00052,node00854,node00068,influence,[complete=true,name=i6],[course=[[ 1365.3526, 693.24222],[ 1320.0585, 653.7422],[ 1237.5795, 618.87249]]]).
arc(arc00245,node00854,node00068,influence,[complete=true,name=i48],[course=[[ 1459.2118, 693.24222],[ 1383.8758, 614.7441700000001],[ 1250.2981, 576.75873]]]).
arc(arc00255,node00854,node00068,influence,[complete=true,name=i57],[course=[[ 1456.7063, 693.24222],[ 1384.7596, 611.11298],[ 1250.3605, 568.33755]]]).
arc(arc00314,node00854,node00072,influence,[complete=true,name=i61],[course=[[ 242.28881, 3645.4312],[ 1536.1953, 2317.708],[ 1250.3605, 485.94895]]]).
arc(arc00319,node00854,node00068,influence,[complete=true,name=i62],[course=[[ 1260.9347, 693.24222],[ 1197.2066, 667.94607],[ 1117.1165, 660.51825]]]).
arc(arc00323,node00854,node00068,influence,[complete=true,name=i67],[course=[[ 1248.8806, 693.24222],[ 1180.586, 665.36181],[ 1095.9295, 660.51825]]]).
arc(arc00328,node00854,node00068,influence,[complete=true,name=i72],[course=[[ 1142.4617, 693.24222],[ 1079.1873, 665.21415],[ 999.5508, 660.51825]]]).
arc(arc00332,node00854,node00068,influence,[complete=true,name=i78],[course=[[ 1038.0651, 693.24222],[ 980.62809, 665.52572],[ 906.82913, 660.51825]]]).
arc(arc00336,node00854,node00068,influence,[complete=true,name=i81],[course=[[ 1372.2145, 693.24222],[ 1363.1108, 588.93154],[ 1250.3605, 485.94895]]]).
arc(arc00476,node00453,node00854,influence,[complete=true,name=i45],[course=[[ 1024.7756, -35.914449],[ 800.35228, -78.56083],[ 541.68813, -97.668862]]]).
arc(arc00481,node00457,node00854,influence,[complete=true,name=i107],[course=[[ 1087.1488, -35.914449],[ 853.8369300000001, -77.74051300000001],[ 586.28418, -97.668862]]]).
arc(arc00485,node00854,node00068,influence,[complete=true,name=i47],[course=[[ 903.80686, 693.24222],[ 827.08627, 675.53589],[ 734.00368, 660.51825]]]).
arc(arc00486,node00854,node00068,influence,[complete=true,name=i106],[course=[[ 907.6284900000001, 693.24222],[ 828.99707, 674.79722],[ 734.00368, 660.51825]]]).
arc(arc00487,node00854,node00068,influence,[complete=true,name=i110],[course=[[ 914.1204, 693.24222],[ 832.24302, 673.54241],[ 734.00368, 660.51825]]]).
arc(arc00514,node00854,node00072,influence,[complete=true,name=i149],[course=[[ 242.28881, 3868.2425],[ 1552.312, 2492.2804],[ 1237.5562, 618.68465]]]).
arc(arc00568,node00518,node00854,influence,[complete=true,name=i116],[course=[[ 1149.2629, -35.914449],[ 907.09927, -76.92362300000001],[ 630.69483, -97.668862]]]).
arc(arc00572,node00522,node00854,influence,[complete=true,name=i121],[course=[[ 1197.2389, -26.252449],[ 955.28024, -68.090979],[ 674.24973, -97.668862]]]).
arc(arc00576,node00526,node00854,influence,[complete=true,name=i127],[course=[[ 634.26654, -35.914449],[ 481.38584, -72.118043],[ 294.26428, -97.668862]]]).
arc(arc00580,node00530,node00854,influence,[complete=true,name=i132],[course=[[ 709.77063, -35.914449],[ 549.80746, -68.445778],[ 355.60342, -97.668862]]]).
arc(arc00584,node00534,node00854,influence,[complete=true,name=i138],[course=[[ 783.75597, -35.914449],[ 616.8527800000001, -64.84737800000001],[ 415.70875, -97.668862]]]).
arc(arc00588,node00538,node00854,influence,[complete=true,name=i142],[course=[[ 852.94605, -35.914449],[ 679.5526599999999, -61.482195],[ 471.91845, -97.668862]]]).
arc(arc00622,node00854,node00068,influence,[complete=true,name=i115],[course=[[ 901.87099, 693.24222],[ 826.11833, 675.91007],[ 734.00368, 660.51825]]]).
arc(arc00625,node00854,node00072,influence,[complete=true,name=i123],[course=[[ 242.37581, 3620.4306],[ 1228.1678, 2263.3814],[ 734.00368, 660.51825]]]).
arc(arc00718,node00854,node00072,influence,[complete=true,name=i170],[course=[[ 242.28881, 3941.3504],[ 1587.4413, 2511.0563],[ 1250.2976, 576.75785]]]).
arc(arc00723,node00854,node00072,influence,[complete=true,name=i175],[course=[[ 242.28881, 3870.0852],[ 1571.7616, 2471.2293],[ 1250.3605, 568.33755]]]).
arc(arc00772,node00737,node00854,influence,[complete=true,name=i30,role=[use(none,in_hierarchy,rand_par,1)]],[course=[[ 237.19995, 56.79009],[ 127.1305, 55.691041],[ -16.612841, 56.44653]]]).
arc(arc00799,node00854,node00826,influence,[complete=true,name=i14],[course=[[ -25.613395, 186.63714],[ 117.3301, 183.88765],[ 237.19995, 185.73141]]]).
arc(arc01027,node00842,node00854,influence,[complete=true,name=i137,role=[use(none,in_hierarchy,[diff_pond],array(1,304))]],[course=[[ 237.19995, 234.25909],[ 139.04292, 243.24069],[ -25.613405, 266.19965]]]).
arc(arc01034,node00854,node00843,influence,[complete=true,name=i139],[course=[[ -25.613405, 337.55407],[ 116.23249, 351.46498],[ 237.19995, 363.52133]]]).
arc(arc01300,node00854,node00068,influence,[complete=true,name=i49],[course=[[ 1125.3952, 693.24222],[ 1135.9786, 678.08144],[ 1130.2001, 660.51825]]]).
arc(arc01685,node00854,node00068,influence,[complete=true,name=i185],[course=[[ 544.70451, 693.24222],[ 537.83641, 669.35569],[ 514.60632, 660.51825]]]).
arc(arc01764,node00068,node00854,influence,[complete=true,name=i272],[course=[[ 1190.4395, 656.18181],[ 1187.3792, 677.81439],[ 1202.849, 693.24222]]]).
arc(arc00465,node00444,node00400,influence,[name=i1],[]).
arc(arc00467,node00445,node00400,influence,[complete=true,name=i2],[course=[[ 825.66381, 69.590475],[ 662.48472, -3.5865662],[ 787.14721, -17.375892]]]).
arc(arc00479,node00455,node00454,influence,[name=i49],[]).
arc(arc00480,node00456,node00454,influence,[complete=true,name=i50],[course=[[ 827.98267, 144.80204],[ 708.58023, 45.264534],[ 849.64491, -17.375892]]]).
arc(arc00566,node00516,node00515,influence,[name=i111],[]).
arc(arc00567,node00517,node00515,influence,[complete=true,name=i112],[course=[[ 835.78269, 206.70584],[ 760.07556, 92.199744],[ 911.88292, -17.375892]]]).
arc(arc00570,node00520,node00519,influence,[name=i119],[]).
arc(arc00571,node00521,node00519,influence,[complete=true,name=i120],[course=[[ 836.25392, 281.36261],[ 805.45362, 145.6322],[ 959.95467, -7.6946121]]]).
arc(arc00574,node00524,node00523,influence,[name=i124],[]).
arc(arc00575,node00525,node00523,influence,[complete=true,name=i126],[course=[[ 925.14772, 61.807232],[ 520.7731700000001, -108.53176],[ 395.85893, -17.375892]]]).
arc(arc00578,node00528,node00527,influence,[name=i129],[]).
arc(arc00579,node00529,node00527,influence,[complete=true,name=i130],[course=[[ 929.07458, 138.04726],[ 579.61874, -52.304856],[ 471.51368, -17.375892]]]).
arc(arc00582,node00532,node00531,influence,[name=i135],[]).
arc(arc00583,node00533,node00531,influence,[complete=true,name=i136],[course=[[ 931.77727, 214.48795],[ 638.7898, 4.3846238],[ 545.64666, -17.375892]]]).
arc(arc00586,node00536,node00535,influence,[name=i140],[]).
arc(arc00587,node00537,node00535,influence,[complete=true,name=i141],[course=[[ 932.16, 281.35369],[ 694.67909, 56.407324],[ 614.97481, -17.375892]]]).
arc(arc00511,node00723,node00466,influence,[complete=true,name=i146],[course=[[ 1000.3758, 638.71766],[ 745.90347, 467.62565],[ 447.45852, 560.94747]]]).
arc(arc00793,node00754,node00753,influence,[name=i12],[]).
arc(arc00763,node00753,node01010,influence,[complete=true,name=i146],[course=[[ 87.69697499999999, 52.388212],[ 73.05671599999999, 53.094796],[ 60.224031, 55.695673]]]).
arc(arc01109,node01015,node00754,influence,[complete=true,name=i20_0,role=[use(none,in_hierarchy,urb_surface,1)]],[course=[[ 45.559129, 55.527072],[ 30.12906, 52.028621],[ 11.177065, 48.562217]]]).
arc(arc01113,node01017,node00754,influence,[complete=true,name=i21_0,role=[use(none,in_hierarchy,surface,1)]],[course=[[ 46.026159, 60.245543],[ 37.255826, 64.16503299999999],[ 11.177065, 69.295405]]]).
arc(arc00591,node00400,node00736,influence,[complete=true,name=i145],[course=[[ 765.93694, 208.51278],[ 791.4779, 163.17383],[ 829.41078, 79.49034]]]).
arc(arc00593,node00454,node00736,influence,[complete=true,name=i147],[course=[[ 765.93694, 207.12269],[ 794.6074, 174.98803],[ 827.45113, 153.68564]]]).
arc(arc00595,node00515,node00736,influence,[complete=true,name=i149],[course=[[ 765.93694, 208.50737],[ 806.28801, 207.62015],[ 832.51193, 211.78553]]]).
arc(arc00597,node00519,node00736,influence,[complete=true,name=i152],[course=[[ 765.93694, 207.61169],[ 783.50522, 221.28712],[ 833.34624, 282.72781]]]).
arc(arc00599,node00523,node00736,influence,[complete=true,name=i154],[course=[[ 765.93694, 206.16473],[ 838.45708, 140.65757],[ 926.23522, 69.44396500000001]]]).
arc(arc00601,node00527,node00736,influence,[complete=true,name=i156],[course=[[ 765.93694, 205.65747],[ 860.91002, 167.72139],[ 928.5796800000001, 144.10606]]]).
arc(arc00603,node00531,node00736,influence,[complete=true,name=i158],[course=[[ 765.93694, 207.18219],[ 849.29971, 212.27884],[ 930.39274, 218.30299]]]).
arc(arc00605,node00535,node00736,influence,[complete=true,name=i165],[course=[[ 765.93694, 208.28736],[ 843.36785, 243.20915],[ 930.79008, 283.37986]]]).
arc(arc00764,node00725,node00724,influence,[complete=true,name=i4],[course=[[ -1.1368684e-13, 150.5282],[ 92.022367, 149.25738],[ 184.69813, 151.68656]]]).
arc(arc00237,node00195,node00726,influence,[complete=true,name=i1,role=[use(none,in_hierarchy,random,1)]],[course=[[ 184.83942, 150.4211],[ 69.258499, 127.45025],[ -5.6843419e-14, 110.27555]]]).
arc(arc00590,node00539,node00726,influence,[complete=true,name=i144,role=[use(none,in_hierarchy,usr(pds_large),int)]],[course=[[ 199.69497, 151.97597],[ 302.72861, 153.2522],[ 340.57087, 154.29946]]]).
arc(arc00592,node00540,node00726,influence,[complete=true,name=i146,role=[use(none,in_hierarchy,usr(pds_med),int)]],[course=[[ 199.68807, 152.21796],[ 287.57108, 156.14599],[ 340.57087, 152.90937]]]).
arc(arc00594,node00541,node00726,influence,[complete=true,name=i148,role=[use(none,in_hierarchy,usr(pds_small),int)]],[course=[[ 199.69539, 151.93223],[ 278.61445, 152.44949],[ 340.57087, 154.29405]]]).
arc(arc00596,node00542,node00726,influence,[complete=true,name=i151,role=[use(none,in_hierarchy,usr(pds_rural),int)]],[course=[[ 199.68607, 152.25996],[ 274.95287, 156.04701],[ 340.57087, 153.39837]]]).
arc(arc00598,node00543,node00726,influence,[complete=true,name=i153,role=[use(none,in_hierarchy,usr(dist_to_roads_threshold),1)]],[course=[[ 199.69162, 152.12583],[ 294.0502, 155.18151],[ 340.57087, 151.95141]]]).
arc(arc00600,node00544,node00726,influence,[complete=true,name=i155,role=[use(none,in_hierarchy,usr(dist_to_sm_threshold),1)]],[course=[[ 199.6952, 151.95562],[ 288.32371, 152.81297],[ 340.57087, 151.44415]]]).
arc(arc00602,node00545,node00726,influence,[complete=true,name=i157,role=[use(none,in_hierarchy,usr(dist_to_med_threshold),1)]],[course=[[ 199.69553, 151.86459],[ 285.40797, 151.65337],[ 340.57087, 152.96887]]]).
arc(arc00604,node00546,node00726,influence,[complete=true,name=i159,role=[use(none,in_hierarchy,usr(dist_to_large_threshold),1)]],[course=[[ 199.69418, 151.73968],[ 277.8378, 150.24536],[ 340.57087, 154.07404]]]).
arc(arc00765,node00722,node00726,influence,[complete=true,name=i12_0,role=[use(none,in_hierarchy,usr(rural),int)]],[course=[[ 199.11369, 148.98665],[ 239.35447, 132.13897],[ 286.97669, 123.14574]]]).
arc(arc00766,node00726,node00725,influence,[name=i2],[]).
arc(arc00767,node00728,node00726,influence,[complete=true,name=i5_0,role=[use(none,in_hierarchy,usr('Dist_to_small_cities'),1)]],[course=[[ 186.84866, 146.62373],[ 156.79001, 117.05725],[ 121.78651, 78.871267]]]).
arc(arc00768,node00729,node00726,influence,[complete=true,name=i6_0,role=[use(none,in_hierarchy,usr('Dist_to_medium_cities'),1)]],[course=[[ 193.24681, 144.45712],[ 194.99262, 132.12494],[ 200.62134, 80.890064]]]).
arc(arc00769,node00730,node00726,influence,[complete=true,name=i7_0,role=[use(none,in_hierarchy,usr('Dist_to_large_cities'),1)]],[course=[[ 198.07983, 147.23278],[ 221.06598, 129.06701],[ 287.04951, 82.25387000000001]]]).
arc(arc00770,node00731,node00726,influence,[complete=true,name=i4_0,role=[use(none,in_hierarchy,usr('Dist_to_roads'),1)]],[course=[[ 185.32262, 148.88095],[ 153.46535, 134.96553],[ 54.31682, 79.918065]]]).
arc(arc00771,node00733,node00732,influence,[name=i24],[]).
arc(arc00774,node00735,node00734,influence,[name=i33],[]).
arc(arc00775,node00732,node00735,influence,[complete=true,name=i34_0,role=[use(none,in_hierarchy,usr(suittot),1)]],[course=[[ 103.35158, 202.08765],[ 91.614614, 202.52492],[ 64.281099, 202.90714]]]).
arc(arc01108,node00725,node00735,influence,[complete=true,name=i31,role=[use(none,in_hierarchy,'Suitability_index',1)]],[course=[[ 117.3034, 197.69373],[ 167.62562, 168.31268],[ 185.96099, 156.05205]]]).
arc(arc00801,node00756,node00726,influence,[complete=true,name=i46,role=[use(none,in_hierarchy,usr('IDNUTS'),1)]],[course=[[ 184.87189, 153.49988],[ 142.90043, 162.7657],[ -5.6843419e-14, 200.31163]]]).
arc(arc00902,node00827,node00726,influence,[complete=true,name=i120,role=[use(none,in_hierarchy,usr(espace),1)]],[course=[[ 190.61436, 159.21451],[ 177.59329, 219.58862],[ 168.04779, 252.9955]]]).
arc(arc00912,node00828,node00726,influence,[complete=true,name=i122,role=[use(none,in_hierarchy,usr(surface),1)]],[course=[[ 187.58791, 157.80082],[ 152.30812, 203.11189],[ 109.74983, 252.9955]]]).
arc(arc01117,node01026,node00733,influence,[complete=true,name=i150,role=[use(none,in_hierarchy,[suittot],array(1,304))]],[course=[[ 49.281875, 203.03757],[ 32.65413, 202.53897],[ 5.6843419e-14, 201.55707]]]).
arc(arc01123,node01031,node00733,influence,[complete=true,name=i154,role=[use(none,in_hierarchy,'IDNUTS',1)]],[course=[[ 49.281855, 202.99325],[ 34.768412, 202.95693],[ -5.6843419e-14, 200.31163]]]).
arc(arc01137,node00734,node01060,influence,[complete=true,name=i165],[course=[[ 58.272969, 252.9955],[ 84.556048, 230.98591],[ 105.83969, 207.07721]]]).
arc(arc01293,node01130,node00726,influence,[complete=true,name=i20,role=[use(none,in_hierarchy,flood_coefficient,1)]],[course=[[ 197.48873, 157.19648],[ 250.67193, 210.5828],[ 311.80507, 252.85058]]]).
arc(arc00720,node00738,node00638,influence,[complete=true,name=i172],[course=[[ 1013.1823, 588.08188],[ 868.42908, 404.07214],[ 638.90388, 402.9505]]]).
arc(arc00311,node00739,node00267,influence,[complete=true,name=i5],[course=[[ 1013.1823, 505.52887],[ 773.00435, 445.01822],[ 603.44503, 626.92764]]]).
arc(arc00317,node00740,node00418,influence,[complete=true,name=i59],[course=[[ 879.6724400000001, 680.4465300000001],[ 820.2935, 539.84036],[ 680.96682, 486.5422]]]).
arc(arc00325,node00741,node00432,influence,[complete=true,name=i70],[course=[[ 761.87211, 680.4465300000001],[ 742.18576, 601.62566],[ 685.17189, 576.03378]]]).
arc(arc00330,node00742,node00436,influence,[complete=true,name=i75],[course=[[ 668.96541, 680.4465300000001],[ 673.4439, 629.63605],[ 655.0377099999999, 610.58755]]]).
arc(arc00321,node00743,node00423,influence,[complete=true,name=i64],[course=[[ 858.44311, 680.4465300000001],[ 803.8047, 568.79148],[ 694.45092, 534.1728900000001]]]).
arc(arc00906,node00745,node00736,influence,[complete=true,name=i121],[course=[[ 593.41386, 307.20883],[ 542.42768, 483.54278],[ 521.93268, 545.18592]]]).
arc(arc00777,node00738,node00746,influence,[complete=true,name=i24_0,role=[use(none,in_hierarchy,usr(inland_waters_0),1)]],[course=[[ 524.06843, 546.30435],[ 569.86893, 485.2789],[ 624.83989, 406.30516]]]).
arc(arc00778,node00739,node00746,influence,[complete=true,name=i52_0,role=[use(none,in_hierarchy,usr(pro_land),1)]],[course=[[ 526.09963, 555.98628],[ 548.1160599999999, 568.39915],[ 591.58117, 623.15117]]]).
arc(arc00779,node00743,node00746,influence,[complete=true,name=i67_0,role=[use(none,in_hierarchy,usr(pro_pcrop),1)]],[course=[[ 527.01733, 551.44589],[ 623.157, 540.3882],[ 680.85757, 529.26518]]]).
arc(arc00780,node00741,node00746,influence,[complete=true,name=i68_0,role=[use(none,in_hierarchy,usr(pro_crop),1)]],[course=[[ 526.9875, 553.38822],[ 606.74333, 565.05269],[ 672.00985, 569.09146]]]).
arc(arc00781,node00742,node00746,influence,[complete=true,name=i69_0,role=[use(none,in_hierarchy,usr(pro_grass),1)]],[course=[[ 526.62086, 554.8495],[ 583.02581, 575.21162],[ 643.7709, 600.78113]]]).
arc(arc00782,node00740,node00746,influence,[complete=true,name=i70_0,role=[use(none,in_hierarchy,usr(pro_forest),1)]],[course=[[ 526.33753, 549.07759],[ 618.65262, 505.10503],[ 667.96998, 482.1956]]]).
arc(arc00783,node00746,node00745,influence,[name=i4],[]).
arc(arc00792,node00723,node00746,influence,[complete=true,name=i5_0,role=[use(none,in_hierarchy,usr('Urb_dens'),1)]],[course=[[ 512.11376, 553.14393],[ 471.56084, 557.7204400000001],[ 447.45852, 560.94747]]]).
arc(arc00794,node00747,node00723,influence,[complete=true,name=i20_0,role=[use(none,in_hierarchy,urb_surface,1)]],[course=[[ 370.93861, 557.12147],[ 317.87223, 461.98308],[ 277.47659, 397.89756]]]).
arc(arc00784,node00744,node00748,influence,[complete=true,name=i3,role=[use(none,in_hierarchy,usr(urbbase),1)]],[course=[[ 264.62714, 397.89756],[ 246.51263, 477.94741],[ 229.61884, 535.23196]]]).
arc(arc00785,node00748,node00747,influence,[name=i10],[]).
arc(arc00715,node00751,node00633,influence,[complete=true,name=i167],[course=[[ 1013.1198, 596.51986],[ 866.52908, 440.29194],[ 659.54385, 448.8072]]]).
arc(arc00789,node00751,node00746,influence,[complete=true,name=i6_0,role=[use(none,in_hierarchy,usr(sea_dens),1)]],[course=[[ 525.2747900000001, 547.43822],[ 594.02919, 488.84565],[ 645.57124, 449.09154]]]).
arc(arc00611,node00752,node00116,influence,[complete=true,name=i20],[course=[[ 495.79509, 680.44652],[ 263.81252, 591.06873],[ 302.69594, 589.10128]]]).
arc(arc00791,node00752,node00748,influence,[complete=true,name=i13_0,role=[use(none,in_hierarchy,surface,1)]],[course=[[ 269.98282, 397.89756],[ 277.60825, 456.21585],[ 306.98023, 578.81399]]]).
arc(arc00795,node00752,node00723,influence,[complete=true,name=i21_0,role=[use(none,in_hierarchy,surface,1)]],[course=[[ 370.93861, 577.85466],[ 355.85432, 579.93459],[ 316.91159, 584.93295]]]).
arc(arc00921,node00752,node00736,influence,[complete=true,name=i123],[course=[[ 535.11589, 307.20883],[ 387.67422, 477.77011],[ 314.26772, 580.12087]]]).
arc(arc00773,node00736,node00755,influence,[complete=true,name=i8],[course=[[ -2.0, 204.71226],[ 210.92986, 203.35295],[ 425.36607, 204.74153]]]).
arc(arc00802,node00758,node00736,influence,[complete=true,name=i47],[course=[[ 425.36607, 254.52495],[ 302.93285, 212.56163],[ 150.24218, 162.2307]]]).
arc(arc00796,node00760,node00759,influence,[name=i25],[]).
arc(arc00797,node00758,node00760,influence,[complete=true,name=i29_0,role=[use(none,in_hierarchy,'IDNUTS',1)]],[course=[[ 141.87212, 218.34994],[ 140.20752, 182.374],[ 142.15628, 167.3207]]]).
arc(arc00800,node00761,node00736,influence,[complete=true,name=i45],[course=[[ 425.36607, 164.48888],[ 243.24792, 100.3237],[ 147.78951, 75.063906]]]).
arc(arc00798,node00762,node00761,influence,[name=i14],[]).
arc(arc01078,node00747,node00934,influence,[complete=true,name=i139],[course=[[ -2.0, 382.85695],[ 163.66714, 383.41193],[ 248.0215, 382.99614]]]).
arc(arc01080,node00963,node00760,influence,[complete=true,name=i137,role=[use(none,in_hierarchy,[diff_pond],array(1,304))]],[course=[[ 135.08188, 227.43737],[ 76.393987, 237.62904],[ -2.0, 253.33677]]]).
arc(arc01084,node00964,node00762,influence,[complete=true,name=i30,role=[use(none,in_hierarchy,rand_par,1)]],[course=[[ 133.04053, 73.29395599999999],[ 108.24958, 73.785354],[ -2.0, 75.513633]]]).
arc(arc01118,node01029,node00736,influence,[complete=true,name=i151],[course=[[ 425.36607, 255.77039],[ 233.49579, 254.8424],[ -2.0, 255.3045]]]).
arc(arc01124,node00758,node01033,influence,[complete=true,name=i155],[course=[[ -2.0, 157.40729],[ 70.835249, 156.82878],[ 135.62586, 159.56618]]]).
arc(arc01131,node01055,node00747,flow,[complete=true,name='Accr_urb'],[bowtie=[ 390.62482, 366.99325, 403.12482, 391.99325],caption_offset=[ -47.262896, -9.7305963],course=[[ 288.02149, 379.49325],[ 505.72814, 379.49325]]]).
arc(arc01132,node01059,arc01131,influence,[name=i160],[]).
arc(arc01133,node00752,node01059,influence,[complete=true,name=i161,role=[use(none,in_hierarchy,surface,1)]],[course=[[ 391.75895, 391.99325],[ 359.08108, 471.83763],[ 312.73079, 579.13244]]]).
arc(arc01134,node00745,node01059,influence,[complete=true,name=i162,role=[use(none,in_hierarchy,espace,1)]],[course=[[ 403.12482, 388.51094],[ 450.13903, 456.34443],[ 515.17011, 546.22651]]]).
arc(arc01135,node00759,node01059,influence,[complete=true,name=i163,role=[use(none,in_hierarchy,urbdiff,1)]],[course=[[ 390.62482, 375.58771],[ 271.28945, 301.01663],[ 148.81425, 229.73045]]]).
arc(arc01138,node00736,node01059,influence,[complete=true,name=i166,role=[use(none,in_hierarchy,suitrel,1)]],[course=[[ 403.12482, 374.90061],[ 452.23411, 338.81401],[ 483.63904, 307.20883]]]).
arc(arc00421,node01127,node01126,influence,[name=i6],[]).
arc(arc01294,node01128,node00736,influence,[complete=true,name=i21],[course=[[ 737.17114, 307.06391],[ 762.41574, 328.32236],[ 783.49815, 350.34179]]]).
arc(arc01275,node01126,node01129,influence,[complete=true,name=i19,role=[use(none,in_hierarchy,flood_sensitivity,1)]],[course=[[ 792.35298, 362.16802],[ 812.25606, 400.71722],[ 838.5925, 437.93859]]]).
arc(arc01276,node01129,node01128,influence,[name=i17],[]).
arc(arc01277,node00835,node01129,influence,[complete=true,name=i18,role=[use(none,in_hierarchy,'High_risks_floodable_areas',1)]],[course=[[ 796.35271, 356.76488],[ 887.54378, 372.65572],[ 929.02462, 382.14546]]]).
arc(arc01296,node00835,node01133,influence,[complete=true,name=i23],[course=[[ 892.78207, 680.4465300000001],[ 986.31615, 546.45854],[ 935.24621, 391.23849]]]).
arc(arc00466,node01182,node01126,influence,[complete=true,name=i7],[course=[[ 840.08106, 437.1209],[ 860.59943, 163.31959],[ 653.8694, -17.375897]]]).
arc(arc01484,node00758,node01322,influence,[complete=true,name=i180],[course=[[ 275.95993, 680.4465300000001],[ 338.79094, 391.05163],[ 144.97364, 167.14988]]]).
arc(arc01765,node01566,node00746,influence,[complete=true,name=i273,role=[use(none,in_hierarchy,'Agro_threshold',1)]],[course=[[ 522.28179, 559.29407],[ 533.454, 588.05925],[ 543.1556, 621.75789]]]).
arc(arc01761,node01567,node01566,influence,[name=i269],[]).
arc(arc01763,node01569,node01566,influence,[complete=true,name=i271],[course=[[ 547.6119, 636.07706],[ 726.90889, 663.94737],[ 953.14174, 676.1014300000001]]]).
arc(arc00873,node00072,node00882,influence,[complete=true,name=i32],[course=[[ -25.613405, 3756.214],[ 125.48053, 3788.4156],[ 242.28881, 3823.1377]]]).
arc(arc01071,node00068,node00955,influence,[complete=true,name=i167],[course=[[ -25.613405, 816.85846],[ 77.321866, 822.55449],[ 187.53278, 822.82451]]]).
arc(arc01087,node00854,node00981,relation,[complete=true,name=role2],[course=[[ 24.095752, -19.081351],[ 114.91374, -10.590859],[ 257.71338, -4.9919451]]]).
arc(arc00443,node00068,node01013,influence,[complete=true,name=i9],[course=[[ -25.613405, 1408.3956],[ 90.128311, 1408.4044],[ 178.98576, 1405.003]]]).
arc(arc00444,node00068,node01018,influence,[complete=true,name=i8],[course=[[ -25.613405, 1540.1502],[ 110.75767, 1536.9111],[ 178.98576, 1535.7165]]]).
arc(arc00488,node01019,node00068,influence,[complete=true,name=i16],[course=[[ 178.98576, 1473.1377],[ 134.74892, 1475.8616],[ -25.613405, 1476.5409]]]).
arc(arc00490,node01027,node00068,influence,[complete=true,name=i17],[course=[[ 178.98576, 1982.8808],[ 91.807316, 1983.9992],[ -25.613405, 1983.0729]]]).
arc(arc01121,node01030,node00854,influence,[complete=true,name=i152],[course=[[ 237.19995, 236.2229],[ 99.61403300000001, 226.09125],[ -25.613405, 218.01642]]]).
arc(arc00482,node00068,node01032,influence,[complete=true,name=i21],[course=[[ -25.613405, 1914.3931],[ 92.905936, 1916.0438],[ 178.98576, 1914.0821]]]).
arc(arc00483,node00068,node01034,influence,[complete=true,name=i34],[course=[[ -25.613405, 2059.4687],[ 72.828197, 2049.8678],[ 178.98576, 2036.8569]]]).
arc(arc01125,node00854,node01035,influence,[complete=true,name=i156],[course=[[ -25.613405, 131.60572],[ 142.11936, 133.3643],[ 237.19995, 138.52065]]]).
arc(arc00942,node01063,node00068,influence,[complete=true,name=i108],[course=[[ 178.98576, 1133.4112],[ 76.219942, 1124.9951],[ -25.613405, 1122.0051]]]).
arc(arc01217,node00068,node01066,influence,[complete=true,name=i173],[course=[[ -25.613405, 894.96371],[ 68.75308800000001, 898.30708],[ 178.98576, 896.22442]]]).
arc(arc00889,node01084,node00068,influence,[complete=true,name=i118],[course=[[ 178.98576, 2233.8539],[ 105.74432, 2231.6255],[ -25.613405, 2229.1661]]]).
arc(arc00943,node01089,node00068,influence,[complete=true,name=i144],[course=[[ 178.98576, 2023.6863],[ 76.782251, 2023.9744],[ -25.613405, 2024.0317]]]).
arc(arc01265,node00068,node01113,influence,[complete=true,name=i150],[course=[[ -25.613405, 2232.3168],[ 97.03052099999999, 2232.1196],[ 178.98576, 2232.1532]]]).
arc(arc01201,node00068,node01174,influence,[complete=true,name=i159],[course=[[ -25.613395, 2902.5927],[ 73.963813, 2967.8528],[ 178.98576, 3027.687]]]).
arc(arc00473,node01183,node00854,influence,[complete=true,name=i12],[course=[[ 891.76318, -35.914449],[ 926.968, -60.230648],[ 931.29565, -97.668862]]]).
arc(arc01353,node00068,node01186,influence,[complete=true,name=i176],[course=[[ -25.613405, 2606.336],[ 89.274559, 2668.8646],[ 178.98576, 2714.6536]]]).
arc(arc01377,node00072,node01216,influence,[complete=true,name=i18],[course=[[ -25.613395, 3532.9617],[ 842.41856, 3531.7118],[ 925.08538, 3532.9823]]]).
arc(arc01424,node00068,node01253,influence,[complete=true,name=i162],[course=[[ -25.613405, 788.56487],[ 82.05649200000001, 794.68531],[ 201.61793, 789.72054]]]).
arc(arc01436,node00068,node01263,influence,[complete=true,name=i177],[course=[[ -25.613395, 1280.9325],[ 90.674076, 1280.9136],[ 178.98576, 1281.1257]]]).
arc(arc01445,node00068,node01272,influence,[complete=true,name=i186],[course=[[ -25.613395, 1799.1504],[ 88.866023, 1798.6346],[ 178.98576, 1798.3496]]]).
arc(arc01466,node00068,node01303,influence,[complete=true,name=i171],[course=[[ -25.613405, 924.52089],[ 73.534156, 981.62117],[ 178.98576, 937.12897]]]).
arc(arc01485,node00854,node01323,influence,[complete=true,name=i181],[course=[[ -25.613405, 382.96139],[ 111.80591, 436.28589],[ 237.19995, 358.91083]]]).
arc(arc01595,node00068,node01427,influence,[complete=true,name=i163],[course=[[ -25.613405, 1405.8679],[ 71.417551, 1467.2014],[ 178.98576, 1426.9424]]]).
arc(arc01645,node00068,node01470,influence,[complete=true,name=i164],[course=[[ -25.613405, 1950.8473],[ 73.525862, 2007.9641],[ 178.98576, 1963.4885]]]).
arc(arc01680,node01501,node00068,influence,[complete=true,name=i178],[course=[[ 178.98576, 1361.3245],[ 126.61929, 1210.6621],[ -25.613405, 1161.5921]]]).
arc(arc01554,node00068,node01609,influence,[complete=true,name=i37],[course=[[ -25.613405, 1208.3716],[ 87.63990099999999, 1210.5081],[ 178.98576, 1212.1684]]]).
arc(arc01799,node00068,node01613,influence,[complete=true,name=i70],[course=[[ -25.613405, 1208.5185],[ 90.621039, 1210.6375],[ 178.98576, 1212.2803]]]).
arc(arc01807,node00068,node01621,influence,[complete=true,name=i79],[course=[[ -25.613405, 1729.5605],[ 88.532438, 1732.0339],[ 178.98576, 1728.3744]]]).
arc(arc01811,node00068,node01625,influence,[complete=true,name=i83],[course=[[ -25.613405, 1728.7843],[ 94.152235, 1731.9948],[ 178.98576, 1729.0723]]]).
arc(arc01819,node00068,node01633,influence,[complete=true,name=i91],[course=[[ -25.613405, 2230.6617],[ 97.273287, 2232.0815],[ 178.98576, 2233.0251]]]).
arc(arc01823,node00068,node01637,influence,[complete=true,name=i96],[course=[[ -25.613405, 2229.7338],[ 91.569216, 2231.3439],[ 178.98576, 2232.4778]]]).
arc(arc00129,node01114,node00846,influence,[complete=true,name=i14],[course=[[ 573.90532, -614.29143],[ 551.0344, -879.11942],[ 378.57063, -1023.642]]]).
arc(arc00138,node01117,node00846,influence,[name=i35],[course=[[ 572.94812, -601.38479],[ 598.713, -848.95839],[ 470.39025, -1022.4678]]]).
arc(arc00364,node01118,node00846,influence,[complete=true,name=i44],[course=[[ 581.61128, -675.70832],[ 628.9318500000001, -864.1398799999999],[ 550.9168100000001, -1012.1366]]]).
arc(arc01268,node01124,node00846,influence,[complete=true,name=i16],[course=[[ 1528.2235, -961.36654],[ 1527.4108, -997.02194],[ 1498.8703, -1024.9925]]]).
arc(arc01360,node01199,node00817,influence,[complete=true,name=i33],[course=[[ -532.85204, -250.61021],[ -504.69643, -289.14773],[ -493.61745, -304.98177]]]).
arc(arc01179,node01200,node01199,influence,[name=i19],[]).
arc(arc01364,node01201,node00817,influence,[complete=true,name=i38],[course=[[ -532.85203, -201.49329],[ -499.8808, -231.4678],[ -495.31306, -232.18377]]]).
arc(arc01187,node01202,node01201,influence,[name=i20],[]).
arc(arc01387,node01203,node00817,influence,[complete=true,name=i43],[course=[[ -532.85203, -155.26663],[ -510.16736, -154.17784],[ -491.11771, -152.12454]]]).
arc(arc01208,node01204,node01203,influence,[name=i27],[]).
arc(arc01391,node01220,node00817,influence,[complete=true,name=i50],[course=[[ -532.85203, -116.27739],[ -501.01124, -98.385347],[ -489.57477, -89.465372]]]).
arc(arc01244,node01221,node01220,influence,[name=i29],[]).
arc(arc01402,node01275,node00817,influence,[complete=true,name=i63],[course=[[ -532.85203, -159.42285],[ -353.23446, -176.96127],[ -259.49465, -331.17837]]]).
arc(arc00947,node01276,node01275,influence,[name=i39],[]).
arc(arc00948,node01179,node01276,influence,[complete=true,name=i40,role=[use(none,in_hierarchy,'T_BAMBU____2015',1)]],[course=[[ -260.56507, -336.25479],[ -293.8019, -341.94809],[ -348.88449, -343.44944]]]).
arc(arc00950,node00957,node01276,influence,[complete=true,name=i51,role=[use(none,in_hierarchy,'T_GRAS____2015',1)]],[course=[[ -259.43751, -339.24818],[ -301.38995, -366.44383],[ -330.60831, -388.61733]]]).
arc(arc00951,node01235,node01276,influence,[complete=true,name=i52,role=[use(none,in_hierarchy,'T_SEDG____2015',1)]],[course=[[ -260.18417, -332.58236],[ -270.98098, -326.5381],[ -333.91824, -299.90737]]]).
arc(arc01077,node01240,node01276,influence,[complete=true,name=i55,role=[use(none,in_hierarchy,'T_BAMBU___2015',1)]],[course=[[ -245.73299, -336.31947],[ -178.83782, -345.82988],[ -153.14787, -344.14471]]]).
arc(arc01395,node00959,node01276,influence,[complete=true,name=i56,role=[use(none,in_hierarchy,'T_GRAS___2015',1)]],[course=[[ -247.12386, -339.64133],[ -214.47317, -359.69664],[ -184.69774, -391.88801]]]).
arc(arc01396,node01237,node01276,influence,[complete=true,name=i58,role=[use(none,in_hierarchy,'T_SEDG___2015',1)]],[course=[[ -246.50804, -331.67393],[ -187.5111, -303.585],[ -168.01785, -294.49701]]]).
arc(arc01535,node01361,node00817,influence,[complete=true,name=i82],[course=[[ -532.85203, 11.145694],[ -150.8044, 0.31181264],[ 69.757076, -311.82662]]]).
arc(arc01527,node01362,node01361,influence,[name=i73],[]).
arc(arc01528,node01345,node01362,influence,[complete=true,name=i75,role=[use(none,in_hierarchy,'M_GRAS',1)]],[course=[[ 70.44012600000001, -319.96476],[ 30.984009, -350.55328],[ -3.8436099, -375.99882]]]).
arc(arc01529,node01347,node01362,influence,[complete=true,name=i76,role=[use(none,in_hierarchy,'M_BAMBU',1)]],[course=[[ 68.958333, -316.53319],[ 52.791559, -317.99127],[ 0.42888967, -318.17206]]]).
arc(arc01530,node01359,node01362,influence,[complete=true,name=i77,role=[use(none,in_hierarchy,'M_SEDG',1)]],[course=[[ 70.70872799999999, -310.44731],[ 50.505268, -289.61419],[ -0.66503911, -258.45872]]]).

