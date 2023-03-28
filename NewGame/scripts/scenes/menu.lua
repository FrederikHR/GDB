function _init() menu_init() end

function menu_init()
    intro_start_sfx = 0
    camera(0,0)
    initfont()
    _update=menu_update
    _draw=menu_draw
    make_player()
    make_enemy(90,90,1)
    start_game=false
end

function menu_draw()
    cls()
    if not start_game then
        print("press x to start!",0,64,7)
    end
    if start_game then
        pal(7,8)
        print("starting!",0,64,8)
        flash(2)
        pal()
    end
end

function menu_update()
    
    if (btnp(❎)) then
        start_game=true
        sfx(intro_start_sfx)
        wait(2)
        game_init()
    end
end

function wait(seconds)
    frames=seconds*30
    for elapsed_frames=0,frames do
        flash(elapsed_frames)
        yield()
    end
end

function flash(frame)
    if frame%2==0 then
        pal(7,8)
    else
        pal(8,7)
    end
    pal()
end