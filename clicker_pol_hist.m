function clicker_pol_hist(h,~)
   

    %get(h, 'selectiontype')
    % 'normal' for left moue button
    % 'alt' for right mouse button
    % 'extend' for middle mouse button
    % 'open' on double click

    a=round(get(h, 'currentpoint'));
    % Current mouse location, in pixels from the lower left.
    % When the units of the figure are 'normalized', the
    % coordinates will be [0 0] inb lower left, and [1 1] in
    % the upper right.
    a=a(1,:);
    figure;
    s = sprintf('pim = polartrans(im,40,256,%d,%d);subplot(211);imagesc(pim)',a(1),a(2));
    
    s2 = sprintf('[h,x]=subhisto(img,%d,%d,40);,subplot(212);bar(x,h),xlim([0 1]);',a(1),a(2));
    evalin('base',s);
    evalin('base',s2);

end
