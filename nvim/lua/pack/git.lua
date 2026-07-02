require("gitsigns").setup({
	signs = {
		add = { text = "+" },
		change = { text = "~" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
	},
})

require("diffview").setup({})

local neogit = require("neogit")

neogit.setup({
	status = {
		["<leader>"] = "Toggle",
	},
	kind = "replace",
})

vim.keymap.set("n", "<leader>go", function()
	neogit.open({ kind = "tab" })
end, { desc = "Neo[G]git [O]pen" })

vim.api.nvim_set_hl(0, "NeogitDiffAdd", { link = "@comment" })
vim.api.nvim_set_hl(0, "NeogitDiffAddHighlight", { link = "@comment" })
vim.api.nvim_set_hl(0, "NeogitDiffAddCursor", { link = "@comment" })

vim.api.nvim_set_hl(0, "NeogitDiffDelete", { link = "@comment.error" })
vim.api.nvim_set_hl(0, "NeogitDiffDeleteHighlight", { link = "@comment.error" })
vim.api.nvim_set_hl(0, "NeogitDiffDeleteCursor", { link = "@comment.error" })

vim.api.nvim_set_hl(0, "NeogitDiffContext", { link = "None" })
vim.api.nvim_set_hl(0, "NeogitDiffContextHighlight", { link = "None" })
vim.api.nvim_set_hl(0, "NeogitDiffContextCursor", { link = "None" })

vim.api.nvim_set_hl(0, "NeogitHunkHeaderHighlight", { link = "NeogitHunkHeader" })
vim.api.nvim_set_hl(0, "NeogitHunkHeaderCursor", { link = "NeogitHunkHeader" })

--
-- Worktrees
--

local worktree_picker = function(title, get_lines, parse_line)
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values

	local lines = get_lines()

	pickers
		.new({}, {
			prompt_title = title,
			finder = finders.new_table({
				results = lines,
			}),
			sorter = conf.generic_sorter({}),

			attach_mappings = function(prompt_bufnr, _)
				actions.select_default:replace(function()
					local selection = action_state.get_selected_entry()
					actions.close(prompt_bufnr)

					local line = selection[1]
					parse_line(line)
				end)

				return true
			end,
		})
		:find()
end

local worktree_add = function()
	local get_lines = function()
		local lines = vim.fn.systemlist("git for-each-ref --format='%(refname:short)' refs/remotes")

		local worktrees_line = vim.fn.systemlist("git worktree list")

		for i, remote_branch in ipairs(lines) do
			for _, worktree_line in ipairs(worktrees_line) do
				local _, worktree_brach = worktree_line:match("^(.-)%s+%x+%s+%[(.-)%]$")
				if
					worktree_brach and (worktree_brach == remote_branch or "origin/" .. worktree_brach == remote_branch)
				then
					lines[i] = "[Exists] " .. worktree_brach
				end
			end
		end

		return lines
	end
	local parse_line = function(line)
		local branch = line:gsub("^origin/", "")

		local cwd = vim.fn.getcwd()
		local path = vim.fs.normalize(cwd .. "/.." .. "/" .. branch)
		print("path " .. path)
		print("cwd " .. cwd)
		print("branch " .. branch)

		local cmd = {
			"git",
			"worktree",
			"add",
			path,
			branch,
		}

		vim.fn.system(cmd)

		print("Created branch: " .. branch .. " at path: " .. path)
	end

	worktree_picker("Add Worktree", get_lines, parse_line)
end

local worktree_switch = function()
	local get_lines = function()
		local lines = vim.fn.systemlist("git worktree list")
		local formatted = {}

		for _, line in ipairs(lines) do
			local path, _, branch = line:match("^(.-)%s+(.-)%s+%[(.-)%]$")

			if branch then
				table.insert(formatted, string.format("%-80s %s", branch, path))
			else
				local bare_path = line:match("^(.-)%s+%(bare%)$")
				if bare_path then
					table.insert(formatted, string.format("%-80s %s", "bare", bare_path))
				end
			end
		end

		return formatted
	end

	local parse_line = function(line)
		local _, path = line:match("^(.-)%s+(.-)$")

		if path then
			vim.cmd("cd " .. vim.fn.fnameescape(path))

			-- clear buffers, current win and jump list
			vim.cmd("%bd!")

			local current_win = vim.api.nvim_get_current_win()
			local empty_buffer = vim.api.nvim_create_buf(true, false)
			vim.api.nvim_win_set_buf(current_win, empty_buffer)

			vim.cmd.clearjumps()

			print("Switched cwd to: " .. path)
		else
			print("Could not parse worktree path")
		end
	end
	worktree_picker("Pick Worktree", get_lines, parse_line)
end

local worktree_remove = function()
	local get_lines = function()
		local lines = vim.fn.systemlist("git worktree list")
		local formatted = {}

		for _, line in ipairs(lines) do
			local path, _, branch = line:match("^(.-)%s+(.-)%s+%[(.-)%]$")

			if branch then
				table.insert(formatted, string.format("%-80s %s", branch, path))
			end
		end

		return formatted
	end

	local parse_line = function(line)
		local branch, path = line:match("^(.-)%s+(.-)$")

		if path then
			local cwd = vim.fn.getcwd()
			local is_current_worktree = vim.startswith(vim.fs.normalize(path), vim.fs.normalize(cwd))
			if not is_current_worktree then
				local cmd = {
					"git",
					"worktree",
					"remove",
					path,
				}

				vim.fn.system(cmd)

				print("Removed worktree " .. branch .. " at path " .. path)
			else
				print("Can not remove current worktree")
			end
		else
			print("Could not parse worktree path")
		end
	end
	worktree_picker("Remove Worktree", get_lines, parse_line)
end

vim.api.nvim_create_user_command("WorktreeAdd", worktree_add, {})
vim.api.nvim_create_user_command("WorktreeRemove", worktree_remove, {})
vim.api.nvim_create_user_command("WorktreeSwitch", worktree_switch, {})
vim.keymap.set("n", "<leader>gw", worktree_switch, { desc = "[G]it [W]orktree [S]witch" })
vim.keymap.set("n", "<leader>gwa", worktree_add, { desc = "[G]it [W]orktree [A]dd" })
vim.keymap.set("n", "<leader>gwr", worktree_remove, { desc = "[G]it [W]orktree [R]emove" })
