%%
path = '\\argon.fmi.ch\gkeller.mdrive\attialex\images\lfm\template_'

for ii = 1:length(proj_meta)
    for ll = 1:4
        try
            template = proj_meta(ii).rd(ll,1).template;
            template = mat2gray(template);
            temp_proc = template_preprocessing(template);
            data = struct();
            data.template = template;
            data.temp_proc = temp_proc;
            save([path num2str(ii) '_' num2str(ll)],'data')
            [~,rois] = plot_im_rois(template,proj_meta(ii).rd(ll,1).ROIinfo);
            imwrite(uint16(template*2^16),[path num2str(ii) '_' num2str(ll) '.png'])
            imwrite(rois,[path '_mask_' num2str(ii) '_' num2str(ll) '.png'])
        catch
            'err'
        end
    end
end

% for ii = 1:length(proj_meta)
%     for ll = 1:4
%         try
%             template = proj_meta(ii).rd(ll,1).template;
%             template = mat2gray(template);
%             imwrite(template,[path num2str(ii) '_' num2str(ll) '.png'])
%         catch
%             'err'
%         end
%     end
% end