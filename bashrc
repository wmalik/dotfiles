# Author: Wasif Malik (wmalik@gmail.com)

alias ls='ls --color=auto'
alias f='find . -name'
alias g='git'
alias girn='grep -irn'

alias tree="tree -AC"
alias now="date +%s"
alias a='sudo aptitude'
alias xm="vim ~/.xmonad/xmonad.hs"
alias xr="vim ~/.Xresources"
alias grep="grep --color"

PS1='\[\033[01;32m\][\u@\h \[\033[01;34m\]\W\[\033[01;32m\]]\[\033[01;34m\]\$\[\033[00m\] '

#unlimited history
export HISTFILESIZE=
export HISTSIZE=

# Trigger the urgency hook manually e.g. after a script finishes execution
alias urgency='PS1="$PS1\a"'
alias ssh='TERM=rxvt ssh'

source ~/.local/bin/bashmarks.sh
source ~/.privrc
if [ ${DISPLAY:="NOT_SET"} == ":0" ]
then
    fortune -c
else
    echo "no xsession"
fi

xset r rate 200 100

alias fehi="feh -d -F --draw-tinted --info \"exif '%f' | grep 'Model\|DateTimeOriginal\|FNumber\|ISO\|Exposure\ Time\|Focal\ Length\|F-Number\|Shutter\|Aperture\|Compression'\""

export PATH="/usr/local/bin:$PATH"
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
source ~/.git-completion.bash
export EDITOR=vim
