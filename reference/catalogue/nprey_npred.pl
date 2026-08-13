source(program='AME',version= 9.0,edition=standard,date='Wed Feb 06 17:02:32 GMT 2008').

roots([node00002,node00003,node00049]).

properties([comment-'This implements the feeding part of predator-prey model with multiple prey species and multiple predator species.   Each predator species predates the multiple prey species as per the "multiprey disc equation" developed by Charnov (1974), and reported in "Serengeti" (Eds Sinclair and Norton-Griffiths) (1979), p.295.  This  has been extended to cater for multiple predator species.\n\nThe disc equaltion for the functional response of one predator species feeding on one prey species is:\nE = a*N/(1+h*a*N)\nwhere:\n  E = number of prey consumed by one predator per unit of time;\n  N = prey density (numbers)\n  a = "rate of search" of predator;\n  h = "handling time" of predator for one prey item.\n\nWith multiple prey, the equation (for one predator species) becomes:\nEi = ai*Ni/(1+sum(j=1...N of hj*aj*Nj)\n\nThis model implements this equation for multiple predator species.\n\nNote that this model has the bare bones required just for handling the predation interaction.   It is *not* a complete predator-prey model, since the normal population processes (reproduction for prey and reproduction and mortality for predator) are not included.   The only such process that is included is the prey mortality rate through predation, since that is a core element of the analysis.   On the predator side, the variable ''total_weight_eaten'' would normally be used to influence the predators'' reproduction and mortality rates.',complete-true,multiplication_spec-[count=[]],name-nprey_npred,separate-0]).

node(node00002,submodel,[node00008,node00009,node00023,node00026,node00027,node00030,node00031,node00058,node00068],[complete=true,fill_colour='#ffffd2',multiplication_spec=[count=[3]],name='Prey species',separate=0],[bounding_box=[-46,40,144,344],caption_offset=[0,0],internal_extent=[58,22,248,326]]).
links(node00002,[arc00007-arc00044,arc00022-arc00019,arc00025-arc00058]).
node(node00008,compartment,[],[complete=true,name='Nprey'],[caption_offset=[-12,-1],centre=[139,121]]).
node(node00009,function,[],[complete=true,name=fn3,spec=[101,108,101,109,101,110,116,40,91,49,48,48,44,50,48,48,44,51,48,48,93,44,105,110,100,101,120,40,49,41,41],units=1,value=element([100,200,300],index(1))],[]).
node(node00023,border,[],[name=var13],[centre=[248,151]]).
node(node00026,cloud,[],[complete=true,name=cd1],[centre=[230,117]]).
node(node00027,function,[],[complete=true,name=fn8,units=1,value=element(sum([['E_Npred']]),index(1))],[]).
node(node00030,variable,[],[complete=true,name=weight],[caption_offset=[0,0],centre=[207,51]]).
node(node00031,function,[],[complete=true,name=fn10,spec=[101,108,101,109,101,110,116,40,91,49,48,44,50,48,44,51,48,93,44,105,110,100,101,120,40,49,41,41],units=int,value=element([10,20,30],index(1))],[]).
node(node00058,border,[],[name=var33],[centre=[248,223]]).
node(node00068,border,[],[name=var42],[centre=[248,64]]).
node(node00003,submodel,[node00007,node00010,node00013,node00070,node00071,node00073],[complete=true,fill_colour='#ffce9d',multiplication_spec=[count=[2]],name='Predator species',separate=0],[bounding_box=[508,48,704,354],caption_offset=[0,0],internal_extent=[0,10,196,316]]).
links(node00003,[arc00008-arc00011,arc00062-arc00061]).
node(node00007,compartment,[],[complete=true,name='Npred'],[caption_offset=[0,0],centre=[85,168]]).
node(node00010,function,[],[complete=true,name=fn2,spec=[101,108,101,109,101,110,116,40,91,49,44,50,93,44,105,110,100,101,120,40,49,41,41],units=1,value=element([1,2],index(1))],[]).
node(node00013,border,[],[name=var4],[centre=[0,190]]).
node(node00070,variable,[],[complete=true,name=total_weight_eaten],[caption_offset=[72,-16],centre=[46,104]]).
node(node00071,function,[],[complete=true,name=fn19,units=1,value=element([total_weight_eaten],index(1))],[]).
node(node00073,border,[],[name=var46],[centre=[0,95]]).
node(node00049,submodel,[node00015,node00022,node00048,node00056,node00057,node00059,node00063,node00065,node00066,node00069,node00072],[complete=true,fill_colour='#ffce9d',multiplication_spec=[count=[2]],name='Pred_eating',separate=0],[bounding_box=[191,123,464,351],caption_offset=[0,0],internal_extent=[-65,-26,208,202]]).
links(node00049,[arc00011-arc00010,arc00018-arc00022,arc00044-arc00043,arc00044-arc00051,arc00058-arc00057,arc00060-arc00062]).
node(node00015,border,[],[name=var6],[centre=[208,81]]).
node(node00022,border,[],[name=var12],[centre=[-65,24]]).
node(node00048,submodel,[node00006,node00011,node00012,node00014,node00021,node00050,node00051,node00052,node00053,node00054,node00055,node00060,node00061,node00062,node00064],[complete=true,fill_colour='#ffffd2',multiplication_spec=[count=[3]],name='Prey_eating',separate=0],[bounding_box=[24,49,178,193],caption_offset=[-16,0],internal_extent=[-27,0,127,144]]).
links(node00048,[arc00010-arc00009,arc00017-arc00018,arc00045-arc00046,arc00047-arc00048,arc00051-arc00050,arc00053-arc00052,arc00055-arc00056]).
node(node00006,border,[],[name=var2],[centre=[86,0]]).
node(node00011,variable,[],[complete=true,name='E_Npred'],[caption_offset=[3,-32],centre=[29,28]]).
node(node00012,function,[],[complete=true,name=fn3,spec=[69,42,101,108,101,109,101,110,116,40,91,78,112,114,101,100,93,44,105,110,100,101,120,40,50,41,41],units=1,value='E'*element(['Npred'],index(2))],[]).
node(node00014,border,[],[name=var5],[centre=[127,34]]).
node(node00021,border,[],[name=var11],[centre=[-25,8]]).
node(node00050,variable,[],[complete=true,name='E'],[caption_offset=[-9,2],centre=[58,64]]).
node(node00051,function,[],[complete=true,name=fn14,units=1,value=a*element(['Nprey'],index(1))/(1+sum_haN)],[]).
node(node00052,variable,[],[complete=true,name=a],[caption_offset=[0,0],centre=[88,95]]).
node(node00053,function,[],[complete=true,name=fn15,spec=[101,108,101,109,101,110,116,40,101,108,101,109,101,110,116,40,91,91,48,46,48,49,44,48,46,48,50,44,48,46,48,51,93,44,91,48,46,48,50,44,48,46,48,52,44,48,46,48,54,93,93,44,105,110,100,101,120,40,50,41,41,44,105,110,100,101,120,40,49,41,41],units=1,value=element(element([[ 0.01, 0.02, 0.03],[ 0.02, 0.04, 0.06]],index(2)),index(1))],[]).
node(node00054,variable,[],[complete=true,name=h],[caption_offset=[0,0],centre=[60,116]]).
node(node00055,function,[],[complete=true,name=fn16,spec=[101,108,101,109,101,110,116,40,101,108,101,109,101,110,116,40,91,91,48,46,49,44,48,46,50,44,48,46,51,93,44,91,48,46,50,44,48,46,52,44,48,46,54,93,93,44,105,110,100,101,120,40,50,41,41,44,105,110,100,101,120,40,49,41,41],units=1,value=element(element([[ 0.1, 0.2, 0.3],[ 0.2, 0.4, 0.6]],index(2)),index(1))],[]).
node(node00060,border,[],[name=var35],[centre=[-27,121]]).
node(node00061,border,[],[name=var36],[centre=[-27,95]]).
node(node00062,border,[],[name=var37],[centre=[-27,33]]).
node(node00064,border,[],[name=var39],[centre=[-27,71]]).
node(node00056,variable,[],[complete=true,name=sum_haN],[caption_offset=[-31,-2],centre=[-3,123]]).
node(node00057,function,[],[complete=true,name=fn17,units=1,value=sum([h]*[a]*['Nprey'])],[]).
node(node00059,border,[],[name=var34],[centre=[-65,80]]).
node(node00063,border,[],[name=var38],[centre=[-65,80]]).
node(node00065,variable,[],[complete=true,name=total_weight_eaten],[caption_offset=[-73,-18],centre=[145,4]]).
node(node00066,function,[],[complete=true,name=fn18,spec=[115,117,109,40,91,69,93,42,91,119,101,105,103,104,116,93,41],units=1,value=sum(['E']*[weight])],[]).
node(node00069,border,[],[name=var43],[centre=[119,-26]]).
node(node00072,border,[],[name=var45],[centre=[199,-18]]).

arc(arc00003,node00009,node00008,influence,[name=i3],[]).
arc(arc00020,node00008,node00026,flow,[complete=true,name=predation],[caption_offset=[-38,-41],curve=[550,500]]).
arc(arc00019,node00023,node00027,influence,[complete=true,name=i17,role=[use(none,in_hierarchy,[['E_Npred']],array(array(1,3),2))]],[curve=[-4,11]]).
arc(arc00021,node00027,arc00020,influence,[name=i20],[]).
arc(arc00023,node00031,node00030,influence,[name=i22],[]).
arc(arc00007,node00008,node00058,influence,[complete=true,name=i7],[curve=[-34,40]]).
arc(arc00025,node00030,node00068,influence,[complete=true,name=i24],[curve=[3,-8]]).
arc(arc00004,node00010,node00007,influence,[name=i3],[]).
arc(arc00008,node00007,node00013,influence,[complete=true,name=i6],[curve=[11,14]]).
arc(arc00059,node00071,node00070,influence,[name=i58],[]).
arc(arc00061,node00073,node00071,influence,[complete=true,name=i60,role=[use(none,in_hierarchy,[total_weight_eaten],array(1,2))]],[curve=[-3,-12]]).
arc(arc00011,node00003,node00049,influence,[complete=true,name=i9],[curve=[7,13]]).
arc(arc00022,node00049,node00002,influence,[complete=true,name=i18],[curve=[-4,14]]).
arc(arc00044,node00002,node00049,influence,[complete=true,name=i43],[curve=[4,21]]).
arc(arc00058,node00002,node00049,influence,[complete=true,name=i57],[curve=[50,-44]]).
arc(arc00062,node00049,node00003,influence,[complete=true,name=i61],[curve=[-8,-15]]).
arc(arc00010,node00015,node00048,influence,[complete=true,name=i8],[curve=[0,-11]]).
arc(arc00018,node00048,node00022,influence,[complete=true,name=i16],[curve=[-8,30]]).
arc(arc00005,node00012,node00011,influence,[name=i4],[]).
arc(arc00009,node00014,node00012,influence,[complete=true,name=i7,role=[use(none,in_hierarchy,['Npred'],array(1,2))]],[curve=[4,18]]).
arc(arc00017,node00011,node00021,influence,[complete=true,name=i15],[curve=[-2,6]]).
arc(arc00006,node00050,node00012,influence,[complete=true,name=i5,role=[use(none,in_hierarchy,'E',1)]],[curve=[-7,2]]).
arc(arc00055,node00050,node00006,influence,[complete=true,name=i54],[curve=[15,15]]).
arc(arc00039,node00051,node00050,influence,[name=i38],[]).
arc(arc00049,node00052,node00051,influence,[complete=true,name=i48,role=[use(none,in_hierarchy,a,1)]],[curve=[-7,2]]).
arc(arc00040,node00053,node00052,influence,[name=i39],[]).
arc(arc00041,node00055,node00054,influence,[name=i40],[]).
arc(arc00045,node00054,node00060,influence,[complete=true,name=i44],[curve=[-3,6]]).
arc(arc00047,node00052,node00061,influence,[complete=true,name=i46],[curve=[0,19]]).
arc(arc00050,node00062,node00051,influence,[complete=true,name=i49,role=[use(none,in_hierarchy,['Nprey'],array(1,3))]],[curve=[3,8]]).
arc(arc00052,node00064,node00051,influence,[complete=true,name=i51,role=[use(none,in_hierarchy,sum_haN,1)]],[curve=[-7,14]]).
arc(arc00053,node00056,node00048,influence,[complete=true,name=i52],[curve=[-2,-3]]).
arc(arc00042,node00057,node00056,influence,[name=i41],[]).
arc(arc00046,node00048,node00057,influence,[complete=true,name=i45,role=[use(none,in_hierarchy,[h],array(1,3))]],[curve=[-6,18]]).
arc(arc00048,node00048,node00057,influence,[complete=true,name=i47,role=[use(none,in_hierarchy,[a],array(1,3))]],[curve=[0,0]]).
arc(arc00043,node00059,node00057,influence,[complete=true,name=i42,role=[use(none,in_hierarchy,['Nprey'],array(1,3))]],[curve=[14,-4]]).
arc(arc00051,node00063,node00048,influence,[complete=true,name=i50],[curve=[0,-7]]).
arc(arc00054,node00066,node00065,influence,[name=i53],[]).
arc(arc00056,node00048,node00066,influence,[complete=true,name=i55,role=[use(none,in_hierarchy,['E'],array(1,3))]],[curve=[-4,-4]]).
arc(arc00057,node00069,node00066,influence,[complete=true,name=i56,role=[use(none,in_hierarchy,[weight],array(int,3))]],[curve=[2,-2]]).
arc(arc00060,node00065,node00072,influence,[complete=true,name=i59],[curve=[-3,-3]]).

