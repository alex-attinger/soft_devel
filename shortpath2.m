ca
im = im1;
img = mat2gray(im);

f=figure;
a = axes();
h=imagesc(im);

set(a, 'ButtonDownFcn', @clicker_pol_hist);
set(h,'HitTest','off')

%%
imshow(img)
cells = ginput(13);
disp('now select other stuff')

stuff = ginput(13);
%%
size_hist = 40;
p_shape = [40,256];
polar_stack_cell = zeros(p_shape(1),p_shape(2),size(cells,1));
polar_stack_stuff = zeros(p_shape(1),p_shape(2),size(stuff,1));
binstep = 0.01;
x=0:binstep:1;

h_cells = zeros(numel(x),size(cells,1));
h_stuff = zeros(numel(x),size(stuff,1));

for ii = 1:size(cells,1)
    [h,~] = subhisto(img,cells(ii,1),cells(ii,2),size_hist);
    h_cells(:,ii)=h';
    pim=polartrans(im,p_shape(1),p_shape(2),cells(ii,1),cells(ii,2));
    polar_stack_cell(:,:,ii) = pim;
end

for ii = 1:size(stuff,1)
    [h,~] = subhisto(img,stuff(ii,1),stuff(ii,2),size_hist);
    h_stuff(:,ii)=h';
    pim=polartrans(im,p_shape(1),p_shape(2),stuff(ii,1),stuff(ii,2));
    polar_stack_stuff(:,:,ii) = pim;
end
figure;
subplot(221);
plot(h_cells);
hold on;
m_c=mean(h_cells,2);
plot(m_c,'k','LineWidth',2);

subplot(222)
plot(h_stuff);
hold on;
m_s=mean(h_stuff,2);
plot(m_s,'k','LineWidth',2);
subplot(2,2,3:4)
plot(m_s,'r')
hold on
plot(m_c,'g')

figure;
subplot(211)
imagesc(mean(polar_stack_cell,3));
subplot(212)
imagesc(mean(polar_stack_stuff,3));