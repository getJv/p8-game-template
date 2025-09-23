## Important rules

1. This is a personal project public available for community usage DO NOT use proprietary code or assets in your solutions.
2. All the source code, code comments and documentation you write/generate should be in English. 
3. Answers to prompt questions or give prompt explanations in the same language the question is asked.

## Pico-8 token usage and rules for counting tokens

 - Use the following rules to count the number of tokens in your code:

1. This is how the pico-8 token usage is calculated:
   - A literal value, such as nil, false, true, any number (e.g. 123, 0xff.ff, -3, ~1e4), or any string (of any size).
   - A variable or operator
   - An opening bracket ('(', '[', '{')
   - A keyword, with the exception of end and local
2. token usage is calculated, In particular, the following are not counted as tokens:
   - The comma (,), semicolon (;), period (.), colon (:), and double-colon (::)
   - Closing brackets (')', ']', '}')
   - The end and local keywords
   - the unary minus (-) and complement (~) operators when applied on a numeric literal

## Files and functions documentation rules

1. The docs in the file header must follow the following format:
```lua
--[[
    File: {file_name}
    Token usage: {num_of_tokens_present_in_the_file}
    {An introduction about what is the objective of the file}
]] 
```
2. The docs form methods should follow the template:
```lua
--[[
    {Nome do metodo}
    - {list of features}

Sample of usage:

```lua
local full_animation = function()
    update_animation(player,"x",80) -- go right
    wait(10)
    update_animation(player,"x",96,30,ease_in_elastic) -- go right
    wait(30)
    update_animation(player,"y",32) -- go top
end

routines_add_new(full_animation,ROUTINE_XYZ,"any_uniq_id")
]]
```
3. If documentation already exists for the new or changed method, the docs must be updated.
4. Always the token amount of each file changes, the token amount of int the README.md file must be updated and show the total of tokens of the vendor folder files. 
5. use a scape character always a multistring happening inside a comment block. Example:
   ```lua
   --[[ Comment block...
        [[ some-info ]\] -- Note the \ is scape the character and keping the comment block active
   ]]
   ```



