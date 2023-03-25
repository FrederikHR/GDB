--test

function animate(an)
	if an.state != an.play then
		an.state = an.play
		an.animindex=1
		an.time=0
	elseif #an.anims[an.state] > 1 then
		an.time+=1
		if an.time > an.anims[an.state].fr then
			an.time=0
			an.animindex = (an.animindex % #an.anims[an.state]) + 1
			if an.animindex==1 and an.anims[an.state].next then
				an.play=an.anims[an.state].next
				an.state=an.play
			end
		end
	end
	an.spr = an.anims[an.state][an.animindex]
end