function clicker_cell(h,~)
   

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
    
    s2 = [sprintf('m = m | polartrans(imi,40,512,%d,%d);',a(1),a(2))];
    s3 = ['overl=imoverlay(im,m,[0 1 0]);axes(a);h=imagesc(overl);set(a,' char(39) 'ButtonDownFcn' char(39) ',@clicker_cell);' 'set(h,' char(39) 'HitTest' char(39) ',' char(39) 'off' char(39) ')'];
    evalin('base',s2);
    evalin('base',s3);
    

end
