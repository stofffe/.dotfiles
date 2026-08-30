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

vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { desc = "[L]sp [F]ormat File" })
vim.keymap.set("v", "<leader>lf", function()
	local start_pos = vim.fn.getpos("'<")
	local end_pos = vim.fn.getpos("'>")

	vim.lsp.buf.format({
		range = {
			["start"] = { start_pos[2], start_pos[3] },
			["end"] = { end_pos[2], end_pos[3] },
		},
	})
end, { desc = "[L]sp [F]ormat selection" })
vim.keymap.set("n", "<leader>ld", require("telescope.builtin").lsp_definitions, { desc = "[L]sp [D]efinition" }) -- <C-t> to go back
vim.keymap.set("n", "<leader>lr", require("telescope.builtin").lsp_references, { desc = "[L]sp [R]eferences" })
vim.keymap.set("n", "<leader>li", require("telescope.builtin").lsp_implementations, { desc = "[L]sp [I]mplementation" })
vim.keymap.set(
	"n",
	"<leader>lt",
	require("telescope.builtin").lsp_type_definitions,
	{ desc = "[L]sp [T]ype Definition" }
)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "[R]e[n]ame" })
vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, { desc = "[L]sp Code [A]ction" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
vim.keymap.set("n", "<leader>lD", vim.lsp.buf.declaration, { desc = "[L]sp [D]eclaration" }) -- ex: C header
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
				},
			},
		},
		on_attach = function(_, bufnr)
			local wasm_target = "wasm32-unknown-unknown"
			local default_target = nil

			local function set_rust_target(target)
				-- needed since setting field to nil doesnt override
				if not target then
					target = "null"
				end

				vim.lsp.config("rust_analyzer", {
					settings = {
						["rust-analyzer"] = {
							cargo = {
								target = target,
							},
							check = {
								allTargets = true,
								command = "clippy",
							},
						},
					},
				})

				for _, client in ipairs(vim.lsp.get_clients({ name = "rust_analyzer" })) do
					client:stop(true)
				end

				vim.defer_fn(function()
					vim.lsp.enable("rust_analyzer")
				end, 100)
			end

			vim.api.nvim_create_user_command("RustWasmEnable", function()
				set_rust_target(wasm_target)
				vim.notify("Rust WASM target enabled")
			end, {})

			vim.api.nvim_create_user_command("RustWasmDisable", function()
				set_rust_target(default_target)
				vim.notify("Rust WASM target disabled")
			end, {})
		end,
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

vim.keymap.set("n", "<leader>W", function()
	local autoformat = vim.g.disable_autoformat
	vim.g.disable_autoformat = true

	vim.cmd("w")

	vim.g.disable_autoformat = autoformat
end, { desc = "Save file without formatting" })
