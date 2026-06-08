require("options")
require("keymaps")
require("commands")
require("pack")
require("platform")

-- vim.lsp.handlers["$/progress"] = nil

-- -- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
	desc = "Highlight when yanking (copying) text",
})

local unset_ft_groups = {
	wgsl = "wgsl",
	wesl = "wgsl",
	templ = "templ",
	xaml = "xml",
}

-- Set filetypes

local set_ft_group = vim.api.nvim_create_augroup("set_filetype", { clear = true })
for suffix, filetype in pairs(unset_ft_groups) do
	vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
		group = set_ft_group,
		pattern = { "*." .. suffix },
		callback = function()
			vim.bo.filetype = filetype
		end,
	})
end

require("vim._core.ui2").enable({})
