

--[[
a filter function the return a new tbl with the found items
or empty tbl when noting is found

example:
```
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

function edges_collision(new_x,new_y,obj_w,obj_h)
    if new_x + obj_w > 127
            or new_x < 0
            or new_y < 0
            or new_y + obj_h > 127
    then
        return true
    end
    return false
end

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


--[[
 - convert a multline string in a arraylist of objects
 - if you just have one-line remember to use the key access myResult[1]
 0 is single_obj is true it return a obj interad of a list

 ```
 example:
 local tt = tbl_from_string([[
            is_open=false;cursor_spr=16;cursor_pos=1
        ]\])[1]
 -- tt is now a object in a tbl: {{is_open=false,...}}
```


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