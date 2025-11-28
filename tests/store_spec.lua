package.path = package.path .. ";./?.lua;./vendor/?.lua;/app/vendor/?.lua"
require('tests/pico_mocks')
require('utils')
require('routines')
require('consts')
require('store')

describe("store.lua", function()
    before_each(function()
        cls()
        routines = {}
        basket = {}
        stores = {}
        store = utils.tbl_from_string([[is_open=false;cursor_spr=16;cursor_pos=1]], true)
    end)

    local function sample_options()
        return utils.tbl_from_string([[ id=potion;name=potion;available=2;cost=50;spr=15\n id=ant;name=antidote;available=1;cost=5;spr=15 ]])
    end

end)
