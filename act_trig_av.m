%%
ca;
framerate = 15;
n_frames = 7;

range = [-10 40];
dset = 4;
layer = 2;
tresh = det_thresh_for_peak_resp(proj_meta(dset).rd(layer).act);
for i_cell = 1:size(proj_meta(dset).rd(layer).act,1)
    active = proj_meta(dset).rd(layer).act(i_cell,:)-1>tresh(i_cell);
    active = filter(ones(1,n_frames),n_frames,active);
    active = active>1-1/n_frames;
    if sum(active)>0
        figure;
        subplot(311)
        plot(proj_meta(dset).rd(layer).act(i_cell,:))
        t_points = find(diff(active)>0);
        t_points = t_points +1;
        hold on
        
        plot(t_points,ones(1,numel(t_points)),'ro')
        dat = zeros(numel(t_points),range(2)-range(1)+1);
        pop_dat=struct();
        
        if t_points(1)<=abs(range(1))
            t_points = t_points(2:end);
        end
        if t_points(end)> size(proj_meta(dset).rd(layer).act(i_cell,:),2) - range(2)
            t_points=t_points(1:end-1);
        end
        for i_point = 1:numel(t_points)
            
            dat(i_point,:)=proj_meta(dset).rd(layer).act(i_cell,t_points(i_point)+range(1):t_points(i_point)+range(2));
            pop_dat(i_point).data = proj_meta(dset).rd(layer).act(:,t_points(i_point)+range(1):t_points(i_point)+range(2));
        end
        subplot(312)
        plot(range(1):range(2),dat');
        if size(dat,1)>1
        hold on
        plot(range(1):range(2),mean(dat,1),'k','LineWidth',2);
        end

        
    end
    
end
%%
range = [-10 40];
act_average = zeros(size(proj_meta(dset).rd(layer).act,1));
act_difference = zeros(size(act_average));
pre = [-8:-3];
post = [1:6];
activity = cell(12,12);
n_samples = size(proj_meta(dset).rd(layer).act,2);
n_cells = size(proj_meta(dset).rd(layer).act,1);
for r_cell = 1:n_cells
    active = proj_meta(dset).rd(layer).act(r_cell,:)-1>tresh(r_cell);
    active = filter(ones(1,n_frames),n_frames,active);
    active = active>1-1/n_frames;
    t_points = [];
    if sum(active)>0
        t_points = find(diff(active)>0);
        t_points = t_points +1;
        if t_points(1)<=abs(range(1))
            t_points = t_points(2:end);
        end
        if t_points(end)> n_samples - range(2)
            t_points=t_points(1:end-1);
        end
    end
        for c_cell = 1:n_cells
            counter =1;
            tmp = struct();
            for i_point = 1:numel(t_points)            
                act_average(r_cell,c_cell) = act_average(r_cell,c_cell)+mean(proj_meta(dset).rd(layer).act(c_cell,t_points(i_point)+range(1):t_points(i_point)+range(2)));
                presig = mean(proj_meta(dset).rd(layer).act(c_cell,t_points(i_point)+pre));
                postsig = mean(proj_meta(dset).rd(layer).act(c_cell,t_points(i_point)+post));
                act_difference(r_cell,c_cell) = act_difference(r_cell,c_cell)+1/numel(t_points)*(postsig-presig);
                tmp(counter).data = proj_meta(dset).rd(layer).act(c_cell,t_points(i_point)+range(1):t_points(i_point)+range(2));
                counter = counter +1;
            end
            if numel(t_points)<2
                act_average(r_cell,c_cell)=0;
            end
            if numel(t_points)>0
                act_average(r_cell,c_cell)=act_average(r_cell,c_cell)/numel(t_points);
            end
            activity{r_cell,c_cell} = cat(1,tmp.data);
        end
    
end
%%
f1=figure; 
b =axes();
h2=imagesc(act_difference);
set(b,'ButtonDownFcn',@clicker_activity);
set(h2,'HitTest','off');
set(f1,'Pointer','fullcross');

f=figure;
a = axes();
h=imagesc(act_average);
%plot(activity{1,1}')
set(a, 'ButtonDownFcn', @clicker_activity);
set(h,'HitTest','off')
set(f,'Pointer','fullcross');
% subplot = @(m,n,p) subtightplot (m, n, p, [0.00 0.00], [0.0 0.00], [0.0 0.0]);
% counter=1;
%figure;
% for ii = 1:4
%     for jj = 1:4
%         subplot(n_cells,n_cells,counter)
%         
%         plot(activity{ii,jj}');
%         m = mean(activity{ii,jj},1);
%         hold on
%         plot(m,'k','LineWidth',2)
%         counter = counter + 1;
%         set(gca,'XTick',[],'YTick',[],'YTickLabel',[],'XTickLabel',[])
%     end
% end
% clear subplot;
%%