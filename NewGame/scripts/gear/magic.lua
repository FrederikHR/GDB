function make_bullet(p)
    local b={}
    b.x=p.x
    b.y=p.y
    b.sw=8
    b.sh=8
    b.aframe=0
    b.animindex=1
    b.anims={
        pew={fr=1,fancy=true,50}
    }
    if p.attack and game_state.equipment[1].type=="wand" then
        b.dir=tblclone(patk1.dir)
        b.spr=50
        b.slot=1
        b.play="pew"
        b.max_aframe=90
        b.speed=1
        b.maxcf=5
        add(game_state.bullets,b)
    elseif p.attack2 and game_state.equipment[2].type=="wand" then
        --TODO: change to different attack
        b.dir=tblclone(patk2.dir)
        b.spr=50
        b.slot=2
        b.play="pew"
        b.max_aframe=90
        b.speed=1
        b.maxcf=5
        add(game_state.bullets,b)
    end
end

function update_bullets()
    --TODO: destroy bullet if far away(? probably not a problem)
    for _,b in pairs(game_state.bullets) do
        b.x+=b.dir[1]
        b.y+=b.dir[2]
    end
end

function draw_bullets()
    for _,b in pairs(game_state.bullets) do
        fancy_draw_attack(b)
        fancy_anim(b)
    end
end

function kill_bullets()
    for i,b in pairs(game_state.bullets) do
        if (b.hit) del(game_state.bullets,b)
    end
end