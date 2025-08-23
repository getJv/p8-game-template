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
    current_index = 0,
    speaker = "",
    typing_speed = 5,
    should_draw = function () return not routines_has_type_of(ROUTINE_DIALOG) end
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
function dialog_add(obj,text,typing_speed)
    _dialog_reset(obj)
    typing_speed = typing_speed or dialog_control.typing_speed

    while dialog_control.current_index < #text do
        dialog_control.current_index = dialog_control.current_index + 1
        dialog_control.message = sub(text, 1, dialog_control.current_index)

        -- waiting frames...
        for i = 1, typing_speed do
            yield()
        end
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
    local text = {
    x = 4,
    y = 116,
    color = 7
    }
    local box_offset = 3
    local box = {
    x = text.x - box_offset,
    y = text.y - box_offset,
    w = 120,
    h = char_w_h,
    bg_color =5,
    border_color=3
    }

    -- dialog box and frame for dialog
    rectfill(box.x ,box.y,box.w,text.y + box.h,box.bg_color)
    rect(box.x,box.y,box.w,text.y + box.h,box.border_color)
    print(dialog_control.message,text.x,text.y,text.color)

    -- dialog box and frame for speaker
    local speaker_box_y_offset = 11
    local speaker_box_x_offset = 2
    local speaker_box = {
    x = text.x ,
    y = text.y - speaker_box_y_offset,
    w = dialog_control.speaker.name_width + char_w_h - speaker_box_x_offset,
    h = text.y - speaker_box_y_offset + char_w_h
    }
    rectfill(speaker_box.x ,speaker_box.y,speaker_box.w,speaker_box.h,box.border_color)
    print(dialog_control.speaker.name,speaker_box.x + speaker_box_x_offset ,speaker_box.y + speaker_box_x_offset,text.color)

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
    dialog_control.speaker = obj or ""
end