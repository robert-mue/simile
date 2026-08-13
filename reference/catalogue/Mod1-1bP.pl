source(program='AME',version= 9.0,edition=standard,date='Wed Feb 06 17:01:19 GMT 2008').

roots([node00019,node00020,node00021,node00022,node00023,node00024,node00025,node00026,node00027,node00028,node00029,node00030,node00031,node00032,node00033,node00034,node00035,node00036,node00037,node00038,node00039,node00040]).

properties([complete-true,file_name-'C:/Documents and Settings/jmm.KONTIKI/My Documents/simile/ModellingSoilBiosphere/Mod1-1b.sml',name-'Mod1-1bP',separate-0]).

node(node00019,compartment,[],[complete=true,description=g,name='Wsalt2'],[caption_offset=[-11,-49],centre=[258,44]]).
node(node00020,function,[],[complete=true,name=fn1,units=1,value='Wsalt_init'],[]).
node(node00021,cloud,[],[complete=true,name=cd2],[centre=[427,46]]).
node(node00022,function,[],[complete=true,name=fn3,units=1,value='Cflask'*'Finout'],[]).
node(node00023,variable,[],[complete=true,name=const],[caption_offset=[0,0],centre=[168,262]]).
node(node00024,function,[],[complete=true,name=fn4,units=1,value= - (log('Cin'-'Wsalt_init'/'Vflask')*'Vflask')],[]).
node(node00025,variable,[],[complete=true,name='Wsalt_analytical'],[caption_offset=[0,0],centre=[267,185]]).
node(node00026,function,[],[complete=true,name=fn5,units=1,value= - ('Vflask'*(exp(- ('Finout'*time(0)+const)/'Vflask')-'Cin'))],[]).
node(node00027,variable,[],[comment='g/l',complete=true,max_val=1000,min_val=0,name='Cin',units=int,value=30],[caption_offset=[-23,-9],centre=[82,205]]).
node(node00028,variable,[],[complete=true,description='l/h',max_val=10,min_val=0,name='Fin_out',units=int,value=2],[caption_offset=[29,-28],centre=[267,126]]).
node(node00029,variable,[],[comment='g/l',complete=true,name='Cflask'],[caption_offset=[7,-32],centre=[299,-21]]).
node(node00030,function,[],[complete=true,name=fn4_0,units=1,value='Wsalt'/'Vflask'],[]).
node(node00031,variable,[],[complete=true,description=l,max_val=10,min_val=0,name='Vflask',units=int,value=5],[caption_offset=[13,-34],centre=[481,-13]]).
node(node00032,variable,[],[complete=true,description=g,max_val=10,min_val=0,name='Wsalt_init',units=int,value=5],[caption_offset=[0,0],centre=[163,144]]).
node(node00033,compartment,[],[complete=true,name='Wsalt1'],[caption_offset=[1,-50],centre=[44,41]]).
node(node00034,function,[],[complete=true,name=fn1_0,spec=[87,115,97,108,116,49,95,105,110,105,116],units=1,value='Wsalt1_init'],[]).
node(node00035,cloud,[],[complete=true,name=cd1_0],[centre=[-96,42]]).
node(node00036,function,[],[complete=true,name=fn2_0,spec=[70,105,110,95,111,117,116,42,99,105,110,95,119,97,116,101,114],units=int,value='Fin_out'*cin_water],[]).
node(node00037,function,[],[complete=true,name=fn3_0,spec=[87,115,97,108,116,49,47,86,102,108,97,115,107,42,70,105,110,95,111,117,116],units=1,value='Wsalt1'/'Vflask'*'Fin_out'],[]).
node(node00038,variable,[],[complete=true,description='Initial mass of salt in flask 1 (g)',name='Wsalt1_init'],[caption_offset=[0,0],centre=[44,138]]).
node(node00039,function,[],[complete=true,name=fn4_1,spec=[67,105,110,42,86,102,108,97,115,107],units=int,value='Cin'*'Vflask'],[]).
node(node00040,variable,[],[complete=true,description='(g dm^-1)',max_val=20,min_val=0,name=cin_water,spec=[49,48],units=int,value=10],[caption_offset=[0,0],centre=[-50,140]]).

arc(arc00023,node00020,node00019,influence,[name=i1],[]).
arc(arc00024,node00019,node00021,flow,[complete=true,name='Rout'],[caption_offset=[-32,5],curve=[550,496]]).
arc(arc00025,node00022,arc00024,influence,[name=i3],[]).
arc(arc00026,node00024,node00023,influence,[name=i4],[]).
arc(arc00027,node00026,node00025,influence,[name=i5],[]).
arc(arc00028,node00023,node00026,influence,[complete=true,name=i6,role=[use(none,in_hierarchy,const,1)]],[curve=[-1,-39]]).
arc(arc00029,node00027,node00024,influence,[complete=true,name=i1_0,role=[use(none,in_hierarchy,'Cin',int)]],[curve=[41,-1]]).
arc(arc00030,node00027,node00026,influence,[complete=true,name=i3_1,role=[use(none,in_hierarchy,'Cin',int)]],[curve=[60,-54]]).
arc(arc00031,node00028,node00022,influence,[complete=true,name=i1_1,role=[use(none,in_hierarchy,'Finout',int)]],[curve=[-16,-17]]).
arc(arc00032,node00028,node00026,influence,[complete=true,name=i2_1,role=[use(none,in_hierarchy,'Finout',int)]],[curve=[8,-15]]).
arc(arc00033,node00029,node00022,influence,[complete=true,name=i13,role=[use(none,in_hierarchy,'Cflask',1)]],[curve=[14,-10]]).
arc(arc00034,node00030,node00029,influence,[name=i9],[]).
arc(arc00035,node00019,node00030,influence,[complete=true,name=i10,role=[use(none,in_hierarchy,'Wsalt',1)]],[curve=[-6,-13]]).
arc(arc00036,node00031,node00024,influence,[complete=true,name=i2_0,role=[use(none,in_hierarchy,'Vflask',int)]],[curve=[168,254]]).
arc(arc00037,node00031,node00026,influence,[complete=true,name=i1_2,role=[use(none,in_hierarchy,'Vflask',int)]],[curve=[34,21]]).
arc(arc00038,node00031,node00030,influence,[complete=true,name=i12,role=[use(none,in_hierarchy,'Vflask',int)]],[curve=[-12,22]]).
arc(arc00039,node00032,node00024,influence,[complete=true,name=i5_0,role=[use(none,in_hierarchy,'Wsalt_init',int)]],[curve=[13,20]]).
arc(arc00040,node00032,node00020,influence,[complete=true,name=i6_1,role=[use(none,in_hierarchy,'Wsalt_init',int)]],[curve=[-9,1]]).
arc(arc00041,node00033,node00019,flow,[complete=true,name='Rflask1_flask2'],[caption_offset=[-3,-46],curve=[550,500]]).
arc(arc00042,node00034,node00033,influence,[name=i1_3],[]).
arc(arc00043,node00035,node00033,flow,[complete=true,description='(g h^-1)',name='Rin_flask1'],[caption_offset=[-42,-45],curve=[550,500]]).
arc(arc00044,node00028,node00036,influence,[complete=true,name=i1_4,role=[use(none,in_hierarchy,'Fin_out',int)]],[curve=[-20,71]]).
arc(arc00045,node00036,arc00043,influence,[name=i2_2],[]).
arc(arc00046,node00033,node00037,influence,[complete=true,name=i1_5,role=[use(none,in_hierarchy,'Wsalt1',1)]],[curve=[0,-20]]).
arc(arc00047,node00037,arc00041,influence,[name=i3_2],[]).
arc(arc00048,node00028,node00037,influence,[complete=true,name=i4_1,role=[use(none,in_hierarchy,'Fin_out',int)]],[curve=[-19,26]]).
arc(arc00049,node00031,node00037,influence,[complete=true,name=i2_3,role=[use(none,in_hierarchy,'Vflask',int)]],[curve=[-76,-113]]).
arc(arc00050,node00038,node00034,influence,[complete=true,name=i9_0,role=[use(none,in_hierarchy,'Wsalt1_init',int)]],[curve=[2,-6]]).
arc(arc00051,node00039,node00038,influence,[name=i6_0],[]).
arc(arc00052,node00027,node00039,influence,[complete=true,name=i7,role=[use(none,in_hierarchy,'Cin',int)]],[curve=[-14,20]]).
arc(arc00053,node00031,node00039,influence,[complete=true,name=i8,role=[use(none,in_hierarchy,'Vflask',int)]],[curve=[-410,-315]]).
arc(arc00054,node00040,node00036,influence,[complete=true,name=i3_0,role=[use(none,in_hierarchy,cin_water,int)]],[curve=[-20,-4]]).

