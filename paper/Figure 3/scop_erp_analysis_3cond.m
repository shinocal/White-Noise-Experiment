clear
clc
close all

loc='C:\Nick Lab\SCRIPTS\White Noise Expmnt\LFP population data\3 condition\Scopolamine high dose\Pre infusion\PFC';
[ERP_preinf,trials_preinf,volt_range_preinf,peak_preinf,trough_preinf,peak_lat_preinf,list_preinf,lfp_t] =...
    pop_ave_lfp_soundonly_3cond(loc,'pre infusion sound alone');

clear loc
loc='C:\Nick Lab\SCRIPTS\White Noise Expmnt\LFP population data\3 condition\Scopolamine high dose\Post infusion\PFC';
[ERP_postinf,trials_postinf,volt_range_postinf,peak_postinf,trough_postinf,peak_lat_postinf,list_postinf,lfp_t] =...
    pop_ave_lfp_soundonly_3cond(loc,'post infusion sound alone');

list_preinf=list_preinf';
list_postinf=list_postinf';

%%
close all
clc
clearvars -except ERP_preinf volt_range_preinf peak_preinf list_preinf ERP_postinf volt_range_postinf...
    peak_postinf list_postinf lfp_t trials_preinf trials_postinf

for mouse =1:length(volt_range_preinf.snd)
figure(mouse)
for channel=1:length(volt_range_preinf.snd{mouse})
clear sem
sem.preinf=std(cell2mat(trials_preinf.snd{mouse}{channel}'))/sqrt(length(trials_preinf.snd{mouse}{channel}));
sem.postinf=std(cell2mat(trials_preinf.snd{mouse}{channel}'))/sqrt(length(trials_preinf.snd{mouse}{channel}));
subplot(4,4,channel)
plot(lfp_t,ERP_preinf.snd{mouse}{channel},'k')
hold on
plot(lfp_t,ERP_postinf.snd{mouse}{channel},'r')
hold on
% legend('pre infusion','post infusion')
av=ERP_preinf.snd{mouse}{channel};
shadedErrorBar(lfp_t,av,[av-sem.preinf;av+sem.preinf],'k',1)
hold on
av=ERP_postinf.snd{mouse}{channel};
shadedErrorBar(lfp_t,av,[av-sem.postinf;av+sem.postinf],'r',1)
% ylim([-1.1 1.1])
xlim([-0.1 0.25])  
hold off
end
end

%%

clc
clearvars -except ERP_preinf volt_range_preinf peak_preinf list_preinf ERP_postinf volt_range_postinf...
    peak_postinf list_postinf lfp_t trials_preinf trials_postinf

t_resp=0.1;

for mouse =1:length(volt_range_preinf.snd)

for channel=1:length(volt_range_preinf.snd{mouse})
for trial=1:length(trials_preinf.snd{mouse}{channel})
clear peak trough    
peak=max(trials_preinf.snd{mouse}{channel}{trial}(lfp_t>0 & lfp_t<=t_resp));
trough=min(trials_preinf.snd{mouse}{channel}{trial}(lfp_t>0 & lfp_t<=t_resp));
vr_trials_preinf{mouse}{channel}(trial)=(peak-trough)*1000;

if trial>length(trials_postinf.snd{mouse}{channel})
    continue
end
clear peak trough    
peak=max(trials_postinf.snd{mouse}{channel}{trial}(lfp_t>0 & lfp_t<=t_resp));
trough=min(trials_postinf.snd{mouse}{channel}{trial}(lfp_t>0 & lfp_t<=t_resp));
vr_trials_postinf{mouse}{channel}(trial)=(peak-trough)*1000;

end 
[H{mouse}{channel},P{mouse}{channel}]=ttest2(vr_trials_preinf{mouse}{channel}...
    ,vr_trials_postinf{mouse}{channel});
end
end

%%
close all
clc
clearvars -except ERP_preinf volt_range_preinf peak_preinf list_preinf ERP_postinf volt_range_postinf...
    peak_postinf list_postinf lfp_t trials_preinf trials_postinf
vr_comb_preinf=cell(1,16);
vr_comb_postinf=cell(1,16);

for mouse=1:length(volt_range_preinf.snd)
    for channel=1:length(volt_range_preinf.snd{mouse})
        
      vr_comb_preinf{channel}=cat(2,vr_comb_preinf{channel},volt_range_preinf.snd{mouse}(channel)); 
      vr_comb_postinf{channel}=cat(2,vr_comb_postinf{channel},volt_range_postinf.snd{mouse}(channel)); 
        
      if mouse==length(volt_range_preinf.snd)
      [H{channel},P{channel}]=ttest2(vr_comb_preinf{channel},vr_comb_postinf{channel});
      end
    end
    
end

%%


clc
clearvars -except ERP_preinf volt_range_preinf peak_preinf list_preinf ERP_postinf volt_range_postinf...
    peak_postinf list_postinf lfp_t trials_preinf trials_postinf

t_resp=0.1;

mouse=1;

for channel=1:length(volt_range_preinf.snd{mouse})
for trial=1:length(trials_preinf.snd{mouse}{channel}) 
peak_preinf=max(trials_preinf.snd{mouse}{channel}{trial}(lfp_t>0 & lfp_t<=t_resp));
trough_preinf=min(trials_preinf.snd{mouse}{channel}{trial}(lfp_t>0 & lfp_t<=t_resp));
vr_trials_preinf{mouse}{channel}(trial)=(peak_preinf-trough_preinf)*1000;

if trial>length(trials_postinf.snd{mouse}{channel})
    continue
end
   
peak_postinf=max(trials_postinf.snd{mouse}{channel}{trial}(lfp_t>0 & lfp_t<=t_resp));
trough_postinf=min(trials_postinf.snd{mouse}{channel}{trial}(lfp_t>0 & lfp_t<=t_resp));
vr_trials_postinf{mouse}{channel}(trial)=(peak_postinf-trough_postinf)*1000;

end 
[H{mouse}{channel},P{mouse}{channel}]=ttest2(vr_trials_preinf{mouse}{channel}...
    ,vr_trials_postinf{mouse}{channel});
end
%%

figure
subplot(2,1,1)
hist(vr_trials_preinf{mouse}{1})
subplot(2,1,2)
hist(vr_trials_postinf{mouse}{1})