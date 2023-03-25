function _init() menu_init() end

function menu_init()
    camera(0,0)
    _update=menu_update
    _draw=menu_draw
    make_player()
end

function menu_draw()
    cls()
    print("press x to start!",0,64,7)
end

function  menu_update()
    if (btn(❎)) game_init()
end