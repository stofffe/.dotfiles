-- go.nvim
local status_ok, go = pcall(require, "go")
if not status_ok then
    return
end

go.setup {
    lsp_inlay_hints = {
        enable = false,
    },
}

-- Run go fmt and import on save
vim.api.nvim_exec([[ autocmd BufWritePre *.go :silent! lua require('go.format').goimport() ]], false)
