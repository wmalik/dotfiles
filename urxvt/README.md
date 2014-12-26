# urxvt

## Extensions
All extensions (urxvt perls) should be installed in /usr/lib/urxvt/perl
### Font Size Perl
git clone https://github.com/majutsushi/urxvt-font-size /tmp/urxvt-font-size
cp font-size /usr/lib/urxvt/perl

### Remote hosts
If you are logging into a remote host, you may encounter problems when running
text-mode programs under rxvt-unicode. This can be fixed by copying
/usr/share/terminfo/r/rxvt-unicode-256color from your local machine to your host
at ~/.terminfo/r/rxvt-unicode
