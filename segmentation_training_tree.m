%% loading a trainign set
source_root = 'M:/attialex/seg_dataTraining/';
source_name = 'set_1';
load([source_root source_name]);

%% list of variables we want to use
varlist = {''};
X=[];
Y=[];

%% training a tree
nTrees= 50;
oobpred = 'on';
oobvarimp = 'on';
minleaf = 1;
b = TreeBagger(nTrees,X,Y,'Method','classification','oobpred',oobpred,'oobvarimp',oobvarimp,'MinLeaf',minleaf);

plot(oobpredict(b));

%% save the tree
target_root = 'M:/attialex/seg_dataTraining/';
target_name = 'tree_1';
save([target_root target_name],b);