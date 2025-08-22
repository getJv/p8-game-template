routines = {}

-- Call this in the _update function to update eat routine in the table
function routines_manager_update()
    for r in all(routines) do
        if costatus(r.routine) == "dead" then
            del(routines,r)
        else
            assert(coresume(r.routine))
        end
    end

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

-- Add new routine to routines table
--[[
 Sample of usage:
 local full_animation = function()
       update_animation(player,"x",80) -- go right
       wait(10)
       update_animation(player,"x",96,30,ease_in_elastic) -- go right
       wait(30)
       update_animation(player,"y",32) -- go top
 end
 add_new_routine(full_animation)
]]
function routines_add_new(new_func, type)
    local co_item = {
        type = type,
        routine = cocreate(new_func)
    }
    add(routines,co_item)
end

function routines_wait(frames)
    for i=1,frames do
        yield()
    end
end