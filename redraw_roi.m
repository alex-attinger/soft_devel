function [] = redraw_roi( ~,event )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

if event.Key == 'b'
    s3 = 'redraw = deletedList(end);cell_rois(redraw)=true;deletedList=deletedList(1:end-1)';
    evalin('base',s3);
    s4 = 'i3 = imoverlay(im,bwperim(sum(bm(:,:,cell_rois),3)),[1 1 0]);axes(a);h=imagesc([1:750],[1:400],i3);set(a, ''ButtonDownFcn'', @clicker_roi);set(h,''HitTest'',''off'')';
    evalin('base',s4);
end

end

