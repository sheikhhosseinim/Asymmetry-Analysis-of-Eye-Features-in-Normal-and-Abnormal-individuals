# -*- coding: utf-8 -*-

import os
import torch
import cv2
import numpy as np


H=256
W=256

#%%
model = torch.load("H:/.../segmentation_model_newresnet50_100.pth")

Dataset='H:/..../Dataset/'
#%%

Num_subj=len(os.listdir(Dataset))


for subj_idx in range(Num_subj):

    data_path=Dataset+'subj'+str(subj_idx+1)

    folderpath=data_path+'/left_after_recons/'
    resultpath=data_path+'/left_after_recons_layers/'
    
    filenames=os.listdir(folderpath)

    for i in enumerate(filenames):
        
        image_path=folderpath+i[1]
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
                [0, 0, 0],       # Background
                [128, 0, 0],     # Class 1
                [0, 128, 0],     # Class 2
                [0, 0, 128],   # Class 3
                [128, 128, 0], 
                [128, 0, 128], 
                [0, 128, 128], 
                ])
        color_mask = COLORS[predicted_mask]
            # Ensure the color mask is in uint8 format
        color_mask_uint8 = color_mask.astype(np.uint8)

        ##Display the image
        # cv2.imshow("Segmentation", color_mask_uint8)
        # cv2.waitKey(0)
        # cv2.destroyAllWindows()
    
        name=resultpath+i[1]
        cv2.imwrite(name, color_mask_uint8)
        
        
    folderpath=data_path+'/right_after_recons/'
    resultpath=data_path+'/right_after_recons_layers/'
    
    filenames=os.listdir(folderpath)

    for i in enumerate(filenames):
        
        image_path=folderpath+i[1]
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
                [0, 0, 0],       # Background
                [128, 0, 0],     # Class 1
                [0, 128, 0],     # Class 2
                [0, 0, 128],   # Class 3
                [128, 128, 0], 
                [128, 0, 128], 
                [0, 128, 128], 
                ])
        color_mask = COLORS[predicted_mask]
            # Ensure the color mask is in uint8 format
        color_mask_uint8 = color_mask.astype(np.uint8)

        ##Display the image
        # cv2.imshow("Segmentation", color_mask_uint8)
        # cv2.waitKey(0)
        # cv2.destroyAllWindows()
    
        name=resultpath+i[1]
        cv2.imwrite(name, color_mask_uint8)
