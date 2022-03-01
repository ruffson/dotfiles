-- This file can be loaded by calling `lua require('plugins')` from your init.vim
-- Bootstrapping packer.nvim
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

-- Only required if you have packer configured as `opt`
-- vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
    use 'cespare/vim-toml'
    -- use {
    --     'junegunn/fzf', 
    --     run ="-> fzf#install()" 
    -- }
    -- use 'junegunn/fzf.vim'
    use 'tpope/vim-commentary'
    use 'folke/tokyonight.nvim'
    use 'rebelot/kanagawa.nvim'
    use 'jiangmiao/auto-pairs'
    use 'chrisbra/csv.vim'
    use 'tpope/vim-fugitive'
    use 'junegunn/gv.vim'
    use 'machakann/vim-highlightedyank'
    use 'folke/which-key.nvim'
    use 'kshenoy/vim-signature'
    use 'tpope/vim-unimpaired'
    use 'qpkorr/vim-bufkill'
    use 'thaerkh/vim-workspace'
    use 'JuliaEditorSupport/julia-vim'
    use 'neovim/nvim-lspconfig'
    use 'nvim-lua/lsp_extensions.nvim'
    use 'nvim-lua/plenary.nvim'
    use 'lewis6991/gitsigns.nvim'
    use 'lukas-reineke/indent-blankline.nvim'
    -- Cheatsheet
    use 'sudormrfbin/cheatsheet.nvim'
    -- nvim-tree
    use 'kyazdani42/nvim-web-devicons'
    use 'kyazdani42/nvim-tree.lua'
    use 'dhruvasagar/vim-zoom'
    use 'nvim-telescope/telescope.nvim'
    use 'nvim-lualine/lualine.nvim'
    -- CMP completion (formerly compe)
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp'
    -- vsnip snippets
    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'
    -- Rust config for convenience
    use 'simrat39/rust-tools.nvim'
    use 'nvim-lua/popup.nvim'
    use 'mhartington/formatter.nvim'
    use {'tami5/lspsaga.nvim', branch = 'nvim6.0'}
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }
    -- should always go last
    use 'ryanoasis/vim-devicons'

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
      require('packer').sync()
    end
end)
