
-- draw border and middle lines in the screen
function debug_draw_rules()
    rect(0, 0, 127, 127, 11)
    line(64, 0, 64, 127, 11)
    line(0, 64, 127, 64, 11)
end

-- Show line in all obj corners
function debug_obj_lines(obj,color)
    --left vertical
    line(obj.x, 0, obj.x, 127, color)
    --right vertical
    line(obj.x + obj.w, 0, obj.x + obj.w, 127, color)

    --top horizontal
    line(0 ,obj.y , 127, obj.y, color)
    --bottom horizontal
    line(0 ,obj.y + obj.h , 127, obj.y + obj.h, color)
end