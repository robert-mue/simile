source(program='AME',version= 9.0,edition=standard,date='Tue Feb 05 17:09:46 GMT 2008').

roots([node00057,node00058,node00059,node00060,node00062]).

properties([complete-true,file_name-'/win98/Program Files/Simile/Develop/Library/chaos.sml',fill_colour-'#f8fcc0',min_val-0,multiplication_spec-[count=[]],name-chaos,separate-0,units-1,value- 0.5]).

node(node00057,compartment,[],[complete=true,min_val=0,name=level],[caption_offset=[0,0],centre=[273,122]]).
node(node00058,cloud,[],[complete=true,name=cd1],[centre=[54,122]]).
node(node00059,function,[],[complete=true,name=fn1,units=1,value=gain*level*(1-level/100)],[]).
node(node00060,variable,[],[complete=true,max_val=3,min_val=1,name=gain,spec=[49,46,53],units=1,value= 1.5],[caption_offset=[0,0],centre=[107,49]]).
node(node00062,function,[],[complete=true,spec=[114,97,110,100,95,99,111,110,115,116,40,53,48,44,53,48,46,48,48,48,48,48,49,41],units=1,value=rand_const(50, 50.000001)],[]).

arc(arc00063,node00058,node00057,flow,[complete=true,name=change],[caption_offset=[0,0],curve=[550,497]]).
arc(arc00064,node00059,arc00063,influence,[complete=true,name=i1],[]).
arc(arc00066,node00057,node00059,influence,[complete=true,name=i3,role=[use(none,in_hierarchy,level,1)]],[curve=[0,22]]).
arc(arc00002,node00060,node00059,influence,[complete=true,name=i4,role=[use(none,in_hierarchy,gain,1)]],[curve=[14,-10]]).
arc(arc00068,node00062,node00057,influence,[],[]).

