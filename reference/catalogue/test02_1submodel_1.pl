source(program='AME',version= 9.0,edition=standard,date='Mon Jun 09 14:38:38 GMT 2008').

roots([node00007]).

properties([comment-'(if land_alloc_rule==1 and sum(sum({[crop_area]}))==0 then floor(social_capital)*1000+index(1) elseif land_alloc_rule==2 then 5000-floor(wealth)*1000+index(1) elseif land_alloc_rule==3 then floor(wealth)*1000+index(1) else 0)',complete-true,enum_types-[fruit-[apple,orange,lemon]],file_name-'C:/Documents and Settings/jvanclay/My_Documents/ZimFLORES/ZimFlores5jv-beta7.sml',fill_colour-blue,name-'test021submodel']).

node(node00007,submodel,[node00001,node00002,node00003,node00004,node00005,node00006],[comment='This is a comment',complete=true,enum_types=[fruit-[apple,orange,lemon]],fill_colour=white,name='Submodel1',multiplication_spec=[count=[4,44]]],[bounding_box=[203,54,455,260],caption_offset=[0,0],internal_extent=[0,0,252,206]]).
node(node00001,compartment,[],[complete=true,name='Comp1',multiplication_spec=[count=[]],value=(if time(1)==init_time(1) then '"false"' else head '!=' last(head))],[caption_offset=[0,0],centre=[70,101]]).
node(node00002,function,[],[complete=true,name=fn1,spec='100',units=1,value=100,multiplication_spec=[type=population]],[]).
node(node00003,cloud,[],[complete=true,name=cd1,multiplication_spec=[type=records]],[centre=[207,102]]).
node(node00004,function,[],[complete=true,name=fn2,spec='Var1*Comp1',units=1,value='Var1'*'Comp1',multiplication_spec=[count=[size(Patch)]]],[]).
node(node00005,variable,[],[complete=true,name='Var1',multiplication_spec=[count=[4]]],[caption_offset=[0,0],centre=[120,33]]).
node(node00006,function,[],[complete=true,name=fn3,spec='0.1',units=1,value= 0.1,multiplication_spec=[count=[905,'"troll"']]],[]).
arc(arc00001,node00002,node00001,influence,[name=i1],[]).
arc(arc00002,node00001,node00003,flow,[complete=true,name='Flow1'],[caption_offset=[0,0],curve=[550,450]]).
arc(arc00003,node00004,arc00002,influence,[name=i2],[]).
arc(arc00005,node00001,node00004,influence,[complete=true,name=i4,role=[use(none,in_hierarchy,'Comp1',1)]],[curve=[6,-11]]).
arc(arc00006,node00005,node00004,influence,[complete=true,name=i5,role=[use(none,in_hierarchy,['Var1'],1)]],[curve=[11,-6]]).
arc(arc00004,node00006,node00005,influence,[name=i3],[]).
