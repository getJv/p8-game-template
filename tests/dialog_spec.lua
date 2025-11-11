package.path = package.path .. ";./?.lua;./vendor/?.lua;/app/vendor/?.lua"
require('tests/pico_mocks')
require('utils')
require('routines')
require('consts')
require('actors')
require('dialog')

describe("dialog.lua", function()
    before_each(function()
        cls()
        routines = {}
        dialogs = tbl_from_string([[ current=0;items={} ]],true)
        dialog_control = tbl_from_string([[message=;current_index=0;typing_speed=1;waiting_confirmation_to_continue=true;]], true)
        dialog_frame_obj = tbl_from_string([[x=4;y=113;w=119;h=10;box_bg_color=5;box_border_color=3;box_txt_color=7;box_p_top=3;box_p_left=3;tab_name_h=8;tab_m_left=4;]], true)
        actors = {}
    end)

end)
