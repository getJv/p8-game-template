package.path = package.path .. ";./vendor/?.lua;./tests/utils/?.lua;"
require("pico_mocks")

describe("utils.tbl_filter", function()

    before_each(function()
        -- intentionally reload the tested file
        dofile("./vendor/utils.lua")

    end)

    it("returns only elements that match the filter", function()
        local routines = {
            { uniq_id = 1, name = "A" },
            { uniq_id = 2, name = "B" },
            { uniq_id = 3, name = "C" },
        }

        local result = utils.tbl_filter(routines, function(r)
            return r.uniq_id == 2
        end)

        assert.are.same({
            { uniq_id = 2, name = "B" }
        }, result)
    end)

  it("returns empty table when nothing matches", function()
        local routines = {
            { uniq_id = 1 },
            { uniq_id = 2 },
        }

        local result = utils.tbl_filter(routines, function(r)
            return r.uniq_id == 99
        end)

        assert.are.same({}, result)
    end)

      it("returns all items if filter always true", function()
           local routines = {
               { v = 1 },
               { v = 2 },
               { v = 3 },
           }

           local result = utils.tbl_filter(routines, function(r)
               return true
           end)

           assert.are.same(routines, result)
       end)

        it("returns empty if input table is empty", function()
           local routines = {}

           local result = utils.tbl_filter(routines, function(r)
               return true
           end)

           assert.are.same({}, result)
       end)



end)


describe("utils.edges_collision", function()

    before_each(function()
        -- intentionally reload the tested file
        dofile("./vendor/utils.lua")

    end)

    it("returns false when actor is fully inside screen bounds", function()
        local actor = {
            x = 10,
            y = 20,
            w = 16,
            h = 16
        }

        local result = utils.edges_collision(actor)

        assert.is_false(result)
    end)

    it("returns true when actor exceeds right screen edge", function()
        local actor = {
            x = 120,
            y = 20,
            w = 16,
            h = 16
        }

        local result = utils.edges_collision(actor)

        assert.is_true(result)
    end)

    it("returns true when actor exceeds left screen edge", function()
        local actor = {
            x = -1,
            y = 20,
            w = 16,
            h = 16
        }

        local result = utils.edges_collision(actor)

        assert.is_true(result)
    end)

    it("returns true when actor exceeds top screen edge", function()
        local actor = {
            x = 10,
            y = -5,
            w = 16,
            h = 16
        }

        local result = utils.edges_collision(actor)

        assert.is_true(result)
    end)

    it("returns true when actor exceeds bottom screen edge", function()
        local actor = {
            x = 10,
            y = 120,
            w = 16,
            h = 16
        }

        local result = utils.edges_collision(actor)

        assert.is_true(result)
    end)

    it("returns false when actor touches edge exactly but does not exceed", function()
        local actor = {
            x = 127 - 16,
            y = 127 - 16,
            w = 16,
            h = 16
        }

        -- x + w == 127
        -- y + h == 127
        local result = utils.edges_collision(actor)

        assert.is_false(result)
    end)

    it("returns true when actor slightly exceeds edge", function()
        local actor = {
            x = 127 - 15,
            y = 127 - 15,
            w = 16,
            h = 16
        }

        -- x + w == 128
        -- y + h == 128
        local result = utils.edges_collision(actor)

        assert.is_true(result)
    end)



end)