source(program='AME',version= 9.0,edition=standard,date='Mon Feb 04 23:30:08 GMT 2008').

roots([node00002,node00003,node00004]).

properties([complete-true,file_name-'C:/Inetpub/wwwroot/www/examples/catalogue/models/bob/assoc_from_data1/assoc_from_data1.sml',name-assoc_from_data1]).

node(node00002,submodel,[node00005,node00006,node00013],[complete=true,fill_colour='#b0ffb0',multiplication_spec=[count=[5]],name='Patch',separate=0],[bounding_box=[54,68,176,245],caption_offset=[20,-7],internal_extent=[0,0,122,177]]).
links(node00002,[arc00007-arc00009]).
node(node00005,variable,[],[complete=true,name='ID'],[caption_offset=[0,0],centre=[84,28]]).
node(node00006,function,[],[complete=true,name=fn1,units=int,value=index(1)],[]).
node(node00013,border,[],[name=var4],[centre=[122,30]]).
node(node00003,submodel,[node00007,node00008,node00014,node00016,node00018],[complete=true,fill_colour='#ffffa8',multiplication_spec=[count=[]],name='Neighbour',separate=0],[bounding_box=[230,64,333,161],caption_offset=[21,-6],internal_extent=[0,0,103,97]]).
links(node00003,[arc00009-arc00008,arc00012-arc00011,arc00015-arc00014]).
references(node00003,[local(arc00001),local(arc00002)]).
node(node00007,condition,[],[complete=true,name=condition],[caption_offset=[1,-46],centre=[44,32]]).
node(node00008,function,[],[complete=true,name=fn2,units=boolean,value=(any('ID1'==['ID1'] and 'ID2'==['ID2']) or any('ID1'==['ID2'] and 'ID2'==['ID1']))],[]).
node(node00014,border,[],[name=var5],[centre=[0,29]]).
node(node00016,border,[],[name=var7],[centre=[35,97]]).
node(node00018,border,[],[name=var9],[centre=[59,97]]).
node(node00004,submodel,[node00009,node00011,node00015,node00017],[complete=true,fill_colour='#e5e5e5',multiplication_spec=[count=[6]],name='Neighbour data',separate=0],[bounding_box=[234,189,335,239],caption_offset=[27,63],internal_extent=[0,0,101,50]]).
links(node00004,[arc00010-arc00012,arc00013-arc00015]).
node(node00009,variable,[],[complete=true,name='ID1',param_type=file,units=1],[caption_offset=[0,0],centre=[25,18]]).
node(node00011,variable,[],[complete=true,name='ID2',param_type=file,units=1],[caption_offset=[0,0],centre=[67,18]]).
node(node00015,border,[],[name=var6],[centre=[27,0]]).
node(node00017,border,[],[name=var8],[centre=[62,0]]).

arc(arc00003,node00006,node00005,influence,[name=i1],[]).
arc(arc00007,node00005,node00013,influence,[complete=true,name=i5],[curve=[0,-8]]).
arc(arc00001,node00002,node00003,relation,[complete=true,name=role1],[caption_offset=[0,-9],curve=[-3,-12]]).
arc(arc00002,node00002,node00003,relation,[complete=true,name=role2],[caption_offset=[0,12],curve=[-7,8]]).
arc(arc00009,node00002,node00003,influence,[complete=true,name=i7],[curve=[1,-12]]).
arc(arc00004,node00008,node00007,influence,[name=i2],[]).
arc(arc00008,node00014,node00008,influence,[complete=true,name=i6,role=[use(1,in_base,'ID2',int),use(0,in_base,'ID1',int)]],[curve=[0,-8]]).
arc(arc00011,node00016,node00008,influence,[complete=true,name=i9,role=[use(none,in_hierarchy,['ID1'],array(1,size('Neighbour data')))]],[curve=[-13,-2]]).
arc(arc00014,node00018,node00008,influence,[complete=true,name=i12,role=[use(none,in_hierarchy,['ID2'],array(1,size('Neighbour data')))]],[curve=[-13,3]]).
arc(arc00012,node00004,node00003,influence,[complete=true,name=i10],[curve=[-7,-1]]).
arc(arc00015,node00004,node00003,influence,[complete=true,name=i13],[curve=[-8,1]]).
arc(arc00010,node00009,node00015,influence,[complete=true,name=i8],[curve=[-3,0]]).
arc(arc00013,node00011,node00017,influence,[complete=true,name=i11],[curve=[-4,0]]).

