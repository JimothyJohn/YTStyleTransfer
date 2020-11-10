#!/bin/bash

# Python program to extract flows
# Run with $ docker exec --gpus all --rm -v `pwd`:/input --shm-size=8gb magenta:runtime ./AddStyle.sh

# Configure environment
DIR=/input

# Clear output directory or create
if [[ -d "$DIR/stylized/" ]]
then
    rm -f $DIR/stylized/* # delete the previous frames
else
    mkdir $DIR/stylized/ # create target folder
fi

python3 ${DIR}/Python/addstyle.py --style=$1

# Clean directory
rm -rf $DIR/motion/ $DIR/segments/