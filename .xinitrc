#~/.zshrc 
xset fp+ /usr/share/fonts/terminus 
xset fp+ /usr/share/fonts/misc
#xbindkeys&
#if [ -f $HOME/.Xmodmap ]; then
#    /usr/bin/xmodmap $HOME/.Xmodmap
#fi

#start urxvt daemon
urxvtd -q -o -f
#polipo
#sync firefox profile to ram disk
~/bin/firefox-sync&
#background image 
#feh --randomize --bg-fill ~/bg/
#feh  --bg-scale ~/bg/rNXud7o.png
conky&
conky -c .conkyrc-gcal&
/home/tom/scripts/toggletouchpad.sh&
#exec dwm 
#xsetroot -solid "#040408" -cursor_name left_ptr
#xbindkeys
#exec startkde
#openbox
xcalib -d :0 -s 0 -v /home/tom/.Lenovo\ LG\ IPS\ Screen.icm
xmonad
#exec cinnamon-session
#exec startlxqt
