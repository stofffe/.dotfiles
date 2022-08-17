-- Autocmd to modify colorschemes
vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        vim.schedule(function()
            local colorscheme = vim.g.colors_name

            if colorscheme == "darkplus" then
                -- Remove reverse border on floating windows
                vim.cmd [[ highlight VertSplit gui=None cterm=None ]]
            end

            if colorscheme == "gruvbox" then
                -- Remove inside of floating window
                vim.cmd [[ highlight Pmenu guibg=NONE ctermfg=NONE ]]
            end
        end)
    end
})

vim.cmd [[
try
  colorscheme darkplus
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
endtry
]]
--
