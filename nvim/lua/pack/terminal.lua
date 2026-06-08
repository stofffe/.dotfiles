local term = require("toggleterm")
term.setup({
	shade_terminals = false,
})

vim.keymap.set({ "n", "t" }, "<leader>t", term.toggle, { desc = "[T]oggle terminal" })
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], {})
vim.keymap.set("t", "jk", [[<C-\><C-n>]], {})
