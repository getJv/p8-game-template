function scene_menu_init()
    _update = scene_menu_update
    _draw = scene_menu_draw

    local e1 = add_new_enemy("bob")
    local e2 = add_new_enemy("ana banana")

    local dialog_anim = function()
        dialog_add(e1,"hello there?")
        routines_wait(8)
        dialog_add(e2,"hey hey!")
        routines_wait(3)
        dialog_add(e2,"what can i do for you?")
        routines_wait(8)
    end
    routines_add_new(dialog_anim,ROUTINE_DIALOG)


end

function scene_menu_update()
    routines_manager_update()
end

function scene_menu_draw()
    cls()
    dialog_draw()
    --draw_enemies()
end

