source(program='Simile v7.4',version= 11.4,edition=free,date='Thu Aug 13 11:36:30 GMT 2026').

roots([node00297,node00298,node00299,node00300,node00301]).

properties([complete-true,file_name-'/win98/Program Files/Simile/Develop/Library/horatio2.sml',fill_colour-'#d4f088',fix_math_args-0,image_posn-none,min_val-0,multiplication_spec-[count=[]],name-'Desktop5',separate-0,units-1,value- 0.5]).

node(node00297,submodel,[node00302,node00303,node00304,node00305,node00306,node00307],[complete=true,enum_types=[],fill_colour='#b8c0e6',image_posn=none,multiplication_spec=[count=[500000]],name=primes,separate=0],[bounding_box=[ 30.0, 45.0, 525.0, 300.0],caption_offset=[ 0.0, 0.0],internal_extent=[ 0.0, 0.0, 495.0, 255.0]]).
links(node00297,[arc00043-arc00273,arc00275-arc00046,arc00302-arc00301]).
node(node00298,variable,[],[complete=true,name='all\nprimes'],[caption_offset=[ 0.0, 0.0],centre=[ 570.0, 150.0]]).
node(node00299,function,[],[complete=true,name=fn1,spec='[prime]',units=array(int,500000),value=[prime]],[]).
node(node00300,variable,[],[complete=true,name='last ten'],[caption_offset=[ 0.0, 0.0],centre=[ 555.0, 45.0]]).
node(node00301,function,[],[complete=true,name=fn2,spec='makearray(element([all_primes],499990+place_in(1)),10)',units=array(int,10),value=makearray(element([all_primes],499990+place_in(1)),10)],[]).
node(node00302,variable,[],[complete=true,max_val=1000,min_val=0,name='start\nprime',spec='3',units=int,value=3],[caption_offset=[ 0.0, 0.0],centre=[ 435.0, 150.0]]).
node(node00303,border,[],[name=var2],[along=990]).
node(node00304,function,[],[complete=true,name=fn2,spec='if index(1)==1 then 5 else element([all_primes],index(1)-1)+2',units=int,value=(if index(1)==1 then 5 else element([all_primes],index(1)-1)+2)],[]).
node(node00305,border,[],[name=var3],[along=998]).
node(node00306,submodel,[node00308,node00309,node00310,node00311,node00312,node00313,node00314,node00315,node00316,node00317],[complete=true,enum_types=[],fill_colour='#eedbae',image_posn=none,multiplication_spec=[count=[]],name='higher numbers',separate=0],[bounding_box=[ 30.0, 15.0, 390.0, 240.0],caption_offset=[ 0.0, 0.0],internal_extent=[ 0.0, 0.0, 360.0, 225.0]]).
links(node00306,[arc00274-arc00293,arc00295-arc00275,arc00301-arc00297]).
node(node00307,border,[],[name=var6],[along=987]).
node(node00308,submodel,[node00318,node00319,node00320,node00321,node00322,node00323,node00324,node00325,node00326,node00327,node00328,node00329,node00330,node00331],[complete=true,enum_types=[],fill_colour='#d6e1d3',image_posn=none,multiplication_spec=[count=[]],name=divisors,separate=0],[bounding_box=[ 30.0, 30.0, 240.0, 210.0],caption_offset=[ 2.0, 1.0],internal_extent=[ 0.0, 0.0, 210.0, 180.0]]).
links(node00308,[arc00276-arc00291,arc00296-arc00288,arc00297-arc00282,arc00298-arc00289]).
node(node00309,alarm,[],[complete=true,name='found prime'],[caption_offset=[ 0.0, 0.0],centre=[ 285.0, 45.0]]).
node(node00310,function,[],[complete=true,name=fn1,spec='not found_divisor',units=boolean,value=not found_divisor],[]).
node(node00311,function,[],[complete=true,name=fn3,spec='if found_prime then start_prime else prev(0)+2',units=int,value=(if found_prime then start_prime else prev(0)+2)],[]).
node(node00312,border,[],[],[along=12]).
node(node00313,border,[],[],[along=2]).
node(node00314,variable,[],[complete=true,max_val=1000,min_val=0,name=prime,spec='95',units=int,value=95],[caption_offset=[ 0.0, 0.0],centre=[ 330.0, 120.0]]).
node(node00315,border,[],[name=var5],[along=990]).
node(node00316,variable,[],[complete=true,name='check\nlimit'],[caption_offset=[ 0.0, 0.0],centre=[ 270.0, 165.0]]).
node(node00317,function,[],[complete=true,name='check\nlimit_0',units=1,value=sqrt(prime_0)],[]).
node(node00318,border,[],[name=var1],[along=907]).
node(node00319,variable,[],[complete=true,name='found divisor'],[caption_offset=[ 0.0, 0.0],centre=[ 150.0, 30.0]]).
node(node00320,function,[],[complete=true,name=fn3,units=boolean,value=(fmod(prime_0,quotient)==0)],[]).
node(node00321,alarm,[],[complete=true,name='done checks'],[caption_offset=[ 0.0, 0.0],centre=[ 120.0, 150.0]]).
node(node00322,function,[],[complete=true,name=fn5,spec='found_divisor or  quotient>check_limit',units=boolean,value=(found_divisor or quotient>check_limit)],[]).
node(node00323,variable,[],[complete=true,name=which],[caption_offset=[ 0.0, 0.0],centre=[ 60.0, 135.0]]).
node(node00324,function,[],[complete=true,name=fn1,spec='if done_checks then 0 else prev(0)+1',units=int,value=(if done_checks then 0 else prev(0)+1)],[]).
node(node00325,variable,[],[name=var3],[caption_offset=[ 0.0, 0.0],centre=[ 75.0, 75.0]]).
node(node00326,function,[],[complete=false,name=fn2],[]).
node(node00327,border,[],[name=var4],[along=974]).
node(node00328,variable,[],[complete=true,name=quotient],[caption_offset=[ 0.0, 0.0],centre=[ 60.0, 45.0]]).
node(node00329,function,[],[complete=true,name=fn7,spec='if which==0 then 3 else element([all_primes],which)',units=int,value=(if which==0 then 3 else element([all_primes],which))],[]).
node(node00330,border,[],[name=var8],[along=947]).
node(node00331,border,[],[name=var12],[along=69]).
arc(arc00276,node00319,node00318,influence,[attached=[],complete=true,name=i2],[curve=[-2,-13]]).
arc(arc00277,node00320,node00319,influence,[attached=[],complete=false,name=i3],[]).
arc(arc00283,node00328,node00320,influence,[attached=[],complete=true,name=i18,role=[use(none,in_hierarchy,quotient,int)]],[curve=[-3,-18]]).
arc(arc00288,node00330,node00320,influence,[attached=[],complete=true,name=i19,role=[use(none,in_hierarchy,prime_0,int)]],[curve=[-6,14]]).
arc(arc00278,node00322,node00321,influence,[attached=[],name=i10],[]).
arc(arc00279,node00319,node00322,influence,[attached=[],complete=true,name=i22,role=[use(none,in_hierarchy,usr(found_divisor),boolean)]],[curve=[24,6]]).
arc(arc00284,node00328,node00322,influence,[attached=[],complete=true,name=i21,role=[use(none,in_hierarchy,usr(quotient),int)]],[curve=[20,-12]]).
arc(arc00289,node00331,node00322,influence,[attached=[],complete=true,name=i27,role=[use(none,in_hierarchy,usr(check_limit),1)]],[curve=[2,18]]).
arc(arc00280,node00324,node00323,influence,[attached=[],name=i4],[]).
arc(arc00281,node00321,node00324,influence,[attached=[],comment='\n',complete=true,name=i5,role=[use(none,in_hierarchy,done_checks,boolean)],use_sofar=1],[curve=[-2,10]]).
arc(arc00022,node00326,node00325,influence,[attached=[],name=i6],[]).
arc(arc00282,node00327,node00325,influence,[attached=[],complete=true,name=i7],[curve=[1,32]]).
arc(arc00285,node00329,node00328,influence,[attached=[],name=i14],[]).
arc(arc00286,node00323,node00329,influence,[attached=[],complete=true,name=i11,role=[use(none,in_hierarchy,usr(which),int)]],[curve=[-19,0]]).
arc(arc00287,node00325,node00329,influence,[attached=[],comment='\n',complete=true,name=i12,role=[use(none,in_hierarchy,usr([all_primes]),array(int,500000))],use_sofar=1],[curve=[-4,2]]).
arc(arc00296,node00314,node00308,influence,[attached=[],complete=true,name=i20],[curve=[-8,20]]).
arc(arc00297,node00315,node00308,influence,[attached=[],complete=true,name=i8],[curve=[1,30]]).
arc(arc00298,node00316,node00308,influence,[attached=[],complete=true,name=i28],[curve=[0,6]]).
arc(arc00290,node00310,node00309,influence,[attached=[],name=i1],[]).
arc(arc00291,node00308,node00310,influence,[attached=[],complete=true,name=i3,role=[use(none,in_hierarchy,found_divisor,boolean)]],[curve=[-1,-7]]).
arc(arc00292,node00309,node00311,influence,[attached=[],comment='\n',complete=true,name=i7,role=[use(none,in_hierarchy,found_prime,boolean)],use_sofar=1],[curve=[13,-8]]).
arc(arc00293,node00312,node00311,influence,[attached=[],complete=true,name=i6,role=[use(none,in_hierarchy,start_prime,int)]],[curve=[0,6]]).
arc(arc00295,node00314,node00313,influence,[attached=[],complete=true,name=i2],[curve=[0,-6]]).
arc(arc00294,node00311,node00314,influence,[attached=[],name=i5],[]).
arc(arc00299,node00317,node00316,influence,[attached=[],name=i25],[]).
arc(arc00300,node00314,node00317,influence,[attached=[],complete=true,name=i26,role=[use(none,in_hierarchy,prime_0,int)]],[curve=[9,12]]).
arc(arc00272,node00304,node00302,influence,[attached=[],name=i4],[]).
arc(arc00275,node00306,node00303,influence,[attached=[],complete=true,name=i2],[curve=[-4,-26]]).
arc(arc00273,node00305,node00304,influence,[attached=[],complete=true,name=i8,role=[use(none,in_hierarchy,[all_primes],array(int,500000))],use_sofar=1],[curve=[6,14]]).
arc(arc00274,node00302,node00306,influence,[attached=[],complete=true,name=i6,role=[use(none,in_hierarchy,start_prime,int)]],[curve=[-2,9]]).
arc(arc00301,node00307,node00306,influence,[attached=[],complete=true,name=i9],[curve=[2,26]]).
arc(arc00043,node00298,node00297,influence,[attached=[],comment='\n',complete=true,name=i9],[curve=[4,10]]).
arc(arc00302,node00298,node00297,influence,[attached=[],complete=true,name=i10],[curve=[0,9]]).
arc(arc00303,node00299,node00298,influence,[attached=[],name=i1],[]).
arc(arc00046,node00297,node00299,influence,[attached=[],complete=true,name=i3,role=[use(none,in_hierarchy,[prime],array(int,500000))]],[curve=[-2,-10]]).
arc(arc00047,node00301,node00300,influence,[attached=[],name=i2],[]).
arc(arc00304,node00298,node00301,influence,[attached=[],complete=true,name=i4,role=[use(none,in_hierarchy,[all_primes],array(int,500000))]],[curve=[-22,4]]).
