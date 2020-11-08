#!/bin/bash

# Build Docker images
docker build -t ytdl:runtime -f Dockerfiles/Dockerfile.densepose
docker build -t flownet:runtime -f Dockerfiles/Dockerfile.densepose
docker build -t densepose:runtime -f Dockerfiles/Dockerfile.densepose
docker build -t magenta:runtime -f Dockerfiles/Dockerfile.densepose

