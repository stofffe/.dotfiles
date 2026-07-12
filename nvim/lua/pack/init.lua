vim.pack.add({
	-- lsp
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/stevearc/conform.nvim" },

	-- completions
	{ src = "https://github.com/hrsh7th/nvim-cmp" },
	{ src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
	{ src = "https://github.com/hrsh7th/cmp-nvim-lsp-signature-help" },
	{ src = "https://github.com/hrsh7th/cmp-path" },
	{ src = "https://github.com/saadparwaiz1/cmp_luasnip" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/rafamadriz/friendly-snippets" },

	-- debugging
	{ src = "https://github.com/mfussenegger/nvim-dap" },
	{ src = "https://github.com/jay-babu/mason-nvim-dap.nvim" },
	{ src = "https://github.com/igorlfs/nvim-dap-view" },
	{ src = "https://github.com/Weissle/persistent-breakpoints.nvim" },
	{ src = "https://github.com/leoluz/nvim-dap-go" },

	-- pickers
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	-- { src = "https://github.com/nvim-telescope/telescope-frecency.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope-ui-select.nvim" },

	-- git
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/neogitorg/neogit" },
	{ src = "https://github.com/sindrets/diffview.nvim" },
	{ src = "https://github.com/harrisoncramer/gitlab.nvim" },

	-- random
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", branch = "main" },
	{ src = "https://github.com/nvim-neo-tree/neo-tree.nvim", branch = "v3.x" },
	{ src = "https://github.com/akinsho/toggleterm.nvim" },
	{ src = "https://github.com/mg979/vim-visual-multi" },
	{ src = "https://github.com/folke/todo-comments.nvim" },
	{ src = "https://github.com/LunarVim/darkplus.nvim" },
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	{ src = "https://github.com/dchinmay2/clangd_extensions.nvim" },
	{ src = "https://github.com/j-hui/fidget.nvim" },
	{ src = "https://github.com/nvim-mini/mini.nvim" },
	{ src = "https://github.com/stevearc/dressing.nvim" },
	{ src = "https://github.com/tpope/vim-dispatch" },

	-- utils
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
})

-- Colorscheme

vim.cmd.colorscheme("darkplus")

vim.keymap.set("n", "<leader>m", ":Make<cr>", { desc = "[M]ake async" })

require("fidget").setup({})
require("todo-comments").setup({})
require("clangd_extensions").setup({})
require("dressing").setup({
	select = {
		enabled = false,
	},
})

--  - va)  - [V]isually select [A]round [)]paren
--  - yinq - [Y]ank [I]nside [N]ext [']quote
--  - ci'  - [C]hange [I]nside [']quote
-- require("mini.ai").setup({ n_lines = 500 })

-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
-- - sd'   - [S]urround [D]elete [']quotes
-- - sr)'  - [S]urround [R]eplace [)] [']
require("mini.surround").setup()
require("mini.pairs").setup({
	modes = { insert = true, command = false, terminal = false },
	mappings = {
		["("] = { action = "open", pair = "()", neigh_pattern = "[^\\]." },
		["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\]." },
		["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\]." },

		[")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
		["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
		["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },

		['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^\\].", register = { cr = false } },
		["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%a\\].", register = { cr = false } },
		["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\].", register = { cr = false } },
	},
})

require("pack.git")
require("pack.pickers")
require("pack.statusbar")
require("pack.terminal")
require("pack.highlighting")
require("pack.completion")
require("pack.file_explorer")
require("pack.lsp")
require("pack.debugging")
