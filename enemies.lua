enemies = {}

function add_new_enemy()
    local new_enemy = {
        x = rnd(120) + 5,
        y = rnd(120) + 5,
        color =  rnd(12)+1
    }
    add(enemies,new_enemy)
    return new_enemy
end

function update_enemies()

end

function draw_enemies()
    for e in all(enemies) do
        rectfill(
                e.x,
                e.y,
                e.x+8,
                e.y+8,
                e.color
        )
    end
end



