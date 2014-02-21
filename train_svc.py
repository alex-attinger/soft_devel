# -*- coding: utf-8 -*-
"""
Created on Wed Feb 12 13:57:29 2014

@author: attialex
"""

from sklearn import svm
import numpy as np
from skimage import io, feature, util
import matplotlib.pyplot as plt
from skimage.filter.rank import maximum
import skimage
import cv2


def imoverlay(im,mask,color):

    
    # Construct a colour image to superimpose
    if im.ndim == 2:
        color_r = np.copy(im)
        color_g = np.copy(im)
        color_b = np.copy(im)
    else:
        color_r=im[:,:,0]
        color_g=im[:,:,1]
        color_b = im[:,:,2]
        
    color_r[mask] = color[0]  # Red block
    color_g[mask] = color[1] # Green block
    color_b[mask] = color[2] # Blue block
 
    # Construct RGB version of grey-level image
    img_color = np.dstack((color_r, color_g, color_b))
        
       
    return img_color
 
def normalize3Chan(img):
    img = (img-img.min())/(img.max()-img.min())
    
    return np.dstack((img,img,img))
    
    
if __name__=='__main__':
    sv = svm.SVC(verbose = True)
    
    f=np.load('C:/users/attialex/Desktop/training_data.npz')
    X=f['X']
    Y=f['Y']
    print 'training the forest...'
    sv.fit(X,Y)
    print 'done'
    
    
    im = io.imread('M:/attialex/images/lfm/bernhard/template_6_2.png')
    
    imex = im[100:300,200:350]
    
    
    winds = util.view_as_windows(imex,(40,40),step=1)
    h = feature.hog(winds[0][0])
    print 'testing...'
    
    td = np.zeros((winds.shape[0]*winds.shape[1],len(h)))
    counter = 0
    
    print 'creating the feature vector'
    for ii in range(0,winds.shape[0]):
        for jj in range(0,winds.shape[1]):
            td[counter,:]=feature.hog(winds[ii][jj])
            counter+=1
    print 'predicting'
    probs = sv.predict(td)
    
    
    out_cell = np.reshape(probs,(winds.shape[0],winds.shape[1]))
    plt.figure()
    plt.subplot(121)
    plt.imshow(out_cell)
    
    try:
        io.imsave('C:/users/attialex/Desktop/out_cell_4.png',skimage.img_as_uint(out_cell))
    except Exception as e:
        print e.message
    
    try:
        bg = normalize3Chan(imex*1.)
        
        fg_c = normalize3Chan(out_cell)
        fg_c[:,:,0]=0;
        fg_c[:,:,2]=0;
        s1 = cv2.addWeighted(bg,.8,fg_c,.2,0)
        cv2.imshow('cell',s1)
      
        cv2.waitKey()
    except Exception as e:
        print e.message
    
    
   
    max_cell = maximum(out_cell,np.ones((40,40)))
    unique_cell = np.unique(max_cell)
    plt.show()