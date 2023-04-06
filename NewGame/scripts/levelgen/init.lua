prl = {}
maze_size = 5
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
    local ox,oy = maze[1][1].ox,maze[1][1].oy
    local scale = maze[1][1].scale
    for x = 1,maze_size do 
        for y = 1,maze_size do 
            if p.x > (x-1)*scale*3*8+ox and p.x < (x+3)*scale*3*8+ox and p.y > (y-1)*scale*3*8+oy and p.y < (y+3)*scale*3*8+oy then
                draw_real_maze_room(x,y,maze[x][y],scale,ox,oy)
            end
        end
    end
end

function draw_real_maze_room(x,y,room,scale,ox,oy)
    local size = 3
    local rx=x*size*scale
    local ry=y*size*scale
    for i=1,3 do
        for j=1,3 do
            pix2mset(rx+(i-1)*scale,ry+(j-1)*scale,241,scale,ox,oy)
            --mset(x*size+i-1,y*size+j-1,241)
        end
    end

    pix2mset(rx+1*scale,ry+1*scale,240,scale,ox,oy)
    --mset(x*size+1, y*size+1, 240)

    --if (room.main_path) mset(x*size+1, y*size+1, 240)
    --if (room.goal == true) rectfill(x*size+1, y*size+1, 240)
    if (not room.left_wall) pix2mset(rx,ry+1*scale,240,scale,ox,oy)--mset(x*size, y*size+1, 240)
    if (not room.right_wall) pix2mset(rx+2*scale,ry+1*scale,240,scale,ox,oy)--mset(x*size+2, y*size+1, 240)
    if (not room.bottom_wall) pix2mset(rx+1*scale,ry+2*scale,240,scale,ox,oy)--mset(x*size+1, y*size+2, 240)
    if (not room.top_wall) pix2mset(rx+1*scale,ry,240,scale,ox,oy)--mset(x*size+1, y*size, 240)
end

function pix2mset(x,y,sprite,scale,ox,oy)
    local sx,sy = get_sspr_x_y(sprite)
    sspr(sx,sy,8,8,x*8+ox,y*8+oy,scale*8,scale*8)
    --for i=1,scale do
        --if (current_map[x*8+(i-1)*8+ox] == nil) current_map[x*8+(i-1)*8+ox] = {}
    --    for j=1,scale do
    --        spr(sprite,x*8+(i-1)*8+ox,y*8+(j-1)*8+oy)
        --    current_map[x*8+(i-1)*8+ox][y*8+(j-1)*8+oy] = {spr=sprite,x=x*8+(i-1)*8+ox,y=y*8+(j-1)*8+oy,sz=scale}
    --    end
    --end
end