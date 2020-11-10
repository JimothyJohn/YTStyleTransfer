#!/bin/bash

# Human segmentation for pre-recorded video
# Run with $ docker exec --gpus all --rm -v `pwd`:/input --shm-size=8gb densepose:runtime ./SegmentFrames.sh

# Configure environment
DIR=/input

# Clear output directory or create
if [[ -d "$DIR/segments/" ]]
then
    rm -f $DIR/segments/* # delete the previous frames
else
    mkdir $DIR/segments/ # create target folder
fi

python ${DENSEPOSE}/my_apply_net.py dump \
	--output $DIR/output_densepose.pkl \
	${DENSEPOSE}/configs/densepose_rcnn_R_50_FPN_s1x.yaml \
	${DENSEPOSE}/densepose_rcnn_R_50_FPN_s1x.pkl \
	$DIR/frames/

python ${DENSEPOSE}/segments_to_png.py

rm -r $DIR/output_densepose.pkl