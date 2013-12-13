%% selection and preparation
ca
layer = 2
figure
imagesc(template{layer})

coords = round(ginput(2));
rectangle('Position',[coords(1,1),coords(1,2),coords(2,1)-coords(1,1),coords(2,2)-coords(1,2)])



av_raw = zeros(1,size(data{layer},3));
dff = zeros(size(av_raw));


act_trace = squeeze(mean(mean(data{layer}(coords(1,2):coords(2,2),coords(1,1):coords(2,1),:),1),2));

dff = psmooth(act_trace);

av_med = median(dff);
a = repmat(av_med,size(data{layer},3),1);
dff = dff./a;



%% activity triggered mean and std

thresh =2.0;
ind = find(dff>thresh);
figure
plot(dff);
ylabel('df/f');
hold on
plot([1, size(dff,1)],[thresh, thresh],'r','LineWidth',.5)
from_to=0;
mov = {};
counter = 1;
for ii = 1:numel(ind)
    curr_ind = ind(ii);
    for jj = curr_ind-from_to:curr_ind+from_to
        for ll = 1:4
        if jj > 0 && jj<size(data{layer},3)
            mov(ll,counter).data = data{ll}(:,:,jj);
            counter = counter +1;
        end
        end
    end
end
for ll = 1:4
    all_frames = cat(3,mov(ll,:).data);
    m_frame = mean(all_frames,3);
    sig = single(all_frames);
    sig = reshape(sig,[],size(all_frames,3));
    stdsig = std(sig');
    stdframe = reshape(stdsig,400,750);
    
    m_frame = m_frame-template{ll};
    figure;
    subplot(221)
    imagesc(m_frame);
    subplot(222)
    imagesc(stdframe);
    subplot(2,2,3:4)
    plot(dff);
    ylabel('df/f');
    hold on
    plot([1, size(dff,1)],[thresh, thresh],'r','LineWidth',.5)
end
%% enlarging ROIs by correlating neighbouring pixels
act_trace = squeeze(mean(mean(data{layer}(coords(1,2):coords(2,2),coords(1,1):coords(2,1),:),1),2));

mask = false(400,750);
mask(coords(1,2):coords(2,2),coords(1,1):coords(2,1))=true;
se1 = strel('diamond',1);
mean_signal = mean(data{layer},1);
mean_signal = squeeze(mean(mean_signal,2));
back_corr = corr(act_trace,mean_signal);
figure(12)
changed =1;
im = mat2gray(template{layer});
movie = {};
counter = 1;
while changed
    changed = 0;
    m_open = imdilate(mask,se1);
    neighbours = m_open & ~mask;
    [x,y]=find(neighbours);
    sig_corr = zeros(1,numel(x));
    for ii=1:numel(x)
         sig_corr(ii) = corr(act_trace,squeeze(single(data{layer}(x(ii),y(ii),:))));
         if sig_corr(ii)>back_corr*.2
             numberpix = nnz(mask);
             mask(x(ii),y(ii))=1;
             changed = 1;
             n_p = squeeze(single(data{layer}(x(ii),y(ii),:)));
             act_trace = (numberpix*act_trace+n_p)/(numberpix+1);
         end
    end
%     for ii = 1:size(data{layer},3)
%         f_i = data{layer}(:,:,ii);
%         av_raw(seg,ii) = mean(mean(f_i(mask)));
%     end
    figure(12); 
    %overl = imoverlay(im,bwperim(mask),[0 1 0]);
    overl = im;
    overl(bwperim(mask))=1;
    movie(counter).data = overl;
    counter = counter + 1;
    imshow(overl);
    pause(0.01)
    if counter > 200
        changed = 0;
    end
end