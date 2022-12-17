local lsp = require("lsp-zero")

lsp.preset("recommended")

-- CMP Config
local cmp = require("cmp")
-- local cmp_config = lsp.defaults.cmp_config({
cmp.setup({
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            -- Kind icons
            vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
            -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
            vim_item.menu = ({
                nvim_lsp = "[LSP]",
                nvim_lsp_signature_help = "[SIGNATURE]",
                nvim_lua = "[NVIM_LUA]",
                luasnip = "[Snippet]",
                buffer = "[Buffer]",
                path = "[Path]",
            })[entry.source.name]
            return vim_item
        end,
    },
    sources = {
        { name = "nvim_lsp" },
        { name = 'nvim_lsp_signature_help' },
        { name = "nvim_lua" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
    },
    confirm_opts = {
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
    },
    experimental = {
        ghost_text = false,
        native_menu = false,
    },
    window = {
        completion = cmp.config.window.bordered()
    }
})

-- cmp.setup(cmp_config)

-- CMP Mappings
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
    ["<C-j>"] = cmp.mapping.select_next_item(cmp_select),
    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
    ["<C-l>"] = cmp.mapping.close(),
})
lsp.setup_nvim_cmp({
    mapping = cmp_mappings
})

-- LSP Mappings
local lspconfig = require("lspconfig")
lsp.on_attach(function(client, bufnr)
    -- Custom setup
    local settings_path = "lsp.settings." .. client.name
    print(settings_path)
    local ok, conf = pcall(require, settings_path)
    if ok then
        lspconfig[client.name].setup(conf)
    end

    -- Binds
    local opts = { buffer = bufnr, remap = false }
    local bind = vim.keymap.set

    bind("n", "<leader>a", vim.lsp.buf.code_action, opts)
    bind("n", "K", vim.lsp.buf.hover, opts)
    bind("n", "<leader>rn", vim.lsp.buf.rename, opts)
    bind("n", "<leader>f", vim.lsp.buf.format, opts)
    bind("n", "<leader>t",
        function() vim.diagnostic.config({ virtual_text = not vim.diagnostic.config().virtual_text }) end, opts)
end)

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

-- Hightligth under cursor
local cursorHightlightGroup = vim.api.nvim_create_augroup("lsp_document_hightlight", { clear = false })
vim.api.nvim_create_autocmd("CursorHold", {
    command = "lua vim.lsp.buf.document_highlight()",
    group = cursorHightlightGroup
})
vim.api.nvim_create_autocmd("CursorMoved", {
    command = "lua vim.lsp.buf.clear_references()",
    group = cursorHightlightGroup,
})

lsp.setup()
