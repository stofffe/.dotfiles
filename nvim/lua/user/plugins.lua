local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    }
    print "Installing packer close and reopen Neovim..."
    vim.cmd [[packadd packer.nvim]]
end

local req = "packer"
local ok, packer = pcall(require, req)
if not ok then print("could not find require \"" .. req .. "\"") return end

-- Have packer use a popup window
packer.init {
    display = {
        open_fn = function() return require("packer.util").float({ border = "rounded" }) end,
    },
}

-- Install your plugins here
return packer.startup(function(use)
    -- My plugins here
    use "wbthomason/packer.nvim" -- Have packer manage itself
    use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
    use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins

    -- Small plugins
    use "windwp/nvim-autopairs" -- Auto completes pairs
    use "numToStr/Comment.nvim"
    use "mg979/vim-visual-multi"
    use "kylechui/nvim-surround"

    -- Colorscheme
    use "joshdick/onedark.vim"
    use "lunarvim/darkplus.nvim"
    use "morhetz/gruvbox"
    use "NLKNguyen/papercolor-theme"
    use "shaunsingh/solarized.nvim"

    -- Telescope
    use { "nvim-telescope/telescope.nvim", requires = { { "nvim-lua/plenary.nvim" } } }

    -- Terminal and file tree
    use { "kyazdani42/nvim-tree.lua", requires = { "kyazdani42/nvim-web-devicons", }, }

    -- Treesitter
    use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate", }
    use "JoosepAlviste/nvim-ts-context-commentstring"

    -- Cmp
    use "hrsh7th/nvim-cmp" -- The completion plugin
    use "hrsh7th/cmp-buffer" -- buffer completions
    use "hrsh7th/cmp-path" -- path completions
    use "hrsh7th/cmp-cmdline" -- cmdline completions
    use "saadparwaiz1/cmp_luasnip" -- snippet completions
    use "hrsh7th/cmp-nvim-lsp"
    use "hrsh7th/cmp-nvim-lua"
    use "hrsh7th/cmp-nvim-lsp-signature-help"

    -- Snippets
    use "L3MON4D3/LuaSnip" --snippet engine
    use "rafamadriz/friendly-snippets" -- a bunch of snippets to use

    -- LSP
    use "neovim/nvim-lspconfig" -- enable LSP
    use "williamboman/nvim-lsp-installer" -- simple to use language server installer
    use "jose-elias-alvarez/null-ls.nvim" -- complementary diagnostics and formatters

    -- Golang
    use "ray-x/go.nvim"
    use "ray-x/guihua.lua"

    -- Rust
    use "simrat39/rust-tools.nvim"


    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
