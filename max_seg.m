function max_seg(im,roifun,ud)
    if nargin < 2
        roifun = @slice_maximum;
    end
    if nargin <3
        ud = struct();
        ud.vmin = .05;
        ud.vmax = 0.7;
        ud.vstep = .05;
        ud.amin = 60;
        ud.amax = 400;
        ud.im = im;
        ud.eccentricity = 1;
        ud.roifun = roifun;
    end
    % Create a figure and an axes to contain a 3-D surface plot.
    h.f=figure('menubar','none','color','k','Position', [100, 100, 1049, 895]);
    h.a1=axes('position',[0 0.025 0.975 1],'Units','pixels');
    axis off
    set(h.f,'userdata',ud);
    set(h.f,'keypressfcn',{@keypressfnc, h})
    getRois(h);
    eval_regionprops(h);
    redraw(h);
    
    
    
    
    % Add a slider uicontrol to control the vertical scaling of the
    % surface object. Position it under the Clear button.
    uicontrol('Style', 'slider',...
        'Min',0,'Max',1,'Value',ud.vmin,...
        'Position', [100 20 120 20],...
        'Callback', {@vmin_cb, h},...
        'SliderStep',[.05 .05]/(1)); 
					% Slider function handle callback
          % Implemented as a local function
   
    % Add a text uicontrol to label the slider.
    uicontrol('Style','text',...
        'Position',[100 45 120 20],...
        'String','Vmin')
    
    uicontrol('Style', 'slider',...
        'Min',0,'Max',1,'Value',ud.vmax,...
        'Position', [250 20 120 20],...
        'Callback', {@vmax_cb, h},...
        'SliderStep',[.05 .05]/(1)); 
    
    % Add a text uicontrol to label the slider.
    uicontrol('Style','text',...
        'Position',[250 45 120 20],...
        'String','Vmax')
    
   
    
    uicontrol('Style', 'slider',...
        'Min',0.01,'Max',0.3,'Value',ud.vstep,...
        'Position', [400 20 120 20],...
        'Callback', {@vstep_cb, h},...
        'SliderStep',[.05 .05]/(0.29)); 
     uicontrol('Style','text',...
        'Position',[400 45 120 20],...
        'String','Vstep')
					% Slider function handle callback
          % Implemented as a local function
   
    
    
    uicontrol('Style', 'slider',...
        'Min',5,'Max',250,'Value',ud.amin,...
        'Position', [600 20 120 20],...
        'Callback', {@amin_cb, h},...
        'SliderStep',[10 10]/(245)); 
					% Slider function handle callback
          % Implemented as a local function
   
    % Add a text uicontrol to label the slider.
    uicontrol('Style','text',...
        'Position',[600 45 120 20],...
        'String','Amin')
    
    uicontrol('Style', 'slider',...
        'Min',300,'Max',1000,'Value',ud.amax,...
        'Position', [750 20 120 20],...
        'Callback', {@amax_cb, h},...
        'SliderStep',[50 50]/(700)); 
					% Slider function handle callback
          % Implemented as a local function
   
    % Add a text uicontrol to label the slider.
    uicontrol('Style','text',...
        'Position',[750 45 120 20],...
        'String','Amax')
    
      uicontrol('Style', 'slider',...
        'Min',0,'Max',1,'Value',ud.eccentricity,...
        'Position', [750 60 120 20],...
        'Callback', {@exx_cb, h},...
        'SliderStep',[.01 .01]); 
					% Slider function handle callback
          % Implemented as a local function
   
    % Add a text uicontrol to label the slider.
    uicontrol('Style','text',...
        'Position',[750 85 120 20],...
        'String','Eccentricity')
    
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
function redraw(h)
    ud_loc = get(h.f,'userdata');
    overl = imoverlay(ud_loc.im,bwperim(ud_loc.bwcurr),[0 1 0]);
    imshow(overl,'Parent',h.a1);
end

function eval_regionprops(h)
    ud_loc = get(h.f,'userdata');
    CC = bwconncomp(ud_loc.bwtot);
    stats = regionprops(CC,'Eccentricity');
    ud_loc.bwcurr = ud_loc.bwtot;
    for ii = 1:length(stats)
        if stats(ii).Eccentricity > ud_loc.eccentricity
            ud_loc.bwcurr(CC.PixelIdxList{ii})=0;
        end
    end
    set(h.f,'userdata',ud_loc)
    redraw(h)
end

function exx_cb(hObj,event,h)
    ud_loc = get(h.f,'userdata');
    ud_loc.eccentricity = get(hObj,'value');
    set(h.f,'userdata',ud_loc);
    eval_regionprops(h);
    redraw(h);
end


function getRois(h)
    ud = get(h.f,'userdata');
    bwtot = ud.roifun(ud.im,ud);
    ud.bwtot = bwtot;
    set(h.f,'userdata',ud);
    
end


function vmin_cb(hObj,event,h) %#ok<INUSL>
    % Called to set zlim of surface in figure axes
    % when user moves the slider control 
    ud = get(h.f,'userdata');
    val = get(hObj,'Value');
    if val <=ud.vmax
        
       ud.vmin = val;
       set(h.f,'userdata',ud)
       getRois(h);
       eval_regionprops(h);
       redraw(h)
    else
        set(hObj,'Value',ud.vmin);
    end
    
end
function vmax_cb(hObj,event,h) %#ok<INUSL>
    % Called to set zlim of surface in figure axes
    % when user moves the slider control 
    ud = get(h.f,'userdata');
    val = get(hObj,'Value');
    if val <=ud.vmin
       set(hObj,'Value',ud.vmax);
    else
        ud.vmax = val;
        set(h.f,'userdata',ud)
        getRois(h);
        eval_regionprops(h);
        redraw(h);
    end
    
end

function vstep_cb(hObj,event,h) %#ok<INUSL>
    % Called to set zlim of surface in figure axes
    % when user moves the slider control 
    ud = get(h.f,'userdata');
    val = get(hObj,'Value');
    
        ud.vstep = val;
        set(h.f,'userdata',ud)
        getRois(h);
        eval_regionprops(h);
        redraw(h);
    
end

function amax_cb(hObj,event,h) %#ok<INUSL>
    % Called to set zlim of surface in figure axes
    % when user moves the slider control 
    ud = get(h.f,'userdata');
    val = get(hObj,'Value');
    if val <=ud.amin
       set(hObj,'Value',ud.amax);
    else
        ud.amax = val;
        set(h.f,'userdata',ud)
        getRois(h);
        eval_regionprops(h);
        redraw(h);
    end
    
end

function amin_cb(hObj,event,h) %#ok<INUSL>
    % Called to set zlim of surface in figure axes
    % when user moves the slider control 
    ud = get(h.f,'userdata');
    val = get(hObj,'Value');
    if val >=ud.amax
       set(hObj,'Value',ud.amin);
    else
        ud.amin = val;
        set(h.f,'userdata',ud)
        getRois(h);
        eval_regionprops(h);
        redraw(h);
    end
    
end