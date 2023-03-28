function scroll_camera(pa,s)

	--basic scrolling
	--cx = px - 64
	--cy = py - 64

	--[[slighty less basic 
	scrolling	
	--]]
	if s then
		cx=pa.x-50+pa.sz/2
		cy=pa.y-50+pa.sz/2
	else
		if pa.x <= box.x then
			cx -= box.x - pa.x
			box.x=pa.x

		elseif pa.x+pa.sw*8 >= box.x+box.w then
			local diff = (pa.x+pa.sw*8) - (box.x + box.w)
			cx += diff
			box.x += diff
		end


		if pa.y < box.y then
			cy -= box.y - pa.y
			box.y -= box.y - pa.y
		end

		if pa.y+pa.sh*8 > box.y + box.h then
			local diffy = (pa.y+pa.sh*8) - (box.y+box.h)
			cy += diffy
			box.y += diffy
		end
	end
end