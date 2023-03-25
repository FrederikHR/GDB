panims ={

}

p={}

function make_player()
    p.spr=1
    p.x=64
    p.y=64
    p.dx=0
    p.dy=0
    p.sz=1
    p.acc=2
    p.play="idle"
    p.flp=false
end

function update_player()
    move_player()
end

function draw_player()
    spr(abs(p.spr),p.x,p.y,p.sz,p.sz,p.flp!=(p.spr))
end

function move_player()
    p.dx=0
    p.dy=0
    if btn(⬅️) then
        p.dx-=p.acc
        p.flp=true
        p.play="walk"
    end
    if btn(➡️) then
        p.dx+=p.acc
        p.flp=false
        p.play="walk"
    end
    if btn(2) then
        p.dy-=p.acc
        p.play="walk"
    end
    if btn(3) then
        p.dy+=p.acc
        p.play="walk"
    end
    p.x+=p.dx
    p.y+=p.dy
end