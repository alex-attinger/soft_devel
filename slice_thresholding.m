function bwtot = slice_thresholding(im,V,leave_away)
if nargin ==1
    V=[.1:.02:.4 .9];
    leave_away=1;
end
w_s=1;
im=grayslice(im,V);
min_area = 90;
max_area = 400;
bwtot = false(400,750);
for ii = numel(V):-1:leave_away
    bw = im>=ii;
   
    %bw = bwareaopen(bw,arealim);
    CC = bwconncomp(bw);
    bworig = bw;
    numPixels = cellfun(@numel,CC.PixelIdxList);
    idx = numPixels < min_area | numPixels>max_area;
    for jj = 1:numel(idx)
        if idx(jj)
            bw(CC.PixelIdxList{jj})=0;
        end
    end
    %watershed, this is for segmentation of touching cells that were
    %discarded from above bc the area was too big.
    if w_s
        bwL = watershedSeg(bworig);
        bwtot(bwL)=1;
    end

    
    bwtot(bw) = 1;
    
end
%figure; imshow(bwtot);
CC=bwconncomp(bwtot);

    
    %bw = bwareaopen(bw,arealim);
    numElements = cellfun(@numel,CC.PixelIdxList);
    n_segs = CC.NumObjects;
    rois = false(size(im,1),size(im,2),n_segs);
    counter =1;
    for n = 1: n_segs
        if numElements(n) <= max_area+200 && numElements(n)>= min_area
            temp = false(400,750);
            temp(CC.PixelIdxList{n})=1;
            rois(:,:,counter)=temp;
            counter =counter+1;
        end
    end
    bwtot = rois;
    

    
    function bwL=watershedSeg(bworig)
        D = bwdist(~bworig);
        D=-D;
        D(~bworig)=-inf;
        L=watershed(D);
        rgb = label2rgb(L,'jet',[.5 .5 .5]);
        %figure, imshow(rgb,'InitialMagnification','fit')
        props = regionprops(L,'Area','PixelIdxList');
        bigtiles =0;
        for kk = 1:numel(props)
            if props(kk).Area>4000
                bigtiles = bigtiles +1;
            end
        end
        bwL = false(400,750);
        if bigtiles < 4
            
            for kk = 1:numel(props)
                if props(kk).Area < min_area || props(kk).Area > max_area +200
                    props(kk).PixelIdxList = [0];
                elseif nnz(bwtot(props(kk).PixelIdxList))>0
                    props(kk).PixelIdxList = [0];
                else
                    bwL(props(kk).PixelIdxList)=1;
                end
            end
        end
    end
%figure; imshow(bwL);
end 