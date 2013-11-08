dset = 1;
layer = 1;
im = mat2gray(proj_meta(dset).rd(layer).template);

d_nut = doughnut(41,12,14);

imshow([im;mat2gray(imfilter(im,d_nut))])