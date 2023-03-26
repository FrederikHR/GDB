inventory = {
    {spr=192},{spr=193},
    {spr=194},{spr=195},
    {spr=196},{spr=197},
    {spr=198},{spr=199},
    {spr=200},{spr=201},
    {spr=202},{spr=203},
    {spr=204},{spr=205},
    {spr=206},{spr=207}
}

inv_pos={0,0}
max_inv_sz=5

function inv_init()
    camera(0,0)
    _update=inv_update
    _draw=inv_draw
end

function inv_draw()
    cls()
    print("you are on the inventory screen!",0,64)
    print("press 🅾️ to go exit",0,74)
    draw_inv()
end

function inv_update()
    move_inv()
end

function draw_inv()
    local SZ = 16
    for i,obj in ipairs(inventory) do
        local x,y = get_x_y(obj.spr)
        sspr(x,y,8,8,((i-1)%4)*SZ+32,((i-1)\4)*SZ,SZ,SZ)
    end

    --highlight selected item
    --rect()
end

function move_inv()
    if btn(⬅️) then
        inv_pos[1]-=1
    elseif btn(➡️) then
        inv_pos[1]+=1
    elseif btn(⬆️) then
        inv_pos[2]-=1
    elseif btn(⬇️) then
        inv_pos[2]+=1
    elseif btnp(❎) then
        print("asdasd")
    elseif btnp(🅾️) then
        p.interact=false
        game_init()
    end
end

function inv_ob(dir)
    if dir=="left" then
        if (inv_pos[1]==0) return true
    elseif dir=="right" then
        if (inv_pos[1]==max_inv_sz) return true
    elseif dir=="up" then
        if (inv_pos[2]==0) return true
    elseif dir=="down" then
        if (inv_pos[2]==max_inv_sz) return true
    end
    return false
end