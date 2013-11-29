im = im1;
act_map = im2; 
step_mean = 1/10;
V_mean=[.1:step_mean:1];
V_act = [.1:1/10:1];
h = fspecial('gaussian',3,1);

im=imfilter(im,h);

im = template_preprocessing(im);

act_map=imfilter(act_map,h);



act_map = mat2gray(act_map);

X1=slice_thresholding(im,V_mean,2);
X2=slice_thresholding(act_map,V_act,1);

i1=imoverlay(im,bwperim(sum(X1,3)),[0 1 0]);
        i2=imoverlay(act_map,bwperim(sum(X2,3)),[0 1 0]);
        %i1=imoverlay(i1,man_segs,[.5 0 0]);
        %i2=imoverlay(i2,man_segs,[.5 0 0]);
        allRois = cat(3,X1,X2);
