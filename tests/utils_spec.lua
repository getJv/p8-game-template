package.path = package.path .. ";./vendor/?.lua;./tests/utils/?.lua;"
require("pico_mocks")


describe("utils.tbl_filter", function()

    before_each(function()
        -- intentionally reload the tested file
        dofile("./vendor/utils.lua")

    end)

    local test_cases = {
        {
            name = "returns only elements that match the filter",
            routines = {
                { uniq_id = 1, name = "A" },
                { uniq_id = 2, name = "B" },
                { uniq_id = 3, name = "C" },
            },
            filter_func = function(r) return r.uniq_id == 2 end,
            expected = { { uniq_id = 2, name = "B" } }
        },
        {
            name = "returns empty table when nothing matches",
            routines = {
                { uniq_id = 1 },
                { uniq_id = 2 },
            },
            filter_func = function(r) return r.uniq_id == 99 end,
            expected = {}
        },
        {
            name = "returns all items if filter always true",
            routines = {
                { v = 1 },
                { v = 2 },
                { v = 3 },
            },
            filter_func = function(r) return true end,
            expected = {
                { v = 1 },
                { v = 2 },
                { v = 3 },
            }
        },
        {
            name = "returns empty if input table is empty",
            routines = {},
            filter_func = function(r) return true end,
            expected = {}
        },
    }

    for _, case in ipairs(test_cases) do
        it(case.name, function()
            local result = utils.tbl_filter(case.routines, case.filter_func)
            assert.are.same(case.expected, result)
        end)
    end



end)

describe("utils.edges_collision", function()

    before_each(function()
        -- intentionally reload the tested file
        dofile("./vendor/utils.lua")

    end)

    local test_cases = {
        {
            name = "actor fully inside screen bounds",
            actor = { x = 10, y = 20, w = 16, h = 16 },
            expected = false
        },
        {
            name = "actor exceeds right screen edge",
            actor = { x = 120, y = 20, w = 16, h = 16 },
            expected = true
        },
        {
            name = "actor exceeds left screen edge",
            actor = { x = -1, y = 20, w = 16, h = 16 },
            expected = true
        },
        {
            name = "actor exceeds top screen edge",
            actor = { x = 10, y = -5, w = 16, h = 16 },
            expected = true
        },
        {
            name = "actor exceeds bottom screen edge",
            actor = { x = 10, y = 120, w = 16, h = 16 },
            expected = true
        },
        {
            name = "actor touches edge exactly but does not exceed",
            actor = { x = 127 - 16, y = 127 - 16, w = 16, h = 16 },
            expected = false
        },
        {
            name = "actor slightly exceeds edge",
            actor = { x = 127 - 15, y = 127 - 15, w = 16, h = 16 },
            expected = true
        },
    }

    for _, case in ipairs(test_cases) do
        it(case.name, function()
            local result = utils.edges_collision(case.actor)
            if case.expected then
                assert.is_true(result)
            else
                assert.is_false(result)
            end
        end)
    end
end)

describe("utils.str_trim", function()
    before_each(function()
        -- intentionally reload the tested file
        dofile("./vendor/utils.lua")

    end)

    local test_cases = {
        { name = "leading spaces", input = "   hello", expected = "hello" },
        { name = "trailing spaces", input = "world   ", expected = "world" },
        { name = "both sides", input = "   hello world   ", expected = "hello world" },
        { name = "tabs", input = "\thello\t", expected = "hello" },
        { name = "mixed spaces and tabs", input = "\t  hello world \t ", expected = "hello world" },
        { name = "only whitespace", input = "   \t  \t ", expected = "" },
        { name = "no whitespace", input = "hello", expected = "hello" },
        { name = "empty string", input = "", expected = "" },
    }

    for _, case in ipairs(test_cases) do
        it(case.name, function()
            local result = utils.str_trim(case.input)
            assert.are.equal(case.expected, result)
        end)
    end


end)

describe("utils.tbl_from_str_tbl", function()

    before_each(function()
        dofile("./vendor/utils.lua")
    end)

    local test_cases = {
        {
            name = "returns empty table for number input",
            input = 123,
            separator = ";",
            expected = {}
        },
        {
            name = "splits a simple string with semicolon separator",
            input = "[a;b;c]",
            separator = ";",
            expected = {"a","b","c"}
        },
        {
            name = "splits a string with comma separator",
            input = "[apple,banana,cherry]",
            separator = ",",
            expected = {"apple","banana","cherry"}
        },
        {
            name = "returns empty table for empty string brackets",
            input = "[]",
            separator = ";",
            expected = {}
        },
        {
            name = "handles single item in brackets",
            input = "[single]",
            separator = ";",
            expected = {"single"}
        },
        {
            name = "trims spaces around items if needed",
            input = "[a ; b ; c]",
            separator = ";",
            expected = {"a "," b "," c"} -- depends se a função split já trim, caso contrário mantém espaços
        }
    }

    for _, case in ipairs(test_cases) do
        it(case.name, function()
            local result = utils.tbl_from_str_tbl(case.input, case.separator)
            assert.are.same(case.expected, result)
        end)
    end
end)

describe("utils.tbl_from_string", function()

    before_each(function()
        dofile("./vendor/utils.lua")
    end)

    local test_cases = {
        {
            name = "parses multiple objects from multi-line string",
            input = [[
                id=potion;name=potion;available=3;cost=50;spr=11
                id=antidote;name=antidote;available=5;cost=5;spr=12
            ]],
            single_obj = false,
            expected = {
                { id = "potion", name = "potion", available = "3", cost = "50", spr = "11" },
                { id = "antidote", name = "antidote", available = "5", cost = "5", spr = "12" }
            }
        },
        {
            name = "returns first object if single_obj is true",
            input = [[
                id=potion;name=potion;available=3;cost=50;spr=11
                id=antidote;name=antidote;available=5;cost=5;spr=12
            ]],
            single_obj = true,
            expected = { id = "potion", name = "potion", available = "3", cost = "50", spr = "11" }
        },
        {
            name = "ignores empty lines and trims spaces",
            input = [[
                a=1;b=2

                c=3;d=4
            ]],
            single_obj = false,
            expected = {
                { a="1", b="2" },
                { c="3", d="4" }
            }
        },
        {
            name = "converts boolean and empty values",
            input = [[
                flag1=true;flag2=false;empty_table={};empty_string=""
            ]],
            single_obj = false,
            expected = {
                { flag1 = true, flag2 = false, empty_table = {}, empty_string = "" }
            }
        },
        {
            name = "parses comma-separated list values",
            input = [[
                items={a,b,c};numbers={1,2,3}
            ]],
            single_obj = false,
            expected = {
                { items = {"a","b","c"}, numbers = {"1","2","3"} }
            }
        },
        {
            name = "returns empty table for empty string",
            input = "",
            single_obj = false,
            expected = {}
        }
    }

    for _, case in ipairs(test_cases) do
        it(case.name, function()
            local result = utils.tbl_from_string(case.input, case.single_obj)
            assert.are.same(case.expected, result)
        end)
    end
end)

describe("utils.actors_collision", function()

    before_each(function()
        dofile("./vendor/utils.lua")
        dofile("./vendor/consts.lua")
    end)

    local test_cases = {
        {
            name = "returns true when actors overlap partially",
            actor1 = { x=10, y=10, w=20, h=20 },
            actor2 = { x=25, y=15, w=20, h=20 },
            expected = true
        },
        {
            name = "returns false when actors do not touch",
            actor1 = { x=0, y=0, w=10, h=10 },
            actor2 = { x=20, y=20, w=10, h=10 },
            expected = false
        },
        {
            name = "returns true when one actor is completely inside another",
            actor1 = { x=5, y=5, w=20, h=20 },
            actor2 = { x=10, y=10, w=5, h=5 },
            expected = true
        },
        {
            name = "returns false when actors touch edges but do not overlap",
            actor1 = { x=0, y=0, w=10, h=10 },
            actor2 = { x=10, y=0, w=10, h=10 },
            expected = false
        },
        {
            name = "returns true when actors touch partially at corner",
            actor1 = { x=0, y=0, w=10, h=10 },
            actor2 = { x=5, y=5, w=10, h=10 },
            expected = true
        },
        {
            name = "returns false when actors are far apart",
            actor1 = { x=50, y=50, w=10, h=10 },
            actor2 = { x=100, y=100, w=20, h=20 },
            expected = false
        }
    }

    for _, case in ipairs(test_cases) do
        it(case.name, function()
            local result = utils.actors_collision(case.actor1, case.actor2)
            assert.are.equal(case.expected, result)
        end)
    end
end)

describe("utils.map_collision", function()

    before_each(function()
        dofile("./vendor/utils.lua")
    end)

    local test_cases = {
        {
            name = "returns false when fget returns false",
            actor = { x = 10, y = 16 },
            flag = 1,
            mock_tile = 5,
            fget_value = false,
            expected = false,
        },
    }

    for _, case in ipairs(test_cases) do
        it(case.name, function()
            -- Override mget to capture arguments and return mock tile
            local called_x, called_y

            function mget(x, y)
                called_x = x
                called_y = y
                return case.mock_tile
            end

            -- Override fget to return expected value
            function fget(tile, flag)
                assert.are.equal(case.mock_tile, tile)
                assert.are.equal(case.flag, flag)
                return case.fget_value
            end

            local result = utils.map_collision(case.actor, case.flag)

            -- check collision result
            assert.are.equal(case.expected, result)

            -- check tile coordinate calculations when expected
            if case.expected_tile_x then
                assert.are.equal(case.expected_tile_x, called_x)
            end
            if case.expected_tile_y then
                assert.are.equal(case.expected_tile_y, called_y)
            end
        end)
    end
end)
