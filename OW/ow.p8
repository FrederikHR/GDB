pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
--init
--new game in space!!!
--by gdb


function _init() menu_init() end

function menu_init()

	camera(0,0)

	initfont()
	vine_sx,vine_sy=get_x_y(64)
	vine_posx, vine_posy=80,80
	
	ice_sx,ice_sy=get_x_y(66)
	ice_posx, ice_posy=50, 20
	
	wind_sx,wind_sy=get_x_y(68)
	wind_posx, wind_posy=20, 80
	
	menu_planets={
		vine={sx=vine_sx,sy=vine_sy,
		posx=vine_posx,posy=vine_posy,spd=.15,t_lim=85,d_lim=75,top=true },
		ice={sx=ice_sx,sy=ice_sy,
		posx=ice_posx,posy=ice_posy,spd=.12, t_lim=25,d_lim=15, top = false},
		wind={sx=wind_sx,sy=wind_sy,
		posx=wind_posx,posy=wind_posy,spd=.15, t_lim=83,d_lim=77, top = true}
		}
	
	--celeste code
	starting=false
	start_game_flash=0
	music(2)
	--celeste code
	
	
	menu=true
 _update=menu_update
 _draw=menu_draw
 scene="menu"
 wl=false
 kiwi_t=time()
 make_player()
 make_astronaut()
 
 xs={{23,55},{33,55},{109,61}}
 for x in all(xs) do
 	make_enemy(x[1]*8,x[2]*8)
 end
end

function menu_update()
	--update_transition()
	update_planets_menu()
 if (btnp(❎)) and not starting then
 	music(-1)
 	sfx(7)
 	start_game_flash=40
 	starting=true
 end
 if starting then
 	start_game_flash-=1
 	if start_game_flash <=-30 then
 				game_init() --play the game
 				starting=false
 	end
 end
end

function game_init()
	-- do transition here
	-- have to wait, so that 
	-- transition can be over
	-- before game_draw begins
	game_over = false
	_update=game_update
	_draw=game_draw
	scene="game"
	landing=false
	within=false
	launch=false
	prompt=false
	blocks_found=false
	prompt_wait=10 -- to do:fix 
	bx1=0
	by1=0
	bx2=0
	by2=0
	
	-- camera offsets
	cx, cy = 0, 0
	
	
	box = {}
	box.x = 25
	box.y = 40
	box.w = 70
	box.h = 32
end

function end_menu()
	cls()
	if wl then
		print("you win!",a.x,a.y,9)
	else
		print("you lose!",a.x,a.y,9)
	end
	print("press ❎ to restart",a.x-20,a.y+10,9)
end

function end_update()
	if (btnp(❎)) menu_init() --play the game
end
-->8
--draw and camera

function menu_draw()
	cls()	
	
	
	for _,p in pairs(menu_planets) do
		sspr(p.sx,p.sy, 16,16,p.posx, p.posy,25,25)
	end

	
	draw_starting_screen()
	print("honey chaser", 43, 10)
	print("collect the honey\n\n   for your ship",30,60, 9)
	spr(122, 100,58)
	ship_x,ship_y=get_x_y(110)
	--sspr(ship_x, ship_y,16,16, 100,74, 8,8)
	spr(16, 100, 70)
	
	print("    ❎\n\n".." to start",45,100, 9)
	print(tosmall("made by gdb"), 80, 122)
	
end


function game_draw()
	cls()
	pal()--reset palette
	camera(cx,cy)
	map(0, 0)
	if p.space then
		draw_stars(p)
		draw_planets()
		draw_player()
		draw_pind()
		draw_hud()
		if prompt then
			draw_prompt()
		end
		-- find disappearing blocks
		if (not blocks_found) find_blocks()
	else
		--do on-planet stuff
		draw_stars(a)
		map(0, 0)
		draw_blocks()
		draw_astronaut()
		draw_hud()
		draw_items()
		for _,e in pairs(enemies) do
			draw_enemy(e)
		end
		draw_kiwi(false)
		if xlkiwi.alive then
			draw_kiwi(true)
		end
		draw_wind()
		
		--debug
		--draw_bs()
		--draw_bss()
		
		if a.prompt then
			draw_prompt()
		end
	end
end

function spr_r(s,x,y,a,w,h)
 sw=(w or 1)*8
 sh=(h or 1)*8
 sx=(s%16)*8
 sy=flr(s/16)*8
 x0=flr(0.5*sw)
 y0=flr(0.5*sh)
 a=a/360
 sa=sin(a)
 ca=cos(a)
 for ix=0,sw-1 do
  for iy=0,sh-1 do
   dx=ix-x0
   dy=iy-y0
   xx=flr(dx*ca-dy*sa+x0)
   yy=flr(dx*sa+dy*ca+y0)
   if (xx>=0 and xx<sw and yy>=0 and yy<=sh) then
    pset(x+ix,y+iy,sget(sx+xx,sy+yy))
   end
  end
 end
end

function scroll_camera(pa,s,fromspace)

	--basic scrolling
	--cx = px - 64
	--cy = py - 64

	--[[slighty less basic 
	scrolling	
	--]]
	if s then
		if fromspace then
			cx=pa.x-60+pa.sw/2
			cy=pa.y-65+pa.sh/2
		else
			cx=pa.x-50+pa.sw/2
			cy=pa.y-50+pa.sh/2
		end
	else
		if pa.x <= box.x then
			cx -= box.x - pa.x
			box.x=pa.x

		elseif pa.x+pa.sw*8 >= box.x+box.w then
			local diff = (pa.x+pa.sw*8) - (box.x + box.w)
			cx += diff
			box.x += diff
		end


		if pa.y < box.y then
			cy -= box.y - pa.y
			box.y -= box.y - pa.y
		end

		if pa.y+pa.sh*8 > box.y + box.h then
			local diffy = (pa.y+pa.sh*8) - (box.y+box.h)
			cy += diffy
			box.y += diffy
		end
	end
end

function animate(an)
	if an.state != an.play then
		an.state = an.play
		an.animindex=1
		an.time=0
	elseif #an.anims[an.state] > 1 then
		an.time+=1
		if an.time > an.anims[an.state].fr then
			an.time=0
			an.animindex = (an.animindex % #an.anims[an.state]) + 1
			if an.animindex==1 and an.anims[an.state].next then
				an.play=an.anims[an.state].next
				an.state=an.play
			end
		end
	end
	an.spr = an.anims[an.state][an.animindex]
end

function draw_prompt()
	local psx=cx+10
	local psy=cy+84
	local psx1=psx+80
	local psy1=psy+12
	
	rectfill(psx,psy,psx1,psy1,5)
	if p.space then
		print("press 🅾️ to land",psx+1,psy+1,7)
	else
		print("press 🅾️ to take off",psx+1,psy+1,7)
	end	
	print("press ❎ to continue",psx+1,psy+7,7)
end

function draw_hud()
	local isx=cx+5     local isy=cy+1
	local	isx1=isx+12  local isy1=isy+6
	local hsx=cx+110   local hsy=cy+1
	local	hsx1=hsx+18  local hsy1=hsy+6
	
	rectfill(isx,isy,isx1,isy1,0)
	rectfill(hsx,hsy,hsx1,hsy1,0)
	
	--draw honey
	for i=1,3 do
		pal({[4]=5,[9]=6,[10]=7})
		spr(122,isx+1+9*i,isy+1)
		pal()
	end
	for i=1,a.items do
		spr(122,isx+1+9*i,isy+1)
	end
		
	--draw lives
	print("♥",hsx+1,hsy+1, 8)
	print("\88"..a.lives,hsx+10,hsy+1,7)
end

function draw_starting_screen()
	pal()
	
	-- start game flash
	if starting then
		local c=10
		if start_game_flash > 10 then
				c=7		
		elseif start_game_flash > 7 then
			c=6
		elseif start_game_flash > 3 then
		 c=5
		elseif start_game_flash > 0 then
			c=1
		else 
			c=0
		end
		--if c<10 then
			pal(1,c)
			pal(2,c)
			pal(3,c)
			pal(4,c)
			pal(5,c)
			pal(6,c)
			pal(7,c)
			pal(8,c)
			pal(9,c)
			pal(10,c)
			pal(11,c)
			pal(12,c)
			pal(13,c)
	
		--end
	end
end


-->8
--update


function game_update()
	if p.space then
		if not landing and not launch then
			update_player()
			scroll_camera(p,false,false)
			land()
		elseif launch then
			scroll_camera(p,true,true)
			update_player()
			launch=false
		end
	else
		update_astronaut()
		update_blocks()
		if a.pl.spr==68 then
			update_wind()
			make_particle(a.x,a.y)
		end
		scroll_camera(a,true,false)
		for _,e in pairs(enemies) do
			update_enemy(e)
		end
		update_kiwi(false)
		if xlkiwi.alive then
			update_kiwi(true)
		end
	end
end


function update_planets_menu()
		if not starting then
		for _,p in pairs(menu_planets) do
			if p.posy <= p.t_lim and p.top then
				p.posy+=p.spd
			
			else
				p.top=false
			end
			if p.posy >= p.d_lim and not p.top then
				p.posy-=p.spd
		 else
		 	p.top=true
			end
		end
end
end
-->8
--player

panims={
	idle={fr=15,38,38},
	thrust={fr=4}
}

function make_player()
	p = {}
	p.spr=78
	p.x=-600
	p.y=-600
	p.a=0
	p.dx=0
	p.dy=0
	p.max_dx=2
	p.max_dy=3
	p.acc=.2
	p.boost=4
	p.play="idle"
	p.sw=2
	p.sh=2
	p.flp=false
	p.space=true
	p.anims=panims
	p.clopl=0
end

function draw_player()
	--spr(abs(p.spr),p.x,p.y,p.sw,p.sh,p.flp!=(p.spr<0))
	spr_r(p.spr,p.x,p.y,p.a,p.sw,p.sh)
end

function update_player()
	if p.space then
		move_player()
		--animate(p)
	else
		return
	--animate(p)
	end
end

function move_player()
	--landing procedure
	if (landproc()) return
	
	--all other movement
	--add gravity
	if p.space then
		local gx=0.
		local gy=0.
		gx,gy=gravity()
		p.dx+=gx
 	p.dy+=gy
 else
 	--astronaut functions reign
 	return
	end
	
	if p.space then
		if btn(⬅️) then
	 	p.a-=10
		elseif btn(➡️) then
			p.a+=10
		end 
		if btn(⬆️) then
			--p.play="thrust"
			at = -(p.a-90)/360
			p.dx+=p.acc*cos(at)
			p.dy+=p.acc*sin(at)
			p.spr=1
			sfx(8)
		else
			sfx(-1)
			p.play="idle"
			p.spr=78
		end
	else
		--astronaut functions reign
		return
	end
	
	--keeps you away from
	-- the planet maps
	if (p.x>=-55 and p.dx>0) p.dx=0
	if (p.y>=-55 and p.dy>0) p.dy=0
	
	--limit speeds
	if (p.dx>5) p.dx=5
	if (p.dy>5) p.dy=5
	
	--add diffs
	p.x+=p.dx
	p.y+=p.dy
end

function land()
	--handle logic and prompt
	--for landing
	c=0
	for _,pl in pairs(planets) do
		c+=1
		if pcoll(pl.x+16,pl.y+16) then
			c-=1
			p.clopl=pl
			if within==false then
				within=true
		 	prompt=true
		 	--landing=true
			end
		elseif c==3 then
			--ship is outside sphere of influence 
			within=false
			prompt=false
		end
	end
end

function landproc()
	if prompt then
		p.dx=0
		p.dy=0
		if btn(❎) then
	 	prompt=false
	 	landing=false
	 	within=true
	 	return true
		elseif btn(🅾️) then
			--do all the stuff
			p.space=false
			p.prompt=false
			prompt=false
			landing=true
			a.prompt=false
			a.pl=p.clopl
			a.x=p.clopl.sx
			a.y=p.clopl.sy
			
			if p.clopl.spr==68 then
				make_wind(a.x,a.y)
				music(5)
			end
			
			if p.clopl.sp then
				a.ship={x=p.clopl.sx-64,y=p.clopl.sy-48,sz=64}
			else
				a.ship={x=p.clopl.sx+16,y=p.clopl.sy-48,sz=64}
			end
			return true
		end
	end
end
-->8
--other functions

function gravity()
 --calculate simple gravity on ship
 gravc=0.003
	local pd=-1
	local pdx=0
	local pdy=0
	local magx=0
	local magy=0
	
	--due to planet resize
	local oft=8
	
	--find closest planet
	for _,pl in pairs(planets) do
		if (pd==-1) then
		 pd=pdist(pl.x+oft,pl.y+oft)
		 pdx=pl.x+oft
		 pdy=pl.y+oft
		end
		if (pdist(pl.x+oft,pl.y+oft)<pd) then
			pd=pdist(pl.x+oft,pl.y+oft)
			pdx=pl.x+oft
			pdy=pl.y+oft
		end
	end
	
	local p2=pd--^2
	if (p2<0) return 32767.9999
	local mag=gravc/(p2)
	magx+=mag*(pdx-p.x)
	magy+=mag*(pdy-p.y)

	if (magx>10) magx=10
	if (magy>10) magy=10
	if (magx<-10) magx=-10
	if (magy<-10) magy=-10

	if pd>1.5 then
		magx=0
		magy=0
	end
	
	if pd<=0.001 then
		magx=0
		magy=0
	end

	return magx,magy
end


function collide_map(obj,aim,flag)
	--obj = table, needs x,y,w,h
	local x=obj.x    local y=obj.y
	local w=obj.sw*8 local h=obj.sh*8
	
	local x1=0 local y1=0
	local x2=0 local y2=0
	
	if aim=="left" then
		x1=x    	 y1=y+1
		x2=x+1    y2=y+h-1
	elseif aim=="right" then
		x1=x+w-1    y1=y+1
		x2=x+w      y2=y+h-1
	elseif aim=="up" then
		x1=x+4    y1=y-1
		x2=x+w-4  y2=y
	elseif aim=="down" then
		x1=x+3      y1=y+h
		x2=x+w-2    y2=y+h+1
	elseif aim=="downish" then
		x1=x+4        y1=y+h
		x2=x+w-2      y2=y+h+2
 elseif aim=="center" then
		x1=x+2      y1=y
		x2=x+w-2    y2=y+h-2
	end
	
	--pixels to tiles
	x1/=8 y1/=8
	x2/=8 y2/=8
	
	if fget(mget(x1,y1),flag)
	or fget(mget(x1,y2),flag)
	or fget(mget(x2,y1),flag)
	or fget(mget(x2,y2),flag) then
		local sp={mget(x1,y1),mget(x1,y2),mget(x2,y1),mget(x2,y2)}
		return true,x1,y1,x2,y2,sp
	end
	return false
end

function collide_sprite(obj,aim,obj2)
	--obj = table, needs x,y,w,h
	local x=obj.x    local y=obj.y
	local w=obj.sz*8 local h=obj.sz*8
	
	local x1=0 local y1=0
	local x2=0 local y2=0
	
	if aim=="left" then
		x1=x-1    y1=y
		x2=x      y2=y+h-1
	elseif aim=="right" then
		x1=x+w-1    y1=y
		x2=x+w      y2=y+h-1
	elseif aim=="up" then
		x1=x+2    y1=y-1
		x2=x+w-3  y2=y
	elseif aim=="down" then
		x1=x+2      y1=y+h
		x2=x+w-2    y2=y+h
 elseif aim=="center" then
		x1=x+2      y1=y+2
		x2=x+w-2    y2=y+h-2
	end
	
	--pixels to tiles
	--x1/=8 y1/=8
	--x2/=8 y2/=8
	if not((obj2.x > x2)
	or (obj2.y > y2)
	or ((obj2.x+obj2.sz) < x1)
	or ((obj2.y+obj2.sz) < y1)) then
		return true
	end
	
	return false
end

function collcheck(a,b)
	print(a.x+a.sz,a.x-40,a.y)
	print(b.x,a.x-20,a.y)
	print(a.y+a.sz,a.x-40,a.y-10)
	print(b.y,a.x-20,a.y-10)
end

function pdist(x,y)
	local dx=(x-p.x)/64
	local dy=(y-p.y)/64
	
	local dsq=dx*dx+dy*dy
	
	if (dsq<0) return 32767.9999
	
	return sqrt(dsq)
end

function pcoll(x,y)
	if pdist(x,y) < 0.38 then
		return true
	end
	return false
end

function round(x)
	return flr(x+0.5)	
end
-->8
-- planets
planets = {
	--vine planet
	p1={spr=64,
					x=-700,
					y=-530,
					sz=2,
					c=11,
	    sx=54*8,
	    sy=54*8,
	    sp=false},
	--ice planet
	p2={spr=66,
					x=-400,
					y=-500,
					sz=2,
					c=12,
	    sx=73*8,
	    sy=61*8,
	    sp=true},
	--wind planet
	p3={spr=68,
					x=-800,
					y=-650,
					sz=2,
					c=6,
	    sx=73*8,
	    sy=29*8,
	    sp=true}
}


function draw_planets()

	for _,pl in pairs(planets) do
		sx, sy = get_x_y(pl.spr)
		sspr(sx,sy, 16, 16, pl.x, pl.y, 32,32, true)		
	end
end

function draw_pind()
	--planet indicators
	local indd=16
	for _,pl in pairs(planets) do
		local pdx=p.x-pl.x
		local pdy=p.y-pl.y
		if abs(pdx) > 64 or abs(pdy) > 64 then
			local dir=atan2(pdx,pdy)
			local dirx=-indd*cos(dir)
			local diry=-indd*sin(dir)
			circfill(p.x+p.sw*8/2+dirx,p.y+p.sh*8/2+diry,2,pl.c)
		end
	end
end

function draw_stars(p)
	--screen=128x128
	local csx=flr(p.x/128)
	local csy=flr(p.y/128)
	
	for i=-1,1 do
		for j=-1,1 do
			--populate each area
			srand((i+csx)+(j+csy)*100)
			local x0=(i+csx)*128
			local y0=(j+csy)*128
			for k=1,50 do
				generate_star(x0,y0)
			end
		end
	end

end

function generate_star(x0,y0)
	local x=rnd(128)+x0
	local y=rnd(128)+y0
	local c=rnd(8)
	
	if (c>4) return
	c+=5 
	if (c==8) c-=1
	pset(x,y,c)
end
-->8
--astronaut
aanims={
	idle={fr=4.5,32,34,36,38},
	walk={fr=1,3,5,7,9,11,13},
	jump={fr=4.5,40, 42, 44, 46},
	fall={fr=1, 46}
}
a_gravity=0.5
friction=0

--jump velocity
jv=2.65

function make_astronaut()
	a={}
	a.x=70
	a.y=70
	a.spr=32
	a.size=2
	a.acc=2.5
	a.sw=2
	a.sh=2
	a.sz=2
	a.dx=0
	a.dy=0
	a.max_dx=0
	a.max_dy=0
	a.play="idle"
	a.flp=false
	a.anims=aanims
	a.anim_time = 0
	a.anim_descend = true
	a.jump=false
	a.fall=false
	a.jump_velocity=jv
	a.grav=a_gravity
	a.pl={}
	a.prompt=false
	a.within=false
	a.items=0
	a.friction=false
	a.lives=3
	
end
function draw_astronaut()
	sp = 108
	sx, sy = (sp % 16) * 8, flr(sp \ 16) * 8
	spr(abs(a.spr), a.x, a.y, a.size, a.size,a.flp!=(a.spr<0))
	if not a.pl.sp then
		sspr(sx,sy, 16, 16, a.pl.sx+16, a.pl.sy-48, 64,64, true)
	else
		sspr(sx,sy, 16, 16, a.pl.sx-64, a.pl.sy-48, 64,64, false)
	end
end

function update_astronaut()
	move_astronaut()
	animate(a)
	if a.pl.spr==64 and a.x<=46*8 and #kiwis<2 then
		--spawn kiwis
		if time()-kiwi_t > 2 or time()<1 then
			make_kiwi(false,a.x,a.y)
			kiwi_t=time()
		end
	end
end

function move_astronaut()
	if (launchproc()) return
	if a.friction or a.fall then
		a.dx*=0.85
	else
		--non-slidy
		a.dx*=friction
	end
	a.dy+=a_gravity
	
	if (a.pl.spr==68) a.dx-=0.5
	
	if btn(⬅️) and not(btn(➡️)) then
	 if not a.fall or a.friction then
	 	a.dx-=a.acc
	 else
	 	a.dx-=a.acc/3
	 end
	 a.flp=true
	 if not a.fall and not a.jump then
		 a.play="walk"
	 end
	 
	elseif btn(➡️) and not(btn(⬅️)) then
		if not a.fall or a.friction then
	 	a.dx+=a.acc
	 else
	 	a.dx+=a.acc/3
	 end
		a.flp=false
		if not a.fall and not a.jump then
			a.play="walk"
		end
	else
		if not a.fall and not a.jump then		
			--if (not a.friction) a.dx=0
			a.play="idle"
		end
	end
		
	--jumping
	if collide_sprite(a,"center",a.ship) then
		if (btnp(❎) and not a.prompt) a.prompt=true
	else
		if (a.within) a.within=false
		jump()
	end
	
	--pickup items
	pickup()

	if a.lives==0 then 
		_update=end_update
		_draw=end_menu
		music(-1, 300)
		--sfx(7)
	end
	
	
	--environment
	if collide_map(a,"center",5) then
		_,_,_,_,_,sp = collide_map(a,"center",5)
		for s in all(sp) do
			if s==73 or s==74 or s==75  then
				--for spikes or lava
				astro_death()
				break
			end
		end
	end
	
	-- spring collision
	if collide_map(a, "right", 7) then
		a.dx=-3
	end
	--enemies
	collide_enemies()
	collide_kiwis()
	if xlkiwi.alive then
		if collide_sprite(a,"center",xlkiwi) then
			astro_death()
		end
	end
	
	--check collision up and down
	local old_ady=a.dy
	if a.dy>0 and (collide_map(a,"down",0) and not collide_map(a,"downish",4)) then
		a.dy=0
		a.y-=((a.y+a.sh*8+1)%8)-1
		
		--slidy blocks
		if collide_map(a,"down",2) then
		 a.friction=true
		else
			a.friction=false
		end
		
		--breaking blocks
		if collide_map(a,"downish",3) then
			_,bx1,by1,bx2,by2=collide_map(a,"downish",3)
			bx1=round(bx1)-1 by1=round(by1)
			bx2=round(bx2)-1 by2=round(by2)
			if (bx2 >=bx1+2) bx2=bx2-1
			find_block(bx1,by1,bx2,by2)
		end
	
		--[[
		these two variables
		are set to false when player
		hits the ground
		--]]
		a.fall = false
		a.jump = false
		
	elseif a.dy<0 and collide_map(a,"up",1) then
		a.dy=0
	end
	
	--check collision left and right
	if a.dx<0 and collide_map(a,"left",1) then
		a.dx=0
	elseif a.dx>0 and collide_map(a,"right",1) then
		a.dx=0
	end
	
	--limit speeds
	if (a.dx>3) a.dx=3
	--if (a.dy>5) a.dy=5
	if (a.dx<-3) a.dx=-3
	--if (a.dy<-3) a.dy=-3
	
	--outside map
	if (a.y>64*8) astro_death()
	
	--add diffs
	a.x+=a.dx
	a.y+=a.dy
end

function jump()

	if (btnp(❎)) and not a.jump then
		a.jump = true
		a.play="jump"
		a.friction=false
		a.stand=false
	end
	
	if a.jump and a.jump_velocity > 1 and not a.fall then
		a.dy -= a.jump_velocity
		a.jump_velocity -= 0.8
	end
	
	-- start falling 
	if a.jump and a.jump_velocity <= 1 then
		a.fall = true
		a.grav*=1.1
	end
	
	if not a.jump then
		a.jump_velocity = jv
	end
	if a.fall then
		a.play = "fall"
	end
end

function launchproc()
	if a.prompt then
		a.dx=0
		a.dy=0
		if btn(❎) and a.within==false then
			a.within=true
	 	a.prompt=false
	 	return false
		elseif btn(🅾️) then
			--do all the stuff
			
			--win
			if a.items==3 then
				wl=true
				_update=end_update
				_draw=end_menu
				music(-1, 300)
				--sfx(6)
			else
				p.space=true
				launch=true
				landing=false
				prompt=false
				a.within=false
				return true
			end
		end
	end
end

function astro_death()
	a.lives=a.lives-1
	a.dx=0
	a.dy=0.1
	a.x=p.clopl.sx
	a.y=p.clopl.sy
end

function reset_camera(obj)
	p.x=-600
	p.y=-600
	cx=obj.x-50+obj.sw/2
	cy=obj.y-50+obj.sh/2
	box.x=25-590
	box.y=40-590
end
-->8
--map elements
--e.g. items and blocks

--=======items=========

items={
	--key at vine
	i1={s=112,x=2*8,y=51*8,
	sz=1,taken=false},
	--key at ice
	i2={s=112,x=77*8,y=47*8,
	sz=1,taken=false},
	--key at wind
	i3={s=112,x=75*8,y=11*8,
	sz=1,taken=false}
}

function draw_items()
	for _,item in pairs(items) do
		if not item.taken then
			spr(item.s,item.x,item.y)
		end
		if items.i1.taken and not xlkiwi.alive then
			--spawn xl kiwi
			make_kiwi(true)
		end
	end
end

function pickup()
	for _,item in pairs(items) do
		if not item.taken and collide_sprite(a,"center",item) then
			item.taken=true
			a.items+=1
		end
	end
end

--======spring=======

spring={cx=12,cy=12,sprung=false}

function update_spring()
	
end

--======blocks=======

blocks={}

function draw_blocks()
	for _,b in pairs(blocks) do
		mset(b.cx,b.cy,b.spr)
	end
end

function update_blocks()
	for i,b in ipairs(blocks) do
		if	b.stand or (b.s>0 and b.ospr==90) then
			b.s=b.s+1
		else
			if b.ospr==90 then
				b.spr=90
				b.s=0
			else
				b.spr=106
				b.s=10
			end
			--return
		end
		if b.s>=10 and b.spr==90 then
			b.spr=106
		elseif b.s>=20 and b.spr==106 then
			b.spr=105
		elseif b.s>=40 then
			b.stand=false
			if b.ospr==90 then
				b.s=0
			else
				b.s=10
			end
		end
	end
end

function find_blocks()
	--really inefficient way
	-- to find all blocks
	for i=0,128 do
		for j=0,64 do
			if mget(i,j)==90 then
				local b={spr=90,ospr=90,x=i*8,y=j*8,
													cx=i,cy=j,
													s=0,stand=false}
				add(blocks,b)
				mset(i,j,0)
			elseif mget(i,j)==106 then
				local b={spr=106,ospr=106,x=i*8,y=j*8,
													cx=i,cy=j,
													s=10,stand=false}
				add(blocks,b)
				mset(i,j,0)
			end
		end
	end
	blocks_found=true
end

function find_block(bbx1,bby1,bbx2,bby2)
	--find block corresponding to coords
	for i,b in ipairs(blocks) do
		if b.cx==bbx1 and b.cy==bby1 then
			b.stand=true
		elseif b.cx==bbx1 and b.cy==bby2 then
			b.stand=true
		elseif b.cx==bbx2 and b.cy==bby1 then
			b.stand=true
		elseif b.cx==bbx2 and b.cy==bby2 then
			b.stand=true
		else
			b.stand=false
		end
	end
end

--======enemies=======

enemies={}

eanims={
 walk={fr=15,15,31}
}

function make_enemy(x,y)
	local e={}
	e.spr=15
	e.x=x
	e.y=y
	e.dx=0
	e.sz=1
	e.sh=1
	e.sw=1
	e.flp=false
	e.anims=eanims
	e.play="walk"
	add(enemies,e)
end

function draw_enemy(e)
	if e.x<64*8 then
 	spr(abs(e.spr),e.x,e.y,e.sz,e.sz,e.flp!=(e.spr<0))
	else
		if e.y>32*8 then
			pal(8,12)
			spr(abs(e.spr),e.x,e.y,e.sz,e.sz,e.flp!=(e.spr<0))
			pal()
		else
			spr(abs(e.spr),e.x,e.y,e.sz,e.sz,e.flp!=(e.spr<0))
		end
	end
end

function update_enemy(e)
	if not e.flp then
		e.dx=0.5
		if collide_map(e,"right",1) then
			e.flp=true
			e.dx*=-1
		end
	else
		e.dx=-0.5
		if collide_map(e,"left",1) then
			e.flp=false
			e.dx*=-1
		end
	end
	e.x+=e.dx
	animate(e)
end

function collide_enemies()
	--astro collides with enemies
	for _,e in pairs(enemies) do
		if collide_sprite(a,"center",e) then
			astro_death()
		end
	end
end

kiwis={}
xlkiwi={}

function make_kiwi(xl,x,y)
	if xl then
		xlkiwi.x=a.x-80
		xlkiwi.y=a.y-16
		xlkiwi.sz=64
		xlkiwi.spr=104
		xlkiwi.spd=2
		xlkiwi.alive=true
	else
		k={}
		if x<=30 or not a.flp then
			k.x=x+30+rnd(10)-5
			k.flp=true
		else
			k.x=x-30+rnd(10)-5
			k.flp=false
		end
		k.y=y-40
		k.sz=1
		k.spr=104
		k.set=false
		k.dir=0
		k.spd=3.5
		
		add(kiwis,k)
	end
end

function update_kiwi(xl)
	if xl then
		xlkiwi.x+=xlkiwi.spd
	else
		for k in all(kiwis) do
			if outside(k.x,k.y) then
				del(kiwis,k)
				goto cont
			end
			if not k.set then
				k.set=true
				local dx=a.x-k.x
				local dy=a.y-k.y
				k.dir=atan2(dx,dy)
			end
				k.x+=k.spd*cos(k.dir)
				k.y+=k.spd*sin(k.dir)
			
			::cont::
		end
	end
end

function draw_kiwi(xl)
	if xl then
		kx,ky=get_x_y(104)
		sspr(kx,ky,8,8,xlkiwi.x, xlkiwi.y, 64,64)
	else
		for k in all(kiwis) do
			spr(k.spr,k.x,k.y,k.sz,k.sz,k.flp)
		end
	end
end

function collide_kiwis()
	--astro collides with enemies
	for _,k in pairs(kiwis) do
		if collide_sprite(a,"center",k) then
			astro_death()
		end
	end
end

function outside(x,y)
	return x>a.x+64 or x<a.x-64 or y>a.y+64 or y<a.y-64
end


--=====wind=====
wps={}
aspd=-5

function make_wind(x,y)
	for i=1,100 do
		w={}
		srand(x+y+i)
		w.x=rnd(140) + x + 10
		w.y=rnd(128) + y - 64
		w.dx=aspd
		add(wps,w)
	end
end

function draw_wind()
	for _,w in pairs(wps) do
		pset(w.x,w.y,7)
	end
end

function update_wind()
	for _,w in pairs(wps) do
		if w.x>a.x-70 and w.x<a.x+100 and w.y>a.y-70 and w.y<a.y+70 then
			w.x+=w.dx
			w.y+=0.01
		else
			del(wps,w)
		end
	end
end

function make_particle(x,y)
	local i=0
	while #wps < 100 do
		w={}
		srand(x+y+wps[1].x)
		w.x=rnd(140) + x + 10
		w.y=rnd(128) + y - 64
		w.dx=aspd
		add(wps,w)
	end
end
-->8
--todo--

--[[
	tor-arne
	 -	kiwi

	
	frederik
	level design lava
	transitions
	 - copy paste bubbles

	done
	intro screen
	intro text 
	- wind physics (walking)
	add music (encompasing + 
												game over + win)											
	win condition
	 - screen and logic
	game over
		- screen and logic
	- honey hud
	
--]]
-->8
--transitions--
t=0

function update_transition()
 --increase timer
 t+=0.05
end

function draw_transition()
 cls()
	
 --this crazy bit loops through
 --limited background colors,
 --and changes it when the
 --screen is covered with white
 local c = 12 + ((t-2.55)/4)%4
 rectfill(0,0,128,128,c)

 for i=0,8 do -- column loop
  for j=0,8 do -- row loop
    --x positions are snapped
    --to 16px columns
    local x = i*16

    --this number sweeps back
    --and forth from -1 to 1
    local osc1 = sin(t+i*0.1)

    --this number also sweeps
    --back and forth, but at
    --a different rate
    local osc2 = sin(t/4+j*0.03)

    --y positions are influenced
    --by one of the sweepy
    --numbers
    local y = j*16 + osc1*10

    --the circles' radii are
    --influenced by the other
    --sweepy number
   circfill(x, y, osc2*15, 7)
  end
 end
end
-->8
--sspr and small print--
function get_x_y(sp)
	sx, sy = (sp % 16) * 8, flr(sp \ 16) * 8 
	return sx, sy
end

ft={}
function initfont()
  small="\65\66\67\68\69\70\71\72\73\74\75\76\77\78\79\80\81\82\83\84\85\86\87\88\89\90"
  big="abcdefghijklmnopqrstuvwxyz"
  for i=1,26 do
    ft[sub(big,i,i)]=sub(small,i,i)
  end
end

function tosmall(str)
  smallstr=""
  for i=1,#str do
    c=sub(str,i,i)
    if c>="a" and c<="z" then
      smallstr=smallstr..ft[c]
    else
      smallstr=smallstr..c
    end
  end
  return smallstr
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000005666600000000000566660000000000000000000000000000000000000000000000000000000000056666000000000000
00700700000000a11a00000000000056666670000000005666667000000000055666000000000000000000000000000156660000000000566666700000888000
00077000000009511590000000000056666760000000005666676000000000556666700000000001566600000000005566667000000000566667600008688800
00077000000092599529000000000056667660000000005666766000000000556667600000000015666670000000005566676000000000566676600008688800
00700700000065222256000000000056666670000000005666667000000000556666600000000055666760000000005566666000000000566666700008888680
00000000000699999999600000000955666755000000095566675500000000556666700000000055666660000000005566667000000009956667500088888880
00000000004042999924040000000195555519000000019555551900000001955666500000000055666670000000019556665000000001955555190088888888
00000000004049222294040000004419999991000000441999999100000004195555190000000419566600000000041955551900000044199999910000000000
09999055006669999996660000005419999dd10000005419999dd1000000054199999100000005d955559000000005419999910000005419999dd10000000000
9669251000990999999099000000556d99ddd6000000556d99ddd6000000055699ddd600000005569999d0000000055699ddd6000000556d99ddd60000000000
966621a000a9099999909a000000d56dddd226000000d56dddddd60000000556ddddd60000000556dddd600000000556ddddd6000000d56dddddd60000888800
999961a000090029920090000000d122222d10000000d1222222100000000050022210000000001dd2210000000000d1222210000000d1222222100008688880
99992110000000022000000000001ddd000dd00000001ddd000dd0000000000dd0dd000000000000d00000000000000d0dd0000000001ddd00dd000008888680
09999200000000000000000000000dd00000000000000dd0000dd00000000000000d00000000000000d000000000000dd000000000000dd00000000088888880
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000088888888
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000056666000000000005666600000000000000000000000000000000000000000000566660000000000056666000000000005666600000000000000000000
00000566666700000000056666670000000000566660000000000000000000000000005666667000000000566666700000000056666670000000000555555000
00000566667600000000056666760000000005666667000000000056666000000000005666676000000000566667600000000056666760000000005666676000
00000566676600000000056667660000000005666676000000000566667600000000005666766000000000566676600000000055666660000000005666666000
00000566666700000000056666670000000005666766000000000566676600000000005666667000000000556666700000000055566670000000005666667000
00009556667550000000956666765000000005666667000000000566666700000000095566675500000009555555550000000495555555000000009566666000
000019555555900000001956666590000000956666765000000005666676500000000195555519000000019d5555190000004419d55519000000011956665500
0004419999991400000019555555900000001956666590000000195666659000000044199999910000004419ddd9910000005419ddd991000000044195559100
000541d9999d140000044199999914000000195555559000000019555555900000005419999dd10000005419999dd1000000556d999dd100000005419999d100
000556dd99dd6500000546d9999d6400000441999999140000044199999914000000556d99ddd6000000556d99ddd6000000d56dd9ddd60000000556d99dd100
000556dddddd6500000556dd99dd6500000546d9999d6400000546d9999d64000000d56dddd226000000d56dddd226000000d1222dd2260000000d56ddddd600
0000d122212210000000d12221221000000556dd99dd6500000556dd99dd65000000d122212d10000000d122221dd00000001dddd21dd00000000d12221dd600
000015dd0ddd1000000015dd0ddd10000000d122212210000000d1222122100000001ddd000dd00000001ddd0000000000000ddd00000000000000dd00022000
000005d000dd0000000005d000dd0000000005d000dd0000000005d000dd000000000dd00000000000000dd000000000000000000000000000000000000dd000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
030000333330000b0000000000000cc0000066666000770000000000666666666666666600000000888888888988888877777777777777770000000000000000
b0300355555300300000000000c0ccc008000000060777700000000066666666666666660c0000008888888899988888777777777c7777770000000000000000
000344333335330000000c177771cc0000808556d75000000000000077777777777777770c000c0088888888898888887c777c77c7777777000000a11a000000
00344445555450000000c1666675100c0008a555555500000000000077776777777767770c000c008888888888888888c77cc777c77777770000095115900000
034444b444444430000c1666666770c00089569555555000000000007776777777767777cc00cc7088888888888888987cc7cc7ccc7777770000925995290000
003333333333334000c16656666666000065556555d6a0000000000077777767777777677cc0ccc08888888888988989c77c7ccccc7777770000652222560000
004555555534444000c165156666660000d66655565a8000000000007677767776777677ccc7ccc78888888888888898c7777ccc7c7777770006999999996000
03444444444b44430016511566666600005555555d988000000000007767777777677777cccccccc8888888888888888c777777c777777770040429999240400
3044444444444443006665566666660000557755556666600000000000000000000000005555555544444444c77777777777777c777777770040492222940400
0333333333333330006666666667560000577775559880000000000008000000000003005555555549999994777ccc7c77cccc77cccccccc0066699999966600
004443555555554000066666667010000077775555598000000000008a80000000003030555555554999999477c7ccc77c7cccc7000007000000099999900000
000444b44444443000006666670cc000000a8856655590000000000008000f8f0003003055555555499999947cccccc77ccc77cccccc7ccc0000099999900000
0b0055555555530000000777751ccc00000098855d55770000000000030008383003000055555555499999947cccccc77ccc77ccccc7cccc0000002992000000
3030433333333000000000000000cc00000609996557777700000000030000300303000055555555499999947c7ccc777cccccc7cc7cccc70000000220000000
300030444440000000000000000000c00000666d00000000000000000300003003030000555555554999999477ccc77777cccc77cccccc7c0000000000000000
033300000000000000000000000000000000000000000000000000000300003003030000555555554444444477777777777777c7000007000000000000000000
333333335565555555555555000000000000000000000000033b003bb33000000000000000000000444444440000000099299922220000000000000000000000
43444345565556655555555500000000000000000000333333333bb33b33bbb000444000000000004099950400aaaaa064999299995000000000000000000000
3453433455555665566556650009222222999900003333333bb333bbbbb3333b44484800000000004009909400a000a064692999959055000000000000000000
3434454355555555555556650091222229122290b33b33bbbb33333bbbb33b3344444400000000004900099400a0a0a060692999522500000000000000000000
343444435655555556655555091222222912222933b333bbb333333bbbb33bb344444990000000004950099400aaaaa064662992111120000000000000000000
5434544355655565566555550912222229122229333333bbb335553bbbb333334544500900000000450900040000a000646629921a1a20000000000000000000
4434444355556555555565550912999229122229333333bbb335543bbbb333330500500000000000409999040000a00029992992111120000000000000000000
5434444355555555555555550912909229122229333333bbb334444bbb3333300050050000000000444444440000aaa029992992111120000000000000000000
0000000044444444444444440999000999999999333333bb00444440bb33333b0000000000000000000000000000000029952992222290000000000000000000
09999aa0444444444444444409190009191222293333b3b000444440bb33333b004000000000004009999aa0000000009256521aa19950000000000000000000
9559559444344444444455440919909919122229333b3bb000555550bbb3333b0094505000000094955955940000000099659911119560000000000000000000
9449449443444443444455440919999919122229333b3bb000444440bbb33b330094050500000094944944940000000096929911119060000000000000000000
4944444444444434444444440912999129122229333b3bb0004444400bb33bb3009405050000009449444444000000009969295dda0006000000000000000000
494444444444444445544444091229122912222933333b00004444400bb333330094505000000094494444440000000009699005dda006000000000000000000
05555550434444444554454409122222291222290303b00000444440000bb30000400000000000400555555000000000056500005dda56500000000000000000
00444400344444444444444409122222291222290003b000005555500000b000000000000000000000444400000000005666500005dda6650000000000000000
b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4
b4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4
94949494949494949494949494949494949494949494949494949494949494949494949494949494949494949494949494949494949494949494949494949494
b4747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474
06000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b4740000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000074
06000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b4740000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000074
06000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b4740000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000074
06000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b4740000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000074
06000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b4740000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000074
06000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b4740000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000074
06000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b4740000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000074
06000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b4740000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000074
06000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b4740000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000074
06000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b4740000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000074
06000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b4740000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000074
06000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b4740000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000074
06000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b4740000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000074
06000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b4740000000000000000000085000085000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000074
06000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b4740000000000000000758506060606750000000000d5d500000000000000000000000000000000000000000000000000000000000000000000000000000074
06000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b4747474747400007474747474747474747474747474d4c5000000d5d5d5000000d5d5d500000000000000000000000000000000000000000000000000000074
06000000000000000000000000000056667600000056667600000000000000566676000000566676000000000000000000000000000000000000000000000000
b4747474747400007474747474747474747474747474c5c4000000b5c5d4000000c5b5c5000000d5d5d5d5d5d500000000000000000000000000000000000074
06000000000000000000000000000057677700000057677700000000000000576777000000576777000000000000000000000000000000000000000000000000
b4740000000000000000000000000000000000747474d4c5000000c5d4c5000000b5c5c4000000c4c5c4c5c5c500000000000000000000000000000000000074
06060606060000000000566676000000670000000000670000000000000000006700000000006700a5a5a5000000000000000000000000000000000000000000
b4740000000000000000000000000000000000747474c5c50000000000000000000000000000000000000000000000d5d5000000000000000000000000000074
1717171706060000000057677700000067000000000067000000a5a5a50000006700000000006700000000000000000000000000000000000000000000000000
b474000000000000000000000000000000000074747400000000000000000000000000000000000000000000000000d5d5000000000000000000000000000074
17171717170606000000006700000000670000000000670000000000000000006700000000006700000000000000000000000000000000000000000000000000
b4740000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d5d500000000000000000074
27272727170606060000006700000085670000000085670085750000000075006700000085006700008575008506060675000000000000000000000000000000
b4740000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000074
27272727171717170606060606060606060606060606060606060000000606060606060606060606060606060606060606060606060606060606060606060606
b4740000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008774
27272717171717171706171717170617171706060617171706060000000606060606170606171706060606061706060606060606060606171717171706171706
b4740000000000000000000000000000000000747474d500000000000000000000000000000000000000000000000000000000000000000000000000d5d5d574
27171717171717171717172717171717171717171717171706060000000606171717171717171717170617171717060606061717171717171717171717171706
b4740000000000000000000000000000000000747474d4d500000000000000000000000000000000000000000000000000000000000000000000000000000074
17171717171717171717172727271717171717171717171706060000000617171717171717171717171717171717171717171717171717171717171717171706
b47474747400000000000000000000a5a50000747474c5c4d5000000000000000000000000000000000000000000000000000000000000d5d5d5d5d500000074
27272727272727271717171717271717171717172727272727060000000627272717171717271717171717171717171717271717171717271717272727272727
b474747474740000000000a5a5000000000000747474c5c5b5d500000000000000000000000000000000000000d5d5d5d5d5d5d5000000000000000000000074
27272727272727272727272727272727272727272727272727060000000627272717171727172727172727171717271727272727272717171717172727272727
b4747474747400000000000000003646000074747474c5c5b5b5d5000000000087b5c4d5d5d5d5d5d5d5d5000000000000000000000000000000000000000074
27272727272727272727272727272727272727272727272727060000000627272727272727271717171717171727272727272727171717172727272727272727
b4747474747400000000000000003747000074747474c5d4c5d4b5d5d5d5d5d5b5d4d49494949494949494949494949494949494949494949494949494949474
27272727272727272727272727272727272727272727272727060000000627272727272727272727272727272727272727272727272727272727272727272727
b4747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474
__label__
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888eeeeee888eeeeee888eeeeee888eeeeee888eeeeee888eeeeee888777777888888888888888888ff8ff8888228822888222822888888822888888228888
8888ee888ee88ee88eee88ee888ee88ee888ee88ee8e8ee88ee888ee88778777788888888888888888ff888ff888222222888222822888882282888888222888
888eee8e8ee8eeee8eee8eeeee8ee8eeeee8ee8eee8e8ee8eee8eeee87778777788888e88888888888ff888ff888282282888222888888228882888888288888
888eee8e8ee8eeee8eee8eee888ee8eeee88ee8eee888ee8eee888ee8777888778888eee8888888888ff888ff888222222888888222888228882888822288888
888eee8e8ee8eeee8eee8eee8eeee8eeeee8ee8eeeee8ee8eeeee8ee87778787788888e88888888888ff888ff888822228888228222888882282888222288888
888eee888ee8eee888ee8eee888ee8eee888ee8eeeee8ee8eee888ee877788877888888888888888888ff8ff8888828828888228222888888822888222888888
888eeeeeeee8eeeeeeee8eeeeeeee8eeeeeeee8eeeeeeee8eeeeeeee877777777888888888888888888888888888888888888888888888888888888888888888
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111166616161666166611111616166616111166116616661666161611111c1c1111111111111111111111111111111111111111111111111111111111111111
1111116116161666161611111616161116111616161111611161161617771c1c1111111111111111111111111111111111111111111111111111111111111111
1111116116161616166611111616166116111616161111611161166611111ccc1111111111111111111111111111111111111111111111111111111111111111
111111611616161616111111166616111611161616111161116111161777111c1111111111111111111111111111111111111111111111111111111111111111
117116611166161616111666116116661666166111661666116116661111111c1111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1ee11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1e1e1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1e1e1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1e1e1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1ee111ee1eee1eee11ee1ee111111661166616661616111116661166166616661166166116661616166611711171111111111111111111111111111111111111
1e1e1e1111e111e11e1e1e1e11111616161616161616111116161611116116161616161616161616116117111117111111111111111111111111111111111111
1e1e1e1111e111e11e1e1e1e11111616166116661616111116661666116116611616161616661616116117111117111111111111111111111111111111111111
1e1e1e1111e111e11e1e1e1e11111616161616161666111116161116116116161616161616161616116117111117111111111111111111111111111111111111
1e1e11ee11e11eee1ee11e1e11111666161616161666166616161661116116161661161616161166116111711171111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111118888811111111111111111111111111111111111
1bbb1bbb1171166611111166166616661111111116661111161611111111166611111616111111111ccc11118878811111111111111111111111111111111111
1b1b1b1b171116161111161116161616111111111616111116161111111116161111161611111111111c11118887811111111111111111111111111111111111
1bbb1bb11711166611111666166616611111111116661111116111111111166611111666111111111ccc11118887811111111111111111111111111111111111
1b111b1b1711161611111116161116161171111116161111161611711111161611111116117111111c1111718887811111111111111111111111111111111111
1b111b1b1171161611711661161116161711111116161171161617111111161611711666171111111ccc17118878811111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1bbb1bbb11711bbb1bbb11bb11711666111111661666166611711111111116661111161611111111166611111616111111111666111111661666166616661111
1b1b1b1b17111b1b1b1b1b1117111616111116111616161611171111111116161111161611111111161611111616111111111616111116111161111616111111
1bbb1bb117111bbb1bb11bbb17111666111116661666166111171111111116661111116111111111166611111666111111111666111116661161116116611111
1b111b1b17111b1b1b1b111b17111616111111161611161611171171111116161111161611711111161611111116117111111616111111161161161116111171
1b111b1b11711b1b1bbb1bb111711616117116611611161611711711111116161171161617111111161611711666171111111616117116611666166616661711
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1ee11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1e1e1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1e1e1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1e1e1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1ee111ee1eee1eee11ee1ee111111616166616611666166616661111166611661666166611661661166616161666117111711111111111111111111111111111
1e1e1e1111e111e11e1e1e1e11111616161616161616116116111111161616111161161616161616161616161161171111171111111111111111111111111111
1e1e1e1111e111e11e1e1e1e11111616166616161666116116611111166616661161166116161616166616161161171111171111111111111111111111111111
1e1e1e1111e111e11e1e1e1e11111616161116161616116116111111161611161161161616161616161616161161171111171111111111111111111111111111
1e1e11ee11e11eee1ee11e1e11111166161116661616116116661666161616611161161616611616161611661161117111711111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11661616166611111666116616661666116616611666161616661171117111111111111111111111111111111111111111111111111111111111111111111111
16161616161111111616161111611616161616161616161611611711111711111111111111111111111111111111111111111111111111111111111111111111
16161616166111111666166611611661161616161666161611611711111711111111111111111111111111111111111111111111111111111111111111111111
16161666161111111616111611611616161616161616161611611711111711111111111111111111111111111111111111111111111111111111111111111111
16611161166616661616166111611616166116161616116611611171117111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
16611666166616661666166611711666117111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
16161161166616161161161117111616111711111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
16161161161616661161166117111666111711111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
16161161161616161161161117111616111711111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
16161666161616161161166611711616117111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1ee11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1e1e1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1e1e1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1e1e1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1ee111ee1eee1eee11ee1ee111111666116616161666111116661166166616661166166116661616166611711171111111111111111111111111111111111111
1e1e1e1111e111e11e1e1e1e11111666161616161611111116161611116116161616161616161616116117111117111111111111111111111111111111111111
1e1e1e1111e111e11e1e1e1e11111616161616161661111116661666116116611616161616661616116117111117111111111111111111111111111111111111
1e1e1e1111e111e11e1e1e1e11111616161616661611111116161116116116161616161616161616116117111117111111111111111111111111111111111111
1e1e11ee11e11eee1ee11e1e11111616166111611666166616161661116116161661161616161166116111711171111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111661161617171111166616661666116616661666116616611111111111111111111111111111111111111111111111111111111111111111111111111111
11111616161611711777161116161161161111611161161616161111111111111111111111111111111111111111111111111111111111111111111111111111
11111616116117771111166116611161161111611161161616161111111111111111111111111111111111111111111111111111111111111111111111111111
11111616161611711777161116161161161111611161161616161111111111111111111111111111111111111111111111111111111111111111111111111111
11711666161617171111161116161666116611611666166116161111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111661161611111111166611111166166616661616166616661616111111111111111111111111111111111111111111111111111111111111111111111111
11111616161611711777161611111611161616161616116111611616111111111111111111111111111111111111111111111111111111111111111111111111
11111616166617771111166611111611166116661616116111611666111111111111111111111111111111111111111111111111111111111111111111111111
11111616111611711777161611111616161616161666116111611116111111111111111111111111111111111111111111111111111111111111111111111111
11711666166611111111161616661666161616161161166611611666111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee11111bbb1bbb1bb1117111666661117111111eee1ee11ee111111ee111ee1eee11711bbb1bbb1bb11171116666611171117111111eee1e1e1eee1ee11111
1e1111111b1b11b11b1b171116661166111711111e1e1e1e1e1e11111e1e1e1e11e117111b1b11b11b1b17111661166611171117111111e11e1e1e111e1e1111
1ee111111bb111b11b1b171116611166111711111eee1e1e1e1e11111e1e1e1e11e117111bb111b11b1b17111661116611171117111111e11eee1ee11e1e1111
1e1111111b1b11b11b1b171116661166111711111e1e1e1e1e1e11111e1e1e1e11e117111b1b11b11b1b17111661166611171117111111e11e1e1e111e1e1111
1e1111111bbb11b11b1b117111666661117111111e1e1e1e1eee11111e1e1ee111e111711bbb11b11b1b11711166666111711171111111e11e1e1eee1e1e1111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
16661111166116161111111116661111166611661166111111111111111111111111111111111111111111111111111111111111111111111111111111111111
16161111161616161111177716161111161616111611111111111111111111111111111111111111111111111111111111111111111111111111111111111111
16661111161611611777111116661111166616111611111111111111111111111111111111111111111111111111111111111111111111111111111111111111
16161111161616161111177716161111161616111611111111111111111111111111111111111111111111111111111111111111111111111111111111111111
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
82888222822882228888822282228882822882228222888888888888888888888888888888888888888882228282822282228882822282288222822288866688
82888828828282888888888282888828882888828882888888888888888888888888888888888888888888828282828282888828828288288282888288888888
82888828828282288888882282228828882882228882888888888888888888888888888888888888888882228222828282228828822288288222822288822288
82888828828282888888888288828828882882888882888888888888888888888888888888888888888882888882828288828828828288288882828888888888
82228222828282228888822282228288822282228882888888888888888888888888888888888888888882228882822282228288822282228882822288822288
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030320202003030000000000000000000000030b0303050000030303000003030300000b000000000000000000000000008000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
4b4b00000000000000005876000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004b590000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000059
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004b590000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000059
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004b5900000000000000000000000000000000000000000000000000000000000000000000000000000000005a5a5a5a5a5a000000000000005a5a000000000059
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004b590000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000059
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004b5900000000000000000000000000000000000000000000000000000000000000000000005a5a5a000000000000000000000000000000000000000000000059
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004b590000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000059595959
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004b590000000000000000000000000000000000000000000000000000000000005a00000000000000000000000000000000000000000078595959595959595959
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004b5900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005a5a5a5a5a5a595959595959595959
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004b590000000000000000000000000000000000000000000000005a000000000000000000000000000000005959595959594a4a4a4a4a4a595959595959590059
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004b5900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000614a4a4a4a4a4a590000000000000059
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004b5900000000000000000000000000000000000000000000000000000000000000000000000000005a5a00000000000061626259616161610000000000000059
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004b590000000000000058580000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000059
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004b590000000000585760606060605758000000005a000000000000000000000000005a5a00000000000000000000000000000000000000000000000000000059
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004b596262000000595962595959595959590000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000059
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004b595959000000595959595962625959000000000000000000000000000000000000000000000059590000000000000000000000000000000000000000000059
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004b595959000000595959595959595959000000000000000000000000000000000000000000000059595900000000000000000000000000000000000000000059
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004b59595900000059595959595959595900000000000000000000000000000000000000000000005959595900000000000000005a5a5a5a000000000000000059
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004b5900000000000000000000000000000000000000000000000000000000000000000000000000594b5959594b4a4a4b4a590000000000000000000000000059
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004b590000000000000000000000000000000000000000000000000000000000000000000000000000594a59595959595959595900000000005a5a5a5a00000059
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004b590000000000000000000000000000000000000000000000000000000000000000000000000000000059595959595959595900000000000000000000000059
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004b590000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000059
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004b590000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005959
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004b590000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000596159
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004b610000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005959595959595959
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004b59000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005a5a5a5a000000000000000059
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004b590000000000000000000000000000000000000000000000000000000000000000000000000000000000000062596259620000000000000000000000000059
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004b590000000000000000000000000000000000000000000000000000000000000000000000005a5a5a5a5a000062595962620000000000000000000000000059
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004b59000000000000000000000000000000000000000000000000000000000000005a5a5a5a000000000000000062626262590000000000000000000000000059
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004b610000000000000000000000000000000000000000000000000062626262626200000000000000000000000062596262620000000000000000000000000059
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004b590000000000000000000061614b4b4b6161625a5a5a5a5a5a6262624b4b62624b4a4b4a4a4b4a4a4b4a4b4b4a4b4b4b4b4a4b4b4a4b4b4b4a4b4b4b4a4b59
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004b610000000000000000006161614a4b4a6161614a4b4b4a4a4a6262624a4b62624a4a4a4b4a4b4a4a4a4b4a4b4b4a4a4b4a4a4a4a4b4a4b4b4a4b4a4b4a4a59
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004b595959595959595959595959595959595959595959595959595959594a4a595959595959595959595959595959595959595959595959595959595959595959
__sfx__
011200000c0231b0001b0001c000246151d00000000000000c023000000000000000246150000000000000000c023000000000000000246150000000000000000c02300000000000000024615000000000000000
001200000211202102021120000002112000000211200000021120000002112000000211200000021120000004112030000411200000041120000004112000000411202102041120000004112000000411200000
001200000611202102061120000006112000000611200000061120000006112000000611200000061120000004112030000411200000041120000004112000000411202102041120000004112000000411200000
0012000818715007051c7150070518715007051c71500705007050070500705007050070500705007050070500705007050070500705007050070500705007050070500705007050070500705007050070500705
001200000c0320c0220c0121000213032130221301212002170321702217012000020000210002130321302218032180221703217022150321502213032000021503215032170320000213032130221301200002
001200000c0320c0220c012100021303213022130121200217032170221701200002000021000213032130221803218022170321702215032150221303200002150321503217032000021a0321a0221703217022
001000000000018250140000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
52100000286502865028650286502865028650286402864028630286302861028610286102861028610286102861021600236001f10020100241002a100000000000000000000000000000000000000000000000
6614000f1061010610106101061010610106101061010610106101061010610106101061010610106102860028600286002860028600286002860028600286002860028600286002860028600286002860028600
00080000165501b040165501d0401d5502004022550240502c050000000000000000000001a500210000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000600001a050151401c050171401f05019140220501c140240501e14026050201402a050231402d05026140310500500007000080000a0000b0000c000000000000000000000000000000000000000000000000
491000201e6101d6101b6101a6101961018610176101561013610116100f6100d6100b610096100561003610016100061000610006100161002610046100561006610086100b6100d6100f610136101561017610
4810000012610106100e6100d6100b6100a61009610086100861007610056100561007610096100961009610086100861008610096100e6100f6100e6100d6100a610096100b6100f61013610196101b6101c610
__music__
01 00010304
02 00020305
01 41044444
02 41054344
01 410b4344
02 410c4344

