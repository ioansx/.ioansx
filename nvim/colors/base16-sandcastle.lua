local palette = {
    base00 = "#282C34",
    base01 = "#2C323B",
    base02 = "#3E4451",
    base03 = "#857064",
    base04 = "#928374",
    base05 = "#DFCDB3", -- was #A89984
    base06 = "#F0EAD8", -- was #D5C4A1
    base07 = "#FFF7E6", -- was #FDF4C1

    base08 = "#83A598",
    base09 = "#A07E3B",
    base0A = "#A07E3B",
    base0B = "#528B8B",
    base0C = "#83A598",
    base0D = "#83A598",
    base0E = "#D75F5F",
    base0F = "#A87322",
}

require("mini.base16").setup({ palette = palette })

-- vim.api.nvim_set_hl(0, "Normal", { fg = palette.base05, bg = palette.base00 })
-- vim.api.nvim_set_hl(0, "NormalFloat", { fg = palette.base05, bg = palette.base01 })
-- emphasize function/identifiers a touch to improve legibility in code
vim.api.nvim_set_hl(0, "Function", { fg = palette.base0D, bold = true })
vim.api.nvim_set_hl(0, "Identifier", { fg = palette.base0B, bold = true })
