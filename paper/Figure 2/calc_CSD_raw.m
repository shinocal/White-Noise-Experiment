function [csd_interp,csd,avg] = calc_CSD_raw(lfp_dpth,numchans,steps,t_before,t_after,Fs)

for i =1:numchans
avg{i}=mean(lfp_dpth{i})*1000;  % converting to millivolts
end

for i=1:numchans
% subtr(i,:)=avg{i}-mean(avg{i});
% subtr(i,:)=avg{i}-mean(avg{i}(1:round(t_before*Fs)));
subtr(i,:)=avg{i};
end

shifted(1,:)=subtr(1,:);
shifted(2:numchans+1,:)=subtr(1:numchans,:);
shifted(numchans+2,:)=subtr(numchans,:);

for n=2:numchans+1
smoothed(n-1,:)=(shifted(n+1,:)+(shifted(n,:)*2)+shifted(n-1,:))/4;   
end

for n=2:numchans-1
 csd(n-1,:)=-((smoothed(n+1,:))-(2*smoothed(n,:))+(smoothed(n-1,:)))./((0.1)^2);  % 0.1 is 100um in mm
 
end

% resulting magnitudes should be mV/mm

    [X,Y] = meshgrid(-t_before:1/Fs:t_after,[1:numchans-2]');
    [XI YI]=meshgrid(-t_before:1/Fs:t_after,[1:steps:numchans-2]');
    csd_interp=interp2(X,Y,csd,XI,YI,'linear');
end