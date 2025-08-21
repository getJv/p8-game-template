ROUTINE_DIALOG = "dialog"
routines = {}
dialog_control = {
    message = "",
    current_index = 0,
    speaker = "",
}

-- Call this in the _update function to update eat routine in the table
function update_routines_manager()
    for r in all(routines) do
        if costatus(r.routine) == "dead" then
            del(routines,r)
        else
            assert(coresume(r.routine))
        end
    end

end

-- add new routine to routines table
--[[
 Sample of usage:
 local full_animation = function()
       update_animation(player,"x",80) -- go right
       wait(10)
       update_animation(player,"x",96,30,ease_in_elastic) -- go right
       wait(30)
       update_animation(player,"y",32) -- go top
 end
 add_new_routine(full_animation)
]]
function add_new_routine(new_func,type)
    local co_item = {
        type = type,
        routine = cocreate(new_func)
    }
    add(routines,co_item)
end

function add_box(obj,text,typing_speed)
    dialog_control.current_index = 0
    dialog_control.message = ""
    dialog_control.speaker = obj
    typing_speed = typing_speed or 5

    while dialog_control.current_index < #text do
        dialog_control.current_index = dialog_control.current_index + 1
        dialog_control.message = sub(text, 1, dialog_control.current_index)

        -- waiting frames...
        for i = 1, typing_speed do
            yield()
        end
    end

end

function wait(frames)
    for i=1,frames do
        yield()
    end
end

function draw_dialog_box()
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
       w = dialog_control.speaker.name_w + char_w_h - speaker_box_x_offset,
       h = text.y - speaker_box_y_offset + char_w_h
   }
   rectfill(speaker_box.x ,speaker_box.y,speaker_box.w,speaker_box.h,box.border_color)
   print(dialog_control.speaker.name,speaker_box.x + speaker_box_x_offset ,speaker_box.y + speaker_box_x_offset,text.color)

end