function scene_menu_init()
    _update = scene_menu_update
    _draw = scene_menu_draw

    --init actors
    actors_add_new("enemy_1", "bob")
    player_init()

    dialog_create(
            "initial_chat",
            [[
                enemy_1;hello there
                player;hey hey!
                player;what can i do for you?
            ]]
    )
end

function scene_menu_update()

    routines_manager_update()
    if (not shopping.is_open) then
        player_controls_update()
        if btn(4) then
            shopping_open()
        end
    else
        --shopping_cursor_manager()
    end



    if btn(4) then
        dialog_start("initial_chat")
    end


end


function scene_menu_draw()
    cls()
    routines_manager_draw()
    --TODO: a new kind of ROUTINE_DRAW_Z1..9 will be need to filter routines to be drew over others... aka: routines_manager_draw_z1()
    debug_draw_rules()
    print(#routines,10,10)
end



