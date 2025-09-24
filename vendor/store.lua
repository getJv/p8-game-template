--[[
    File: store.lua
    Token usage: 318
    Simple in-game store UI and logic: open/close, navigation, basket handling, drawing and update
    routines. Uses a string-to-table parser for configuration.
]]

store_initial_values = [[
            is_open=false;cursor_spr=16;cursor_pos=1
        ]]

store = tbl_from_string(store_initial_values,true)

basket = {}
stores = {}
store_box = tbl_from_string([[
            x=20;y=20;w=88;h=88;bg_color=5;border_color=6;title=shopping;text_color=7;selected_color=12
        ]])[1]

--[[ store_create
 - Register the store in a list of stores and prepare the routine callback

Sample of usage:

```lua
store_create("potion_shop", [[
    id=potion;name=potion;available=3;cost=50;spr=15
    id=antidote;name=antidote;available=5;cost=5;spr=15
    ]\])
```
]]
function store_create(store_id, tbl_string_options)
    stores[store_id] = function()
        store_routine_draw(
                tbl_from_string(tbl_string_options)
        )
    end
end

function store_close(confirmed)
    if confirmed then
        print("check out not implemented")
    end
    basket = {}
    store.is_open = false
end

function store_open(store_id)
    routines_add_new(
            stores[store_id],
            ROUTINE_DRAW,
            'shopping_id'
    )
end

--[[
shopping_routine_update
    open the store with the given option
example:
```
routines_add_new(
            function()
                shopping_routine_draw(
                        [[
                        id=potion;name=potion;available=3;cost=50;sprite=15
                        id=antidote;name=antidote;available=5;cost=5;sprite=15
                        ]\]
                )
                end,
                ROUTINE_DRAW,
                'shopping_id'
)

```

]]
function store_routine_update(options)

    local total_items = #options
    local current_cursor_pos = store.cursor_pos
    local cursor_item = 1
    while store.is_open do
        if current_cursor_pos <= total_items then -- prevent nil error if cancel(total_items +1) or confirm (total_items+2) is select
            cursor_item = options[current_cursor_pos]
        end
        if btnp(3) then
            -- down item
            if current_cursor_pos < total_items then
                current_cursor_pos = current_cursor_pos + 1
            else
                current_cursor_pos = total_items + 1 -- is cancelAction
            end

        end
        if btnp(2) then
            -- up item
            if current_cursor_pos > 1 then
                current_cursor_pos = current_cursor_pos - 1
            else
                current_cursor_pos = total_items + 1 -- is cancelAction
            end
        end
        if btnp(0) then
            -- left decrease
            if current_cursor_pos > total_items then
                current_cursor_pos = total_items + 1
            else
                del(basket, cursor_item)
            end


        end
        if btnp(1) then
            -- right increase
            if current_cursor_pos > total_items then
                current_cursor_pos = total_items + 2
            else
                if store_amount_in_basket(cursor_item.id) < cursor_item.available then
                    add(basket, options[current_cursor_pos])
                end
            end
        end
        if total_items + 2 == current_cursor_pos and btnp(5) then
            store_close()
        end
        store.cursor_pos = current_cursor_pos
        yield()
    end
end

function store_routine_draw(options)

    store.cursor_pos = 1
    store.is_open = true
    routines_add_new(
            function()
                store_routine_update(options)
            end,
            ROUTINE_UPDATE,
            'shopping_update_id'
    )
    while store.is_open do


        local box_bottom_y = store_box.y + store_box.h
        local box_right_x = store_box.x + store_box.w
        local get_text_color = function(selected)
            if selected then
                return store_box.selected_color
            else
                return store_box.text_color
            end
        end
        rectfill(store_box.x, store_box.y, box_right_x, box_bottom_y, store_box.bg_color)
        rect(store_box.x, store_box.y, box_right_x, box_bottom_y, store_box.border_color)
        local row_pos = {
            x = store_box.x + 2,
            y = store_box.y + 15
        }
        print(store_box.title, row_pos.x + 2, store_box.y + 3, 7)
        line(row_pos.x + 2, store_box.y + 10, box_right_x - 4, store_box.y + 10, 7)
        for i, item in ipairs(options) do
            local selected = i == store.cursor_pos
            if (selected) then
                spr(store.cursor_spr, row_pos.x, row_pos.y)
            end
            spr(item.spr, row_pos.x + 9, row_pos.y-2)
            print(item.name, row_pos.x + 19, row_pos.y, get_text_color(selected))
            print("$" .. item.cost, row_pos.x + 55, row_pos.y, get_text_color(selected)) -- 10 is 8 for sprite + 2 of margin

            print(store_amount_in_basket(item.id) .. "/" .. item.available, row_pos.x + 68, row_pos.y, get_text_color())
            row_pos.y = row_pos.y + 8
        end
        local total = "total: $" .. _store_basket_total()
        print(total, box_right_x - 6 - #total * CONST.letter_width, row_pos.y + 4, get_text_color())
        line(row_pos.x + 2, box_bottom_y - 10, box_right_x - 4, box_bottom_y - 10, get_text_color())

        local cancel_is_selected = store.cursor_pos == (#options + 1)
        if cancel_is_selected then -- is cancel option
            spr(store.cursor_spr, row_pos.x, box_bottom_y - 7)
        end
        print("cancel", row_pos.x + 10, box_bottom_y - 7, get_text_color(cancel_is_selected))

        local confirm = "confirm"
        local confirm_selected = store.cursor_pos == (#options + 2)
        if confirm_selected then -- is confirm option
            spr(store.cursor_spr, box_right_x - 20 - #confirm * CONST.letter_width, box_bottom_y - 7)
        end
        print(confirm, box_right_x - 10 - #confirm * CONST.letter_width, box_bottom_y - 7, get_text_color(confirm_selected))

        yield()
    end
end

function _store_basket_total()
    local value = 0
    for i in all(basket) do
        value = value + i.cost
    end
    return value
end

--[[
amount_in_basket
    return the number of a current item in the basket
]]
function store_amount_in_basket(product_id)
    return #tbl_filter(basket, function(b)
        return product_id == b.id
    end)
end