%% label matrix and stats

tp=1;

path = '\\argon.fmi.ch\gkeller.mdrive\attialex\images\tp\';
prefix = 'vml';
width = 40;
idx = -(width/2) +1:width/2;
for site = 2:4%size(proj_meta,2)
    for layer = 1:4
        ROIs =proj_meta(site).rd(layer,tp).ROIinfo;

        nROIs = size(ROIs,2);
        L=zeros(400,750);
        for ii = 1:nROIs
           
            L(ROIs(ii).indices)=ii;
        end
        stats = regionprops(L,'centroid');
        %f=figure;
        %imagesc(proj_meta(animal).rd(layer,tp).template);
        t=mat2gray(proj_meta(site).rd(layer,tp).template);
        for ii = 1:nROIs
            cen = round(stats(ii).Centroid);
            try
                pic = t(cen(2)+idx,cen(1)+idx);
                fn =[prefix sprintf('_%d_%d_%d',site,layer,ii) '.png'];
                imwrite(pic,[path fn]);
                
            catch
                s=sprintf('didnt work for %d,%d,',cen(1),cen(2));
                disp(s);
            end
            %rectangle('Position',[cen(1)-width/2,cen(2)-width/2,width,width]);
        end
        %waitfor(f);
    end
end



%% bounding boxes


