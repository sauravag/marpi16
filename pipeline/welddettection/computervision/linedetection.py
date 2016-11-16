import cv2
import numpy as np
from matplotlib import pyplot as plt

# Read the input image
img = cv2.imread('weldexample.jpg')

# make a copy of the image
imgcopy = cv2.copyMakeBorder(img,0,0,0,0,cv2.BORDER_REPLICATE)

# convert input image to grayscale
gray = cv2.cvtColor(img,cv2.COLOR_BGR2GRAY)

# blur gray image to remove noise
blur = cv2.GaussianBlur(gray,(5,5),0)

# detect edges in image
edges = cv2.Canny(blur,150,200,apertureSize = 3)


# Detect Lines
lines = cv2.HoughLines(edges,1,np.pi/90,110)
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

plt.subplot(2,2,1),plt.imshow(img,cmap = 'gray')
plt.title('Original'), plt.xticks([]), plt.yticks([])

plt.subplot(2,2,2),plt.imshow(blur,cmap = 'gray')
plt.title('Blurred'), plt.xticks([]), plt.yticks([])

plt.subplot(2,2,3),plt.imshow(edges,cmap = 'gray')
plt.title('Edges'), plt.xticks([]), plt.yticks([])

plt.subplot(2,2,4),plt.imshow(imgcopy,cmap = 'gray')
plt.title('Lines'), plt.xticks([]), plt.yticks([])

plt.show()