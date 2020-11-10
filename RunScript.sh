#!/bin/bash

# Arbitrary style transfer with optical flow and human segmentation for pre-recorded video
# Sample command $ ./RunScript.sh https://www.youtube.com/watch?v=FTkU-EmBV6k 00:04 00:08 vangogh

# Configure environment
DIR=/input/
SCRIPTS=${DIR}/Scripts

# Make sure a YouTube URL is entered
if [[ "$1" != "https://www.youtube.com/watch?v="* ]] 
then
    echo "Enter a YouTube URL"
    exit 1
fi

# Test command: $ docker run --rm -v `pwd`:/input vidslicer:runtime /input/Scripts/VidSlicer.sh https://www.youtube.com/watch?v=FTkU-EmBV6k "00:04" "00:06"
echo "SLICING VIDEO"
docker run --rm -v `pwd`:/input/ vidslicer:runtime \
    ${SCRIPTS}/VidSlicer.sh $1 $2 $3

# Test command: $ docker run --rm --gpus=all -v `pwd`:/input --shm-size=8gb flownet:runtime /input/Scripts/ExtractFlows.sh
echo "DETECTING MOTION"
docker run --rm --gpus all -v `pwd`:/input/ \
    --shm-size=8gb flownet:runtime \
    ${SCRIPTS}/ExtractFlows.sh

# Test command: $ docker run --rm --gpus=all -v `pwd`:/input --shm-size=8gb densepose:runtime /input/Scripts/SegmentFrames.sh
# echo "SEGMENTING VIDEO"
# docker run --rm --gpus all --rm -v `pwd`:/input/ \
#     --shm-size=8gb densepose:runtime \
#     ${SCRIPTS}/SegmentFrames.sh

# Test command: $ docker run --rm --gpus=all -v `pwd`:/input magenta:runtime /input/Scripts/AddStyle.sh vangogh.jpg
echo "ADDING STYLE"
docker run --rm --gpus all -v `pwd`:/input/ \
    --shm-size=8gb magenta:runtime \
    ${SCRIPTS}/AddStyle.sh $4

# Test command: $ docker run --rm -v `pwd`:/input vidslicer:runtime /input/Scripts/VidCompiler.sh stylized
echo "CREATING VIDEO"
docker run --rm -v `pwd`:/input/ vidslicer:runtime \
    ${SCRIPTS}/VidCompiler.sh $4
