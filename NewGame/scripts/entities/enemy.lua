eanims ={
    idle1={fr=15,128},
    walk1={fr=10,129,130},
    idle2={fr=15,144},
    walk2={fr=10,145,146},
    idle3={fr=15,160},
    walk3={fr=10,161,162},
    idle4={fr=15,176},
    walk4={fr=10,177,178},
    idle5={fr=15,131},
    walk5={fr=10,132,133}
}

function make_enemy(x,y,lvl)
    local e={}
    e.type=rnd({1,2,3,4,5})
    e.spr=1
    e.x=x
    e.y=y
    e.dx=0
    e.dy=0
    e.sz=1
    e.acc=0.2

    e.health=lvl*10
    e.max_health=lvl*10
    e.armor=lvl*5
    e.xp=lvl*2
    e.resist="none"
    e.timer=t()

    e.curr_mt=nil
    e.play="idle"..tostr(e.type)
    e.anims=eanims
    e.flp=false
    e.attack=false
    e.aframe=0
    add(game_state.enemies,e)
end

function update_enemy(e)
    if (e.attack) e.aframe+=1
    move_enemy(e)
    enemy_attack(e)
    animate(e)
end

function draw_enemy(e)
    spr(abs(e.spr),e.x,e.y,e.sz,e.sz,e.flp)
    print(e.health,e.x,e.y-4,2)
end

function move_enemy(e)
    e.dx=0
    e.dy=0
    if dist(e,p)*64 < 40 then
        local dir = atan2(p.x-e.x,p.y-e.y)
        e.dx += cos(dir)
        e.dy += sin(dir)
        e.play="walk"..tostr(e.type)
    else
        e.play="idle"..tostr(e.type)
    end

    find_map_tile(e)
    player_collide_map(e,"left")
    player_collide_map(e,"right")
    player_collide_map(e,"up")
    player_collide_map(e,"down")

    e.x += e.dx
    e.y += e.dy
end

function enemy_attack(e)
    if (collide_sprite(e,"center",p) and (t() - e.timer)>1) then
        p.health-=1
        e.timer=t()
    end
end

function kill_enemy(e)
    if (e.health<=0) then
        p.curr_exp+=e.xp
        if p.curr_exp>p.level_up then
            p.curr_exp=p.curr_exp%p.level_up
            p.level+=1
            p.level_up=p.level*10
        end
        del(game_state.enemies,e)
    end
end

function enemies_for_map(lvl)
    for _,x in pairs(maze) do
        for _,y in pairs(x) do
            srand(y.x+y.y)
            if (not y.is_wall and not y.goal) then
                if (rnd()>0.75) make_enemy(y.x*y.scale+y.ox+rnd(y.scale-2*8)+8,y.y*y.scale+y.oy+rnd(y.scale-2*8)+8,lvl)
            end
        end
    end
end