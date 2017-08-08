### Install Pathogen
git clone https://github.com/tpope/vim-pathogen /tmp/vim-pathogen
mkdir -p ~/.vim/autoload && cp /tmp/vim-pathogen/autoload/pathogen.vim ~/.vim/autoload/

### Install vim plugins
git clone https://github.com/kien/ctrlp.vim
git clone https://github.com/scrooloose/syntastic
git clone https://github.com/wmalik/snipmate.vim
git clone https://github.com/mattn/gist-vim
git clone https://github.com/scrooloose/nerdcommenter
git clone https://github.com/scrooloose/nerdtree
git clone https://github.com/tpope/vim-surround
git clone https://github.com/mattn/webapi-vim
git clone https://github.com/mileszs/ack.vim
git clone git@github.com:flazz/vim-colorschemes.git
git clone git@github.com:flazz/vim-colorschemes.git
git clone git@github.com:SirVer/ultisnips.git
git clone git@github.com:Valloric/YouCompleteMe.git && cd ~/.vim/bundle/YouCompleteMe && git submodule update --init --recursive && ./install.sh -clang-completer
git clone vim-flake8
