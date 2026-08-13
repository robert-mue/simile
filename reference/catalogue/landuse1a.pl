source(program='AME',version=7.1,edition=enterprise,date='Wed Jun 25 14:28:59 GMT Daylight Time 2003').



roots([node00002,node00036,node00038,node00054,node00007,node00041,node00042]).



properties([comment-'21/08/02 this model gives good behaviour with a time step of 1',complete-true,file_name-'C:/Inetpub/wwwroot/www/examples/catalogue/models/bob/landuse1/landuse1a.sml',fix_math_args-0,multiplication_spec-[count=[]],name-'Desktop',separate-0]).



node(node00002,submodel,[node00003,node00004,node00005,node00006,node00008,node00009,node00026,node00027,node00028,node00029,node00030,node00031,node00032,node00033,node00034,node00035,node00037,node00039,node00040,node00043,node00044,node00045,node00056,node00057,node00059,node00061,node00063,node00064],[comment='21/08/02 this one works well with a time step of 1',complete=true,fill_colour='#ff8040',fix_math_args=0,multiplication_spec=[count=[225]],name='Patch',separate=0],[bounding_box=[69.97020854049995,-74.95431976212996,517.405163853698,246.70903674246998],caption_offset=[25.974180735000004,-10.989076464799998],hide_contents=0,internal_extent=[-22.914597815699118,0,424.52035749750127,321.66335650460064]]).

links(node00002,[arc00033-arc00032,arc00034-arc00040,arc00046-arc00048,arc00049-arc00051]).

references(node00002,[obsolete,obsolete,local(arc00018),local(arc00019)]).

node(node00003,variable,[],[complete=true,name='change\nto\nforest'],[bounding_box=[103.91261171780158,248.77457795500038,117.91261171780158,262.7745779550004],caption_offset=[-24.93530548900013,1.560229591000052]]).

node(node00004,submodel,[node00010,node00011,node00016,node00017,node00022,node00023,node00050,node00065,node00066,node00067],[complete=true,fill_colour='#80ff80',fix_math_args=0,multiplication_spec=[count=[]],name='Forest',separate=0],[bounding_box=[181.77457795480035,19.981132075459577,406.5511420068011,116.88480635619986],caption_offset=[16.98311817300001,-9.990069513400023],hide_contents=0,internal_extent=[0,0,224.77656405200125,96.90367428074028]]).

links(node00004,[arc00022-arc00025,arc00022-arc00052,arc00037-arc00036]).

node(node00010,compartment,[],[complete=true,name=volume],[bounding_box=[175.8053624630006,17.96722939424007,215.8053624630006,47.96722939424007],caption_offset=[0,0]]).

node(node00011,function,[],[complete=true,max_val=500,min_val=0,name=fn3,units=1,value=(if time(1)<1 then maxvol else rand_const(0,50))],[]).

node(node00016,cloud,[],[complete=true,name=cd1],[bounding_box=[72.91559086400031,24.963257199540074,96.9155908640003,48.963257199540074]]).

node(node00017,function,[],[complete=true,name=fn6,units=1,value=0.03*volume*(1-volume/maxvol)],[]).

node(node00022,condition,[],[complete=true,name=exists],[bounding_box=[25.959285006000197,16.968222442840023,55.95928500600021,46.96822244284005],caption_offset=[0,0]]).

node(node00023,function,[],[complete=true,name=fn9,units=boolean,value=(state==1)],[]).

node(node00050,variable,[],[name=var14],[]).

node(node00065,variable,[],[name=var2],[]).

node(node00066,variable,[],[complete=true,name=maxvol],[bounding_box=[162.89870903600305,68.95233366487003,176.89870903600305,82.95233366487003],caption_offset=[0,0]]).

node(node00067,function,[],[complete=true,name=fn2,units=1,value=rand_const(350,450)],[]).

node(node00005,submodel,[node00012,node00013,node00014,node00015,node00018,node00019,node00020,node00021,node00024,node00025,node00051,node00053],[complete=true,fill_colour='#eec877',fix_math_args=0,multiplication_spec=[count=[]],name='Crop',separate=0],[bounding_box=[176.77358490580042,153.84905660309997,403.54816286080097,257.7457795421003],caption_offset=[15.984111221000063,-10.989076464700048],hide_contents=0,internal_extent=[-6.993048660000028,0,219.7815292950005,103.89672293900031]]).

links(node00005,[arc00026-arc00027,arc00039-arc00038]).

node(node00012,compartment,[],[complete=true,name=biomass],[bounding_box=[162.81827209600036,6.978152929000029,202.81827209600036,36.97815292900003],caption_offset=[0,0]]).

node(node00013,function,[],[complete=true,max_val=20,min_val=0,name=fn4,units=1,value=rand_const(0,5)],[]).

node(node00014,compartment,[],[complete=true,name='time under crop'],[bounding_box=[122.85799404300033,55.92949354400014,162.85799404300033,85.92949354400014],caption_offset=[8.99106256200001,0.999006952000002]]).

node(node00015,function,[],[complete=true,name=fn5,units=1,value=0],[]).

node(node00018,cloud,[],[complete=true,name=cd2],[bounding_box=[52.93545183600018,9.97815292800001,76.93545183600018,33.978152928000014]]).

node(node00019,function,[],[complete=true,name=fn7,units=1,value=0.5*(1-biomass/20)],[]).

node(node00020,cloud,[],[complete=true,name=cd3],[bounding_box=[15.972194638000033,59.928500496000154,39.97219463800005,83.92850049600015]]).

node(node00021,function,[],[complete=true,name=fn8,units=int,value=1],[]).

node(node00024,condition,[],[complete=true,name=exists],[bounding_box=[12.97219463800009,9.975173783000024,42.97219463800012,39.975173783000024],caption_offset=[0,0]]).

node(node00025,function,[],[complete=true,name=fn10,units=boolean,value=(state==2)],[]).

node(node00051,variable,[],[name=var15],[]).

node(node00053,variable,[],[name=var6],[]).

node(node00006,function,[],[complete=true,name=fn1,units=1,value=(if state==2 and sum({time_under_crop})>20 then 1 else 0)],[]).

node(node00008,compartment,[],[complete=true,name=state],[bounding_box=[114.83018867880023,147.84011916609992,154.83018867880023,177.84011916609992],caption_offset=[13.000000000000057,1.0]]).

node(node00009,function,[],[complete=true,max_val=2,min_val=1,name=fn2,units=1,value=(if column==1 then 2 else 1)],[]).

node(node00026,variable,[],[complete=true,name=column],[bounding_box=[15.023833168800063,27.952333664379637,29.023833168800053,41.95233366437964],caption_offset=[10.00099304800004,-32.97120158890016]]).

node(node00027,function,[],[complete=true,name=fn11,units=1,value=fmod(index(1)-1,15)+1],[]).

node(node00028,variable,[],[complete=true,name='change\nto\ncrop'],[bounding_box=[93.92254220480153,73.94836147019959,107.92254220480153,87.94836147019959],caption_offset=[41.31349928500019,-36.15132446132019]]).

node(node00029,function,[],[name=fn12,units=1,value=sum({volume})],[]).

node(node00030,variable,[],[complete=true,name=row],[bounding_box=[62.999006950800194,28.944389275099564,76.99900695080021,42.94438927509958],caption_offset=[17.99106256200008,-17.01390268120007]]).

node(node00031,function,[],[complete=true,name=fn13,units=1,value=floor((index(1)-1)/15)+1],[]).

node(node00032,function,[],[complete=true,name=fn2_0,units=1,value=(if state==1 and(sum({volume})>250 and n_crop_neighbour>=2 and rand_var(0,1)<0.4)or column==1 and sum({volume})>350 and time(1)>0 or n_crop_neighbour>6 then 1 else 0)],[]).

node(node00033,function,[],[complete=true,name=fn14,units=int,value=0],[]).

node(node00034,variable,[],[complete=true,name='n\ncrop\nneighbour'],[bounding_box=[22.993048659801218,60.96127110266953,36.993048659801225,74.96127110266953],caption_offset=[6.9930486600000314,10.98907646480005]]).

node(node00035,function,[],[name=fn15,units=int,value=(if state==1 and sum({volume})>rand_var(250,400)and n_crop_neighbour>1.9 then 1 else 0)],[]).

node(node00037,function,[],[name=fn16,units=1,value=sum({time_under_crop})],[]).

node(node00039,function,[],[name=fn17,units=1,value=sum({biomass})],[]).

node(node00040,function,[],[complete=true,name=fn3,units=1,value=sum({crop_neighbour_0})],[]).

node(node00043,function,[],[name=fn19,units=int,value=(if state==2 and sum({time_under_crop})>100 then 1 else 0)],[]).

node(node00044,cloud,[],[complete=true,name=cd4],[bounding_box=[-2.9612711005999612,152.8381330680999,21.038728899400056,176.8381330680999]]).

node(node00045,function,[],[complete=true,name=fn20,units=1,value=(if change_to_crop==1 then 1/dt(1)elseif change_to_forest==1 then-1/dt(1)else 0)],[]).

node(node00056,variable,[],[name=var8],[]).

node(node00057,variable,[],[name=var9],[]).

node(node00059,variable,[],[name=var11],[]).

node(node00061,variable,[],[name=var13],[]).

node(node00063,variable,[],[complete=true,name=display],[bounding_box=[229.8300108028023,124.88759141312981,243.8300108028023,138.8875914131298],caption_offset=[0,0]]).

node(node00064,function,[],[complete=true,max_val=2,min_val=0,name=fn1_0,units=1,value=(if state==2 then 0 else sum({volume})/450+1)],[]).

node(node00036,function,[],[complete=false,name=fn1],[]).

node(node00038,function,[],[complete=false,name=fn1_0],[]).

node(node00054,function,[],[complete=false,name=fn2],[]).

node(node00007,function,[],[name=fn1,units=boolean,value=(! (column==column_0 and row==row_0)and abs(column-column_0)<1.5 and abs(row-row_0)<1.5)],[]).

node(node00041,function,[],[name=fn18,units=int,value=(if state==2 then 1 else 0)],[]).

node(node00042,submodel,[node00046,node00047,node00048,node00049,node00055,node00058,node00060,node00062],[complete=true,fill_colour='#80ffff',fix_math_args=0,multiplication_spec=[count=[]],name='Next to',separate=0],[bounding_box=[-65.73303746621998,-44.536270845,22.179574251779997,205.21546698990005],caption_offset=[20.979145978199995,-11.988083416099997],hide_contents=0,internal_extent=[19.980139026800003,0,107.8927507448,249.75173783489998]]).

links(node00042,[arc00031-arc00033,arc00040-arc00035,arc00048-arc00047,arc00051-arc00050]).

references(node00042,[local(arc00018),local(arc00019)]).

node(node00046,condition,[],[complete=true,name=condition],[bounding_box=[50.934458788499995,19.965243296899985,80.9344587885,49.965243296899985],caption_offset=[0,0]]).

node(node00047,function,[],[complete=true,name=fn4,units=boolean,value=(! (column==column_0 and row==row_0)and abs(column-column_0)<1.5 and abs(row-row_0)<1.5)],[]).

node(node00048,variable,[],[complete=true,name='crop\nneighbour'],[bounding_box=[63.91329422466,116.50641796260001,77.91329422465999,130.5064179626],caption_offset=[-7.160188725100014,-7.327328790999928]]).

node(node00049,function,[],[complete=true,name=fn5,units=1,value=(if state==2 then 1 else 0)],[]).

node(node00055,variable,[],[name=var7],[]).

node(node00058,variable,[],[name=var10],[]).

node(node00060,variable,[],[name=var12],[]).

node(node00062,variable,[],[name=var14],[]).





arc(arc00003,node00011,node00010,influence,[name=i3],[]).

arc(arc00006,node00016,node00010,flow,[complete=true,name=growth],[bowtie=[128.48957298900004,23.999006951299997,140.48957298900004,47.9990069513],caption_offset=[-59.0686819000003,-1.8109396895300165],course=[[175,35.9990069513],[93.97914597800006,35.9990069513]]]).

arc(arc00007,node00017,arc00006,influence,[name=i6],[]).

arc(arc00057,node00010,node00017,influence,[complete=true,name=i1,role=[use(none,in_hierarchy,volume,1)]],[course=[[140,30],[156.00198609799986,17.023833167799886],[175,24]]]).

arc(arc00012,node00023,node00022,influence,[name=i9],[]).

arc(arc00036,node00050,node00023,influence,[complete=true,name=i32,role=[use(none,in_hierarchy,state,1)]],[course=[[25,44],[8.49255213550028,59.31413869146905],[-0.7745779548000371,80.64714530747851]]]).

arc(arc00022,node00010,node00065,influence,[complete=true,name=i6_0],[course=[[-0.7745779547998382,64.01886792454042],[96.00000000000028,85.5],[175,42]]]).

arc(arc00054,node00066,node00011,influence,[complete=true,name=i5,role=[use(none,in_hierarchy,maxvol,1)]],[course=[[185,47],[173,54],[172,69]]]).

arc(arc00055,node00066,node00017,influence,[complete=true,name=i6_1,role=[use(none,in_hierarchy,maxvol,1),use(none,in_hierarchy,maxvol_0,1)]],[course=[[140,41],[145,61],[164,69]]]).

arc(arc00053,node00067,node00066,influence,[name=i4],[]).

arc(arc00004,node00013,node00012,influence,[name=i4],[]).

arc(arc00005,node00015,node00014,influence,[name=i5],[]).

arc(arc00008,node00018,node00012,flow,[complete=true,name=growth],[bowtie=[111.99602780549998,9.003972193999989,123.99602780549998,33.003972193999985],caption_offset=[-18.981132076000108,0.9990069509999842],course=[[161.99205561099996,21.00397219399999],[74,21.00397219399999]]]).

arc(arc00009,node00019,arc00008,influence,[name=i7],[]).

arc(arc00058,node00012,node00019,influence,[complete=true,name=i2,role=[use(none,in_hierarchy,biomass,1)]],[course=[[123,15],[140.00198609799997,0.031777557999831174],[162,14]]]).

arc(arc00010,node00020,node00014,flow,[complete=true,name=increment],[bowtie=[72.01588877899997,53.001986097,84.01588877899997,77.001986097],caption_offset=[-49.18211656700024,-0.9990069509999842],course=[[122.03177755799993,65.001986097],[34,65.001986097]]]).

arc(arc00011,node00021,arc00010,influence,[name=i8],[]).

arc(arc00013,node00025,node00024,influence,[name=i10],[]).

arc(arc00038,node00051,node00025,influence,[complete=true,name=i34,role=[use(none,in_hierarchy,state,1)]],[course=[[10.990069514000012,19.999006951000005],[2.995034757000006,15.499503475500003],[-7.765640516800602,17.152929493900047]]]).

arc(arc00026,node00014,node00053,influence,[complete=true,name=i8_0],[course=[[64.23336643419948,103.15094339690003],[91.00595829199992,98.02184706999987],[122,80]]]).

arc(arc00001,node00006,node00003,influence,[name=i1],[]).

arc(arc00027,node00005,node00006,influence,[complete=true,name=i9,role=[use(none,in_hierarchy,{time_under_crop},list(1))]],[course=[[116,256],[184.0,270.0],[248,257]]]).

arc(arc00037,node00008,node00004,influence,[complete=true,name=i33],[course=[[180.9999999999998,100.6282773829381],[147.49999999999994,111.8141386914691],[138,147]]]).

arc(arc00039,node00008,node00005,influence,[complete=true,name=i35],[course=[[176.00099304899985,171.00198609700007],[166.0004965244999,159.00099304850005],[154,160]]]).

arc(arc00041,node00008,node00006,influence,[complete=true,name=i19,role=[use(none,in_hierarchy,state,1)]],[course=[[111,248],[138,217],[130,177]]]).

arc(arc00002,node00009,node00008,influence,[name=i2],[]).

arc(arc00059,node00026,node00009,influence,[complete=true,name=i2_2,role=[use(none,in_hierarchy,column,1)]],[course=[[120,147],[100,69],[26,39]]]).

arc(arc00014,node00027,node00026,influence,[name=i11],[]).

arc(arc00016,node00031,node00030,influence,[name=i13],[]).

arc(arc00015,node00032,node00028,influence,[name=i2_0],[]).

arc(arc00025,node00004,node00032,influence,[complete=true,name=i7,role=[use(none,in_hierarchy,{volume},list(1))]],[course=[[106,82],[145.0,99.50000000000001],[181,84]]]).

arc(arc00042,node00008,node00032,influence,[complete=true,name=i20_0,role=[use(none,in_hierarchy,state,1)]],[course=[[102,86],[99,122],[127,147]]]).

arc(arc00060,node00026,node00032,influence,[complete=true,name=i3_1,role=[use(none,in_hierarchy,column,1)]],[course=[[93,76],[70,40],[28,37]]]).

arc(arc00028,node00034,node00032,influence,[complete=true,name=i10,role=[use(none,in_hierarchy,n_crop_neighbour,1)]],[course=[[93,76],[65.50347567050001,60.00297914598499],[35.00695134099998,67.00595829196998]]]).

arc(arc00017,node00040,node00034,influence,[name=i3],[]).

arc(arc00023,node00044,node00008,flow,[complete=true,name='change state'],[bowtie=[60.999999999999915,153.02482621599992,72.99999999999992,177.02482621599992],caption_offset=[-40.98113207500013,-44.002979146100216],course=[[113.99999999999983,165.02482621599992],[20,165.02482621599992]]]).

arc(arc00024,node00045,arc00023,influence,[name=i20],[]).

arc(arc00043,node00028,node00045,influence,[complete=true,name=i21,role=[use(none,in_hierarchy,change_to_crop,1)]],[course=[[70,153],[100,126],[97,86]]]).

arc(arc00044,node00003,node00045,influence,[complete=true,name=i22,role=[use(none,in_hierarchy,change_to_forest,1)]],[course=[[71,177],[70,221],[106,248]]]).

arc(arc00032,node00056,node00040,influence,[complete=true,name=i14,role=[use(2,in_assoc,{crop_neighbour},list(1)),use(3,in_assoc,{crop_neighbour_0},list(1))]],[course=[[22.006951340999983,70.00595829196998],[-7.496524329500009,73.002979145985],[-23.867924528199037,103.96921549199969]]]).

arc(arc00034,node00008,node00057,influence,[complete=true,name=i16],[course=[[-22,209],[45.93396226409952,218.5153922539999],[114,174]]]).

arc(arc00046,node00026,node00059,influence,[complete=true,name=i24],[course=[[-22,41],[-0.05759682190048565,47.52284011893532],[16,37]]]).

arc(arc00049,node00030,node00061,influence,[complete=true,name=i27],[course=[[-22.000000000000014,57.0],[24.441906653599506,67.02333664328529],[62.999006950999984,39.000993048699996]]]).

arc(arc00030,node00064,node00063,influence,[name=i1_1],[]).

arc(arc00045,node00008,node00064,influence,[complete=true,name=i2_1,role=[use(none,in_hierarchy,state,1)]],[course=[[229.06337723799987,131.98491018130002],[183.53168861899994,119.49245509065001],[151,147]]]).

arc(arc00052,node00004,node00064,influence,[complete=true,name=i3_0,role=[use(none,in_hierarchy,{volume},list(1))]],[course=[[231.06337723799987,125.98491018130004],[212.53168861899994,94.99245509064998],[181,84]]]).

arc(arc00018,node00002,node00042,relation,[complete=true,name=me],[caption_offset=[-0.27064424610000515,-18.336339403199993],course=[[21.4289724518,57.202414371],[44.214486225899954,73.10120718550002],[69,57]]]).

arc(arc00019,node00002,node00042,relation,[complete=true,name='my\nneighbour'],[caption_offset=[23.504761674599994,4.647098329399981],course=[[21.4289724518,76.202414371],[42.21647232309996,95.10120718550013],[69,82]]]).

arc(arc00033,node00042,node00002,influence,[complete=true,name=i15],[course=[[69.01688182799998,29.014895729870005],[36.15185266749,21.73931244243503],[21.286823506980006,47.463729155000024]]]).

arc(arc00040,node00002,node00042,influence,[complete=true,name=i18],[course=[[21.20241437098,125.42897245190002],[46.0436103635895,145.73732634488505],[70.88480635619898,134.0456802378699]]]).

arc(arc00048,node00002,node00042,influence,[complete=true,name=i26],[course=[[21.286823506980006,-25.536270844999983],[49.58581493158952,-17.745295303564657],[70.88480635619901,-33.95431976212933]]]).

arc(arc00051,node00002,node00042,influence,[complete=true,name=i29],[course=[[21.20241437098,-18.5710275481],[48.543610363589515,-6.262673655114703],[70.88480635619901,-17.95431976212941]]]).

arc(arc00020,node00047,node00046,influence,[name=i4],[]).

arc(arc00021,node00049,node00048,influence,[name=i5],[]).

arc(arc00031,node00048,node00055,influence,[complete=true,name=i13],[course=[[107.0,92.0],[86.03013271308,94.83910769040001],[72.97585629016,115.64345867770001]]]).

arc(arc00035,node00058,node00049,influence,[complete=true,name=i17,role=[use(0,in_base,state,1),use(1,in_base,state_0,1)]],[course=[[73.97585629016,127.64345867770001],[90.98792814508,157.31974324085002],[106.915590864,169.96524329689998]]]).

arc(arc00047,node00060,node00047,influence,[complete=true,name=i25,role=[use(0,in_base,column,1),use(1,in_base,column_0,1)]],[course=[[80,32],[95.042204568,30.517378351550008],[107,19]]]).

arc(arc00050,node00062,node00047,influence,[complete=true,name=i28,role=[use(0,in_base,row,1),use(1,in_base,row_0,1)]],[course=[[80,31],[94,35],[106.915590864,25.965243296899985]]]).


