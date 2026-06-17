# -*- coding: utf-8 -*-
"""
Created on Sun Jan 26 10:46:49 2025

@author: msi
"""

#%%
import os
import cv2
import numpy as np
from torch.utils.data import Dataset as BaseDataset

#%%


class Dataset(BaseDataset):
    CLASSES = [
        "layer1",
        "layer2",
        "layer3",
        "layer4",
        "layer5",
        "unlabelled",
    ]

    def __init__(self, images_dir, masks_dir, classes=None, Height=256, Width=256, augmentation=None):
        self.ids = os.listdir(images_dir)
        self.images_fps = [os.path.join(images_dir, image_id) for image_id in self.ids]
        self.masks_fps = [os.path.join(masks_dir, image_id) for image_id in self.ids]
        self.H=Height
        self.W=Width

        # Always map background ('unlabelled') to 0
        self.background_class = self.CLASSES.index("unlabelled")

        # If specific classes are provided, map them dynamically
        if classes:
            self.class_values = [self.CLASSES.index(cls.lower()) for cls in classes]
        else:
            self.class_values = list(range(len(self.CLASSES)))  # Default to all classes

        # Create a remapping dictionary: class value in dataset -> new index (0, 1, 2, ...)
        # Background will always be 0, other classes will be remapped starting from 1.
        self.class_map = {self.background_class: 0}
        self.class_map.update(
            {
                v: i + 1
                for i, v in enumerate(self.class_values)
                if v != self.background_class
            }
        )

        self.augmentation = augmentation

    def __getitem__(self, i):
        # Read the image
        image = cv2.imread(self.images_fps[i])
        image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)  # Convert BGR to RGB
        image=cv2.resize(image,(self.H,self.W))
        # print(image.shape)

        # Read the mask in grayscale mode
        mask_name=self.masks_fps[i][0:-3]+'png'
        mask = cv2.imread(mask_name, cv2.IMREAD_GRAYSCALE)
        mask=(mask/255)*5
        mask=cv2.resize(mask,(self.H,self.W))

        # print(mask)

        # Create a blank mask to remap the class values
        mask_remap = np.zeros_like(mask)

        # Remap the mask according to the dynamically created class map
        for class_value, new_value in self.class_map.items():
            mask_remap[mask == class_value] = new_value

        if self.augmentation:
            sample = self.augmentation(image=image, mask=mask_remap)
            image, mask_remap = sample["image"], sample["mask"]
        image = image.transpose(2, 0, 1)

        return image, mask_remap

    def __len__(self):
        return len(self.ids)