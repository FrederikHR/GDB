function generate_item (type,rarity,element)
    local item = {}

    if (type == 0) then
        item.type = rnd(itemTypes)
    else
        item.type = itemTypes[type]
    end

    if (rarity == 0) then
        item.rarity = rnd(5) + 1
    else
        item.rarity = rarity
    end

    if (item.rarity == "trash") then
        item.element = "none"
    elseif (element == 0) then
        item.element = rnd(elements)
    else
        item.element = elements[element]
    end

    return item
end

function upgrade_item (item)
    if (item.rarity != 5) then
        item.rarity += 1
    end

    if (item.element == "none") then
        item.element = rnd(elements)
    end
end