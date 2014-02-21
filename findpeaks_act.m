%% preprocessing
% dat=(prev_adata.ROIs{3}(1).activity);
% dff = psmooth(dat);
% dff = dff/median(dat);
% 
% 
layer = 1;
dpoint = 1;
animal = 4
dff = proj_meta(animal).rd(layer,dpoint).act(6,:);
aux_data = [proj_meta(animal).rd(layer,dpoint).vis_speed;proj_meta(animal).rd(layer,dpoint).velM_smoothed;proj_meta(animal).rd(layer,dpoint).velP_smoothed];

%% peak detection
idx = find_rising_act(dff,1.15,0.05);

figure;
subplot(211)
%plot(dat); hold on;
plot(idx,500*ones(size(idx)),'ro')
subplot(212)
plot(dff)
hold on
plot(idx,2*ones(size(idx)),'ro')

%%
channels_ana=true(10,1);
channels_ana(1:3)=false;
%[out,a] = analyzeAUX(frame_times(idx),aux_data,[-15,15],channels_ana);
w =[-15,15];
[out,a] = analyzeAUX(idx,aux_data,w);


figure;
plot(w(1):w(2),a')

figure;
plot(proj_meta(animal).rd(layer,dpoint).vis_speed);
hold on
plot(idx,ones(1,length(idx)),'ro')

% fn = fieldnames(ach.auxrec);
% leg ={};
% counter = 1;
% for ii = 1:10
%     if channels_ana(ii)
%         leg{counter}=getfield(ach.auxrec,fn{ii});
%         counter = counter +1;
%     end
% end
% 
% legend(leg)