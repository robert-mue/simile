source(program='AME',version= 9.0,edition=standard,date='Tue Feb 05 12:16:44 GMT 2008').

roots([node00495,node00496,node00497,node00498,node00499,node00500,node00501,node00502,node00503,node00504,node00505,node00506,node00507,node00508,node00509,node00510,node00511,node00512,node00513,node00514,node00515,node00516,node00517,node00518,node00519]).

properties([comment-'Set up for ''medium'' soil',complete-true,file_name-'C:/Inetpub/wwwroot/www/examples/catalogue/models/bob/biomewater2/biomewater2.sml',fill_colour-'#3cffff',multiplication_spec-[count=[]],name-biomewater2]).

node(node00495,compartment,[],[comment=mm,complete=true,name='Water'],[caption_offset=[48,-26],centre=[-98,6]]).
node(node00496,function,[],[complete=true,name=fn1,units=1,value=100],[]).
node(node00497,cloud,[],[complete=true,name=cd1],[centre=[-79,-83]]).
node(node00498,function,[],[complete=true,name=fn2,units=1,value=40],[]).
node(node00499,cloud,[],[complete=true,name=cd2],[centre=[-206,-5]]).
node(node00500,function,[],[complete=true,name=fn3,units=1,value=transp+transp2],[]).
node(node00501,cloud,[],[complete=true,name=cd3],[centre=[-172,-79]]).
node(node00502,function,[],[complete=true,name=fn4,units=1,value=20*bare],[]).
node(node00503,variable,[],[complete=true,name='W1'],[caption_offset=[0,0],centre=[-213,48]]).
node(node00504,function,[],[complete=true,name=fn5,units=1,value=water*thetamax1*d1/(d1+d2)],[]).
node(node00505,variable,[],[complete=true,name='W2'],[caption_offset=[0,0],centre=[-204,108]]).
node(node00506,function,[],[complete=true,name=fn6,units=1,value=water*thetamax2*d2/(d1+d2)],[]).
node(node00507,variable,[],[complete=true,max_val=1,min_val=0,name=bare,units=1,value= 0.1],[caption_offset=[0,0],centre=[-246,-61]]).
node(node00508,variable,[],[complete=true,max_val=500,min_val=0,name=total_transp1,units=1,value=15],[caption_offset=[-18,8],centre=[-246,-22]]).
node(node00509,variable,[],[comment='mm: depth of upper layer',complete=true,name=d1],[caption_offset=[0,0],centre=[-155,53]]).
node(node00510,function,[],[complete=true,name=fn10,units=1,value=500],[]).
node(node00511,variable,[],[comment='mm: depth of lower layer',complete=true,name=d2],[caption_offset=[0,0],centre=[-144,90]]).
node(node00512,function,[],[complete=true,name=fn11,units=1,value=1500],[]).
node(node00513,variable,[],[complete=true,name=thetamax2],[caption_offset=[0,0],centre=[-86,89]]).
node(node00514,function,[],[complete=true,name=fn12,units=1,value=200],[]).
node(node00515,variable,[],[complete=true,name=thetamax1],[caption_offset=[0,0],centre=[-85,53]]).
node(node00516,function,[],[complete=true,name=fn13,units=1,value=300],[]).
node(node00517,variable,[],[complete=true,max_val=500,min_val=0,name=total_transp2,units=1,value=20],[caption_offset=[0,0],centre=[-246,58]]).
node(node00518,border,[],[name=var3],[centre=[-3039,-377]]).
node(node00519,border,[],[name=var4],[centre=[-3039,-260]]).

arc(arc00528,node00496,node00495,influence,[name=i1],[curve=[0,0]]).
arc(arc00529,node00497,node00495,flow,[comment='mm/month',complete=true,name=rain],[caption_offset=[9,-61],curve=[550,508]]).
arc(arc00530,node00498,arc00529,influence,[name=i2],[curve=[0,0]]).
arc(arc00531,node00495,node00499,flow,[complete=true,name=transpiration],[caption_offset=[-51,2],curve=[550,500]]).
arc(arc00532,node00500,arc00531,influence,[name=i3],[curve=[0,0]]).
arc(arc00533,node00495,node00501,flow,[complete=true,name=evaporation],[caption_offset=[-77,-79],curve=[593,500]]).
arc(arc00534,node00502,arc00533,influence,[name=i4],[curve=[0,0]]).
arc(arc00535,node00504,node00503,influence,[name=i5],[curve=[0,0]]).
arc(arc00537,node00495,node00504,influence,[complete=true,name=i10,role=[use(none,in_hierarchy,water,1)]],[curve=[8,22]]).
arc(arc00536,node00506,node00505,influence,[name=i6],[curve=[0,0]]).
arc(arc00538,node00495,node00506,influence,[complete=true,name=i11,role=[use(none,in_hierarchy,water,1)]],[curve=[20,21]]).
arc(arc00540,node00507,node00502,influence,[complete=true,name=i14,role=[use(none,in_hierarchy,bare,1)]],[curve=[4,-24]]).
arc(arc00539,node00508,node00500,influence,[complete=true,name=i12,role=[use(none,in_hierarchy,transp,1)]],[curve=[6,-18]]).
arc(arc00545,node00509,node00504,influence,[complete=true,name=i19,role=[use(none,in_hierarchy,d1,1)]],[curve=[0,11]]).
arc(arc00550,node00509,node00506,influence,[complete=true,name=i24,role=[use(none,in_hierarchy,d1,1)]],[curve=[11,10]]).
arc(arc00541,node00510,node00509,influence,[name=i15],[curve=[0,0]]).
arc(arc00547,node00511,node00506,influence,[complete=true,name=i21,role=[use(none,in_hierarchy,d2,1)]],[curve=[4,12]]).
arc(arc00549,node00511,node00504,influence,[complete=true,name=i23,role=[use(none,in_hierarchy,d2,1)]],[curve=[-8,14]]).
arc(arc00542,node00512,node00511,influence,[name=i16],[curve=[0,0]]).
arc(arc00548,node00513,node00506,influence,[complete=true,name=i22,role=[use(none,in_hierarchy,thetamax2,1)]],[curve=[4,26]]).
arc(arc00543,node00514,node00513,influence,[name=i17],[curve=[0,0]]).
arc(arc00546,node00515,node00504,influence,[complete=true,name=i20,role=[use(none,in_hierarchy,thetamax1,1)]],[curve=[0,28]]).
arc(arc00544,node00516,node00515,influence,[name=i18],[curve=[0,0]]).
arc(arc00551,node00517,node00500,influence,[complete=true,name=i40,role=[use(none,in_hierarchy,transp2,1)]],[curve=[-10,-20]]).
arc(arc00552,node00503,node00518,influence,[complete=true,name=i1_0],[curve=[0,9]]).
arc(arc00553,node00505,node00519,influence,[complete=true,name=i2_0],[curve=[4,11]]).

