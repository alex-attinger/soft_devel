% im = im1;
% act_map = im2;
dataset ='vml';
dset = 4;
layer =2;
im = proj_meta(dset).rd(layer).template;
im = mat2gray(im);
act_map = proj_meta(1).rd(1).act_map;
step_mean = 1/10;
V_mean=[.1:step_mean:1];
V_act = [.1:1/10:1];
h = fspecial('gaussian',3,1);

% im=imfilter(im,h);
% 
im = template_preprocessing(im);

act_map=imfilter(act_map,h);



act_map = mat2gray(act_map);

X1=slice_thresholding(im,V_mean,2);
X2=slice_thresholding(act_map,V_act,1);

i1=imoverlay(im,bwperim(sum(X1,3)),[0 1 0]);
        i2=imoverlay(act_map,bwperim(sum(X2,3)),[0 1 0]);
        %i1=imoverlay(i1,man_segs,[.5 0 0]);
        %i2=imoverlay(i2,man_segs,[.5 0 0]);
        allRois = cat(3,X1,X2);
%%
[bm, ~]=merging_overlap(size(allRois,3),allRois,.5);
i3 = imoverlay(im,bwperim(sum(bm,3)),[1 1 0]);



%% doughnut filtering
%f_d =doughnut(31,7,14);
% a thin ring seems to work better:
f_d = doughnut(41,8,10);
response_d = filter2(f_d,im,'same');
i4 = imoverlay(mat2gray(mat2gray(response_d)-im),bwperim(sum(bm,3)),[1 1 0]);

figure; imshow([i3; i4])
figure; imshow(i2)
%%
n_rois = size(bm,3);
score_max = zeros(n_rois,1);

score_avg = zeros(n_rois,1);

for ii = 1:n_rois
    pi_index = find(bm(:,:,ii));
    pi = response_d(pi_index);
    score_max(ii)=max(pi);
    score_avg(ii)=mean(pi);
end
%%
outer_se = strel('diamond',2);
inner_se = strel('diamond',1);
score_ratio = zeros(1,n_rois);

for ii  = 1:n_rois
    pi_inner = find(imerode(bm(:,:,ii),inner_se));
    pi_outer = find(imdilate(bm(:,:,ii),outer_se));
    score_ratio(ii) = mean(im(pi_outer))/(mean(im(pi_inner))+eps);
end

%% select which ones are rois
bm_old = bm;
cell_rois = true(1,n_rois);
deletedList =[];
fig = figure('name','Cell Selection');

a = axes();

h=imagesc([1:750],[1:400],i3);
colormap gray
%plot(activity{1,1}')
set(a, 'ButtonDownFcn', @clicker_roi);
set(fig,'KeyPressFcn',@redraw_roi);
set(h,'HitTest','off')
waitfor(a)
figure;
% hold on;
% plot3(score_max(cell_rois),score_avg(cell_rois),score_ratio(cell_rois),'g.')
% 
% plot3(score_max(~cell_rois),score_avg(~cell_rois),score_ratio(~cell_rois),'r.')
% xlabel('max')
% ylabel('avg')
% zlabel('ratio')
% 
% hold off
%%
root = 'M:/attialex/seg_data/';
fn = [dataset '_' num2str(dset) '_' num2str(layer)];
data = struct();
data.template = im;
data.filt_response = response_d;
data.filt_diff = mat2gray(response_d)-im;
data.amap = act_map;
data.rois = bm_old;
data.cellList = cell_rois;
data.deletedList = deletedList;
data.score_max = score_max;
data.score_ratio = score_ratio;
data.score_avg = score_avg;
save([root fn],'data');

%%
% i5 = im;
% t = median(score_max);
% for ii = 1:n_rois
%     if score_max(ii)>t
%         i5 = imoverlay(i5,bwperim(bm(:,:,ii)),[1 1 0]);
%     end
% end
% figure; imshow(i5)