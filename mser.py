import os
import sys
import cv2
import numpy as np
import matplotlib.pyplot as plt
from PIL import Image
import itertools
from operator import itemgetter
import itertools
from pandas import *
"""
    This is a simple example on how to use OpenCV for MSER
"""

def find_overlaps(rect,data):
    data=data[data[::,0]<rect[1]]
    data=data[data[::,1]>rect[0]]
    data=data[data[::,2]<rect[3]]
    data=data[data[::,3]>rect[2]]
    return data




def mser(cv_image, list_diag_coords):
    # vis = cv_image.copy()
    mser = cv2.MSER_create(5, 60, 120 , 0.25)
    regions, boundingBoxes = mser.detectRegions(cv_image)

    # boundingBoxes = np.array(sorted(boundingBoxes, key=itemgetter(1)))
    # boundingBoxes = np.array(sorted(boundingBoxes, key=itemgetter(0)))
    # print(boundingBoxes)
    # boundingBoxes = DataFrame(boundingBoxes).drop_duplicates().values 1# boxes = combine_boxes(boundingBoxes)

    # for rect in boundingBoxes:
    #     overlaps = find_overlaps(rect,boundingBoxes)
    #     for overlap in overlaps:
    #         print(overlap)

    string_build = ''
    for x, y, w, h in boundingBoxes:
        # xmax, ymax = np.amax(p, axis=0)
        # xmin, ymin = np.amin(p, axis=0)
        # cv2.rectangle(vis, (xmin,ymax), (xmax,ymin), (0, 255, 0), 1)
        cv2.rectangle(cv_image, (x, y), (x+w, y+h), (139,0,0), 1)
        string_build = string_build + ":" + str((x+(w/2))) + "," + str((y+(h/2)))

    list_diag_coords = string_build


    # print(len(boundingBoxes))
    # print(len(boxes))

    # return list
    print(list_diag_coords)
    return cv_image

def main(argv):
    file_path = argv[1]
    save_path = argv[2]

    list_diag_coords = ''

    cv2.imwrite(save_path, mser(cv2.imread(file_path, 0), list_diag_coords))

if __name__=='__main__':
    main(sys.argv)
