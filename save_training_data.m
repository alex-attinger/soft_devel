%% The Trainingdata
meta_root = 'G:/AData/_metaData/';
meta_sets={'hom_1_meta','LFM_meta','VML_meta','ENU_meta'};
training_data = struct();
test_data = struct();
counter = 1;
test_counter = 1;
for ii = 1:4
    disp(['Loading ',meta_root meta_sets{ii}])
    load([meta_root meta_sets{ii}]);
    seg_root = ['H:/images/seg_',meta_sets{ii}];
    
    files = dir([seg_root,'/*.png']);
    
    nmasks = size(files,1);
    for jj = 1:nmasks
        name = files(jj).name;
        [indx] = strfind(name,'_');
        if numel(indx) == 3 %% a mask image
            animal = str2num(name(indx(1)+1:indx(2)-1));
            layer = str2num(name(indx(2)+1));
            
            training_data(counter).act_map = proj_meta(animal).rd(layer).act_map;
            training_data(counter).template = proj_meta(animal).rd(layer).template;
            training_data(counter).roi = proj_meta(animal).rd(layer).ROIinfo;
            training_data(counter).animalID = proj_meta(animal).animal;
            training_data(counter).animal = animal;
            training_data(counter).siteID = proj_meta(animal).siteID;
            training_data(counter).layer = layer;
            im = imread([seg_root,'/',name]);
            training_data(counter).mask = im(401:end,1:750) == 0;
            figure
            imshow(imoverlay(mat2gray(training_data(counter).template),training_data(counter).mask,[0 1 1]))
            counter = counter+1;
        else
            animal = str2num(name(indx(1)+1:indx(2)-1));
            layer = str2num(name(indx(2)+1));
            
            test_data(test_counter).act_map = proj_meta(animal).rd(layer).act_map;
            test_data(test_counter).template = proj_meta(animal).rd(layer).template;
            test_data(test_counter).roi = proj_meta(animal).rd(layer).ROIinfo;
            test_data(test_counter).animalID = proj_meta(animal).animal;
            test_data(test_counter).animal = animal;
            test_data(test_counter).siteID = proj_meta(animal).siteID;
            test_data(test_counter).layer = layer;
            im = imread([seg_root,'/',name]);
            test_data(test_counter).mask = im(401:end,1:750) == 1;
            
            test_counter = test_counter+1;
        end
    end
end
save(['G:/temp/alex/trainingdata/training_data2'],'training_data')
save('G:/temp/alex/trainingdata/test_data2','test_data')