source(program='AME',version= 9.0,edition=standard,date='Mon Feb 04 23:16:23 GMT 2008').

roots([node00016,node00017,node00018,node00019,node00020,node00027]).

properties([complete-true,file_name-'C:/Inetpub/wwwroot/www/examples/catalogue/models/bob/ageclass6/ageclass6.sml',name-ageclass6]).

node(node00016,submodel,[node00002,node00003,node00004,node00005,node00006,node00007,node00008,node00009,node00010,node00011,node00012,node00013,node00014,node00015,node00021,node00022,node00023,node00024,node00025,node00026,node00032,node00035,node00036,node00037,node00038],[complete=true,fill_colour='#ffff80',multiplication_spec=[count=[4]],name='Age class'],[bounding_box=[49,21,341,252],caption_offset=[-14,-3],internal_extent=[0,1,292,232]]).
links(node00016,[arc00018-arc00019,arc00021-arc00020,arc00025-arc00026,arc00028-arc00027,arc00032-arc00034,arc00037-arc00036,arc00039-arc00041]).
references(node00016,[local(arc00030),local(arc00031)]).
node(node00002,compartment,[],[complete=true,name='pop size'],[caption_offset=[6,2],centre=[155,101]]).
node(node00003,function,[],[complete=true,name=fn1,units=1,value=element([2,0,0,0],index(1))],[]).
node(node00004,cloud,[],[complete=true,name=cd1],[centre=[38,169]]).
node(node00005,function,[],[complete=true,name=fn2,units=1,value=(if index(1)==1 then births else 0)],[]).
node(node00006,cloud,[],[complete=true,name=cd2],[centre=[265,105]]).
node(node00007,function,[],[complete=true,name=fn3,spec=[101,108,101,109,101,110,116,40,91,49,44,48,46,50,44,48,46,49,44,48,93,44,105,110,100,101,120,40,49,41,41,42,112,111,112,95,115,105,122,101],units=1,value=element([1, 0.2, 0.1,0],index(1))*pop_size],[]).
node(node00008,cloud,[],[complete=true,name=cd3],[centre=[155,22]]).
node(node00009,function,[],[complete=true,name=fn4,units=1*1,value=m*pop_size],[]).
node(node00010,cloud,[],[complete=true,name=cd4],[centre=[37,103]]).
node(node00011,function,[],[complete=true,name=fn5,spec=[115,117,109,40,123,97,103,101,105,110,103,95,110,101,120,116,125,41],units=1,value=sum({ageing_next})],[]).
node(node00012,variable,[],[complete=true,name=m],[caption_offset=[0,0],centre=[121,56]]).
node(node00013,function,[],[complete=true,name=fn6,spec=[101,108,101,109,101,110,116,40,91,48,46,48,53,44,48,46,48,49,44,48,46,48,49,44,48,46,48,53,93,44,105,110,100,101,120,40,49,41,41],units=1,value=element([ 0.05, 0.01, 0.01, 0.05],index(1))],[]).
node(node00014,variable,[],[complete=true,name=r],[caption_offset=[1,-32],centre=[219,170]]).
node(node00015,function,[],[complete=true,name=fn7,spec=[101,108,101,109,101,110,116,40,91,48,44,48,46,48,53,44,48,46,50,44,48,46,49,93,44,105,110,100,101,120,40,49,41,41,42,40,49,45,116,111,116,97,108,95,112,111,112,95,115,105,122,101,47,49,48,48,41],units=1,value=element([0, 0.05, 0.2, 0.1],index(1))*(1-total_pop_size/100)],[]).
node(node00021,border,[],[name=var5],[centre=[292,142]]).
node(node00022,border,[],[name=var6],[centre=[292,161]]).
node(node00023,variable,[],[complete=true,name='these births'],[caption_offset=[36,2],centre=[159,181]]).
node(node00024,function,[],[complete=true,name=fn10,units=1*1,value=r*pop_size],[]).
node(node00025,border,[],[name=var8],[centre=[145,232]]).
node(node00026,border,[],[name=var9],[centre=[110,232]]).
node(node00032,border,[],[name=var1],[centre=[218,1]]).
node(node00035,border,[],[name=var4],[centre=[161,1]]).
node(node00036,variable,[],[complete=true,name=class],[caption_offset=[0,0],centre=[72,29]]).
node(node00037,function,[],[complete=true,name=fn1_0,spec=[105,110,100,101,120,40,49,41],units=int,value=index(1)],[]).
node(node00038,border,[],[name=var6_0],[centre=[72,1]]).
node(node00017,variable,[],[complete=true,name=births],[caption_offset=[0,0],centre=[180,285]]).
node(node00018,function,[],[complete=true,name=fn8,units=1,value=sum([these_births])],[]).
node(node00019,variable,[],[complete=true,name='total pop size'],[caption_offset=[7,1],centre=[399,176]]).
node(node00020,function,[],[complete=true,name=fn9,units=1,value=sum([pop_size])],[]).
node(node00027,submodel,[node00028,node00029,node00030,node00031,node00033,node00034,node00039],[complete=true,fill_colour='#b0ffb0',multiplication_spec=[count=[]],name='Next class'],[bounding_box=[90,-71,278,-15],caption_offset=[10,-7],internal_extent=[0,0,187,56]]).
links(node00027,[arc00034-arc00033,arc00035-arc00037,arc00041-arc00040]).
references(node00027,[local(arc00030),local(arc00031)]).
node(node00028,condition,[],[complete=true,name=condition],[caption_offset=[4,-46],centre=[29,32]]).
node(node00029,function,[],[complete=true,name=fn1,spec=[99,108,97,115,115,95,110,101,120,116,61,61,99,108,97,115,115,95,116,104,105,115,43,49],units=boolean,value=(class_next==class_this+1)],[]).
node(node00030,variable,[],[complete=true,name=ageing],[caption_offset=[2,-32],centre=[117,26]]).
node(node00031,function,[],[complete=true,name=fn2,spec=[97,103,101,105,110,103,95,111,117,116,95,116,104,105,115],units=1,value=ageing_out_this],[]).
node(node00033,border,[],[name=var2],[centre=[159,56]]).
node(node00034,border,[],[name=var3],[centre=[121,56]]).
node(node00039,border,[],[name=var7],[centre=[29,56]]).

arc(arc00001,node00003,node00002,influence,[name=i1],[]).
arc(arc00002,node00004,node00002,flow,[complete=true,name=births],[caption_offset=[11,-11],curve=[600,500]]).
arc(arc00003,node00005,arc00002,influence,[name=i2],[]).
arc(arc00004,node00002,node00006,flow,[complete=true,name='ageing out'],[caption_offset=[8,-44],curve=[550,646]]).
arc(arc00005,node00007,arc00004,influence,[name=i3],[]).
arc(arc00014,node00002,node00007,influence,[complete=true,name=i10,role=[use(none,in_hierarchy,pop_size,1)]],[curve=[0,-18]]).
arc(arc00006,node00002,node00008,flow,[complete=true,name=deaths],[caption_offset=[15,-19],curve=[550,611]]).
arc(arc00007,node00009,arc00006,influence,[name=i4],[]).
arc(arc00013,node00002,node00009,influence,[complete=true,name=i9,role=[use(none,in_hierarchy,pop_size,1)]],[curve=[-19,4]]).
arc(arc00008,node00010,node00002,flow,[complete=true,name='ageing in'],[caption_offset=[-57,4],curve=[550,409]]).
arc(arc00009,node00011,arc00008,influence,[name=i5],[]).
arc(arc00012,node00012,node00009,influence,[complete=true,name=i8,role=[use(none,in_hierarchy,m,1)]],[curve=[-1,-4]]).
arc(arc00010,node00013,node00012,influence,[name=i6],[]).
arc(arc00011,node00015,node00014,influence,[name=i7],[]).
arc(arc00018,node00002,node00021,influence,[complete=true,name=i14],[curve=[-8,2]]).
arc(arc00020,node00022,node00015,influence,[complete=true,name=i16,role=[use(none,in_hierarchy,total_pop_size,1)]],[curve=[1,14]]).
arc(arc00022,node00024,node00023,influence,[name=i18],[]).
arc(arc00023,node00014,node00024,influence,[complete=true,name=i19,role=[use(none,in_hierarchy,r,1)]],[curve=[2,11]]).
arc(arc00024,node00002,node00024,influence,[complete=true,name=i20,role=[use(none,in_hierarchy,pop_size,1)]],[curve=[14,-1]]).
arc(arc00025,node00023,node00025,influence,[complete=true,name=i21],[curve=[-4,-10]]).
arc(arc00027,node00026,node00005,influence,[complete=true,name=i23,role=[use(none,in_hierarchy,births,1)]],[curve=[4,12]]).
arc(arc00032,arc00004,node00032,influence,[complete=true,name=i1_0],[curve=[-1,2]]).
arc(arc00036,node00035,node00011,influence,[complete=true,name=i5_0,role=[use(0,in_assoc,{ageing_this_0},list(1)),use(1,in_assoc,{ageing_next},list(1))]],[curve=[-19,8]]).
arc(arc00038,node00037,node00036,influence,[name=i7_0],[]).
arc(arc00039,node00036,node00038,influence,[complete=true,name=i8_0],[curve=[-5,0]]).
arc(arc00028,node00017,node00016,influence,[complete=true,name=i24],[curve=[-10,4]]).
arc(arc00016,node00018,node00017,influence,[name=i12],[]).
arc(arc00026,node00016,node00018,influence,[complete=true,name=i22,role=[use(none,in_hierarchy,[these_births],array(1,size('Age class')))]],[curve=[8,1]]).
arc(arc00021,node00019,node00016,influence,[complete=true,name=i17],[curve=[0,11]]).
arc(arc00017,node00020,node00019,influence,[name=i13],[]).
arc(arc00019,node00016,node00020,influence,[complete=true,name=i15,role=[use(none,in_hierarchy,[pop_size],array(1,size('Age class')))]],[curve=[2,-12]]).
arc(arc00030,node00016,node00027,relation,[complete=true,name=this],[caption_offset=[-15,-4],curve=[-7,-1]]).
arc(arc00031,node00016,node00027,relation,[complete=true,name=next],[caption_offset=[20,2],curve=[8,-1]]).
arc(arc00034,node00016,node00027,influence,[complete=true,name=i3],[curve=[-8,2]]).
arc(arc00037,node00027,node00016,influence,[complete=true,name=i6],[curve=[8,5]]).
arc(arc00041,node00016,node00027,influence,[complete=true,name=i10],[curve=[-10,0]]).
arc(arc00015,node00029,node00028,influence,[name=i1],[curve=[0,0]]).
arc(arc00029,node00031,node00030,influence,[name=i2],[curve=[0,0]]).
arc(arc00033,node00033,node00031,influence,[complete=true,name=i2_0,role=[use(0,in_base,usr(ageing_out_this),1),use(1,in_base,ageing_out_next,1)]],[curve=[-8,2]]).
arc(arc00035,node00030,node00034,influence,[complete=true,name=i4],[curve=[3,4]]).
arc(arc00040,node00039,node00029,influence,[complete=true,name=i9,role=[use(0,in_base,class_this,int),use(1,in_base,class_next,int)]],[curve=[-2,0]]).

