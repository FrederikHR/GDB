game_state={
    level=1
}

function game_init()
    menuitem(2,"inventory",function() inv_init() end)
    camera(0,0)
    _update=game_update
    _draw=game_draw
    spawn_item(70,40)
end

function game_draw()
    cls()
    --map(0,0)
    --mset(0,0,32)
    draw_items_on_map()
    draw_player()
    for _,e in pairs(enemies) do
        draw_enemy(e)
    end
    draw_attack()
end

function game_update()
    update_player()
    for _,e in pairs(enemies) do
        update_enemy(e)
    end
end