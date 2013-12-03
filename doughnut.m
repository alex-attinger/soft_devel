function [ h ] = doughnut( shape,r_i,r_o )
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
h = ones(shape)*-.1;
cen = ceil(shape/2);

r_i = r_i^2;
r_o = r_o^2;



for ii = 1:shape
    for jj = 1:shape
        d = (ii-cen)^2+(jj-cen)^2;
        if d<=r_o && d>=r_i
            h(ii,jj)=1;
        end
    end
end
% 
% h2 = fspecial('gaussian',5);
% h = imfilter(h,h2);
%h=h./abs(sum(h(:)));

end

