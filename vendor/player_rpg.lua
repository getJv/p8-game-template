--[[
    File: player_rpg.lua
    Token usage: 166
    Player actor setup and input handling for movement and animation updates.
]]

player = {}

--[[
    player_init
    - Initialize the player actor with default animation map and size

Sample of usage:

```lua
player_init()
```
]]
function player_init()
    player = actors_add_new(
            "player",
            "ana banana",
            10,
            10,
            8,
            8,
            {
                curr_anim = "idle",
                curr_anim_frames = 12,
                curr_spr_index = 1,
                spr_w = 1,
                spr_h = 1,
                idle = { 1, 2 },
                up = { 3, 4 },
                right = { 5, 6 },
                down = { 7, 8 },
                left = { 9, 10 }
            })
end
--[[
player_controls_update
 - manager the waking of player
]]
function player_controls_update()

    -- compute intended delta using direction components
    local dx = 0
    local dy = 0
    if btn(1) then dx = 1 end -- right
    if btn(0) then dx = -1 end -- left overrides right
    if btn(3) then dy = 1 end -- down
    if btn(2) then dy = -1 end -- up overrides down

    -- choose animation by priority: horizontal, then vertical, else idle
    if dx > 0 then
        _actor_update_anim(player, "right")
    elseif dx < 0 then
        _actor_update_anim(player, "left")
    elseif dy < 0 then
        _actor_update_anim(player, "up")
    elseif dy > 0 then
        _actor_update_anim(player, "down")
    else
        _actor_update_anim(player, "idle")
    end

    if dx == 0 and dy == 0 then
        return
    end

    new_actor_coords = {
        x = player.x + dx,
        y = player.y + dy,
        w = player.w,
        h = player.h
    }

    if edges_collision(new_actor_coords) then
        return
    end

    player.in_collision["store_man"] = actors_collision(new_actor_coords,actors["store_man"])
    if player.in_collision["store_man"] then
        return
    end

    player.in_collision["lake_border"] = map_collision(new_actor_coords,0)
    if player.in_collision["lake_border"] then
        return
    end



    player.x = new_actor_coords.x
    player.y = new_actor_coords.y


end

function _actor_update_anim(actor, anim_key)
    if (actor.anim.curr_anim ~= anim_key) then
        actor.anim.curr_anim = anim_key
        actor.anim.curr_spr_index = 1
    end
end