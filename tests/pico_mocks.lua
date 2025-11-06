-- Pico-8 stubs used by utils.lua
function all(t)
    local i = 0
    return function()
        i = i + 1
        return t[i]
    end
end
function add(t, v)
    table.insert(t, v)
end
function sub(s, i, j)
    return string.sub(s, i, j)
end
function split(str, sep)
    sep = sep or ","
    local out = {}
    local pattern = string.format("[^%s]+", sep)
    for token in string.gmatch(str, pattern) do
        table.insert(out, token)
    end
    return out
end