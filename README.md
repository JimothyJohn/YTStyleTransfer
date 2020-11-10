# YTStyleTransfer
Apply arbitrary styles to YouTube clips!

Uses algorithms from:

Optical Flow: [NVIDIA Flownet2](https://github.com/NVIDIA/flownet2-pytorch)

Segmentation: [Facebook Detectron2](https://github.com/facebookresearch/detectron2)

Style Transfer: [Google Magenta](https://tfhub.dev/google/magenta/arbitrary-image-stylization-v1-256/2)

# Installation
Run installation script to automatically build Docker images <br />
    
    ./Install.sh

# Usage
Run script requires a YouTube video link and either a length of time or start and end times <br />
    
    ./RunScript.sh https://www.youtube.com/watch?v=cxLbmnvMWM0 01:40 01:45

It takes a while, but it will style your image!