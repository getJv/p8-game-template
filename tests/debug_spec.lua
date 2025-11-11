package.path = package.path .. ";./?.lua;./vendor/?.lua;/app/vendor/?.lua"
require('tests/pico_mocks')
require('./utils')
require('./debug')

describe("debug.lua", function()
    before_each(function()
        cls()
        _stopped = false
    end)

    it("draws rules: border and mid lines", function()
        debug_draw_rules()
        assert.is_true(#_draw_calls.rect >= 1)
        assert.is_true(#_draw_calls.line >= 2)
    end)

    it("draws object lines around an object", function()
        debug_obj_lines({x=10,y=20,w=8,h=6}, 12)
        assert.is_true(#_draw_calls.line >= 4)
    end)

    it("prints string and can stop when requested", function()
        debug_dd("hello", true, 1, 2)
        assert.is_true(_stopped)
        assert.are.same("debug:", _print_log[1].val)
    end)


end)
