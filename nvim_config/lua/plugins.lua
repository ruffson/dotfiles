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
    -- -------------
    -- UI
    --
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
    },
    {"EdenEast/nightfox.nvim", lazy = true },
    {"catppuccin/nvim", as="catppuccin", lazy = true },
    {'navarasu/onedark.nvim', lazy = true },
    {'Mofiqul/dracula.nvim', lazy = true },
    {"rebelot/kanagawa.nvim", lazy = true },
    {'Everblush/everblush.nvim', as='everblush', lazy = true },
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = {
            "nvim-tree/nvim-web-devicons"
        }
    },
    { "nvim-lualine/lualine.nvim", lazy = false },
    {
        'akinsho/bufferline.nvim',
        version = "*",
        dependencies = 'nvim-tree/nvim-web-devicons'
    },
    {
        "wfxr/minimap.vim",
        build = ":!cargo install --locked code-minimap"
    },
    {
        "nvimdev/lspsaga.nvim",
        config = function()
            require('lspsaga').setup({
                lightbulb = {
                    enable = false,
                },
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
    {
      "utilyre/barbecue.nvim",
      name = "barbecue",
      version = "*",
      dependencies = {
        "SmiteshP/nvim-navic",
        "nvim-tree/nvim-web-devicons", -- optional dependency
      },
    },

    -- -------------
    -- TWEAKS
    --
    { "tpope/vim-commentary" },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        opts = {}
    },
    { "chrisbra/csv.vim" },
    { "tpope/vim-fugitive" },
    { "folke/which-key.nvim" },
    { "kshenoy/vim-signature" },
    { "tpope/vim-unimpaired" },
    { "qpkorr/vim-bufkill" },
    { "thaerkh/vim-workspace", lazy = false},
    -- { 'rmagatti/auto-session', lazy = false },
    { "lewis6991/gitsigns.nvim" },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {}
    },
    { "sudormrfbin/cheatsheet.nvim" },
    { "dhruvasagar/vim-zoom" },
    { "nvim-telescope/telescope.nvim" },
    { "nvim-lua/plenary.nvim" },
    { "ggandor/leap.nvim" },
    -- { "zane-/howdoi.nvim" },
    {
        'kevinhwang91/nvim-ufo',
        lazy = false,
        dependencies = 'kevinhwang91/promise-async'
    },
    {
        "danymat/neogen",
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = true,
    },
    {
        "luckasRanarison/nvim-devdocs",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {}
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    -- {
    --     "zbirenbaum/copilot.lua",
    --     config = function() require("copilot").setup() end,
    -- },
    {
        "zbirenbaum/copilot.lua",
        lazy = false,
        opts = {
            panel = {
               enabled = true,
               auto_refresh = false,
               keymap = {
                 jump_prev = "[[",
                 jump_next = "]]",
                 accept = "<CR>",
                 refresh = "gr",
                 open = "<M-CR>"
               },
               layout = {
                 position = "bottom", -- | top | left | right
                 ratio = 0.4
               },
            },
            suggestion = {
               enabled = true,
               auto_trigger = true,
               debounce = 75,
               keymap = {
                 accept = "<M-l>",
                 accept_word = false,
                 accept_line = false,
                 next = "<M-]>",
                 prev = "<M-[>",
                 dismiss = "<C-]>",
               },
            },
            filetypes = {
               yaml = false,
               markdown = false,
               help = false,
               gitcommit = false,
               gitrebase = false,
               hgcommit = false,
               svn = false,
               cvs = false,
               ["."] = false,
            },
            copilot_node_command = 'node', -- Node.js version must be > 18.x
            server_opts_overrides = {},
        },
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
    { "cespare/vim-toml" },
    { "mfussenegger/nvim-dap-python" },
    -- -------------
    -- LSP
    --
    { "folke/neodev.nvim", opts = {} },
    { "mfussenegger/nvim-dap" },
    {
        "theHamsta/nvim-dap-virtual-text",
        config = function() require("nvim-dap-virtual-text").setup() end,
        dependencies = { "mfussenegger/nvim-dap" },
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio"

        },
            config = function() require("dapui").setup({
                --local dap, dapui = require("dap"), require("dapui")
                --dap.listeners.before.launch.dapui_config = function()
                --    dapui.open()
                --end
            }) end,
    },
    -- {
    --     "rcarriga/nvim-dap-ui",
    --     config = function() require("dapui").setup() end,
    --     dependencies = { "mfussenegger/nvim-dap" },
    -- },
    { "sindrets/diffview.nvim" },
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
    { "saadparwaiz1/cmp_luasnip" },


    { "mhartington/formatter.nvim" },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
    },
    {
        "folke/trouble.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons"
        },
    },
    {
        "dstein64/vim-startuptime",
        cmd = "StartupTime",
        init = function()
          vim.g.startuptime_tries = 10
        end,
    },

})
