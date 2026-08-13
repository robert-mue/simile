source(program='AME',version= 9.0,edition=standard,date='Wed Feb 06 13:07:51 GMT 2008').

roots([node00454,node00455]).

properties([complete-true,file_name-'/win98/Program Files/Simile/Develop/Library/hexagon.sml',min_val-0,name-hexagon,separate-0,units-1,value- 0.5]).

node(node00454,submodel,[node00002,node00456,node00457,node00458,node00459,node00460,node00461,node00462,node00463,node00464,node00465,node00466,node00467,node00468,node00469,node00470,node00471,node00472,node00473,node00474,node00475],[complete=true,enum_types=[],fill_colour='#7ef18a',multiplication_spec=[count=[9,9]],name=hexagon,separate=0],[bounding_box=[-218,-209,134,75],caption_offset=[0,0],internal_extent=[0,0,352,284]]).
links(node00454,[arc00531-arc00533,arc00534-arc00536,arc00537-arc00539,arc00546-arc00545,arc00556-arc00543]).
references(node00454,[local(arc00528),local(arc00529)]).
node(node00002,submodel,[node00003,node00004,node00005,node00006,node00007,node00008],[complete=true,enum_types=[],multiplication_spec=[count=[6]],name=borders,separate=0],[bounding_box=[14,155,96,249],caption_offset=[0,0],internal_extent=[0,0,82,95]]).
links(node00002,[arc00004-arc00003,arc00006-arc00005]).
references(node00002,[ancestor(0),ancestor(1)]).
node(node00003,variable,[],[complete=true,name=x],[caption_offset=[0,0],centre=[18,24]]).
node(node00004,function,[],[complete=true,name=fn1,spec=[111,102,102,61,115,113,114,116,40,51,47,52,41,44,120,43,49,48,42,101,108,101,109,101,110,116,40,91,48,44,111,102,102,44,111,102,102,44,48,44,45,111,102,102,44,45,111,102,102,93,44,105,110,100,101,120,40,49,41,41],units=1,value=(off=sqrt(3/4),x+10*element([0,off,off,0,-off,-off],index(1)))],[]).
node(node00005,variable,[],[complete=true,name=y],[caption_offset=[0,0],centre=[52,64]]).
node(node00006,function,[],[complete=true,name=fn2,spec=[121,43,49,48,42,101,108,101,109,101,110,116,40,91,49,44,46,53,44,45,46,53,44,45,49,44,45,46,53,44,46,53,93,44,105,110,100,101,120,40,49,41,41],units=1,value=y+10*element([1, 0.5, -0.5,-1, -0.5, 0.5],index(1))],[]).
node(node00007,border,[],[name=var3],[centre=[58,0]]).
node(node00008,border,[],[name=var4],[centre=[82,42]]).
node(node00456,variable,[],[complete=true,name=a],[caption_offset=[0,0],centre=[57,49]]).
node(node00457,variable,[],[complete=true,name=b],[caption_offset=[0,0],centre=[99,48]]).
node(node00458,variable,[],[complete=true,name=c],[caption_offset=[0,0],centre=[140,44]]).
node(node00459,condition,[],[complete=true,name=cond1],[caption_offset=[0,0],centre=[55,102]]).
node(node00460,variable,[],[complete=true,name=x],[caption_offset=[0,0],centre=[254,47]]).
node(node00461,variable,[],[complete=true,name=y],[caption_offset=[0,0],centre=[285,45]]).
node(node00462,function,[],[complete=true,name=fn10,spec=[115,117,109,40,123,118,97,114,49,50,95,48,125,41],units=1,value=sum({var12_0})],[]).
node(node00463,border,[],[name=var17],[centre=[188,0]]).
node(node00464,submodel,[node00476,node00477,node00478,node00479,node00480,node00481,node00482,node00483],[complete=true,file_name='C:/Program Files/AME/Tutorial/step1.ame',name=dynamics],[bounding_box=[118,117,317,243],caption_offset=[0,0],internal_extent=[51,25,344,211]]).
links(node00464,[arc00554-arc00553,arc00555-arc00556]).
references(node00464,[ancestor(0),ancestor(1)]).
node(node00476,cloud,[],[complete=true,name=cd1],[centre=[105,116]]).
node(node00477,function,[],[complete=true,name=fn1,units=1,value=sum_biomass/20],[]).
node(node00478,function,[],[complete=true,units=1,value=10],[]).
node(node00479,border,[],[name=var21],[centre=[202,24]]).
node(node00480,compartment,[],[comment='Initial size of tree',complete=true,name='TREE'],[caption_offset=[0,0],centre=[199,120]]).
node(node00481,cloud,[],[complete=true,name=cd2],[centre=[295,111]]).
node(node00482,function,[],[complete=true,name=fn2,units=1,value= 0.1 +tREE*tREE/2000],[]).
node(node00483,border,[],[name=var20],[centre=[94,24]]).
node(node00465,function,[],[complete=true,name=fn1,units=int,value=index(1)-5],[]).
node(node00466,function,[],[complete=true,name=fn2,units=int,value=index(2)-5],[]).
node(node00467,function,[],[complete=true,name=fn3,spec=[45,97,45,98],units=int,value= -a-b],[]).
node(node00468,function,[],[complete=true,name=fn4,spec=[122,62,45,53,38,38,122,60,53],units=boolean,value=(z> -5&&z<5)],[]).
node(node00469,function,[],[complete=true,name=fn6,units=1,value=50+10*(a-c)* 0.866],[]).
node(node00470,function,[],[complete=true,name=fn7,units=1,value=50+10*b* 1.5],[]).
node(node00471,border,[],[name=var6],[centre=[63,0]]).
node(node00472,border,[],[name=var8],[centre=[99,0]]).
node(node00473,border,[],[name=var10],[centre=[120,0]]).
node(node00474,variable,[],[complete=true,name='Sum_biomass'],[caption_offset=[0,0],centre=[164,65]]).
node(node00475,border,[],[name=var22],[centre=[215,0]]).
node(node00455,submodel,[node00484,node00485,node00486,node00487,node00488,node00489,node00490,node00491,node00492],[complete=true,name=neighbor],[bounding_box=[-203,-343,-25,-244],caption_offset=[0,0],internal_extent=[0,49,178,148]]).
links(node00455,[arc00533-arc00532,arc00536-arc00535,arc00539-arc00538,arc00543-arc00542,arc00544-arc00546]).
references(node00455,[local(arc00528),local(arc00529)]).
node(node00484,function,[],[complete=true,name=fn8,spec=[97,95,48,61,61,97,45,49,44,98,95,48,61,61,98,43,49,44,99,95,48,61,61,99],units=boolean,value=(a_0==a-1,b_0==b+1,c_0==c)],[]).
node(node00485,border,[],[name=var7],[centre=[52,148]]).
node(node00486,border,[],[name=var9],[centre=[73,148]]).
node(node00487,border,[],[name=var11],[centre=[85,148]]).
node(node00488,function,[],[complete=true,name=fn9,units=1,value=biomass],[]).
node(node00489,border,[],[name=var15],[centre=[178,148]]).
node(node00490,condition,[],[comment='Outside is to upper left of middle',complete=true,name=cond2],[caption_offset=[0,0],centre=[58,91]]).
node(node00491,variable,[],[complete=true,name=var12],[caption_offset=[0,0],centre=[129,90]]).
node(node00492,border,[],[name=var16],[centre=[178,148]]).

arc(arc00001,node00004,node00003,influence,[name=i1],[]).
arc(arc00002,node00006,node00005,influence,[name=i2],[]).
arc(arc00003,node00007,node00004,influence,[complete=true,name=i3,role=[use(none,in_hierarchy,x,1)]],[curve=[6,8]]).
arc(arc00005,node00008,node00006,influence,[complete=true,name=i9,role=[use(none,in_hierarchy,y,1)]],[curve=[4,5]]).
arc(arc00004,node00460,node00002,influence,[complete=true,name=i8],[curve=[26,43]]).
arc(arc00006,node00461,node00002,influence,[complete=true,name=i14],[curve=[36,45]]).
arc(arc00545,node00463,node00462,influence,[complete=true,name=i30,references=[arc00528,arc00529],role=[use(0,in_assoc,{var12},list(1)),use(1,in_assoc,{var12_0},list(1))]],[curve=[14,5]]).
arc(arc00548,node00477,arc00547,influence,[name=i1],[]).
arc(arc00547,node00476,node00480,flow,[complete=true,name='GROWTH'],[caption_offset=[-22,-40],curve=[550,500]]).
arc(arc00552,node00478,node00480,influence,[],[]).
arc(arc00555,node00480,node00479,influence,[complete=true,name=i36],[curve=[-34,0]]).
arc(arc00549,node00480,node00481,flow,[complete=true,name=loss],[caption_offset=[-16,3],curve=[550,492]]).
arc(arc00550,node00482,arc00549,influence,[name=i2],[]).
arc(arc00551,node00480,node00482,influence,[complete=true,name=i4,role=[use(none,in_hierarchy,tREE,1)]],[curve=[-1,-6]]).
arc(arc00553,node00483,node00477,influence,[complete=true,name=i34,role=[use(none,in_hierarchy,sum_biomass,1)]],[curve=[35,-23]]).
arc(arc00516,node00465,node00456,influence,[name=i1],[]).
arc(arc00517,node00466,node00457,influence,[name=i2],[]).
arc(arc00007,node00457,node00467,influence,[complete=true,name=i16,role=[use(none,in_hierarchy,b,int)]],[curve=[0,-7]]).
arc(arc00008,node00456,node00467,influence,[complete=true,name=i17,role=[use(none,in_hierarchy,a,int)]],[curve=[-2,-18]]).
arc(arc00518,node00467,node00458,influence,[name=i3],[]).
arc(arc00519,node00468,node00459,influence,[name=i4],[curve=[0,0]]).
arc(arc00522,node00458,node00468,influence,[complete=true,name=i7,role=[use(none,in_hierarchy,z,int)]],[curve=[12,14]]).
arc(arc00523,node00469,node00460,influence,[name=i9],[]).
arc(arc00525,node00456,node00469,influence,[complete=true,name=i11,role=[use(none,in_hierarchy,a,int)]],[curve=[-1,-46]]).
arc(arc00526,node00458,node00469,influence,[complete=true,name=i12,role=[use(none,in_hierarchy,c,int)]],[curve=[0,-26]]).
arc(arc00524,node00470,node00461,influence,[name=i10],[]).
arc(arc00527,node00457,node00470,influence,[complete=true,name=i13,role=[use(none,in_hierarchy,b,int)]],[curve=[-1,-43]]).
arc(arc00531,node00456,node00471,influence,[complete=true,name=i15],[curve=[-11,-2]]).
arc(arc00534,node00457,node00472,influence,[complete=true,name=i18],[curve=[-11,0]]).
arc(arc00537,node00458,node00473,influence,[complete=true,name=i21],[curve=[-10,4]]).
arc(arc00541,node00462,node00474,influence,[name=i25],[]).
arc(arc00554,node00474,node00464,influence,[complete=true,name=i35],[curve=[10,4]]).
arc(arc00556,node00464,node00475,influence,[complete=true,name=i38],[curve=[-30,1]]).
arc(arc00528,node00454,node00455,relation,[complete=true,ident=0,name=middle],[caption_offset=[-3,-8],curve=[-8,4]]).
arc(arc00529,node00454,node00455,relation,[complete=true,ident=1,name=outside],[caption_offset=[1,-1],curve=[16,2]]).
arc(arc00533,node00454,node00455,influence,[complete=true,name=i17],[curve=[-8,0]]).
arc(arc00536,node00454,node00455,influence,[complete=true,name=i20],[curve=[-8,4]]).
arc(arc00539,node00454,node00455,influence,[complete=true,name=i23],[curve=[-8,6]]).
arc(arc00543,node00454,node00455,influence,[complete=true,name=i28],[curve=[-8,6]]).
arc(arc00546,node00455,node00454,influence,[complete=true,name=i31],[curve=[10,2]]).
arc(arc00532,node00485,node00484,influence,[complete=true,name=i16,references=[arc00528,arc00529],role=[use(0,in_base,a,int),use(1,in_base,a_0,int)]],[curve=[-11,-1]]).
arc(arc00535,node00486,node00484,influence,[complete=true,name=i19,references=[arc00528,arc00529],role=[use(0,in_base,b,int),use(1,in_base,b_0,int)]],[curve=[-11,3]]).
arc(arc00538,node00487,node00484,influence,[complete=true,name=i22,references=[arc00528,arc00529],role=[use(0,in_base,c,int),use(1,in_base,c_0,int)]],[curve=[-11,5]]).
arc(arc00542,node00489,node00488,influence,[complete=true,name=i27,references=[arc00528,arc00529],role=[use(0,in_base,biomass,1),use(1,in_base,biomass_0,1)]],[curve=[-14,12]]).
arc(arc00530,node00484,node00490,influence,[name=i14],[curve=[0,0]]).
arc(arc00540,node00488,node00491,influence,[name=i24],[]).
arc(arc00544,node00491,node00492,influence,[complete=true,name=i29],[curve=[13,-12]]).

