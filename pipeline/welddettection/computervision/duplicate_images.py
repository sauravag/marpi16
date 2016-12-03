#!/usr/bin/env python
# Batch thumbnail generation script using PIL

import sys
import os
import Image

# thumbnail_size = (28, 28)


def make_image_copies(filename, image):

    numCopies = 5

    for i in range(1, numCopies+1):

        # Resize the image
        # image = image.resize(thumbnail_size, Image.ANTIALIAS)

        # Split our original filename into name and extension
        (name, extension) = os.path.splitext(filename)

        # Save the thumbnail as "(original_name)_thumb.png"
        image.save(name + '_' + str(i) + '.png')


if __name__ == "__main__":

    basePath = '/home/elijah/Documents/AggieChallenge/WeldSamples/'

    for fn in os.listdir(basePath):

        if os.path.isfile(basePath+fn) == True:

            try:
                # Attempt to open an image file
                fml = basePath + fn

                image = Image.open((fml)

                make_image_copies(fml, image)
                
            except IOError, e:
                # Report error, and then skip to the next argument
                print "Problem opening", fml, ":", e
                continue
