#!/bin/bash

# Call with docker run --rm -it --gpus all -v $HOME/StyleTransfer:/input \
#    -v /home/nick/github/flownet2-pytorch/:/MyFlownet \
#    --shm-size=8gb flownet:v0

### Python program to extract flows
# Configure environment
DIR=/input/

# If frame directory doesn't exist
if [[ -d "$DIR/flows" ]]
then
# delete the previous frames
rm -rf $DIR/flows
fi

# make it
mkdir $DIR/flows

python3 ./main.py --inference --model FlowNet2 \
    --save_flow --save $DIR/flows \
    --inference_dataset ImagesFromFolder \
    --inference_dataset_root $DIR/.frames/ \
    --resume $DIR/FlowNet2_checkpoint.pth.tar

# If frame directory exists
if [[ -d "$DIR/motion" ]]
then
# delete the previous frames
rm -rf $DIR/motion
fi

mkdir $DIR/motion

python3 ./readmotion.py