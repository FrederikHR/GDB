function do_atk(slot)
    if equipment[slot].type == "none" then
        if slot==1 then
            patk1.play="punch"
        else
            patk2.play="punch"
        end
    else
        if slot==1 then
            patk1.play=move1
        else
            patk2.play=move2
        end
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
    max_aframe=50,
    range=true,
    speed=1,
    move1="punch",
    anims={
        idle={fr=1,-1},
        punch={fr=15,48,49}
    }
}

--sword
atk1 = {
    spr=0,
    play="idle",
    x=0,
    y=0,
    sw=8,
    sh=8,
    dir={1,0},
    aframe=0,
    max_aframe=50,
    range=true,
    speed=1,
    move1="slice",
    move2="slice",
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
    sw=8,
    sh=8,
    dir={1,0},
    aframe=0,
    max_aframe=50,
    range=true,
    speed=1,
    move1="slice",
    move2="slice",
    anims={
        idle={fr=1,-1},
        slice={fr=0.5, 21,22,23,24,25,26,27,28,29,30}
    }
}

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
    max_aframe=50,
    range=true,
    speed=1,
    move1="slice",
    move2="slice",
    anims={
        idle={fr=1,-1},
        slice={fr=0.5, 21,22,23,24,25,26,27,28,29,30}
    }
}

--TODO:wand
atk4 = {
    spr=0,
    play="idle",
    x=0,
    y=0,
    sw=8,
    sh=8,
    dir={1,0},
    aframe=0,
    max_aframe=50,
    range=true,
    speed=1,
    move1="slice",
    move2="slice",
    anims={
        idle={fr=1,-1},
        slice={fr=0.5, 21,22,23,24,25,26,27,28,29,30}
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
    max_aframe=50,
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
    max_aframe=50,
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
    max_aframe=50,
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
    max_aframe=50,
    range=true,
    speed=1,
    move1="slice",
    move2="slice",
    anims={
        idle={fr=1,-1},
        slice={fr=0.5, 21,22,23,24,25,26,27,28,29,30}
    }
}