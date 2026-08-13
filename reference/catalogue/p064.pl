source(program='AME',version= 9.0,edition=standard,date='Tue Feb 05 17:11:57 GMT 2008').

roots([node00002,node00003,node00004,node00005,node00006,node00007,node00008,node00009,node00010,node00011,node00012,node00013,node00014,node00015,node00016,node00017,node00018,node00019,node00020,node00021,node00022,node00023,node00024,node00025,node00026,node00027]).

properties([complete-true,file_name-'C:/Inetpub/wwwroot/www/examples/catalogue/models/ford/p064/p064.sim',name-p064,separate-0]).

node(node00002,compartment,[],[complete=true,name='size of\nsales force'],[caption_offset=[-60,-32],centre=[5,-3]]).
node(node00003,function,[],[complete=true,name=fn1,units=1,value=50],[]).
node(node00004,cloud,[],[complete=true,name=cd1],[centre=[8,114]]).
node(node00005,function,[],[complete=true,name=fn2,units=1*1,value=hiring_fraction*(budgeted_size_of_sales_force-size_of_sales_force)],[]).
node(node00006,cloud,[],[complete=true,name=cd2],[centre=[6,-100]]).
node(node00007,function,[],[complete=true,name=fn3,units=1*1,value=size_of_sales_force*exit_rate],[]).
node(node00008,variable,[],[complete=true,name='hiring fraction'],[caption_offset=[-24,-1],centre=[-41,77]]).
node(node00009,function,[],[complete=true,name=fn4,units=1,value=1],[]).
node(node00010,variable,[],[complete=true,name='exit rate'],[caption_offset=[-10,-31],centre=[-48,-86]]).
node(node00011,function,[],[complete=true,name=fn5,units=1,value= 0.2],[]).
node(node00012,variable,[],[complete=true,name='effectiveness in\nwidgets per day'],[caption_offset=[4,-50],centre=[126,-74]]).
node(node00013,function,[],[complete=true,name=fn6,table_data=[file='/graph/',data=[2,0,400],indices=[0,2000,400,0],current=[2,2,2,40,80,240,319,357,379,386,386],units=1,bounds=1,dims=11],units=1,value=graph(size_of_sales_force)],[]).
node(node00014,variable,[],[complete=true,name='widget sales'],[caption_offset=[0,0],centre=[118,-8]]).
node(node00015,function,[],[complete=true,name=fn7,units=1*1*1,value=size_of_sales_force*effectiveness_in_widgets_per_day*365],[]).
node(node00016,variable,[],[complete=true,name='widget price'],[caption_offset=[19,-35],centre=[213,-57]]).
node(node00017,function,[],[complete=true,name=fn8,units=1,value=100],[]).
node(node00018,variable,[],[complete=true,name='annual revenue\nin millions'],[caption_offset=[64,-26],centre=[195,10]]).
node(node00019,function,[],[complete=true,name=fn9,units=1*1/1,value=widget_sales*widget_price/1000000],[]).
node(node00020,variable,[],[complete=true,name='sales dept budget'],[caption_offset=[42,-3],centre=[180,84]]).
node(node00021,function,[],[complete=true,name=fn10,units=1*(1*1/1),value=fraction_to_sales*annual_revenue_in_millions],[]).
node(node00022,variable,[],[complete=true,name='fraction to sales'],[caption_offset=[18,-33],centre=[258,63]]).
node(node00023,function,[],[complete=true,name=fn11,units=1,value= 0.5],[]).
node(node00024,variable,[],[complete=true,name='budgeted size\nof sales force'],[caption_offset=[39,-50],centre=[102,85]]).
node(node00025,function,[],[complete=true,name=fn12,units=1*1/1,value=sales_dept_budget*1000000/average_salary],[]).
node(node00026,variable,[],[complete=true,name='average salary'],[caption_offset=[0,0],centre=[121,120]]).
node(node00027,function,[],[complete=true,name=fn13,units=1,value=25000],[]).

arc(arc00001,node00003,node00002,influence,[name=i1],[]).
arc(arc00002,node00004,node00002,flow,[complete=true,name=' new hires'],[caption_offset=[-10,-5],curve=[550,506]]).
arc(arc00003,node00005,arc00002,influence,[name=i2],[]).
arc(arc00019,node00002,node00005,influence,[complete=true,name=i17,role=[use(none,in_hierarchy,size_of_sales_force,1)]],[curve=[9,0]]).
arc(arc00004,node00002,node00006,flow,[complete=true,name=departures],[caption_offset=[-95,-7],curve=[550,648]]).
arc(arc00005,node00007,arc00004,influence,[name=i3],[]).
arc(arc00017,node00002,node00007,influence,[complete=true,name=i15,role=[use(none,in_hierarchy,size_of_sales_force,1)]],[curve=[-16,4]]).
arc(arc00018,node00008,node00005,influence,[complete=true,name=i16,role=[use(none,in_hierarchy,hiring_fraction,1)]],[curve=[-2,-8]]).
arc(arc00006,node00009,node00008,influence,[name=i4],[]).
arc(arc00016,node00010,node00007,influence,[complete=true,name=i14,role=[use(none,in_hierarchy,exit_rate,1)]],[curve=[4,-8]]).
arc(arc00007,node00011,node00010,influence,[name=i5],[]).
arc(arc00008,node00013,node00012,influence,[name=i6],[]).
arc(arc00021,node00002,node00013,influence,[complete=true,name=i19,role=[use(none,in_hierarchy,size_of_sales_force,1)]],[curve=[-14,-23]]).
arc(arc00009,node00015,node00014,influence,[name=i7],[]).
arc(arc00020,node00002,node00015,influence,[complete=true,name=i18,role=[use(none,in_hierarchy,size_of_sales_force,1)]],[curve=[-1,-21]]).
arc(arc00022,node00012,node00015,influence,[complete=true,name=i20,role=[use(none,in_hierarchy,effectiveness_in_widgets_per_day,1)]],[curve=[12,2]]).
arc(arc00010,node00017,node00016,influence,[name=i8],[]).
arc(arc00011,node00019,node00018,influence,[name=i9],[]).
arc(arc00023,node00014,node00019,influence,[complete=true,name=i21,role=[use(none,in_hierarchy,widget_sales,1)]],[curve=[2,-16]]).
arc(arc00024,node00016,node00019,influence,[complete=true,name=i22,role=[use(none,in_hierarchy,widget_price,1)]],[curve=[12,4]]).
arc(arc00012,node00021,node00020,influence,[name=i10],[]).
arc(arc00025,node00018,node00021,influence,[complete=true,name=i23,role=[use(none,in_hierarchy,annual_revenue_in_millions,1*1/1)]],[curve=[15,2]]).
arc(arc00026,node00022,node00021,influence,[complete=true,name=i24,role=[use(none,in_hierarchy,fraction_to_sales,1)]],[curve=[4,16]]).
arc(arc00013,node00023,node00022,influence,[name=i11],[]).
arc(arc00029,node00024,node00005,influence,[complete=true,name=i27,role=[use(none,in_hierarchy,budgeted_size_of_sales_force,1)]],[curve=[12,-24]]).
arc(arc00014,node00025,node00024,influence,[name=i12],[]).
arc(arc00027,node00020,node00025,influence,[complete=true,name=i25,role=[use(none,in_hierarchy,sales_dept_budget,1)]],[curve=[0,16]]).
arc(arc00028,node00026,node00025,influence,[complete=true,name=i26,role=[use(none,in_hierarchy,average_salary,1)]],[curve=[-6,3]]).
arc(arc00015,node00027,node00026,influence,[name=i13],[]).

