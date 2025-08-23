function scene_menu_init()
    _update = scene_menu_update
    _draw = scene_menu_draw

    local e1 = actors_add_new("bob")
    local e2 = actors_add_new(
            "ana banana",
            10,
            10,
            8,
            8,
            {
                curr_anim = "idle",
                curr_spr_index = 1,
                spr_w = 1,
                spr_h = 1,
                idle = {1,2},
                top = {3,4},
                right = {5,6},
                bottom = {5,6},
            })

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
    actors_draw()
    dialog_draw()
end

