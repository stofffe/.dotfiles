local actions = require("telescope.actions")
require("telescope").setup({
    defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        path_display = { "smart" },

        mappings = {
            i = {
                ["<Esc>"] = actions.close,
                ["jk"] = actions.close,
                ["<CR>"] = actions.select_default,
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,

                ["<C-h>"] = actions.select_horizontal,
                ["<C-s>"] = actions.select_vertical, -- should be v but gets blocked on windows

                ["<C-u>"] = actions.preview_scrolling_up,
                ["<C-d>"] = actions.preview_scrolling_down,

                ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                ["<C-q>"] = actions.smart_add_to_qflist + actions.open_qflist,
            },
            n = {
                ["<Esc>"] = actions.close,
                ["q"] = actions.close,
            },
        },
    },
})

-- See `:help telescope.builtin`
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
vim.keymap.set("n", "<leader>f", builtin.find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "fS]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set("n", "<leader>sm", function()
    builtin.lsp_document_symbols({
        symbols = { "Function", "Method" },
    })
end, { desc = "[S]earch [M]ethods in Document" })
vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

-- diagnostics
local severity = vim.diagnostic.severity
vim.keymap.set("n", "<leader>d", builtin.diagnostics, { desc = "[D]iagnostics" })
vim.keymap.set("n", "<leader>de", function() builtin.diagnostics({ severity = severity.ERROR }) end, { desc = "[D]iagnostics: [E]rrors" })
vim.keymap.set("n", "<leader>dw", function() builtin.diagnostics({ severity = severity.WARN }) end, { desc = "[D]iagnostics: [W]arnings" })
vim.keymap.set("n", "<leader>di", function() builtin.diagnostics({ severity = severity.INFO }) end, { desc = "[D]iagnostics: [I]nfos" })
vim.keymap.set("n", "<leader>dh", function() builtin.diagnostics({ severity = severity.HINT }) end, { desc = "[D]iagnostics: [H]ints" })

-- Fuzzy search current buffer
vim.keymap.set( "n", "<leader>/", builtin.current_buffer_fuzzy_find, { desc = "[/] Fuzzily search in current buffe" })

-- Shortcut for searching your neovim configuration files
vim.keymap.set("n", "<leader>sn", function()
    builtin.find_files({ cwd = vim.fn.stdpath("config") })
end, { desc = "[S]earch [N]eovim files" })

vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { link = "TelescopeTitle" })
vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { link = "TelescopeTitle" })
vim.api.nvim_set_hl(0, "TelescopePromptTitle", { link = "TelescopeTitle" })
