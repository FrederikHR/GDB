prl = {}
maze_size = 25

function init_levelgen()
    --prl = perlin()
    --prl:init()
    --prl:getmapdata(0,150,0,150)
    maze = init_maze(maze_size,maze_size)
    backtrack(maze,maze_size,maze_size)
end

function draw_level()
    for x = 1,maze_size,1 do 
        for y = 1,maze_size,1 do 
            --draw_rect(x,y, flr(prl.fmap[x][y]))
            draw_maze_room(x,y,maze[x][y])
        end
    end
end

function draw_rect(x,y, color)
    size = 4
    rectfill(x*size, y*size, (x*size)+size-1, (y*size)+size-1, color)
end

function draw_maze_room(x,y,room)
    size = 3
    rectfill(x*size, y*size, (x*size)+size-1, (y*size)+size-1, 5)
    rectfill(x*size+1, y*size+1, x*size+1, y*size+1, 7)

    if (room.main_path == true) then rectfill(x*size+1, y*size+1, x*size+1, y*size+1, 8) end
    if (room.goal == true) then rectfill(x*size+1, y*size+1, x*size+1, y*size+1, 11) end
    if (room.left_wall == false) then rectfill(x*size, y*size+1, x*size, y*size+1, 7) end
    if (room.right_wall == false) then rectfill(x*size+2, y*size+1, x*size+2, y*size+1, 7) end
    if (room.bottom_wall == false) then rectfill(x*size+1, y*size+2, x*size+1, y*size+2, 7) end
    if (room.top_wall == false) then rectfill(x*size+1, y*size, x*size+1, y*size, 7) end
end