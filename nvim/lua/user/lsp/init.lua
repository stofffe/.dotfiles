local req = "lspconfig"
local ok, _ = pcall(require, req)
if not ok then print("could not find require \"" .. req .. "\"") return end

-- lsp
require("user.lsp.null-ls")
require("user.lsp.mason")
require("user.lsp.handlers")

-- language specific plugins

-- null ls diagnostics and formatting
