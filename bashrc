# Author: Wasif Malik (wmalik@gmail.com)

alias ls='ls --color=auto'
export PATH="/usr/local/bin:$PATH"
alias fname='find . -name'
alias kb='killall beam.smp'
alias g='git'
alias girn='grep -irn'

alias tree="tree -AC"
alias now="date +%s"
alias a='sudo aptitude'
alias gvimm='gvim --remote-tab-silent'
alias xm="vim ~/.xmonad/xmonad.hs"
alias xr="vim ~/.Xresources"

PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
PS1="$PS1\a"

#unlimited history
export HISTFILESIZE=
export HISTSIZE=
alias webserver='python -m SimpleHTTPServer'
# Trigger the urgency hook manually e.g. after a script finishes execution
alias urgency='PS1="$PS1\a"'
alias de='sudo dhclient eth0'

# Open erlang man pages like a boss. Usually, man string will show you the man
# page of the C string library. However, eman will show you the man page for the
# erlang string module.
alias eman='man 3erl'

source ~/.local/bin/bashmarks.sh
source ~/.privrc
