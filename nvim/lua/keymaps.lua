vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit file" })
vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle file explorer" }) -- Refresh and toggle
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode" })
vim.keymap.set("x", "p", [["_dP]], { desc = "" })
-- vim.keymap.set("n", "<leader>f", "<cmd>Format<cr>", { desc = "Format file" })
-- vim.keymap.set("n", "<leader>v", "<cmd>vsplit<cr>", { desc = "Split window horizontally" })

vim.keymap.set("n", "tn", vim.cmd.tabnext, { desc = "[T]ab [N]ext" })
vim.keymap.set("n", "tc", vim.cmd.tabclose, { desc = "[T]ab [C]lose" })

local wrap = false
vim.keymap.set("n", "<leader>tw", function()
	wrap = not wrap
	vim.opt.wrap = wrap
end, { desc = "[T]oggle [W]rap" })

vim.keymap.set("i", "<C-j>", "<Down>", { desc = "Move left in insert mode" })
vim.keymap.set("i", "<C-k>", "<Up>", { desc = "Move right in insert mode" })
vim.keymap.set("i", "<C-h>", "<Left>", { desc = "Move left in insert mode" })
vim.keymap.set("i", "<C-l>", "<Right>", { desc = "Move right in insert mode" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Moves lines down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Moves lines up" })

vim.keymap.set("v", "<", "<gv", { desc = "Unindent and keep selection" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent and keep selection" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines without moving cursor" })

-- run selecetd lua
vim.keymap.set("v", "<leader>l", ":'<,'>lua<cr>", { desc = "Run selection in Lua" })

-- window navigation
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set("n", "<Up>", "<cmd>resize +2<cr>", { desc = "Increase window size vertically" })
vim.keymap.set("n", "<Down>", "<cmd>resize -2<cr>", { desc = "Decrease window size vertically" })
vim.keymap.set("n", "<Left>", "<cmd>vertical resize -2<cr>", { desc = "Increase window size horizontally" })
vim.keymap.set("n", "<Right>", "<cmd>vertical resize +2<cr>", { desc = "Decrease window size horizontally" })

-- quickfix
vim.keymap.set("n", "<leader>fn", "<cmd>cnext<cr>", { desc = "Quick[F]ix [N]ext item" })
vim.keymap.set("n", "<leader>fp", "<cmd>cprev<cr>", { desc = "Quick[F]ix [P]rev item" })
vim.keymap.set("n", "<leader>fo", "<cmd>copen<cr>", { desc = "Quick[F]ix [O]pen" })
vim.keymap.set("n", "<leader>fc", "<cmd>cclose<cr>", { desc = "Quick[F]ix: [C]lose" })
vim.keymap.set("n", "<leader>fd", "<cmd>cexpr []<cr>", { desc = "Quick[F]ix: [D]elete" })

local filter_qflist = function(type)
	local qf = vim.fn.getqflist()
	local filtered = {}

	for _, item in ipairs(qf) do
		if item.type == type then
			table.insert(filtered, item)
		end
	end

	vim.fn.setqflist(filtered, "r")
end

vim.keymap.set("n", "<leader>ffe", function()
	filter_qflist("e")
end, { desc = "Quick[F]ix [F]ilter [E]rrors" })
vim.keymap.set("n", "<leader>ffw", function()
	filter_qflist("w")
end, { desc = "Quick[F]ix [F]ilter [W]arnings" })
vim.keymap.set("n", "<leader>ffi", function()
	filter_qflist("i")
end, { desc = "Quick[F]ix [F]ilter [I]nfos" })
