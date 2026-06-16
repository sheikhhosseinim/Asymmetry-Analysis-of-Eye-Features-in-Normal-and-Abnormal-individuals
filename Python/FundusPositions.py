# -*- coding: utf-8 -*-
"""
Created on Sun Jun 14 21:11:35 2026

@author: msi
"""


import tensorflow as tf
import numpy as np
# import matplotlib.pyplot as plt
import cv2
# import os

#%%
#**********************************
# encoder and decoder blocks
def Encoder(x, k, ks, dr, a=0.1):
  x = tf.keras.layers.Conv2D(2 * k, kernel_size=(ks, ks), strides=(1, 1), padding='same', dilation_rate=(dr, dr))(x)
  x = tf.keras.layers.BatchNormalization()(x)
  x = tf.keras.layers.LeakyReLU(alpha=a)(x)
  x = tf.keras.layers.Conv2D(k, kernel_size=(ks, ks), strides=(1, 1), padding='same', dilation_rate=(dr, dr))(x)
  x = tf.keras.layers.BatchNormalization()(x)
  x = tf.keras.layers.LeakyReLU(alpha=a)(x)
  x = tf.keras.layers.Conv2D(2 * k, kernel_size=(ks, ks), strides=(1, 1), padding='same', dilation_rate=(dr, dr))(x)
  x = tf.keras.layers.BatchNormalization()(x)
  x = tf.keras.layers.LeakyReLU(alpha=a)(x)
  pool = tf.keras.layers.MaxPool2D(pool_size=(2, 2), strides=(2, 2))(x)
  return x, pool

def Decoder(x, skip, k, ks, dr, a=0.1):
  x = tf.keras.layers.concatenate([tf.keras.layers.Conv2DTranspose(k, kernel_size=(2, 2), strides=(2, 2), padding='same')(x), skip])
  x = tf.keras.layers.Conv2D(2 * k, kernel_size=(ks, ks), strides=(1, 1), padding='same', dilation_rate=(dr, dr))(x)
  x = tf.keras.layers.BatchNormalization()(x)
  x = tf.keras.layers.LeakyReLU(alpha=a)(x)
  x = tf.keras.layers.Conv2D(k, kernel_size=(ks, ks), strides=(1, 1), padding='same', dilation_rate=(dr, dr))(x)
  x = tf.keras.layers.BatchNormalization()(x)
  x = tf.keras.layers.LeakyReLU(alpha=a)(x)
  x = tf.keras.layers.Conv2D(2 * k, kernel_size=(ks, ks), strides=(1, 1), padding='same', dilation_rate=(dr, dr))(x)
  x = tf.keras.layers.BatchNormalization()(x)
  x = tf.keras.layers.LeakyReLU(alpha=a)(x)
  return x

def BuildModel(k, IMG_SIZE=128, KPS=2, C=3):
  inputs = tf.keras.Input(shape=(IMG_SIZE, IMG_SIZE, C))
  conv1, pool1 = Encoder(inputs, k, 7, 1)
  k = k * 2
  conv2, pool2 = Encoder(pool1, k, 5, 1)
  k = k * 2
  conv3, pool3 = Encoder(pool2, k, 3, 1)
  k = k * 2
  conv4, pool4 = Encoder(pool3, k, 3, 2)
  k = k * 2
  conv5, _ = Encoder(pool4, k, 3, 2)
  deconv1 = Decoder(conv5, conv4, k, 3, 2)
  k = k // 2
  deconv2 = Decoder(deconv1, conv3, k, 3, 1)
  k = k // 2
  deconv3 = Decoder(deconv2, conv2, k, 5, 1)
  k = k // 2
  deconv4 = Decoder(deconv3, conv1, k, 7, 1)
  outputs = tf.keras.layers.Conv2D(KPS, kernel_size=(1, 1))(deconv4)
  outputs = tf.keras.layers.BatchNormalization()(outputs)
  outputs = tf.keras.layers.Activation('sigmoid')(outputs)
  model = tf.keras.Model(inputs=inputs, outputs=outputs)
  return model
#%%
#*********************************
  # build the model
fp = BuildModel(16)
fp.compile(optimizer=tf.keras.optimizers.Adam(lr=1e-3),
           loss='MSE')
# uncomment the following line, to continue training from last checkpoint
fp.summary()

main_path="E:/.../Python/"
model_path=main_path+"models/FPN.model"
Dataset='H:/..../Dataset/'

checkpoint = tf.keras.callbacks.ModelCheckpoint(model_path,
                                                monitor='val_loss', # monitor the val loss
                                                verbose=1,
                                                save_best_only=True,
                                                save_weights_only=False,
                                                mode='min', # save model if val loss is less
                                                period=50)
#%%
#*********************************
def EDprediction(paths, imgpath):
  count = 0
  predictedPos = []
  imName = []
  print(len(paths))
  for p in paths:
    try:
      # pre-process raw image
      img = cv2.imread(imgpath.format(p))
      img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
      # find the dimension re-scaling factor
      rH, rW = (1. * img.shape[0])/(1. * IMG_SIZE), (1. * img.shape[1])/(1. * IMG_SIZE)
      # resize the image
      img = cv2.resize(img, (IMG_SIZE, IMG_SIZE), interpolation=cv2.INTER_AREA)/255.0
      # feed the input image
      output = model.predict([img.reshape(1, IMG_SIZE, IMG_SIZE, 3)])
      points = []
      for i in range(2):
        # detect the countours
        cnts, _ = cv2.findContours(np.uint8(output[0, :, :, i]*255.0), cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
        max_area_index = [cv2.contourArea(cnt) for cnt in cnts]
        index = max_area_index.index(max(max_area_index))
        # apply moments on contour with max area
        M = cv2.moments(cnts[index])
        # find the co-ordinates from moments
        cx = M['m10']/M['m00']
        cy = M['m01']/M['m00']
        points.append(cx*rW)
        points.append(cy*rH)
      predictedPos.append(points)
      imName.append(p.split(".")[0])
      count = count + 1
    except:
      print(p)
  print(count)
  predictedPos = np.array(predictedPos)
  return predictedPos, imName
#*********************************
  
#%%
# single image output testing and layer by layer analysis, build the model architecture(fp) and compile it in the cells above
model = tf.keras.models.load_model(model_path)

fp.set_weights(model.get_weights())
inter = [tf.keras.Model(inputs=fp.input, outputs=fp.layers[i].output) for i in range(1, len(model.layers))]

IMG_SIZE = 128 # input image size

for subj_idx in range(90):

    data_path=Dataset+'subj'+str(subj_idx+1)
    
    filename=data_path+'/fundus_left.jpg'
    img = cv2.imread(filename)
    img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
    rH, rW = (1. * img.shape[0])/(1. * IMG_SIZE), (1. * img.shape[1])/(1. * IMG_SIZE)
    img = cv2.resize(img, (IMG_SIZE, IMG_SIZE), interpolation=cv2.INTER_AREA)/255.0
    output = model.predict([img.reshape(1, IMG_SIZE, IMG_SIZE, 3)])
    tmp = fp.predict([img.reshape(1, IMG_SIZE, IMG_SIZE, 3)])

    points = []
    for i in range(2):
        blur = cv2.GaussianBlur(np.uint8(output[0, :, :, i]*255.0), (25, 25), 0)
        _,th = cv2.threshold(blur,0,255,cv2.THRESH_BINARY+cv2.THRESH_OTSU)
        a,cnts, _ = cv2.findContours(th, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
        if cnts!=[]:
            max_area_index = [cv2.contourArea(cnt) for cnt in cnts]
            index = max_area_index.index(max(max_area_index))
            M = cv2.moments(cnts[index])
            cx = M['m10']/M['m00']
            cy = M['m01']/M['m00']
            img = cv2.drawMarker(img, (int(cx), int(cy)), (0,0,255), markerType=cv2.MARKER_CROSS,
                  markerSize=5, thickness=1, line_type=cv2.LINE_AA)
            points.append(cx*rW)
            points.append(cy*rH)

        name=filename[0:-4]+'.txt'
        np.savetxt(name,points)

    filename=data_path+'fundus_right.jpg'
    img = cv2.imread(filename)
    img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
    rH, rW = (1. * img.shape[0])/(1. * IMG_SIZE), (1. * img.shape[1])/(1. * IMG_SIZE)
    img = cv2.resize(img, (IMG_SIZE, IMG_SIZE), interpolation=cv2.INTER_AREA)/255.0
    output = model.predict([img.reshape(1, IMG_SIZE, IMG_SIZE, 3)])
    tmp = fp.predict([img.reshape(1, IMG_SIZE, IMG_SIZE, 3)])

    points = []
    for i in range(2):
        blur = cv2.GaussianBlur(np.uint8(output[0, :, :, i]*255.0), (25, 25), 0)
        _,th = cv2.threshold(blur,0,255,cv2.THRESH_BINARY+cv2.THRESH_OTSU)
        a,cnts, _ = cv2.findContours(th, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
        if cnts!=[]:
            max_area_index = [cv2.contourArea(cnt) for cnt in cnts]
            index = max_area_index.index(max(max_area_index))
            M = cv2.moments(cnts[index])
            cx = M['m10']/M['m00']
            cy = M['m01']/M['m00']
            img = cv2.drawMarker(img, (int(cx), int(cy)), (0,0,255), markerType=cv2.MARKER_CROSS,
                  markerSize=5, thickness=1, line_type=cv2.LINE_AA)
            points.append(cx*rW)
            points.append(cy*rH)

        name=filename[0:-4]+'.txt'
        np.savetxt(name,points)