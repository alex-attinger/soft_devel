%%
ca
dset = 1;
layer =2;
cell = 1;


figure
imagesc(template{layer})

coords = round(ginput(2));
rectangle('Position',[coords(1,1),coords(1,2),coords(2,1)-coords(1,1),coords(2,2)-coords(1,2)])

%act_trace = mean(mean(data{layer}(145:178,70:125,:),1),2); %active cell
%act_trace = mean(mean(data{layer}(105:135,70:125,:),1),2); %background
%act_trace = mean(mean(data{layer}(212:230,615:650,:),1),2); %less active cell
act_trace = mean(mean(data{layer}(coords(1,2):coords(2,2),coords(1,1):coords(2,1),:),1),2);
%act_trace = mean(mean(data{layer}(104:132,614:656,:),1),2);
act_trace = squeeze(act_trace)';
background = squeeze(mean(mean(data{layer},1),2))';


% background_median = zeros(1,n_samples);
% for ii = 1:n_samples
%     f=data{layer}(:,:,ii);
%     background_median(ii)=median(f(:));
%     
% end
%     


%% Integrated brightness
%ca
%min factor 1.4
%
[n_rows,n_samples]= size(act_trace);

figure;
plot(act_trace,'r')
hold on
plot(background,'b')

% the reward settings
framerate = 15;
window_f = framerate*30; %reward frequency window in frames

freq_min = 120/(3600*framerate);
freq_max = 400/(3600*framerate);

%trheshold settings6
min_factor = 1.4;
step = .1;
max_factor = 6.1;
factor = 1.8;


% the integrator settings
f_background = .7;
f_alpha = .7;


%init some variables
accu=0;
accu_b = 0;
threshold_save = zeros(1,n_samples);
factor_save = zeros(1,n_samples);

accu_save = zeros(1,n_samples);

active =false(1,n_samples);


for ii = 1:n_samples
    accu = f_alpha * accu + act_trace(ii);
    accu_save(ii) = accu;
    accu_b = f_background * accu_b + background(ii);
    %above threshold?
    thresh = factor*accu_b;
    if accu>=thresh
        active(ii)=true;
    end
    if ii > window_f
        freq = mean(active(ii-window_f:ii));
        if freq<freq_min && factor > min_factor
            factor = factor-step;
        elseif freq>freq_max && factor < max_factor
            factor = factor+step;
        end
    end
    
    factor_save(ii)=factor;
    threshold_save(ii) = thresh;
 
end
figure;
%subplot(211);
hold on
plot(accu_save,'b');
plot(threshold_save,'k');
plot(100*active,'m','LineWidth',.5)

figure
plot(factor_save)



%% Integrated Brightness + reset and refractory period

[n_rows,n_samples]= size(act_trace);

figure;
plot(act_trace,'r')
hold on
plot(background,'b')

% the reward settings
framerate = 15;
window_f = framerate*30; %reward frequency window in frames

freq_min = 120/(3600*framerate);
freq_max = 400/(3600*framerate);

%trheshold settings6
min_factor = 1.8;
step = .01;
max_factor = 6.1;
factor = 1.8;


% the integrator settings
f_background = .5;
f_alpha = .5;


%init some variables
accu=0;
accu_b = 0;
threshold_save = zeros(1,n_samples);
factor_save = zeros(1,n_samples);

accu_save = zeros(1,n_samples);
accu_b_save = zeros(1,n_samples);

active =false(1,n_samples);


for ii = 1:n_samples
    accu = f_alpha * accu + act_trace(ii);
    
    accu_b = f_background * accu_b + background(ii);
   
    %above threshold?
    thresh = factor*accu_b;
    if accu>=thresh
        active(ii)=true;
        accu = accu_b;
    end
    accu_save(ii) = accu;
    accu_b_save(ii)= accu_b;
    if ii > window_f
        freq = mean(active(ii-window_f:ii));
        if freq<freq_min && factor > min_factor
            factor = factor-step;
        elseif freq>freq_max && factor < max_factor
            factor = factor+step;
        end
    end
    
    factor_save(ii)=factor;
    threshold_save(ii) = thresh;
 
end
figure;
%subplot(211);
hold on
plot(accu_save,'b');
plot(threshold_save,'k');
plot(accu_b_save,'y')
plot(100*active,'m','LineWidth',.5)

legend('I B C','Threshold','I B image','Active')

figure
plot(factor_save)



%% running median

window_length = 5;


%% running stats median+n*sigma
figure
window_length = 400;
factor = 2;
window = nan(n_rows,window_length);
threshold = zeros(1,n_samples);
threshold_curr = inf;
med = zeros(size(threshold_curr));
sig = zeros(size(threshold));

window_idx = 0;

above_t = false(1,n_samples);

active = false(1,n_samples);
n_active = 20;

min_factor= 1.2;
step = 0.05;
max_factor = 3;
median_save = zeros(1,n_samples);
mean_save = zeros(1,n_samples);
for ii = 1:n_samples
        %the background median window
        if act_trace(ii)<threshold_curr
            %put value in window
            window(window_idx+1)=act_trace(ii);
            %update index
            window_idx=mod(window_idx+1,window_length);
            med = nanmedian(window,2);
            sig = nanstd(window,[],2);
            %threshold_curr = med+factor*sig;
            threshold_curr = 1.2*med;
            m = nanmean(window);
        else
            above_t(ii) = true;
            if ii >n_active
                active(ii) = sum(above_t(ii-n_active:ii))>=n_active;
                %reset
                if active(ii)
                    above_t(ii-n_active:ii) = false;
                end
            end
        end
        
        median_save(ii)=med;
        mean_save(ii)=m;
        threshold(ii)=threshold_curr;
    
end
%subplot(212);
figure
plot(act_trace,'r')
hold on
plot(threshold,'b');
plot(above_t,'y-')
plot(100*active,'m','LineWidth',.5)
figure;
plot(median_save,'r');
hold on
plot(mean_save,'b');

