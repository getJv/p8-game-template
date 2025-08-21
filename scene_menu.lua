function scene_menu_init()
    _update = scene_menu_update
    _draw = scene_menu_draw

    local e1 = add_new_enemy("bob")
    local e2 = add_new_enemy("ana banana")


    local dialog_anim = function()
        add_box(e1,"hello there?")
        wait(8)
        add_box(e2,"hey hey!")
        wait(3)
        add_box(e2,"what can i do for you?")
    end
    add_new_routine(dialog_anim,ROUTINE_DIALOG)


end

function scene_menu_update()
    update_routines_manager()
end

function scene_menu_draw()
    cls()
    draw_dialog_box()
    --draw_enemies()
end

