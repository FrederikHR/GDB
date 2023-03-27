function collide_map(obj,aim,flag)
	--obj = table, needs x,y,w,h
	local x=obj.x    local y=obj.y
	local w=obj.sz*8 local h=obj.sz*8
	
	local x1=0 local y1=0
	local x2=0 local y2=0
	
	if aim=="left" then
		x1=x    	 y1=y+1
		x2=x+1    y2=y+h-1
	elseif aim=="right" then
		x1=x+w-1    y1=y+1
		x2=x+w      y2=y+h-1
	elseif aim=="up" then
		x1=x+4    y1=y-1
		x2=x+w-4  y2=y
	elseif aim=="down" then
		x1=x+3      y1=y+h
		x2=x+w-2    y2=y+h+1
    elseif aim=="center" then
		x1=x+2      y1=y
		x2=x+w-2    y2=y+h-2
	end
	
	--pixels to tiles
	x1\=8 y1\=8
	x2\=8 y2\=8
	
    log(x1.." "..y1.." "..x2.." "..y2)
    log(fget(mget(x1,y1),flag))

	if fget(mget(x1,y1),flag)
	or fget(mget(x1,y2),flag)
	or fget(mget(x2,y1),flag)
	or fget(mget(x2,y2),flag) then
		local sp={mget(x1,y1),mget(x1,y2),mget(x2,y1),mget(x2,y2)}
		return true,x1,y1,x2,y2,sp
	end
	return false
end

function collide_sprite(obj,aim,obj2)
	--obj = table, needs x,y,w,h
	local x=obj.x    local y=obj.y
	local w=obj.sz*8 local h=obj.sz*8
	
	local x1=0 local y1=0
	local x2=0 local y2=0
	
	if aim=="left" then
		x1=x-1    y1=y
		x2=x      y2=y+h-1
	elseif aim=="right" then
		x1=x+w-1    y1=y
		x2=x+w      y2=y+h-1
	elseif aim=="up" then
		x1=x+2    y1=y-1
		x2=x+w-3  y2=y
	elseif aim=="down" then
		x1=x+2      y1=y+h
		x2=x+w-2    y2=y+h
    elseif aim=="center" then
		x1=x+2      y1=y+2
		x2=x+w-2    y2=y+h-2
    elseif aim=="atk" then
        x1=x        y1=y
        x2=x+w      y2=y+h
	end

	if not((obj2.x > x2)
	or (obj2.y > y2)
	or ((obj2.x+obj2.sz*8) < x1)
	or ((obj2.y+obj2.sz*8) < y1)) then
		return true
	end
	
	return false
end