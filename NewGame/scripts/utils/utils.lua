--test

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

function dist(a,b)
	local dx=(b.x-a.x)/64
	local dy=(b.y-a.y)/64
	
	local dsq=dx*dx+dy*dy
	
	if (dsq<0) return 32767.9999
	
	return sqrt(dsq)
end

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

function tblclone(org)
    local t={}
    for key, value in pairs(org) do
        t[key] = value
    end
    return t
end


function get_sspr_x_y(spr_num)
	sx, sy = (spr_num % 16) * 8, flr(spr_num \ 16) * 8
	return sx, sy
end


function fade_out() 
	dpal={0,1,1, 2,1,13,6,
							4,4,9,3, 13,1,13,14}
	-- palette fade
	for i=0,40 do
		for j=1,15 do
			col = j
			for k=1,((i+(j%5))/4) do
				col=dpal[col]
			end
			pal(j,col,1)
		end
		flip() -- https://pico-8.fandom.com/wiki/Flip virke som flip e utdatert? Funksjonen funke ikke uten, derimot.
	end
end


function fade_in() -- reversed for-loops. not sure if working correctly
	dpal={0,1,1, 2,1,13,6,
							4,4,9,3, 13,1,13,14}
	-- palette fade
	for i=40,0,-1 do
		for j=15,1,-1 do
			col = j
			for k=1,((i+(j%5))/4) do
				col=dpal[col]
			end
			pal(j,col,1)
		end
		flip()
	end
end

function flash_text()

	flash_speed=5
	flashframe=0
	flash_color=8
	for i=0,120 do
		flashframe+=1
		if flashframe>flash_speed then
			flashframe=0
			if (flash_color==8) then 
				flash_color=9
			else
				flash_color=8
			end 
			
		end   
    end
	flash_text_bool=false
end

function fancy_draw_spr(spr,cf,maxf,x,y,sz)
    local t={}
    for i=1,maxf do
        add(t,0)
    end
    t[cf] = 7
    pal(t,0)
    spr(spr,x,y)
    pal()
end
--[[
    function _init()
	i=0
	t={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
end

function _draw()
	cls()
	pal(t, 0)
	spr(1,10,10)
	pal()
	spr(1,20,20)
end

function _update()
	t[i+1]=7
	i+=1
	if (t[i-1]==7) t[i-1]=0
end
--]]

--[[
function damage_enemy(enemy,item,hand)
	-- Base damage lookup
	if (item.type == "wand" || item.type == "orb") then
		local phys = 0
		local mag = item_dmg[item.type] * item.rarity
	elseif (item.type == "shield") then
		local phys = item_dmg[item.type] * item.rarity
		local mag = 0
	else
		local phys = item_dmg[item.type] * item.rarity
		local mag = item.rarity - 1
	end

	-- Armor and resistance
	phys -= enemy.armor
	if (enemy.resist != "none" && enemy.resist == item.element) then
		mag *= 0.5
	end
	local damage = phys + mag

	-- Conditional modifiers
	if (hand == 2)
		damage *= offhand_mod[item.type]
	end
	if (enemy.dbf == "holy") then
		damage *= 1.1
	end

	-- Damage and debuff application
	enemy.HP -= damage
	if (item.element != "none" && item.element != enemy.resist) then
		enemy.dbf = item.element
		enemy.dbft = 0 -- Timer reset
	end
end
]]