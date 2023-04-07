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
    p.curr_mt=nil
    update_atk(0)
end

function update_player()
    if (flash_text_bool) flash_text()

    atk_frames()
    move_player()
    player_pickup()
    player_attack()
    update_attack()
    update_bullets()
    animate(p)
    fancy_anim(patk1)
    fancy_anim(patk2)
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

    

    --map collision
    find_map_tile(p)
    player_collide_map(p,"left")
    player_collide_map(p,"right")
    player_collide_map(p,"up")
    player_collide_map(p,"down")

    if (p.curr_mt.x==game_state.goal[1] and p.curr_mt.y==game_state.goal[2]) init_level(game_state.level)

    --update position
    p.x+=p.dx
    p.y+=p.dy
end

function player_collide_map(en,dir)
    local scale = maze[1][1].scale
    local ox = maze[1][1].ox
    local oy = maze[1][1].oy
    local checkx1=en.x-1<en.curr_mt.x*scale+ox
    local checkx2=en.x+1>en.curr_mt.x*scale+scale+ox-en.sz*8
    local checky1=en.y-1<en.curr_mt.y*scale+oy
    local checky2=en.y+1>en.curr_mt.y*scale+scale+oy-en.sz*8
    if dir=="left" and checkx1 and maze[en.curr_mt.x-1][en.curr_mt.y].is_wall then
        if (en.dx<0) then
            en.dx=0
            en.x=en.curr_mt.x*scale+ox
        end
    elseif dir=="right" and checkx2 and maze[en.curr_mt.x+1][en.curr_mt.y].is_wall then
        if (en.dx>0) then
            en.dx=0
            en.x=en.curr_mt.x*scale+scale+ox-en.sz*8
        end
    elseif dir=="up" and checky1 and maze[en.curr_mt.x][en.curr_mt.y-1].is_wall then
        if (en.dy<0) then
            en.dy=0
            en.y=en.curr_mt.y*scale+oy
        end
    elseif dir=="down" and checky2 and maze[en.curr_mt.x][en.curr_mt.y+1].is_wall then
        if (en.dy>0) then
            en.dy=0
            en.y=en.curr_mt.y*scale+scale+oy-en.sz*8
        end
    end
end

function find_map_tile(en)
    local scale = maze[1][1].scale
    local ox = maze[1][1].ox
    local oy = maze[1][1].oy
    if en.curr_mt != nil then
        if (en.curr_mt.x*scale+ox < en.x and en.x+en.sz*8 < en.curr_mt.x*scale+scale+ox and en.curr_mt.y*scale+oy < en.y and en.y+en.sz*8 < en.curr_mt.y*scale+scale+oy) return
    end
    for _,x in pairs(maze) do
        for _,y in pairs(x) do
            if y.x*scale+ox < en.x+1 and en.x+en.sz*8-1 < y.x*scale+scale+ox and y.y*scale+oy < en.y+1 and en.y+en.sz*8-1 < y.y*scale+scale+oy then 
                en.curr_mt=y
                return
            end
        end
    end
end

function player_pickup()
    for j,i in ipairs(game_state.current_items) do
        if collide_sprite(p,"center",i) then
            if #inventory<16 then 
                sfx(17)
                flash_text_bool=true
                
                add(inventory,i)
                deli(game_state.current_items,j)
            else
                p.inv_full=true
            end
        end
    end
end

function player_attack()
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

function update_attack()
    if p.attack then
        patk1.x=p.x+p.sz\2+patk1.dir[1]*8
        patk1.y=p.y+p.sz\2+patk1.dir[2]*8

    elseif p.attack2 then
        patk2.x=p.x+p.sz\2+patk2.dir[1]*8
        patk2.y=p.y+p.sz\2+patk2.dir[2]*8
    end
end

function atk_collide()
    --TODO: make hit moment dependent on item
    for _,e in pairs(game_state.enemies) do
        if patk1.aframe==patk1.max_aframe\2 then
            if (collide_atk(patk1,e) and patk1.spr != -1) damage_enemy(e,equipment[1],1)
        elseif patk2.aframe==patk2.max_aframe\2 then
            if (collide_atk(patk2,e) and patk2.spr != -1) damage_enemy(e,equipment[2],2)
        end
        --bullet collision
        for i,b in ipairs(bullets) do
            if collide_atk(b,e) then
                damage_enemy(e,equipment[b.slot],b.slot)
                b.hit=true
            end
        end
        --destroy bullets that hit something
        kill_bullets()
    end
end

function draw_attack(atk)
   sx, sy = get_sspr_x_y(atk.spr)

   if (atk.spr != -1) sspr(sx,sy,8,8, atk.x,atk.y,atk.sw,atk.sh,p.flp, p.left_swipe)
end

function fancy_draw_attack(atk)
    if not atk.anims[atk.play].fancy then
        draw_attack(atk)
    else
        fancy_draw_spr(atk)
    end
end

function current_player_health()
    local curr = p.health/p.max_health
    if (curr>0) return curr
    return 0
end

function current_player_mana()
    local curr=p.mana/p.max_mana
    if (curr>0) return curr
    return 0
end

function update_atk(item,slot)
    if item==0 then
        if slot == nil then
            patk1=tblclone(atk0)
            patk2=tblclone(atk0)
        elseif slot==1 then
            patk1=tblclone(atk0)
        else
            patk2=tblclone(atk0)
        end
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
        patk1.spr=-1
        p.play="idle"
        patk1.aframe=0
        p.attack=false
    end

    --if attack 2 is done, reset
    if patk2.aframe==patk2.max_aframe then
        patk2.play="idle"
        patk2.spr=-1
        p.play="idle"
        patk2.aframe=0
        p.attack2=false
    end
end