eanims ={
    idle={fr=15,17,18},
    walk={fr=10,17,18,19,20},
    attack_1={fr=10,7,8,9,10},
    damaged_idle={fr=10,33,34},
    damaged_walk={fr=10,33,34,35,36}
}

enemies={}

function make_enemy(x,y,lvl)
    local e={}
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
    e.resist="none"
    e.timer=t()

    e.play="idle"
    e.anims=eanims
    e.flp=false
    e.attack=false
    e.aframe=0
    add(enemies,e)
end

function update_enemy(e)
    if (e.attack) e.aframe+=1
    move_enemy(e)
    if e.health < e.max_health then
        e.play = "damaged_"..e.play
    end
    enemy_attack(e)
    animate(e)
end

function draw_enemy(e)
    spr(abs(e.spr),e.x,e.y,e.sz,e.sz,e.flp)
    print(e.health,e.x,e.y-4,7)
end

function move_enemy(e)
    e.dx=0
    e.dy=0
    if dist(e,p)*64 < 10 then
        local dir = atan2(p.x-e.x,p.y-e.y)
        e.dx += cos(dir)
        e.dy += sin(dir)
        e.play="walk"
    else
        e.play="idle"
    end

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
    if (e.health==0) del(enemies,e)
end