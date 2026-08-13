source(program='AME',version= 9.0,edition=standard,date='Wed Feb 06 17:22:40 GMT 2008').

roots([node00012,node00013,node00014,node00015,node00016]).

properties([complete-true,file_name-'/win98/Program Files/Simile/Develop/Library/horatio2.sml',fill_colour-'#d4f088',fix_math_args-0,image_posn-none,min_val-0,multiplication_spec-[count=[]],name-primes,separate-0,units-1,value- 0.5]).

node(node00012,submodel,[node00017,node00018,node00019,node00020,node00021,node00022],[complete=true,enum_types=[],fill_colour='#b8c0e6',image_posn=none,multiplication_spec=[count=[500000]],name=primes,separate=0],[bounding_box=[30,45,525,300],caption_offset=[0,0],internal_extent=[0,0,495,255]]).
links(node00012,[arc00015-arc00046,arc00043-arc00013,arc00044-arc00042]).
node(node00017,variable,[],[complete=true,max_val=1000,min_val=0,name='start\nprime',spec='3',units=int,value=3],[caption_offset=[0,0],centre=[435,150]]).
node(node00018,border,[],[name=var2],[centre=[495,112]]).
node(node00019,function,[],[complete=true,name=fn2,spec='if index(1)==1 then 5 else element([all_primes],index(1)-1)+2',units=int,value=(if index(1)==1 then 5 else element([all_primes],index(1)-1)+2)],[]).
node(node00020,border,[],[name=var3],[centre=[495,124]]).
node(node00021,submodel,[node00023,node00024,node00025,node00026,node00027,node00028,node00029,node00030,node00031,node00032],[complete=true,enum_types=[],fill_colour='#eedbae',image_posn=none,multiplication_spec=[count=[]],name='higher numbers',separate=0],[bounding_box=[30,15,390,240],caption_offset=[0,0],internal_extent=[0,0,360,225]]).
links(node00021,[arc00014-arc00034,arc00036-arc00015,arc00042-arc00038]).
node(node00023,submodel,[node00033,node00034,node00035,node00036,node00037,node00038,node00039,node00040,node00041,node00042,node00043,node00044,node00045,node00046],[complete=true,enum_types=[],fill_colour='#d6e1d3',image_posn=none,multiplication_spec=[count=[]],name=divisors,separate=0],[bounding_box=[30,30,240,210],caption_offset=[2,1],internal_extent=[0,0,210,180]]).
links(node00023,[arc00016-arc00032,arc00037-arc00029,arc00038-arc00023,arc00039-arc00030]).
node(node00033,border,[],[name=var1],[centre=[210,21]]).
node(node00034,variable,[],[complete=true,name='found divisor'],[caption_offset=[0,0],centre=[150,30]]).
node(node00035,function,[],[complete=true,name=fn3,units=boolean,value=(fmod(prime_0,quotient)==0)],[]).
node(node00036,alarm,[],[complete=true,name='done checks'],[caption_offset=[0,0],centre=[120,150]]).
node(node00037,function,[],[complete=true,name=fn5,spec='found_divisor or  quotient>check_limit',units=boolean,value=(found_divisor or quotient>check_limit)],[]).
node(node00038,variable,[],[complete=true,name=which],[caption_offset=[0,0],centre=[60,135]]).
node(node00039,function,[],[complete=true,name=fn1,spec='if done_checks then 0 else prev(0)+1',units=int,value=(if done_checks then 0 else prev(0)+1)],[]).
node(node00040,variable,[],[name=var3],[caption_offset=[0,0],centre=[75,75]]).
node(node00041,function,[],[name=fn2],[]).
node(node00042,border,[],[name=var4],[centre=[210,73]]).
node(node00043,variable,[],[complete=true,name=quotient],[caption_offset=[0,0],centre=[60,45]]).
node(node00044,function,[],[complete=true,name=fn7,spec='if which==0 then 3 else element([all_primes],which)',units=int,value=(if which==0 then 3 else element([all_primes],which))],[]).
node(node00045,border,[],[name=var8],[centre=[210,54]]).
node(node00046,border,[],[name=var12],[centre=[210,139]]).
node(node00024,alarm,[],[complete=true,name='found prime'],[caption_offset=[0,0],centre=[285,45]]).
node(node00025,function,[],[complete=true,name=fn1,spec='not found_divisor',units=boolean,value=not found_divisor],[]).
node(node00026,function,[],[complete=true,name=fn3,spec='if found_prime then start_prime else prev(0)+2',units=int,value=(if found_prime then start_prime else prev(0)+2)],[]).
node(node00027,border,[],[],[centre=[360,126]]).
node(node00028,border,[],[],[centre=[360,115]]).
node(node00029,variable,[],[complete=true,max_val=1000,min_val=0,name=prime,spec='95',units=int,value=95],[caption_offset=[0,0],centre=[330,120]]).
node(node00030,border,[],[name=var5],[centre=[360,101]]).
node(node00031,variable,[],[complete=true,name='check\nlimit'],[caption_offset=[0,0],centre=[270,165]]).
node(node00032,function,[],[complete=true,name='check\nlimit_0',units=1,value=sqrt(prime_0)],[]).
node(node00022,border,[],[name=var6],[centre=[495,108]]).
node(node00013,variable,[],[complete=true,name='all\nprimes'],[caption_offset=[0,0],centre=[570,150]]).
node(node00014,function,[],[complete=true,name=fn1,spec='[prime]',units=array(int,500000),value=[prime]],[]).
node(node00015,variable,[],[complete=true,name='last ten'],[caption_offset=[0,0],centre=[555,45]]).
node(node00016,function,[],[complete=true,name=fn2,spec='makearray(element([all_primes],499990+place_in(1)),10)',units=array(int,10),value=makearray(element([all_primes],499990+place_in(1)),10)],[]).

arc(arc00012,node00019,node00017,influence,[name=i4],[]).
arc(arc00013,node00020,node00019,influence,[complete=true,name=i8,role=[use(none,in_hierarchy,[all_primes],array(int,500000))]],[curve=[6,14]]).
arc(arc00014,node00017,node00021,influence,[complete=true,name=i6,role=[use(none,in_hierarchy,start_prime,int)]],[curve=[-2,9]]).
arc(arc00015,node00021,node00018,influence,[complete=true,name=i2],[curve=[-4,-26]]).
arc(arc00016,node00034,node00033,influence,[complete=true,name=i2],[curve=[-2,-13]]).
arc(arc00017,node00035,node00034,influence,[complete=false,name=i3],[]).
arc(arc00018,node00037,node00036,influence,[name=i10],[]).
arc(arc00019,node00034,node00037,influence,[complete=true,name=i22,role=[use(none,in_hierarchy,usr(found_divisor),boolean)]],[curve=[24,6]]).
arc(arc00020,node00039,node00038,influence,[name=i4],[]).
arc(arc00021,node00036,node00039,influence,[comment='\n',complete=true,name=i5,role=[use(none,in_hierarchy,done_checks,boolean)],use_sofar=1],[curve=[-2,10]]).
arc(arc00022,node00041,node00040,influence,[name=i6],[]).
arc(arc00023,node00042,node00040,influence,[complete=true,name=i7],[curve=[1,32]]).
arc(arc00024,node00043,node00035,influence,[complete=true,name=i18,role=[use(none,in_hierarchy,quotient,int)]],[curve=[-3,-18]]).
arc(arc00025,node00043,node00037,influence,[complete=true,name=i21,role=[use(none,in_hierarchy,usr(quotient),int)]],[curve=[20,-12]]).
arc(arc00026,node00044,node00043,influence,[name=i14],[]).
arc(arc00027,node00038,node00044,influence,[complete=true,name=i11,role=[use(none,in_hierarchy,usr(which),int)]],[curve=[-19,0]]).
arc(arc00028,node00040,node00044,influence,[comment='\n',complete=true,name=i12,role=[use(none,in_hierarchy,usr([all_primes]),array(int,500000))],use_sofar=1],[curve=[-4,2]]).
arc(arc00029,node00045,node00035,influence,[complete=true,name=i19,role=[use(none,in_hierarchy,prime_0,int)]],[curve=[-6,14]]).
arc(arc00030,node00046,node00037,influence,[complete=true,name=i27,role=[use(none,in_hierarchy,usr(check_limit),1)]],[curve=[2,18]]).
arc(arc00031,node00025,node00024,influence,[name=i1],[]).
arc(arc00032,node00023,node00025,influence,[complete=true,name=i3,role=[use(none,in_hierarchy,found_divisor,boolean)]],[curve=[-1,-7]]).
arc(arc00033,node00024,node00026,influence,[comment='\n',complete=true,name=i7,role=[use(none,in_hierarchy,found_prime,boolean)],use_sofar=1],[curve=[13,-8]]).
arc(arc00034,node00027,node00026,influence,[complete=true,name=i6,role=[use(none,in_hierarchy,start_prime,int)]],[curve=[0,6]]).
arc(arc00035,node00026,node00029,influence,[name=i5],[]).
arc(arc00036,node00029,node00028,influence,[complete=true,name=i2],[curve=[0,-6]]).
arc(arc00037,node00029,node00023,influence,[complete=true,name=i20],[curve=[-8,20]]).
arc(arc00038,node00030,node00023,influence,[complete=true,name=i8],[curve=[1,30]]).
arc(arc00039,node00031,node00023,influence,[complete=true,name=i28],[curve=[0,6]]).
arc(arc00040,node00032,node00031,influence,[name=i25],[]).
arc(arc00041,node00029,node00032,influence,[complete=true,name=i26,role=[use(none,in_hierarchy,prime_0,int)]],[curve=[9,12]]).
arc(arc00042,node00022,node00021,influence,[complete=true,name=i9],[curve=[2,26]]).
arc(arc00043,node00013,node00012,influence,[comment='\n',complete=true,name=i9,use_sofar=1],[curve=[4,10]]).
arc(arc00044,node00013,node00012,influence,[complete=true,name=i10],[curve=[0,9]]).
arc(arc00045,node00014,node00013,influence,[name=i1],[]).
arc(arc00046,node00012,node00014,influence,[complete=true,name=i3,role=[use(none,in_hierarchy,[prime],array(int,500000))]],[curve=[-2,-10]]).
arc(arc00047,node00016,node00015,influence,[name=i2],[]).
arc(arc00048,node00013,node00016,influence,[complete=true,name=i4,role=[use(none,in_hierarchy,[all_primes],array(int,500000))]],[curve=[-22,4]]).

