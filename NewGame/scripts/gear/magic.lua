
bullets={}

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
    if p.attack and equipment[1].type=="wand" then
        b.dir=tblclone(patk1.dir)
        b.spr=50
        b.play="pew"
        b.max_aframe=90
        b.speed=1
        b.maxcf=5
        add(bullets,b)
    elseif p.attack2 and equipment[2].type=="wand" then
        --TODO: change to different attack
        b.dir=tblclone(patk2.dir)
        b.spr=50
        b.play="pew"
        b.max_aframe=90
        b.speed=1
        b.maxcf=5
        add(bullets,b)
    end
end

function update_bullets()
    for _,b in pairs(bullets) do
        b.x+=b.dir[1]
        b.y+=b.dir[2]
    end
end

function draw_bullets()
    for _,b in pairs(bullets) do
        fancy_draw_attack(b)
        fancy_anim(b)
    end
end

function kill_bullets()
    for i,b in pairs(bullets) do
        if (b.hit) deli(i)
    end
end