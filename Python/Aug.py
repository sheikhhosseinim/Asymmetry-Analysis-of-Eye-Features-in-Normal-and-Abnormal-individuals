# -*- coding: utf-8 -*-
"""
Created on Sun Jan 26 10:51:10 2025

@author: msi
"""

import albumentations as A

# training set images augmentation
def get_training_augmentation(H,W):
    train_transform = [
        A.HorizontalFlip(p=0.5),
        A.ShiftScaleRotate(
            scale_limit=0.5, rotate_limit=0, shift_limit=0.1, p=1, border_mode=0
        ),
        A.PadIfNeeded(min_height=H, min_width=W, always_apply=True),
        A.RandomCrop(height=H, width=W, always_apply=True),
        # A.GaussNoise(p=0.2),
        A.Perspective(p=0.5),
        # A.OneOf(
        #     [
        #         A.CLAHE(p=1),
        #         A.RandomBrightnessContrast(p=1),
        #         A.RandomGamma(p=1),
        #     ],
        #     p=0.9,
        # ),
        # A.OneOf(
        #     [
        #         A.Sharpen(p=1),
        #         A.Blur(blur_limit=3, p=1),
        #         A.MotionBlur(blur_limit=3, p=1),
        #     ],
        #     p=0.9,
        # ),
        # A.OneOf(
        #     [
        #         A.RandomBrightnessContrast(p=1),
        #         A.HueSaturationValue(p=1),
        #     ],
        #     p=0.9,
        # ),
    ]
    return A.Compose(train_transform)


def get_validation_augmentation(H,W):
    """Add paddings to make image shape divisible by 32"""
    test_transform = [
        A.PadIfNeeded(H,W),
    ]
    return A.Compose(test_transform)