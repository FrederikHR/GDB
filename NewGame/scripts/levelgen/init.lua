prl = {}
current_map={}
maze={}

function init_levelgen(floor)
    printh("init level "..floor)
    local maze_size = 8
    local maze_scale = 32
    if floor % 2 == 0 then
        maze_size = 4
        maze_scale = 48
    end
        
    maze = init_maze(maze_size,maze_size,maze_scale,-400,-400)
    maze[2][2].goal = true
    maze[maze_size*2][maze_size*2].goal = true
    backtrack(maze,maze_size,maze_size,maze[2][2],maze[maze_size*2][maze_size*2])
    if (floor % 3 != 0) backtrack(maze,maze_size,maze_size,maze[maze_size*2][2],maze[2][maze_size*2])
    return maze_size
end

function draw_level()
    local scale=maze[1][1].scale
    local ox=maze[1][1].ox
    local oy=maze[1][1].oy
    for x = 1,#maze do 
        for y = 1,#maze[1] do
            if (p.curr_mt==nil or abs(p.curr_mt.x-x)<4 and abs(p.curr_mt.y-y)<4) draw_maze_room(x,y,maze[x][y],scale,ox,oy)
        end
    end
end

function draw_maze_room(x,y,room,scale,ox,oy)

    --rectfill(x*scale+ox, y*scale+oy, x*scale+scale+ox, y*scale+scale+oy, 7)
    if (not room.is_wall) draw_tile("floor",x,y,scale,ox,oy)
    if room.goal then
        draw_tile("goal",x,y,scale,ox,oy)
        --rectfill(x*scale+ox, y*scale+oy, x*scale+scale+ox, y*scale+scale+oy, 11)
    end
    if room.is_wall then
        --rectfill(x*scale+ox, y*scale+oy, x*scale+scale+ox, y*scale+scale+oy, 1)
        draw_tile("wall",x,y,scale,ox,oy)
        if room.goal then
            rectfill(x*scale+ox, y*scale+oy, x*scale+scale+ox, y*scale+scale+oy, 9)
        end
    end

end

function draw_tile(type,x,y,scale,ox,oy)
    local walls={}
    local floors={112,113,114}
    srand(x+y+scale)
    if type=="goal" then
        local sx,sy=get_sspr_x_y(115)
        sspr(sx,sy,8,8,x*scale+ox,y*scale+oy,scale,scale)
    else
        for i=0,scale\8-1 do
            for j=0,scale\8-1 do
                if (type=="floor") then 
                    spr(rnd(floors),x*scale+ox+i*8,y*scale+oy+j*8)
                    if(y<#maze[1] and maze[x][y+1].is_wall == true and j == 1) spr(96,x*scale+ox+i*8,y*scale+oy+scale)
                elseif (type=="wall") then
                    if y==#maze[1] and j==0 and x!=0 and x!=#maze[1] and maze[x][y-1].is_wall == false then --if on bottom edge
                        spr(96,x*scale+ox+i*8,y*scale+oy+j*8)
                    elseif ((x==0 or x==#maze[1]) and y<#maze[1]) then --if on left/right edges
                        if (x==0 and i==scale\8-1) spr(98,x*scale+ox+i*8,y*scale+oy+j*8,1,1,x==0)
                        if (x==#maze[1] and i==0) spr(98,x*scale+ox+i*8,y*scale+oy+j*8,1,1,x==0)
                    elseif y!=#maze[1] then
                        spr(99,x*scale+ox+i*8,y*scale+oy+j*8)
                    end
                end
            end
        end
    end
end