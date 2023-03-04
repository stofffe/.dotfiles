-- Autocmd to modify colorschemes
vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        vim.schedule(function()
            local colorscheme = vim.g.colors_name

            if colorscheme == "darkplus" then
                -- Remove reverse border on floating windows
                vim.cmd [[ highlight VertSplit gui=None cterm=None ]]

                -- React
                vim.api.nvim_set_hl(0, "typescriptCall", { link = "cleared" })
            end

            if colorscheme == "gruvbox" then
                -- Remove inside of floating window
                vim.cmd [[ highlight Pmenu guibg=NONE ctermfg=NONE ]]
            end
        end)
    end
})

-- Set default colorscheme
function DefautlColorScheme(color)
    color = color or "darkplus"
    vim.cmd.colorscheme(color)
end

DefautlColorScheme()
