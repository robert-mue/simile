source(program='AME',version= 9.0,edition=standard,date='Wed Feb 06 15:41:49 GMT 2008').

roots([node00002]).

properties([complete-true,file_name-'C:/Inetpub/wwwroot/www/examples/catalogue/models/bob/lagrangian1/lagrangian1.sml',name-lagrangian1,separate-0]).

node(node00002,submodel,[node00003,node00004,node00005,node00006,node00007,node00008,node00009,node00010,node00011,node00012,node00013,node00014,node00015,node00016,node00017,node00018,node00019,node00020,node00021,node00022,node00023,node00024],[complete=true,fill_colour='#ffff80',multiplication_spec=[type=population],name='PREDATOR',separate=0],[bounding_box=[48,36,345,268],caption_offset=[29,-10],internal_extent=[-6,-6,300,233]]).
node(node00003,compartment,[],[complete=true,name='XNW'],[caption_offset=[-1,-48],centre=[246,72]]).
node(node00004,compartment,[],[complete=true,name='Dir'],[caption_offset=[0,0],centre=[31,118]]).
node(node00005,compartment,[],[complete=true,min_val=0,name='Y'],[caption_offset=[0,0],centre=[252,169]]).
node(node00006,cloud,[],[complete=true,name=cd5],[centre=[123,70]]).
node(node00007,function,[],[complete=true,name=fn8,units=1,value=(if outside==1 then speed*cos(dir+ 3.14) else speed*cos(dir))],[]).
node(node00008,cloud,[],[complete=true,name=cd6],[centre=[130,116]]).
node(node00009,function,[],[complete=true,name=fn9,units=1,value=(if outside==1 then  3.14/dt(1) else (if (x>30,x<50,y<70) then  0.4*( 1.57-fmod(abs(dir), 6.28)) else  0.4*( 3.14-fmod(abs(dir), 6.28))+rand( -0.15, 0.15)/dt(1)))],[]).
node(node00010,cloud,[],[complete=true,name=cd7],[centre=[94,169]]).
node(node00011,function,[],[complete=true,name=fn10,units=1,value=(if outside==1 then speed*sin(dir+ 3.14) else speed*sin(dir))],[]).
node(node00012,variable,[],[complete=true,name=speed],[caption_offset=[10,-31],centre=[254,124]]).
node(node00013,function,[],[complete=true,name=fn11,units=1,value=5],[]).
node(node00014,variable,[],[complete=true,name=size],[caption_offset=[0,0],centre=[36,190]]).
node(node00015,function,[],[complete=true,name=fn1,units=1,value=1],[]).
node(node00016,variable,[],[complete=true,name=outside],[caption_offset=[34,-13],centre=[176,117]]).
node(node00017,function,[],[complete=true,name=fn21,units=1,value=(if max(abs(50-x),abs(50-y))>50 then 1 else 0)],[]).
node(node00018,immigration,[],[complete=true,name=im1],[caption_offset=[0,0],centre=[35,19]]).
node(node00019,function,[],[complete=true,name=fn1_0,units=1,value=10],[]).
node(node00020,loss,[],[complete=true,name=loss1],[caption_offset=[0,0],centre=[210,17]]).
node(node00021,function,[],[complete=true,name=fn2,units=boolean,value=(x<0)],[]).
node(node00022,function,[],[complete=true,units=1,value=80],[]).
node(node00023,function,[],[complete=true,units=1,value=rand(0, 6.28)],[]).
node(node00024,function,[],[complete=true,units=1,value=rand(10,90)],[]).

arc(arc00001,node00006,node00003,flow,[complete=true,name=xchange],[caption_offset=[-33,-39],curve=[550,495]]).
arc(arc00002,node00007,arc00001,influence,[complete=true,name=i8],[]).
arc(arc00009,node00004,node00007,influence,[complete=true,name=i13,role=[use(none,in_hierarchy,dir,1)]],[curve=[-11,-30]]).
arc(arc00003,node00008,node00004,flow,[complete=true,name=dirchange],[caption_offset=[-4,-38],curve=[550,500]]).
arc(arc00004,node00009,arc00003,influence,[complete=true,name=i9],[]).
arc(arc00019,node00004,node00009,influence,[complete=true,name=i1_0,role=[use(none,in_hierarchy,dir,1)]],[curve=[-1,-7]]).
arc(arc00020,node00003,node00009,influence,[complete=true,name=i2,role=[use(none,in_hierarchy,x,1)]],[curve=[10,33]]).
arc(arc00021,node00005,node00009,influence,[complete=true,name=i3,role=[use(none,in_hierarchy,y,1)]],[curve=[-12,35]]).
arc(arc00005,node00010,node00005,flow,[complete=true,name=ychange],[caption_offset=[-10,-1],curve=[550,500]]).
arc(arc00006,node00011,arc00005,influence,[complete=true,name=i10],[]).
arc(arc00010,node00004,node00011,influence,[complete=true,name=i14,role=[use(none,in_hierarchy,dir,1)]],[curve=[10,-28]]).
arc(arc00008,node00012,node00007,influence,[complete=true,name=i12,role=[use(none,in_hierarchy,speed,1)]],[curve=[-12,16]]).
arc(arc00011,node00012,node00011,influence,[complete=true,name=i15,role=[use(none,in_hierarchy,speed,1)]],[curve=[10,18]]).
arc(arc00007,node00013,node00012,influence,[complete=true,name=i11],[]).
arc(arc00012,node00015,node00014,influence,[complete=true,name=i1],[]).
arc(arc00016,node00016,node00007,influence,[complete=true,name=i55,role=[use(none,in_hierarchy,outside,1)]],[curve=[-8,-2]]).
arc(arc00017,node00016,node00009,influence,[complete=true,name=i56,role=[use(none,in_hierarchy,outside,1)]],[curve=[0,19]]).
arc(arc00018,node00016,node00011,influence,[complete=true,name=i57,role=[use(none,in_hierarchy,outside,1)]],[curve=[8,1]]).
arc(arc00013,node00017,node00016,influence,[complete=true,name=i52],[]).
arc(arc00014,node00003,node00017,influence,[complete=true,name=i53,role=[use(none,in_hierarchy,x,1)]],[curve=[6,10]]).
arc(arc00015,node00005,node00017,influence,[complete=true,name=i54,role=[use(none,in_hierarchy,y,1)]],[curve=[-10,12]]).
arc(arc00022,node00019,node00018,influence,[complete=true,name=i1_1],[]).
arc(arc00023,node00021,node00020,influence,[complete=true,name=i2_0],[]).
arc(arc00024,node00003,node00021,influence,[complete=true,name=i3_0,role=[use(none,in_hierarchy,x,1)]],[curve=[-4,5]]).
arc(arc00025,node00022,node00003,influence,[],[]).
arc(arc00026,node00023,node00004,influence,[],[]).
arc(arc00027,node00024,node00005,influence,[],[]).

