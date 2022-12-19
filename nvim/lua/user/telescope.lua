local req = "telescope"
local ok, telescope = pcall(require, req)
if not ok then print("could not find require \"" .. req .. "\"") return end

-- Maps
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
keymap('n', "<leader>p",
    "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<CR>"
    , opts)
keymap('n', "<leader>P", "<cmd>lua require'telescope.builtin'.find_files()<CR>", opts)
keymap('n', "<leader>g", "<cmd>Telescope live_grep<CR>", opts)
keymap('n', "<leader>m", "<cmd>Telescope treesitter<CR>", opts)

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
