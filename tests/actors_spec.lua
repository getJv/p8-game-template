package.path = package.path .. ";./?.lua;./vendor/?.lua;/app/vendor/?.lua"
require('tests/pico_mocks')
require('utils')
require('routines')
require('consts')
require('actors')

describe("actors.lua", function()
    before_each(function()
        cls()
        routines = {}
        actors = {}
        player = { in_scene = true }
    end)

    --[[it("actors_add_new creates actor without anim and draws default square", function()
        local a = actors_add_new({ id="a1", name="bob", color=12, in_scene=true, in_collision={} }, { x=10, y=20, w=8, h=6 })
        assert.are.same(a, actors["a1"])
        -- draw default branch
        _actor_drawing(a)
        assert.is_true(#_draw_calls.rectfill >= 1)
    end)]]

    it("actors_add_new with anim registers a DRAW routine and anim draw produces spr calls", function()
        local anim = utils.tbl_from_string([[curr_anim=idle;curr_anim_frames=2;curr_spr_index=1;spr_w=1;spr_h=1;idle={1,2,3}]], true)
        local a = actors_add_new({ id="a2", name="alice", color=8, in_scene=true, in_collision={} }, { x=1, y=2, w=8, h=8 }, anim)
        -- should have a draw routine queued
        assert.is_true(routines_has_type_of(ROUTINE_DRAW))
        -- step some draw frames to execute the inner routine and callback drawing
        for i=1,10 do
            routines_manager_draw()
        end
        assert.is_true(#_draw_calls.spr > 0)
        assert.is_true(a.anim.curr_spr_index >= 1)
    end)

    --[[it("actor_in_scene_routine runs while player.in_scene is true and stops after false", function()
        local ticks = 0
        actor_in_scene_routine(function() ticks = ticks + 1 end, ROUTINE_UPDATE, 'test_actor_wrapper')
        for i=1,3 do routines_manager_update() end
        assert.is_true(ticks > 0)
        player.in_scene = false
        local prev = ticks
        for i=1,3 do routines_manager_update() end
        assert.are.same(prev, ticks)
    end)]]
end)
