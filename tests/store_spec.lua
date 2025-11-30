package.path = package.path .. ";./vendor/?.lua;./tests/utils/?.lua;"
require("pico_mocks")


describe("store initial value loading", function()



    before_each(function()
        -- intentionally reload the tested file
        dofile("./vendor/utils.lua")
        dofile("./vendor/store.lua")

    end)

    it("store.store_initial_values string",function()
        local given = utils.str_trim(store_initial_values)
        local expected = utils.str_trim([[ is_open=false;cursor_spr=16;cursor_pos=1 ]])
        assert.are.same(given,expected)
    end  )

    it("store table state ",function()
        local expected = {
            cursor_pos = '1',
            is_open = false,
            cursor_spr = '16',
        }
        assert.are.same(store,expected)

    end  )

    it("basket and store start empty",function()
        assert.are.same(basket,{})
        assert.are.same(stores,{})
    end)

    it("store.store_box",function()
        local given = store_box
        local expected = {
            selected_color = '12',
            text_color = '7',
            border_color = '6',
            w = '88',
            y = '20',
            x = '20',
            title = 'shopping',
            h = '88',
            bg_color = '5'
        }
        assert.are.same(given,expected)
    end  )

end)

describe("store functions", function()

    local mock = nil

    before_each(function()
        mock = require("luassert.mock")

        -- intentionally reload the tested file
        dofile("./vendor/utils.lua")
        dofile("./tests/utils/helpers.lua")
        dofile("././vendor/consts.lua")
        dofile("./vendor/store.lua")

    end)

    it("store_create adds a function to stores",function()

        stub(_G, "store_routine_draw")

        local store_string = [[
                    id=potion;name=potion;available=3;cost=50;spr=11
                    id=antidote;name=antidote;available=5;cost=5;spr=12
                    ]]

        store_create("store_man",store_string)

        assert.are.equal("function", type(stores.store_man))

        -- test if tue generated function are called with right value
        stores.store_man()
        assert.stub(store_routine_draw).was_called(1)
        assert.stub(store_routine_draw).was_called_with(
                utils.tbl_from_string(store_string)
        )


    end  )

    it("store_close call checkout, close store and reset basket",function()

    -- not implemented.


    end  )

end)
