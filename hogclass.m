%%
run('C:/vlfeat/vlfeat-0.9.18/toolbox/vl_setup')
%% tp
root_tp = 'M:/attialex/images/tp_cleaned_vml/';
files = dir([root_tp '*.png']);
f1 = imread([root_tp files(1).name]);
hogf = vl_hog(im2single(f1),8);
tp_mat = zeros(length(files),numel(hogf));

for jj=1:length(files)
    im = imread([root_tp files(jj).name]);
    im = im2single(im);
    hogf = vl_hog(im,8);
    tp_mat(jj,:)=hogf(:);
end


%% tn
root_tn = 'M:/attialex/images/tn/';
files = dir([root_tn '*.png']);
f1 = imread([root_tn files(1).name]);
hogf = vl_hog(im2single(f1),8);
tn_mat = zeros(length(files),numel(hogf));

for jj=1:length(files)
    im = imread([root_tn files(jj).name]);
    im = im2single(im);
    hogf = vl_hog(im,8);
    tn_mat(jj,:)=hogf(:);
end
%% collecting
xData = [tp_mat;tn_mat];
Y=[ones(size(tp_mat,1),1);zeros(size(tn_mat,1),1)];
%% tree training
B = TreeBagger(50,xData,Y);

%% test
t = im2single(data.template);
imshow(t);
func1 = @(x) giveOutScore(reshape(vl_hog(x,8),1,[]),B,2);

test_feature=nlfilter(t,[40,40],func1);
%%
test = t(101:200,101:200);
out=zeros(100,100,2);
idx = -19:20;
for ii = 20:80
    for jj = 20:80
        h = vl_hog(test(ii+idx,jj+idx),8);
        h = h(:)';
        [~,score]=B.predict(h);
        out(ii,jj,1)=score(1);
        out(ii,jj,2)=score(2);
    end
end
%%
outt = out(:,:,2);
outt(outt<.7)=0;
regmax = imregionalmax(outt);
figure; imshow(regmax)
figure;
subplot(121)
imagesc(out(:,:,1));
subplot(122)
imagesc(out(:,:,2));

overl = imoverlay(test,regmax,[0 1 0]);
figure;
imshow(overl)

