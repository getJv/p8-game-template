--[[
File: routines.lua
Token usage: 154
Purpose:
 This module manages coroutine-like routines for Pico-8. It stores, updates and draws routines,
 cleans up finished ones, allows adding routines with a unique id, checks for the presence of
 routines by type, and provides a helper to wait a number of frames (optionally executing a
 callback among yields).

]]
routines = {}
ROUTINE_DRAW = "draw"
ROUTINE_UPDATE = "update"

-- Call this in the _update function to update each routine in the table not DRAW type
--[[ routines_manager_update
 - Iterate and run all non-DRAW routines once per _update tick
 - Removes finished routines automatically
 - Safe to call each frame

Sample of usage:

```lua
-- inside _update()
routines_manager_update()
```
]]
function routines_manager_update()
    _routines_iterate(
            tbl_filter(
                    routines,
                    function(r)
                        return r.type ~= ROUTINE_DRAW
                    end
            )
    )
end

-- Call this in the _draw function to update each routine type DRAW in the table
--[[ routines_manager_draw
 - Iterate and run all routines of type DRAW once per _draw frame
 - Removes finished routines automatically
 - Safe to call each frame

Sample of usage:

```lua
-- inside _draw()
routines_manager_draw()
```
]]
function routines_manager_draw()

    local rr =  tbl_filter(
            routines,
            function(r)
                return r.type == ROUTINE_DRAW
            end
    )


    _routines_iterate(rr)
end

-- consume the routines in the given list
--[[ _routines_iterate
 - Consume and step a given list of routines
 - Remove dead ones and resume the alive ones
 - Internal helper used by the managers

Sample of usage:

```lua
-- normally you won't call this directly; see the managers above
```
]]
function _routines_iterate(routines_list)
    for r in all(routines_list) do
        if costatus(r.routine) == "dead" then
            del(routines,r)
        else
            assert(coresume(r.routine))
        end
    end
end

-- Return true if the routine table still have routines in the given type
--[[ routines_has_type_of
 - Check if there is at least one routine of the given type in the registry
 - Useful to know if a category is still active

Sample of usage:

```lua
if routines_has_type_of(ROUTINE_DRAW) then
  -- draw-related routines are still running
end
```
]]
function routines_has_type_of(routine_type)
    for r in all(routines) do
        if r.type == routine_type then
            return true
        end
    end
    return false
end

--[[ routines_add_new
 - Add a new routine (coroutine) to the registry
 - Prevent duplicates using uniq_id
 - Safe to call from inside _update/_draw (adds only once)
 - Routines are created with cocreate(new_func)

Sample of usage:

```lua
local full_animation = function()
       update_animation(player,"x",80) -- go right
       wait(10)
       update_animation(player,"x",96,30,ease_in_elastic) -- go right
       wait(30)
       update_animation(player,"y",32) -- go top
 end
 routines_add_new(full_animation,ROUTINE_XYZ,"any_uniq_id")
```
]]
function routines_add_new(new_func, type,uniq_id)
    local co_item = {
        uniq_id = uniq_id,
        type = type,
        routine = cocreate(new_func)
    }

    local result_search = tbl_filter(routines,
            function(r)
                return r.uniq_id == uniq_id
            end
    )


    if #result_search < 1 then -- prevent add infinite routines if called inside _update or _draw
        add(routines,co_item)
    end

end

--[[ routines_wait
 - Suspend the current routine for a number of frames
 - Optionally run a callback on each frame while waiting (among yields)

Sample of usage:

```lua
routines_wait(30)
routines_wait(60,function() update_particles() end)
```
]]
function routines_wait(frames,cb_among_yields)
    for i=1,frames do
        if(cb_among_yields) then
            cb_among_yields()
        end
        yield()
    end
end