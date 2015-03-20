function []=plot_trials(trials,sclfac,condition,FILENAME,t_before,t_after,Fs,rem_rows)

spacing =1;
sclfac=sclfac/500;
figure('visible','off')
for i=1:4
subplot(1,4,i)    
for n =1:length(trials{i});
    if isempty(intersect(rem_rows,n))==0
    plot(-t_before:1/Fs:t_after,(trials{i}{n}*sclfac)-((n-1)*spacing),'r')
    if i ==2 && n==1;
    title(strcat(FILENAME(1:length(FILENAME)-4),'-',condition,'chans 1-4'))
    end    
        
    end
    if isempty(intersect(rem_rows,n))==1
    plot(-t_before:1/Fs:t_after,(trials{i}{n}*sclfac)-((n-1)*spacing),'b')
    if i ==2 && n==1;
    title(strcat(FILENAME(1:length(FILENAME)-4),'-',condition,'chans 1-4'))
    end
    end
    
    hold on
end
hold off
ylim([-length(trials{i})-5 5])    
xlim([-t_before t_after])
xlabel('time [sec]')
ylabel('trial #')
end
 
print('-dpsc2',condition,'-append',gcf); 
figure('visible','off')
for i=5:8
subplot(1,4,i-4)    
for n =1:length(trials{i});
    if isempty(intersect(rem_rows,n))==0
    plot(-t_before:1/Fs:t_after,(trials{i}{n}*sclfac)-((n-1)*spacing),'r')
    if i ==6 && n==1;
    title(strcat(FILENAME(1:length(FILENAME)-4),'-',condition,'chans 5-8'))
    end
    end
    
    if isempty(intersect(rem_rows,n))==1
    plot(-t_before:1/Fs:t_after,(trials{i}{n}*sclfac)-((n-1)*spacing),'b')
    if i ==6 && n==1;
    title(strcat(FILENAME(1:length(FILENAME)-4),'-',condition,'chans 5-8'))
    end
    end
 
    hold on
end
hold off
ylim([-length(trials{i})-5 5])    
xlim([-t_before t_after])
xlabel('time [sec]')
ylabel('trial #')
end

print('-dpsc2',condition,'-append',gcf); 
figure('visible','off')
for i=9:12
subplot(1,4,i-8)    
for n =1:length(trials{i});
    
    if isempty(intersect(rem_rows,n))==0
    plot(-t_before:1/Fs:t_after,(trials{i}{n}*sclfac)-((n-1)*spacing),'r')
    if i ==10 && n==1;
    title(strcat(FILENAME(1:length(FILENAME)-4),'-',condition,'chans 9-12'))
    end
    end
    
    if isempty(intersect(rem_rows,n))==1
    plot(-t_before:1/Fs:t_after,(trials{i}{n}*sclfac)-((n-1)*spacing),'b')
    if i ==10 && n==1;
    title(strcat(FILENAME(1:length(FILENAME)-4),'-',condition,'chans 9-12'))
    end
    end
    
    hold on
end
hold off
ylim([-length(trials{i})-5 5])    
xlim([-t_before t_after])
xlabel('time [sec]')
ylabel('trial #')
end

print('-dpsc2',condition,'-append',gcf); 
figure('visible','off')
for i=13:16
subplot(1,4,i-12)    
for n =1:length(trials{i});
    
    if isempty(intersect(rem_rows,n))==0
    plot(-t_before:1/Fs:t_after,(trials{i}{n}*sclfac)-((n-1)*spacing),'r')
    if i ==14 && n==1;
    title(strcat(FILENAME(1:length(FILENAME)-4),'-',condition,'chans 13-16'))
    end
    end
    
    if isempty(intersect(rem_rows,n))==1
    plot(-t_before:1/Fs:t_after,(trials{i}{n}*sclfac)-((n-1)*spacing),'b')
    if i ==14 && n==1;
    title(strcat(FILENAME(1:length(FILENAME)-4),'-',condition,'chans 13-16'))
    end
    end
    
    hold on
end
hold off
ylim([-length(trials{i})-5 5])    
xlim([-t_before t_after])
xlabel('time [sec]')
ylabel('trial #')
end
print('-dpsc2',condition,'-append',gcf); 
end