source(program='AME',version= 9.0,edition=standard,date='Tue Feb 05 17:08:15 GMT 2008').

roots([node00002,node00003,node00004,node00005,node00006,node00007,node00008,node00009,node00010,node00011,node00012,node00013]).

properties([complete-true,file_name-'C:/Inetpub/wwwroot/www/examples/catalogue/models/bob/budworm1/budworm1.sml',name-budworm1]).

node(node00002,compartment,[],[complete=true,name=forest],[caption_offset=[0,0],centre=[201,46]]).
node(node00003,compartment,[],[complete=true,name=budworm],[caption_offset=[0,0],centre=[209,163]]).
node(node00004,cloud,[],[complete=true,name=cd1],[centre=[63,44]]).
node(node00005,function,[],[complete=true,name=fn1,units=1,value=(if forest<4 then  0.02 else 0)],[]).
node(node00006,cloud,[],[complete=true,name=cd2],[centre=[322,44]]).
node(node00007,function,[],[complete=true,name=fn2,units=1,value=(if budworm>300 then forest-1 else 0)],[]).
node(node00008,cloud,[],[complete=true,name=cd3],[centre=[52,168]]).
node(node00009,function,[],[complete=true,name=fn3,table_data=[file='/graph/',data=[5,0,400],indices=[0,400,400,1],current=[292,315,346,346,328,311,302,301,301,308,318,327,332,339,345,346,348,352,352,352,353],units=1,bounds=1,dims=21],units=1,value=forest*graph(budworm)*budworm],[]).
node(node00010,cloud,[],[complete=true,name=cd4],[centre=[346,165]]).
node(node00011,function,[],[complete=true,name=fn4,units=1,value=budworm],[]).
node(node00012,function,[],[complete=true,units=1,value=1],[]).
node(node00013,function,[],[complete=true,units=1,value=10],[]).

arc(arc00001,node00004,node00002,flow,[complete=true,name=ageing],[caption_offset=[-38,2],curve=[550,500]]).
arc(arc00002,node00005,arc00001,influence,[name=i1],[]).
arc(arc00011,node00002,node00005,influence,[complete=true,name=i8,role=[use(none,in_hierarchy,forest,1)]],[curve=[-1,12]]).
arc(arc00003,node00002,node00006,flow,[complete=true,name=regression],[caption_offset=[0,0],curve=[550,494]]).
arc(arc00004,node00007,arc00003,influence,[name=i2],[]).
arc(arc00009,node00002,node00007,influence,[complete=true,name=i6,role=[use(none,in_hierarchy,forest,1)]],[curve=[0,-10]]).
arc(arc00010,node00003,node00007,influence,[complete=true,name=i7,role=[use(none,in_hierarchy,budworm,1)]],[curve=[-24,-12]]).
arc(arc00005,node00008,node00003,flow,[complete=true,name=recruitment],[caption_offset=[-45,0],curve=[550,496]]).
arc(arc00006,node00009,arc00005,influence,[name=i3],[]).
arc(arc00007,node00003,node00009,influence,[complete=true,name=i4,role=[use(none,in_hierarchy,budworm,1)]],[curve=[1,14]]).
arc(arc00008,node00002,node00009,influence,[complete=true,name=i5,role=[use(none,in_hierarchy,forest,1)]],[curve=[24,15]]).
arc(arc00012,node00003,node00010,flow,[complete=true,name=death],[caption_offset=[0,0],curve=[550,495]]).
arc(arc00013,node00011,arc00012,influence,[name=i9],[]).
arc(arc00014,node00003,node00011,influence,[complete=true,name=i10,role=[use(none,in_hierarchy,budworm,1)]],[curve=[0,-12]]).
arc(arc00015,node00012,node00002,influence,[],[]).
arc(arc00016,node00013,node00003,influence,[],[]).

