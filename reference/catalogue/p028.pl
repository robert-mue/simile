source(program='AME',version= 9.0,edition=standard,date='Wed Feb 06 17:04:31 GMT 2008').

roots([node00002,node00003,node00004,node00005,node00006,node00007,node00008,node00009,node00010,node00011,node00012,node00013,node00014,node00015,node00016,node00017,node00018,node00019,node00020,node00021,node00022,node00023,node00024,node00025]).

properties([complete-true,file_name-'C:/Inetpub/wwwroot/www/examples/catalogue/models/ford/p028/p028.sim',name-p028,separate-0]).

node(node00002,compartment,[],[comment='Number of young, millions',complete=true,name=young],[caption_offset=[0,-46],centre=[-26,119]]).
node(node00003,function,[],[complete=true,name=fn1,units=1,value=50],[]).
node(node00004,compartment,[],[comment='Number of mature, millions',complete=true,name=mature],[caption_offset=[-1,-47],centre=[108,120]]).
node(node00005,function,[],[complete=true,name=fn2,units=1,value=30],[]).
node(node00006,compartment,[],[comment='Number of elderly, millions',complete=true,name=elderly],[caption_offset=[1,-46],centre=[230,122]]).
node(node00007,function,[],[complete=true,name=fn3,units=1,value=20],[]).
node(node00008,cloud,[],[complete=true,name=cd1],[centre=[-110,117]]).
node(node00009,function,[],[complete=true,name=fn4,units=1*(1*1),value=births_per_mature_female_per_year*mature_females],[]).
node(node00010,function,[],[complete=true,name=fn5,units=1*1,value=maturation_rate*young],[]).
node(node00011,function,[],[complete=true,name=fn6,units=1*1,value=aging_rate*mature],[]).
node(node00012,cloud,[],[complete=true,name=cd2],[centre=[331,116]]).
node(node00013,function,[],[complete=true,name=fn7,units=1*1,value=death_rate*elderly],[]).
node(node00014,variable,[],[comment='Number of births per female per year',complete=true,name='births per mature\nfemale per year'],[caption_offset=[0,0],centre=[-85,179]]).
node(node00015,function,[],[complete=true,name=fn8,units=1,value= 0.5],[]).
node(node00016,variable,[],[comment='Number of mature females, millions',complete=true,name='mature females'],[caption_offset=[-5,4],centre=[87,184]]).
node(node00017,function,[],[complete=true,name=fn9,units=1*1,value=female_fraction*mature],[]).
node(node00018,variable,[],[comment='Proportion of females in the population',complete=true,name='female fraction'],[caption_offset=[61,-15],centre=[180,187]]).
node(node00019,function,[],[complete=true,name=fn10,units=1,value= 0.5],[]).
node(node00020,variable,[],[comment='Proportion of young maturing, per year',complete=true,name='maturation rate'],[caption_offset=[-57,-16],centre=[13,64]]).
node(node00021,function,[],[complete=true,name=fn11,units=1,value= 0.1],[]).
node(node00022,variable,[],[comment='Proportion aging, per year',complete=true,name='aging rate'],[caption_offset=[-43,-17],centre=[123,63]]).
node(node00023,function,[],[complete=true,name=fn12,units=1,value= 0.1],[]).
node(node00024,variable,[],[comment='Proportion dying, per year',complete=true,name='death rate'],[caption_offset=[-41,-16],centre=[269,66]]).
node(node00025,function,[],[complete=true,name=fn13,units=1,value= 0.2],[]).

arc(arc00001,node00003,node00002,influence,[name=i1],[]).
arc(arc00006,node00002,node00004,flow,[comment='Number maturing, millions per year',complete=true,name=maturation],[caption_offset=[-43,3],curve=[550,613]]).
arc(arc00002,node00005,node00004,influence,[name=i2],[]).
arc(arc00008,node00004,node00006,flow,[comment='Number maturing, millions per year',complete=true,name=aging],[caption_offset=[-29,2],curve=[550,646]]).
arc(arc00003,node00007,node00006,influence,[name=i3],[]).
arc(arc00004,node00008,node00002,flow,[comment='Births, millions per year',complete=true,name=births],[caption_offset=[-15,5],curve=[550,509]]).
arc(arc00005,node00009,arc00004,influence,[name=i4],[]).
arc(arc00007,node00010,arc00006,influence,[name=i5],[]).
arc(arc00022,node00002,node00010,influence,[complete=true,name=i18,role=[use(none,in_hierarchy,young,1)]],[curve=[4,-25]]).
arc(arc00009,node00011,arc00008,influence,[name=i6],[]).
arc(arc00024,node00004,node00011,influence,[complete=true,name=i20,role=[use(none,in_hierarchy,mature,1)]],[curve=[0,-20]]).
arc(arc00010,node00006,node00012,flow,[comment='Number dying, millions per year',complete=true,name=deaths],[caption_offset=[-31,3],curve=[550,657]]).
arc(arc00011,node00013,arc00010,influence,[name=i7],[]).
arc(arc00026,node00006,node00013,influence,[complete=true,name=i22,role=[use(none,in_hierarchy,elderly,1)]],[curve=[-2,-20]]).
arc(arc00018,node00014,node00009,influence,[complete=true,name=i14,role=[use(none,in_hierarchy,births_per_mature_female_per_year,1)]],[curve=[-10,-2]]).
arc(arc00012,node00015,node00014,influence,[name=i8],[]).
arc(arc00019,node00016,node00009,influence,[complete=true,name=i15,role=[use(none,in_hierarchy,mature_females,1*1)]],[curve=[-15,36]]).
arc(arc00013,node00017,node00016,influence,[name=i9],[]).
arc(arc00021,node00004,node00017,influence,[complete=true,name=i17,role=[use(none,in_hierarchy,mature,1)]],[curve=[10,2]]).
arc(arc00020,node00018,node00017,influence,[complete=true,name=i16,role=[use(none,in_hierarchy,female_fraction,1)]],[curve=[-1,20]]).
arc(arc00014,node00019,node00018,influence,[name=i10],[]).
arc(arc00023,node00020,node00010,influence,[complete=true,name=i19,role=[use(none,in_hierarchy,maturation_rate,1)]],[curve=[10,-8]]).
arc(arc00015,node00021,node00020,influence,[name=i11],[]).
arc(arc00025,node00022,node00011,influence,[complete=true,name=i21,role=[use(none,in_hierarchy,aging_rate,1)]],[curve=[11,-12]]).
arc(arc00016,node00023,node00022,influence,[name=i12],[]).
arc(arc00027,node00024,node00013,influence,[complete=true,name=i23,role=[use(none,in_hierarchy,death_rate,1)]],[curve=[9,-4]]).
arc(arc00017,node00025,node00024,influence,[name=i13],[]).

