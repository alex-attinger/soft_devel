function [ binxymask, n_redsegs ] = segmentMerging(n_segs,binxymask,overlap,areaofmask)

if nargin < 4
    areaofmask = zeros(1,n_segs);
    disp('calculating areas')
    for i= 1:n_segs
        areaofmask(i)=nnz(binxymask(:,:,i));
    end
end
    

disp('----merging segments contained in each other----');
 newbinxymask = binxymask;
 blank = false(size(binxymask(:,:,1)));
 figure(22)
 for n = 1: n_segs-1
     for m = n+1 : n_segs
         commonmask = binxymask(:,:,n) & binxymask(:,:,m);
         commonpixels = nnz(commonmask);
%             figure(22)
%             imshow(commonmask)
%             %input('anz key')
%             pause(0.1)
         if commonpixels > 0
            
             if (areaofmask(n) > overlap *commonpixels) || (areaofmask(m) > overlap * commonpixels)
                 if areaofmask(n) > areaofmask(m)
                     newbinxymask(:,:,m)=blank;
                 else
                     newbinxymask(:,:,n)=blank;
                 end
             end
         end
     end
 end

 %Removal of empty segments
 emptyseg = zeros(size(binxymask,3));
 n_redsegs=0 ;
 for n = 1: n_segs
     emptyseg(n) = nnz(newbinxymask(:,:,n));
     if emptyseg(n) > 0
         n_redsegs = n_redsegs+1;
     end
 end
 
 binxymask=false(size(binxymask,1), size(binxymask,2), n_redsegs);
 j=1;
 for n = 1: n_segs
     if emptyseg(n) > 0
         binxymask(:,:,j) = newbinxymask(:,:,n);
         j=j+1;
     end
 end
 
 clear j;
 clear newbinxymask;
%  
%  figure(23)
%  mask2=sum(binxymask,3);
%  mask2=bwperim(mask2>0);
%  overl=imoverlay(meanIm,mask2,[0,155,155]);
%  imshow(overl)
%  
%  imshow(overl)
%  
%  figure(24)
%  overl2=imoverlay(overl,mask,[155,0,0]);
%  imshow(overl2)
%  title('r: before merging overlapping segments, b: after merging');
%  toc
%  pause(0.1)
% 

end

