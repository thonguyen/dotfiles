#~/.zshrc
xset fp+ /usr/share/fonts/terminus 
#xbindkeys&
if [ -f $HOME/.Xmodmap ]; then
    /usr/bin/xmodmap $HOME/.Xmodmap
fi

#start urxvt daemon
urxvtd -q -o -f
#polipo
#redshift&
#sync firefox profile to ram disk
~/bin/firefox-sync&
#~/bin/luakit-sync&
#~/bin/dwb-sync&
#exec awesome
#exec i3 
#exec i3 --force-xinerama
#exec wmfs 
#/usr/local/bin/dwmstatus&
#exec dwm 
#exec /usr/local/bin/dwm 
#exec /usr/local/bin/musca
#exec /usr/bin/musca
#exec /home/tom/old/c/musca--/musca
#xsetroot -solid "#040408" -cursor_name left_ptr
#exec ttwm 
#exec spectrwm
#exec catwm
#exec /usr/local/bin/snapwm
#/home/tom/dwmstart.sh
#exec wmii 
#exec /home/tom/old/c/monsterwm/monsterwm
#exec herbstluftwm
#exec monsterwm
#exec notion
#exec pictorwm
xmonad
#bspwm
#xbindkeys
#openbox
#exec startkde
