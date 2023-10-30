pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
--hohoho!
--cree par gigi, tijana et karina
--remerciment pour leur contribution de 
--tom,philippe & chichi 

function init_game()
	music(0)
	create_player()
	init_msg()
	deer=false
	snow=false
	santa=false
end

function update_game()
 if #messages==0 then
 	player_movement()
 end	
 										
 update_camera()
 
 update_msg()
 
 if btn(❎) then
 	deer=false
 	snow=false
 	santa=false
 end
 
end

function draw_game()
	cls()
	draw_map()
	draw_player()
	draw_msg()
	draw_ui()
	
	if deer then
 	anime_deer()
	end
	if snow then
	 anime_snow()
	end
	if santa then
 	anime_santa()
	end
	
end
-->8
--player

function create_player()
	p={
	 shovel=0,
		candy=0,
	 gift=0,
	 key=0,
		x=4,
		y=2,
		ox=0,oy=0,
		start_ox=0,start_oy=0,
		anim_t=0,
		sprite=00
	}
end

function player_movement()

 newx=p.x
 newy=p.y
	if p.anim_t==0 then
			newox,newoy=0,0
		if btn(➡️) then
		 newx+=1
		 newox=-8
		 p.flip=true
		elseif btn(⬅️) then
		 newx-=1
		 newox=8
		 p.flip=false
		elseif btn(⬇️) then
		 newy+=1
		 newoy=-8
		elseif btn(⬆️) then
		 newy-=1
			newoy=8
		end
	end
		
	interact(newx,newy)
	
	if not check_flag(0,newx,newy)
	and (p.x!=newx or p.y!=newy) then
		p.x=mid(0,newx,20)
		p.y=mid(0,newy,20)
		p.start_ox=newox
		p.start_oy=newoy
		p.anim_t=1
	end
	
--animtion

	p.anim_t=max(p.anim_t-0.125,0)
	p.ox=p.start_ox*p.anim_t
	p.oy=p.start_oy*p.anim_t
	
	if p.anim_t>=0.5 then
		p.sprite=16
	else
		p.sprite=0
	end
end

function draw_player()
	spr(p.sprite,p.x*8+p.ox,p.y*8+p.oy,
	1,1,p.flip)
end	


function interact(x,y)
	if check_flag(7,x,y) then
		pile_of_snow(x,y)
	elseif check_flag(2,x,y) then
		feed_the_deer(x,y)
	elseif check_flag(3,x,y) then
			pick_up_candy(x,y)
	elseif check_flag(4,x,y) then
			pick_up_key(x,y)
	elseif check_flag(6,x,y) then 
	  pick_up_shovel(x,y)
	elseif check_flag(1,x,y) then 
  pick_up_gift(x,y)
 elseif check_flag(5,x,y)
  and p.key>0 then
  open_door(x,y)
 elseif check_flag(5,x,y)
  and p.key==0 then
  create_msg("porte","oh non, c'est ferme !\nsi seulement j'avais une clef...")
		sfx(0)
		
--messages

 elseif x==7 and y==4 then
 	create_msg("panneau",
 	"aide tincelle a trouver les 3 \ncardeaux perdus par papa noel.")
 elseif x==16 and y==15 then 
 	create_msg("panneau",
 	"le chemin est bloque comment\nfaire pour le deblayer?")
 elseif x==15 and y==17 and p.gift==3 or x==15 and y==18 and p.gift==3 then
 	create_msg("papa noel",
 	"bravooo,tu as gagne!")
 	santa=true
 end
 
end
 
-->8
--map

function draw_map()
	map(0,0,0,0,127,63)
end

function check_flag(flag,x,y)
	local sprite=mget(x,y)
	return fget(sprite,flag)
end

function update_camera()
	camx=mid(0,(p.x-7.5)*8+p.ox,(20-15)*8)
	camy=mid(0,(p.y-7.5)*8+p.oy,(20-15)*8)
	camera(camx,camy)
end

function next_tile(x,y)
 local sprite=mget(x,y)
 mset(x,y,sprite+1)
 sfx(1)
end

function new_next_tile(x,y)
 local sprite=mget(x,y)
 mset(x,y,sprite+2)
 sfx(1)
end


  
function pick_up_gift(x,y)
 next_tile(x,y)
 p.gift+=1
end
 
function open_door(x,y)
 next_tile(x,y)
 p.key-=1
end

function pick_up_key(x,y)
 next_tile(x,y)
 p.key+=1
end

function pick_up_candy(x,y)
	next_tile(x,y)
	p.candy+=1
end

function feed_the_deer(x,y)
	if p.candy==0 then
 	create_msg("rodolphe",
 	"j'ai faim!\nas tu quelque chose pour moi?")
 elseif p.candy>0 then
 	deer=true
	 create_msg(
		"rodolphe",
		"merci ! voici une clef.")
 	next_tile(x,y)
 	p.candy-=1
 end
 
end 

function pick_up_shovel(x,y)
 next_tile(x,y)
 p.shovel+=1
 create_msg("bonhomme de neige",
 "hey! voleur de pelle!")
 snow=true
end

function pile_of_snow(x,y)
	if p.shovel>0 then
	 if x==19 and y==15 then
	 	create_msg("tas de neige",
	 "oh! un cadeau etait enseveli!")
			next_tile(x,y)
		else 
			new_next_tile(x,y)
  end
 else sfx(0)
	end
	
end
-->8
--sign

function init_msg()
 messages={}
end

function update_msg()
 if btnp(❎) then	
	 deli(messages,1)
 end
end

function draw_msg()
	if messages[1] then
		camera()
	 local y=100
	 rectfill(7,y,11+#msg_title*4,y+7,2)
	 print(msg_title,10,y+2,9) 
	
	 rectfill(3,y+8,124,y+24,4)
	 rect(3,y+8,124,y+24,2)
  print(messages[1],6,y+11,15)
	end
	
end

function draw_msg2()
	if messages[1] then
	 local y=100
	 rectfill(7,y,11+#msg_title*4,y+7,2)
	 print(msg_title,10,y+2,9) 
	
	 rectfill(3,y+8,124,y+24,4)
	 rect(3,y+8,124,y+24,4)
  print(messages[1],6,y+11,15)
	end
	
end
 
--messages

function create_msg(name,...)
 msg_title=name
 messages={...}
end

-->8
--main page

function _init()
init_menu()
end

function _update()
end

function _draw()
end


--menu
 
function init_menu()
 _update = update_menu
 _draw = draw_menu
 init_msg()
 text_timer=0
end
 
function update_menu()
	text_timer+=0.5
	update_msg()
 if btnp(🅾️) then
 create_msg("bienvenue",
 "aide le lutin a retouver\nles cadeaux egares.(press ❎)")
 elseif btnp(❎) then 
  _init = init_game()
  _update = update_game
  _draw = draw_game
 end
 
end

function draw_menu()
	animate_menu()
	cls()
	map(113.5,0,0,0)
	print(" press   to start",30,60,col)
	sspr(sspr_x,40,16,16,54,80)
	draw_msg()
end 

function animate_menu()
		if text_timer%8>4 then
						 col=10  sspr_x=88
		else col=9			sspr_x=104	 
		end
		
end

 
-->8
--ui
function draw_ui()
 camera(0,0)
	spr(43,2,2)
	print_outline(p.gift.."/3",13,4)
end

function print_outline(text,x,y)
 print(text,x-1,y,0)
 print(text,x+1,y,0)
 print(text,x,y-1,0)
 print(text,x,y+1,0)
 print(text,x,y,7)
end

function anime_deer()
		spr(192+(time()*2)%2,50,50)
		spr(194+(time()*2)%2,58,50)
		spr(196+(time()*2)%2,66,50)
		spr(198+(time()*2)%2,74,50)
		
		spr(208+(time()*2)%2,50,58)
		spr(210+(time()*2)%2,58,58)
		spr(212+(time()*2)%2,66,58)
		spr(214+(time()*2)%2,74,58)
		
		spr(224+(time()*2)%2,50,66)
		spr(226+(time()*2)%2,58,66)
		spr(228+(time()*2)%2,66,66)
		spr(230+(time()*2)%2,74,66)
		
		spr(240+(time()*2)%2,50,74)
		spr(242+(time()*2)%2,58,74)
		spr(244+(time()*2)%2,66,74)
		spr(246+(time()*2)%2,74,74)
end

function anime_snow()
		spr(128+(time()*2)%2,50,50)
		spr(130+(time()*2)%2,58,50)
		spr(132+(time()*2)%2,66,50)
		spr(134+(time()*2)%2,74,50)
		
		spr(144+(time()*2)%2,50,58)
		spr(146+(time()*2)%2,58,58)
		spr(148+(time()*2)%2,66,58)
		spr(150+(time()*2)%2,74,58)
		
		spr(160+(time()*2)%2,50,66)
		spr(162+(time()*2)%2,58,66)
		spr(164+(time()*2)%2,66,66)
		spr(166+(time()*2)%2,74,66)
		
		spr(176+(time()*2)%2,50,74)
		spr(178+(time()*2)%2,58,74)
		spr(180+(time()*2)%2,66,74)
		spr(182+(time()*2)%2,74,74)
end

function anime_santa()
		spr(200+(time()*2)%2,50,50)
		spr(202+(time()*2)%2,58,50)
		spr(204+(time()*2)%2,66,50)
		spr(206+(time()*2)%2,74,50)
		
		spr(216+(time()*2)%2,50,58)
		spr(218+(time()*2)%2,58,58)
		spr(220+(time()*2)%2,66,58)
		spr(222+(time()*2)%2,74,58)
		
		spr(232+(time()*2)%2,50,66)
		spr(234+(time()*2)%2,58,66)
		spr(236+(time()*2)%2,66,66)
		spr(238+(time()*2)%2,74,66)
		
		spr(248+(time()*2)%2,50,74)
		spr(250+(time()*2)%2,58,74)
		spr(252+(time()*2)%2,66,74)
		spr(254+(time()*2)%2,74,74)
end
__gfx__
00838383666666666444444466673766666666666666666666666666444445554444444455555444555555556466646666666666666666666666666666666666
033333386666666667707076667b33766666666666cc6cc666666666444555554444444455544444555555556644466666666666666666669999999966666666
0f5f5f03666666666777977666b3333666766666666ccc666666666644444555444444445555544455555555684466666a666666666666664444444466666666
0fffff006666666666777766667b3376666666666888c888666666664445555545454545555444444545454566646664a0aaaa66666666664242242466666666
3333333f666666666683838667b33337666666666888c8886666666644444555454545455555544445454545666494466a666a66666666664444444466666666
f445440466666666677778766b333333666666666ccccccc66666666444555555555555555544444444444446664444666666666666666666626626666666666
08888844667666666777737666664566666666666888c88866666666444445555555555555555444444444446664664666666666666666666646646666666666
05000544666666666877778666664566666666666888c88866666666444555555555555555544444444444446669669666666666666666666646646666666666
008383836666666666b6b6666666666666666666188888811880000144444444994599990077777766666666666d666666666666666666666666666666666666
0333333866444666666b66666678766666666666880505088850000044444444994599990777777766666666665dd666666666666666566666cc6cc666666666
0f5f5f0364444466669996666686866666666666980505089552000095599559994599990777770766666666655ddd666666666666657566666ccc6666666666
0fffff004444044666aa96666666766666666666988888889582000095599559994555590777770066666666655ddd6666666666665777566888c88866666666
33333330444444466699966666668666666666668888885888820000999999999944444977777777666666666554dd6666666666657777756888c88866766666
f44544f45404446666aa9666666676666666666698888868988200009999999999444449777777076666666665646d6666666666577777776ccccccc66666666
08888844654445666699966666668666666666669828288898200000999999999959995907777777666666666664666666666666777777776888c88866666666
00205044665556666669666666666666666666664228282882000000999999999999999907000777666666666664666666666666555555556888c88866666666
666666678888886666666665555555556666666666666666664666465555555555555555666666666666666666cc6cc600000000000000000000000000000000
6666668882288886666666577777777756666666666666666664446655555555555555556666666666666666666ccc6600000000000000000000000000000000
666667886888888866666657555555575666666666666666666644f6555555555555555566666666666666666888c88800000000000000000000000000000000
66666777622222226666666558888857555666666555556646664666555545455454555566666666666666666888c88800000000000000000000000000000000
66667666677777776666666658888857777566666577775664494666555445455454455566666666666666666ccccccc00000000000000000000000000000000
66666666674040476666666658888885557756665775575664444666555554444445555566666666666666666888c88800000000000000000000000000000000
6666666667e444e76666666658888888885755665758556664664666555444444444455566666666666666666888c88800000000000000000000000000000000
66666666677444776666666658888878885775555758566669669666555554444445555566666666666666666666666600000000000000000000000000000000
6666666666777776666666665888878788857777775856666646664655555444444555556666666666666666bbbbbbbb88888888999999999999999999999999
6666666666677766666666666588887888885555558856666664446655544444444445556666666666666666bbbbbbbb888888889999999999cc9cc999999999
6666666666887886666666666588888888888888888256666666448655555444444555556666666666666666bbbbbbbb8888888899999999999ccc9999999999
6666666668888888666666666652222222222222222566564666466655544545545445556666666666666666bbbbbbbb88888888999999999888c88899999999
666666666800a008666666666665555555555555555666656449466655554545545455556666666666666666bbbbbbbb88888888999999999888c88899999999
6666666664777774666666666666656666656666656666656444466655555555555555556666666666666666bbbbbbbb88888888999999999ccccccc99999999
6666666666686866666666666666656666656666656666566466466655555555555555556666666666666666bbbbbbbb88888888999999999888c88899999999
6666666666446446666666555555555555555555555555666966966655555555555555556666666666666666bbbbbbbb88888888999999999888c88899999999
66666666666666666666666666666676666666666666666666678666666666666666666666666666666666666666666600000000000000000000000000000000
66677666667766666666667777766666666666666666666666678666666666666666666667666666666666666666666600000000000000000000000000000000
66678666667866666666778888877666667666766666666666678666766666666666666666666666666667666666666600000000000000000000000000000000
66678666667866666667886666688766666777666666666666678666766666666666666666666776677666666666666600000000000000000000000000000000
66678667667866666678666666666876666777668666668666678666667766666666666666666776677666666666666600000000000000000000000000000000
66678666667866666786666666666687667666768666668666666666667766666666666666666667766666666666666600000000000000000000000000000000
66678666667866666866666666666668666666668668668666677666776666666666666776677667766776677666666600000000000000000000000000000000
66678666667866666866666666666668666666668686868666678666776666666666666776677667766776677666666600000000000000000000000000000000
66678777777866666866666666666668000000006866686666666666667766666666666667766667766667760000000000000000000000000000000000000000
66678888887866666866676666666668000000006666666666666666667766666666666667766667766667760000000000000000000000000000000000000000
66678666667866666866666666666668000000006666666666666666766666666666666776677667766776670000000000000000000000000000000000000000
66678666667866766876666666666678000000006666666666666666766666666666666776677667766776670000000000000000000000000000000000000000
66678666667866666687666666666786000000006666666666666666666666666666776666666777777666660000000000000000000000000000000000000000
66678666667866666668776666677866000000006766666666666666666666666666776666666777777666660000000000000000000000000000000000000000
76678666667866666666887777788666000000006666666666666666766666666666667777777777777777770000000000000000000000000000000000000000
66666666666666666666668888866666000000006666666666666666766666666666667777777777777777770000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000006666776666666777777666660000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000006666776666666777777666660000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000006666666776677667766776670000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000006666666776677667766776670000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000006666666667766667766667760000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000006666666667766667766667760000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000006666666776677667766776670000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000006666666776677667766776670000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000006666666666666667766666666666666600000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000006666666666666776677666666666666600000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000006666666666666776677666666666666600000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000006666666666666666666666666666666600000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000006666666666666666666666666666666600000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000006666666666766666666666666666666600000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000006666666666666666666667666666666600000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000006666666666666666666666666666666600000000000000000000000000000000
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
13333333133333333333333333333333333333333333333333333331333333311333333333333333333333333333333113333333333333333333333333333331
13666666136666664444444466666666444444446666666644466631666666311366666666666666666666666666663113666666666666666666666666666631
13664444136666644444444444444444444444444444444444466631444666311366666666666666666666666666663113666666666666666666666666666631
13644444136644444444444444444444444444444444444744444631744666311366666666666666666666666666663113666666666666666666666666666631
13644444136444444444444444444444444444444444444444444631444446311366666666666666666666666666663113666666666666666666666666666631
13644444136444444444444444444444444444444444444444444631444446311366666666666666666666666666663113666666666666666666666666666631
1366444413644444444444444444444444444444444444444444463144444631136666cc6cc6666666cc6cc666666631136666cc6cc666666666666666666631
13664444136644444444444444444444444444444444444444444631444446311366666ccc666666666ccc66666688311366666ccc6666666666666666666631
136667771366444477222777444444447777772244444444777766314444463113666888c88866666888c8886668883113666888c88866666666666666666631
136667771366677777722277772227777777222577777722777766317777663113666888c88866666888c8886688883113666888c88866666666666666666831
136667771366677777775222777222777772275577772225777766317777663113666ccccccc66666ccccc448888863113666ccccccc66666666666666668831
136667771366677777575572777752227777775577722755777766317777663113666888c88866666888c8448866663113666888c88866666666666666688831
136667771366677777555577775755727777555577777755777766317777663113666888c88866666888c8886666663113666888c88866666666666448888831
13666777136667777755557777555577777755557777555577776631777766311365555555556666666666666666663113655555555566666666666448886631
136667771366677777755777775555777777755777775555777766317777663113577777777756666666666666666631135777777777566666cc6cc666666631
1366677713666777777777777775577777777777777775577776663177776631135755555557566666666666666666311357555555575666666ccc6666666631
13666677136667777777777777777777999777777777777777766631777666311365588888575556666666555566663113655888885755566888c85555666631
13666677136667777777777977777779999977779977777777766631777666311366588888577775666665777756663113665888885777756888c57777566631
13666677136667777777777977777779799997779997777777666631777666311366588888855577566657755756663113665888888555775888577557566631
13666667136666777777777777777777777997777999777777666631777666311366588888888857556657585566663113665888888888575588575855666631
13666666136666677777777777777777777799777779997776666631776666311366588888788857755557585666663113665888887888577555575856666631
13666666136666677777777777777777777777777777797776666631776666311366588887878885777777585666663113665888878788857777775856666631
13666666136666667777777777777777777777767777777766666631766666311366658888788888555555885666663113666588887888885555558856666631
13666666136666666667777767777777777777667777777766666631666666311366658888888888888888825666663113666588888888888888888256666631
13666666136666663333888833338888833333888333338888866631888666311366665222222222222222256656663113666652222222222222222566566631
13666888136668883333778833338888833333888333377788866631888666311366666555555555555555566665663113666665555555555555555666656631
13668888136688883337788833338888833333888333377888866631888666311366666665666665666665666665663113666666656666656666656666656631
13668888136688883337788833338888833333888333338888886631888866311366666665666665666665666656663113666666656666656666656666566631
13668888136688883333888833338888833333888333338888886631888866311355555555555555555555555566663113555555555555555555555555666631
13333333133333333333333333333333333333333333333333333331333333311333333333333333333333333333333113333333333333333333333333333331
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
13333333133333333333333333333333333333333333333333333331333333311333333313333333333333333333333333333333333333333333333133333331
13666666136666666666666666666666622655626226556222225531222255311366666613666666666666666666666666666666666666666666663166666631
13666666136666666666666666666666622655226226552222225531222255311366666613666666666666666666666666666666666666666666663166666631
13666666136666666666666666666666622222226222222222555631225556311366666613666666666666666666666666666666666666666666663166666631
13666666136666666666666666666666622222226222222255566631555666311366666613666666666666666666666666666666666666666666663166666631
13666666136666666666666266666662222222552222225556666631566666311366666613666666666666666666666666666666666666666666663166666631
1366666613666666666666226666662222555666225556666666663166666631136666cc136666cc6cc666666cc6666666cc6cc6666666666666663166666631
13666666136666666666662266666622655999666556666666666631666666311366666c1366666ccc666666cc666666666ccc66666666666666883166666631
136666661366666666644422666444224499f9664499999666666631666666311366688813666888c8886666c88866666888c888666666666668883166666631
13666666136666666644444466444444449f9966449ff99666666631666666311366688813666888c8886666c88866666888c888666666666688883166666831
1366666613666666644444446444444444f9966644f99966666666316666663113666ccc13666ccccccc6666cccc66666ccccc44666666668888863166668831
13688886136888866422244464222444444466664444666666666631666666311366688813666888c8886666c88866666888c844666666668866663166688831
13888784138887844454444444544444444446664444466666666631666666311366688813666888c8886666c88866666888c888666666646666663148888831
13888844138888444444444444444444444446664444466666666631666666311365555513655555555566665555666666666666666666646666663148886631
1388844413888444444444444444444444444666444446666666663166666631135777771357777777775666777756666666666666cc6cc66666663166666631
13444444134444444444444444444444444446664444466666666631666666311357555513575555555756665557566666666666666ccc666666663166666631
136666661366668888444444884444444444466644444666666666316666663113655888136558888857555688575556666666556888c8555566663155666631
136666661366888888888444844444444444446644444466666666316666663113665888136658888857777588577775666665776888c5777756663177566631
13664444136648884888444444444444444444664444446666666631666666311366588813665888888555778885557756665775588857755756663157566631
13666444136664444444444444444444444444664444446666666631666666311366588813665888888888578888885755665758558857585566663155666631
13666666136666666666666466666664444444464444444666666631666666311366588813665888887888578878885775555758755557585666663156666631
13666666136666666666666466666664444444444444444466666631666666311366588813665888878788858787888577777758777777585666663156666631
13666666136666666666666466666664444444444444444466666631666666311366658813666588887888888878888855555588555555885666663156666631
13666666136666666666664466666644444444444444444446666631466666311366658813666588888888888888888888888882888888825666663156666631
13666666136666666666664466666644444444444444444446666631466666311366665213666652222222222222222222222225222222256656663166566631
13666666136666666666664466666644444444444444444444666631446666311366666513666665555555555555555555555556555555566665663166656631
13666666136666666666664466666644444444444444444444466631444666311366666613666666656666656566666566666566666665666665663166656631
13666666136666666666644466666444444444444444444444444431444444311366666613666666656666656566666566666566666665666656663166566631
13666666136666666666644466666444444444444444444444444431444444311355555513555555555555555555555555555555555555555566663155666631
13333333133333333333333333333333333333333333333333333331333333311333333313333333333333333333333333333333333333333333333133333331
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
__gff__
0000010100030001010101051100010000000008002100010100004000810300010101010101010101000000000000000001050101010001010000000000030000040004040000000000000000000000000404040400000000000000000000000004040404000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000001010101010101010000000000000000050101010501010100000000000000000000000000000000000000000000000000000000000000000000000000000000010101010101010100000000000000000505010101010101
__map__
0303010103030303030303030303030303030303031010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101010101010101010101030303030303030303030303030303
03030101040303030303051f0303010101010103031010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101010101010101010101030404040404040404040404040403
0303030104010303030303010101011f03010101031010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101010101010101010101034041424340414243404142434003
0303030301010101030303030303030302010103031010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101010101010101010101035051525350515253505152534603
030303030304010e0402010101010101010103030310101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010101010101010101010348494a4b04040404040404040403
03030303030401010401040401010101010103030110101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010101010101010101010358595a4704040404040404040403
03030101010101040401040101010101010303011210101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010101010101010101010368696a5704040404040404040403
0303040101030404030101010101010103031212121010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101010101010101010101031f797a0404044504040404040403
0303010103030101030101010101010404121212121010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101010101010101010101030101010101015501010101010103
0303010403030103030301010101010104011212121010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101010101010101010101030101010101010101010101010103
03030103030204030303010101010b0103030312011010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101010101010101010101030101010105010101010101010103
03030103270a150a0a2801010101010101030303031010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101010101010101010101030120212223242526262636010103
03030103093d3d3d3d0701010101010101010303031010101010101010101010101010100000101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101010101010101010101030101313233343526262626010103
03030101093d3d3d3d0701010301010101010101031010101010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101010101010101010101030101010101010101010101010103
0303010109183d3e3d0701010303010101010101012c10101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101010101010101010101030101010101010101010101010103
03030101091817173d070101030303010e1d1d1d1d1010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101010101010101010101030303030303030303030303030303
0303030337080808083801010303030303030103031010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101010101010101010101010101010101010101010101010101
0303030301010101010101010303202101010103031010100010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101010101010101010101010101010101010101010101010101
0313030101010101010101010303013101010303031010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101010101010101010101010101010101010101010101010103
0301010101010101010101010403232425262626011010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101010101010101010101010101010101010101010101010103
0303030101010101010101021b03333435262626261010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101010101010101010101010101010101010101010101010103
__sfx__
680e00000d2500c2500b2500a25000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000001c35020350223502535029350000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001300001c350000001c350000001c35000000000001c350000001c350000001c35000000000001c3500000000000183500f3501c350000000000000000000000000000000000000000000000000000000000000
001800001c5251c5251c525000001c5251c5251c525000001c5251f525185251a5251c52500000000001c5251d5251d5251d5251d5251c5251c5251c5251c5251a5251a5251c5251a525000001f5250000000000
001800000e5150c5150e5150c5150e5150c5150e5150c5150e5150c5150e5150c5150e5150c5150e5150c5150e5150c5150e5150c5150e5150c5150e5150c5150e5150c5150e5150c5150e5150c5150e5150c515
79180000000001c5151c5151c515000001c5151c5151c515000001c5151f515185151a5151c51500000000001c5151d5151d5151d5151d5151c5151c5151c5151c5151a5151a5151c5151a515000001f51500000
011800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
02 04030544

