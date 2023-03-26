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
    p.aframe=0
end

function update_player()
    if (p.attack) p.aframe+=1
    --if attack is done, reset
    if p.aframe==10 then
        atk.play="idle"
        p.play="idle"
        p.aframe=0
        p.attack=false
    end
    move_player()
    player_attack()
    animate(p)
    animate(atk)
end

function draw_player()
    spr(abs(atk.spr),p.x+atk.dir[1]*8,p.y+atk.dir[2]*8,p.sz,p.sz,p.flp)
    spr(abs(p.spr),p.x,p.y,p.sz,p.sz,p.flp)
end

function move_player()
    p.dx=0
    p.dy=0

    local dir={0,0}

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
    end
    if btn(⬇️) then
        p.dy+=p.acc
        p.play="walk"
        p.pressarrow=true
        dir[2]=1
    end

    -- if no arrow presses and no attack, idle animation
    if (not p.pressarrow and not p.attack) p.play="idle"
    p.pressarrow=false

    atk.dir=dir
    p.x+=p.dx
    p.y+=p.dy
end

function player_attack()
    -- if not already attacking
    if p.aframe == 0 then
        if btn(❎) then
            p.attack=true
            --p.play="attack_1"
            p.play="attack_1"
            atk.play="slice"
        end
        if btn(🅾️) then
            p.attack=true
        end
    end
end