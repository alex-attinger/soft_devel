%%
%  meta_root = 'G:/AData/_metaData/';
  files={'HOM_1_meta','LFM_meta','VML_meta','ENU_meta'};
  to_load = 2;
% load([meta_root files{to_load}]);
 n_sets = size(proj_meta,2)-1;
 root=['G:/temp/alex/images/seg_' ,files{to_load}, '/'];
%%

step_mean = 1/10;
V_mean=[.1:step_mean:1];
V_act = [.1:1/10:1];

h = fspecial('gaussian',3,1);
stats = zeros(6,4*n_sets);
counter = 0;
for ii = 1:n_sets
    for l=1:4
        counter = counter +1;
        im = mat2gray(proj_meta(ii).rd(l).template);
        im=imfilter(im,h);
        
        im = template_preprocessing(im);
        
        act_map=imfilter(proj_meta(ii).rd(l).act_map,h);
        %im=adapthisteq(im,'NumTiles',[4,8]);
        
        act_map = mat2gray(act_map);
        n_im=sprintf('im_%d_%d.png',ii,l);
        n_act=sprintf('act_%d_%d.png',ii,l);
%         X1=grayslice(im,10);
%         X2=grayslice(act_map,10);
        X1=slice_thresholding(im,V_mean,2);
        X2=slice_thresholding(act_map,V_act,1);
        
  
        %imwrite(im,[root, n_im],'png');
        %imwrite(act_map,[root, n_act],'png');
        man_segs = false(400,750);
        ROIs=proj_meta(ii).rd(l).ROIinfo;
        for i_roi = 1:numel(ROIs)
            man_segs(ROIs(i_roi).indices)=1;
        end
        man_segs_all = man_segs;
        man_segs =bwperim(man_segs);
%         figure; 
        i1=imoverlay(im,bwperim(sum(X1,3)),[0 1 0]);
        i2=imoverlay(act_map,bwperim(sum(X2,3)),[0 1 0]);
        %i1=imoverlay(i1,man_segs,[.5 0 0]);
        %i2=imoverlay(i2,man_segs,[.5 0 0]);
        allRois = cat(3,X1,X2);
        [bm, ~]=merging_overlap(size(allRois,3),allRois,.5);
        bm_collapsed = sum(bm,3);
        total_aut = nnz(bm_collapsed);
        stats(1,counter)=total_aut;
        
        total_man = nnz(man_segs_all);
        stats(2,counter)=total_man;
        total_overlap = nnz(man_segs_all & bm_collapsed);
        stats(3,counter)=total_overlap;
        n_rois_aut = size(bm,3);
        n_rois_man = numel(ROIs);
        stats(4,counter)=n_rois_aut;
        stats(5,counter)=n_rois_man;
        
        combined = man_segs_all & bm_collapsed;
        CC = bwconncomp(combined);
        n_rois_both = CC.NumObjects;
        stats(6,counter)=n_rois_both;
        
        i3 = imoverlay(im,bwperim(sum(bm,3)),[0 1 0]);
        i3 = imoverlay(i3,man_segs,[.5 0 0]);
        figure
        imshow([i1 i2; i3 zeros(size(i3)) ])
        n_over = sprintf('act_%d_%d',ii,l);
        %imwrite([i1 i2; i3 zeros(size(i3))],[root, n_over,'.png'],'png')
        
        
    end
end
%save([root,'stats'],'stats');

