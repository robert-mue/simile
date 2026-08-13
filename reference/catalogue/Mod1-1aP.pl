source(program='AME',version= 9.0,edition=standard,date='Wed Feb 06 17:00:37 GMT 2008').

roots([node00001,node00002,node00004,node00005,node00006,node00007,node00008,node00009,node00010,node00011,node00012,node00013,node00014,node00015,node00016,node00017]).

properties([complete-true,file_name-'C:/Documents and Settings/jmm.KONTIKI/My Documents/simile/ModellingSoilBiosphere/Mod1-1a.sml',name-'Mod1-1aP',separate-0]).

node(node00001,compartment,[],[complete=true,description=g,name='Wsalt'],[caption_offset=[16,1],centre=[178,30]]).
node(node00002,function,[],[complete=true,name=fn1,units=1,value='Wsalt_init'],[]).
node(node00004,cloud,[],[complete=true,name=cd1],[centre=[39,31]]).
node(node00005,function,[],[complete=true,name=fn2,units=int,value='Cin'*'Fin'],[]).
node(node00006,cloud,[],[complete=true,name=cd2],[centre=[301,28]]).
node(node00007,function,[],[complete=true,name=fn3,units=1,value='Cflask'*'Finout'],[]).
node(node00008,variable,[],[complete=true,name=const],[caption_offset=[0,0],centre=[76,220]]).
node(node00009,function,[],[complete=true,name=fn4,units=1,value= - (log('Cin'-'Wsalt_init'/'Vflask')*'Vflask')],[]).
node(node00010,variable,[],[complete=true,name='Wsalt_analytical'],[caption_offset=[0,0],centre=[259,171]]).
node(node00011,function,[],[complete=true,name=fn5,units=1,value= - ('Vflask'*(exp(- ('Finout'*time(0)+const)/'Vflask')-'Cin'))],[]).
node(node00012,variable,[],[comment='g/l',complete=true,max_val=1000,min_val=0,name='Cin',units=int,value=30],[caption_offset=[-33,-7],centre=[87,104]]).
node(node00013,variable,[],[complete=true,description='l/h',max_val=10,min_val=0,name='Finout',units=int,value=2],[caption_offset=[29,-28],centre=[259,112]]).
node(node00014,variable,[],[comment='g/l',complete=true,name='Cflask'],[caption_offset=[7,-32],centre=[259,-37]]).
node(node00015,function,[],[complete=true,name=fn4_0,units=1,value='Wsalt'/'Vflask'],[]).
node(node00016,variable,[],[complete=true,description=l,max_val=10,min_val=0,name='Vflask',units=int,value=5],[caption_offset=[13,-34],centre=[359,16]]).
node(node00017,variable,[],[complete=true,description=g,max_val=10,min_val=0,name='Wsalt_init',units=int,value=5],[caption_offset=[0,0],centre=[155,130]]).

arc(arc00001,node00002,node00001,influence,[name=i1],[]).
arc(arc00002,node00004,node00001,flow,[complete=true,name='Rin'],[caption_offset=[0,0],curve=[550,500]]).
arc(arc00003,node00005,arc00002,influence,[name=i2],[]).
arc(arc00004,node00001,node00006,flow,[complete=true,name='Rout'],[caption_offset=[0,3],curve=[550,500]]).
arc(arc00005,node00007,arc00004,influence,[name=i3],[]).
arc(arc00006,node00009,node00008,influence,[name=i4],[]).
arc(arc00007,node00011,node00010,influence,[name=i5],[]).
arc(arc00008,node00008,node00011,influence,[complete=true,name=i6,role=[use(none,in_hierarchy,const,1)]],[curve=[4,0]]).
arc(arc00009,node00012,node00009,influence,[complete=true,name=i1_0,role=[use(none,in_hierarchy,'Cin',int)]],[curve=[-1,-4]]).
arc(arc00010,node00012,node00005,influence,[complete=true,name=i3_0,role=[use(none,in_hierarchy,'Cin',int)]],[curve=[9,-24]]).
arc(arc00011,node00012,node00011,influence,[complete=true,name=i3_1,role=[use(none,in_hierarchy,'Cin',int)]],[curve=[59,-54]]).
arc(arc00012,node00013,node00005,influence,[complete=true,name=i4_0,role=[use(none,in_hierarchy,'Fin',int)]],[curve=[4,-14]]).
arc(arc00013,node00013,node00007,influence,[complete=true,name=i1_1,role=[use(none,in_hierarchy,'Finout',int)]],[curve=[16,-32]]).
arc(arc00014,node00013,node00011,influence,[complete=true,name=i2_1,role=[use(none,in_hierarchy,'Finout',int)]],[curve=[8,-15]]).
arc(arc00015,node00014,node00007,influence,[complete=true,name=i13,role=[use(none,in_hierarchy,'Cflask',1)]],[curve=[12,3]]).
arc(arc00016,node00015,node00014,influence,[name=i9],[]).
arc(arc00017,node00001,node00015,influence,[complete=true,name=i10,role=[use(none,in_hierarchy,'Wsalt',1)]],[curve=[-12,-14]]).
arc(arc00018,node00016,node00009,influence,[complete=true,name=i2_0,role=[use(none,in_hierarchy,'Vflask',int)]],[curve=[170,258]]).
arc(arc00019,node00016,node00011,influence,[complete=true,name=i1_2,role=[use(none,in_hierarchy,'Vflask',int)]],[curve=[36,23]]).
arc(arc00020,node00016,node00015,influence,[complete=true,name=i12,role=[use(none,in_hierarchy,'Vflask',int)]],[curve=[-11,22]]).
arc(arc00021,node00017,node00009,influence,[complete=true,name=i5_0,role=[use(none,in_hierarchy,'Wsalt_init',int)]],[curve=[22,2]]).
arc(arc00022,node00017,node00002,influence,[complete=true,name=i6_1,role=[use(none,in_hierarchy,'Wsalt_init',int)]],[curve=[-4,2]]).

