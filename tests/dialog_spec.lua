package.path = package.path .. ";./vendor/?.lua;./tests/utils/?.lua;"
require("pico_mocks")
require("utils")

describe("dialog.lua", function()

    before_each(function()
        -- intentionally reload the tested file
        dofile("./vendor/dialog.lua")


    end)

    it("test name", function()
            -- do test here
    end)


end)
