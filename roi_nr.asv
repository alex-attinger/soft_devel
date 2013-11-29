function [ roi ] = roi_nr(rois,r,c)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

point = false(400,750);
point(r,c)=true;
found_one = false;
n_rois =size(rois,3);
roi = nan;
for ii = 1:n_rois
    if nnz(rois(:,:,ii) & point)>0
        found_one = true;
        roi = ii;
        break
    end
end
if ~found_one
    disp('no roi found')
end


end

