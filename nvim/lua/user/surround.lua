local req = "nvim-surround"
local ok, surround = pcall(require, req)
if not ok then print("could not find require \"" .. req .. "\"") return end

surround.setup({})
