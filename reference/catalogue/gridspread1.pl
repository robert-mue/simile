source(program='AME',version= 9.0,edition=standard,date='Wed Feb 06 13:06:07 GMT 2008').

roots([node00062,node00072,node00073,node00076,node00077,node00078,node00079]).

properties([complete-true,file_name-'C:/Inetpub/wwwroot/www/examples/catalogue/models/bob/gridspread1/gridspread1.sml',name-gridspread1]).

node(node00062,submodel,[node00002,node00063,node00064,node00065,node00066,node00067,node00068,node00069,node00070,node00071,node00074,node00075,node00080,node00081,node00082,node00083],[complete=true,fill_colour='#ffc6aa',multiplication_spec=[count=[100]],name=cell,separate=0],[bounding_box=[86,-79,313,89],caption_offset=[19,0],internal_extent=[-1,-1,228,168]]).
links(node00062,[arc00074-arc00075,arc00077-arc00076,arc00080-arc00081,arc00082-arc00083,arc00085-arc00084,arc00087-arc00086]).
node(node00002,function,[],[complete=true,spec=[105,102,32,105,110,100,101,120,40,49,41,61,61,51,53,32,116,104,101,110,32,49,48,48,48,32,101,108,115,101,32,48],units=1,value=(if index(1)==35 then 1000 else 0)],[]).
node(node00063,compartment,[],[complete=true,name=amount],[caption_offset=[0,-47],centre=[127,89]]).
node(node00064,cloud,[],[complete=true,name=cd1],[centre=[39,92]]).
node(node00065,function,[],[complete=true,name=fn1,spec=[115,117,109,40,105,102,32,97,98,115,40,91,114,111,119,115,93,45,114,111,119,41,60,49,46,53,32,97,110,100,32,97,98,115,40,91,99,111,108,115,93,45,99,111,108,41,60,49,46,53,32,116,104,101,110,32,91,105,110,116,101,114,102,108,111,119,115,93,32,101,108,115,101,32,48,41],units=1,value=sum(if abs([rows]-row)< 1.5 and abs([cols]-col)< 1.5 then [interflows] else 0)],[]).
node(node00066,cloud,[],[complete=true,name=cd2],[centre=[208,92]]).
node(node00067,function,[],[complete=true,name=fn2,units=1,value= 0.05 *amount],[]).
node(node00068,variable,[],[complete=true,name=row],[caption_offset=[0,0],centre=[33,31]]).
node(node00069,function,[],[complete=true,name=fn3,units=1,value=floor((index(1)-1)/10)+1],[]).
node(node00070,variable,[],[complete=true,name=col],[caption_offset=[0,0],centre=[81,32]]).
node(node00071,function,[],[complete=true,name=fn4,units=1,value=index(1)-10*(row-1)],[]).
node(node00074,border,[],[name=var4],[centre=[228,60]]).
node(node00075,border,[],[name=var5],[centre=[226,149]]).
node(node00080,border,[],[name=var8],[centre=[0,33]]).
node(node00081,border,[],[name=var9],[centre=[0,59]]).
node(node00082,border,[],[name=var10],[centre=[-1,49]]).
node(node00083,border,[],[name=var11],[centre=[0,79]]).
node(node00072,variable,[],[complete=true,name=interflows],[caption_offset=[4,5],centre=[361,29]]).
node(node00073,function,[],[complete=true,name=fn5,spec=[91,111,117,116,102,108,111,119,93,47,56],units=array(1,100),value=[outflow]/8],[]).
node(node00076,variable,[],[complete=true,name=rows],[caption_offset=[-2,3],centre=[44,-54]]).
node(node00077,function,[],[complete=true,name=fn6,spec=[91,114,111,119,93],units=array(1,100),value=[row]],[]).
node(node00078,variable,[],[complete=true,name=cols],[caption_offset=[0,3],centre=[42,-8]]).
node(node00079,function,[],[complete=true,name=fn7,spec=[91,99,111,108,93],units=array(1,100),value=[col]],[]).

arc(arc00001,node00002,node00063,influence,[],[]).
arc(arc00066,node00064,node00063,flow,[complete=true,name=inflow],[caption_offset=[-42,1],curve=[550,500]]).
arc(arc00067,node00065,arc00066,influence,[name=i1],[]).
arc(arc00068,node00063,node00066,flow,[complete=true,name=outflow],[caption_offset=[-34,1],curve=[550,500]]).
arc(arc00069,node00067,arc00068,influence,[name=i2],[]).
arc(arc00088,node00063,node00067,influence,[complete=true,name=i21,role=[use(none,in_hierarchy,amount,1)]],[curve=[0,-6]]).
arc(arc00090,node00068,node00065,influence,[complete=true,name=i23,role=[use(none,in_hierarchy,row,1)]],[curve=[12,-9]]).
arc(arc00070,node00069,node00068,influence,[name=i3],[]).
arc(arc00089,node00070,node00065,influence,[complete=true,name=i22,role=[use(none,in_hierarchy,col,1)]],[curve=[10,0]]).
arc(arc00071,node00071,node00070,influence,[name=i4],[]).
arc(arc00072,node00068,node00071,influence,[complete=true,name=i5,role=[use(none,in_hierarchy,row,1)]],[curve=[0,-9]]).
arc(arc00074,arc00068,node00074,influence,[complete=true,name=i7],[curve=[10,-7]]).
arc(arc00076,node00075,node00065,influence,[complete=true,name=i9,role=[use(none,in_hierarchy,[interflows],array(1,100))]],[curve=[-14,36]]).
arc(arc00080,node00068,node00080,influence,[complete=true,name=i13],[curve=[0,6]]).
arc(arc00082,node00070,node00081,influence,[complete=true,name=i15],[curve=[6,18]]).
arc(arc00084,node00082,node00065,influence,[complete=true,name=i17,role=[use(none,in_hierarchy,[rows],array(1,100))]],[curve=[8,-15]]).
arc(arc00086,node00083,node00065,influence,[complete=true,name=i19,role=[use(none,in_hierarchy,[cols],array(1,100))]],[curve=[3,-18]]).
arc(arc00077,node00072,node00062,influence,[complete=true,name=i10],[curve=[-4,6]]).
arc(arc00073,node00073,node00072,influence,[name=i6],[]).
arc(arc00075,node00062,node00073,influence,[complete=true,name=i8,role=[use(none,in_hierarchy,[outflow],array(1,100))]],[curve=[6,-8]]).
arc(arc00085,node00076,node00062,influence,[complete=true,name=i18],[curve=[4,-8]]).
arc(arc00078,node00077,node00076,influence,[name=i11],[]).
arc(arc00081,node00062,node00077,influence,[complete=true,name=i14,role=[use(none,in_hierarchy,[row],array(1,100))]],[curve=[4,-8]]).
arc(arc00087,node00078,node00062,influence,[complete=true,name=i20],[curve=[0,-8]]).
arc(arc00079,node00079,node00078,influence,[name=i12],[]).
arc(arc00083,node00062,node00079,influence,[complete=true,name=i16,role=[use(none,in_hierarchy,[col],array(1,100))]],[curve=[2,-4]]).

