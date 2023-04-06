prl = {}
maze_size = 25

function init_levelgen()
    --prl = perlin()
    --prl:init()
    --prl:getmapdata(0,150,0,150)
    maze = init_maze(maze_size,maze_size)
    backtrack(maze,maze_size,maze_size)

    printh("maze size="..#maze)
    for j = 2, maze_size*2, 2 do
        --printh("j="..j)
        add(maze, {}, j)
        for i = 2, maze_size*2, 2 do
            --printh("i="..i)
            if maze[j-1][i-1].bottom_wall == true then
                add(maze[j-1], "w", i)
            else 
                add(maze[j-1], "e", i)
            end

            add(maze[j], "e")

            if maze[j-1][i-1].right_wall == true then
                add(maze[j], "w")
            else 
                add(maze[j], "e")
            end

            maze[j-1][i-1] = "e"
        end
    end
end

function draw_level()
    for x = 1,maze_size*2,1 do 
        for y = 1,maze_size*2,1 do 
            --draw_rect(x,y, flr(prl.fmap[x][y]))
            draw_maze_room(x,y,maze[x][y])
        end
    end
end

--[[
function draw_rect(x,y, color)
    size = 4
    rectfill(x*size, y*size, (x*size)+size-1, (y*size)+size-1, color)
end
]]

function draw_maze_room(x,y,room)
    size = 3
    -- rectfill(x*size, y*size, (x*size)+size-1, (y*size)+size-1, 5)
    local room_c = 7
    --if (room.main_path == true) room_c = 8
    --if (room.goal == true) room_c = 11
    if (room == "e") room_c = 8
    if (room == "w") room_c = 1
    
    -- draw rooms
    rectfill(x*size, y*size, (x*size)+size, (y*size)+size, room_c)


    --if (room.right_wall == true) then 
    --    rectfill(x*2*size+(size/2), y*2*size, x*2*size+size+(size/2), y*2*size+size, 4)
    --end
    
    --if (room.top_wall == false) rectfill(x*size+1, y*size, x*size+1, y*size, 7)
end
