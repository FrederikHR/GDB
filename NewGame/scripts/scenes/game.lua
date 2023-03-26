function game_init()
    camera(0,0)
    _update=game_update
    _draw=game_draw
end

function game_draw()
    cls()
    draw_player()
    for _,e in pairs(enemies) do
        draw_enemy(e)
    end
end

function game_update()
    update_player()
    for _,e in pairs(enemies) do
        update_enemy(e)
    end
end