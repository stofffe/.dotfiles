local req = "nvim-tree"
local ok, nvim_tree = pcall(require, req)
if not ok then print("could not find require \"" .. req .. "\"") return end

-- Maps
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
keymap('n', "<leader>e", ":NvimTreeToggle<CR>:NvimTreeRefresh<CR>", opts) -- Refresh and toggle

-- Setup
local tree_cb = require("nvim-tree.config").nvim_tree_callback
nvim_tree.setup {
    disable_netrw = true,
    hijack_netrw = true,
    open_on_setup = false,
    open_on_tab = false,
    hijack_cursor = false,
    diagnostics = {
        enable = true,
        show_on_dirs = true,
        icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
        },
    },
    git = {
        enable = true,
        ignore = true,
        timeout = 500,
    },
    filters = { dotfiles = true, },
    actions = {
        open_file = {
            resize_window = true,
        },
    },
    view = {
        width = 30,
        hide_root_folder = true,
        side = "left",
        mappings = {
            custom_only = false,
            list = {
                { key = { "l", "<CR>", "o" }, cb = tree_cb "edit" },
                { key = "h", cb = tree_cb "close_node" },
                { key = "v", cb = tree_cb "vsplit" },
            },
        },
        number = false,
        relativenumber = false,
    },
    renderer = {
        icons = {
            show = {
                folder = true,
                folder_arrow = true,
                git = true,
            },
            glyphs = {
                default = "",
                symlink = "",
                folder = {
                    arrow_closed = "",
                    arrow_open = "",
                    default = "",
                    open = "",
                    empty = "",
                    empty_open = "",
                    symlink = "",
                    symlink_open = "",
                },
                git = {
                    unstaged = "",
                    staged = "S",
                    unmerged = "",
                    renamed = "➜",
                    untracked = "U",
                    deleted = "",
                    ignored = "◌",
                },
            },
        }
    },
}
