local on_windows = vim.fn.has("win32") == 1
local on_mac = vim.fn.has("mac") == 1

local platform
if on_windows then
	platform = require("platform.windows")
elseif on_mac then
	platform = require("platform.mac")
end

return {
	on_windows = on_windows,
	on_mac = on_mac,
	open_path = platform.open_path,
}
