local status_ok, rust_tools = pcall(require, "rust-tools")
if not status_ok then
    return
end

local extension_path = vim.env.HOME .. '/.local/share/nvim/mason/packages/codelldb/extension'
local codelldb_path = extension_path .. 'adapter/codelldb'
local liblldb_path = extension_path .. 'lldb/lib/liblldb.dylib' -- MacOS: This may be .dylib otherwise .so

return {
    setup = function(lsp_keymaps)
        rust_tools.setup({
            server = {
                on_attach = function(_, bufnr)
                    -- Disable inlay hints
                    rust_tools.inlay_hints.disable()
                    vim.api.nvim_create_user_command("EnableInlineHints", function()
                        rust_tools.inlay_hints.enable()
                    end, {})
                    vim.api.nvim_create_user_command("DisableInlineHints", function()
                        rust_tools.inlay_hints.disable()
                    end, {})
                    -- Keymaps
                    lsp_keymaps(bufnr)
                    vim.keymap.set('n', '<leader>a', "<cmd>RustCodeAction<CR>", {})
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
            dap = {
                adapter = require('rust-tools.dap').get_codelldb_adapter(
                    codelldb_path, liblldb_path)
            },
            tools = {
                -- Custom here
            },
        })
    end
}

-- Run dap
-- while sleep 1; do codelldb --port 13000; done
