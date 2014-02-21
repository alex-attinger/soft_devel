%% reading the files
source_root = 'M:/attialex/seg_data/';


files = dir(source_root,'.mat');

training_data = struct();

for ii = 1:size(files,1)
   fn = files(ii).name;
   load([source_root fn]);
   fieldnames = fieldnames(data);
   for jj = 1:numel(fieldnames)
       tmp = getfield(data,fieldnames(jj));
       training_data=setfield(training_data,{ii},fieldnames(jj),{1},tmp);
   end
   
   
end
%% rearranging
data = struct();


%% saving to file
dest_root = 'M:/attialex/seg_dataTraining/';
dest_name = 'set_1';
save([dest_root dest_name],data);
