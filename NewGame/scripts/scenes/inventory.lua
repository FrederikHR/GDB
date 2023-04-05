inventory = {}

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

inv_pos={0,0}
inv_prompt_pos=0
inv_prompt=false
max_inv_sz=4

function inv_init()
    camera(0,0)
    _update=inv_update
    _draw=inv_draw
    menuitem(2)
    menuitem(2,"resume game",function(b) if (b&32 > 0) resume_game() end)
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
    local OFFSET = 28
    for i=1,16 do
        local x1=((i-1)%4)*(SZ+2)+OFFSET
        local x2=((i-1)\4)*(SZ+2)
        rect(x1,x2,x1+SZ+1,x2+SZ+1,6)
    end
    for i,obj in ipairs(inventory) do
        local x,y = get_x_y(obj.spr)
        local pos_x=((i-1)%4)*(SZ+2)+OFFSET+1
        local pos_y=((i-1)\4)*(SZ+2)+1
        draw_item(obj,pos_x,pos_y,true,SZ)
        --sspr(x,y,8,8,pos_x,pos_y,SZ,SZ)
        if (obj.taken) circ(pos_x+SZ\2,pos_y+SZ\2,SZ\2-1,obj.slot)
    end

    --highlight selected item
    rect(inv_pos[1]*(SZ+2)+OFFSET,inv_pos[2]*(SZ+2),inv_pos[1]*(SZ+2)+SZ+OFFSET+1,inv_pos[2]*(SZ+2)+SZ+1,10)

    --draw weapons in slots with stats
    draw_slots()

    --draw currently highlighted weapon with stats
    draw_current_item(inv_pos[1],inv_pos[2])

    if (inv_prompt) draw_inv_prompt()

    print("❎ to select, 🅾️ to delete",0,112)
    print("pause to return to game",6,120)
end

function draw_inv_prompt()
    rectfill()
end

function move_inv()
    local pos=inv_pos[2]*4+inv_pos[1]+1

    if btnp(⬅️) then
        if (not inv_ob"left") then 
            inv_pos[1]-=1
            sfx(19)
        end
    elseif btnp(➡️) then
        if (not inv_ob"right") then 
            inv_pos[1]+=1
            sfx(19)
        end
    elseif btnp(⬆️) then
        if (not inv_ob"up") then
            inv_pos[2]-=1
            sfx(19)
        end
    elseif btnp(⬇️) then
        if (not inv_ob"down") then
            inv_pos[2]+=1
            sfx(19)
        end
    elseif btnp(❎) and inventory[pos]!=nil then
        inv_prompt=true
    elseif btnp(🅾️) and inventory[pos]!=nil then
        --TODO: add visual effect (smoke or something)    
        sfx(21)
        delete_item(pos)
    end
end

function move_inv_prompt()
    local pos=inv_pos[2]*4+inv_pos[1]+1
    --The code below can be used to extend inventory management
    --if btnp(⬅️) then
    --    inv_prompt_pos = (inv_prompt_pos - 1) % 2
    --elseif btnp(➡️) then
    --    inv_prompt_pos = (inv_prompt_pos + 1) % 2
    if btnp(🅾️) then
        add_to_slot(pos,1)
    elseif btnp(❎) then
        add_to_slot(pos,2)
    end
end

function add_to_slot(pos,slot)
    reset_slot(slot)
    --reset_item(12)
    equipment[slot]=tblclone(inventory[pos])
    equipment[slot].pos=pos
    inventory[pos].taken=true
    if slot==1 then
        inventory[pos].slot=12
    else
        inventory[pos].slot=8
    end
    inv_prompt=false
    update_atk(equipment[slot].type,slot)
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

function print_item(item,x,y,col)
    print(item.type,x,y+8,col)
    print(item.element,x,y+16,col)
    print(item.rarity,x,y+24,col)
end

function draw_slots()
    local area1={0,74}
    local col1=12
    local area2={41,74}
    local col2=8
    print("slot 1",area1[1],area1[2],col1)
    print_item(equipment[1],area1[1],area1[2],col1)

    print("slot 2",area2[1],area2[2],col2)
    print_item(equipment[2],area2[1],area2[2],col2)
end

function draw_current_item(x,y)
    local pos=y*4+x+1
    local area={82,74}
    local col=6
    print("current",area[1],area[2],col)
    if inventory[pos] then
        print_item(inventory[pos],area[1],area[2],col)
    else
        print("no item",area[1],area[2]+8,col)
        print("selected",area[1],area[2]+16,col)
    end
end

function draw_inv_prompt()
    rectfill(20,40,100,46,5)
    print("🅾️=slot 1, ❎=slot 2",21,41,7)
end

function delete_item(pos)
    if inventory[pos] != nil then
        --check if in slot, and remove from slot
        if inventory[pos].slot==12 then
            reset_slot(1)
            update_atk(0,1)
        elseif inventory[pos].slot==8 then
            reset_slot(2)
            update_atk(0,2)
        else
            --item not in slot, delete from inventory
            update_positions(pos)
            deli(inventory,pos)
        end
    end
end

function reset_slot(pos)
    if equipment[pos].pos != none then
        inventory[equipment[pos].pos].slot="none"
        inventory[equipment[pos].pos].taken=false
    end
    equipment[pos].spr=0
    equipment[pos].type="none"
    equipment[pos].rarity="none"
    equipment[pos].element="none"
    equipment[pos].taken=false
    equipment[pos].slot="none"
    equipment[pos].pos=none
end

function reset_item(slot)
    for _,i in pairs(inventory) do
        if (i.slot==slot) i.taken=false
    end
end

function update_positions(pos)
    --update stored equipment positions if needed
    for i=1,2 do
        if (equipment[i].pos != nil and equipment[i].pos > pos) equipment[i].pos -= 1
    end
end