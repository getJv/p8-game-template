function scene_menu_init()
    _update = scene_menu_update
    _draw = scene_menu_draw

    --init actors
    local e1 = actors_add_new("bob")
    player_init()


    dialog_create(
            "initial_chat",
            function()
                dialog_speech(e1, "hello there?")
                dialog_speech(player, "hey hey!")
                dialog_speech(player, "what can i do for you?")
            end
    )
end



function scene_menu_update()

    routines_manager_update()
    player_controls_update()

    if btn(4) then
        dialog_start("initial_chat")
    end

end

function scene_menu_draw()
    cls()
    routines_manager_draw()
    --TODO: a new kind of ROUTINE_DRAW_Z1..9 will be need to filter routines to be drew over others... aka: routines_manager_draw_z1()
    debug_draw_rules()

end

