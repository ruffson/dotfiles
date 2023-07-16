-- This file can be loaded by calling `lua require('plugins')` from your init.vim
-- Bootstrapping lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Only required if you have packer configured as `opt`
-- vim.cmd [[packadd packer.nvim]]
require("lazy").setup({
    { "cespare/vim-toml" },
    { "tpope/vim-commentary" },
    -- -------------
    -- UI
    --
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
    },
    { 
        "nvim-tree/nvim-tree.lua",
        dependencies = {
            "nvim-tree/nvim-web-devicons"
        }
    },
    { "nvim-lualine/lualine.nvim", lazy = false },
    {
        'romgrk/barbar.nvim',
        dependencies = {
            'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
            'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
        },
        init = function() vim.g.barbar_auto_setup = false end,
        version = '^1.0.0', -- optional: only update when a new 1.x version is released
    },
    {
        "wfxr/minimap.vim",
        build = ":!cargo install --locked code-minimap"
    },
    {
        "nvimdev/lspsaga.nvim",
        config = function()
            require('lspsaga').setup({
                symbol_in_winbar = {
                    enable=true,
                },
                diagnostic = {
                    on_insert = false;
                }
            })
        end,
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'nvim-tree/nvim-web-devicons'
        }
    },
    -- {"EdenEast/nightfox.nvim"},
    -- {"catppuccin/nvim", as="catppuccin"},
    -- {'navarasu/onedark.nvim'},
    -- {'Mofiqul/dracula.nvim'},
    -- {"rebelot/kanagawa.nvim"},
    -- {'Everblush/everblush.nvim', as='everblush'},
    
    -- -------------
    -- TWEAKS
    --
    { "jiangmiao/auto-pairs" },
    { "chrisbra/csv.vim" },
    { "tpope/vim-fugitive" },
    { "folke/which-key.nvim" },
    { "kshenoy/vim-signature" },
    { "tpope/vim-unimpaired" },
    { "qpkorr/vim-bufkill" },
    { "thaerkh/vim-workspace" },
    { "lewis6991/gitsigns.nvim" },
    { "lukas-reineke/indent-blankline.nvim" },
    { "sudormrfbin/cheatsheet.nvim" },
    { "dhruvasagar/vim-zoom" },
    { "nvim-telescope/telescope.nvim" },
    { "nvim-lua/plenary.nvim" },
    { "ggandor/leap.nvim" },
    { "zane-/howdoi.nvim" },
    { 
        "danymat/neogen", 
        dependencies = "nvim-treesitter/nvim-treesitter", 
        config = true,
    },

    -- -------------
    -- LANGUAGES
    --
    {
        'tadachs/ros-nvim',
        config = function() require("ros-nvim").setup({only_workspace = true}) end,
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    { "JuliaEditorSupport/julia-vim"},
    { "p00f/clangd_extensions.nvim" },
    { "simrat39/rust-tools.nvim" },
    { "khaveesh/vim-fish-syntax" },

    -- -------------
    -- LSP
    --
    { "neovim/nvim-lspconfig" },
    { "nvim-lua/lsp_extensions.nvim" },

    -- CMP completion (formerly compe)
    {
        "hrsh7th/nvim-cmp",
        lazy = false,
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
        },
    },
    {
        "L3MON4D3/LuaSnip",
        version = "1.*",
    },
    { "mhartington/formatter.nvim" },
    { "saadparwaiz1/cmp_luasnip" },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
    },
    -- should always go last
    { "ryanoasis/vim-devicons" },

})
