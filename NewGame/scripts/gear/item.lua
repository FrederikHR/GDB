function generateItem (type,rarity,element)
    local item = {}

    if (type == 0) then
        item.type = rnd(itemTypes)
    else
        item.type = itemTypes[type]
    end

    if (rarity == 0) then
        item.rarity = rnd(rarities)
    else
        item.rarity = rarities[rarity]
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
