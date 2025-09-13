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
    store_create("store_id",
            [[
                id=potion;name=potion;available=3;cost=50;sprite=15
                id=antidote;name=antidote;available=5;cost=5;sprite=15
                ]]
    )
end

function scene_menu_update()

    routines_manager_update()
    if (not store.is_open) then
        player_controls_update()
    end

    if btn(4) then
        dialog_start("initial_chat")
        store_open("store_id")
    end


end

function scene_menu_draw()
    cls()
    routines_manager_draw()
    debug_draw_rules()
end



