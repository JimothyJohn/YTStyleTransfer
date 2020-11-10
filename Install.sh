#!/bin/bash

# Build Docker images
docker build -t ytdl:runtime -f ./Dockerfiles/Dockerfile.ytdl .
docker build -t flownet:runtime -f ./Dockerfiles/Dockerfile.flownet .
docker build -t detectron:v0 -f ./Dockerfiles/Dockerfile.detectron .
docker build -t densepose:runtime -f ./Dockerfiles/Dockerfile.densepose .
docker build -t magenta:runtime -f ./Dockerfiles/Dockerfile.magenta .
