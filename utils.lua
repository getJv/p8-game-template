

function edges_collision(new_x,new_y,obj_w,obj_h)
    if new_x + obj_w > 127
            or new_x < 0
            or new_y < 0
            or new_y + obj_h > 127
    then
        return true
    end

    return false


end