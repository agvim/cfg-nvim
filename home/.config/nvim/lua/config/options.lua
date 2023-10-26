-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- change the terminal title to reflect the filename
vim.opt.title = true

-- wrap text with a visually distinct line wrap
vim.opt.wrap = true
vim.opt.showbreak = "↪ "

-- highlight whitespace
vim.opt.list = true
vim.opt.listchars = "tab:  ›,trail:•,extends:❯,precedes:❮"

-- indentation: tabs are displayed as 4 spaces, indent with 4 spaces
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- disable autoformatting on save (LSP)
vim.g.autoformat = false
