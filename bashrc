# Author: Wasif Malik (wmalik@gmail.com)

force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi
if [ "$color_prompt" = yes ]; then
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$(__git_ps1)\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

export PAGER=less
export HISTFILESIZE=
export HISTSIZE=

# Trigger the urgency hook manually e.g. after a script finishes execution

[ -f ~/repos/labs/bashmarks/bashmarks.sh ] && source ~/repos/labs/bashmarks/bashmarks.sh
[ -f ~/.privrc ] && source ~/.privrc


export TERM="rxvt"
export EDITOR=vim
export CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt

alias fehi="feh -d -F --draw-tinted --info \"exif '%f' | grep 'Model\|DateTimeOriginal\|FNumber\|ISO\|Exposure\ Time\|Focal\ Length\|F-Number\|Shutter\|Aperture\|Compression'\""
alias urgency='PS1="$PS1\a"'
alias vim='TERM=rxvt-unicode-256color vim'
alias ls='ls --color=auto'
alias f='find . -name'
alias g='/usr/bin/git'
alias girn='grep -irn'
alias digs="dig +short"
alias tree="tree -AC"
alias now="date +%s"
alias a='sudo apt'
alias xm="vim ~/.xmonad/xmonad.hs"
alias xc="vim ~/.xmonad/.conky_dzen"
alias xr="vim ~/.Xresources; xrdb ~/.Xresources"
alias grep="grep --color"
alias w="wicd-curses"
alias holidays='gcal --holiday-list --cc-holidays=de_be'
alias rand="cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1"
