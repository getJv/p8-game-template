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

    local new_x = player.x
    local new_y = player.y

    if btn(1) and btn(3) then -- right down
        new_x += 1
        new_y += 1
        _actor_update_anim(player, "right")
    elseif btn(0) and btn(3) then -- left down
        new_x -= 1
        new_y += 1
        _actor_update_anim(player, "left")
    elseif btn(1) and btn(2) then -- right up
        new_x += 1
        new_y -= 1
        _actor_update_anim(player, "right")
    elseif btn(0) and btn(2) then -- left up
        new_x -= 1
        new_y -= 1
        _actor_update_anim(player, "left")
    elseif btn(0) then -- left
        new_x -= 1
        _actor_update_anim(player, "left")
    elseif btn(1) then -- right
        new_x += 1
        _actor_update_anim(player, "right")
    elseif btn(2) then -- up
        new_y -= 1
        _actor_update_anim(player, "up")
    elseif btn(3) then -- down
        new_y += 1
        _actor_update_anim(player, "down")
    elseif btn() == 0 then
        _actor_update_anim(player, "idle")
    end

    if edges_collision(new_x,new_y,player.w,player.h) then
       return
    end

    player.x = new_x
    player.y = new_y

end




function _actor_update_anim(actor, anim_key)
    if (actor.anim.curr_anim ~= anim_key) then
        actor.anim.curr_anim = anim_key
        actor.anim.curr_spr_index = 1
    end
end