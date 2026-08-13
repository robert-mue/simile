source(program='AME',version= 9.0,edition=standard,date='Wed Feb 06 15:40:23 GMT 2008').

roots([node00571,node00572,node00576,node00577,node00586,node00588]).

properties([comment-'Designed by Robert Muetzelfeldt\n20/10/2000\nThis takes as input:\n- an array of times needed for each of n activities;\n- an array of the prioroty for each of the n activities;\n- a total time available\nand allocates an actual time for the higher-priority activities, until all the available time has been used up.  The rest get zero, except for the one at the threshold which is allocated any remaining time.\nThis is an implementation of the prioroty-based time allocated method mentiond by Jerry Vanclay in his first FLORES papers.',complete-true,file_name-'C:/Inetpub/wwwroot/www/examples/catalogue/models/bob/labour_by_priority1/labour_by_priority1.sml',fill_colour-'#ffffff',multiplication_spec-[count=[]],name-labour_by_priority1,separate-0]).

node(node00571,submodel,[node00592,node00593,node00594,node00595,node00596,node00597,node00598,node00599,node00600,node00601,node00602,node00603,node00604,node00605],[complete=true,fill_colour='#ffff80',multiplication_spec=[count=[5]],name='Activity',separate=0],[bounding_box=[182,47,329,253],caption_offset=[9,-7],internal_extent=[0,0,147,206]]).
links(node00571,[arc00367-arc00482,arc00368-arc00483,arc00370-arc00603,arc00376-arc00438,arc00443-arc00442,arc00465-arc00481]).
references(node00571,[local(arc00343),local(arc00344),obsolete,obsolete,ancestor(0),ancestor(1)]).
node(node00592,variable,[],[complete=true,name=priority],[caption_offset=[9,-2],centre=[52,41]]).
node(node00593,function,[],[complete=true,name=fn2,units=1,value=element([priorities],index(1))],[]).
node(node00594,variable,[],[complete=true,name='time\nrequired'],[caption_offset=[5,-39],centre=[71,112]]).
node(node00595,function,[],[complete=true,name=fn3,units=1,value=element([time_required],index(1))],[]).
node(node00596,variable,[],[complete=true,name='sum of higher\npriority times'],[caption_offset=[0,0],centre=[50,167]]).
node(node00597,function,[],[complete=true,name=fn5,units=1,value=sum({value_0})],[]).
node(node00598,border,[],[name=var7],[centre=[0,141]]).
node(node00599,border,[],[name=var10],[centre=[0,163]]).
node(node00600,border,[],[name=var13],[centre=[0,64]]).
node(node00601,border,[],[name=var16],[centre=[43,0]]).
node(node00602,border,[],[name=var18],[centre=[147,106]]).
node(node00603,variable,[],[complete=true,name='time\nallocated'],[caption_offset=[0,0],centre=[117,170]]).
node(node00604,function,[],[complete=true,name=fn8,units=1,value=(if sum_of_higher_priority_times+time_required<time_available then time_required elseif sum_of_higher_priority_times<time_available then sum_of_higher_priority_times+time_required-time_available else 0)],[]).
node(node00605,border,[],[name=var21],[centre=[85,0]]).
node(node00572,submodel,[node00607,node00608,node00609,node00610,node00611,node00612,node00613],[complete=true,fill_colour='#ffff80',multiplication_spec=[count=[]],name='Higher priority'],[bounding_box=[17,93,114,219],caption_offset=[35,-9],internal_extent=[0,0,97,126]]).
links(node00572,[arc00438-arc00433,arc00440-arc00443,arc00481-arc00466]).
references(node00572,[local(arc00343),local(arc00344),ancestor(0),ancestor(1)]).
node(node00607,condition,[],[complete=true,name='higher priority\ncondition'],[caption_offset=[2,3],centre=[46,26]]).
node(node00608,function,[],[complete=true,name=fn1,units=boolean,value=(priority>priority_0)],[]).
node(node00609,variable,[],[complete=true,name=value],[caption_offset=[0,0],centre=[46,85]]).
node(node00610,function,[],[complete=true,name=fn4,units=1,value=value],[]).
node(node00611,border,[],[name=var8],[centre=[97,78]]).
node(node00612,border,[],[name=var9],[centre=[97,101]]).
node(node00613,border,[],[name=var14],[centre=[97,27]]).
node(node00576,variable,[],[complete=true,name=priorities,param_type=file,units=array(1,5)],[caption_offset=[0,0],centre=[131,0]]).
node(node00577,variable,[],[complete=true,name='time available',param_type=file,units=1],[caption_offset=[2,-33],centre=[246,11]]).
node(node00586,variable,[],[complete=true,name='times required',param_type=file,units=array(1,5)],[caption_offset=[13,-29],centre=[360,153]]).
node(node00588,function,[],[comment='Why 94? Why not?',name=fn5,units=array(1/1,2),value=(if ['Tasks_req']>0 then [time_allocated]/['Tasks_req'] else 94)],[]).

arc(arc00358,node00593,node00592,influence,[name=i2],[]).
arc(arc00365,node00595,node00594,influence,[name=i3],[]).
arc(arc00375,node00597,node00596,influence,[name=i8],[]).
arc(arc00376,node00594,node00598,influence,[complete=true,name=i9],[curve=[6,16]]).
arc(arc00442,node00599,node00597,influence,[complete=true,name=i13,role=[use(0,in_assoc,{value},list(1)),use(1,in_assoc,{value_0},list(1)),use(none,in_hierarchy,{value_1},list(1))]],[curve=[0,-12]]).
arc(arc00465,node00592,node00600,influence,[complete=true,name=i16],[curve=[4,10]]).
arc(arc00482,node00601,node00593,influence,[complete=true,name=i20,role=[use(none,in_hierarchy,[priorities],array(1,5))]],[curve=[8,-2]]).
arc(arc00483,node00602,node00595,influence,[complete=true,name=i23,role=[use(none,in_hierarchy,[time_required],array(1,5))]],[curve=[1,18]]).
arc(arc00602,node00604,node00603,influence,[name=i25],[]).
arc(arc00604,node00594,node00604,influence,[complete=true,name=i30,role=[use(none,in_hierarchy,time_required,1)]],[curve=[12,-10]]).
arc(arc00608,node00596,node00604,influence,[complete=true,name=i31,role=[use(none,in_hierarchy,sum_of_higher_priority_times,1)]],[curve=[0,-14]]).
arc(arc00603,node00605,node00604,influence,[complete=true,name=i28,role=[use(none,in_hierarchy,time_available,1)]],[curve=[40,-8]]).
arc(arc00343,node00571,node00572,relation,[complete=true,name=before],[caption_offset=[1,9],curve=[1,17]]).
arc(arc00344,node00571,node00572,relation,[complete=true,name=after],[caption_offset=[4,-10],curve=[7,-14]]).
arc(arc00438,node00571,node00572,influence,[complete=true,name=i11],[curve=[-6,16]]).
arc(arc00443,node00572,node00571,influence,[complete=true,name=i14],[curve=[4,-18]]).
arc(arc00481,node00571,node00572,influence,[complete=true,name=i18],[curve=[-6,6]]).
arc(arc00354,node00608,node00607,influence,[name=i1],[]).
arc(arc00374,node00610,node00609,influence,[name=i7],[]).
arc(arc00433,node00611,node00610,influence,[complete=true,name=i10,role=[use(0,in_base,value,1),use(1,in_base,value_0,1),use(none,in_hierarchy,[value_1],array(1,size(item)))]],[curve=[-4,-4]]).
arc(arc00440,node00609,node00612,influence,[complete=true,name=i12],[curve=[0,6]]).
arc(arc00466,node00613,node00608,influence,[complete=true,name=i17,role=[use(0,in_base,priority,1),use(1,in_base,priority_0,1),use(none,in_hierarchy,[priority_1],array(1,size(item)))]],[curve=[-1,8]]).
arc(arc00367,node00576,node00571,influence,[complete=true,name=i21],[curve=[11,-22]]).
arc(arc00370,node00577,node00571,influence,[complete=true,name=i29],[curve=[14,-8]]).
arc(arc00368,node00586,node00571,influence,[complete=true,name=i24],[curve=[0,6]]).

