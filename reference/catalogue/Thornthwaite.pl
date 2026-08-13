source(program='AME',version= 9.0,edition=standard,date='Wed Feb 06 17:30:42 GMT 2008').

roots([node00004,node00005,node00006,node00010,node00011,node00013,node00014,node00116,node00119,node00137,node00138,node00151,node00152]).

properties([complete-true,file_name-'F:/Program Files/www/examples/catalogue/models/Thornthwaite/Thornthwaite.sml',fill_colour-'#ffffff',multiplication_spec-[count=[]],name-'Thornthwaite',separate-0]).

node(node00004,variable,[],[comment='Model time step is one month.',complete=true,description='Month of year',name=month],[caption_offset=[0,0],centre=[178,224]]).
node(node00005,function,[],[complete=true,name=fn1,spec=[116,105,109,101,40,41,43,49],units=1,value=time('')+1],[]).
node(node00006,submodel,[node00002,node00003,node00007,node00012,node00015,node00064,node00125],[complete=true,multiplication_spec=[count=[12]],name='monthly time series',separate=0],[bounding_box=[-22,-39,141,219],caption_offset=[0,0],internal_extent=[0,0,163,258]]).
links(node00006,[arc00007-arc00003,arc00008-arc00017,arc00010-arc00012]).
node(node00002,variable,[],[complete=true,description='Monthly heat index',name=i],[caption_offset=[0,0],centre=[144,80]]).
node(node00003,function,[],[complete=true,name=fn1_1,spec=[105,102,32,84,97,62,48,32,116,104,101,110,32,40,84,97,47,53,41,94,49,46,53,10,101,108,115,101,32,48],units=1,value=(if'Ta'>0 then ('Ta'/5)^ 1.5 else 0)],[]).
node(node00007,border,[],[],[centre=[163,80]]).
node(node00012,border,[],[name=var2],[centre=[163,112]]).
node(node00015,border,[],[name=var4],[centre=[163,160]]).
node(node00064,variable,[],[comment='Relative to the mean daylength of 12 hours.',complete=true,description='Relative daylength',name=dl,param_type=file,spec=[],units=1],[caption_offset=[0,0],centre=[74,145]]).
node(node00125,variable,[],[complete=true,description='Mean monthly air temperature (Celsius)',name='Ta',param_type=file,spec=[],units=1],[caption_offset=[0,0],centre=[78,75]]).
node(node00010,variable,[],[complete=true,name='Ta'],[caption_offset=[0,0],centre=[208,100]]).
node(node00011,function,[],[complete=true,name=fn1_1,spec=[101,108,101,109,101,110,116,40,91,84,97,93,44,109,111,110,116,104,41],units=1,value=element(['Ta'],month)],[]).
node(node00013,variable,[],[complete=true,name=dl],[caption_offset=[0,0],centre=[222,162]]).
node(node00014,function,[],[complete=true,name=fn2,spec=[101,108,101,109,101,110,116,40,91,100,108,93,44,109,111,110,116,104,41],units=1,value=element([dl],month)],[]).
node(node00116,variable,[],[complete=true,description='Potential evapo-transpiration (mm/day)',name='PET'],[caption_offset=[0,0],centre=[318,150]]).
node(node00119,function,[],[complete=true,name=fn1_7,spec=[105,102,32,84,97,60,61,48,32,116,104,101,110,32,48,32,10,101,108,115,101,32,100,108,42,49,54,42,40,49,48,42,84,97,47,73,41,94,97],units=1,value=(if'Ta'<=0 then 0 else dl*16*(10*'Ta'/'I')^a)],[]).
node(node00137,variable,[],[complete=true,description='ET parameter deg C',name='I'],[caption_offset=[0,0],centre=[268,4]]).
node(node00138,function,[],[complete=true,name=fn2_0,spec=[115,117,109,40,91,105,93,41],units=1,value=sum([i])],[]).
node(node00151,variable,[],[complete=true,description='ET parameter',name=a],[caption_offset=[9,-3],centre=[318,32]]).
node(node00152,function,[],[complete=true,name=fn1_0,spec='0.49+0.0179*I-7.71*10^ -5*I^2+6.75*10^ -7*I^3',units=1,value= 0.49 + 0.0179 *'I'- 7.71 *10^ -5*'I'^2+ 6.75 *10^ -7*'I'^3],[]).

arc(arc00005,node00005,node00004,influence,[name=i2_0],[]).
arc(arc00001,node00003,node00002,influence,[name=i1_4],[]).
arc(arc00007,node00002,node00007,influence,[complete=true,name=i3,role=[use(none,in_hierarchy,usr([i]),array(1,12))]],[curve=[0,3]]).
arc(arc00008,node00064,node00015,influence,[complete=true,name=i1,role=[use(none,in_hierarchy,[dl],array(1,12))]],[curve=[-3,21]]).
arc(arc00002,node00125,node00003,influence,[complete=true,name=i2,role=[use(none,in_hierarchy,'Ta',1)]],[curve=[-14,-10]]).
arc(arc00010,node00125,node00012,influence,[complete=true,name=i4_3,role=[use(none,in_hierarchy,['Ta'],array(1,12))]],[curve=[-8,19]]).
arc(arc00011,node00011,node00010,influence,[name=i1_0],[]).
arc(arc00012,node00006,node00011,influence,[complete=true,name=i2,role=[use(none,in_hierarchy,['Ta'],array(1,12))]],[curve=[-4,12]]).
arc(arc00014,node00004,node00011,influence,[complete=true,name=i4,role=[use(none,in_hierarchy,month,1)]],[curve=[-6,-44]]).
arc(arc00015,node00014,node00013,influence,[name=i5],[]).
arc(arc00016,node00004,node00014,influence,[complete=true,name=i6,role=[use(none,in_hierarchy,month,1)]],[curve=[0,-15]]).
arc(arc00017,node00006,node00014,influence,[complete=true,name=i7,role=[use(none,in_hierarchy,[dl],array(1,12))]],[curve=[-12,12]]).
arc(arc00009,node00119,node00116,influence,[name=i1_7],[]).
arc(arc00013,node00010,node00119,influence,[complete=true,name=i3_1,role=[use(none,in_hierarchy,'Ta',1)]],[curve=[2,-4]]).
arc(arc00018,node00013,node00119,influence,[complete=true,name=i8,role=[use(none,in_hierarchy,usr(dl),1)]],[curve=[-10,10]]).
arc(arc00088,node00137,node00119,influence,[complete=true,name=i2_7,role=[use(none,in_hierarchy,'I',1)]],[curve=[0,-8]]).
arc(arc00003,node00006,node00138,influence,[complete=true,name=i3,role=[use(none,in_hierarchy,usr([i]),array(1,12))]],[curve=[0,14]]).
arc(arc00039,node00138,node00137,influence,[name=i7_0],[]).
arc(arc00128,node00151,node00119,influence,[name=i2_1,role=[use(none,in_hierarchy,a,1)]],[curve=[16,-8]]).
arc(arc00127,node00152,node00151,influence,[name=i1_1],[]).
arc(arc00129,node00137,node00152,influence,[complete=true,name=i1_2,role=[use(none,in_hierarchy,'I',1)]],[curve=[-6,-8]]).

