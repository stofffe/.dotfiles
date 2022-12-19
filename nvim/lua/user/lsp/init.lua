local req = "lspconfig"
local ok, _ = pcall(require, req)
if not ok then print("could not find require \"" .. req .. "\"") return end

-- lsp
require("user.lsp.lsp-installer")
require("user.lsp.handlers").setup()

-- language specific plugins
require("user.lsp.extra.go")
require("user.lsp.extra.rust")

-- null ls diagnostics and formatting
require("user.lsp.null-ls")
