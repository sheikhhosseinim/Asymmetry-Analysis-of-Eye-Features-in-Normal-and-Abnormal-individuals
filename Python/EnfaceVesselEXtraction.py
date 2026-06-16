# -*- coding: utf-8 -*-
"""
Created on Mon Jun 15 18:26:55 2026

@author: msi
"""


import torch
import cv2
import numpy as np
from Layers import CamVidModel

H=256
W=256

#%%
model = torch.load("/segmentation_model_vessel_unet_resnet50_500.pth")

Dataset='H:/..../Dataset/'

#%%
for subj_idx in range(90):

    data_path=Dataset+'subj'+str(subj_idx+1)

    image_path=data_path+'/enface_left.jpg'

    image = cv2.imread(image_path)
    image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)  # Convert BGR to RGB
    image=cv2.resize(image,(H,W))
    image = image / 255.0
    image = np.transpose(image, (2, 0, 1))
    image = np.expand_dims(image, axis=0)
    image = torch.tensor(image, dtype=torch.float32)
    

    with torch.no_grad():
        output = model(image)
        predicted_mask = torch.argmax(output, dim=1).squeeze(0).cpu().numpy()
        
        # Visualize
    COLORS = np.array([
            [255, 255, 255],       # Background
            [0, 0, 0],     # Class 1
            ])
    color_mask = COLORS[predicted_mask]
        # Ensure the color mask is in uint8 format
    color_mask_uint8 = color_mask.astype(np.uint8)

    # ##Display the image
    # cv2.imshow("Segmentation", color_mask_uint8)   
    # cv2.waitKey(0)
    # cv2.destroyAllWindows()
    
    name=data_path+'/enface_vessel_left.jpg'
    cv2.imwrite(name, color_mask_uint8)
 ###############################################     
    image_path=data_path+'/enface_right.jpg'

    image = cv2.imread(image_path)
    image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)  # Convert BGR to RGB
    image=cv2.resize(image,(H,W))
    image = image / 255.0
    image = np.transpose(image, (2, 0, 1))
    image = np.expand_dims(image, axis=0)
    image = torch.tensor(image, dtype=torch.float32)
    

    with torch.no_grad():
        output = model(image)
        predicted_mask = torch.argmax(output, dim=1).squeeze(0).cpu().numpy()       

        # Visualize
    COLORS = np.array([
            [255, 255, 255],       # Background
            [0, 0, 0],     # Class 1
            ])
    color_mask = COLORS[predicted_mask]
        # Ensure the color mask is in uint8 format
    color_mask_uint8 = color_mask.astype(np.uint8)


    # ##Display the image
    # cv2.imshow("Segmentation", color_mask_uint8)   
    # cv2.waitKey(0)
    # cv2.destroyAllWindows()
    
    name=data_path+'/enface_vessel_right.jpg'
    cv2.imwrite(name, color_mask_uint8)
