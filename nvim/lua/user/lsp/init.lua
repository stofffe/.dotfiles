local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
    return
end

-- lsp
require("user.lsp.lsp-installer")
require("user.lsp.handlers").setup()

-- language specific plugins
require("user.lsp.extra.go")
require("user.lsp.extra.rust")

-- null ls diagnostics and formatting
require("user.lsp.null-ls")
