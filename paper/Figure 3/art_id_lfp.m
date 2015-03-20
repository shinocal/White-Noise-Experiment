function [rem_trial] = art_id_lfp(lfp,Fs,fac)

incr=1/10;
ms=round(Fs*incr);
avg_rms_trace=[];
for i = 1:length(lfp{1})
    
    for n=1:length(lfp)
        o=1;
        for p =1:ms:length(lfp{n}{i})-ms;
        squares=(lfp{n}{i}(p:p+ms).^2)./ms;
        rmsq(n,o)=sqrt(sum(squares));
        o=o+1;
        clear squares
        end
    end
    
    avg_rms_trace=cat(2,avg_rms_trace,mean(rmsq));
    max_rms(i)=max(mean(rmsq));
    clear rmsq
end
rem_trial=find(max_rms>mean(avg_rms_trace)+fac*std(avg_rms_trace));
end



%     if max(mean(rmsq)) > mean(mean(rmsq)) + fac*std(mean(rmsq)) 
%         rem_trial(i)=1;
%     else
%         rem_trial(i)=0;
%     end
    