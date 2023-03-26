inv_pos={0,0}
max_inv_sz=5

function inv_init()
    camera(0,0)
    _update=inv_update
    _draw=inv_draw
end

function inv_draw()
    cls()
    print("you are on the inventory screen!")
    print("press 🅾️ to go exit",0,10)
    --draw_inv()
end

function inv_update()
    move_inv()
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