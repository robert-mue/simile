source(program='AME',version= 9.0,edition=enterprise,date='Wed Feb 20 11:48:19 GMT 2008').

roots([node00016,node00017,node00018,node00019,node00020,node00027,node00028]).

properties([complete-true,file_name-'C:/Inetpub/wwwroot/www/examples/catalogue/models/bob/ageclass5/ageclass5.sml',name-ageclass5_0]).

node(node00016,submodel,[node00002,node00003,node00004,node00005,node00006,node00007,node00008,node00009,node00010,node00011,node00012,node00013,node00014,node00015,node00021,node00022,node00023,node00024,node00025,node00026,node00029,node00030],[complete=true,fill_colour='#ffff80',multiplication_spec=[count=[4]],name='Age class'],[bounding_box=[49,20,352,253],caption_offset=[35,-7],internal_extent=[0,0,303,233]]).
links(node00016,[arc00018-arc00019,arc00021-arc00020,arc00025-arc00026,arc00028-arc00027,arc00030-arc00031,arc00033-arc00032]).
node(node00002,compartment,[],[complete=true,name='pop size'],[caption_offset=[6,2],centre=[155,101]]).
node(node00003,function,[],[complete=true,name=fn1,units=1,value=element([2,0,0,0],index(1))],[]).
node(node00004,cloud,[],[complete=true,name=cd1],[centre=[38,169]]).
node(node00005,function,[],[complete=true,name=fn2,units=1,value=(if index(1)==1 then births else 0)],[]).
node(node00006,cloud,[],[complete=true,name=cd2],[centre=[265,105]]).
node(node00007,function,[],[complete=true,name=fn3,spec=[101,108,101,109,101,110,116,40,91,49,44,48,46,50,44,48,46,49,44,48,93,44,105,110,100,101,120,40,49,41,41,42,112,111,112,95,115,105,122,101],units=1,value=element([1, 0.2, 0.1,0],index(1))*pop_size],[]).
node(node00008,cloud,[],[complete=true,name=cd3],[centre=[155,22]]).
node(node00009,function,[],[complete=true,name=fn4,units=1*1,value=m*pop_size],[]).
node(node00010,cloud,[],[complete=true,name=cd4],[centre=[37,103]]).
node(node00011,function,[],[complete=true,name=fn5,units=1,value=(if index(1)>1 then element([ageing],index(1)-1) else 0)],[]).
node(node00012,variable,[],[complete=true,name=m],[caption_offset=[0,0],centre=[121,56]]).
node(node00013,function,[],[complete=true,name=fn6,spec=[101,108,101,109,101,110,116,40,91,48,46,48,53,44,48,46,48,49,44,48,46,48,49,44,48,46,48,53,93,44,105,110,100,101,120,40,49,41,41],units=1,value=element([ 0.05, 0.01, 0.01, 0.05],index(1))],[]).
node(node00014,variable,[],[complete=true,name=r],[caption_offset=[-2,-32],centre=[219,170]]).
node(node00015,function,[],[complete=true,name=fn7,spec=[101,108,101,109,101,110,116,40,91,48,44,48,46,48,53,44,48,46,50,44,48,46,49,93,44,105,110,100,101,120,40,49,41,41,42,40,49,45,112,111,112,95,115,105,122,101,47,49,48,48,41],units=1,value=element([0, 0.05, 0.2, 0.1],index(1))*(1-pop_size/100)],[]).
node(node00021,border,[],[name=var5],[centre=[303,142]]).
node(node00022,border,[],[name=var6],[centre=[303,161]]).
node(node00023,variable,[],[complete=true,name='these births'],[caption_offset=[30,3],centre=[159,181]]).
node(node00024,function,[],[complete=true,name=fn10,units=1*1,value=r*pop_size],[]).
node(node00025,border,[],[name=var8],[centre=[151,233]]).
node(node00026,border,[],[name=var9],[centre=[114,233]]).
node(node00029,border,[],[name=var11],[centre=[171,0]]).
node(node00030,border,[],[name=var12],[centre=[138,0]]).
node(node00017,variable,[],[complete=true,name=births],[caption_offset=[0,0],centre=[184,300]]).
node(node00018,function,[],[complete=true,name=fn8,units=1,value=sum([these_births])],[]).
node(node00019,variable,[],[complete=true,name='pop size'],[caption_offset=[0,0],centre=[399,176]]).
node(node00020,function,[],[complete=true,name=fn9,units=1,value=sum([pop_size])],[]).
node(node00027,variable,[],[complete=true,name=ageing],[caption_offset=[39,-17],centre=[206,-15]]).
node(node00028,function,[],[complete=true,name=fn11,spec='[ageing_out]',units=array(1,4),value=[ageing_out]],[]).

arc(arc00001,node00003,node00002,influence,[name=i1],[]).
arc(arc00002,node00004,node00002,flow,[complete=true,name=births],[caption_offset=[10,-9],curve=[600,500]]).
arc(arc00003,node00005,arc00002,influence,[name=i2],[]).
arc(arc00004,node00002,node00006,flow,[complete=true,name='ageing out'],[caption_offset=[0,2],curve=[550,683]]).
arc(arc00005,node00007,arc00004,influence,[name=i3],[]).
arc(arc00014,node00002,node00007,influence,[complete=true,name=i10,role=[use(none,in_hierarchy,pop_size,1)]],[curve=[0,-12]]).
arc(arc00006,node00002,node00008,flow,[complete=true,name=deaths],[caption_offset=[16,-19],curve=[550,611]]).
arc(arc00007,node00009,arc00006,influence,[name=i4],[]).
arc(arc00013,node00002,node00009,influence,[complete=true,name=i9,role=[use(none,in_hierarchy,pop_size,1)]],[curve=[-19,4]]).
arc(arc00008,node00010,node00002,flow,[complete=true,name='ageing in'],[caption_offset=[-49,-2],curve=[550,409]]).
arc(arc00009,node00011,arc00008,influence,[name=i5],[]).
arc(arc00012,node00012,node00009,influence,[complete=true,name=i8,role=[use(none,in_hierarchy,m,1)]],[curve=[-1,-4]]).
arc(arc00010,node00013,node00012,influence,[name=i6],[]).
arc(arc00011,node00015,node00014,influence,[name=i7],[]).
arc(arc00018,node00002,node00021,influence,[complete=true,name=i14],[curve=[-7,18]]).
arc(arc00020,node00022,node00015,influence,[complete=true,name=i16,role=[use(none,in_hierarchy,pop_size,1)]],[curve=[2,14]]).
arc(arc00022,node00024,node00023,influence,[name=i18],[]).
arc(arc00023,node00014,node00024,influence,[complete=true,name=i19,role=[use(none,in_hierarchy,r,1)]],[curve=[2,11]]).
arc(arc00024,node00002,node00024,influence,[complete=true,name=i20,role=[use(none,in_hierarchy,pop_size,1)]],[curve=[14,-1]]).
arc(arc00025,node00023,node00025,influence,[complete=true,name=i21],[curve=[-4,-10]]).
arc(arc00027,node00026,node00005,influence,[complete=true,name=i23,role=[use(none,in_hierarchy,births,1)]],[curve=[12,10]]).
arc(arc00030,arc00004,node00029,influence,[complete=true,name=i26],[curve=[31,-3]]).
arc(arc00032,node00030,node00011,influence,[complete=true,name=i28,role=[use(none,in_hierarchy,[ageing],array(1,4))]],[curve=[-18,9]]).
arc(arc00028,node00017,node00016,influence,[complete=true,name=i24],[curve=[-10,4]]).
arc(arc00016,node00018,node00017,influence,[name=i12],[]).
arc(arc00026,node00016,node00018,influence,[complete=true,name=i22,role=[use(none,in_hierarchy,[these_births],array(1,size('Age class')))]],[curve=[8,2]]).
arc(arc00021,node00019,node00016,influence,[complete=true,name=i17],[curve=[1,10]]).
arc(arc00017,node00020,node00019,influence,[name=i13],[]).
arc(arc00019,node00016,node00020,influence,[complete=true,name=i15,role=[use(none,in_hierarchy,[pop_size],array(1,size('Age class')))]],[curve=[2,-12]]).
arc(arc00033,node00027,node00016,influence,[complete=true,name=i29],[curve=[6,4]]).
arc(arc00029,node00028,node00027,influence,[name=i25],[]).
arc(arc00031,node00016,node00028,influence,[complete=true,name=i27,role=[use(none,in_hierarchy,[ageing_out],array(1,4))]],[curve=[1,-4]]).

