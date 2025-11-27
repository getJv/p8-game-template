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


