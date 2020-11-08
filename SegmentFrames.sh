#!/bin/bash

# Run with $ docker exec --gpus all --rm -v `pwd`:/input --shm-size=8gb densepose:runtime ./SegmentFrames.sh
### Human segmentation for pre-recorded video
python $DENSEPOSE/my_apply_net.py dump \
	--output /input/output_densepose.pkl \
	$DENSEPOSE/configs/densepose_rcnn_R_50_FPN_s1x.yaml \
	$DENSEPOSE/densepose_rcnn_R_50_FPN_s1x.pkl \
	/input/.frames

python $DENSEPOSE/segment_to_png.py