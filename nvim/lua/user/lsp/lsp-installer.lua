local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
    return
end

local allowed = { "rust_analyzer", "jsonls", "sumneko_lua", "svelte", "gopls"}

-- Register a handler that will be called for all installed servers.
-- Alternatively, you may also register handlers on specific server instances instead (see example below).
lsp_installer.on_server_ready(function(server)
    local opts = {
        on_attach = require("user.lsp.handlers").on_attach,
        capabilities = require("user.lsp.handlers").capabilities,
    }

    for _, server_name in ipairs(allowed) do
        if server.name == server_name then
            local lang_opts = require("user.lsp.settings." .. server.name)
            opts = vim.tbl_deep_extend("force", lang_opts, opts)
        end
    end
    -- This setup() function is exactly the same as lspconfig's setup function.
    -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    server:setup(opts)
end)



-- if server.name == "rust_analyzer" then
--     local rust_analyzer_opts = require("user.lsp.settings.rust_analyzer")
--     opts = vim.tbl_deep_extend("force", rust_analyzer_opts, opts)
-- end
--
-- if server.name == "jsonls" then
--     local jsonls_opts = require("user.lsp.settings.jsonls")
--     opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
-- end
--
-- if server.name == "sumneko_lua" then
--     local sumneko_opts = require("user.lsp.settings.sumneko_lua")
--     opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
-- end
