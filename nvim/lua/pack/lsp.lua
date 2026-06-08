-- vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "[F]ormat file" })

require("mason").setup()
require("mason-lspconfig").setup()

--
-- Diagnostics
--

vim.diagnostic.config({
	virtual_text = false,
	update_in_insert = true,
	underline = true,
	severity_sort = true,
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
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

vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { fg = "#00aaff", bg = "NONE" })

--
-- LSP
--

vim.keymap.set("n", "gd", require("telescope.builtin").lsp_definitions, { desc = "[G]oto [D]efinition" }) -- <C-t> to go back
vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, { desc = "[G]oto [R]eferences" })
vim.keymap.set("n", "gi", require("telescope.builtin").lsp_implementations, { desc = "[G]oto [I]mplementation" })
vim.keymap.set("n", "gt", require("telescope.builtin").lsp_type_definitions, { desc = "[G]oto [T]ype Definition" })
vim.keymap.set(
	"n",
	"<leader>sds",
	require("telescope.builtin").lsp_document_symbols,
	{ desc = "[S]earch [D]ocument [S]ymbols" }
)
vim.keymap.set(
	"n",
	"<leader>sws",
	require("telescope.builtin").lsp_dynamic_workspace_symbols,
	{ desc = "[S]earch [W]orkspace [S]ymbols" }
)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "[R]e[n]ame" })
vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, { desc = "Code [A]ction" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "[G]oto [D]eclaration" }) -- ex: C header
vim.keymap.set("n", "<leader>dl", vim.diagnostic.open_float, { desc = "[D]iagnostic [L]ine" })

local configs = {
	rust_analyzer = {
		tools = {},
		settings = {
			-- rust-analyzer language server configuration
			["rust-analyzer"] = {
				linkedProjects = {
					"Cargo.toml",
				},
				check = {
					allTargets = true,
					command = "clippy",
					overrideCommand = {
						"cargo",
						"clippy",
						"--workspace",
						"--message-format=json",
						"--all-targets",
					},
				},
			},
		},
	},
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
				diagnostics = {
					disable = { "missing-fields" },
					globals = { "vim" },
				},
			},
		},
	},
	stylua = {},
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

for server_name, config in pairs(configs) do
	-- This handles overriding only values explicitly passed
	-- by the server configuration above. Useful when disabling
	-- certain features of an LSP (for example, turning off formatting for tsserver)
	config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})
	vim.lsp.config(server_name, config)
end

-- Non mason
vim.lsp.enable("glasgow")
vim.lsp.config("glasgow", {
	filetypes = { "wgsl", "wesl" },
})

--
-- Formatting
--

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
