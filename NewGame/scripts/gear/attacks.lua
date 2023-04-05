function do_atk(slot)
    if equipment[slot].type == "none" then
        if slot==1 then
            patk1.play="punch"
            patk1.spr=48
        else
            patk2.play="punch"
            patk2.spr=48
        end
    else
        if slot==1 then
            patk1.play=patk1.move1
            patk1.spr=patk1.anims[patk1.play][1]
        else
            patk2.play=patk2.move2
            patk2.spr=patk2.anims[patk2.play][1]
        end
    end
    
    --make bullet if wand equipped and enough mana
    if current_player_mana() > 1 then
        make_bullet(p)
        p.mana -= 1
    end

    sfx(player_sfx.attack_sfx)
    if p.left_swipe then
        p.left_swipe=false
    else
        p.left_swipe=true
    end
end

--no items
atk0 = {
    spr=0,
    play="idle",
    x=0,
    y=0,
    sw=8,
    sh=8,
    dir={1,0},
    aframe=0,
    max_aframe=10,
    range=true,
    speed=1,
    move1="punch",
    animindex=1,
    maxcf=3,
    anims={
        idle={fr=1,-1},
        punch={fr=3,fancy=true,48}
    }
}

--sword
atk1 = {
    spr=0,
    play="idle",
    x=0,
    y=0,
    sw=16,
    sh=16,
    dir={1,0},
    aframe=0,
    max_aframe=10,
    range=true,
    speed=1,
    move1="slice",
    move2="slice",
    animindex=1,
    maxcf=2,
    anims={
        idle={fr=1,-1},
        slice={fr=0.5, 21,22,23,24,25,26,27,28,29,30}
    }
}

--TODO:spear
atk2 = {
    spr=0,
    play="idle",
    x=0,
    y=0,
    sw=10,
    sh=8,
    dir={1,0},
    aframe=0,
    max_aframe=10,
    range=true,
    speed=1,
    move1="pierce",
    move2="pierce",
    animindex=1,
    maxcf=2,
    anims={
        idle={fr=1,-1},
        pierce={fr=5,fancy=true,49}
    }
}

--TODO:wand
--works differently from every other weapon
atk4 = {
    spr=0,
    play="idle",
    x=0,
    y=0,
    sw=8,
    sh=8,
    dir={1,0},
    aframe=0,
    max_aframe=10,
    range=true,
    speed=1,
    move1="idle",
    move2="idle",
    animindex=1,
    maxcf=5,
    anims={
        idle={fr=1,-1},
        pew={fr=1,fancy=true,50}
    }
}

--TODO:mace
atk5 = {
    spr=0,
    play="idle",
    x=0,
    y=0,
    sw=8,
    sh=8,
    dir={1,0},
    aframe=0,
    max_aframe=10,
    range=true,
    speed=1,
    move1="slice",
    move2="slice",
    anims={
        idle={fr=1,-1},
        slice={fr=0.5, 21,22,23,24,25,26,27,28,29,30}
    }
}

--TODO:shield
atk7 = {
    spr=0,
    play="idle",
    x=0,
    y=0,
    sw=8,
    sh=8,
    dir={1,0},
    aframe=0,
    max_aframe=10,
    range=true,
    speed=1,
    move1="slice",
    move2="slice",
    anims={
        idle={fr=1,-1},
        slice={fr=0.5, 21,22,23,24,25,26,27,28,29,30}
    }
}

--[[
--TODO:dagger
atk3 = {
    spr=0,
    play="idle",
    x=0,
    y=0,
    sw=8,
    sh=8,
    dir={1,0},
    aframe=0,
    max_aframe=10,
    range=true,
    speed=1,
    move1="slice",
    move2="slice",
    anims={
        idle={fr=1,-1},
        slice={fr=0.5, 21,22,23,24,25,26,27,28,29,30}
    }
}

--TODO:orb
atk6 = {
    spr=0,
    play="idle",
    x=0,
    y=0,
    sw=8,
    sh=8,
    dir={1,0},
    aframe=0,
    max_aframe=10,
    range=true,
    speed=1,
    move1="slice",
    move2="slice",
    anims={
        idle={fr=1,-1},
        slice={fr=0.5, 21,22,23,24,25,26,27,28,29,30}
    }
}

--TODO:whip
atk8 = {
    spr=0,
    play="idle",
    x=0,
    y=0,
    sw=8,
    sh=8,
    dir={1,0},
    aframe=0,
    max_aframe=10,
    range=true,
    speed=1,
    move1="slice",
    move2="slice",
    anims={
        idle={fr=1,-1},
        slice={fr=0.5, 21,22,23,24,25,26,27,28,29,30}
    }
}

]]