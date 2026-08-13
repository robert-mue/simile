source(program='AME',version= 9.0,edition=standard,date='Tue Feb 05 17:20:32 GMT 2008').

roots([node00001,node00007,node00008,node00010,node00011,node00012,node00017,node00018,node00019]).

properties([complete-true,name-drainage1]).

node(node00001,submodel,[node00002,node00004,node00005,node00006,node00009,node00013,node00014,node00015,node00016,node00020,node00021,node00022,node00024,node00027,node00054,node00055,node00073,node00082,node00083],[complete=true,enum_types=[''-[]],fill_colour=white,image_posn=none,multiplication_spec=[count=[10000]],name=cell,separate=0],[bounding_box=[-20,-24,342,353],caption_offset=[0,0],internal_extent=[-81,0,281,377]]).
links(node00001,[arc00006-arc00007,arc00017-arc00016,arc00019-arc00018,arc00019-arc00023,arc00021-arc00020,arc00021-arc00026]).
references(node00001,[obsolete,obsolete]).
node(node00002,variable,[],[comment='int(rand_const(0,10))+1',complete=true,name=height,param_type=file,units=1],[caption_offset=[0,-1],centre=[232,82]]).
node(node00004,variable,[],[comment='-1 if no lower neighbour',complete=true,description='Bearing from north to lower neighbour (degrees)',name='flow direction'],[caption_offset=[0,0],centre=[194,290]]).
node(node00005,function,[],[complete=true,name=fn2,spec='if nid_min== 1 then 225\nelseif  nid_min== 2 then 180\nelseif  nid_min== 3 then 135\nelseif  nid_min== 4 then 270\nelseif  nid_min== 6 then 90\nelseif  nid_min== 7 then 315\nelseif  nid_min== 8 then 0\nelseif  nid_min== 9 then 45\nelse -1',units=int,value=(if nid_min==1 then 225 elseif nid_min==2 then 180 elseif nid_min==3 then 135 elseif nid_min==4 then 270 elseif nid_min==6 then 90 elseif nid_min==7 then 315 elseif nid_min==8 then 0 elseif nid_min==9 then 45 else -1)],[]).
node(node00006,function,[],[complete=true,name=fn1,spec='int(rand_const(0,10)+1)',units=1,value=int(rand_const(0,10)+1)],[]).
node(node00009,border,[],[name=var2],[centre=[281,119]]).
node(node00013,variable,[],[complete=true,name=col],[caption_offset=[0,0],centre=[177,20]]).
node(node00014,function,[],[complete=true,name=fn5,spec='index(1)-(row-1)*x_length',units=int,value=index(1)-(row-1)*x_length],[]).
node(node00015,variable,[],[complete=true,name=row],[caption_offset=[0,0],centre=[248,33]]).
node(node00016,function,[],[complete=true,name=fn6,spec='int((index(1)-1)/y_length)+1',units=int,value=int((index(1)-1)/y_length)+1],[]).
node(node00020,border,[],[name=var6],[centre=[281,156]]).
node(node00021,border,[],[name=var4],[centre=[156,0]]).
node(node00022,border,[],[name=var5],[centre=[230,0]]).
node(node00024,border,[],[name=var7],[centre=[156,0]]).
node(node00027,border,[],[name=var11],[centre=[230,0]]).
node(node00054,variable,[],[comment='If there is no lower neighbour the value will be the the Neighbour ID of itself, i.e. 5. The Neighbour ID is the index of the "neighbours and self" submodel instances.',complete=true,description='Neighbour ID of the lowest neighbour',name=nid_min],[caption_offset=[0,0],centre=[81,277]]).
node(node00055,function,[],[complete=true,name=fn9,spec='posleast([h])',units=int,value=posleast([h])],[]).
node(node00073,submodel,[node00003,node00023,node00025,node00026,node00046,node00047,node00048,node00074,node00075,node00076,node00077,node00078,node00079,node00080,node00081],[comment='Index codes direction to neighbour or if to self:\n1 SW, 2 S, 3 SE, 4 W, 5 self, 6 E, 7 NW, 8 N, NE',complete=true,enum_types=[],fill_colour=white,image_posn=none,multiplication_spec=[count=[9]],name='neighbours and self',separate=0],[bounding_box=[-59,59,190,231],caption_offset=[0,0],internal_extent=[0,4,249,176]]).
links(node00073,[arc00016-arc00043,arc00023-arc00022,arc00023-arc00024,arc00026-arc00025,arc00042-arc00001,arc00078-arc00077,arc00080-arc00079]).
references(node00073,[ancestor(0),ancestor(1),obsolete]).
node(node00003,border,[],[name=var1],[centre=[133,176]]).
node(node00023,border,[],[name=var6],[centre=[188,4]]).
node(node00025,border,[],[name=var9],[centre=[188,4]]).
node(node00026,border,[],[name=var10],[centre=[238,7]]).
node(node00046,variable,[],[comment='Height is assigned the value  1.0E+300 if the "neighbours" will be outside the grid.',complete=true,description='Height of the cell''s neighbours and itself',name=h],[caption_offset=[0,0],centre=[164,98]]).
node(node00047,function,[],[complete=true,name=fn4,spec='if col>=1 and col<=x_length and row>=1 and row<=y_length then element([h],nid) else 1.0E+300',units=1,value=(if col>=1 and col<=x_length and row>=1 and row<=y_length then element([h],nid) else  1.0e+300)],[]).
node(node00048,border,[],[name=var2],[centre=[249,88]]).
node(node00074,variable,[],[comment='If the cell is at the edge of the grid some of the "neighbours" will be outside the grid.',complete=true,description='Column of the cells neighbour''s and itself',name=col],[caption_offset=[0,0],centre=[61,28]]).
node(node00075,function,[],[complete=true,name=fn1,spec='col+element([-1,0,1,-1,0,1,-1,0,1],index(1))',units=int,value=col+element([-1,0,1,-1,0,1,-1,0,1],index(1))],[]).
node(node00076,variable,[],[comment='If the cell is at the edge of the grid some of the "neighbours" will be outside the grid.',complete=true,description='Row of the cells neighbour''s and itself',name=row],[caption_offset=[-12,-32],centre=[176,48]]).
node(node00077,function,[],[complete=true,name=fn2,spec='row+element([-1,-1,-1,0,0,0,1,1,1],index(1))',units=int,value=row+element([-1,-1,-1,0,0,0,1,1,1],index(1))],[]).
node(node00078,border,[],[name=var7],[centre=[163,4]]).
node(node00079,border,[],[name=var8],[centre=[224,4]]).
node(node00080,variable,[],[comment='If the cell is at the edge of the grid some of the "neighbours" will be outside the grid',complete=true,description='ID of the cell''s neighbours and itself',name=nid],[caption_offset=[0,0],centre=[107,96]]).
node(node00081,function,[],[complete=true,name=fn3,spec='x_length*(row-1)+col',units=int,value=x_length*(row-1)+col],[]).
node(node00082,variable,[],[complete=true,name=id],[caption_offset=[0,0],centre=[101,18]]).
node(node00083,function,[],[complete=true,name=fn4,spec='index(1)',units=int,value=index(1)],[]).
node(node00007,variable,[],[comment='Outside the cell submodel to provide an array of heights the elements of which are addressable from inside /cell and "/cell/neighbours and self" .  (Inside a submodel only values for the currenent instance is accessable.)',complete=true,description='Height array',name=h],[caption_offset=[0,0],centre=[394,121]]).
node(node00008,function,[],[complete=true,name=fn1,spec='[height]',units=array(1,10000),value=[height]],[]).
node(node00010,variable,[],[complete=true,name='N_cells'],[caption_offset=[0,0],centre=[82,-71]]).
node(node00011,function,[],[complete=true,name=fn2,spec='size(cell)',units=int,value=size(cell)],[]).
node(node00012,variable,[],[complete=true,name=x_length],[caption_offset=[0,0],centre=[167,-72]]).
node(node00017,function,[],[complete=true,name=fn3,spec='100',units=int,value=100],[]).
node(node00018,variable,[],[complete=true,name=y_length],[caption_offset=[0,0],centre=[264,-72]]).
node(node00019,function,[],[complete=true,name=fn4,spec='N_cells/x_length',units=1,value='N_cells'/x_length],[]).

arc(arc00002,node00005,node00004,influence,[name=i2],[]).
arc(arc00003,node00006,node00002,influence,[name=i6],[]).
arc(arc00006,node00002,node00009,influence,[complete=true,name=i3],[curve=[12,-8]]).
arc(arc00010,node00014,node00013,influence,[name=i8],[]).
arc(arc00012,node00015,node00014,influence,[complete=true,name=i1,role=[use(none,in_hierarchy,row,int)]],[curve=[-2,-8]]).
arc(arc00011,node00016,node00015,influence,[name=i9],[]).
arc(arc00018,node00021,node00014,influence,[complete=true,name=i14,role=[use(none,in_hierarchy,x_length,int)]],[curve=[4,-4]]).
arc(arc00020,node00022,node00016,influence,[complete=true,name=i16,role=[use(none,in_hierarchy,y_length,1)]],[curve=[7,-3]]).
arc(arc00015,node00054,node00005,influence,[complete=true,name=i5,role=[use(none,in_hierarchy,nid_min,int)]],[curve=[7,-12]]).
arc(arc00049,node00055,node00054,influence,[name=i18],[]).
arc(arc00001,node00073,node00055,influence,[complete=true,name=i4,role=[use(none,in_hierarchy,usr([h]),array(1,9))]],[curve=[9,-18]]).
arc(arc00016,node00020,node00073,influence,[complete=true,name=i7],[curve=[-72,-10]]).
arc(arc00023,node00024,node00073,influence,[complete=true,name=i19],[curve=[6,10]]).
arc(arc00026,node00027,node00073,influence,[complete=true,name=i22],[curve=[16,13]]).
arc(arc00078,node00013,node00073,influence,[complete=true,name=i11],[curve=[-20,14]]).
arc(arc00080,node00015,node00073,influence,[complete=true,name=i13],[curve=[-6,1]]).
arc(arc00042,node00046,node00003,influence,[complete=true,name=i13],[curve=[-12,-14]]).
arc(arc00024,node00025,node00047,influence,[complete=true,name=i20,role=[use(none,in_hierarchy,x_length,int)]],[curve=[22,6]]).
arc(arc00025,node00026,node00047,influence,[complete=true,name=i21,role=[use(none,in_hierarchy,y_length,1)]],[curve=[22,18]]).
arc(arc00036,node00047,node00046,influence,[name=i1],[]).
arc(arc00043,node00048,node00047,influence,[complete=true,name=i7,role=[use(none,in_hierarchy,[h],array(1,10000))]],[curve=[-9,-12]]).
arc(arc00041,node00074,node00047,influence,[complete=true,name=i3,role=[use(none,in_hierarchy,col,int)]],[curve=[22,-24]]).
arc(arc00075,node00075,node00074,influence,[name=i8],[]).
arc(arc00037,node00076,node00047,influence,[complete=true,name=i2,role=[use(none,in_hierarchy,row,int)]],[curve=[12,0]]).
arc(arc00076,node00077,node00076,influence,[name=i9],[]).
arc(arc00077,node00078,node00075,influence,[complete=true,name=i10,role=[use(none,in_hierarchy,col,int)]],[curve=[-14,0]]).
arc(arc00079,node00079,node00077,influence,[complete=true,name=i12,role=[use(none,in_hierarchy,usr(row),int)]],[curve=[8,5]]).
arc(arc00044,node00080,node00047,influence,[complete=true,name=i11,role=[use(none,in_hierarchy,nid,int)]],[curve=[6,-11]]).
arc(arc00022,node00023,node00081,influence,[complete=true,name=i18,role=[use(none,in_hierarchy,x_length,int)]],[curve=[-20,-24]]).
arc(arc00081,node00081,node00080,influence,[name=i14],[]).
arc(arc00083,node00076,node00081,influence,[complete=true,name=i16,role=[use(none,in_hierarchy,usr(row),int)]],[curve=[-12,-12]]).
arc(arc00084,node00074,node00081,influence,[complete=true,name=i17,role=[use(none,in_hierarchy,col,int)]],[curve=[12,-13]]).
arc(arc00082,node00083,node00082,influence,[name=i15],[]).
arc(arc00017,node00007,node00001,influence,[complete=true,name=i8],[curve=[-8,2]]).
arc(arc00005,node00008,node00007,influence,[name=i1],[]).
arc(arc00007,node00001,node00008,influence,[complete=true,name=i4,role=[use(none,in_hierarchy,[height],array(1,10000))]],[curve=[0,7]]).
arc(arc00004,node00011,node00010,influence,[name=i7],[]).
arc(arc00019,node00012,node00001,influence,[complete=true,name=i15],[curve=[10,-12]]).
arc(arc00008,node00017,node00012,influence,[name=i9],[]).
arc(arc00021,node00018,node00001,influence,[complete=true,name=i17],[curve=[10,-6]]).
arc(arc00009,node00019,node00018,influence,[name=i10],[]).
arc(arc00013,node00012,node00019,influence,[complete=true,name=i11,role=[use(none,in_hierarchy,x_length,int)]],[curve=[1,-20]]).
arc(arc00014,node00010,node00019,influence,[complete=true,name=i12,role=[use(none,in_hierarchy,'N_cells',int)]],[curve=[0,-42]]).

