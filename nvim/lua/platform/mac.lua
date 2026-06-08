local function open_path(path)
	vim.fn.jobstart({ "open", path }, { detach = true })
end

return {
    open_path = open_path,
}
