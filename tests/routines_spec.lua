package.path = package.path .. ";./?.lua;./vendor/?.lua;/app/vendor/?.lua"
require('tests/pico_mocks')
require('utils')
require('routines')

describe("routines.lua", function()
    before_each(function()
        routines = {}
    end)


    it("routines_wait yields requested frames and can call a callback", function()
        local calls = 0
        local frames = 0
        local co
        local fn = function()
            routines_wait(3, function() calls = calls + 1 end)
            frames = frames + 1
        end
        routines_add_new(fn, ROUTINE_UPDATE, 'waiter')
        for i=1,5 do
            routines_manager_update()
        end
        assert.are.equal(3, calls)
        assert.are.equal(1, frames)
    end)

    it("manager_draw filters by draw type", function()
        local draw_count = 0
        routines_add_new(function() draw_count=draw_count+1; yield() end, ROUTINE_DRAW, 'd1')
        routines_add_new(function() yield() end, ROUTINE_UPDATE, 'u1')
        routines_manager_draw()
        assert.are.equal(1, draw_count)
    end)

    it("routines_has_type_of returns true when present", function()
        routines_add_new(function() yield() end, ROUTINE_UPDATE, 'u2')
        assert.is_true(routines_has_type_of(ROUTINE_UPDATE))
    end)
end)
