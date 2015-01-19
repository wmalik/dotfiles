# Author: Wasif Malik (wmalik@gmail.com)

alias ls='ls --color=auto -h'
export PATH="/usr/local/bin:$PATH"
alias f='find . -name'
alias kb='killall beam.smp'
alias g='git'
alias girn='grep -irn'

alias tree="tree -AC"
alias now="date +%s"
alias a='sudo aptitude'
alias gvimm='gvim --remote-tab-silent'
alias xm="vim ~/.xmonad/xmonad.hs"
alias xr="vim ~/.Xresources"
alias grep="grep --color"

#PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
PS1='\[\033[01;32m\][\u@\h \[\033[01;34m\]\W\[\033[01;32m\]]\[\033[01;34m\]\$\[\033[00m\] '
#PS1="${PS1}\a"

#unlimited history
export HISTFILESIZE=
export HISTSIZE=
alias webserver='python -m SimpleHTTPServer'
# Trigger the urgency hook manually e.g. after a script finishes execution
alias urgency='PS1="$PS1\a"'
alias de='sudo dhclient eth0'
alias ll='ls -ltrh'

# Open erlang man pages like a boss. Usually, man string will show you the man
# page of the C string library. However, eman will show you the man page for the
# erlang string module.
alias eman='man 3erl'

source ~/.local/bin/bashmarks.sh
source ~/.privrc
if [ ${DISPLAY:="NOT_SET"} == ":0" ]
then
    xset r rate 400 44 &>/dev/null
else
    echo "No XSession detected"
fi

# Image viewing
alias fehi="feh -F --draw-tinted --info \"exif '%f' | grep 'Model\|DateTimeOriginal\|FNumber\|ISO\|Exposure\ Time\|Focal\ Length\|F-Number\|Shutter\|Aperture\|Compression'\""

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

export PATH=$PATH:~/.local/bin
