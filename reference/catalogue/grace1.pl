source(program='AME',version= 9.0,edition=standard,date='Wed Feb 06 13:01:57 GMT 2008').

roots([node00003,node00039,node00040,node00046,node00048]).

properties([complete-true,file_name-'C:/Inetpub/wwwroot/www/examples/catalogue/models/bob/grace1/grace1.sml',name-grace1]).

node(node00003,function,[],[complete=true,name=fn20,units=array(array(1,5),5),value=[[ 0.02, 0.01, 0.03, 0.01, 0.01],[ 0.01, 0.01, 0.01, 0.01, 0.04],[ 0.01, 0.02, 0.01, 0.04, 0.01],[ 0.01, 0.01, 0.01, 0.05, 0.01],[ 0.01, 0.04, 0.01, 0.01, 0.02]]],[]).
node(node00039,variable,[],[complete=true,name=biomasses],[caption_offset=[-1,5],centre=[14,189]]).
node(node00040,function,[],[complete=true,name=fn17,spec=[91,98,105,111,109,97,115,115,93],units=array(1,5),value=[biomass]],[]).
node(node00046,variable,[],[complete=true,name=c],[caption_offset=[-8,0],centre=[14,97]]).
node(node00048,submodel,[node00002,node00006,node00034,node00035,node00036,node00042,node00043,node00044,node00045,node00049,node00050],[complete=true,fill_colour='#80ff80',multiplication_spec=[count=[5]],name='SPECIES',separate=0],[bounding_box=[53,-13,351,244],caption_offset=[0,0],internal_extent=[-1,-1,299,257]]).
links(node00048,[arc00031-arc00038,arc00035-arc00039,arc00040-arc00041]).
node(node00002,function,[],[complete=true,units=1,value=element([1,2,4,8,16],index(1))],[]).
node(node00006,border,[],[],[centre=[0,171]]).
node(node00034,compartment,[],[complete=true,name=biomass],[caption_offset=[1,-46],centre=[164,101]]).
node(node00035,cloud,[],[complete=true,name=cd1],[centre=[55,100]]).
node(node00036,function,[],[complete=true,name=fn15,units=1,value=r*biomass*(1-inhib)],[]).
node(node00042,variable,[],[complete=true,name=inhib],[caption_offset=[0,0],centre=[47,137]]).
node(node00043,function,[],[complete=true,name=fn18,spec=[115,117,109,40,101,108,101,109,101,110,116,40,91,91,99,93,93,44,105,110,100,101,120,40,49,41,41,42,91,98,105,111,109,97,115,115,101,115,93,41],units=1,value=sum(element([[c]],index(1))*[biomasses])],[]).
node(node00044,variable,[],[complete=true,name=r],[caption_offset=[0,0],centre=[83,37]]).
node(node00045,function,[],[complete=true,name=fn19,units=1,value=element([ 0.6, 0.5, 0.4, 0.3, 0.2],index(1))],[]).
node(node00049,border,[],[],[centre=[0,122]]).
node(node00050,border,[],[name=var22],[centre=[0,181]]).

arc(arc00019,node00040,node00039,influence,[name=i17],[]).
arc(arc00030,node00003,node00046,influence,[name=i28],[]).
arc(arc00031,node00046,node00048,influence,[complete=true,name=i29,role=[use(none,in_hierarchy,[c],1)]],[curve=[2,-8]]).
arc(arc00035,node00039,node00048,influence,[complete=true,name=i26,role=[use(none,in_hierarchy,[biomasses],1)]],[curve=[-7,-8]]).
arc(arc00041,node00048,node00040,influence,[complete=true,name=i34,role=[use(none,in_hierarchy,[biomass],array(1,5))]],[curve=[4,8]]).
arc(arc00001,node00002,node00034,influence,[],[]).
arc(arc00015,node00035,node00034,flow,[complete=true,name=growth],[caption_offset=[-39,3],curve=[550,500]]).
arc(arc00016,node00036,arc00015,influence,[name=i15],[]).
arc(arc00027,node00034,node00036,influence,[complete=true,name=i25,role=[use(none,in_hierarchy,biomass,1)]],[curve=[-1,8]]).
arc(arc00026,node00042,node00036,influence,[complete=true,name=i24,role=[use(none,in_hierarchy,inhib,1)]],[curve=[-8,-12]]).
arc(arc00022,node00043,node00042,influence,[name=i20],[]).
arc(arc00039,node00006,node00043,influence,[complete=true,name=i26,role=[use(none,in_hierarchy,[biomasses],array(1,5))]],[curve=[-8,-11]]).
arc(arc00024,node00044,node00036,influence,[complete=true,name=i22,role=[use(none,in_hierarchy,r,1)]],[curve=[11,-4]]).
arc(arc00023,node00045,node00044,influence,[name=i21],[]).
arc(arc00038,node00049,node00043,influence,[complete=true,name=i29,role=[use(none,in_hierarchy,[[c]],array(array(1,5),5))]],[curve=[3,-10]]).
arc(arc00040,node00034,node00050,influence,[complete=true,name=i33],[curve=[18,36]]).

