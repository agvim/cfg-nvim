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
	{ "norcalli/nvim-colorizer.lua" },

	-- show the undo tree in an easier to use form
	{
		"mbbill/undotree",
		cmd = "UndotreeToggle",
		config = function()
			vim.cmd([[let g:undotree_SetFocusWhenToggle=1]])
		end,
		keys = { { "<leader>uu", "<cmd>UndotreeToggle<cr>", desc = "Toggle undo tree" } },
	},

	-- -- functions and symbols bar
	-- {
	--   "liuchengxu/vista.vim",
	--   config = function()
	--     vim.cmd([[ let g:vista#renderer#enable_icon = 1 ]])
	--   end,
	--   keys = { { "<leader>tt", "<cmd>Vista!!<cr>", desc = "tags explorer" } },
	-- },
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
	{ "kylechui/nvim-surround" },
	-- disable the lazyvim surround
	{ "echasnovski/mini.surround", enabled = false },

	-- xml tag closing
	{ "sukima/xmledit" },

	-- eases sharing and following editor configuration conventions
	{ "gpanders/editorconfig.nvim" },

	-- language servers for languages I'm using
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				pyright = {},
				clangd = {},
				rust_analyzer = {},
				texlab = {},
			},
		},
	},
}
