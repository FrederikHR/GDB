inventory = {}

equipment={}

inv_pos={0,0}
inv_prompt_pos=0
inv_prompt=false
max_inv_sz=4

function inv_init()
    camera(0,0)
    _update=inv_update
    _draw=inv_draw
    menuitem(2,"resume game",function() game_init() end)
end

function inv_draw()
    cls()
    draw_inv()
    if (inv_prompt) draw_inv_prompt()
end

function inv_update()
    if not inv_prompt then
        move_inv()
    else
        move_inv_prompt()
    end
end

function draw_inv()
    local SZ = 16
    local OFFSET = 32
    for i=1,16 do
        local x1=((i-1)%4)*SZ+OFFSET
        local x2=((i-1)\4)*SZ
        rect(x1,x2,x1+SZ,x2+SZ,6)
    end
    for i,obj in ipairs(inventory) do
        local x,y = get_x_y(obj.spr)
        sspr(x,y,8,8,((i-1)%4)*SZ+OFFSET,((i-1)\4)*SZ,SZ,SZ)
    end

    --highlight selected item
    rect(inv_pos[1]*SZ+OFFSET,inv_pos[2]*SZ,inv_pos[1]*SZ+SZ+OFFSET,inv_pos[2]*SZ+SZ,10)

    --draw weapons in slots with stats
    draw_slots()

    --draw currently highlighted weapon with stats
    draw_current_item(inv_pos[1],inv_pos[2])

    print("❎ to select, 🅾️ to delete",0,112)
    print("pause to return to game",6,120)
end

function draw_inv_prompt()
    rectfill()
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
        print("asfdasf")
    end
end

function move_inv_prompt()
    if btnp(⬅️) then
        inv_prompt_pos = (inv_prompt_pos - 1) % 2
    elseif btnp(➡️) then
        inv_prompt_pos = (inv_prompt_pos + 1) % 2
    elseif btnp(❎) then
        print("asdasd")
    elseif btnp(🅾️) then
        print("asfdasf")
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
    local area1={0,66}
    local col1=12
    local area2={41,66}
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

function draw_current_item(x,y)
    local pos=y*4+x+1
    local area={82,66}
    local col=6
    print("current",area[1],area[2],col)
    if inventory[pos] then
        print(inventory[pos].type,area[1],area[2]+8,col)
        print(inventory[pos].element,area[1],area[2]+16,col)
        print(inventory[pos].rarity,area[1],area[2]+24,col)
    else
        print("no item",area[1],area[2]+8,col)
        print("selected",area[1],area[2]+16,col)
    end
end