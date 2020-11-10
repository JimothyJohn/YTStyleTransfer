#!/bin/bash

# Run with $ docker exec --gpus all --rm -v `pwd`:/input --shm-size=8gb flownet:runtime ./ExtractFlows.sh

# Configure environment
DIR=/input/

# If frame directory doesn't exist
if [[ -d "$DIR/flows/" ]]
then
# delete the previous frames
rm -rf $DIR/flows/
fi

# make it
mkdir $DIR/flows/

python3 ./main.py --inference --model FlowNet2 \
    --save_flow --save $DIR/flows/ \
    --inference_dataset ImagesFromFolder \
    --inference_dataset_root $DIR/frames/ \
    --resume /flownet/FlowNet2_checkpoint.pth.tar

# If frame directory exists
if [[ -d "$DIR/motion/" ]]
then
    # delete the previous frames
    rm -f $DIR/motion/*
else
    mkdir $DIR/motion # create target folder
fi

python3 ./readmotion.py # create .png from flow data

rm -rf $DIR/flows/ $DIR/flowvis/ # delete unneeded directories