" Plugins START
call plug#begin()
Plug 'cespare/vim-toml'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-commentary'
Plug 'folke/tokyonight.nvim'
Plug 'jiangmiao/auto-pairs'
Plug 'chrisbra/csv.vim'

Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
Plug 'machakann/vim-highlightedyank'
Plug 'liuchengxu/vim-which-key'
Plug 'kshenoy/vim-signature'
Plug 'tpope/vim-unimpaired'
Plug 'qpkorr/vim-bufkill'
Plug 'thaerkh/vim-workspace'
Plug 'JuliaEditorSupport/julia-vim'

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'lukas-reineke/indent-blankline.nvim',
" Cheatsheet
Plug 'sudormrfbin/cheatsheet.nvim'
Plug 'nvim-lua/popup.nvim'
"nvim-tree
Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'kyazdani42/nvim-tree.lua'

Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lualine/lualine.nvim'

" CMP completion (formerly compe)
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

" vsnip snippets
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

Plug 'mhartington/formatter.nvim'
Plug 'glepnir/lspsaga.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
" should always go last
Plug 'ryanoasis/vim-devicons'
call plug#end()
" Plugins END
"------------------------------------------------
"------------------------------------------------
" Settings START
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
" set foldmethod=expr
" set foldexpr=nvim_treesitter#foldexpr()
set nofoldenable    " disable folding

" Settings END
"------------------------------------------------

"" -----------------------------------------------
" PLUGIN CONFIG
" -----------------------------------------------

"Lualine
lua << EOF
require'lualine'.setup{
options = {
    theme = 'ayu_mirage',
    },
  sections = {
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
EOF

" Workspaces
let g:workspace_session_directory = $HOME . '/.local/share/nvim/sessions/'
let g:workspace_autocreate = 1
let g:workspace_session_disable_on_args = 1
let g:workspace_persist_undo_history = 0
let g:workspace_autosave = 0

" Syntax highlighting for embedded lua
let g:vimsyn_embed= 'l'

" LSP config
set completeopt=menu,menuone,noselect
" Avoid showing extra messages when using completion
" set shortmess+=c

" CMP COMPLETION SETUP (formerly compe)
lua <<EOF

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

  -- Enable julials
  nvim_lsp.julials.setup({
      capabilities=capabilities,
      })

  -- Enable rust analyzer
  nvim_lsp.rust_analyzer.setup({
      capabilities=capabilities,
      settings = {
          ["rust-analyzer"] = {
              assist = {
                  importMergeBehavior = "last",
                  importPrefix = "by_self",
              },
              cargo = {
                  loadOutDirsFromCheck = true
              },
              procMacro = {
                  enable = true
              },
              diagnostics = {
                  enable = true,
                  disabled = {"unresolved-proc-macro"},
              },
          }
      }
    })

  nvim_lsp.pyright.setup{
    capabilities=capabilities,
  }

EOF

" ----------CONFIGURE TREESITTER----------
" lua << EOF
" require'nvim-treesitter.configs'.setup {
"   ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
"   highlight = {
"     enable = true,                 -- false will disable the whole extension
"     -- disable = { "c", "rust" },  -- list of language that will be disabled
"     additional_vim_regex_highlighting = false,
"   },
" }
" EOF

" ----------Configure Nvim-tree----
nnoremap <C-n> :NvimTreeToggle<CR>
lua <<EOF
require'nvim-tree'.setup()
EOF


" ----------Configure LSP-diagnostics ----------
lua <<EOF
-- Enable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
    signs = true,
    update_in_insert = true,
  }
)
EOF


" ----------GITSIGNS SETUP----------
lua << EOF
require('gitsigns').setup()
EOF

""LSP config
"Async Lsp Finder
nnoremap <silent> gh <cmd>lua require'lspsaga.provider'.lsp_finder()<CR>
nnoremap <silent> gh :Lspsaga lsp_finder<CR>
"Code Action
nnoremap <silent>ga :Lspsaga code_action<CR>
vnoremap <silent>ga :<C-U>Lspsaga range_code_action<CR>
" Hover Docs
nnoremap <silent>K :Lspsaga hover_doc<CR>
" -- scroll down hover doc or scroll in definition preview
nnoremap <silent> <C-b> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>
" -- scroll up hover doc
nnoremap <silent> <C-f> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>
" SignatureHelp
nnoremap <silent> gs :Lspsaga signature_help<CR>
" Rename
nnoremap <silent>gr :Lspsaga rename<CR>
" Preview Definition
nnoremap <silent> gd :Lspsaga preview_definition<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> ]g :Lspsaga diagnostic_jump_next<CR>
nnoremap <silent> [g :Lspsaga diagnostic_jump_prev<CR>

"-- scroll down hover doc or scroll in definition preview

nnoremap <silent> <C-f> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>
"-- scroll up hover doc
nnoremap <silent> <C-b> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>

" Set updatetime for CursorHold
" 300ms of no cursor movement to trigger CursorHold
" set updatetime=300
" Show diagnostic popup on cursor hover
autocmd CursorHold * lua vim.lsp.diagnostic._define_default_signs_and_highlights()


"" ----------CONFIGURE FORMATTER----------
lua << EOF
require('formatter').setup(
{
  logging = false,
  filetype = {
    rust = {
      -- Rustfmt
      function()
        return {
          exe = "rustfmt",
          args = {"--emit=stdout"},
          stdin = true
        }
      end
      }, julia = {


      }

    }})
vim.api.nvim_exec([[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost *.js,*.rs,*.lua FormatWrite
augroup END
]], true)
EOF

""------------------------------------------------
" -----------------------------------------------
" END PLUGIN CONFIG
" -----------------------------------------------
" persist START
set undofile " Maintain undo history between sessions
set undodir=~/.local/share/nvim/undo

" Persist cursor
autocmd BufReadPost *
            \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
            \ |   exe "normal! g`\""
            \ | endif
" persist END
"------------------------------------------------

autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *.rs
\ lua require'lsp_extensions'.inlay_hints{ prefix = '', highlight = "Comment", enabled = {"TypeHint", "ChainingHint", "ParameterHint"} }
"------------------------------------------------
" Theme START
if (has("nvim"))
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif
if (has("termguicolors"))
    set termguicolors
endif

syntax on

let g:tokyonight_style = 'night' " available: night, storm
let g:tokyonight_enable_italic = 1

colorscheme tokyonight
set background=dark
set cursorline
" Theme END
"------------------------------------------------


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
noremap <SPACE> <Nop>
noremap <Up>    :5winc -<CR>
noremap <Down>  :5winc +<CR>
noremap <Left>  :5winc <<CR>
noremap <Right> :5winc ><CR>

" let mapleader = " "
let g:mapleader = "\<Space>"
let g:maplocalleader = ','
let g:which_key_map =  {}
call which_key#register('<Space>', "g:which_key_map")
nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
" Define prefix dictionary

" Search mappings
let g:which_key_map.s = {'name': 'search'}
nmap <leader>sz :FZF<CR>
map <leader>sg :Rg<space>
let g:which_key_map.s.z = 'FZF-file-search'
let g:which_key_map.s.g = 'grep-search'
" File mappings
let g:which_key_map.f = { 'name' : 'file' }
nnoremap <silent> <leader>fs :update<CR>
let g:which_key_map.f.s = 'save-file'

map <silent> <leader><ESC> :noh<CR>
let g:which_key_map['<Esc>'] = 'clear-search'
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-H> <C-W>h
nnoremap <C-L> <C-W>l

" LSP saga
nnoremap <silent> <leader>d :Lspsaga show_line_diagnostics<CR>
let g:which_key_map.d = {'name': 'diagnostics'}


" GITSIGNS
let g:which_key_map.h = {'name': 'hunks'}
let g:which_key_map.h.p = 'preview'
let g:which_key_map.h.b = 'blame'
let g:which_key_map.h.u = 'undo'
let g:which_key_map.h.r = 'reset hunk'
let g:which_key_map.h.s = 'stage'
let g:which_key_map.h.R = 'reset buffer'

nnoremap <leader>g :Git<CR>
let g:which_key_map.g = {'name': 'git'}

nnoremap <Leader>l :ls<CR>:b<Space>
let g:which_key_map.l = 'list-buffers'

nnoremap <leader>w :ToggleWorkspace<CR>
let g:which_key_map.w = 'workspace-toggle'

let g:which_key_map.o = {'name': 'format'}

"CHEATSHEET
nnoremap <leader>? :Cheatsheet<CR>
