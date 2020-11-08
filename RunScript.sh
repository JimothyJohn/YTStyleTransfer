#!/bin/bash

### Arbitrary style transfer with optical flow and human segmentation for pre-recorded video
# Sample command $ ./RunScript https://www.youtube.com/watch?v=FTkU-EmBV6k 4 6
if [[ "$1" != "https://www.youtube.com/watch?v="* ]] 
then
    echo "Enter a YouTube URL"
    exit 1
fi

echo "SLICING VIDEO"
docker exec --rm -v $HOME/StyleTransfer:/input vidslicer:runtime /input/VidSlicer $1 $2 $3

echo "SEGMENTING VIDEO"
docker exec --gpus all --rm -v `pwd`:/input \
    --shm-size=8gb densepose:runtime /input/SegmentFrames.sh

echo "DETECTING MOTION"
docker exec --gpus all --rm -v $HOME/StyleTransfer:/input \
    -v $HOME/github/flownet2-torch:/MyFlownet \
    --shm-size=8gb flownet:runtime /input/ExtractFlows.sh

echo "ADDING STYLE"
docker exec --rm --gpus all -v $HOME/StyleTransfer:/input \
    --shm-size=8gb magenta:runtime /input/AddStyle.sh $4

echo "CREATING VIDEO"
docker exec --rm -v $HOME/StyleTransfer:/input vidslicer:runtime /input/VidCompiler $4

# Clean files
rm -f $DIR/clip.mp3 $DIR/clip.mp4 \
# Clean directory
rm -rf $DIR/.frames $DIR/stylized \
    $DIR/motion $DIR/flows $DIR/flowvis \
    $DIR/stylized