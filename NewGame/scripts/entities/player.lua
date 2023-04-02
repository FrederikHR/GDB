panims ={
    idle={fr=15,5,6},
    walk={fr=10,1,2,3,4},
    attack_1={fr=10,7,8,9,10},
}

player_sfx={attack_sfx = 1}

p={}
patk1={}
patk2={}
flash_text_bool=false
function make_player()
    p.spr=1
    p.x=64
    p.y=64
    p.dx=0
    p.dy=0
    p.sz=1
    p.acc=2
    p.dir={1,0}
    p.play="idle"
    p.anims=panims
    p.health=10
    p.max_health=10
    p.mana=10
    p.max_mana=10
    p.pressarrow=false
    p.left_swipe=false
    p.attack=false
    p.attack2=false
    p.interact=false
    p.inv_full=false
    update_atk(0)
end

function update_player()
    if (flash_text_bool) flash_text()

    atk_frames()
    move_player()
    player_pickup()
    player_attack()
    update_attack()
    animate(p)
    animate(patk1)
    animate(patk2)
end

function draw_player()
    if (flash_text_bool) print("got item!", p.x-5, p.y-10, flash_color)
    spr(abs(p.spr),p.x,p.y,p.sz,p.sz,p.flp)
end

function move_player()
    p.dx=0
    p.dy=0

    local dir1=patk1.dir
    local dir2=patk2.dir
    local updown=false

    if btn(⬅️) then
        p.dx-=p.acc
        p.flp=true
        p.play="walk"
        p.pressarrow=true
        dir1[1]=-1
        dir2[1]=-1
    end
    if btn(➡️) then
        p.dx+=p.acc
        p.flp=false
        p.play="walk"
        p.pressarrow=true
        dir1[1]=1
        dir2[1]=1
    end
    if btn(⬆️) then
        p.dy-=p.acc
        p.play="walk"
        p.pressarrow=true
        dir1[2]=-1
        dir2[2]=-1
        updown=true
    end
    if btn(⬇️) then
        p.dy+=p.acc
        p.play="walk"
        p.pressarrow=true
        dir1[2]=1
        dir2[2]=1
        updown=true
    end

    -- if no arrow presses and no attack, idle animation
    if (not p.pressarrow and not p.attack and not p.attack2) then
        p.play="idle"
    end
    p.pressarrow=false

    --update attack direction
    if not p.attack then
        if (not updown) dir1[2]=0
        patk1.dir=dir1
    end
    if not p.attack2 then
        if (not updown) dir2[2]=0
        patk2.dir=dir2
    end

    --update position
    p.x+=p.dx
    p.y+=p.dy
end

function player_pickup()
    local pickedup={}
    for j,i in ipairs(current_items) do
        if collide_sprite(p,"center",i) then
            if #inventory<16 then 
                sfx(17)
                flash_text_bool=true
                
                add(inventory,i)
                add(pickedup,j)
            else
                p.inv_full=true
            end
        end
    end
    for i in all(pickedup) do
        deli(current_items,i)
    end
end

function update_attack()
    if p.attack then
        --patk1.x=p.x+p.sz\2+8*cos(atan2(dir1[1],dir1[2]))
        --patk1.y=p.y+p.sz\2+8*sin(atan2(dir1[1],dir1[2]))
        patk1.x=p.x+p.sz\2+patk1.dir[1]*8
        patk1.y=p.y+p.sz\2+patk1.dir[2]*8

    elseif p.attack2 then
        patk2.x=p.x+p.sz\2+patk2.dir[1]*8
        patk2.y=p.y+p.sz\2+patk2.dir[2]*8
    end
end

function player_attack()
    -- if not already attacking
    if patk1.aframe==0 and patk2.aframe==0 then
        if btnp(🅾️) then
            p.attack=true
            p.play="attack_1"
            do_atk(1)
        elseif btnp(❎) then
            p.attack2=true
            p.play="attack_1"
            do_atk(2)
        end
    end
    atk_collide()
end

function atk_collide()
    --TODO: make hit moment dependent on item
    for _,e in pairs(enemies) do
        if patk1.aframe==patk1.max_aframe\2 then
            if (collide_atk(patk1,e) and patk1.spr != -1) e.health-=1
        elseif patk2.aframe==patk2.max_aframe\2 then
            if (collide_atk(patk2,e) and patk2.spr != -1) e.health-=1
        end
    end
end

function draw_attack()
   sx1, sy1 = (patk1.spr % 16) * 8, flr(abs(patk1.spr) \ 16) * 8
   sx2, sy2 = (patk2.spr % 16) * 8, flr(abs(patk2.spr) \ 16) * 8

   if (patk1.spr != -1)  sspr(sx1,sy1,8,8, patk1.x,patk1.y,patk1.sw,patk1.sh,p.flp, p.left_swipe)
   if (patk2.spr != -1)  sspr(sx2,sy2,8,8, patk2.x,patk2.y,patk2.sw,patk2.sh,p.flp, p.left_swipe)
end

function fancy_draw_attack()
    print("asdfa")
end

function current_player_health()
    return p.health/p.max_health
end

function current_player_mana()
    return p.mana/p.max_mana
end

function update_atk(item,slot)
    if item==0 then
        patk1=tblclone(atk0)
        patk2=tblclone(atk0)
    else
        if slot==1 then
            patk1=tblclone(item_atks[item])
        else
            patk2=tblclone(item_atks[item])
        end
    end
end

function atk_frames()
    if (p.attack) patk1.aframe+=1
    if (p.attack2) patk2.aframe+=1

    --if attack 1 is done, reset
    if patk1.aframe==patk1.max_aframe then
        patk1.play="idle"
        p.play="idle"
        patk1.aframe=0
        p.attack=false
    end

    --if attack 2 is done, reset
    if patk2.aframe==patk2.max_aframe then
        patk2.play="idle"
        p.play="idle"
        patk2.aframe=0
        p.attack2=false
    end
end