function negative_selection(im,savepath)
    if nargin == 0
        im = zeros(400,750);
        savepath = 'b';
    end
   
  
    ud = struct();
    ud.im = mat2gray(im);
    ud.savepath = savepath;
    ud.points = {};
    ud.currentpoint =[];
    ud.win_widht = 40;
    ud.idx = [0:39];
    
    h.f=figure('menubar','none','color','k','Position', [100, 100, 750, 400]);
    %set(h.f,'HitTest','off')
    h.a1=axes('position',[0 0.0 1. 1.],'Units','pixels');
    axis tight
    
    axis off
    set(h.f,'userdata',ud);
    set(h.f,'keypressfcn',{@keypressfnc, h})
    set(h.f,'WindowButtonDownFcn',{@clicker_non_cell,h})
    redraw(h)
    
    
    
end

function redraw(h)
    ud_loc = get(h.f,'userdata');
    %imagesc('CData',ud_loc.im,'Parent',h.a1);
    imshow(ud_loc.im,[],'Parent',h.a1);
    n_rect = length(ud_loc.points);
    for ii = 1:n_rect
        rectangle('Position',[ud_loc.points{ii}(1),ud_loc.points{ii}(2),40,40,],'EdgeColor','y')
    end
    if ~isempty(ud_loc.currentpoint)
        rectangle('Position',[ud_loc.currentpoint(1), ud_loc.currentpoint(2),40,40],'EdgeColor','r')
    end
end

function keypressfnc(hObj,event,h)
    ud_loc = get(h.f,'userdata');
    switch event.Key
        case 'a'
            nrois = length(ud_loc.points);
            ud_loc.points{nrois+1}=ud_loc.currentpoint;
            ud_loc.currentpoint
            t=ud_loc.im(ud_loc.currentpoint(2)+ud_loc.idx,ud_loc.currentpoint(1)+ud_loc.idx);
            temp = dir([ud_loc.savepath '*.png']);
            counter = length(temp)+1;
            fn = [ud_loc.savepath sprintf('im_%d.png',counter)];
            imwrite(t,fn);
        case 'd'
            ud_loc.currentoint=[];
    
    end
    set(h.f,'userdata',ud_loc);
    redraw(h);
end


function clicker_non_cell(hobj,event,h)
   

    %get(h, 'selectiontype')
    % 'normal' for left moue button
    % 'alt' for right mouse button
    % 'extend' for middle mouse button
    % 'open' on double click
    ud_loc = get(h.f,'userdata');
    aI=get(hobj, 'currentpoint');
    a=aI;
    a(2)=-a(2)+401;
    a=a-ud_loc.win_widht/2;
    % Current mouse location, in pixels from the lower left.
    % When the units of the figure are 'normalized', the
    % coordinates will be [0 0] inb lower left, and [1 1] in
    % the upper right.
    
    ud_loc.currentpoint = a;
    ud_loc.currentpointI = aI;
    set(h.f,'userdata',ud_loc);
    redraw(h)

end






