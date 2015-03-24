function [ERP,volt_range,peak] = norej_trial_rem_erp(aligned_trace,lfp_t)
num_chans=length(aligned_trace);

for channel=1:num_chans
clear data I

data=cell2mat(aligned_trace{channel}');
ERP{channel}=mean(data);
volt_range(channel)=max(ERP{channel})-min(ERP{channel});

[~,I] = max(ERP{channel});

peak(channel)=lfp_t(I);

end
end
