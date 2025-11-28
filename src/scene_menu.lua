function scene_menu_init()
    _update = scene_menu_update
    _draw = scene_menu_draw
    load_dialogs()
    load_stores()

    --init actors



    actors_add_new(
            utils.tbl_from_string([[id=store_man;name=bob]],true),
            utils.tbl_from_string([[x=96;y=5;w=16;h=16]],true),
            utils.tbl_from_string([[curr_anim=idle;curr_anim_frames=16;curr_spr_index=1;spr_w=2;spr_h=2;idle={32,34};]],true)
    )
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



