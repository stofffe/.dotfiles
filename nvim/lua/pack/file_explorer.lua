local platform = require("platform")

require("neo-tree").setup({
    hide_root_node = true,
    window = {
        width = 35,
    },
    filesystem = {
        window = {
            mappings = {
                -- Remap navigations
                ["h"] = "close_node",
                ["l"] = "open", -- or "open" or “toggle_node” depending on your preference
                ["s"] = "open_split",
                ["v"] = "open_vsplit",
                ["<leader>o"] = function(state)
                    local node = state.tree:get_node()
                    if not node then
                        return
                    end
                    local path = node:get_id()

                    platform.open_path(path)
                end,
                ["Y"] = function(state)
                    local node = state.tree:get_node()
                    if not node or not node.path then
                        return
                    end

                    -- Yank the file path to system clipboard
                    vim.fn.setreg("+", node.path)
                    print("Copied to system clipboard: " .. node.path)
                end,
            },
        },
    },
    event_handlers = {
        {
            event = "file_opened",
            handler = function(_)
                require("neo-tree.command").execute({ action = "close" })
            end,
        },
    },
})
