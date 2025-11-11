package.path = package.path .. ";./?.lua;./vendor/?.lua;/app/vendor/?.lua"
require('tests/pico_mocks')
require('utils')
require('consts')

describe("consts.lua", function()
    it("builds CONST from string with proper types", function()
        assert.are.equal('4', CONST.letter_width)
        assert.are.equal('8', CONST.cell_size)
    end)
end)
