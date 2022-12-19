local status_ok, rust_tools = pcall(require, "rust-tools")
if not status_ok then
    return
end


return {
    setup = function(lsp_keymaps)
        rust_tools.setup({
            server = {
                on_attach = function(_, bufnr)
                    -- Rust specific commands
                    vim.api.nvim_create_user_command("RustEnableInlineHints", function()
                        rust_tools.inlay_hints.enable()
                    end, {})
                    vim.api.nvim_create_user_command("RustDisableInlineHints", function()
                        rust_tools.inlay_hints.disable()
                    end, {})
                    lsp_keymaps(bufnr)

                end,
                settings = {
                    ["rust-analyzer"] = {
                        completion = {
                            postfix = {
                                enable = false
                            }
                        },
                        checkOnSave = {
                            command = "clippy",
                            allFeatures = true,
                            overrideCommand = {
                                'cargo', 'clippy', '--workspace', '--message-format=json',
                                '--all-targets', '--all-features'
                            }
                        },
                    }
                }
            },
            tools = {
                -- Custom here
            },
        })
    end
}
