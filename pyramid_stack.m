function [ stack ] = pyramid_stack( im )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
ftype = 'disk';
radius = [5,10];
stack = struct();
for ii = 1:numel(radius)
    stack(ii).dat = imfilter(im,fspecial(ftype,radius(ii)));
end
stack = cat(3,stack.dat);
stack = cat(3,im,stack);

end

