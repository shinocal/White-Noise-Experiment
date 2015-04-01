function [s_avg,t,f,sub_mat] = spectrogram_norm(aligned,t_before,Fs)

movingwin = [0.5 0.05]; 
params.tapers = [2 3];   
params.pad = -1;
params.Fs = Fs;

[m,~]=size(aligned);
for n =1:m
[S(:,:,n),t,f]=mtspecgramc(detrend(aligned(n,:)),movingwin,params);
end

s_avg=mean(abs(S),3);
avrg=mean(s_avg((t-t_before)<0,:));
[a,~]=size(s_avg);

for p=1:a
sub_mat(p,:)=(s_avg(p,:))./avrg;
end


end

