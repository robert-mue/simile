source(program='AME',version= 9.0,edition=standard,date='Wed Feb 06 17:31:32 GMT 2008').

roots([node00002,node00003,node00004,node00005,node00006,node00007,node00008,node00009]).

properties([comment-'Robert Muetzelfeldt, 22/11/00\nThis model actually shows two alternative approaches to implementing a deterministic Markov model of vegetation change.  Both give exactly the same answers for the proportions of an area in different vegetation states.\nMerhod 1.  The variable ''proportions'' uses the ''prev(1)'' function to look at its previous value, except at time=0.\nMethod 2.  The variable ''current_proportions''  uses the last()'' function to look at the previous value of ''new_proportions'', except at time=0.\nBoth method use Simile''s built-in mechanism for array multiplication to actuall do the matrix multiplication.\nNote the order in which you need to enter the values for the transition probabilities.\nTo run the model: set Update#1 every to 1.\nPlot graphs for ''proportions'' and ''current proportions'' (they''ll give the same results).\nIf desired, use the Read/write data table helper to get the actual values for the either or both of these two variables (and thence export to a spreadsheet if required).',complete-true,file_name-'C:/Inetpub/wwwroot/www/examples/catalogue/models/bob/vegproportions1/vegproportions1.sml',multiplication_spec-[count=[]],name-vegproportions1,separate-0]).

node(node00002,variable,[],[comment='Matrix of transition probabilities\nColumn = current state\nRow = next state\nNote that the values are entered column by column into the Simile nested array.\n0.3\t0\t0\t0.7\n0.5\t0.4\t0\t0\n0.2\t0.6\t0.7\t0\n0\t0\t0.3\t0.3',complete=true,name='transition\nprobabilities'],[caption_offset=[-3,-50],centre=[147,101]]).
node(node00003,function,[],[complete=true,name=fn1,units=array(array(1,4),4),value=[[ 0.3, 0.5, 0.2, 0.0],[ 0.0, 0.4, 0.6, 0.0],[ 0.0, 0.0, 0.7, 0.3],[ 0.7, 0.0, 0.0, 0.3]]],[]).
node(node00004,variable,[],[complete=true,name='new\nproportions'],[caption_offset=[0,-6],centre=[236,162]]).
node(node00005,function,[],[complete=true,name=fn2,units=array(1*1,4),value=sum([[transition_probabilities]]*[current_proportions])],[]).
node(node00006,variable,[],[complete=true,name='current\nproportions'],[caption_offset=[5,-47],centre=[243,95]]).
node(node00007,function,[],[complete=true,name=fn3,units=array(1,4),value=(if time(1)==0 then [ 0.25, 0.1, 0.65, 0.0] else last([new_proportions]))],[]).
node(node00008,variable,[],[complete=true,name=porportions],[caption_offset=[4,8],centre=[82,170]]).
node(node00009,function,[],[complete=true,name=fn1_0,units=array(1,4),value=(if time(1)==0 then [ 0.25, 0.1, 0.65, 0.0] else sum([[transition_probabilities]]*prev(1)))],[]).

arc(arc00001,node00003,node00002,influence,[name=i1],[]).
arc(arc00002,node00005,node00004,influence,[name=i2],[]).
arc(arc00003,node00002,node00005,influence,[complete=true,name=i3,role=[use(none,in_hierarchy,[[transition_probabilities]],array(array(1,4),4))]],[curve=[13,-20]]).
arc(arc00007,node00006,node00005,influence,[complete=true,name=i3_0,role=[use(none,in_hierarchy,[current_proportions],array(1,4))]],[curve=[13,1]]).
arc(arc00004,node00007,node00006,influence,[name=i4],[]).
arc(arc00006,node00004,node00007,influence,[complete=true,name=i2_0,role=[use(none,in_hierarchy,[new_proportions],array(1*1,4))]],[curve=[-14,-2]]).
arc(arc00008,node00009,node00008,influence,[name=i4_0],[]).
arc(arc00009,node00002,node00009,influence,[complete=true,name=i5,role=[use(none,in_hierarchy,[[transition_probabilities]],array(array(1,4),4))]],[curve=[14,14]]).

