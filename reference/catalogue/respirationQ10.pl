source(program='AME',version= 9.0,edition=standard,date='Wed Feb 06 17:24:30 GMT 2008').

roots([node00002,node00007,node00008]).

properties([complete-true,file_name-'F:/Program Files/www/examples/catalogue/models/respirationQ10/respirationQ10.sml',fill_colour-'#ffffff',multiplication_spec-[count=[]],name-respirationQ10,separate-0]).

node(node00002,submodel,[node00009,node00031,node00033,node00034,node00035,node00036,node00038,node00039],[complete=true,fill_colour='#ffffff',multiplication_spec=[count=[]],name='Dark Respiration',separate=0],[bounding_box=[-13,-24,119,81],caption_offset=[0,0],internal_extent=[0,0,131,106]]).
links(node00002,[arc00007-arc00006]).
node(node00009,border,[],[name=var2],[centre=[0,54]]).
node(node00031,variable,[],[complete=true,description='Respiration rate',name='R'],[caption_offset=[0,0],centre=[42,53]]).
node(node00033,function,[],[complete=true,name=fn1,spec=[82,114,101,102,42,81,49,48,94,40,40,84,45,84,114,101,102,41,47,49,48,41],units=1,value='Rref'*'Q10'^(('T'-'Tref')/10)],[]).
node(node00034,variable,[],[comment='Respiration rate at reference temperature Tref',complete=true,description='Reference respiration rate',name='Rref'],[caption_offset=[0,0],centre=[74,14]]).
node(node00035,function,[],[complete=true,name=fn2,spec=[49],units=1,value=1],[]).
node(node00036,variable,[],[comment='Coefficient by which the respiration rate increases for any 10 degree Celcius temperature increase.',complete=true,description='Q10',max_val= 10.0,min_val= 1.0,name='Q10',spec=[50,46,48],units=1,value= 2.0],[caption_offset=[0,0],centre=[100,77]]).
node(node00038,variable,[],[comment='Temperature where respiration rate equals Rref',complete=true,description='Reference temperature',name='Tref'],[caption_offset=[0,0],centre=[115,44]]).
node(node00039,function,[],[complete=true,name=fn4,spec=[48],units=1,value=0],[]).
node(node00007,variable,[],[complete=true,description='Temperature of respiring tissue',name='T'],[caption_offset=[0,0],centre=[-40,27]]).
node(node00008,function,[],[complete=true,name=fn1,spec=[105,102,32,116,105,109,101,40,41,62,53,48,32,116,104,101,110,32,52,48,10,101,108,115,101,32,116,105,109,101,40,41,45,49,48],units=1,value=(if time('')>50 then 40 else time('')-10)],[]).

arc(arc00006,node00009,node00033,influence,[complete=true,name=i2,role=[use(none,in_hierarchy,'T',1)]],[curve=[2,-11]]).
arc(arc00026,node00033,node00031,influence,[name=i1],[]).
arc(arc00029,node00034,node00033,influence,[complete=true,name=i4,role=[use(none,in_hierarchy,'Rref',1)]],[curve=[2,3]]).
arc(arc00027,node00035,node00034,influence,[name=i2_0],[]).
arc(arc00030,node00036,node00033,influence,[complete=true,name=i5_0,role=[use(none,in_hierarchy,'Q10',1)]],[curve=[-2,5]]).
arc(arc00033,node00038,node00033,influence,[complete=true,name=i8,role=[use(none,in_hierarchy,'Tref',1)]],[curve=[2,8]]).
arc(arc00032,node00039,node00038,influence,[name=i7],[]).
arc(arc00007,node00007,node00002,influence,[complete=true,name=i3],[curve=[1,-5]]).
arc(arc00005,node00008,node00007,influence,[name=i1],[]).

