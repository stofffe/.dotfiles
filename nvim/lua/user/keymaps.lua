local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

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

-- Exit insert mode with jk
keymap(i, "jk", "<Esc>", opts)

-- Move left/right in insert mode
keymap(i, "<C-h>", "<Left>", opts)
keymap(i, "<C-l>", "<Right>", opts)

-- Copy to clipboard
keymap(v, "<Leader>y", '"*y', opts)
keymap(V, "<Leader>y", '"*y', opts)

-- Quickfix
keymap(n, "<leader>cn", "<cmd>cnext<CR>", opts)
keymap(n, "<leader>cp", "<cmd>cprevious<CR>", opts)
keymap(n, "<leader>cr", "<cmd>call setqflist([])<CR>", opts)

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

-- Nvim-Tree

-- Rust
