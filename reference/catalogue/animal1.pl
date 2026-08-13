source(program='AME',version= 9.0,edition=standard,date='Mon Feb 04 23:18:48 GMT 2008').

roots([node00002,node00003,node00004]).

properties([complete-true,file_name-'C:/Inetpub/wwwroot/www/examples/catalogue/models/bob/animal1/animal1.sml',name-animal1]).

node(node00002,submodel,[node00005,node00006,node00007,node00008,node00009,node00010,node00011,node00012,node00013,node00027,node00028,node00029,node00030,node00031,node00032,node00033,node00034,node00035,node00036,node00037,node00038,node00039,node00040,node00041,node00042,node00043,node00044],[complete=true,fill_colour='#ffff80',multiplication_spec=[type=population],name='ANIMAL'],[bounding_box=[24,18,327,269],caption_offset=[42,-7],internal_extent=[-8,-3,260,219]]).
links(node00002,[arc00005-arc00007]).
node(node00005,creation,[],[complete=true,name=create],[caption_offset=[0,0],centre=[26,27]]).
node(node00006,function,[],[complete=true,name=fn1,units=1,value=100],[]).
node(node00007,reproduction,[],[complete=true,name=r],[caption_offset=[0,0],centre=[68,28]]).
node(node00008,function,[],[complete=true,name=fn2,spec=[114,97,110,100,40,48,44,50,42,48,46,55,41],units=1,value=rand(0,2* 0.7)],[]).
node(node00009,loss,[],[complete=true,name=m],[caption_offset=[0,0],centre=[106,29]]).
node(node00010,function,[],[complete=true,name=fn3,spec=[48,46,54],units=1,value= 0.6],[]).
node(node00011,variable,[],[complete=true,name=one],[caption_offset=[0,0],centre=[153,27]]).
node(node00012,function,[],[complete=true,name=fn4,units=1,value=1],[]).
node(node00013,border,[],[name=var3],[centre=[191,-3]]).
node(node00027,compartment,[],[complete=true,name='XNW'],[caption_offset=[-1,-48],centre=[220,87]]).
node(node00028,compartment,[],[complete=true,name='Dir'],[caption_offset=[0,0],centre=[20,134]]).
node(node00029,compartment,[],[complete=true,name='Y'],[caption_offset=[0,0],centre=[220,182]]).
node(node00030,cloud,[],[complete=true,name=cd5],[centre=[93,88]]).
node(node00031,function,[],[complete=true,name=fn8,units=1,value=(if outside==1 then speed*cos(dir+ 3.14) else speed*cos(dir))],[]).
node(node00032,cloud,[],[complete=true,name=cd6],[centre=[99,134]]).
node(node00033,function,[],[complete=true,name=fn9,units=1,value=(if outside==1 then  3.14/dt(1) else rand( -0.4, 0.4)/dt(1))],[]).
node(node00034,cloud,[],[complete=true,name=cd7],[centre=[95,186]]).
node(node00035,function,[],[complete=true,name=fn10,units=1,value=(if outside==1 then speed*sin(dir+ 3.14) else speed*sin(dir))],[]).
node(node00036,variable,[],[complete=true,name=speed],[caption_offset=[10,-31],centre=[212,140]]).
node(node00037,function,[],[complete=true,name=fn11,units=1,value=5],[]).
node(node00038,variable,[],[complete=true,name=size],[caption_offset=[0,0],centre=[40,192]]).
node(node00039,function,[],[complete=true,name=fn1,units=1,value=3],[]).
node(node00040,variable,[],[complete=true,name=outside],[caption_offset=[-28,-4],centre=[158,142]]).
node(node00041,function,[],[complete=true,name=fn21,units=1,value=(if (x<0;x>100;y<0;y>100) then 1 else 0)],[]).
node(node00042,function,[],[complete=true,units=1,value=rand(30,70)],[]).
node(node00043,function,[],[complete=true,units=1,value=rand(0, 6.28)],[]).
node(node00044,function,[],[complete=true,units=1,value=rand(30,70)],[]).
node(node00003,variable,[],[complete=true,name='N'],[caption_offset=[15,-21],centre=[295,-6]]).
node(node00004,function,[],[complete=true,name=fn12,units=1,value=sum({one})],[]).

arc(arc00001,node00006,node00005,influence,[name=i1],[curve=[0,0]]).
arc(arc00002,node00008,node00007,influence,[name=i2],[curve=[0,0]]).
arc(arc00003,node00010,node00009,influence,[name=i3],[curve=[0,0]]).
arc(arc00004,node00012,node00011,influence,[name=i4],[curve=[0,0]]).
arc(arc00005,node00011,node00013,influence,[complete=true,name=i6],[curve=[4,6]]).
arc(arc00022,node00030,node00027,flow,[complete=true,name=xchange],[caption_offset=[-23,-40],curve=[550,495]]).
arc(arc00023,node00031,arc00022,influence,[name=i8],[curve=[0,0]]).
arc(arc00030,node00028,node00031,influence,[complete=true,name=i13,role=[use(none,in_hierarchy,dir,1)]],[curve=[-24,-66]]).
arc(arc00024,node00032,node00028,flow,[complete=true,name=dirchange],[caption_offset=[-4,-38],curve=[550,500]]).
arc(arc00025,node00033,arc00024,influence,[name=i9],[curve=[0,0]]).
arc(arc00026,node00034,node00029,flow,[complete=true,name=ychange],[caption_offset=[-10,-1],curve=[550,500]]).
arc(arc00027,node00035,arc00026,influence,[name=i10],[curve=[0,0]]).
arc(arc00031,node00028,node00035,influence,[complete=true,name=i14,role=[use(none,in_hierarchy,dir,1)]],[curve=[5,2]]).
arc(arc00029,node00036,node00031,influence,[complete=true,name=i12,role=[use(none,in_hierarchy,speed,1)]],[curve=[-10,12]]).
arc(arc00032,node00036,node00035,influence,[complete=true,name=i15,role=[use(none,in_hierarchy,speed,1)]],[curve=[9,12]]).
arc(arc00028,node00037,node00036,influence,[name=i11],[curve=[0,0]]).
arc(arc00033,node00039,node00038,influence,[name=i1],[curve=[0,0]]).
arc(arc00037,node00040,node00031,influence,[complete=true,name=i55,role=[use(none,in_hierarchy,outside,1)]],[curve=[-12,-4]]).
arc(arc00038,node00040,node00033,influence,[complete=true,name=i56,role=[use(none,in_hierarchy,outside,1)]],[curve=[-4,12]]).
arc(arc00039,node00040,node00035,influence,[complete=true,name=i57,role=[use(none,in_hierarchy,outside,1)]],[curve=[0,-2]]).
arc(arc00034,node00041,node00040,influence,[name=i52],[curve=[0,0]]).
arc(arc00035,node00027,node00041,influence,[complete=true,name=i53,role=[use(none,in_hierarchy,x,1)]],[curve=[6,7]]).
arc(arc00036,node00029,node00041,influence,[complete=true,name=i54,role=[use(none,in_hierarchy,y,1)]],[curve=[-6,4]]).
arc(arc00040,node00042,node00027,influence,[],[curve=[0,0]]).
arc(arc00041,node00043,node00028,influence,[],[curve=[0,0]]).
arc(arc00042,node00044,node00029,influence,[],[curve=[0,0]]).
arc(arc00006,node00004,node00003,influence,[name=i22],[]).
arc(arc00007,node00002,node00004,influence,[complete=true,name=i23,role=[use(none,in_hierarchy,{one},list(1))]],[curve=[-15,-13]]).

