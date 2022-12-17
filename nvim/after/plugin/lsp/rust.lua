local rust_tools = require("rust-tools")

vim.cmd [[ command! RustEnableInlineHints execute 'lua require("rust-tools").inlay_hints.enable()' ]]
vim.cmd [[ command! RustDisableInlineHints execute 'lua require("rust-tools").inlay_hints.disable()' ]]

rust_tools.setup({
    server = {
        on_attach = function(_, bufnr)
        end,
    },
    tools = {}
})
