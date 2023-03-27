current_items={}

function generate_item (type,rarity,element)
    local item = {}

    if (not type) then
        item.type = rnd(item_types)
    else
        item.type = item_types[type]
    end

    item.spr=item_sprites[item.type]

    if (not rarity) then
        item.rarity = rnd(5) + 1
    else
        item.rarity = rarity
    end

    if (item.rarity == "trash") then
        item.element = "none"
    elseif (not element) then
        item.element = rnd(elements)
    else
        item.element = elements[element]
    end

    item.sz=1
    item.taken=false

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

function upgrade_item (item)
    if (item.rarity != 5) then
        item.rarity += 1
    end

    if (item.element == "none") then
        item.element = rnd(elements)
    end
end