clear
clc
close all

loc='C:\Nick Lab\SCRIPTS\White Noise Expmnt\LFP population data\4 condition\scopolamine high dose\pre infusion\PFC';
[ERP_preinf,trials_preinf,volt_range_preinf,peak_preinf,trough_preinf,peak_lat_preinf,list_preinf,lfp_t] = pop_ave_lfp_soundonly(loc,'pre infusion sound alone');

clear loc
loc='C:\Nick Lab\SCRIPTS\White Noise Expmnt\LFP population data\4 condition\scopolamine high dose\post infusion\PFC';
[ERP_postinf,trials_postinf,volt_range_postinf,peak_postinf,trough_postinf,peak_lat_postinf,list_postinf,lfp_t] = pop_ave_lfp_soundonly(loc,'post infusion sound alone');

list_preinf=list_preinf';
list_postinf=list_postinf';
%%

%github changes
close all
clc
clearvars -except ERP_preinf volt_range_preinf peak_preinf list_preinf ERP_postinf volt_range_postinf...
    peak_postinf list_postinf lfp_t trials_preinf trials_postinf


t_resp=0.15;

for mouse =1:length(volt_range_preinf.snd)

   for channel=1:length(volt_range_preinf.snd{mouse})
       clear Pp temp_preinf
       Pp=randperm(100,100);
       temp_preinf=trials_preinf.snd{mouse}{channel}(Pp);
       temp_postinf=trials_postinf.snd{mouse}{channel}(Pp);
       p=1;
       for trial=10:10:length(trials_preinf.snd{mouse}{channel})
           clear peak trough
           ERP_perm_preinf{mouse,channel}(p,:)=mean(cell2mat(temp_preinf(trial-9:trial)'));
           ERP_perm_postinf{mouse,channel}(p,:)=mean(cell2mat(temp_postinf(trial-9:trial)'));
           peak=max(ERP_perm_preinf{mouse,channel}(p,lfp_t>0 & lfp_t<=t_resp));
           trough=min(ERP_perm_preinf{mouse,channel}(p,lfp_t>0 & lfp_t<=t_resp));
           vr_perm_preinf{mouse}{channel}(trial)=(peak-trough)*1000;
           clear peak trough
           peak=max(ERP_perm_postinf{mouse,channel}(p,lfp_t>0 & lfp_t<=t_resp));
           trough=min(ERP_perm_postinf{mouse,channel}(p,lfp_t>0 & lfp_t<=t_resp));
           vr_perm_postinf{mouse}{channel}(trial)=(peak-trough)*1000;
           p=p+1;
       end
       [H(mouse,channel),P(mouse,channel)]=ttest2(vr_perm_preinf{mouse}{channel},vr_perm_postinf{mouse}{channel});
   end
end



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

clear peak trough    
peak=max(trials_postinf.snd{mouse}{channel}{trial}(lfp_t>0 & lfp_t<=t_resp));
trough=min(trials_postinf.snd{mouse}{channel}{trial}(lfp_t>0 & lfp_t<=t_resp));
vr_trials_postinf{mouse}{channel}(trial)=(peak-trough)*1000;

[H{mouse}{channel},P{mouse}{channel}]=ttest2(vr_trials_preinf{mouse}{channel}...
    ,vr_trials_postinf{mouse}{channel});

end   
end
end


%%
figure
for mouse =1:length(volt_range_preinf.snd)
    subplot(length(volt_range_preinf.snd),1,mouse)
    plot(lfp_t,cell2mat(ERP_preinf.snd{mouse}')')
   for channel=1:length(volt_range_preinf.snd{mouse})
   ERP_allchans_preinf(mouse,:)=mean(cell2mat(ERP_preinf.snd{mouse}')); 
   ERP_allchans_postinf(mouse,:)=mean(cell2mat(ERP_postinf.snd{mouse}')); 
   end
end

%%
close all
clc
clearvars -except ERP_preinf volt_range_preinf peak_preinf list_preinf ERP_postinf volt_range_postinf...
    peak_postinf list_postinf lfp_t trials_preinf trials_postinf
vr_comb_preinf=cell(1,16);
vr_comb_postinf=cell(1,16);

% for mouse=1:length(volt_range_preinf.snd)
for mouse=[1,3,4,5,6,7]
    for channel=1:length(volt_range_preinf.snd{mouse})
        
      vr_comb_preinf{channel}=cat(2,vr_comb_preinf{channel},volt_range_preinf.snd{mouse}(channel)); 
      vr_comb_postinf{channel}=cat(2,vr_comb_postinf{channel},volt_range_postinf.snd{mouse}(channel)); 
        
      if mouse==length(volt_range_preinf.snd)
      [H{channel},P{channel}]=ttest2(vr_comb_preinf{channel},vr_comb_postinf{channel});
      end
    end
    
end
%%
figure
plot(lfp_t,ERP_allchans(5,:)')



%%
vr_preinf=[];
alltraces_preinf=[];

for i =1:length(volt_range_preinf.snd)
   for n=1:length(volt_range_preinf.snd{i})
   vr_preinf=cat(2,vr_preinf,volt_range_preinf.snd{i}(n));  
   alltraces_preinf=cat(1,alltraces_preinf,ERP_preinf.snd{i}{n});
   end
end


vr_postinf=[];
alltraces_postinf=[];
for i =1:length(volt_range_postinf.snd)
   for n=1:length(volt_range_postinf.snd{i})
   vr_postinf=cat(2,vr_postinf,volt_range_postinf.snd{i}(n));  
   alltraces_postinf=cat(1,alltraces_postinf,ERP_postinf.snd{i}{n});
   end
end


%%

[m,n]=size(alltraces_preinf);
av=mean(alltraces_preinf)/max(mean(alltraces_preinf));
sem=std(alltraces_preinf/max(mean(alltraces_preinf)))/sqrt(n);

figure
plot(lfp_t,mean(alltraces_preinf)/max(mean(alltraces_preinf)),'k')
hold on
plot(lfp_t,mean(alltraces_postinf)/max(mean(alltraces_preinf)),'r')
hold on
legend('pre infusion','post infusion')
shadedErrorBar(lfp_t,av,[av-sem;av+sem],'k',1)
hold on
clear av sem
av=mean(alltraces_postinf)/max(mean(alltraces_preinf));
sem=std(alltraces_postinf/max(mean(alltraces_preinf)))/sqrt(n);
shadedErrorBar(lfp_t,av,[av-sem;av+sem],'r',1)
hold off
ylim([-1.1 1.1])
xlim([-0.1 0.25])
xlabel('time [sec]')
ylabel('normalized ERP mag.')
title('scop 100 ug/ul')

%%

figure
subplot(2,1,1)
hist(vr_preinf,0:5e-6:1.8e-4)
title('pre infusion erp magnitudes')
subplot(2,1,2)
hist(vr_postinf,0:5e-6:1.8e-4)
title('post infusion erp magnitudes')

%%

vr_preinf_mv=vr_preinf*1000;
vr_postinf_mv=vr_postinf*1000;

labels{1}='pre-infusion';
labels{2}='post-infusion';

figure
bar(1:2,[mean(vr_preinf_mv) mean(vr_postinf_mv)])
hold on
errorbar(1:2,[mean(vr_preinf_mv) mean(vr_postinf_mv)],[std(vr_preinf_mv)/sqrt(length(vr_preinf_mv)),...
    std(vr_postinf_mv)/sqrt(length(vr_postinf_mv))],'k.')
hold off
set(gca,'xticklabel',labels)
ylabel('ERP Mag. Millivolts')
title('scop 100 ug/ul infusion')
%%

vr_diff=-(vr_preinf_mv-vr_postinf_mv)./vr_preinf_mv;