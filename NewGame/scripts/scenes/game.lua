game_state={
    level=1
}

function game_init()
    sfx(-1)
    menuitem(2,"inventory",function() inv_init() end)
    camera(0,0)
    _update=game_update
    _draw=game_draw
    spawn_item(70,40)
end

function game_draw()
    cls()
    camera(cx,cy)
    --map(0,0)
    --mset(0,0,32)
    draw_items_on_map()
    draw_player()
    for _,e in pairs(enemies) do
        draw_enemy(e)
    end
    draw_attack()
    draw_hud()
end

function game_update()
    update_player()
    scroll_camera(p,true)
    for _,e in pairs(enemies) do
        update_enemy(e)
    end
end

function draw_hud()
    local hbarx=30
    local mbarx=20
    local wpos={cx+1,cy+120,cx+17,cy+128}
    --health
    rectfill(cx+1,cy+1,cx+hbarx,cy+3,5)
    rectfill(cx+1,cy+1,cx+current_player_health()*hbarx,cy+3,8)

    --mana
    rectfill(cx+1,cy+4,cx+mbarx,cy+6,5)
    rectfill(cx+1,cy+4,cx+current_player_mana()*mbarx,cy+6,12)

    --weapons
    rectfill(wpos[1],wpos[2],wpos[3],wpos[4],5)

    --no pickup if inventory full
end