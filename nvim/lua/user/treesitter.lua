local req = "nvim-treesitter.configs"
local ok, configs = pcall(require, req)
if not ok then print("could not find require \"" .. req .. "\"") return end

configs.setup {
    ensure_installed = { "go", "rust", "lua" },
    sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
    highlight = {
        enable = true, -- false will disable the whole extension
        additional_vim_regex_highlighting = true,
    },
    indent = { enable = true, disable = { "yaml" } },
    -- Plugin specific
    autopairs = { enable = true },
    context_commentstring = {
        enable = true,
        enable_autocmd = false,
    },
}

-- Install language if not installed
local ask_install = {}
function _G.ensure_treesitter_language_installed()
    local parsers = require "nvim-treesitter.parsers"
    local lang = parsers.get_buf_lang()
    if parsers.get_parser_configs()[lang] and not parsers.has_parser(lang) and ask_install[lang] ~= false then
        vim.schedule_wrap(function()
            vim.ui.select({ "yes", "no" }, { prompt = "Install tree-sitter parsers for " .. lang .. "?" },
                function(item)
                    if item == "yes" then
                        vim.cmd("TSInstall " .. lang)
                    elseif item == "no" then
                        ask_install[lang] = false
                    end
                end)
        end)()
    end
end

vim.api.nvim_create_autocmd("FileType", {
    callback = function() ensure_treesitter_language_installed() end
})
