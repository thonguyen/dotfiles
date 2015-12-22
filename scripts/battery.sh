echo -n "last_full_capacity:" `cat /sys/devices/platform/smapi/BAT0/last_full_capacity` 
echo " /" `cat /sys/devices/platform/smapi/BAT0/design_capacity`
echo "remaining_capacity:" `cat /sys/devices/platform/smapi/BAT0/remaining_capacity`
echo "temperature:" `cat /sys/devices/platform/smapi/BAT0/temperature`
echo "cycle count:" `cat /sys/devices/platform/smapi/BAT0/cycle_count`
echo "status:" `cat /sys/class/power_supply/BAT0/status`
echo "power_avg:" `cat /sys/devices/platform/smapi/BAT0/power_avg`
echo "power_now:" `cat /sys/devices/platform/smapi/BAT0/power_now`
echo "Remain:" `cat /sys/devices/platform/smapi/BAT0/remaining_running_time_now` min
echo "Remain charging:" `cat /sys/devices/platform/smapi/BAT0/remaining_charging_time` min
