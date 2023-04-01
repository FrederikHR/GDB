current_items={}

function generate_item (type,rarity,element)
    local item = {}

    if (not type) then
        item.type = rnd(item_types)
    else
        item.type = type
    end

    item.spr=item_sprites[item.type]

    if (not rarity) then
        item.rarity = rnd(rarities)
    else
        item.rarity = rarity
    end

    if (item.rarity == "trash") then
        item.element = "none"
    elseif (not element) then
        item.element = rnd(elements)
    else
        item.element = element
    end

    item.pal=item_pal[item.type]
    item.sz=1
    item.taken=false
    item.slot="none"

    return item
end

function spawn_item(x,y,type,rarity,element)
    local item = generate_item(type,rarity,element)
    item.x=x
    item.y=y
    add(current_items,item)
end

function draw_items_on_map()
    for _,i in pairs(current_items) do
        spr(32,i.x,i.y)
    end
end

function draw_item(item,x,y,scaled,sz)
    --This function deals with coloring items based on elements and rarity
    --takes an item and draws it in position x,y
    --if scaled=true, uses sz in sspr
    if not scaled then
        change_pal(item)
        spr(item.spr,x,y)
        pal()
    else
        local sx,sy = get_x_y(item.spr)
        change_pal(item)
        sspr(sx,sy,8,8,x,y,sz,sz)
        pal()
    end
end

function change_pal(item)
    pal(15,rarity_colors[item.rarity])
    pal(14,0)
    pal(item.pal,element_colors[item.element])
end

function upgrade_item (item)
    if (item.rarity != 5) then
        item.rarity += 1
    end

    if (item.element == "none") then
        item.element = rnd(elements)
    end
end