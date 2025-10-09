--[[
    File: actors.lua
    Token usage: 188
    Actor registry and animation drawing helpers. Adds and animates actors on screen.
]]

actors = {}

--[[
actors_add_new
 - add a actor with name, type, coords and a anim map
 - add the actor in the actors maps
 - if a anim map is not given a square numbered square is drew
 - returns the actor reference
 - in_collision is a key_value tbl that hold the actor_id in collision (in_collision["store_man"] = true)

 deps:
 - routines.lua
 
 usage example:
 
```
actors_add_new(
   "player_1",
   "ana",
   10,
   10,
   8,
   8,
   {
      curr_anim = "idle",
      curr_anim_frames = 12,
      curr_spr_index = 0,
      spr_w = 1,
      spr_h = 1,
      idle = {1,2},
      up = {3,4},
      right = {5,6},
      down = {7,8},
      left = {9,10}
    },
    13,
    in_collision = {}
 )
```

]]
function actors_add_new(actor_id,actor_name, x, y,w,h, anim,color,in_scene)
    local new_actor = {
        id = actor_id,
        name = actor_name or "",
        x = x or rnd(120) + 5,
        y = y or rnd(120) + 5,
        w = w or 8,
        h = h or 8,
        anim = anim or "", -- anim is an object
        color = color or rnd(14) +1,
        in_collision = {},
        in_scene = in_scene or true
    }
    actors[actor_id]=new_actor

    if( new_actor.anim ~= "") then
        -- routine to draw the sprite sequence
        routines_add_new(
                function()
                    actor_routine_anim_draw(new_actor)
                end,
                ROUTINE_DRAW,
                "draw_actor_" .. actor_id
        )
    end
    return new_actor
end

--[[
TODO: player have the sprites updated by the user controls. but new actors
will need a kind of routine update the will set the curr_anim after some trigger...
]]

--[[
actor_routine_anim_draw
 - update the actor sprites to keep animation alive
 - lower frames fast updates. default is 12

deps:
    - routines_wait:routines.lua

]]
function actor_routine_anim_draw(actor)
    while true do
        for i = 1, #actor.anim[actor.anim.curr_anim] do
            actor.anim.curr_spr_index = i
            routines_wait(actor.anim.curr_anim_frames, function()
                _actor_drawing(actor)
            end)
        end
        actor.anim.curr_spr_index = 1 -- go to first sprite
    end

end
--[[
_actor_drawing
 - draw the actors sprites or default square
]]
function _actor_drawing(actor)
        if actor.anim == "" then
            rectfill(
                    actor.x,
                    actor.y,
                    actor.x+actor.w,
                    actor.y+actor.h,
                    actor.color
            )
            print(i, actor.x+actor.w/4+1, actor.y+actor.h/4, 7)
        else
            spr(
                    actor.anim[actor.anim.curr_anim][actor.anim.curr_spr_index], -- :D beautiful hum?
                    actor.x,actor.y,actor.anim.spr_w,actor.anim.spr_h
            )
        end
end

--[[
actor_in_scene_routine
 - a wrapper to add a actor routine to run while actor.in_scene is true
]]
function actor_in_scene_routine(callback_func,routine_type,routine_id)
    routines_add_new(
            function()
                while player.in_scene do
                    callback_func()
                    yield()
                end
            end,
            routine_type,
            routine_id
    )
end




