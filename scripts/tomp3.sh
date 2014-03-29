#$1: input type $2 output folder
for f in *ogg; do ffmpeg -i "$f" -acodec mp3 -ar 44100 -ab 192kbps -y "${f%.ogg}.mp3"; done
