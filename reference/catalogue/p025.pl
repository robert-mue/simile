source(program='AME',version= 9.0,edition=standard,date='Wed Feb 06 17:03:10 GMT 2008').

roots([node00002,node00003,node00004,node00005,node00006,node00007]).

properties([complete-true,file_name-'C:/Inetpub/wwwroot/www/examples/catalogue/models/ford/p025/p025.sml',name-p025,separate-0]).

node(node00002,compartment,[],[comment='Population size, millions',complete=true,name=population],[caption_offset=[57,-26],centre=[157,86]]).
node(node00003,function,[],[complete=true,name=fn1,units=1,value=10],[]).
node(node00004,cloud,[],[complete=true,name=cd1],[centre=[31,84]]).
node(node00005,function,[],[complete=true,name=fn2,units=1*1,value=growth_rate*population],[]).
node(node00006,variable,[],[comment='Annual proportional growth rate, proportion per year',complete=true,name='growth rate'],[caption_offset=[48,-18],centre=[154,123]]).
node(node00007,function,[],[complete=true,name=fn3,units=1,value= 0.07],[]).

arc(arc00001,node00003,node00002,influence,[name=i1],[]).
arc(arc00002,node00004,node00002,flow,[comment='Population growth, millions per year',complete=true,name=growth],[caption_offset=[-40,-44],curve=[550,500]]).
arc(arc00003,node00005,arc00002,influence,[name=i2],[]).
arc(arc00006,node00002,node00005,influence,[complete=true,name=i5,role=[use(none,in_hierarchy,population,1)]],[curve=[7,22]]).
arc(arc00005,node00006,node00005,influence,[complete=true,name=i4,role=[use(none,in_hierarchy,growth_rate,1)]],[curve=[-8,13]]).
arc(arc00004,node00007,node00006,influence,[name=i3],[]).

