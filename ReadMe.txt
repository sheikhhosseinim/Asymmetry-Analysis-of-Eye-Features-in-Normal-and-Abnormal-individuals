This repository contains the implementation of the proposed pipeline for retinal image analysis and classification described in our study. The code integrates MATLAB and Python scripts for image preprocessing, vessel extraction, layer segmentation, feature extraction, statistical analysis, and classification.


To run the code, you need to change the dataset path in both the MATLAB and Python scripts so that it points to the folder containing the subject data.

For example:

Dataset_path = 'E:\...\Dataset\'

Some parts of the algorithm must be executed in Python. Make sure the dataset path is correctly set before running the scripts.

The files should be executed in the following order:

FundusAlignmentEnfaceGeneration.m
FundusVesselExtraction.py
EnfaceVesselExtraction.py
Registration.m
LayerSegmentation.py
FeatureExtraction.m
StatisticalAnalysis.m
ClassificationAnalysis.m


Data and Pre-trained Models
Due to file size limitations, the trained models and dataset are hosted on Zenodo.

Pre-trained Models:

The trained segmentation models can be downloaded from Zenodo:

[https://doi.org/10.5281/zenodo.20716818]

After downloading, place the model files in the appropriate directory specified in the Python scripts.

Dataset:

Dataset containing 90 subjects:

Subject 1-45: Normal (control)
Subject 46-90: Abnormal

Download the dataset from Zenodo:

[https://doi.org/10.5281/zenodo.20749486]

After downloading, extract the dataset and place it in a folder named Dataset.