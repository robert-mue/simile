source(program='AME',version= 9.0,edition=standard,date='Mon Feb 04 23:22:18 GMT 2008').

roots([node00050,node00051,node00052,node00053,node00054,node00197,node00198,node00199,node00200,node00201,node00202]).

properties([complete-true,enum_types-['hexagon coefficients'-[a,b,c]],file_name-'/win98/Program Files/Simile/Develop/Library/hexagon.sml',fill_colour-'#d1d3d3',fix_math_args-0,image_posn-none,min_val-0,multiplication_spec-[count=[]],name-antsworld,separate-0,units-1,value- 0.5]).

node(node00050,submodel,[node00056,node00057,node00058,node00059,node00060,node00061,node00062,node00063,node00064,node00065,node00066,node00067,node00068,node00069,node00070,node00071,node00072,node00073,node00074,node00075,node00076,node00077,node00078],[complete=true,enum_types=[],fill_colour='#ff997e',image_posn=none,multiplication_spec=[type=population],name='Ants',separate=0],[bounding_box=[-237,-414,76,88],internal_extent=[0,0,313,502]]).
links(node00050,[arc00053-arc00068,arc00066-arc00072,arc00069-arc00057,arc00070-arc00058,arc00071-arc00063]).
references(node00050,[local(arc00067)]).
node(node00056,immigration,[],[complete=true,name=im1],[centre=[39,29]]).
node(node00057,function,[],[complete=true,name=fn1,spec='.1',units=1,value= 0.1],[]).
node(node00058,variable,[],[complete=true,name='my space'],[centre=[272,188]]).
node(node00059,function,[],[complete=true,name=fn3,spec='infront=element(last([neighbour_spaces]),my_direction),if time()==init_time() then 5102 elseif infront>0 then infront else prev(1)',units=int,value=(infront=element(last([neighbour_spaces]),my_direction),if time('')==init_time('') then 5102 elseif infront>0 then infront else prev(1))],[]).
node(node00060,border,[],[name=var2],[centre=[313,208]]).
node(node00061,variable,[],[complete=true,name=x],[centre=[248,236]]).
node(node00062,function,[],[complete=true,name=fn4,spec=x_at,units=1,value=x_at],[]).
node(node00063,variable,[],[complete=true,name=y],[centre=[292,234]]).
node(node00064,function,[],[complete=true,name=fn5,spec=y_at,units=1,value=y_at],[]).
node(node00065,variable,[],[complete=true,name='my head size'],[centre=[150,240]]).
node(node00066,function,[],[complete=true,name=fn6,spec='1',units=int,value=1],[]).
node(node00067,border,[],[name=var10],[centre=[313,266]]).
node(node00068,border,[],[name=var14],[centre=[313,244]]).
node(node00069,variable,[],[complete=true,name='my direction'],[centre=[150,188]]).
node(node00070,function,[],[complete=true,name=fn10,spec='ceil(rand_var(0,6))',units=int,value=ceil(rand_var(0,6))],[]).
node(node00071,variable,[],[complete=true,name='neighbour\nspaces'],[centre=[268,314]]).
node(node00072,function,[],[complete=true,name=fn11,spec='[neighbours_at]',units=array(int,6),value=[neighbours_at]],[]).
node(node00073,border,[],[name=var28],[centre=[313,324]]).
node(node00074,variable,[],[complete=true,name='my body size'],[centre=[152,308]]).
node(node00075,function,[],[complete=true,name=fn2,spec='2',units=int,value=2],[]).
node(node00076,variable,[],[complete=true,name='Pheromone\noutput'],[centre=[228,388]]).
node(node00077,function,[],[complete=true,name=fn7,spec='1',units=int,value=1],[]).
node(node00078,border,[],[name=var3],[centre=[313,396]]).
node(node00051,submodel,[node00079,node00080,node00081,node00082,node00083,node00084,node00085,node00086,node00087,node00088,node00089,node00090,node00091,node00093,node00094,node00095,node00096,node00097,node00235],[complete=true,enum_types=[],fill_colour='#c4ffff',image_posn=none,multiplication_spec=[count=[]],name=location,separate=0],[bounding_box=[126,-194,220,82],internal_extent=[0,0,94,276]]).
links(node00051,[arc00068-arc00075,arc00072-arc00085,arc00078-arc00069,arc00080-arc00070,arc00083-arc00071,arc00086-arc00093,arc00090-arc00077,arc00091-arc00079,arc00240-arc00239]).
references(node00051,[local(arc00067),local(arc00088)]).
node(node00079,variable,[],[complete=true,name=x],[centre=[24,80]]).
node(node00080,function,[],[complete=true,name=fn1,spec=x_has,units=1,value=x_has],[]).
node(node00081,condition,[],[complete=true,name=cond1],[centre=[40,30]]).
node(node00082,function,[],[complete=true,name=fn2,spec='index(1) is my_space_at',units=cond_spec,value=(index(1) is my_space_at)],[]).
node(node00083,border,[],[name=var3],[centre=[0,11]]).
node(node00084,variable,[],[complete=true,name=y],[centre=[68,82]]).
node(node00085,function,[],[complete=true,name=fn3,spec=y_has,units=1,value=y_has],[]).
node(node00086,border,[],[name=var8],[centre=[94,69]]).
node(node00087,border,[],[name=var9],[centre=[0,69]]).
node(node00088,border,[],[name=var12],[centre=[94,77]]).
node(node00089,border,[],[name=var13],[centre=[0,48]]).
node(node00090,variable,[],[complete=true,name=neighbours],[centre=[46,124]]).
node(node00091,function,[],[complete=true,name=fn9,units=array(int,6),value=[their_ids_has]],[]).
node(node00093,border,[],[name=var27],[centre=[0,114]]).
node(node00094,variable,[],[complete=true,name='Pheromone'],[centre=[50,184]]).
node(node00095,function,[],[complete=true,name=fn8,spec='Pheromone_output_at',units=int,value='Pheromone_output_at'],[]).
node(node00096,border,[],[name=var4],[centre=[0,179]]).
node(node00097,border,[],[name=var5],[centre=[94,189]]).
node(node00235,border,[],[name=var28],[centre=[94,90]]).
node(node00052,variable,[],[complete=true,name=n],[centre=[496,-304]]).
node(node00053,function,[],[complete=true,name=fn5,spec='int(sqrt(size(World)))',units=int,value=int(sqrt(size('World')))],[]).
node(node00054,submodel,[node00098,node00099,node00100,node00101,node00102,node00110,node00111,node00115,node00116,node00117,node00118,node00119,node00120,node00121,node00122,node00123,node00124,node00125,node00126,node00127,node00128,node00129,node00203,node00212,node00215,node00218,node00224,node00234],[complete=true,enum_types=[],fill_colour='#7ef18a',fix_math_args=0,image_posn=none,multiplication_spec=[count=[10201]],name='World',separate=0],[bounding_box=[265,-284,628,105],internal_extent=[-11,0,352,389]]).
links(node00054,[arc00089-arc00145,arc00089-arc00148,arc00089-arc00226,arc00093-arc00140,arc00142-arc00090,arc00144-arc00091,arc00207-arc00206,arc00212-arc00211,arc00217-arc00216,arc00238-arc00240]).
references(node00054,[obsolete,obsolete,local(arc00088)]).
node(node00098,submodel,[node00133,node00134,node00135,node00136,node00137,node00138],[complete=true,enum_types=[],fill_colour='#ffffff',fix_math_args=0,image_posn=none,multiplication_spec=[count=[6]],name=borders,separate=0],[bounding_box=[213,158,295,253],internal_extent=[0,0,82,95]]).
links(node00098,[arc00141-arc00096,arc00143-arc00097]).
references(node00098,[ancestor(0),ancestor(1)]).
node(node00133,variable,[],[complete=true,name=x],[centre=[18,24]]).
node(node00134,function,[],[complete=true,name=fn1,spec='off=sqrt(3/4),x+element([0,off,off,0,-off,-off],index(1))',units=1,value=(off=sqrt(3/4),x+element([0,off,off,0,-off,-off],index(1)))],[]).
node(node00135,variable,[],[complete=true,name=y],[centre=[52,64]]).
node(node00136,function,[],[complete=true,name=fn2,spec='y+element([1, 0.5, -0.5,-1, -0.5, 0.5],index(1))',units=1,value=y+element([1, 0.5, -0.5,-1, -0.5, 0.5],index(1))],[]).
node(node00137,border,[],[name=var3],[centre=[35,0]]).
node(node00138,border,[],[name=var4],[centre=[78,3]]).
node(node00099,border,[],[name=var1],[centre=[186,0]]).
node(node00100,border,[],[name=var2],[centre=[186,0]]).
node(node00101,variable,[],[complete=true,name='my id'],[centre=[252,14]]).
node(node00102,function,[],[complete=true,name=fn5,spec='index(1)',units=int,value=index(1)],[]).
node(node00110,border,[],[name=var7],[centre=[-11,152]]).
node(node00111,border,[],[name=var11],[centre=[-11,159]]).
node(node00115,compartment,[],[complete=true,name='Pheromone'],[centre=[48,337]]).
node(node00116,function,[],[complete=true,name=fn9,spec='0',units=1,value=0],[]).
node(node00117,cloud,[],[complete=true,name=cd1],[centre=[46,252]]).
node(node00118,function,[],[complete=true,name=fn10,spec='sum({Pheromone_has})',units=int,value=sum({'Pheromone_has'})],[]).
node(node00119,border,[],[name=var9],[centre=[-11,285]]).
node(node00120,variable,[],[complete=true,name=a],[centre=[226,50]]).
node(node00121,variable,[],[complete=true,name=b],[centre=[268,49]]).
node(node00122,variable,[],[complete=true,name=c],[centre=[309,45]]).
node(node00123,variable,[],[complete=true,name=x],[centre=[286,103]]).
node(node00124,variable,[],[complete=true,name=y],[centre=[316,101]]).
node(node00125,function,[],[complete=true,name=fn1,spec='ceil(index(1)/n)-ceil(n/2)',units=int,value=ceil(index(1)/n)-ceil(n/2)],[]).
node(node00126,function,[],[complete=true,name=fn2,spec='index(1)-n*a-ceil(n*n/2)',units=int,value=index(1)-n*a-ceil(n*n/2)],[]).
node(node00127,function,[],[complete=true,name=fn3,spec='-a-b',units=int,value= -a-b],[]).
node(node00128,function,[],[complete=true,name=fn6,spec='50+(a-c)* 0.866',units=1,value=50+(a-c)* 0.866],[]).
node(node00129,function,[],[complete=true,name=fn7,spec='50+b* 1.5',units=1,value=50+b* 1.5],[]).
node(node00203,submodel,[node00204,node00205,node00206,node00207,node00208,node00209,node00210,node00211,node00213,node00214,node00216,node00217,node00221,node00222,node00225,node00233],[complete=true,enum_types=[],fill_colour='#ffffff',image_posn=none,multiplication_spec=[count=[6]],name=neighbours,separate=0],[bounding_box=[33,27,193,126],internal_extent=[0,0,160,99]]).
links(node00203,[arc00204-arc00203,arc00206-arc00205,arc00209-arc00208,arc00211-arc00210,arc00214-arc00213,arc00216-arc00215,arc00226-arc00227,arc00237-arc00238]).
references(node00203,[ancestor(0),ancestor(1),ancestor(2)]).
node(node00204,variable,[],[complete=true,name=a],[centre=[30,24]]).
node(node00205,function,[],[complete=true,name=fn2,spec='a+element([neighbour_offsets_a],index(1))',units=int,value=a+element([neighbour_offsets_a],index(1))],[]).
node(node00206,variable,[],[complete=true,name=b],[centre=[74,24]]).
node(node00207,function,[],[complete=true,name=fn3,spec='b+element([neighbour_offsets_b],index(1))',units=int,value=b+element([neighbour_offsets_b],index(1))],[]).
node(node00208,variable,[],[complete=true,name=c],[centre=[126,24]]).
node(node00209,function,[],[complete=true,name=fn4,spec='c+element([neighbour_offsets_c],index(1))',units=int,value=c+element([neighbour_offsets_c],index(1))],[]).
node(node00210,border,[],[name=var5],[centre=[160,23]]).
node(node00211,border,[],[name=var6],[centre=[17,0]]).
node(node00213,border,[],[name=var9],[centre=[160,23]]).
node(node00214,border,[],[name=var10],[centre=[68,0]]).
node(node00216,border,[],[name=var13],[centre=[160,22]]).
node(node00217,border,[],[name=var14],[centre=[116,0]]).
node(node00221,variable,[],[complete=true,name='their ids'],[centre=[34,62]]).
node(node00222,function,[],[complete=true,name=fn6,spec='if all([a,b,c]>-n/2) and all([a,b,c]<n/2) then n*a+b+ceil(n*n/2) else 0',units=int,value=(if all([a,b,c]> - (n/2)) and all([a,b,c]<n/2) then n*a+b+ceil(n*n/2) else 0)],[]).
node(node00225,border,[],[name=var19],[centre=[145,0]]).
node(node00233,border,[],[name=var25],[centre=[0,87]]).
node(node00212,border,[],[name=var8],[centre=[35,0]]).
node(node00215,border,[],[name=var12],[centre=[93,0]]).
node(node00218,border,[],[name=var15],[centre=[137,0]]).
node(node00224,border,[],[name=var18],[centre=[186,0]]).
node(node00234,border,[],[name=var26],[centre=[-11,147]]).
node(node00197,variable,[],[complete=true,name='neighbour offsets a'],[centre=[280,-340]]).
node(node00198,function,[],[complete=true,name=fn1,spec='[0,1,1,0,-1,-1]',units=array(int,6),value=[0,1,1,0,-1,-1]],[]).
node(node00199,variable,[],[complete=true,name='neighbour offsets b'],[centre=[350,-356]]).
node(node00200,function,[],[complete=true,name=fn1,spec='[1,0,-1,-1,0,1]',units=array(int,6),value=[1,0,-1,-1,0,1]],[]).
node(node00201,variable,[],[complete=true,name='neighbour offsets c'],[centre=[394,-328]]).
node(node00202,function,[],[complete=true,name=fn1,spec='[-1,-1,0,1,1,0]',units=array(int,6),value=[-1,-1,0,1,1,0]],[]).

arc(arc00051,node00057,node00056,influence,[name=i1],[]).
arc(arc00052,node00059,node00058,influence,[name=i3],[]).
arc(arc00053,node00058,node00060,influence,[complete=true,name=i4],[curve=[4,-9]]).
arc(arc00054,node00062,node00061,influence,[name=i5],[]).
arc(arc00055,node00064,node00063,influence,[name=i6],[]).
arc(arc00056,node00066,node00065,influence,[name=i7],[]).
arc(arc00057,node00067,node00062,influence,[complete=true,name=i24,role=[use(0,in_assoc,x_at,1)]],[curve=[-6,14]]).
arc(arc00058,node00068,node00064,influence,[complete=true,name=i31,role=[use(0,in_assoc,y_at,1)]],[curve=[-2,4]]).
arc(arc00059,node00069,node00059,influence,[complete=true,name=i56,role=[use(none,in_hierarchy,my_direction,int)]],[curve=[0,-27]]).
arc(arc00060,node00070,node00069,influence,[name=i35],[]).
arc(arc00061,node00071,node00059,influence,[complete=true,name=i55,role=[use(none,in_hierarchy,[neighbour_spaces],array(int,6))]],[curve=[-27,-1]]).
arc(arc00062,node00072,node00071,influence,[name=i36],[]).
arc(arc00063,node00073,node00072,influence,[complete=true,name=i53,role=[use(0,in_assoc,[neighbours_at],array(int,6))]],[curve=[-2,10]]).
arc(arc00064,node00075,node00074,influence,[name=i2],[]).
arc(arc00065,node00077,node00076,influence,[name=i8],[]).
arc(arc00066,node00076,node00078,influence,[complete=true,name=i27],[curve=[2,-20]]).
arc(arc00067,node00050,node00051,relation,[can_lookup=0,complete=true,exclusive=1,name=at],[curve=[5,-12]]).
arc(arc00068,node00050,node00051,influence,[complete=true,name=i7],[curve=[6,-12]]).
arc(arc00069,node00051,node00050,influence,[complete=true,name=i26],[curve=[-6,12]]).
arc(arc00070,node00051,node00050,influence,[complete=true,name=i32],[curve=[-6,12]]).
arc(arc00071,node00051,node00050,influence,[complete=true,name=i54],[curve=[-3,12]]).
arc(arc00072,node00050,node00051,influence,[complete=true,name=i30],[curve=[1,-12]]).
arc(arc00073,node00080,node00079,influence,[name=i1],[]).
arc(arc00074,node00082,node00081,influence,[name=i2],[]).
arc(arc00075,node00083,node00082,influence,[complete=true,name=i5,role=[use(0,in_base,my_space_at,int)]],[curve=[4,-6]]).
arc(arc00076,node00085,node00084,influence,[name=i3],[]).
arc(arc00077,node00086,node00080,influence,[complete=true,name=i21,role=[use(1,in_base,x_has,1)]],[curve=[2,16]]).
arc(arc00078,node00079,node00087,influence,[complete=true,name=i23],[curve=[-2,5]]).
arc(arc00079,node00088,node00085,influence,[complete=true,name=i28,role=[use(1,in_base,y_has,1)]],[curve=[1,4]]).
arc(arc00080,node00084,node00089,influence,[complete=true,name=i30],[curve=[-7,15]]).
arc(arc00081,node00091,node00090,influence,[name=i34],[]).
arc(arc00083,node00090,node00093,influence,[complete=true,name=i52],[curve=[-2,10]]).
arc(arc00084,node00095,node00094,influence,[name=i9],[]).
arc(arc00085,node00096,node00095,influence,[complete=true,name=i29,role=[use(0,in_base,'Pheromone_output_at',int)]],[curve=[1,-10]]).
arc(arc00086,node00094,node00097,influence,[complete=true,name=i31],[curve=[2,-8]]).
arc(arc00239,node00235,node00091,influence,[complete=true,name=i53,role=[use(1,in_base,[their_ids_has],array(int,6))]],[curve=[8,11]]).
arc(arc00087,node00053,node00052,influence,[name=i6],[]).
arc(arc00088,node00054,node00051,relation,[can_lookup=1,complete=true,exclusive=0,name=has],[curve=[2,11]]).
arc(arc00089,node00052,node00054,influence,[complete=true,name=i24],[curve=[6,0]]).
arc(arc00090,node00054,node00051,influence,[complete=true,name=i22],[curve=[2,12]]).
arc(arc00091,node00054,node00051,influence,[complete=true,name=i29],[curve=[2,11]]).
arc(arc00093,node00051,node00054,influence,[complete=true,name=i33],[curve=[2,-12]]).
arc(arc00240,node00054,node00051,influence,[complete=true,name=i55],[curve=[8,12]]).
arc(arc00094,node00134,node00133,influence,[name=i1],[]).
arc(arc00095,node00136,node00135,influence,[name=i2],[]).
arc(arc00096,node00137,node00134,influence,[complete=true,name=i3,role=[use(none,in_hierarchy,x,1)]],[curve=[4,4]]).
arc(arc00097,node00138,node00136,influence,[complete=true,name=i9,role=[use(none,in_hierarchy,y,1)]],[curve=[14,6]]).
arc(arc00098,node00102,node00101,influence,[name=i19],[]).
arc(arc00137,node00116,node00115,influence,[name=i24],[]).
arc(arc00138,node00117,node00115,flow,[complete=true,name='Addition'],[curve=[550,508]]).
arc(arc00139,node00118,arc00138,influence,[name=i26],[]).
arc(arc00140,node00119,node00118,influence,[complete=true,name=i32,role=[use(2,in_assoc,{'Pheromone_has'},list(int))]],[curve=[1,-11]]).
arc(arc00141,node00123,node00098,influence,[complete=true,name=i8],[curve=[12,8]]).
arc(arc00142,node00123,node00110,influence,[complete=true,name=i20],[curve=[12,72]]).
arc(arc00143,node00124,node00098,influence,[complete=true,name=i14],[curve=[14,6]]).
arc(arc00144,node00124,node00111,influence,[complete=true,name=i27],[curve=[14,80]]).
arc(arc00145,node00099,node00125,influence,[complete=true,name=i23,role=[use(none,in_hierarchy,usr(n),int)]],[curve=[11,-2]]).
arc(arc00146,node00125,node00120,influence,[name=i1],[]).
arc(arc00147,node00120,node00126,influence,[complete=true,name=i5,role=[use(none,in_hierarchy,usr(a),int)]],[curve=[0,-6]]).
arc(arc00148,node00100,node00126,influence,[complete=true,name=i25,role=[use(none,in_hierarchy,n,int)]],[curve=[10,-10]]).
arc(arc00149,node00126,node00121,influence,[name=i2],[]).
arc(arc00150,node00121,node00127,influence,[complete=true,name=i16,role=[use(none,in_hierarchy,usr(b),int)]],[curve=[-1,-7]]).
arc(arc00151,node00120,node00127,influence,[complete=true,name=i17,role=[use(none,in_hierarchy,usr(a),int)]],[curve=[-1,-17]]).
arc(arc00152,node00127,node00122,influence,[name=i3],[]).
arc(arc00153,node00128,node00123,influence,[name=i9],[]).
arc(arc00154,node00120,node00128,influence,[complete=true,name=i11,role=[use(none,in_hierarchy,usr(a),int)]],[curve=[11,-12]]).
arc(arc00155,node00122,node00128,influence,[complete=true,name=i12,role=[use(none,in_hierarchy,usr(c),int)]],[curve=[11,4]]).
arc(arc00156,node00129,node00124,influence,[name=i10],[]).
arc(arc00157,node00121,node00129,influence,[complete=true,name=i13,role=[use(none,in_hierarchy,usr(b),int)]],[curve=[10,-10]]).
arc(arc00204,node00120,node00203,influence,[complete=true,name=i6],[curve=[0,6]]).
arc(arc00209,node00121,node00203,influence,[complete=true,name=i18],[curve=[0,18]]).
arc(arc00214,node00122,node00203,influence,[complete=true,name=i28],[curve=[0,27]]).
arc(arc00200,node00205,node00204,influence,[name=i2],[]).
arc(arc00201,node00207,node00206,influence,[name=i3],[]).
arc(arc00202,node00209,node00208,influence,[name=i4],[]).
arc(arc00203,node00210,node00205,influence,[complete=true,name=i5,role=[use(none,in_hierarchy,a,int)]],[curve=[0,31]]).
arc(arc00205,node00211,node00205,influence,[complete=true,name=i7,role=[use(none,in_hierarchy,[neighbour_offsets_a],array(int,6))]],[curve=[4,-2]]).
arc(arc00208,node00213,node00207,influence,[complete=true,name=i17,role=[use(none,in_hierarchy,b,int)]],[curve=[1,19]]).
arc(arc00210,node00214,node00207,influence,[complete=true,name=i19,role=[use(none,in_hierarchy,[neighbour_offsets_b],array(int,6))]],[curve=[4,-1]]).
arc(arc00213,node00216,node00209,influence,[complete=true,name=i24,role=[use(none,in_hierarchy,c,int)]],[curve=[0,6]]).
arc(arc00215,node00217,node00209,influence,[complete=true,name=i29,role=[use(none,in_hierarchy,[neighbour_offsets_c],array(int,6))]],[curve=[4,-2]]).
arc(arc00219,node00222,node00221,influence,[name=i33],[]).
arc(arc00220,node00204,node00222,influence,[complete=true,name=i34,role=[use(none,in_hierarchy,a,int)]],[curve=[5,0]]).
arc(arc00221,node00206,node00222,influence,[complete=true,name=i35,role=[use(none,in_hierarchy,b,int)]],[curve=[7,7]]).
arc(arc00236,node00208,node00222,influence,[complete=true,name=i50,role=[use(none,in_hierarchy,c,int)]],[curve=[8,20]]).
arc(arc00227,node00225,node00222,influence,[complete=true,name=i41,role=[use(none,in_hierarchy,n,int)]],[curve=[14,26]]).
arc(arc00237,node00221,node00233,influence,[complete=true,name=i51],[curve=[6,7]]).
arc(arc00206,node00212,node00203,influence,[complete=true,name=i15],[curve=[6,-4]]).
arc(arc00211,node00215,node00203,influence,[complete=true,name=i21],[curve=[7,-2]]).
arc(arc00216,node00218,node00203,influence,[complete=true,name=i30],[curve=[7,-2]]).
arc(arc00226,node00224,node00203,influence,[complete=true,name=i40],[curve=[7,2]]).
arc(arc00238,node00203,node00234,influence,[complete=true,name=i52],[curve=[8,12]]).
arc(arc00207,node00197,node00054,influence,[complete=true,name=i16],[curve=[12,-7]]).
arc(arc00197,node00198,node00197,influence,[name=i1],[]).
arc(arc00212,node00199,node00054,influence,[complete=true,name=i23],[curve=[16,-4]]).
arc(arc00198,node00200,node00199,influence,[name=i1],[]).
arc(arc00217,node00201,node00054,influence,[complete=true,name=i31],[curve=[9,-4]]).
arc(arc00199,node00202,node00201,influence,[name=i1],[]).

