vim.g.mapleader = " "
local opts = { silent = true, noremap = true }
local keymap = vim.keymap.set

keymap("n", "<leader>s", ":w<CR>", opts)
keymap("n", "<leader>q", ":q<CR>", opts)
keymap("i", "jk", "<Esc>", opts)
keymap("v", "<Leader>y", '"*y', opts)
