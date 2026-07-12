local term = require("toggleterm")
term.setup({
	shade_terminals = false,
})

vim.keymap.set({ "n", "t" }, "<leader>tt", term.toggle, { desc = "[T]oggle [T]erminal" })
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], {})
vim.keymap.set("t", "jk", [[<C-\><C-n>]], {})
