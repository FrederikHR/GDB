function _init() menu_init() end

function menu_init()
    music(4)
    --countdown=-1
    --fade_color=12
    game_state={
        level=1,
        map_drawn=false,
        enemies={},
        current_items={},
        bullets={},
        inventory={},
        equipment={
            {
                type="none",
                rarity="none",
                element="none"
            },
            {
                type="none",
                rarity="none",
                element="none"
            }
        }
    }
    intro_start_sfx = 0
    flashframe=0
    flash_color=8
    flash_speed=10
    cx,cy = 0,0
    camera(cx,cy)
    _update=menu_update
    _draw=menu_draw
    p={}
    patk1={}
    patk2={}
    make_player()

    -- for drawing clouds and islands
    cloud_island_1_x, cloud_island_1_y = get_sspr_x_y(37)
    cloud_island_2_x, cloud_island_2_y = get_sspr_x_y(38)
    title1_x, title1_y = get_sspr_x_y(68) -- C
    title2_x, title2_y = get_sspr_x_y(84) -- E 
    cloud_x, cloud_y = get_sspr_x_y(39)
end

function menu_draw()
    cls(12)
    
    sspr(cloud_island_1_x,cloud_island_1_y, 8,8,60,20,16,16)
    sspr(cloud_island_2_x,cloud_island_2_y, 8,8,80,80,26,26)
    sspr(cloud_x,cloud_y, 8,8,50,0,100,32)
    sspr(cloud_x,cloud_y, 8,8,10,110,100,32)

    sspr(title1_x,title1_y, 40,8,30,40,40,16)
    sspr(title2_x,title2_y, 48,8,50,60,48,16)
    print("press x to start",30,110,flash_color)
    
    
end

function menu_update()
    flash()
   
  --[[   if countdown<0 then
        if (btnp(❎)) then
            countdown=60 --countdown/30 == 2 seconds
            sfx(intro_start_sfx)
        end
    else ]]
    if (btnp(❎)) then
        flash_speed=1
        sfx(intro_start_sfx)
        --countdown-=1
        fade_out()
        --if countdown<=0 then
        game_init()

    end
       --     countdown=-1 -- reset countdown
     --   end
    --end
end

function flash()
    flashframe+=1
    if flashframe>flash_speed then
        flashframe=0
        if (flash_color==8) then 
            flash_color=9
        else
            flash_color=8
        end
    end
end
--[[ 
function fadeout()
    if countdown > 0 then
        if (countdown) < 25 fade_color=14
        if (countdown) < 20 fade_color=6
        if (countdown) < 15 fade_color=12
        if (countdown) < 13 fade_color=5
        if (countdown) < 11 fade_color=2
        if (countdown) < 10 fade_color=1
        if (countdown) < 9 fade_color=0
        
    end
end
 ]]





--[[ function fadepal(_perc) 
    local p=flr(mid(0,_perc,1)*100)
    local kmax,col,dpal,j,k
    dpal={0,1,1,2,1,13,6,4,4,9,3,13,1,13,14}
    for j=1,15 do 
        col=j
        kmax=(p+(j*1.46))/22
    end
    for k=1,kmax do
        col=dpal[col]
    end
    pal(j,col)
end ]]