function clicker_activity(h,~)
   

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
    s = [sprintf('subplot(211);plot(activity{%d,%d}',a(2),a(1)) char(39) ')'];
    s2 = [sprintf('hold on; m = mean(activity{%d,%d},1);plot(m,',a(2),a(1)) char(39) 'k' char(39) ',' char(39) 'LineWidth' char(39) ',' num2str(2) ')'];
    figure; evalin('base',s)
    evalin('base',s2);
    s3 = [sprintf('subplot(212);plot(proj_meta(dset).rd(layer).act(%d,:),',a(2)) char(39) 'r' char(39) ')'];
    s4 = [sprintf('hold on;plot(proj_meta(dset).rd(layer).act(%d,:),',a(1)) char(39) 'g' char(39) ');title(' char(39) 'r: trigger' char(39) ')'];
    evalin('base',s3);
    evalin('base',s4);

end
