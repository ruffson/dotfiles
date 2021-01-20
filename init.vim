"" -----------------------------------------------
" PLUGIN CONFIG
" -----------------------------------------------

  set omnifunc=ale#completion#OmniFunc
  let g:ale_completion_enabled = 1
  let g:ale_completion_autoimport = 1
  let g:ale_sign_column_always = 1
  let g:ale_fix_on_save = 1
  let g:ale_sign_error = '✗'
  " let g:ale_sign_warning = ''
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

  let g:user_emmet_leader_key='<C-/>'

  let g:lightline = {
      \ 'colorscheme': 'one',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'readonly', 'filename', 'modified' ] ]
      \ ,
      \   'right': [ [ 'lineinfo' ],
      \              ['linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok' ],
      \              [ 'percent' ],
      \              [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component_function': {
      \   'filename': 'LightlineFilename',
      \ },
      \ 'component_expand': {
      \   'buffers': 'lightline#bufferline#buffers',
      \  'linter_checking': 'lightline#ale#checking',
      \  'linter_infos': 'lightline#ale#infos',
      \  'linter_warnings': 'lightline#ale#warnings',
      \  'linter_errors': 'lightline#ale#errors',
      \  'linter_ok': 'lightline#ale#ok',
      \ },
      \ 'component_type': {
      \     'linter_checking': 'right',
      \     'linter_infos': 'right',
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \     'linter_ok': 'right',
      \   'buffers': 'tabsel',
      \ },
      \ 'tabline': {
      \   'left': [ ['buffers'] ],
      \   'right': [ ['close'] ]
      \ }
  \ }
    " let buffers be clickable
    let g:lightline#bufferline#clickable=1
    let g:lightline#bufferline#shorten_path=1
    let g:lightline#bufferline#min_buffer_count=1
    let g:lightline#bufferline#show_number=1
    let g:lightline#bufferline#enable_devicons=1
  " let g:lightline#ale#indicator_checking = "\uf110"
  " let g:lightline#ale#indicator_infos = "\uf129"
  " let g:lightline#ale#indicator_warnings = "\uf071"
  " let g:lightline#ale#indicator_errors = "\uf05e"
  " let g:lightline#ale#indicator_ok = "\uf00c"
  " let g:lightline.separator = {
      " \   'left': '', 'right': ''
  " \}
  " let g:lightline.subseparator = {
      " \   'left': '', 'right': ''
  " \}
  function! LightlineFilename()
    return expand('%:t') !=# '' ? @% : '[No Name]'
  endfunction



" -----------------------------------------------
" END PLUGIN CONFIG
" -----------------------------------------------

" Plugins START
call plug#begin()
  Plug 'airblade/vim-gitgutter'
  Plug 'cespare/vim-toml'
  Plug 'editorconfig/editorconfig-vim'
  Plug 'itchyny/lightline.vim'
  Plug 'junegunn/vim-easy-align'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'mengelbrecht/lightline-bufferline'
  Plug 'tpope/vim-commentary'
  Plug 'ghifarit53/tokyonight-vim'
  Plug 'dense-analysis/ale'
  Plug 'maximbaz/lightline-ale'
  Plug 'jiangmiao/auto-pairs'
  Plug 'preservim/nerdtree'

call plug#end()
" Plugins END
"------------------------------------------------

"------------------------------------------------
" Settings START
let mapleader = "\<Space>"
filetype plugin on
set completeopt=menuone
set mouse=a
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

" let g:lightline = {
"       \ 'colorscheme': 'one',
"       \ 'active': {
"       \   'left': [ [ 'mode', 'paste' ], [ 'readonly', 'filename', 'modified' ] ]
"       \ },
"       \ 'tabline': {
"       \   'left': [ ['buffers'] ],
"       \   'right': [ ['close'] ]
"       \ },
"       \ 'component_expand': {
"       \   'buffers': 'lightline#bufferline#buffers'
      " \ },
      " \ 'component_type': {
      " \   'buffers': 'tabsel'
      " \ }
      " \ }




" Theme END
"------------------------------------------------


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
noremap <SPACE> <Nop>
noremap <Up>    :1winc -<CR>
noremap <Down>  :1winc +<CR>
noremap <Left>  :1winc <<CR>
noremap <Right> :1winc ><CR>

let mapleader = " "

nmap <leader><CR> :FZF<CR>
nmap <silent> <leader><leader> :w!<CR>
" nmap <silent> <F11> <Plug>(ale_previous_wrap)
" nmap <silent> <F23> <Plug>(ale_next_wrap)
nnoremap <leader>g :ALEGoToDefinition<CR>
nnoremap <leader>r :ALEFindReferences<CR>

map <leader>s :Rg<space>
map <silent> <leader><ESC> :noh<CR>
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" NERDTREE
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
"au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
