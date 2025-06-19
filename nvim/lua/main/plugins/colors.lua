return {
    {
        "sainnhe/gruvbox-material",
        lazy = false,
        priority = 1000,
        config = function()
            vim.g.gruvbox_material_transparent_background = 1
            vim.g.gruvbox_material_enable_bold = 1
            vim.g.gruvbox_material_background = "soft"
            vim.g.gruvbox_material_palette = "mix"
            vim.g.gruvbox_material_enable_italic = true
            vim.cmd.colorscheme("gruvbox-material")
        end,
    },
    -- {
    --     'kepano/flexoki-neovim',
    --     name = 'flexoki',
    --     lazy = false,
    --     priority = 1000,
    --     config = function()
    --         vim.cmd [[colorscheme flexoki-dark]]
    --     end
    -- },
    -- {
    --     "rebelot/kanagawa.nvim",
    --     config = function()
    --         require('kanagawa').setup({
    --
    --             compile = false,
    --             undercurl = true,
    --             commentStyle = { italic = true },
    --             functionStyle = {},
    --             keywordStyle = { italic = true },
    --             statementStyle = { bold = true },
    --             typeStyle = {},
    --             transparent = true,
    --             dimInactive = false,
    --             terminalColors = true,
    --             colors = {
    --                 palette = {},
    --                 theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
    --             },
    --             overrides = function(colors) -- add/modify highlights
    --                 return {}
    --             end,
    --             theme = "lotus",
    --         })
    --         vim.cmd("colorscheme kanagawa")
    --     end
    -- }
}
