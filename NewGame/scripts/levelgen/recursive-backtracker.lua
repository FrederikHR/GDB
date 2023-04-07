-- returns a two-dimensional array of width*height size, populated with maze rooms that are completely closed
function init_maze(width, height,scale,ox,oy)
    local maze = {}

    for x=0, width do
        maze[x] = {}
        for y = 0, height do
            maze[x][y] = {}
            maze[x][y].y = y
            maze[x][y].x = x
            maze[x][y].scale=scale
            maze[x][y].ox=ox
            maze[x][y].oy=oy
            maze[x][y].visited = false
            maze[x][y].main_path = false
            maze[x][y].goal = false
            maze[x][y].top_wall = true
            maze[x][y].right_wall = true
            maze[x][y].left_wall = true
            maze[x][y].bottom_wall = true
        end
    end
    return maze
end

-- inputs a two-dimensional maze room array and moves randomly and removes walls until every maze room has been visited exactly once
-- when the algorithm moves from one room to another, the previous room is added to a stack
-- when no more unvisited rooms are adjacent to the current room, move back one step by popping stack
-- when every room has been visited once, the remaining stack is the solution to the maze (path from first to last room)
function backtrack(maze, width, height)
    local current = maze[1][1]
    local finish = maze[width][height]
    current.goal = true
    finish.goal = true
    current.visited = true
    local stack = {}
    local vcount = 1
    while (vcount < width*height) do
        next = unvisited_neighbour(maze, current.x, current.y, width, height)
        if next != nil then
            remove_separating_wall(current, next)
            next.visited = true
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
    if (x > 1 and maze[x-1][y].visited == false) unvisited[#unvisited+1] = maze[x-1][y]
    if (y > 1 and maze[x][y-1].visited == false) unvisited[#unvisited+1] = maze[x][y-1]
    if (x < width and maze[x+1][y].visited == false) unvisited[#unvisited+1] = maze[x+1][y]
    if (y < height and maze[x][y+1].visited == false) unvisited[#unvisited+1] = maze[x][y+1]
    if (#unvisited == 0) return nil
    
    return rnd(unvisited)
end

-- remove the two walls that separate rooms a and b
function remove_separating_wall(a, b)
    if a.x > b.x then
        a.left_wall = false
        b.right_wall = false
    elseif a.x < b.x then
        a.right_wall = false
        b.left_wall = false
    elseif a.y < b.y then
        a.bottom_wall = false
        b.top_wall = false
    else
        a.top_wall = false
        b.bottom_wall = false
    end
end