package.path = package.path .. ";./?.lua;./vendor/?.lua;/app/vendor/?.lua"
require('tests/pico_mocks')
require('utils')

describe("utils.lua", function()
    it(" test_tbl_filter filter using a callback logic ", function()
        local tbl = { 1, 2, 3, 4, 5 }
        local filtered = tbl_filter(tbl, function(n)
            return n % 2 == 0
        end)
        assert.are.same(filtered, { 2, 4 })
    end)

    it("str_trim removes blank space from both sides", function()
        assert.are.same(str_trim("  hello  "), "hello")
        assert.are.same(str_trim("\thello\t"), "hello")
        assert.are.same(str_trim("  hello world  "), "hello world")
    end)

    describe("tbl_from_string", function()
        local inputString = [[
            is_open=false;cursor_spr=16;cursor_pos=1;title=Big;
            is_open=true;cursor_spr=18;cursor_pos=5;title=tiny;
        ]]

        local item1 = {
            is_open=false,
            cursor_spr="16",
            cursor_pos="1",
            title="Big"
        }
        local item2 = {
            is_open=true,
            cursor_spr="18",
            cursor_pos="5",
            title="tiny"
        }

        it("converts strings into tables across multiple lines and keeps types as expected", function()
            local obj = tbl_from_string(inputString, false)
            assert.is.equal(#obj, 2)
            assert.are.same(item1, obj[1])
            assert.are.same(item2, obj[2])
        end)

        it("returns only the first object when single_obj is true", function()
            local oneLine = "is_open=true;cursor_spr=7;cursor_pos=9;title=Solo;"
            local obj = tbl_from_string(oneLine, true)
            assert.are.same({ is_open=true, cursor_spr="7", cursor_pos="9", title="Solo" }, obj)
        end)

        it("converts true/false, {} and \"\" correctly", function()
            local line = "a=true;b=false;c={};d=\"\";e=123" -- e remains string
            local obj = tbl_from_string(line, true)
            assert.are.same(true, obj.a)
            assert.are.same(false, obj.b)
            assert.are.same({}, obj.c)
            assert.are.same("", obj.d)
            assert.are.same("123", obj.e)
        end)

        it("parses list-like values using tbl_from_str_tbl", function()
            local line = "list={1,2,3};name=jhon"
            local obj = tbl_from_string(line, true)
            assert.are.same({"1","2","3"}, obj.list)
            assert.are.same("jhon", obj.name)
        end)

        it("ignores entries without '=' and ignores empty lines", function()
            local messy = [[
                foo=bar;invalid;also_invalid
                
                is_open=false; trailing=ok;
            ]]
            local arr = tbl_from_string(messy, false)
            assert.is.equal(2, #arr)
            assert.are.same({ foo="bar" }, arr[1])
            assert.are.same({ is_open=false, trailing="ok" }, arr[2])
        end)

        it("handles trailing semicolons without creating bogus keys", function()
            local line = "x=1;y=2;" -- trailing ;
            local obj = tbl_from_string(line, true)
            assert.are.same({ x="1", y="2" }, obj)
        end)
    end)
end)
