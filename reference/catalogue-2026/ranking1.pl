source(program='Simile v7.4',version= 11.4,edition=free,date='Thu Aug 13 10:35:28 GMT 2026').

roots([node00002,node00003]).

properties([complete-true,file_name-'C:/Inetpub/wwwroot/www/examples/catalogue/models/bob/ranking1/ranking1.sml',fill_colour-'#ffffffffffff',name-'Desktop1',separate-0]).

node(node00002,submodel,[node00006,node00007,node00010,node00016,node00017,node00019,node00020,node00021],[complete=true,fill_colour='#ffff80',multiplication_spec=[type=population],name=individual,separate=0],[bounding_box=[ 36.0, 49.0, 231.0, 282.0],caption_offset=[ 25.0, -10.0],internal_extent=[ 0.0, -3.0, 195.0, 230.0]]).
links(node00002,[arc00006-arc00008,arc00014-arc00013]).
references(node00002,[local(arc00004),local(arc00005)]).
node(node00003,submodel,[node00008,node00009,node00011,node00014,node00015,node00018],[complete=true,fill_colour='#80ff80',multiplication_spec=[count=[]],name=ranking,separate=0],[bounding_box=[ 426.0, 76.0, 541.0, 230.0],caption_offset=[ 21.0, -7.0],internal_extent=[ 0.0, 0.0, 115.0, 154.0]]).
links(node00003,[arc00008-arc00007,arc00012-arc00014]).
references(node00003,[local(arc00004),local(arc00005)]).
node(node00008,condition,[],[complete=true,name=condition],[caption_offset=[ 0.0, 0.0],centre=[ 66.0, 85.0]]).
node(node00009,function,[],[complete=true,name=fn3,spec=[97,116,116,114,105,98,117,116,101,95,114,111,108,101,49,62,97,116,116,114,105,98,117,116,101,95,114,111,108,101,50],units=boolean,value=(attribute_role1>attribute_role2)],[]).
node(node00011,border,[],[name=var3],[along=473]).
node(node00014,variable,[],[complete=true,name=one],[caption_offset=[ 0.0, 0.0],centre=[ 33.0, 130.0]]).
node(node00015,function,[],[complete=true,name=fn5,spec=[49],units=int,value=1],[]).
node(node00018,border,[],[name=var7],[along=376]).
arc(arc00003,node00009,node00008,influence,[attached=[],name=i3],[]).
arc(arc00007,node00011,node00009,influence,[attached=[],complete=true,name=i5,role=[use(0,in_base,attribute_role1,1),use(1,in_base,attribute_role2,1)]],[curve=[0,-13]]).
arc(arc00010,node00015,node00014,influence,[attached=[],name=i8],[]).
arc(arc00012,node00014,node00018,influence,[attached=[],complete=true,name=i10],[curve=[1,6]]).
node(node00006,variable,[],[complete=true,name=attribute],[caption_offset=[ 0.0, 0.0],centre=[ 148.0, 102.0]]).
node(node00007,function,[],[complete=true,name=fn2,spec=[114,97,110,100,95,99,111,110,115,116,40,48,44,49,48,48,41],units=1,value=rand_const(0,100)],[]).
node(node00010,border,[],[name=var2],[along=977]).
node(node00016,variable,[],[complete=true,name=rank],[caption_offset=[ 0.0, 0.0],centre=[ 143.0, 161.0]]).
node(node00017,function,[],[complete=true,name=fn6,spec=[99,111,117,110,116,40,123,111,110,101,95,114,111,108,101,50,125,41,43,49],units=int,value=count({one_role2})+1],[]).
node(node00019,border,[],[name=var8],[along=62]).
node(node00020,creation,[],[complete=true,name='initial\nnumber'],[caption_offset=[ 1.0, 11.0],centre=[ 50.0, 36.0]]).
node(node00021,function,[],[complete=true,name=fn7,spec=[49,48],units=int,value=10],[]).
arc(arc00002,node00007,node00006,influence,[attached=[],name=i2],[]).
arc(arc00006,node00006,node00010,influence,[attached=[],complete=true,name=i4],[curve=[0,-10]]).
arc(arc00011,node00017,node00016,influence,[attached=[],name=i9],[]).
arc(arc00013,node00019,node00017,influence,[attached=[],complete=true,name=i11,role=[use(0,in_assoc,{one_role1},list(int)),use(1,in_assoc,{one_role2},list(int))]],[curve=[2,10]]).
arc(arc00015,node00021,node00020,influence,[attached=[],name=i13],[]).
arc(arc00014,node00003,node00002,influence,[attached=[],complete=true,name=i12],[curve=[2,15]]).
arc(arc00004,node00002,node00003,relation,[attached=[],complete=true,name=role1],[caption_offset=[3,-9],curve=[10,128]]).
arc(arc00005,node00002,node00003,relation,[attached=[],complete=true,name=role2],[caption_offset=[1,11],curve=[-8,-63]]).
arc(arc00008,node00002,node00003,influence,[attached=[],complete=true,name=i6],[curve=[0,-16]]).
