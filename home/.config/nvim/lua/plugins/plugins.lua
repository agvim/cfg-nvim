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

    -- show the undo tree in an easier to use form
    {
        "mbbill/undotree",
        cmd = "UndotreeToggle",
        config = function()
            vim.g.undotree_SetFocusWhenToggle = 1
        end,
        keys = { { "<leader>uu", "<cmd>UndotreeToggle<cr>", desc = "Toggle undo tree" } },
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
        init = function()
            -- use treesitter html parser for xml based files
            vim.g.xml_filetypes = {"xml", "docbk"}
            vim.treesitter.language.register(
                "html",
                vim.g.xml_filetypes
            )
        end,
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
}
