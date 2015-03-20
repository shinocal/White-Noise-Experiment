function [aligned_trace_full,rem_rows] = gen_traces(lfp,Fs,TS,t_before,t_after)

if TS(1) < t_before
TS=TS(2:length(TS));    
end

[aligned_trace_full] = align_lfp_multchan(lfp,Fs,TS,t_before,t_after);

rej_fac=4; %factor for artifact rejection in standard deviations above mean rms

[rem_trial] = art_id_lfp(aligned_trace_full,Fs,rej_fac);
% rem_rows=find(rem_trial==1);
rem_rows=rem_trial;

end