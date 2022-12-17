local treesitter = require("nvim-treesitter.configs")
treesitter.setup {
  ensure_installed = { "c", "lua", "rust", "go" },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}
