vim.opt.shell = "pwsh"
vim.opt.shellcmdflag = "-nologo -noprofile -ExecutionPolicy RemoteSigned -command"
vim.opt.shellxquote = ""

vim.pack.add({
	{ src = "https://github.com/GustavEikaas/easy-dotnet.nvim" },
})

require("easy-dotnet").setup({
	lsp = {
		auto_refresh_codelens = false,
	},
})

local function open_path(path)
	local ext = path:match("^.+(%..+)$") -- get the file extension, e.g., ".cs" or ".xaml"

	local command = {
		"cmd",
		"/C",
		"start",
		"",
		path,
	}

	if ext == ".xaml" then
		local visual_studio_path =
			"C:\\Program Files\\Microsoft Visual Studio\\18\\Professional\\Common7\\IDE\\devenv.exe"
		command = {
			visual_studio_path,
			"/Edit",
			path,
		}
	end

	vim.fn.jobstart(command, { detach = true })
end

return {
	open_path = open_path,
}
