# PICO-8 Game Template

This repository is a simple template based on my PICO-8 studies. The idea is to consolidate utilities and base logic to facilitate bootstrapping a new game (studies, prototypes, and game jams).

The resources here gather and encapsulate references from the [PICO-8 CheatSheet][cheatsheet] and from fan sites, forums, and YouTube channels of the PICO-8 community.

## Project Purpose (hobby/study)

- This is a personal and hobby project, created for educational purposes.
- There is no commercial purpose.
- There is no intention to infringe copyrights or trademarks. All names, brands, and materials mentioned belong to their respective owners.
- If you are a rights holder and identify any issues, please open an issue so I can promptly adjust/remove the content.

## Token usage:

These scripts area helpful but them will cost you tokens.
**Total tokens used (vendor folder): 1477**

Remember two things:
1. This is a usage estimative
2. You don't need all then vendor scripts in your project, delete them.


## AI Usage

The use of AI tools in this project is limited to:

1. Improvements in code quality and readability.
2. Assistance with more complex mathematics related to game logic.
3. Documentation and text revision.
4. Token counting/optimization.

## Credits, references and mentions

1. Helper routines and `tbl_from_str` inspired by [Kevin's video][kevin-video].
2. Various ideas and inspirations from the [Nerdy Teachers website][nerdy-website].
3. Token counting/optimization inspired by [a forum post][saving-tokens]

## Development

### Dependencies

Setting lua maybe  not be easy... these are the steps i used:

1. sudo apt update
2. sudo apt install lua5.1 luarocks
3. sudo luarocks --lua-version=5.1 install busted
4. sudo luarocks --lua-version=5.1 install luacov
5. sudo luarocks --lua-version=5.1 install luacov-console

and now to run tests use: 
```bash
busted tests -c && luacov-console && luacov-console -s
```

or for a single file:

```bash
busted --verbose tests/utils_spec.lua
```


#### troubleshotting:

**busted not installing**
in the step 5 busted was refusing to install. So I created a symlink:    `sudo ln -sf /usr/bin/luarocks /usr/local/bin/luarocks` it solved.

**busted not running dua mismatch lua version** 
after installing I tried the `busted tests` and got this error: 
`/home/<my-user>/.luarocks/bin/busted: 3: exec: /usr/bin/lua5.4: not found` 
for some reason busted is waiting for 5.4 and no 5.1
so I edit the `nano /home/jhonatan/.luarocks/bin/busted`
and update the `LUAROCKS_SYSCONFDIR` from this: `/usr/bin/lua5.4` to this: `/usr/bin/lua`   


## License

This project is licensed under the terms of the MIT license. See the [LICENSE](LICENSE) file for more details.

[cheatsheet]: https://www.lexaloffle.com/bbs/files/16585/PICO-8_CheatSheet_0111Gm_4k.png
[kevin-video]: https://www.youtube.com/watch?v=tfGmjB72t0o&t
[nerdy-website]: https://nerdyteachers.com/
[saving-tokens]:https://pico-8.fandom.com/wiki/Tokens