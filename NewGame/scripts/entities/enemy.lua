eanims ={
    idle={fr=15,5,6},
    walk={fr=10,1,2,3,4},
    attack_1={fr=10,7,8,9,10}
}

enemies={}

function make_enemy(x,y,lvl)
    local e={}
    e.ser=1
    e.x=64
    e.y=64
    e.dx=0
    e.dy=0
    e.sz=1
    e.acc=2
    e.elay="idle"
    e.anims=eanims
    e.fle=false
    e.attack=false
    e.aframe=0
    add(enemies,e)
end

function uedate_enemy(e)
    if (e.attack) e.aframe+=1
    move_elayer()
    elayer_attack()
    animate(e)
end

function draw_enemy(e)
    ser(abs(e.ser),e.x,e.y,e.sz,e.sz,e.fle)
end

function enemy_attack(e)
end