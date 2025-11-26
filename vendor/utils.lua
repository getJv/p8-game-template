--[[
    File: utils.lua
    Token usage: 257
    Utility helpers used across the project: table filtering, edge collision checks, string trimming,
    simple key=value multiline string parsing, and a fatal panic helper.
]]

--[[
    tbl_filter
    - Return a new table with items that match the provided predicate

Sample of usage:

```lua
local result_search = tbl_filter(
    routines,
    function(r)
        return r.uniq_id == uniq_id
    end
)
```
]]
function tbl_filter(tbl,filter_func)
    local filtered = {}
    for r in all(tbl) do
        if(filter_func(r)) then
            add(filtered,r)
        end
    end
    return filtered
end

--[[
    edges_collision
    - Check if an object would collide with the 0..127 screen bounds
    - Returns true if any edge would be exceeded

Sample of usage:

```lua
if not edges_collision({x=10,y=10,w=10,h=10,}) then
    do something...
end
```
]]
function edges_collision(actor_obj)
    if actor_obj.x + actor_obj.w > 127
            or actor_obj.x < 0
            or actor_obj.y < 0
            or actor_obj.y + actor_obj.h > 127
    then
        return true
    end
    return false
end

--[[
    str_trim
    - Remove leading and trailing spaces and tabs from a string

Sample of usage:

```lua
local clean = str_trim("  hello\t") -- "hello"
```
]]
function str_trim(s)
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


--[[ tbl_from_str_tbl
Useful to create real tables from string tables;

Example:
```lua
local string_tbl = "{1,2}"
tbl_from_str_tbl(string_tbl,","),true) -- returns: {1,2}
```
]]
function tbl_from_str_tbl(text_value,separator)
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
        line = str_trim(line)
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
                    elseif #tbl_from_str_tbl(value,",") > 1 then
                        value = tbl_from_str_tbl(value,",")
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