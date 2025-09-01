routines = {}
ROUTINE_DRAW = "draw"

-- Call this in the _update function to update each routine in the table not DRAW type
function routines_manager_update()
    _routines_iterate(
            routines_filter(
                    function(r)
                        return r.type ~= ROUTINE_DRAW
                    end
            )
    )
end

-- Call this in the _draw function to update each routine type DRAW in the table
function routines_manager_draw()
    _routines_iterate(
            routines_filter(
                    function(r)
                        return r.type == ROUTINE_DRAW
                    end
            )
    )
end

-- consume the routines in the given list
function _routines_iterate(routines_list)
    for r in all(routines_list) do
        if costatus(r.routine) == "dead" then
            del(routines,r)
        else
            assert(coresume(r.routine))
        end
    end
end

--[[ routines_filter
 - filter the routines using a  callback func like in javascript
 - return a table with the true comparison filter
example:
```
local result_search = routines_filter(
            function(r)
                return r.uniq_id == uniq_id
            end
    )
```
]]--
function routines_filter(filter_func)
    local filtered = {}
    for r in all(routines) do
        if(filter_func(r)) then
            add(filtered,r)
        end
    end
    return filtered
end

-- Return true if the routine table still have routines in the given type
function routines_has_type_of(routine_type)
    for r in all(routines) do
        if r.type == routine_type then
            return true
        end
    end
    return false
end

--[[ routines_add_new
 - Add new routine to routines table
 -
 Sample of usage:
 local full_animation = function()
       update_animation(player,"x",80) -- go right
       wait(10)
       update_animation(player,"x",96,30,ease_in_elastic) -- go right
       wait(30)
       update_animation(player,"y",32) -- go top
 end
 routines_add_new(full_animation,ROUTINE_XYZ,"any_uniq_id")
]]
function routines_add_new(new_func, type,uniq_id)
    local co_item = {
        uniq_id = uniq_id,
        type = type,
        routine = cocreate(new_func)
    }

    local result_search = routines_filter(
            function(r)
                return r.uniq_id == uniq_id
            end
    )


    if #result_search < 1 then -- prevent add infinite routines if called inside _update or _draw
        add(routines,co_item)
    end

end

function routines_wait(frames)
    for i=1,frames do
        yield()
    end
end