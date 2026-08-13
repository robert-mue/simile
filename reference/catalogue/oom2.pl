source(program='AME',version= 9.0,edition=standard,date='Wed Feb 06 14:23:58 GMT 2008').

roots([node00004,node00005,node00006,node00007,node00008,node00009,node00010,node00011,node00012,node00013,node00014,node00015,node00016,node00019,node00020]).

properties([complete-true,fill_colour-'#e8ffff',image_posn-none,multiplication_spec-[count=[]],name-oom2,separate-0]).

node(node00004,submodel,[node00003,node00021,node00022,node00031,node00032,node00036,node00037,node00038,node00039,node00040,node00041,node00042,node00043,node00044,node00045,node00046,node00047,node00048,node00049,node00050,node00098,node00099,node00103,node00106],[complete=true,enum_types=[],fill_colour='#80ff7c',image_posn=none,multiplication_spec=[count=[19608]],name=hexagon,separate=0],[bounding_box=[-165,-45,270,510],caption_offset=[-1,1],internal_extent=[-13,-13,443,568]]).
links(node00004,[arc00025-arc00052,arc00026-arc00053,arc00054-arc00027,arc00055-arc00028,arc00087-arc00023,arc00087-arc00033,arc00088-arc00024,arc00088-arc00034,arc00109-arc00029,arc00109-arc00030,arc00112-arc00114,arc00116-arc00118,arc00122-arc00121]).
references(node00004,[local(arc00047),local(arc00048)]).
node(node00003,variable,[],[complete=true,name='my parent'],[caption_offset=[0,0],centre=[375,30]]).
node(node00021,variable,[],[complete=true,name='my level'],[caption_offset=[0,0],centre=[210,120]]).
node(node00022,function,[],[complete=true,name=fn2,spec='hi_level_lower+1',units=int,value=hi_level_lower+1],[]).
node(node00031,variable,[],[complete=true,name='posn in parent'],[caption_offset=[0,0],centre=[390,465]]).
node(node00032,function,[],[complete=true,name=fn6,spec='if index(1)==1 then 0 else int(fmod(index(1)-2,7))',units=int,value=(if index(1)==1 then 0 else int(fmod(index(1)-2,7)))],[]).
node(node00036,variable,[],[complete=true,name='centre x'],[caption_offset=[0,0],centre=[315,390]]).
node(node00037,function,[],[complete=true,name=fn7,spec='if posn_in_parent==0 then hi_cx_lower else hi_cx_lower+magic*element(element([[offb]],my_level),int(posn_in_parent))',units=1,value=(if posn_in_parent==0 then hi_cx_lower else hi_cx_lower+magic*element(element([[offb]],my_level),int(posn_in_parent)))],[]).
node(node00038,variable,[],[complete=true,name='centre y'],[caption_offset=[0,0],centre=[375,330]]).
node(node00039,function,[],[complete=true,name=fn8,spec='if posn_in_parent==0 then hi_cy_lower else hi_cy_lower-magic*element(element([[offa]],my_level),int(posn_in_parent))',units=1,value=(if posn_in_parent==0 then hi_cy_lower else hi_cy_lower-magic*element(element([[offa]],my_level),int(posn_in_parent)))],[]).
node(node00040,border,[],[name=var28],[centre=[223,-13]]).
node(node00041,border,[],[name=var30],[centre=[290,-13]]).
node(node00042,border,[],[name=var31],[centre=[223,-13]]).
node(node00043,border,[],[name=var32],[centre=[290,-13]]).
node(node00044,border,[],[name=var35],[centre=[443,386]]).
node(node00045,border,[],[name=var37],[centre=[443,327]]).
node(node00046,border,[],[name=var40],[centre=[443,386]]).
node(node00047,border,[],[name=var42],[centre=[443,327]]).
node(node00048,border,[],[name=var44],[centre=[443,405]]).
node(node00049,border,[],[name=var45],[centre=[443,405]]).
node(node00050,submodel,[node00001,node00002,node00051,node00052,node00053,node00054,node00055,node00056,node00057,node00058,node00059,node00060,node00061,node00062,node00063],[complete=true,enum_types=[],fill_colour='#ff5874',image_posn=none,multiplication_spec=[count=[]],name=' for display',separate=0],[bounding_box=[30,165,210,435],caption_offset=[0,0],internal_extent=[0,0,180,270]]).
links(node00050,[arc00031-arc00039,arc00032-arc00042,arc00033-arc00040,arc00034-arc00043,arc00035-arc00041,arc00035-arc00046,arc00036-arc00044]).
references(node00050,[ancestor(0),ancestor(1)]).
node(node00001,variable,[],[complete=true,name=colour],[caption_offset=[0,0],centre=[30,210]]).
node(node00002,function,[],[complete=true,name=fn1,spec='index(1)',units=int,value=index(1)],[]).
node(node00051,variable,[],[complete=true,name=xpts],[caption_offset=[0,0],centre=[30,105]]).
node(node00052,function,[],[complete=true,name=fn12,units=array(1,6),value=centre_x+element([[offa]],my_level)],[]).
node(node00053,variable,[],[complete=true,name=ypts],[caption_offset=[0,0],centre=[90,180]]).
node(node00054,function,[],[complete=true,name=fn13,units=array(1,6),value=centre_y+element([[offb]],my_level)],[]).
node(node00055,border,[],[],[centre=[180,176]]).
node(node00056,border,[],[],[centre=[90,0]]).
node(node00057,border,[],[],[centre=[154,0]]).
node(node00058,border,[],[],[centre=[180,175]]).
node(node00059,border,[],[],[centre=[173,6]]).
node(node00060,border,[],[],[centre=[162,0]]).
node(node00061,condition,[],[complete=true,name=cond1],[caption_offset=[0,0],centre=[120,60]]).
node(node00062,function,[],[complete=true,name=fn17,spec='my_level==6',units=cond_spec,value=(my_level==6)],[]).
node(node00063,border,[],[name=var46],[centre=[154,0]]).
node(node00098,function,[],[complete=true,name=fn1,spec='if index(1)==1 then 1 else int((index(1)+5)/7)',units=int,value=(if index(1)==1 then 1 else int((index(1)+5)/7))],[]).
node(node00099,border,[],[name=var2],[centre=[443,49]]).
node(node00103,border,[],[name=var6],[centre=[443,153]]).
node(node00106,border,[],[name=var9],[centre=[443,153]]).
node(node00005,submodel,[node00064,node00065,node00069,node00070,node00072,node00073,node00074,node00075,node00076,node00077,node00078,node00079,node00100,node00101,node00102,node00104,node00105],[complete=true,enum_types=[],fill_colour='#a4c4ff',image_posn=none,multiplication_spec=[count=[]],name=hierarchy,separate=0],[bounding_box=[390,15,645,405],caption_offset=[0,0],internal_extent=[0,0,255,390]]).
links(node00005,[arc00052-arc00067,arc00053-arc00068,arc00069-arc00054,arc00070-arc00055,arc00114-arc00113,arc00118-arc00117,arc00120-arc00122]).
references(node00005,[local(arc00048),local(arc00047)]).
node(node00064,condition,[],[complete=true,name=cond1],[caption_offset=[0,0],centre=[45,45]]).
node(node00065,function,[],[complete=true,name=fn7,spec='index(1) is my_parent_lower',units=cond_spec,value=(index(1) is my_parent_lower)],[]).
node(node00069,variable,[],[complete=true,name=dummy],[caption_offset=[-1,1],centre=[105,150]]).
node(node00070,function,[],[complete=true,name=fn2,spec='index(2)==1',units=boolean,value=(index(2)==1)],[]).
node(node00072,variable,[],[complete=true,name=hi_cx],[caption_offset=[0,0],centre=[45,315]]).
node(node00073,function,[],[complete=true,name=fn14,spec='if dummy then 0 else centre_x_higher',units=1,value=(if dummy then 0 else centre_x_higher)],[]).
node(node00074,variable,[],[complete=true,name=hi_cy],[caption_offset=[0,0],centre=[105,255]]).
node(node00075,function,[],[complete=true,name=fn15,spec='if dummy then 0 else centre_y_higher',units=1,value=(if dummy then 0 else centre_y_higher)],[]).
node(node00076,border,[],[name=var36],[centre=[0,317]]).
node(node00077,border,[],[name=var38],[centre=[0,260]]).
node(node00078,border,[],[name=var39],[centre=[0,317]]).
node(node00079,border,[],[name=var41],[centre=[0,260]]).
node(node00100,border,[],[name=var3],[centre=[0,33]]).
node(node00101,variable,[],[complete=true,name=hi_level],[caption_offset=[0,0],centre=[30,120]]).
node(node00102,function,[],[complete=true,name=fn3,spec='if dummy then 0 else my_level_higher',units=int,value=(if dummy then 0 else my_level_higher)],[]).
node(node00104,border,[],[name=var7],[centre=[0,116]]).
node(node00105,border,[],[name=var8],[centre=[0,116]]).
node(node00006,variable,[],[complete=true,name=offa_even],[caption_offset=[0,0],centre=[-240,232]]).
node(node00007,function,[],[complete=true,name=fn4,spec='[.5,-.5,-1,-.5,.5,1]',units=array(1,6),value=[ 0.5, -0.5,-1, -0.5, 0.5,1]],[]).
node(node00008,variable,[],[complete=true,name=offb_even],[caption_offset=[0,0],centre=[-240,308]]).
node(node00009,function,[],[complete=true,name=fn5,spec='[.866,.866,0,-.866,-.866,0]',units=array(1,6),value=[ 0.866, 0.866,0, -0.866, -0.866,0]],[]).
node(node00010,variable,[],[complete=true,name=offa_odd],[caption_offset=[0,0],centre=[-240,-8]]).
node(node00011,function,[],[complete=true,name=fn7,spec='cos(theta)*[offa_even]-sin(theta)*[offb_even]',units=array(1,6),value=cos(theta)*[offa_even]-sin(theta)*[offb_even]],[]).
node(node00012,variable,[],[complete=true,name=offb_odd],[caption_offset=[0,0],centre=[-240,68]]).
node(node00013,function,[],[complete=true,name=fn8,spec='sin(theta)*[offa_even]+cos(theta)*[offb_even]',units=array(1,6),value=sin(theta)*[offa_even]+cos(theta)*[offb_even]],[]).
node(node00014,variable,[],[complete=true,name=theta],[caption_offset=[0,0],centre=[-240,150]]).
node(node00015,function,[],[complete=true,name=fn2,spec='atan(3*sqrt(3))',units=1,value=atan(3*sqrt(3))],[]).
node(node00016,submodel,[node00084,node00085,node00086,node00087,node00088,node00089,node00090,node00091,node00092,node00093,node00094,node00095,node00096,node00097],[complete=true,enum_types=[],fill_colour='#d0d0d6',image_posn=none,multiplication_spec=[count=[6]],name='level info',separate=0],[bounding_box=[-30,-165,255,-75],caption_offset=[3,-4],internal_extent=[-30,-15,255,75]]).
links(node00016,[arc00083-arc00100,arc00084-arc00101,arc00085-arc00102,arc00086-arc00103,arc00104-arc00087,arc00105-arc00088]).
node(node00084,variable,[],[complete=true,name=side],[caption_offset=[0,0],centre=[0,15]]).
node(node00085,function,[],[complete=true,name=fn4,spec='50/7^((index(1)-1)/2)',units=1,value=50/7^((index(1)-1)/2)],[]).
node(node00086,variable,[],[complete=true,name=offa],[caption_offset=[0,0],centre=[30,38]]).
node(node00087,function,[],[complete=true,name=fn9,spec='side*(if even_level then [offa_even] else [offa_odd])',units=array(1,6),value=side*(if even_level then [offa_even] else [offa_odd])],[]).
node(node00088,variable,[],[complete=true,name=offb],[caption_offset=[0,0],centre=[120,38]]).
node(node00089,function,[],[complete=true,name=fn10,spec='side*(if even_level then [offb_even] else [offb_odd])',units=array(1,6),value=side*(if even_level then [offb_even] else [offb_odd])],[]).
node(node00090,variable,[],[complete=true,name='even level'],[caption_offset=[0,0],centre=[105,8]]).
node(node00091,function,[],[complete=true,name=fn11,spec='fmod(index(1),2)==1.0',units=boolean,value=(fmod(index(1),2)== 1.0)],[]).
node(node00092,border,[],[name=var21],[centre=[1,75]]).
node(node00093,border,[],[name=var22],[centre=[-30,61]]).
node(node00094,border,[],[name=var23],[centre=[88,75]]).
node(node00095,border,[],[name=var24],[centre=[45,75]]).
node(node00096,border,[],[name=var27],[centre=[47,75]]).
node(node00097,border,[],[name=var29],[centre=[122,75]]).
node(node00019,variable,[],[complete=true,name=magic],[caption_offset=[0,0],centre=[315,360]]).
node(node00020,function,[],[complete=true,name=fn16,spec='sqrt(3)',units=1,value=sqrt(3)],[]).

arc(arc00002,node00022,node00021,influence,[name=i2],[]).
arc(arc00011,node00032,node00031,influence,[name=i12],[]).
arc(arc00017,node00037,node00036,influence,[name=i22],[]).
arc(arc00018,node00021,node00037,influence,[complete=true,name=i84,role=[use(none,in_hierarchy,my_level,int)]],[curve=[64,-25]]).
arc(arc00019,node00031,node00037,influence,[complete=true,name=i86,role=[use(none,in_hierarchy,posn_in_parent,int)]],[curve=[-19,6]]).
arc(arc00020,node00039,node00038,influence,[name=i24],[]).
arc(arc00021,node00021,node00039,influence,[complete=true,name=i85,role=[use(none,in_hierarchy,my_level,int)]],[curve=[50,-39]]).
arc(arc00022,node00031,node00039,influence,[complete=true,name=i87,role=[use(none,in_hierarchy,posn_in_parent,int)]],[curve=[-32,-6]]).
arc(arc00023,node00042,node00039,influence,[complete=true,name=i67,role=[use(none,in_hierarchy,[[offa]],array(array(1,6),6))]],[curve=[84,-37]]).
arc(arc00024,node00043,node00037,influence,[complete=true,name=i68,role=[use(none,in_hierarchy,[[offb]],array(array(1,6),6))]],[curve=[98,-7]]).
arc(arc00025,node00036,node00044,influence,[complete=true,name=i71],[curve=[0,-30]]).
arc(arc00026,node00038,node00045,influence,[complete=true,name=i74],[curve=[0,-16]]).
arc(arc00027,node00046,node00037,influence,[complete=true,name=i78,role=[use(0,in_assoc,{hi_cx_higher},list(1)),use(1,in_assoc,hi_cx_lower,1)]],[curve=[2,30]]).
arc(arc00028,node00047,node00039,influence,[complete=true,name=i81,role=[use(0,in_assoc,{hi_cy_higher},list(1)),use(1,in_assoc,hi_cy_lower,1)]],[curve=[0,14]]).
arc(arc00029,node00048,node00039,influence,[complete=true,name=i88,role=[use(none,in_hierarchy,magic,1)]],[curve=[-18,16]]).
arc(arc00030,node00049,node00037,influence,[complete=true,name=i90,role=[use(none,in_hierarchy,magic,1)]],[curve=[-4,30]]).
arc(arc00031,node00036,node00050,influence,[complete=true,name=i57,role=[use(none,in_hierarchy,cx,1)]],[curve=[-11,24]]).
arc(arc00032,node00038,node00050,influence,[complete=true,name=i58,role=[use(none,in_hierarchy,cy,1)]],[curve=[2,39]]).
arc(arc00033,node00040,node00050,influence,[complete=true,name=i60,role=[use(none,in_hierarchy,[[offa]],array(array(1,6),5))]],[curve=[44,25]]).
arc(arc00034,node00041,node00050,influence,[complete=true,name=i63,role=[use(none,in_hierarchy,[[offb]],array(array(1,6),5))]],[curve=[46,22]]).
arc(arc00035,node00021,node00050,influence,[complete=true,name=i65,role=[use(none,in_hierarchy,my_level,int)]],[curve=[10,5]]).
arc(arc00036,node00021,node00050,influence,[complete=true,name=i66,role=[use(none,in_hierarchy,my_level,int)]],[curve=[10,4]]).
arc(arc00001,node00002,node00001,influence,[name=i1],[]).
arc(arc00037,node00052,node00051,influence,[name=i55],[]).
arc(arc00038,node00054,node00053,influence,[name=i56],[]).
arc(arc00039,node00055,node00052,influence,[complete=true,name=i57,role=[use(none,in_hierarchy,centre_x,1)]],[curve=[-16,36]]).
arc(arc00040,node00056,node00052,influence,[complete=true,name=i60,role=[use(none,in_hierarchy,[[offa]],array(array(1,6),6))]],[curve=[25,14]]).
arc(arc00041,node00057,node00052,influence,[complete=true,name=i65,role=[use(none,in_hierarchy,my_level,int)]],[curve=[25,30]]).
arc(arc00042,node00058,node00054,influence,[complete=true,name=i58,role=[use(none,in_hierarchy,centre_y,1)]],[curve=[2,20]]).
arc(arc00043,node00059,node00054,influence,[complete=true,name=i63,role=[use(none,in_hierarchy,[[offb]],array(array(1,6),6))]],[curve=[42,20]]).
arc(arc00044,node00060,node00054,influence,[complete=true,name=i66,role=[use(none,in_hierarchy,my_level,int)]],[curve=[42,18]]).
arc(arc00045,node00062,node00061,influence,[name=i91],[]).
arc(arc00046,node00063,node00062,influence,[complete=true,name=i92,role=[use(none,in_hierarchy,my_level,int)]],[curve=[12,6]]).
arc(arc00111,node00098,node00003,influence,[name=i1],[]).
arc(arc00112,node00003,node00099,influence,[complete=true,name=i4],[curve=[4,-16]]).
arc(arc00116,node00021,node00103,influence,[complete=true,name=i20],[curve=[8,-56]]).
arc(arc00121,node00106,node00022,influence,[complete=true,name=i25,role=[use(0,in_assoc,usr({hi_level_higher}),list(int)),use(1,in_assoc,usr(hi_level_lower),int)]],[curve=[-8,56]]).
arc(arc00047,node00004,node00005,relation,[can_lookup=1,complete=true,exclusive=0,name=higher],[caption_offset=[1,3],curve=[-1,-30]]).
arc(arc00048,node00004,node00005,relation,[can_lookup=0,complete=true,exclusive=1,name=lower],[caption_offset=[0,0],curve=[-1,30]]).
arc(arc00052,node00004,node00005,influence,[complete=true,name=i73,use_sofar=1],[curve=[-1,-30]]).
arc(arc00053,node00004,node00005,influence,[complete=true,name=i76,use_sofar=1],[curve=[-1,-30]]).
arc(arc00054,node00005,node00004,influence,[complete=true,name=i79,use_sofar=0],[curve=[1,30]]).
arc(arc00055,node00005,node00004,influence,[complete=true,name=i82,use_sofar=0],[curve=[1,30]]).
arc(arc00114,node00004,node00005,influence,[complete=true,name=i18],[curve=[8,-30]]).
arc(arc00118,node00004,node00005,influence,[complete=true,name=i22,use_sofar=1],[curve=[4,-30]]).
arc(arc00122,node00005,node00004,influence,[complete=true,name=i26],[curve=[-4,30]]).
arc(arc00056,node00065,node00064,influence,[name=i16],[]).
arc(arc00061,node00070,node00069,influence,[name=i1],[]).
arc(arc00063,node00069,node00073,influence,[complete=true,name=i5,role=[use(none,in_hierarchy,dummy,boolean)]],[curve=[38,14]]).
arc(arc00064,node00073,node00072,influence,[name=i69],[]).
arc(arc00065,node00069,node00075,influence,[complete=true,name=i6,role=[use(none,in_hierarchy,dummy,boolean)]],[curve=[23,-1]]).
arc(arc00066,node00075,node00074,influence,[name=i70],[]).
arc(arc00067,node00076,node00073,influence,[complete=true,name=i72,role=[use(0,in_base,centre_x_lower,1),use(1,in_base,centre_x_higher,1)]],[curve=[-1,-9]]).
arc(arc00068,node00077,node00075,influence,[complete=true,name=i75,role=[use(0,in_base,centre_y_lower,1),use(1,in_base,centre_y_higher,1)]],[curve=[-1,-24]]).
arc(arc00069,node00072,node00078,influence,[complete=true,name=i77],[curve=[0,9]]).
arc(arc00070,node00074,node00079,influence,[complete=true,name=i80],[curve=[1,24]]).
arc(arc00113,node00100,node00065,influence,[complete=true,name=i7,role=[use(0,in_base,usr(my_parent_lower),int),use(1,in_base,usr(my_parent_higher),int)]],[curve=[2,-8]]).
arc(arc00115,node00102,node00101,influence,[name=i19],[]).
arc(arc00119,node00069,node00102,influence,[complete=true,name=i23,role=[use(none,in_hierarchy,dummy,boolean)]],[curve=[-6,15]]).
arc(arc00117,node00104,node00102,influence,[complete=true,name=i21,role=[use(0,in_base,my_level_lower,int),use(1,in_base,my_level_higher,int)]],[curve=[0,-6]]).
arc(arc00120,node00101,node00105,influence,[complete=true,name=i24],[curve=[-2,6]]).
arc(arc00071,node00007,node00006,influence,[name=i4],[]).
arc(arc00072,node00009,node00008,influence,[name=i5],[]).
arc(arc00073,node00011,node00010,influence,[name=i12],[]).
arc(arc00074,node00006,node00011,influence,[complete=true,name=i14,role=[use(none,in_hierarchy,[offa_even],array(1,6))]],[curve=[-56,0]]).
arc(arc00075,node00008,node00011,influence,[complete=true,name=i15,role=[use(none,in_hierarchy,[offb_even],array(1,6))]],[curve=[-75,0]]).
arc(arc00076,node00013,node00012,influence,[name=i13],[]).
arc(arc00077,node00006,node00013,influence,[complete=true,name=i10,role=[use(none,in_hierarchy,[offa_even],array(1,6))]],[curve=[-38,0]]).
arc(arc00078,node00008,node00013,influence,[complete=true,name=i11,role=[use(none,in_hierarchy,[offb_even],array(1,6))]],[curve=[-56,0]]).
arc(arc00079,node00014,node00013,influence,[complete=true,name=i8,role=[use(none,in_hierarchy,theta,1)]],[curve=[-17,0]]).
arc(arc00080,node00014,node00011,influence,[complete=true,name=i9,role=[use(none,in_hierarchy,theta,1)]],[curve=[-36,0]]).
arc(arc00081,node00015,node00014,influence,[name=i2],[]).
arc(arc00083,node00006,node00016,influence,[complete=true,name=i48],[curve=[-76,-59]]).
arc(arc00084,node00010,node00016,influence,[complete=true,name=i50],[curve=[-20,-50]]).
arc(arc00085,node00008,node00016,influence,[complete=true,name=i52],[curve=[-94,-80]]).
arc(arc00086,node00012,node00016,influence,[complete=true,name=i54],[curve=[-35,-70]]).
arc(arc00087,node00016,node00004,influence,[complete=true,name=i61],[curve=[8,-3]]).
arc(arc00088,node00016,node00004,influence,[complete=true,name=i64],[curve=[8,0]]).
arc(arc00092,node00085,node00084,influence,[name=i21],[]).
arc(arc00093,node00087,node00086,influence,[name=i25],[]).
arc(arc00094,node00084,node00087,influence,[complete=true,name=i45,role=[use(none,in_hierarchy,side,1)]],[curve=[3,-4]]).
arc(arc00095,node00089,node00088,influence,[name=i26],[]).
arc(arc00096,node00084,node00089,influence,[complete=true,name=i46,role=[use(none,in_hierarchy,side,1)]],[curve=[5,-26]]).
arc(arc00097,node00090,node00087,influence,[complete=true,name=i41,role=[use(none,in_hierarchy,even_level,boolean)]],[curve=[6,16]]).
arc(arc00098,node00090,node00089,influence,[complete=true,name=i42,role=[use(none,in_hierarchy,even_level,boolean)]],[curve=[4,-2]]).
arc(arc00099,node00091,node00090,influence,[name=i27],[]).
arc(arc00100,node00092,node00087,influence,[complete=true,name=i47,role=[use(none,in_hierarchy,[offa_even],array(1,6))]],[curve=[-8,-6]]).
arc(arc00101,node00093,node00087,influence,[complete=true,name=i49,role=[use(none,in_hierarchy,[offa_odd],array(1,6))]],[curve=[-6,-14]]).
arc(arc00102,node00094,node00089,influence,[complete=true,name=i51,role=[use(none,in_hierarchy,[offb_even],array(1,6))]],[curve=[-8,-7]]).
arc(arc00103,node00095,node00089,influence,[complete=true,name=i53,role=[use(none,in_hierarchy,[offb_odd],array(1,6))]],[curve=[-8,-17]]).
arc(arc00104,node00086,node00096,influence,[complete=true,name=i59],[curve=[7,-4]]).
arc(arc00105,node00088,node00097,influence,[complete=true,name=i62],[curve=[8,0]]).
arc(arc00109,node00019,node00004,influence,[complete=true,name=i89],[curve=[-1,9]]).
arc(arc00110,node00020,node00019,influence,[name=i83],[]).

