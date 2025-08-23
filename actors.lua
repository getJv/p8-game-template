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
      top = {3,4},
      right = {5,6},
      bottom = {5,6},
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
    return new_actor
end

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



