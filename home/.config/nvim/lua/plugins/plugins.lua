return {

    -- ===============
    -- display related
    -- ===============

    -- colorscheme
    {
        "ishan9299/nvim-solarized-lua",
        config = function()
            -- customize the colorscheme in an autocmd so when it is reloaded it is applied
            vim.api.nvim_create_autocmd("Colorscheme", {
                pattern = "solarized",
                group = vim.api.nvim_create_augroup("colorschemefix", { clear = true }),
                -- do not overwrite the foreground collor for spell check marked text
                -- using vim.cmd.highlight since nvim_set_hl requires a full definition
                callback = function()
                    vim.cmd.highlight("SpellBad", "ctermfg=NONE", "guifg=NONE")
                    vim.cmd.highlight("SpellCap", "ctermfg=NONE", "guifg=NONE")
                    vim.cmd.highlight("SpellLocal", "ctermfg=NONE", "guifg=NONE")
                    vim.cmd.highlight("SpellRare", "ctermfg=NONE", "guifg=NONE")
                end,
            })
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
            vim.g.undotree_SetFocusWhenToggle = 1
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

    -- xml tag closing and renaming using treesitter with "windwp/nvim-ts-autotag"
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = { "windwp/nvim-ts-autotag", },
        init = function()
            -- use treesitter html parser for xml based files
            vim.g.xml_filetypes = {"xml", "docbk"}
            vim.treesitter.language.register(
                "html",
                vim.g.xml_filetypes
            )
        end,
        opts = { autotag = { enable = true, }, },
    },
    {
        "windwp/nvim-ts-autotag",
        config = function()
            -- enable ts-autotag for xml based files
            -- disable skip tag so all tags are closed
            require("nvim-ts-autotag").setup({
                filetypes = vim.g.xml_filetypes,
                skip_tag = {}
            })
        end,
    },

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
