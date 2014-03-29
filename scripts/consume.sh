#!/bin/bash

CONSO=0

while :
        do
                sleep 1
                WATT=`upower -i /org/freedesktop/UPower/devices/battery_BAT0 | awk '/energy-rate:/{print $2}' | cut -f1 -dW`
                TEMPO=$(($TEMPO+1))
                CONSO=`echo "scale=2;$WATT+$CONSO" | bc`

                case $TEMPO in

                10|20|30|40|50) 
                C=`echo "scale=2;$CONSO/$TEMPO" | bc `
                AFF="Power consumption for $TEMPO s :$C W"
                ;;

                60)
                C=`echo "scale=2;$CONSO/$TEMPO" | bc `
                AFF="Power consumption by min :$C W/min"
                CONSO=$C ; TEMPO=0 
                ;;
                esac

                clear ; echo -n "Wait 10 seconds
                
                $AFF"
                done
