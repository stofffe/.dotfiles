local req = "goto-preview"
local ok, preview = pcall(require, req)
if not ok then print("could not find require \"" .. req .. "\"") return end

local opts = { remap = false, silent = true }
vim.keymap.set('n', "gt", preview.goto_preview_type_definition, opts)
vim.keymap.set('n', "gtc", preview.close_all_win, opts)

preview.setup({
    border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
})
