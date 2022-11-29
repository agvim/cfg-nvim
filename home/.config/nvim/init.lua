-- ===============
-- display related
-- ===============

-- show line numbers and signs merged
vim.opt.number = true
vim.opt.signcolumn = 'number'
vim.opt.termguicolors = true
-- change the terminal title to reflect the filename
vim.opt.title = true

-- highlight whitespace
vim.opt.list = true
vim.opt.listchars = 'tab:› ,trail:•,extends:❯,precedes:❮'

-- visually distinct line wrap
vim.opt.showbreak = '↪ '

-- highlight matching braces/brackets/etc
vim.opt.showmatch = true

-- highlight column 80 and the current line
vim.opt.colorcolumn = '80'
vim.opt.cursorline = true


-- highlight yanked text for 200ms using the "Visual" highlight group
vim.api.nvim_create_autocmd (
    'TextYankPost',
    {
        desc = 'Highlight on yank',
        callback = function(event)
            vim.highlight.on_yank({higroup = 'IncSearch', timeout = 500})
        end
    }
)

-- neovide gui display options
if vim.fn.exists('g:neovide') then
    -- Use Fira code font and fall back to JetBrains Mono.
    vim.opt.guifont='FiraCode Nerd Font Mono,JetBrainsMono Nerd Font Mono:h11'
    -- misc neovide options
    vim.g.neovide_remember_window_size = false
    vim.g.neovide_cursor_animation_length = 0.02
    vim.g.neovide_cursor_trail_length = 0
end


-- =================
-- behaviour related
-- =================

-- use comma as the leader key
vim.g.mapleader = ','

-- indentation: tabs are displayed as 8 spaces, but indent with 4 spaces
vim.opt.expandtab = true
vim.opt.tabstop = 8
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- Less identation for the following file types
vim.api.nvim_create_autocmd (
    "FileType",
    {
        pattern = {
            'tex', 'markdown', -- text
            'xml', 'docbk', 'xsd', 'xslt', -- xml
        },
        command = "setlocal shiftwidth=2 softtabstop=2",
    }
)

-- use os clipboard
vim.opt.clipboard = 'unnamed,unnamedplus'

-- smarter searching
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- spellcheck
vim.opt.spell = true

-- ignore spaces in diff
vim.opt.diffopt:append('iwhiteall')

-- grep with ripgrep
if vim.fn.executable('rg') == 1 then
    vim.opt.grepprg = "rg --vimgrep --hidden --smart-case --glob ‘!.git’"
    vim.opt.grepformat = '%f:%l:%c:%m'
end

-- keymaps
-- +++++++

-- screen line scroll
vim.keymap.set('n','j', 'gj')
vim.keymap.set('n','k', 'gk')

-- reselect visual block after indent
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')


-- plugins with their config
require('packer').startup(function(use)
    -- use packer to manage packer
    use 'wbthomason/packer.nvim'

    -- ===============
    -- display related
    -- ===============

    -- solarized colorscheme
    use {
        'ishan9299/nvim-solarized-lua',
        config = vim.cmd[[
            " do not overwrite the foreground color for spell check marked text,
            augroup colorschemefix
                " Remove all group autocommands
                autocmd!
                " place it in the colorscheme autocommand to trigger it on background change also
                " using NONE to preserve the syntax color
                autocmd ColorScheme * highlight SpellBad ctermfg=NONE guifg=NONE
                autocmd ColorScheme * highlight SpellCap ctermfg=NONE guifg=NONE
                autocmd ColorScheme * highlight SpellLocal ctermfg=NONE guifg=NONE
                autocmd ColorScheme * highlight SpellRare ctermfg=NONE guifg=NONE
            augroup END
            colorscheme solarized
        ]],
    }

    -- show indent levels
    use {
        'lukas-reineke/indent-blankline.nvim',
        requires = 'nvim-treesitter/nvim-treesitter',
        config = function()
            require('indent_blankline').setup {
                show_first_indent_level = false,
                -- link with treesitter
               use_treesitter = true,
               show_current_context = true,
            }
        end,
    }

    -- fancy statusline
    use {
        'nvim-lualine/lualine.nvim',
        requires = 'nvim-tree/nvim-web-devicons', -- for fancy icons
        config = function()
            vim.opt.showmode = false
            require('lualine').setup {
                options = {
                    theme = 'solarized',
                }
            }
        end,
    }

    -- show changed lines in the numbers bar
    use {
        'mhinz/vim-signify',
        config = vim.cmd[[
            let g:signify_sign_add='+'
            let g:signify_sign_delete='-'
            let g:signify_sign_delete_first_line='‾'
            let g:signify_sign_change='!'
            " vim.g.signify_sign_change_delete=g:signify_sign_change . g:signify_sign_delete_first_line
            let g:signify_number_highlight=1
        ]],
    }

    -- better language highlighting per file parsing
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function()
            require('nvim-treesitter.configs').setup {
                auto_install = true,
                highlight = {
                    enable = true,
                },
                indent = {
                    enable = true,
                },
            }
            -- use treesitter for folding
            vim.opt.foldmethod = 'expr'
            vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
            vim.opt.foldenable = false
        end,
    }
    -- underline the word under cursor
    use {
        'yamatsum/nvim-cursorline',
        config = function()
            require('nvim-cursorline').setup {
                cursorline = {enable = false}
            }
        end,
    }

    -- highlight colors
    use {
        'norcalli/nvim-colorizer.lua',
        config = function()
            require('colorizer').setup()
        end,
    }

    -- tabs experience similar to other editors
    use {
        'romgrk/barbar.nvim',
        requires = 'nvim-tree/nvim-web-devicons', -- for fancy icons
    }

    -- show the undo tree in an easier to use form
    use {
        'mbbill/undotree',
        config = vim.cmd[[
            let g:undotree_SetFocusWhenToggle=1
            nnoremap <silent> <leader>uu :UndotreeToggle<CR>
        ]],
    }

    -- file browser
    use {
        'nvim-tree/nvim-tree.lua',
        requires = 'nvim-tree/nvim-web-devicons', -- for fancy icons
        config = function()
            require('nvim-tree').setup {
                vim.keymap.set('n','<leader>ee', ':NvimTreeToggle<CR>')
            }
        end,
    }

    -- functions and symbols bar
    use {
        'liuchengxu/vista.vim',
        config = vim.cmd[[
            let g:vista#renderer#enable_icon = 1
            nnoremap <silent> <leader>tt :Vista!!<CR>
        ]],
    }

    -- key binding discovery
    use {
        "folke/which-key.nvim",
        config = function()
            require("which-key").setup()
        end
    }

    -- =================
    -- behaviour related
    -- =================

    -- surround a selected block of text
    use {
        'kylechui/nvim-surround',
        config = function()
            require('nvim-surround').setup()
        end,
    }

    -- auto closes braces and such
    use {
        'windwp/nvim-autopairs',
        config = function()
            require('nvim-autopairs').setup {
                map_cr = false,
                map_bs = false,
            }
        end,
    }

    -- xml tag closing
    use 'sukima/xmledit'

    -- eases sharing and following editor configuration conventions
    use 'gpanders/editorconfig.nvim'

    -- webapi and emmet for simpler xml editing
    --   Plug 'mattn/webapi-vim'
    --   Plug 'mattn/emmet-vim'
    -- " load custom emmet snippets for emmet-vim ('mattn/emmet-vim')
    -- " TODO FIXME: the substitution works if there is no snippet with //
    -- let emmet_without_comments = substitute(join(readfile(expand('~/emmet1snippets.json')), "\n"), '//[^\r\n]*', '', 'g')
    -- let g:user_emmet_settings = webapi#json#decode(emmet_without_comments)

    -- autocompletion using LSP, buffer words and snippets
    use {
        'hrsh7th/nvim-cmp',
        config = function()
            -- nvim-cmp with lspconfig manual server config not needed as it is handled from mason,
            -- just require the plugins
            require("cmp_nvim_lsp")
            require('lspconfig')

            -- luasnip setup
            local luasnip = require 'luasnip'
            require('luasnip.loaders.from_vscode').lazy_load()

            -- nvim-cmp setup
            local cmp = require 'cmp'
            cmp.setup {
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert ({
                    -- documentation scroll
                    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    -- force trigger completion
                    ['<C-Space>'] = cmp.mapping.complete(),
                    -- complete item
                    ['<CR>'] = cmp.mapping.confirm {
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    },
                    -- go to next completion item with shift tab
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, {'i', 's'}),
                    -- go to previous completion item with shift tab
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, {'i', 's'}),
                }),
                sources = {
                    {name = 'nvim_lsp'},
                    {name = 'nvim_lsp_signature_help'},
                    {name = 'luasnip'},
                    {name = 'path'},
                    {name = 'buffer', keyword_length = 3},
                },
            }

            -- mason
            -- autoinstall lsp servers with mason
            require('mason').setup()
            mason_lspconfig = require('mason-lspconfig')
            mason_lspconfig.setup {
                automatic_installation = true,
                ensure_installed = {
                    "clangd", -- C
                    "pyright", -- python
                    "rust_analyzer", -- rust
                    "texlab", -- latex
                }
            }
            -- Use an on_attach function to only map the following keys
            -- after the language server attaches to the current buffer
            local on_attach = function(client, bufnr)
                -- Enable completion triggered by <c-x><c-o>
                vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

                -- Mappings.
                -- See `:help vim.lsp.*` for documentation on any of the below functions
                local bufopts = {noremap=true, silent=true, buffer=bufnr}
                -- Jump to declaration
                vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
                -- Jump to the definition
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
                -- Displays hover information about the symbol under the cursor
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
                -- Lists all the implementations for the symbol under the cursor
                vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
                -- Displays a function's signature information
                vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
                -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
                -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
                -- vim.keymap.set('n', '<space>wl', function()
                --     print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                -- end, bufopts)
                -- vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
                -- vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
                -- vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
                -- display references
                vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
                -- vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format {async = true} end, bufopts)
            end
            -- tie together the servers installed with mason with the lsp config + keybindings
            mason_lspconfig.setup_handlers {
                function (server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        on_attach = on_attach,
                    }
                end,
            }
        end,
        requires = {
            'neovim/nvim-lspconfig', -- LSP config

            -- completion sources
            'hrsh7th/cmp-nvim-lsp', -- LSP
            'hrsh7th/cmp-buffer', -- local buffer words
            'hrsh7th/cmp-path', -- file paths
            'hrsh7th/cmp-nvim-lsp-signature-help', -- function signatures

            -- snippets
            'L3MON4D3/LuaSnip', -- Snippets plugin
            'saadparwaiz1/cmp_luasnip', -- Snippets source for nvim-cmp
            'rafamadriz/friendly-snippets', -- actual snippets

            -- lsp installer
            'williamboman/mason.nvim', -- installer for external packages
            'williamboman/mason-lspconfig.nvim', -- autoinstall external language servers
        },
    }
end)

