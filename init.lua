-- --------------------
-- --------------------
-- PLUGINS --
-- --------------------
-- --------------------

-- Use packer.nvim
-- Install via:
--  git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
-- Load plugins from lua/plugins.lua:
require('plugins')
-- --------------------
-- --------------------
-- GLOBAL --
-- --------------------
-- --------------------

vim.cmd([[
filetype plugin indent on
set nobackup
set nocompatible
set noswapfile
set nowritebackup
set number
set signcolumn=yes
set title
set wrap
setlocal wrap
set tabstop=4
set shiftwidth=4
set expandtab
set smartindent
set splitbelow
set splitright
set scrolloff=5
set clipboard+=unnamedplus
set diffopt+=vertical
set foldmethod=syntax
set synmaxcol=1024
" set foldmethod=expr
" set foldexpr=nvim_treesitter#foldexpr()
set nofoldenable
set completeopt=menuone,noinsert,noselect
" Avoid showing extra messages when using completion
set shortmess+=c
" Format-on-write for selected langs
autocmd BufWritePre *.rs,*.jl,*.lua lua vim.lsp.buf.formatting_sync(nil, 200)
set undofile " Maintain undo history between sessions
set undodir=~/.local/share/nvim/undo
autocmd BufReadPost *
            \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
            \ |   exe "normal! g`\""
            \ | endif
if (has("termguicolors"))
    set termguicolors
endif
syntax on
set background=dark
set cursorline

" Automatically re-synchronize packer on plugins change
augroup packer_user_config
  autocmd!
  autocmd BufWritePost plugins.lua source <afile> | PackerCompile
augroup end

" Disable syntax highlighting on larger files
autocmd BufWinEnter *
            \ if line2byte(line("$") + 1) > 1000000
            \ | syntax clear
            \ | set nowrap
            \ | endif

autocmd Filetype lua setlocal shiftwidth=2
]])


-- --------------------
-- --------------------
-- PLUGIN SPECIFIC --
-- --------------------
-- --------------------

-- --------------------
-- Lualine --
-- --------------------
require'lualine'.setup{
options = {
    theme = 'tokyonight', -- 'ayu_mirage',
    },
  sections = {
    lualine_a = {
      {
        'filename',
        path = 1,
    }
    },
    lualine_x = {'filetype'},
  },
  tabline = {
    lualine_a = {
      {
        'buffers',
        show_filename_only = false,
      }
    },
  }
}


-- --------------------
-- Workspaces --
-- --------------------
HOME = os.getenv("HOME")
vim.g.workspace_session_directory = HOME .. '/.local/share/nvim/sessions/'
vim.g.workspace_autocreate = "1"
vim.g.workspace_session_disable_on_args = "1"
vim.g.workspace_persist_undo_history = "0"
vim.g.workspace_autosave = "0"

-- --------------------
-- Leap --
-- --------------------
require('leap').set_default_keymaps()

-- --------------------
-- Telescope --
-- --------------------

-- Add howdoi to Telescope, install howdoi via pip first
require('telescope').load_extension('howdoi')

-- --------------------
-- Lsp saga --
-- --------------------
local on_attach = function(client, bufnr)
    local function map(mode, lhs, rhs, opts)
        opts = vim.tbl_extend('force', {noremap = true, silent = true}, opts or {})
        vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
    end
    map("n", "gh", "<cmd>Lspsaga lsp_finder<cr>")
    map("n", "gs", "<cmd>Lspsaga signatur_help<cr>")
    map("n", "gr", "<cmd>Lspsaga rename<cr>")
    map("n", "gd", "<cmd>Lspsaga preview_definition<cr>")
    map("n", "gD", "vim.lsp.buf.definition()<cr>")
    map("n", "ga", "<cmd>Lspsaga code_action<cr>")
    map("n", "K",  "<cmd>Lspsaga hover_doc<cr>")
    map("n", "go", "<cmd>Lspsaga show_line_diagnostics<cr>")
    map("n", "]g", "<cmd>Lspsaga diagnostic_jump_next<cr>")
    map("n", "[g", "<cmd>Lspsaga diagnostic_jump_prev<cr>")
    -- map("n", "<C-u>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1, '<c-u>')<cr>")
    -- map("n", "<C-d>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1, '<c-d>')<cr>")
    map("n", "<leader>d", "<cmd>Lspsaga show_line_diagnostics<cr>")
end

-- --------------------
-- LSP Setup --
-- --------------------

-- CMP Completion Setup
local has_words_before = function()
local line, col = unpack(vim.api.nvim_win_get_cursor(0))
return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local cmp = require'cmp'
local luasnip = require("luasnip")

cmp.setup({
snippet = {
  -- REQUIRED - you must specify a snippet engine
  expand = function(args)
    require('luasnip').lsp_expand(args.body)
  end,
},
mapping = {
  ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
  ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
  ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
  ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
  ['<C-e>'] = cmp.mapping({
    i = cmp.mapping.abort(),
    c = cmp.mapping.close(),
  }),
  ['<CR>'] = cmp.mapping.confirm({ select = true }),
  -- TAB/shift-TAB completion (luascript specific)
  ["<Tab>"] = cmp.mapping(function(fallback)
  if cmp.visible() then
    cmp.select_next_item()
  elseif luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  elseif has_words_before() then
    cmp.complete()
  else
    fallback()
  end
end, { "i", "s" }),

  ["<S-Tab>"] = cmp.mapping(function(fallback)
  if cmp.visible() then
    cmp.select_prev_item()
  elseif luasnip.jumpable(-1) then
    luasnip.jump(-1)
  else
    fallback()
  end
end, { "i", "s" }),

},
sources = cmp.config.sources({
  { name = 'nvim_lsp' },
  { name = 'luasnip' },
}, {
  { name = 'buffer' },
})
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
sources = {
  { name = 'buffer' }
}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
sources = cmp.config.sources({
  { name = 'path' }
}, {
  { name = 'cmdline' }
})
})

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

local nvim_lsp = require'lspconfig'

-- Add on_attach to EACH server's setup fn
-- Enable LSP server for JULIA
nvim_lsp.julials.setup({
  on_attach=on_attach,
  capabilities=capabilities,
  })

-- Enable LSP server for PYTHON
nvim_lsp.pyright.setup{
  on_attach=on_attach,
  capabilities=capabilities,
}

-- Enable LSP server for C++/C/Objective-C
-- require("clangd_extensions").setup()
-- nvim_lsp.clangd.setup {
--   }
require("clangd_extensions").setup {
  server = {
    on_attach=on_attach,
    capabilities=capabilities,
  },
  extensions = {
    autoSetHints = true,
    hover_with_actions = true,
    inlay_hints = {
        only_current_line = false,
        only_current_line_autocmd = "CursorHold",
        show_parameter_hints = true,
        -- The color of the hints
        highlight = "Comment",
    },
  },
  -- Keybindings to switch between header and source files of C/C++ files
  vim.api.nvim_set_keymap("n", "<leader>cs", "<cmd>ClangdSwitchSourceHeader<cr>", {noremap = true})
}
-- Enable Rust using Rust tools
local opts = {
    on_attach=on_attach,
    tools = { -- rust-tools options
        autoSetHints = true,
        hover_with_actions = true,
        inlay_hints = {
            show_parameter_hints = true,
            parameter_hints_prefix = "",
            other_hints_prefix = "",
        },
    },
    server = {
        settings = {
            ["rust-analyzer"] = {
                checkOnSave = {
                    command = "clippy"
                },
            }
        }
    },
}
require('rust-tools').setup(opts)


-- --------------------
-- Nvim-Tree --
-- --------------------
vim.api.nvim_set_keymap(
    "n",
    "<c-n>",
    ":NvimTreeToggle<cr>",
    { noremap = true }
)
-- vim.g.nvim_tree_disable_window_picker = "1"
require'nvim-tree'.setup({
  update_focused_file = {
    enable = true,
    update_cwd = false,
    ignore_list = {},
  },
  actions = {
    open_file = {
      window_picker = {
        enable = false,
      },
    },
  },
})
-- --------------------
-- Cheatsheet --
-- --------------------
require("cheatsheet").setup({
    bundled_cheatsheets = {
        -- only show the default cheatsheet
        disabled = { "nerd-fonts" },
    },
})

-- --------------------
-- Git signs --
-- --------------------
require('gitsigns').setup{
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    -- Actions
    map({'n', 'v'}, '<leader>gs', ':Gitsigns stage_hunk<CR>')
    map({'n', 'v'}, '<leader>gr', ':Gitsigns reset_hunk<CR>')
    map('n', '<leader>gS', gs.stage_buffer)
    map('n', '<leader>gu', gs.undo_stage_hunk)
    map('n', '<leader>gR', gs.reset_buffer)
    map('n', '<leader>gp', gs.preview_hunk)
    map('n', '<leader>gb', function() gs.blame_line{full=true} end)
    map('n', '<leader>tb', gs.toggle_current_line_blame)
    map('n', '<leader>gd', gs.diffthis)
    map('n', '<leader>gD', function() gs.diffthis('~') end)
    map('n', '<leader>td', gs.toggle_deleted)

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
}
-- --------------------
-- THEME --
-- --------------------
vim.g.tokyonight_style = "night"
vim.tokyonight_enable_italic_functions = true
vim.cmd[[colorscheme tokyonight]]
-- --------------------
-- Moving around, tabs, windows and buffers --
-- --------------------
vim.api.nvim_set_keymap("n", "<SPACE>", "<Nop>", {noremap = true})
vim.g.mapleader = " "
vim.api.nvim_set_keymap("n", "<Up>", ":5winc -<cr>", {noremap = true})
vim.api.nvim_set_keymap("n", "<Down>", ":5winc +<cr>", {noremap = true})
vim.api.nvim_set_keymap("n", "<Left>", ":5winc <<cr>", {noremap = true})
vim.api.nvim_set_keymap("n", "<Right>", ":5winc ><cr>", {noremap = true})
-- Let mapleader = <SPACE>
vim.g.maplocalleader = ","

-- Telescope config
vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", {noremap = true})
vim.api.nvim_set_keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", {noremap = true})
vim.api.nvim_set_keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", {noremap = true})
vim.api.nvim_set_keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", {noremap = true})
vim.api.nvim_set_keymap("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", {noremap = true})
-- When searching symbols, use <C-l> to filter for types (e.g. methods), select via <C-n> and <C-p>
vim.api.nvim_set_keymap("n", "<leader>fh", "<cmd>Telescope lsp_document_symbols<cr>", {noremap = true})

vim.api.nvim_set_keymap("n", "<leader>h", "<cmd>Telescope howdoi<cr>", {noremap = true})

-- Save
vim.api.nvim_set_keymap("n", "<leader>s", "<cmd>update<cr>", {noremap = true})

-- Clear search
vim.api.nvim_set_keymap("n", "<leader><ESC>", "<cmd>noh<cr>", {noremap = true})

-- Move around windows with ctrl- hjkl
vim.api.nvim_set_keymap("n", "<C-J>", "<C-W>j", {noremap = true})
vim.api.nvim_set_keymap("n", "<C-K>", "<C-W>k", {noremap = true})
vim.api.nvim_set_keymap("n", "<C-H>", "<C-W>h", {noremap = true})
vim.api.nvim_set_keymap("n", "<C-L>", "<C-W>l", {noremap = true})

-- Misc
vim.api.nvim_set_keymap("n", "<leader>g", "<cmd>Git<cr>", {noremap = true})
vim.api.nvim_set_keymap("n", "<leader>w", "<cmd>ToggleWorkspace<cr>", {noremap = true})
vim.api.nvim_set_keymap("n", "<leader>?", "<cmd>Cheatsheet<cr>", {noremap = true})




-- which-key
-- Build-in plugins: press ` for Marks, " for registers and z, g
local wk = require("which-key")

wk.register({
  f = {
    name = "Files",
    f = "File",
    g = 'Grep',
    b = "Buffer",
    r = "Recent",
    s = "Symbols",
    h = "Help",
    },
    s = "Save",
  d = "Diagnostics",
  h = "how do I",
  g = {
    name = 'Git hunks',
    p = 'Preview hunk',
    s = 'Stage hunk',
    r = 'Reset hunk',
    u = 'Undo stage hunk',
    R = 'Reset BUFFER',
    b = 'Blame line',
    d = 'Diff this',
    D = 'DIFF this??',
  },
  t = {
    name = "Git toggle",
    d = 'toggle deleted',
    b = 'toggle line blame',
  },
  w = "Workspace toggle",
  o = "Format",
  c = {
    name = "C/C++",
    s = 'Switch Source/Header file',
  },

},
{ prefix = "<leader>" })

