" @Author: Wasif Malik (wmalik@gmail.com)
" @Reference: Some stuff taken from these awesome blog posts:
"             http://stevelosh.com/blog/2010/09/coming-home-to-vim
"             http://learnvimscriptthehardway.stevelosh.com/


" Pathogen stuff {{{
call pathogen#infect()
call pathogen#incubate()
call pathogen#helptags()
"}}}

" Absolute essentials {{{
set nocompatible	" Use Vim defaults instead of 100% vi compatibility
set nofoldenable
colorscheme Tomorrow-Night
syntax on
filetype on
filetype plugin on
filetype indent on
set encoding=utf-8
set scrolloff=3
set autoindent
set showmode
set showcmd
"set hidden " dont really like the fact that the buffers stay open
set wildmenu
set wildmode=list:longest
set novisualbell
set cursorline
set ttyfast
set ruler
set backspace=indent,eol,start
set laststatus=2
set nowrap
set sidescroll=1
set textwidth=80
set formatoptions=qrn1
set listchars=tab:▸\ ,eol:¬
set number
set smartcase
set showmatch

" For smart indenting
"set smartindent "'smartindent' and 'cindent' might interfere with file type
""based indentation, and should never be used in conjunction with it.
set tabstop=4
set shiftwidth=4
set expandtab "pressing tab inserts spaces
if has("gui_running")
    set mouse=a
    set guioptions=egmrt
    set guioptions-=m
    set guifont=Inconsolata\ Medium\ 9
    "
    " Set cursor color in different modes
    highlight Cursor guifg=black guibg=lightgreen
    highlight iCursor guibg=red
    set guicursor=n-v-c:block-Cursor
    set guicursor+=i:ver25-iCursor
    set guicursor+=n-v-c:blinkon0
    "set guicursor+=i:blinkwait10
endif

set directory=/tmp "this is to store all sw* files in /tmp
set incsearch
set hlsearch

set ignorecase
set colorcolumn=80
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
set wildignore=*.o,*~,*.beam,*.swf,*.mp3,*.jpg,*.png,ebin
if filereadable(".vimrc.project")
    so .vimrc.project
endif
"}}}

" Shortcuts {{{

" shortcut to run a shell command and paste the output in a scratch buffer
command! -nargs=* -complete=shellcmd R new | setlocal buftype=nofile bufhidden=hide noswapfile  | r !<args>
" grep the word under cursor (case insensitive) in multiple directories
nmap <leader>f :R grep -sirn <c-r>=expand("<cword> *")<cr> src include test script
" shortcut to find a string in multiple src dirs, example :F something
command! -nargs=* F new | setlocal buftype=nofile bufhidden=hide noswapfile | set ft=erlang | r !grep -sirn --exclude=tags --exclude-dir=log --exclude-dir=ebin --exclude-dir=assets --exclude-dir=public <args> .
" Open a scratch buffer
command! S new | setlocal buftype=nofile bufhidden=hide noswapfile
command! T tabnew | setlocal buftype=nofile bufhidden=hide noswapfile
" Open my notes files in a new buffer and go to the last line
command! Notes tabnew ~/.notes | set filetype=markdown | %

" Get the current unix timestamp
command! Timestamp r! date \+\%s
" Get nicely formatted time stamp
nnoremap <leader>d :r! date \+\[\%Y-\%m-\%d\ \%H:\%M:\%S\]<cr>


let mapleader = ","
inoremap jk <Esc>
nnoremap <leader>w <C-w>v<C-w>l
nnoremap <C-j> <C-w>w
nnoremap <C-k> <C-w>W
nnoremap <Backspace> <C-w>w
nnoremap <S-Backspace> <C-w>W
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <C-l> :tabnext<CR>
nnoremap <C-h> :tabprev<CR>
nnoremap <Tab>n :tabnew<CR>
nnoremap <Tab>d :tabclose<CR>
noremap <silent> <Space> :noh<Bar>:echo<CR>
nnoremap <leader>k :set list!<CR>
nnoremap :W :w
nnoremap Y 0y$
nnoremap 9 $
inoremap <C-a> <C-o>^
inoremap <C-e> <C-o>$
"}}}

" Mouse {{{
"set mouse=a
"}}}

" Erlang {{{
"remove an erlang binary term
nnoremap <leader>B 2F<d2f>i
"ignore binary files
" remove trailing whitespace and save the file
nnoremap <leader><Space> $x<Esc>:w<CR>
let g:erlangManPath = "/usr/share/man/man1"
"let g:erlangHighlightErrors = 0
"let g:erlangHighlightBif = 1
command! Er set ft=erlang
"}}}

" Plugin Conf {{{
let g:CommandTMaxHeight=10
"}}}

" Steve Losh Learning Vimscript the Hard Way
" move a line upward or downward
nnoremap - ddp
nnoremap _ ddkP

" Delete current line in insert mode
inoremap <c-d> <esc>ddi

" Convert the current word to uppercase insert mode
inoremap <C-u> <Esc>viwUea

iabbrev adn and
iabbrev @@ wmalik@gmail.com
nnoremap <leader>ve :vsplit $MYVIMRC<cr>
nnoremap <leader>vs :source ~/.vimrc<cr>

" surround a word or a visual block with "" (doesnt work with v-line)
vnoremap <leader>" <esc>`<i"<esc>`>la"
nnoremap <leader>" viw<esc>a"<esc>hbi"<esc>lel
inoremap <C-q> <Esc>viw<esc>a"<esc>hbi"<esc>lela
" surround a word or a visual block with {} (doesnt work with v-line)
vnoremap <leader>{ <esc>`<i}<esc>`>la{
nnoremap <leader>{ viw<esc>a}<esc>hbi{<esc>lel
inoremap <C-q> <Esc>viw<esc>a}<esc>hbi{<esc>lela
" surround a word or a visual block with {} (doesnt work with v-line)
vnoremap <leader>( <esc>`<i)<esc>`>la(
nnoremap <leader>( viw<esc>a)<esc>hbi(<esc>lel
inoremap <C-q> <Esc>viw<esc>a)<esc>hbi(<esc>lela
" surround a word or a visual block with {} (doesnt work with v-line)
vnoremap <leader>[ <esc>`<i]<esc>`>la[
nnoremap <leader>[ viw<esc>a]<esc>hbi[<esc>lel
inoremap <C-q> <Esc>viw<esc>a]<esc>hbi[<esc>lela

" surround a word or a visual block with '' (doesnt work with v-line)
vnoremap <leader>" <esc>`<i'<esc>`>la'
nnoremap <leader>' viw<esc>a'<esc>hbi'<esc>lel
noh
" Insert a character at the end of line
nnoremap <leader>, :normal! mqA,<esc>`q
nnoremap <leader>. :normal! mqA.<esc>`q
nnoremap <leader>; :normal! mqA;<esc>`q

" generate exuberant ctags for all directories excluding the assets directory
nnoremap <leader>ct :!ctags -R --exclude=assets *<cr>


" Notes {{{
" Taken from bare bones vim http://vimeo.com/65250028
" makes navigation easier without ctags (use gf)
" set path=**
" set suffixesadd=.erl,.hrl
" }}}


augroup filetype_erl
    autocmd!
    autocmd FileType app.src setlocal filetype=erlang
    autocmd FileType abtests setlocal filetype=erlang
 augroup END



"" UNSORTED
inoremap <C-h> <left>
inoremap <C-l> <right>
inoremap <C-j> <down>
inoremap <C-k> <up>
command! Ds set syntax=0
command! Z tabnew %
xnoremap . :norm.<CR>
inoremap bin<Tab> <<"">><Esc>F"i
