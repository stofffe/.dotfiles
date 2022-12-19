local req = "lspconfig"
local ok, _ = pcall(require, req)
if not ok then print("could not find require \"" .. req .. "\"") return end

-- lsp
require("user.lsp.lsp-installer")
require("user.lsp.handlers").setup()

-- language specific plugins

-- null ls diagnostics and formatting
require("user.lsp.null-ls")
