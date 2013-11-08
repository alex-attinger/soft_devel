%% preparation
% N=2000;
% smalldata = data{1}(:,:,1:N);
N=500;
smalldata=ffdata;


m = mean(smalldata,3);

smalldata = reshape(smalldata,[400*750 N ]);
smalldata=double(smalldata');
%% skew
S=skewness(smalldata);
SR=reshape(S,400,750);
figure
imagesc(SR)
title('skewness')
%% kurtosis
K=kurtosis(smalldata);
KR=reshape(S,400,750);
figure
imagesc(KR)
title('kurtosis')
%% variance
V=var(smalldata);
VR=reshape(V,400,750);
figure
imagesc(VR)
title('Variance')
%% mean
figure
imagesc(m)
title('mean')