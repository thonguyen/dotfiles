while true; do
       # Log stderror to a file 
       /usr/local/bin/dwm 2> ~/.dwm/e.log
       # No error logging
       #dwm >/dev/null 2>&1
done
