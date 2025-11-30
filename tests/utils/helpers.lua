--- Prints a labeled message to stderr.
---
--- This function is intended for debugging. It writes a title and a value
--- to the standard error stream, ensuring the output is always shown even
--- when test frameworks suppress normal prints.
---
--- @param title string
---        A short label that describes the content being printed.
---
--- @param content any
---        The value to print. It will be converted to a string via
---        concatenation, so it should be a type that supports `..`
---        or be safely convertible with `tostring()`.
---
--- @return nil
---        This function does not return anything.
---
--- @example
--- local value = 42
--- d_print("Debug value", value)
--- -- Output (stderr):
--- -- Debug value: 42
function d_print(content,title)
    title = (title and tostring(title) .. ": \n") or ""
    io.stderr:write(title , content)
    io.stderr:write("\n")
end


--- Converts a Lua table into a formatted, human-readable string.
--- Useful for debugging nested tables by printing their structure with indentation.
---
--- The output is similar to a JSON object, but follows Lua table notation.
---
--- @param o any
---        The value to be converted. If it's not a table, it will be converted
---        to a string using `tostring()`.
---
--- @param indent number|nil
---        Optional. The current indentation level in spaces.
---        Default is 0. This is mainly used internally for recursive calls.
---
--- @return string
---        Returns a formatted string representation of the value or table.
---        If `o` is not a table, the return value is just `tostring(o)`.
---
--- @example
--- local t = {
---     name = "dialog",
---     settings = {
---         speed = 2,
---         auto = false
---     }
--- }
--- print(d_tbl_str(t))
function d_tbl_str(o, indent)
    indent = indent or 0

    if type(o) ~= "table" then
        return tostring(o)
    end

    local s = "{\n"

    for k, v in pairs(o) do
        s = s .. string.rep(" ", indent + 2)
        s = s .. tostring(k) .. " = " .. d_tbl_str(v, indent + 2) .. ",\n"
    end

    s = s .. string.rep(" ", indent) .. "}"
    return s
end

--- Converts a Lua table into a compact, single-line string representation.
---
--- This function is intended for debugging and testing purposes, especially
--- when you want to compare tables as strings without worrying about
--- indentation or line breaks.
---
--- The output resembles a Lua table, but is all on a single line:
--- e.g. `{items={},current=0,}`.
---
--- @param o any
---        The value to be converted. If it is not a table, it will be converted
---        to a string using `tostring()`.
---
--- @return string
---        Returns a compact string representation of the table or value.
---
--- @example
--- local t = { current = 0, items = {} }
--- local s = d_tbl_str_compact(t)
--- print(s)  -- Output: {items={},current=0,}
function d_tbl_str_compact(o)
    if type(o) ~= "table" then
        return tostring(o)
    end

    local s = "{"
    for k, v in pairs(o) do
        s = s .. tostring(k) .. "=" .. d_tbl_str_compact(v) .. ","
    end
    s = s .. "}"
    return s
end
