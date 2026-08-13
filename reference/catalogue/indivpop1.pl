source(program='AME',version= 9.0,edition=standard,date='Wed Feb 06 15:35:41 GMT 2008').

roots([node00002,node00015,node00016]).

properties([complete-true,file_name-'C:/Inetpub/wwwroot/www/examples/catalogue/models/bob/indivpop1/indivpop1.sml',name-indivpop1]).

node(node00002,submodel,[node00003,node00004,node00005,node00006,node00007,node00008,node00009,node00010,node00011,node00012,node00013,node00014,node00017,node00018,node00019,node00020],[complete=true,fill_colour='#ffbe9f',multiplication_spec=[type=population],name='Individual'],[bounding_box=[100,60,225,183],caption_offset=[34,-8],internal_extent=[0,0,125,123]]).
links(node00002,[arc00008-arc00009,arc00012-arc00011]).
node(node00003,creation,[],[complete=true,name='initial\npop size'],[caption_offset=[3,3],centre=[23,23]]).
node(node00004,function,[],[complete=true,name=fn1,units=1,value=2],[]).
node(node00005,reproduction,[],[complete=true,name=birth],[caption_offset=[4,0],centre=[65,24]]).
node(node00006,function,[],[complete=true,name=fn2,units=1,value=(if rand_var(0,1)<r then 1 else 0)],[]).
node(node00007,loss,[],[complete=true,name=death],[caption_offset=[6,-1],centre=[101,24]]).
node(node00008,function,[],[complete=true,name=fn3,spec=m,units=1,value=m],[]).
node(node00009,variable,[],[complete=true,name=r],[caption_offset=[-14,-9],centre=[47,69]]).
node(node00010,function,[],[complete=true,name=fn4,table_data=[file='/graph/',data=[ 0.2,0,400],indices=[0,20,400,0],current=[339,334,306,211,167,129,87,35,32,34,31,30,29,29,32,46,89,123,190,246,271],units=1,bounds=1,dims=21],units=day,value=graph(age)*(1-pop_size/100)],[]).
node(node00011,variable,[],[complete=true,name=m],[caption_offset=[4,-1],centre=[85,68]]).
node(node00012,function,[],[complete=true,name=fn5,table_data=[file='/graph/',data=[ 0.2,0,400],indices=[0,20,400,0],current=[230,233,241,251,263,280,304,320,341,344,354,354,353,352,344,332,312,292,275,263,241],units=1,bounds=1,dims=21],units=day,value=graph(age)],[]).
node(node00013,variable,[],[complete=true,name=one],[caption_offset=[0,0],centre=[109,66]]).
node(node00014,function,[],[complete=true,name=fn6,units=1,value=1],[]).
node(node00017,border,[],[name=var5],[centre=[125,72]]).
node(node00018,border,[],[name=var6],[centre=[125,94]]).
node(node00019,variable,[],[complete=true,name=age],[caption_offset=[0,0],centre=[62,96]]).
node(node00020,function,[],[complete=true,name=fn8,units=day,value=time(1)-init_time(1)],[]).
node(node00015,variable,[],[complete=true,name='pop size'],[caption_offset=[1,-31],centre=[251,131]]).
node(node00016,function,[],[complete=true,name=fn7,units=1,value=sum({one})],[]).

arc(arc00001,node00004,node00003,influence,[name=i1],[curve=[0,0]]).
arc(arc00002,node00006,node00005,influence,[name=i2],[curve=[0,0]]).
arc(arc00003,node00008,node00007,influence,[name=i3],[curve=[0,0]]).
arc(arc00013,node00009,node00006,influence,[complete=true,name=i13,role=[use(none,in_hierarchy,r,day)]],[curve=[-6,-2]]).
arc(arc00004,node00010,node00009,influence,[name=i4],[curve=[0,0]]).
arc(arc00010,node00011,node00008,influence,[complete=true,name=i10,role=[use(none,in_hierarchy,m,day)]],[curve=[-6,-2]]).
arc(arc00005,node00012,node00011,influence,[name=i5],[curve=[0,0]]).
arc(arc00006,node00014,node00013,influence,[name=i6],[curve=[0,0]]).
arc(arc00008,node00013,node00017,influence,[complete=true,name=i8],[curve=[1,-3]]).
arc(arc00011,node00018,node00010,influence,[complete=true,name=i11,role=[use(none,in_hierarchy,pop_size,1)]],[curve=[-6,18]]).
arc(arc00015,node00019,node00010,influence,[complete=true,name=i15,role=[use(none,in_hierarchy,age,day)]],[curve=[-4,2]]).
arc(arc00016,node00019,node00012,influence,[complete=true,name=i16,role=[use(none,in_hierarchy,age,day)]],[curve=[-5,-4]]).
arc(arc00014,node00020,node00019,influence,[name=i14],[curve=[0,0]]).
arc(arc00012,node00015,node00002,influence,[complete=true,name=i12],[curve=[4,4]]).
arc(arc00007,node00016,node00015,influence,[name=i7],[]).
arc(arc00009,node00002,node00016,influence,[complete=true,name=i9,role=[use(none,in_hierarchy,{one},list(1))]],[curve=[0,-6]]).

