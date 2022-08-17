local opts = { noremap = true, silent = true }

local keymap = vim.api.nvim_set_keymap

-- Space to leader
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "

-- Modes
local n = "n" -- normal
local i = "i" -- insert
local v = "v" -- visual line
local V = "x" -- visual block
local t = "t" -- term mode
local c = "c" -- command mode

-- Insert
-- Exit insert mode with jk
keymap(i, "jk", "<Esc>", opts)
keymap(i, "<C-h>", "<Left>", opts)
keymap(i, "<C-l>", "<Right>", opts)
keymap(i, "<C-f>", "<cmd>GoFillStruct<CR>", opts)

-- Visual
keymap(v, "<Leader>y", '"*y', opts)
keymap(V, "<Leader>y", '"*y', opts)

-- Normal --
-- Format and save
keymap(n, "<leader>f", ":Format<cr>", opts)
keymap(n, "<leader>s", ":w<cr>", opts)
keymap(n, "<leader>q", ":q<cr>", opts)

-- Better window navigation
keymap(n, "<C-h>", "<C-w>h", opts)
keymap(n, "<C-j>", "<C-w>j", opts)
keymap(n, "<C-k>", "<C-w>k", opts)
keymap(n, "<C-l>", "<C-w>l", opts)

-- Resize with arrows
keymap(n, "<S-Up>", ":resize +2<CR>", opts)
keymap(n, "<S-Down>", ":resize -2<CR>", opts)
keymap(n, "<S-Left>", ":vertical resize -2<CR>", opts)
keymap(n, "<S-Right>", ":vertical resize +2<CR>", opts)

-- Visual
-- Don't override when pasting
-- keymap(v, "p", "_p", opts)

-- Telescope
keymap(n, "<leader>p",
    "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<CR>"
    , opts)
keymap(n, "<leader>P", "<cmd>lua require'telescope.builtin'.find_files()<CR>", opts)
keymap(n, "<leader>g", "<cmd>Telescope live_grep<CR>", opts)
keymap(n, "<leader>m", "<cmd>Telescope treesitter<CR>", opts)

-- ToggleTerm
keymap(n, "<C-p><C-p>", '<cmd>ToggleTerm direction=float size=20<CR>', opts)
keymap(n, "<C-p><C-h>", '<cmd>ToggleTerm direction=horizontal size=20<CR>', opts)
keymap(n, "<C-p><C-v>", '<cmd>ToggleTerm direction=vertical size=100<CR>', opts)

-- Nvim-Tree
keymap(n, "<leader>e", ":NvimTreeToggle<CR>:NvimTreeRefresh<CR>", opts) -- Refresh and toggle
