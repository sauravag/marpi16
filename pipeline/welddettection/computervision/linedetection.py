import cv2
import numpy as np
from matplotlib import pyplot as plt
import sys
import os

def line_detect(filepath):

  print filepath
  #Read the input image
  #   Input: image as .jpg 
  img = cv2.imread(filepath)

  # make a copy of the image
  #   Input 1: image
  #   Input 2: top border width in number of pixels
  #   Input 3: bottom border width in number of pixels
  #   Input 4: left border width in number of pixels
  #   Input 5: right border width in number of pixels
  #   Input 6: type of border added
  imgcopy = cv2.copyMakeBorder(img,0,0,0,0,cv2.BORDER_REPLICATE)

  # convert input image to grayscale
  #   Input 1: image
  #   Input 2: color space conversion code
  gray = cv2.cvtColor(img,cv2.COLOR_BGR2GRAY)
   
  # blur gray image to remove noise
  #   Input 1: image
  #   Input 2: gaussian kernel height (must be odd number and greater than zero)
  #   Input 3: gaussian kernel width (must be odd number and greater than zero)
  #   Input 4: 
  blur = cv2.GaussianBlur(gray,(5,5),0)

  # detect edges in image (image is now gray and noise removed)
  #   Input 1: image
  #   Input 2: minval (pixels with intensity gradient below this is discarded)
  #   Input 3: maxVal (poxels with intesity gradient above this are imediately edges)
  #   Input 4: size of Sobel kernel
  edges = cv2.Canny(blur,150,200,apertureSize = 3)


  # Detect Lines and draw lines on image copy
  lines = cv2.HoughLines(edges,1,np.pi/90,110)

  # What if there was no line
  if lines == None:
    print "No line detected"
    exit()

  for rho,theta in lines[0]:
      if (np.pi/70 <= theta <= np.pi/7) or (2.056 < theta < 4.970) or (1.570 <= theta <= 1.600): #(2,6 <=theta <= 26) or (theta >118 and theta <= 285)

          a = np.cos(theta)
          b = np.sin(theta)
          x0 = a*rho
          y0 = b*rho
          x1 = int(x0 + 1000*(-b))
          y1 = int(y0 + 1000*(a))

          x2 = int(x0 - 1000*(-b))
          y2 = int(y0 - 1000*(a))

          cv2.line(imgcopy,(x1,y1),(x2,y2),(0,255,0),2)

  return imgcopy

  
  '''#plot original input image
  plt.subplot(2,2,1),plt.imshow(img,cmap = 'gray')
  plt.title('Original'), plt.xticks([]), plt.yticks([])

        #plot grey image with noise removed
  plt.subplot(2,2,2),plt.imshow(blur,cmap = 'gray')
  plt.title('Blurred'), plt.xticks([]), plt.yticks([])

       #plot image of detected lines
  plt.subplot(2,2,3),plt.imshow(edges,cmap = 'gray')
  plt.title('Edges'), plt.xticks([]), plt.yticks([])

       #plot original image with dected lines drawn on top 
  plt.subplot(2,2,4),plt.imshow(imgcopy,cmap = 'gray')
  plt.title('Lines'), plt.xticks([]), plt.yticks([])

  plt.show()'''


if __name__ == "__main__":

  basePath = '/home/elijah/Documents/AggieChallenge/WeldSamples/'

  for fn in os.listdir(basePath):
      
      #print os.path.isfile(fn)
      print fn

      if os.path.isfile(basePath + fn) ==  True:
          
          try:
              # Attempt to open an image file
              img = line_detect(basePath + fn)

              (name, extension) = os.path.splitext(fn)

              cv2.imwrite(basePath+name+'_detection.jpg',img)
              
          except IOError, e:
              # Report error, and then skip to the next argument
              print "Problem opening", fn, ":", e
              continue