vim.opt.shell = "pwsh"
vim.opt.shellcmdflag = "-nologo -noprofile -ExecutionPolicy RemoteSigned -command"
vim.opt.shellxquote = ""

-- lazy load easy dotnet
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "cs" },
	once = true,
	callback = function()
		vim.pack.add({
			{ src = "https://github.com/GustavEikaas/easy-dotnet.nvim" },
		})

		require("easy-dotnet").setup({
			lsp = {
				auto_refresh_codelens = false,
				restart_roslyn_on_branch_change = true,
			},
		})
	end,
})

-- native file/foler open
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
