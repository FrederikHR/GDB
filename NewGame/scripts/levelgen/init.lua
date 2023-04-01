prl = {}
function init_levelgen()

    prl = perlin()
    prl:init()
    prl:getmapdata(0,150,0,150)
end

function draw_level()
    local st = "values="
    draw_rect(0,0)
    draw_rect(1,1)

    for x = 1,26,1 do 
        for y = 1,26,1 do 
            --st ..= prl.fmap[x][y]
            draw_rect(x,y, flr(prl.fmap[x][y]))
        end
    end
    
    --printh(st, "@clip")
end

function draw_rect(x,y, color)
    size = 4
    rectfill(x*size, y*size, (x*size)+size-1, (y*size)+size-1, color)
end