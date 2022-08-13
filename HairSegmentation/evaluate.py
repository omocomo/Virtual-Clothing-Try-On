"""
Evaluate
"""

import re
import math
import datetime
import random
import torch
import cv2
import numpy as np

USE_CUDA = torch.cuda.is_available()
DEVICE = torch.device("cuda" if USE_CUDA else "cpu")

def evaluateOne(img, model, absolute=True):
    img = img.to(DEVICE).unsqueeze(0)
    pred = model(img)
    
    threshold = 0.9 # hair mask threshold
    if absolute:
        pred[pred > threshold] = 1.0
        pred[pred <= threshold] = 0.0
    else:
        pred[pred < 0.4] = 0
        # pred[pred < .90] = 0

    # save hair mask image
    mask_pred = pred[0].detach().cpu().numpy()
    mask_pred = mask_pred * 255
    mask_pred = mask_pred.transpose(1, 2, 0)
    mask_pred = mask_pred.astype(np.uint8).copy()

    # erosion
    kernel_size = 7
    kernel = np.ones((kernel_size, kernel_size), np.uint8)
    mask_pred = cv2.erode(mask_pred, kernel, iterations = 2)

    kernel_size = 5
    kernel = np.ones((kernel_size, kernel_size), np.uint8)
    mask_pred = cv2.dilate(mask_pred, kernel, iterations = 2)

    return mask_pred
