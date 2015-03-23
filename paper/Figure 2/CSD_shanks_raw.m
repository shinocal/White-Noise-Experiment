function [CSD,CSD_raw,avg] = CSD_shanks_raw(aligned,Fs,t_before,t_after)

num_chans=8;
steps=0.1;

[CSD.frstshnk,CSD_raw.frstshnk,avg.frstshnk] = calc_CSD_raw(aligned.frstshnk,num_chans,steps,t_before,t_after,Fs);
[CSD.secshnk,CSD_raw.secshnk,avg.secshnk] = calc_CSD_raw(aligned.secshnk,num_chans,steps,t_before,t_after,Fs);
[CSD.thrdshnk,CSD_raw.thrdshnk,avg.thrdshnk] = calc_CSD_raw(aligned.thrdshnk,num_chans,steps,t_before,t_after,Fs);
[CSD.frthshnk,CSD_raw.frthshnk,avg.frthshnk] = calc_CSD_raw(aligned.frthshnk,num_chans,steps,t_before,t_after,Fs);


end