local req = "telescope"
local ok, telescope = pcall(require, req)
if not ok then print("could not find require \"" .. req .. "\"") return end

-- Maps
local builtin = require("telescope.builtin")
local themes = require("telescope.themes")
vim.keymap.set('n', '<leader>P', builtin.find_files)
vim.keymap.set('n', '<leader>p', function() builtin.find_files(themes.get_dropdown({ previewer = false })) end)
vim.keymap.set('n', '<leader>g', builtin.live_grep)
vim.keymap.set('n', '<leader>n', builtin.grep_string)
vim.keymap.set('n', '<leader>m', builtin.diagnostics)
vim.keymap.set('n', '<leader>/', function()
    builtin.current_buffer_fuzzy_find(themes.get_dropdown {
        winblend = 10,
        previewer = false,
    })
end)

-- Setup
local actions = require("telescope.actions")
telescope.setup {
    defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        path_display = { "smart" },

        mappings = { i = {
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-p>"] = actions.cycle_history_prev,

            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,

            ["<Esc>"] = actions.close,

            ["<CR>"] = actions.select_default,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,

            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,

            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            ['<C-q>'] = actions.smart_add_to_qflist + actions.open_qflist,
            ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
        }, n = {
            ["<leader>p"] = actions.close,
            ["<Esc>"] = actions.close,

            ["<CR>"] = actions.select_default,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,

            ["gg"] = actions.move_to_top,
            ["G"] = actions.move_to_bottom,

            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,

            ["?"] = actions.which_key,

            ['<leader>ca'] = actions.smart_add_to_qflist + actions.open_qflist, -- Send selected to qflist

        } },
    },
}

-- ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
-- ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
-- ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
-- ["<C-l>"] = actions.complete_tag,
