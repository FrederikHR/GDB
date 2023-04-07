-- returns a two-dimensional array of width*height size, populated with maze rooms that are completely closed
function init_maze(width, height,scale,ox,oy)
    local maze = {}

    for x=1, (width*3)+1 do
        maze[x] = {}
        for y = 1, (height*3)+1 do
            maze[x][y] = {}
            maze[x][y].y = y
            maze[x][y].x = x
            maze[x][y].sz = scale
            maze[x][y].scale = scale
            maze[x][y].ox = ox
            maze[x][y].oy = oy
            maze[x][y].visited = false
            maze[x][y].main_path = false
            maze[x][y].goal = false

            maze[x][y].is_wall = true
        end
    end
    return maze
end

-- inputs a two-dimensional maze room array and moves randomly and removes walls until every maze room has been visited exactly once
-- when the algorithm moves from one room to another, the previous room is added to a stack
-- when no more unvisited rooms are adjacent to the current room, move back one step by popping stack
-- when every room has been visited once, the remaining stack is the solution to the maze (path from first to last room)
function backtrack(maze, width, height)
    local current = maze[2][2]
    local finish = maze[width*3][height*3]
    current.goal = true
    finish.goal = true
    current.visited = true
    current.is_wall = false
    local stack = {}
    local vcount = 1
    while (vcount < width*height) do
        printh("current: "..current.x..","..current.y)
        next = unvisited_neighbour(maze, current.x, current.y, width*3, height*3)
        if next != nil then
            printh("visiting: "..next.x..","..next.y)
            remove_separating_wall(current, next, maze)
            next.visited = true
            next.is_wall = false
            vcount += 1
            stack[#stack+1] = current
            current = next

            if current == finish then
                for i = 1, #stack do
                    stack[i].main_path = true
                end
            end

        else
            if (#stack == 0) return
            current = deli(stack, #stack)
        end
    end
end

-- get a random neighbouring room that has not been visited before
-- returns nil if all rooms have already been visited
function unvisited_neighbour(maze, x, y, width, height)
    local unvisited = {}
    if (x > 4 and maze[x-3][y].visited == false) unvisited[#unvisited+1] = maze[x-3][y]
    if (y > 4 and maze[x][y-3].visited == false) unvisited[#unvisited+1] = maze[x][y-3]
    if (x < width-1 and maze[x+3][y].visited == false) unvisited[#unvisited+1] = maze[x+3][y]
    if (y < height-1 and maze[x][y+3].visited == false) unvisited[#unvisited+1] = maze[x][y+3]
    if (#unvisited == 0) return nil
    
    return rnd(unvisited)
end

-- remove the wall that separate rooms a and b
function remove_separating_wall(a, b, maze)
    if a.x > b.x then
        maze[a.x-1][a.y].is_wall = false
        maze[a.x-2][a.y].is_wall = false
    elseif a.x < b.x then
        maze[a.x+1][a.y].is_wall = false
        maze[a.x+2][a.y].is_wall = false
    elseif a.y < b.y then
        maze[a.x][a.y+1].is_wall = false
        maze[a.x][a.y+2].is_wall = false
    else
        maze[a.x][a.y-1].is_wall = false
        maze[a.x][a.y-2].is_wall = false
    end
end