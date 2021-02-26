"" -----------------------------------------------
" PLUGIN CONFIG
" -----------------------------------------------

"COC
" Give more space for displaying messages.
" set cmdheight=2
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif
" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> ga <Plug>(coc-codeaction-selected)
" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

function! CocMinimalStatus() abort
  return get(g:, 'coc_status', '')
endfunction

" let g:airline_section_c = '%t %#LineNr#%{CocMinimalStatus()}'

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')
augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end set omnifunc=ale#completion#OmniFunc


" air-line
let g:airline_theme = "tokyonight"
let g:airline#extensions#tabline#enabled = 1
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif


" airline symbols
let g:airline_left_sep = "\uE0Bc"
let g:airline_left_alt_sep = "\ue216"
let g:airline_right_sep = "\ue0ba"

" MINIMAP
" let g:minimap_auto_start = 1

" Workspaces
let g:workspace_session_directory = $HOME . '/.local/share/nvim/sessions/'
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
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'jiangmiao/auto-pairs'
Plug 'chrisbra/csv.vim'
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'machakann/vim-highlightedyank'
Plug 'liuchengxu/vim-which-key'
Plug 'kshenoy/vim-signature'
Plug 'tpope/vim-unimpaired'
Plug 'qpkorr/vim-bufkill'
Plug 'thaerkh/vim-indentguides'
" Plug 'wfxr/minimap.vim', {'do': ':!cargo install --locked code-minimap'}
Plug 'thaerkh/vim-workspace'
Plug 'mbbill/undotree'
" Plug 'mhinz/vim-startify'
" should always go last
Plug 'ryanoasis/vim-devicons'
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
set scrolloff=5
set clipboard+=unnamedplus
set diffopt+=vertical

" Settings END
"------------------------------------------------

"------------------------------------------------
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
nnoremap <leader>b :NERDTreeFocus<CR>
let g:which_key_map.b = 'file-browser'
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>


let g:which_key_map.o = {'name': 'format'}

nnoremap <leader>u :UndotreeToggle<CR>
let g:which_key_map.u = 'Undo tree'
