source(program='Simile v7.4',version= 11.4,edition=free,date='Thu Aug 13 10:43:00 GMT 2026').

roots([node00234,node00235,node00236,node00237]).

properties([complete-true,file_name-'C:/Inetpub/wwwroot/www/examples/catalogue/models/bob/feeding1/feeding1.sml',fill_colour-'#ffffffffffff',name-'Desktop4']).

node(node00234,submodel,[node00238,node00239,node00240,node00241,node00242,node00243,node00244,node00245,node00246],[complete=true,fill_colour='#ff8040',multiplication_spec=[count=[4]],name=animal],[bounding_box=[ -10.0, 118.0, 99.0, 260.0],caption_offset=[ 21.0, -7.0],internal_extent=[ 0.0, 0.0, 109.0, 142.0]]).
links(node00234,[arc00228-arc00232,arc00230-arc00224,arc00231-arc00226]).
references(node00234,[local(arc00229)]).
node(node00235,submodel,[node00247,node00248,node00249,node00250,node00251,node00252,node00253,node00254,node00255,node00256,node00257,node00258,node00259,node00260,node00261,node00262,node00263,node00264,node00265,node00266,node00267,node00268,node00269,node00270,node00271,node00272,node00273,node00274],[complete=true,fill_colour='#ff80ff',multiplication_spec=[count=[]],name=eats],[bounding_box=[ 146.0, 52.0, 307.0, 224.0],caption_offset=[ -28.0, 20.0],internal_extent=[ 1.0, 0.0, 166.0, 176.0]]).
links(node00235,[arc00022-arc00231,arc00022-arc00254,arc00049-arc00250,arc00049-arc00251,arc00232-arc00241,arc00238-arc00230,arc00242-arc00255,arc00253-arc00237,arc00262-arc00043,arc00262-arc00234,arc00262-arc00244,arc00263-arc00235,arc00263-arc00245,arc00263-arc00248,arc00264-arc00247]).
references(node00235,[local(arc00229),local(arc00252)]).
node(node00236,submodel,[node00275,node00276,node00277,node00278,node00279,node00280,node00281,node00282,node00283],[complete=true,fill_colour='#80ff80',multiplication_spec=[count=[3]],name=plant],[bounding_box=[ 345.0, 98.0, 480.0, 238.0],caption_offset=[ 19.0, -6.0],internal_extent=[ 0.0, 0.0, 135.0, 140.0]]).
links(node00236,[arc00254-arc00259,arc00255-arc00261,arc00257-arc00253]).
references(node00236,[local(arc00252)]).
node(node00237,submodel,[node00284,node00285,node00286,node00287,node00288,node00289,node00290,node00291,node00292,node00293,node00294,node00295],[complete=true,fill_colour='#c0c0c0',multiplication_spec=[count=[6]],name='feeding relationship'],[bounding_box=[ 81.0, -44.0, 347.0, 23.0],caption_offset=[ -5.0, -5.0],internal_extent=[ 0.0, 4.0, 266.0, 71.0]]).
links(node00237,[arc00268-arc00262,arc00269-arc00263,arc00270-arc00264,arc00271-arc00049]).
node(node00284,variable,[],[complete=true,name='eating\nanimals'],[caption_offset=[ -8.0, -46.0],centre=[ 97.0, 45.0]]).
node(node00285,function,[],[complete=true,name=fn21,units=1,value=element([1,1,2,2,3,4],index(1))],[]).
node(node00286,variable,[],[complete=true,name='eaten\nplants'],[caption_offset=[ 11.0, -49.0],centre=[ 136.0, 46.0]]).
node(node00287,function,[],[complete=true,name=fn22,units=1,value=element([1,2,2,3,1,2],index(1))],[]).
node(node00288,variable,[],[complete=true,name=indexes],[caption_offset=[ -13.0, -33.0],centre=[ 39.0, 33.0]]).
node(node00289,function,[],[complete=true,name=fn1,units=1,value=index(1)],[]).
node(node00290,variable,[],[complete=true,name=palatabilities],[caption_offset=[ 18.0, -34.0],centre=[ 203.0, 38.0]]).
node(node00291,function,[],[complete=true,name=fn4,units=1,value=element([11,12,13,14,15,16],index(1))],[]).
node(node00292,border,[],[],[along=355]).
node(node00293,border,[],[],[along=241]).
node(node00294,border,[],[],[along=429]).
node(node00295,border,[],[],[along=68]).
arc(arc00265,node00285,node00284,influence,[attached=[],name=i49],[curve=[0,0]]).
arc(arc00266,node00287,node00286,influence,[attached=[],name=i50],[curve=[0,0]]).
arc(arc00267,node00289,node00288,influence,[attached=[],name=i3],[curve=[0,0]]).
arc(arc00047,node00291,node00290,influence,[attached=[],name=i12],[curve=[0,0]]).
arc(arc00268,node00284,node00292,influence,[attached=[],complete=true,name=i52],[curve=[2,-1]]).
arc(arc00269,node00286,node00293,influence,[attached=[],complete=true,name=i54],[curve=[1,1]]).
arc(arc00270,node00288,node00294,influence,[attached=[],complete=true,name=i6_0],[curve=[6,-4]]).
arc(arc00271,node00290,node00295,influence,[attached=[],complete=true,name=i14_0],[curve=[4,0]]).
node(node00275,variable,[],[complete=true,name=biomass],[caption_offset=[ 0.0, 0.0],centre=[ 72.0, 72.0]]).
node(node00276,function,[],[complete=true,name=fn29,units=1,value=element([2,4,6],index(1))],[]).
node(node00277,border,[],[name=var50],[along=472]).
node(node00278,variable,[],[complete=true,name=eaten],[caption_offset=[ 0.0, 0.0],centre=[ 59.0, 119.0]]).
node(node00279,function,[],[complete=true,name=fn3,units=1,value=sum({eaten})],[]).
node(node00280,border,[],[name=var6],[along=390]).
node(node00281,variable,[],[complete=true,name='pop size'],[caption_offset=[ 0.0, 0.0],centre=[ 60.0, 22.0]]).
node(node00282,function,[],[complete=true,name=fn6,units=1,value=sum({pop_size})],[]).
node(node00283,border,[],[name=var13],[along=549]).
arc(arc00256,node00276,node00275,influence,[attached=[],name=i66],[]).
arc(arc00257,node00275,node00277,influence,[attached=[],complete=true,name=i68],[curve=[0,8]]).
arc(arc00258,node00279,node00278,influence,[attached=[],name=i3],[]).
arc(arc00259,node00280,node00279,influence,[attached=[],complete=true,name=i7,role=[use(0,in_assoc,{eaten},list(1)),use(none,in_hierarchy,{eaten_0},list(1))]],[curve=[0,-12]]).
arc(arc00260,node00282,node00281,influence,[attached=[],name=i11],[]).
arc(arc00261,node00283,node00282,influence,[attached=[],complete=true,name=i16,role=[use(0,in_assoc,{pop_size},list(1)),use(none,in_hierarchy,{pop_size_0},list(1))]],[curve=[0,-8]]).
node(node00247,condition,[],[complete=true,name=condition],[caption_offset=[ 0.0, 0.0],centre=[ 33.0, 99.0]]).
node(node00248,function,[],[complete=true,name=fn1,units=boolean,value=any(index(1)==[eating_animals]&&index(2)==[eaten_plants])],[]).
node(node00249,border,[],[name=var34],[along=670]).
node(node00250,border,[],[name=var35],[along=695]).
node(node00251,variable,[],[complete=true,name=biomass],[caption_offset=[ 0.0, 0.0],centre=[ 82.0, 122.0]]).
node(node00252,function,[],[complete=true,name=fn30,units=1,value=biomass],[]).
node(node00253,border,[],[name=var51],[along=82]).
node(node00254,border,[],[name=var53],[along=525]).
node(node00255,variable,[],[complete=true,name=eaten],[caption_offset=[ 0.0, 0.0],centre=[ 30.0, 148.0]]).
node(node00256,function,[],[complete=true,name=fn1_0,units=1,value=floor(rand_const(0,10))],[]).
node(node00257,border,[],[name=var4],[along=235]).
node(node00258,variable,[],[complete=true,name='pop size'],[caption_offset=[ 0.0, 0.0],centre=[ 123.0, 142.0]]).
node(node00259,function,[],[complete=true,name=fn5,units=1,value=pop_size],[]).
node(node00260,border,[],[name=var11],[along=576]).
node(node00261,border,[],[name=var12],[along=922]).
node(node00262,variable,[],[complete=true,name=palatability1],[caption_offset=[ 2.0, -1.0],centre=[ 117.0, 18.0]]).
node(node00263,function,[],[complete=true,name=fn1_1,units=1,value=greatest(if index(1)==[eating_animals]&&index(2)==[eaten_plants] then [palatabilities] else 0)],[]).
node(node00264,border,[],[name=var2],[along=670]).
node(node00265,border,[],[name=var3],[along=695]).
node(node00266,variable,[],[complete=true,name=index],[caption_offset=[ 0.0, 0.0],centre=[ 26.0, 43.0]]).
node(node00267,function,[],[complete=true,name=fn2,units=1,value=greatest(if index(1)==[eating_animals]&&index(2)==[eaten_plants] then [indexes] else 0)],[]).
node(node00268,border,[],[name=var4_0],[along=630]).
node(node00269,border,[],[name=var5],[along=670]).
node(node00270,border,[],[name=var6],[along=695]).
node(node00271,variable,[],[complete=true,name=palatability2],[caption_offset=[ 0.0, 0.0],centre=[ 108.0, 58.0]]).
node(node00272,function,[],[complete=true,name=fn3,units=1,value=element([palatabilities],index)],[]).
node(node00273,border,[],[name=var10],[along=832]).
node(node00274,border,[],[name=var11_0],[along=832]).
arc(arc00233,node00248,node00247,influence,[attached=[],name=i1],[curve=[0,0]]).
arc(arc00234,node00249,node00248,influence,[attached=[],complete=true,name=i51,role=[use(none,in_hierarchy,[eating_animals],array(1,6))]],[curve=[17,1]]).
arc(arc00235,node00250,node00248,influence,[attached=[],complete=true,name=i53,role=[use(none,in_hierarchy,[eaten_plants],array(1,6))]],[curve=[17,4]]).
arc(arc00236,node00252,node00251,influence,[attached=[],name=i67],[curve=[0,0]]).
arc(arc00237,node00253,node00252,influence,[attached=[],complete=true,name=i69,role=[use(1,in_base,biomass,1),use(none,in_hierarchy,[biomass_0],array(1,3))]],[curve=[10,14]]).
arc(arc00238,node00251,node00254,influence,[attached=[],complete=true,name=i72],[curve=[-12,15]]).
arc(arc00239,node00256,node00255,influence,[attached=[],name=i1_0],[curve=[0,0]]).
arc(arc00022,node00255,node00257,influence,[attached=[],complete=true,name=i4],[curve=[-8,-14]]).
arc(arc00240,node00259,node00258,influence,[attached=[],name=i10],[curve=[0,0]]).
arc(arc00241,node00260,node00259,influence,[attached=[],complete=true,name=i13,role=[use(0,in_base,pop_size,1),use(none,in_hierarchy,[pop_size_0],array(1,4))]],[curve=[20,-26]]).
arc(arc00242,node00258,node00261,influence,[attached=[],complete=true,name=i15],[curve=[-22,-10]]).
arc(arc00243,node00263,node00262,influence,[attached=[],name=i1_1],[curve=[0,0]]).
arc(arc00244,node00264,node00263,influence,[attached=[],complete=true,name=i2,role=[use(none,in_hierarchy,[eating_animals],array(1,6))]],[curve=[6,-18]]).
arc(arc00245,node00265,node00263,influence,[attached=[],complete=true,name=i3,role=[use(none,in_hierarchy,[eaten_plants],array(1,6))]],[curve=[6,-14]]).
arc(arc00250,node00273,node00263,influence,[attached=[],complete=true,name=i13_0,role=[use(none,in_hierarchy,[palatabilities],array(1,6))]],[curve=[6,1]]).
arc(arc00246,node00267,node00266,influence,[attached=[],name=i4_0],[curve=[0,0]]).
arc(arc00043,node00269,node00267,influence,[attached=[],complete=true,name=i7,role=[use(none,in_hierarchy,[eating_animals],array(1,6))]],[curve=[6,2]]).
arc(arc00247,node00268,node00267,influence,[attached=[],complete=true,name=i5,role=[use(none,in_hierarchy,[indexes],array(1,6))]],[curve=[6,-4]]).
arc(arc00248,node00270,node00267,influence,[attached=[],complete=true,name=i8,role=[use(none,in_hierarchy,[eaten_plants],array(1,6))]],[curve=[6,4]]).
arc(arc00249,node00272,node00271,influence,[attached=[],name=i9],[curve=[0,0]]).
arc(arc00046,node00266,node00272,influence,[attached=[],complete=true,name=i11,role=[use(none,in_hierarchy,index,1)]],[curve=[2,-9]]).
arc(arc00251,node00274,node00272,influence,[attached=[],complete=true,name=i15_0,role=[use(none,in_hierarchy,[palatabilities],array(1,6))]],[curve=[9,10]]).
node(node00238,variable,[],[complete=true,name='available\nbiomass'],[caption_offset=[ 0.0, 0.0],centre=[ 72.0, 63.0]]).
node(node00239,function,[],[complete=true,name=fn31,units=1,value=sum({biomass})],[]).
node(node00240,border,[],[name=var54],[along=26]).
node(node00241,variable,[],[complete=true,name=intake],[caption_offset=[ 0.0, 0.0],centre=[ 53.0, 113.0]]).
node(node00242,function,[],[complete=true,name=fn2,units=1,value=sum({eaten})],[]).
node(node00243,border,[],[name=var5],[along=112]).
node(node00244,variable,[],[complete=true,name='pop size'],[caption_offset=[ 0.0, 0.0],centre=[ 68.0, 23.0]]).
node(node00245,function,[],[complete=true,name=fn4,units=1,value=element([10,20,30,40],index(1))],[]).
node(node00246,border,[],[name=var10],[along=947]).
arc(arc00223,node00239,node00238,influence,[attached=[],name=i71],[]).
arc(arc00224,node00240,node00239,influence,[attached=[],complete=true,name=i73,role=[use(0,in_assoc,{biomass},list(1)),use(none,in_hierarchy,{biomass_0},list(1))]],[curve=[0,8]]).
arc(arc00225,node00242,node00241,influence,[attached=[],name=i2],[]).
arc(arc00226,node00243,node00242,influence,[attached=[],complete=true,name=i5,role=[use(0,in_assoc,{eaten},list(1)),use(none,in_hierarchy,{eaten_0},list(1))]],[curve=[0,9]]).
arc(arc00227,node00245,node00244,influence,[attached=[],name=i9],[]).
arc(arc00228,node00244,node00246,influence,[attached=[],complete=true,name=i12],[curve=[0,-12]]).
arc(arc00230,node00235,node00234,influence,[attached=[],complete=true,name=i74],[curve=[0,14]]).
arc(arc00231,node00235,node00234,influence,[attached=[],complete=true,name=i6],[curve=[18,16]]).
arc(arc00049,node00237,node00235,influence,[attached=[],complete=true,name=i14_0],[curve=[4,-2]]).
arc(arc00229,node00234,node00235,relation,[attached=[],complete=true,name=eater],[caption_offset=[1,8],curve=[0,-16]]).
arc(arc00232,node00234,node00235,influence,[attached=[],complete=true,name=i14],[curve=[-2,-15]]).
arc(arc00252,node00236,node00235,relation,[attached=[],complete=true,name=food],[caption_offset=[-3,1],curve=[0,9]]).
arc(arc00253,node00236,node00235,influence,[attached=[],complete=true,name=i70],[curve=[0,9]]).
arc(arc00262,node00237,node00235,influence,[attached=[],complete=true,name=i52],[curve=[4,0]]).
arc(arc00263,node00237,node00235,influence,[attached=[],complete=true,name=i54],[curve=[4,2]]).
arc(arc00264,node00237,node00235,influence,[attached=[],complete=true,name=i6_0],[curve=[5,-2]]).
arc(arc00254,node00235,node00236,influence,[attached=[],complete=true,name=i8],[curve=[-15,24]]).
arc(arc00255,node00235,node00236,influence,[attached=[],complete=true,name=i17],[curve=[0,-10]]).
