%pim = polartrans(im,256,256,355,170);
dset = 2;
layer =1;
m = false(400,750);
imi = proj_meta(dset).rd(layer).template;
im = mat2gray(im);
f=figure;
a = axes();
h=imagesc([1:750],[1:400],im);
%plot(activity{1,1}')
set(a, 'ButtonDownFcn', @clicker_cell);
set(h,'HitTest','off')