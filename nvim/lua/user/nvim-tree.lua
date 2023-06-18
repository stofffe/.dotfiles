local req = "nvim-tree"
local ok, nvim_tree = pcall(require, req)
if not ok then
    print("could not find require \"" .. req .. "\"")
    return
end

-- global maps
local opts = { noremap = true, silent = true }
vim.keymap.set('n', "<leader>e", ":NvimTreeToggle<CR>:NvimTreeRefresh<CR>", opts) -- Refresh and toggle

-- specific maps in file tree
local function on_attach(bufnr)
    local api = require('nvim-tree.api')

    local function opts(desc)
        return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- You will need to insert "your code goes here" for any mappings with a custom action_cb
    vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
    vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
    vim.keymap.set('n', 'o', api.node.open.edit, opts('Open'))
    vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Close Directory'))
    vim.keymap.set('n', 'v', api.node.open.vertical, opts('Open: Vertical Split'))
end


-- Setup
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
        side = "left",
        number = false,
        relativenumber = false,
    },
    renderer = {
        root_folder_label = false,
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
    on_attach = on_attach,
}
