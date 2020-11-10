#!/bin/bash

### Convert video back into frames
# Configure environment
DIR=/input

# Remove clip if already there
rm -rf ${DIR}/$1.mp4

# Compile frames and audio back into video
ffmpeg -y -hide_banner -loglevel panic \
    -r 30 -i $DIR/stylized/stylized.%04d.png \
    -i "$DIR/clip.mp3" -c:v libx264 -c:a aac \
    -pix_fmt yuv420p -crf 23 -r 30 \
    -shortest -y $DIR/$1.mp4

# Clean files
rm -f $DIR/clip.mp3
# Clean directory
rm -rf $DIR/frames/ $DIR/stylized/