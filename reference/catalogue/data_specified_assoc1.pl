source(program='AME',version= 9.0,edition=standard,date='Tue Feb 05 17:14:45 GMT 2008').

roots([node00002,node00003,node00004,node00013,node00014,node00015,node00016]).

properties([complete-true,file_name-'C:/Inetpub/wwwroot/www/examples/catalogue/models/bob/data_specified_assoc1/data_specified_assoc1.sml',name-data_specified_assoc1]).

node(node00002,submodel,[node00007,node00008,node00009],[complete=true,multiplication_spec=[count=[3]],name='Household'],[bounding_box=[45,57,138,234],caption_offset=[9,-3],internal_extent=[0,0,93,177]]).
links(node00002,[arc00005-arc00007]).
node(node00007,variable,[],[complete=true,name=h],[caption_offset=[0,0],centre=[51,31]]).
node(node00008,function,[],[complete=true,name=fn2,units=int,value=index(1)],[]).
node(node00009,border,[],[name=var2],[centre=[93,33]]).
node(node00003,submodel,[node00005,node00006,node00010,node00018,node00019,node00020],[complete=true,name=submodel2],[bounding_box=[189,61,274,208],caption_offset=[7,167],internal_extent=[0,0,85,147]]).
links(node00003,[arc00007-arc00006,arc00013-arc00012,arc00015-arc00014,arc00017-arc00016]).
references(node00003,[local(arc00001),local(arc00002)]).
node(node00005,condition,[],[complete=true,name=cond1],[caption_offset=[0,0],centre=[35,35]]).
node(node00006,function,[],[complete=true,name=fn1,units=boolean,value=any(var1==[hs] and f==[fs])],[]).
node(node00010,border,[],[name=var3],[centre=[0,32]]).
node(node00018,border,[],[name=var8],[centre=[85,39]]).
node(node00019,border,[],[name=var9],[centre=[15,0]]).
node(node00020,border,[],[name=var10],[centre=[34,0]]).
node(node00004,submodel,[node00011,node00012,node00017],[complete=true,multiplication_spec=[count=[4]],name='Field'],[bounding_box=[335,61,444,222],caption_offset=[45,-2],internal_extent=[0,0,109,161]]).
links(node00004,[arc00011-arc00013]).
node(node00011,variable,[],[complete=true,name=f],[caption_offset=[0,0],centre=[60,49]]).
node(node00012,function,[],[complete=true,name=fn3,units=int,value=index(1)],[]).
node(node00017,border,[],[name=var7],[centre=[0,43]]).
node(node00013,variable,[],[complete=true,name=hs],[caption_offset=[-4,-33],centre=[181,18]]).
node(node00014,function,[],[complete=true,name=fn4,units=array(int,3),value=[1,1,2]],[]).
node(node00015,variable,[],[complete=true,name=fs],[caption_offset=[-6,-31],centre=[250,18]]).
node(node00016,function,[],[complete=true,name=fn5,units=array(int,3),value=[3,4,4]],[]).

arc(arc00004,node00008,node00007,influence,[name=i2],[]).
arc(arc00005,node00007,node00009,influence,[complete=true,name=i3],[curve=[0,-9]]).
arc(arc00001,node00002,node00003,relation,[complete=true,name=owner],[caption_offset=[3,-13],curve=[-2,-13]]).
arc(arc00007,node00002,node00003,influence,[complete=true,name=i5],[curve=[0,-14]]).
arc(arc00003,node00006,node00005,influence,[name=i1],[]).
arc(arc00006,node00010,node00006,influence,[complete=true,name=i4,role=[use(0,in_base,var1,int)]],[curve=[0,-6]]).
arc(arc00012,node00018,node00006,influence,[complete=true,name=i10,role=[use(1,in_base,f,int)]],[curve=[-2,8]]).
arc(arc00014,node00019,node00006,influence,[complete=true,name=i12,role=[use(none,in_hierarchy,[hs],array(int,3))]],[curve=[4,-3]]).
arc(arc00016,node00020,node00006,influence,[complete=true,name=i14,role=[use(none,in_hierarchy,[fs],array(int,3))]],[curve=[5,0]]).
arc(arc00002,node00004,node00003,relation,[complete=true,name=owned],[caption_offset=[2,13],curve=[0,12]]).
arc(arc00013,node00004,node00003,influence,[complete=true,name=i11],[curve=[-2,10]]).
arc(arc00008,node00012,node00011,influence,[name=i6],[]).
arc(arc00011,node00011,node00017,influence,[complete=true,name=i9],[curve=[-2,12]]).
arc(arc00015,node00013,node00003,influence,[complete=true,name=i13],[curve=[9,-6]]).
arc(arc00009,node00014,node00013,influence,[name=i7],[]).
arc(arc00017,node00015,node00003,influence,[complete=true,name=i15],[curve=[8,0]]).
arc(arc00010,node00016,node00015,influence,[name=i8],[]).

