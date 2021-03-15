
" Plugins START
call plug#begin()
Plug 'airblade/vim-gitgutter'
Plug 'cespare/vim-toml'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-commentary'
Plug 'ghifarit53/tokyonight-vim'
Plug 'jiangmiao/auto-pairs'
Plug 'chrisbra/csv.vim'
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
Plug 'machakann/vim-highlightedyank'
Plug 'liuchengxu/vim-which-key'
Plug 'kshenoy/vim-signature'
Plug 'tpope/vim-unimpaired'
Plug 'qpkorr/vim-bufkill'
" Plug 'norcalli/snippets.nvim'
Plug 'thaerkh/vim-workspace'
Plug 'mbbill/undotree'
Plug 'mg979/vim-visual-multi'
Plug 'JuliaEditorSupport/julia-vim'
" --> Neovim 5 only:
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp_extensions.nvim'
" Plug 'nvim-lua/completion-nvim'
Plug 'hrsh7th/nvim-compe'
Plug 'hrsh7th/vim-vsnip'
Plug 'mhartington/formatter.nvim'
Plug 'glepnir/lspsaga.nvim'
" --> Neovim 5
" should always go last
Plug 'ryanoasis/vim-devicons'
call plug#end()
" Plugins END
"------------------------------------------------

"------------------------------------------------
" Settings START
filetype plugin indent on
" set completeopt=menuone
" set mouse=a
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

" Settings END
"------------------------------------------------

"" -----------------------------------------------
" PLUGIN CONFIG
" -----------------------------------------------
"" air-line
let g:airline_theme = "tokyonight"
let g:airline#extensions#tabline#enabled = 1
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif


" Workspaces
let g:workspace_session_directory = $HOME . '/.local/share/nvim/sessions/'
let g:workspace_autocreate = 1
let g:workspace_session_disable_on_args = 1
let g:workspace_persist_undo_history = 0
let g:workspace_autosave = 0

"NERDTREE
" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif


" If another buffer tries to replace NERDTree, put in the other window, and bring back NERDTree.
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

let g:NERDTreeGitStatusUseNerdFonts = 1

" Syntax highlighting for embedded lua
let g:vimsyn_embed= 'l'

" LSP config
set completeopt=menu,menuone,noselect
" Avoid showing extra messages when using completion
set shortmess+=c

" Configure LSP
lua <<EOF
-- nvim_lsp object
local nvim_lsp = require'lspconfig'

-- function to attach completion when setting up lsp
-- local on_attach = function(client)
-- end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Enable rust_analyzer
nvim_lsp.rust_analyzer.setup({
    capabilities=capabilities,
    -- on_attach=on_attach

    })

-- Enable Julials
nvim_lsp.julials.setup({
    capabilities=capabilities,
    -- on_attach=on_attach
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
        }
    }
    })


-- Enable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
    signs = true,
    update_in_insert = true,
  }
)
EOF

" Code navigation shortcuts
" as found in :help lsp
" nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
" nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
" nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
" nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
" nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
" nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
" nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
" nnoremap <silent> ga    <cmd>lua vim.lsp.buf.code_action()<CR>
" Goto previous/next diagnostic warning/error
nnoremap <silent> ]g <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <silent> [g <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
" rust-analyzer does not yet support goto declaration
" re-mapped `gd` to definition
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
"nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
" use <tab> and <s-tab> to navigate through popup menu


" Completion
lua <<EOF
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    vsnip = true;
    nvim_lsp = true;
    nvim_lua = true;
    spell = true;
    tags = true;
    snippets_nvim = true;
    treesitter = true;

  };
}
EOF

inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
" inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })
inoremap <expr> <tab>   pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr> <s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"
" use <tab> as trigger keys
"




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
nnoremap <silent> [g :Lspsaga diagnostic_jump_next<CR>
nnoremap <silent> ]g :Lspsaga diagnostic_jump_prev<CR>


" Set updatetime for CursorHold
" 300ms of no cursor movement to trigger CursorHold
" set updatetime=300
" Show diagnostic popup on cursor hover
 autocmd CursorHold * lua vim.lsp.diagnostic._define_default_signs_and_highlights()

" goto previous/next diagnostic warning/error
" nnoremap <silent> [g <cmd>lua vim.lsp.diagnostic.goto_prev()<cr>
" nnoremap <silent> ]g <cmd>lua vim.lsp.diagnostic.goto_next()<cr>
" enable type inlay hints
" " rust end
"lsp config

"" Configure Formatter 
"
"
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
"
"
" End Formatter
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


"GIT-gutter
let g:which_key_map.h = {'name': 'hunks'}
let g:which_key_map.h.p = 'preview'
let g:which_key_map.h.u = 'undo'
let g:which_key_map.h.s = 'stage'
nnoremap <leader>hn :GitGutterNextHunk<CR>
let g:which_key_map.h.n = 'next'
nnoremap <leader>hN :GitGutterPrevHunk<CR>
let g:which_key_map.h.N = 'previous'

nnoremap <leader>g :Git<CR>
let g:which_key_map.g = {'name': 'git'}

nnoremap <Leader>l :ls<CR>:b<Space>
let g:which_key_map.l = 'list-buffers'

nnoremap <leader>w :ToggleWorkspace<CR>
let g:which_key_map.w = 'workspace-toggle'

"NERDTREE
nnoremap <C-t> :NERDTreeToggle<CR>


let g:which_key_map.o = {'name': 'format'}

nnoremap <leader>u :UndotreeToggle<CR>
let g:which_key_map.u = 'Undo tree'
