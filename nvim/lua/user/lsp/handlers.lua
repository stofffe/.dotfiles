local capabilities = vim.lsp.protocol.make_client_capabilities()

local req = "cmp_nvim_lsp"
local ok, cmp_nvim_lsp = pcall(require, req)
if not ok then print("could not find require \"" .. req .. "\"") return end
cmp_nvim_lsp.setup {
    capabilities = capabilities,
}

local setup = function()
    local signs = {
        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
    }

    for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
    end

    local config = {
        virtual_text = false,
        signs = { active = signs, },
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
            focusable = false,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
        },
    }
    vim.diagnostic.config(config)
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
    })
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
    })
end

-- Format command
vim.api.nvim_create_user_command("Format", function()
    vim.lsp.buf.format()
end, {})

-- Auto format on save
local autoFormatGroup = vim.api.nvim_create_augroup("lsp_auto_format", { clear = false })
local autoFormatId = vim.api.nvim_create_autocmd("BufWritePre", {
    command = "lua vim.lsp.buf.format()",
    group = autoFormatGroup,
})
vim.api.nvim_create_user_command("DisableAutoFormat", function()
    vim.api.nvim_del_autocmd(autoFormatId)
end, {})
vim.api.nvim_create_user_command("EnableAutoFormat", function()
    autoFormatId = vim.api.nvim_create_autocmd("BufWritePre", {
        command = "silent! lua vim.lsp.buf.format()",
        group = autoFormatGroup,
    })
end, {})

setup()



-- vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
-- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
-- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>f", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
