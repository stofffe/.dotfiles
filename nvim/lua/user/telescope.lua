local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
    return
end

local actions = require "telescope.actions"


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

            -- ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            -- ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            -- ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            -- ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            -- ["<C-l>"] = actions.complete_tag,
            -- ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
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

            -- ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            -- ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            -- ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            -- ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

            -- ["j"] = actions.move_selection_next,
            -- ["k"] = actions.move_selection_previous,
            -- ["H"] = actions.move_to_top,
            -- ["M"] = actions.move_to_middle,
            -- ["L"] = actions.move_to_bottom,

            -- ["<Down>"] = actions.move_selection_next,
            -- ["<Up>"] = actions.move_selection_previous,
        },
        },
    },
    pickers = {
        -- Default configuration for builtin pickers goes here:
        -- picker_name = {
        --   picker_config_key = value,
        --   ...
        -- }
        -- Now the picker_config_key will be applied every time you call this
        -- builtin picker
    },
    extensions = {
    },
}

-- Uberzug not supported on macos
-- Enable previewing media files
--[[ telescope.load_extension('media_files') ]]
-- media_files = {
-- -- filetypes whitelist
-- -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
--[[     filetypes = { "png", "webp", "jpg", "jpeg" }, ]]
--[[     find_cmd = "rg" -- find command (defaults to `fd`) ]]
--[[ }, ]]
