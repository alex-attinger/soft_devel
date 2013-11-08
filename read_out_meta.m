%%
%  meta_root = 'G:/AData/_metaData/';
%  files={'HOM_1_meta','LFM_1_meta','VML_meta'};
%  to_load = 2;
% load([meta_root files{to_load}]);
%  n_sets = size(proj_meta,2);
%  n_sets =6;

 %% Correlation by distance
Data=struct();
counter = 0;
n_frames_running = 1;
n_frames_active = 5;
for ii = 1:6
    for layer = 1:4%layer =1:size(proj_meta(ii).rd,1)
        counter = counter+1;
        man_segs = false(400,750);
        ROIs=proj_meta(ii).rd(layer).ROIinfo;
        centroids = zeros(2,numel(ROIs));
        for i_roi = 1:numel(ROIs)
            [x,y]=ind2sub([400,750],ROIs(i_roi).indices);
            centroids(1,i_roi)=mean(x);
            centroids(2,i_roi)=mean(y);
        end
       
        distances = zeros(numel(ROIs));
        for i_roi = 1:numel(ROIs)
           d=centroids-repmat(centroids(:,i_roi),1,numel(ROIs));
           d = d.^2;
           distances(i_roi,:)=sqrt(sum(d,1));
        end
        correlations = zeros(size(distances))*-inf;
        correlations_fb = zeros(size(distances))*-inf;
        correlations_pb = zeros(size(distances))*-inf;
        correlations_running = zeros(size(distances))*-inf;
        correlations_running_fb = zeros(size(distances))*-inf;
        correlations_running_pb = zeros(size(distances))*-inf;
        correlations_non_running = zeros(size(distances))*-inf;
        correlations_non_running_fb = zeros(size(distances))*-inf;
        correlations_non_running_pb = zeros(size(distances))*-inf;
        dist_sorted = zeros(size(distances));
        indices = zeros(size(distances));
        thresholds = det_thresh_for_peak_resp(proj_meta(ii).rd(layer,1).act);
        for jj = 1:numel(ROIs)
            
%             [y,ind] = sort(distances(jj,:));
%             dist_sorted(jj,:)=y;
%             indices(jj,:)=ind;
            sig_1 = proj_meta(ii).rd(layer,1).act(jj,:)'-1;
            active_1 = sig_1<thresholds(jj);
            active_1 = filter(1/n_frames_active*ones(1,n_frames_active),1,active_1);
            not_active_1 = active_1< 1;
            sig_1(not_active_1) = 0;
            for i_roi = jj+1:numel(ROIs)
                
                sig_2= proj_meta(ii).rd(layer,1).act(i_roi,:)'-1;
                active_2 = sig_2<thresholds(i_roi);
                active_2 = filter(1/n_frames_active*ones(1,n_frames_active),1,active_2);
                not_active_2 = active_2< 1;
                sig_2(not_active_2) = 0;
                running = proj_meta(ii).rd(layer,1).velM_smoothed > 0.001;
                if n_frames_running > 1
                    running = filter(1/n_frames_running*ones(1,n_frames_running),1,running);
                    running = running > 1-1/n_frames_runing;
                end
                correlations(jj,i_roi)=corr(sig_1,sig_2);
                correlations(i_roi,jj)=correlations(jj,i_roi);
                
                correlations_fb(jj,i_roi) = corr(sig_1(1:proj_meta(ii).rd(layer,1).nbr_frames(1)),sig_2(1:proj_meta(ii).rd(layer,1).nbr_frames(1)));
                correlations_pb(jj,i_roi) = corr(sig_1(proj_meta(ii).rd(layer,1).nbr_frames(1):end),sig_2(proj_meta(ii).rd(layer,1).nbr_frames(1):end));
                
                correlations_running(jj,i_roi) = corr(sig_1(running),sig_2(running));
                correlations_running(i_roi,jj) = correlations_running(jj,i_roi);
                
                correlations_running_fb(jj,i_roi) = corr(sig_1(running(1:proj_meta(ii).rd(layer,1).nbr_frames(1))),sig_2(running(1:proj_meta(ii).rd(layer,1).nbr_frames(1))));
                correlations_running_pb(jj,i_roi) = corr(sig_1(running(proj_meta(ii).rd(layer,1).nbr_frames(1):end)),sig_2(running(proj_meta(ii).rd(layer,1).nbr_frames(1):end)));
                
                correlations_non_running(jj,i_roi) = corr(sig_1(~running),sig_2(~running));
                correlations_non_running(i_roi,jj) =correlations_non_running(jj,i_roi);
                
                correlations_non_running_fb(jj,i_roi) = corr(sig_1(~running(1:proj_meta(ii).rd(layer,1).nbr_frames(1))),sig_2(~running(1:proj_meta(ii).rd(layer,1).nbr_frames(1))));
                correlations_non_running_pb(jj,i_roi) = corr(sig_1(~running(proj_meta(ii).rd(layer,1).nbr_frames(1):end)),sig_2(~running(proj_meta(ii).rd(layer,1).nbr_frames(1):end)));
                
                
            end
        end
%             Data(counter).dist_sorted=dist_sorted;
            Data(counter).distances = distances;
            Data(counter).correlations = correlations;
            Data(counter).correlations_fb = correlations_fb;
            Data(counter).correlations_pb = correlations_pb;
            
            Data(counter).correlations_non_running = correlations_non_running;
            Data(counter).correlations_non_running_fb = correlations_non_running_fb;
            Data(counter).correlations_non_running_pb = correlations_non_running_pb;
            Data(counter).correlations_running = correlations_running;
            Data(counter).correlations_running_fb = correlations_running_fb;
            Data(counter).correlations_running_pb = correlations_running_pb;
            
            Data(counter).set = ii;
            Data(counter).layer = layer;
            [~, ind] = sort(distances,2);
            Data(counter).ind = ind;
            debug = 0
            if debug
                figure;
                subplot(431)
                
                hold on
                for kk = 1:size(distances,1)
                    plot(distances(kk,ind(:,kk)),correlations(kk,ind(:,kk))','.')
                end
                s = sprintf('dset: %d, Layer %d',ii,layer);
                title(s);
                hold off
                
                subplot(432)
                hold on
                for kk = 1:size(distances,1)
                    plot(distances(kk,ind(:,kk)),correlations_running(kk,ind(:,kk))','.')
                end
                title('running')
                hold off
                subplot(433)
                hold on
                for kk = 1:size(distances,1)
                    plot(distances(kk,ind(:,kk)),correlations_non_running(kk,ind(:,kk))','.')
                end
                hold off
                subplot(434)
                plot(proj_meta(ii).rd(layer).act')
                subplot(437)
                corr_copy = correlations;
                corr_copy(correlations>.99)=0;
                [vals, ind] = max(corr_copy);
                [vals2, maxcol] = max(vals);
                maxrow =ind(maxcol);
                hold on
                plot(proj_meta(ii).rd(layer).act(maxrow,:),'g')
                plot(proj_meta(ii).rd(layer).act(maxcol,:),'r')
                s = sprintf('max corr: %d, rois %d and %d',vals2,maxrow,maxcol);
                title(s)
                hold off
                handle=subplot(4,3,10:12);
                plot_im_rois(proj_meta(ii).rd(layer).template,proj_meta(ii).rd(layer).ROIinfo([maxrow maxcol]),handle)
            end
    end
end
figure('Name','All'); hold on
subplot(311)
hold on
for ii = 1:numel(Data)
    for kk = 1:size(Data(ii).distances,1)
        plot(Data(ii).distances(kk,Data(ii).ind(:,kk)),Data(ii).correlations(kk,Data(ii).ind(:,kk))','.')
    end
end
subplot(312)
hold on
for ii = 1:numel(Data)
    for kk = 1:size(Data(ii).distances,1)
        plot(Data(ii).distances(kk,Data(ii).ind(:,kk)),Data(ii).correlations_fb(kk,Data(ii).ind(:,kk))','.')
    end
end

subplot(313)
hold on
for ii = 1:numel(Data)
    for kk = 1:size(Data(ii).distances,1)
        plot(Data(ii).distances(kk,Data(ii).ind(:,kk)),Data(ii).correlations_pb(kk,Data(ii).ind(:,kk))','.')
    end
end

figure('Name','running'); 
subplot(311);hold on
for ii = 1:numel(Data)
    for kk = 1:size(Data(ii).distances,1)
        plot(Data(ii).distances(kk,Data(ii).ind(:,kk)),Data(ii).correlations_running(kk,Data(ii).ind(:,kk))','.')
    end
end
subplot(312);hold on
for ii = 1:numel(Data)
    for kk = 1:size(Data(ii).distances,1)
        plot(Data(ii).distances(kk,Data(ii).ind(:,kk)),Data(ii).correlations_running_fb(kk,Data(ii).ind(:,kk))','.')
    end
end

subplot(313);hold on
for ii = 1:numel(Data)
    for kk = 1:size(Data(ii).distances,1)
        plot(Data(ii).distances(kk,Data(ii).ind(:,kk)),Data(ii).correlations_running_pb(kk,Data(ii).ind(:,kk))','.')
    end
end

figure('Name','non running'); 
subplot(311);hold on
for ii = 1:numel(Data)
    for kk = 1:size(Data(ii).distances,1)
                plot(Data(ii).distances(kk,Data(ii).ind(:,kk)),Data(ii).correlations_non_running(kk,Data(ii).ind(:,kk))','.')
            end
end 

subplot(312);hold on
for ii = 1:numel(Data)
    for kk = 1:size(Data(ii).distances,1)
                plot(Data(ii).distances(kk,Data(ii).ind(:,kk)),Data(ii).correlations_non_running_fb(kk,Data(ii).ind(:,kk))','.')
            end
end
subplot(313);hold on
for ii = 1:numel(Data)
    for kk = 1:size(Data(ii).distances,1)
                plot(Data(ii).distances(kk,Data(ii).ind(:,kk)),Data(ii).correlations_non_running_pb(kk,Data(ii).ind(:,kk))','.')
            end
end

%%
for ii = 1:numel(Data)
    
    n_rois = size(Data(ii).distances,1);
    X=zeros(n_rois-1*(n_rois)/2,1);
    Y=zeros(n_rois-1*(n_rois)/2,1);
    counter = 1;
    for rr = 1:n_rois
        for cc=rr+1:n_rois
            if ~isnan(Data(ii).correlations(rr,cc))
                X(counter)=Data(ii).distances(rr,cc);
                Y(counter)=Data(ii).correlations(rr,cc);
                counter = counter +1;
            end
        end
    end
    
end
