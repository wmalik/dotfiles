" Configuration file for vim
set modelines=0		" CVE-2007-2438

" Normally we use vim-extensions. If you want true vi-compatibility
" remove change the following statements
set nocompatible	" Use Vim defaults instead of 100% vi compatibility
set backspace=2		" more powerful backspacing

" Don't write backup file if vim is being called by "crontab -e"
au BufWrite /private/tmp/crontab.* set nowritebackup
" Don't write backup file if vim is being called by "chpass"
au BufWrite /private/etc/pw.* set nowritebackup


" Pathogen stuff
call pathogen#infect()
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

syntax on
filetype on " File type identification
filetype plugin on " Enable filetype plugins
filetype indent on " Enable filetype indent
set nofoldenable

colorscheme jellybeans

" http://stevelosh.com/blog/2010/09/coming-home-to-vim
set encoding=utf-8
set scrolloff=3
set autoindent
set showmode
set showcmd
"set hidden " dont really like the fact that the buffers stay open
set wildmenu
set wildmode=list:longest
set visualbell
set cursorline
set ttyfast
set ruler
set backspace=indent,eol,start
set laststatus=2
"set undofile
set nowrap
set textwidth=79
set formatoptions=qrn1
set listchars=tab:▸\ ,eol:¬
let mapleader = ","
nnoremap <leader>w <C-w>v<C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
map <leader>n :NERDTreeToggle<CR>

set number
" For smart indenting
"set smartindent "'smartindent' and 'cindent' might interfere with file type
""based indentation, and should never be used in conjunction with it.
set tabstop=4
set shiftwidth=4
set expandtab "pressing tab inserts spaces
map <C-l> :tabnext<CR>
map <C-h> :tabprev<CR>
map <Tab>n :tabnew<CR>
map <Tab>d :tabclose<CR>
" For disabling the macvim toolbar
if has("gui_running")
    set guioptions=egmrt
endif
" Press Space to turn off highlighting and clear any message already displayed
:nnoremap <silent> <Space> :noh<Bar>:echo<CR>
:nnoremap <C-Space> :noh<Bar>:echo<CR>
"
" Toggle newline/tab view
map <leader>k :set list!<CR>
set directory=/tmp "this is to store all sw* files in /tmp
set incsearch
set hlsearch

map <leader>v :tabedit ~/.vimrc<CR>
set ignorecase
if exists('+colorcolumn')
  set colorcolumn=80
else
  au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif



nmap <leader>f :grep <c-r>=expand("<cword> *")<cr>
map :W :w

" Relative Line numbers
"au InsertEnter * :set number
au InsertLeave * :set relativenumber
au FocusLost * :set number
au FocusGained * :set relativenumber

"yank from cursor till end-of-line
:map Y y$

" ##### Erlang
" remove an erlang binary term
map <leader>B 2F<d2f>i
set tw=80 "for gq
"ignore binary files
:set wildignore=*.o,*~,*.beam,*.swf,*.mp3,*.jpg,*.png,ebin
" remove trailing whitespace and save the file
map <leader><Space> $x<Esc>:w<CR>
" searches for a tags file in the higher level directories until it is found
" enables tag browsing no matter where the src is
set tags=./tags;/
let g:erlangManPath = "/usr/local/Cellar/erlang/R15B01/share/man"
"let g:erlangHighlightErrors = 0

" highlight extra whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
