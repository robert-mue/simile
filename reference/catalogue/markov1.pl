source(program='AME',version= 9.0,edition=standard,date='Wed Feb 06 16:57:18 GMT 2008').

roots([node00004,node00007,node00008]).

properties([complete-true,file_name-'C:/Inetpub/wwwroot/www/examples/catalogue/models/bob/markov1/markov1.sml',name-markov1,separate-0]).

node(node00004,submodel,[node00002,node00003,node00005,node00006,node00009,node00010,node00011],[complete=true,fill_colour='#80ff80',multiplication_spec=[count=[100]],name=patch,separate=0],[bounding_box=[88,75,245,150],caption_offset=[12,-7],internal_extent=[0,0,157,75]]).
links(node00004,[arc00004-arc00005]).
node(node00002,variable,[],[comment='if time(1)==0 then 1 elseif last(1)==1 and rand_var(0,1)<0.1 then 2 elseif last(1)==2 and rand_var(0,1)<0.1 then 1 else last(1)',complete=true,name=state],[caption_offset=[0,0],centre=[113,31]]).
node(node00003,function,[],[complete=true,max_val=1,min_val=0,name=fn1,units=int,value=(if time(1)==0 then 0 elseif prev(1)==0 and rand_var(0,1)< 0.1 then 1 elseif prev(1)==1 and rand_var(0,1)< 0.1 then 0 else prev(1))],[]).
node(node00005,variable,[],[complete=true,name=column],[caption_offset=[0,0],centre=[25,35]]).
node(node00006,function,[],[complete=true,name=fn1_0,units=1,value=fmod(index(1)-1,10)+1],[]).
node(node00009,border,[],[name=var3],[centre=[157,14]]).
node(node00010,variable,[],[complete=true,name=row],[caption_offset=[0,0],centre=[69,35]]).
node(node00011,function,[],[complete=true,name=fn1_1,units=int,value=1],[]).
node(node00007,variable,[],[complete=true,name=n1],[caption_offset=[0,0],centre=[320,106]]).
node(node00008,function,[],[complete=true,name=fn2,units=int,value=sum([state])],[]).

arc(arc00001,node00003,node00002,influence,[name=i1],[]).
arc(arc00002,node00006,node00005,influence,[name=i1_0],[]).
arc(arc00004,node00002,node00009,influence,[complete=true,name=i3],[curve=[-2,-20]]).
arc(arc00006,node00011,node00010,influence,[name=i1_1],[]).
arc(arc00003,node00008,node00007,influence,[name=i2],[]).
arc(arc00005,node00004,node00008,influence,[complete=true,name=i4,role=[use(none,in_hierarchy,[state],array(int,size(submodel1)))]],[curve=[-1,-10]]).

