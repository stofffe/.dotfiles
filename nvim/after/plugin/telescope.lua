local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>p', builtin.find_files, {})
vim.keymap.set('n', '<leader>g', builtin.live_grep, {})

local telescope = require("telescope")
local actions = require("telescope.actions")
telescope.setup{
	defaults = {
        path_display = { "smart" }, 
        mappings = {
            i = {
                ["<Esc>"] = actions.close,
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<C-h>"] = "which_key",
            },
            n = {

            },
        }
	},
	pickers = {},
	extensions = {}
}
