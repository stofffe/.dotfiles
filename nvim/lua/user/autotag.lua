local req = "nvim-ts-autotag"
local ok, auto_tag = pcall(require, req)
if not ok then print("could not find require \"" .. req .. "\"") return end

auto_tag.setup()
