
a=20; 
im1=mat2gray(proj_meta(2).rd(1).template);
im2=0;

imshow(im1)
cells = ginput;

cell_stack = zeros(2*a+1,2*a+1,size(cells,1));
%%
for ii=1:size(cells,1)
    cell_stack(:,:,ii)=im1(cells(ii,2)-a:cells(ii,2)+a,cells(ii,1)-a:cells(ii,1)+a);
end

mean_cell =mean(cell_stack,3);     
figure;imshow(mean_cell)

%%
d_nut = doughnut(40,10,15);

conv_1 = conv2(im1,mean_cell,'same');
conv_2 = conv2(im1,d_nut,'same');

bw_1 = imregionalmax(conv_1);
bw_2 = imregionalmax(conv_2);

