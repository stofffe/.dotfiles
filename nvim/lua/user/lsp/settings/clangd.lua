return {
    after_attach = function(client, bufnr)
        local opts = { remap = false, silent = true, buffer = bufnr }
        vim.keymap.set('n', '<leader>h', function()
            --[[ vim.api.nvim_cmd("ClangdSwitchSourceHeader") ]]
            vim.cmd "ClangdSwitchSourceHeader"
        end, opts)
    end
}
