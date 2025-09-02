function scene_menu_init()
    _update = scene_menu_update
    _draw = scene_menu_draw

    --init actors
    local e1 = actors_add_new("bob")
    player_init()

    --set dialogs actors
    local dialog_anim = function()
        dialog_add(e1, "hello there?",3)
        routines_wait(8)
        dialog_add(player, "hey hey!")
        routines_wait(3)
        dialog_add(player, "what can i do for you?")
        routines_wait(8)
    end
    routines_add_new(dialog_anim, ROUTINE_DIALOG,"dialog_test")

end



function scene_menu_update()

    routines_manager_update()
    player_controls_update()
    dialog_continue_update()

end

function scene_menu_draw()
    cls()
    actors_draw()
    dialog_frame("hahahah","ana")
    routines_manager_draw()
    debug_draw_rules()

end

