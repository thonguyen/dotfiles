#!/bin/bash - 
#===============================================================================
#
#          FILE: mp3toPhone.sh
# 
#         USAGE: ./mp3toPhone.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 04/02/2012 10:55:39 AM ICT
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error
output="/mnt/usb/shit/";
cat $1| 
(
    while read line
        do
            sudo cp "$line" $output
          echo \""$line"\" $output
        done
)

#for f in *wma; do ffmpeg -i "$f" -acodec libmp3lame -ab 128k "${f%.wma}.mp3"; done

