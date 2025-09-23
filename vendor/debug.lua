--[[
    File: debug.lua
    Token usage: 92
    Debug helpers for drawing guides and printing quick values.
]]

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
--[[
    clean the screen and print a string value then stop the game
]]
function debug_dd(value,should_stop,x,y)
    cls()
    x = x or 5
    y = x or 5
    should_stop = should_stop or true
    print("debug:",2,0,7)
    if type(value) == "table" then
        local currentY = y + 5
        currentY = currentY + 8
        for k, v in pairs(value) do
            print(tostring(k) .. ": " .. tostring(v), x, currentY, 7)
            currentY = currentY + 8
        end
    else
        print(value, x, y + 5, 7)
    end
    if(should_stop) then
        stop()
    end
end

