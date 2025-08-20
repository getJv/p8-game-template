function scene_menu_init()
    _update = scene_menu_update
    _draw = scene_menu_draw

    local e1 = add_new_enemy()
    local e1_anim = function()
        update_animation(e1,"x",120) -- go right
        wait(10)
        update_animation(e1,"x",10,30,ease_in_elastic) -- go right
    end
    add_new_routine(e1_anim)

end

function scene_menu_update()
    update_routines_manager()
end

function scene_menu_draw()
    cls()
    draw_enemies()
end

