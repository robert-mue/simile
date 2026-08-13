source(program='AME',version= 9.0,edition=standard,date='Mon Feb 04 23:27:04 GMT 2008').

roots([node00067,node00070,node00074,node00080]).

properties([complete-true,fill_colour-'#c0c0c0',multiplication_spec-[count=[]],name-'ArcieroAggressiveTumorModel',separate-0]).

node(node00067,submodel,[node00008,node00009,node00025,node00049,node00050,node00051,node00052,node00061,node00063,node00065,node00069],[complete=true,fill_colour='#ff8040',multiplication_spec=[count=[]],name='TGF-beta immuno-suppressant',separate=0],[bounding_box=[174,167,679,363],caption_offset=[247,-10],internal_extent=[-15,-38,492,159]]).
links(node00067,[arc00073-arc00078,arc00077-arc00015,arc00077-arc00022,arc00077-arc00024,arc00077-arc00048]).
node(node00008,compartment,[],[comment='suppressive cytokine - immuno-suppressive and growth stimulatory effects',complete=true,description='TGF-beta',name='S'],[caption_offset=[0,0],centre=[225,43]]).
node(node00009,function,[],[complete=true,name=fn4,spec=[48],units=1,value=0],[]).
node(node00025,border,[],[name=var3],[centre=[183,-38]]).
node(node00049,cloud,[],[complete=true,name=cd3_1],[centre=[438,42]]).
node(node00050,function,[],[complete=true,name=fn3_3,spec=[112,52,42,84,94,50,47,40,116,111,114,95,99,94,50,43,84,94,50,41],units=1,value=p4*'T'^2/(tor_c^2+'T'^2)],[]).
node(node00051,cloud,[],[complete=true,name=cd4],[centre=[36,38]]).
node(node00052,function,[],[complete=true,name=fn4_2,spec=[109,117,51,42,83],units=1,value=mu3*'S'],[]).
node(node00061,variable,[],[complete=true,description='Maximum rate of TGF-beta production',name=p4,param_type=file,spec=[],units=1],[caption_offset=[0,0],centre=[386,85]]).
node(node00063,variable,[],[complete=true,description='The critical tumor cell population at which TGF-beta production starts',name=tor_c,param_type=file,spec=[],units=1],[caption_offset=[0,0],centre=[306,91]]).
node(node00065,variable,[],[complete=true,description='Decay rate constant of TGF-?',name=mu3,param_type=file,spec=[],units=1],[caption_offset=[28,-20],centre=[98,12]]).
node(node00069,border,[],[],[centre=[344,-38]]).
node(node00070,submodel,[node00006,node00007,node00027,node00045,node00046,node00047,node00048,node00053,node00055,node00057,node00059,node00071,node00072,node00073],[complete=true,fill_colour='#ffff80',multiplication_spec=[count=[]],name='IL-2 immuno-stimulant',separate=0],[bounding_box=[-433,164,56,361],caption_offset=[-9,-9],internal_extent=[31,-23,521,175]]).
links(node00070,[arc00024-arc00023,arc00064-arc00080,arc00065-arc00081,arc00079-arc00021]).
node(node00006,compartment,[],[comment='immuno-stimulatory cytokine',complete=true,description='IL-2',name='I'],[caption_offset=[0,0],centre=[268,53]]).
node(node00007,function,[],[complete=true,name=fn3,spec=[48],units=1,value=0],[]).
node(node00027,border,[],[name=var4],[centre=[521,4]]).
node(node00045,cloud,[],[complete=true,name=cd1_1],[centre=[462,49]]).
node(node00046,function,[],[complete=true,name=fn1_3,spec=[112,51,42,69,42,84,47,40,40,103,52,43,84,41,42,40,49,43,97,108,112,104,97,42,83,41,41],units=1,value=p3*'E'*'T'/((g4+'T')*(1+alpha*'S'))],[]).
node(node00047,cloud,[],[complete=true,name=cd2_1],[centre=[98,54]]).
node(node00048,function,[],[complete=true,name=fn2_3,spec=[109,117,50,42,73],units=1,value=mu2*'I'],[]).
node(node00053,variable,[],[complete=true,description='Maximal rate production IL-2',name=p3,param_type=file,spec=[],units=1],[caption_offset=[0,0],centre=[435,88]]).
node(node00055,variable,[],[complete=true,description='Half-saturation constant of production of IL-2',name=g4,param_type=file,spec=[],units=1],[caption_offset=[0,0],centre=[383,110]]).
node(node00057,variable,[],[complete=true,description='Inhibition by TGF-beta constant',name=alpha,param_type=file,spec=[],units=1],[caption_offset=[0,0],centre=[341,99]]).
node(node00059,variable,[],[complete=true,description='Decay rate of IL-2 constant',name=mu2,param_type=file,spec=[],units=1],[caption_offset=[23,-32],centre=[126,16]]).
node(node00071,border,[],[],[centre=[230,-23]]).
node(node00072,border,[],[],[centre=[387,-23]]).
node(node00073,border,[],[],[centre=[468,-23]]).
node(node00074,submodel,[node00002,node00003,node00010,node00011,node00012,node00013,node00014,node00015,node00016,node00018,node00020,node00022,node00024,node00026,node00028,node00075,node00076,node00077,node00078,node00079],[complete=true,fill_colour='#80ff80',multiplication_spec=[count=[]],name='Immune effector cell population',separate=0],[bounding_box=[-511,-292,47,-34],caption_offset=[0,0],internal_extent=[245,26,803,284]]).
links(node00074,[arc00014-arc00083,arc00015-arc00084,arc00021-arc00086,arc00022-arc00085,arc00082-arc00046,arc00082-arc00064]).
node(node00002,compartment,[],[comment='activated immune-system cells (commonly called effector cells) such as cytotoxic T-cells,\nmacrophages, and natural killer cells that are cytotoxic to the tumor cells',complete=true,description='Number of effector cells',name='E'],[caption_offset=[0,0],centre=[538,156]]).
node(node00003,function,[],[complete=true,name=fn1,spec=[48],units=1,value=0],[]).
node(node00010,cloud,[],[complete=true,name=cd1],[centre=[538,52]]).
node(node00011,function,[],[complete=true,name=fn1_0,spec=[99,42,84,47,40,49,43,103,97,109,109,97,42,83,41],units=1,value=c*'T'/(1+gamma*'S')],[]).
node(node00012,cloud,[],[complete=true,name=cd2],[centre=[370,156]]).
node(node00013,function,[],[complete=true,name=fn2_0,spec=[40,40,69,42,73,41,47,40,103,49,43,73,41,41,42,40,112,49,45,40,113,49,42,83,41,47,40,113,50,43,83,41,41],units=1,value='E'*'I'/(g1+'I')*(p1-q1*'S'/(q2+'S'))],[]).
node(node00014,cloud,[],[complete=true,name=cd3],[centre=[710,162]]).
node(node00015,function,[],[complete=true,name=fn3_0,spec=[109,117,49,42,69],units=1,value=mu1*'E'],[]).
node(node00016,variable,[],[complete=true,description='Antigenicity of tumour',name=c,param_type=file,spec=[],units=1],[caption_offset=[0,0],centre=[616,116]]).
node(node00018,variable,[],[complete=true,description='Effector recruitment suppression by TGF-beta constant',name=gamma,param_type=file,spec=[],units=1],[caption_offset=[6,0],centre=[604,62]]).
node(node00020,variable,[],[complete=true,description='Effector cell mortality rate constant',name=mu1,param_type=file,spec=[],units=1],[caption_offset=[17,-2],centre=[728,214]]).
node(node00022,variable,[],[complete=true,description='Half-saturation constants for stimulation of effector cell proliferation by IL-2',name=g1,param_type=file,spec=[],units=1],[caption_offset=[-20,-7],centre=[312,196]]).
node(node00024,variable,[],[complete=true,description='Maximum rate of effector cell proliferation in the absence of TGF-?',name=p1,param_type=file,spec=[],units=1],[caption_offset=[-14,-1],centre=[328,244]]).
node(node00026,variable,[],[complete=true,description='Half-saturation constants for suppression of effector cell proliferation by TGF-beta',name=q2,param_type=file,spec=[],units=1],[caption_offset=[0,0],centre=[378,246]]).
node(node00028,variable,[],[complete=true,description='Maximum rate of anti-proliferative effect of TGF-beta',name=q1,param_type=file,spec=[],units=1],[caption_offset=[11,-3],centre=[420,252]]).
node(node00075,border,[],[],[centre=[786,281]]).
node(node00076,border,[],[],[centre=[803,137]]).
node(node00077,border,[],[],[centre=[803,207]]).
node(node00078,border,[],[],[centre=[544,284]]).
node(node00079,border,[],[],[centre=[510,284]]).
node(node00080,submodel,[node00004,node00005,node00017,node00021,node00030,node00031,node00032,node00033,node00034,node00035,node00036,node00038,node00041,node00043,node00081,node00082,node00083],[complete=true,fill_colour='#ff0000',multiplication_spec=[count=[]],name='Tumor cell population',separate=0],[bounding_box=[175,-291,712,-43],caption_offset=[0,0],internal_extent=[0,0,537,248]]).
links(node00080,[arc00046-arc00088,arc00048-arc00089,arc00087-arc00014,arc00087-arc00065,arc00087-arc00073]).
node(node00004,compartment,[],[complete=true,description='Number of tumor cells',name='T'],[caption_offset=[0,0],centre=[294,111]]).
node(node00005,function,[],[complete=true,name=fn2,spec=[48,49],units=1,value=1],[]).
node(node00017,variable,[],[complete=true,description='Coeffiicient of strength of the immune response to tumor cells',name=a,param_type=file,spec=[],units=1],[caption_offset=[0,0],centre=[363,44]]).
node(node00021,variable,[],[complete=true,description='Half-saturation constants for clearance of tumor cell by effector cells',name=g2,param_type=file,spec=[],units=1],[caption_offset=[12,-3],centre=[434,42]]).
node(node00030,cloud,[],[complete=true,name=cd1_0],[centre=[70,96]]).
node(node00031,function,[],[complete=true,name=fn1_1,spec=[114,42,84,42,40,49,45,84,47,75,41],units=1,value=r*'T'*(1-'T'/'K')],[]).
node(node00032,cloud,[],[complete=true,name=cd2_0],[centre=[484,106]]).
node(node00033,function,[],[complete=true,name=fn2_1,spec=[109,105,110,40,97,42,69,42,84,47,40,103,50,43,84,41,44,84,41],units=1,value=min(a*'E'*'T'/(g2+'T'),'T')],[]).
node(node00034,cloud,[],[complete=true,name=cd3_0],[centre=[65,203]]).
node(node00035,function,[],[complete=true,name=fn3_1,spec=[112,50,42,83,42,84,47,40,103,51,43,83,41],units=1,value=p2*'S'*'T'/(g3+'S')],[]).
node(node00036,variable,[],[complete=true,description='Intrinsic tumour cell population growth rate',name=r,param_type=file,spec=[],units=1],[caption_offset=[0,0],centre=[141,16]]).
node(node00038,variable,[],[complete=true,description='Carrying capacity for tumor cells',name='K',param_type=file,spec=[],units=1],[caption_offset=[9,0],centre=[204,15]]).
node(node00041,variable,[],[complete=true,description='Maximum rate of increased proliferation caused by TGF-beta',name=p2,param_type=file,spec=[],units=1],[caption_offset=[0,0],centre=[134,152]]).
node(node00043,variable,[],[complete=true,description='Half-saturation constant of increased proliferation of tumour cells',name=g3,param_type=file,spec=[],units=1],[caption_offset=[16,-10],centre=[243,198]]).
node(node00081,border,[],[],[centre=[331,248]]).
node(node00082,border,[],[],[centre=[6,236]]).
node(node00083,border,[],[],[centre=[124,248]]).

arc(arc00004,node00009,node00008,influence,[name=i4],[]).
arc(arc00077,node00008,node00025,influence,[complete=true,name=i8],[curve=[12,3]]).
arc(arc00054,node00049,node00008,flow,[complete=true,name='S production'],[caption_offset=[-57,-45],curve=[550,500]]).
arc(arc00055,node00050,arc00054,influence,[name=i3_4],[]).
arc(arc00056,node00008,node00051,flow,[complete=true,description='Decay rate of TGF--beta',name='S decay'],[caption_offset=[-39,5],curve=[550,500]]).
arc(arc00057,node00052,arc00056,influence,[name=i4_3],[]).
arc(arc00072,node00008,node00052,influence,[complete=true,name=i19_0,role=[use(none,in_hierarchy,'S',1)]],[curve=[0,-18]]).
arc(arc00070,node00061,node00050,influence,[complete=true,name=i17_0,role=[use(none,in_hierarchy,p4,1)]],[curve=[8,-10]]).
arc(arc00071,node00063,node00050,influence,[complete=true,name=i18_0,role=[use(none,in_hierarchy,tor_c,1)]],[curve=[8,4]]).
arc(arc00075,node00065,node00052,influence,[complete=true,name=i22_0,role=[use(none,in_hierarchy,mu3,1)]],[curve=[-9,3]]).
arc(arc00078,node00069,node00050,influence,[complete=true,name=i20_0,role=[use(none,in_hierarchy,'T',1)]],[curve=[-8,2]]).
arc(arc00024,node00067,node00070,influence,[complete=true,name=i4],[curve=[-18,-43]]).
arc(arc00003,node00007,node00006,influence,[name=i3],[]).
arc(arc00050,node00045,node00006,flow,[complete=true,description='IL-2 production rate',name='I production'],[caption_offset=[-54,-51],curve=[550,500]]).
arc(arc00023,node00027,node00046,influence,[complete=true,name=i3_0,role=[use(none,in_hierarchy,'S',1)]],[curve=[-2,-21]]).
arc(arc00051,node00046,arc00050,influence,[name=i1_4],[]).
arc(arc00052,node00006,node00047,flow,[complete=true,description='Decay rate of IL-2.',name='I decay'],[caption_offset=[0,0],curve=[550,500]]).
arc(arc00053,node00048,arc00052,influence,[name=i2_4],[]).
arc(arc00066,node00006,node00048,influence,[complete=true,name=i13_0,role=[use(none,in_hierarchy,'I',1)]],[curve=[0,16]]).
arc(arc00061,node00053,node00046,influence,[complete=true,name=i8_1,role=[use(none,in_hierarchy,p3,1)]],[curve=[-8,13]]).
arc(arc00062,node00055,node00046,influence,[complete=true,name=i9_1,role=[use(none,in_hierarchy,g4,1)]],[curve=[-11,2]]).
arc(arc00063,node00057,node00046,influence,[complete=true,name=i10_1,role=[use(none,in_hierarchy,alpha,1)]],[curve=[-8,-4]]).
arc(arc00076,node00059,node00048,influence,[complete=true,name=i23_0,role=[use(none,in_hierarchy,mu2,1)]],[curve=[9,-10]]).
arc(arc00079,node00006,node00071,influence,[complete=true,name=i14],[curve=[15,16]]).
arc(arc00080,node00072,node00046,influence,[complete=true,name=i11,role=[use(none,in_hierarchy,'E',1)]],[curve=[-17,4]]).
arc(arc00081,node00073,node00046,influence,[complete=true,name=i12_0,role=[use(none,in_hierarchy,'T',1)]],[curve=[-14,-23]]).
arc(arc00015,node00067,node00074,influence,[complete=true,name=i8],[curve=[-43,50]]).
arc(arc00021,node00070,node00074,influence,[complete=true,name=i14],[curve=[-2,19]]).
arc(arc00022,node00067,node00074,influence,[complete=true,name=i15],[curve=[-26,26]]).
arc(arc00064,node00074,node00070,influence,[complete=true,name=i11],[curve=[2,19]]).
arc(arc00001,node00003,node00002,influence,[name=i1],[]).
arc(arc00005,node00010,node00002,flow,[comment='Effector cells are assumed to be recruited to the tumor site as\na direct result of the presence of tumor cells.  The production of TGF-beta has\nbeen shown to reduce antigen expression, thereby limiting the level of recruitment.',complete=true,description='Immune effector cell recruitment',name='E Recruitment'],[caption_offset=[-137,-36],curve=[550,500]]).
arc(arc00006,node00011,arc00005,influence,[name=i1_0],[]).
arc(arc00007,node00012,node00002,flow,[complete=true,name='E Proliferation'],[caption_offset=[-88,-46],curve=[550,500]]).
arc(arc00008,node00013,arc00007,influence,[name=i2_0],[]).
arc(arc00020,node00002,node00013,influence,[complete=true,name=i13,role=[use(none,in_hierarchy,'E',1)]],[curve=[-1,16]]).
arc(arc00009,node00002,node00014,flow,[complete=true,description='Immune effector cell mortailty rate',name='E Mortality'],[caption_offset=[-17,-47],curve=[550,632]]).
arc(arc00010,node00015,arc00009,influence,[name=i3_0],[]).
arc(arc00090,node00002,node00015,influence,[complete=true,name=i1_1,role=[use(none,in_hierarchy,'E',1)]],[curve=[1,-20]]).
arc(arc00016,node00016,node00011,influence,[complete=true,name=i9,role=[use(none,in_hierarchy,c,1)]],[curve=[6,0]]).
arc(arc00017,node00018,node00011,influence,[complete=true,name=i10,role=[use(none,in_hierarchy,gamma,1)]],[curve=[-3,-17]]).
arc(arc00019,node00020,node00015,influence,[complete=true,name=i12,role=[use(none,in_hierarchy,mu1,1)]],[curve=[-11,17]]).
arc(arc00027,node00022,node00013,influence,[complete=true,name=i20,role=[use(none,in_hierarchy,g1,1)]],[curve=[-24,6]]).
arc(arc00029,node00024,node00013,influence,[complete=true,name=i22,role=[use(none,in_hierarchy,p1,1)]],[curve=[-20,-11]]).
arc(arc00030,node00026,node00013,influence,[complete=true,name=i23,role=[use(none,in_hierarchy,q2,1)]],[curve=[-15,-4]]).
arc(arc00028,node00028,node00013,influence,[complete=true,name=i21,role=[use(none,in_hierarchy,q1,1)]],[curve=[0,-19]]).
arc(arc00082,node00002,node00075,influence,[complete=true,name=i2_3],[curve=[-42,-12]]).
arc(arc00083,node00076,node00011,influence,[complete=true,name=i7,role=[use(none,in_hierarchy,'T',1)]],[curve=[32,-46]]).
arc(arc00084,node00077,node00011,influence,[complete=true,name=i8,role=[use(none,in_hierarchy,'S',1)]],[curve=[118,-62]]).
arc(arc00085,node00078,node00013,influence,[complete=true,name=i15,role=[use(none,in_hierarchy,'S',1)]],[curve=[-28,12]]).
arc(arc00086,node00079,node00013,influence,[complete=true,name=i14,role=[use(none,in_hierarchy,'I',1)]],[curve=[-29,2]]).
arc(arc00014,node00080,node00074,influence,[complete=true,name=i7],[curve=[-106,198]]).
arc(arc00046,node00074,node00080,influence,[complete=true,name=i2_3],[curve=[20,-16]]).
arc(arc00048,node00067,node00080,influence,[complete=true,name=i4_2],[curve=[-51,16]]).
arc(arc00065,node00080,node00070,influence,[complete=true,name=i12_0],[curve=[68,24]]).
arc(arc00073,node00080,node00067,influence,[complete=true,name=i20_0],[curve=[44,15]]).
arc(arc00002,node00005,node00004,influence,[name=i2],[]).
arc(arc00013,node00030,node00004,flow,[comment='(other growth terms were studied\nin [13] and no significant difference in the dynamics were noted).',complete=true,description='logistic growth dynamics  in the absence of effector cells and TGF-beta',name='T Growth'],[caption_offset=[-73,-1],curve=[550,500]]).
arc(arc00031,node00031,arc00013,influence,[name=i1_1],[]).
arc(arc00045,node00004,node00031,influence,[complete=true,name=i1_3,role=[use(none,in_hierarchy,'T',1)]],[curve=[-3,11]]).
arc(arc00032,node00004,node00032,flow,[complete=true,description='Reduction rate of the tumor population due to immune clearance.',name='T Clearance'],[caption_offset=[-38,2],curve=[550,500]]).
arc(arc00018,node00017,node00033,influence,[complete=true,name=i3_2,role=[use(none,in_hierarchy,a,1)]],[curve=[12,-6]]).
arc(arc00033,node00033,arc00032,influence,[name=i2_1],[]).
arc(arc00038,node00021,node00033,influence,[complete=true,name=i4_0,role=[use(none,in_hierarchy,g2,1)]],[curve=[14,8]]).
arc(arc00047,node00004,node00033,influence,[complete=true,name=i3_3,role=[use(none,in_hierarchy,'T',1)]],[curve=[-2,-38]]).
arc(arc00034,node00034,node00004,flow,[complete=true,name='T proliferation'],[caption_offset=[0,0],curve=[597,524]]).
arc(arc00035,node00035,arc00034,influence,[name=i3_1],[]).
arc(arc00049,node00004,node00035,influence,[complete=true,name=i5_1,role=[use(none,in_hierarchy,'T',1)]],[curve=[7,16]]).
arc(arc00039,node00036,node00031,influence,[complete=true,name=i5,role=[use(none,in_hierarchy,r,1)]],[curve=[15,-8]]).
arc(arc00040,node00038,node00031,influence,[complete=true,name=i6,role=[use(none,in_hierarchy,'K',1)]],[curve=[15,5]]).
arc(arc00043,node00041,node00035,influence,[complete=true,name=i9_0,role=[use(none,in_hierarchy,p2,1)]],[curve=[2,-7]]).
arc(arc00044,node00043,node00035,influence,[complete=true,name=i10_0,role=[use(none,in_hierarchy,g3,1)]],[curve=[-8,9]]).
arc(arc00087,node00004,node00081,influence,[complete=true,name=i20_0],[curve=[28,17]]).
arc(arc00088,node00082,node00033,influence,[complete=true,name=i2_3,role=[use(none,in_hierarchy,'E',1)]],[curve=[210,69]]).
arc(arc00089,node00083,node00035,influence,[complete=true,name=i4_2,role=[use(none,in_hierarchy,'S',1)]],[curve=[-18,-6]]).

