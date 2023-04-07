prl = {}
maze_size = 4
current_map={}
maze={}

function init_levelgen()
    --prl = perlin()
    --prl:init()
    --prl:getmapdata(0,150,0,150)
    maze = init_maze(maze_size,maze_size,5,-400,-400)
    backtrack(maze,maze_size,maze_size)
end

function draw_level()
    for x = 1,#maze do 
        for y = 1,#maze[1] do 
            --draw_rect(x,y, flr(prl.fmap[x][y]))
            draw_maze_room(x,y,maze[x][y],maze.scale,maze.ox,maze.oy)
        end
    end
end

function draw_maze_room(x,y,room,scale,ox,oy)
    local size = scale*8

    rectfill(x*size+ox, y*size+oy, x*size+size+ox, y*size+size+oy, 7)
    if room.goal then
        rectfill(x*size+ox, y*size+oy, x*size+size+ox, y*size+size+oy, 11)
    end
    if room.is_wall then
        rectfill(x*size+ox, y*size+oy, x*size+size+ox, y*size+size+oy, 1)
        if room.goal then
            rectfill(x*size+ox, y*size+oy, x*size+size+ox, y*size+size+oy, 9)
        end
    end

end