displacement = {};

for ii = 1:numel(proj_meta)
    for ll = 1:size(proj_meta(ii).rd,1)
        for tp = 1:size(proj_meta(ii).rd,2)
            d = cat(1,proj_meta(ii).rd(ll,tp).ROIinfo.shift);
            absol = 0;
            for jj = 1:size(d,1)
                absol = absol+ norm(d(jj,:));
            end
            displacement(ii,ll,tp).absolute = absol;
        end
    end
end

%%
l = 1;
m = zeros(size(displacement,3),1);
n_anim = size(displacement,1);
d = zeros(size(displacement,3),n_anim);
figure
hold on
for ii = 1:size(displacement,1)
    temp = cat(1,displacement(ii,l,:).absolute);
    d(1:numel(temp),ii) = temp;
   
end
plot(d)
plot(mean(d),'r','LineWidth',2)