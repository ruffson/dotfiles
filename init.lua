-- --------------------
-- --------------------
-- PLUGINS --
-- --------------------
-- --------------------

-- Use lazy.nvim
require("plugins")
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
" set cmdheight=0
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
"set foldmethod=indent
"set nofoldenable
" Disable this shortcut as it conflicts with barbar's picker
let g:AutoPairsShortcutToggle = ''
set synmaxcol=1024
set completeopt=menuone,noinsert,noselect
" Avoid showing extra messages when using completion
set shortmess+=c
" Format-on-write for selected langs
" autocmd BufWritePre *.rs,*.jl,*.lua lua vim.lsp.buf.formatting_sync(nil, 200)
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

" Disable syntax highlighting on larger files
autocmd BufWinEnter *
            \ if line2byte(line("$") + 1) > 1000000
            \ | syntax clear
            \ | set nowrap
            \ | endif

autocmd Filetype xml setlocal shiftwidth=2

" Use xml syntax when working with xacro files
" au BufReadPost *.sdf *.xacro *.launch *.urdf set syntax=xml

" Highlight yanked line
au TextYankPost * silent! lua vim.highlight.on_yank()
]])

-- Disable mouse mode
vim.opt.mouse = ""
-- --------------------
-- THEME --
-- --------------------
require("tokyonight").setup({
  style = "night", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
  transparent = false, -- Enable this to disable setting the background color
  terminal_colors = true, -- Configure the colors used when opening a `:terminal` in [Neovim](https://github.com/neovim/neovim)
  styles = {
    -- Style to be applied to different syntax groups
    -- Value is any valid attr-list value for `:help nvim_set_hl`
    comments = { italic = true },
    keywords = { italic = true },
    functions = { italic = true },
    variables = {},
    -- Background styles. Can be "dark", "transparent" or "normal"
    sidebars = "dark", -- style for sidebars, see below
    floats = "dark", -- style for floating windows
  },
  sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
  day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
  hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
  dim_inactive = true, -- dims inactive windows
  lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold

  --- You can override specific color groups to use other groups or a hex color
  --- function will be called with a ColorScheme table
  ---@param colors ColorScheme
  on_colors = function(colors) end,

  --- You can override specific highlights to use other groups or a hex color
  --- function will be called with a Highlights and ColorScheme table
  ---@param highlights Highlights
  ---@param colors ColorScheme
  on_highlights = function(highlights, colors) end,
})

-- vim.tokyonight_enable_italic_functions = true
vim.cmd([[colorscheme tokyonight-night]])
vim.cmd.highlight({ "WinSeparator", "guifg=#3b4261" })
-- require('onedark').setup {
--     style = 'deep'
-- }
-- vim.cmd([[colorscheme onedark]])

-- Set color of separating line of split windows

-- --------------------
-- --------------------
-- PLUGIN SPECIFIC --
-- --------------------
-- --------------------

-- Global shortcut to make keymap definitions easier
local map = vim.api.nvim_set_keymap
local opts_nore = { noremap = true }
local opts_silent = { noremap = true, silent = true }
-- Set <space> as mapleader
map("n", "<SPACE>", "<Nop>", opts_nore)
-- Disable <visual>-capitilzation
map("v", "U", "<Nop>", opts_nore)
map("v", "u", "<Nop>", opts_nore)
vim.g.mapleader = " "

-- --------------------
-- Lualine --
-- --------------------

-- disable show-mode in COMMAND line because it will show up in lualine
vim.cmd([[set noshowmode]])
require("lualine").setup({
    options = {
        theme = "tokyonight", -- "tokyonight", -- 'ayu_mirage',
    },
    sections = {
        lualine_a = {
            {
                "mode"
            },
            {
                "filename",
                path = 1,
                shorting_target = 30,
            },
        },
        lualine_c = {},
        lualine_x = { "filetype" },
    },
})
-- Enable global statusline
vim.opt.laststatus = 3

-- --------------------
-- Bufferline --
-- --------------------

require("bufferline").setup{
    options = {
       separator_style = "slant", 
       show_buffer_close_icons = false,
       show_close_icon = false,
       always_show_bufferline = false,
    }
}
-- Pin/unpin buffer
map("n", "<A-p>", "<Cmd>BufferLineTogglePin<CR>", opts_silent)
--- Close buffer
map("n", "<A-x>", "<Cmd>BufferLinePickClose<CR>", opts_silent)
-- Magic buffer-picking mode
map("n", "<C-p>", "<Cmd>BufferLinePick<CR>", opts_silent)

--------------------
-- Workspaces --
-- --------------------
HOME = os.getenv("HOME")
vim.g.workspace_session_directory = HOME .. "/.local/share/nvim/sessions/"
vim.g.workspace_autocreate = "1"
vim.g.workspace_session_disable_on_args = "1"
vim.g.workspace_persist_undo_history = "0"
vim.g.workspace_autosave = "0"
map("n", "<leader>w", "<cmd>ToggleWorkspace<cr>", opts_nore)
-- vim.o.sessionoptions="blank,buffers,curdir,help,tabpages,winsize,winpos,terminal,localoptions"

-- require("auto-session").setup({ 
--   auto_session_enable_last_session = false,
--   auto_session_root_dir = vim.fn.stdpath('data').."/sessions/",
--   -- auto_session_enabled = true,
--   auto_save_enabled = nil,
--   auto_restore_enabled = nil,
--   auto_session_suppress_dirs = nil,
--   auto_session_use_git_branch = nil,
--   -- the configs below are lua only
--   bypass_session_save_file_types = nil
-- })
-- -- Workaround to close nvim tree before saving session
-- vim.api.nvim_create_autocmd({ 'BufEnter' }, {
--   pattern = 'NvimTree*',
--   callback = function()
--     local api = require('nvim-tree.api')
--     local view = require('nvim-tree.view')

--     if not view.is_visible() then
--       api.tree.open()
--     end
--   end,
-- })

-- --------------------
-- Leap --
-- --------------------
require("leap").set_default_keymaps()

-- --------------------
-- Telescope --
-- --------------------
require("telescope").setup({
    defaults = {
        file_ignore_patterns = {
            "build",
            -- "install",
            "log",
        },
    },
})
-- Add howdoi to Telescope, install howdoi via pip first
require("telescope").load_extension("howdoi")

map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts_nore)
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts_nore)
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts_nore)
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts_nore)
map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", opts_nore)
map("n", "<leader>fc", "<cmd>Telescope colorscheme<cr>", opts_nore)
-- When searching symbols, use <C-l> to filter for types (e.g. methods), select via <C-n> and <C-p>
map("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", opts_nore)

map("n", "<leader>h", "<cmd>Telescope howdoi<cr>", opts_nore)

-- --------------------
-- Lsp saga --
-- --------------------

local keymap = vim.keymap.set
-- Lsp finder find the symbol definition implement reference
-- when you use action in finder like open vsplit then you can
-- use <C-t> to jump back
keymap("n", "gh", "<cmd>Lspsaga finder<CR>", { silent = true })
keymap("n", "<leader>lf", "<cmd>Lspsaga finder<CR>", { silent = true })
-- Code action
keymap({"n","v"}, "ga", "<cmd>Lspsaga code_action<CR>", { silent = true })
keymap("n", "<leader>la", "<cmd>Lspsaga code_action<CR>", { silent = true })
-- Rename
keymap("n", "gr", "<cmd>Lspsaga rename<CR>", { silent = true })
keymap("n", "<leader>lr", "<cmd>Lspsaga rename<CR>", { silent = true })
-- Peek Definition
-- you can edit the definition file in this flaotwindow
-- also support open/vsplit/etc operation check definition_action_keys
-- support tagstack C-t jump back
keymap("n", "gd", "<cmd>Lspsaga peek_definition<CR>", { silent = true })
keymap("n", "<leader>lp", "<cmd>Lspsaga peek_definition<CR>", { silent = true })

keymap("n", "<leader>ld", "<cmd>Lspsaga show_line_diagnostics<CR>", { silent = true })

keymap("n", "<leader>lc", "<cmd>Lspsaga show_cursor_diagnostics<CR>", { silent = true })

keymap("n","<leader>lo", "<cmd>Lspsaga outline<CR>",{ silent = true })


-- Diagnsotic jump can use `<c-o>` to jump back
keymap("n", "[g", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { silent = true })
keymap("n", "]g", "<cmd>Lspsaga diagnostic_jump_next<CR>", { silent = true })


keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", { silent = true })
keymap("n", "<leader>ld", "<cmd>Lspsaga hover_doc<CR>", { silent = true })
-- keymap("n", "<C-u>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1, '<c-u>')<cr>")
-- keymap("n", "<C-d>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1, '<c-d>')<cr>")

-- --------------------
-- Treesitter --
-- --------------------

require'nvim-treesitter.configs'.setup {
    ensure_installed = { "lua", "html", "markdown" },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
}

-- --------------------
-- LSP/CMP Setup --
-- --------------------

-- CMP Completion Setup
local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    sorting = {
        comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.recently_used,
            require("clangd_extensions.cmp_scores"),
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    },
    mapping = {
        ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ["<C-e>"] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
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
        { name = "nvim_lsp" },
        { name = "luasnip" },
    }, {
        { name = "buffer" },
    }),
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline("/", {
    sources = {
        { name = "buffer" },
    },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
    sources = cmp.config.sources({
        { name = "path" },
    }, {
        { name = "cmdline" },
    }),
})

-- Setup lspconfig.
-- local capabilities = require("cmp_nvim_lsp").default_capabilities()
local nvim_lsp = require("lspconfig")

-- Add on_attach to EACH server's setup fn

-- -------------------------
-- Enable LSP server for JULIA
nvim_lsp.julials.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})
--- -------------------------
--- Enable LSP server for PYTHON
-- Make sure pip package python-lsp-ruff is installed
nvim_lsp.pylsp.setup({
	settings = {
		pylsp = {
			plugins = {
				ruff = {
					enabled = true,
					extendSelect = { "I" },
				},
			}
		}
	},
    on_attach = on_attach,
    capabilities = capabilities,
})
-- -------------------------
-- Enable LSP server for C/C++
require("clangd_extensions").setup({
    server = {
        on_attach = on_attach,
        capabilities = capabilities,
    },
    extensions = {
        autoSetHints = true,
        hover_with_actions = true,
        inlay_hints = {
            only_current_line = false,
            show_parameter_hints = true,
            -- The color of the hints
            highlight = "Comment",
        },
    },
    -- Keybindings to switch between header and source files of C/C++ files
    vim.api.nvim_set_keymap("n", "<leader>cs", "<cmd>ClangdSwitchSourceHeader<cr>", { noremap = true }),
})

-- -------------------------
require("rust-tools").setup({
    server = {
        on_attach = on_attach,
    },
})

-- local coq = require("coq")

-- --------------------
-- NEORG --
-- --------------------

require("neorg").setup {
    load = {
        ["core.defaults"] = {}, -- Loads default behaviour
        ["core.concealer"] = {}, -- Adds pretty icons to your documents
        ["core.dirman"] = { -- Manages Neorg workspaces
            config = {
                workspaces = {
                    notes = "~/Documents/neorg",
                },
                default_workspace = "notes",
            },
        },
    },
}
-- --------------------
-- Nvim UFO --
-- --------------------
-- vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
vim.o.foldcolumn = '0' -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
}
local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
for _, ls in ipairs(language_servers) do
    require('lspconfig')[ls].setup({
        capabilities = capabilities
    })
end
require('ufo').setup()

-- --------------------
-- Nvim-Tree --
-- --------------------
vim.api.nvim_set_keymap("n", "<c-n>", ":NvimTreeToggle<cr>", { noremap = true })
vim.g.nvim_tree_disable_window_picker = "1"
require("nvim-tree").setup({
    update_focused_file = {
        enable = true,
        update_cwd = false,
        ignore_list = {},
    },
    view = {
        adaptive_size = true,
        preserve_window_proportions = true,
    },
    actions = {
        open_file = {
            window_picker = {
                enable = true,
            },
        },
    },
})

-- --------------------
-- FORMATTER --
-- --------------------
local util = require("formatter.util")

-- Provides the Format and FormatWrite commands
require("formatter").setup({
    logging = true,
    log_level = vim.log.levels.WARN,
    filetype = {
        lua = {
            require("formatter.filetypes.lua").stylua,
        },

        ["*"] = {
            require("formatter.filetypes.any").remove_trailing_whitespace,
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
-- Build-in plugins: press ` for Marks, " for registers and z, g
map("n", "<leader>?", "<cmd>Cheatsheet<cr>", opts_nore)

-- --------------------
-- Git signs --
-- --------------------
require("gitsigns").setup({
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "]c", function()
            if vim.wo.diff then
                return "]c"
            end
            vim.schedule(function()
                gs.next_hunk()
            end)
            return "<Ignore>"
        end, { expr = true })

        map("n", "[c", function()
            if vim.wo.diff then
                return "[c"
            end
            vim.schedule(function()
                gs.prev_hunk()
            end)
            return "<Ignore>"
        end, { expr = true })

        -- Actions
        map({ "n", "v" }, "<leader>gs", ":Gitsigns stage_hunk<CR>")
        map({ "n", "v" }, "<leader>gr", ":Gitsigns reset_hunk<CR>")
        map("n", "<leader>gS", gs.stage_buffer)
        map("n", "<leader>gu", gs.undo_stage_hunk)
        map("n", "<leader>gR", gs.reset_buffer)
        map("n", "<leader>gp", gs.preview_hunk)
        map("n", "<leader>gb", function()
            gs.blame_line({ full = true })
        end)
        map("n", "<leader>tb", gs.toggle_current_line_blame)
        map("n", "<leader>gd", gs.diffthis)
        map("n", "<leader>gD", function()
            gs.diffthis("~")
        end)
        map("n", "<leader>td", gs.toggle_deleted)

        -- Text object
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
    end,
})

-- --------------------
-- Neogen (code annotations) --
-- --------------------
require("neogen").setup({})
vim.api.nvim_set_keymap("n", "<leader>af", ":lua require('neogen').generate({ type = 'func' })<CR>", opts_silent)
vim.api.nvim_set_keymap("n", "<leader>ac", ":lua require('neogen').generate({ type = 'class' })<CR>", opts_silent)
vim.api.nvim_set_keymap("n", "<leader>ai", ":lua require('neogen').generate({ type = 'file' })<CR>", opts_silent)
vim.api.nvim_set_keymap("n", "<leader>at", ":lua require('neogen').generate({ type = 'type' })<CR>", opts_silent)

-- --------------------
-- CSV
-- --------------------

vim.g.csv_nomap_up = 1
vim.g.csv_nomap_down = 1

-- --------------------
-- Misc Keybindings
-- --------------------

-- Moving around, tabs, windows and buffers
map("n", "<Up>", ":5winc -<cr>", opts_nore)
map("n", "<Down>", ":5winc +<cr>", opts_nore)
map("n", "<Left>", ":5winc <<cr>", opts_nore)
map("n", "<Right>", ":5winc ><cr>", opts_nore)
-- vim.g.maplocalleader = ","

-- Move around windows with ctrl- hjkl
map("n", "<C-J>", "<C-W>j", opts_nore)
map("n", "<C-K>", "<C-W>k", opts_nore)
map("n", "<C-H>", "<C-W>h", opts_nore)
map("n", "<C-L>", "<C-W>l", opts_nore)

-- Save file
map("n", "<leader>s", "<cmd>update<cr>", opts_nore)

-- Clear search
map("n", "<leader><ESC>", "<cmd>noh<cr>", opts_nore)

local wk = require("which-key")


wk.register({
    f = {
        name = "Files",
        f = "File",
        g = "Grep",
        b = "Buffer",
        r = "Recent",
        s = "Symbols",
        h = "Help",
        c = "Colorscheme",
    },
    s = "Save",
    d = "Diagnostics",
    h = "how do I",
    g = {
        name = "Git hunks",
        p = "Preview hunk",
        s = "Stage hunk",
        r = "Reset hunk",
        u = "Undo stage hunk",
        R = "Reset BUFFER",
        b = "Blame line",
        d = "Diff this",
        D = "DIFF this??",
    },
    t = {
        name = "Git toggle",
        d = "toggle deleted",
        b = "toggle line blame",
    },
    w = "Workspace toggle",
    a = {
        name = "Annotate",
        f = "Function",
        c = "Class",
        i = "File",
        t = "Type",
    },
    c = {
        name = "c/c++",
        s = "switch source/header file",
    },
    l = {
        name = "LSP",
        f = "Find symbol",
        o = "Outline",
        p = "Peek Defintion",
        d = "Hover Doc",
        l = "Line Diagnostics",
        c = "Cursor Diagnostics",
        a = "Action",
        r = "Rename",
    },
}, { prefix = "<leader>" })
