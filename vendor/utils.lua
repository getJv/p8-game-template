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

--- Parses a multi-line string into a table of objects.
--
-- This function converts a string containing lines of `key=value` pairs
-- separated by semicolons (`;`) into a Lua table. Each line becomes an object.
-- Values are automatically converted to the appropriate type:
-- - `"true"` → boolean `true`
-- - `"false"` → boolean `false`
-- - `"{}"` → empty table `{}`
-- - `""` → empty string `""`
-- - comma-separated strings (e.g., `{a,b,c}`) → table of strings
--
-- Leading and trailing whitespace in each line is removed.
-- Empty lines are ignored.
--
-- @param str_data string
--        The input string containing one or more lines of `key=value` pairs.
--
-- @param single_obj boolean
--        If `true`, only the first parsed object is returned.
--        If `false` or `nil`, a table containing all objects is returned.
--
-- @return table
--        A table of parsed objects. Each object is a table of key-value pairs.
--        Returns a single object if `single_obj` is true.
--
-- @example
-- local data = [[
--     id=potion;name=potion;available=3;cost=50;spr=11
--     id=antidote;name=antidote;available=5;cost=5;spr=12
-- ]]
-- local result = utils.tbl_from_string(data, false)
-- -- result == {
-- --     { id="potion", name="potion", available="3", cost="50", spr="11" },
-- --     { id="antidote", name="antidote", available="5", cost="5", spr="12" }
-- -- }
--
-- local first = utils.tbl_from_string(data, true)
-- -- first == { id="potion", name="potion", available="3", cost="50", spr="11" }
function utils.tbl_from_string(str_data,single_obj)
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

--- Displays a fatal error message and stops the game.
--
-- This function is intended to be used by developers to indicate a critical
-- error that cannot be recovered from, such as missing configuration,
-- invalid data, or other unrecoverable conditions.
-- It clears the screen, prints the error message at a fixed position,
-- and stops execution immediately.
--
-- @param message string
--        The error message to display on the screen.
--
-- @usage
-- panic("Configuration file is missing!")
-- -- The game screen is cleared, the message is displayed, and the game stops.
--
-- @note
-- This function is intended for debugging or fatal error handling during
-- development. In a production environment, consider more graceful
-- error handling or logging.
function utils.panic(message)
    cls()
    print(message,10,10,7)
    stop()
end

--- Checks whether two rectangular actors are colliding.
--
-- This function performs an axis-aligned bounding box (AABB) collision check.
-- Each actor is expected to have the properties:
-- `x` (horizontal position), `y` (vertical position), `w` (width), and `h` (height).
-- Returns `true` if the rectangles overlap and `false` otherwise.
--
-- @param actor_1 table
--        The first actor with fields `x`, `y`, `w`, `h`.
--
-- @param actor_2 table
--        The second actor with fields `x`, `y`, `w`, `h`.
--
-- @return boolean
--        `true` if the two actors' rectangles overlap, `false` otherwise.
--
-- @example
-- local a1 = { x = 10, y = 10, w = 20, h = 20 }
-- local a2 = { x = 25, y = 15, w = 20, h = 20 }
-- local result = utils.actors_collision(a1, a2)
-- -- result == true (they partially overlap)
--
-- local a3 = { x = 0, y = 0, w = 10, h = 10 }
-- local a4 = { x = 20, y = 20, w = 10, h = 10 }
-- local result2 = utils.actors_collision(a3, a4)
-- -- result2 == false (they do not overlap)
function utils.actors_collision(actor_1,actor_2)
     return actor_1.x  < actor_2.x+actor_2.w and
            actor_1.x+actor_1.w  > actor_2.x and
            actor_1.y  < actor_2.y+actor_2.h and
            actor_1.y+actor_1.h  > actor_2.y
end


--- Checks whether an actor collides with a map tile that has a specific flag.
--
-- This function performs a PICO-8 style tile-flag collision check.
--
-- It calculates the tile position based on the actor's coordinates,
-- retrieves the tile using `mget`, and checks if the tile has the flag set
-- using `fget`.
--
-- The collision check looks at the tile located at:
--   tile_x = (actor_obj.x + 1) / CONST.cell_size
--   tile_y = actor_obj.y / CONST.cell_size
--
-- `+1` in the x coordinate compensates for the way PICO-8 draws sprites
-- relative to tile boundaries, preventing boundary off-by-one errors.
--
-- @param actor_obj table
--        The actor object with fields:
--          - `x`: horizontal position in pixels
--          - `y`: vertical position in pixels
--        Optionally can include width/height, though unused here.
--
-- @param flag number
--        The flag index (0–7) to check in the tile metadata.
--
-- @return boolean
--        `true` if the tile at the actor's position has the flag set,
--        `false` otherwise.
--
-- @example
-- CONST = { cell_size = 8 }
--
-- function mget(x, y) return 12 end
-- function fget(tile, flag) return tile == 12 and flag == 1 end
--
-- local actor = { x = 10, y = 16 }
-- local result = map_collision(actor, 1)
-- -- result == true  (tile 12 has flag 1)
function utils.map_collision( actor_obj, flag )
    return fget( mget((actor_obj.x +1)/CONST.cell_size,actor_obj.y/CONST.cell_size), flag )
end