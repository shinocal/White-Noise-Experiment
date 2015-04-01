function [s_avg,sub_mat,t,f] =pop_spectrogram_sound_only_aud(dir)

list=file_list(dir);

for i=1:length(list)
   rem_chans{i}=[]; 
end

exp_index=1;
for list_index=1:2:length(list) 
% clearvars -except list list_index trial_index rem_chans pop_frstshnk...
%   pop_secshnk pop_thrdshnk pop_frthshnk sub_mat t f exp_index s_avg

clearvars -except list list_index rem_chans exp_index s_avg sub_mat

t_before=2;
t_after=3;

num_chans=8;
%for 32 chan probe correct configuration
chan_order_frstshnk=[4 8 9 5 3 7 10 6];
chan_order_secshnk=[13 12 14 1 15 11 16 2];
chan_order_thrdshnk=[21 20 23 19 22 18 25 17]-16;
chan_order_frthshnk=[28 29 31 26 30 27 32 24]-16;

probe_depth=[0 100 200 300 400 500 600 700];

file=list{list_index};
load(file); 

lfp_frstshnk=lfp(chan_order_frstshnk);
lfp_secshnk=lfp(chan_order_secshnk);
clear lfp file

file=list{list_index+1};
load(file); 

lfp_thrdshnk=lfp(chan_order_thrdshnk);
lfp_frthshnk=lfp(chan_order_frthshnk);
clear lfp

[~,FILENAME,~] = fileparts(list{list_index});

Fs=Fs/8;
spacing=100;
sclfac=1.4489e+06;

b=1;  
for i =1:length(noise_TS)
if min(abs(noise_TS(i)-laser2_TS))>0.3 && min(abs(noise_TS(i)-laser1_TS))>0.3
snds_cond(b)=noise_TS(i);
b=b+1;
end
end  

[aligned_trace.frstshnk{exp_index}]=gen_aligned_trace(lfp_frstshnk,Fs,snds_cond,...
    t_before,t_after,exp_index,rem_chans);

[aligned_trace.secshnk{exp_index}]=gen_aligned_trace(lfp_secshnk,Fs,snds_cond,...
    t_before,t_after,exp_index,rem_chans);

[aligned_trace.thrdshnk{exp_index}]=gen_aligned_trace(lfp_thrdshnk,Fs,snds_cond,...
    t_before,t_after,exp_index,rem_chans);

[aligned_trace.frthshnk{exp_index}]=gen_aligned_trace(lfp_frthshnk,Fs,snds_cond,...
    t_before,t_after,exp_index,rem_chans);

[s_avg{exp_index}.frstshnk,sub_mat{exp_index}.frstshnk,~,~]=...
    spectrogram_mult_chan(aligned_trace.frstshnk{exp_index},t_before,Fs);

[s_avg{exp_index}.secshnk,sub_mat{exp_index}.secshnk,~,~]=...
    spectrogram_mult_chan(aligned_trace.secshnk{exp_index},t_before,Fs);

[s_avg{exp_index}.thrdshnk,sub_mat{exp_index}.thrdshnk,~,~]=...
    spectrogram_mult_chan(aligned_trace.thrdshnk{exp_index},t_before,Fs);

[s_avg{exp_index}.frthshnk,sub_mat{exp_index}.frthshnk,t,f]=...
    spectrogram_mult_chan(aligned_trace.frthshnk{exp_index},t_before,Fs);

colorscale=[0.5 1.2];
colorscale_raw=[-120 -90];

tit=strcat(FILENAME,'sound only - 500 ms');

plot_spectrogram_shanks_int(t,f,sub_mat{exp_index},t_before,tit,colorscale)

exp_index=exp_index+1;
close all 
end

ps2pdf1('psfile',strcat(pwd,'\','sound only spectrograms','.ps'),...
    'pdffile',strcat(pwd,'\','sound only spectrograms','.pdf'),'deletepsfile',1);

end

function [s_avg,sub_mat,t,f]=spectrogram_mult_chan(aligned,t_before,Fs)

for i =1:length(aligned)
[s_avg{i},t,f,sub_mat{i}] = spectrogram_norm(aligned{i},t_before,Fs);
end

end

function [aligned_mat]=gen_aligned_trace(lfp,Fs,TS,t_before,t_after,list_index,rem_chans)

if TS(1) < t_before
TS=TS(2:length(TS));    
end

[aligned_trace] = align_lfp_multchan(lfp,Fs,TS,t_before,t_after);
lfp_t_full=[1/Fs:1/Fs:length(aligned_trace{1}{1})/Fs];

rej_fac=3.5; %factor for artifact rejection in standard deviations above mean rms
[rem_trial] = art_id_lfp(aligned_trace,Fs,rej_fac);



if isempty(rem_chans{list_index}) ~= 1
aligned_trace=removerows(aligned_trace',rem_chans{list_index})';
end

for i =1:length(aligned_trace)
aligned_mat{i}=cell2mat(aligned_trace{i}');
end
end

function [] = plot_spectrogram_shanks_int(t,f,sub_mat,t_before,tit,colorscale)
figure('visible','off')
for i =1:8

subplot(8,4,((i-1)*4)+1)
pcolor(t-(t_before),f,sub_mat.frstshnk{i}')
shading interp
caxis(colorscale)
colorbar
axis xy
set(gca, 'Yscale', 'log')
ylim([0 100])
if i==1
    title(tit)
end
end

for i =1:8
subplot(8,4,((i-1)*4)+2)
pcolor(t-(t_before),f,sub_mat.secshnk{i}')
shading interp
caxis(colorscale)
colorbar
axis xy
set(gca, 'Yscale', 'log')
ylim([0 100])
end

for i =1:8
subplot(8,4,((i-1)*4)+3)
pcolor(t-(t_before),f,sub_mat.thrdshnk{i}')
shading interp
caxis(colorscale)
colorbar
axis xy
set(gca, 'Yscale', 'log')
ylim([0 100])
end

for i =1:8
subplot(8,4,((i-1)*4)+4)
pcolor(t-(t_before),f,sub_mat.frthshnk{i}')
shading interp
caxis(colorscale)
colorbar
axis xy
set(gca, 'Yscale', 'log')
ylim([0 100])
end
print('-dpsc2','sound only spectrograms','-append',gcf); 

end

