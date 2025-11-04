--
-- Global
--

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

--
-- Options
--

vim.opt.number = true
vim.opt.clipboard = "unnamedplus"
vim.opt.breakindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrap = false
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.scrolloff = 10
vim.opt.termguicolors = true
vim.opt.incsearch = true
vim.opt.hlsearch = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.winborder = "rounded"

--
-- Keymaps
--
vim.keymap.set("n", "<leader>s", "<Nop>", {})
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit file" })
vim.keymap.set("n", "<leader>f", "<cmd>Format<CR>", { desc = "Format file" })
vim.keymap.set("n", "<leader>v", "<cmd>vsplit<CR>", { desc = "Split window horizontally" })
vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "Toggle file explorer" }) -- Refresh and toggle
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode" })
vim.keymap.set("i", "<C-h>", "<Left>", { desc = "Move left in insert mode" })
vim.keymap.set("i", "<C-l>", "<Right>", { desc = "Move right in insert mode" })
vim.keymap.set({ "n", "i" }, "<C-q>", "@q", { desc = "Execute default macro @q" })
--vim.keymap.set("x", "p", [['_dP]], { desc = "Keep yank when pasting" })

-- window navigation
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set("n", "<Up>", ":resize +2<CR>", {})
vim.keymap.set("n", "<Down>", ":resize -2<CR>", {})
vim.keymap.set("n", "<Left>", ":vertical resize -2<CR>", {})
vim.keymap.set("n", "<Right>", ":vertical resize +2<CR>", {})

-- quickfix
vim.keymap.set("n", "<leader>cn", "<cmd>cnext<cr>", {})
vim.keymap.set("n", "<leader>cp", "<cmd>cprev<cr>", {})
vim.keymap.set("n", "<leader>co", "<cmd>copen<cr>", {})
vim.keymap.set("n", "<leader>cc", "<cmd>cexpr []<cr><cmd>cclose<cr>", {})
vim.keymap.set("n", "<leader>cd", ":cdo", {})

local on_windows = vim.fn.has("win32") == 1
local on_mac = vim.fn.has("mac") == 1

-- Windows specific
if on_windows then
	vim.opt.shell = "pwsh"

	vim.keymap.set("n", "<M-j>", "<cmd>move +1<CR>", { desc = "Move line up" })
	vim.keymap.set("n", "<M-k>", "<cmd>move -2<CR>", { desc = "Move line down" })
	vim.keymap.set("v", "<M-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down", silent = true })
	vim.keymap.set("v", "<M-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up", silent = true })

	vim.api.nvim_create_user_command("Build", function()
		vim.cmd("set shell=cmd")
		-- Run make silently and capture all output
		local output = vim.fn.systemlist(vim.o.makeprg)
		vim.cmd("set shell=pwsh")

		-- Remove carriage returns (\r) from each line
		for i, line in ipairs(output) do
			output[i] = line:gsub("\r", "")
		end

		-- Send output to quickfix
		vim.fn.setqflist({}, " ", { title = "Build", lines = output })

		-- Open quickfix at half screen height
		local win_height = math.floor(vim.o.lines / 2)
		vim.cmd(win_height .. "copen")

		-- Enter the quickfix window
		vim.cmd("wincmd j")
	end, {})
end

-- Mac specific
if on_mac then
	vim.keymap.set("n", "√", "<cmd>move +1<CR>", { desc = "Move line up" })
	vim.keymap.set("n", "ª", "<cmd>move -2<CR>", { desc = "Move line down" })
	vim.cmd("vnoremap √ :m '>+1<CR>gv=gv")
	vim.cmd("vnoremap ª :m '<-2<CR>gv=gv")
end

local open_native = function(path)
	if on_windows then
		vim.fn.jobstart({ "cmd", "/C", "start", "", path }, { detach = true })
	elseif on_mac then
		vim.fn.jobstart({ "open", path }, { detach = true })
	else
		vim.fn.jobstart({ "xdg-open", path }, { detach = true })
	end
end

vim.keymap.set("n", "<leader>o", function()
	local path = vim.fn.expand("%:p")
	open_native(path)
end, { desc = "[O]pen current natively" })

-- Toggle between two suffixes in the current buffer
local function toggle_suffix(suffix_a, suffix_b)
	local file = vim.fn.expand("%:p") -- full path
	local target = nil

	if file:match("%" .. suffix_a .. "$") then
		-- suffix_a -> suffix_b
		target = file:gsub("%" .. suffix_a .. "$", suffix_b)
	elseif file:match("%" .. suffix_b .. "$") then
		-- suffix_b -> suffix_a
		target = file:gsub("%" .. suffix_b .. "$", suffix_a)
	else
		vim.notify("Not a " .. suffix_a .. " or " .. suffix_b .. " file", vim.log.levels.WARN)
		return
	end

	if vim.fn.filereadable(target) == 1 then
		vim.cmd("edit " .. target)
	else
		vim.notify("No matching file found: " .. target, vim.log.levels.WARN)
	end
end

-- setup buffer-local keymap for two suffixes
local function setup_toggle_file_keymap(suffix_a, suffix_b, key)
	vim.api.nvim_create_autocmd("BufEnter", {
		pattern = { "*" .. suffix_a, "*" .. suffix_b },
		callback = function()
			vim.keymap.set("n", key or "<leader>h", function()
				toggle_suffix(suffix_a, suffix_b)
			end, { buffer = true, desc = "Toggle between " .. suffix_a .. " and " .. suffix_b, silent = true })
		end,
	})
end

-- Example usage for XAML and XAML.CS
setup_toggle_file_keymap(".xaml", ".xaml.cs", "<leader>h")
setup_toggle_file_keymap(".templ", "_templ.go", "<leader>h")

--
-- Terminal
--

local active_term = -1
vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("terminal-opts", { clear = true }),
	callback = function(info)
		vim.opt.number = false
		vim.opt.relativenumber = false

		active_term = info.buf
	end,
})

vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], {})
vim.keymap.set("t", "jk", [[<C-\><C-n>]], {})
vim.keymap.set("t", "<leader>t", vim.cmd.q, {})
vim.keymap.set("n", "<leader>t", function()
	local terminal_open = false
	local terminal_win = -1

	local open_win = vim.api.nvim_list_wins()
	for _, win in pairs(open_win) do
		local bufnr = vim.api.nvim_win_get_buf(win)
		if bufnr == active_term then
			terminal_open = true
			terminal_win = win
		end
	end

	if terminal_open then
		if vim.api.nvim_get_current_win() == terminal_win then
			vim.api.nvim_win_close(terminal_win, true)
		else
			vim.api.nvim_set_current_win(terminal_win)
		end
	else
		if active_term == -1 then
			vim.cmd.split()
			vim.cmd.term()
		else
			vim.cmd.split()
			vim.cmd.buffer(active_term)
		end
		vim.cmd.wincmd("J")
		vim.api.nvim_win_set_height(0, 15)
		vim.cmd.startinsert()
	end
end, {})

--
-- Commands
--

-- -- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
	desc = "Highlight when yanking (copying) text",
})

-- Some filetypes are not set by default
local unset_ft_groups = {
	wgsl = "wgsl",
	templ = "templ",
	xaml = "xml",
}
local set_ft_group = vim.api.nvim_create_augroup("set_filetype", { clear = true })
for suffix, filetype in pairs(unset_ft_groups) do
	vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
		group = set_ft_group,
		pattern = { "*." .. suffix },
		callback = function()
			vim.bo.filetype = filetype
		end,
	})
end

-- Diagnostic styling

vim.diagnostic.config({
	virtual_text = false,
	update_in_insert = true,
	underline = true,
	severity_sort = true,
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		-- source = "always",
		source = true,
		header = "",
		prefix = "",
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.INFO] = " ",
			[vim.diagnostic.severity.HINT] = "󰠠 ",
		},
	},
})

-- Install Lazy plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- Setup plugins
require("lazy").setup({
	-- { "numToStr/Comment.nvim", opts = {} },

	{ "mg979/vim-visual-multi" },

	--
	-- Git
	--
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "+" },
					change = { text = "~" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
				},
			})
		end,
	},

	{
		"ThePrimeagen/git-worktree.nvim",
		config = function()
			local Worktree = require("git-worktree")

			-- store the current worktree root before switching
			Worktree.on_tree_change(function(op, metadata)
				if op == Worktree.Operations.Switch then
					if not Worktree.update_current_buffer(metadata.prev_path) then
						print("could not update buffer")
					end
				end
			end)

			vim.keymap.set(
				"n",
				"<leader>gw",
				require("telescope").extensions.git_worktree.git_worktrees,
				{ desc = "[G]it [W]orktrees [S]withc" }
			)
			vim.keymap.set(
				"n",
				"<leader>gwc",
				require("telescope").extensions.git_worktree.create_git_worktree,
				{ desc = "[G]it [W]orktree [C]reate" }
			)
		end,
	},

	{
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		branch = "0.1.x",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "nvim-tree/nvim-web-devicons" },
			-- {
			-- 	"nvim-telescope/telescope-fzf-native.nvim",
			-- 	build = "cmake -S. -Bbuild -DCMAKE_POLICY_VERSION_MINIMUM=3.5 -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
			-- },
			-- {
			-- 	"nvim-telescope/telescope-fzf-native.nvim",
			-- 	build = "make", -- Update plugin when neccesary
			-- 	cond = function()
			-- 		return vim.fn.executable("make") == 1
			-- 	end,
			-- },
		},
		config = function()
			local actions = require("telescope.actions")
			require("telescope").setup({
				defaults = {
					prompt_prefix = " ",
					selection_caret = " ",
					path_display = { "smart" },

					mappings = {
						i = {
							["<Esc>"] = actions.close,
							["jk"] = actions.close,
							["<CR>"] = actions.select_default,
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,

							["<C-h>"] = actions.select_horizontal,
							["<C-s>"] = actions.select_vertical, -- should be v but gets blocked on windows

							["<C-u>"] = actions.preview_scrolling_up,
							["<C-d>"] = actions.preview_scrolling_down,

							["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
							["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
							["<C-q>"] = actions.smart_add_to_qflist + actions.open_qflist,
						},
						n = {
							["<Esc>"] = actions.close,
							["q"] = actions.close,
						},
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
				-- pickers = {}
			})

			-- Enable telescope extensions, if they are installed
			if not pcall(require("telescope").load_extension, "fzf") then
				print("failed to load fzf")
			end
			if not pcall(require("telescope").load_extension, "ui-select") then
				print("failed to load ui-select")
			end
			if not pcall(require("telescope").load_extension, "git_worktree") then
				print("failed to load git_worktree")
			end

			-- See `:help telescope.builtin`
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
			vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
			vim.keymap.set("n", "<leader>f", builtin.find_files, { desc = "[S]earch [F]iles" })
			vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
			vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
			vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
			vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
			vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
			vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

			-- diagnostics
			local severity = vim.diagnostic.severity
			vim.keymap.set("n", "<leader>d", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
			vim.keymap.set("n", "<leader>de", function()
				builtin.diagnostics({ severity = severity.ERROR })
			end, { desc = "[D]iagnostics: [E]rrors" })
			vim.keymap.set("n", "<leader>dw", function()
				builtin.diagnostics({ severity = severity.WARN })
			end, { desc = "[D]iagnostics: [W]arnings" })
			vim.keymap.set("n", "<leader>di", function()
				builtin.diagnostics({ severity = severity.INFO })
			end, { desc = "[D]iagnostics: [I]nfo" })
			vim.keymap.set("n", "<leader>dh", function()
				builtin.diagnostics({ severity = severity.HINT })
			end, { desc = "[D]iagnostics: [H]ints" })

			-- Fuzzy search current buffer
			vim.keymap.set(
				"n",
				"<leader>/",
				builtin.current_buffer_fuzzy_find,
				{ desc = "[/] Fuzzily search in current buffe" }
			)

			-- Shortcut for searching your neovim configuration files
			vim.keymap.set("n", "<leader>sn", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "[S]earch [N]eovim files" })
		end,
	},

	{
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs and related tools to stdpath for neovim
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },
			{ "WhoIsSethDaniel/mason-tool-installer.nvim" },
			{ "j-hui/fidget.nvim", opts = {} }, -- status updates
			{
				"folke/lazydev.nvim",
				ft = "lua", -- only load on lua files
				opts = {
					library = {
						-- See the configuration section for more details
						-- Load luvit types when the `vim.uv` word is found
						{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
					},
				},
			},
		},
		config = function()
			-- require("lspconfig").glasgow.setup({})

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition") -- <C-t> to go back
					map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					map("gi", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
					map("gt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")
					map(
						"<leader>sds",
						require("telescope.builtin").lsp_document_symbols,
						"[S]earch [D]ocument [S]ymbols"
					)
					map(
						"<leader>sws",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						"[S]earch [W]orkspace [S]ymbols"
					)
					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("<leader>a", vim.lsp.buf.code_action, "Code [A]ction")
					map("K", vim.lsp.buf.hover, "Hover Documentation")
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration") -- ex: C header
					map("<leader>dl", vim.diagnostic.open_float, "[D]iagnostic [L]ine")

					-- Highlight all occurances of word under cursor
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.server_capabilities.documentHighlightProvider then
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							callback = vim.lsp.buf.clear_references,
						})
					end
				end,
			})

			--  Add any additional override configuration in the following tables. Available keys are:
			--  - cmd (table): Override the default command used to start the server
			--  - filetypes (table): Override the default list of associated filetypes for the server
			--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
			--  - settings (table): Override the default settings passed when initializing the server.
			--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
			local servers = {
				rust_analyzer = {},
				clangd = {
					on_attach = function(_, bufnr)
						local opts = { silent = true, buffer = bufnr }
						vim.keymap.set("n", "<leader>h", "<cmd>ClangdSwitchSourceHeader<CR>", opts)
					end,
				},
				lua_ls = {
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
							workspace = {
								library = vim.api.nvim_get_runtime_file("", true), -- make Neovim runtime available
								checkThirdParty = false,
							},
							-- diagnostics = {
							-- 	disable = { "missing-fields" },
							-- 	globals = { "vim" },
							-- },
						},
					},
				},
				stylua = {},
			}

			require("mason").setup({
				registries = {
					"github:Crashdummyy/mason-registry", -- for roslyn
					"github:mason-org/mason-registry",
				},
			})
			require("mason-tool-installer").setup({
				ensure_installed = vim.tbl_keys(servers or {}),
			})
			require("mason-lspconfig").setup({
				automatic_enable = true,

				-- TODO: uncomment if using rustaceanvim
				-- automatic_enable = {
				-- 	-- exclude = { "rust_analyzer" },
				-- },
			})

			-- Manually enable non mason lsp:s
			vim.lsp.enable("glasgow")

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
			for server_name, config in pairs(servers) do
				-- This handles overriding only values explicitly passed
				-- by the server configuration above. Useful when disabling
				-- certain features of an LSP (for example, turning off formatting for tsserver)
				config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})
				vim.lsp.config(server_name, config)
			end

			-- print("INIT GLASGOW")
			-- vim.lsp.config("glasgow", {
			-- 	cmd = { "glasgow", "--stdio" },
			-- 	filetypes = { "wgsl", "txt" },
			-- 	root_markers = {
			-- 		".git",
			-- 	},
			-- })
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local empty_theme = {
				a = { fg = "NONE", bg = "NONE" },
				b = { fg = "NONE", bg = "NONE" },
				c = { fg = "NONE", bg = "NONE" },
			}
			require("lualine").setup({
				sections = {
					lualine_c = {
						{ "filename", path = 1 },
					},
				},
				options = {
					theme = {
						normal = empty_theme,
						insert = empty_theme,
						visual = empty_theme,
						replace = empty_theme,
						command = empty_theme,
						inactive = empty_theme,
					},
					section_separators = "",
					component_separators = "",
				},
			})

			vim.api.nvim_create_user_command("LualineToggle", function()
				if vim.o.laststatus == 0 then
					vim.o.laststatus = 3 -- show lualine
				else
					vim.o.laststatus = 0 -- hide lualine
				end
			end, { desc = "Toggle Lualine" })
		end,
	},

	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				notify_on_error = false,
				format_on_save = function(bufnr)
					if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
						return
					end
					-- Disable "format_on_save lsp_fallback" for languages that don't
					-- have a well standardized coding style. You can add additional
					-- languages here or re-enable it for the disabled ones.
					local disable_filetypes = { c = true, cpp = true }
					return {
						timeout_ms = 500,
						lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
					}
				end,
				formatters_by_ft = {
					lua = { "stylua" },
					go = { "goimports", "gofmt" },
					templ = { "templ" },
				},
			})

			vim.api.nvim_create_user_command("EnableAutoFormat", function()
				vim.g.disable_autoformat = false
			end, {})
			vim.api.nvim_create_user_command("DisableAutoFormat", function()
				vim.g.disable_autoformat = true
			end, {})
		end,
	},

	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			-- Snippet Engine & its associated nvim-cmp source
			{
				"L3MON4D3/LuaSnip",
				build = (function()
					-- Build Step is needed for regex support in snippets
					-- This step is not supported in many windows environments
					-- Remove the below condition to re-enable on windows
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {
					{
						"rafamadriz/friendly-snippets",
						config = function()
							require("luasnip.loaders.from_vscode").lazy_load()
						end,
					},
				},
			},
			{ "saadparwaiz1/cmp_luasnip" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lsp-signature-help" },
			{ "hrsh7th/cmp-path" },
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			luasnip.config.setup({})

			local kind_icons = {
				Text = "",
				Method = "m",
				Function = "",
				Constructor = "",
				Field = "",
				Variable = "",
				Class = "",
				Interface = "",
				Module = "",
				Property = "",
				Unit = "",
				Value = "",
				Enum = "",
				Keyword = "",
				Snippet = "",
				Color = "",
				File = "",
				Reference = "",
				Folder = "",
				EnumMember = "",
				Constant = "",
				Struct = "",
				Event = "",
				Operator = "",
				TypeParameter = "",
			}

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				completion = { completeopt = "menu,menuone,noinsert" },
				mapping = cmp.mapping.preset.insert({
					["<C-j>"] = cmp.mapping.select_next_item(), -- Select the [n]ext item
					["<C-k>"] = cmp.mapping.select_prev_item(), -- Select the [p]revious item

					["<CR>"] = cmp.mapping.confirm({ select = true }),
					-- ["<Tab>"] = cmp.mapping.confirm({ select = true }),
					["<C-s>"] = cmp.mapping.complete(),
					["<C-d>"] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),

					-- <c-l> will move you to the right of each of the expansion locations.
					-- <c-h> is similar, except moving you backwards.
					["<C-l>"] = cmp.mapping(function()
						if luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						end
					end, { "i", "s" }),
					["<C-h>"] = cmp.mapping(function()
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						end
					end, { "i", "s" }),

					-- scroll the documentation window [b]ack / [f]orward
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
				}),
				formatting = {
					fields = { "kind", "abbr", "menu" },
					format = function(entry, vim_item)
						-- Kind icons
						vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
						-- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
						vim_item.menu = ({
							nvim_lsp = "[LSP]",
							nvim_lsp_signature_help = "[SIGNATURE]",
							luasnip = "[Snippet]",
							buffer = "[Buffer]",
							path = "[Path]",
						})[entry.source.name]
						return vim_item
					end,
				},
				sources = {
					{ name = "nvim_lsp" },
					{ name = "nvim_lsp_signature_help" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
				},
				window = {
					documentation = {
						border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
					},
					completion = {
						border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
					},
				},
			})
		end,
	},

	{
		"lunarvim/darkplus.nvim",
		priority = 1000,
		config = function()
			require("darkplus").setup()

			vim.cmd.colorscheme("darkplus")

			-- You can configure highlights by doing something like
			vim.cmd.hi("Comment gui=none")
			vim.cmd.hi("VertSplit gui=None cterm=None")
		end,
	},

	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},

	{
		--  Check out: https://github.com/echasnovski/mini.nvim
		"echasnovski/mini.nvim",
		config = function()
			--  - va)  - [V]isually select [A]round [)]paren
			--  - yinq - [Y]ank [I]nside [N]ext [']quote
			--  - ci'  - [C]hange [I]nside [']quote
			require("mini.ai").setup({ n_lines = 500 })

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
		end,
	},

	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons", -- optional, but recommended
		},
		lazy = false, -- neo-tree will lazily load itself
		opts = {
			hide_root_node = true,
			window = {
				width = 35,
			},
			filesystem = {
				window = {
					mappings = {
						-- Remap navigations
						["h"] = "close_node",
						["l"] = "open", -- or "open" or “toggle_node” depending on your preference
						["s"] = "open_split",
						["v"] = "open_vsplit",
						["<leader>o"] = function(state)
							local node = state.tree:get_node()
							if not node then
								return
							end
							local path = node:get_id()

							open_native(path)
						end,
						["Y"] = function(state)
							local node = state.tree:get_node()
							if not node or not node.path then
								return
							end

							-- Yank the file path to system clipboard
							vim.fn.setreg("+", node.path)
							print("Copied to system clipboard: " .. node.path)
						end,
					},
				},
			},
			event_handlers = {
				{
					event = "file_opened",
					handler = function(file_path)
						require("neo-tree.command").execute({ action = "close" })
					end,
				},
			},
		},
	},

	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		-- commit = "63260da18bf273c76b8e2ea0db84eb901cab49ce",
		config = function(_, opts)
			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "go", "rust", "lua", "markdown", "vim", "vimdoc" },
				auto_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = {},
					-- disable = { "markdown", "cpp", "c_sharp" }, ---TODO: quick fix for windos
				},
				indent = { enable = true, disable = {} },
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<c-x>",
						node_incremental = "<c-x>",
						--[[ scope_incremental = '<c-s>', ]]
						node_decremental = "<c-s>",
					},
				},
			})
		end,
	},

	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"williamboman/mason.nvim",
			"jay-babu/mason-nvim-dap.nvim",

			-- Custom debuggers
			"leoluz/nvim-dap-go",
		},
		-- cmd = { "DapContinue", "DapToggleBreakpoint", "DapStepOver", "DapStepInto", "DapStepOut" },
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			local dap_mason = require("mason-nvim-dap")

			dap_mason.setup({
				automatic_setup = true, -- Best effort
				handlers = {},
				-- ensure_installed = { "codelldb" },
			})
			dapui.setup({})

			-- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
			dap.listeners.after.event_initialized["dapui_config"] = dapui.open
			dap.listeners.before.event_terminated["dapui_config"] = dapui.close
			dap.listeners.before.event_exited["dapui_config"] = dapui.close

			-- keymaps
			vim.keymap.set("n", "<F1>", dap.step_into, { desc = "Debug: Step Into" })
			vim.keymap.set("n", "<F2>", dap.step_over, { desc = "Debug: Step Over" })
			vim.keymap.set("n", "<F3>", dap.step_out, { desc = "Debug: Step Out" })
			vim.keymap.set("n", "<F4>", dap.step_back, { desc = "Debug: Step Back" })
			vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
			vim.keymap.set("n", "<F7>", dapui.toggle, { desc = "Debug: See last session result." })
			vim.keymap.set("n", "<leader>dk", function()
				dapui.eval(nil, { enter = true })
			end, { desc = "Evaluate work under cursor" })
			vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
			vim.keymap.set("n", "<leader>B", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, { desc = "Debug: Set Breakpoint with condition" })
			-- vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
			vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "DapBreakpoint", linehl = "", numhl = "" })

			--
			-- Specific debuggers
			--
			require("dap-go").setup()

			dap.adapters.executable = {
				type = "executable",
				command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
				name = "lldb1",
				host = "127.0.0.1",
				port = 13000,
			}

			dap.adapters.codelldb = {
				name = "codelldb server",
				type = "server",
				port = "${port}",
				executable = {
					command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
					args = { "--port", "${port}" },
				},
			}
		end,
	},

	--
	-- Language specific plugins
	--

	-- {
	-- 	"laytan/tailwind-sorter.nvim",
	-- 	dependencies = {
	--      "nvim-treesitter/nvim-treesitter",
	-- 		"nvim-lua/plenary.nvim",
	-- 	},
	-- 	-- build = "cd formatter && npm ci && npm run build",
	-- 	lazy = true,
	-- 	ft = { "css", "scss", "html", "typescriptreact", "javascriptreact" },
	-- 	config = function()
	-- 		local tailwind_sorter = require("tailwind-sorter")
	-- 		tailwind_sorter.setup({})
	-- 		tailwind_sorter.toggle_on_save()
	-- 	end,
	-- },

	{
		"akinsho/flutter-tools.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"stevearc/dressing.nvim", -- optional for vim.ui.select
		},
		lazy = true,
		ft = { "dart" },
		config = function()
			require("flutter-tools").setup({
				lsp = { settings = { lineLength = 120 } },
			})
			-- vim.keymap.set("n", "<leader>t", "<cmd>FlutterLogToggle<cr>", { desc = "Toggle flutter logs" })
		end,
	},

	{
		"seblyng/roslyn.nvim",
		dependencies = { "williamboman/mason.nvim" },
		lazy = true,
		ft = { "cs" },
		config = function()
			vim.lsp.config("roslyn", {
				cmd = {
					"C:/Users/chan/AppData/Local/nvim-data/mason/bin/roslyn.cmd",
					"--logLevel=Information",
					"--extensionLogDirectory=C:/Users/chan/AppData/Local/nvim-data",
					"--stdio",
				},
			})
		end,
	},

	-- {
	-- 	"mrcjkb/rustaceanvim",
	-- 	version = "^6", -- Recommended
	-- 	lazy = false, -- This plugin is already lazy
	-- 	init = function()
	-- 		vim.g.rustaceanvim = {
	-- 			-- Plugin configuration
	-- 			tools = {},
	-- 			-- LSP configuration
	-- 			server = {
	-- 				on_attach = function(client, bufnr)
	-- 					vim.keymap.set("n", "dl", function()
	-- 						vim.cmd.RustLsp("renderDiagnostic")
	-- 					end, { buffer = bufnr, desc = "[Override] [D]iagnostic [L]ine" })
	-- 					vim.keymap.set("n", "dr", function()
	-- 						vim.cmd.RustLsp("relatedDiagnostic")
	-- 					end, { buffer = bufnr, desc = "[Override] [D]iagnostic [R]elated" })
	-- 					vim.keymap.set("n", "<F5>", function()
	-- 						vim.cmd.RustLsp("debuggables")
	-- 					end, { buffer = bufnr, desc = "[Override] Dap Continue" })
	-- 				end,
	-- 				default_settings = {
	-- 					["rust-analyzer"] = {
	-- 						checkOnSave = true,
	-- 						-- checkOnSave = {
	-- 						-- 	command = "clippy",
	-- 						-- 	allFeatures = true,
	-- 						-- 	overrideCommand = {
	-- 						-- 		"cargo",
	-- 						-- 		"clippy",
	-- 						-- 		"--workspace",
	-- 						-- 		"--message-format=json",
	-- 						-- 		"--all-targets",
	-- 						-- 	},
	-- 						-- },
	-- 					},
	-- 				},
	-- 			},
	-- 			dap = {},
	-- 		}
	-- 	end,
	-- },

	{
		"p00f/clangd_extensions.nvim",
		ft = { "c", "cpp" },
		lazy = true,
	},
})
