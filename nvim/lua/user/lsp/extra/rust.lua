local status_ok, rust_tools = pcall(require, "rust-tools")
if not status_ok then
    return
end

vim.cmd [[ command! RustEnableInlineHints execute 'lua require("rust-tools").inlay_hints.enable()' ]]
vim.cmd [[ command! RustDisableInlineHints execute 'lua require("rust-tools").inlay_hints.disable()' ]]

rust_tools.setup({
    server = {
        on_attach = function(_, bufnr)
            -- have not gotten keymaps to work here
        end,
    },
    tools = {
        -- Custom here
    }
})
