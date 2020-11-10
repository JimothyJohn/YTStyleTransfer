#!/bin/bash

### Snatch YouTube video and extract into frames
# Configure environment
DIR=/input

# Download with youtube-dl as NA.mp4
### BUGGY WAY TO DO IT ###
echo "Downloading video..."
youtube-dl -q -f best -o '%(input)s.%(ext)s' $1

# Remove clip if already there
if [[ -f "${DIR}/clip.mp4" ]]
then
    rm ${DIR}/clip.mp4
fi

# OPTIONAL Isolate clip of interest
# If no clip specified
if [[ $2 -eq 0 ]]
then
    # Just rename clip
    mv ./NA.mp4 ${DIR}/clip.mp4
else
    echo "Extracting clip..."
    # If just length specified
    if [[ $3 -eq 0 ]]
    then
        ffmpeg -y -hide_banner -loglevel panic \
            -ss 00:00:00.00 -i ./NA.mp4 -t \
            00:$2.00 -c copy ${DIR}/clip.mp4
    # If start AND finish specified
    else
        ffmpeg -y -hide_banner -loglevel panic \
            -ss 00:$2.00 -i ./NA.mp4 -t \
            00:$3.00 -c copy ${DIR}/clip.mp4
    fi
fi

# Clear output directory or create
if [[ -d "$DIR/frames/" ]]
then
    rm -f $DIR/frames/* # delete the previous frames
else
    mkdir $DIR/frames/ # create target folder
fi

echo "Slicing video"
# Extract frames and audio
ffmpeg -y -hide_banner -loglevel panic \
    -i ${DIR}/clip.mp4 ${DIR}/frames/clip.%04d.png \
    -q:a 0 -map a ${DIR}/clip.mp3

# Remove clip
rm -f ${DIR}/clip.mp4