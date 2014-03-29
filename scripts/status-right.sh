TIME=`date +"%a %b %d %H:%M"`
TEMP=$(($(cat /sys/class/thermal/thermal_zone0/temp) / 1000))
echo $TEMP

