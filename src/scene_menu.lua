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
end

function scene_menu_draw()
    cls()
    map(0, 0)
    routines_manager_draw()
end



