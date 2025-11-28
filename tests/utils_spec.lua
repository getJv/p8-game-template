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