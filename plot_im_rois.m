function [ imoverl,man_segs ] = plot_im_rois(im,rois,handle)
%% if rois is a struct, it assumes it is a roi struct from callipe
%% if rois is a 3d matrix of logicals, it assumes that each plane contains a mask
imoverl = zeros(size(im));
if isa(rois,'logical')
    r = sum(rois,3)>0;
    map = bwperim(r);
    man_segs = r;
end

if isa(rois,'struct')
    man_segs = zeros(size(im));
    for i_roi = 1:numel(rois)
        man_segs(rois(i_roi).indices)=1;
    end
    map = bwperim(man_segs>0);
end

imoverl1 = imoverlay(mat2gray(im),map,[0 1 0]);
if nargin ==2
    %imshow(imoverl1)
else if nargin ==3
        %imshow(imoverl1,'Parent',handle)
    end
end
    if nargout >= 1
        imoverl = imoverl1;
        
    end
end

