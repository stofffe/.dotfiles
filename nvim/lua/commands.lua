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

--
-- Terminal
--

-- local state = {
-- 	floating = {
-- 		buf = -1,
-- 		win = -1,
-- 	},
-- }
--
-- local function create_floating_window(opts)
-- 	opts = opts or {}
-- 	local width = opts.width or math.floor(vim.o.columns * 0.8)
-- 	local height = opts.height or math.floor(vim.o.lines * 0.8)
--
-- 	-- Calculate the position to center the window
-- 	local col = math.floor((vim.o.columns - width) / 2)
-- 	local row = math.floor((vim.o.lines - height) / 2)
--
-- 	-- Create a buffer
-- 	local buf = nil
-- 	if vim.api.nvim_buf_is_valid(opts.buf) then
-- 		buf = opts.buf
-- 	else
-- 		buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
-- 	end
--
-- 	-- Define window configuration
-- 	local win_config = {
-- 		relative = "editor",
-- 		width = width,
-- 		height = height,
-- 		col = col,
-- 		row = row,
-- 		style = "minimal", -- No borders or extra UI elements
-- 		border = "rounded",
-- 	}
--
-- 	-- Create the floating window
-- 	local win = vim.api.nvim_open_win(buf, true, win_config)
--
-- 	return { buf = buf, win = win }
-- end
--
-- local toggle_terminal = function()
-- 	if not vim.api.nvim_win_is_valid(state.floating.win) then
-- 		state.floating = create_floating_window({ buf = state.floating.buf })
-- 		if vim.bo[state.floating.buf].buftype ~= "terminal" then
-- 			vim.cmd.terminal()
-- 		end
-- 	else
-- 		vim.api.nvim_win_hide(state.floating.win)
-- 	end
-- end
--
-- vim.api.nvim_create_user_command("Floaterminal", toggle_terminal, {})
--
-- vim.keymap.set({ "n", "t" }, "<leader>t", toggle_terminal, { desc = "[T]oggle terminal" })
-- vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], {})
-- vim.keymap.set("t", "jk", [[<C-\><C-n>]], {})
--
-- -- local active_term = -1
-- -- vim.api.nvim_create_autocmd("TermOpen", {
-- -- 	group = vim.api.nvim_create_augroup("terminal-opts", { clear = true }),
-- -- 	callback = function(info)
-- -- 		vim.opt.number = false
-- -- 		vim.opt.relativenumber = false
-- --
-- -- 		active_term = info.buf
-- -- 	end,
-- -- })
-- -- vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], {})
-- -- vim.keymap.set("t", "jk", [[<C-\><C-n>]], {})
-- -- vim.keymap.set("t", "<leader>t", vim.cmd.q, {})
-- -- vim.keymap.set("n", "<leader>t", function()
-- -- 	local terminal_open = false
-- -- 	local terminal_win = -1
-- --
-- -- 	local open_win = vim.api.nvim_list_wins()
-- -- 	for _, win in pairs(open_win) do
-- -- 		local bufnr = vim.api.nvim_win_get_buf(win)
-- -- 		if bufnr == active_term then
-- -- 			terminal_open = true
-- -- 			terminal_win = win
-- -- 		end
-- -- 	end
-- --
-- -- 	if terminal_open then
-- -- 		if vim.api.nvim_get_current_win() == terminal_win then
-- -- 			vim.api.nvim_win_close(terminal_win, true)
-- -- 		else
-- -- 			vim.api.nvim_set_current_win(terminal_win)
-- -- 		end
-- -- 	else
-- -- 		if active_term == -1 then
-- -- 			vim.cmd.split()
-- -- 			vim.cmd.term()
-- -- 		else
-- -- 			vim.cmd.split()
-- -- 			vim.cmd.buffer(active_term)
-- -- 		end
-- -- 		vim.cmd.wincmd("J")
-- -- 		vim.api.nvim_win_set_height(0, 15)
-- -- 		vim.cmd.startinsert()
-- -- 	end
-- -- end, {})
