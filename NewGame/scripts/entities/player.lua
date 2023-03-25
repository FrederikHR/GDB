panims ={
    idle={fr=15,5,6},
    walk={fr=10,1,2,3,4},
    attack_1={fr=10,7,8,9,10}
}

p={}

function make_player()
    p.spr=1
    p.x=64
    p.y=64
    p.dx=0
    p.dy=0
    p.sz=1
    p.acc=2
    p.play="idle"
    p.anims=panims
    p.pressarrow=false
    p.flp=false
    p.attack=false
    p.aframe=0
end

function update_player()
    if (p.attack) p.aframe+=1
    move_player()
    player_attack()
    animate(p)
end

function draw_player()
    spr(abs(p.spr),p.x,p.y,p.sz,p.sz,p.flp)
end

function move_player()
    p.dx=0
    p.dy=0
    if btn(⬅️) then
        p.dx-=p.acc
        p.flp=true
        p.play="walk"
        p.pressarrow=true
    end
    if btn(➡️) then
        p.dx+=p.acc
        p.flp=false
        p.play="walk"
        p.pressarrow=true
    end
    if btn(⬆️) then
        p.dy-=p.acc
        p.play="walk"
        p.pressarrow=true
    end
    if btn(⬇️) then
        p.dy+=p.acc
        p.play="walk"
        p.pressarrow=true
    end

    -- if no arrow presses, idle animation
    if (not p.pressarrow) p.play="idle"
    p.pressarrow=false

    p.x+=p.dx
    p.y+=p.dy
end

function player_attack()

    -- X
    if btn(❎) then
        p.attack=true
        p.play="attack_1"
    end
    -- O
    if btn(🅾️) then
        p.attack=true
    end
end