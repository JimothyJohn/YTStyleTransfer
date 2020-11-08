import os, shutil, functools, argparse

from matplotlib import gridspec
import matplotlib.pylab as plt
import numpy as np
import tensorflow as tf
tf.compat.v1.enable_eager_execution()
import tensorflow_hub as hub

## Imaging tools
import PIL
from PIL import Image
from PIL import ImageFilter
from PIL import ImageDraw
from PIL import ImageFont

# Load image path as tf tensor ADJUST MAX DIMS
def load_img(path_to_img):
  max_dim = 1024 # maximum size that is compatible with model
  img = tf.io.read_file(path_to_img) # read file and return a tensor type of string
  img = tf.image.decode_image(img, channels=3) # convert bytes-type string above into Tensor of dtype
  img = tf.image.convert_image_dtype(img, tf.float32) # convert to float32 dtype

  shape = tf.cast(tf.shape(img)[:-1], tf.float32) # get LAST two axes as resolution / dimensions in float values
  long_dim = max(shape) # find longest side
  scale = max_dim / long_dim # find scaling factor based on largest side

  new_shape = tf.cast(shape * scale, tf.int32) # create new shape based on scale

  img = tf.image.resize(img, new_shape) # resize to new shape
  img = img[tf.newaxis, :] # adds another axis aka brackets on the outside
  return img # return image

# Converts tensor to PIL.Image
def tensor_to_image(tensor):
  tensor = tensor*255 # convert tensor from 0-1 to 0-255
  tensor = np.array(tensor, dtype=np.uint8) # convert tensor type to integer for RGB indexing
  if np.ndim(tensor)>3: # if tensor is more than W  xH x channel
    assert tensor.shape[0] == 1 # flatten?
    tensor = tensor[0] # grab initial index
  return PIL.Image.fromarray(tensor) # convert np to PIL image

# Apply style to content with optional mask
def style_image(contentPath, styleTensor):
  contentTensor = load_img(contentPath)

  stylizedTensor = hub_module(tf.constant(contentTensor), tf.constant(styleTensor))[0]
  outputTensor = tf.squeeze(stylizedTensor, axis=0) # get rid of batch dimension

  return tensor_to_image(outputTensor) # convert tensor back to image

parser = argparse.ArgumentParser(description='Process some integers.')
parser.add_argument('--style', help='input file')
args = parser.parse_args()

# Directories
CONTENT_PATH = '/input/.frames/'
MASK_PATH = '/input/motion/'
STYLIZED_PATH = '/input/stylized'

# Flags
MASKING = True

if os.path.exists(STYLIZED_PATH):
    shutil.rmtree(STYLIZED_PATH)
    
os.mkdir(STYLIZED_PATH)

styleTensor = load_img('/input/style/'+args.style)
contentTensor = load_img(CONTENT_PATH+'clip.0001.png')
_, height, width, _ = contentTensor.shape

# Load TF-Hub module.
hub_handle = 'https://tfhub.dev/google/magenta/arbitrary-image-stylization-v1-256/2'
hub_module = hub.load(hub_handle)

lastImage = style_image(CONTENT_PATH+'clip.0001.png', styleTensor)

for idx, framePath in enumerate(sorted(os.listdir(CONTENT_PATH))):
  styleImage = style_image(CONTENT_PATH+framePath, styleTensor).resize((width, height), Image.ANTIALIAS)
  
  if MASKING is True and os.path.exists(MASK_PATH+'motion.{:04d}.png'.format(idx)):
      flow_img = Image.open(MASK_PATH+'motion.{:04d}.png'.format(idx))
      #seg_img = Image.open('/input/segments/segment.0071.png')

      flowImage = flow_img.resize((width, height), Image.ANTIALIAS) # resize style output image
      
      outputImage = Image.composite(styleImage, lastImage, flowImage)
      lastImage = outputImage
  else:
    outputImage = styleImage
  
  outputImage.save('/input/stylized/stylized.{:04d}.png'.format(idx))