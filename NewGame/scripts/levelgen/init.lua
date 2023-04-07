prl = {}
maze_size = 5

real_maze = {}
maze = {}

function init_levelgen()
    --prl = perlin()
    --prl:init()
    --prl:getmapdata(0,150,0,150)
    maze = init_maze(maze_size,maze_size)
    backtrack(maze,maze_size,maze_size)

    printh("maze size="..#maze)

    --[[

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
    end]]--
    real_maze = {}
    add(real_maze, {})
    for i = 1, maze_size*2 do
        add(real_maze[1], "w")
    end

    for i = 1, maze_size do
        add(real_maze, {})
        add(real_maze, {})
        for j = 1, maze_size do
            char = "e"
            if (maze[j][i].main_path == true) char = "m"
            if (maze[j][i].goal == true) char = "g"

            if maze[j][i].right_wall == true and maze[j][i].bottom_wall == true then
                add(real_maze[#real_maze-1], char)
                add(real_maze[#real_maze-1], "w")
                add(real_maze[#real_maze], "w")
                add(real_maze[#real_maze], "w")

            elseif maze[j][i].right_wall == true and maze[j][i].bottom_wall == false then
                add(real_maze[#real_maze-1], char)
                add(real_maze[#real_maze-1], "w")
                add(real_maze[#real_maze], char)
                add(real_maze[#real_maze], "w")

            elseif maze[j][i].right_wall == false and maze[j][i].bottom_wall == true then
                add(real_maze[#real_maze-1], char)
                add(real_maze[#real_maze-1], char)
                add(real_maze[#real_maze], "w")
                add(real_maze[#real_maze], "w")

            elseif maze[j][i].right_wall == false and maze[j][i].bottom_wall == false then
                add(real_maze[#real_maze-1], char)
                add(real_maze[#real_maze-1], char)
                add(real_maze[#real_maze], char)
                add(real_maze[#real_maze], char)
            end

        end
    end

    for i = 1, #real_maze do
        s = ""
        for j = 1, #real_maze[i] do
            s = s..real_maze[i][j]
        end
        printh(s)
    end

end

function draw_level()
    for x = 1,#real_maze,1 do 
        for y = 1,#real_maze[1],1 do 
            --draw_rect(x,y, flr(prl.fmap[x][y]))
            draw_maze_room(x,y,real_maze[x][y])
        end
    end

    for x = 1,maze_size,1 do 
        for y = 1,maze_size,1 do 
            --draw_rect(x,y, flr(prl.fmap[x][y]))
            draw_old_maze_room(x-maze_size-2,y,maze[x][y])
        end
    end
end

--[[
function draw_rect(x,y, color)
    size = 4
    rectfill(x*size, y*size, (x*size)+size-1, (y*size)+size-1, color)
end
]]

function draw_old_maze_room(x,y,room)
    local size = 2
    --rectfill(x*size, y*size, (x*size)+size-1, (y*size)+size-1, 5)
    rectfill(x*size, y*size, x*size+1, y*size+1, 7)
    if (room.goal == true) rectfill(x*size, y*size, x*size+1, y*size+1, 11)
    --if (room.goal == true) rectfill(x*size+1, y*size+1, x*size+1, y*size+1, 11)
    --if (room.left_wall == false) rectfill(x*size, y*size+1, x*size, y*size+1, 7)
    if (room.right_wall == true) rectfill(x*size+1, y*size, x*size+1, y*size+1, 1)
    if (room.bottom_wall == true) rectfill(x*size, y*size+1, x*size+1, y*size+1, 1)
    --if (room.top_wall == false) rectfill(x*size+1, y*size, x*size+1, y*size, 7)

end 

function draw_maze_room(x,y,room)
    size = 3
    -- rectfill(x*size, y*size, (x*size)+size-1, (y*size)+size-1, 5)
    local room_c = 7
    --if (room.main_path == true) room_c = 8
    --if (room.goal == true) room_c = 11
    if (room == "e") room_c = 8
    if (room == "w") room_c = 1
    if (room == "m") room_c = 8
    if (room == "g") room_c = 11


    
    -- draw rooms
    rectfill(x*size, y*size, (x*size)+size, (y*size)+size, room_c)


    --if (room.right_wall == true) then 
    --    rectfill(x*2*size+(size/2), y*2*size, x*2*size+size+(size/2), y*2*size+size, 4)
    --end
    
    --if (room.top_wall == false) rectfill(x*size+1, y*size, x*size+1, y*size, 7)
end
