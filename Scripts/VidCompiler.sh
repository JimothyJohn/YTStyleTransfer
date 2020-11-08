#!/bin/bash

### Convert video back into frames
# Configure environment
DIR=/input

# Compile frames and audio back into video -y -hide_banner -loglevel panic \
    
ffmpeg -y -hide_banner -loglevel panic \
    -r 30 -i $DIR'/flowvis/flowvis.%04d.png' \
    -c:v libx264 -c:a aac \
    -pix_fmt yuv420p -crf 23 -shortest "$DIR/flowvis.mp4"

ffmpeg -y -hide_banner -loglevel panic \
     -r 30 -i $DIR'/stylized/stylized.%04d.png' \
    -i "$DIR/clip.mp3" -c:v libx264 -c:a aac \
    -pix_fmt yuv420p -crf 23 -shortest "$DIR/$1.mp4"