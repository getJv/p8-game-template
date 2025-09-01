--[[
dialog.lua
- contains the dialog register logic
- rely on routines system

dependencies:
 - routines.lua:routines_has_type_of

]]

ROUTINE_DIALOG = "dialog"
dialog_control = {
    message = "",
    message_width = 0, -- used to calculate the spot to show the X btn confirm animation
    current_index = 0,
    speaker = "",
    typing_speed = 5,
    should_draw = function() -- cb function to show the dialog box
        return not routines_has_type_of(ROUTINE_DIALOG)
    end,
    waiting_confirmation_to_continue = true -- trigger flag. player should press X to continue
}
dialog_text = {
    x = 4,
    y = 116,
    color = 7
}
box_offset = 3 -- padding left and top

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
    dialog_control.message_width = print(text,0,0,true)
    typing_speed = typing_speed or dialog_control.typing_speed

    while dialog_control.current_index < #text do
        dialog_control.current_index = dialog_control.current_index + 1
        dialog_control.message = sub(text, 1, dialog_control.current_index)

        -- waiting frames...
        for i = 1, typing_speed do
            yield()
        end
    end
    -- start the press X animation after a dialog box
    while dialog_control.waiting_confirmation_to_continue do
        _start_press_x_animation()
        yield()
    end
end

-- Render the X animation to let the player know which button press to continue
function _start_press_x_animation()
    local press_x_btn_anim = function()
        local show = true
        while dialog_control.waiting_confirmation_to_continue do
            -- waiting frames...
            if(show) then
                for i=1,10 do
                    print("❎", dialog_control.message_width + box_offset * 2,dialog_text.y)
                    yield()
                end
            end
            show = not show
            routines_wait(5)
        end
    end
    routines_add_new(function()
        press_x_btn_anim()
    end,
            ROUTINE_DRAW,
            "press_x_btn_anim"
    )
end

-- Should be called at the _update it will trigger the dialog to continue
function dialog_continue_update()
    if btn(5) then
        dialog_control.waiting_confirmation_to_continue = false
    end
end



--[[
dialog_draw
 - Should be called in the last position of the _draw section
 - the `skip` param if true will reset the dialog and stop drawing

usage example
```
function scene_menu_draw()
   cls()
   dialog_draw(not routines_has_type_of(ROUTINE_DIALOG))
end
```
]]
function dialog_draw()

    if(dialog_control.should_draw()) then
        _dialog_reset()
        return
    end

    local char_w_h = 8

    local box = {
        x = dialog_text.x - box_offset,
        y = dialog_text.y - box_offset,
        w = 120,
        h = char_w_h,
        bg_color = 5,
        border_color = 3
    }

    -- dialog box and frame for dialog
    rectfill(box.x, box.y, box.w, dialog_text.y + box.h, box.bg_color)
    rect(box.x, box.y, box.w, dialog_text.y + box.h, box.border_color)

    print(dialog_control.message, dialog_text.x, dialog_text.y, dialog_text.color)

    -- dialog box and frame for speaker
    local speaker_box_y_offset = 11
    local speaker_box_x_offset = 2
    local speaker_box = {
        x = dialog_text.x,
        y = dialog_text.y - speaker_box_y_offset,
        w = dialog_control.speaker.name_width + char_w_h - speaker_box_x_offset,
        h = dialog_text.y - speaker_box_y_offset + char_w_h
    }
    rectfill(speaker_box.x, speaker_box.y, speaker_box.w, speaker_box.h, box.border_color)
    print(dialog_control.speaker.name, speaker_box.x + speaker_box_x_offset, speaker_box.y + speaker_box_x_offset, dialog_text.color)

end

--[[
_dialog_reset
 - internal function
 - set the dialog_control to initial state
 - the optional `obj` param is the speaker of next dialog


]]
function _dialog_reset(obj)
    dialog_control.current_index = 0
    dialog_control.message = ""
    dialog_control.message_width = 0
    dialog_control.speaker = obj or ""
    dialog_control.waiting_confirmation_to_continue = true
end