ROUTINE_ACTOR_ANIM = "actor_anim"
actors = {}

--[[
actors_add_new
 - add a actor with name, type, coords and a anim map
 - add the actor in the actors maps
 - if a anim map is not given a square numbered square is drew
 - returns the actor reference

deps:
 - routines.lua

usage example:

```
actors_add_new(
   "ana",
   10,
   10,
   8,
   8,
   {
      curr_anim = "idle",
      curr_spr_index = 0,
      spr_w = 1,
      spr_h = 1,
      idle = {1,2},
      up = {3,4},
      right = {5,6},
      down = {7,8},
      left = {9,10}
    },
    13
 )
```

]]
function actors_add_new(actor_name, x, y,w,h, anim,color)

    local new_actor = {
        name = actor_name or "",
        name_width = print(actor_name,0,0,7,true) or "",
        x = x or rnd(120) + 5,
        y = y or rnd(120) + 5,
        w = w or 8,
        h = h or 8,
        anim = anim or "",
        color = color or rnd(14) +1
    }
    add(actors, new_actor)

    if( new_actor.anim ~= "") then
        routines_add_new(
                function()
                    actor_routine_anim(new_actor)
                end,
                ROUTINE_ACTOR_ANIM,
                "update_actor_spr_" .. actor_name
        )
    end

    return new_actor
end

function _actor_curr_anim_sprs(actor)
    return actor.anim[actor.anim.curr_anim]
end

--[[
actor_routine_anim
 - update the actor sprites to keep animation alive
 - lower frames fast updates. default is 12

deps:
    - routines_wait:routines.lua

]]
function actor_routine_anim(actor,frames)
    frames = frames or 12
    for i = 1, #_actor_curr_anim_sprs(actor) do
        actor.anim.curr_spr_index = i
        routines_wait(frames)
        if(i == #_actor_curr_anim_sprs(actor)) then
            actor.anim.curr_spr_index = 1
            actor_routine_anim(actor)
        end
    end
end

--[[
actors_draw
 - draw the actors sprites or default square
 - should be call at _scene _draw section

]]
function actors_draw()
    for i = 1, #actors do
        local e = actors[i]
        if e.anim == "" then
            rectfill(
                    e.x,
                    e.y,
                    e.x+e.w,
                    e.y+e.h,
                    e.color
            )
            print(i, e.x+e.w/4+1, e.y+e.h/4, 7)
        else
            spr(
                e.anim[e.anim.curr_anim][e.anim.curr_spr_index], -- :D beautiful hum?
                e.x,e.y,e.anim.spr_w,e.anim.spr_h
            )
        end
    end
end



