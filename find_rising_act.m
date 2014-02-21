function [ idx ] = find_rising_act( dff,ampT,slopeT,diff_smooth )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
if size(dff,1)==1
    dff = dff';
end
if nargin <2
    ampT=.9;
end
if nargin <3
    slopeT = .04;
end
if nargin <4
    diff_smooth = 5;
end

%dff_f=smooth(dff,5); %moving average
dff_f = filtfilt(1/3*ones(1,3),1,dff);
dff_diff = diff(dff_f);

%dff_filt = smooth(dff_diff,diff_smooth);
dff_filt = filtfilt(1/3*ones(1,3),1,dff_diff);

dff_t = dff_filt;
dff_t(dff_t<slopeT) = 0;
dff_t(dff_t>slopeT) = 1;
dff_thr = dff_f>ampT;
idx = find([dff_t;0]& ~[0;dff_t]);
idx = idx(idx>10 & idx < length(dff)-10);

for ii = 1:length(idx)
    idx_new = idx(ii);
    for jj = 1:5
        if dff_filt(idx(ii)+jj)>=dff_filt(idx(ii))
            idx_new = idx(ii)+jj;
        else
            break
        end
    end
    idx(ii)=idx_new;
end
idx_tmp = find(dff_thr(idx));
idx = idx(idx_tmp);

end

