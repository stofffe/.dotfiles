local req = "mason"
local ok, mason = pcall(require, req)
if not ok then print("could not find require \"" .. req .. "\"") return end

local req = "mason-lspconfig"
local ok, mason_lspconfig = pcall(require, req)
if not ok then print("could not find require \"" .. req .. "\"") return end

local req = "mason-null-ls"
local ok, mason_null_ls = pcall(require, req)
if not ok then print("could not find require \"" .. req .. "\"") return end

-- Mason
mason.setup {
    ui = {
        icons = {
            package_installed = "✓"
        }
    }
}
-- Lspconfig
mason_lspconfig.setup {
    ensure_installed = { "sumneko_lua" },
}
-- Null-ls
mason_null_ls.setup({
    ensure_installed = nil,
    automatic_installation = true,
    automatic_setup = true
})
-- Dap?

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
local default_attach = function(client, bufnr)
    if client.name == "html" then
        client.server_capabilities.document_formatting = false
    end
    if client.name == "tsserver" then
        client.server_capabilities.document_formatting = false
    end
    lsp_keymaps(bufnr)
    lsp_highlight_document(client)
end

-- Automatically set up servers
mason_lspconfig.setup_handlers {
    function(server_name) -- default handler (optional)
        local ok, custom = pcall(require, "user.lsp.settings." .. server_name)
        if ok then
            require("lspconfig")[server_name].setup(custom)
            local config = require("user.lsp.settings." .. server_name)
            local on_attach = function(client, bufnr)
                default_attach(client, bufnr)
                if not (config.after_attach == nil) then
                    config.after_attach(client, bufnr)
                end
            end
            config.on_attach = on_attach
            require("lspconfig")[server_name].setup(config)
        else
            require("lspconfig")[server_name].setup({
                on_attach = default_attach
            })
        end
    end,

    -- Next, you can provide a dedicated handler for specific servers.
    ["rust_analyzer"] = function()
        require("user.lsp.extra.rust").setup(lsp_keymaps)
    end,
}
