local req = "mason"
local ok, mason = pcall(require, req)
if not ok then print("could not find require \"" .. req .. "\"") return end

local req = "mason-lspconfig"
local ok, mason_lspconfig = pcall(require, req)
if not ok then print("could not find require \"" .. req .. "\"") return end

-- mason
mason.setup {
    ui = {
        icons = {
            package_installed = "✓"
        }
    }
}
mason_lspconfig.setup {
    ensure_installed = { "sumneko_lua" },
}

mason_lspconfig.setup_handlers {
    function(server_name) -- default handler (optional)
        if pcall(require, "user.lsp.settings." .. server_name) then
            require("lspconfig")[server_name].setup(require("user.lsp.settings." .. server_name))
        else
            require("lspconfig")[server_name].setup({})
        end

    end,
    -- Next, you can provide a dedicated handler for specific servers.
    ["rust_analyzer"] = function()
        require("user.lsp.extra.rust")
    end
}
