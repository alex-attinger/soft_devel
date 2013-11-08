%%
%   meta_root = 'G:/AData/_metaData/';
%    files={'HOM_1_meta','LFM_meta','VML_meta'};
%  to_load = 3;
% load([meta_root files{to_load}]);
%  n_sets = size(proj_meta,2);
%  n_sets =6;

 %% CrossCorrelation 
 
Data=struct();
counter = 0;
act_threshold = .2;
n_sets = 3;
window = 40;
counter = 0;
for ii = n_sets
    for layer = 3%1:size(proj_meta(ii).rd,1)
        %counter = counter+1;
        n_cells = size(proj_meta(ii).rd(layer).act,1);
        act = proj_meta(ii).rd(layer).act;
        act = act -1;
        act(act<act_threshold)=0;
        %act(act>= act_threshold)=1;
        
        cells = [ 1:3:n_cells];
        for jj = 1:numel(cells)
            for kk = jj+1:numel(cells)
                cell_1 = cells(jj);
                cell_2 =cells(kk);
                c=xcorr(act(cell_1,:),act(cell_2,:),window,'coeff');
                if max(c)>.2 && sum(act(cell_1,:)) > 0 && sum(act(cell_2,:))>0
                    figure
                    subplot(211)
                    plot(-window:window,c)
                    subplot(212)
                    %plot(proj_meta(ii).rd(layer).act([cell_1 cell_2],:)');
                    plot(act([cell_1, cell_2],:)');
                    legend(num2str(cell_1),num2str(cell_2))
                    title(sprintf('cell %d and %d',cell_1,cell_2))
                    if counter > 20
                        error('too many plots')
                    end
                    counter = counter +1;
                end
            end
        end
    end
end
