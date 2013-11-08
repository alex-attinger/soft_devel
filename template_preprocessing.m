function im = template_preprocessing(im)
%%%
% do the preprocessing for the template image. this is to reduce the uneven
% light
%
%%%
  imf=imfilter(im,fspecial('average',[70 70]),'replicate');
    
  d=im-imf;
    df = imfilter(d,fspecial('average',[15 15]));
    mi = min(df(:));
    ma = max(df(:));
    im=mat2gray(im-imf,[mi ma]);
