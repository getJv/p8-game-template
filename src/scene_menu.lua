function scene_menu_init()
    _update = scene_menu_update
    _draw = scene_menu_draw
    load_dialogs()
    load_stores()

    --init actors
    actors_add_new("store_man", "bob",
            96,
            5,
            16,
            16,
            {
                curr_anim = "idle",
                curr_anim_frames = 16,
                curr_spr_index = 1,
                spr_w = 2,
                spr_h = 2,
                idle = { 32, 34 },
            })
    player_init()


end

function scene_menu_update()

    routines_manager_update()
    if (not store.is_open) then
        player_controls_update()
    end

    if player.in_collision["store_man"] then
        if btn(4) then
            store_open("store_man")
        end
    elseif btn(4) then
        dialog_start("initial_chat")
    end


end

function scene_menu_draw()
    cls()
    map(0, 0)
    routines_manager_draw()

end



