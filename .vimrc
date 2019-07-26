set mouse=a
map <ScrollWheelUp> <C-Y>
map <ScrollWheelDown> <C-E>

set backspace=indent,eol,start "backspace is unstoppable

"jk don't skip the part of the line that was wrapped
nnoremap j gj
nnoremap k gk

set esckeys "esc is fast
set ttimeoutlen=50 "ms waited to timeout a key code
"set ttimeoutlen& "set to default
set ttyfast "more chars are sent to the screen for redrawing

set fileencoding=utf-8 "used for the file
set encoding=utf-8 "used 'inside' vim to display

set hidden "no longer prompts for save when opening a file to current buffer

" sane swap/recovery files and full undo history
set backupdir=~/.tmp//
set directory=~/.tmp//
set undofile
set undodir=~/.tmp//

set tabstop=4 "tab will show as x spaces
set softtabstop=4 "tab will insert/delete x spaces
set shiftwidth=4 ">>, << and  == will shift x spaces
set expandtab "all inserted/shifted tabs become spaces
set autoindent "copies the indent of line above
set nosmartindent "(smart indent is useless for python)

set listchars=tab:t·,space:·,trail:! "show invisible chars with :set list"

set hlsearch "highlight found patterns with /
set incsearch "highligt as you type
set ignorecase "ignore case...
set smartcase "UnLeSs YoU hAvE a CaPiTaL lEtTeR iN iT
" hlsearch colors define after theme is applied below

set cursorline "highlight line the cursor is in
set number "show line number
" set textwidth=90 "add newline when text reaches 90 chars
set colorcolumn=80 "highlight column 90
set formatoptions=l "won't break the line while in insert mode

set splitbelow "horizontal splits open below the current pane
"set splitright "vertical splits open to the right of the current pane

set showcmd "show current command input sequence on last line of the screen.

nnoremap <F2> :source ~/.vimrc<cr>:echo "vimrc reloaded"<cr>

"Leader mappings
let mapleader="\<Space>"
"make the background transparent
nnoremap <leader>c :hi Normal guibg=NONE ctermbg=NONE<cr>
nnoremap <leader>n :noh<cr>
nnoremap <leader>l :set list!<cr>
nnoremap <leader>r :registers<cr>
nnoremap <leader>j :jumps<cr>
nnoremap <leader>m :marks<cr>
nnoremap <leader>e :edit<cr>

nnoremap <leader>g :GitGutter<cr>:echo "GitGutter refresh"<cr>
nnoremap <leader>hs :GitGutterStageHunk<cr>
nnoremap <leader>hu :GitGutterUndoHunk<cr>

"buffer management"
nnoremap <leader>b :ls<CR>:b<Space>

"autoclose tags
"inoremap ( ()<Left>
"inoremap { {}<Left>
"inoremap [ []<Left>
"inoremap " ""<Left>

"Trying to change split in insert mode just ESCapes"
inoremap <c-h> <ESC>
inoremap <c-j> <ESC>
inoremap <c-k> <ESC>
inoremap <c-l> <ESC>
"Control Find"
nnoremap <c-f> /

"HJKL in normal mode
"J and K in normal mode could be better"
nnoremap K :bnext<cr>
nnoremap J :bprev<cr>
"For convenience, those stay here"
" nnoremap H B
" vnoremap H B
" nnoremap L E
" vnoremap L E
" vnoremap J }
" vnoremap K {


call plug#begin('~/.vim/plugged')
Plug 'itchyny/lightline.vim'
Plug 'djoshea/vim-autoread'
Plug '907th/vim-auto-save'
Plug '~/.fzf'
Plug 'junegunn/fzf.vim'
"Plug 'terryma/vim-multiple-cursors'
Plug 'jnurmine/zenburn'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-surround'
Plug 'airblade/vim-gitgutter'
Plug 'dracula/vim', { 'as': 'dracula' },
Plug 'tpope/vim-fugitive',
"Plug 'ap/vim-buftabline'
call plug#end()

" lightline.vim needs it
set laststatus=2
set noshowmode
" vim-auto-save
let g:auto_save = 1
" fzf vim
nnoremap <C-p> :Files<cr>
" zenburn:
" colors dracula
set term=screen-256color
hi Search ctermfg=209
hi Search ctermbg=237
hi IncSearch ctermfg=209
hi IncSearch ctermbg=233
" git gutter:
set updatetime=100
" write swp file after 100 if nothing happens
let g:gitgutter_override_sign_column_highlight = 0
let g:gitgutter_terminal_reports_focus=0
highlight SignColumn ctermbg=0
highlight GitGutterAdd ctermfg=2 ctermbg=0
highlight GitGutterChange ctermfg=3 ctermbg=0
highlight GitGutterDelete ctermfg=1 ctermbg=0
" colors must be here to override zenburn
":highlight #will show the current colors

