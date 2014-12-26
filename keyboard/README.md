For mapping Caps Lock to Ctrl in Debian:

Edit /etc/default/keyboard:
Change
    XKBOPTIONS=""
to:
    XKBOPTIONS="ctrl:nocaps"
    # or
    #XKBOPTIONS="ctrl:swapcaps"

To make it effective:
    sudo dpkg-reconfigure -phigh console-setup

or

from the keyboard(5) manpage in debian:
    udevadm trigger --subsystem-match=input --action=change
