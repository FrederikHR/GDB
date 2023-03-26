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
max_inv_sz=4

function inv_init()
    camera(0,0)
    _update=inv_update
    _draw=inv_draw
    --menuitem(2,"resume game",function() game_init() end)
end

function inv_draw()
    cls()
    --print("you are on the inventory screen!",0,64,7)
    --print("press 🅾️ to go exit",0,74,7)
    draw_inv()
end

function inv_update()
    move_inv()
end

function draw_inv()
    local SZ = 16
    local OFFSET = 32
    for i,obj in ipairs(inventory) do
        local x,y = get_x_y(obj.spr)
        sspr(x,y,8,8,((i-1)%4)*SZ+OFFSET,((i-1)\4)*SZ,SZ,SZ)
    end

    --highlight selected item
    rect(inv_pos[1]*SZ+OFFSET,inv_pos[2]*SZ,inv_pos[1]*SZ+SZ+OFFSET,inv_pos[2]*SZ+SZ,10)

    --draw weapons in slots with stats
    draw_slots()

    --draw currently highlighted weapon with stats
    draw_current_item()
end

function move_inv()
    if btnp(⬅️) then
        if (not inv_ob("left")) inv_pos[1]-=1
    elseif btnp(➡️) then
        if (not inv_ob("right")) inv_pos[1]+=1
    elseif btnp(⬆️) then
        if (not inv_ob("up")) inv_pos[2]-=1
    elseif btnp(⬇️) then
        if (not inv_ob("down")) inv_pos[2]+=1
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
        if (inv_pos[1]==max_inv_sz-1) return true
    elseif dir=="up" then
        if (inv_pos[2]==0) return true
    elseif dir=="down" then
        if (inv_pos[2]==max_inv_sz-1) return true
    end
    return false
end

function draw_slots()
    local area1={0,64}
    local col1=12
    local area2={41,64}
    local col2=8
    print("slot 1",area1[1],area1[2],col1)
    print("sword",area1[1],area1[2]+8,col1)
    print("fire",area1[1],area1[2]+16,col1)
    print("rare",area1[1],area1[2]+24,col1)

    print("slot 2",area2[1],area2[2],col2)
    print("shield",area2[1],area2[2]+8,col2)
    print("none",area2[1],area2[2]+16,col2)
    print("trash",area2[1],area2[2]+24,col2)
end

function draw_current_item()
    local area={82,64}
    local col=6
    print("current",area[1],area[2],col)
    print("mace",area[1],area[2]+8,col)
    
end