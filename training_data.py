# -*- coding: utf-8 -*-
"""
Created on Wed Feb 12 12:53:20 2014

@author: attialex
"""
import glob
from skimage import io, feature
import skimage
import numpy as np

def getTrainingData(searchstring):
    orientations = 9;    
    ppc = (8,8)
    cpb = (3,3)
    files = glob.glob(searchstring)
    im = io.imread(files[1])
    h = feature.hog(im,orientations= orientations, pixels_per_cell = ppc,cells_per_block = cpb)
    dataMat = np.zeros((len(files)*5,len(h)))
    counter = 0
    for i,f in enumerate(files):
                
        im= io.imread(f)
        ims = rotatedImList(im)
        
        for im in ims:
            h = feature.hog(im,orientations= orientations, pixels_per_cell = ppc,cells_per_block = cpb)
            dataMat[counter,:]=h;
            counter +=1
        
    
    return dataMat
    
    
def rotatedImList(im):
    ims = list()
    ims.append(im)
    
    ims.append(np.fliplr(im));
    ims.append(np.flipud(im));
    im_90 = np.rot90(im)
    ims.append(im_90)
    ims.append(np.flipud(im_90));
    return ims

def saveRotatedImages(searchstring,targetPath):
    files = glob.glob(searchstring)
    counter = 0
    for i,f in enumerate(files):
        
        im= io.imread(f)
        ims = rotatedImList(im)
            
        for im in ims:
            fn = targetPath+'{:05d}.png'.format(counter)
            io.imsave(fn,im)
            counter = counter+1
    return
        
    
if __name__=='__main__':
    
    tp_string = 'M:/attialex/images/tp_cleaned_vml/*.png'
    tn_string = 'M:/attialex/images/tn/*.png'
    saveRotatedImages(tp_string,'M:/attialex/images/tp_rot/')
    saveRotatedImages(tn_string,'M:/attialex/images/tn_rot/')
#    
#    tp_mat = getTrainingData(tp_string)
#    tn_mat = getTrainingData(tn_string)
#    X = np.concatenate((tp_mat,tn_mat))
#    
#    tp_label = np.ones((len(tp_mat),),dtype='uint8')
#    tn_label = np.zeros((len(tn_mat)),dtype='uint8')
#    Y = np.concatenate((tp_label,tn_label))
#    np.savez('C:/users/attialex/Desktop/training_data',X=X,Y=Y)