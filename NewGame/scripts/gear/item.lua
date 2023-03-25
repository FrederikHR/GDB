function generateItem (type,rarity,element)
    local item = {}
    if (type)
    item.type = rnd(itemTypes)
    item.rarity = rnd(rarities)
    if (item.rarity == "trash")
        item.element = "none"
    else
        item.element = rnd(elements)
    end
    return item
end
