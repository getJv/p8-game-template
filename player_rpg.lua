player = {}

--[[
player_init
 - keep the player code in a same file
 - player is an actor
 - the anim tbl must be updated with proper spr numbers

deps
 - actors_add_new::actors.lua
]]
function player_init()
    player = actors_add_new(
            "ana banana",
            10,
            10,
            8,
            8,
            {
                curr_anim = "idle",
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
    if btn(1) and btn(3) then -- right down
        player.x += 1
        player.y += 1
        _actor_update_anim(player, "right")
    elseif btn(0) and btn(3) then -- left down
        player.x -= 1
        player.y += 1
        _actor_update_anim(player, "left")
    elseif btn(1) and btn(2) then -- right up
        player.x += 1
        player.y -= 1
        _actor_update_anim(player, "right")
    elseif btn(0) and btn(2) then -- left up
        player.x -= 1
        player.y -= 1
        _actor_update_anim(player, "left")
    elseif btn(0) then -- left
        player.x -= 1
        _actor_update_anim(player, "left")
    elseif btn(1) then -- right
        player.x += 1
        _actor_update_anim(player, "right")
    elseif btn(2) then -- up
        player.y -= 1
        _actor_update_anim(player, "up")
    elseif btn(3) then -- down
        player.y += 1
        _actor_update_anim(player, "down")
    elseif btn() == 0 then
        _actor_update_anim(player, "idle")
    end
end
function _actor_update_anim(actor, anim_key)
    if (actor.anim.curr_anim ~= anim_key) then
        actor.anim.curr_anim = anim_key
        actor.anim.curr_spr_index = 1
    end
end