function [list,rmscsd] = pop_CSD_sound_only_rms(path,cond)

list=file_list(path);

for i=1:length(list)
   rem_chans{i}=[]; 
end

t_resp=[0.05 0.15];
exp_index=1;
for list_index=1:2:length(list) 
clearvars -except list list_index exp_index rmscsd cond t_resp


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
spacing =100;

t_before=0.5;
t_after=1;

b=1;  
for i =1:length(noise_TS)
if min(abs(noise_TS(i)-laser2_TS))>0.3 && min(abs(noise_TS(i)-laser1_TS))>0.3
snds_cond(b)=noise_TS(i);
b=b+1;
end
end  
   
for i=1:num_chans
[aligned_1.frstshnk{i}]=align_lfp(lfp_frstshnk{i},snds_cond*Fs,t_before,t_after,Fs);
aligned_1.frstshnk{i}=cell2mat(aligned_1.frstshnk{i}');

[aligned_1.secshnk{i}]=align_lfp(lfp_secshnk{i},snds_cond*Fs,t_before,t_after,Fs);
aligned_1.secshnk{i}=cell2mat(aligned_1.secshnk{i}');

[aligned_1.thrdshnk{i}]=align_lfp(lfp_thrdshnk{i},snds_cond*Fs,t_before,t_after,Fs);
aligned_1.thrdshnk{i}=cell2mat(aligned_1.thrdshnk{i}');

[aligned_1.frthshnk{i}]=align_lfp(lfp_frthshnk{i},snds_cond*Fs,t_before,t_after,Fs);
aligned_1.frthshnk{i}=cell2mat(aligned_1.frthshnk{i}');

end

[CSD_1,CSD_raw,avg_1] = CSD_shanks_raw(aligned_1,Fs,t_before,t_after);

[m,n]=size(CSD_raw.frstshnk);

csd_t=(1/Fs:1/Fs:n/Fs)-t_before;

for i =1:m
    
rmscsd{exp_index}.frstshnk(i)=rms(CSD_raw.frstshnk(i,csd_t>=t_resp(1) & csd_t<=t_resp(2)));  
rmscsd{exp_index}.secshnk(i)=rms(CSD_raw.secshnk(i,csd_t>=t_resp(1) & csd_t<=t_resp(2)));
rmscsd{exp_index}.thrdshnk(i)=rms(CSD_raw.thrdshnk(i,csd_t>=t_resp(1) & csd_t<=t_resp(2)));
rmscsd{exp_index}.frthshnk(i)=rms(CSD_raw.frthshnk(i,csd_t>=t_resp(1) & csd_t<=t_resp(2)));
    
end

plotshift=0.075;
coloraxis=[-6 6];
sclfac=(100/(max(avg_1.frstshnk{1})-min(avg_1.frstshnk{i})))*3;
plot_CSD_PDF(CSD_1,rmscsd{exp_index},avg_1,sclfac,coloraxis,strcat(FILENAME,'-sound alone'),Fs,t_before,t_after,cond);
close all
exp_index=exp_index+1;
end

ps2pdf1('psfile',strcat(pwd,'\',strcat('CSD-',cond),'.ps'),...
    'pdffile',strcat(pwd,'\',strcat('CSD-',cond),'.pdf'),'deletepsfile',1)
end

function [] = plot_CSD_PDF(CSD,rmscsd,avg,sclfac,coloraxis,tit,Fs,t_before,t_after,cond)
plotshift=0.075;
num_chans=8;
spacing=100;
steps=0.1;
taxis=-t_before:1/Fs:t_after;
daxis=0:100:700;

figure('visible','off')
subplot(4,3,1)
% coloraxis=[min(min(CSD_cond_frstshnk(1:m,:))) max(max(CSD_cond_frstshnk(1:m,:)))];
surface(-t_before:1/Fs:t_after,spacing.*(1:steps:num_chans-2),CSD.frstshnk,'edgecolor','none')
ylim([spacing spacing*(num_chans-2)])
yLimits = get(gca,'YLim');  
yTicks = yLimits(2):-spacing:yLimits(1); 
set(gca,'YTickLabel',num2str(yTicks.'));  
xlim([-t_before+plotshift t_after])
% xlim([-0.1 0.25])
caxis(coloraxis)
colormap('default')
ylabel('depth um')

title(tit) 
colorbar

subplot(4,3,2)
for i =1:8
    plot(-t_before:1/Fs:t_after,(avg.frstshnk{i}*sclfac)-((i-1)*spacing))
    hold on
end
hold off
ylim([-900 50])
xlim([-t_before+plotshift t_after])

subplot(4,3,3)
plot(rmscsd.frstshnk,[1:6],'k*')


% coloraxis=[min(min(CSD_cond_secshnk(1:m,:))) max(max(CSD_cond_secshnk(1:m,:)))]
subplot(4,2,4)
surface(-t_before:1/Fs:t_after,spacing.*(1:steps:num_chans-2),CSD.secshnk,'edgecolor','none')
ylim([spacing spacing*(num_chans-2)])
yLimits = get(gca,'YLim');  
yTicks = yLimits(2):-spacing:yLimits(1); 
set(gca,'YTickLabel',num2str(yTicks.'));  
xlim([-t_before+plotshift t_after])
% xlim([-0.1 0.25])
caxis(coloraxis)
colormap('default')
ylabel('depth um')
colorbar

subplot(4,3,5)
for i =1:8
    plot(-t_before:1/Fs:t_after,(avg.secshnk{i}*sclfac)-((i-1)*spacing))
    hold on
end
hold off
ylim([-900 50])
xlim([-t_before+plotshift t_after])

subplot(4,3,6)
plot(rmscsd.secshnk,[1:6],'k*')

% coloraxis=[min(min(CSD_cond_thrdshnk(1:m,:))) max(max(CSD_cond_thrdshnk(1:m,:)))];
subplot(4,2,7)
surface(-t_before:1/Fs:t_after,spacing.*(1:steps:num_chans-2),CSD.thrdshnk,'edgecolor','none')
ylim([spacing spacing*(num_chans-2)])
yLimits = get(gca,'YLim'); 
yTicks = yLimits(2):-spacing:yLimits(1); 
set(gca,'YTickLabel',num2str(yTicks.'));  
xlim([-t_before+plotshift t_after])
% xlim([-0.1 0.25])
caxis(coloraxis)
colormap('default')
ylabel('depth um')
colorbar

subplot(4,3,8)
for i =1:8
    plot(-t_before:1/Fs:t_after,(avg.thrdshnk{i}*sclfac)-((i-1)*spacing))
    hold on
end
hold off
ylim([-900 50])
xlim([-t_before+plotshift t_after])

subplot(4,3,9)
plot(rmscsd.thrdshnk,[1:6],'k*')

% coloraxis=[min(min(CSD_cond_frthshnk(1:m,:))) max(max(CSD_cond_frthshnk(1:m,:)))];
subplot(4,3,10)
surface(-t_before:1/Fs:t_after,spacing.*(1:steps:num_chans-2),CSD.frthshnk,'edgecolor','none')
ylim([spacing spacing*(num_chans-2)])
yLimits = get(gca,'YLim');  
yTicks = yLimits(2):-spacing:yLimits(1); 
set(gca,'YTickLabel',num2str(yTicks.'));  
xlim([-t_before+plotshift t_after])
% xlim([-0.1 0.25])
caxis(coloraxis)
colormap('default')
ylabel('depth um')
xlabel('Time [sec]')
colorbar

subplot(4,3,11)
for i =1:8
    plot(-t_before:1/Fs:t_after,(avg.frthshnk{i}*sclfac)-((i-1)*spacing))
    hold on
end
hold off
ylim([-900 50])
xlim([-t_before+plotshift t_after])

subplot(4,3,12)
plot(rmscsd.thrdshnk,[1:6],'k*')

print('-dpsc2',strcat('CSD-',cond),'-append',gcf); 
end