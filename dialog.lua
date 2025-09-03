--[[
dialog.lua
- contains the dialog register logic
- rely on routines system
dependencies:
 - routines.lua
]]

-- dialog_control function settings controls the dialog pace
dialog_control = {
    message = "",
    current_index = 0,
    typing_speed = 3,
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
dialog_add
 - register a speech to a speaker
 - Allow set a custom type_speed

usage sample:
 - better usage in the _init or preload
 ```
   local e1 = add_new_enemy("bob")
   local e2 = add_new_enemy("ana banana")
   local dialog_anim = function()
      dialog_add(e1,"hello there?")
      wait(8)
      dialog_add(e2,"hey hey!")
      wait(3)
      dialog_add(e2,"what can i do for you?")
      wait(8)
   end
   add_new_routine(dialog_anim,ROUTINE_DIALOG)
```
]]
function dialog_add(obj, text, typing_speed)
    _dialog_reset(obj)
    typing_speed = typing_speed or dialog_control.typing_speed

    local print_x_btn = true -- control the toggle animation to the button x

    while dialog_control.current_index < #text do
        dialog_control.current_index = dialog_control.current_index + 1
        dialog_control.message = sub(text, 1, dialog_control.current_index)
        -- waiting frames to print next dialog character
        routines_wait(typing_speed,function()
            _dialog_frame(dialog_control.message,obj.name)
        end)
    end

    -- starts waiting for the user press X to continue the dialog
    while dialog_control.waiting_confirmation_to_continue do
        if(print_x_btn) then -- prints the message with the btn_x for 10 frames
            routines_wait(10,function()
                _dialog_frame(dialog_control.message,obj.name)
                print(
                        "❎",
                        #dialog_control.message * letter_width + 8, -- 2 is the text margin right
                        dialog_frame_obj.y + dialog_frame_obj.box_p_top
                )
                _dialog_check_if_user_pressed_x_to_continue()
            end)
        end
        print_x_btn = not print_x_btn
        routines_wait(5,function() -- prints the message without the btn_x for 5 frames
            _dialog_frame(dialog_control.message,obj.name)
            _dialog_check_if_user_pressed_x_to_continue()
        end)
    end
end

function _dialog_check_if_user_pressed_x_to_continue()
    if btn(5) then -- 5 is the btn 5
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
    print(new_txt, dialog_frame_obj.x + dialog_frame_obj.box_p_left, dialog_frame_obj.y+ dialog_frame_obj.box_p_top, dialog_frame_obj.box_txt_color)
    -- dialog box and frame for speaker
    local name_tab = {
        x =  dialog_frame_obj.x + dialog_frame_obj.tab_m_left,
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