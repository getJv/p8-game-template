--[[
dialog.lua
- contains the dialog register logic
- rely on routines system
dependencies:
 - routines.lua
]]

-- store the group of dialogs
dialogs = {
    current = 0,
    items = {}
}
-- dialog_control function settings controls the current dialog
dialog_control = {
    message = "",
    current_index = 0,
    typing_speed = 2,
    waiting_confirmation_to_continue = true -- trigger flag. player should press X to continue
}
-- _dialog_frame function settings. controls the dialog box layout
dialog_frame_obj = {
    x = 4, -- left dialog box
    y = 113, -- top dialog box
    w = 119, -- right dialog box
    h = 10, -- bottom dialog box
    box_bg_color = 5, -- grey
    box_border_color = 3, -- dark green
    box_txt_color = 7, -- white
    box_p_top = 3, -- padding top
    box_p_left = 3, -- padding left
    tab_name_h = 8, -- how tall is the dialog box
    tab_m_left = 4 -- margin left
}

--[[
dialog_create
 - add a group os speeches to the collection
 - the short version use way fewer tokens
 - the parameters orders are actor_id,messag;type_speed
 - the type_speed is optional, will use the default value from dialog_control if omitted
 - the actor_id is crucial to create the dialog

 ``` short version
   local e1 = add_new_enemy("enemy_1","bob")
   local player = add_new_enemy("player","ana banana")
    dialog_create(
            "initial_chat",
            [[
                enemy_1;hello there
                player;hey hey!;5
                player;what can i do for you?
            ]/] -- ignore this scape bar... it need to not deactivate the comments... :/

  ```
``` long version
   local e1 = add_new_enemy("bob")
   local player = add_new_enemy("ana banana")
   dialog_create(
            "initial_chat",
            function()
                dialog_speech(e1, "hello there?")
                dialog_speech(player, "hey hey!")
                dialog_speech(player, "what can i do for you?")
            end
    )
```
]]
function dialog_create(dialog_id, speeches)
    add(dialogs.items, {
        id = dialog_id,
        cb_with_speeches = _dialog_parse_from_tbl_text_to_cb(speeches)
    })
end

--[[
dialog_start
 - queue the dialog group to routines tbl, if the dialog_id exist

]]
function dialog_start(dialog_id)
    if dialogs.current == 0 then
        local items = tbl_filter(dialogs.items, function(i)
            return i.id == dialog_id
        end)
        dialogs.current = dialog_id
        routines_add_new(
                items[1].cb_with_speeches,
                ROUTINE_DRAW,
                dialog_id
        )
    end
end

--[[
dialog_speech
 - add a speech to a actor
 - typing_speed is how fast the text is written in the screen. Higher the num, slower will be

 ```
   local e1 = add_new_enemy("bob")
   local player = add_new_enemy("ana banana")
   dialog_create(
            "initial_chat",
            function()
                dialog_speech(e1, "hello there?")
                dialog_speech(player, "hey hey!")
                dialog_speech(player, "what can i do for you?")
            end
    )
```
]]
function dialog_speech(obj, text, typing_speed)
    _dialog_reset(obj)
    typing_speed = typing_speed or dialog_control.typing_speed
    local print_x_btn = true -- control the toggle animation to the button x

    while dialog_control.current_index < #text do
        dialog_control.current_index = dialog_control.current_index + 1
        dialog_control.message = sub(text, 1, dialog_control.current_index)
        -- waiting frames to print next dialog character
        routines_wait(typing_speed, function()
            _dialog_frame(dialog_control.message, obj.name)
        end)
    end

    -- starts waiting for the user press X to continue the dialog
    while dialog_control.waiting_confirmation_to_continue do
        if (print_x_btn) then
            -- prints the message with the btn_x for 10 frames
            routines_wait(10, function()
                _dialog_frame(dialog_control.message, obj.name)
                print(
                        "❎",
                        #dialog_control.message * letter_width + 8, -- 2 is the text margin right
                        dialog_frame_obj.y + dialog_frame_obj.box_p_top
                )
                _dialog_check_if_user_pressed_x_to_continue()
            end)
        end
        print_x_btn = not print_x_btn
        routines_wait(5, function()
            -- prints the message without the btn_x for 5 frames
            _dialog_frame(dialog_control.message, obj.name)
            _dialog_check_if_user_pressed_x_to_continue()
        end)
    end

    dialogs.current = 0 -- no ongoing dialog
end



--[[
    internal parser from tbl text to dialog group callback
]]
function _dialog_parse_from_tbl_text_to_cb(dialog_string)
    local dialog_parts = {}
    -- break in lines
    for line in all(split(dialog_string, '\n')) do
        if line ~= "" then
            -- extract the parameters
            local parts = split(line, ';')
            if #parts > 1 then -- check minimal number of params
                local actor = tbl_filter(actors,function(i)
                    return i.id == str_trim(parts[1])
                end)

                add(dialog_parts,{
                    actor[1], --parts[1], -- actor name,
                    parts[2], -- dialog text
                    parts[3] or dialog_control.typing_speed
                })
            end
        end
    end

    return function()
        for i in all(dialog_parts) do
            dialog_speech(i[1],i[2])
        end
    end

end

function _dialog_check_if_user_pressed_x_to_continue()
    if btn(5) then
        -- 5 is the btn 5
        dialog_control.waiting_confirmation_to_continue = false
    end
end
--[[
_dialog_frame
 - internal function
 - draw the dialog box, tab name and dialog text
]]
function _dialog_frame(new_txt, speaker_name)
    -- dialog box and border frame for dialog
    rectfill(dialog_frame_obj.x, dialog_frame_obj.y, dialog_frame_obj.x + dialog_frame_obj.w, dialog_frame_obj.y + dialog_frame_obj.h, dialog_frame_obj.box_bg_color)
    rect(dialog_frame_obj.x, dialog_frame_obj.y, dialog_frame_obj.x + dialog_frame_obj.w, dialog_frame_obj.y + dialog_frame_obj.h, dialog_frame_obj.box_border_color)
    -- print the message inside the box
    print(new_txt, dialog_frame_obj.x + dialog_frame_obj.box_p_left, dialog_frame_obj.y + dialog_frame_obj.box_p_top, dialog_frame_obj.box_txt_color)
    -- dialog box and frame for speaker
    local name_tab = {
        x = dialog_frame_obj.x + dialog_frame_obj.tab_m_left,
        y = dialog_frame_obj.y - dialog_frame_obj.tab_name_h,
    }
    rectfill(
            name_tab.x,
            name_tab.y,
            name_tab.x + (#speaker_name * letter_width) + 4, -- 4 is the padding x
            name_tab.y + dialog_frame_obj.tab_name_h,
            dialog_frame_obj.box_border_color
    )
    print(
            speaker_name,
            name_tab.x + 3,
            name_tab.y + 2,
            dialog_frame_obj.box_txt_color
    )

end
--[[
_dialog_reset
 - internal function
 - set the dialog_control to initial state
]]
function _dialog_reset()
    dialog_control.current_index = 0
    dialog_control.message = ""
    dialog_control.waiting_confirmation_to_continue = true
end