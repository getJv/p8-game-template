routines = {}

-- Call this in the _update function to update eat routine in the table
function update_routines_manager()
    for r in all(routines) do
        if costatus(r) == "dead" then
            del(routines,r)
        else
            assert(coresume(r))
        end
    end
end

-- add new routine to routines table
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
function add_new_routine(new_func)
    add(routines,cocreate(new_func))
end

function update_animation(obj,key,target_point,frames,anim_function)
    local initial_point = obj[key]
    frames = frames or 30
    anim_function = anim_function or linear
    for i=1,frames do
        local time = anim_function(i/frames) -- time is update based on anim_function type
        obj[key] = lerp(initial_point,target_point,time)
        yield()
    end
end

function linear(t)
    return t
end

function wait(frames)
    for i=1,frames do
        yield()
    end
end

-- a: from, b: to, t: time
function lerp(a,b,t)
    return a + (b - a) * t
end



