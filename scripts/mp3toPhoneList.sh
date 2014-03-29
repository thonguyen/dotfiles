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
output="/mnt/music/music/rock/";
echo > convert-r.sh
cat $1| 
(
    while read line
        do
            filename="${line##*/}"
            base="${filename%.[^.]*}"
            if [ ! -f "$output$base.ogg" ]
            then
                echo ffmpeg -i \""$line"\" -acodec libvorbis -ab 192k \""$output$base.ogg"\" >> convert-r.sh
                echo "$output$base.ogg"
            fi            
        done
)

#for f in *wma; do ffmpeg -i "$f" -acodec libmp3lame -ab 128k "${f%.wma}.mp3"; done

