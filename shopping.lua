shopping = {
    is_open = false,
    cursor = {
        spr = 16,
        pos = 1,
    }

}

basket = {}

function shopping_open()
    local shopping_cb = function()
        shopping_routine_drawing(
                {
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
        )
    end

    routines_add_new(
            shopping_cb,
            ROUTINE_DRAW,
            'shopping_id'
    )
end


function basket_total()
    local value = 0
    for i in all(basket) do
        value = value + i.cost
    end
    return value
end

function shopping_cursor_routine_update(options)

    while shopping.is_open do
        local cursor_item = options[shopping.cursor.pos]
        if btnp(3) then -- down item
            if shopping.cursor.pos < #options then
                shopping.cursor.pos = shopping.cursor.pos + 1
            else
                shopping.cursor.pos = #options + 1 -- is cancelAction
            end

        end
        if btnp(2) then -- up item
            if shopping.cursor.pos > 1 then
                shopping.cursor.pos = shopping.cursor.pos - 1
            else
                shopping.cursor.pos = #options + 1 -- is cancelAction
            end
        end
        if btnp(0) then -- left decrease
            if shopping.cursor.pos > #options then
                shopping.cursor.pos =  #options + 1
            else
                del(basket,cursor_item)
            end


        end
        if btnp(1) then -- right increase
            if shopping.cursor.pos > #options then
                shopping.cursor.pos =  #options + 2
            else
                if amount_in_basket(cursor_item.id) < cursor_item.available then
                    add(basket,options[shopping.cursor.pos])
                end
            end
        end
        if #options + 2 == shopping.cursor.pos and btnp(5) then
            shopping.is_open = false
        end
        yield()
    end
end

function shopping_routine_drawing(options)

    shopping.is_open = true
    routines_add_new(
            function() shopping_cursor_routine_update(options)  end,
            ROUTINE_UPDATE,
            'shopping_update_id'
    )
    while shopping.is_open do
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
            if(i == shopping.cursor.pos) then
                spr(shopping.cursor.spr,row_pos.x,row_pos.y)
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
        if shopping.cursor.pos == (#options + 1) then -- is cancel option
            spr(shopping.cursor.spr,row_pos.x,box_bottom_y-7)
            print("cancel",row_pos.x + 10,box_bottom_y-7,12)
        else
            print("cancel",row_pos.x + 10,box_bottom_y-7,7)
        end

        local confirm = "confirm"
        if shopping.cursor.pos == (#options + 2) then -- is confirm option
            spr(shopping.cursor.spr,box_right_x - 20 - #confirm * letter_width ,box_bottom_y-7)
            print(confirm,box_right_x - 10 - #confirm * letter_width,box_bottom_y-7,12)
        else
            print(confirm,box_right_x - 10 - #confirm * letter_width,box_bottom_y-7,7)
        end

        yield()
    end

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