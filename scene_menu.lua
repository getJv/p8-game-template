menu_select = {
    is_open = true
}
cursor = {
    spr = 16,
    pos = 1,
}

options = {
    {
        id = "potion",
        name = "potion",
        available = 3,
        cost = 50,
        sprite = 15
    },
    {
        id = "antidote",
        name = "antidote",
        available = 1,
        cost = 5,
        sprite = 15
    },
}

basket = {}

function scene_menu_init()
    _update = scene_menu_update
    _draw = scene_menu_draw

    --init actors
    actors_add_new("enemy_1", "bob")
    player_init()

    dialog_create(
            "initial_chat",
            [[
                enemy_1;hello there
                player;hey hey!
                player;what can i do for you?
            ]]
    )
end

function scene_menu_update()

    routines_manager_update()
    if (not menu_select.is_open) then
        player_controls_update()
    end

    local cursor_item = options[cursor.pos]

    if btnp(3) then -- up item
        cursor.pos = cursor.pos + 1
    end
    if btnp(2) then -- down item
        cursor.pos = cursor.pos - 1
    end
    if btnp(0) then -- left decrease
            del(basket,cursor_item)
    end
    if btnp(1) then -- right increase
        if amount_in_basket(cursor_item.id) < cursor_item.available then
            add(basket,options[cursor.pos])
        end
    end

    if btn(4) then
        dialog_start("initial_chat")
    end

end

function basket_total()
    local value = 0
    for i in all(basket) do
        value = value + i.cost
    end
    return value
end

function scene_menu_draw()
    cls()
    routines_manager_draw()
    --TODO: a new kind of ROUTINE_DRAW_Z1..9 will be need to filter routines to be drew over others... aka: routines_manager_draw_z1()
    debug_draw_rules()

    local box = {
        x = 20,
        y = 20,
        w = 88,
        h = 88,
        bg_color = 5,
        border_color = 6
    }
    local box_bottom_y =  box.y + box.h
    local box_right_x = box.x +box.w
    rectfill(box.x,box.y,box_right_x,box_bottom_y,box.bg_color)
    rect(box.x,box.y,box_right_x,box_bottom_y,box.border_color)
    local row_pos = {
        x = box.x + 2,
        y = box.y + 15
    }
    print("shopping",row_pos.x+2,box.y + 3,7)
    line(row_pos.x+2,box.y + 10,box_right_x-4,box.y + 10,7)
    for i,item in ipairs(options) do
        local text_color = 7
        if(i == cursor.pos) then
            spr(cursor.spr,row_pos.x,row_pos.y)
            text_color = 12
        end
        print("$" .. item.cost, row_pos.x + 10 ,row_pos.y,text_color) -- 10 is 8 for sprite + 2 of margin
        print(item.name, row_pos.x + 24 ,row_pos.y,text_color)

        print(amount_in_basket(item.id) .. "/" .. item.available, row_pos.x + 68 ,row_pos.y,text_color)
        row_pos.y = row_pos.y + 8
    end
    local total = "total: $" .. basket_total()
    print(total,box_right_x - 6 - #total * letter_width,row_pos.y + 4,7)

    line(row_pos.x+2,box_bottom_y-10,box_right_x-4,box_bottom_y-10,7)
    print("cancel",row_pos.x + 10,box_bottom_y-7,7)
    local confirm = "confirm"
    print(confirm,box_right_x - 10 - #confirm * letter_width,box_bottom_y-7,7)


end

--[[
amount_in_basket
    return the number of a current item in the basket
]]
function amount_in_basket(product_id)
    return #tbl_filter(basket,function(b)
        return product_id == b.id
    end)
end

