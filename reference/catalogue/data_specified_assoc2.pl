source(program='AME',version= 9.0,edition=standard,date='Tue Feb 05 17:15:05 GMT 2008').

roots([node00002,node00003,node00010,node00011,node00012,node00013]).

properties([complete-true,file_name-'C:/Inetpub/wwwroot/www/examples/catalogue/models/bob/data_specified_assoc2/data_specified_assoc2.sml',name-data_specified_assoc2]).

node(node00002,submodel,[node00004,node00005,node00008],[complete=true,fill_colour='#80ff80',multiplication_spec=[count=[4]],name='Node'],[bounding_box=[38,60,234,270],caption_offset=[0,0],internal_extent=[0,0,196,210]]).
links(node00002,[arc00005-arc00007]).
node(node00004,variable,[],[complete=true,name='ID'],[caption_offset=[0,0],centre=[121,52]]).
node(node00005,function,[],[complete=true,name=fn1,units=int,value=index(1)],[]).
node(node00008,border,[],[name=var2],[centre=[196,64]]).
node(node00003,submodel,[node00006,node00007,node00009,node00014,node00015],[complete=true,fill_colour='#ffff80',multiplication_spec=[count=[]],name='Arc',separate=0],[bounding_box=[292,101,460,261],caption_offset=[5,-9],internal_extent=[0,0,168,160]]).
links(node00003,[arc00007-arc00006,arc00011-arc00010,arc00013-arc00012]).
references(node00003,[local(arc00001),local(arc00002)]).
node(node00006,condition,[],[complete=true,name=cond1],[caption_offset=[0,0],centre=[41,41]]).
node(node00007,function,[],[complete=true,name=fn2,units=boolean,value=(any('ID'==['IDa'] and 'ID_0'==['IDb']) or any('ID'==['IDb'] and 'ID_0'==['IDa']))],[]).
node(node00009,border,[],[name=var3],[centre=[0,33]]).
node(node00014,border,[],[name=var6],[centre=[30,0]]).
node(node00015,border,[],[name=var7],[centre=[56,0]]).
node(node00010,variable,[],[complete=true,name='IDa'],[caption_offset=[-2,-37],centre=[309,51]]).
node(node00011,function,[],[complete=true,name=fn3,units=array(int,3),value=[1,2,3]],[]).
node(node00012,variable,[],[complete=true,name='IDb'],[caption_offset=[1,-36],centre=[367,54]]).
node(node00013,function,[],[complete=true,name=fn4,units=array(int,3),value=[2,3,4]],[]).

arc(arc00003,node00005,node00004,influence,[name=i1],[]).
arc(arc00005,node00004,node00008,influence,[complete=true,name=i3],[curve=[2,-18]]).
arc(arc00001,node00002,node00003,relation,[complete=true,name=role1],[caption_offset=[1,-10],curve=[1,-15]]).
arc(arc00002,node00002,node00003,relation,[complete=true,name=role2],[caption_offset=[-1,12],curve=[15,12]]).
arc(arc00007,node00002,node00003,influence,[complete=true,name=i5],[curve=[2,-15]]).
arc(arc00004,node00007,node00006,influence,[name=i2],[]).
arc(arc00006,node00009,node00007,influence,[complete=true,name=i4,role=[use(0,in_base,'ID',int),use(1,in_base,'ID_0',int)]],[curve=[1,-6]]).
arc(arc00010,node00014,node00007,influence,[complete=true,name=i8,role=[use(none,in_hierarchy,['IDa'],array(int,3))]],[curve=[6,-2]]).
arc(arc00012,node00015,node00007,influence,[complete=true,name=i10,role=[use(none,in_hierarchy,['IDb'],array(int,3))]],[curve=[6,2]]).
arc(arc00011,node00010,node00003,influence,[complete=true,name=i9],[curve=[11,-3]]).
arc(arc00008,node00011,node00010,influence,[name=i6],[]).
arc(arc00013,node00012,node00003,influence,[complete=true,name=i11],[curve=[10,4]]).
arc(arc00009,node00013,node00012,influence,[name=i7],[]).

