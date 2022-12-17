require("stofffe")

-- Allow after/plugins to be used in "require"
local home_dir = os.getenv("HOME")
package.path = home_dir .. "/.config/nvim/after/plugin/?.lua;" .. package.path
