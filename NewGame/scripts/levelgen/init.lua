prl = {}
maze_size = 5

function init_levelgen()
    --prl = perlin()
    --prl:init()
    --prl:getmapdata(0,150,0,150)
    maze = init_maze(maze_size,maze_size)
    backtrack(maze,maze_size,maze_size)
end

function draw_level()
    for x = 1,maze_size do 
        for y = 1,maze_size do 
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
    local size = 3
    rectfill(x*size, y*size, (x*size)+size-1, (y*size)+size-1, 5)
    rectfill(x*size+1, y*size+1, x*size+1, y*size+1, 7)

    if (room.main_path == true) rectfill(x*size+1, y*size+1, x*size+1, y*size+1, 8)
    if (room.goal == true) rectfill(x*size+1, y*size+1, x*size+1, y*size+1, 11)
    if (room.left_wall == false) rectfill(x*size, y*size+1, x*size, y*size+1, 7)
    if (room.right_wall == false) rectfill(x*size+2, y*size+1, x*size+2, y*size+1, 7)
    if (room.bottom_wall == false) rectfill(x*size+1, y*size+2, x*size+1, y*size+2, 7)
    if (room.top_wall == false) rectfill(x*size+1, y*size, x*size+1, y*size, 7)
end



function draw_real_level()
    for x = 1,maze_size do 
        for y = 1,maze_size do 
            draw_real_maze_room(x,y,maze[x][y],2)
        end
    end
end

function draw_real_maze_room(x,y,room,scale)
    local size = 3
    for i=1,3 do
        for j=1,3 do
            pix2mset(x*size*scale+i*scale-1,y*scale*size+j*scale-1,241,scale)
            --mset(x*size+i-1,y*size+j-1,241)
        end
    end

    pix2mset(x*size*scale+1*scale,y*size*scale+1*scale,240,scale)
    --mset(x*size+1, y*size+1, 240)

    --if (room.main_path) mset(x*size+1, y*size+1, 240)
    --if (room.goal == true) rectfill(x*size+1, y*size+1, 240)
    if (not room.left_wall) pix2mset(x*size*scale,y*size*scale+1*scale,240,scale)--mset(x*size, y*size+1, 240)
    if (not room.right_wall) pix2mset(x*size*scale+2*scale,y*size*scale+1*scale,240,scale)--mset(x*size+2, y*size+1, 240)
    if (not room.bottom_wall) pix2mset(x*size*scale+1*scale,y*size*scale+2*scale,240,scale)--mset(x*size+1, y*size+2, 240)
    if (not room.top_wall) pix2mset(x*size*scale+1*scale,y*size*scale,240,scale)--mset(x*size+1, y*size, 240)
end

function pix2mset(x,y,spr,scale)
    for i=1,scale do
        for j=1,scale do
            mset(x+i-1,y+j-1,spr)
        end
    end
end