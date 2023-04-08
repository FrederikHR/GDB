prl = {}
maze_size = 4
current_map={}
maze={}

function init_levelgen()
    maze = init_maze(maze_size,maze_size,48,-400,-400)
    backtrack(maze,maze_size,maze_size)
end

function draw_level()
    local scale=maze[1][1].scale
    local ox=maze[1][1].ox
    local oy=maze[1][1].oy
    for x = 1,#maze do 
        for y = 1,#maze[1] do
            if (p.curr_mt== nil or abs(p.curr_mt.x-x)<3 and abs(p.curr_mt.y-y)<3) draw_maze_room(x,y,maze[x][y],scale,ox,oy)
        end
    end
end

function draw_maze_room(x,y,room,scale,ox,oy)

    --rectfill(x*scale+ox, y*scale+oy, x*scale+scale+ox, y*scale+scale+oy, 7)
    draw_tile("floor",x,y,scale,ox,oy)
    if room.goal then
        rectfill(x*scale+ox, y*scale+oy, x*scale+scale+ox, y*scale+scale+oy, 11)
    end
    if room.is_wall then
        rectfill(x*scale+ox, y*scale+oy, x*scale+scale+ox, y*scale+scale+oy, 1)
        if room.goal then
            rectfill(x*scale+ox, y*scale+oy, x*scale+scale+ox, y*scale+scale+oy, 9)
        end
    end

end

function draw_tile(type,x,y,scale,ox,oy)
    local walls={}
    local floors={112,113,114}
    srand(x+y+scale)
    for i=0,scale\8-1 do
        for j=0,scale\8-1 do
            if (type=="floor") spr(rnd(floors),x*scale+ox+i*8,y*scale+oy+j*8)
        end
    end
end