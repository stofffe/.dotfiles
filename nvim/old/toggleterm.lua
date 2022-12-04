local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
    return
end

toggleterm.setup({
    size = 20,
    hide_numbers = true,
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    direction = "float",
    close_on_exit = true,
    shell = vim.o.shell,
    float_opts = {
        border = "curved",
        winblend = 0,
        highlights = {
            border = "Normal",
            background = "Normal",
        },
    },
})

-- Basic keymaps
function _G.set_terminal_keymaps()
    local opts = { noremap = true }
    vim.api.nvim_buf_set_keymap(0, 't', '<Esc>', [[<C-\><C-n>]], opts) -- Enter normal mode with jk
    vim.api.nvim_buf_set_keymap(0, 't', '<C-p>', [[<cmd>ToggleTerm<CR>]], opts) -- Close terminal

    -- vim.api.nvim_buf_set_keymap(0, 't', '<C-b>', [[<Up><CR>]], opts) -- Run last command
    -- vim.api.nvim_buf_set_keymap(0, 't', '<C-d>', [[<Down>]], opts) -- Close terminal
    -- vim.api.nvim_buf_set_keymap(0, 't', '<C-u>', [[<Up>]], opts) -- Close terminal
    -- vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<Left>]], opts) -- Close terminal
    -- vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<Right>]], opts) -- Close terminal

end

vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

-- Lazygit
local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({
    cmd = "lazygit",
    hidden = true,

})

function _LAZYGIT_TOGGLE()
    lazygit:toggle()
end

-- vim.api.nvim_set_keymap("n", "<C-g>", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", { noremap = true, silent = true })
