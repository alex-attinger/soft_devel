function oii_eval(movie,fs)
    if nargin == 1
        fs = 10;
    end
    ud = struct();
    ud.maxFreq = fs/2;
        
        ud.center = (.1*ud.maxFreq);
        ud.width = (0.1*ud.maxFreq);
    
    ud.nFrames = size(movie,3);
    ud.log = 0;
    mov = double(movie);
    %xdft(1:N/2+1);
    MOV = fft(mov,[],3);
    ud.MOV = abs(MOV(:,:,1:ud.nFrames/2+1)).^2;
    ud.phase = angle(MOV(:,:,1:ud.nFrames/2+1));
    ud.maxBin = size(ud.MOV,3);
    
    % Create a figure and an axes to contain a 3-D surface plot.
    h.f=figure('menubar','none','color','k','Position', [100, 100, 800, 800]);
    h.a1=axes('position',[-.3 0.2 1 0.6],'Units','pixels');
    axis off
    
    

    
    % Add a slider uicontrol to control the vertical scaling of the
    % surface object. Position it under the Clear button.
    uicontrol('Style', 'slider',...
        'Min',0,'Max',1,'Value',ud.center/ud.maxFreq,...
        'Position', [100 20 130 20],...
        'Callback', {@center_cb, h},...
        'SliderStep',[.01 .01]/(1)); 
					% Slider function handle callback
          % Implemented as a local function
   
    % Add a text uicontrol to label the slider.
    ud.lLabel = uicontrol('Style','text',...
        'Position',[100 45 120 20],...
        'String',sprintf('Center Frequency Hz: %.03f',ud.center));
    
    uicontrol('Style', 'slider',...
        'Min',0,'Max',.5,'Value',ud.width/ud.maxFreq,...
        'Position', [250 20 130 20],...
        'Callback', {@width_cb, h},...
        'SliderStep',[.01 .01]/(.5)); 
    
    % Add a text uicontrol to label the slider.
    ud.hLabel = uicontrol('Style','text',...
        'Position',[250 45 120 20],...
        'String',sprintf('Bin width: %.03f',2*ud.width));
   set(h.f,'userdata',ud); 
   set(h.f,'keypressfcn',{@keypressfcn,h});
   redraw(h);
  
end

function redraw(h)
    ud_loc = get(h.f,'userdata');
    im = getIm(ud_loc,[400,400]);
    imshow(im,'Parent',h.a1);colormap(gray())
    set(ud_loc.lLabel,'String',sprintf('Center Frequency: %.03f',ud_loc.center))
    set(ud_loc.hLabel,'String',sprintf('Bin Width: %.03f',2*ud_loc.width))
    
    
    idx = getIdx(ud_loc);
    [y,i]=max(ud_loc.MOV(:,:,idx),[],3);
    idx = i+idx(1)-1;
    
    f_idx = reshape(idx,[],1);


    npix = numel(ud_loc.MOV(:,:,1));
    pixIDX = (1:npix)';
    fullidx = pixIDX+npix*(f_idx-1);
    imphase = ud_loc.phase(fullidx);
    imphase = reshape(imphase,size(ud_loc.MOV(:,:,1)));
    imphase = mat2gray(imphase);
    imphase = imresize(imphase,[600,600]);
    figure(12)
    imshow(imphase);colormap(hsv());caxis([-pi,pi]);colorbar;
    %imshow(imphase,'Parent',h.a2);colormap(hsv());freezeColors(h.a2);cbfreeze(colorbar);
    
    set(h.f,'userdata',ud_loc);
    
end

function idx = getIdx(ud)
    c = round(ud.center*ud.maxBin/ud.maxFreq);
    width = round(ud.width*ud.maxBin/ud.maxFreq);
 
    idx = c+[-width:width];
    idx = idx(idx>0);
    idx = idx(idx<=ud.maxBin);
end

function iml = getIm(ud,size)
    if nargin == 1
        size = [];
    end

    idx = getIdx(ud);
    iml = sum(ud.MOV(:,:,idx),3);
    if ud.log
        iml = log(iml);
    end
    iml = mat2gray(iml);
    if ~isempty(size)
        iml = imresize(iml,[600,600]);
    end
end


function keypressfcn(hObj,event,h)
    ud_loc = get(h.f,'userdata');
    switch event.Key
        case 'p'
            s=sprintf('Amin = %d;\n Amax = %d; \n Vmin = %.3g;\n Vmax = %.3g;\n Vstep = %.3g; ',ud_loc.amin,ud_loc.amax,ud_loc.vmin,ud_loc.vmax,ud_loc.vstep);
            disp(s)
        case 's'
             im = getIm(ud_loc);
             assignin('base','image',im);
        case 'l'
            ud_loc.log = ~ud_loc.log;
            ud_loc.log
   

    end
    redraw(h);
    set(h.f,'userdata',ud_loc);
end









function center_cb(hObj,event,h) %#ok<INUSL>
    % Called to set zlim of surface in figure axes
    % when user moves the slider control 
    ud_loc = get(h.f,'userdata');
    val = get(hObj,'Value');
    
        
    ud_loc.center = val*ud_loc.maxFreq;
      
    set(h.f,'userdata',ud_loc);
     redraw(h)
    
     
end

function width_cb(hObj,event,h) %#ok<INUSL>
    % Called to set zlim of surface in figure axes
    % when user moves the slider control 
    ud_loc = get(h.f,'userdata');
    val = get(hObj,'Value');
    
        ud_loc.width = val*ud_loc.maxFreq;
    set(h.f,'userdata',ud_loc);
        redraw(h);
   
     
end
