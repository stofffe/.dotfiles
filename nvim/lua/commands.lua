local platform = require("platform")

-- Open current file

vim.keymap.set("n", "<leader>o", function()
	local path = vim.fn.expand("%:p") -- full path of current file
	platform.open_path(path)
end, { desc = "[O]pen current path" })

-- Toggle between two suffixes in the current buffer

local function toggle_suffix(suffix_a, suffix_b)
	local file = vim.fn.expand("%:p") -- full path
	local target = nil

	if file:match("%" .. suffix_a .. "$") then
		-- suffix_a -> suffix_b
		target = file:gsub("%" .. suffix_a .. "$", suffix_b)
	elseif file:match("%" .. suffix_b .. "$") then
		-- suffix_b -> suffix_a
		target = file:gsub("%" .. suffix_b .. "$", suffix_a)
	else
		vim.notify("Not a " .. suffix_a .. " or " .. suffix_b .. " file", vim.log.levels.WARN)
		return
	end

	if vim.fn.filereadable(target) == 1 then
		vim.cmd("edit " .. target)
	else
		vim.notify("No matching file found: " .. target, vim.log.levels.WARN)
	end
end

-- setup buffer-local keymap for two suffixes
local function setup_toggle_file_keymap(suffix_a, suffix_b, key)
	vim.api.nvim_create_autocmd("BufEnter", {
		pattern = { "*" .. suffix_a, "*" .. suffix_b },
		callback = function()
			vim.keymap.set("n", key or "<leader>h", function()
				toggle_suffix(suffix_a, suffix_b)
			end, { buffer = true, desc = "Toggle between " .. suffix_a .. " and " .. suffix_b, silent = true })
		end,
	})
end

-- Example usage for XAML and XAML.CS
-- setup_toggle_file_keymap(".xaml", ".xaml.cs", "<leader>h")
setup_toggle_file_keymap(".xaml", "Model.cs", "<leader>h")
setup_toggle_file_keymap(".templ", "_templ.go", "<leader>h")

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = { "*View.xaml", "*ViewModel.cs" },
	callback = function()
		vim.keymap.set("n", "<leader>h", function()
			local file = vim.fn.expand("%:p") -- full path
			local target = nil

			if file:match("View.xaml") then
				-- suffix_a -> suffix_b
				target = file:gsub("View", "ViewModel")
				target = target:gsub("%.xaml", ".cs")
			elseif file:match("ViewModel.cs") then
				-- suffix_b -> suffix_a
				target = file:gsub("ViewModel", "View")
				target = target:gsub("%.cs$", ".xaml")
			else
				vim.notify("Not a View.xaml or ViewModel.cs file", vim.log.levels.WARN)
				return
			end

			if vim.fn.filereadable(target) == 1 then
				vim.cmd("edit " .. target)
			else
				vim.notify("No matching file found: " .. target, vim.log.levels.WARN)
			end
		end, { buffer = true, desc = "Toggle between View.xaml and ViewModel.cs", silent = true })
	end,
})
