" @Author: Wasif Malik (wmalik@gmail.com)
" @Reference: Some stuff taken from this blog post:
"             http://stevelosh.com/blog/2010/09/coming-home-to-vim


" -----------------------------------
" -------- Pathogen stuff -----------
" -----------------------------------
call pathogen#infect()
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()


" -----------------------------------
" ------- Absolute essentials -------
" -----------------------------------

set nocompatible	" Use Vim defaults instead of 100% vi compatibility
colorscheme jellybeans
syntax on
filetype on " File type identification
filetype plugin on " Enable filetype plugins
filetype indent on " Enable filetype indent
set nofoldenable
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
set textwidth=80
set formatoptions=qrn1
set listchars=tab:▸\ ,eol:¬
set number

" For smart indenting
"set smartindent "'smartindent' and 'cindent' might interfere with file type
""based indentation, and should never be used in conjunction with it.
set tabstop=4
set shiftwidth=4
set expandtab "pressing tab inserts spaces
" For disabling the macvim toolbar
if has("gui_running")
    set guioptions=egmrt
endif
"
set directory=/tmp "this is to store all sw* files in /tmp
set incsearch
set hlsearch

set ignorecase
if exists('+colorcolumn')
  set colorcolumn=80
else
  au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif
"" Example :Man grep
runtime! ftplugin/man.vim
" searches for a tags file in the higher level directories until it is found
" enables tag browsing no matter where the src is
set tags=./tags;/
" highlight extra whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
set tw=80
" Relative Line numbers
set relativenumber
set wildignore=*.o,*~,*.beam,*.swf,*.mp3,*.jpg,*.png,ebin



" -----------------------------------
" ------------ Shortcuts ------------
" -----------------------------------

" Execute the command on current line and paste the output below
map <F5> yyp!!sh<CR><Esc>
" shortcut to run a shell command and paste the output in a scratch buffer
" Example :R ls -l
command! -nargs=* -complete=shellcmd R new | setlocal buftype=nofile bufhidden=hide noswapfile  | r !<args>
" grep the word under cursor (case insensitive) in multiple directories
nmap <leader>f :R grep -irn <c-r>=expand("<cword> *")<cr> src lib include test script
" shortcut to find a string in multiple src dirs, example :F something
command! -nargs=* F new | setlocal buftype=nofile bufhidden=hide noswapfile | set ft=erlang | r !grep -irn <args> src lib include test script
" Open a scratch buffer
command! S new | setlocal buftype=nofile bufhidden=hide noswapfile
" Open my notes files in a new buffer and go to the last line
command! Notes 20new ~/notes/transient.txt | set filetype=markdown | %
map <F1> :Notes<CR>G
" Get the current unix timestamp
command! Timestamp r! date \+\%s
" Get nicely formatted time stamp
command! Date r! date \+\[\%Y-\%m-\%d\ \%H:\%M:\%S\]
" Open my ~/.vimrc
command! Vimrc :tabedit ~/.vimrc

let mapleader = ","
inoremap jj <ESC>
nnoremap <leader>w <C-w>v<C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
map <leader>n :NERDTreeToggle<CR>
map <C-l> :tabnext<CR>
map <C-h> :tabprev<CR>
map <Tab>n :tabnew<CR>
map <Tab>d :tabclose<CR>
nnoremap <silent> <Space> :noh<Bar>:echo<CR>
nnoremap <C-Space> :noh<Bar>:echo<CR>
" Toggle newline/tab view
map <leader>k :set list!<CR>
map <leader>v :tabedit ~/.vimrc<CR>
map :W :w
map Y y$
nnoremap L $
nnoremap H ^


" -----------------------------------
" ------------- Mouse ---------------
" -----------------------------------
set mouse=a

" -----------------------------------
" ----------- Erlang ----------------
" -----------------------------------
map <leader>B 2F<d2f>i ""remove an erlang binary term
"ignore binary files
" remove trailing whitespace and save the file
map <leader><Space> $x<Esc>:w<CR>
let g:erlangManPath = "/usr/local/Cellar/erlang/R15B01/share/man"
"let g:erlangHighlightErrors = 0
"let g:erlangHighlightBif = 1
