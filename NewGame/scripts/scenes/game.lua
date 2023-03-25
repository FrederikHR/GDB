function game_init()
    camera(0,0)
    _update=game_update
    _draw=game_draw
end

function game_draw()
    cls()
    draw_player()
end

function game_update()
    update_player()
end