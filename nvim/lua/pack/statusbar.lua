local empty_theme = {
	a = { fg = "NONE", bg = "NONE" },
	b = { fg = "NONE", bg = "NONE" },
	c = { fg = "NONE", bg = "NONE" },
}

require("lualine").setup({
	sections = {
		lualine_c = {
			{ "filename", path = 1 },
		},
	},
	options = {
		theme = {
			normal = empty_theme,
			insert = empty_theme,
			visual = empty_theme,
			replace = empty_theme,
			command = empty_theme,
			inactive = empty_theme,
		},
		section_separators = "",
		component_separators = "",
	},
})

vim.api.nvim_create_user_command("LualineToggle", function()
	if vim.o.laststatus == 0 then
		vim.o.laststatus = 3 -- show lualine
	else
		vim.o.laststatus = 0 -- hide lualine
	end
end, { desc = "Toggle Lualine" })
