panims ={
    idle={fr=15,5,6},
    walk={fr=10,1,2,3,4},
    attack_1={fr=10,7,8,9,10},
}

atk_anims = {
    idle={fr=1,16},
    slice={fr=0.6, 21,22,23,24.25,26,27,28,29,30}
}

p={}
atk={
    spr=0,
    x=0,
    y=0,
    sz=1,
    dir={1,0},
    play="idle",
    anims=atk_anims  
}

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
    p.pressarrow=false
    p.flp=false
    p.attack=false
    p.interact=false
    p.aframe=0
    p.max_aframe=10
end

function update_player()
    if (p.attack) p.aframe+=1
    --if attack is done, reset
    if p.aframe==p.max_aframe then
        atk.play="idle"
        p.play="idle"
        p.aframe=0
        p.attack=false
    end
    move_player()
    player_interact()
    if not p.interact then
        player_attack()
        animate(p)
        animate(atk)
    end
end

function draw_player()
    spr(abs(p.spr),p.x,p.y,p.sz,p.sz,p.flp)
end

function move_player()
    p.dx=0
    p.dy=0

    local dir=atk.dir
    local updown=false

    if btn(⬅️) then
        p.dx-=p.acc
        p.flp=true
        p.play="walk"
        p.pressarrow=true
        dir[1]=-1
    end
    if btn(➡️) then
        p.dx+=p.acc
        p.flp=false
        p.play="walk"
        p.pressarrow=true
        dir[1]=1
    end
    if btn(⬆️) then
        p.dy-=p.acc
        p.play="walk"
        p.pressarrow=true
        dir[2]=-1
        updown=true
    end
    if btn(⬇️) then
        p.dy+=p.acc
        p.play="walk"
        p.pressarrow=true
        dir[2]=1
        updown=true
    end

    -- if no arrow presses and no attack, idle animation
    if (not p.pressarrow and not p.attack) then
        p.play="idle"
    end
    p.pressarrow=false

    -- update attack
    if (not updown) dir[2]=0
    atk.dir=dir
    atk.x=p.x+atk.dir[1]*8
    atk.y=p.y+atk.dir[2]*8

    --update position
    p.x+=p.dx
    p.y+=p.dy
end

function player_interact()
    -- if not already attacking
    if p.aframe == 0 then
        if collide_map(p,"center",0) and btn(❎) then
            p.interact=true
            inv_init()
        end
    end
end

function player_attack()
    -- if not already attacking
    if p.aframe == 0 then
        if btnp(❎) then
            p.attack=true
            --p.play="attack_1"
            p.play="attack_1"
            atk.play="slice"
        end
        if btnp(🅾️) then
            p.attack=true
        end
    end
    atk_collide()
end

function atk_collide()
    if p.aframe==p.max_aframe\2 then
        for _,e in pairs(enemies) do
            if (collide_sprite(atk,"atk",e)) e.health-=1
        end
    end
end

function draw_attack()
    spr(abs(atk.spr),atk.x,atk.y,atk.sz,atk.sz,p.flp)
end