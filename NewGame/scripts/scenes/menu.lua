function _init() menu_init() end

function menu_init()
    countdown=-1
    fade_color=12
    intro_start_sfx = 0
    flashframe=0
    flash_color=8
    flash_speed=10
    cx,cy = 0,0
    camera(cx,cy)
    initfont()
    _update=menu_update
    _draw=menu_draw
    make_player()

    -- for drawing clouds and islands
    sp_1=37
    sp_2=38
    sp_3=39
    sx_1, sy_1 = (sp_1 % 16) * 8, flr(sp_1 \ 16) * 8
    sx_2, sy_2 = (sp_2 % 16) * 8, flr(sp_2 \ 16) * 8
    sx_3, sy_3 = (sp_3 % 16) * 8, flr(sp_3 \ 16) * 8
end

function menu_draw()
    cls(fade_color)
    sspr(sx_1,sy_1, 8,8,60,20,16,16)
    sspr(sx_2,sy_2, 8,8,80,80,26,26)
    sspr(sx_3,sy_3, 8,8,50,0,100,32)
    sspr(sx_3,sy_3, 8,8,10,110,100,32)
    
    print("press x to start!",30,64,flash_color)
    
end

function menu_update()
    flash()
    if countdown<0 then
        if (btnp(❎)) then
            countdown=60 --countdown/30 == 2 seconds
            sfx(intro_start_sfx)
        end
    else
        flash_speed=1
        countdown-=1
        fadeout()
        if countdown<=0 then
            game_init()
            countdown=-1 -- reset countdown
        end
    end
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