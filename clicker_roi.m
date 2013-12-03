function clicker_roi(h,~)
   

    %get(h, 'selectiontype')
    % 'normal' for left moue button
    % 'alt' for right mouse button
    % 'extend' for middle mouse button
    % 'open' on double click

    a=floor(get(h, 'currentpoint'));
    % Current mouse location, in pixels from the lower left.
    % When the units of the figure are 'normalized', the
    % coordinates will be [0 0] inb lower left, and [1 1] in
    % the upper right.
    a=a(1,:);
   
    s2 = [sprintf('current_roi = roi_nr(bm,%d,%d);',a(2),a(1))];
    
    evalin('base',s2);
    
    %s3 = ['if ~isnan(current_roi); cell_rois(current_roi)=false;bm(:,:,current_roi) = false(400,750);i3 = imoverlay(im,bwperim(sum(bm,3)),[1 1 0]);axes(a);h=imagesc([1:750],[1:400],i3);set(a, ''ButtonDownFcn'', @clicker_roi);set(h,''HitTest'',''off'');end' ];
    
    s3 = ['if ~isnan(current_roi);deletedList(end+1)=current_roi;cell_rois(deletedList)=false;i3 = imoverlay(im,bwperim(sum(bm(:,:,cell_rois),3)),[1 1 0]);axes(a);h=imagesc([1:750],[1:400],i3);set(a, ''ButtonDownFcn'', @clicker_roi);set(h,''HitTest'',''off'');end' ];
    evalin('base',s3);
    
    
    

end

