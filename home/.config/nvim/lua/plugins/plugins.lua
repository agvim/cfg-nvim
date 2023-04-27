return {

    -- ===============
    -- display related
    -- ===============

    -- colorscheme
    {
        "ishan9299/nvim-solarized-lua",
        config = function()
            vim.cmd([[
        " do not overwrite the foreground color for spell check marked text,
        augroup colorschemefix
        " Remove all group autocommands
        autocmd!
        " place it in the colorscheme autocommand to trigger it on background change also
        " using NONE to preserve the syntax color
        autocmd ColorScheme solarized highlight SpellBad ctermfg=NONE guifg=NONE
        autocmd ColorScheme solarized highlight SpellCap ctermfg=NONE guifg=NONE
        autocmd ColorScheme solarized highlight SpellLocal ctermfg=NONE guifg=NONE
        autocmd ColorScheme solarized highlight SpellRare ctermfg=NONE guifg=NONE
        augroup END
      ]])
        end,
    },
    {
        "LazyVim/LazyVim",
        opts = { colorscheme = "solarized" },
    },

    -- highlight colors
    {
        "norcalli/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup()
        end,
    },

    -- tune lazyvim indent display
    {
        "lukas-reineke/indent-blankline.nvim",
        opts = {
            indent_blankline_use_treesitter = true,
            show_trailing_blankline_indent = false,
            show_current_context = true,
        },
    },

    -- show the undo tree in an easier to use form
    {
        "mbbill/undotree",
        cmd = "UndotreeToggle",
        config = function()
            vim.cmd([[let g:undotree_SetFocusWhenToggle=1]])
        end,
        keys = { { "<leader>uu", "<cmd>UndotreeToggle<cr>", desc = "Toggle undo tree" } },
    },

    -- functions and symbols bar
    {
        "simrat39/symbols-outline.nvim",
        cmd = "SymbolsOutline",
        keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
        config = true,
    },

    -- =================
    -- behaviour related
    -- =================

    -- surround a selected block of text with xml support
    {
        "kylechui/nvim-surround",
        config = true,
    },
    -- disable the lazyvim surround
    { "echasnovski/mini.surround", enabled = false },

    -- xml tag closing
    { "sukima/xmledit" },

    -- eases sharing and following editor configuration conventions
    { "gpanders/editorconfig.nvim" },

    {
        "neovim/nvim-lspconfig",
        opts = {
            -- language servers for languages I'm using
            servers = {
                pyright = {},
                clangd = {},
                rust_analyzer = {},
                texlab = {},
            },
            -- disable autoformatting on save
            autoformat = false,
        },
    },
}
