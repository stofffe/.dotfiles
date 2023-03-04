local opts = { remap = false, silent = true }

-- Space to leader
vim.keymap.set("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "

-- Vsplit
vim.keymap.set("n", "<leader>v", "<cmd>vsplit<CR>", opts)

-- Move lines Mac specfic
vim.keymap.set("n", "√", "<cmd>move +1<CR>", opts)
vim.keymap.set("n", "ª", "<cmd>move -2<CR>", opts)
vim.cmd "vnoremap √ :m '>+1<CR>gv=gv"
vim.cmd "vnoremap ª :m '<-2<CR>gv=gv"

-- Exit insert mode with jk
vim.keymap.set('i', 'jk', '<Esc>', opts)
vim.keymap.set('i', "jk", "<Esc>", opts)

-- Move left/right in insert mode
vim.keymap.set('i', "<C-h>", "<Left>", opts)
vim.keymap.set('i', "<C-l>", "<Right>", opts)

-- Execute macros
vim.keymap.set({ 'n', 'i' }, "<C-q>", "@q", opts)

-- Copy to clipboard
vim.keymap.set('v', "<Leader>y", '"*y', opts)

-- Keep buffer when pasting
vim.keymap.set("x", "p", [["_dP]], opts)

-- Normal --
-- Format and save
vim.keymap.set('n', "<leader>f", ":Format<cr>", opts)
vim.keymap.set('n', "<leader>s", ":w<cr>", opts)
vim.keymap.set('n', "<leader>q", ":q<cr>", opts)

-- Better window navigation
vim.keymap.set('n', "<C-h>", "<C-w>h", opts)
vim.keymap.set('n', "<C-j>", "<C-w>j", opts)
vim.keymap.set('n', "<C-k>", "<C-w>k", opts)
vim.keymap.set('n', "<C-l>", "<C-w>l", opts)

-- Resize with arrows
vim.keymap.set('n', "<S-Up>", ":resize +2<CR>", opts)
vim.keymap.set('n', "<S-Down>", ":resize -2<CR>", opts)
vim.keymap.set('n', "<S-Left>", ":vertical resize -2<CR>", opts)
vim.keymap.set('n', "<S-Right>", ":vertical resize +2<CR>", opts)

-- Quickfix
--[[ vim.keymap.set('n', "<leader>cn", "<cmd>cnext<CR>", opts) ]]
--[[ vim.keymap.set('n', "<leader>cp", "<cmd>cprevious<CR>", opts) ]]
--[[ vim.keymap.set('n', "<leader>cr", "<cmd>call setqflist([])<CR>", opts) ]]
--[[ vim.keymap.set('n', "<leader>cr", "<cmd>call setqflist([])<CR>", opts) ]]
--[[ vim.keymap.set('n', "<leader>cr", "<cmd>call setqflist([])<CR>", opts) ]]
--[[ vim.keymap.set('n', "<leader>cr", "<cmd>call setqflist([])<CR>", opts) ]]
--[[ vim.keymap.set('n', "<leader>cr", "<cmd>call setqflist([])<CR>", opts) ]]
--[[ vim.keymap.set('n', "<leader>cr", "<cmd>call setqflist([])<CR>", opts) ]]
--[[ vim.keymap.set('n', "<leader>cr", "<cmd>call setqflist([])<CR>", opts) ]]
--[[ vim.keymap.set('n', "<leader>cr", "<cmd>call setqflist([])<CR>", opts) ]]
--[[ vim.keymap.set('n', "<leader>cr", "<cmd>call setqflist([])<CR>", opts) ]]
--[[ vim.keymap.set('n', "<leader>cr", "<cmd>call setqflist([])<CR>", opts) ]]
--[[ vim.keymap.set('n', "<leader>cr", "<cmd>call setqflist([])<CR>", opts) ]]
--[[ vim.keymap.set('n', "<leader>cr", "<cmd>call setqflist([])<CR>", opts) ]]
--[[ vim.keymap.set('n', "<leader>cr", "<cmd>call setqflist([])<CR>", opts) ]]
--[[ vim.keymap.set('n', "<leader>cr", "<cmd>call setqflist([])<CR>", opts) ]]
--[[ vim.keymap.set('n', "<leader>cr", "<cmd>call setqflist([])<CR>", opts) ]]
--[[ vim.keymap.set('n', "<leader>cr", "<cmd>call setqflist([])<CR>", opts) ]]
--[[ vim.keymap.set('n', "<leader>cr", "<cmd>call setqflist([])<CR>", opts) ]]
--[[ vim.keymap.set('n', "<leader>cr", "<cmd>call setqflist([])<CR>", opts) ]]
--[[ vim.keymap.set('n', "<leader>cr", "<cmd>call setqflist([])<CR>", opts) ]]
