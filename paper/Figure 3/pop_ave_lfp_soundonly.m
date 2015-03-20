function [ERP,trials,volt_range,peak,trough,peak_lat,list,lfp_t] = pop_ave_lfp_soundonly(loc,condition)

list=file_list(loc);

for i=1:length(list)
   rem_chans{i}=[]; 
end

for list_index=1:length(list) 
clearvars -except list list_index trials rem_chans group volt_range peak ERP rem_rows condition trough peak_lat

t_before=0.5;
t_after=1;
t_resp=0.12;  %%value chosen by eye from five mice erps across channels

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
        b=1;  
    for i =1:length(noise_TS)
      if min(abs(noise_TS(i)-laser2_TS))>0.3 && min(abs(noise_TS(i)-laser1_TS))>0.3
          snds_cond(b)=noise_TS(i);
          b=b+1;
      end
    end  
    
    Wn=(5*2)/Fs;
    [B,A]=butter(3,Wn,'high');
    
    for i =1:length(lfp)
    filtered{i}=filtfilt(B,A,lfp{i});    
    end
    
    clear lfp
    lfp=filtered;
    clear filtered
    
    spacing =100;

[ERP.snd{list_index},volt_range.snd{list_index},peak.snd{list_index},trough.snd{list_index},peak_lat.snd{list_index},trials.snd{list_index},lfp_t,...
    rem_rows.snd{list_index}]=gen_erps(lfp,Fs,snds_cond,t_before,t_after,t_resp,list_index,rem_chans);

ERP.snd{list_index}=ERP.snd{list_index}(chan_order);
trials.snd{list_index}=trials.snd{list_index}(chan_order);

sclfac=1.4489e+06;

plot_trials(trials.snd{list_index},sclfac,condition,FILENAME,t_before,t_after,Fs,rem_rows.snd{list_index});
close all
end
ps2pdf1('psfile',strcat(pwd,'\',condition,'.ps'),...
    'pdffile',strcat(pwd,'\',condition,'.pdf'),'deletepsfile',1)
end

function [ERP,volt_range,peak,trough,peak_lat,aligned_trace,lfp_t,rem_rows] =...
    gen_erps(lfp,Fs,TS,t_before,t_after,t_resp,list_index,rem_chans)

if TS(1) < t_before
TS=TS(2:length(TS));    
end

[aligned_trace,rem_rows] = gen_traces(lfp,Fs,TS,t_before,t_after);
lfp_t=(1/Fs:1/Fs:length(aligned_trace{1}{1})/Fs)-t_before;

if isempty(rem_chans{list_index}) ~= 1
aligned_trace=removerows(aligned_trace',rem_chans{list_index})';
end

[ERP,volt_range,peak,trough,peak_lat] = avg_erps(aligned_trace,lfp_t,t_resp,Fs,rem_rows);

end

function [ERP,volt_range,peak,trough,peak_lat] = avg_erps(aligned_trace,lfp_t,t_resp,Fs,rem_rows)
num_chans=length(aligned_trace);
for channel=1:num_chans
clear data I

data=cell2mat(aligned_trace{channel}');
data=removerows(data,'ind',rem_rows);
ERP{channel}=mean(data);
peak=max(ERP{channel}(lfp_t>0 & lfp_t<=t_resp));
trough=min(ERP{channel}(lfp_t>0 & lfp_t<=t_resp));
volt_range(channel)=peak-trough;

[~,I] = max(ERP{channel}(lfp_t>0 & lfp_t<=t_resp));

peak_lat(channel)=Fs*I;

end
end

