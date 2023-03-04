local req = "dap"
local ok, dap = pcall(require, req)
if not ok then print("could not find require \"" .. req .. "\"") return end

--Plugins
local dapui = require("dapui")
require("telescope").load_extension("dap")
require("nvim-dap-virtual-text").setup()

-- Indivudal DAP servers
require("user.lsp.dap.go")
--[[ require("user.lsp.dap.rust") ]]
require("user.lsp.dap.cpp")

-- Icons
vim.fn.sign_define('DapBreakpoint', { text = '🟥', texthl = '', linehl = '', numhl = '' })

-- Keymaps
local opts = { remap = false, silent = true }

-- Normal
vim.keymap.set('n', '<leader>ds', function()
    dap.continue()
    dap.repl.close()
end, opts)
vim.keymap.set('n', '<leader>dn', dap.step_over, opts)
vim.keymap.set('n', '<leader>di', dap.step_into, opts)
vim.keymap.set('n', '<leader>do', dap.step_out, opts)
vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, opts)
vim.keymap.set('n', '<leader>dq', function()
    dap.close()
    dapui.close()
    dap.repl.close()
end, opts)

-- Telescope
vim.keymap.set('n', '<leader>dc', require("telescope").extensions.dap.commands, opts)
vim.keymap.set('n', '<leader>dv', require("telescope").extensions.dap.variables, opts)

-- UI
vim.keymap.set('n', '<leader>dt', dapui.toggle, opts)

-- Ui
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end
dapui.setup()
