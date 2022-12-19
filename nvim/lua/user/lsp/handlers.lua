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

local function lsp_keymaps(bufnr)
    local opts = { noremap = true, silent = true }
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>a", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gl", '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>t",
        "<cmd>lua vim.diagnostic.config({virtual_text = not vim.diagnostic.config().virtual_text})<CR>", opts) -- toggle virtual text
end

-- Add document highlight if filetype supports it
local function lsp_highlight_document(client)
    local file_suffix = vim.fn.expand("%"):match("%.(.+)") -- get suffix
    -- Set autocommands conditional on server_capabilities
    if client.server_capabilities.documentHighlightProvider then
        local cursorHightlightGroup = vim.api.nvim_create_augroup("lsp_document_hightlight", { clear = false })
        vim.api.nvim_create_autocmd("CursorHold", {
            pattern = { "*." .. file_suffix },
            callback = function() vim.lsp.buf.document_highlight() end,
            group = cursorHightlightGroup
        })
        vim.api.nvim_create_autocmd("CursorMoved", {
            pattern = { "*." .. file_suffix },
            callback = function() vim.lsp.buf.clear_references() end,
            group = cursorHightlightGroup,
        })
    end
end

-- On attach
local on_attach = function(client, bufnr)
    print("attach")
    if client.name == "html" then
        client.server_capabilities.document_formatting = false
    end
    if client.name == "tsserver" then
        client.server_capabilities.document_formatting = false
    end
    if client.name == "rust-analyzer" then
        print("hello")
    end
    lsp_keymaps(bufnr)
    lsp_highlight_document(client)
end

-- Format command
vim.api.nvim_create_user_command("Format", function()
    vim.lsp.buf.format()
end, {})

-- Auto format on save
local autoFormatGroup = vim.api.nvim_create_augroup("lsp_document_hightlight", { clear = false })
local autoFormatId = vim.api.nvim_create_autocmd("BufWritePre", {
    command = "silent! lua vim.lsp.buf.formatting_sync()",
    group = autoFormatGroup,
})
vim.api.nvim_create_user_command("DisableAutoFormat", function()
    vim.api.nvim_del_autocmd(autoFormatId)
end, {})
vim.api.nvim_create_user_command("EnableAutoFormat", function()
    autoFormatId = vim.api.nvim_create_autocmd("BufWritePre", {
        command = "silent! lua vim.lsp.buf.formatting_sync()",
        group = autoFormatGroup,
    })
end, {})

return {
    setup = setup,
    on_attach = on_attach,
}




-- vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
-- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
-- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>f", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
