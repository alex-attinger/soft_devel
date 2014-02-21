function bwtot = slice_maximum(im,ud)
if nargin == 1
    ud = struct();
   
end
if ~isa(ud,'struct')
    ud = struct();
end
if ~isfield(ud,'amin'); ud.amin = 90; end
if ~isfield(ud,'amax'); ud.amax = 600; end
if ~isfield(ud,'vmin'); ud.vmin = 0.05; end
if ~isfield(ud,'vmax'); ud.vmax = 0.7; end
if ~isfield(ud,'vstep'); ud.vstep = 0.05; end
    
V = ud.vmin:ud.vstep:ud.vmax;

bwtot = false(400,750);
for ii = 1:numel(V)
    bw = imextendedmax(im,V(ii));
    mask_em = imclose(bw, ones(3,3));
    mask_em = imfill(mask_em, 'holes');
    mask_em = bwareaopen(mask_em, ud.amin);
    %bw = bwareaopen(bw,arealim);
    CC = bwconncomp(mask_em);
    %figure; imshow(mask_em)

    numPixels = cellfun(@numel,CC.PixelIdxList);
    idx = numPixels < ud.amin | numPixels>ud.amax;
    for jj = 1:numel(idx)
        if idx(jj)
            mask_em(CC.PixelIdxList{jj})=0;
        else
            common = sum(intersect(CC.PixelIdxList{jj},find(bwtot)));
            if common > 2
                CC.PixelIdxList{jj}=0;
            end
        end
        
    end
    
    bwtot = bwtot  | mask_em;
    
end


    

    

