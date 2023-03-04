local req = "null-ls"
local ok, null_ls = pcall(require, req)
if not ok then print("could not find require \"" .. req .. "\"") return end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup {
    debug = false,
    sources = {
        formatting.prettier.with({ extra_args = {
            "--no-semi", "--single-quote", "--jsx-single-quote", "--tab-width 4", "--use-tabs"
        } }),
        formatting.goimports,
        --[[ formatting.clang_format.with({}), ]]
    },
}
