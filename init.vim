"" -----------------------------------------------
" PLUGIN CONFIG
" -----------------------------------------------

set omnifunc=ale#completion#OmniFunc
let g:ale_completion_enabled = 1
let g:ale_completion_autoimport = 1
let g:ale_sign_column_always = 1
let g:ale_fix_on_save = 1
let g:ale_sign_error = '✗'
let g:ale_sign_warning = ''
let g:ale_linters = {'rust': ['analyzer']}
let g:ale_fixers = {
            \   '*': ['remove_trailing_lines', 'trim_whitespace'],
            \   'javascript': ['eslint'],
            \   'typescript': ['eslint','tslint', 'xo'],
            \   'css': ['stylelint', 'fecs'],
            \   'rust': ['rustfmt']
            \}
inoremap <silent><expr> <Tab>
            \ pumvisible() ? "\<C-n>" : "\<TAB>"

let g:airline#extensions#ale#enabled = 1
let g:airline_theme = "tokyonight"
let g:airline#extensions#tabline#enabled = 1
" air-line
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

" MINIMAP
" let g:minimap_auto_start = 1

" Workspaces
let g:workspace_session_directory = $HOME . '/.local/share/nvim/sessions/'
let g:workspace_session_disable_on_args = 1

" -----------------------------------------------
" END PLUGIN CONFIG
" -----------------------------------------------

" Plugins START
call plug#begin()
Plug 'airblade/vim-gitgutter'
Plug 'cespare/vim-toml'
Plug 'editorconfig/editorconfig-vim'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-commentary'
Plug 'ghifarit53/tokyonight-vim'
Plug 'dense-analysis/ale'
Plug 'jiangmiao/auto-pairs'
" Plug 'preservim/nerdtree'
Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'machakann/vim-highlightedyank'
Plug 'liuchengxu/vim-which-key'
Plug 'kshenoy/vim-signature'
Plug 'tpope/vim-unimpaired'
Plug 'qpkorr/vim-bufkill'
" Plug 'wfxr/minimap.vim', {'do': ':!cargo install --locked code-minimap'}
Plug 'thaerkh/vim-workspace'
call plug#end()
" Plugins END
"------------------------------------------------

"------------------------------------------------
" Settings START
filetype plugin on
set completeopt=menuone
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
" Settings END
"------------------------------------------------

"------------------------------------------------
" persist START
set undofile " Maintain undo history between sessions
set undodir=~/.vim/undodir

" Persist cursor
autocmd BufReadPost *
            \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
            \ |   exe "normal! g`\""
            \ | endif
" persist END
"------------------------------------------------

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

" nmap <silent> <F11> <Plug>(ale_previous_wrap)
" nmap <silent> <F23> <Plug>(ale_next_wrap)
let g:which_key_map.a = {'name': 'ALE'}
nnoremap <leader>an :ALENextWrap<CR>
let g:which_key_map.a.n = 'next-problem'
nnoremap <leader>ap :ALEPreviousWrap<CR>
let g:which_key_map.a.p = 'previous-problem'
nnoremap <leader>ag :ALEGoToDefinition<CR>
let g:which_key_map.a.g = 'go-to-definition'
nnoremap <leader>ar :ALEFindReferences<CR>
let g:which_key_map.a.r = 'find-reference'

map <silent> <leader><ESC> :noh<CR>
let g:which_key_map['<Esc>'] = 'clear-search'
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-H> <C-W>h
nnoremap <C-L> <C-W>l

"CHADtree
nnoremap <leader>b <cmd>CHADopen<cr>
let g:which_key_map.b = 'file-browser'

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
" nnoremap <leader>n :NERDTreeFocus<CR>
" nnoremap <C-n> :NERDTree<CR>
" nnoremap <C-t> :NERDTreeToggle<CR>
" nnoremap <C-f> :NERDTreeFind<CR>
