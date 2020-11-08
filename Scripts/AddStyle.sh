#!/bin/bash

# Python program to extract flows
# Run with $ docker exec --gpus all --rm -v `pwd`:/input --shm-size=8gb magenta:runtime ./AddStyle.sh

# Configure environment
DIR=/input/

python3 ${DIR}/addstyle.py --style=$1
