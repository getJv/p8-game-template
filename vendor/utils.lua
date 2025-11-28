utils = {}


--- Filters elements of a table based on a predicate function.
--
-- This function iterates through all elements of the given table and returns
-- a new table containing only the elements for which the filter function
-- returns true.
--
-- This implementation uses PICO-8 style iteration (`all`) and insertion (`add`).
-- Make sure these functions are available or mocked when running outside PICO-8.
--
-- @param tbl table
--        The table to be filtered. Expected to be an array-like table.
--
-- @param filter_func function
--        A function that receives one element of the table and must return true
--        to keep the element in the result, or false to discard it.
--
-- @return table
--        A new table containing only the elements that passed the filter.
--
-- @example
-- local routines = {
--     { uniq_id = 1, name = "A" },
--     { uniq_id = 2, name = "B" },
-- }
--
-- local result = utils.tbl_filter(routines, function(r)
--     return r.uniq_id == 2
-- end)
-- -- result = { { uniq_id = 2, name = "B" } }
--
function utils.tbl_filter(tbl,filter_func)
    local filtered = {}
    for r in all(tbl) do
        if(filter_func(r)) then
            add(filtered,r)
        end
    end
    return filtered
end

--- Checks whether an actor object is colliding with the screen edges.
--
-- This function determines if a rectangular actor exceeds the boundaries
-- of a 128x128 PICO-8 screen. It returns `true` if any part of the actor
-- is outside the valid screen coordinates (0 to 127), and `false` otherwise.
--
-- @param actor_obj table
--        A table representing the actor, expected to have the following numeric fields:
--        - `x`: the horizontal position (top-left corner)
--        - `y`: the vertical position (top-left corner)
--        - `w`: the width of the actor
--        - `h`: the height of the actor
--
-- @return boolean
--        Returns `true` if the actor is outside the screen boundaries, `false` otherwise.
--
-- @example
-- local actor = { x = 120, y = 50, w = 16, h = 16 }
-- local collided = utils.edges_collision(actor)
-- -- collided == true because x + w = 136 > 127
--
-- local actor2 = { x = 50, y = 50, w = 16, h = 16 }
-- local collided2 = utils.edges_collision(actor2)
-- -- collided2 == false, actor fully inside screen
function utils.edges_collision(actor_obj)
    if actor_obj.x + actor_obj.w > 127
            or actor_obj.x < 0
            or actor_obj.y < 0
            or actor_obj.y + actor_obj.h > 127
    then
        return true
    end
    return false
end

--- Trims leading and trailing whitespace from a string.
--
-- This function removes spaces and tab characters from the start and end
-- of the input string. It does not modify the original string but returns
-- a new trimmed string.
--
-- @param s string
--        The input string to be trimmed.
--
-- @return string
--        A new string with leading and trailing whitespace removed.
--
-- @example
-- local result1 = utils.str_trim("   hello world   ")
-- -- result1 == "hello world"
--
-- local result2 = utils.str_trim("\t\thello\t")
-- -- result2 == "hello"
--
-- local result3 = utils.str_trim("no_spaces")
-- -- result3 == "no_spaces"
--
-- local result4 = utils.str_trim("   \t  ")
-- -- result4 == "" (empty string)
function utils.str_trim(s)
    -- Remove leading whitespace
    local start = 1
    while sub(s, start, start) == " " or sub(s, start, start) == "\t" do
        start = start + 1
    end


    -- Remove trailing whitespace
    local finish = #s
    while finish >= start and (sub(s, finish, finish) == " " or sub(s, finish, finish) == "\t") do
        finish = finish - 1
    end

    return sub(s, start, finish)
end


--- Converts a string representation of a table into a Lua table.
--
-- This function expects a string with items enclosed in brackets (e.g., "[a;b;c]")
-- and separated by the given `separator`. It removes the opening and closing brackets
-- and splits the inner string by the separator to produce a table of elements.
-- If the input is a number, it returns an empty table.
--
-- @param text_value string|number
--        The input string to convert, or a number. Numbers will return an empty table.
--
-- @param separator string
--        The character or substring used to split the inner string into elements.
--
-- @return table
--        A table containing the elements extracted from the string. Returns `{}` for numbers or empty strings.
--
-- @example
-- local t1 = utils.tbl_from_str_tbl("[a;b;c]", ";")
-- -- t1 == {"a", "b", "c"}
--
-- local t2 = utils.tbl_from_str_tbl("[apple,banana,cherry]", ",")
-- -- t2 == {"apple", "banana", "cherry"}
--
-- local t3 = utils.tbl_from_str_tbl(42, ";")
-- -- t3 == {} (number input returns empty table)
--
-- local t4 = utils.tbl_from_str_tbl("[]", ";")
-- -- t4 == {} (empty brackets)
function utils.tbl_from_str_tbl(text_value,separator)
    if type(text_value) == "number" then
        return {}
    end
    return split(sub(text_value,2,#text_value-1),separator)
end

--[[
 - convert a multline string in a arraylist of objects
 - if you just have one-line remember to use the key access myResult[1]
 0 is single_obj is true it return a obj interad of a list
]]
function tbl_from_string(str_data,single_obj)
    local list = {}
    for line in all(split(str_data, '\n')) do -- split lines
        local obj = {}
        line = utils.str_trim(line)
        if #line > 0 then -- remove possible extra lines
            for entry in all(split(line, ';')) do -- split lines
                local parties = split(entry, '=')
                local value = parties[2]
                if #parties > 1 then
                    -- Convert value to the appropriate type
                    if value == "true" then
                        value = true
                    elseif value == "false" then
                        value = false
                    elseif value == "{}" then
                        value = {}
                    elseif value == '""' then
                        value=""
                    elseif #utils.tbl_from_str_tbl(value,",") > 1 then
                        value = utils.tbl_from_str_tbl(value,",")
                    end

                    obj[parties[1]] = value
                end
            end
            add(list,obj)
        end
    end
    if single_obj then
        return list[1]
    end
    return list
end

--[[ panic
 - is a fatal error thal will stop the game.
 - it helps the developer to understand with config is missing
]]
function panic(message)
    cls()
    print(message,10,10,7)
    stop()
end


function actors_collision(actor_1,actor_2)
     return actor_1.x  < actor_2.x+actor_2.w and
            actor_1.x+actor_1.w  > actor_2.x and
            actor_1.y  < actor_2.y+actor_2.h and
            actor_1.y+actor_1.h  > actor_2.y
end

function map_collision( actor_obj, flag )
    return fget( mget((actor_obj.x +1)/CONST.cell_size,actor_obj.y/CONST.cell_size), flag )
end

--[[
if package then
    return utils
end]]
