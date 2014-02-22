t=0:0.1:(50-0.1);
size(t)
min(mov(:));
min(mov(:))
sig = 5*cos(2*pi*t);
SIG = repmat(sig,[10,10,1]);
s = reshape(sig,[1,1,500]);
SIG = repmat(s,[10,10,1]);
mov(51:60,51:60)=SIG;
mov(51:60,51:60,:)=SIG;
view_tiff_stack(mov)
mo2=mov+rand(100,100,500);
view_tiff_stack(mo29
view_tiff_stack(mo2)
mo2=mov+4*(rand(100,100,500)-1);
view_tiff_stack(mo2)