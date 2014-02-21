root = 'M:\attialex\images\';

dataset = 'vml\';


D=dir([root dataset 'template*.mat']);

ud_max = struct();
ud_max.vmin = 0.05;
ud_max.vmax = 0.7;
ud_max.vstep = 0.05;
ud_max.amin = 80;
ud_max.amax = 550;

ud_t = struct();
ud_t.vmin = 0.05;
ud_t.vmax = 0.5;
ud_t.vstep = 0.01;
ud_t.amin = 90;
ud_t.amax = 500;

for ii = 1:3
    load([root dataset D(ii).name])
    bw_max = slice_maximum(data.temp_proc,ud_max);
    bw_t = slice_thresh(data.temp_proc,ud_t);
    figure;
    imerode(bw_max,stre
    imshow([bw_max bw_t])
    save([root dataset D(ii).name],'data')
end