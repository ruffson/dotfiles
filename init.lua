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
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set nofoldenable
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
-- vim.g.tokyonight_style = "night"
vim.tokyonight_enable_italic_functions = true
vim.cmd([[colorscheme tokyonight-night]])
-- require('onedark').setup {
--     style = 'deep'
-- }
-- vim.cmd([[colorscheme onedark]])

-- Set color of separating line of split windows
vim.cmd.highlight({ "WinSeparator", "guifg=#3b4261" })
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
vim.g.mapleader = " "

-- --------------------
-- Lualine --
-- --------------------
require("lualine").setup({
    options = {
        theme = "tokyonight", -- "tokyonight", -- 'ayu_mirage',
    },
    sections = {
        lualine_a = {
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
-- barbar.nvim --
-- --------------------
-- Set barbar's options
require("bufferline").setup({
    tabpages = false,
    auto_hide = true,

    -- Configure icons on the bufferline.
    icons = {
        button = false,
        modified = { button = "●" },
        pinned = { button =  "車"},
    },
    insert_at_end = true,
    insert_at_start = false,
    maximum_length = 30,
    semantic_letters = true,
    -- Sets the name of unnamed buffers. By default format is "[Buffer X]"
    -- where X is the buffer number. But only a static string is accepted here.
    no_name_title = nil,
})
-- Move to previous/next
-- map <S-k> <Nop>
map("n", "[b", "<Nop>", opts_silent)
map("n", "[b", "<Cmd>BufferPrevious<CR>", opts_silent)
map("n", "]b", "<Nop>", opts_silent)
map("n", "]b", "<Cmd>BufferNext<CR>", opts_silent)
-- Pin/unpin buffer
map("n", "<A-p>", "<Cmd>BufferPin<CR>", opts_silent)
--- Close buffer
map("n", "<A-x>", "<Cmd>BufferClose<CR>", opts_silent)
-- Magic buffer-picking mode
map("n", "<C-p>", "<Cmd>BufferPick<CR>", opts_silent)

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
keymap("n", "gh", "<cmd>Lspsaga lsp_finder<CR>", { silent = true })
-- Code action
keymap({"n","v"}, "ga", "<cmd>Lspsaga code_action<CR>", { silent = true })
-- Rename
keymap("n", "gr", "<cmd>Lspsaga rename<CR>", { silent = true })
-- Peek Definition
-- you can edit the definition file in this flaotwindow
-- also support open/vsplit/etc operation check definition_action_keys
-- support tagstack C-t jump back
keymap("n", "gd", "<cmd>Lspsaga peek_definition<CR>", { silent = true })
keymap("n", "<leader>d", "<cmd>Lspsaga show_line_diagnostics<CR>", { silent = true })
keymap("n", "go", "<cmd>Lspsaga show_cursor_diagnostics<CR>", { silent = true })
-- Diagnsotic jump can use `<c-o>` to jump back
keymap("n", "[g", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { silent = true })
keymap("n", "]g", "<cmd>Lspsaga diagnostic_jump_next<CR>", { silent = true })
keymap("n","<leader>o", "<cmd>LSoutlineToggle<CR>",{ silent = true })
keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", { silent = true })
-- keymap("n", "<C-u>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1, '<c-u>')<cr>")
-- keymap("n", "<C-d>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1, '<c-d>')<cr>")

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
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local nvim_lsp = require("lspconfig")

-- Add on_attach to EACH server's setup fn

-- -------------------------
-- Enable LSP server for JULIA
nvim_lsp.julials.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})
-- -------------------------
-- Enable LSP server for PYTHON
-- nvim_lsp.pylsp.setup({
--     on_attach = on_attach,
--     capabilities = capabilities,
-- })

-- Configure `ruff-lsp`.
-- See: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#ruff_lsp
-- For the default config, along with instructions on how to customize the settings
nvim_lsp.ruff_lsp.setup {
  on_attach = on_attach,
  init_options = {
    settings = {
      -- Any extra CLI arguments for `ruff` go here.
      args = {},
    }
  }
}
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
    -- on_attach = on_attach,
    server = {
        on_attach = on_attach,
    },
})

-- --------------------
-- Nvim-Tree --
-- --------------------
vim.api.nvim_set_keymap("n", "<c-n>", ":NvimTreeToggle<cr>", { noremap = true })
-- vim.g.nvim_tree_disable_window_picker = "1"
require("nvim-tree").setup({
    update_focused_file = {
        enable = true,
        update_cwd = false,
        ignore_list = {},
    },
    view = {
        adaptive_size = true,
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
    o = "Outline toggle",
    c = {
        name = "c/c++",
        s = "switch source/header file",
    },
}, { prefix = "<leader>" })
