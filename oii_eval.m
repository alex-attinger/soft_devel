function oii_eval(movie)
    
   global ud
        ud = struct();
        ud.low = .05;
        ud.high = 0.15;
    
    ud.nFrames = size(movie,3);
   
    mov = double(movie);
    %xdft(1:N/2+1);
    MOV = fft(mov,[],3);
    ud.MOV = abs(MOV(:,:,1:ud.nFrames/2+1)).^2;
    ud.maxFreq = size(MOV,3);
    % Create a figure and an axes to contain a 3-D surface plot.
    h.f=figure('menubar','none','color','k','Position', [100, 100, 1049, 895]);
    h.a1=axes('position',[0 0.025 0.975 1],'Units','pixels');
    axis off
    set(h.f,'userdata',ud);
    
    redraw(h);
    
    
    % Add a slider uicontrol to control the vertical scaling of the
    % surface object. Position it under the Clear button.
    uicontrol('Style', 'slider',...
        'Min',0,'Max',1,'Value',ud.low,...
        'Position', [100 20 120 20],...
        'Callback', {@low_cb, h},...
        'SliderStep',[.05 .05]/(1)); 
					% Slider function handle callback
          % Implemented as a local function
   
    % Add a text uicontrol to label the slider.
    uicontrol('Style','text',...
        'Position',[100 45 120 20],...
        'String','Lower Bound')
    
    uicontrol('Style', 'slider',...
        'Min',0,'Max',1,'Value',ud.high,...
        'Position', [250 20 120 20],...
        'Callback', {@high_cb, h},...
        'SliderStep',[.05 .05]/(1)); 
    
    % Add a text uicontrol to label the slider.
    uicontrol('Style','text',...
        'Position',[250 45 120 20],...
        'String','Upper Bound')
    
   
  
end

function redraw(h)
global ud
    f = floor(ud.low*ud.maxFreq);
    t = ceil(ud.high*ud.maxFreq);
    t
    f
    %ud_loc = get(h.f,'userdata');
    %overl = imoverlay(ud_loc.im,bwperim(ud_loc.bwcurr),[0 1 0]);
    %imshow(overl,'Parent',h.a1);
    im = sum(ud.MOV(:,:,f:t),3);
    imshow(mat2gray(im),'Parent',h.a1);
end

function keypressfnc(hObj,event,h)
    ud_loc = get(h.f,'userdata');
    switch event.Key
        case 'p'
            s=sprintf('Amin = %d;\n Amax = %d; \n Vmin = %.3g;\n Vmax = %.3g;\n Vstep = %.3g; ',ud_loc.amin,ud_loc.amax,ud_loc.vmin,ud_loc.vmax,ud_loc.vstep);
            disp(s)
        case 's'
            assignin('base','ud_out',ud_loc);
            
    
    end
end









function low_cb(hObj,event,h) %#ok<INUSL>
    % Called to set zlim of surface in figure axes
    % when user moves the slider control 
    global ud
    val = get(hObj,'Value');
    if val <ud.high
        
       ud.low = val;
      
      
       redraw(h)
    else
        set(hObj,'Value',ud.low);
    end
    
end
function high_cb(hObj,event,h) %#ok<INUSL>
    % Called to set zlim of surface in figure axes
    % when user moves the slider control 
    global ud
    val = get(hObj,'Value');
    if val <=ud.low
       set(hObj,'Value',ud.high);
    else
        ud.high = val;
 
        redraw(h);
    end
    
end
