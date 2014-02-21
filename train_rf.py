# -*- coding: utf-8 -*-
"""
Created on Wed Feb 12 13:57:29 2014

@author: attialex
"""

from sklearn import ensemble
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
    rf = ensemble.RandomForestClassifier(n_estimators = 100,n_jobs=1,oob_score=True)
    f=np.load('C:/users/attialex/Desktop/training_data.npz')
    X=f['X']
    Y=f['Y']
    print 'training the forest...'
    rf.fit(X,Y)
    print 'done'
    print 'oob score:{}'.format(rf.oob_score_)
    
    im = io.imread('M:/attialex/images/lfm/bernhard/template_6_2.png')
    
    imex = im[0:400,0:400]
    
    
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
    probs = rf.predict_proba(td)
    probs[probs<.7]=0
    out_pile = probs[:,0]
    out_cell = probs[:,1]
    
    out_cell = np.reshape(out_cell,(winds.shape[0],winds.shape[1]))
    out_pile = np.reshape(out_pile,(winds.shape[0],winds.shape[1]))
    out_pile = np.pad(out_pile,((19,20),(19,20)),'constant')
    out_cell = np.pad(out_cell,((19,20),(29,10)),'constant')
    plt.figure()
    plt.subplot(121)
    plt.imshow(out_cell)
    plt.subplot(122)
    plt.imshow(out_pile)
    try:
        io.imsave('C:/users/attialex/Desktop/out_pile_3.png',skimage.img_as_uint(out_pile))
        io.imsave('C:/users/attialex/Desktop/out_cell_3.png',skimage.img_as_uint(out_cell))
    except Exception as e:
        print e.message
    
    try:
        bg = normalize3Chan(imex*1.)
        
        fg_c = normalize3Chan(out_cell)
        fg_p = normalize3Chan(out_pile)
        fg_c[:,:,0]=0;
        fg_c[:,:,2]=0;
        
        s1 = cv2.addWeighted(bg,.8,fg_c,.2,0)
        cv2.imshow('cell',s1)
        s2 = cv2.addWeighted(bg,.8,fg_p,.2,0)
        cv2.imshow('pile',s2)
        cv2.waitKey()
    except Exception as e:
        print e.message
    
    
    max_pile = maximum(out_pile,np.ones((40,40)))
    unique_pile = np.unique(max_pile)
    
    max_cell = maximum(out_cell,np.ones((40,40)))
    unique_cell = np.unique(max_cell)
    plt.show()