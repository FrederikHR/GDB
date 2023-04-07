prl = {}
maze_size = 4
current_map={}
maze={}

function init_levelgen()
    --prl = perlin()
    --prl:init()
    --prl:getmapdata(0,150,0,150)
    maze = init_maze(maze_size,maze_size,5,-600,-600)
    backtrack(maze,maze_size,maze_size)
end

function draw_level()
    for x = 1,#maze do 
        for y = 1,#maze[1] do 
            --draw_rect(x,y, flr(prl.fmap[x][y]))
            draw_maze_room(x,y,maze[x][y])
        end
    end
end

function draw_maze_room(x,y,room)
    local size = 32

    rectfill(x*size, y*size, x*size+size, y*size+size, 7)
    if room.goal then
        rectfill(x*size, y*size, x*size+size, y*size+size, 11)
    end
    if room.is_wall then
        rectfill(x*size, y*size, x*size+size, y*size+size, 1)
        if room.goal then
            rectfill(x*size, y*size, x*size+size, y*size+size, 9)
        end
    end

end