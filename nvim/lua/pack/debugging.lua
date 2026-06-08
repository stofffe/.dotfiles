local dap = require("dap")
local dap_view = require("dap-view")
local dap_mason = require("mason-nvim-dap")
local dap_widgets = require("dap.ui.widgets")
local dap_persistent = require("persistent-breakpoints")
local dap_persistent_api = require("persistent-breakpoints.api")

-- vim.api.nvim_set_hl(0, 'DapStoppedCursor', { fg='#FFCC00', bg=None })
-- vim.api.nvim_set_hl(0, 'DapStoppedBackground', { bg="#4C4C19" })
-- vim.fn.sign_define('DapStopped', { text='', texthl='DapStoppedCursor', linehl='DapStoppedBackground', numhl=''})

vim.api.nvim_set_hl(0, "DapStoppedCursor", { fg = "#0eb0cc", bg = None })
vim.api.nvim_set_hl(0, "DapStoppedBackground", { bg = "#33583e" })
vim.fn.sign_define(
	"DapStopped",
	{ text = "", texthl = "DapStoppedCursor", linehl = "DapStoppedBackground", numhl = "" }
)

dap_mason.setup({
	automatic_installation = true,
})

dap_view.setup({
	auto_toggle = true,
	winbar = {
		default_section = "scopes",
	},
	windows = {
		position = "below",
		size = 0.4,
		terminal = {
			position = "right",
			size = 0.3,
		},
	},
})

dap_persistent.setup({
	load_breakpoints_event = { "BufReadPost" },
})

vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })
vim.keymap.set("n", "<S-F11>", dap.step_out, { desc = "Debug: Step Out" })
vim.keymap.set("n", "<F12>", dap.step_back, { desc = "Debug: Step Back" })
vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
vim.keymap.set("n", "<F6>", dap.run_to_cursor, { desc = "Debug: Start/Continue" })
vim.keymap.set("n", "<S-F5>", dap.terminate, { desc = "Debug: Terminate" })
vim.keymap.set("n", "<leader>dk", dap_widgets.hover, { desc = "Evaluate work under cursor" })

vim.keymap.set("n", "<leader>b", dap_persistent_api.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
vim.keymap.set(
	"n",
	"<leader>B",
	dap_persistent_api.set_conditional_breakpoint,
	{ desc = "Debug: Toggle Conditional Breakpoint" }
)
vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "DapBreakpoint", linehl = "", numhl = "" })

--
-- Specific debuggers
--

require("dap-go").setup()

dap.adapters.codelldb = {
	type = "executable",
	command = "codelldb",

	-- On windows you may have to uncomment this:
	detached = not require("platform").on_windows,
}

dap.configurations.c = {
	{
		name = "Launch file",
		type = "codelldb",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
	},
}
dap.configurations.cpp = dap.configurations.c

local function rust_lldb_commands()
	local sysroot = vim.fn.trim(vim.fn.system("rustc --print sysroot"))

	return {
		("command script import %s/lib/rustlib/etc/lldb_lookup.py"):format(sysroot),
		("command source %s/lib/rustlib/etc/lldb_commands"):format(sysroot),
	}
end

dap.configurations.rust = {
	{
		name = "Launch codelldb",
		type = "codelldb",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,

		expressions = "native",
		initCommands = rust_lldb_commands(),
	},
}
