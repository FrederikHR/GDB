sprites={level_1=52, cloud=39}
function game_init()
    --only called after starting game from menu
    sfx(-1)
    music(-1)
    
    background_spr=50
    level_1_sx, level_1_sy = get_sspr_x_y(sprites["level_1"])

    init_level(1)
   
end

function resume_game()
    background_spr=50
    level_1_sx, level_1_sy = get_sspr_x_y(sprites["level_1"])
    menuitem(2)
    menuitem(2,"inventory",function(b) if (b&32 > 0) inv_init() end)
    camera(0,0)
    _update=game_update
    _draw=game_draw
end

function game_draw()
    if not game_state.dead then
        cls(12)
        --sspr(level_1_sx,level_1_sy,8,8,0,0,154,154)
        print("how to play", 50,60,2)
        print("1. press x to attack", 30,70,2)
        print("2. survive!", 30,80,2)
        camera(cx,cy)
        --map(0,0)
        --mset(0,0,32)
        --if not map_drawn then
        draw_level()
        --    map_drawn=true
        --end
        --map(0,0)
        draw_items_on_map()
        draw_player()
        for _,e in pairs(game_state.enemies) do
            draw_enemy(e)
        end
        fancy_draw_attack(patk1)
        fancy_draw_attack(patk2)
        draw_bullets()
        draw_hud()
        --print(atan2(patk1.dir[1],patk1.dir[2]).." "..patk1.dir[1].." "..patk1.dir[2],cx+10,cy+10)
        --print(patk1.move1,cx+10,cy+20)
    else
        pal()
        rectfill(cx,cy,cx+128,cy+128,0)
        print("you died.",cx,cy,8)
        print("press ❎ to restart",cx,cy+10,8)
    end
end

function game_update()
    if not game_state.dead then
        update_player()
        scroll_camera(p,true)
        for _,e in pairs(game_state.enemies) do
            update_enemy(e)
            kill_enemy(e)
        end
    else
        if (btnp(❎)) then
            sfx(intro_start_sfx)
            game_state.dead=false
            menu_init()
        end
    end
end

function draw_hud()
    local hbarx=30
    local mbarx=20
    local wpos={cx+1,cy+117,cx+19,cy+126}
    local SZ=8
    --health
    rectfill(cx+1,cy+1,cx+hbarx,cy+3,5)
    rectfill(cx+1,cy+1,cx+current_player_health()*hbarx,cy+3,8)

    --mana
    rectfill(cx+1,cy+4,cx+mbarx,cy+6,5)
    rectfill(cx+1,cy+4,cx+current_player_mana()*mbarx,cy+6,13)

    --weapons
    rect(wpos[1],wpos[2],wpos[3],wpos[4],5)
    line(wpos[1]+SZ+1,wpos[2],wpos[1]+SZ+1,wpos[4])
    if (game_state.equipment[2].spr !="none") draw_item(game_state.equipment[1],wpos[1]+1,wpos[2]+1)

    print("🅾️",wpos[1],wpos[2]+6,13)

    if (game_state.equipment[1].spr !="none") draw_item(game_state.equipment[2],wpos[1]+SZ+2,wpos[2]+1)

    print("❎",wpos[1]+SZ+4,wpos[2]+6,8)

    --no pickup if inventory full
end

function init_level(l)
    menuitem(2)
    menuitem(2,"inventory",function(b) if (b&32 > 0) inv_init() end)
    camera(0,0)
    
    _update=game_update
    _draw=game_draw

    game_state.current_items={}
    game_state.enemies={}
    game_state.bullets={}
    game_state.goal={2,2}

    local maze_size = init_levelgen(l)

    --reset player position
    p.x=maze[maze_size*2][maze_size*2].x*maze[1][1].scale+maze[1][1].ox+maze[1][1].scale\2
    p.y=maze[maze_size*2][maze_size*2].y*maze[1][1].scale+maze[1][1].oy+maze[1][1].scale\2

    enemies_for_map(l)
    items_for_map()
    game_state.level += 1
end