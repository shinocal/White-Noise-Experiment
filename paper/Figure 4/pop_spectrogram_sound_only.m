function [s_avg,sub_mat,t,f] = pop_spectrogram_laser_only()

list=file_list();

for i=1:length(list)
   rem_chans{i}=[]; 
end

trial_index=1;
for list_index=1:length(list) 
clearvars -except list list_index trial_index rem_chans pop s_avg sub_mat t f

t_before=2;
t_after=7;

chan_order=[9 8 10 7 13 4 12 5 15 2 16 1 14 3 11 6];  

file=list{list_index};
 for q=length(list{list_index}):-1:1
    if double(file(q))==double('\')
        slash=q; %#ok<NASGU>
        break
    end
 end

FILENAME=file(q+1:length(file));
PATHNAME=file(1:q);
load(strcat(PATHNAME,FILENAME)); 

Fs=Fs/8;
spacing =100;
sclfac=1.4489e+06;

for i =1:length(noise_TS)
if min(abs(noise_TS(i)-laser2_TS))>0.3 && min(abs(noise_TS(i)-laser1_TS))>0.3
snds_cond(b)=noise_TS(i);
b=b+1;
end
end 

[aligned_trace{list_index}]=gen_aligned_trace(lfp,Fs,snds_cond,...
    t_before,t_after,list_index,rem_chans);

aligned_trace{list_index}=aligned_trace{list_index}(chan_order);

[s_avg{list_index},sub_mat{list_index},t,f]=...
    spectrogram_mult_chan(aligned_trace{list_index},t_before,Fs);

colorscale=[0 2];
colorscale_raw=[-120 -90];

tit=strcat(FILENAME,'laser only - 5 sec');

 plot_spectrogram_singleshank_internal(s_avg{list_index},t,f,sub_mat{list_index},t_before,...
     tit,colorscale,colorscale_raw);

end

ps2pdf1('psfile',strcat(pwd,'\','laser only spectrograms','.ps'),...
    'pdffile',strcat(pwd,'\','laser only spectrograms','.pdf'),'deletepsfile',1);

end

function [s_avg,sub_mat,t,f]=spectrogram_mult_chan(aligned,t_before,Fs)

for i =1:length(aligned)
[s_avg{i},t,f,sub_mat{i}] = spectrogram_norm(aligned{i},t_before,Fs);
% [pop.S{i},pop.t,pop.f] = spectrogram_pop(aligned{i},t_before,Fs);
end

end

function [aligned_mat]=gen_aligned_trace(lfp,Fs,TS,t_before,t_after,list_index,rem_chans)

if TS(1) < t_before
TS=TS(2:length(TS));    
end

[aligned_trace] = align_lfp_multchan(lfp,Fs,TS,t_before,t_after);
lfp_t_full=[1/Fs:1/Fs:length(aligned_trace{1}{1})/Fs];

[rem_trial] = art_id_lfp(aligned_trace,Fs,6);

if isempty(rem_chans{list_index}) ~= 1
aligned_trace=removerows(aligned_trace',rem_chans{list_index})';
end

for i =1:length(aligned_trace)
aligned_mat{i}=cell2mat(aligned_trace{i}');
end
end

function [S,t,f] = spectrogram_pop(aligned,t_before,Fs)

movingwin = [0.5 0.05]; 
params.tapers = [2 3];   
params.pad = -1;
params.Fs = Fs;

[m,~]=size(aligned);
for n =1:m
[S(:,:,n),t,f]=mtspecgramc(detrend(aligned(n,:)),movingwin,params);
end

end

function [] = plot_spectrogram_singleshank_internal(S,t,f,sub_mat,t_before,tit,colorscale,colorscale_raw)

figure('visible','off')
for i =1:16
subplot(4,4,i)
pcolor(t-(t_before),f,sub_mat{i}')
shading interp
caxis(colorscale)
colorbar
axis xy
ylim([0 100])
if i==2
    title(tit)
end
end
print('-dpsc2','laser only spectrograms','-append',gcf); 

figure('visible','off')
for i =1:16
subplot(4,4,i)
imagesc(t-(t_before),f,10*log10(S{i}'))
axis xy
caxis(colorscale_raw)
colorbar
grid off
ylim([0 100])
if i==2
    title(tit)   
end
end
print('-dpsc2','laser only spectrograms','-append',gcf); 
end