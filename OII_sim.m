
t=0:0.1:(200-0.1);
nsamples = length(t);
mov = zeros(100,100,nsamples);
amp = .005;
f =.1;
sig = amp*cos(f*2*pi*t);

s = reshape(sig,[1,1,nsamples]);
SIG = repmat(s,[10,10,1]);
mov(51:60,51:60,:)=SIG;

sig2 = amp*cos(f*2*pi*t+.2*pi);
SIG2=reshape(sig2,[1,1,nsamples]);
SIG2=repmat(SIG2,[5,5,1]);

sig3 = amp*cos(f*2*pi*t-.2*pi);
SIG3= reshape(sig3,[1,1,nsamples]);
SIG3 = repmat(SIG3,[5,5,1]);
mov(51:55,61:65,:)=SIG2;
mov(48:52,48:52,:)=SIG3;



mo2=mov+.1*randn(100,100,nsamples);

view_tiff_stack(mo2)
s = mean(mean(mo2(51:55,61:65,:),2),1);
figure
pwelch(s)
oii_eval2(mo2)