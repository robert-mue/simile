source(program='AME',version= 9.0,edition=standard,date='Wed Feb 06 16:57:50 GMT 2008').

roots([node00020,node00025,node00026,node00027,node00028]).

properties([complete-true,file_name-'C:/Inetpub/wwwroot/www/examples/catalogue/models/bob/markov2/markov2.sml',fill_colour-'#ffffff',multiplication_spec-[count=[]],name-markov2,separate-0]).

node(node00020,submodel,[node00006,node00007,node00008,node00009,node00010,node00011,node00012,node00013,node00014,node00015,node00016,node00017,node00018,node00019,node00021,node00022,node00023,node00024,node00029,node00030],[complete=true,fill_colour='#ff8080',multiplication_spec=[count=[400]],name=cell],[bounding_box=[64,29,386,307],caption_offset=[0,0],internal_extent=[0,0,322,278]]).
links(node00020,[arc00026-arc00025,arc00028-arc00027]).
node(node00006,variable,[],[complete=true,name=select],[caption_offset=[36,-13],centre=[175,96]]).
node(node00007,function,[],[complete=true,name=fn3,units=array(1,3),value=(if r>[low] and r<[up] then [index] else 0)],[]).
node(node00008,variable,[],[complete=true,name=r],[caption_offset=[0,0],centre=[143,42]]).
node(node00009,function,[],[complete=true,name=fn4,units=1,value=rand_var(0,1)],[]).
node(node00010,compartment,[],[complete=true,name=state],[caption_offset=[0,0],centre=[289,171]]).
node(node00011,function,[],[complete=true,max_val=3,min_val=1,name=fn1_0,units=1,value=1],[]).
node(node00012,variable,[],[complete=true,name=up],[caption_offset=[0,0],centre=[115,86]]).
node(node00013,function,[],[complete=true,name=fn6,spec=[101,108,101,109,101,110,116,40,91,91,117,112,112,101,114,93,93,44,115,116,97,116,101,41],units=array(1,3),value=element([[upper]],state)],[]).
node(node00014,variable,[],[complete=true,name=low],[caption_offset=[0,0],centre=[115,164]]).
node(node00015,function,[],[complete=true,name=fn7,spec=[101,108,101,109,101,110,116,40,91,91,108,111,119,101,114,93,93,44,115,116,97,116,101,41],units=array(1,3),value=element([[lower]],state)],[]).
node(node00016,variable,[],[complete=true,name=index],[caption_offset=[2,-32],centre=[209,45]]).
node(node00017,function,[],[complete=true,name=fn8,units=array(1,3),value=[1,2,3]],[]).
node(node00018,cloud,[],[complete=true,name=cd1],[centre=[178,166]]).
node(node00019,function,[],[complete=true,name=fn2_0,units=1,value= -state+sum([select])],[]).
node(node00021,variable,[],[complete=true,name=row],[caption_offset=[0,0],centre=[68,243]]).
node(node00022,function,[],[complete=true,name=fn1_1,units=1,value=fmod(index(1)-1,20)+1],[]).
node(node00023,variable,[],[complete=true,name=column],[caption_offset=[0,0],centre=[109,247]]).
node(node00024,function,[],[complete=true,name=fn2_1,units=1,value=floor((index(1)-1)/20)+1],[]).
node(node00029,border,[],[name=var3],[centre=[0,108]]).
node(node00030,border,[],[name=var4],[centre=[0,200]]).
node(node00025,variable,[],[complete=true,name=upper],[caption_offset=[0,0],centre=[14,147]]).
node(node00026,function,[],[complete=true,name=fn1,spec=[91,91,48,46,57,54,44,48,46,57,56,44,49,46,48,93,44,91,48,46,48,50,44,48,46,57,56,44,49,46,48,93,44,91,48,46,48,50,44,48,46,48,52,44,49,46,48,93,93],units=array(array(1,3),3),value=[[ 0.96, 0.98, 1.0],[ 0.02, 0.98, 1.0],[ 0.02, 0.04, 1.0]]],[]).
node(node00027,variable,[],[complete=true,name=lower],[caption_offset=[0,0],centre=[22,242]]).
node(node00028,function,[],[complete=true,name=fn2,spec=[91,91,48,46,48,44,48,46,57,54,44,48,46,57,56,93,44,91,48,46,48,44,48,46,48,50,44,48,46,57,56,93,44,91,48,46,48,44,48,46,48,50,44,48,46,48,52,93,93],units=array(array(1,3),3),value=[[ 0.0, 0.96, 0.98],[ 0.0, 0.02, 0.98],[ 0.0, 0.02, 0.04]]],[]).

arc(arc00003,node00007,node00006,influence,[name=i3],[]).
arc(arc00007,node00008,node00007,influence,[complete=true,name=i7,role=[use(none,in_hierarchy,r,1)]],[curve=[10,-6]]).
arc(arc00004,node00009,node00008,influence,[name=i4],[]).
arc(arc00005,node00011,node00010,influence,[name=i1_0],[]).
arc(arc00016,node00012,node00007,influence,[complete=true,name=i16,role=[use(none,in_hierarchy,[up],array(1,3))]],[curve=[2,-12]]).
arc(arc00009,node00010,node00013,influence,[complete=true,name=i3_0,role=[use(none,in_hierarchy,state,1)]],[curve=[-16,27]]).
arc(arc00010,node00013,node00012,influence,[name=i10],[]).
arc(arc00017,node00014,node00007,influence,[complete=true,name=i17,role=[use(none,in_hierarchy,[low],array(1,3))]],[curve=[-14,-14]]).
arc(arc00011,node00015,node00014,influence,[name=i11],[]).
arc(arc00014,node00010,node00015,influence,[complete=true,name=i4_0,role=[use(none,in_hierarchy,state,1)]],[curve=[-2,26]]).
arc(arc00019,node00016,node00007,influence,[complete=true,name=i19,role=[use(none,in_hierarchy,[index],array(1,3))]],[curve=[10,6]]).
arc(arc00018,node00017,node00016,influence,[name=i18],[]).
arc(arc00006,node00018,node00010,flow,[complete=true,name='state\nchange'],[caption_offset=[-11,8],curve=[550,500]]).
arc(arc00008,node00019,arc00006,influence,[name=i2_0],[]).
arc(arc00015,node00006,node00019,influence,[complete=true,name=i5,role=[use(none,in_hierarchy,[select],array(1,3))]],[curve=[16,-11]]).
arc(arc00020,node00010,node00019,influence,[complete=true,name=i6,role=[use(none,in_hierarchy,state,1)]],[curve=[0,8]]).
arc(arc00021,node00022,node00021,influence,[name=i1_1],[]).
arc(arc00022,node00024,node00023,influence,[name=i2_1],[]).
arc(arc00025,node00029,node00013,influence,[complete=true,name=i3_1,role=[use(none,in_hierarchy,[[upper]],array(array(1,3),3))]],[curve=[-5,-26]]).
arc(arc00027,node00030,node00015,influence,[complete=true,name=i5_0,role=[use(none,in_hierarchy,[[lower]],array(array(1,3),3))]],[curve=[-8,-27]]).
arc(arc00026,node00025,node00020,influence,[complete=true,name=i4],[curve=[-2,-10]]).
arc(arc00023,node00026,node00025,influence,[name=i1],[]).
arc(arc00028,node00027,node00020,influence,[complete=true,name=i6],[curve=[-2,-8]]).
arc(arc00024,node00028,node00027,influence,[name=i2],[]).

