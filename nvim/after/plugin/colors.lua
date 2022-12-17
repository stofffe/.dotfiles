function SetColorScheme(color)
    color = color or "darkplus"
    vim.cmd.colorscheme(color)
end

SetColorScheme()
