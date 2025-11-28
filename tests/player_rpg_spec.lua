package.path = package.path .. ";./?.lua;./vendor/?.lua;/app/vendor/?.lua"
require('tests/pico_mocks')
require('utils')
require('routines')
require('consts')
require('actors')
require('player_rpg')

-- Provide minimal globals used by player_init wrappers
store = { is_open = false }
function store_open(id) store.last_opened = id end
function dialog_start(id) dialogs = dialogs or {}; dialogs.started = id end

describe("player_rpg.lua", function()
    before_each(function()
        cls()
        routines = {}
        actors = {}
        store = { is_open = false }
        dialogs = { started = nil }
    end)


    local function setup_player()
        player = actors_add_new(
                utils.tbl_from_string([[id=player;name=ana]], true),
                utils.tbl_from_string([[x=10;y=10;w=8;h=8]], true),
                utils.tbl_from_string([[curr_anim=idle;curr_anim_frames=12;curr_spr_index=1;spr_w=1;spr_h=1;idle={1,2};up={3,4};right={5,6};down={7,8};left={9,10};]], true)
        )
        -- ensure there is a store_man actor to avoid nil in collision check
        actors["store_man"] = { x=100, y=100, w=8, h=8 }
    end




end)
