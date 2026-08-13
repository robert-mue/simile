source(program='AME',version=7.1,edition=enterprise,date='Wed Jun 25 14:35:15 GMT Daylight Time 2003').

roots([node00002]).

properties([complete-true,file_name-'C:/Inetpub/wwwroot/www/examples/catalogue/models/bob/move1/move1.sml',name-'Desktop',separate-0]).

node(node00002,submodel,[node00003,node00004,node00005,node00006,node00007,node00008,node00009,node00010,node00011,node00012,node00013,node00014,node00015,node00016,node00017,node00018,node00019,node00020],[complete=true,fill_colour='#ffb591',fix_math_args=0,multiplication_spec=[count=[10]],name='Individual'],[bounding_box=[-59,-14,120,143],caption_offset=[29,-10],hide_contents=0,internal_extent=[33,1,212,158]]).
node(node00003,compartment,[],[complete=true,name='X'],[bounding_box=[154,19,194,49],caption_offset=[-1,-48]]).
node(node00004,compartment,[],[complete=true,name='Dir'],[bounding_box=[42,59,82,89],caption_offset=[0,0]]).
node(node00005,compartment,[],[complete=true,name='Y'],[bounding_box=[158,110,198,140],caption_offset=[0,0]]).
node(node00006,cloud,[],[complete=true,name=cd5],[bounding_box=[85,24,109,48]]).
node(node00007,function,[],[complete=true,name=fn8,units=1,value=(if outside==1 then speed*cos(dir+3.14)else speed*cos(dir))],[]).
node(node00008,cloud,[],[complete=true,name=cd6],[bounding_box=[118,65,142,89]]).
node(node00009,function,[],[complete=true,name=fn9,units=1,value=(if outside==1 then 3.14/dt(1)else rand(-0.4,0.4)/dt(1))],[]).
node(node00010,cloud,[],[complete=true,name=cd7],[bounding_box=[88,111,112,135]]).
node(node00011,function,[],[complete=true,name=fn10,units=1,value=(if outside==1 then speed*sin(dir+3.14)else speed*sin(dir))],[]).
node(node00012,variable,[],[complete=true,name=speed],[bounding_box=[177,66,191,80],caption_offset=[10,-31]]).
node(node00013,function,[],[complete=true,name=fn11,units=1,value=5],[]).
node(node00014,variable,[],[complete=true,name=size],[bounding_box=[62,118,76,132],caption_offset=[0,0]]).
node(node00015,function,[],[complete=true,name=fn1,units=1,value=3],[]).
node(node00016,variable,[],[complete=true,name=outside],[bounding_box=[151,83,165,97],caption_offset=[29,-14]]).
node(node00017,function,[],[complete=true,name=fn21,units=1,value=(if (x<0;x>100;y<0;y>100)then 1 else 0)],[]).
node(node00018,function,[],[complete=true,units=1,value=rand(30,70)],[]).
node(node00019,function,[],[complete=true,units=1,value=rand(0,6.28)],[]).
node(node00020,function,[],[complete=true,units=1,value=rand(30,70)],[]).


arc(arc00001,node00006,node00003,flow,[complete=true,name=xchange],[bowtie=[124.5,24,136.5,48],caption_offset=[-23,-40],course=[[154,36],[107,36]]]).
arc(arc00002,node00007,arc00001,influence,[name=i8],[course=[[130,36],[130,36],[130,36]]]).
arc(arc00009,node00004,node00007,influence,[complete=true,name=i13,role=[use(none,in_hierarchy,dir,1)]],[course=[[124,39],[97,40],[82,62]]]).
arc(arc00003,node00008,node00004,flow,[complete=true,name=dirchange],[bowtie=[94.5,65,106.5,89],caption_offset=[-4,-38],course=[[82,77],[119,77]]]).
arc(arc00004,node00009,arc00003,influence,[name=i9],[course=[[100,77],[100,77],[100,77]]]).
arc(arc00005,node00010,node00005,flow,[complete=true,name=ychange],[bowtie=[128.0,111,140.0,135],caption_offset=[-10,-1],course=[[158,123],[110,123]]]).
arc(arc00006,node00011,arc00005,influence,[name=i10],[course=[[134,123],[134,123],[134,123]]]).
arc(arc00010,node00004,node00011,influence,[complete=true,name=i14,role=[use(none,in_hierarchy,dir,1)]],[course=[[128,118],[112,91],[82,87]]]).
arc(arc00008,node00012,node00007,influence,[complete=true,name=i12,role=[use(none,in_hierarchy,speed,1)]],[course=[[136,40],[149,65],[178,69]]]).
arc(arc00011,node00012,node00011,influence,[complete=true,name=i15,role=[use(none,in_hierarchy,speed,1)]],[course=[[140,117],[169,106],[179,77]]]).
arc(arc00007,node00013,node00012,influence,[name=i11],[course=[[-1,-1],[-1,-1],[-1,-1]]]).
arc(arc00012,node00015,node00014,influence,[name=i1],[course=[[-1,-1],[-1,-1],[-1,-1]]]).
arc(arc00016,node00016,node00007,influence,[complete=true,name=i55,role=[use(none,in_hierarchy,outside,1)]],[course=[[136,47],[136,69],[154,83]]]).
arc(arc00017,node00016,node00009,influence,[complete=true,name=i56,role=[use(none,in_hierarchy,outside,1)]],[course=[[106,78],[126,94],[151,88]]]).
arc(arc00018,node00016,node00011,influence,[complete=true,name=i57,role=[use(none,in_hierarchy,outside,1)]],[course=[[140,114],[151,107],[153,95]]]).
arc(arc00013,node00017,node00016,influence,[name=i52],[course=[[-1,-1],[-1,-1],[-1,-1]]]).
arc(arc00014,node00003,node00017,influence,[complete=true,name=i53,role=[use(none,in_hierarchy,x,1)]],[course=[[159,83],[172,68],[169,49]]]).
arc(arc00015,node00005,node00017,influence,[complete=true,name=i54,role=[use(none,in_hierarchy,y,1)]],[course=[[161,96],[161,105],[169,110]]]).
arc(arc00019,node00018,node00003,influence,[],[course=[[174,34],[174,34],[174,34]]]).
arc(arc00020,node00019,node00004,influence,[],[course=[[62,74],[62,74],[62,74]]]).
arc(arc00021,node00020,node00005,influence,[],[course=[[178,125],[178,125],[178,125]]]).

