

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