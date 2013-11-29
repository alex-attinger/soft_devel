function [ h ,x] = subhisto(im,cx,cy,size)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
binstep = .01;
x=0:binstep:1;
excerpt = im(round(cy-size/2):round(cy+size/2),round(cx-size/2):round(cx+size/2));
[h,x] = hist(excerpt(:),x);

end

