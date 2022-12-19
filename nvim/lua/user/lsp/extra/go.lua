local req = "go"
local ok, go = pcall(require, req)
if not ok then print("could not find require \"" .. req .. "\"") return end

go.setup {
    lsp_inlay_hints = {
        enable = false,
    },
}

-- Run go fmt and import on save
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.go" },
    callback = function()
        require('go.format').goimport()
    end
})
