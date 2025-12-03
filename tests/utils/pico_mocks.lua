-- Pico-8 stubs and helpers for tests
-- Drawing logs
_draw_calls = { rect={}, rectfill={}, line={}, spr={} }
_print_log = {}

-- array iterator
function all(t)
    local i = 0
    return function()
        i = i + 1
        return t[i]
    end
end
-- add element to list
function add(t, v)
    table.insert(t, v)
end
-- delete first occurrence from list (p8 del)
function del(t, v)
    for i=1,#t do
        if t[i] == v then
            table.remove(t, i)
            return
        end
    end
end
-- substring
function sub(s, i, j)
    return string.sub(s, i, j)
end
-- split by single char (approximate Pico-8 split)
function split(str, sep)
    sep = sep or ","
    local out = {}
    if str == nil then return out end
    local pattern = string.format("([^%s]+)", sep)
    for token in string.gmatch(str, pattern) do
        table.insert(out, token)
    end
    return out
end

-- math/random
function rnd(n)
    n = n or 1
    return 0 -- deterministic for tests
end

-- graphics mocks
function rect(x1,y1,x2,y2,c)
    table.insert(_draw_calls.rect, {x1=x1,y1=y1,x2=x2,y2=y2,c=c})
end
function rectfill(x1,y1,x2,y2,c)
    table.insert(_draw_calls.rectfill, {x1=x1,y1=y1,x2=x2,y2=y2,c=c})
end
function line(x1,y1,x2,y2,c)
    table.insert(_draw_calls.line, {x1=x1,y1=y1,x2=x2,y2=y2,c=c})
end
function spr(s,x,y,sw,sh)
    table.insert(_draw_calls.spr, {s=s,x=x,y=y,sw=sw,sh=sh})
end
function cls()
    _draw_calls = { rect={}, rectfill={}, line={}, spr={} }
    _print_log = {}
end
function print(val,x,y,c)
    table.insert(_print_log, {val=tostring(val),x=x,y=y,c=c})
end

-- stop simply marks a flag
_stopped = false
function stop()
    _stopped = true
end

-- input mocks
_btn_state = {}
_btnp_state = {}
function btn(i)
    return _btn_state[i] or false
end
function btnp(i)
    local pressed = _btnp_state[i] or false
    _btnp_state[i] = false -- consume
    return pressed
end
function _set_btn(i, v)
    _btn_state[i] = v and true or false
end
function _press_btnp(i)
    _btnp_state[i] = true
end

-- map/tile mocks
function mget(x,y)
    return 0
end
function fget(tile, flag)
    return false
end

